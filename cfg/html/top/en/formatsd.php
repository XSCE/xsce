<?php 
	$SUMMARIZE_SERVICES = "/usr/bin/sudo /usr/sbin/fdisk -l /dev/mmcblk0";
	$results = shell_exec($SUMMARIZE_SERVICES);
	$lines = explode("\n",$results);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Running Services</title>
</head>

<body>
<div align="center">
<h1>SD Information</h1>
</div>

<div align="left">
	<pre>
    <?php 
	foreach($lines as $line){
		echo($line);
		echo("<br />");
	}
	$SUMMARIZE_SERVICES = "/usr/bin/sudo /usr/bin/xs-flashbench -a /dev/mmcblk0";
	$results = shell_exec($SUMMARIZE_SERVICES);
	$lines = explode("\n",$results);
	?>
	</pre>
</div>

<div align="center">
<h3>Flash Speed Across Erase Possible Block Boundries</h3>
</div>

<div align="left">
	<pre>
	<?php 
	foreach($lines as $line){
		echo($line);
		echo("<br />");
	}
	?>
	</pre>
</div>


</body>
</html>
