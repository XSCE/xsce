function ejabberd()
{
	case "$1" in
	"yes")
            if [ -e /etc/ejabberd/ejabberd.pem ]; then
                if [ -e /var/lib/ejabberd/spool ]; then
                    rm -rf /var/lib/ejabberd/spool
                fi
                rm -f /etc/ejabberd/ejabberd.pem
                $YUM_REINSTALL ejabberd 2>&1 | tee -a $LOG
            else
                $YUM_CMD ejabberd 2>&1 | tee -a $LOG
		    fi
            if [ $? -ne 0 ] ; then
		        echo "\n\nYum returned an error\n\n" | tee -a $LOG
		        exit $YUMERROR
		    fi
            touch $SETUPSTATEDIR/ejabberd
            chkconfig ejabberd-xs on
            # and set it to autostart
            #systemctl enable ejabberd-xs.service 2>&1 | tee -a $LOG
            
            # the follwoing change to ejabbeerdctl tells to write a pid file
            # it needs to be a place where ejabberd can write
            cp -f /etc/ejabberd/ejabberdctl.cfg.in /etc/ejabberd/ejabberdctl.cfg
            # create a place and permissions for pid file to be written
            #mkdir -p /var/run/ejabberd
            #chown ejabberd:ejabberd /var/run/ejabberd
            # it turns out that /var/run is a tmpfs, so I created in init.d/ejabberd-xs

            # can get a reliable start if the following:
            set +e;
            killall beam
            killall epmd;set -e

            echo "the following start command executes for a long time. Have a cup of coffee!"
            /etc/init.d/ejabberd-xs start 2>&1 | tee -a $LOG
		;;
	"no")
            set +e;
            killall beam
            killall epmd;set -e
            systemctl disable ejabberd.service 2>&1 | tee -a $LOG
            systemctl stop ejabberd.service 2>&1 | tee -a $LOG
            rm $SETUPSTATEDIR/ejabberd
		;;
		esac
}


