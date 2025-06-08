using System;
using System.Data;
using MySqlConnector;

namespace kozmetik
{
    public partial class adminKullanicilar : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid(string aramaKelimesi = "")
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                string query = @"
                    SELECT userID, isim, soyisim, mail, kayitTarihi 
                    FROM users";

                if (!string.IsNullOrEmpty(aramaKelimesi))
                {
                    query += " WHERE CONCAT(isim, ' ', soyisim) LIKE @aramaKelimesi";
                }

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(aramaKelimesi))
                    {
                        cmd.Parameters.AddWithValue("@aramaKelimesi", "%" + aramaKelimesi + "%");
                    }

                    MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvKullanicilar.DataSource = dt;
                    gvKullanicilar.DataBind();
                }
            }
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            string arama = txtArama.Text.Trim();
            BindGrid(arama);
        }
    }
}
