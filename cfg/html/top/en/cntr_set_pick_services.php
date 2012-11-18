<?php 
	// get the list of packages currently active
	$installed = scandir("/etc/sysconfig/olpc-scripts/setup.d/installed");
	$selected =array();
	if (isset($_POST['token'])) {
		if (isset($_POST['gateway'])) {
			$selected['gateway'] = 'on'; } else {$selected['gateway'] = 'off';}
		if (isset($_POST['dansguardian'])) {
 			$selected['dansguardian'] = 'on'; }else{ $selected['dansguardian'] = 'off';}
		if (isset($_POST['opendns']) ) {
 			$selected['opendns'] = 'on'; }else{ $selected['opendns'] = 'off';}
		if (isset($_POST['squid']) ) {
 			$selected['squid'] = 'on'; }else{ $selected['squid'] = 'off';}
		if (isset($_POST['named']) ) {
 			$selected['named'] = 'on';} else {$selected['named'] = 'off';}
		//die(print_r($_POST));
	} else {
		//die(print_r($installed));
		$selected['gateway'] = (in_array("gateway", $installed) ? 'on' : 'off');
		$selected['dansguardian'] = (in_array("dansguardian", $installed) ? 'on' : 'off');
		$selected['opendns'] = (in_array("opendns", $installed) ? 'on' : 'off');
		$selected['squid'] = (in_array("squid", $installed) ? 'on' : 'off');
		$selected['named'] = (in_array("named", $installed) ? 'on' : 'off');
	}
	$forwarders = "";
	if (isset($_POST['token'])) {
		if (strlen($_POST['opendnsip']) > 0) {
			// use php to sanity check the ip address -- an error will kill named
			$dnsip = $_REQUEST['opendnsip'];
			$ip_list = explode(";",$dnsip);
			// ok flag indicates valid ip format
			foreach($ip_list as $ip) {
				if (strlen(parse_ip($ip)) > 0) {
					$forwarders .= parse_ip($ip) . ";";
				}
			}
		}
	}

	function parse_ip($ip_in){
		$ok = true;
		$outstr = "";
		$nibbles = explode(".",$ip_in);
		if (count($nibbles) <> 4) $ok = false; 
		foreach($nibbles as $nibble) {
			$num = (int)$nibble;
			if (($num < 0 ) or ($num > 254)) $ok = false;
			if ($ok) $outstr .= (string)$num . ".";
		}
		if ($ok) {
			return substr($outstr,0,strlen($outstr) - 1);
		}
		return "";
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
<script language="JavaScript" type="text/JavaScript" src="../vnc.js"></script>

<script language="JavaScript" type="text/JavaScript">

function toggleMenu(objID) {
	if (!document.getElementById) return;
	var ob = document.getElementById(objID).style;
	ob.display = (ob.display == 'block')?'none': 'block';
}

function setvisible(){
var internet = '<?php echo $selected['gateway'] ?>';
	if (!document.getElementById) return;
	var ob = document.getElementById('menu1').style;
	if (internet == 'on'){
		ob.display = 'block';
	} else {
		ob.display = 'none';
	}
}
</script>

</head>

<body onload="setvisible()">
<h2>Internet:</h2>
<div class="centerframe">
<form action="" method="post" >
<table><tr><td>
<?php if ($selected['gateway'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="gateway" class="mH" onclick="toggleMenu('menu1')" type="checkbox" value=""<?php echo $checked ?> /></td><td class="mS">
Check here if you have internet service and want the School Server to provide internet services to XO laptops.</td></tr>
</table>
<div id="menu1" class="mL">
<table>
<tr><td>
<?php if ($selected['opendns'] == 'on') $checked = "CHECKED";  else $checked = "";	?>

  <input name="opendns" class="mO" type="checkbox"  value=""<?php echo $checked ?>  /></td><td class="mS">
Enable Domain Name Service content controls using OPENDNS (is mainteined for schools worldwide by specialists)</td></tr>
<tr><td></td><td><div align="center" >Ip address of OPENDNS service: <input name="opendnsip" type="text"  /></div></td></tr>
<tr><td>
<?php if ($selected['dansguardian'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="dansguardian" class="mO" type="checkbox"  value=""<?php echo $checked ?>  /></td><td class="mS">
Install Dan's Guardian content filter (permits local control, requires setup, continued maintenance)
</td></tr>

<tr><td colspan="2"> 
<h3>Internet Speedups</h3></td></tr><tr ><td></td><td class="mS">
 Is your internet speed faster than 1Megabit for 5 students, 5 Megabits for 30 students, or 15Mebagits for 75 students? If not:</td></tr><tr><br /></tr> </tr><td>
  
<?php if ($selected['squid'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="squid" class="mO" type="checkbox" value=""<?php echo $checked ?>  /></td><td class="mS">
Enable local web page storage for later fast access<br /></td></tr><tr><td>
<?php if ($selected['named'] == 'on') $checked = "CHECKED";  else $checked = "";?>
  <input name="named" class="mO" type="checkbox" value=""<?php echo $checked ?>  /></td><td class="mS">
Enable local Domain Name storage for faster access
</td></tr>
</table>
</div>
  <input name="token" type="hidden" />
<div  align="center"> <input class="centerpick" onClick="peervnc()" name="Apply" value ="Apply Changes" type="submit"/></div>
</form>
<?php 
if (isset($_POST['token'])) {
	$outfile = '/home/admin/apply_changes';
	$fh = fopen($outfile,"w") or die("failed to open ". $outfile);
	$outstr = "#!/bin/bash\n";
	$outstr .= "# small apply script to change selected configuration of School server\n";
	$outstr .= "source /usr/bin/xs-setup-functions\n";
	$outstr .= "do-first\n";

	if ( $selected['gateway'] == 'on' and !in_array("gateway", $installed)) 	$outstr .= "gateway yes\n";
	if ( $selected['gateway'] == 'off' and in_array("gateway", $installed)) 	$outstr .= "gateway no\n";

	if ( $selected['dansguardian'] == 'on' and !in_array("dansguardian", $installed)) $outstr .= "dansguardian yes\n";
	if ( ($selected['dansguardian'] == 'off' ) and in_array("dansguardian", $installed)) $outstr .= "dansguardian no\n";
	
	if ( $selected['opendns'] == 'on' and !in_array("opendns", $installed or strlen($forwarders > 0))) 
		  $outstr .= "opendns yes " . $forwarders . "\n";
	if ( ($selected['opendns'] == 'off' ) and in_array("opendns", $installed)) $outstr .= "opendns no\n";
	
	if ( $selected['squid'] == 'on' and !in_array("squid", $installed)) $outstr .= "squid yes\n";
	if ( ($selected['squid'] == 'off') and in_array("squid", $installed)) $outstr .= "squid no\n";
	
	if ( $selected['named'] == 'on' and !in_array("named", $installed) ) $outstr .= "named yes\n";
	if ( ($selected['named'] == 'off') and in_array("named", $installed) ) $outstr .= "named no\n";

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

</div>
</body>
</html>
