<?php 
	$PING = "ping -c 4  yahoo.com";
	$results = shell_exec($PING);
	$lines = explode("\n",$results);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Ping inside and outside</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div align="center">
<h2>Contact Internet</h2></div> 
<div align="left" class="bash_output">
<pre>
    <?php 
	foreach($lines as $line){
		$nibbles = explode("\t",$line);
		foreach($nibbles as $value){
			echo("$value" . '<br />');
		}
	}
	?>
    </pre>
</div>
<div align="center">
<h2>Internal Network</h2></div> 
<div align="left" class="bash_output">
<pre>
<?php 
	$PING = "avahi-browse -a -t | grep Workstation";
	$results = shell_exec($PING);
	$lines = explode("\n",$results);
	foreach($lines as $line){
		$nibbles = explode("\t",$line);
		foreach($nibbles as $value){
			echo("$value" . '<br />');
		}
	}
?>

</pre>
</div>
</body>
</html>
