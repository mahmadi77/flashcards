<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="viewentries.aspx.cs" Inherits="viewentries" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Entries in this lesson</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b><asp:Label ID="lblLessonName" runat="server" /></b></span>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <table cellpadding="5">
    <tr valign="top">
    <td width="20%">
    <ul style="list-style-type: square;">
    <li><asp:LinkButton ID="lbCopyLesson" runat="server" Text="Create editable copy" OnClick="lbCopyLesson_Click" /></li>
    <li><asp:HyperLink ID="hlViewLesson" runat="server" Text="View lesson" /></li>
    <li style="list-style-type: none;"><hr /></li>
    <li><a href="mylessons.aspx">My Lessons</a></li><li><a href="start.aspx">My Dashboard</a></li><li><a href="publiclessons.aspx">Public Lessons</a></li></ul>
    </td>
    <td>
    <asp:Literal ID="ltlEntries" runat="server" />
    </td>
    </tr>
    </table>

</asp:Content>

