<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminKullanicilar.aspx.cs" Inherits="kozmetik.adminKullanicilar" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <title>Kullanıcılar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        /* Aynı CSS */
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
                        <li class="nav-item"><a class="nav-link" href="adminSiparisler.aspx">Siparişler</a></li>
                        <li class="nav-item"><a class="nav-link active" href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                        <li class="nav-item"><a class="nav-link" href="adminStok.aspx">Stok</a></li>
                    </ul>
                </div>

                <!-- İçerik -->
                <div class="col-md-9 p-4">
                    <div class="card">
                        <div class="card-header">Kullanıcılar Listesi</div>
                        <div class="card-body">
                            <div class="mb-3 row">
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtArama" runat="server" CssClass="form-control" placeholder="İsim veya Soyisim ile ara" />
                                </div>
                                <div class="col-md-4">
                                    <asp:Button ID="btnAra" runat="server" CssClass="btn btn-primary w-100" Text="Ara" OnClick="btnAra_Click" />
                                </div>
                            </div>

                            <asp:GridView ID="gvKullanicilar" runat="server" CssClass="table table-bordered table-hover"
                                AutoGenerateColumns="false" EmptyDataText="Kullanıcı bulunamadı.">
                                <Columns>
                                    <asp:BoundField DataField="userID" HeaderText="ID" ReadOnly="true" />
                                    <asp:BoundField DataField="isim" HeaderText="İsim" />
                                    <asp:BoundField DataField="soyisim" HeaderText="Soyisim" />
                                    <asp:BoundField DataField="mail" HeaderText="E-posta" />
                                    <asp:BoundField DataField="kayitTarihi" HeaderText="Kayıt Tarihi" DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
