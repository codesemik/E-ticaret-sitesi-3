<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminpanel.aspx.cs" Inherits="kozmetik.adminpanel" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        .card-header {
            background-color: #fff;
            border-bottom: 1px solid #e9ecef;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .nav-link {
            color: #333;
            font-weight: 500;
        }

        .nav-link:hover {
            color: #0d6efd;
            background-color: #f0f0f0;
            border-radius: 8px;
        }

        .form-control,
        .form-select {
            border-radius: 10px;
            box-shadow: none !important;
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
        }

        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }

        .btn-success {
            background-color: #198754;
            border: none;
        }

        @media (max-width: 768px) {
            .card {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body class="bg-light">
    <form id="form1" runat="server">

<div class="container-fluid">
    <div class="row min-vh-100">
        <!-- Sidebar -->
        <div class="col-md-3 bg-white shadow p-4">
            <h4 class="mb-4">Yönetim Paneli</h4>
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link" href="adminPanel.aspx">Ürünler</a></li>
                <li class="nav-item"><a class="nav-link" href="adminSiparisler.aspx">Siparişler</a></li>
                <li class="nav-item"><a class="nav-link" href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                <li class="nav-item"><a class="nav-link" href="adminStok.aspx">Stok</a></li>
            </ul>
        </div>

        <!-- Ana içerik -->
        <div class="col-md-9 p-4">
            <!-- İstatistikler -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">Toplam Ürün<br><strong runat="server" id="lblToplamUrun">0</strong></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">Toplam Sipariş<br><strong runat="server" id="lblToplamSiparis">0</strong></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">Bekleyen Sipariş<br><strong runat="server" id="lblBekleyenSiparis">0</strong></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">Stokta Azalan<br><strong runat="server" id="lblStokAzalan">0</strong></div>
                    </div>
                </div>
            </div>

            <!-- Ürün Ekleme Formu -->
            <div class="card mb-4">
                <div class="card-header">Yeni Ürün Ekle</div>
                <div class="card-body">
                    <asp:TextBox ID="txtUrunAdi" runat="server" CssClass="form-control mb-3" placeholder="Ürün Adı"></asp:TextBox>
                    <asp:TextBox ID="txtFiyat" runat="server" CssClass="form-control mb-3" placeholder="Fiyat" TextMode="Number"></asp:TextBox>
                    <asp:TextBox ID="txtStok" runat="server" CssClass="form-control mb-3" placeholder="Stok" TextMode="Number"></asp:TextBox>

                    <asp:DropDownList ID="ddlKategori" runat="server" CssClass="form-select mb-3">
                        <asp:ListItem Value="" Text="Kategori Seçiniz" Selected="True" />
                        <asp:ListItem Value="Ruj" Text="Ruj" />
                        <asp:ListItem Value="Allık" Text="Allık" />
                        <asp:ListItem Value="Fondoten" Text="Fondöten" />
                    </asp:DropDownList>

                    <asp:FileUpload ID="fuResim" runat="server" CssClass="form-control mb-3" />
        
                    <asp:Button ID="btnUrunEkle" runat="server" CssClass="btn btn-primary" Text="Ürün Ekle" OnClick="btnUrunEkle_Click" />
                </div>
            </div>

            <!-- Ürün Arama -->
            <div class="card mb-4">
                <div class="card-header">Ürün Ara</div>
                <div class="card-body">
                    <asp:TextBox ID="txtArama" runat="server" CssClass="form-control mb-3" placeholder="Ürün adı girin"></asp:TextBox>
                    <asp:Button ID="btnAra" runat="server" CssClass="btn btn-primary" Text="Ara" OnClick="btnAra_Click" />
                    <asp:GridView ID="gvSonuc" runat="server" CssClass="table table-bordered table-hover mt-3"
                        AutoGenerateColumns="false" Visible="false">
                        <Columns>
                            <asp:BoundField DataField="urunID" HeaderText="Ürün ID" />
                            <asp:BoundField DataField="urunAdi" HeaderText="Ürün Adı" />
                            <asp:BoundField DataField="fiyat" HeaderText="Fiyat" />
                            <asp:BoundField DataField="adet" HeaderText="Stok" />
                        </Columns>
                    </asp:GridView>

                </div>
            </div>
            <%--ürün düzenleme--%>
            <div class="card mb-4">
                <div class="card-header">Ürün Güncelle</div>
                <div class="card-body">
                    <asp:TextBox ID="txtUrunID" runat="server" CssClass="form-control mb-3" placeholder="Güncellenecek Ürün ID"></asp:TextBox>
                    <asp:Button ID="btnGetir" runat="server" CssClass="btn btn-info mb-3" Text="Ürünü Getir" OnClick="btnGetir_Click" />

                    <asp:Panel ID="pnlUpdate" runat="server" Visible="false">
                        <asp:TextBox ID="txtUrunAdiGuncelle" runat="server" CssClass="form-control mb-3" placeholder="Ürün Adı"></asp:TextBox>

                        <asp:DropDownList ID="ddlKategoriGuncelle" runat="server" CssClass="form-select mb-3">
                            <asp:ListItem Value="Ruj" Text="Ruj" />
                            <asp:ListItem Value="Allık" Text="Allık" />
                            <asp:ListItem Value="Fondoten" Text="Fondöten" />
                        </asp:DropDownList>

                        <asp:TextBox ID="txtFiyatGuncelle" runat="server" CssClass="form-control mb-3" placeholder="Fiyat" TextMode="Number"></asp:TextBox>
                        <asp:TextBox ID="txtStokGuncelle" runat="server" CssClass="form-control mb-3" placeholder="Stok" TextMode="Number"></asp:TextBox>

                        <asp:FileUpload ID="fuResimGuncelle" runat="server" CssClass="form-control mb-3" />

                        <asp:Button ID="btnGuncelle" runat="server" CssClass="btn btn-success" Text="Güncelle" OnClick="btnGuncelle_Click" />
                    </asp:Panel>
                </div>
            </div>


        </div>
    </div>
</div>
</form>
</body>
</html>