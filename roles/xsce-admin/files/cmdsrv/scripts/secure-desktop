#!/bin/bash
# close down the vnc remote desktop

/etc/init.d/vnc stop
killall websockify
iptables -D INPUT -p tcp --dport 6080 -j ACCEPT
