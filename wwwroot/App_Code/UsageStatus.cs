using System;
using System.Data;

public class UsageStatus
{
    private string description;
    private string name;
    private string code;
    private double price;
    private int maxLessons;
    private int maxEntries;
    private int maxPrivateLessons;
    private int maxLessonGroups;
    private bool viewPublicLessons;
    private DateTime endDate;
    private int currentNumLessons;
    private int currentNumPrivateLessons;
    private int currentNumLessonGroups;

    public string Description { get { return description; } set { description = value; } }
    public string Name { get { return name; } set { name = value; } }
    public string Code { get { return code ; } set { code = value; } }
    public double Price { get { return price; } set { price = value; } }
    public int MaxLessons { get { return maxLessons; } set { maxLessons = value; } }
    public int MaxEntries { get { return maxEntries; } set { maxEntries = value; } }
    public int MaxPrivateLessons { get { return maxPrivateLessons; } set { maxPrivateLessons = value; } }
    public int MaxLessonGroups { get { return maxLessonGroups; } set { maxLessonGroups = value; } }
    public bool ViewPublicLessons { get { return viewPublicLessons; } set { viewPublicLessons = value; } }
    public DateTime EndDate { get { return endDate; } set { endDate = value; } }
    public int CurrentNumLessons { get { return currentNumLessons; } set { currentNumLessons = value; } }
    public int CurrentNumPrivateLessons { get { return currentNumPrivateLessons; } set { currentNumPrivateLessons = value; } }
    public int CurrentNumLessonGroups { get { return currentNumLessonGroups; } set { currentNumLessonGroups = value; } }

    public static UsageStatus MapUsageStatus(DataRow dr)
    {
        UsageStatus us = new UsageStatus();
        us.Code = dr["Code"].ToString();
        us.CurrentNumLessonGroups = (int)dr["CurrentNumLessonGroups"];
        us.CurrentNumLessons = (int)dr["CurrentNumLessons"];
        us.CurrentNumPrivateLessons = (int)dr["CurrentNumPrivateLessons"];
        us.Description = dr["Description"].ToString();
        us.EndDate = (DateTime)dr["EndDate"];
        us.MaxEntries = (int)dr["MaxEntries"];
        us.MaxLessonGroups = (int)dr["MaxLessonGroups"];
        us.MaxLessons = (int)dr["MaxLessons"];
        us.MaxPrivateLessons = (int)dr["MaxPrivateLessons"];
        us.Name = dr["Name"].ToString();
        us.Price = (double)dr["Price"];
        us.ViewPublicLessons = (bool)dr["ViewPublicLessons"];
        return us;
    }
}
