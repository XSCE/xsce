function squid()
{
	case "$1" in
	"yes")
        touch $SETUPSTATEDIR/squid
        # create the cache directories
        mkdir -p /library/cache
        chown squid:squid /library/cache
        squid -z
        ## Update flag for httpd cache
        if [ ! -e /etc/sysconfig/xs_httpcache_on ]; then
            touch /etc/sysconfig/xs_httpcache_on
            etckeeper-if-selected 'xs-setup force-create httpcache flag'
        fi
        systemctl enable squid.service 2>&1 | tee -a $LOG
        set +x; systemctl start squid.service 2>&1 | tee -a $LOG; set -x

        # need to set up iptables to forward port 80 queries
        # the following script regenerates /etc/sysconfig/iptables
        cp /etc/sysconfig/olpc-scripts/firewall-xs.in /etc/sysconfig/olpc-scripts/firewall-xs
        systemctl restart iptables.service
        ;;
    "no")
        systemctl disable squid.service 2>&1 | tee -a $LOG
        systemctl stop squid.service 2>&1 | tee -a $LOG
        rm /etc/sysconfig/xs_httpcache_on
        rm $SETUPSTATEDIR/squid

        # reinitialize the iptables to just use masqueradeing
        systemctl restart iptables.service
        ;;
    esac
}


