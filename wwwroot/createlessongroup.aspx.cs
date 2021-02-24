using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class createlessongroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        // We handle the login logic here instead of letting the master page take care of it
        // because this way we can add the redirect key and value to the session.
        if (cookie == null || cookie.Value == null || cookie.Value == "")
        {
            Session["Redirect"] = "createlessongroup.aspx";
            Response.Redirect("login.aspx");
        }

        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(cookie.Value);
        }
        catch (Exception)
        {
            Response.Redirect("login.aspx");
        }

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);
        
        // Get the usage status of the user from the db
        DataTable dtStatus = dao.GetUsageStatus(userId);
        
        // Create the usage status object
        UsageStatus us = UsageStatus.MapUsageStatus(dtStatus.Rows[0]);

        // Determine if they can make another lesson group
        if (us.CurrentNumLessonGroups + 1 > us.MaxLessonGroups)
        {
            // If they haven't subscribed
            // mlgns = max lesson group registered
            if (us.Code == "R")
                Response.Redirect("subscribe.aspx?cd=mlgr");

            // If they have subscribed
            // mlgs = max lesson group subscription
            else
                Response.Redirect("subscribe.aspx?cd=mlgs");
        }
    }
    protected void btnCreate_Click(object sender, EventArgs e)
    {
        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        if (cookie == null || cookie.Value == null || cookie.Value == "")
        {
            Session["Redirect"] = "createlesson.aspx";
            Response.Redirect("login.aspx");
        }

        // Get the user id
        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(cookie.Value);
        }
        catch (Exception)
        {
            Response.Redirect("login.aspx");
        }

        // TODO: Validate that the user entered a valid name for the lesson.

        // Insert the lesson
        int lessonGroupId = dao.InsertLessonGroup(txtLessonGroupName.Text.Trim(), userId);

        Response.Redirect("mylessongroups.aspx");
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("mylessongroups.aspx");
    }
}
