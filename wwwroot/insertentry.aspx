<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="insertentry.aspx.cs" Inherits="insertentry"  ValidateRequest="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <asp:Button ID="btnInsertEntry" runat="server" Text="Add Entry" OnClick="btnInsertEntry_Click"/>
    
    <asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click"
        Text="Cancel" Width="85px" /><br />
    <br />
    <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
    
    <div style="background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px;">
    <br />
    Front<br />
    <asp:TextBox ID="txtFront" runat="server" Width="500"></asp:TextBox><br />
    <br />
    Back<br />
    <asp:TextBox ID="txtBack" runat="server" Width="500"></asp:TextBox><br />
    <br />
    </div><br /><br />
    
    
    <div style="background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px; font-size: 10px; text-align: left;">
    * Note: If you want to put an accent mark over a character, just type a ^ symbol right after the character
    or characters that you wish to accent.  For example, fanta^stic = fanta&#0769;stic.  The accents will show up
    during the lesson, but not when viewing the entries page.
    </div>
    
<%--    <a href="#" id="useAccents" onclick="javascript:if (getElementById('useAccents').innerHTML == 'Create accent pattern'){ getElementById('accents').style.visibility = 'visible'; getElementById('useAccents').innerHTML='Hide'; } else{ getElementById('accents').style.visibility = 'hidden'; getElementById('useAccents').innerHTML='Create accent pattern'; }" style="cursor: pointer;">Create accent pattern</a>
    <div id="accents" style="visibility: hidden; background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px;">
    <br />
    Accents Front<br />
    <asp:TextBox ID="txtAccents" runat="server" Width="500"></asp:TextBox><br />
    <br />
    Accents Back<br />
    <asp:TextBox ID="txtAccentsBack" runat="server" Width="500"></asp:TextBox><br />
    <br />
    </div>--%>
    <br /><br />

</asp:Content>

