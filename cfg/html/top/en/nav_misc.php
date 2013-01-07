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
<title>Untitled Document</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="../vnc.js"></script>

</head>

<body class="nav" onload="vncinit()">
<div class="navhead">
<h2>SysAdmin</h2></div>

<a class="nav" href="cntr_rpt_services.php" target="formframe">Services</a><br />
<a class="nav" href="cntr_misc_process_tree.php" target="formframe">Processes</a><br />
<a class="nav" href="cntr_misc_test.php" target="formframe">Php Config</a><br />
<a class="nav" href="cntr_misc_memory.php" target="formframe">Memory Use</a><br />
<a class="nav" href="cntr_misc_net-config.php" target="formframe">Network Setup</a><br />
<a class="nav" href="cntr_misc_interface_info.php" target="formframe">Devices</a><br />
<a class="nav" href="cntr_misc_ping.php"target="formframe">Connected?</a><br />
<a class="nav" href="cntr_misc_dig.php"target="formframe">Name Server?</a><br />
<a class="nav" href="cntr_misc_formatsd.php"target="formframe">SD card info</a><br />
<a class="nav" href="http://<?php echo $results;?>:5280/admin" target="_blank">Ejabberd</a><br />
</body>
</html>
