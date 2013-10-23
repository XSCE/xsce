<?php

$serv_arr  = array();
$serv_arr = parse_ini_file ( '{{service_filelist}}', true);

var_dump ($serv_arr);

function service_link($service_key, $service_link_text, $service_link_desc)
{
	global $serv_arr;

  if (array_key_exists ( $service_key , $serv_arr )) {
    $link_clause = '<div class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_arr[$service_key]["path"] . '">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';
    echo $link_clause;
    echo $link_desc;
  }
}

function iiab_link($service_link_text, $service_link_desc, $service_search_text)
{
	global $serv_arr;

  if (array_key_exists ( "iiab" , $serv_arr )) {
  	// 1st show a text to indicate we are searching for content	  	
    $link_clause = '<div id="iiab-search" class="xsServiceWrapper"><div class="xsServiceLink">' . $service_link_text . '</div>';
    $search_text = '<div class="xsServiceDesc">' . $service_search_text . '</div></div><div style="clear:both"></div>';    
    echo $link_clause;
    echo $search_text;
    // now the actual link
    $link_clause = '<div id="iiab-link" style="display: none" class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_arr["iiab"]["path"] . '">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';    
    echo $link_clause;
    echo $link_desc;
    }
}
?> 
