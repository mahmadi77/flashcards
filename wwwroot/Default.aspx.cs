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

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
        
        // Get the host name to set the website name correctly
        string hostname = Request.ServerVariables["HTTP_HOST"];

        lblWebsiteName.Text = "Xublimynal";

        if (hostname.ToLower().Contains("карточки"))
            lblWebsiteName.Text = "Flash Карточки";

        if (hostname.ToLower().Contains("kardz"))
            lblWebsiteName.Text = "Flash Kardz";

    }
}
