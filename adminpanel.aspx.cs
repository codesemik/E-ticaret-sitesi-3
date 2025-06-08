using System;
using System.Data;
using System.IO;
using MySqlConnector;

namespace kozmetik
{
    public partial class adminpanel : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ToplamUrun();
                ToplamSiparis();
                BekleyenSiparis();
                StokAzalan();
            }
        }

        private void ToplamUrun()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT COUNT(*) FROM urunler", conn);
                int toplam = Convert.ToInt32(cmd.ExecuteScalar());
                lblToplamUrun.InnerText = toplam.ToString();
            }
        }

        private void ToplamSiparis()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT COUNT(*) FROM siparisler", conn);
                int toplam = Convert.ToInt32(cmd.ExecuteScalar());
                lblToplamSiparis.InnerText = toplam.ToString();
            }
        }

        private void BekleyenSiparis()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT COUNT(*) FROM siparisler WHERE Durum = 'Beklemede'", conn);
                int toplam = Convert.ToInt32(cmd.ExecuteScalar());
                lblBekleyenSiparis.InnerText = toplam.ToString();
            }
        }

        private void StokAzalan()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT COUNT(*) FROM urunler WHERE adet <= 20", conn);
                int toplam = Convert.ToInt32(cmd.ExecuteScalar());
                lblStokAzalan.InnerText = toplam.ToString();
            }
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            string aranan = txtArama.Text.Trim();

            if (!string.IsNullOrEmpty(aranan))
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT urunID, urunAdi, fiyat, adet FROM urunler WHERE urunAdi LIKE @aranan";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@aranan", "%" + aranan + "%");
                        MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvSonuc.DataSource = dt;
                        gvSonuc.DataBind();
                        gvSonuc.Visible = dt.Rows.Count > 0;
                    }
                }
            }
        }

        protected void btnUrunEkle_Click(object sender, EventArgs e)
        {
            string urunAdi = txtUrunAdi.Text.Trim();
            string kategori = ddlKategori.SelectedValue;
            decimal fiyat;
            int stok;

            if (string.IsNullOrEmpty(urunAdi))
            {
                Response.Write("<script>alert('Ürün adı boş olamaz.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(kategori))
            {
                Response.Write("<script>alert('Lütfen kategori seçin.');</script>");
                return;
            }

            if (!decimal.TryParse(txtFiyat.Text.Trim(), out fiyat))
            {
                Response.Write("<script>alert('Fiyat geçerli değil.');</script>");
                return;
            }

            if (!int.TryParse(txtStok.Text.Trim(), out stok))
            {
                Response.Write("<script>alert('Stok geçerli değil.');</script>");
                return;
            }

            // Resim yükleme işlemi
            string resimAdi = null;
            if (fuResim.HasFile)
            {
                string imagesPath = Server.MapPath("~/images/");
                if (!Directory.Exists(imagesPath))
                    Directory.CreateDirectory(imagesPath);

                // Mevcut resim sayısını al
                int resimSayisi = Directory.GetFiles(imagesPath, "resim*.jpg").Length;

                // Yeni isim belirle (resim.jpg, resim1.jpg, resim2.jpg ...)
                resimAdi = resimSayisi == 0 ? "resim.jpg" : $"resim{resimSayisi}.jpg";

                string tamYol = Path.Combine(imagesPath, resimAdi);

                try
                {
                    fuResim.SaveAs(tamYol);
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Resim yüklenirken hata: {ex.Message}');</script>");
                    return;
                }
            }
            else
            {
                resimAdi = "default.jpg"; // Eğer resim yoksa default resmi kullan (ya da boş geç)
            }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                string query = "INSERT INTO urunler (urunAdi, kategori, fiyat, adet, foto) " +
                               "VALUES (@urunAdi, @kategori, @fiyat, @stok, @gorselURL)";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@urunAdi", urunAdi);
                cmd.Parameters.AddWithValue("@kategori", kategori);
                cmd.Parameters.AddWithValue("@fiyat", fiyat);
                cmd.Parameters.AddWithValue("@stok", stok);
                cmd.Parameters.AddWithValue("@gorselURL", resimAdi);

                con.Open();
                int sonuc = cmd.ExecuteNonQuery();
                con.Close();

                if (sonuc > 0)
                {
                    Response.Write("<script>alert('Ürün başarıyla eklendi!');</script>");
                    txtUrunAdi.Text = "";
                    ddlKategori.SelectedIndex = 0;
                    txtFiyat.Text = "";
                    txtStok.Text = "";
                }
                else
                {
                    Response.Write("<script>alert('Ürün eklenirken hata oluştu.');</script>");
                }
            }
        }

        protected void btnGetir_Click(object sender, EventArgs e)
        {
            pnlUpdate.Visible = false;

            int urunID;
            if (!int.TryParse(txtUrunID.Text.Trim(), out urunID))
            {
                Response.Write("<script>alert('Geçerli bir ürün ID girin.');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                string query = "SELECT urunAdi, kategori, fiyat, adet, foto FROM urunler WHERE urunID=@urunID";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@urunID", urunID);

                con.Open();
                var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUrunAdiGuncelle.Text = reader["urunAdi"].ToString();
                    ddlKategoriGuncelle.SelectedValue = reader["kategori"].ToString();
                    txtFiyatGuncelle.Text = reader["fiyat"].ToString();
                    txtStokGuncelle.Text = reader["adet"].ToString();

                    pnlUpdate.Visible = true;
                }
                else
                {
                    Response.Write("<script>alert('Ürün bulunamadı.');</script>");
                }
                con.Close();
            }
        }

        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            int urunID;
            if (!int.TryParse(txtUrunID.Text.Trim(), out urunID))
            {
                Response.Write("<script>alert('Geçerli bir ürün ID girin.');</script>");
                return;
            }

            string urunAdi = txtUrunAdiGuncelle.Text.Trim();
            string kategori = ddlKategoriGuncelle.SelectedValue;
            decimal fiyat;
            int stok;

            if (string.IsNullOrEmpty(urunAdi))
            {
                Response.Write("<script>alert('Ürün adı boş olamaz.');</script>");
                return;
            }

            if (!decimal.TryParse(txtFiyatGuncelle.Text.Trim(), out fiyat))
            {
                Response.Write("<script>alert('Fiyat geçerli değil.');</script>");
                return;
            }

            if (!int.TryParse(txtStokGuncelle.Text.Trim(), out stok))
            {
                Response.Write("<script>alert('Stok geçerli değil.');</script>");
                return;
            }

            string resimAdi = null;
            if (fuResimGuncelle.HasFile)
            {
                string imagesPath = Server.MapPath("~/images/");
                if (!Directory.Exists(imagesPath))
                    Directory.CreateDirectory(imagesPath);

                // Aynı isimlendirme mantığı (yeni isim ver)
                int resimSayisi = Directory.GetFiles(imagesPath, "resim*.jpg").Length;
                resimAdi = resimSayisi == 0 ? "resim.jpg" : $"resim{resimSayisi}.jpg";
                string tamYol = Path.Combine(imagesPath, resimAdi);

                try
                {
                    fuResimGuncelle.SaveAs(tamYol);
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Resim yüklenirken hata: {ex.Message}');</script>");
                    return;
                }
            }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                string query;
                MySqlCommand cmd = new MySqlCommand();
                cmd.Connection = con;

                if (resimAdi != null)
                {
                    // Resim güncellenecek
                    query = "UPDATE urunler SET urunAdi=@urunAdi, kategori=@kategori, fiyat=@fiyat, adet=@adet, gorselURL=@gorselURL WHERE urunID=@urunID";
                    cmd.CommandText = query;
                    cmd.Parameters.AddWithValue("@gorselURL", resimAdi);
                }
                else
                {
                    // Resim değişmeyecek
                    query = "UPDATE urunler SET urunAdi=@urunAdi, kategori=@kategori, fiyat=@fiyat, adet=@adet WHERE urunID=@urunID";
                    cmd.CommandText = query;
                }

                cmd.Parameters.AddWithValue("@urunAdi", urunAdi);
                cmd.Parameters.AddWithValue("@kategori", kategori);
                cmd.Parameters.AddWithValue("@fiyat", fiyat);
                cmd.Parameters.AddWithValue("@adet", stok);
                cmd.Parameters.AddWithValue("@urunID", urunID);

                con.Open();
                int sonuc = cmd.ExecuteNonQuery();
                con.Close();

                if (sonuc > 0)
                {
                    Response.Write("<script>alert('Ürün başarıyla güncellendi!');</script>");
                    pnlUpdate.Visible = false;
                    txtUrunID.Text = "";
                }
                else
                {
                    Response.Write("<script>alert('Güncelleme sırasında hata oluştu.');</script>");
                }
            }
        }

    }

    

//}
}
