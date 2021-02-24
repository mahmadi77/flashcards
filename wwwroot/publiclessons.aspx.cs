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
using System.Text.RegularExpressions;

using Moa.RussianFlashCards.Data.Dao;

public partial class publiclessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the user id from the cookies
        HttpCookie userIdCookie = Request.Cookies[Constants.CookieKeys.UserId];

        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(userIdCookie.Value);
        }
        catch (Exception)
        {
        }
        
        // We need to know what page we're on, so let's assume 1 until
        // we find out from the query string
        int pageNumber = 1;

        // Attempt to get the page number from the query string
        try
        {
            pageNumber = int.Parse(Request.QueryString[Constants.QueryStringKeys.PublicLessonsPageNumber]);
        }
        catch (Exception)
        {
        }

        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the data set
        DataSet ds = dao.GetSharedLessons(Configuration.NumLessonsPerPage, pageNumber);

        // The first table is the list of top three entries per lesson
        DataTable dtLessonEntries = ds.Tables[0];
        
        // The second table is the lesson names by id
        DataTable dtLessonNames = ds.Tables[1];

        // The third table is just a count of the number of total lessons
        DataTable dtNumTotalLessons = ds.Tables[2];

        // Stick the lesson names in a hashtable
        Dictionary<int, Lesson> lessonNames = new Dictionary<int, Lesson>();
        foreach (DataRow dr in dtLessonNames.Rows)
        {
            int lessonId = (int)dr["LessonId"];
            string lessonName = dr["LessonName"].ToString();
            int ownerId = (int)dr["OwnerId"];
            string ownername = dr["Username"].ToString();
            Lesson lesson = new Lesson();
            lesson.lessonId = lessonId;
            lesson.lessonName = lessonName;
            lesson.ownerId = ownerId;
            lesson.ownername = ownername;

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

        // Get the total number of lessons
        int numTotalLessons = (int)dtNumTotalLessons.Rows[0][0];

        string totalHtml = "";
        
        // Go through the hashtable and create the html
        foreach (int lessonId in lessonNames.Keys)
        {
            Lesson lesson = lessonNames[lessonId];
            
            string lessonNameHtml = String.Format("<b><a href=\"lesson.aspx?lessonid={0}\">{1}</a></b><br /><br />", lessonId, lesson.lessonName);
            string lessonEntriesHtml = "";

            if (lessonEntries.ContainsKey(lesson.lessonId))
            {
                List<string> entries = lessonEntries[lesson.lessonId];
                foreach (string s in entries)
                    lessonEntriesHtml += s + ", ";
                lessonEntriesHtml = lessonEntriesHtml.TrimEnd(", ".ToCharArray()) + "...<br /><br />";

            }
            string editEntriesLink = "";
            if (lesson.ownerId == userId)
                editEntriesLink = String.Format(Constants.Anchor, "lessonentries.aspx?lessonid=" + lesson.lessonId, "Entries");
            else
                editEntriesLink = String.Format(Constants.Anchor, "viewentries.aspx?lessonid=" + lesson.lessonId, "Entries");
            string lessonCreatorHtml = "Created by " + lesson.ownername + "<br /><br />";
            string addLink = String.Format(Constants.Anchor, "insertuserlesson.aspx?lessonid=" + lesson.lessonId, "Add to my lessons");


            string allLinks = "";
            if (userId != lesson.ownerId)
                allLinks = String.Format("{0} | {1}", editEntriesLink, addLink);
            else    
                allLinks = editEntriesLink;
           
                

            string html = String.Format(Constants.RoundedBox500, lessonNameHtml + lessonCreatorHtml + (lessonEntriesHtml == "" ? "No entries yet<br /><br />" : lessonEntriesHtml) + allLinks);

            totalHtml += html;
        }

        // If we've got more total lessons that currently displayed
        // we need to implement paging.
        if (numTotalLessons > dtLessonNames.Rows.Count)
        {
            // The hyperlink to the page
            string pageLinkFormat = "<a href=\"publiclessons.aspx?page={0}\">{1}</a>";

            // Here's a list to hold our "before" links
            List<string> beforePageLinks = new List<string>();
            
            // Here's a list to hold our "after" page links
            List<string> afterPageLinks = new List<string>();

            // If we have pages before this one
            if (pageNumber > 1)
            {
                // Show up to five pages before
                int pagesBefore = 0;
                for (int i = pageNumber - 1; i > 0 && pagesBefore < 5; i--)
                {
                    // Create a link to that page
                    string pageLink = String.Format(pageLinkFormat, i, i);
                    
                    // Add it to our "before" pages
                    beforePageLinks.Add(pageLink);

                    // Decrement tne number of page links we've created
                    pagesBefore++;
                }
            }

            // Determine the total number of pages required
            int totalPages = numTotalLessons / Configuration.NumLessonsPerPage;
            
            // Add one more if there's a remainder
            if (numTotalLessons % Configuration.NumLessonsPerPage != 0)
                totalPages++;

            // If we have pages after this one
            if (pageNumber < totalPages)
            {
                // Show up to five pages after
                int pagesAfter = 0;
                for (int i = pageNumber + 1; i <= totalPages && pagesAfter < 5; i++)
                {
                    // Create a link to that page
                    string pageLink = String.Format(pageLinkFormat, i, i);

                    // Add it to our "after" pages
                    afterPageLinks.Add(pageLink);

                    // Decrement tne number of page links we've created
                    pagesAfter++;
                }
            }

            // Now we go through our lists and build the page links html.
            string totalPageLinksHtml = "";
            
            // We have to go through the before links backwards
            for (int i = beforePageLinks.Count - 1; i >= 0; i--)
                totalPageLinksHtml += beforePageLinks[i] + "&nbsp;&nbsp;";

            // Add the current page just for the fuck of it
            totalPageLinksHtml += "<b>" + pageNumber + "</b>" + "&nbsp;&nbsp;";

            // We can go through the after links in order
            foreach (string s in afterPageLinks)
                totalPageLinksHtml += s + "&nbsp;&nbsp;";

            // Create a first page link
            string firstPageLink = String.Format(pageLinkFormat, 1, "<");
            totalPageLinksHtml = firstPageLink + "&nbsp;&nbsp;" + totalPageLinksHtml;
            
            // Create a last page link
            string lastPageLlink = String.Format(pageLinkFormat, totalPages, ">");
            totalPageLinksHtml += lastPageLlink;

            totalHtml += "<div style=\"text-align: center;\">Go to page: " + totalPageLinksHtml + "</div>";
        }

        ltlLessons.Text = totalHtml;
    }
    protected void ibSearch_Click(object sender, ImageClickEventArgs e)
    {
        lblSearchError.Text = "";

        if (txtSearch.Text.Trim().Length < 3)
        {
            lblSearchError.Text = "Your search term must be at least 3 characters.";
            return;
        }
        
        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        string searchTerms = Regex.Replace(txtSearch.Text, "[ ]+", " ");
        searchTerms = searchTerms.Replace(" ", ",");
        string[] S = searchTerms.Split(',');

        DataTable dt = dao.SearchLessons(searchTerms);

        Dictionary<int, List<SearchResult>> searchResults = new Dictionary<int, List<SearchResult>>();
        
        foreach (DataRow dr in dt.Rows)
        {
            int lessonId = (int)dr["LessonId"];
            string lessonName = dr["LessonName"].ToString();
            //int lessonEntryId = (int)dr["LessonEntryId"];
            string entry = dr["SearchTerm"].ToString();

            SearchResult searchResult = new SearchResult();
            searchResult.lessonId = lessonId;
            searchResult.lessonName = lessonName;
            //searchResult.lessonEntryId = lessonEntryId;
            searchResult.entry = entry;

            if (!searchResults.ContainsKey(lessonId))
                searchResults[lessonId] = new List<SearchResult>();

            searchResults[lessonId].Add(searchResult);
        }

        string totalHtml = "";
        
        foreach (List<SearchResult> s in searchResults.Values)
        {

            string lessonNameHtml = "";
            string lessonEntriesHtml = "";
            int lessonId = 0;

            foreach (SearchResult sr in s)
            {

                lessonNameHtml = String.Format("<b><a href=\"lesson.aspx?lessonid={0}\">{1}</a></b><br /><br />", sr.lessonId, sr.lessonName);
                lessonId = sr.lessonId;

                string entry = sr.entry;
                foreach (string searchTerm in S)
                {
                    MatchCollection mc = Regex.Matches(entry, searchTerm, RegexOptions.IgnoreCase);
                    foreach (Match match in mc)
                    {
                        entry = entry.Replace(match.Value, "<b>" + match.Value + "</b>");
                    }
                }
                lessonEntriesHtml += entry + ", ";
            }

            lessonEntriesHtml = lessonEntriesHtml.TrimEnd(", ".ToCharArray()) + "...<br /><br />";
            
            string editEntriesLink = String.Format(Constants.Anchor, "viewentries.aspx?lessonid=" + lessonId, "Entries");
            string addLink = String.Format(Constants.Anchor, "insertuserlesson.aspx?lessonid=" + lessonId, "Add to my lessons");
            string allLinks = String.Format("{0} | {1}", editEntriesLink, addLink);

            totalHtml += String.Format(Constants.RoundedBox500, lessonNameHtml + lessonEntriesHtml + allLinks);
        }

        ltlLessons.Text = totalHtml == "" ? "No search results" : totalHtml;
    }

    private class SearchResult { public int lessonId; public string lessonName; public int lessonEntryId; public string entry; }

    private class Lesson { public string lessonName; public int lessonId; public int ownerId; public string ownername; }

    protected void lbClear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        Response.Redirect("publiclessons.aspx");
    }
}
