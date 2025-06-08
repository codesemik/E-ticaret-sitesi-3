<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="siparislerim.aspx.cs" Inherits="DiorWeb.siparislerim" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <title>Siparişlerim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .siparis-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            background: #fff;
        }
        .siparis-baslik {
            font-weight: 600;
            margin-bottom: 10px;
        }
        .siparis-detay {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container mt-5" style="max-width: 900px;">
    <h3>Siparişlerim</h3>
    <asp:Label ID="lblMesaj" runat="server" ForeColor="red"></asp:Label>

    <asp:DataList ID="dlSiparisler" runat="server" RepeatDirection="Vertical" ItemStyle-CssClass="siparis-card" OnItemCommand="dlSiparisler_ItemCommand">
        <ItemTemplate>
            <div class="siparis-baslik">Sipariş ID: <%# Eval("siparisID") %></div>
            <div class="siparis-detay"><strong>Tarih:</strong> <%# Eval("SiparisTarihi", "{0:dd.MM.yyyy}") %></div>
            <div class="siparis-detay"><strong>Durum:</strong> <%# Eval("Durum") %></div>
            <div class="siparis-detay"><strong>Toplam Tutar:</strong> <%# Eval("ToplamFiyat", "{0:C}") %></div>
            <asp:Button ID="btnDetay" runat="server" Text="Detayları Göster" CommandName="Detay" CommandArgument='<%# Eval("siparisID") %>' CssClass="btn btn-primary btn-sm" />
        </ItemTemplate>
    </asp:DataList>

    <asp:Panel ID="pnlDetaylar" runat="server" Visible="false" CssClass="mt-4">
        <h4>Sipariş Detayları</h4>
        <asp:Label ID="lblDetayMesaj" runat="server" ForeColor="red"></asp:Label>
        <asp:GridView ID="gvSiparisDetay" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="urunAdi" HeaderText="Ürün Adı" />
                <asp:BoundField DataField="adet" HeaderText="Miktar" />
                <asp:BoundField DataField="fiyat" HeaderText="Fiyat" DataFormatString="{0:C}" />

                <asp:TemplateField HeaderText="Görsel">
                    <ItemTemplate>
                        <img src='<%# ResolveUrl("~/images/" + Eval("foto")) %>' alt="Ürün" style="width: 100px; height: auto;" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

    </asp:Panel>
</form>

</body>
</html>
