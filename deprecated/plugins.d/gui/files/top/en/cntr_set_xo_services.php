<?php 
	// get the list of packages currently active
	$installed = scandir("/etc/sysconfig/olpc-scripts/setup.d/installed");
	$selected =array();
	if (isset($_POST['token'])) {
		if (isset($_POST['register'])) $selected['register'] = 'on'; else $selected['register'] = 'off';
		if (isset($_POST['ejabberd'])) $selected['ejabberd'] = 'on'; else $selected['ejabberd'] = 'off';
		if (isset($_POST['activity_server'])) $selected['activity_server'] = 'on'; else $selected['activity_server'] = 'off';
		if (isset($_POST['moodle-xs'])) $selected['moodle-xs'] = 'on'; else $selected['moodle-xs'] = 'off';
		if (isset($_POST['xs-security'])) $selected['xs-security'] = 'on'; else $selected['xs-security'] = 'off';
		if (isset($_POST['upload'])) $selected['upload'] = 'on'; else $selected['upload'] = 'off';
		if (isset($_POST['dhcpd']) ) {
 			$selected['dhcpd'] = 'on';} else {$selected['dhcpd'] = 'off';}
		if (isset($_POST['xs-acpowergaps']) ) {
 			$selected['xs-acpowergaps'] = 'on';} else {$selected['xs-acpowergaps'] = 'off';}
	} else {
		$selected['register'] = (in_array("idmgr", $installed) ? 'on' : 'off');
		$selected['ejabberd'] = (in_array("ejabberd", $installed) ? 'on' : 'off');
		$selected['activity_server'] = (in_array("activity-server", $installed) ? 'on' : 'off');
		$selected['moodle-xs'] = (in_array("moodle-xs", $installed) ? 'on' : 'off');
		$selected['xs-security'] = (in_array("xs-security", $installed) ? 'on' : 'off');
		$selected['upload'] = (in_array("upload", $installed) ? 'on' : 'off');
		$selected['dhcpd'] = (in_array("dhcpd", $installed) ? 'on' : 'off');
		$selected['xs-acpowergaps'] = (in_array("xs-acpowergaps", $installed) ? 'on' : 'off');
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache>    
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
<div class="centerframe">
<h2>Services to the XO Laptops</h2>
<form action="" method="post" >
<table>
<tr><td>
<?php if ($selected['register'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="register" type="checkbox" value=""<?php echo $checked ?> />
</td><td class="mS">
Register XO's and backup student Journals.<div class="red">(future release)</div>
</td></tr><tr><td>
<?php if ($selected['activity_server'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="activity_server" type="checkbox"  value="" <?php echo $checked ?>/>
</td><td class="mS">
Serve Activities, input to server VIA Upload.<div class="red">(future release)</div>
</td></tr><tr><td>
<?php if ($selected['moodle-xs'] == 'on') $checked = "CHECKED";  else $checked = "";?>
<input name="moodle-xs" type="checkbox" value="" <?php echo $checked ?>/>
</td><td class="mS">
Moodle content and classroom management system.<div class="red">(future release)</div>
</td></tr><tr><td>
<?php if ($selected['xs-security'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="xs-security" type="checkbox" value=""<?php echo $checked ?>/>
</td><td class="mS">
Manage activation of XO leases, and security.<div class="red">(future release)</div>
</td></tr><tr><td>
<?php if ($selected['upload'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="upload" type="checkbox" value="" <?php echo $checked ?>/>
</td><td class="mS">
WebDav Storage and retrieval of files on the server.
</td></tr><tr><td>
<?php if ($selected['ejabberd'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="ejabberd" type="checkbox"  value="" <?php echo $checked ?>/>
</td><td class="mS">
Make collaboration faster (ejabber server)
  <input name="token" type="hidden" />
</td></tr><tr><td>
<?php if ($selected['dhcpd'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="dhcpd" type="checkbox" value=""<?php echo $checked ?>  />
</td><td class="mS">
Uncheck to disable ip address assignments (dhcpd) if XS is joining an established network
</td></tr><tr><td>
<?php if ($selected['xs-acpowergaps'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="xs-acpowergaps" type="checkbox"  value="" <?php echo $checked ?>/>
</td><td class="mS">
Enable Recording of AC power failures.<div class="red">(future release)</div>
</td></tr>
</table>
<?php if ( ! isset($_POST['token'])) { ?>
<div  align="center"> <input class="centerpick" onClick="peervnc()" name="Apply" value ="Apply Changes" type="submit"/></div>
<?php } ?>

</form>
</div>
<?php 
if (isset($_POST['token'])) {
	$outfile = '/home/admin/apply_changes';
	$fh = fopen($outfile,"w") or die("failed to open ". $outfile);
	$outstr = "#!/bin/bash\n";
	$outstr .= "# small apply script to change selected configuration of School server\n";
	$outstr .= "source /usr/bin/xs-setup-functions\n";
	$outstr .= "do-first\n";

	if ( $selected['register'] == 'on' and !in_array("idmgr", $installed)) 	$outstr .= "idmgr yes\n";
	if ( $selected['register'] == 'off' and in_array("idmgr", $installed)) 	$outstr .= "idmgr no\n";
	
	if ( $selected['ejabberd'] == 'on' and !in_array("ejabberd", $installed)) $outstr .= "ejabberd yes\n";
	if ( $selected['ejabberd'] == 'off' and in_array("ejabberd", $installed)) $outstr .= "ejabberd no\n";
	
	if ( $selected['activity_server'] == 'on' and !in_array("activity-server", $installed)) $outstr .= "activity-server yes\n";
	if ( $selected['activity_server'] == 'off' and in_array("activity-server", $installed)) $outstr .= "activity-server no\n";
	
	if ( $selected['moodle-xs'] == 'on' and !in_array("moodle-xs", $installed)) $outstr .= "moodle-xs yes\n";
	if ( $selected['moodle-xs'] == 'off' and in_array("moodle-xs", $installed)) $outstr .= "moodle-xs no\n";
	
	if ( $selected['xs-security'] == 'on' and !in_array("xs-security", $installed) ) $outstr .= "xs-security yes\n";
	if ( $selected['xs-security'] == 'off' and in_array("xs-security", $installed) ) $outstr .= "xs-security no\n";

	if ( $selected['upload'] == 'on' and !in_array("upload", $installed) ) $outstr .= "upload yes\n";
	if ( $selected['upload'] == 'off' and in_array("upload", $installed) ) $outstr .= "upload no\n";

	if ( $selected['dhcpd'] == 'on' and !in_array("dhcpd", $installed) ) $outstr .= "dhcpd yes\n";
	if ( ($selected['dhcpd'] == 'off') and in_array("dhcpd", $installed) ) $outstr .= "dhcpd no\n";

	if ( $selected['xs-acpowergaps'] == 'on' and !in_array("xs-acpowergaps", $installed) ) 
			$outstr .= "xs-acpowergaps yes\n";
	if ( ($selected['xs-acpowergaps'] == 'off') and in_array("xs-acpowergaps", $installed) ) 
			$outstr .= "xs-acpowergaps no\n";

	$outstr .= "do-last\n";
	// see if there are no changes in the output string
	$matchloc = strpos($outstr, "do-first\ndo-last");
	if ($matchloc > 0) {
		$outstr = substr($outstr, 0, $matchloc);
		$outstr .= "# There are no changes to apply";
	} 
	fwrite($fh,$outstr);
	fclose($fh);
	//make it executable
	system("chmod 750 $outfile");
	echo "<pre>";
	echo $outstr;
	echo "</pre>";
	
	// apply the changes
	$APPLY= "sudo /root/xs-apply-changes";
	$results = shell_exec($APPLY);

}
?>

</body>
</html>
