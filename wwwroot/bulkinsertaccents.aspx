<%@ Page Title="" Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="bulkinsertaccents.aspx.cs" Inherits="bulkinsertaccents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Bulk Insert (With Accents)</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Make a bunch of cards all at once.  And use accents.</b></span>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<table align="center">
<tr><th>Front</th><th>Front Accent Pattern</th><th>Back</th><th>Back Accent Pattern</th></tr>
<tr>
<td><asp:TextBox ID="txtFront" runat="server" TextMode="MultiLine" Height="300" Width="150" /></td>
<td><asp:TextBox ID="txtFrontAccents" runat="server" TextMode="MultiLine" Height="300" Width="150" /></td>
<td><asp:TextBox ID="txtBack" runat="server" TextMode="MultiLine" Height="300" Width="150" /></td>
<td><asp:TextBox ID="txtBackAccents" runat="server" TextMode="MultiLine" Height="300" Width="150" /></td>
</tr>
</table>
<asp:Button ID="btnInsert" runat="server" Text="Insert" OnClick="btnInsert_Click"/>&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"/>
<br /><br />
<asp:Label ID="lblError" runat="server" CssClass="error" />
</asp:Content>

