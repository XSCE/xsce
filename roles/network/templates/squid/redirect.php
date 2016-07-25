<?php
  $portal = file_get_contents("/etc/xsce/portal");
  header( "Location: http://{{ xsce_hostname }}.{{ xsce_domain }}$portal );
?>
