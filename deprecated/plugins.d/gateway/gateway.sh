function gateway()
{
	case "$1" in
	"yes")
        $YUM_CMD iptables iptables-services 2>&1 | tee -a $LOG 
        cp /etc/sysconfig/olpc-scripts/iptables-xs.in /etc/sysconfig/olpc-scripts/iptables-xs
        cp /etc/sysconfig/olpc-scripts/ip6tables-xs.in /etc/sysconfig/olpc-scripts/ip6tables-xs
        cp /etc/sysconfig/iptables-config.in /etc/sysconfig/iptables-config

        touch $SETUPSTATEDIR/gateway
        cp  $CFGDIR/etc/systemd/system/iptables.service $DESTDIR/etc/systemd/system

        set +e
        systemctl stop firewalld.service 2>&1 | tee -a $LOG
        systemctl disable firewalld.service 2>&1 | tee -a $LOG
        systemctl enable iptables.service 2>&1 | tee -a $LOG
        systemctl enable ip6tables.service 2>&1 | tee -a $LOG

        /etc/sysconfig/iptables-config 2>&1 | tee -a $LOG
        # we're going to reload when the network is configured.
        # Lets not do this now.
        #systemctl restart iptables.service

        # TODO figure out the bestway to handle ipv6   	
        systemctl restart ip6tables.service 2>&1 | tee -a $LOG
        set -e
        ;;
	"no")
        # the gateway flag is used to control masquerading in iptables
        rm $SETUPSTATEDIR/gateway
        # the following call removes the httpcache flag and regenerates iptables
        squid no
        ;;
	esac
}
