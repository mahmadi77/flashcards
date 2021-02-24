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

public partial class createlesson : System.Web.UI.Page
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
            Session["Redirect"] = "createlesson.aspx";
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

        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);
        DataTable dtStatus = dao.GetUsageStatus(userId);
        UsageStatus us = UsageStatus.MapUsageStatus(dtStatus.Rows[0]);

        if (us.CurrentNumLessons + 1 > us.MaxLessons)
        {
            if (us.Code == "R")
                Response.Redirect("subscribe.aspx?cd=mlr");
            else
                Response.Redirect("subscribe.aspx?cd=mls");
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
        int lessonId = dao.InsertLesson(txtLessonName.Text.Trim(), userId);

        //bool reachedMaxPrivateLessons = dao.ReachedMaxPrivateLessons(userId);

        //if (reachedMaxPrivateLessons)
        //    Response.Redirect("lessonentries.aspx?lessonid=" + lessonId + "&mpl=true");
        //else
        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("mylessons.aspx");
    }
}
