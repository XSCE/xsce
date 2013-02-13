function opendns()
{
	case "$1" in
    "yes")
        if [ "$#" -lt 2 ]; then
            echo "You must enter an IP address in the form 123.456.789.123"
            exit 1
        fi

        # make the simplifying assumption that if opendns is wanted, it must be
        #   enforced by the localhost name server via named
        if [ ! -e $SETUPSTATEDIR/named]; then
            named yes
        fi
        sed -i -e "
        /\@\@forwarders\@\@/ c\
        forwarders      {$2;}; //@@forwarders@@" /etc/named-xs.conf
        echo $2 > /etc/sysconfig/xs_opendns_ip
        systemctl restart named.service

        # need for force name resolution to be through local named
        # so drop a script to ensure this in the wan NM up dir
        ln -s /$CFGDIR/etc/NetworkManager/dispatcher.d/xs-net-device \
                /etc/NetworkManager/dispatcher.d/

        touch $SETUPSTATEDIR/opendns
        ;;
    "no")
        # remove the rerouting through named and forwarders - dont error out
        set +e; unlink /etc/NetworkManager/dispatcher.d/xs-wan-opendns-up; set -e;

        sed -i -e '
        /\@\@forwarders\@\@/ c\
        // @@forwarders@@ disabled ; //@@forwarders@@' /etc/named-xs.conf
        systemctl restart named.service
        rm $SETUPSTATEDIR/opendns
        ;;
    esac
}



