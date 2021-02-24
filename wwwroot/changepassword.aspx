<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="changepassword.aspx.cs" Inherits="changepassword"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Change that password</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Change it now</b></span>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table align="center">
<tr><td>Your old password:</td><td><asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password" /></td></tr>
<tr><td>Your new password:</td><td><asp:TextBox ID="txtNewPassword1" runat="server" TextMode="Password" /></td></tr>
<tr><td>Type it again:</td><td><asp:TextBox ID="txtNewPassword2" runat="server" TextMode="Password" /></td></tr>
</table><br />
<asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" /> 
<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" /><br /><br />
<asp:Label ID="lblError" runat="server" CssClass="error" />
</asp:Content>
