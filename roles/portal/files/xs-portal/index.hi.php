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
<h1>स्वागतम् Welcome to the School Server</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
<p>
		
यह पृष्ठ हिंदी में होना चाहिए

<p>	
<br><h2>Interesting Things You Can Do Here:</h2>

<?php service_link("pathagar", "Read Books on पाठागार", "Ipsum "); ?>
<?php // iiab_link("Internet In A Box", 
//                "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily.",
//                "Searching for Internet In A Box"); 
?>
<?php service_link("iiab", "Internet In A Box", "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily."); ?>
<?php service_link("moodle","मूडल्","लोरेम इप्सुम dolor sit amet, consectetur dipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non "); ?>
<?php service_link("upload", "Upload", "Lorem Ipsum"); ?>
<?php service_link("activity-server", "Download an Activity", "Lorem Ipsum"); ?>

<BR> Enjoy Exploring!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
