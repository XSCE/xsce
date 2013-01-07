<?php 
	header('Cache-Control: no-cache, must-revalidate, max-age=1');
	header('Expires: Sat, 26 Jul 1997 05:00:00 GMT');  //date in the past
	$results="";
	if (isset($_POST['scan'])) {
		unset($_POST['device']);
		unset($_POST['token']);
		// The following will reset the connection, and cause an error message on browseer
		shell_exec('sudo /bin/systemctl restart httpd.service');
		//print("scan was set");
	}
	if (isset($_REQUEST['device'])) $device = $_REQUEST['device']; else $device = "";
	//$cmd = "sudo /bin/mount ";
	$cmd = "sudo cat /etc/mtab | grep -e ^/dev/sd | cut -d ' ' -f 2";
	$results = shell_exec($cmd);
	//print_r($results);
	//die($results);
	$devices = explode('\n',$results);
//if (count($devices) > 0)
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<META http-equiv=Pragma content=no-cache>
<META http-equiv=Cache-Control content=no-cache, max-age=1, must-revalidate>    
<title>Untitled Document</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="../vnc.js"></script>
</head>

<body>
<div align="center" class="centerframe">
<h3>Create USB to update Classroom XO's</h3>
<h4>Will execute "onboot" script in USB root Directory</h4>
<?php 
	if (count($devices) > 0 and $devices[0] != ""){
			if ($device == "") {
				if (count($devices) > 1 ){
					echo("More than 1 USB device found. Click on the Target device");
					foreach ($devices as $dev) {
						$dev = deblank(trim($dev));
						echo_device($dev);
					}
				} else {
					echo("If this is the USB device target, Click on CREATE. <br>");
					echo("Otherwise, insert USB stick, and Click on ANOTHER USB <br>");
					$device = deblank(trim($devices[0]));
					echo_device($device);
				}
			} else { // a device has already been selected
				echo_device($device);
		}
	} else { 
		echo("No USB devices Found.<br>");
		echo("Instructions: Place a USB flash drive in the Schoolserver that has at least 30MB of free space.");
	}
	
function echo_device($this_dev){
	echo("<br>");
	echo('<pre><div align="left">');
	echo( "<a href=#%device=".$this_dev."> ".$this_dev."</a>");
	// only root can see all devices
	$cmd = "sudo df -h ".$this_dev." | grep -e ".$this_dev." | gawk '{print $4}'";
	//$cmd = "sudo df -h ".$dev ;
	$space = shell_exec($cmd);
	//die($space);
	echo("  --  Free Space: ".$space."\n");
	$cmd = "sudo ls -lh ".$this_dev." | grep  -v -e total";
	//$cmd = "sudo ls -l ".$dev;
	$results = shell_exec($cmd);
	//exec($cmd, &$results);
	echo $results;
	echo "</div></pre>";
}

function deblank($instr){
	$rval = str_replace("\\040","\\ ",$instr);
	return($rval);
}

?>
<form action="" method="post" >
<input name="token" type="hidden" />
<input name="device" type="hidden" value="<?php echo $device ?>"/>
<?php if ( ! isset($_POST['token'])) { ?>
<div  align="center"> 
<input class="centerpick" name="create" onClick="peervnc()" value ="CREATE" type="submit"/>
<input class="centerpick" name="scan" value ="Another USB" type="submit"/>
</div>
<?php } ?>

</form>
</div>
<?php 
if (isset($_POST['token'])) {
	if (is_dir("/run/media/olpc")){
	}
	$outfile = '/home/admin/apply_changes';
	$fh = fopen($outfile,"w") or die("failed to open ". $outfile);
	$outstr = "#!/bin/bash\n";
	$outstr .= "# small apply script to change selected configuration of School server\n";
	$outstr .= "source /usr/bin/xs-setup-functions\n";
	$outstr .= "do-first\n";
	$outstr .= 'create-usb-microcore-linux '.$device;

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