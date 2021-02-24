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

public partial class reorderentries : System.Web.UI.Page
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
        // TODO: Handle bad lesson id
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // 1. Make sure the lesson belongs to the user
        //    If not see if they want to make a copy to edit
        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // See whether the user owns the lesson
        bool userOwnsLesson = dao.ValidateUserOwnsLesson(userId, lessonId);

        // 1. If the user doesn't own the lesson
        if (!userOwnsLesson)
        {
            Response.Redirect("userdoesntown.aspx?lessonid=" + lessonId);
        }
        else
        {

            hlCancel.NavigateUrl = "lessonentries.aspx?lessonid=" + lessonId;
            
            // Get the lesson entries
            DataTable dt = dao.GetLessonEntries(lessonId);


            string totalHtml = "";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string front = dt.Rows[i]["Entry"].ToString();
                string back = dt.Rows[i]["Translation"].ToString();
                string accents = dt.Rows[i]["Accents"].ToString();
                int entryId = (int)dt.Rows[i]["LessonEntryId"];

                string li = "<li id=\"item_" + entryId + "\">{0}</li>";
                li = String.Format(li, String.Format("<div style=\"padding: 10px; width: 500px; vertical-align: middle; text-align: left; background-color: #cccccc;\">{0}</div><br />", front));

                totalHtml += li + "\n";
            }

            if (dt.Rows.Count > 0)
            {
                totalHtml = "<ul id=\"sortablecards\" style=\"list-style-type: none;\">" + totalHtml + "</ul>";
                totalHtml +=
                    "\n<script type=\"text/javascript\">\n" +
                    "Sortable.create(\"sortablecards\", {constraint:'vertical'});\n" + 
                    "</script>\n";
            }

            ltlEntries.Text = totalHtml;


            
        }
    }
    protected void lbReorder_Click(object sender, EventArgs e)
    {
        //this.Page.Form.Controls;
        //Console.WriteLine();
    }
}
