<?php
//change the language context by setting the default directory
//	$url = $_SERVER['REQUEST_URI'];
	//$workingdir = getcwd();
/*	$i = strrpos($abs_url,"/");
	$new_dir = substr($abs_url,0,$i);
	//print($new_dir);
	header("location(./" . $goto . ")");
	chdir($new_dir);
*/
	$filename = "./bin/lang";
	$result = shell_exec($filename);
	if (strlen($result)<2) $result = 'en';
	$goto = substr($result,1,2);
	$locationstring = "Location: ./" . $goto;
	$workingdir = getcwd();
	$lang_dir = $workingdir . "/" . $goto;
	if (is_dir($lang_dir)) {
		//die($locationstring);
		header($locationstring);
		exit(0);
	}
	//default to english if the configured language does not exist
	header("Location: http://" . $_SERVER['HTTP_HOST'] ."/top/en");
?>
<html>
<head>
<meta name="description" content="SchoolServer">
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<title>School Server Remote Access</title>
<link href="schsrv.css" rel="stylesheet" type="text/css" />
</head>
</html>

