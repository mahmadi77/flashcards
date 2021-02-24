<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="mylessons.aspx.cs" Inherits="mylessons" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">My Lessons</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Here are the lessons you created</b></span>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table cellpadding="5">
    <tr valign="top">
    <td width="15%">
    - <a href="createlesson.aspx">New lesson</a><br /><br />
    - <a href="start.aspx">My Dashboard</a><br /><br />
    </td>
    <td>
<%--    <asp:GridView ID="gvLessons" runat="server" BorderColor="White" BackColor="#555555" BorderStyle="Solid" CellPadding="5" AutoGenerateColumns="False">
        <HeaderStyle BackColor="#333333" />
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="LessonId" DataNavigateUrlFormatString="lesson.aspx?lessonid={0}"
                DataTextField="LessonName" NavigateUrl="~/lesson.aspx" HeaderText="Click on the lesson to view it" />
            <asp:BoundField DataField="Username" HeaderText="Created By" />
            <asp:HyperLinkField DataNavigateUrlFields="LessonId" DataNavigateUrlFormatString="lessonsettings.aspx?lessonid={0}"
                 NavigateUrl="~/lessonsettings.aspx" Text="Edit Lesson" />
            <asp:HyperLinkField DataNavigateUrlFields="LessonId" DataNavigateUrlFormatString="lessonentries.aspx?lessonid={0}"
                 NavigateUrl="~/lessonentries.aspx" Text="Edit Entries" />
            <asp:TemplateField>
            <ItemTemplate >
            <asp:HyperLink ID="hlDelete" runat="server" Text="Delete" NavigateUrl='<%# "deletelesson.aspx?lessonid=" + Eval("LessonId")%>' />
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>--%>
    
    <asp:Literal ID="ltlLessons" runat="server" />
    <asp:Label ID="lblMessage" runat="server"></asp:Label><br />
    </td>
    </tr>
    </table>
    
    
    

    
</asp:Content>

