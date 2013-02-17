# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /
PLUGINDIR = plugins.d

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
	#rpmlint $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

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
	PLUGINDIRLIST := `ls -d $(PLUGINDIR)`
	(for D in $(PLUGINDIRLIST);do;cd $(D);make -e install;done)
