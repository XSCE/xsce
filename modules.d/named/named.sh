function named()
{
	case "$1" in
	"yes")
            touch $SETUPSTATEDIR/named
        cp /etc/sysconfig/olpc-scripts/resolv.conf.in /etc/sysconfig/olpc-scripts/resolv.conf
        # if xs data files are installed before bind, named user doesn't exist,
        # and group ownership is set to root, which user named cannot read
        if [ -d /var/named-xs ]; then
            chgrp -R named /var/named-xs
        fi
        systemctl enable named.service 2>&1 | tee -a $LOG
        systemctl start named.service 2>&1 | tee -a $LOG
        ;;
	"no")
		systemctl disable named.service 2>&1 | tee -a $LOG
		systemctl stop named.service 2>&1 | tee -a $LOG
        # let the dhclinet control the name resolution normally
        set +x
        #rm /etc/sysconfig/olpc-scripts/resolv.conf
        rm $SETUPSTATEDIR/named
        set -x
        ;;
	esac
}


