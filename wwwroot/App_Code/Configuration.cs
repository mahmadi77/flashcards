using System;
using System.Configuration;
using System.Data;
using Moa.RussianFlashCards.Data.Dao;

public class Configuration
{
    private static string registrationEmailSubject;
    private static string registrationEmailBody;
    private static string registrationEmailFrom;

    private static string passwordResetEmailSubject;
    private static string passwordResetEmailBody;
    private static string passwordResetEmailFrom;

    private static string accentMarkup;
    private static string highlightMarkup;

    private static int numLessonsPerPage;

    private static int cookieExpiration;

    private static string connection;

    public static string RegistrationEmailSubject
    {
        get { return registrationEmailSubject; }
        set { registrationEmailSubject = value; }
    }

    public static string RegistrationEmailBody
    {
        get { return registrationEmailBody; }
        set { registrationEmailBody = value; }
    }

    public static string RegistrationEmailFrom
    {
        get { return registrationEmailFrom; }
        set { registrationEmailFrom = value; }
    }

    public static string PasswordResetEmailSubject
    {
        get { return passwordResetEmailSubject; }
        set { passwordResetEmailSubject = value; }
    }

    public static string PasswordResetEmailBody
    {
        get { return passwordResetEmailBody; }
        set { passwordResetEmailBody = value; }
    }

    public static string PasswordResetEmailFrom
    {
        get { return passwordResetEmailFrom; }
        set { passwordResetEmailFrom = value; }
    }

    public static string AccentMarkup
    {
        get { return accentMarkup; }
        set { accentMarkup = value; }
    }

    public static string HighlightMarkup
    {
        get { return highlightMarkup; }
        set { highlightMarkup = value; }
    }

    public static int NumLessonsPerPage
    {
        get { return numLessonsPerPage; }
        set { numLessonsPerPage = value; }
    }

    public static int CookieExpiration
    {
        get { return cookieExpiration; }
        set { cookieExpiration = value; }
    }

    public static string Connection
    {
        get { return connection; }
        set { connection = value; }
    }

    /* When you use a 3.0 compiler
     * 
    public static string RegistrationEmailSubject { get; set; }
    public static string RegistrationEmailBody { get; set; }
    public static string RegistrationEmailFrom { get; set; }
     * 
     */
    
    static Configuration()
	{
        // Initialize all the configuration settings
        RegistrationEmailBody = "";
        RegistrationEmailFrom = "";
        RegistrationEmailSubject = "";

        PasswordResetEmailBody = "";
        PasswordResetEmailFrom = "";
        PasswordResetEmailSubject = "";

        AccentMarkup = "";
        HighlightMarkup = "";

        NumLessonsPerPage = 100;
        CookieExpiration = 60 * 60 * 24 * 7 * 6;

        Connection = ConfigurationManager.AppSettings["Conn"];

        // Get the settings from the db
        Dao dao = Utilities.NewDao();
        DataTable dt = dao.GetConfigurationSettings();

        // Set the settings
        foreach (DataRow dr in dt.Rows)
        {
            string key = dr["Key"].ToString();
            string value = dr["Value"].ToString();

            switch (key)
            {
                case "Registration.Email.Subject":
                    RegistrationEmailSubject = value;
                    break;
                case "Registration.Email.Body":
                    RegistrationEmailBody = value;
                    break;
                case "Registration.Email.From":
                    RegistrationEmailFrom = value;
                    break;
                case "ForgotPassword.Email.Subject":
                    PasswordResetEmailSubject = value;
                    break;
                case "ForgotPassword.Email.Body":
                    PasswordResetEmailBody = value;
                    break;
                case "ForgotPassword.Email.From":
                    PasswordResetEmailFrom = value;
                    break;
                case "AccentMarkup":
                    AccentMarkup = value;
                    break;
                case "HighlightMarkup":
                    HighlightMarkup = value;
                    break;
                case "NumLessonsPerPage":
                    try
                    {
                        NumLessonsPerPage = int.Parse(value);
                    }
                    catch (Exception)
                    {
                    }
                    break;
                case "CookieExpiration":
                    try
                    {
                        CookieExpiration = int.Parse(value);
                    }
                    catch (Exception)
                    {
                    }
                    break;
            }
        }
	}
}
