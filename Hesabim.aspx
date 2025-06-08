<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Hesabim.aspx.cs" Inherits="DiorWeb.Hesabim" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <title>Hesabım</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        form.container {
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }

        h3 {
            margin-bottom: 25px;
            color: #343a40;
            font-weight: 600;
            text-align: center;
        }

        .btn-primary {
            width: 100%;
            font-weight: 600;
            font-size: 1.1rem;
        }

        #lblMesaj {
            margin-bottom: 15px;
            text-align: center;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container mt-5">
        <h3>Hesap Bilgilerim</h3>
        <asp:Label ID="lblMesaj" runat="server" ForeColor="red"></asp:Label>

        <h5>E-posta Değişikliği</h5>
        <div class="mb-3">
            <asp:Label ID="lblEskiEmail" runat="server" Text="Eski E-posta" AssociatedControlID="txtEskiEmail" CssClass="form-label" />
            <asp:TextBox ID="txtEskiEmail" runat="server" CssClass="form-control" TextMode="Email" />
        </div>

        <div class="mb-3">
            <asp:Label ID="lblYeniEmail" runat="server" Text="Yeni E-posta" AssociatedControlID="txtYeniEmail" CssClass="form-label" />
            <asp:TextBox ID="txtYeniEmail" runat="server" CssClass="form-control" TextMode="Email" />
        </div>

        <hr />

        <h5>Şifre Değişikliği</h5>
        <div class="mb-3">
            <asp:Label ID="lblEskiSifre" runat="server" Text="Eski Şifre" AssociatedControlID="txtEskiSifre" CssClass="form-label" />
            <asp:TextBox ID="txtEskiSifre" runat="server" CssClass="form-control" TextMode="Password" />
        </div>

        <div class="mb-3">
            <asp:Label ID="lblYeniSifre" runat="server" Text="Yeni Şifre" AssociatedControlID="txtYeniSifre" CssClass="form-label" />
            <asp:TextBox ID="txtYeniSifre" runat="server" CssClass="form-control" TextMode="Password" />
        </div>

        <div class="mb-3">
            <asp:Label ID="lblYeniSifreTekrar" runat="server" Text="Yeni Şifre (Tekrar)" AssociatedControlID="txtYeniSifreTekrar" CssClass="form-label" />
            <asp:TextBox ID="txtYeniSifreTekrar" runat="server" CssClass="form-control" TextMode="Password" />
        </div>

        <asp:Button ID="btnGuncelle" runat="server" Text="Güncelle" CssClass="btn btn-primary" OnClick="btnGuncelle_Click" />
    </form>
</body>
</html>
