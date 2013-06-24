function monit()
{
	case "$1" in
	"yes")
	    $YUM_CMD monit 
            if [ $? -ne 0 ] ; then
                echo "\n\nYum returned an error\n\n" | tee -a $LOG
                exit $YUMERROR
            fi

            touch $SETUPSTATEDIR/monit
	    #sshd is always enabled
            ln -sf /usr/share/xs-config/cfg/etc/monit.d/sshd /etc/monit.d/sshd

	    for i in ejabberd httpd squid idmgr postgresql
	    do
	        if [ test -a $SETUPSTATEDIR/$i ]
		then
			ln -sf /usr/share/xs-config/cfg/etc/monit.d/$i /etc/monit.d/$i
		else
			rm -f /etc/monit.d/$i
		fi
	    done
		#We wait until next reboot
		systemctl enable monit 2>&1 | tee -a $LOG
        ;;
	"no")
		systemctl disable monit 2>&1 | tee -a $LOG
	        rm $SETUPSTATEDIR/monit
        ;;
	esac
}


