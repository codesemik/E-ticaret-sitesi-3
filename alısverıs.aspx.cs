using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI.WebControls;
using System.Linq;
using MySqlConnector;

namespace DiorWeb
{
    public partial class alisveris : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UrunleriGetir("Ruj"); // Varsayılan kategori
            }
        }

        protected void rblKategoriler_SelectedIndexChanged(object sender, EventArgs e)
        {
            string secilenKategori = rblKategoriler.SelectedValue;
            UrunleriGetir(secilenKategori);
        }

        private void UrunleriGetir(string kategori)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "SELECT urunID, fiyat, foto, urunAdi FROM urunler WHERE kategori = @kategori";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@kategori", kategori);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        dlUrunler.DataSource = dt;
                        dlUrunler.DataBind();
                    }
                }
            }
        }

        protected void dlUrunler_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "SepeteEkle")
            {
                int urunID = Convert.ToInt32(e.CommandArgument);

                // Veritabanından ürün bilgilerini ve stok miktarını çek
                string urunAdi = "";
                decimal fiyat = 0;
                string url = "";
                int stokAdet = 0;

                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT urunAdi, fiyat, foto, adet FROM urunler WHERE urunID = @urunID";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@urunID", urunID);
                        using (MySqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                urunAdi = dr["urunAdi"].ToString();
                                url = dr["foto"].ToString();
                                fiyat = Convert.ToDecimal(dr["fiyat"]);
                                stokAdet = Convert.ToInt32(dr["adet"]);
                            }
                            else
                            {
                                return; // Ürün bulunamadı
                            }
                        }
                    }
                }

                // Session kontrolü yap
                List<SepetItem> sepet;
                if (Session["Sepet"] == null)
                {
                    sepet = new List<SepetItem>();
                }
                else
                {
                    sepet = (List<SepetItem>)Session["Sepet"];
                }

                // Ürün zaten sepette var mı kontrol et
                SepetItem mevcutUrun = sepet.FirstOrDefault(item => item.UrunID == urunID);

                // Stok kontrolü: sepetteki mevcut adet + 1 <= stokAdet olmalı
                int toplamAdet = (mevcutUrun != null) ? mevcutUrun.Adet + 1 : 1;

                if (toplamAdet > stokAdet)
                {
                    ShowAlert($"{urunAdi} için yeterli stok yok. Mevcut: {stokAdet}");

                    return;
                }

                if (mevcutUrun != null)
                {
                    mevcutUrun.Adet++;
                    mevcutUrun.toplamFiyat = mevcutUrun.Adet * mevcutUrun.Fiyat;
                }
                else
                {
                    SepetItem yeniUrun = new SepetItem
                    {
                        UrunID = urunID,
                        UrunAdi = urunAdi,
                        Fiyat = fiyat,
                        foto = url,
                        Adet = 1,
                        toplamFiyat = fiyat
                    };
                    sepet.Add(yeniUrun);
                }

                Session["Sepet"] = sepet;
            }
        }

        private void ShowAlert(string message)
        {
            string script = $"<script type=\"text/javascript\">alert('{message}');</script>";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", script);
        }

    }
}

public class SepetItem
    {
        public int UrunID { get; set; }
        public string UrunAdi { get; set; }
        public decimal Fiyat { get; set; }

        public string foto { get; set; }
        public int Adet { get; set; }
        public decimal toplamFiyat { get; set; }
    }
