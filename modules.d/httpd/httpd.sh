function httpd()
{
	case "$1" in
	"yes")
        touch $SETUPSTATEDIR/httpd
        cp -p /etc/httpd/conf/httpd-xs.conf.in /etc/httpd/conf/httpd-xs.conf
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
        systemctl start httpd.service 2>&1 | tee -a $LOG
		systemctl enable httpd.service 2>&1 | tee -a $LOG
        # add apache user to the admin group, so she can write to admin
        usermod -G admin,apache apache
        # for some reason, http does not make the needed directories
        mkdir -p /var/log/httpd
        mkdir -p /var/run/httpd
        chown apache:apache /var/log/httpd
        chown apache:apache /var/run/httpd
        touch $SETUPSTATEDIR/httpd

        # Add symlink to 64 bit php modules because we use a 32 bit php.ini
        is32or64bit=`uname -m`
        echo $is32or64bit
        if [[ "$is32or64bit" = "x86_64" ]]; then
          echo "is 64"
          ln -s /usr/lib64/php /usr/lib/php
        fi
		;;
	"no")
		systemctl disable httpd.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/httpd
		;;
	esac
}


