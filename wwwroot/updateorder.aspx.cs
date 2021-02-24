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

public partial class updateorder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);
        string sortablecards = Request.Form["sortablecards[]"];
        string[] S = sortablecards.Split(',');
        for (int i = 0; i < S.Length; i++)
        {
            string entry = S[i];
            int entryId = 0;
            try
            {
                entryId = int.Parse(entry);
            }
            catch (Exception)
            {
                continue;
            }

            if (entryId != 0)
                dao.UpdateEntryOrder(entryId, i + 1);
        }

        
    }
}
