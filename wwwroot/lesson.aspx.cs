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

public partial class lesson : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Create a dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        bool isSingleLesson = Request.QueryString["lessonid"] != null && Request.QueryString["lessonid"] != "";

        DataTable dt = null;
        int lessonId = -1;
        int lessonGroupId = -1;

        // Get the cookie
        HttpCookie cookie = Request.Cookies[Constants.CookieKeys.UserId];

        // Get the user id from the cookie
        int userId = -1;

        try
        {
            userId = Utilities.GetUserId(cookie.Value);
        }
        catch (Exception)
        {
        }

        if (Request.QueryString["lg"] != null && Request.QueryString["lg"] != "")
        {
            lessonGroupId = int.Parse(Request.QueryString["lg"]);
            dt = dao.GetLessonGroupAsLesson(lessonGroupId);
        }
        else
        {
            lessonId = int.Parse(Request.QueryString["lessonid"]);
            dt = dao.GetLesson(lessonId);
        }

        // Get the lesson entries from the database
        // TODO: Error handling for query string

        if (dt.Rows.Count == 0)
        {
            if (isSingleLesson)
                Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
            else
                Response.Redirect("editlessongroup.aspx?lg=" + lessonGroupId);
        }

        DataSet ds = null;
        DataTable dtSettings = null;
        DataTable dtNumEntriesWithAccents = null;

        if (isSingleLesson)
            ds = dao.GetLessonSettings(lessonId);
        else
            ds = dao.GetLessonGroupSettings(lessonGroupId);

        dtSettings = ds.Tables[0];
        dtNumEntriesWithAccents = ds.Tables[1];

        string lessonName = dtSettings.Rows[0]["LessonName"].ToString();
        int ownerId = (int)dtSettings.Rows[0]["UserId"];
        int speed = (int)dtSettings.Rows[0]["Speed"];
        bool random = !(bool)dtSettings.Rows[0]["InOrder"];
        bool accents = (bool)dtSettings.Rows[0]["AccentsOn"];
        bool direction = (bool)dtSettings.Rows[0]["Direction"];
        bool showSettings = (bool)dtSettings.Rows[0]["ShowSettings"];
        string backgroundColor = dtSettings.Rows[0]["BackgroundColor"].ToString();
        string backgroundImage = dtSettings.Rows[0]["BackgroundImage"].ToString();
        string textColor = dtSettings.Rows[0]["TextColor"].ToString();
        string hideButtonColor = dtSettings.Rows[0]["HideButtonColor"].ToString();
        string menuTextColor = dtSettings.Rows[0]["MenuTextColor"].ToString();
        string accentsColor = dtSettings.Rows[0]["AccentsColor"].ToString();
        string entryMarkupType = dtSettings.Rows[0]["EntryMarkupType"].ToString();

        this.Title = lessonName;

        int numEnriesWithAccents = (int)dtNumEntriesWithAccents.Rows[0][0];

        Theme theme = new Theme();
        theme.AccentsColor = accentsColor;
        theme.BackgroundColor = backgroundColor;
        theme.BackgroundImage = backgroundImage;
        theme.HideButtonColor = hideButtonColor;
        theme.MenuTextColor = menuTextColor;
        theme.TextColor = textColor;

        EntryMarkupType markupType = entryMarkupType == "H" ? EntryMarkupType.Highlights : EntryMarkupType.Accents;

        Lesson lesson = new Lesson();
        lesson.Direction = direction;
        lesson.EntryMarkupType = markupType;
        lesson.IsSingleLesson = isSingleLesson;
        lesson.LessonGroupId = lessonGroupId;
        lesson.LessonId = lessonId;
        lesson.LessonName = lessonName;
        lesson.OwnerId = ownerId;
        lesson.Random = random;
        lesson.ShowSettings = showSettings;
        lesson.Speed = speed;
        lesson.Theme = theme;
        lesson.UseAccents = accents;
        lesson.NumLessonEntriesWithAccents = numEnriesWithAccents;

        // TODO: Verify that the lesson is either owned by the user
        // or is shared with the user
        // or is a public lesson

        string usageStatus = "";
        if (userId != -1)
        {
            DataTable dtUserSubscriptionStatus = dao.GetUsageStatus(userId);
            if (dtUserSubscriptionStatus.Rows.Count > 0)
                usageStatus = dtUserSubscriptionStatus.Rows[0]["Code"].ToString();
        }
        
        bool isDemoLesson = false;
        DataTable dtDemoLessons = dao.GetDemoLessons();
        foreach (DataRow dr in dtDemoLessons.Rows)
        {
            int demoLessonId = (int)dr["LessonId"];
            if (demoLessonId == lesson.LessonId)
            {
                isDemoLesson = true;
                break;
            }
        }

        // Create the javascript
        string javascript = CreateJavascript(dt, lesson, userId, usageStatus, isDemoLesson);

        // Stick it in the literal
        ltlScript.Text = javascript;


        if (userId != -1)
            dao.InsertLessonView(lessonId, userId);
        else
            dao.InsertLessonView(lessonId, null);
    }

    private string CreateJavascript(DataTable dt, Lesson lesson, int userId, string usageStatus, bool isDemoLesson)
    {
        // A string to hold the javascript
        string javascript = "";
        
        // Get the format string (for accents) from the config file
        //string formatString = ConfigurationManager.AppSettings["AccentsMarkup"];


        string formatString = lesson.EntryMarkupType == EntryMarkupType.Highlights ? Configuration.HighlightMarkup : Configuration.AccentMarkup;
        formatString = formatString.Replace("\"", "\\\"");
        
        if (!lesson.UseAccents)
        {
            if (lesson.EntryMarkupType == EntryMarkupType.Accents)
                formatString = formatString.Replace("Visible", "Hidden");
            if (lesson.EntryMarkupType == EntryMarkupType.Highlights)
                formatString = formatString.Replace("<<ACCENT_COLOR>>", lesson.Theme.TextColor);
        }

        // The text color and the accent color
        //string textColor = "#303030";
        //string accentColor = "#55c961";
        //string textColor = "green";
        //string accentColor = "yellow";
        //string textColor = theme.TextColor;
        //string accentColor = theme.AccentsColor;

        // Go through all the entries to build the word array
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            // Get the fields
            string entry = dt.Rows[i]["Entry"].ToString().Replace("\"", "\\\"");
            string accents = dt.Rows[i]["Accents"].ToString().Replace("\"", "\\\"");

            // Create the first array entry
            string wordOrPhraseMarkedUp = accents.Length == entry.Length ? MarkUpEntry(entry, accents, formatString) : entry;
            string s = string.Format("wordArray[{0}] = \"{1}\";", i, wordOrPhraseMarkedUp);
            javascript += s + "\n";
        }

        
        bool additionalElement = false;
        if (!isDemoLesson && dt.Rows.Count > 0 && (userId == -1 || usageStatus == "R"))
        {         
            additionalElement = true;

            if (userId == -1)
                javascript += "wordArray[" + dt.Rows.Count + "] = \"<a href=\\\"login.aspx\\\">Login</a> or <a href=\\\"subscribe.aspx\\\">subscribe</a> to stop seeing this message.\";\n";
            else
                javascript += "wordArray[" + dt.Rows.Count + "] = \"<a href=\\\"subscribe.aspx\\\">Subscribe</a> to stop seeing this message.\";\n";
        }

        // Go through all the entries a second time to build the translation array
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            // Get the fields
            string translation = dt.Rows[i]["Translation"].ToString();
            string accentsBack = dt.Rows[i]["AccentsBack"].ToString();

            // Create the first array entry
            string wordOrPhraseMarkedUp = accentsBack.Length == translation.Length ? MarkUpEntry(translation, accentsBack, (lesson.UseAccents ? formatString : formatString.Replace(lesson.Theme.AccentsColor, lesson.Theme.TextColor))) : translation;
            string s = string.Format("translationArray[{0}] = \"{1}\";", i, wordOrPhraseMarkedUp);
            javascript += s + "\n";
        }

        if (!isDemoLesson && dt.Rows.Count > 0 && (userId == -1 || usageStatus == "R"))
        {
            if (userId == -1)
                javascript += "translationArray[" + dt.Rows.Count + "] = \"<a href=\\\"login.aspx\\\">Login</a> or <a href=\\\"subscribe.aspx\\\">subscribe</a> to stop seeing this message.\";\n";
            else
                javascript += "translationArray[" + dt.Rows.Count + "] = \"<a href=\\\"subscribe.aspx\\\">Subscribe</a> to stop seeing this message.\";\n";
        }

        string settings = @"<a href=""{0}.aspx?{1}={2}"">Settings</a>";
        string entries = @"<a href=""{0}.aspx?{1}={2}"">Entries</a>";

        if (lesson.IsSingleLesson)
        {
            settings = String.Format(settings, "lessonsettings", "lessonid", lesson.LessonId);
            entries = String.Format(entries, "lessonentries", "lessonid", lesson.LessonId);
        }
        else
        {
            settings = String.Format(settings, "lessonsettings", "lg", lesson.LessonGroupId);
            entries = String.Format(entries, "editlessongroup", "lg", lesson.LessonGroupId);
        }

        string settingsAndEntries = String.Format("{0}<br />{1}<br />", settings, entries);

        string theScript = Script.script.Replace("<<ARRAY_ASSIGNMENTS>>", javascript);
        
        if (additionalElement)
            theScript = theScript.Replace("<<NUM_ELEMENTS>>", (dt.Rows.Count + 1).ToString());
        else
            theScript = theScript.Replace("<<NUM_ELEMENTS>>", dt.Rows.Count.ToString());
        theScript = theScript.Replace("<<LESSON_NAME>>", lesson.LessonName);
        theScript = theScript.Replace("<<SPEED>>", lesson.Speed.ToString());
        theScript = theScript.Replace("<<RANDOM>>", lesson.Random.ToString().ToLower());
        theScript = theScript.Replace("<<IN_ORDER>>", lesson.Random ? "Random" : "In Order");
        theScript = theScript.Replace("<<ACCENTS>>", lesson.UseAccents.ToString().ToLower());
        
        if (lesson.NumLessonEntriesWithAccents > 0)
            theScript = theScript.Replace("<<ACCENTS_STR>>", lesson.UseAccents ? "Remove Accents" : "Use Accents");
        else
            theScript = theScript.Replace("<<ACCENTS_STR>>", "");

        theScript = theScript.Replace("<<FACEBOOKLIKEBUTTON>>", String.Format(Constants.Facebook.LikeButtonLesson, lesson.LessonId.ToString()));
        theScript = theScript.Replace("<<TWEETBUTTON>>", Constants.Twitter.TweetButtonLesson);
        theScript = theScript.Replace("<<LESSON_ID>>", lesson.LessonId.ToString());
        theScript = theScript.Replace("<<DIRECTION_STR>>", !lesson.Direction ? "Front to Back" : "Back to Front");
        theScript = theScript.Replace("<<DIRECTION>>", (!lesson.Direction).ToString().ToLower());
        theScript = theScript.Replace("<<SHOW_SETTINGS>>", lesson.ShowSettings.ToString().ToLower());
        theScript = theScript.Replace("<<SHOW_OR_HIDE>>", lesson.ShowSettings ? "<b>Hide</b>" : "<b>+</b>");
        theScript = theScript.Replace("<<SETTINGS_VISIBILITY>>", lesson.ShowSettings ? "visible" : "hidden");
        theScript = theScript.Replace("<<ENTRY_MARKUP_TYPE>>", lesson.EntryMarkupType.ToString().ToLower());
        theScript = theScript.Replace("<<SECONDS>>", String.Format("{0:#.##}", lesson.Speed / 1000.0));

        if (lesson.OwnerId == userId)
            theScript = theScript.Replace("<<SETTINGS_AND_ENTRIES>>", settingsAndEntries);
        else
        {
            //if (lesson.IsSingleLesson)
            //    theScript = theScript.Replace("<<SETTINGS_AND_ENTRIES>>", "<a href=\"insertuserlesson.aspx?lessonid=" + lesson.LessonId + "\">Add to My Lessons</a><br />");
            //else
                theScript = theScript.Replace("<<SETTINGS_AND_ENTRIES>>", "");
        }

        //// Themes
        //theScript = theScript.Replace("<<BACKGROUND_COLOR>>", "black");
        //theScript = theScript.Replace("<<TEXT_COLOR>>", textColor);
        //theScript = theScript.Replace("<<BACKGROUND_IMAGE>>", "");
        //theScript = theScript.Replace("<<MENUTEXT_COLOR>>", "green");
        //theScript = theScript.Replace("<<HIDEBUTTON_COLOR>>", "green");
        //theScript = theScript.Replace("<<ACCENT_COLOR>>", accentColor);
        
        //// Themes
        //theScript = theScript.Replace("<<BACKGROUND_COLOR>>", "#eeeeee");
        //theScript = theScript.Replace("<<TEXT_COLOR>>", textColor);
        //theScript = theScript.Replace("<<BACKGROUND_IMAGE>>", "");
        //theScript = theScript.Replace("<<MENUTEXT_COLOR>>", "black");
        //theScript = theScript.Replace("<<HIDEBUTTON_COLOR>>", "black");
        //theScript = theScript.Replace("<<ACCENT_COLOR>>", accentColor);


        // Themes
        theScript = theScript.Replace("<<BACKGROUND_COLOR>>", lesson.Theme.BackgroundColor);
        theScript = theScript.Replace("<<TEXT_COLOR>>", lesson.Theme.TextColor);
        theScript = theScript.Replace("<<BACKGROUND_IMAGE>>", lesson.Theme.BackgroundImage == "" || lesson.Theme.BackgroundImage == null ? "" : String.Format("background: url(\"{0}\");", lesson.Theme.BackgroundImage));
        theScript = theScript.Replace("<<MENUTEXT_COLOR>>", lesson.Theme.MenuTextColor);
        theScript = theScript.Replace("<<HIDEBUTTON_COLOR>>", lesson.Theme.HideButtonColor);
        theScript = theScript.Replace("<<ACCENT_COLOR>>", lesson.Theme.AccentsColor);
        

        return theScript;
    }

    private string MarkUpEntry(string entry, string accents, string formatString)
    {
        if (entry.Length != accents.Length)
            throw new Exception("Accent pattern not same length as word or phrase.");

        string markedUpWordOrPhrase = "";

        for (int i = 0; i < entry.Length; i++)
        {
            char c1 = entry[i];
            char c2 = accents[i];

            if (c1 == c2)
                markedUpWordOrPhrase += c1;
            else
                markedUpWordOrPhrase += MarkUpChar(c1, formatString);
        }

        return markedUpWordOrPhrase;
    }

    private static string MarkUpChar(char c, string formatString)
    {
        //return "<font color=\\\"yellow\\\">" + c + "</font>";

        return string.Format(formatString, c);
    }
}

