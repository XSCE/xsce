#!/bin/bash
# start the vnc server and websockify server
/etc/init.d/vnc start

# open the new port for direct access to the websocket
iptables -I INPUT -p tcp --dport 6080 -j ACCEPT

# launch the websocket server
systemctl start websockify.service
