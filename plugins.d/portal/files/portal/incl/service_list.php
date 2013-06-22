<?php
$serv_loc = array(    
"activity-server" => "",
"iiab" => "/iiab/redir",
"moodle-xs" => "/moodle",
"pathagar" => "",
"upload" => ""
);

$serv_arr  = array();
$temp =  shell_exec('ls /etc/sysconfig/olpc-scripts/setup.d/installed');
$tok = strtok($temp, " \n\t\r");

while ($tok !== false) {
//    echo "Word=$tok<br />";
    $tok = strtok(" \n\t\r");
    $serv_arr[$tok] = 1;
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

function iiab_link($service_link_text, $service_link_desc)
{
	global $serv_arr, $serv_loc;

  if (array_key_exists ( "iiab" , $serv_arr )) {  	  	
    $link_clause = '<div id="iiab-link" style="display: none" class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_loc["iiab"] . '">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';    
    echo $link_clause;
    echo $link_desc;
    }
}
?> 
