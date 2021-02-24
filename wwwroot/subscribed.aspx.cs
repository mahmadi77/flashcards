using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Configuration;
using Moa.RussianFlashCards.Data.Dao;

public partial class subscribed : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sub = Request.QueryString["sub"];

        string usageStatusCode = "R";

        if (sub == "bsc")
            usageStatusCode = "S1";
        if (sub == "enh")
            usageStatusCode = "S2";
        if (sub == "del")
            usageStatusCode = "S3";

        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        if (cookie == null || cookie.Value == null || cookie.Value == "")
        {
            Response.Redirect("login.aspx");
            Session["Redirect"] = "subscribed.aspx?sub=" + sub;
        }

        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(cookie.Value);
        }
        catch (Exception)
        {
            Session["Redirect"] = "subscribed.aspx?sub=" + sub;
            Response.Redirect("login.aspx");
        }

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        dao.InsertSubscriptionHistory(userId, DateTime.Now, usageStatusCode);

        Response.Redirect("subscribe.aspx?cd=sbs");
    }
}