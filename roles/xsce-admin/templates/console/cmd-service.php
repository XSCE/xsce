<?php
/*
*  xsce-cmdsrv service handler
*  Connects DEALER socket to ipc:///run/cmdsrv_sock
*  Sends command, expects response json back
*/

//  Socket to talk to server
$command = $_POST['command'];
//echo "Command: $command <BR>";
$context = new ZMQContext();
$requester = new ZMQSocket($context, ZMQ::SOCKET_DEALER);
$requester->connect("ipc:///run/cmdsrv_sock");
$requester->send($command);
$reply = $requester->recv();
header('Content-type: application/json');
echo $reply;
?>
