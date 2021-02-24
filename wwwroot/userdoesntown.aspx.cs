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

public partial class userdoesntown : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void lbCreateCopy_Click(object sender, EventArgs e)
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
        // TODO: Handle bad lesson id
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // Create the dao
        Dao dao = Utilities.NewDao();

        // Copy the lesson
        dao.CopyLesson(userId, lessonId);

        // Go back to my lessons
        // TODO: Handle failed copy
        Response.Redirect("mylessons.aspx");
    }
}
