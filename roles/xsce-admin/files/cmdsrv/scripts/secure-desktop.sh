#!/bin/bash
# close down the vnc remote desktop

/etc/init.d/vnc stop
systemctl stop websockify.service
iptables -D INPUT -p tcp --dport 6080 -j ACCEPT
