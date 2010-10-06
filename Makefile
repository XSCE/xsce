# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# symbols
PKGNAME = xsau-config
#VERSION = $(shell git describe | sed 's/^v//' | sed 's/-/./g')
VERSION = 0.7.0.4
RELEASE = 1XSAU
ARCH = noarch
#BRANCH = $(shell git branch | grep '*' | sed 's/* //')

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

xsau-config.spec: xsau-config.spec.in
	sed -e 's:@VERSION@:$(VERSION):g' < $< > $@

.PHONY: xsau-config.spec.in
	# This forces a rebuild of xs-config.spec.in

rpm: SOURCES xsau-config.spec
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

	install -D -d $(DESTDIR)/etc
	install -D -d $(DESTDIR)/etc/xinetd.d
	install -D -d $(DESTDIR)/etc/sysconfig
	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts
	install -D -d $(DESTDIR)/var
	install -D -d $(DESTDIR)/var/named-xs
	install -D -d $(DESTDIR)/var/named-xs/data

	install -D altfiles/etc/named-xs.conf.in  $(DESTDIR)/etc
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config    $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/ejabberd $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/idmgr    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/named    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/resolvconf    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/resolv.conf.in           $(DESTDIR)/etc/sysconfig/olpc-scripts

	install -D altfiles/etc/sysconfig/olpc-scripts/mkaccount       $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/network_config  $(DESTDIR)/etc/sysconfig/olpc-scripts/

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

	install -D -d $(DESTDIR)/etc/httpd/conf
	install -D altfiles/etc/httpd/conf/httpd-xs.conf  $(DESTDIR)/etc/httpd/conf

	install -D -d $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd-xs.cfg.in  $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd.pem     $(DESTDIR)/etc/ejabberd

	install -D altfiles/etc/*.in  $(DESTDIR)/etc/

	# fsckoptions goes in / 
	install -D altfiles/fsckoptions  $(DESTDIR)/

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
	install -D altfiles/etc/httpd/conf.d/*.conf     $(DESTDIR)/etc/httpd/conf.d
	install -D altfiles/etc/httpd/conf.d/*.conf.in  $(DESTDIR)/etc/httpd/conf.d

	install -D -d $(DESTDIR)/etc/logrotate.d
	install -D altfiles/etc/logrotate.d/syslog-xslogs  $(DESTDIR)/etc/logrotate.d

	# Pg - nonconflicting
	install -D -d $(DESTDIR)/etc/init.d
	install -D -d $(DESTDIR)/etc/sysconfig/pgsql
	install -D -d $(DESTDIR)/etc/pgsql-xs
	install -D -d $(DESTDIR)/library/pgsql-xs/data-8.3
	install -D altfiles/etc/pgsql-xs/p*.conf $(DESTDIR)/etc/pgsql-xs
	install -D altfiles/etc/sysconfig/pgsql/pgsql-xs $(DESTDIR)/etc/sysconfig/pgsql

	#Non-conflicting init.d scripts
	install -D altfiles/etc/init.d/pgsql-xs $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/no-fsck-questions $(DESTDIR)/etc/init.d
	install -D altfiles/etc/xinetd.d/xs-rsyncd.in $(DESTDIR)/etc/xinetd.d/
	install -D altfiles/etc/xinetd.d/xsactivation.in $(DESTDIR)/etc/xinetd.d/

	# conf.d-style or non-conflicting conffiles that are actually executable scripts...
	install -D altfiles/etc/dhclient-exit-hooks $(DESTDIR)/etc

	install -D -d $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/01_beep_on_mount  $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/99_beep_when_done $(DESTDIR)/etc/usbmount/mount.d

	install -D --mode 750 -d $(DESTDIR)/etc/sudoers.d
	install -D --mode 440 altfiles/etc/sudoers.d/00-base  $(DESTDIR)/etc/sudoers.d
	install -D --mode 440 altfiles/etc/sudoers.d/10-ejabberdmoodle  $(DESTDIR)/etc/sudoers.d

	# scripts
	install -D -d $(DESTDIR)/usr/bin
	install -D scripts/xs-commitchanged $(DESTDIR)/usr/bin
	install -D scripts/cat-parts   $(DESTDIR)/usr/bin
	install -D scripts/xs-swapnics $(DESTDIR)/usr/bin

	install -D -d $(DESTDIR)/sbin
	install -D scripts/ifup-local $(DESTDIR)/sbin

