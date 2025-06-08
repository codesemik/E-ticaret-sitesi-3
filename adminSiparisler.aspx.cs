using MySqlConnector;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace kozmetik
{
    public partial class adminSiparisler : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SiparisleriYukle();
            }
        }

        protected void SiparisleriYukle(string musteriAdi = "")
        {
            string query = @"
                            SELECT 
                                s.siparisID,
                                CONCAT(u.isim, ' ', u.soyisim) AS musteriAdi,
                                s.toplamFiyat,
                                s.Durum
                            FROM siparisler s
                            JOIN users u ON s.userID = u.userID
";

            if (!string.IsNullOrEmpty(musteriAdi))
            {
                query += " WHERE CONCAT(u.isim, ' ', u.soyisim) LIKE @musteriAdi";
            }




            using (MySqlConnection conn = new MySqlConnection(connectionString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                if (!string.IsNullOrEmpty(musteriAdi))
                {
                    cmd.Parameters.AddWithValue("@musteriAdi", "%" + musteriAdi + "%");
                }

                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                gvSiparisler.DataSource = reader;
                gvSiparisler.DataBind();
            }
        }

        private void BindGrid(string siparisID)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                string query = @"
            SELECT sd.siparisID, 
                   CONCAT(u.isim, ' ', u.soyisim) AS musteriAdi, 
                   ur.urunAdi, 
                   sd.adet, 
                   sd.fiyat * sd.adet AS toplamFiyat,
                   s.Durum AS durum,
                   ur.foto
            FROM siparis_detaylari sd
            INNER JOIN siparisler s ON sd.siparisID = s.siparisID
            INNER JOIN urunler ur ON sd.urunID = ur.urunID
            INNER JOIN users u ON s.userID = u.userID
            WHERE sd.siparisID = @siparisID";

                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@siparisID", siparisID);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUrunSiparisleri.DataSource = dt;
                gvUrunSiparisleri.DataBind();
            }
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            string urunID = txtUrunID.Text.Trim();
            string musteriAdi = txtArama.Text.Trim();
            SiparisleriYukle(musteriAdi);

            if (!string.IsNullOrEmpty(urunID))
            {
                BindGrid(urunID);
            }
            else
            {
                gvUrunSiparisleri.DataSource = null;
                gvUrunSiparisleri.DataBind();
            }
        }

        protected void btnSiparisGuncelle_Click(object sender, EventArgs e)
        {
            int siparisID;
            string durum = ddlDurum.SelectedValue;

            if (!int.TryParse(txtSiparisID.Text.Trim(), out siparisID))
            {
                Response.Write("<script>alert('Lütfen geçerli bir Sipariş ID girin.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(durum))
            {
                Response.Write("<script>alert('Lütfen bir durum seçin.');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                string query = "UPDATE siparisler SET durum = @durum WHERE siparisID = @siparisID";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@durum", durum);
                cmd.Parameters.AddWithValue("@siparisID", siparisID);

                con.Open();
                int sonuc = cmd.ExecuteNonQuery();
                con.Close();

                if (sonuc > 0)
                {
                    Response.Write("<script>alert('Sipariş durumu başarıyla güncellendi.');</script>");
                    txtSiparisID.Text = "";
                    ddlDurum.SelectedIndex = 0;
                }
                else
                {
                    Response.Write("<script>alert('Sipariş bulunamadı veya güncellenemedi.');</script>");
                }
            }
        }
    }
}
