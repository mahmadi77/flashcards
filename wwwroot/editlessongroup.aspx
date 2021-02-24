<%@ Page Title="" Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="editlessongroup.aspx.cs" Inherits="editlessongroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Lessons in this group</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b><asp:Label ID="lblLessonGroupName" runat="server" /></b></span>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Just click on the ones you want in there.  Unhighlight the ones you don't want.<br />
It's that simple.  Click <a href="mylessongroups.aspx">here</a> when you're done.

<div style="padding: 51px; text-align: center">
<asp:Literal ID="ltlLessons" runat="server" />
</div>
</asp:Content>

