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
using System.Text.RegularExpressions;

using Moa.RussianFlashCards.Data.Dao;

public partial class editentry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Create the dao
            Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

            int entryId = int.Parse(Request.QueryString["entryid"]);
            int lessonId = int.Parse(Request.QueryString["lessonid"]);

            DataTable dt = dao.GetLessonEntry(entryId);

            if (dt.Rows.Count < 1)
                Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);

            string front = dt.Rows[0]["Entry"].ToString();
            string back = dt.Rows[0]["Translation"].ToString();
            string accentsFront = dt.Rows[0]["Accents"].ToString();
            string accentsBack = dt.Rows[0]["AccentsBack"].ToString();

            if (accentsFront != "" && accentsFront != front)
            {
                string f = "";
                for (int i = 0; i < accentsFront.Length; i++)
                {
                    if (front[i] == accentsFront[i])
                        f += front[i];
                    else
                        f += front[i] + "^";
                }
                front = f;
            }

            if (accentsBack != "" && accentsBack != back)
            {
                string b = "";
                for (int i = 0; i < accentsBack.Length; i++)
                {
                    if (back[i] == accentsBack[i])
                        b += back[i];
                    else
                        b += back[i] + "^";
                }
                back = b;
            }

            txtFront.Text = front;
            txtBack.Text = back;

            //if ((txtAccents.Text.Length == 0 && txtAccentsBack.Text.Length == 0) || (txtFront.Text == txtAccents.Text && txtBack.Text == txtAccentsBack.Text))
            //{
            //    accentsDiv.Attributes.Add("style", "visibility: hidden; background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px;");
            //    ltlAccents.Text = "Create accent pattern";
            //}
            //else
            //{
            //    accentsDiv.Attributes.Add("style", "background-color: #cecece; border: 1px solid #cccccc; margin-left: 50px; margin-right: 50px;");
            //    ltlAccents.Text = "Hide";
            //}
        }
    }
    protected void btnUpdateEntry_Click(object sender, EventArgs e)
    {
        //if (txtFront.Text.Trim().Length != txtAccents.Text.Trim().Length && txtAccents.Text.Trim().Length != 0)
        //{
        //    lblError.Text = "The accent pattern for the front is not the same length as the text on the front of the card.";
        //    return;
        //}
        //if (txtBack.Text.Trim().Length != txtAccentsBack.Text.Trim().Length && txtAccentsBack.Text.Trim().Length != 0)
        //{
        //    lblError.Text = "The accent pattern for the back is not the same length as the text on the back of the card.";
        //    return;
        //}

        int lessonId = int.Parse(Request.QueryString["lessonid"]);
        int entryId = int.Parse(Request.QueryString["entryid"]);

        // Create the dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);


        string front = txtFront.Text.Trim();
        string back = txtBack.Text.Trim();
        string accentsFront = null;
        string accentsBack = null;

        if (front.Contains("^"))
        {
            front = Regex.Replace(front, @"\^+", "^");
            accentsFront = Regex.Replace(front, @".\^", "^");
            front = front.Replace("^", "");

            if (accentsFront.Length != front.Length)
                throw new Exception("Accent pattern on front not same length as front of card.");
        }
        if (back.Contains("^"))
        {
            back = Regex.Replace(back, @"\^+", "^");
            accentsBack = Regex.Replace(back, @".\^", "^");
            back = back.Replace("^", "");

            if (accentsBack.Length != back.Length)
                throw new Exception("Accent pattern on back not same length as back of card.");
        }

        dao.UpdateLessonEntry(
            entryId,
            front,
            back,
            accentsFront,
            accentsBack
            );


        Response.Redirect("lessonentries.aspx?lessonid=" + lessonId);
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("lessonentries.aspx?lessonid=" + Request.QueryString["lessonid"]);
    }
}
