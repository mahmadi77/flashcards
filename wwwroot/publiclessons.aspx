<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="publiclessons.aspx.cs" Inherits="publiclessons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Public Lessons</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Here's what everyone else is doing</b></span>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table cellpadding="5">
    <tr valign="top">
    <td width="15%">
    
    - <a href="createlesson.aspx">New Lesson</a><br /><br />
    - <a href="start.aspx">My Dashboard</a><br /><br />
    - <a href="mylessons.aspx">My Lessons</a><br /><br />
    
    <asp:TextBox ID="txtSearch" runat="server" Width="100" /><br />
    <asp:ImageButton ID="ibSearch" runat="server" ImageUrl="images/search.bmp" OnClick="ibSearch_Click" /><br />
    <asp:LinkButton ID="lbClear" runat="server" Text="Clear" OnClick="lbClear_Click" /><br />
    <asp:Label ID="lblSearchError" runat="server" CssClass="error"/>
    
    </td>
    <td>
    <asp:Literal ID="ltlLessons" runat="server" />
    </td>
    </tr>
    </table>
</asp:Content>

