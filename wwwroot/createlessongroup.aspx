<%@ Page Title="" Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="createlessongroup.aspx.cs" Inherits="createlessongroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">New Lesson Group</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Jam those lessons together, baby.</b></span>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Give your lesson group a name:<br />
    <asp:TextBox ID="txtLessonGroupName" runat="server"></asp:TextBox><br />
    <br />
    <asp:Button ID="btnCreate" runat="server" Text="Create" Width="50" 
        onclick="btnCreate_Click"/>
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" Width="50" 
        onclick="btnCancel_Click"/>
    <br />
<br />

<a href="mylessongroups.aspx">My Lesson Groups</a><br />
<a href="mylessons.aspx">My Lessons</a><br />
<a href="start.aspx">My Dashboard</a>
</asp:Content>

