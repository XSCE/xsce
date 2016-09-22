#!/bin/bash
# return the state of ssh and openvpn
if [ -f /etc/xsce/openvpn_allowed ]; then
  vpn=True
else
  vpn=False
fi
if [ -f /etc/xsce/ssh_allowed ]; then
  ssh=True
else
  ssh=False
fi
rtn="{\"openvpn_allowed\":\"$vpn\",'ssh_allowed':\"$ssh\"}"
echo $rtn
