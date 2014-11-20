function named()
{
	case "$1" in
	"yes")
        $YUM_CMD bind bind-utils 2>&1 | tee -a $LOG
        # if xs data files are installed before bind, named user doesn't exist,
        # and group ownership is set to root, which user named cannot read
        if [ -d /var/named-xs ]; then
            chown -R named /var/named-xs
        fi
        systemctl enable named.service 2>&1 | tee -a $LOG
        systemctl restart named.service 2>&1 | tee -a $LOG
        touch $SETUPSTATEDIR/named
        ;;
	"no")
		systemctl disable named.service 2>&1 | tee -a $LOG
		systemctl stop named.service 2>&1 | tee -a $LOG
        # let the dhclinet control the name resolution normally
        #rm /etc/sysconfig/olpc-scripts/resolv.conf
        rm $SETUPSTATEDIR/named
        ;;
	esac
}
