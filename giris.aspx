<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="giris.aspx.cs" Inherits="DiorWeb.giris" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Giriş Yap</title>
    <style>
        .login-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        .login-container input[type="submit"] {
            background-color: #222;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .login-container input[type="submit"]:hover {
            background-color: #444;
        }

        .error {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>Giriş Yap</h2>
            <asp:TextBox ID="txtMail" runat="server" placeholder="E-posta adresi"></asp:TextBox><br />
            <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" placeholder="Şifre"></asp:TextBox><br />
            <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" OnClick="btnGiris_Click" /><br />
            <asp:Label ID="lblHata" runat="server" CssClass="error"></asp:Label>
        </div>
    </form>
</body>
</html>
