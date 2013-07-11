function IIAB()
{
	case "$1" in
	"yes")
        $YUM_CMD Internet-in-a-Box mod_wsgi mod_xsendfile 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/IIAB
        cp `which iiab.wsgi` /var/www/html
        cat <<EOF > /etc/httpd/conf.d/iiab.conf
        XSendFile on
        XSendFilePath /iiab

        <VirtualHost *>
             WSGIScriptAlias /iiab /var/www/html/iiab.wsgi

             <Directory /var/www/iiab>
                 require all granted
             </Directory>
        </VirtualHost>
        EOF

        ;;
    "no")
        rm $SETUPSTATEDIR/IIAB
    ;;
	esac
}

