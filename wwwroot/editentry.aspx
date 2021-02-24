<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" ValidateRequest="false" CodeFile="editentry.aspx.cs" Inherits="editentry"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <asp:Button ID="btnUpdateEntry" runat="server" Text="Update Entry" OnClick="btnUpdateEntry_Click" />
    <asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel"
        Width="110px" /><br />
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
    
    
<%--    <a href="#" id="useAccents" onclick="javascript:var x = document.getElementsByTagName('div'); var y; for (i = 0; i < x.length; i++) { if (x[i].id.indexOf('accentsDiv') > -1) y = x[i].id; } if (getElementById('useAccents').innerHTML == 'Create accent pattern'){ getElementById(y).style.visibility = 'visible'; getElementById('useAccents').innerHTML='Hide'; } else{ getElementById(y).style.visibility = 'hidden'; getElementById('useAccents').innerHTML='Create accent pattern'; }" style="cursor: pointer;"><asp:Literal ID="ltlAccents" runat="server" /></a>
    
    <div runat="server" id="accentsDiv" style="background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px;">
    <br />
    Accents Front<br />
    <asp:TextBox ID="txtAccents" runat="server" Width="500"></asp:TextBox><br />
    <br />
    Accents Back<br />
    <asp:TextBox ID="txtAccentsBack" runat="server" Width="500"></asp:TextBox><br />
    <br />
    </div>--%>

</asp:Content>

