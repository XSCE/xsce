# install root
%define DESTDIR  /


BuildArch: noarch

#  Requires a few tools and
#  a list of packages modified by xs-config
Requires: python
Requires: authconfig
Requires: initscripts
Requires: iptables
Requires: net-tools
Requires: module-init-tools
Requires: nscd
Requires: nss
Requires: ntp
Requires: openssh-server
Requires: radvd
Requires: rpm
Requires: selinux-policy
Requires: setup
Requires: smartmontools
Requires: sudo
Requires: syslog
Requires: logrotate
Requires: xml-common
Requires: etckeeper
Requires: make
Requires: createrepo
Requires: usbmount
Requires: avahi
Requires: nss-mdns
Requires: avahi-tools
Requires: avahi-ui
Requires: hostname
Requires: yum-utils
Requires: NetworkManager
Requires: Ansible

Requires(post): coreutils

Summary: Install Ansible Playbooks which in turn make a school server
Name: XSCE
Version: @VERSION@
Release: 1
BuildRoot: %{_builddir}/%{name}-root
Distribution: OLPC XS/XSX School Server
Group: Base System/Administration Tools
License: GPLv2
Packager: Jerry Vonau <jerry@laptop.org.au>
Source: %{name}-%{version}.tar.gz
URL: http://sugardextrose.org/projects/xs-config/repository/show?rev=ghunt
Vendor: OLPC
%description
The default configuration of an OLPC XS School server.

%package xo
Summary: Bootstraper for running OLPC XS School server on an XO.

%description xo
Bootstraper for running OLPC XS School server on an XO.

%package ts
Summary: Bootstraper for running OLPC XS School server on an trimslice.

%description ts
Bootstraper for running OLPC XS School server on an trimslice.

%package x86_64
Summary: Config file for running OLPC XS School server on x86_64.

%description x86_64
Config file for running OLPC XS School server on X86_64.

%prep
%setup
%install
echo $PWD
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT%{DESTDIR} install
%clean
rm -rf $RPM_BUILD_ROOT

%post

## fix logrotate
if [ -e /etc/logrotate.d/"*" ]; then
    rm /etc/logrotate.d/"*"
fi

## Rename old conffiles
if [ -e /etc/sysconfig/olpc-scripts/domain_config.d/dhclient ]; then
    rm /etc/sysconfig/olpc-scripts/domain_config.d/dhclient
fi

if [ -e /etc/sysconfig/olpc-scripts/xs-domain-name ]; then
   mv /etc/sysconfig/olpc-scripts/xs-domain-name /etc/sysconfig/xs_domain_name
fi

# Regenerate files, some templates could have changed in this update
xs-setup --upgrade-only
xs-setup-network --upgrade-only

%pre

##
## clear the way for a better pkg
##
## remove olpcsave links and olpcnew symlinks in /etc
find /etc -type l -name '*.olpcnew'  -lname '*fsroot*' -print0 | xargs -0 --no-run-if-empty rm
find /etc -type l -name '*.olpcsave' -lname '*fsroot*' -print0 | xargs -0 --no-run-if-empty rm

# remove old stale init scripts
if chkconfig --level 3 olpc-mesh-config ; then
      chkconfig --del olpc-mesh-config
fi
if chkconfig --level 3 olpc-network-config ; then
      chkconfig --del olpc-network-config
fi

%preun
#if [ $1 = 0 ]; then
#   /sbin/service pgsql-xs stop  > /dev/null 2>&1
#   chkconfig --del pgsql-xs
#fi

%files
%{_datadir}/%{name}
%config(noreplace) %{_sysconfdir}/*.in
%config(noreplace) %{_sysconfdir}/squid/squid-xs.conf.in
%config(noreplace) %{_sysconfdir}/squid/squid-xs-dg.conf.in
%config(noreplace) %{_sysconfdir}/ejabberd/ejabberd-xs.cfg.in
%config(noreplace) %{_sysconfdir}/ejabberd/ejabberdctl.cfg.in
%config(noreplace) %{_sysconfdir}/httpd/conf.d/*.conf.in
%config(noreplace) %{_sysconfdir}/pathagar/settings.py.in
%config(noreplace) %{_sysconfdir}/pathagar/pathagar.conf.in
%config(noreplace) %{_sysconfdir}/pathagar/pathagar.wsgi
%config(noreplace) %{_sysconfdir}/openvpn/road*
%config(noreplace) %{_sysconfdir}/openvpn/keys/client*
%config(noreplace) %{_sysconfdir}/openvpn/keys/ca.crt

%config(noreplace) %{_sysconfdir}/sysconfig/olpc-scripts/
%config(noreplace) %{_sysconfdir}/sysconfig/modules/*.modules
%config(noreplace) /var/named-xs

#%config(noreplace) %{_sysconfdir}/motd.in
#%config(noreplace) %{_sysconfdir}/hosts.in
#%config(noreplace) %{_sysconfdir}/sysctl.conf.in
#%config(noreplace) %{_sysconfdir}/rsyslog.conf.in
#%config(noreplace) %{_sysconfdir}/rssh.conf.in
%config(noreplace) %{_sysconfdir}/rc.d/rc.local
%config(noreplace) %{_sysconfdir}/ssh/sshd_config.in
%config(noreplace) %{_sysconfdir}/sysconfig/*.in
%config(noreplace) %{_sysconfdir}/sysconfig/ejabberd-xs
#%config %{_sysconfdir}/sysconfig/olpc-scripts/iptables-xs.in
#%config %{_sysconfdir}/sysconfig/olpc-scripts/ip6tables-xs.in

%attr(750, root , named)   %dir /var/named-xs
%attr(770, named , named)  %dir /var/named-xs/data

#%config(noreplace) %{_sysconfdir}/init.d/no-fsck-questions
%config(noreplace) %{_sysconfdir}/init.d/ejabberd-xs
#systemd replacements
%config(noreplace) %{_sysconfdir}/systemd/system/dhcpd.service
%config(noreplace) %{_sysconfdir}/systemd/system/*.in

#Pg
%config(noreplace) %{_sysconfdir}/pgsql-xs/p*.conf
%config(noreplace) %{_sysconfdir}/sysconfig/pgsql/pgsql-xs
#%{_sysconfdir}/init.d/pgsql-xs
#%attr(700, postgres, postgres)   %dir /library/pgsql-xs

#dansguardian
%config(noreplace) %{_sysconfdir}/dansguardian/dansguardian.conf.in

#monit
%config(noreplace) %{_prefix}/share/xs-config/cfg/etc/monit.d/*
%config(noreplace) %{_sysconfdir}/monitrc.in

%config %{_prefix}/share/xs-config/cfg/etc/xs-setup.conf

%{_bindir}/cat-parts
%{_bindir}/xs-*
%{_libexecdir}/moodle-xs-init
%doc README README.networking
%doc README.no-fsck-questions
%doc COPYING
#%{_sysconfdir}/sysconfig/vnc/self.pem
#%{_sysconfdir}/sysconfig/vnc/xstartup

%files xo
%{_bindir}/bootstrap-xo
%{_bindir}/prep-storage.sh
%{_bindir}/prep-storage-xo1.sh
%{_libdir}/udev/rules.d/10-olpc-net.rules

%files ts
%{_bindir}/bootstrap-ts
%{_sysconfdir}/dhcp/dhcpd-ts.conf.in
%{_sysconfdir}/hostapd/hostapd.conf.in
%{_sysconfdir}/avahi/avahi-daemon.conf.in

%files x86_64
%config(noreplace) /etc/xs-setup.conf
