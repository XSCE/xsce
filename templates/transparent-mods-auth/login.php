<?php

$cookie_name = "xoid";
$original_url = $_GET['url'];


if (isset($_COOKIE[$cookie_name]))
{
	// Check whether each service-specific login-mapping is present.

	/*
	 *  1. For Moodle, we do not need to do anything else, as Moodle
	 *     uses the cookie-data itself to authenticate and login.
	 *
	 *  2. <handle 2nd service>
	 *
	 *  3. <handle 3rd service>, and so on ...
	 */
}
else
{
	header('Location: /login/unauthorized.jsp');
	exit;
}



# If all ok, redirect to the "original" URL.
header('Location: ' . $original_url . '?check=0');

?>

