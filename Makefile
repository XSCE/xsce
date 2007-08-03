# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

SCRIPTS = symlink-tree.py unlink-tree.py
OLPCROOT = fsroot.olpc

install: $(OLPCROOT) $(DESTDIR)
	rsync -ar $(OLPCROOT) $(DESTDIR)

$(DESTDIR):
	mkdir -p $(DESTDIR)


# For developers:

# rpm target directory
RPMDIR = /usr/src/redhat

# olpc configuration tree
OLPCIMG = fsroot.olpc.img

# symbols
NAME = xs-config
VERSION = 0.1.6
RELEASE = 2
ARCH = noarch

NV = $(NAME)-$(VERSION)

SOURCES: Makefile $(SCRIPTS)
	mkdir -p $(NV)
	cp -p Makefile $(NV)
	rsync -ar $(OLPCIMG)/ $(NV)/$(OLPCROOT)
	cp -p $(SCRIPTS) $(NV)/$(OLPCROOT)
	tar czf $(RPMDIR)/SOURCES/$(NV).tar.gz $(NV)
	rm -rf $(NV)

rpm: SOURCES
	rpmbuild -ba --target $(ARCH) $(NAME).spec
	rm -f $(NV)-*.$(ARCH).rpm
	cp -p $(RPMDIR)/RPMS/$(ARCH)/$(NV)-$(RELEASE).$(ARCH).rpm .

