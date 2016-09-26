#!/bin/bash -x
# create an override which enables/disables remote admin, attach to button

# get the current status
curdir=$(dirname $0)
source $curdir/status.inc

# error if no control parameter
if [ $# -ne 1 ]; then
   exit 1
fi
if [ "$1" == "true" ]; then

  # error if the variable does not exist
  grep remote_admin_allowed /etc/xsce/xsce.env
  if [ $? -ne 0 ];then
     exit 1
  fi
  sed -i -e 's/^remote_admin_allowed.*/remote_admin_allowed=true/' /etc/xsce/xsce.env
  if [ "$openvpn_enabled" == "true" ];then
     systemctl enable openvpn@xscenet
     systemctl start openvpn@xscenet
  fi
  if [ "$teamviewer_enabled" == "true" ];then
     systemctl enable teamviewer
     systemctl start teamviewer
  fi
else
  sed -i -e 's/^remote_admin_allowed.*/remote_admin_allowed=false/' /etc/xsce/xsce.env
  systemctl stop openvpn@xscenet.service
  systemctl disable openvpn@xscenet.service
  systemctl stop teamviewer
  systemctl disable teamviewer
fi
