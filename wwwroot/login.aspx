<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Login</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Log in to get to your own page</b></span></div>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<table align="center">
<tr><td>Username or email:</td><td>
    <asp:TextBox ID="txtUsername" runat="server" Width="150"></asp:TextBox></td></tr>
<tr><td>Password:</td><td>
    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="150"></asp:TextBox></td></tr>
</table>
    <asp:Button ID="btnLogin" runat="server" OnClick="btnLogin_Click" Text="Log In" /><br />
    <br />
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Text="Sorry, that login information is invalid.  If you have not registered please do so now.<br /><br />"
        Visible="False"></asp:Label>
    New user? <a href="register.aspx">Register</a> (It's free!)<br /><br />
    <a href="forgotpassword.aspx">Forgot your password?</a>
    <br />
</asp:Content>

