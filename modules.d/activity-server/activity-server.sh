function activity-server()
{
	case "$1" in
    "yes")
        $YUM_CMD xs-activity-server 2>&1 | tee -a $LOG
            if [ $? -ne 0 ] ; then
                echo "\n\nYum returned an error\n\n" | tee -a $LOG
                exit $YUMERROR
            fi
        #execute the setup script
        /etc/sysconfig/olpc-scripts/setup.d/xs-activity-server
        # permit apache to perform the upload task,
        chgrp -R admin /library/xs-activity-server
        chmod -R 775 /library/xs-activity-server
        # short term addition of link for upload-activity server
        ln -sf /usr/share/xs-config/cfg/html/top/en/cntr_upl_activity.php \
                    /var/www/html/upload_activity.php

        touch $SETUPSTATEDIR/activity-server
        ;;
    "no")
        rm $SETUPSTATEDIR/activity-server
        unlink /etc/httpd/conf.d/xs-activity-server.conf
        ;;
    esac
}


