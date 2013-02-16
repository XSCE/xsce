<?php

	$filename = "/usr/bin/xs-regerate-activities";
	$result = shell_exec($filename);
	header("Location: http://" . $_SERVER['HTTP_HOST'] ."activities");
?>
<html>
<head>
<meta name="description" content="SchoolServer">
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<title>List Activities on School Server</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>
</html>

