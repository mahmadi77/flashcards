<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="deletelesson.aspx.cs" Inherits="deletelesson"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

Lesson: <asp:Label ID="lblLessonName" runat="server" /><br /><br />
Are you sure you want to delete this lesson?&nbsp;<br /><br />
    <asp:Button ID="btnDelete" runat="server" OnClick="btnDelete_Click" Text="Delete" Width="50"/>

<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Width="50"/>
</asp:Content>

