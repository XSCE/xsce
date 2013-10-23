<?php
$serv_loc = array(    
"activity-server" => "/activities",
"iiab" => "/iiab/redirect",
"moodle-xs" => "/moodle",
"pathagar" => "/books/latest",
"upload" => "/upload_activity.php"
);

$serv_arr  = array();
$temp =  shell_exec('ls /etc/sysconfig/olpc-scripts/setup.d/installed');
$tok = strtok($temp, " \n\t\r");

while ($tok !== false) {
//    echo "Word=$tok<br />";
    $serv_arr[$tok] = 1;
    $tok = strtok(" \n\t\r");
}

function service_link($service_key, $service_link_text, $service_link_desc)
{
	global $serv_arr, $serv_loc;

  if (array_key_exists ( $service_key , $serv_arr )) {
    $link_clause = '<div class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_loc[$service_key] . '">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';
    echo $link_clause;
    echo $link_desc;
  }
}

function iiab_link($service_link_text, $service_link_desc, $service_search_text)
{
	global $serv_arr, $serv_loc;

  if (array_key_exists ( "iiab" , $serv_arr )) {
  	// 1st show a text to indicate we are searching for content	  	
    $link_clause = '<div id="iiab-search" class="xsServiceWrapper"><div class="xsServiceLink">' . $service_link_text . '</div>';
    $search_text = '<div class="xsServiceDesc">' . $service_search_text . '</div></div><div style="clear:both"></div>';    
    echo $link_clause;
    echo $search_text;
    // now the actual link
    $link_clause = '<div id="iiab-link" style="display: none" class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_loc["iiab"] . '">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';    
    echo $link_clause;
    echo $link_desc;
    }
}
?> 
