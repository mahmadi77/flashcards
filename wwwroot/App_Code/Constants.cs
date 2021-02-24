public class Constants
{
    public class CookieKeys
    {
        public const string UserIsLoggedIn = "UILI";
        public const string UserId = "UI";
        public const string UserName = "GFY";
    }

    public class QueryStringKeys
    {
        public const string PublicLessonsPageNumber = "page";
    }

    public class UnicodeCharacters
    {
        public const char AccentMark = '\u0301';
    }

    public class Facebook
    {
        public const string LikeButtonLesson =
            "<iframe src=\"http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.xublimynal.com%2Flesson.aspx%3Flessonid%3D{0}&amp;send=false&amp;layout=button_count&amp;width=150&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:150px; height:21px;\" allowTransparency=\"true\"></iframe>";

    }

    public class Twitter
    {
        public const string TweetButtonLesson =
            "<a href=\"http://twitter.com/share\" class=\"twitter-share-button\" data-count=\"none\">Tweet</a><script type=\"text/javascript\" src=\"http://platform.twitter.com/widgets.js\"></script>";
    }
    
    public const string RoundedBox300 =
        @"
<!-- ROUNDED BOX -->
<div style=""background:url('images/boxtop300.gif');width:300px;height:20;margin:0 auto; padding: 0; border: 0;""></div>
  <div style=""text-align: left;background:url('images/boxmid300.gif');width:300px;margin:0 auto; padding:0; border: 0;"">
    <div style=""margin-left: 20px;margin-right: 20px;padding-top:5px; text-align: center;"">
       <span style=""text-decoration: none; font-family: verdana; font-size: 11px;"">
        {0}
       </span>
    </div>
  </div>
<div style=""background:url('images/boxbot300.gif');width:300px;height:20px;margin: 0 auto;""></div>
<!-- END ROUNDED BOX -->
        ";

    public const string RoundedBox200 =
    @"
<!-- ROUNDED BOX -->
<div style=""background:url('images/boxtop200.gif');width:200px;height:20;margin:0 auto; padding: 0; border: 0;""></div>
  <div style=""text-align: left;background:url('images/boxmid200.gif');width:200px;margin:0 auto; padding:0; border: 0;"">
    <div style=""margin-left: 20px;margin-right: 20px;padding-top:5px; text-align: center;"">
       <span style=""text-decoration: none; font-family: verdana; font-size: 11px;"">
        {0}
       </span>
    </div>
  </div>
<div style=""background:url('images/boxbot200.gif');width:200px;height:20px;margin: 0 auto;""></div>
<!-- END ROUNDED BOX -->
        ";


    public const string RoundedBox500 =
    @"
<!-- ROUNDED BOX -->
<div style=""background:url('images/boxtop500.gif');width:500px;height:20;margin:0 auto; padding: 0; border: 0;""></div>
  <div style=""text-align: left;background:url('images/boxmid500.gif');width:500px;margin:0 auto; padding:0; border: 0;"">
    <div style=""margin-left: 20px;margin-right: 20px;padding-top:5px; text-align: center;"">
       <span style=""text-decoration: none; font-family: verdana; font-size: 11px;"">
        {0}
       </span>
    </div>
  </div>
<div style=""background:url('images/boxbot500.gif');width:500px;height:20px;margin: 0 auto;""></div>
<!-- END ROUNDED BOX -->
        ";

    public const string Anchor = "<a href=\"{0}\">{1}</a>";

}
