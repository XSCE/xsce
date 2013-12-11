# new code to use NetworkManager to set up devices
# copied verbatim from xs-setup-network
function write_nm_connection(){
    # receives connection_filename, hwaddr,  device_name as parameters
    cp "/usr/share/xs-config/cfg/etc/NetworkManager/system-connections/$1" \
        "/etc/NetworkManager/system-connections/$1"
    #removed -i to try to get rid of sed intermediate files 9/24/2012
    sed -i  "s/\@\@MAC\@\@/$2/" "/etc/NetworkManager/system-connections/$1"
    sed -i  "s/\@\@DEVICE\@\@/$3/" "/etc/NetworkManager/system-connections/$1"
    chmod 600 "/etc/NetworkManager/system-connections/$1"
}

function setlan()
# a GUI action routine
{
    if [ "$#" != 1 ];then
        exit 1
    fi
    IP=`echo $1 | gawk 'BEGIN {FS=":"} {print $1}'`
    MASK=`echo $1 | gawk 'BEGIN {FS=":"} {print $2}'`
    GATEWAY=`echo $1 | gawk 'BEGIN {FS=":"} {print $3}'`
    DNS=`echo $1 | gawk 'BEGIN {FS=":"} {print $4}'`
    if [ "$IP" == "0.0.0.0" ]; then
        # user wants a dhcp client config
        mac=`ifconfig | gawk 'BEGIN { eth="";} (/^.*: flags=/) {eth = $1;}
            /^ *ether / { if (eth == "eth1:") print( $2);}'`
        write_nm_connection "dhcp" "$mac" "eth1"
        rm -f /etc/NetworkManager/system-connections/static
    else
        mac=`ifconfig | gawk 'BEGIN { eth="";} (/^.*: flags=/) {eth = $1;}
            /^ *ether / { if (eth == "eth1:") print( $2);}'`
        write_nm_connection "static" "$mac" "eth1"
        sed -i -e "
    /^addresses1=/ c\
addresses1=$IP;$MASK;$GATEWAY;" /etc/NetworkManager/system-connctions/static
        sed -i -e "
    /^dns=/ c\
dns=$GATEWAY;" /etc/NetworkManager/system-connections/static
        rm -f /etc/NetworkManager/system-connections/dhcp
    fi
}

function setwan()
# a GUI action routine
{
    if [ "$#" != 1 ];then
        exit 1
    fi

    # Determine the number of interfaces
    num_ifaces=`ls /sys/class/net | wc | gawk '{print $1}'`
    if [ $num_ifaces = 3 && "$ISXO" == "1" ]; then
        wanif="eth2"
    else
        wanif="eth0"
    fi
    IP=`echo $1 | gawk 'BEGIN {FS=":"} {print $1}'`
    MASK=`echo $1 | gawk 'BEGIN {FS=":"} {print $2}'`
    GATEWAY=`echo $1 | gawk 'BEGIN {FS=":"} {print $3}'`
    DNS=`echo $1 | gawk 'BEGIN {FS=":"} {print $4}'`
    if [ "$IP" == "0.0.0.0" ]; then
        # user wants a dhcp client config
        mac=`ifconfig | gawk 'BEGIN { eth="";} (/^.*: flags=/) {eth = $1;}
            /^ *ether / { if (eth == "$wanif:") print( $2);}'`
        write_nm_connection "dhcp" "$mac" "$wanif"
        rm -f /etc/NetworkManager/system-connections/static
    else
        mac=`ifconfig | gawk 'BEGIN { eth="";} (/^.*: flags=/) {eth = $1;}
            /^ *ether / { if (eth == "$wanif:") print( $2);}'`
        write_nm_connection "static" "$mac" "eth1"
        sed -i -e "
    /^addresses1=/ c\
addresses1=$IP;$MASK;$GATEWAY;" /etc/NetworkManager/system-connctions/static
        sed -i -e "
    /^dns=/ c\
dns=$GATEWAY;" /etc/NetworkManager/system-connections/static
        rm -f /etc/NetworkManager/system-connections/dhcp
    fi
}


