<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="resetpassword.aspx.cs" Inherits="resetpassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Reset your password</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Man, you're such a pain</b></span>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Enter a new password:<br />
Enter it once: <asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" /><br />
Enter it again: <asp:TextBox ID="txtPassword2" runat="server" TextMode="Password" /><br /><br />
<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" /><br /><br />
<asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
</asp:Content>

