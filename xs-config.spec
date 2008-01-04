# install root
%define DESTDIR  /

%define OLPCROOT %{DESTDIR}/fsroot.olpc

%define LINK	 %{OLPCROOT}/symlink-tree.py
%define UNLINK   %{OLPCROOT}/unlink-tree.py

Requires: python

#  This really should just require xs-pkgs, right ?
#  or nothing at all...
#  Now a list of packages modified by xs-config
Requires: authconfig  
Requires: bind  
Requires: glibc  
Requires: glibc-common  
Requires: httpd  
Requires: info  
Requires: initscripts  
Requires: iptables  
Requires: lighttpd  
Requires: module-init-tools  
Requires: nscd  
Requires: nss  
Requires: openssh-server  
Requires: radvd  
Requires: rpm  
Requires: selinux-policy  
Requires: setup  
Requires: smartmontools  
Requires: sudo  
Requires: sysklogd  
Requires: xml-common  
Requires: xs-pkgs
Requires: kernel

Summary: XS/XSX default configuration
Name: xs-config
Version: 0.2.3
Release: 1
BuildRoot: %{_builddir}/%{name}-root
Distribution: OLPC XS/XSX School Server
Group: Base System/Administration Tools
License: GPL
Packager: John Watlington <wad@laptop.org>
Source: %{name}-%{version}.tar.gz
URL: http://dev.laptop.org/git.do?p=projects/xs-config;a=summary
Vendor: OLPC
%description
The default configuration of an OLPC XS School server. Don't install this if you don't understand what it is!

%prep
%setup
%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT/%{DESTDIR} install
%clean
rm -rf $RPM_BUILD_ROOT

%post
%{LINK} %{OLPCROOT} %{DESTDIR}
#
#  If any kernel modules are being installed using this mechanism, you
#  need to depmod them in...
depmod -b %{DESTDIR} -C %{DESTDIR}/etc/depmod.d
#
#  There are some files which must be copied, not symlinked
#  syslog.conf, sysctl.conf, and sudoers are examples.
rm %{DESTDIR}/etc/sudoers
cp -fp %{OLPCROOT}/etc/sudoers %{DESTDIR}/etc/
chmod 0440 %{DESTDIR}/etc/sudoers
rm %{DESTDIR}/etc/syslog.conf
cp -fp %{OLPCROOT}/etc/syslog.conf %{DESTDIR}/etc/
rm %{DESTDIR}/etc/sysctl.conf
cp -fp %{OLPCROOT}/etc/sysctl.conf %{DESTDIR}/etc/
rm %{DESTDIR}/etc/httpd/conf/httpd.conf
cp -fp %{OLPCROOT}/etc/httpd/conf/httpd.conf %{DESTDIR}/etc/httpd/conf/
#
#  Massive hack, done instead of fixing symlink-tree at this time!
ln -s %{OLPCROOT}/etc/named.conf %{DESTDIR}/etc/named.conf
#
#
#  Delete link script ?
rm %{LINK}*
#  Temporary fix to remove script symlinks
rm %{DESTDIR}/symlink-tree.py*
rm %{DESTDIR}/unlink-tree.py*

%preun
#  If this is an uninstall...
if [ $1 -eq 0 ]
then
   %{UNLINK} %{OLPCROOT} %{DESTDIR}
   rm %{UNLINK}*
fi

%files
%config(noreplace) %{OLPCROOT}
