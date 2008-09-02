##
## XS config make file
##
## See /usr/share/doc/xs-config-<version>/README for
## how this works...
##
earlyset: syslog.conf motd yum.conf sysctl.conf ssh/sshd_config \
     sysconfig/dhcpd sysconfig/named sysconfig/init \
     sysconfig/iptables-config sysconfig/squid \
     sudoers rssh.conf

networkset: sysconfig/network hosts

# Any file that has a ".in"
# 'template' can be made with this catch-all
# that is just a straight cp -p right now.
##
##  - Do not use with resolv.conf, idmgr.conf.in
##       or named-xs.conf.in
##  - If you add a more specific rule it will
##    override this rule for your target.
% :: %.in
	# It may be dirty
	xs-commitchanged -m 'Dirty state' $@
	# Overwrite
	cp -p $@.in $@
	xs-commitchanged -m "Made from $@.in" $@

sudoers: sudoers.d/*
	touch sudoers.tmp
	chmod 640 sudoers.tmp
	cat-parts sudoers.d > sudoers.tmp
	chmod 440 sudoers.tmp
	xs-commitchanged -m 'Dirty state' $@
	mv -f sudoers.tmp sudoers
	xs-commitchanged -m "Made from sudoers.d" $@

sysconfig/network:  sysconfig/network.in sysconfig/xs_server_number
	xs-commitchanged -m 'Dirty state' $@
	sed -e "s/@@SERVERNUM@@/$$(cat /etc/sysconfig/xs_server_number)/" < $@.in > $@
	xs-commitchanged -m "Made from $@.in" $@

hosts:  hosts.in sysconfig/xs_server_number
	xs-commitchanged -m 'Dirty state' $@
	sed -e "s/@@SERVERNUM@@/$$(cat /etc/sysconfig/xs_server_number)/" < $@.in > $@
	xs-commitchanged -m "Made from $@.in" $@

dhcpd-xs.conf:  sysconfig/xs_server_number sysconfig/xs_domain_name
	xs-commitchanged -m 'Dirty state' $@
	#	SERVERNUM := $(shell cat sysconfig/xs_server_number)
	#BASEDNSNAME := $(shell cat sysconfig/xs_domain_name)
	cp /etc/sysconfig/olpc-scripts/dhcpd.conf.$(shell cat sysconfig/xs_server_number) $@.tmp
	sed -i -e "s/@@BASEDNSNAME@@/$(shell cat sysconfig/xs_domain_name)/" $@.tmp
	mv $@.tmp $@
	xs-commitchanged -m "Made from /etc/sysconfig/olpc-scripts/dhcpd.conf.${SERVERNUM}" $@

