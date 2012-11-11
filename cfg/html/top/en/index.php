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
	nav.src="pick_services.php";
}
function classroom_click() {
	var nav=document.getElementById("formframe");
	nav.src="registrations.php";
}
function tools_click() {
	var nav=document.getElementById("formframe");
	nav.src="dig.php";
}
function status_click() {
	var nav=document.getElementById("formframe");
	nav.src="cnt_service_summary.php";
}
</script>
<script language="JavaScript" type="text/JavaScript" src="../vnc.js"></script>
</head>
	<iframe src="SS_banner.html" name="topframe" height="190px" width="100%"  marginwidth="0"  frameborder="0"></iframe>
    <div class="nav" height="40px" width="100%">
    <table width="100%" align="center" border="0">
  <tr>
    <td width="20%">
    <?php if (is_xo()) { ?>
<a class="nav" href="" onClick="peervnc()">Desktop</a>
	<?php } else {?>
	    <a class="nav" href="" onClick="popvnc();">Desktop</a>
<?php } ?>
</td>
    <td width="10%"><a class="nav" href="setup_nav.html" target="navigation" onClick="setup_click()">Setup</a></td>
    <td width="10%"><a class="nav" href="classroom_nav.html" target="navigation" onClick="classroom_click()">Classroom</a></td>
    <td width="10%">&nbsp;</td>
    <td width="10%"><a class="nav" href="tools_nav.html" target="navigation" onClick="tools_click()">Tools</a></td>
    <td width="10%"><a class="nav" href="status_nav.html"target="navigation" onClick="status_click()">Status</a></td>
    <td width="10%">&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="10%">&nbsp;</td>
  </tr>
</table></div>
    <iframe src="setup_nav.html" name="navigation" id="navigation" class="nav" width="17%" height="100%" noresize frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
    <iframe src="pick_services.php" name="formframe" id="formframe" width="56%" height="100%" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
    <iframe src="SS_blank.html" name="helpframe" class="help" width="24%" height="100%" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto"></iframe>                
</html>

