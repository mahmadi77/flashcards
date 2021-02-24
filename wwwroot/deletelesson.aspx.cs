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

public partial class deletelesson : System.Web.UI.Page
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
            int lessonId = int.Parse(Request.QueryString["lessonid"]);

            // Create the Dao
            Dao dao = Utilities.NewDao();

            // See whether the user owns the lesson
            bool userOwnsLesson = dao.ValidateUserOwnsLesson(userId, lessonId);

            // 1. If the user doesn't own the lesson
            if (!userOwnsLesson)
            {
                // Try to just remove it from userlessons
                dao.DeleteUserLesson(lessonId, userId);
                
                Response.Redirect("mylessons.aspx");
            }

            // Get the lesson settings in order to get the name
            DataTable dtSettings = dao.GetLessonSettings(lessonId).Tables[0];
            if (dtSettings.Rows.Count > 0)
            {
                string lessonName = dtSettings.Rows[0]["LessonName"].ToString();
                lblLessonName.Text = lessonName;
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("mylessons.aspx");
    }
    
    
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        dao.DeleteLesson(int.Parse(Request.QueryString["lessonid"]));

        Response.Redirect("mylessons.aspx");
    }
}
