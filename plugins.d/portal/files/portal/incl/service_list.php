<?php
$serv_loc = array(    
"activity-server" => "",
"moodle-xs" => "/moodle",
"pathagar" => "",
"upload" => "",
"iiab_int" => ""
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

  if (array_key_exists ( "iiab_int" , $serv_arr )) {
    service_link("iiab_int", $service_link_text, $service_link_desc);    
    return;
  }

  if (array_key_exists ( "iiab_ext" , $serv_arr )) {
  	$output = shell_exec('avahi-resolve -n know.local');
    $iiab_name = strtok($output, " \t\n\r");
    $iiab_ip = strtok(' ');
  
    if ($iiab_name != ""){
      $link_clause = '<div class="xsServiceWrapper"></div><div class="xsServiceLink"><a href="' . $iiab_ip . '">' . $service_link_text . '</a></div>';
      $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';
      echo $link_clause;
      echo $link_desc;
    }
  
  }
}
?> 
