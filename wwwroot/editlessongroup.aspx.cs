using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class editlessongroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Validate the query string contains the lesson group id
        if (Request.QueryString["lg"] == null ||
            Request.QueryString["lg"] == "")
            Response.Redirect("mylessongroups.aspx");

        // Validate the query string is an integer
        int lessonGroupId = -1;
        try
        {
            lessonGroupId = int.Parse(Request.QueryString["lg"]);
        }
        catch (Exception)
        {
            Response.Redirect("mylessongroups.aspx");
        }

        // Get the user id from the cookies
        HttpCookie userIdCookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Error handling for null cookie, redirect to login
        if (userIdCookie == null || userIdCookie.Value == null || userIdCookie.Value == "")
            Response.Redirect("login.aspx");

        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(userIdCookie.Value);
        }
        catch (Exception)
        {
            Response.Redirect("login.aspx");
        }

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Validate that the user owns the lesson group
        bool userOwnsLessonGroup = dao.ValidateUserOwnsLessonGroup(userId, lessonGroupId);
        if (!userOwnsLessonGroup)
            Response.Redirect("mylessongroups.aspx");

        // Get the lessons in the lesson group
        DataTable dtLessons = dao.GetLessonGroup(lessonGroupId);

        // Go through all the lessons and add them to the html
        string totalHtml = "";
        foreach (DataRow dr in dtLessons.Rows)
        {
            int lessonId = (int)dr["LessonId"];
            string lessonName = dr["LessonName"].ToString();
            bool isPartOfLessonGroup = (bool)dr["IsPartOfLessonGroup"];

            string elementId = String.Format("cb_lg{0}_l{1}", lessonGroupId, lessonId);
            string lessonHtml = "<div onclick=\"javascript:insertOrDeleteFromLessonGroup('{0}');\" id=\"{1}\" style=\"padding: 10px; width: 500px; vertical-align: middle; text-align: left; background-color: {2}; cursor: pointer;\">{3}<span style=\"visibility: Hidden\">{4}</span></div><br />";
            lessonHtml = String.Format(lessonHtml, elementId, elementId, isPartOfLessonGroup ? "yellow" : "#cccccc", lessonName, isPartOfLessonGroup ? "LessonIsPartOfLessonGroup" : "LessonIsNotPartOfLessonGroup");

            totalHtml += lessonHtml;
        }

        ltlLessons.Text = totalHtml;
        
    }
}
