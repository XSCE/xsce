function dansguardian()
{
        case "$1" in
    "yes")
        $YUM_CMD  dansguardian 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        if ! [ -f /etc/sysconfig/xs_httpcache_on ]
		then
		echo "Squid must be enabled in order to run dansguardian!"
		return 
	fi

	#Create directories
	mkdir -p /library/dansguardian
	chown dansguardian:dansguardian /library/dansguardian -R        

	#Squid must be restarted config file changed	
	systemctl stop squid.service 2>&1 | tee -a $LOG
	cp /etc/sysconfig/squid-dg.in /etc/sysconfig/squid         
	systemctl start squid.service 2>&1 | tee -a $LOG

	#Update dansguardian conf
	cp /etc/dansguardian/dansguardian.conf.in /etc/dansguardian/dansguardian.conf
	systemctl enable dansguardian.service 2>&1 | tee -a $LOG
	systemctl restart dansguardian.service 2>&1 | tee -a $LOG

        touch $SETUPSTATEDIR/dansguardian
        ;;
    "no")
	systemctl stop squid
        cp /etc/sysconfig/squid.in /etc/sysconfig/squid
        systemctl stop dansguardian
        systemctl disable dansguardian
        rm $SETUPSTATEDIR/dansguardian
	systemctl start squid

        ;;
    esac
}


