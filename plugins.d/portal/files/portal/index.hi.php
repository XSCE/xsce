<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.4.2.min.js"></script>
    <link href="rotate.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript">
      $(window).load(function() {
        startRotator("#rotator");
      })
      function rotateBanners(elem) {
  var active = $(elem+" img.active");
  var next = active.next();
  if (next.length == 0) 
    next = $(elem+" img:first");
  active.removeClass("active").fadeOut(200);
  next.addClass("active").fadeIn(200);
}
 
function prepareRotator(elem) {
  $(elem+" img").fadeOut(0);
  $(elem+" img:first").fadeIn(0).addClass("active");
}
 
function startRotator(elem) {
  prepareRotator(elem);
  setInterval("rotateBanners('"+elem+"')", 2500);
}

    </script>


<TITLE>Welcome to the School Server</TITLE>

</HEAD>
<BODY>
<div id="wrapper">	
<h1>स्वागतम् Welcome to the School Server</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
<br><h2>Interesting Things You Can Do Here:</h2>

<?php service_link("pathagar", "Read Books on पाठागार", "Ipsem "); ?>
<?php iiab_link("Internet In A Box", "Ipsem Lorem"); ?>
<?php service_link("moodle-xs","मूडल्","लोरेम इप्सुम dolor sit amet, consectetur dipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non "); ?>
<?php service_link("upload", "Upload", "Ipsem Lorem"); ?>
<?php service_link("activity-server", "Download an Activity", "Ipsem Lorem"); ?>
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>

</HTML>
