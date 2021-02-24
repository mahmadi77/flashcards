<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="lessons.aspx.cs" Inherits="lessons" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Demo Lessons</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Get an idea of what you can do</b></span>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="text-align: left; padding-left: 20px; padding-right: 20px;">
    Take a look and see how versatile these suckers are.
    Then <a href="register.aspx">register</a> in order to
    make your own
    lessons from scratch and to see lessons
    from other users.  It's <i>free</i> to register!</div>

    <br />
    
    <asp:Literal ID="ltlRoundedBoxes" runat="server" />
    
    <br />
    
    <a href="createlesson.aspx">Make my own lesson!</a><br />
</asp:Content>

