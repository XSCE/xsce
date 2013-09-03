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


# If all ok, redirect to the "original" URL, after appending the original "GET"-variables.
$original_url = $original_url . "?";

foreach ($_GET as $key => $val)
{
        # Do not re-append "url" GET-variable.
        if ($key == "url")
        {
                continue;
        }

        $original_url = $original_url . "$key=$val&";
}

header('Location: ' . $original_url . 'check=0');

?>
