using System;
using System.Data;
using System.Web.UI.WebControls;
using MySqlConnector;

namespace DiorWeb
{
    public partial class siparislerim : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userID"] == null)
                {
                    Response.Redirect("Giris.aspx");
                    return;
                }

                int kullaniciID = Convert.ToInt32(Session["userID"]);
                SiparisleriGetir(kullaniciID);
            }
        }

        private void SiparisleriGetir(int kullaniciID)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"SELECT siparisID, SiparisTarihi, Durum, ToplamFiyat 
                                     FROM siparisler 
                                     WHERE userID = @kullaniciID 
                                     ORDER BY SiparisTarihi DESC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@kullaniciID", kullaniciID);

                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            dlSiparisler.DataSource = dt;
                            dlSiparisler.DataBind();

                            if (dt.Rows.Count == 0)
                                lblMesaj.Text = "Henüz hiç siparişiniz bulunmamaktadır.";
                            else
                                lblMesaj.Text = "";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Siparişler yüklenirken bir hata oluştu: " + ex.Message;
            }
        }

        protected void dlSiparisler_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "Detay")
            {
                int siparisID = Convert.ToInt32(e.CommandArgument);
                SiparisDetaylariniGetir(siparisID);
            }
        }

        private void SiparisDetaylariniGetir(int siparisID)
        {
            pnlDetaylar.Visible = true;
            lblDetayMesaj.Text = "";

            try
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                SELECT urunler.urunAdi, siparis_detaylari.adet, urunler.fiyat, urunler.foto
                FROM siparis_detaylari 
                INNER JOIN urunler ON siparis_detaylari.urunID = urunler.urunID 
                WHERE siparis_detaylari.siparisID = @siparisID";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@siparisID", siparisID);

                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            if (dt.Rows.Count == 0)
                            {
                                lblDetayMesaj.Text = "Bu siparişe ait detay bulunamadı.";
                                gvSiparisDetay.DataSource = null;
                                gvSiparisDetay.DataBind();
                            }
                            else
                            {
                                gvSiparisDetay.DataSource = dt;
                                gvSiparisDetay.DataBind();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblDetayMesaj.Text = "Sipariş detayları yüklenirken hata oluştu: " + ex.Message;
            }
        }

    }
}
