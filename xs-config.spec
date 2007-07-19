# install root
%define DESTDIR  /

%define OLPCROOT %{DESTDIR}/fsroot.olpc

%define LINK	 %{OLPCROOT}/symlink_tree.py
%define UNLINK   %{OLPCROOT}/unlink_tree.py

Requires: python, aiccu, at, audit-libs, authconfig, autofs, bind, fontconfig, glibc, glibc-common, httpd, info, initscripts, ipsec-tools, iptables, iptables-ipv6, isdn4k-utils, lighttpd, logrotate, mgetty, module-init-tools, nfs-utils, nscd, nss, ntp, openssh, openssh-server, pam, policycoreutils, ppp, prelink, radvd, rootfiles, rpm, selinux-policy, setup, shadow-utils, smartmontools, spamassassin, squid, sudo, sysklogd, wpa_supplicant, wvdial, xml-common, xorg-x11-xfs

Summary: XS/XSX default configuration
Name: xs-config
Version: 0.1.1
Release: 1
BuildRoot: %{_builddir}/%{name}-root
Group: Base System/Administration Tools
License: GPL
Source: %{name}-%{version}.tar.gz
%description
The default configuration of an OLPC XS/XSX school server. Don't install this if you don't understand what it is! (Look at the project's README).

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
rm %{DESTDIR}/symlink_tree.py*
rm %{DESTDIR}/unlink_tree.py*

%preun
# if this is an uninstall...
if [ $1 -eq 0 ]
then
   %{UNLINK} %{OLPCROOT} %{DESTDIR}
   rm %{UNLINK}*
fi

%files
%config(noreplace) %{OLPCROOT}

