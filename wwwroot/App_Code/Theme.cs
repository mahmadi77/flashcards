public class Theme
{
    private string backgroundColor;
    private string backgroundImage;
    private string textColor;
    private string hideButtonColor;
    private string menuTextColor;
    private string accentsColor;

    public string BackgroundColor
    {
        get { return backgroundColor; }
        set { backgroundColor = value; }
    }

    public string BackgroundImage
    {
        get { return backgroundImage; }
        set { backgroundImage = value; }
    }

    public string TextColor
    {
        get { return textColor; }
        set { textColor = value; }
    }

    public string HideButtonColor
    {
        get { return hideButtonColor; }
        set { hideButtonColor = value; }
    }

    public string MenuTextColor
    {
        get { return menuTextColor; }
        set { menuTextColor = value; }
    }

    public string AccentsColor
    {
        get { return accentsColor; }
        set { accentsColor = value; }
    }
}
