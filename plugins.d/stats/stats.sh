function stats {
	case "$1" in
	"yes")
        mkdir -p /library/sugar-stats/rrd
        mkdir -p /library/sugar-stats/log
        if [ ! -e /home/admin/openssl/server.key c]; then
            openssl genrsa -des3 -out /home/admin/openssl/server.key 1024
            cp /home/admin/openssl/server.key /home/admin/openssl/server.key.org
            openssl rsa -in /home/admin/openssl/server.key.org \
                    -out /home/admin/openssl/server.key
        fi
        ;;

    "no")
        ;;
}



