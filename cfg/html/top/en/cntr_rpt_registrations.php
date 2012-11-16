<?php 
$error='';
try
{
$db = new SQLite3('/home/idmgr/identity.db',0666);
}
catch (exception $e)
{ 
    die($e);
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
<div align="center" >
<h1>Journal Backups</h1>
<table> 
    <?php 
	foreach($lines as $line){
		$sql = "select nickname, serial from laptops where serial='" . $line . "';";
		$result = $db->query($sql);
		if ($result) {
			echo('<tr> <td style="width:60%;">');
			$single = $result->fetchArray();
			echo($line );
			echo("</td><td>");
			echo( $single['nickname']);
			echo ("</td></tr>");
		} else { die("failed to get result from " . $sql);}
	}
	?>
    </table>
</div>

</body>
</html>
