<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?php
session_start();
if (!isset($_SERVER['PHP_AUTH_USER'])) {
	$_SESSION['unique'] = sprintf('%s', rand());
    header(sprintf('WWW-Authenticate: Basic realm="My Realm_%s"', $_SESSION["unique"]));
    header('HTTP/1.0 401 Unauthorized');
    echo 'To access School Server setup, you must log in with superuser password';
    exit;
} else {
    echo "<p>Hello {$_SERVER['PHP_AUTH_USER']}.</p>";
    echo "<p>You entered {$_SERVER['PHP_AUTH_PW']} as your password.</p>";
}
?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>School Server Login</title>
</head>

<body>
</body>
</html>