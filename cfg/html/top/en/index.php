<!-- the naming of small files to create a GUI for XS has gotten completely out of  hand. 
The following nameing convention will be adopted:
 	Four regions of the screen -- top, left, center, right -> top, nav, cntr, help
    Four categories of function -- setup, reports, upload, server, miscellaneous -> set, rpt, upl, srv, misc
-->
<?php 
function is_xo() {
	if (file_exists("/proc/device-tree/mfg-data/MN")) return true; else return false;
}
$browser = get_browser(null, true);
//die(print_r($browser));
?>

<html>
<head>
<meta name="description" content="SchoolServer">
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<title>School Server Remote Access</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/javascript">

//a variable to keep track of the vnc window
var vncwin = null;
var test = "";

function setup_click() {
	var nav=document.getElementById("formframe");
	nav.src="cntr_set_pick_services.php";
}
function classroom_click() {
	var nav=document.getElementById("formframe");
	nav.src="cntr_rpt_registrations.php";
}
function upload_click() {
	var nav=document.getElementById("formframe");
	nav.src="cntr_upl_activity.php";
}
function status_click() {
	var nav=document.getElementById("formframe");
	nav.src="cntr_rpt_services.php";
}
</script>
<script language="JavaScript" type="text/JavaScript" src="../vnc.js"></script>
</head>
<body onLoad="define_var()">
	<iframe src="SS_banner.html" name="topframe" height="190px" width="100%"  marginwidth="0"  frameborder="0"></iframe>
    <div class="nav" height="40px" width="100%">
    <table width="100%" align="center" border="0">
  <tr>
    <td width="10%">&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="10%"><a class="nav" href="nav_set.html" target="navigation" onClick="setup_click()">Setup</a></td>
    <td width="10%"><a class="nav" href="nav_rpt_classroom.html" target="navigation" onClick="classroom_click()">Classroom</a></td>
    <td width="10%">&nbsp;</td>
    <td width="10%"><a class="nav" href="nav_upl.html" target="navigation" onClick="upload_click()">Upload</a></td>
    <td width="10%"><a class="nav" href="nav_srv.html"target="navigation" onClick="status_click()">Status</a></td>
    <td width="10%"><a href="" onClick="peervnc()">test</a></td>
    <td width="20%">
    <a class="nav" href="/novnc/vnc_auto.html?HOST=172.18.96.1&port=6080&true_color=1" target="_blank">Desktop</a><br />
</td>
  </tr>
</table></div>
    <iframe src="nav_set.html" name="navigation" id="navigation" class="nav" width="17%" height="100%" noresize frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
    <iframe src="cntr_set_pick_services.php" name="formframe" id="formframe" width="56%" height="100%" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
    <iframe src="SS_blank.html" name="helpframe" class="help" width="24%" height="100%" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe> 
</body>               
</html>

