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

public partial class insertentry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //txtFront.Attributes["onkeyup"] =
        //    "javascript:" +
        //    "var entry = document.getElementById('" + txtFront.ClientID + "'); " +
        //    "var accents = document.getElementById('" + txtAccents.ClientID + "'); " +
        //    "accents.value = entry.value; ";

        //txtBack.Attributes["onkeyup"] =
        //    "javascript:" +
        //    "var entry = document.getElementById('" + txtBack.ClientID + "'); " +
        //    "var accents = document.getElementById('" + txtAccentsBack.ClientID + "'); " +
        //    "accents.value = entry.value; ";

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

        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);
        DataTable dtStatus = dao.GetUsageStatus(userId);
        UsageStatus us = UsageStatus.MapUsageStatus(dtStatus.Rows[0]);

        int lessonId = int.Parse(Request.QueryString["LessonId"]);
        int numEntries = dao.GetNumEntries(lessonId);

        // If adding an entry would put the user over the max entry
        // count for their usage status
        if (numEntries + 1 > us.MaxEntries)
        {
            // If they don't have a subscription, only registered
            // mler = max lesson entries registered
            if (us.Code == "R")
                Response.Redirect("subscribe.aspx?cd=mler");
            // If they have a subscription
            // mles = max lesson entries subscription
            else
                Response.Redirect("subscribe.aspx?cd=mles");
        }



    }
    protected void btnInsertEntry_Click(object sender, EventArgs e)
    {
        //if (txtFront.Text.Trim().Length != txtAccents.Text.Trim().Length && txtAccents.Text.Trim().Length != 0)
        //{
        //    lblError.Text = "The accent pattern for the front is not the same length as the text on the front of the card.";
        //    return;
        //}
        //if (txtBack.Text.Trim().Length != txtAccentsBack.Text.Trim().Length && txtAccentsBack.Text.Trim().Length != 0)
        //{
        //    lblError.Text = "The accent pattern for the back is not the same length as the text on the back of the card.";
        //    return;
        //}
        
        int lessonId = int.Parse(Request.QueryString["lessonid"]);

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        string front = txtFront.Text.Trim();
        string back = txtBack.Text.Trim();
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

        dao.InsertLessonEntry(
            lessonId,
            front,
            back,
            accentsFront,
            accentsBack
            );


        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("lessonentries.aspx?lessonid=" + Request.QueryString["lessonid"]);
    }
}
