<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="lessonsettings.aspx.cs" Inherits="lessonsettings" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Lesson Settings</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b><asp:Label ID="lblLessonName" runat="server" /></b></span>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div style="padding-left: 20px; padding-right: 20px; text-align: left">
    <b>Lesson name</b><br />
    <asp:TextBox ID="txtLessonName" runat="server"></asp:TextBox><br />
    <br />
    <b>Lesson speed</b><br />
    <asp:TextBox ID="txtSpeed" runat="server"></asp:TextBox>
    seconds between flashes (You can use fractions of seconds!)<br />
    <br />
    <b>Direction</b><br />
    <asp:RadioButtonList ID="rblDirection" runat="server">
        <asp:ListItem Value="0">Forward</asp:ListItem>
        <asp:ListItem Value="1">Backward</asp:ListItem>
    </asp:RadioButtonList><br />
    <b>Order</b><br />
    <asp:RadioButtonList ID="rblOrder" runat="server">
        <asp:ListItem Value="0">Random</asp:ListItem>
        <asp:ListItem Value="1">In Order</asp:ListItem>
    </asp:RadioButtonList><br />
    <b>Accenting</b><br />
    <asp:RadioButtonList ID="rblAccents" runat="server">
        <asp:ListItem Value="A">Accent marks</asp:ListItem>
        <asp:ListItem Value="H">Highlights</asp:ListItem>
    </asp:RadioButtonList><br />
    <asp:CheckBox ID="chkShowSettings" runat="server" Text="Show the settings menu in the upper left corner" /><br />
    <br />
    <asp:CheckBox ID="chkAccents" runat="server" Text="Use Accents" /><br />
    <br />
    <!--
    <asp:CheckBox ID="chkGloballyShare" runat="server" Text="Share this lesson with everyone" /><br />
    <br />
    -->
    <b>Theme</b><br/ /> <asp:DropDownList ID="ddlTheme" runat="server" Width="200" /><br /><br />
    <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update" />
    &nbsp;&nbsp;
    <asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" /><br />
    <br />
    <br />
    <asp:Button ID="btnEditEntries" runat="server" OnClick="btnEditEntries_Click" Text="Edit entries" /><br />
    </div>
</asp:Content>

