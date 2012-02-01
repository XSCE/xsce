# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# symbols
PKGNAME = xs-config
VERSION = $(shell git describe | sed 's/^v//' | sed 's/-/./g')
RELEASE = 1
ARCH = noarch
BRANCH = $(shell git branch | grep '*' | sed 's/* //')

# NOTE: Release is hardcoded in the spec file to 1
NV = $(PKGNAME)-$(VERSION)
REL = 1

RPMBUILD = rpmbuild \
	--define "_topdir $(BUILDDIR)" \

SOURCES: Makefile
	mkdir -p $(BUILDDIR)/BUILD $(BUILDDIR)/RPMS \
	$(BUILDDIR)/SOURCES $(BUILDDIR)/SPECS $(BUILDDIR)/SRPMS
	mkdir -p $(NV)
	git archive --format=tar --prefix="$(NV)/" HEAD > $(NV).tar
	mkdir -p $(NV)
	echo $(VERSION) > $(NV)/build-version
	tar -rf $(NV).tar $(NV)/build-version
	rm -fr $(NV)
	gzip  $(NV).tar
	mv $(NV).tar.gz $(BUILDDIR)/SOURCES/

xs-config.spec: xs-config.spec.in
	sed -e 's:@VERSION@:$(VERSION):g' < $< > $@

.PHONY: xs-config.spec.in
	# This forces a rebuild of xs-config.spec.in

rpm: SOURCES xs-config.spec
	$(RPMBUILD) -ba --target $(ARCH) $(PKGNAME).spec
	rm -fr $(BUILDDIR)/BUILD/$(NV)
	rpmlint $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

# for scp `make rpm-name` ...
rpm-name:
	@echo $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

publish:
	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/11/i586/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/11/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/11/i586
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/11/source/SRPMS

publish-stable:

	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/$(BRANCH)/i586/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/$(BRANCH)/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/i586
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/source/SRPMS


install: $(DESTDIR)

	install -D -d $(DESTDIR)/usr/share/xs-config
	cp -a cfg $(DESTDIR)/usr/share/xs-config

	install -D -d $(DESTDIR)/etc
	install -D -d $(DESTDIR)/etc/sysconfig
	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts
	install -D -d $(DESTDIR)/var
	install -D -d $(DESTDIR)/var/named-xs
	install -D -d $(DESTDIR)/var/named-xs/data

	install -D altfiles/etc/named-xs.conf.in  $(DESTDIR)/etc
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_OFF $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_ON  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.in     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config    $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/dhcpd    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/ejabberd $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/idmgr    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/named    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/squid    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/resolvconf    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/resolv.conf.in           $(DESTDIR)/etc/sysconfig/olpc-scripts

	install -D altfiles/etc/sysconfig/olpc-scripts/iptables-xs.in  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/gen-iptables    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/mkaccount       $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D altfiles/var/named-xs/localdomain.zone         $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/localhost.zone           $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.broadcast          $(DESTDIR)/var/named-xs/ 
	install -D altfiles/var/named-xs/named.ip6.local          $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.local              $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.rfc1912.zones      $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.root               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.root.hints         $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.zero               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.external.zone.db  $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.16.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.32.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.48.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.db               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.in-addr.db.in    $(DESTDIR)/var/named-xs/

	install -D -d $(DESTDIR)/etc/squid
	install -D altfiles/etc/squid/squid-xs.conf.in  $(DESTDIR)/etc/squid

	install -D -d $(DESTDIR)/etc/httpd/conf
	install -D altfiles/etc/httpd/conf/httpd-xs.conf  $(DESTDIR)/etc/httpd/conf

	install -D -d $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd-xs.cfg.in  $(DESTDIR)/etc/ejabberd

	install -D altfiles/etc/*.in  $(DESTDIR)/etc/

	# makefile-driven set
	install -D altfiles/etc/xs-config.make  $(DESTDIR)/etc/
	install -D -m 644 altfiles/etc/rsyslog.conf.in $(DESTDIR)/etc/
	install -D altfiles/etc/sysctl.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/rssh.conf.in    $(DESTDIR)/etc/
	install -D altfiles/etc/motd.in         $(DESTDIR)/etc/
	install -D altfiles/etc/hosts.in        $(DESTDIR)/etc/

	install -D -d $(DESTDIR)/etc/ssh
	install -D altfiles/etc/ssh/sshd_config.in $(DESTDIR)/etc/ssh

	install -D altfiles/etc/sysconfig/*.in $(DESTDIR)/etc/sysconfig

	# conf.d-style conffiles
	install -D -d $(DESTDIR)/etc/httpd/conf.d
	install -D altfiles/etc/httpd/conf.d/*.conf.in  $(DESTDIR)/etc/httpd/conf.d

	# Pg - nonconflicting
	install -D -d $(DESTDIR)/etc/init.d
	install -D -d  $(DESTDIR)/etc/sysconfig/pgsql
	install -D -d $(DESTDIR)/etc/pgsql-xs
	install -D -d $(DESTDIR)/library/pgsql-xs/data-8.3
	install -D altfiles/etc/pgsql-xs/p*.conf $(DESTDIR)/etc/pgsql-xs
	install -D altfiles/etc/sysconfig/pgsql/pgsql-xs $(DESTDIR)/etc/sysconfig/pgsql

	#Non-conflicting init.d scripts
	install -D altfiles/etc/init.d/pgsql-xs $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/ejabberd-xs $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/*.in $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/no-fsck-questions $(DESTDIR)/etc/init.d

	# scripts
	install -D -d $(DESTDIR)/usr/bin
	install -D scripts/xs-commitchanged $(DESTDIR)/usr/bin
	install -D scripts/cat-parts   $(DESTDIR)/usr/bin
	install -D scripts/xs-swapnics $(DESTDIR)/usr/bin
	install -D scripts/xs-setup $(DESTDIR)/usr/bin
	install -D scripts/xs-setup-network $(DESTDIR)/usr/bin
