using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using Moa.RussianFlashCards.Data.Dao;

public class Common
{
    private static string loggedInGuid;
    private static string userIdGuid;
    private static List<string> publicPages;
    private static List<string> pagesUserNotRequiredToOwnLesson;

    public static string LoggedInGuid
    {
        get { return loggedInGuid; }
        set { loggedInGuid = value; }
    }

    public static string UserIdGuid
    {
        get { return userIdGuid; }
        set { userIdGuid = value; }
    }

    public static List<string> PublicPages
    {
        get { return publicPages; }
        set { publicPages = value; }
    }

    public static List<string> PagesUserNotRequiredToOwnLesson
    {
        get { return pagesUserNotRequiredToOwnLesson; }
        set { pagesUserNotRequiredToOwnLesson = value; }
    }
    
    static Common()
	{
        LoggedInGuid = "xtrqdtacvtqtatataxcta";//Guid.NewGuid().ToString();
        UserIdGuid = "xtasdtdsatatsdatdatsat";//Guid.NewGuid().ToString();
        PublicPages = new List<string>();
        PagesUserNotRequiredToOwnLesson = new List<string>();
	}

    public enum UserLessonSettings
    {
        Shared,
        ShowSettings,
        Speed,
        Direction,
        InOrder,
        AccentsOn,
        ThemeId,
        EntryMarkupType
    }
}
