using System;
using MySqlConnector;

namespace DiorWeb
{
    public partial class giris : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Eğer kullanıcı zaten giriş yaptıysa, doğrudan anasayfa'ya yönlendir
            if (Session["userID"] != null)
            {
                Response.Redirect("anasayfa.aspx");
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            string mail = txtMail.Text.Trim();
            string sifre = txtSifre.Text.Trim();

            string connStr = "Server=localhost;Database=dior;Uid=root;Pwd=;";

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT * FROM users WHERE mail=@mail AND sifre=@sifre";
                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@mail", mail);
                    cmd.Parameters.AddWithValue("@sifre", sifre);

                    MySqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // Oturum bilgilerini kaydet
                        Session["userID"] = dr["userID"];
                        Session["isim"] = dr["isim"];
                        Session["soyisim"] = dr["soyisim"];
                        Session["mail"] = dr["mail"];

                        // Anasayfaya yönlendir
                        Response.Redirect("anasayfa.aspx");
                    }
                    else
                    {
                        lblHata.Text = "E-posta veya şifre hatalı.";
                    }
                }
                catch (Exception ex)
                {
                    lblHata.Text = "Hata oluştu: " + ex.Message;
                }
            }
        }
    }
}
