using System;
using MySqlConnector;

namespace DiorWeb
{
    public partial class kayitol : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnKayitOl_Click(object sender, EventArgs e)
        {
            string isim = txtIsim.Text.Trim();
            string soyisim = txtSoyisim.Text.Trim();
            string mail = txtMail.Text.Trim();
            string sifre = txtSifre.Text.Trim();

            string connStr = "Server=localhost;Database=dior;Uid=root;Pwd=;";

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                try
                {
                    conn.Open();

                    // E-posta zaten var mı kontrolü
                    string kontrolQuery = "SELECT COUNT(*) FROM users WHERE mail=@mail";
                    MySqlCommand kontrolCmd = new MySqlCommand(kontrolQuery, conn);
                    kontrolCmd.Parameters.AddWithValue("@mail", mail);

                    int count = Convert.ToInt32(kontrolCmd.ExecuteScalar());

                    if (count > 0)
                    {
                        lblMesaj.CssClass = "error";
                        lblMesaj.Text = "Bu e-posta zaten kayıtlı.";
                        return;
                    }

                    string kayitQuery = "INSERT INTO users (isim, soyisim, mail, sifre) VALUES (@isim, @soyisim, @mail, @sifre)";
                    MySqlCommand cmd = new MySqlCommand(kayitQuery, conn);
                    cmd.Parameters.AddWithValue("@isim", isim);
                    cmd.Parameters.AddWithValue("@soyisim", soyisim);
                    cmd.Parameters.AddWithValue("@mail", mail);
                    cmd.Parameters.AddWithValue("@sifre", sifre);

                    cmd.ExecuteNonQuery();

                    // Giriş sayfasına yönlendir
                    Response.Redirect("giris.aspx");
                }
                catch (Exception ex)
                {
                    lblMesaj.CssClass = "error";
                    lblMesaj.Text = "Hata: " + ex.Message;
                }
            }
        }
    }
}
