# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

OLPCROOT = fsroot.olpc

install: $(OLPCROOT) $(DESTDIR)
	rsync -ar $(OLPCROOT) $(DESTDIR)

$(DESTDIR):
	mkdir -p $(DESTDIR)

