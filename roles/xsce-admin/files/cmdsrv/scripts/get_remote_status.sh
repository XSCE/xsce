#!/bin/bash -x
# return the state of remote_admin_allowed, teamviewer_enabled end openvpn_enabled
if [ ! -f /etc/xsce/xsce.env ]; then
  exit 1 # this file should exit, do not proceed
fi
remote_admin_allowed=`cat /etc/xsce/xsce.env|grep remote_admin_allowed`
if [ $? -ne 0 ]; then
  echo "remote_admin_allowed=false" >> /etc/xsce/xsce.env
  remote_admin-allowed='false'
fi
if [ ! -f /etc/xsce/config_vars.yml ]; then
  exit 1 # this file should exit, do not proceed
fi
openvpn_enabled=`cat /etc/xsce/config_vars.yml|grep openvpn_enabled|cut -d":" -f2`
teamviewer_enabled=`cat /etc/xsce/config_vars.yml|grep teamviewer_enabled|cut -d":" -f2`
echo \{\"openvpn_enabled\":\"$openvpn_enabled\",\"teamviewer_allowed\":\"$teamviewer_enabled\",\"remote_admin_allowed\":$\"$remote_admin_allowed\"\}
