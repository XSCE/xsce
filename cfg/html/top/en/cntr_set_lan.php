<?php 
	if (isset($_POST['token'])) {
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

<body>
<div class="centerframe" align="center">
<h2>Wide Area Network (WAN) Setup</h2>
<form action="" method="post">
<?php if (true) $checked = "CHECKED";  else $checked = "";?>
 <td class="mS">
<input name="usedhcp" class="mH" onclick="toggleMenu('menu1')" type="checkbox" value="" <?php echo $checked ?> />
Use automatic configuration (dhcp).
<br  />
<br  />
<div id="menu1" class="mL">
<table width="500" border="0">
  <tr>
    <td>&nbsp;</td>
    <td>All of the following fields should be period separated xxx.xxx.xxx.xxx<b:r /></td>
  </tr>
  <tr>
    <td width="20%">Ip Addr:</td>
    <td ><input name="ip" type="text" size="40" /></td>
  </tr>
  <tr>
    <td>Netmask:</td>
    <td><input name="mask" type="text" value="255.255.255.0" size="40" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="gateway" type="text" size="40" value="" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="dns" type="text" size="40" value="" /></td>
  </tr>
</table>
<br  />
<br  />
</div>
  <input name="token" type="hidden" />
<input name="wan" type="submit" value="Apply" />
</form>
<form action="" method="post">
<h3>Set the School Server (LAN) Address</h3>
<table width="500" border="0">
  <tr>
    <td>&nbsp;</td>
    <td>Following fields should be used when wifi, dns, and gateway are already available on the network<b:r /></td>
  </tr>
  <tr>
    <td width="20%">Ip Addr:</td>
    <td ><input name="ip" type="text" size="40" /></td>
  </tr>
  <tr>
    <td>Netmask:</td>
    <td><input name="mask" type="text" value="255.255.255.0" size="40" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="gateway" type="text" size="40" value="" /></td>
  </tr>
  <tr>
    <td>Gateway:</td>
    <td><input name="dns" type="text" size="40" value="" /></td>
  </tr>
</table>
<input name="lan" type="submit" value="Apply" />
</form>
</div>
<br />
This GUI feature is still under construction.
</body>
</html>