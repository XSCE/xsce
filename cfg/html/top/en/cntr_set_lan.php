<?php 
/* Notes:
	LAN and WAN are set to dhcp when the ip address is 0.0.0.0
	LAN checkbox is set to default when ip address is $DEFAULTLAN
	--having trouble passing boolean to javascript, use string "true" and "false" instead
*/	
	$DEFAULTLAN = "172.18.96.1";
	$outwan = "/home/admin/etc/sysconfig/xs_wan_ip";
	$outlan = "/home/admin/etc/sysconfig/xs_lan_ip";

	// Examine WAN
	if (file_exists($outwan)){
		$wanip = shell_exec("cat " . $outwan);
		$wanlist = explode(";",$wanip);
	} else {$wanlist = array();}
	$WanConfigDhcp = zeros_ip($wanlist[0]);
	if (! isset($_POST["token"])) {
		$WanDhcpChecked = $WanConfigDhcp;
	} else { $WanDhcpChecked = (isset($_POST["WanDhcpChecked"])?"true" : "false");}

	// Examine LAN
	if (file_exists($outlan)){
		$lanip = shell_exec("cat " . $outlan);
		$lanlist = explode(";",$lanip);
	} else $lanlist = array();
	$LanConfigDhcp = zeros_ip($lanlist[0]);
	$LanConfigStd = ( $lanlist[0] == $DEFAULTLAN) ? "true" : "false";
	//get the check box states
	
	//if ($lanlist[0] == $DEFAULTLAN) $_POST["LanStdChecked"] = true; 
	if (! isset($_POST["token"])) {
		$LanStdChecked = $LanConfigStd;
		//if ($LanConfigDhcp == "true") $LanDhcpChecked = "true";else $LanDhcpChecked = "false";
		$LanDhcpChecked = $LanConfigDhcp;
	} else {
		$LanStdChecked = isset($_POST["LanStdChecked"]) ? "true" : "false";
		$LanDhcpChecked = isset($_POST["LanDhcpChecked"]) ? "true" : "false";
		//die(print_r($_POST)."LanStdChecked".$LanStdChecked);
	}
	if ($LanStdChecked == "true") $LanDhcpChecked = "true";
	//if ($LanStdChecked == "true") $LanDhcpChecked = "false";
	//print("LanConfigStd:".$LanConfigStd." LanStdChecked:".$LanStdChecked." LanConfigDhcp:".$LanConfigDhcp. " LanDhcpChecked:".$LanDhcpChecked );

	
