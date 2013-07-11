function IIAB()
{
	case "$1" in
	"yes")
        $YUM_CMD Internet-in-a-Box mod_wsgi mod_xsendfile 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        ln -sf /bin/iiab.wsgi /var/www/html/iiab.wsgi
	if [ ! -f $SETUPSTATEDIR/IIAB ]; then
	    cat << EOF >> /etc/httpd/conf/http.conf
XSendFile on
XSendFilePath /
WSGIScriptAlias /iiab /var/www/iiab.wsgi
EOF
	fi
        cat << EOF > /etc/httpd/conf.d/iiab.conf
Redirect /iiab http://schoolserver:25000/iiab
EOF
        touch $SETUPSTATEDIR/IIAB
        ;;
    "no")
        rm $SETUPSTATEDIR/IIAB
    ;;
	esac
}

