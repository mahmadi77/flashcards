using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class subscribe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {        
        // Get the message code from query string
        string messageCode = Request.QueryString["cd"];

        // Maxed lessons, registered
        if (messageCode == "mlr")
        {
            lblSubscription.Text = "Subscribe";
            lblMessage.Text = "You can't add any more lessons.";
            lblCompleteMessage.Text = "Sorry, but you've run out of freebies. You can either delete one of your other lessons, or subscribe and get much more functionality.  It's cheap - check it out.";
        }

        // Maxed lessons, subscription
        if (messageCode == "mls")
        {
            lblSubscription.Text = "You've maxed something out";
            lblMessage.Text = "You can't add any more lessons.";
            lblCompleteMessage.Text = "Sorry, you've used up all your lessons.  You can upgrade your subscription if you'd like.";
        }

        // Maxed lesson groups, registered
        if (messageCode == "mlgr")
        {
            lblSubscription.Text = "Subscribe";
            lblMessage.Text = "You can't add any more lesson groups.";
            lblCompleteMessage.Text = "Sorry, but you've run out of freebies. Subscribe and get much more functionality.  It's cheap - check it out.";
        }

        // Maxed lesson groups, subscription
        if (messageCode == "mlgs")
        {
            lblSubscription.Text = "You've maxed something out";
            lblMessage.Text = "You can't add any more lessons.";
            lblCompleteMessage.Text = "Sorry, you've used up all your lessons.  You can upgrade your subscription if you'd like.";
        }

        // Maxed entries, registered
        if (messageCode == "mer")
        {
            lblSubscription.Text = "Subscribe";
            lblMessage.Text = "You can't add any more entries to that lesson.";
            lblCompleteMessage.Text = "Sorry, but you've run out of freebies. You can either delete some of your existing cards in that lesson, or you can subscribe and get much more functionality.  It's cheap - check it out.";
        }

        // Maxed lessons
        if (messageCode == "mes")
        {
            lblSubscription.Text = "You've maxed something out";
            lblMessage.Text = "You can't add any more cards to that lesson.";
            lblCompleteMessage.Text = "Sorry, you've used up all your cards for that lesson.  You can upgrade your subscription if you'd like.";
        }

        // Generic
        if (messageCode == "gen")
        {
            lblSubscription.Text = "Subscription options";
            lblMessage.Text = "";
            lblCompleteMessage.Text = "";
        }

        // Subscribed: Basic
        if (messageCode == "sbs")
        {
            lblSubscription.Text = "Thanks for subscribing!";
            lblMessage.Text = "We hope you enjoy using the site!";
            lblCompleteMessage.Text = "";
        }

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

        // Get the usage descriptions for that user
        DataTable dt = dao.GetUsageStatusDescriptions(userId);

        string usageCode = "";

        // Go through the rows and create the table
        string htmlHeaderRow = "<tr><th>Package</th><th>Maximum Lessons</th><th>Maximum Cards Per Lesson</th><th>Maximum Lesson Groups</th><th>Lessons Expire After</th>" //<th>Maximum Private Lessons</th>
            + "<th>Price Per Month</th><th>You are:</th>"
            + "<th>Subscribe</th>"
            + "</tr>";
        string totalHtml = htmlHeaderRow;

        foreach (DataRow dr in dt.Rows)
        {
            string code = dr["Code"].ToString();
            string name = dr["Name"].ToString();
            double price = (double)dr["Price"];
            int maxLessons = (int)dr["MaxLessons"];
            int maxLessonGroups = (int)dr["MaxLessonGroups"];
            int maxPrivateLessons = (int)dr["MaxPrivateLessons"];
            int maxEntries = (int)dr["MaxEntries"];
            string currentUsageCode = dr["CurrentUsageCode"].ToString();

            string htmlRow = "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td><td>{6}</td><td>{7}</td></tr>";
            string htmlRowFormatted = "";

            string payPalButton = "";

            if (currentUsageCode != "")
                usageCode = currentUsageCode;


            // https://www.x.com/message/190158


            if (code == "S1")
            {
                payPalButton =
                "<form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">" +
                "<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">" +
                "<input type=\"hidden\" name=\"hosted_button_id\" value=\"X87KZLA373EY2\">" +
                "<input type=\"image\" src=\"https://www.paypal.com/en_US/i/btn/btn_subscribeCC_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">" +
                "<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">" +
                "</form>";
            }
            else if (code == "S2")
            {
                payPalButton =
                "<form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">" +
                "<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">" +
                "<input type=\"hidden\" name=\"hosted_button_id\" value=\"MHE3HU344UDBU\">" +
                "<input type=\"image\" src=\"https://www.paypal.com/en_US/i/btn/btn_subscribeCC_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">" +
                "<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">" +
                "</form>";
            }
            else if (code == "S3")
            {
                payPalButton =
                "<form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">" +
                "<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">" +
                "<input type=\"hidden\" name=\"hosted_button_id\" value=\"C2KHRQSZKFTU8\">" +
                "<input type=\"image\" src=\"https://www.paypal.com/en_US/i/btn/btn_subscribeCC_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">" +
                "<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">" +
                "</form>";
            }

            htmlRowFormatted = String.Format(htmlRow, name, maxLessons, maxEntries, maxLessonGroups, currentUsageCode == "R" ? "1 Hour" : "Never", //maxPrivateLessons, 
                "$" + price, currentUsageCode != "" ? "<img src=\"images/check.gif\" />" : "", payPalButton);

            totalHtml += htmlRowFormatted;
        }



        string unsubscribe = "<A HREF=\"https://www.paypal.com/cgi-bin/webscr?cmd=_subscr-find&alias=Q2M6494J28XMU\">" +
                             "<IMG SRC=\"https://www.paypal.com/en_US/i/btn/btn_unsubscribe_LG.gif\" BORDER=\"0\">" +
                             "</A>";

        ltlUsageDescriptions.Text = "<table border=\"1\" style=\"background-color: blue;\">" + totalHtml + "</table><br /><br />" + (usageCode != "R" ? unsubscribe : "");


        // Get the user statistics for that user
        DataSet ds = dao.GetUserStatistics(userId);

        int numLessons = (int)ds.Tables[0].Rows[0]["NumLessons"];
        int numLessonGroups = (int)ds.Tables[0].Rows[0]["NumLessonGroups"];
        int numPrivateLessons = (int)ds.Tables[0].Rows[0]["NumPrivateLessons"];

        string firstTable = 
            String.Format(
            "<table align=\"center\" border=\"1\" style=\"background-color: blue;\">{0}</table>",
            "<tr><td>Current Number of Lessons</td><td>" + numLessons + "</td></tr>" +
            "<tr><td>Current Number of Lesson Groups</td><td>" + numLessonGroups + "</td></tr>" 
            //+
            //"<tr><td>Current Number of Private Lessons</td><td>" + numPrivateLessons + "</td></tr>"
            );


        string entriesTable = "<table align=\"center\" border=\"1\" style=\"background-color: blue;\"><tr><th>Lesson</th><th>Number of Entries</th></tr>{0}</table>";
        string totalRows = "";

        foreach (DataRow dr in ds.Tables[1].Rows)
        {
            string lessonName = dr["LessonName"].ToString();
            int numEntries = (int)dr["NumEntries"];

            totalRows += "<tr><td>" + lessonName + "</td><td>" + numEntries + "</td></tr>";
        }

        entriesTable = String.Format(entriesTable, totalRows);




        ltlUserStatistics.Text = "<hr /><br/ ><br /><b>Here's where you currently stand</b><br />" + firstTable + "<br /><br /><b>And here are the number of entries per lesson</b><br />" + entriesTable;
        
    }
}
