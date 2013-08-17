function httpd()
{
	case "$1" in
	"yes")
        $YUM_CMD httpd  php 2>&1 | tee -a $LOG
	if [ $? -ne 0 ] ; then
	    echo "\n\nYum returned an error\n\n" | tee -a $LOG
	    exit $YUMERROR
	fi
	touch $SETUPSTATEDIR/httpd

	# point the OLPC configuration during systemd startup
	cp -f /etc/sysconfig/httpd.in /etc/sysconfig/httpd

        # if httpd version is 2.4.4, use new syntax for access control
	if [ $(rpm -q httpd | grep fc17) ]; then
	    cp -pf /etc/httpd/conf/httpd-xs-2.2.conf.in /etc/httpd/conf/httpd-xs.conf |tee -a $LOG
	else
	    cp -pf /etc/httpd/conf/httpd-xs-2.4.conf.in /etc/httpd/conf/httpd-xs.conf |tee -a $LOG

	fi

	# Choose a config depending on memory
	MEMSIZE=$(grep '^MemTotal' /proc/meminfo | grep -oP '\d+')
	CONFMEM=256m
	# Note: the sizes are rounded to a lower value
	#       as they are usually reported a tad lower than the
	#       "proper" MB value in bytes (video cards often steal RAM!).
	if [ $MEMSIZE -gt  500000 ]; then
	    CONFMEM=512m
	fi
	if [ $MEMSIZE -gt 1000000 ]; then
	    CONFMEM=1024m
	fi
	if [ $MEMSIZE -gt 2000000 ]; then
	    CONFMEM=2048m
	fi
	#update the httpd.conf file with this information
	sed -i -e "s/\@\@CONFMEM\@\@/MEM$CONFMEM/" /etc/httpd/conf/httpd-xs.conf

	etckeeper-if-selected "modified /etc/httpd/conf/httpd-xs.conf"
        # for some reason, http does not make the needed directories
        mkdir -p /var/run/httpd
        chown apache:apache /var/log/httpd

        # add apache user to the admin group, so she can write to admin
        usermod -G admin,apache apache

        # Add symlink to 64 bit php modules because we use a 32 bit php.ini
        is32or64bit=`uname -m`
        echo $is32or64bit
        if [[ "$is32or64bit" = "x86_64" ]]; then
          echo "is 64"
          ln -sf /usr/lib64/php /usr/lib/php
        fi

        systemctl enable httpd.service 2>&1 | tee -a $LOG
        systemctl start httpd.service 2>&1 | tee -a $LOG
		;;
	"no")
		systemctl disable httpd.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/httpd
		;;
	esac
}
