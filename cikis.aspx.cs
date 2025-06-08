using System;
using System.Web;

namespace DiorWeb
{
    public partial class cikis : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Tüm session verilerini temizle
            Session.Clear();
            Session.Abandon();

            // Gerekirse tarayıcı önbelleğini de temizlemek için aşağıdakileri ekleyebilirsin
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            // Giriş sayfasına yönlendir
            Response.Redirect("anasayfa.aspx");
        }
    }
}
