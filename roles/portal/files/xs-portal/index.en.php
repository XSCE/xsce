<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>

<TITLE>Welcome to the School Server</TITLE>

</HEAD>
<BODY>
<div id="wrapper">	
<h1>Welcome to the School Server</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
<br><h2>Interesting Things You Can Do Here:</h2>

<?php service_link("pathagar", "Read Books on Pathagar", "Pathagar is a Book Server that contains a local collection of books that you can read without downloading them from the internet."); ?>
<?php hard_link("/content", "Access Other Content", "Put additional content in /library/content and any subdirectories and link to it with this function, such as syans in Haiti."); ?>
<?php // iiab_link("Internet In A Box", 
//                "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily.",
//                "Searching for Internet In A Box"); 
?>
<?php service_link("iiab", "Internet In A Box", "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily."); ?>
<?php service_link("moodle", "Moodle Home Page", "Moodle is a collection of lessons and study materials organized to help you learn many fascinating things."); ?>
<?php service_link("upload", "Upload Files", "From this link you can upload various files such as images and activities"); ?>
<?php service_link("activity-server", "Download an Activity", "You can add a new activity to your XO from this link."); ?>

<BR> Enjoy Exploring!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
