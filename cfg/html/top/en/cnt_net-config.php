<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>

<body>
<h2>Routing Table</h2>
<pre class="bash_output">
<?php 	
		$results = shell_exec("route -n");
		print(htmlentities($results));
?>
</pre>
<h2>IP Address Config</h2>
<pre class="bash_output">
<?php 	
		$filename = "../bin/ifiplist";
		$results = shell_exec($filename);
		echo(htmlentities($results));
?>
</pre>

</body>
</html>
