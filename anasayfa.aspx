<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="anasayfa.aspx.cs" Inherits="DiorWeb.anasayfa" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dior Ana Sayfa</title>
    <link rel="stylesheet" href="style.css" />
    <script>
function toggleDropdown() {
    var dropdownContent = document.getElementById("dropdownContent");
    dropdownContent.classList.toggle("show");
}

// Kapatmak için dışarı tıklanınca kapanması:
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
}
    </script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .header {
            background-color: #111;
            color: white;
            padding: 30px 0;
            text-align: center;
            font-size: 36px;
            font-weight: bold;
            letter-spacing: 2px;
        }

        /* NAVBAR */
.navbar {
    background-color: #111;
    padding: 20px 0;
    text-align: center;
}

.navbar a {
    text-decoration: none;
    color: white;
    background-color: #333;
    padding: 12px 25px;
    margin: 0 10px;
    border-radius: 8px;
    font-family: 'Segoe UI', sans-serif;
    transition: background-color 0.3s ease;
}

.navbar a:hover {
    background-color: #555;
}

        .cart-link {
            background-color: #2ecc71 !important;
        }

        .cart-link:hover {
            background-color: #27ae60 !important;
        }

        .banner {
            display: flex;
            justify-content: center;
            margin: 40px 0;
        }

        .banner img {
            width: 90%;
            max-width: 1033px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

                /* Dropdown (Hesabım) */
.dropdown {
    display: inline-block;
    position: relative;
}

.dropbtn {
    background-color: #333;
    color: white;
    padding: 12px 24px;
    margin-left: 10px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
}

.dropbtn:hover {
    background-color: #555;
}

.dropdown-content {
    display: none;
    position: absolute;
    right: 0;
    background-color: #444;
    min-width: 160px;
    border-radius: 8px;
    box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
    z-index: 1;
}

.dropdown-content a {
    color: white;
    padding: 12px 16px;
    display: block;
    text-decoration: none;
    border-bottom: 1px solid #555;
}

.dropdown-content a:hover {
    background-color: #555;
}

.show {
    display: block;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            DIOR
        </div>

        <div class="navbar">
            <a href="anasayfa.aspx">Ana Sayfa</a>
            <a href="alısverıs.aspx">Ürünler</a>
            <a href="#">İletişim</a>
            <a href="sepet.aspx" class="cart-link">Sepete Git</a>

            <div class="dropdown">
                <button type="button" onclick="toggleDropdown()" class="dropbtn">
                    <% 
                        if (Session["isim"] != null)
                        {
                            Response.Write(Session["isim"].ToString()+" ▼");
                        }
                        else
                        {
                            Response.Write("Hesabım ▼");
                        }
                    %>
                </button>
                <div id="dropdownContent" class="dropdown-content">
                    <%
                        if (Session["isim"] != null)
                        {
                    %>
                        <a href="hesabim.aspx">Hesabım</a>
                        <a href="siparislerim.aspx">Siparişlerim</a>
                        <a href="cikis.aspx">Çıkış Yap</a>
                    <%
                        }
                        else
                        {
                    %>
                        <a href="giris.aspx">Giriş Yap</a>
                        <a href="kayitol.aspx">Kayıt Ol</a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <div class="banner">
            <asp:Image ID="Image1" runat="server" ImageUrl="~/nedior.jpg" AlternateText="Banner" />
        </div>
    </form>
</body>
</html>
