<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="register" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Register</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>If you register you can do more stuff</b></span>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<table align="center">
<tr><td>Email address:</td><td>
    <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td></tr>
<tr><td>Enter email again:</td><td>
    <asp:TextBox ID="txtEmailVerify" runat="server"></asp:TextBox></td></tr>
<tr><td>Enter a password:</td><td>
    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox></td></tr>
<tr><td>Enter password again:</td><td>
    <asp:TextBox ID="txtPasswordVerify" runat="server" TextMode="Password"></asp:TextBox></td></tr>
<tr><td>Enter a username:</td><td>
    <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox></td></tr>    
</table>
    <asp:Button ID="btnRegister" runat="server" OnClick="btnRegister_Click" Text="Register" /><br />
    <br />
    <span class="error">
    <asp:Label ID="lblError" runat="server" Text="Label" Visible="False"></asp:Label>
    </span>



</asp:Content>


