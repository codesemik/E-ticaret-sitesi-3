<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminStok.aspx.cs" Inherits="kozmetik.adminStok" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <title>Stok Yönetimi</title>
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
        .form-control, .form-select {
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
        .btn-danger {
            border-radius: 10px;
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
                        <li class="nav-item"><a class="nav-link" href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                        <li class="nav-item"><a class="nav-link active" href="adminStok.aspx">Stok</a></li>
                    </ul>
                </div>

                <!-- İçerik -->
                <div class="col-md-9 p-4">
                    <div class="card">
                        <div class="card-header">Stok Listesi</div>
                        <div class="card-body">
                            <asp:GridView ID="gvStok" runat="server" CssClass="table table-bordered table-hover"
                                AutoGenerateColumns="false" EmptyDataText="Stok bulunamadı." DataKeyNames="urunID"
                                OnRowEditing="gvStok_RowEditing" OnRowCancelingEdit="gvStok_RowCancelingEdit" OnRowUpdating="gvStok_RowUpdating" OnRowCommand="gvStok_RowCommand">

                                <Columns>
                                    <asp:BoundField DataField="urunID" HeaderText="ID" ReadOnly="true" />
                                    <asp:BoundField DataField="urunAdi" HeaderText="Ürün Adı" ReadOnly="true" />
        
                                    <%-- Düzenlenebilir Stok Miktarı --%>
                                    <asp:TemplateField HeaderText="Miktar">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMiktar" runat="server" Text='<%# Bind("adet") %>' CssClass="form-control" />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <%# Eval("adet") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Düzenle Butonu --%>
                                    <asp:CommandField ShowEditButton="true" />

                                    <%-- Sil Butonu --%>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Button ID="btnSil" runat="server" Text="Sil" CssClass="btn btn-danger btn-sm"
                                                CommandName="Sil" CommandArgument='<%# Eval("urunID") %>'
                                                OnClientClick="return confirm('Stok sıfırlansın mı?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
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
