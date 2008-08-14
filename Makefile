# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

SCRIPTS = symlink-tree.py unlink-tree.py
OLPCROOT = fsroot.olpc

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# olpc configuration tree
OLPCIMG = fsroot.olpc.img

# symbols
PKGNAME = xs-config
VERSION = $(shell git describe | sed 's/^v//' | sed 's/-/./g')
RELEASE = 1
ARCH = noarch

# NOTE: Release is hardcoded in the spec file to 1
NV = $(PKGNAME)-$(VERSION)
REL = 1

RPMBUILD = rpmbuild \
	--define "_topdir $(BUILDDIR)" \

SOURCES: Makefile $(SCRIPTS)
	mkdir -p $(BUILDDIR)/BUILD $(BUILDDIR)/RPMS \
	$(BUILDDIR)/SOURCES $(BUILDDIR)/SPECS $(BUILDDIR)/SRPMS
	mkdir -p $(NV)
	cp -p Makefile $(NV)
	rsync -ar $(OLPCIMG)/ $(NV)/$(OLPCROOT)
	rsync -ar altfiles/ $(NV)/altfiles
	cp -p $(SCRIPTS) $(NV)/$(OLPCROOT)
	tar czf $(BUILDDIR)/SOURCES/$(NV).tar.gz $(NV)
	rm -rf $(NV)

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
	    xs-dev.laptop.org:/xsrepos/testing/olpc/7/i386/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/7/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/7/i386

install: $(OLPCROOT) $(DESTDIR)
	rsync -ar $(OLPCROOT) $(DESTDIR)

	install -D -d $(DESTDIR)/etc
	install -D -d $(DESTDIR)/etc/sysconfig
	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts
	install -D -d $(DESTDIR)/var
	install -D -d $(DESTDIR)/var/named-xs


	install -D altfiles/etc/named-xs.conf.in  $(DESTDIR)/etc
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_OFF $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_ON  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/auxiliary_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.1     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.1.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.2     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.2.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/ 
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.3     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.3.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.4     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.4.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.5     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.5.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.6     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.6.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.7     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.7.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.8     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.8.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config    $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/dhcpd    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/ejabberd $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/idmgr    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/named    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/squid    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d

	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-dummy0 $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth0.auxiliary $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth1   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh1   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh2   $(DESTDIR)/etc/sysconfig/olpc-scripts/ 
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-tun0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ip6tables    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.auxiliary  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal.cache  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/mkaccount    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/network_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/principal_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
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
