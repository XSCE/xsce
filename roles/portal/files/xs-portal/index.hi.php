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
<h1>स्कूल सर्वर में आपका स्वागत है। </h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
	
<br><h2>आप यहाँ नीचे दिए गए कार्यों को कर सकते हैं:</h2>

<?php service_link("pathagar", "पाठागर पर किताबें पढ़ें", "पाठागर एक सर्वर है जिसमे आप बिना इंटरनेट से डाउनलोड करे किताबें पढ़ सक्ते हैं। "); ?>
<?php // iiab_link("Internet In A Box", 
//                "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily.",
//                "Searching for Internet In A Box"); 
?>
//<?php hard_link("/content", "Access Other Content", "Put additional content in /library/content and any subdirectories and link to it with this function, such as syans in Haiti."); ?>
<?php service_link("iiab", "इंटरनेट इन अ बॉक्स", "इंटरनेट-इन-अ-बॉक्स में आप इंटरनेट पे उपलब्ध विभिन्न प्रकार कि महत्वपूर्ण चीज़ें जैसे विकिपीडिया, नक्शे, इत्यादि पाएंगे। "); ?>
<?php service_link("moodle","मूडल्",""); ?>
<?php service_link("upload", "अपलोड", "एक्टिविटीज़ अपलोड करें"); ?>
<?php service_link("activity-server", "ऐक्टिविटी सर्वर", "आप यहाँ से अपने कंप्यूटर में नयी एक्टिविटीज़ डाउनलोड कर सकते हैं। "); ?>

<BR> खोज का आनंद लें!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
