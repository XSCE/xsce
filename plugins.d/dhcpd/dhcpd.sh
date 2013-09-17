function dhcpd()
{
	case "$1" in
	"yes")
	    $YUM_CMD dhcp 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/dhcpd
        # fc18 (olpc 13.2.0) failed to start because leases file didn't exist
        touch /var/lib/dhcpd/dhcpd.leases
        chown dhcpd:dhcpd /var/lib/dhcpd/dhcpd.leases
        systemctl enable dhcpd.service 2>&1 | tee -a $LOG
	# release 0.4 defer dchpd startup until network is up
        #systemctl start dhcpd.service 2>&1 | tee -a $LOG
        ;;
	"no")
		systemctl disable dhcpd.service 2>&1 | tee -a $LOG
        systemctl stop dhcpd.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/dhcpd
        ;;
	esac
}


