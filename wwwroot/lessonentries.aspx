<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="lessonentries.aspx.cs" Inherits="lessonentries" %>

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
    <li><asp:HyperLink ID="hlAddEntry" runat="server" Text="Add entry" /></li>
    <li><asp:HyperLink ID="hlReorder" runat="server" Text="Reorder cards" /></li>
    <li><asp:HyperLink ID="hlBulkInsert" runat="server" Text="Add multiple entries at once" /></li>
    <li style="list-style-type: none;"><hr /></li>
    <li><asp:HyperLink ID="hlViewLesson" runat="server" Text="View lesson" /></li>
    <li><asp:HyperLink ID="hlLessonSettings" runat="server" Text="Lesson settings" /></li>
    <li style="list-style-type: none;"><hr /></li>
    <li><a href="mylessons.aspx">My Lessons</a></li>
    <li><a href="start.aspx">My Dashboard</a></li>
    <!--
    <li><a href="publiclessons.aspx">Public Lessons</a></li>
    -->
    </ul>
    </td>
    <td>
    <!--
    <asp:GridView ID="gvEntries" runat="server" BorderColor="White" BackColor="#555555" BorderStyle="Solid" CellPadding="5" AutoGenerateColumns="False">
        <HeaderStyle BackColor="#333333" />
        <Columns>
            <asp:BoundField DataField="LessonEntryId" Visible="False" />
            <asp:BoundField DataField="Entry" HeaderText="Front" />
            <asp:BoundField DataField="Translation" HeaderText="Back" />
            <asp:BoundField DataField="Accents" HeaderText="Accent Pattern" />
            <asp:TemplateField>
            <ItemTemplate>
            <asp:HyperLink ID="hlEdit" runat="server" Text="Edit" NavigateUrl='<%# "editentry.aspx?lessonid=" + Eval("LessonId") + "&entryid=" + Eval("LessonEntryId")%>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
            <ItemTemplate>
            <asp:HyperLink ID="hlDelete" runat="server" Text="Delete" NavigateUrl='<%# "deleteentry.aspx?lessonid=" + Eval("LessonId") + "&entryid=" + Eval("LessonEntryId")%>' />
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView><br />
    -->
    <asp:Label ID="lblMessage" runat="server" CssClass="error" />
    <asp:HyperLink ID="hlSubscribe" runat="server" Visible="false" Text="Click here to visit the subscription page." NavigateUrl="~/subscribe.aspx" />
    <asp:Literal ID="ltlEntries" runat="server" />
    </td>
    </tr>
    </table>

</asp:Content>

