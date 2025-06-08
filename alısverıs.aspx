<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="alisveris.aspx.cs" Inherits="DiorWeb.alisveris" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dior Ürünleri</title>
    <link href="style.css" rel="stylesheet" />
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

    <style type="text/css">
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: #f4f4f4;
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

        .header {
            background-color: #111;
            color: white;
            padding: 20px 0;
            text-align: center;
            font-size: 32px;
            font-weight: bold;
            letter-spacing: 2px;
        }

        .kategori-secimi {
            text-align: center;
            margin: 30px 0;
        }

        .kategori-listesi {
            display: inline-block;
        }

        .urun-listesi {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
            gap: 30px;
        }

        .urun-karti {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 280px;
            padding: 15px;
            text-align: center;
            transition: 0.3s;
        }

        .urun-karti:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }

        .urun-karti img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }

        .urun-karti h3 {
            margin: 10px 0;
            font-size: 20px;
            color: #333;
        }

        .urun-karti p {
            color: #888;
            font-size: 16px;
            margin: 10px 0;
        }

        .ekle-btn {
            background-color: #222;
            color: white;
            border: none;
            padding: 10px 25px;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .ekle-btn:hover {
            background-color: #444;
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

        <div class="kategori-secimi">
            <asp:RadioButtonList ID="rblKategoriler" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="rblKategoriler_SelectedIndexChanged"
                RepeatDirection="Horizontal"
                CssClass="kategori-listesi">
                <asp:ListItem Text="Ruj" Value="Ruj" />
                <asp:ListItem Text="Allık" Value="Allık" />
                <asp:ListItem Text="Fondöten" Value="Fondoten" />
            </asp:RadioButtonList>
        </div>

        <div class="urun-listesi">
            <asp:DataList ID="dlUrunler" runat="server" RepeatColumns="3" RepeatLayout="Flow"
                OnItemCommand="dlUrunler_ItemCommand">

                <ItemTemplate>
                    <div class="urun-karti">
                        <img src='<%# ResolveUrl("~/images/" + Eval("foto")) %>' alt="Ürün" />
                        <h2><%# Eval("urunAdi") %></h2>
                        <p>Fiyat: <%# Eval("fiyat", "{0:C}") %></p>
                        <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle" CssClass="ekle-btn"
                            CommandName="SepeteEkle" CommandArgument='<%# Eval("urunID") %>' />
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>
    </form>
</body>
</html>
