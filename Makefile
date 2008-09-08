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

publish:
	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/9/i386/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/9/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/9/i386
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/9/source/SRPMS

publish-stable:

	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/$(BRANCH)/i386/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/$(BRANCH)/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/i386
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/source/SRPMS


install: $(DESTDIR)

	install -D -d $(DESTDIR)/etc
	install -D -d $(DESTDIR)/etc/sysconfig
	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts
	install -D -d $(DESTDIR)/var
	install -D -d $(DESTDIR)/var/named-xs
	install -D -d $(DESTDIR)/var/named-xs/data

	install -D altfiles/etc/named-xs.conf.in  $(DESTDIR)/etc
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_OFF $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_ON  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.1     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.2     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.3     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.4     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.5     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.6     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.7     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.8     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config    $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/dhcpd    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/ejabberd $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/idmgr    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/named    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/squid    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/resolvconf    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/resolv.conf.in           $(DESTDIR)/etc/sysconfig/olpc-scripts

	install -D altfiles/etc/sysconfig/olpc-scripts/ip6tables    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal.cache  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/mkaccount    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/network_config $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/network-scripts
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-lanbond0    $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-lanbond0:1  $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-mshbond0    $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-mshbond1    $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-mshbond2    $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-eth0   $(DESTDIR)/etc/sysconfig/olpc-scripts/ifcfg-eth0
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-eth1   $(DESTDIR)/etc/sysconfig/olpc-scripts/ifcfg-eth1
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-msh0   $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-msh1   $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-msh2   $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-wlan0  $(DESTDIR)/etc/sysconfig/network-scripts
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-wlan1  $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/ifcfg-wlan2  $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/route-eth0     $(DESTDIR)/etc/sysconfig/network-scripts/
	install -D altfiles/etc/sysconfig/network-scripts/route-lanbond0 $(DESTDIR)/etc/sysconfig/network-scripts/


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

	install -D -d $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd.cfg.in  $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd.pem     $(DESTDIR)/etc/ejabberd

	install -D altfiles/etc/resolv.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/idmgr.conf.in  $(DESTDIR)/etc/

	# fsckoptions goes in / 
	install -D altfiles/fsckoptions  $(DESTDIR)/

	# makefile-driven set
	install -D altfiles/etc/xs-config.make  $(DESTDIR)/etc/
	install -D altfiles/etc/syslog.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/sysctl.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/yum.conf.in     $(DESTDIR)/etc/
	install -D altfiles/etc/rssh.conf.in    $(DESTDIR)/etc/
	install -D altfiles/etc/motd.in         $(DESTDIR)/etc/
	install -D altfiles/etc/hosts.in        $(DESTDIR)/etc/

	install -D -d $(DESTDIR)/etc/ssh
	install -D altfiles/etc/ssh/sshd_config.in $(DESTDIR)/etc/ssh

	install -D altfiles/etc/sysconfig/dhcpd.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/init.in  $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/named.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/squid.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/iptables-config.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/network.in $(DESTDIR)/etc/sysconfig

	# conf.d-style conffiles
	install -D -d $(DESTDIR)/etc/httpd/conf.d
	install -D altfiles/etc/httpd/conf.d/mime_olpc.conf  $(DESTDIR)/etc/httpd/conf.d

	install -D -d $(DESTDIR)/etc/yum.repos.olpc.d
	install -D altfiles/etc/yum.repos.olpc.d/testing.repo $(DESTDIR)/etc/yum.repos.olpc.d
	install -D altfiles/etc/yum.repos.olpc.d/stable.repo  $(DESTDIR)/etc/yum.repos.olpc.d

	install -D -d $(DESTDIR)/etc/logrotate.d
	install -D altfiles/etc/logrotate.d/syslog-xslogs  $(DESTDIR)/etc/logrotate.d

	install -D -d $(DESTDIR)/etc/modprobe.d
	install -D altfiles/etc/modprobe.d/xs_bonding  $(DESTDIR)/etc/modprobe.d

	# conf.d-style or non-conflicting conffiles that are actually executable scripts...
	install -D altfiles/etc/dhclient-exit-hooks $(DESTDIR)/etc

	install -D -d $(DESTDIR)/etc/udev/rules.d
	install -D altfiles/etc/udev/rules.d/10-olpcmesh.rules    $(DESTDIR)/etc/udev/rules.d
	install -D altfiles/etc/udev/rules.d/65-xsmeshnames.rules $(DESTDIR)/etc/udev/rules.d

	install -D -d $(DESTDIR)/etc/init.d

	install -D -d $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/01_beep_on_mount  $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/99_beep_when_done $(DESTDIR)/etc/usbmount/mount.d

	install -D --mode 750 -d $(DESTDIR)/etc/sudoers.d
	install -D --mode 440 altfiles/etc/sudoers.d/00-base  $(DESTDIR)/etc/sudoers.d

	# scripts
	install -D -d $(DESTDIR)/usr/bin
	install -D scripts/xs-commitchanged $(DESTDIR)/usr/bin
	install -D scripts/cat-parts   $(DESTDIR)/usr/bin
	install -D scripts/xs-swapnics $(DESTDIR)/usr/bin

	install -D -d $(DESTDIR)/sbin
	install -D scripts/ifup-local $(DESTDIR)/sbin

	install -D -d $(DESTDIR)/lib/udev
	install -D scripts/udev-mesh-namer $(DESTDIR)/lib/udev/mesh-namer
