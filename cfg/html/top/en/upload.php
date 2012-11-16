<?php
$allowedExts = array("xo", "odt", "gif", "png","html","pdf");
$extension = end(explode(".", $_FILES["file"]["name"]));
if ((($_FILES["file"]["type"] == "application/octet-stream")
|| ($_FILES["file"]["type"] == "application/pdf")
|| ($_FILES["file"]["type"] == "application/odt")
|| ($_FILES["file"]["type"] == "image/pjpeg")
|| ($_FILES["file"]["type"] == "image/jpeg")
|| ($_FILES["file"]["type"] == "image/png")
|| ($_FILES["file"]["type"] == "image/pjpeg"))
&& ($_FILES["file"]["size"] < 5000000)
&& in_array($extension, $allowedExts))
  {
  if ($_FILES["file"]["error"] > 0)
    {
    echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
    }
  else
    {
    echo "Upload: " . $_FILES["file"]["name"] . "<br />";
    echo "Type: " . $_FILES["file"]["type"] . "<br />";
    echo "Size: " . ($_FILES["file"]["size"] / 1024) . " Kb<br />";
    echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br />";
	if( isset($_SERVER['REMOTE_ADDR']) ){
		echo "Host: ";
		echo $_SERVER['REMOTE_ADDR'] . "<br />";
	}

    if (file_exists("/library/xs-activity-server/upload/" . $_FILES["file"]["name"]))
      {
      echo $_FILES["file"]["name"] . " already exists. ";
      }
    else
      {
      move_uploaded_file($_FILES["file"]["tmp_name"],
      "/library/upload/" . $_FILES["file"]["name"]);
      echo "Stored in: " . "/library/upload/" . $_FILES["file"]["name"];
	  // apply the changes
      }
	//$APPLY= "sudo /usr/bin/xs-regenerate-activities /library/xs-activity-server/activities";
	//$results = shell_exec($APPLY);
    }
  }
else
  {
  echo "Invalid file -- The suffix was not '.xo'";
  }
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<link href="../schsrv.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div class="centerpick" align="center"><form action="" method="post"
enctype="multipart/form-data">
<h1>Upload Activity (suffix=.xo)</h1>
<label for="file">Filename:</label>
<input type="file" name="file" id="file" /> 
<br />
<input type="submit" name="submit" value="Submit" />
</form>
</div>
</body>
</html>