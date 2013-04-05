<?php 
	$SUMMARIZE_SERVICES = "sudo /usr/bin/xs-acpowergaps";
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
<h1>AC Power Log</h1>
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

</div>

</body>
</html>
