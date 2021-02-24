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

public partial class lessonentries : System.Web.UI.Page
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
            bool reachedMaxPrivateLessons = Request.QueryString["mpl"] != null && Request.QueryString["mpl"] != "";

            if (reachedMaxPrivateLessons)
            {
                lblMessage.Text = "(You reached the maximum number of private lessons allowed per your usage status.  This lesson was created as a public lesson.  If you'd like to increase your number of private lessons, visit the subscription page to upgrade your status.)  ";
                hlSubscribe.Visible = true;
            }
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
                string accentsFront = dr["Accents"].ToString();
                string accentsBack = dr["AccentsBack"].ToString();
                int entryId = (int)dr["LessonEntryId"];
                bool soloed = (bool)dr["Solo"];

                // Remember when you uncomment this to change the font
                // from verdana because it fucks up the accents.

                //if (accentsFront != "" && accentsFront != front)
                //{
                //    string f = "";
                //    for (int i = 0; i < accentsFront.Length; i++)
                //    {
                //        if (front[i] == accentsFront[i])
                //            f += front[i];
                //        else
                //            f += front[i].ToString() + "&#0769;";
                //    }
                //    front = f;
                //}

                //if (accentsBack != "" && accentsBack != back)
                //{
                //    string b = "";
                //    for (int i = 0; i < accentsBack.Length; i++)
                //    {
                //        if (back[i] == accentsBack[i])
                //            b += back[i];
                //        else
                //            b += back[i] + "&#0769;";
                //    }
                //    back = b;
                //}

                string tableRow = "<tr><td style=\"border: 1px solid #cccccc;\">{0}</td><td style=\"border: 1px solid #cccccc;\">{1}</td><td style=\"border: 1px solid #cccccc;\">{2}</td><td style=\"border: 1px solid #cccccc;\">{3}</td><td style=\"border: 1px solid #cccccc;\">{4}</td></tr>";
                tableRow = String.Format(
                    tableRow,
                    String.Format(Constants.RoundedBox200, front),
                    String.Format(Constants.RoundedBox200, back),
                    String.Format("<a href=\"editentry.aspx?lessonid={0}&entryid={1}\"><img src=\"images/edit.gif\" border=\"0\" title=\"Edit\"/></a>", lessonId, entryId),
                    String.Format("<a href=\"deleteentry.aspx?lessonid={0}&entryid={1}\"><img src=\"images/delete.gif\" border=\"0\" title=\"Delete\"/></a>", lessonId, entryId),
                    "<a href=\"#\"><img src=\"images/solo.gif\" border=\"0\" title=\"Show only checked cards during the lesson.\"/></a><input onclick=\"javascript:solo('cb_" + entryId + "');\" id=\"cb_" + entryId + "\" type=\"checkbox\" " + (soloed ? "checked=\"yes\"" : "") + " />"
                    );

                totalHtml += tableRow + "\n";
            }

            if (dt.Rows.Count > 0)
                totalHtml = "<table cellpadding=\"5\"><tr><th>Front</th><th>Back</th><th></th><th></th></tr>" + totalHtml + "</table>";
            
            ltlEntries.Text = totalHtml;
            if (reachedMaxPrivateLessons)
                ltlEntries.Text = "<br /><br />" + ltlEntries.Text;

            hlAddEntry.NavigateUrl = "insertentry.aspx?lessonid=" + lessonId;
            hlReorder.NavigateUrl = "reorderentries.aspx?lessonid=" + lessonId;
            hlBulkInsert.NavigateUrl = "bulkinsert.aspx?lessonid=" + lessonId;
            hlLessonSettings.NavigateUrl = "lessonsettings.aspx?lessonid=" + lessonId;

            hlViewLesson.NavigateUrl = "lesson.aspx?lessonid=" + lessonId;
            // Bind
            gvEntries.DataSource = dt;
            gvEntries.DataBind();
        }



    }

}
