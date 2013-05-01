function postgresql()
{
	case "$1" in
	"yes")
	    $YUM_CMD postgresql postgresql-server 2>&1 | tee -a $LOG
            if [ $? -ne 0 ] ; then
                echo "\n\nYum returned an error\n\n" | tee -a $LOG
                exit $YUMERROR
            fi
            touch $SETUPSTATEDIR/postgresql
            install -m 440 $CFGDIR/etc/systemd/system/postgresql-xs.service $DESTDIR/etc/systemd/system
            #cp -f $CFGDIR/etc/systemd/system/postgresql-xs.service \
            #$DESTDIR/lib/systemd/system/
            # systemctl does not enable by linking a link, hence above cp
            systemctl enable postgresql-xs.service 2>&1 | tee -a $LOG

		# Pg - prime the DB if needed.
		if [ ! -e ${POSTGRESSDIR}/PG_VERSION ];then
            # /etc/init.d/pgsql-xs initdb -- this was used before systemd
            # postgresql-setup initdb need to move this edit upstream FIXME
            mkdir -p /library/pgsql-xs
            chown -R postgres:postgres /library/pgsql-xs/
            sed -i -e "s/--auth='ident'\"/--auth='ident' --encoding='UTF8'\"/" \
                                    /usr/bin/postgresql-setup
			/usr/bin/postgresql-setup  initdb postgresql-xs
            sed -i -e '
            /^#standard_conforming_strings/ c\
standard_conforming_strings = off
            ' /library/pgsql-xs/postgresql.conf
            sed -i -e '
            /^#backslash_quote/ c\
backslash_quote = on
            ' /library/pgsql-xs/postgresql.conf
		fi

		# and set it to autostart
		systemctl start postgresql-xs.service 2>&1 | tee -a $LOG
		;;
	"no")
		systemctl disable postgresql-xs.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/postgresql
		;;
	esac
}