public class Script
{
    public const string script =
@"

<style>

.menu
{
  font-family: Tahmoa, Verdana, Helvetica;
  font-size: 11px;
  color: <<MENUTEXT_COLOR>>;
  background-color: #aaaaaa;
}
.menu2
{
  font-family: Tahmoa, Verdana, Helvetica;
  font-size: 11px;
  color: <<HIDEBUTTON_COLOR>>;
}
.clickable
{
  font-weight: bold;
}

p
{
  top:45%;
  left:5%;
  width:90%;
  line-height:90px;
  margin-top:-1em;
  text-align:center;
  position:absolute;
  color: <<TEXT_COLOR>>;
  font-size: 76px;
}

body
{
  background-color: <<BACKGROUND_COLOR>>;
  color: <<TEXT_COLOR>>;
  <<BACKGROUND_IMAGE>>
}

a
{
  cursor:pointer;
}
</style>

<script type=""text/javascript"">

var wordIsShown = false;
var numElements = <<NUM_ELEMENTS>>;
var currentIndex = Math.floor(Math.random() * numElements);
var wordArray = new Array(numElements);
var translationArray = new Array(numElements);
var timeout;
var started = true;
var flashInterval = <<SPEED>>;
var startWithWord = <<DIRECTION>>;
var showSettings = <<SHOW_SETTINGS>>;
var doRandom = <<RANDOM>>;
var accentsOn = <<ACCENTS>>;
var entryMarkupType = ""<<ENTRY_MARKUP_TYPE>>"";

if (doRandom == false)
{
  currentIndex = 0;
}

<<ARRAY_ASSIGNMENTS>>

function flash()
{

  var txt = document.getElementById(""wordOrTranslation"");

  if (wordIsShown)
  {
    if (startWithWord)
      txt.innerHTML = translationArray[currentIndex];
    else
      txt.innerHTML = wordArray[currentIndex];
    currentIndex = getNextIndex();
  }
  else
  {
    if (startWithWord)
      txt.innerHTML = wordArray[currentIndex];
    else
      txt.innerHTML = translationArray[currentIndex];
  }

  wordIsShown = !wordIsShown;

  timeout = setTimeout(""flash()"", flashInterval);
}

function getNextIndex()
{
  if (numElements == 1)
    return 0;

  if (doRandom)
  {
    var nextIndex = currentIndex;

    while (nextIndex == currentIndex)
    {
      nextIndex = Math.floor(Math.random() * numElements);
    }

    return nextIndex;
  }
  else
  {
    if (currentIndex < numElements - 1)
      return currentIndex + 1;
    else
      return 0;
  }
}

function stopOrStart()
{
  if (started)
  {
    clearTimeout(timeout);
    document.getElementById(""stopOrStart"").innerHTML = ""Resume"";
  }
  else
  {
    document.getElementById(""stopOrStart"").innerHTML = ""Stop"";
    flash();
  }

  started = !started;
}

function speedUp()
{
  if (flashInterval > 250)
  {
    flashInterval = flashInterval - 250;
    document.getElementById(""seconds"").innerHTML = flashInterval / 1000.0;
  }
}

function slowDown()
{
  if (flashInterval < 1000 * 20)
  {
    flashInterval = flashInterval + 250;
    document.getElementById(""seconds"").innerHTML = flashInterval / 1000.0;
  }
}

function switchDirection()
{
  clearTimeout(timeout);

  startWithWord = !startWithWord;
  wordIsShown = false;
  currentIndex = getNextIndex();

  var instructions = document.getElementById(""direction"");
  var mainWord = document.getElementById(""wordOrTranslation"");

  if (startWithWord)
  {
    instructions.innerHTML = ""Front to Back"";
    mainWord.innerHTML = ""Front to Back"";
  }
  else
  {
    instructions.innerHTML = ""Back to Front"";
    mainWord.innerHTML = ""Back to Front"";
  }

  started = true;
  document.getElementById(""stopOrStart"").innerHTML = ""Stop"";
  timeout = setTimeout(""flash()"", 1500);
}

function showOrHide()
{
  showSettings = !showSettings;

  var showHide = document.getElementById(""showOrHide"");
  var settings = document.getElementById(""settings"");

  if (showSettings)
  {
    showHide.innerHTML = ""<b>Hide</b>"";
    settings.style.visibility = ""Visible"";
  }
  else
  {
    showHide.innerHTML = ""<b>+</b>"";
    settings.style.visibility = ""Hidden"";
  }

}

function setIndexMethod()
{
  clearTimeout(timeout);

  doRandom = !doRandom;

  var order = document.getElementById(""order"");
  var mainWord = document.getElementById(""wordOrTranslation"");

  if (doRandom)
  {
    order.innerHTML = ""Random"";
    mainWord.innerHTML = ""Random"";
  }
  else
  {
    order.innerHTML = ""In order"";
    currentIndex = 0;
    mainWord.innerHTML = ""In order"";
  }

  started = true;
  document.getElementById(""stopOrStart"").innerHTML = ""Stop"";
  timeout = setTimeout(""flash()"", 1500);
}

function toggleAccents()
{ 
  accentsOn = !accentsOn;
  var accents = document.getElementById(""accents"");

  if (entryMarkupType == ""highlights"")
  {
    if (accentsOn)
    {
      for (i = 0; i < wordArray.length; i++)
      {
        wordArray[i] = wordArray[i].replace(/<<TEXT_COLOR>>/g, ""<<ACCENT_COLOR>>"");
        translationArray[i] = translationArray[i].replace(/<<TEXT_COLOR>>/g, ""<<ACCENT_COLOR>>"");
      }
      accents.innerHTML = ""Remove Accents"";
    }
    if (!accentsOn)
    {
      for (i = 0; i < wordArray.length; i++)
      {
        wordArray[i] = wordArray[i].replace(/<<ACCENT_COLOR>>/g, ""<<TEXT_COLOR>>"");
        translationArray[i] = translationArray[i].replace(/<<ACCENT_COLOR>>/g, ""<<TEXT_COLOR>>"");
      }
      accents.innerHTML = ""Use Accents"";
    }
  }
  if (entryMarkupType == ""accents"")
  {
    if (accentsOn)
    {
      for (i = 0; i < wordArray.length; i++)
      {
        wordArray[i] = wordArray[i].replace(/: Hidden/g, "": Visible"");
        translationArray[i] = translationArray[i].replace(/: Hidden/g, "": Visible"");
      }
      accents.innerHTML = ""Remove Accents"";
    }
    if (!accentsOn)
    {
      for (i = 0; i < wordArray.length; i++)
      {
        wordArray[i] = wordArray[i].replace(/: Visible/g, "": Hidden"");
        translationArray[i] = translationArray[i].replace(/: Visible/g, "": Hidden"");
      }
      accents.innerHTML = ""Use Accents"";
    }
  }
  
  
}

</script>



</head>

<body onLoad=""flash()"">


