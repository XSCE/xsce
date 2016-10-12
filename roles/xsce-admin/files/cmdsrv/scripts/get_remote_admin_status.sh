#!/bin/bash -x
# return the state of remote_admin_allowed, teamviewer_enabled end openvpn_enabled
sleep 1
curdir=$(dirname $0)
source $curdir/status.inc
echo \{\"openvpn_enabled\":\"$openvpn_enabled\",\"teamviewer_enabled\":\"$teamviewer_enabled\",\"remote_admin_allowed\":\"$remote_admin_allowed\",\"handle\":\"$handle\"\}
