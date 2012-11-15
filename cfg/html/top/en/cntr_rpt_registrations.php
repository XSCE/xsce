<?php 
if ($db = sqlite_open('/home/idmgr/identity.db', 0666, $sqliteerror)) { 
    $result = sqlite_query($db, 'select nickname,serial from laptops;');
    var_dump(sqlite_fetch_array($result)); 
} else {
    die($sqliteerror);
}	
$SUMMARIZE_SERVICES = "ls /library/users";
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
<h1>Journal Backups</h1>
    <?php 
	foreach($lines as $line){
		echo($line);
		echo("<br />");
	}
	?>
</div>

</body>
</html>
