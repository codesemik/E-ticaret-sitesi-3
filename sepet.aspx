<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sepet.aspx.cs" Inherits="DiorWeb.sepet" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sepetim</title>
    <link rel="stylesheet" href="index.css" />
    <script>
        function toggleDropdown() {
            var dropdownContent = document.getElementById("dropdownContent");
            dropdownContent.classList.toggle("show");
        }

        // Kapatmak için dışarı tıklanınca kapanması:
        window.onclick = function (event) {
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
        /* Genel Ayarlar */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background-color: #f5f5f5;
}

/* Header */
.header {
    background-color: #111;
    color: white;
    text-align: center;
    padding: 25px;
    font-size: 36px;
    font-weight: bold;
    letter-spacing: 2px;
}

/* Navbar */
.navbar {
    background-color: #222;
    overflow: hidden;
    text-align: center;
    padding: 15px 0;
}

.navbar a {
    display: inline-block;
    color: white;
    text-decoration: none;
    padding: 12px 24px;
    margin: 0 10px;
    background-color: #333;
    border-radius: 8px;
    transition: background-color 0.3s ease;
}

.navbar a:hover {
    background-color: #555;
}

.cart-link {
    background-color: #444;
}

/* GridView (Sepet) */
.sepet-grid {
    width: 90%;
    border-collapse: collapse;
    margin: 30px auto;
    background-color: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 0 15px rgba(0,0,0,0.1);
}

.sepet-grid th {
    background-color: #333;
    color: white;
    padding: 12px;
    font-size: 16px;
    text-align: center;
}

.sepet-grid td {
    padding: 15px;
    text-align: center;
    vertical-align: middle;
    border-bottom: 1px solid #ddd;
}

/* Ürün Resmi */
.urun-resmi img, .urun-resmi {
    border-radius: 6px;
    max-width: 80px;
    max-height: 80px;
}

/* Butonlar */
.sil-butonu,
.satinal-butonu {
    background-color: #111;
    color: white;
    padding: 8px 16px;
    margin: 0 5px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    transition: background-color 0.3s ease;
}

.sil-butonu:hover {
    background-color: crimson;
}

.satinal-butonu:hover {
    background-color: #444;
}

/* Adet sayısı */
.product-adet {
    padding: 0 10px;
    font-size: 16px;
    font-weight: bold;
}

/* Footer */
footer {
    background-color: #222;
    color: #ddd;
    text-align: center;
    padding: 20px 0;
    margin-top: 50px;
    font-size: 14px;
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
    <form runat="server">
        <header>
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
        </header>

        <main>
            <center>
            <asp:GridView ID="SepetGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="UrunID" OnRowDeleting="SepetGridView_RowDeleting" CssClass="sepet-grid" OnRowCommand="SepetGridView_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Ürün Resmi">
                        <ItemTemplate>
                            <asp:Image ID="imgUrun" runat="server"
                            ImageUrl='<%# VirtualPathUtility.ToAbsolute("~/images/" + Eval("foto")) %>'
                            CssClass="urun-resmi"
                            Height="80" Width="80"
                            AlternateText='<%# Eval("UrunAdi") %>' />

                        </ItemTemplate>
                        <ItemStyle CssClass="urun-resmi" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                    <asp:TemplateField HeaderText="Adet">
                        <ItemTemplate>
                            <asp:Button ID="btnAzalt" runat="server" Text="-" CommandName="Azalt" CommandArgument='<%# Container.DataItemIndex %>' CssClass="sil-butonu" />
                            <asp:Label ID="lblAdet" runat="server" Text='<%# Eval("adet") %>' CssClass="product-adet"></asp:Label>
                            <asp:Button ID="btnArttir" runat="server" Text="+" CommandName="Arttir" CommandArgument='<%# Container.DataItemIndex %>' CssClass="satinal-butonu" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Fiyat" HeaderText="Birim Fiyat" DataFormatString="{0:C}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnSil" runat="server" Text="Sil" CommandName="Delete" CssClass="sil-butonu" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <br />
            <br />
            </center>
            <p>
                <strong>Toplam Fiyat: </strong>
                <asp:Literal ID="ToplamFiyatLiteral" runat="server" />
                <asp:Button ID="btnSatınAl" runat="server" Text="Satın Al" OnClick="BtnSatınAl_Click" CssClass="satinal-butonu" />    </p>
        </main>

        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>
    <script>
        function toggleDropdown() {
            var dropdownContent = document.getElementById("dropdownContent");
            dropdownContent.classList.toggle("show");
        }

        window.onclick = function(event) {
            if (!event.target.matches('.dropbtn')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                var i;
                for (i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }
    </script>
</body>
</html>
