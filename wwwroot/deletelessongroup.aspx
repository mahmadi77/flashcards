<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="deletelessongroup.aspx.cs" Inherits="deletelessongroup"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

Lesson Group: <asp:Label ID="lblLessonGroupName" runat="server" /><br /><br />
Are you sure you want to delete this lesson group?&nbsp;<br /><br />
    <asp:Button ID="btnDelete" runat="server" Text="Delete" Width="50" 
        onclick="btnDelete_Click"/>

<asp:Button ID="btnCancel" runat="server" Text="Cancel" Width="50" 
        onclick="btnCancel_Click"/>
</asp:Content>

