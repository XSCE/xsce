
function is_network_changed 
{
#========================================================
# 4/14/13   then abort further processing if device names and mac numbers are unchanged
    last_wan_dev=`[ -f /etc/sysconfig/xs_wan_device ] && cat /etc/sysconfig/xs_wan_device`
    last_lan_dev=`[ -f /etc/sysconfig/xs_lan_device ] && cat /etc/sysconfig/xs_lan_device`
    last_wan_mac=`[ -f /etc/sysconfig/xs_wan_mac ] && cat /etc/sysconfig/xs_wan_mac`
    last_lan_mac=`[ -f /etc/sysconfig/xs_lan_mac ] && cat /etc/sysconfig/xs_lan_mac`
    if [ -n "$oth_iface" ] && [ "$oth_iface" = "$last_lan_dev" ];then
        if [ -n "$gw_iface" ] && [ "$gw_iface" = "$last_wan_dev" ];then
            wan_mac=`ifconfig "$wan_iface" | gawk '(/^ *ether /) {print( $2);}'`
            lan_mac=`ifconfig "$oth_iface" | gawk '(/^ *ether /) {print( $2);}'`
            if [ "$last_wan_mac" = "$wan_mac" ] && [ "$last_lan_mac" = "$lan_mac" ];then
                echo "devices and mac numbers identical. xs-setup-network aborted." >> $LOG
                exit 1 # return false, network is not changed
            fi
        fi
    fi
    exit 0 # return true
}
