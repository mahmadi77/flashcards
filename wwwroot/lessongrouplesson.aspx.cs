using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Moa.RussianFlashCards.Data.Dao;

public partial class lessongrouplesson : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int lessonGroupId = int.Parse(Request.QueryString["lg"]);
        string check = Request.QueryString["checked"];
        int lessonId = int.Parse(Request.QueryString["l"]);
        bool isChecked = check.ToLower() == "true";


        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        if (isChecked)
            dao.InsertLessonGroupLesson(lessonGroupId, lessonId);
        else
            dao.DeleteLessonGroupLesson(lessonGroupId, lessonId);
    }
}
