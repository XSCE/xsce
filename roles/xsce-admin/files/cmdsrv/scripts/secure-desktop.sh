#!/bin/bash
# close down the vnc remote desktop

# delete any rules permitting 6080
rules=`iptables -L INPUT --line-numbers |grep 6080|cut -d" " -f1`
for rulenum in rules; do
  iptables -D $rulenum
done

/etc/init.d/vnc stop
systemctl stop websockify.service
