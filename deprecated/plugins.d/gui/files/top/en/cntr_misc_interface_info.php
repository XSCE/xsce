<?php 
	$results = shell_exec("ifconfig");
	//$results_wan = shell_exec("wan_info");
	$results_wan = shell_exec("iwconfig");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Network Interfaces</title>
</head>

<body>
<!--<h1>Network Interface Information</h1>-->
<pre>
<?php print(htmlentities($results));?>
<h3>Wireless Device</h3>
<?php print(htmlentities($results_wan));?>
</pre>
</body>
</html>
