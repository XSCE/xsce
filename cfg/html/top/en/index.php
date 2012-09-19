<?php
//change the language context by setting the default directory
	$url = $_SERVER['REQUEST_URI'];
	$wd = getcwd();
	$abs_url = $wd.$url;
	$i = strrpos($abs_url,"/");
	$new_dir = substr($abs_url,0,$i);
	//print($new_dir);
	chdir($new_dir);
?>
<html>
<head>
<meta name="description" content="SchoolServer">
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<title>School Server Remote Access</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>

<!--<frameset rows="112,*"> _-->
<frameset rows="170,*"> 
	<frame src="SS_banner.html" name="topframe" noresize scrolling="no" marginwidth="0" marginheight="0" framespacing="0" frameborder="1">
	<frameset cols="17%,56%,23%">
		<frame src="SS_menu.html" name="contents" class="nav" noresize frameborder="1" marginwidth="0" marginheight="0" scrolling="auto">
		<frame src="cnt_service_summary.php" name="formframe" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto">
		<frame src="SS_blank.html" name="helpframe" frameborder="1" marginwidth="0" marginheight="0" scrolling="auto">                
	</frameset>
</frameset><noframes></noframes>
</html>

