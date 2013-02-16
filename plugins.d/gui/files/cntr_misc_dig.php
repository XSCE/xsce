<?php 
	$SUMMARIZE_SERVICES = "dig yahoo.com";
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
<h1>Name Server Response</h1></div>
<div align="left" class="bash_script">
<pre>
    <?php 
	foreach($lines as $line){
		echo($line . "<br />");
	}
	?>
</pre>
</div>

</body>
</html>
