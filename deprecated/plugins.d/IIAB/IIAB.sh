function IIAB()
{
	case "$1" in
	"yes")
        $YUM_CMD Internet-in-a-Box mod_wsgi mod_xsendfile Whoosh backports.lzma 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
## future use
        ln -sf /bin/iiab.wsgi /var/www/html/iiab.wsgi
	if [ ! -f $SETUPSTATEDIR/IIAB ]; then
	    cat << EOF > /etc/httpd/conf.d/iiab.conf
XSendFile on
XSendFilePath /
WSGIScriptAlias /iiab /var/www/html/iiab.wsgi
Alias /iiabstatic /usr/lib/python2.7/site-packages/iiab/static

<Directory /usr/lib/python2.7/site-packages/iiab/static>
	require all granted
</Directory>
EOF
	fi

	## temp workaround for above
#        cat << EOF > /etc/httpd/conf.d/iiab.conf
#Redirect /iiab http://schoolserver:25000/iiab
#EOF
	## started from rc.local on reboots
#        /bin/iiab-server &
        touch $SETUPSTATEDIR/IIAB
	
        ;;
    "no")
        rm $SETUPSTATEDIR/IIAB
    ;;
	esac
}

