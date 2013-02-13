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
        systemctl enable dhcpd.service 2>&1 | tee -a $LOG
        systemctl start dhcpd.service 2>&1 | tee -a $LOG
        ;;
	"no")
		systemctl disable dhcpd.service 2>&1 | tee -a $LOG
        systemctl stop dhcpd.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/dhcpd
        ;;
	esac
}


