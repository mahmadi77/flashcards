<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="createlesson.aspx.cs" Inherits="createlesson" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Create your lesson</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>You're making a new lesson</b></span>

</asp:Content>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    Give your lesson a name:<br />
    <asp:TextBox ID="txtLessonName" runat="server"></asp:TextBox><br />
    <br />
    <asp:Button ID="btnCreate" runat="server" OnClick="btnCreate_Click" Text="Create" Width="50"/>
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Width="50"/>
<br />
<br />
<a href="mylessons.aspx">My Lessons</a><br />
<a href="start.aspx">Dashboard</a>
<br />
<br />

</asp:Content>

