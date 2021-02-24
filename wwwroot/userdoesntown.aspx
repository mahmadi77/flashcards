<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="userdoesntown.aspx.cs" Inherits="userdoesntown" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="lblMessage" runat="server" Text="You're not the owner of this lesson.  Would you like to make a copy that you can edit?"
        ></asp:Label><br /><br />
    <asp:LinkButton ID="lbCreateCopy" runat="server" OnClick="lbCreateCopy_Click">Yes, create a copy</asp:LinkButton><br />
    <asp:LinkButton ID="lbMyLessons" runat="server" PostBackUrl="~/mylessons.aspx">No, take me back to my lessons</asp:LinkButton><br />
    <br />
</asp:Content>

