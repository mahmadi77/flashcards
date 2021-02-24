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

public partial class viewentries : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of no check on lesson id pages
        if (!Common.PagesUserNotRequiredToOwnLesson.Contains(this.Page.ToString()))
            Common.PagesUserNotRequiredToOwnLesson.Add(this.Page.ToString());

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
        
        // Get the lesson entries
        DataTable dt = dao.GetLessonEntries(lessonId);


        // Get the lesson settings in order to get the name
        DataTable dtSettings = dao.GetLessonSettings(lessonId).Tables[0];
        if (dtSettings.Rows.Count > 0)
        {
            string lessonName = dtSettings.Rows[0]["LessonName"].ToString();
            lblLessonName.Text = lessonName;
        }

        string totalHtml = "";

        foreach (DataRow dr in dt.Rows)
        {
            string front = dr["Entry"].ToString();
            string back = dr["Translation"].ToString();
            string accents = dr["Accents"].ToString();
            int entryId = (int)dr["LessonEntryId"];

            string tableRow = "<tr><td style=\"border: 1px solid #cccccc;\">{0}</td><td style=\"border: 1px solid #cccccc;\">{1}</td></tr>";
            tableRow = String.Format(
                tableRow,
                String.Format(Constants.RoundedBox200, front),
                String.Format(Constants.RoundedBox200, back)
                );

            totalHtml += tableRow + "\n";
        }

        if (dt.Rows.Count > 0)
            totalHtml = "<table cellpadding=\"5\"><tr><th>Front</th><th>Back</th><th></th><th></th></tr>" + totalHtml + "</table>";

        ltlEntries.Text = totalHtml;


        hlViewLesson.NavigateUrl = "lesson.aspx?lessonid=" + lessonId;

       
    }

    protected void lbCopyLesson_Click(object sender, EventArgs e)
    {
        Response.Redirect("copylesson.aspx?lessonid=" + Request.QueryString["lessonid"]);
    }
}
