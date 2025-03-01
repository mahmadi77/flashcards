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

using System.Collections.Generic;

using Moa.RussianFlashCards.Data.Dao;

public partial class MasterPage : System.Web.UI.MasterPage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        // Set the year
        lblCopyrightYear.Text = DateTime.Today.Year.ToString();
        
        // Get the host name to set the homepage link correctly
        string hostname = Request.ServerVariables["HTTP_HOST"];

        lblHomepageLink.Text = "Home";

        if (hostname.ToLower().Contains("карточки"))
            lblHomepageLink.Text = "ФК";

        if (hostname.ToLower().Contains("kardz"))
            lblHomepageLink.Text = "Home";
        
        // Don't check for cookies if we're on a public page
        if (!Common.PublicPages.Contains(this.Page.ToString()))
        {
            // Get the login cookie
            HttpCookie userIsLoggedIn = Request.Cookies[Constants.CookieKeys.UserIsLoggedIn];

            // If no cookie, redirect
            if (userIsLoggedIn == null || userIsLoggedIn.Value == null)
                Response.Redirect("login.aspx");

            // If cookie value is not correct, redirect
            if (userIsLoggedIn.Value.ToLower() != Common.LoggedInGuid)
                Response.Redirect("login.aspx");
        }

        // Verify that the user owns the lesson if the lessonid query string key isn't null
        if (Request.QueryString["lessonid"] != null)
        {
            // Get the cookie
            HttpCookie userIdCookie = Request.Cookies[Constants.CookieKeys.UserId];

            // If no or bad cookie, redirect
            if (userIdCookie == null || userIdCookie.Value == null || userIdCookie.Value == "")
                Response.Redirect("login.aspx");

            // Get the userid
            int userId = -1;

            try
            {
                userId = Utilities.GetUserId(userIdCookie.Value);
            }
            catch (Exception)
            {
                Response.Redirect("login.aspx");
            }

            // TODO: Handle bad lessonid
            int lessonId = int.Parse(Request.QueryString["lessonid"]);

            // Create the Dao
            Dao dao = Utilities.NewDao();

            // Validate that the user owns the lesson
            if (!Common.PagesUserNotRequiredToOwnLesson.Contains(this.Page.ToString()) &&
                !dao.ValidateUserOwnsLesson(userId, lessonId) &&
                !this.Page.ToString().Contains("userdoesntown"))
                Response.Redirect("start.aspx");
        }

        // But now check for cookies to see if logged in
        HttpCookie loggedInCookie = Request.Cookies[Constants.CookieKeys.UserIsLoggedIn];

        if (loggedInCookie == null || loggedInCookie.Value == null || loggedInCookie.Value == "")
        {
            lblLoggedIn.Text = "";
            lbLogIn.Text = "Log In";
        }
        else
        {
            HttpCookie userNameCookie = Request.Cookies[Constants.CookieKeys.UserName];

            if (userNameCookie == null || userNameCookie.Value == null || userNameCookie.Value == "")
            {
                lblLoggedIn.Text = "Logged In  |  ";
                lbLogIn.Text = "Log Out";
            }
            else
            {
                lblLoggedIn.Text = "Logged in as " + userNameCookie.Value + "  |  ";
                lbLogIn.Text = "Log Out";
            }
        }
    }
    protected void lbLogIn_Click(object sender, EventArgs e)
    {
        if (lbLogIn.Text.ToLower() == "log out")
        {
            Response.Cookies[Constants.CookieKeys.UserIsLoggedIn].Value = "";
            Response.Redirect("Default.aspx");
        }
        if (lbLogIn.Text.ToLower() == "log in")
        {
            Response.Redirect("login.aspx");
        }
    }
}
