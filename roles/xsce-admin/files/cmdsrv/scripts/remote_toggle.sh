#!/bin/bash -x
# toggle the remote flags in /etc/xsce
if [ -f /etc/xsce/ssh_allowed ]; then
  rm /etc/xsce/ssh_allowed
  rm /etc/xsce/openvpn_allowed
  systemctl stop sshd.service
  systemctl disable sshd.service
  systemctl stop openvpn@xscenet.service
  systemctl disable openvpn@xscenet.service
else
  touch /etc/xsce/ssh_allowed
  touch /etc/xsce/openvpn_allowed
  systemctl enable sshd.service
  systemctl start sshd.service
  # determine if user has chosen to enable openvpn
  vpn=`cat /etc/xsce/config_vars.yml|grep openvpn_enabled|cut -d' ' -f2`
  case $vpn in
  "True"|"true"|"TRUE"|"Yes"|"yes"|"YES")
	  systemctl enable openvpn@xscenet.service
	  systemctl start openvpn@xscenet.service
         ;;
  esac
fi  

