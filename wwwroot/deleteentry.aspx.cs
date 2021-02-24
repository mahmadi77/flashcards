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

public partial class deleteentry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
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

        // Get the lesson id from the query string
        // TODO: Handle bad lesson entry id
        int lessonEntryId = int.Parse(Request.QueryString["entryid"]);
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // Create the Dao
        Dao dao = Utilities.NewDao();

        // See whether the user owns the lesson
        bool userOwnsLesson = dao.ValidateUserOwnsLesson(userId, lessonId);

        // 1. If the user doesn't own the lesson
        if (!userOwnsLesson)
        {
            Response.Redirect("mylessons.aspx");
        }

        // Delete the lesson
        dao.DeleteLessonEntry(lessonEntryId);



        // Redirect to lessonentries.aspx
        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
}
