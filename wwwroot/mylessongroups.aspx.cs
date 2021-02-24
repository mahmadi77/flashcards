using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class mylessongroups : System.Web.UI.Page
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

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the LessonGroups
        DataSet dsLessonGroups = dao.GetLessonGroups(userId);
        DataTable dtLessonGroups = dsLessonGroups.Tables[0];
        DataTable dtLessonGroupLessons = dsLessonGroups.Tables[1];

        // No lesson groups, then message and return
        if (dtLessonGroups.Rows.Count == 0)
        {
            ltlLessonGroups.Text = "You don't have any lesson groups yet!";
            return;
        }

        // Put lessons in dictionary
        Dictionary<int, List<string>> lessons = new Dictionary<int,List<string>>();
        foreach (DataRow dr in dtLessonGroupLessons.Rows)
        {
            string lessonName = dr["LessonName"].ToString();
            int lessonGroupId = (int)dr["LessonGroupId"];

            if (!lessons.ContainsKey(lessonGroupId))
                lessons[lessonGroupId] = new List<string>();

            lessons[lessonGroupId].Add(lessonName);
        }

        // Display lesson groups
        string totalHtml = "";
        foreach (DataRow dr in dtLessonGroups.Rows)
        {
            int lessonGroupId = (int)dr["LessonGroupId"];
            string name = dr["Name"].ToString();

            string lessonGroupHtml = String.Format("<b><a href=\"lesson.aspx?lg={0}\" >{1}</a></b><br /><br />", lessonGroupId, name);
            string lessonGroupLessonsHtml = "";
            string editLessonGroup = "<a href=\"editlessongroup.aspx?lg=" + lessonGroupId + "\">Edit</a>";
            string settings = "<a href=\"lessonsettings.aspx?lg=" + lessonGroupId + "\">Settings</a>";
            string delete = "<a href=\"deletelessongroup.aspx?lg=" + lessonGroupId + "\">Delete</a>";
            
            string linksHtml = String.Format("{0} | {1} | {2}", settings, editLessonGroup, delete);

            if (lessons.ContainsKey(lessonGroupId))
            {
                foreach (string s in lessons[lessonGroupId])
                {
                    lessonGroupLessonsHtml += String.Format("<li>{0}</li>", s);
                }

                lessonGroupLessonsHtml = String.Format("<ul style=\"text-align: left;\">{0}</ul>", lessonGroupLessonsHtml);
            }
            else
                lessonGroupLessonsHtml = "No lessons";

            lessonGroupLessonsHtml += "<br /><br />";
            lessonGroupHtml = String.Format(Constants.RoundedBox500, lessonGroupHtml + lessonGroupLessonsHtml + linksHtml);
            totalHtml += lessonGroupHtml;
        }

        ltlLessonGroups.Text = totalHtml;
        
    }
}
