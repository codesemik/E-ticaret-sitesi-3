<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminSiparisler.aspx.cs" Inherits="kozmetik.adminSiparisler" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <title>Siparişler</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
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
                        <li class="nav-item"><a class="nav-link" href="adminpanel.aspx">Ürünler</a></li>
                        <li class="nav-item"><a class="nav-link active" href="adminSiparisler.aspx">Siparişler</a></li>
                        <li class="nav-item"><a class="nav-link" href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                        <li class="nav-item"><a class="nav-link" href="adminStok.aspx">Stok</a></li>
                    </ul>
                </div>

                <!-- İçerik -->
                <div class="col-md-9 p-4">
                    <div class="card">
                        <div class="card-header">Siparişler Listesi</div>
                        <div class="card-body">
                            <div class="mb-3 row">
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtArama" runat="server" CssClass="form-control" placeholder="Müşteri adına göre ara" />
                                </div>
                                <div class="col-md-4">
                                    <asp:Button ID="btnAra" runat="server" CssClass="btn btn-primary w-100" Text="Ara" OnClick="btnAra_Click" />
                                </div>
                            </div>
                            <asp:GridView ID="gvSiparisler" runat="server" CssClass="table table-bordered table-hover"
                                AutoGenerateColumns="false" >
                                <Columns>
                                    <asp:BoundField DataField="siparisID" HeaderText="Sipariş ID" ReadOnly="true" />
                                    <asp:BoundField DataField="musteriAdi" HeaderText="Müşteri" />
                                    <asp:BoundField DataField="toplamFiyat" HeaderText="Toplam Fiyat" DataFormatString="{0:C}" />
                                    <asp:BoundField DataField="durum" HeaderText="Durum" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Sipariş Güncelleme -->
                    <div class="card">
                        <div class="card-header">Sipariş Durumu Güncelle</div>
                        <div class="card-body">
                            <asp:TextBox ID="txtSiparisID" runat="server" CssClass="form-control mb-3" placeholder="Sipariş ID"></asp:TextBox>
                            <asp:DropDownList ID="ddlDurum" runat="server" CssClass="form-select mb-3">
                                <asp:ListItem Text="Durum Seçiniz" Value="" Selected="True" Disabled="True"></asp:ListItem>
                                <asp:ListItem Text="Beklemede" Value="bekliyor"></asp:ListItem>
                                <asp:ListItem Text="Hazırlanıyor" Value="hazırlanıyor"></asp:ListItem>
                                <asp:ListItem Text="Kargoda" Value="kargoda"></asp:ListItem>
                                <asp:ListItem Text="Teslim Edildi" Value="teslim edildi"></asp:ListItem>
                                <asp:ListItem Text="İptal Edildi" Value="iptal edildi"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="btnSiparisGuncelle" runat="server" CssClass="btn btn-success" Text="Durumu Güncelle" OnClick="btnSiparisGuncelle_Click" />
                        </div>
                    </div>

                    <h3>Ürün ID'ye Göre Siparişleri Listele</h3>
                    <div class="mb-3 row">
                        <div class="col-md-6">
                            <asp:TextBox ID="txtUrunID" runat="server" CssClass="form-control" placeholder="Ürün ID Giriniz" />
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnUrunAra" runat="server" CssClass="btn btn-primary w-100" Text="Ara" OnClick="btnAra_Click" />
                        </div>
                    </div>

                    <asp:GridView ID="gvUrunSiparisleri" runat="server" CssClass="table table-bordered table-hover"
                        AutoGenerateColumns="false" EmptyDataText="Bu ürün ID için sipariş bulunamadı.">
                        <Columns>
                            <asp:BoundField DataField="siparisID" HeaderText="Sipariş ID" ReadOnly="true" />
                            <asp:BoundField DataField="musteriAdi" HeaderText="Müşteri" />
                            <asp:BoundField DataField="urunAdi" HeaderText="Ürün" />
                            <asp:BoundField DataField="adet" HeaderText="Adet" />
                            <asp:BoundField DataField="toplamFiyat" HeaderText="Toplam Fiyat" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="durum" HeaderText="Durum" />
                            <asp:TemplateField HeaderText="Ürün Resmi">
                                <ItemTemplate>
                                    <asp:Image ID="imgUrun" runat="server" Width="80px" Height="80px" ImageUrl='<%# ResolveUrl("~/images/" + Eval("foto")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    
                </div>
            </div>
        </div>
    </form>
</body>
</html>