  <a class=""menu2"" id=""showOrHide"" onClick=""showOrHide();""><<SHOW_OR_HIDE>></a>
  <div class=""menu"" id=""settings"" style=""visibility:<<SETTINGS_VISIBILITY>>; padding: 5px; border:1px solid <<MENUTEXT_COLOR>>; width: 175px"">
    Lesson: <<LESSON_NAME>><br />
    <hr />
    <a href=""#"" class=""clickable"" id=""stopOrStart"" onClick=""stopOrStart();"">Stop</a><br />
    Speed:
    <a href=""#"" class=""clickable"" id=""faster"" onClick=""speedUp();""><img border=""0"" src=""images/faster.gif"" /></a> <a href=""#"" class=""clickable"" id=""slower"" onClick=""slowDown();""><img border=""0"" src=""images/slower.gif"" /></a>
    &nbsp;<span id=""seconds""><<SECONDS>></span> sec/card
<br />
    <a href=""#"" class=""clickable"" id=""switchDirection"" onClick=""switchDirection();"">Direction:</a> <span id=""direction""><<DIRECTION_STR>></span><br />
    <a href=""#"" class=""clickable"" id=""inOrderOrRandom"" onClick=""setIndexMethod();"">Order:</a> <span id=""order""><<IN_ORDER>></span><br />
    <a href=""#"" class=""clickable"" id=""accents"" onClick=""toggleAccents();""><<ACCENTS_STR>> </a><br /><hr />
    <<SETTINGS_AND_ENTRIES>>
    <a href=""mylessons.aspx"">My Lessons</a><br />
    <a href=""start.aspx"">Dashboard</a><br /><br />
    <<FACEBOOKLIKEBUTTON>><br /><br />
    <<TWEETBUTTON>>
  </div>

  <p><span id=""wordOrTranslation""></span></p>

</body>
";

}
