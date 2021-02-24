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

public partial class changepassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        if (cookie == null || cookie.Value == null || cookie.Value == "")
            Response.Redirect("login.aspx");

        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(cookie.Value);
        }
        catch (Exception)
        {
            Response.Redirect("login.aspx");
        }

        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        string oldPassword = txtOldPassword.Text.Trim();
        string newPassword1 = txtNewPassword1.Text.Trim();
        string newPassword2 = txtNewPassword2.Text.Trim();

        bool oldPasswordValid = dao.ValidatePassword(userId, oldPassword);

        if (!oldPasswordValid)
        {
            lblError.Text = "You didn't enter your old password correctly.";
            return;
        }

        if (newPassword1 != newPassword2)
        {
            lblError.Text = "Passwords don't match.";
            return;
        }

        if (newPassword1.Length < 6)
        {
            lblError.Text = "Password must be at least 6 characters.";
            return;
        }

        dao.UpdatePassword(userId, newPassword1);

        Response.Redirect("myaccount.aspx");
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("myaccount.aspx");
    }
}
