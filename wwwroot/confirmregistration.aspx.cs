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

public partial class confirmregistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());

        Dao dao = Utilities.NewDao();

        string verificationGuid = Request.QueryString["verification"];

        dao.UpdateVerified(verificationGuid);

        DataTable dt = dao.ValidateUserInfoFromGuid(verificationGuid);

        if (dt.Rows.Count < 1)
            Response.Write("Error during validation.");

        int userId = (int)dt.Rows[0]["UserId"];
        string userName = dt.Rows[0]["UserName"].ToString();

        // If the login info is valid
        if (userId != -1)
        {
            // Give the response cookies
            Response.Cookies[Constants.CookieKeys.UserIsLoggedIn].Value = Common.LoggedInGuid;
            int seconds = int.Parse(ConfigurationManager.AppSettings["CookieExpiration"]);
            DateTime now = DateTime.Now;
            Response.Cookies[Constants.CookieKeys.UserIsLoggedIn].Expires = now.AddSeconds(seconds);
            Response.Cookies[Constants.CookieKeys.UserId].Value = Common.UserIdGuid + userId.ToString();
            Response.Cookies[Constants.CookieKeys.UserId].Expires = now.AddSeconds(seconds);
            Response.Cookies[Constants.CookieKeys.UserName].Value = userName;
            Response.Cookies[Constants.CookieKeys.UserName].Expires = now.AddSeconds(seconds);

        }
    }
}
