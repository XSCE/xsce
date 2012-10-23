<?php 
	// get the list of packages currently active
	$installed = scandir("/etc/sysconfig/olpc-scripts/setup.d/installed");
	$selected =array();
	if (isset($_POST['token'])) {
		if (isset($_POST['register'])) $selected['register'] = 'on'; else $selected['register'] = 'off';
		if (isset($_POST['ejabberd'])) $selected['ejabberd'] = 'on'; else $selected['ejabberd'] = 'off';
		if (isset($_POST['activity_server'])) $selected['activity_server'] = 'on'; else $selected['activity_server'] = 'off';
		if (isset($_POST['moodle'])) $selected['moodle'] = 'on'; else $selected['moodle'] = 'off';
		if (isset($_POST['security_tools'])) $selected['security_tools'] = 'on'; else $selected['security_tools'] = 'off';
		if (isset($_POST['webdav'])) $selected['webdav'] = 'on'; else $selected['webdav'] = 'off';
	} else {
		$selected['register'] = (in_array("idmgr", $installed) ? 'on' : 'off');
		$selected['ejabberd'] = (in_array("ejabberd", $installed) ? 'on' : 'off');
		$selected['activity_server'] = (in_array("activity-server", $installed) ? 'on' : 'off');
		$selected['moodle'] = (in_array("moodle-xs", $installed) ? 'on' : 'off');
		$selected['security_tools'] = (in_array("security_tools", $installed) ? 'on' : 'off');
		$selected['webdav'] = (in_array("webdav", $installed) ? 'on' : 'off');
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />

<script language="JavaScript" type="text/JavaScript">

function toggleMenu(objID) {
	if (!document.getElementById) return;
	var ob = document.getElementById(objID).style;
	ob.display = (ob.display == 'block')?'none': 'block';
}
</script>

</head>

<body>
<h2>Services to the XO Laptops</h2>
<form action="<?php echo($_SERVER['self']);?>" method="post" >
<div class="centerpick">
<?php if ($selected['ejabberd'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="ejabberd" type="checkbox"  value="" <?php echo $checked ?>/>
Facilitate collaboration by centralizing identity information (ejabber server)<br />
<?php if ($selected['register'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="register" type="checkbox" value="" <?php echo $checked ?> />
Register XO's and accumulate backup copies of student Journals.<br />
<?php if ($selected['activity_server'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="activity_server" type="checkbox"  value="" <?php echo $checked ?>/>
Store and serve new or updated Activities to XO's, input from a USB stick.<br />
<?php if ($selected['moodle'] == 'on') $checked = "CHECKED";  else $checked = "";?>
<input name="moodle" type="checkbox" value="" <?php echo $checked ?>/>
Use the Moodle content and classroom management system<br />
<?php if ($selected['security_tools'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="security_tools" type="checkbox" value="" <?php echo $checked ?>/>
Manage activation of XO leases, and security.<br  />
<?php if ($selected['webdav'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="webdav" type="checkbox" value="" <?php echo $checked ?>/>
Enable the storage and retrieval of files on the server using WebDav.<br  />
</div>
  <input name="token" type="hidden" />
<div align="center"> <input name="Apply" type="submit"/></div>
</form>
<?php 
if (isset($_POST['token'])) {
	$outfile = '/library/webdav/apply_changes';
	$fh = fopen($outfile,"w") or die("failed to open ". $outfile);
	$outstr = "#!/bin/bash\n";
	$outstr .= "# small apply script to change selected configuration of School server\n";
	$outstr .= "source /usr/bin/xs-setup-functions\n";
	$outstr .= "do-first\n";

	if ( $selected['register'] == 'on' and !in_array("idmgr", $installed)) 	$outstr .= "idmgr yes\n";
	if ( $selected['register'] == 'off' and in_array("idmgr", $installed)) 	$outstr .= "idmgr no\n";
	
	if ( $selected['ejabberd'] == 'on' and !in_array("ejabberd", $installed)) $outstr .= "ejabberd yes\n";
	if ( $selected['ejabberd'] == 'off' and in_array("ejabberd", $installed)) $outstr .= "ejabberd no\n";
	
	if ( $selected['activity_server'] == 'on' and !in_array("activity-server", $installed)) $outstr .= "activity_server yes\n";
	if ( $selected['activity_server'] == 'off' and in_array("activity-server", $installed)) $outstr .= "activity_server no\n";
	
	if ( $selected['moodle'] == 'on' and !in_array("moodle-xs", $installed)) $outstr .= "moodle yes\n";
	if ( $selected['moodle'] == 'off' and in_array("moodle-xs", $installed)) $outstr .= "moodle no\n";
	
	if ( $selected['security_tools'] == 'on' and !in_array("security-tools", $installed) ) $outstr .= "security_tools yes\n";
	if ( $selected['security_tools'] == 'off' and in_array("security-tools", $installed) ) $outstr .= "security_tools no\n";

	if ( $selected['webdav'] == 'on' and !in_array("webdav", $installed) ) $outstr .= "webdav yes\n";
	if ( $selected['webdav'] == 'off' and in_array("webdav", $installed) ) $outstr .= "webdav no\n";

	$outstr .= "do-last\n";
	fwrite($fh,$outstr);
	fclose($fh);
	//make it executable
	system("chmod 755 $outfile");
	echo "<pre>";
	echo $outstr;
	echo "</pre>";
}
?>

</body>
</html>
