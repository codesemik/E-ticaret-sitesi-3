using System;
using System.Data;
using MySqlConnector;

namespace kozmetik
{
    public partial class adminStok : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=dior;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                // stokID yok, urunID kullanılıyor; miktar yerine adet; guncellemeTarihi yok, o yüzden göstermiyorum
                string query = "SELECT urunID, urunAdi, adet FROM urunler ORDER BY urunAdi";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvStok.DataSource = dt;
                    gvStok.DataBind();
                }
            }
        }

        protected void gvStok_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            gvStok.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void gvStok_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            gvStok.EditIndex = -1;
            BindGrid();
        }

        protected void gvStok_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            int urunID = Convert.ToInt32(gvStok.DataKeys[e.RowIndex].Value);
            System.Web.UI.WebControls.TextBox txtMiktar = (System.Web.UI.WebControls.TextBox)gvStok.Rows[e.RowIndex].FindControl("txtMiktar");

            int yeniAdet;
            if (!int.TryParse(txtMiktar.Text.Trim(), out yeniAdet) || yeniAdet < 0)
            {
                // Hatalı giriş - kullanıcıya mesaj verilebilir
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                string query = "UPDATE urunler SET adet = @adet WHERE urunID = @urunID";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@adet", yeniAdet);
                    cmd.Parameters.AddWithValue("@urunID", urunID);
                    cmd.ExecuteNonQuery();
                }
            }

            gvStok.EditIndex = -1;
            BindGrid();
        }

        // Sil butonu stok miktarını 0 yapacak
        protected void gvStok_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Sil")
            {
                int urunID = Convert.ToInt32(e.CommandArgument);

                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "UPDATE urunler SET adet = 0 WHERE urunID = @urunID";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@urunID", urunID);
                        cmd.ExecuteNonQuery();
                    }
                }

                BindGrid();
            }
        }
    }
}
