<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="forgotpassword.aspx.cs" Inherits="forgotpassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Forgot your password?</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Why did you forget your password?</b></span>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Go ahead and enter the email address you used to register.  Then click submit and we'll
send you an email.<br /><br />

Email: <asp:TextBox ID="txtEmail" runat="server" Width="150" /><br /><br />
<asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
</asp:Content>

