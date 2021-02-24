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

public partial class printcards : System.Web.UI.Page
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

        //// See whether the user owns the lesson
        //bool userOwnsLesson = dao.ValidateUserOwnsLesson(userId, lessonId);

        //// 1. If the user doesn't own the lesson
        //if (!userOwnsLesson)
        //{
        //    Response.Redirect("userdoesntown.aspx?lessonid=" + lessonId);
        //}

        DataTable dtLesson = dao.GetLesson(lessonId);


        List<Entry> entries = new List<Entry>();


        bool foundFrontAccents = false;
        bool foundBackAccents = false;

        foreach (DataRow dr in dtLesson.Rows)
        {
            string front = dr["Entry"].ToString();
            string back = dr["Translation"].ToString();
            string frontAccents = dr["Accents"].ToString();
            string backAccents = dr["AccentsBack"].ToString();

            if (frontAccents.Trim() != "") foundFrontAccents = true;
            if (backAccents.Trim() != "") foundBackAccents = true;

            Entry entry = new Entry();
            entry.front = front;
            entry.back = back;
            entry.frontAccents = frontAccents;
            entry.backAccents = backAccents;

            entries.Add(entry);
        }

        string totalHtml = "";

        foreach (Entry lessonEntry in entries)
        {
            if (foundFrontAccents && foundBackAccents)
                totalHtml += String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>", lessonEntry.front, lessonEntry.back, lessonEntry.frontAccents, lessonEntry.backAccents);

            if (foundFrontAccents && !foundBackAccents)
                totalHtml += String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", lessonEntry.front, lessonEntry.back, lessonEntry.frontAccents);

            if (!foundFrontAccents && foundBackAccents)
                totalHtml += String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", lessonEntry.front, lessonEntry.back, lessonEntry.backAccents);

            if (!foundFrontAccents && !foundBackAccents)
                totalHtml += String.Format("<tr><td>{0}</td><td>{1}</td></tr>", lessonEntry.front, lessonEntry.back);
        }

        string headerRow = "";

        if (foundFrontAccents && foundBackAccents)
            headerRow = "<tr><th>Front</th><th>Back</th><th>Front Accents</th><th>Back Accents</th></tr>";

        if (foundFrontAccents && !foundBackAccents)
            headerRow = "<tr><th>Front</th><th>Back</th><th>Front Accents</th></tr>";

        if (!foundFrontAccents && foundBackAccents)
            headerRow = "<tr><th>Front</th><th>Back</th><th>Back Accents</th></tr>";

        if (!foundFrontAccents && !foundBackAccents)
            headerRow = "<tr><th>Front</th><th>Back</th></tr>";
        
        totalHtml = "<table>" + headerRow + totalHtml + "</table>";

        ltlTotalHtml.Text = totalHtml;
    }

    private class Entry { public string front; public string back; public string frontAccents; public string backAccents; }
}
