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
<div class="centerframe">
<h2>Internet:</h2>
  <input name="have_internet" class="mH" onclick="toggleMenu('menu1')"type="checkbox" value="" />
Check here if you have internet service and want the School Server to provide internet services to XO laptops.<br />
<div id="menu1" class="mL">
  <input name="name_server_censor" class="mO" type="checkbox"  value="" />
Enable Domain Name Service content controls using OPENDNS (is mainteined for schools worldwide by specialists)<br />
  <input name="dans_guardian_censor" class="mO" type="checkbox"  value="" />
Install Dan's Guardian content filter (permits local control, requires setup, continued maintenance) 
<h3>Internet Speedups</h3>
Is your internet speed faster than 1Megabit for 5 students, 5 Megabits for 30 students, or 15Mebagits for 75 students? If not:<br />
  
<input name="enable_squid" class="mO" type="checkbox" value="" />
Enable local web page storage for later fast access<br />
  <input name="enable_named" class="mO" type="checkbox" value="" />
Enable local Domain Name storage for faster access</div>
</div>
</body>
</html>
