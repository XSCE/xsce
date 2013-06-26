function dansguardian()
{
        case "$1" in
    "yes")
        $YUM_CMD  dansguardian 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/dansguardian

        #execute the setup script
        #Update squid conf
        #save backup
        systemctl stop squid.service
        cp /etc/squid/squid-xs.conf /etc/squid-xs.conf.bkp.`date +%s`
        sed -i 's/http_port 0.0.0.0:3128 transparent/http_port 0.0.0.0:3130/g' /etc/squid/squid-xs.conf
        sed -i 's/#acl localhost/acl localhost/' /etc/squid/squid-xs.conf

        #Update dansguardian conf
        cp /etc/dansguardian/dansguardian.conf.in /etc/dansguardian/dansguardian.conf
        
	systemctl enable dansguardian.service
        systemctl start dansguardian.service        

        ;;
    "no")
        systemctl stop dansguardian
        systemctl disable dansguardian
        rm $SETUPSTATEDIR/dansguardian

        ;;
    esac
}


