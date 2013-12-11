function idmgr()
{
	case "$1" in
	"yes")
	$YUM_CMD idmgr ds-backup-server \
        xs-rsync xinetd 2>&1 | tee -a $LOG
	if [ $? -ne 0 ] ; then
	    echo "\n\nYum returned an error\n\n" | tee -a $LOG
	    exit $YUMERROR
        fi

        # long term, change the idmgr package
        cp /etc/init.d/idmgr /usr/libexec/idmgr.init

        # execute the xs-rsync setup script
        /etc/sysconfig/olpc-scripts/setup.d/xs-rsync

        # setup ds-backup symlinks to config locations
        /etc/sysconfig/olpc-scripts/setup.d/ds-backup

        cp /etc/systemd/system/idmgr.service.in /etc/systemd/system/idmgr.service

        # set up the sqlite database for idmgr
        /etc/sysconfig/olpc-scripts/setup.d/idmgr

	systemctl enable idmgr.service 2>&1 | tee -a $LOG
	systemctl restart idmgr.service 2>&1 | tee -a $LOG
	systemctl enable xinetd.service 2>&1 | tee -a $LOG
	systemctl restart xinetd.service 2>&1 | tee -a $LOG
        touch $SETUPSTATEDIR/idmgr
        ;;
	"no")
		systemctl disable idmgr.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/idmgr
        ;;
	esac
}


