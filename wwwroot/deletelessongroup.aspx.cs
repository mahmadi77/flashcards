using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class deletelessongroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
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
            int lessonGroupId = int.Parse(Request.QueryString["lg"]);

            // Create the Dao
            Dao dao = Utilities.NewDao();

            // See whether the user owns the lesson
            bool userOwnsLesson = dao.ValidateUserOwnsLessonGroup(userId, lessonGroupId);

            // 1. If the user doesn't own the lesson
            if (!userOwnsLesson)
            {
                Response.Redirect("mylessongroups.aspx");
            }

            // Get the lesson settings in order to get the name
            DataTable dtSettings = dao.GetLessonGroupSettings(lessonGroupId).Tables[0];
            if (dtSettings.Rows.Count > 0)
            {
                string lessonName = dtSettings.Rows[0]["LessonName"].ToString();
                lblLessonGroupName.Text = lessonName;
            }
        }
    }
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        dao.DeleteLessonGroup(int.Parse(Request.QueryString["lg"]));

        Response.Redirect("mylessongroups.aspx");
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("mylessongroups.aspx");
    }
}
