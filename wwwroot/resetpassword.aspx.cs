using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Moa.RussianFlashCards.Data.Dao;

public partial class resetpassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (txtPassword1.Text != txtPassword2.Text)
        {
            lblError.Text = "Passwords don't match";
            return;
        }

        if (txtPassword1.Text.Length < 6)
        {
            lblError.Text = "Password must be at least 6 characters.";
            return;
        }

        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        string verificationGuid = Request.QueryString["reset"];

        if (verificationGuid.Length < 10)
        {
            Response.Write("Invalid verification string.");
            return;
        }

        dao.ResetPassword(verificationGuid, txtPassword1.Text.Trim());

        Response.Redirect("passwordreset.aspx");
    }
}
