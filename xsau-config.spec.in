# install root
%define DESTDIR  /

Requires(post): coreutils

Summary: XS default service configuration
Name: xsau-config
Version: 0.7.0.4
Release: 1XSAU
BuildRoot: %{_builddir}/%{name}-root
Distribution: OLPC XS/XSX School Server
Group: Base System/Administration Tools
License: GPLv2
Packager: Jerry Vonau <jvonau@shaw.ca>
Source: %{name}-%{version}.tar.gz
URL: http://download.laptop.org.au/XS/F11/XS-AU/bleeding/SOURCES/
#URL: http://dev.laptop.org/git.do?p=projects/xs-config;a=summary
Vendor: OLPC

#  Requires a few tools 
Provides: xs-config

Requires: git
Requires: make
Requires: python
Requires: authconfig  
Requires: initscripts  
Requires: nscd  
Requires: nss  
Requires: radvd  
Requires: rpm  
Requires: selinux-policy
Requires: setup  
Requires: smartmontools  
Requires: sudo  
Requires: syslog 
Requires: usbmount

#a list of packages modified by xs-config
Requires: openssh-server  
Requires: httpd
Requires: moodle-xs
Requires: postgresql-server
Requires: xml-common  
Requires: php-common
Requires: bind
Requires: xs-rsync
Requires: xs-activation

%prep
%setup
%install
echo $PWD
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT/%{DESTDIR} install
%clean
rm -rf $RPM_BUILD_ROOT

%post
## Prepare config files
# fix xinetd.d services
# xs-rsyncd xsactivation 
sed -i -e "s/172.18.0.1/0.0.0.0/" /etc/xinetd.d/xs-rsyncd 
sed -i -e "s/172.18.0.1/0.0.0.0/" /etc/xinetd.d/xsactivation  

pushd /etc
# these don't need network settings
make -B -f xs-config.make earlyset
# seed low-level network and domain
/etc/sysconfig/olpc-scripts/domain_config
popd 

# Pg - prime the DB if needed.
if [ ! -e /library/pgsql-xs/data-8.3/PG_VERSION ];then
   /etc/init.d/pgsql-xs initdb
fi

# and set it to autostart
chkconfig --add pgsql-xs
chkconfig --levels 2345 pgsql-xs on
chkconfig --levels 2345 postgresql off

# enable no-fsck-questions 
chkconfig --add no-fsck-questions

%pre

## Prepare a .git directory so xs-commitchanged
## can store its database...
if [ ! -d /etc/.git ];then
   pushd /etc
   git init
   chmod 700 .git
   popd
fi


%preun
if [ $1 = 0 ]; then
   /sbin/service pgsql-xs stop  > /dev/null 2>&1
   chkconfig --del pgsql-xs
fi

%files
%{_sysconfdir}/xs-config.make
%{_sysconfdir}/dhclient-exit-hooks
%{_sysconfdir}/usbmount/mount.d/01_beep_on_mount
%{_sysconfdir}/usbmount/mount.d/99_beep_when_done
%config(noreplace) /fsckoptions
%config(noreplace) %{_sysconfdir}/*.in
%config(noreplace) %{_sysconfdir}/ejabberd/ejabberd-xs.cfg.in
%config(noreplace) %{_sysconfdir}/ejabberd/ejabberd.pem
%config(noreplace) %{_sysconfdir}/httpd/conf/httpd-xs.conf
%config(noreplace) %{_sysconfdir}/httpd/conf.d/*.conf.in
%config(noreplace) %{_sysconfdir}/httpd/conf.d/*.conf
%config(noreplace) %{_sysconfdir}/logrotate.d/syslog-xslogs
%config(noreplace) %{_sysconfdir}/ssh/sshd_config.in
%config(noreplace) %{_sysconfdir}/sysconfig/*.in
%config(noreplace) %{_sysconfdir}/init.d/no-fsck-questions
%config(noreplace) %{_sysconfdir}/sysconfig/olpc-scripts/
%config(noreplace) /var/named-xs
%attr(750, root , named)   %dir /var/named-xs
%attr(770, named , named)  %dir /var/named-xs/data

#Pg
%config(noreplace) %{_sysconfdir}/pgsql-xs/p*.conf
%config(noreplace) %{_sysconfdir}/sysconfig/pgsql/pgsql-xs
%{_sysconfdir}/init.d/pgsql-xs
%attr(700, postgres, postgres)   %dir /library/pgsql-xs
%attr(700, postgres, postgres)   %dir /library/pgsql-xs/data-8.3

%attr(750, root , root)   %dir %{_sysconfdir}/sudoers.d
%attr(440, root , root) %config(noreplace) %{_sysconfdir}/sudoers.d/*

%{_bindir}/xs-commitchanged
%{_bindir}/cat-parts
%{_bindir}/xs-swapnics
/sbin/ifup-local

%doc README.no-fsck-questions README 

%description
The default service configuration of an OLPC XS School server.


