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

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        // Get the login info
        string usernameOrEmail = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        // Validate it
        int userId = ValidateLoginInfo(usernameOrEmail, password);

        // If the login info is valid
        if (userId != -1)
        {
            // Give the response cookies
            Response.Cookies[Constants.CookieKeys.UserIsLoggedIn].Value = Common.LoggedInGuid;
            //int seconds = int.Parse(ConfigurationManager.AppSettings["CookieExpiration"]);
            DateTime now = DateTime.Now;
            Response.Cookies[Constants.CookieKeys.UserIsLoggedIn].Expires = now.AddYears(1);
            Response.Cookies[Constants.CookieKeys.UserId].Value = Common.UserIdGuid + userId.ToString();
            Response.Cookies[Constants.CookieKeys.UserId].Expires = now.AddYears(1);
            Response.Cookies[Constants.CookieKeys.UserName].Value = usernameOrEmail;
            Response.Cookies[Constants.CookieKeys.UserName].Expires = now.AddYears(1);

            // If they came from somewhere
            object redirect = Session["Redirect"];
            if (redirect != null)
                Response.Redirect(redirect.ToString());
            
            // Redirect to the main page
            Response.Redirect("start.aspx");
        }

        // Otherwise show invalid login message and register link
        lblError.Visible = true;
        txtUsername.Text = "";
        txtPassword.Text = "";
    }

    private int ValidateLoginInfo(string usernameOrEmail, string password)
    {
        // Create the Dao
        Dao dao = Utilities.NewDao();
        
        // Get the user id (returns -1 if not found)
        int userId = dao.ValidateUserInfo(usernameOrEmail, password);

        // Return the user id
        return userId;
    }
}
