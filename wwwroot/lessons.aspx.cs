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

public partial class lessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
        
        // Create the dao object
        Dao dao = Utilities.NewDao();

        // Get the lessons from the db
        DataTable dt = dao.GetDemoLessons();

        // Create the rounded boxes
        string totalHtml = "";

        foreach (DataRow dr in dt.Rows)
        {
            string lessonName = dr["LessonName"].ToString();
            int lessonId = (int)dr["LessonId"];
            string lessonAddress = "lesson.aspx?lessonid=" + lessonId;
            string addToMyLessonsAddress = "insertuserlesson.aspx?lessonid=" + lessonId;
            string lessonAnchor = Utilities.FormatAnchorTag(lessonName, lessonAddress);
            string addToMyLessonsAnchor = Utilities.FormatAnchorTag("Add to My Lessons!", addToMyLessonsAddress);
            string html = String.Format(Constants.RoundedBox200, lessonAnchor);
            totalHtml += html + "<br />\n";
        }

        ltlRoundedBoxes.Text = totalHtml;
    }
}
