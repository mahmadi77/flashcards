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

public partial class myaccount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

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

        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the user account info
        DataTable dtUser = dao.GetUser(userId);

        if (dtUser.Rows.Count < 1)
            return;

        string username = dtUser.Rows[0]["UserName"].ToString();

        lblUsername.Text = username;

        // Get the user lesson settings
        DataTable dtSettings = dao.GetUserSettings(userId);

        // If the user doesn't have settings, insert new ones
        if (dtSettings.Rows.Count < 1)
        {
            dao.InsertUserSettings(userId);

            dtSettings = dao.GetUserSettings(userId);
        }
        
        bool shared = (bool)dtSettings.Rows[0]["Public"];
        bool showSettings = (bool)dtSettings.Rows[0]["SettingsMenuShown"];
        int speed = (int)dtSettings.Rows[0]["Speed"];
        bool direction = (bool)dtSettings.Rows[0]["Direction"];
        bool inOrder = (bool)dtSettings.Rows[0]["InOrder"];
        bool accentsOn = (bool)dtSettings.Rows[0]["AccentsOn"];
        int themeId = (int)dtSettings.Rows[0]["ThemeId"];
        string entryMarkupType = dtSettings.Rows[0]["EntryMarkupType"].ToString();

        lblShareLessons.Text = shared ? "shared." : "private.";
        lblSettingsMenuShown.Text = showSettings ? "be shown." : "be hidden.";
        txtSpeed.Text = String.Format("{0:0.00}", speed / 1000.0);
        lblDirection.Text = !direction ? "front to back." : "back to front.";
        lblInOrder.Text = inOrder ? "in order." : "at random.";
        lblAccents.Text = accentsOn ? "be shown." : "be hidden.";

        ddlAccents.Items.Add(new ListItem("accent marks", "A"));
        ddlAccents.Items.Add(new ListItem("highlights", "H"));
        ddlAccents.SelectedValue = entryMarkupType;

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
    protected void lbEditShare_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.Shared);
    }
    protected void lbEditSettingsMenuShown_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.ShowSettings);
    }
    protected void lbEditSpeed_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.Speed);
    }
    protected void lbEditDirection_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.Direction);
    }
    protected void lbEditInOrder_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.InOrder);
    }
    protected void lbEditAccents_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.AccentsOn);
    }

    private void Toggle(Common.UserLessonSettings userLessonSettings)
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

        // Create the Dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the user lesson settings
        DataTable dtSettings = dao.GetUserSettings(userId);

        // If the user doesn't have settings, insert new ones
        if (dtSettings.Rows.Count < 1)
        {
            dao.InsertUserSettings(userId);

            dtSettings = dao.GetUserSettings(userId);
        }

        bool shared = (bool)dtSettings.Rows[0]["Public"];
        bool showSettings = (bool)dtSettings.Rows[0]["SettingsMenuShown"];
        int speed = (int)dtSettings.Rows[0]["Speed"];
        bool direction = (bool)dtSettings.Rows[0]["Direction"];
        bool inOrder = (bool)dtSettings.Rows[0]["InOrder"];
        bool accentsOn = (bool)dtSettings.Rows[0]["AccentsOn"];
        int themeId = (int)dtSettings.Rows[0]["ThemeId"];
        string entryMarkupType = dtSettings.Rows[0]["EntryMarkupType"].ToString();

        switch (userLessonSettings)
        {
            case Common.UserLessonSettings.Shared:
                shared = !shared;
                break;
            case Common.UserLessonSettings.ShowSettings:
                showSettings = !showSettings;
                break;
            case Common.UserLessonSettings.Speed:
                try
                {
                    speed = (int)(double.Parse(txtSpeed.Text.Trim()) * 1000);
                }
                catch (Exception)
                {
                }
                break;
            case Common.UserLessonSettings.Direction:
                direction = !direction;
                break;
            case Common.UserLessonSettings.InOrder:
                inOrder = !inOrder;
                break;
            case Common.UserLessonSettings.AccentsOn:
                accentsOn = !accentsOn;
                break;
            case Common.UserLessonSettings.ThemeId:
                try
                {
                    themeId = int.Parse(ddlTheme.SelectedValue);
                }
                catch (Exception)
                {
                }
                break;
            case Common.UserLessonSettings.EntryMarkupType:
                entryMarkupType = ddlAccents.SelectedValue;
                break;
        }

        dao.UpdateUserSettings(userId, shared, showSettings, speed, direction, inOrder, accentsOn, themeId, entryMarkupType);

        lblShareLessons.Text = shared ? "shared." : "private.";
        lblSettingsMenuShown.Text = showSettings ? "be shown." : "be hidden.";
        txtSpeed.Text = String.Format("{0:0.00}", speed / 1000.0);
        lblDirection.Text = !direction ? "front to back." : "back to front.";
        lblInOrder.Text = inOrder ? "in order." : "at random.";
        lblAccents.Text = accentsOn ? "be shown." : "be hidden.";
        ddlAccents.SelectedValue = entryMarkupType;

        ddlTheme.SelectedValue = themeId.ToString();
    }
    protected void lbEditTheme_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.ThemeId);
    }
    protected void lbEditMarkupType_Click(object sender, EventArgs e)
    {
        Toggle(Common.UserLessonSettings.EntryMarkupType);
    }
}
