<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="reorderentries.aspx.cs" Inherits="reorderentries"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
  <span class="font1">Reorder your cards</span>
  <br /><br />
  <span class="font1" style="font-size: 12px;"><b>Drag them</b></span>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <b>Click <a style="cursor: pointer;" onclick="updateOrder();"><u>here</u></a> when you're done.</b>
  <br />
  <br />
  <asp:HyperLink ID="hlCancel" runat="server" Text="Cancel" />
  <br />
  <br />
  <asp:Literal ID="ltlEntries" runat="server" />
  <asp:TextBox ID="txtSortableCards" runat="server" Visible="false" />
</asp:Content>

