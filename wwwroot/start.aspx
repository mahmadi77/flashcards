<%@ Page Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="start.aspx.cs" Inherits="start" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<span class="font1">Flashcard Dashboard</span>
<br /><br />
<span class="font1" style="font-size: 12px;"><b>Here's your stuff</b></span>

</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    <table align="center">
    <tr><td><a href="mylessons.aspx">My Lessons</a></td><td>-</td><td>Individual lessons.<!--Lessons you've made from scratch or public lessons that you've added and tweaked.--></td></tr>
    <tr><td><a href="mylessongroups.aspx">My Lesson Groups</a></td><td>-</td><td>Groups of lessons you've chained together to create larger studying blocks.</td></tr>
    <tr><td><a href="demolessons.aspx">Demo Lessons</a></td><td>-</td><td>Lessons to help you get some ideas about all you can do.</td></tr>
    <tr><td><a href="myaccount.aspx">My Account</a></td><td>-</td><td>The settings to your account.</td></tr>
    <tr><td><a href="subscribe.aspx?cd=gen">Subscription options</a></td><td>-</td><td>Subscribers can create more lessons and the lessons don't expire.</td></tr>
    <tr><td><a href="mailto:mail@xublimynal.com">Contact us</a></td><td>-</td><td>Questions, comments, whatever.</td></tr>
    <!-- 
    <tr><td><a href="register.aspx">Register</a></td><td>-</td><td>If you haven't registered, do so now.  It's free.</td></tr>
    -->
    </table>
    

</asp:Content>

