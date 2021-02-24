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

public partial class bulkinsertaccents : System.Web.UI.Page
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
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // Create the Dao
        Dao dao = Utilities.NewDao();

        // See whether the user owns the lesson
        bool userOwnsLesson = dao.ValidateUserOwnsLesson(userId, lessonId);

        if (!userOwnsLesson)
            Response.Redirect("mylessons.aspx");
    }
    protected void btnInsert_Click(object sender, EventArgs e)
    {
        string fronts = txtFront.Text.Trim();
        string backs = txtBack.Text.Trim();
        string frontAccents = txtFrontAccents.Text.Trim();
        string backAccents = txtBackAccents.Text.Trim();

        string[] F = fronts.Split('\n');
        string[] B = backs.Split('\n');
        string[] FA = frontAccents.Split('\n');
        string[] BA = backAccents.Split('\n');

        if (F.Length != B.Length || F.Length != FA.Length || B.Length != BA.Length)
        {
            lblError.Text = "You don't have the same number of rows in each box.";
            return;
        }

        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        string errorText = "";

        for (int i = 0; i < F.Length; i++)
        {
            string front = F[i].Trim();
            string back = B[i].Trim();
            string frontAccent = FA[i].Trim();
            string backAccent = BA[i].Trim();

            if ((front.Length == frontAccent.Length || frontAccent.Length == 0) && (back.Length == backAccent.Length || backAccent.Length == 0))
                dao.InsertLessonEntry(lessonId, front, back, frontAccent, backAccent);
            else
            {
                if (front.Length != frontAccent.Length && frontAccent.Length != 0)
                    errorText += "Line " + (i + 1) + ", the front: " + front + ", " + frontAccent + "<br />";
                if (back.Length != backAccent.Length && backAccent.Length != 0)
                    errorText += "Line " + (i + 1) + ", the back: " + back + ", " + backAccent + "<br />";
            }
        }

        if (errorText != "")
        {
            errorText = "There were some problems inserting one or more of your cards.  It's totally your fault.  Maybe fix them and try it again.  Or don't.  I really don't care.<br /><br />" + errorText;
            lblError.Text = errorText;
        }
        else
            Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        int lessonId = int.Parse(Request.QueryString["lessonid"]);
        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
}
