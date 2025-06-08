<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kayitol.aspx.cs" Inherits="DiorWeb.kayitol" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Kayıt Ol</title>
    <style>
        .register-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .register-container h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .register-container input[type="text"],
        .register-container input[type="password"],
        .register-container input[type="email"] {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        .register-container input[type="submit"] {
            background-color: #222;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .register-container input[type="submit"]:hover {
            background-color: #444;
        }

        .message {
            margin-top: 10px;
            color: green;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <h2>Kayıt Ol</h2>
            <asp:TextBox ID="txtIsim" runat="server" placeholder="İsim"></asp:TextBox><br />
            <asp:TextBox ID="txtSoyisim" runat="server" placeholder="Soyisim"></asp:TextBox><br />
            <asp:TextBox ID="txtMail" runat="server" TextMode="Email" placeholder="E-posta"></asp:TextBox><br />
            <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" placeholder="Şifre"></asp:TextBox><br />
            <asp:Button ID="btnKayitOl" runat="server" Text="Kayıt Ol" OnClick="btnKayitOl_Click" /><br />
            <asp:Label ID="lblMesaj" runat="server" CssClass="message" />
        </div>
    </form>
</body>
</html>
