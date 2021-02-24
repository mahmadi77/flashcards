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
using System.Net.Mail;

using Moa.RussianFlashCards.Data.Dao;

public partial class register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Add this page to the list of public pages so master page won't check cookies
        if (!Common.PublicPages.Contains(this.Page.ToString()))
            Common.PublicPages.Add(this.Page.ToString());
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // Validate the info
        string email1 = txtEmail.Text.Trim().ToLower();
        string email2 = txtEmailVerify.Text.Trim().ToLower();
        string password1 = txtPassword.Text.Trim().ToLower();
        string password2 = txtPasswordVerify.Text.Trim().ToLower();
        string userName = txtUsername.Text.Trim();
        ValidationResult result = ValidateRegistrationInfo(email1, email2, password1, password2, userName);

        // If validation fails
        if (!result.Valid)
        {
            // Show the error message
            lblError.Text = result.Message;
            lblError.Visible = true;
        }
        // On success
        else
        {
            // Create a verification GUID
            string verificationGuid = Guid.NewGuid().ToString() + "_" + userName;
            
            // Insert the user
            Dao dao = Utilities.NewDao();
            int userId = dao.InsertUser(userName, email1, password1, verificationGuid, false);
            
            // Send a verification email
            SendEmail(email1, "http://www.xublimynal.com/confirmregistration.aspx?verification=" + verificationGuid);

            // Redirect to the main page
            Response.Redirect("register2.aspx");
        }
    }

    private ValidationResult ValidateRegistrationInfo(string email1, string email2, string password1, string password2, string userName)
    {
        // Email should be filled out
        if (email1 == "")
            return new ValidationResult(false, "Plesae enter your email address.");

        // Password should be filled out
        if (password1 == "")
            return new ValidationResult(false, "Please enter a password.");

        // Username should be filled out
        if (userName == "")
            return new ValidationResult(false, "Please enter a username.");
        
        // Emails should match
        if (email1 != email2)
            return new ValidationResult(false, "Email addresses don't match!");
        
        // Passwords should match
        if (password1 != password2)
            return new ValidationResult(false, "Passwords don't match!");

        // Password should be at least 6 characters
        if (password1.Length < 6)
            return new ValidationResult(false, "Password should be at least 6 characters.");

        // Email should be a valid email address
        if (!ValidateEmailAddress(email1))
            return new ValidationResult(false, "Please enter a valid email address.");

        // Check to see if email already in db
        // Check to see if username already in db
        ValidationResult usernameAndEmail = ValidateUserExistence(userName, email1);
        if (!usernameAndEmail.Valid)
            return usernameAndEmail;

        // Success
        return new ValidationResult(true, "");
    }

    private bool ValidateEmailAddress(string email)
    {
        Match match = Regex.Match(email, ".*?@.*?[.].*?");
        return match.Success;
    }

    private ValidationResult ValidateUserExistence(string username, string email)
    {
        // Create a dao
        Dao dao = new Dao(ConfigurationManager.AppSettings["Conn"]);

        // Get the data table
        DataTable dt = dao.ExistsUser(username, email);

        // Get the fields
        int numUsers = (int)dt.Rows[0]["NumUsernames"];
        int numEmails = (int)dt.Rows[0]["NumEmails"];

        // Validate email
        if (numEmails > 0)
            return new ValidationResult(false, "That email address is already registered.");

        // Validate username
        if (numUsers > 0)
            return new ValidationResult(false, "That username is already taken.");

        // Return success
        return new ValidationResult(true, "");

    }

    public class ValidationResult
    {
        public bool Valid;
        public string Message;

        public ValidationResult(bool valid, string message)
        {
            Valid = valid;
            Message = message;
        }
    }

    private void SendEmail(string emailAddress, string verificationUrl)
    {
        MailMessage message = new MailMessage();
        message.Body = String.Format(Configuration.RegistrationEmailBody, verificationUrl);
        message.Subject = Configuration.RegistrationEmailSubject;
        message.To.Add(emailAddress);
        message.From = new MailAddress(Configuration.RegistrationEmailFrom);

        SmtpClient client = new SmtpClient("localhost");

        try
        {
            client.Send(message);
        }
        catch (Exception)
        {
            Response.Write("There was an error with the registration process.  Please send an email to mail@xublimynal.com.");
        }
    }
}

