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
using System.Collections.Generic;

using Moa.RussianFlashCards.Data.Dao;

public partial class mylessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Create the dao object
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

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

        // Get the lessons from the db
        DataSet ds = dao.GetMyLessons(userId);

        // The first table is the list of top three entries per lesson
        DataTable dtLessonEntries = ds.Tables[0];

        // The second table is the lesson names by id
        DataTable dtLessonNames = ds.Tables[1];




        // If the user has lessons
        if (dtLessonNames.Rows.Count > 0)
        {



            // Stick the lesson names in a hashtable
            Dictionary<int, Lesson> lessonNames = new Dictionary<int, Lesson>();
            foreach (DataRow dr in dtLessonNames.Rows)
            {
                int lessonId = (int)dr["LessonId"];
                string lessonName = dr["LessonName"].ToString();
                int ownerId = (int)dr["OwnerId"];
                string username = dr["Username"].ToString();

                Lesson lesson = new Lesson();
                lesson.lessonId = lessonId;
                lesson.lessonName = lessonName;
                lesson.ownerId = ownerId;
                lesson.ownername = username;

                lessonNames[lessonId] = lesson;
            }

            // Stick the lesson entries in a hashtable
            Dictionary<int, List<string>> lessonEntries = new Dictionary<int, List<string>>();
            foreach (DataRow dr in dtLessonEntries.Rows)
            {
                int lessonId = (int)dr["LessonId"];
                string entry = dr["Entry"].ToString();

                if (!lessonEntries.ContainsKey(lessonId))
                    lessonEntries[lessonId] = new List<string>();

                lessonEntries[lessonId].Add(entry);
            }
            
            

            string totalHtml = "";
            
            // Go through each lesson and build the rounded boxes
            foreach (int lessonId in lessonNames.Keys)
            {
                Lesson lesson = lessonNames[lessonId];
                string lessonName = lesson.lessonName;
                
                
                string lessonEntriesHtml = "";

                if (lessonEntries.ContainsKey(lessonId))
                {
                    List<string> entries = lessonEntries[lessonId];
                    foreach (string s in entries)
                        lessonEntriesHtml += s + ", ";
                    lessonEntriesHtml = lessonEntriesHtml.TrimEnd(", ".ToCharArray()) + "...<br /><br />";
                }

                string viewEntries = lesson.ownerId == userId ? "lessonentries" : "viewentries";
                viewEntries = String.Format("{0}.aspx?lessonid={1}", viewEntries, lesson.lessonId);

                string lessonNameHtml = String.Format("<b><a href=\"lesson.aspx?lessonid={0}\">{1}</a></b><br /><br />", lessonId, lessonName);
                string lessonCreatorHtml = lesson.ownerId == userId ? "" : "Created by " + lesson.ownername + "<br /><br />";
                string editLessonLink = String.Format(Constants.Anchor, "lessonsettings.aspx?lessonid=" + lessonId, "Settings");
                string editEntriesLink = String.Format(Constants.Anchor, viewEntries, "Entries");
                string deleteLessonLink = String.Format(Constants.Anchor, "deletelesson.aspx?lessonid=" + lessonId, lesson.ownerId == userId ? "Delete" : "Remove");
                string copyLessonLink = String.Format("<a href=\"{0}\" title=\"Make another copy of this lesson.\">{1}</a>", "copylesson.aspx?ownlesson=yes&lessonid=" + lessonId, "Copy");
                string printCardsLink = String.Format("<a href=\"{0}\" title=\"View the entries for copying and pasting.\" target=\"printcards\">{1}</a>", "printcards.aspx?lessonid=" + lessonId, "Copy entries");

                string allLinks = "";
                if (lesson.ownerId == userId)
                    allLinks = String.Format("{0} | {1} | {2} | {3} | {4}", editLessonLink, editEntriesLink, deleteLessonLink, copyLessonLink, printCardsLink);
                else
                    allLinks = String.Format("{0} | {1} | {2} | {3}", editEntriesLink, deleteLessonLink, copyLessonLink, printCardsLink);

                string html = String.Format(Constants.RoundedBox500, lessonNameHtml + lessonCreatorHtml + (lessonEntriesHtml == "" ? "No entries yet<br /><br />" : lessonEntriesHtml) + allLinks);

                totalHtml += html;
            }

            ltlLessons.Text = totalHtml;

        }
        // Otherwise
        else
        {
            // Indicate that they have no lessons
            lblMessage.Text = "You don't have any lessons yet!";

        }

        
    }


    private class Lesson { public string lessonName; public int lessonId; public int ownerId; public string ownername; }
}
