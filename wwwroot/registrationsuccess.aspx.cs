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

public partial class registrationsuccess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());

        Dao dao = Utilities.NewDao();

        string verificationGuid = Request.QueryString["verified"];

        dao.UpdateVerified(verificationGuid);
    }
}
