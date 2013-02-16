<?php 
	$cmd = "../bin/server_ip";
	$results = shell_exec($cmd);
	//$results = substr($results,2);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
<title>Setup Navigation Pane</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>

<body class="nav">
<div class="navhead">
<h2>Tools</h2></div>
<a class="nav" href="cntr_upl_activity.php" target="formframe">Activity Load</a><br />
<a class="nav" href="/activities" target="formframe">List Activities</a><br />
<a class="nav" href="cntr_create_offline_usb.php" target="formframe">Offline USB</a><br />
<a class="nav" href="cntr_micro2USB.php" target="formframe">USB Config</a><br />
<a class="nav" href="http://<?php echo $results;?>:8000" target="_blank">Pathgar</a><br />

</body>
</html>
