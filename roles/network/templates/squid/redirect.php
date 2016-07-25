<?php
  $portal = file_get_contents("/etc/xsce/portal");
  header( "Location: http://schoolserver".$portal );
?>
