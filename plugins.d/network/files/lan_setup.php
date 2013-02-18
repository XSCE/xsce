<?php 
	$SUMMARIZE_SERVICES = "ls /library/users";
	$results = shell_exec($SUMMARIZE_SERVICES);
	$lines = explode("\n",$results);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
<div align="center">
<form action="" method="post">
<input name="usedhcp" type="checkbox" value="" checked="checked" />
Use automatic configuration (dhcp).
<table width="600" border="1">
  <tr>
    <td>&nbsp;</td>
    <td>All of the following fields should be period separated xxx.xxx.xxx.xxx</td>
  </tr>
  <tr>
    <td>Ip Address:</td>
    <td><input name="ip" type="text" size="40" /></td>
  </tr>
  <tr>
    <td>Netmaks</td>
    <td><input name="mask" type="text" value="255.255.255.0" size="40" /></td>
  </tr>
  <tr>
    <td>Gateway</td>
    <td><input name="gateway" type="text" value="000.000.000.000" /></td>
  </tr>
</table>
</form>
</div>
</body>
</html>