<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">

<span class="font1"><asp:Label ID="lblWebsiteName" runat="server" /></span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Make real flash cards from which to study</b></span>
<br />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      
<div class="font1" style="font-size: 12px; padding-left:200px; padding-right:50px; text-align: left;">
Not to print.<br /><br />
These actually <span style="color: #aaaa43"> <b>flash</b></span> at you on the screen.<br /><br />
You can create pretty much anything you want.<br /><br />
Speed them up, slow them down, make them random.<br /><br />
They work great on your smart phone's browser.
</div><br />

            <div style="background:url('images/boxtop300.gif');width:300px;height:20;margin:0 auto; padding: 0; border: 0;"></div>
              <div
              onmouseover="javascript:getElementById('spnPublicLessons').innerHTML='Some cards to get you started.';"
              onmouseout= "javascript:getElementById('spnPublicLessons').innerHTML='<b>Demo cards</b>';"

              style="text-align: left;background:url('images/boxmid300.gif');width:300px;margin:0 auto; padding:0; border: 0;">

                    <div style="margin-left: 20px;margin-right: 20px;padding-top:5px; text-align: center;">
                       <a style="text-decoration: none; font-family: verdana; font-size: 11px;"
                       href="demolessons.aspx"
                       id="spnPublicLessons"

                       style="font-family: verdana; font-size: 10px"><b>Demo cards</b></a>
                    </div>

              </div>
            <div style="background:url('images/boxbot300.gif');width:300px;height:20px;margin: 0 auto;"></div>

<br />
            <div style="background:url('images/boxtop300.gif');width:300px;height:20;margin:0 auto; padding: 0; border: 0;"></div>
              <div
              onmouseover="javascript:getElementById('spnMyStuff').innerHTML='Make your own sets of flashcards.';"
              onmouseout= "javascript:getElementById('spnMyStuff').innerHTML='<b>My Flashcard Dashboard</b>';"
              style="text-align: left;background:url('images/boxmid300.gif');width:300px;margin:0 auto; padding:0; border: 0;">

                    <div style="margin-left: 20px;margin-right: 20px;padding-top:5px; text-align: center;">
                       <a style="text-decoration: none; font-family: verdana; font-size: 11px;"
                       href="start.aspx"
                       id="spnMyStuff"

                       style="font-family: verdana; font-size: 10px"><b>My Flashcard Dashboard</b></a>
                    </div>

              </div>
            <div style="background:url('images/boxbot300.gif');width:300px;height:20px;margin: 0 auto;"></div>

</asp:Content>

