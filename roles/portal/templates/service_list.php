<?php

$serv_arr  = array();
$serv_arr = parse_ini_file ( '{{service_filelist}}', true);
//$serv_arr = parse_ini_file ( '/etc/xsce/xsce.ini', true);
$rachel_modules = array();

$host  = $_SERVER['HTTP_HOST'];
$protocol  = $_SERVER['REQUEST_SCHEME'];

function service_link($service_key, $service_link_text, $service_link_desc = "")
{
	global $serv_arr;

  if (array_key_exists ( $service_key , $serv_arr )) {
  	output_link_start($serv_arr[$service_key]["path"], $service_link_text);
  	output_link_end($service_link_desc);
  }
}

function hard_link($link_url, $service_link_text, $service_link_desc = "", $realpath = "")
{
  if ($realpath == "") {
  	$realpath = realpath ( "/var/www/html/" . $link_url);
  }
  if (file_exists($realpath)) {
  	output_link_start($link_url, $service_link_text);
  	output_link_end($service_link_desc);
  }
}

function kiwix_link($zim_name, $service_link_text, $service_link_desc = "")
{
	global $serv_arr;
	global $host;
	// global $protocol;

  if (array_key_exists ( "kiwix-serve" , $serv_arr )) {
  	if ($serv_arr["kiwix-serve"]["enabled"]) {
  	  $service_link_url = "http://" . $host . ":" . $serv_arr["kiwix-serve"]["kiwix_port"] . "/" . $zim_name . "/";
  	  output_link_start($service_link_url, $service_link_text);
  	  output_link_end($service_link_desc);
    }
  }
}

function kalite_link($service_link_text, $service_link_desc = "")
{
	global $serv_arr;
	global $host;
	// global $protocol;

  if (array_key_exists ( "kalite" , $serv_arr )) {
  	if ($serv_arr["kalite"]["enabled"]) {
  	  $service_link_url = "http://" . $host . ":" . $serv_arr["kalite"]["port"];
  	  output_link_start($service_link_url, $service_link_text);
  	  output_link_end($service_link_desc);
    }
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
    $link_clause = '<div id="iiab-link" style="display: none" class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $serv_arr["iiab"]["path"] . '" target="_blank">' . $service_link_text . '</a></div>';
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';
    echo $link_clause;
    echo $link_desc;
    }
}

function rachel_link()
{
	global $serv_arr;
	global $rachel_modules;


  if (array_key_exists ( "rachel" , $serv_arr )) {
  	if ($serv_arr["rachel"]["enabled"]) {
  		get_rachel_modules();
  		rachel_links();
    }
  }
}

function get_rachel_modules()
{
	global $serv_arr;
	global $rachel_modules;
	$mod_dir_base = $serv_arr["rachel"]["rachel_content_path"]."/modules";
	$link_url_base = "/rachel/modules";

	if (is_dir($mod_dir_base)) {

    $handle = opendir($mod_dir_base);
    $count = 0;
    while ($file = readdir($handle)) {
        if (preg_match("/^\./", $file)) continue; // skip hidden
        if (is_dir("$mod_dir_base/$file")) { // look in dirs
        	  $link_url = "$link_url_base/$file";
        	  $moddir = "$mod_dir_base/$file";
            $dir = $link_url; // keep name so includes work
            if (file_exists("$moddir/index.htmlf")) { // check for index fragment
                $count++;
                $frag = "index.htmlf";
                $content = file_get_contents("$moddir/$frag");
                preg_match("/<!-- *position *\: *(\d+) *-->/", $content, $match);
                array_push($rachel_modules, array(
                    'file' => $file,
                    'dir'  => $dir, // this is used by the include to know it's directory
                    'frag' => "$moddir/$frag", // this is what is actually included
                    'position' => $match[1]
                ));
            } else {
                # there was no index fragment, so...
                array_push($rachel_modules, array(
                    'file' => $file, // this is the name of the module
                    'dir'  => $dir, // this is the module's directory
                    'frag' => "nofrag.php", // we include a special fragment
                    'position' => 9999
                ));
            }
        }
    }
    closedir($handle);
    if ($count > 0) {
      usort($rachel_modules, 'bypos');
    }
  }
}

function bypos($a, $b) {
  return $a['position'] - $b['position'];
}

function rachel_links()
{
	global $serv_arr;
	global $rachel_modules;

  foreach ($rachel_modules as $mod) {
      $file = $mod['file']; // only matters for modules without a fragment
      $dir  = $mod['dir'];
      include $mod['frag'];
  }
}

function xovis_link($service_link_text, $service_link_desc = "")
{
	global $serv_arr;
	global $host;
	// global $protocol;

  // 6/11/2015 xovis not in xsce.ini
  //if (array_key_exists ( "xovis" , $serv_arr )) {
  	//if ($serv_arr["xovis"]["enabled"]) {
  	  $service_link_url = "http://" . $host . ":5984/xovis/_design/xovis-couchapp/index.html";
  	  output_link_start($service_link_url, $service_link_text);
  	  output_link_end($service_link_desc);
    //}
  //}
}

function output_link_start($service_link_url, $service_link_text)
{
  $link_clause = '<div class="xsServiceWrapper"><div class="xsServiceLink"><a href="' . $service_link_url . '" target="_blank">' . $service_link_text . '</a></div>';
  echo $link_clause;
}

function output_link_end($service_link_desc = "")
{
  if ($service_link_desc != "") {
    $link_desc = '<div class="xsServiceDesc">' . $service_link_desc . '</div></div><div style="clear:both"></div>';
  } else    {
  	//$link_desc = '</div><div style="clear:both"></div>';
  	$link_desc = '</div>';
  }
  echo $link_desc;
}
?>