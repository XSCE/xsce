function gateway()
{
	case "$1" in
	"yes")
        cp /etc/sysconfig/olpc-scripts/iptables-xs.in /etc/sysconfig/olpc-scripts/iptables-xs
        cp /etc/sysconfig/olpc-scripts/ip6tables-xs.in /etc/sysconfig/olpc-scripts/ip6tables-xs
        cp /etc/sysconfig/iptables-config.in /etc/sysconfig/iptables-config

        touch $SETUPSTATEDIR/gateway
        cp  $CFGDIR/etc/systemd/system/iptables.service $DESTDIR/etc/systemd/system

        set +e
        systemctl enable iptables.service
        systemctl enable ip6tables.service
        /etc/sysconfig/iptables-config
        systemctl restart iptables.service
        systemctl restart ip6tables.service
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
