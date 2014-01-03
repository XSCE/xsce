function moodle()
{
	case "$1" in
	"yes")
        # execute the moodle startup script
        /usr/libexec/moodle-xs-init start 2>&1 | tee -a $LOG
        # we've dropped a file in /etc/httpd/conf.d, pick up the change
        cp /etc/systemd/system/moodle-xs.service.in /etc/systemd/system/moodle-xs.service
        cp -p /etc/httpd/conf.d/010-make-moodle-default.conf.in \
                    /etc/httpd/conf.d/010-make-moodle-default.conf
        systemctl -f enable moodle-xs.service
        touch $SETUPSTATEDIR/moodle-xs
        systemctl restart httpd.service 2>&1 | tee -a $LOG
	;;

	"no")
        /usr/libexec/moodle-xs-init stop 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/moodle-xs
        rm /etc/httpd/conf.d/010-make-moodle-default.conf
	;;
	esac
}


