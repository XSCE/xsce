function stats {
	case "$1" in
	"yes")
        $YUM_CMD active-document restful-document sugar-stats-server \
        sugar-stats-client python-xappy 2>&1 | tee -a $LOG
            if [ $? -ne 0 ] ; then
                echo "\n\nYum returned an error\n\n" | tee -a $LOG
                exit $YUMERROR
            fi
        touch $SETUPSTATEDIR/stats
        mkdir -p /library/sugar-stats/rrd
        mkdir -p /library/sugar-stats/log
        cp -f /etc/systemd/system/sugar-stats-server.service.in \
              /etc/systemd/system/sugar-stats-server.service
	chown sugar-stats.sugar-stats /library/sugar-stats -R
        cp -f /etc/sugar-stats.conf.in /etc/sugar-stats.conf
        systemctl enable sugar-stats-server
#        if [ ! -e /home/admin/openssl/server.key ]; then
#            openssl genrsa -des3 -out /home/admin/openssl/server.key 1024
#            cp /home/admin/openssl/server.key /home/admin/openssl/server.key.org
#            openssl rsa -in /home/admin/openssl/server.key.org \
#                    -out /home/admin/openssl/server.key
#        fi
        ;;

    "no")
        systemctl disable sugar-stats-server
        rm $SETUPSTATEDIR/stats
        ;;
    esac
}



