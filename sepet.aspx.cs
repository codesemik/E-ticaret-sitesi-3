using MySqlConnector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace DiorWeb
{
    public partial class sepet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SepetiYukle();
                ToplamFiyatiGuncelle();
            }
        }

        private void SepetiYukle()
        {
            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem>;
            decimal toplamFiyat = 0;

            if (sepet != null && sepet.Any())
            {
                foreach (var item in sepet)
                {
                    item.toplamFiyat = item.Adet * item.Fiyat;
                    toplamFiyat += item.toplamFiyat;
                }

                SepetGridView.DataSource = sepet;
                SepetGridView.DataBind();
                ToplamFiyatLiteral.Text = toplamFiyat.ToString("C");
            }
            else
            {
                SepetGridView.DataSource = null;
                SepetGridView.DataBind();
                ToplamFiyatLiteral.Text = "0.00 TL";
            }
        }

        private void ToplamFiyatiGuncelle()
        {
            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem>;
            decimal toplam = sepet?.Sum(i => i.Adet * i.Fiyat) ?? 0;
            ToplamFiyatLiteral.Text = toplam.ToString("C");
        }

        protected void SepetGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int urunId = Convert.ToInt32(SepetGridView.DataKeys[e.RowIndex].Value);
            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem>;

            if (sepet != null)
            {
                SepetItem item = sepet.FirstOrDefault(i => i.UrunID == urunId);
                if (item != null)
                {
                    if (item.Adet > 1)
                        item.Adet--;
                    else
                        sepet.Remove(item);

                    Session["Sepet"] = sepet;
                    SepetiYukle();
                }
            }
        }

        protected void BtnSatınAl_Click(object sender, EventArgs e)
        {
            string email = Session["mail"] as string;
            if (string.IsNullOrEmpty(email))
            {
                ShowAlert("Lütfen giriş yapın!");
                return;
            }

            int userID = GetUserID(email);
            if (userID == 0)
            {
                ShowAlert("Kullanıcı bulunamadı!");
                return;
            }

            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem>;
            if (sepet == null || !sepet.Any())
            {
                ShowAlert("Sepetinizde ürün bulunmamaktadır!");
                return;
            }

            string connStr = "Server=localhost;Port=3306;Database=dior;Uid=root;";
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                MySqlTransaction tran = conn.BeginTransaction();

                try
                {
                    decimal toplamFiyat = 0;
                    string insertSiparis = "INSERT INTO siparisler (userID, SiparisTarihi, Durum, ToplamFiyat) " +
                                           "VALUES (@userID, @tarih, @durum, @toplamFiyat); SELECT LAST_INSERT_ID();";

                    MySqlCommand cmd = new MySqlCommand(insertSiparis, conn, tran);
                    cmd.Parameters.AddWithValue("@userID", userID);
                    cmd.Parameters.AddWithValue("@tarih", DateTime.Now);
                    cmd.Parameters.AddWithValue("@durum", "Beklemede");
                    cmd.Parameters.AddWithValue("@toplamFiyat", 0);
                    int siparisID = Convert.ToInt32(cmd.ExecuteScalar());

                    foreach (var item in sepet)
                    {
                        toplamFiyat += item.toplamFiyat;

                        string insertDetay = "INSERT INTO siparis_detaylari (siparisID, urunID, adet, fiyat) " +
                                             "VALUES (@siparisID, @urunID, @adet, @fiyat)";
                        MySqlCommand detayCmd = new MySqlCommand(insertDetay, conn, tran);
                        detayCmd.Parameters.AddWithValue("@siparisID", siparisID);
                        detayCmd.Parameters.AddWithValue("@urunID", item.UrunID);
                        detayCmd.Parameters.AddWithValue("@adet", item.Adet);
                        detayCmd.Parameters.AddWithValue("@fiyat", item.Fiyat);
                        detayCmd.ExecuteNonQuery();

                        string updateStok = "UPDATE urunler SET adet = adet - @adet WHERE urunID = @urunID";
                        MySqlCommand stokCmd = new MySqlCommand(updateStok, conn, tran);
                        stokCmd.Parameters.AddWithValue("@adet", item.Adet);
                        stokCmd.Parameters.AddWithValue("@urunID", item.UrunID);
                        stokCmd.ExecuteNonQuery();
                    }

                    string updateFiyat = "UPDATE siparisler SET ToplamFiyat = @toplam WHERE siparisID = @id";
                    MySqlCommand fiyatCmd = new MySqlCommand(updateFiyat, conn, tran);
                    fiyatCmd.Parameters.AddWithValue("@toplam", toplamFiyat);
                    fiyatCmd.Parameters.AddWithValue("@id", siparisID);
                    fiyatCmd.ExecuteNonQuery();

                    tran.Commit();

                    Session.Remove("Sepet");
                    SepetiYukle();
                    ToplamFiyatiGuncelle();
                    ShowAlert("Siparişiniz başarıyla alınmıştır!");
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    Response.Write("Hata: " + ex.Message);
                }
            }
        }

        protected void SepetGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            int urunId = Convert.ToInt32(SepetGridView.DataKeys[index].Value);
            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem>;

            if (sepet == null) return;

            SepetItem urun = sepet.FirstOrDefault(i => i.UrunID == urunId);
            if (urun == null) return;

            if (e.CommandName == "Arttir")
            {
                string connStr = "Server=localhost;Port=3306;Database=dior;Uid=root;";
                using (MySqlConnection conn = new MySqlConnection(connStr))
                {
                    conn.Open();
                    string stokQuery = "SELECT adet, urunAdi FROM urunler WHERE urunID = @id";
                    MySqlCommand cmd = new MySqlCommand(stokQuery, conn);
                    cmd.Parameters.AddWithValue("@id", urunId);

                    using (MySqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            int stok = Convert.ToInt32(rdr["adet"]);
                            string urunAdi = rdr["urunAdi"].ToString();

                            if (urun.Adet + 1 > stok)
                            {
                                ShowAlert($"{urunAdi} için yeterli stok yok. Mevcut: {stok}");
                                return;
                            }

                            urun.Adet++;
                        }
                    }
                }
            }
            else if (e.CommandName == "Azalt")
            {
                if (urun.Adet > 1)
                    urun.Adet--;
                else
                    sepet.Remove(urun);
            }

            Session["Sepet"] = sepet;
            SepetiYukle();
            ToplamFiyatiGuncelle();
        }

        private int GetUserID(string email)
        {
            string connStr = "Server=localhost;Port=3306;Database=dior;Uid=root;";
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT userID FROM users WHERE mail = @mail";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@mail", email);

                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        private void ShowAlert(string message)
        {
            string script = $"<script type=\"text/javascript\">alert('{message}');</script>";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", script);
        }
    }
}
