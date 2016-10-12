#!/bin/bash -x
# return the state of remote_admin_allowed, teamviewer_enabled, openvpn_enabled and handle

if [ ! -f /etc/xsce/xsce.env ]; then
  exit 1 # this file should exist, do not proceed
fi

remote_admin_allowed=`cat /etc/xsce/xsce.env|grep REMOTE_ADMIN_ALLOWED|cut -d= -f2`
if [ $? -ne 0 ]; then
  echo "REMOTE_ADMIN_ALLOWED=False" >> /etc/xsce/xsce.env
  remote_admin_allowed=False
fi

if [ ! -f /etc/xsce/config_vars.yml ]; then
  exit 1 # this file should exit, do not proceed
fi
openvpn_enabled=`cat /etc/xsce/config_vars.yml|grep openvpn_enabled|cut -d":" -f2`
openvpn_enabled=${openvpn_enabled# }
teamviewer_enabled=`cat /etc/xsce/config_vars.yml|grep teamviewer_enabled|cut -d":" -f2`
teamviewer_enabled=${teamviewer_enabled# }

# get the handle
if [ -f /etc/xsce/handle ]; then
  handle=`cat /etc/xsce/handle`
else
  echo "default handle" >> /etc/xsce/handle
  handle="default handle"
fi

