<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSubscribe.master" AutoEventWireup="true" CodeFile="subscribe.aspx.cs" Inherits="subscribe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <span class="font1"><asp:Label ID="lblSubscription" runat="server" /></span>
    <br /><br />
    <span class="font1" style="font-size: 12px;"><b><asp:Label ID="lblMessage" runat="server" /></b></span>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="lblCompleteMessage" runat="server" />
    <br /><br />
    <asp:Literal ID="ltlUsageDescriptions" runat="server" />
    
    <asp:Literal ID="ltlUserStatistics" runat= "server" />
    
</asp:Content>

