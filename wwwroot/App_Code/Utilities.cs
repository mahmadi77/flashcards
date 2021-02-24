using System;
using Moa.RussianFlashCards.Data.Dao;

public class Utilities
{
    public static string FormatAnchorTag(string text, string href)
    {
        return String.Format(Constants.Anchor, href, text);
    }

    public static Dao NewDao()
    {
        return new Dao(Configuration.Connection);
    }

    public static int GetUserId(string userIdGuid)
    {
        return int.Parse(userIdGuid.Replace(Common.UserIdGuid, ""));
    }
}
