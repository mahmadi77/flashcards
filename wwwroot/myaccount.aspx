<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="myaccount.aspx.cs" Inherits="myaccount"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">My Account</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>The settings to your account.</b></span>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<a href="start.aspx">Back</a><br /><br /><br />


<b>My Info</b><br />
<table align="center" cellpadding="5">
<tr><td>Username:</td><td><asp:Label ID="lblUsername" runat="server" /></td><td></td></tr>
<tr><td>Password:</td><td>******</td><td><a href="changepassword.aspx">Change Password</a></td></tr>
</table>

<br /><br />
<b>When I create a new lesson ...</b><br />
<table align="center" cellpadding="5" border="1">
<!--
<tr><td>... it should default to </td><td><asp:Label ID="lblShareLessons" runat="server" /></td><td><asp:LinkButton ID="lbEditShare" runat="server" Text="Change" OnClick="lbEditShare_Click" /></td></tr>
-->
<tr><td>... the settings menu should </td><td><asp:Label ID="lblSettingsMenuShown" runat="server" /></td><td><asp:LinkButton ID="lbEditSettingsMenuShown" runat="server" Text="Change" OnClick="lbEditSettingsMenuShown_Click" /></td></tr>
<tr><td>... the cards should flash every </td><td><asp:TextBox ID="txtSpeed" runat="server" Width="30" /> second(s)</td><td><asp:LinkButton ID="lbEditSpeed" runat="server" Text="Change" OnClick="lbEditSpeed_Click" /></td></tr>
<tr><td>... the cards should flash </td><td><asp:Label ID="lblDirection" runat="server" /></td><td><asp:LinkButton ID="lbEditDirection" runat="server" Text="Change" OnClick="lbEditDirection_Click" /></td></tr>
<tr><td>... the cards should flash </td><td><asp:Label ID="lblInOrder" runat="server" /></td><td><asp:LinkButton ID="lbEditInOrder" runat="server" Text="Change" OnClick="lbEditInOrder_Click" /></td></tr>
<tr><td>... any accenting patterns should </td><td><asp:Label ID="lblAccents" runat="server" /></td><td><asp:LinkButton ID="lbEditAccents" runat="server" Text="Change" OnClick="lbEditAccents_Click" /></td></tr>
<tr><td>... the theme should default to</td><td><asp:DropDownList ID="ddlTheme" runat="server" Width="150" /><td><asp:LinkButton ID="lbEditTheme" runat="server" Text="Change" OnClick="lbEditTheme_Click" /></td></tr>
<tr><td>... the accenting should be marked up as</td><td><asp:DropDownList ID="ddlAccents" runat="server" Width="150" /></td><td><asp:LinkButton ID="lbEditMarkupType" runat="server" Text="Change" OnClick="lbEditMarkupType_Click" /></td></tr>
</table><br />
(You can of course override these settings in each individual lesson.)
<br /><br />
<a href="subscribe.aspx?cd=gen">Subscription Options</a>
</asp:Content>

