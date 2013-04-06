function gateway()
{
	case "$1" in
	"yes")
        cp /etc/sysconfig/olpc-scripts/iptables-xs.in /etc/sysconfig/olpc-scripts/iptables-xs
        cp /etc/sysconfig/olpc-scripts/ip6tables-xs.in /etc/sysconfig/olpc-scripts/ip6tables-xs
        cp /etc/sysconfig/olpc-scripts/firewall-xs.in /etc/sysconfig/olpc-scripts/firewall-xs
        cp /etc/sysconfig/iptables-config.in /etc/sysconfig/iptables-config

        touch $SETUPSTATEDIR/gateway
        cp  $CFGDIR/etc/systemd/system/iptables.service $DESTDIR/etc/systemd/system

        # systemd has a check for exist /etc/sysconfig/iptables - so ensure that it exists
        # the following script regenerates /etc/sysconfig/iptables
        /etc/sysconfig/olpc-scripts/firewall-xs
        iptables-save >/etc/sysconfig/iptables


        systemctl enable iptables.service
        #set +x; systemctl restart iptables.service; set -x
        systemctl enable ip6tables.service
        #systemctl start ip6tables.service
        ;;
	"no")
        # the gateway flag is used to control masquerading in iptables
        rm $SETUPSTATEDIR/gateway
        # the following call removes the httpcache flag and regenerates iptables
        squid no
        ;;
	esac
}


