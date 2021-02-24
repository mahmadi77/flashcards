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
using System.Text.RegularExpressions;

using Moa.RussianFlashCards.Data.Dao;

public partial class bulkinsert : System.Web.UI.Page
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

        // Set the hyperlink navigate url for the bulk insert with accents page
        //hlAccents.NavigateUrl = "bulkinsertaccents.aspx?lessonid=" + lessonId;

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

        string[] F = fronts.Split('\n');
        string[] B = backs.Split('\n');

        if (F.Length != B.Length)
        {
            lblError.Text = "You don't have the same number of rows in each box.";
            return;
        }

        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        int lessonId = int.Parse(Request.QueryString["lessonid"]);

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

        DataTable dtStatus = dao.GetUsageStatus(userId);
        UsageStatus us = UsageStatus.MapUsageStatus(dtStatus.Rows[0]);
        int numEntries = dao.GetNumEntries(lessonId);

        for (int i = 0; i < F.Length; i++)
        {
            if (numEntries + 1 > us.MaxEntries)
            {
                if (us.Code == "R")
                    Response.Redirect("subscribe.aspx?cd=mer");
                else
                    Response.Redirect("subscribe.aspx?cd=mes");
            }

            string front = F[i].Trim();
            string back = B[i].Trim();
            string accentsFront = null;
            string accentsBack = null;

            if (front.Contains("^"))
            {
                front = Regex.Replace(front, @"\^+", "^");
                accentsFront = Regex.Replace(front, @".\^", "^");
                front = front.Replace("^", "");

                if (accentsFront.Length != front.Length)
                    throw new Exception("Accent pattern on front not same length as front of card.");
            }
            if (back.Contains("^"))
            {
                back = Regex.Replace(back, @"\^+", "^");
                accentsBack = Regex.Replace(back, @".\^", "^");
                back = back.Replace("^", "");

                if (accentsBack.Length != back.Length)
                    throw new Exception("Accent pattern on back not same length as back of card.");
            }

            dao.InsertLessonEntry(lessonId, front, back, accentsFront, accentsBack);
            numEntries++;
        }

        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        int lessonId = int.Parse(Request.QueryString["lessonid"]);
        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
}
