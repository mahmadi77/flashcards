using System;
using System.Collections.Generic;
using System.Web;


public class Lesson
{
    private string lessonName;
    private int lessonId;
    private int ownerId;
    private int speed;
    private bool random;
    private bool useAccents;
    private bool direction;
    private bool showSettings;
    private EntryMarkupType entryMarkupType;
    private Theme theme;
    private bool isSingleLesson;
    private int lessonGroupId;
    private int numLessonEntriesWithAccents;

    public string LessonName
    {
        get { return lessonName; }
        set { lessonName = value; }
    }

    public int LessonId
    {
        get { return lessonId; }
        set { lessonId = value; }
    }

    public int OwnerId
    {
        get { return ownerId; }
        set { ownerId = value; }
    }

    public int Speed
    {
        get { return speed; }
        set { speed = value; }
    }

    public bool Random
    {
        get { return random; }
        set { random = value; }
    }

    public bool UseAccents
    {
        get { return useAccents; }
        set { useAccents = value; }
    }

    public bool Direction
    {
        get { return direction; }
        set { direction = value; }
    }

    public bool ShowSettings
    {
        get { return showSettings; }
        set { showSettings = value; }
    }

    public EntryMarkupType EntryMarkupType
    {
        get { return entryMarkupType; }
        set { entryMarkupType = value; }
    }

    public Theme Theme
    {
        get { return theme; }
        set { theme = value; }
    }

    public bool IsSingleLesson
    {
        get { return isSingleLesson; }
        set { isSingleLesson = value; }
    }

    public int LessonGroupId
    {
        get { return lessonGroupId; }
        set { lessonGroupId = value; }
    }

    public int NumLessonEntriesWithAccents
    {
        get { return numLessonEntriesWithAccents; }
        set { numLessonEntriesWithAccents = value; }
    }

    public Lesson()
	{
	}
}
