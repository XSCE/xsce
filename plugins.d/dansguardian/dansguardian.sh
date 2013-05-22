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
        systemctl start squid.service

        #Update dansguardian conf
        cp /etc/dansguardian/dansguardian.conf /etc/dansguardian/dansguardian.conf.bkp.`date +%s`
        sed -i 's/filterport = 8080/filterport = 3128/' /etc/dansguardian/dansguardian.conf
        sed -i 's/proxyport = 3128/proxyport = 3130/' /etc/dansguardian/dansguardian.conf        
        systemctl enable dansguardian.service
        systemctl restart dansguardian.service        
        ;;
    "no")
        rm $SETUPSTATEDIR/dansguardian
        ;;
    esac
}


