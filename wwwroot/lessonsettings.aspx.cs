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

public partial class lessonsettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
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


            bool isSingleLesson = Request.QueryString["lessonid"] != null && Request.QueryString["lessonid"] != "";
        
            
            // Get the lesson id from the query string
            // TODO: Handle bad lesson id
            int lessonId = -1;
            int lessonGroupId = -1;

            if (isSingleLesson)
                lessonId = int.Parse(Request.QueryString["lessonid"]);
            else
                lessonGroupId = int.Parse(Request.QueryString["lg"]);

            // 1. Make sure the lesson belongs to the user
            //    If not see if they want to make a copy to edit
            // Create the dao
            Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

            // See whether the user owns the lesson
            bool userOwns = false;
            if (isSingleLesson)
                userOwns = dao.ValidateUserOwnsLesson(userId, lessonId);
            else
                userOwns = dao.ValidateUserOwnsLessonGroup(userId, lessonGroupId);

            // 1. If the user doesn't own the lesson
            if (!userOwns)
            {
                Response.Redirect("start.aspx");
            }
            // 2. Show lesson settings with update button
            else
            {
                // Get the lesson settings
                DataTable dt = null;
                
                if (isSingleLesson)
                    dt = dao.GetLessonSettings(lessonId).Tables[0];
                else
                    dt = dao.GetLessonGroupSettings(lessonGroupId).Tables[0];

                // Get the fields
                string lessonName = dt.Rows[0]["LessonName"].ToString();
                int speed = (int)dt.Rows[0]["Speed"];
                bool inOrder = (bool)dt.Rows[0]["InOrder"];
                bool direction = (bool)dt.Rows[0]["Direction"];
                bool accentsOn = (bool)dt.Rows[0]["AccentsOn"];
                bool globallyShared = (bool)dt.Rows[0]["GloballyShared"];
                bool showSettings = (bool)dt.Rows[0]["ShowSettings"];
                int themeId = (int)dt.Rows[0]["ThemeId"];
                string entryMarkupType = dt.Rows[0]["EntryMarkupType"].ToString();

                // Display
                lblLessonName.Text = isSingleLesson ? lessonName : lessonName + " (Lesson Group)";
                
                txtLessonName.Text = lessonName;

                txtSpeed.Text = String.Format("{0}", speed / 1000.0);

                rblOrder.SelectedValue = inOrder ? "1" : "0";

                rblDirection.SelectedValue = direction ? "1" : "0";

                rblAccents.SelectedValue = entryMarkupType;

                chkShowSettings.Checked = showSettings;

                chkAccents.Checked = accentsOn;

                chkGloballyShare.Checked = globallyShared;

                // Get the themes
                DataTable dtThemes = dao.GetThemes();

                foreach (DataRow dr in dtThemes.Rows)
                {
                    string name = dr["Name"].ToString();
                    string id = dr["ThemeId"].ToString();

                    ddlTheme.Items.Add(new ListItem(name, id));
                }

                ddlTheme.SelectedValue = themeId.ToString();
            }
        }
    }


    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the lesson id from the query string
        // TODO: Handle bad lesson id
        bool isSingleLesson = Request.QueryString["lessonid"] != null && Request.QueryString["lessonid"] != "";


        // Get the lesson id from the query string
        // TODO: Handle bad lesson id
        int lessonId = -1;
        int lessonGroupId = -1;

        if (isSingleLesson)
            lessonId = int.Parse(Request.QueryString["lessonid"]);
        else
            lessonGroupId = int.Parse(Request.QueryString["lg"]);

        // TODO: Validate user input
        
        // Update the lesson
        if (isSingleLesson)
        {
            dao.UpdateLessonSettings(
                lessonId,
                txtLessonName.Text,
                (int)(double.Parse(txtSpeed.Text) * 1000),
                rblDirection.SelectedValue == "1",
                rblOrder.SelectedValue == "1",
                chkShowSettings.Checked,
                chkAccents.Checked,
                chkGloballyShare.Checked,
                int.Parse(ddlTheme.SelectedValue),
                rblAccents.SelectedValue);

            Response.Redirect("mylessons.aspx");
        }
        else
        {
            dao.UpdateLessonGroupSettings(
                lessonGroupId,
                txtLessonName.Text,
                (int)(double.Parse(txtSpeed.Text) * 1000),
                rblDirection.SelectedValue == "1",
                rblOrder.SelectedValue == "1",
                chkShowSettings.Checked,
                chkAccents.Checked,
                int.Parse(ddlTheme.SelectedValue),
                rblAccents.SelectedValue);

            Response.Redirect("mylessongroups.aspx");

        }

        
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        bool isSingleLesson = Request.QueryString["lessonid"] != null && Request.QueryString["lessonid"] != "";
        
        // Go back to my lessons
        if (isSingleLesson)
            Response.Redirect("mylessons.aspx");

        else
            Response.Redirect("mylessongroups.aspx");
    }

    protected void btnEditEntries_Click(object sender, EventArgs e)
    {

        bool isSingleLesson = Request.QueryString["lessonid"] != null && Request.QueryString["lessonid"] != "";

        if (isSingleLesson)
            Response.Redirect("lessonentries.aspx?lessonid=" + Request.QueryString["lessonid"]);
        else
            Response.Redirect("editlessongroup.aspx?lg=" + Request.QueryString["lg"]);

    }
}
