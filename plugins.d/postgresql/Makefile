install:
	install -D files/idmgr.conf.in  $(DESTDIR)/etc/idmgr.conf.in
	install -D files/postgresql-1024m.conf  $(DESTDIR)/etc/pgsql-xs/postgresql-1024m.conf
	install -D files/postgresql-2048m.conf  $(DESTDIR)/etc/pgsql-xs/postgresql-2048m.conf
	install -D files/postgresql-256m.conf  $(DESTDIR)/etc/pgsql-xs/postgresql-256m.conf
	install -D files/postgresql-512m.conf  $(DESTDIR)/etc/pgsql-xs/postgresql-512m.conf
	install -D files/pgsql-xs  $(DESTDIR)/etc/sysconfig/pgsql/pgsql-xs
	install -D files/pgsql-xs  $(DESTDIR)/library/pgsql-xs
	install -D files/postgresql-xs.service  $(DESTDIR)/usr/share/xs-config/cfg/etc/systemd/system/postgresql-xs.service
	install -D files/pg_hba.conf  $(DESTDIR)/usr/share/xs-config/cfg/library/pgsql-xs/pg_hba.conf
    install -D postgresql.sh $(DESTDIR)/usr/share/xs-config/sh.d/
