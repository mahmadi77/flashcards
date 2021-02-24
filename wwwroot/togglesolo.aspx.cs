using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

using Moa.RussianFlashCards.Data.Dao;

public partial class togglesolo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        int entryId = int.Parse(Request.QueryString["entryid"]);
        string check = Request.QueryString["checked"];
        bool isChecked = check.ToLower() == "true";


        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        dao.ToggleSolo(entryId, isChecked);
    }
}
