<%@ Page Title="" Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="mylessongroups.aspx.cs" Inherits="mylessongroups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Lesson Groups</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Chain your lessons together to make bigger ones</b></span>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table cellpadding="5">
    <tr valign="top">
    <td width="20%">
    <ul style="list-style-type: square;">
    <li><a href="createlessongroup.aspx">New Lesson Group</a></li>
    <li><a href="mylessons.aspx">My Lessons</a></li>
    <li><a href="start.aspx">My Dashboard</a></li>
    </ul>
    </td>
    <td>
    <asp:Literal ID="ltlLessonGroups" runat="server" />
    </td>
    </tr>
    </table>

</asp:Content>

