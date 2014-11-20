function avahi()
{
	case "$1" in
	"yes")
	    $YUM_CMD nss-mdns avahi avahi-tools avahi-ui 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        systemctl enable avahi-daemon.service 2>&1 | tee -a $LOG
        touch $SETUPSTATEDIR/avahi
        ;;
	"no")
	systemctl disable avahi-daemon.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/avahi
        ;;
	esac
}


