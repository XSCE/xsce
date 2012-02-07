##
## XS config make file
##
## See /usr/share/doc/xs-config-<version>/README for
## how this works...
##
earlyset: rsyslog.conf motd sysctl.conf ssh/sshd_config \
     sysconfig/named sysconfig/init \
     sysconfig/iptables-config sysconfig/squid \
     rssh.conf php.ini sysconfig/httpd \
     httpd/conf.d/proxy_ajp.conf httpd/conf.d/ssl.conf

networkset: sysconfig/dhcpd

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
	etckeeper commit -m 'Dirty state'
	# Overwrite
	cp -p $@.in $@
	etckeeper commit -m "Made from $@.in"

sysctl.conf:
	etckeeper commit -m 'Dirty state'
	cp -p $@.in $@
	etckeeper commit -m "Made from $@.in"
	sysctl -p $@
