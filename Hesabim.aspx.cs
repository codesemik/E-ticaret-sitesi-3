using System;
using MySqlConnector;

namespace DiorWeb
{
    public partial class Hesabim : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userID"] == null)
                {
                    Response.Redirect("Giris.aspx"); // Giriş yapılmamışsa login sayfasına yönlendir
                    return;
                }

                int kullaniciID = Convert.ToInt32(Session["userID"]);
                KullaniciBilgileriniGetir(kullaniciID);
            }
        }

        private void KullaniciBilgileriniGetir(int kullaniciID)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT mail FROM users WHERE userID = @kullaniciID";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@kullaniciID", kullaniciID);
                    var email = cmd.ExecuteScalar();
                    if (email != null)
                    {
                        txtEskiEmail.Text = email.ToString();  // eski emailyi forma yazdırabiliriz (istersen)
                    }
                }
            }
        }

        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            int kullaniciID = Convert.ToInt32(Session["userID"]);

            string eskiEmail = txtEskiEmail.Text.Trim();
            string yeniEmail = txtYeniEmail.Text.Trim();

            string eskiSifre = txtEskiSifre.Text.Trim();
            string yeniSifre = txtYeniSifre.Text.Trim();
            string yeniSifreTekrar = txtYeniSifreTekrar.Text.Trim();

            lblMesaj.ForeColor = System.Drawing.Color.Red;
            lblMesaj.Text = "";

            if (string.IsNullOrEmpty(eskiEmail) || string.IsNullOrEmpty(yeniEmail))
            {
                lblMesaj.Text = "E-posta alanları boş bırakılamaz.";
                return;
            }

            if (string.IsNullOrEmpty(eskiSifre) && (!string.IsNullOrEmpty(yeniSifre) || !string.IsNullOrEmpty(yeniSifreTekrar)))
            {
                lblMesaj.Text = "Şifre değiştirmek için eski şifreyi giriniz.";
                return;
            }

            if (!string.IsNullOrEmpty(yeniSifre))
            {
                if (yeniSifre != yeniSifreTekrar)
                {
                    lblMesaj.Text = "Yeni şifreler uyuşmuyor.";
                    return;
                }
            }

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                // Kullanıcının eski email ve eski şifresinin doğruluğunu kontrol edelim
                string checkQuery = "SELECT COUNT(*) FROM users WHERE userID = @kullaniciID AND mail = @eskiEmail";

                // Eğer şifre değiştirilecekse, şifre de kontrol edilecek
                if (!string.IsNullOrEmpty(eskiSifre))
                {
                    checkQuery = "SELECT COUNT(*) FROM users WHERE userID = @kullaniciID AND mail = @eskiEmail AND sifre = @eskiSifre";
                }

                using (MySqlCommand checkCmd = new MySqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@kullaniciID", kullaniciID);
                    checkCmd.Parameters.AddWithValue("@eskiEmail", eskiEmail);
                    if (!string.IsNullOrEmpty(eskiSifre))
                        checkCmd.Parameters.AddWithValue("@eskiSifre", eskiSifre); // Not: burada şifre hash kontrolü olmalı

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count == 0)
                    {
                        lblMesaj.Text = "Eski e-posta veya eski şifre hatalı.";
                        return;
                    }
                }

                // Güncelleme işlemleri
                string updateEmailQuery = "UPDATE users SET mail = @yeniEmail WHERE userID = @kullaniciID";
                using (MySqlCommand updateCmd = new MySqlCommand(updateEmailQuery, conn))
                {
                    updateCmd.Parameters.AddWithValue("@yeniEmail", yeniEmail);
                    updateCmd.Parameters.AddWithValue("@kullaniciID", kullaniciID);
                    updateCmd.ExecuteNonQuery();
                }

                if (!string.IsNullOrEmpty(yeniSifre))
                {
                    string updateSifreQuery = "UPDATE users SET sifre = @yeniSifre WHERE userID = @kullaniciID";
                    using (MySqlCommand updateSifreCmd = new MySqlCommand(updateSifreQuery, conn))
                    {
                        updateSifreCmd.Parameters.AddWithValue("@yeniSifre", yeniSifre); // Burada da şifre hashlenmeli!
                        updateSifreCmd.Parameters.AddWithValue("@kullaniciID", kullaniciID);
                        updateSifreCmd.ExecuteNonQuery();
                    }
                }
            }

            lblMesaj.ForeColor = System.Drawing.Color.Green;
            lblMesaj.Text = "Bilgiler başarıyla güncellendi.";
        }
    }
}
