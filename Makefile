# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /
PLUGINS_ROOT := $(CURDIR)/plugins.d/
MYENV = 'DESTDIR=$(DESTDIR)'
PLUGINDIRLIST := $(shell find $(PLUGINS_ROOT) -maxdepth 1 -type d  -print )
$(warning PLUGINDIRLIST IS $(PLUGINDIRLIST))

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# symbols
# The following should permit branding, without affecting function of school server
PKGNAME = XSCE
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
xsce.spec: xsce.spec.in
	sed -e 's:@VERSION@:$(VERSION):g' < $< > $@
	sed -e 's:@PKGNAME@:$(PKGNAME):g' < $< > $@

.PHONY: xsce.spec.in
	# This forces a rebuild of xs-config.spec.in

rpm: SOURCES xsce.spec
	$(RPMBUILD) -ba --target $(ARCH) xsce.spec
	rm -fr $(BUILDDIR)/BUILD/$(NV)
	#rpmlint $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

# for scp `make rpm-name` ...
rpm-name:
	@echo $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

publish:
	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xsce.activitycentral.com:/repos/xsce/devel/RPMS/noarch/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xsce.activitycentral.com:/repos/xsce/devel/SRPMS/
	ssh xsce.activitycentral.com sudo createrepo /repos/xsce/devel

publise-stable:

	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xsce.activitycentral.com:/repos/xsce/devel/$(BRANCH)/i586/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xsce.activitycentral.com:/xsrepos/testing/olpc/$(BRANCH)/source/SRPMS/
	ssh xsce.activitycentral.com sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/i586
	ssh xsce.activitycentral.com sudo createrepo /xsrepos/testing/olpc/$(BRANCH)/source/SRPMS
MY = one two

install:
	# Makefile at PLUGINS_ROOT creates all the directories in BUILDROOT
	(cd $(PLUGINS_ROOT); $(MAKE) $(MFLAGS) $(MYENV)  install)
	@for D in $(PLUGINDIRLIST); do \
		(cd $$D; echo $$D; $(MAKE)  $(MFLAGS) $(MYENV) install) \
	done
# use print-<macro> from command line to inspect its value
print-%: ; @echo $* is $($*)
# cause shell commands to output the rules being executed
#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^)
#		($?)]) $(OLD SHELL)
