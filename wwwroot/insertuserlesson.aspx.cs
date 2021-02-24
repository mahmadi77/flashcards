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

public partial class insertuserlesson : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        if (cookie == null || cookie.Value == null || cookie.Value == "")
        {
            Session["Redirect"] = "insertuserlesson.aspx?lessonid=" + Request.QueryString["lessonid"];
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

        // Get the lesson id from the query string
        // TODO: Handle bad lesson id
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Insert the lesson
        dao.InsertUserLesson(userId, lessonId);

        // Redirect to mylessons.aspx
        Response.Redirect("mylessons.aspx");
    }
}