// DEFINE FUNCTIONS
	function parse_ip($ip_in){
		// return validated ip terminated by ";", or just ";"
		$ok = true;
		$outstr = "";
		$nibbles = explode(".",$ip_in);
		if (count($nibbles) <> 4) $ok = false; 
		foreach($nibbles as $nibble) {
			$num = (int)$nibble;
			if (($num < 0 ) or ($num > 255)) $ok = false;
			if ($ok) $outstr .= (string)$num . ".";
		}
		if ($ok) {
			return substr($outstr,0,strlen($outstr) - 1) . ";";
		}
		return ";";
	}

	function zeros_ip($ip_in){
		// check the xx.xx.xx.xx for all zeros
		$ok = "true";
		$nibbles = explode(".",$ip_in);
		if (count($nibbles) <> 4) $ok = "false"; 
		foreach($nibbles as $nibble) {
			if ((int)$nibble != 0) $ok = "false";
		}
		return $ok;
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

function setvisible(){
var WanDhcpChecked = "<?php echo $WanDhcpChecked; ?>";
var usestd = "<?php echo $LanStdChecked; ?>";
var usedhcp = "<?php echo $LanDhcpChecked; ?>";
	if (!document.getElementById) return;
	var ob = document.getElementById('menu1').style;
	if (WanDhcpChecked == 'true'){
		ob.display = 'none';
	} else {
		ob.display = 'block';
	}
	var ob = document.getElementById('menu2').style;
	if (usestd == 'true'){
		ob.display = 'none';
	} else {
		ob.display = 'block';
	}
	var ob = document.getElementById('menu3').style;
	ob.display = 'none';
	if (usedhcp != 'true' && usestd != 'true'){
		ob.display = 'block';
	} 
	
}
</script>
</head>

<body onload="setvisible()">
<div class="centerframe" align="center">
<h2>Wide Area Network (WAN) Setup</h2>
<form action="" method="post">
<?php 
if ($WanDhcpChecked == "true") $checked = "CHECKED";  else $checked = ""; ?>
 <div class="mS">
<input name="WanDhcpChecked" class="mH" onclick="toggleMenu('menu1')" type="checkbox" value="" <?php echo $checked ?> /> 
Use automatic configuration (dhcp).</div>
<br  />
<div id="menu1" class="mL">
<table width="500" border="0">
  <tr>
    <td width="20%">Ip Addr:</td>
    <td ><input name="wanip" type="text" size="40" value="<?php echo $wanlist[0]; ?>" /></td>
  </tr>
  <tr>
    <td>Netmask:</td>
    <td><input name="wanmask" type="text"  size="40" value="<?php echo $wanlist[1]; ?>" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="wangateway" type="text" size="40" value="<?php echo $wanlist[2]; ?>"  /></td>
  </tr>
  <tr>
    <td>DNS:</td>
    <td><input name="wandns" type="text" size="40" value="<?php echo $wanlist[3]; ?>"  /></td>
  </tr>
</table>
<br  />
<br  />
</div>
<h2>Set the School Server (LAN) Address</h2>
<?php 
if ($LanStdChecked == "true") $checked = "CHECKED";  else $checked = "";?>
 <div class="mS">
<input name="LanStdChecked" class="mH" onclick="toggleMenu('menu2')" type="checkbox" value="" <?php echo $checked ?> /> 
Use standard LAN ip (172.18.96.1).</div>
<div id="menu2" class="mL">
	<?php 
    if ($LanDhcpChecked == "true") $checked = "CHECKED";  else $checked = "";?>
     <div class="mS">
    <input name="LanDhcpChecked" class="mH" onclick="toggleMenu('menu3')" type="checkbox" value="" <?php echo $checked ?> /> 
    Let Server request ip from network (dhcp).</div>


<div id="menu3" class="mO">
<table width="500" border="0">
  <tr>
    <td>&nbsp;</td>
    <td>Following fields should be used only when wifi, dns, and gateway are already available on the network</td>
  </tr>
  <tr>
    <td width="20%">Ip Addr:</td>
    <td ><input name="lanip" type="text" size="40" value="<?php echo $lanlist[0]; ?>" /></td>
  </tr>
  <tr>
    <td>Netmask:</td>
    <td><input name="lanmask" type="text" value="<?php echo $lanlist[1]; ?>"  size="40" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="langateway" type="text" size="40" value="<?php echo $lanlist[2]; ?>"   /></td>
  </tr>
  <tr>
    <td>DNS:</td>
    <td><input name="landns" type="text" size="40" value="<?php echo $lanlist[3]; ?>"   /></td>
  </tr>
</table>

<input name="token" type="hidden" />
</div>
</div>
<?php if ( ! isset($_POST['token'])) { ?>
	<input name="lan" type="submit" value="Apply Changes" />
<?php } ?>
</form>

<?php 
if (isset($_POST['token'])) {
	$outfile = '/home/admin/apply_changes';
	$fh = fopen($outfile,"w") or die("failed to open ". $outfile);
	$outstr = "#!/bin/bash\n";
	$outstr .= "# small apply script to change selected configuration of School server\n";
	$outstr .= "source /usr/bin/xs-setup-functions\n";
	$outstr .= "do-first\n";

	$wanchanged = false;
	
	if ($WanDhcpChecked == "true" ){
		//die("WanDhcpChecked:". $WanDhcpChecked .
		if ($WanDhcpChecked != $WanConfigDhcp ){
			$wanchanged = "true";
			$_POST["wanip"] = "0.0.0.0";
		}
	} elseif (($wanlist[0] <> $_POST["wanip"]) or
		($wanlist[1] <> $_POST["wanmask"]) or
		($wanlist[2] <> $_POST["wangateway"]) or
		($wanlist[3] <> $_POST["wandns"])) $wanchanged = true;
	if ($wanchanged) {
		$wanstr = "";
		$outstr .= "setwan ";
		$outstr .= parse_ip($_POST['wanip']);
		$wanstr .= parse_ip($_POST['wanip']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['wanmask']);
		$wanstr .= parse_ip($_POST['wanmask']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['wangateway']);
		$wanstr .= parse_ip($_POST['wangateway']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['wandns']);
		$wanstr .= parse_ip($_POST['wandns']);
		$wanstr .= "\nThis file is automatically generated by the html GUI. It will not configure WAN\n";
		$outstr .= "\n";
		
		//record the selection, as a permanent config change
		$fwan = fopen($outwan,"w") or die("failed to open ". $outwan);
		fwrite($fwan,$wanstr);
		fclose($fwan);
	}
	$lanchanged = false;
	//die("lanDhcpchecked:".$LanDhcpChecked."LanConfigDhcp:".$LanConfigDhcp."LanStdChecked:".$LanStdChecked);
	if ($LanStdChecked == "true"){
		if ( $LanStdChecked != $LanConfigStd){
			$_POST['lanip'] = "172.18.96.1";
			$_POST['lanmask'] = "255.255.224.0";
			$_POST['langateway'] = "127.0.0.1";
			$_POST['landns'] = "127.0.0.1";
			$lanchanged = true;
		}
	} elseif ($LanDhcpChecked == "true")  {
		if ( $LanDhcpChecked != $LanConfigDhcp){
			$_POST['lanip'] = "0.0.0.0";
			$lanchanged = true;
		}
	} elseif (($lanlist[0] <> $_POST["lanip"]) or
		($lanlist[1] <> $_POST["lanmask"]) or
		($lanlist[2] <> $_POST["langateway"]) or
		($lanlist[3] <> $_POST["landns"]))  $lanchanged = true;
	if ($lanchanged) {
		$lanstr = "";
		$outstr .= "setlan ";
		$outstr .= parse_ip($_POST['lanip']);
		$lanstr .= parse_ip($_POST['lanip']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['lanmask']);
		$lanstr .= parse_ip($_POST['lanmask']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['langateway']);
		$lanstr .= parse_ip($_POST['langateway']);
		$outstr .= " ";
		$outstr .= parse_ip($_POST['landns']);
		$lanstr .= parse_ip($_POST['landns']);
		$lanstr .= "\nThis file is automatically generated by the html GUI. It will not configure lan\n";
		$outstr .= "\n";
		
		//record the selection, as a permanent config change
		$flan = fopen($outlan,"w") or die("failed to open ". $outlan);
		fwrite($flan,$lanstr);
		fclose($flan);
		//sleep(5);
	}

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
	//$results = shell_exec($APPLY);
	
	//let the files be written before exiting
}
?>

</div>
</body>
</html>