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
using System.Net.Mail;
using Moa.RussianFlashCards.Data.Dao;

public partial class forgotpassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        string verificationGuid = Guid.NewGuid().ToString();
        string verificationUrl = "http://www.xublimynal.com/resetpassword.aspx?reset=" + verificationGuid;

        dao.UpdateVerificationGuid(txtEmail.Text.Trim(), verificationGuid);

        SendEmail(txtEmail.Text.Trim(), verificationUrl);

        Response.Redirect("passwordemail.aspx");
    }

    private void SendEmail(string emailAddress, string verificationUrl)
    {
        MailMessage message = new MailMessage();
        message.Body = String.Format(Configuration.PasswordResetEmailBody, verificationUrl);
        message.Subject = Configuration.PasswordResetEmailSubject;
        message.To.Add(emailAddress);
        message.From = new MailAddress(Configuration.PasswordResetEmailFrom);

        SmtpClient client = new SmtpClient("localhost");

        try
        {
            client.Send(message);
        }
        catch (Exception)
        {
            Response.Write("There was an error with the password reset process.  Please send an email to mail@xublimynal.com.");
        }
    }
}
