<?php 
	$results = shell_exec("systemd-cgls");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Network Interfaces</title>
</head>

<body>
<h2>Process Parents and Children</h2>
<pre>
<?php print(htmlentities($results));?>
</pre>
</body>
</html>
