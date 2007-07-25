# install root
%define DESTDIR  /

%define OLPCROOT %{DESTDIR}/fsroot.olpc

%define LINK	 %{OLPCROOT}/symlink-tree.py
%define UNLINK   %{OLPCROOT}/unlink-tree.py

Requires: python

# modified pkgs on schoolserver
Requires: authconfig  
Requires: bind  
Requires: fontconfig  
Requires: glibc  
Requires: glibc-common  
Requires: httpd  
Requires: info  
Requires: initscripts  
Requires: iptables  
Requires: lighttpd  
Requires: logrotate  
Requires: module-init-tools  
Requires: nscd  
Requires: nss  
Requires: openssh-server  
Requires: pam  
Requires: prelink  
Requires: radvd  
Requires: rpm  
Requires: selinux-policy  
Requires: setup  
Requires: smartmontools  
Requires: squid  
Requires: sudo  
Requires: sysklogd  
Requires: xml-common  
Requires: xorg-x11-xfs  

Summary: XS/XSX default configuration
Name: xs-config
Version: 0.1.3
Release: 2
BuildRoot: %{_builddir}/%{name}-root
Distribution: OLPC XS/XSX School Server
Group: Base System/Administration Tools
License: GPL
Packager: Daniel Margo <dwm34@cornell.edu>
Source: %{name}-%{version}.tar.gz
URL: http://dev.laptop.org/git.do?p=projects/xs-config;a=summary
Vendor: OLPC
%description
The default configuration of an OLPC XS/XSX school server. Don't install this if you don't understand what it is!

%prep
%setup
%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT/%{DESTDIR} install
%clean
rm -rf $RPM_BUILD_ROOT

%post
%{LINK} %{OLPCROOT} %{DESTDIR}
rm %{LINK}*
# temporary fix to remove script symlinks
rm %{DESTDIR}/symlink-tree.py*
rm %{DESTDIR}/unlink-tree.py*

%preun
# if this is an uninstall...
if [ $1 -eq 0 ]
then
   %{UNLINK} %{OLPCROOT} %{DESTDIR}
   rm %{UNLINK}*
fi

%files
%config(noreplace) %{OLPCROOT}

