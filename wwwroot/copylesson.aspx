<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="copylesson.aspx.cs" Inherits="copylesson"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<asp:Label ID="lblMessage" runat="server" Text="This is your own lesson.  Do you still want to make a copy?" /><br /><br />
<asp:Button ID="btnYes" runat="server" Text="Yes" Width="75" OnClick="btnYes_Click"/>
<asp:Button ID="btnNo" runat="server" Text="No" Width="75" OnClick="btnNo_Click"/>
</asp:Content>

