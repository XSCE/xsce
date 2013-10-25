=====================
DXS Testing Checklist
=====================

dhcpd
=====
- Client: gets an IP address in the 172.18.x.x range
- Server: check /var/lib/dhcpd/dhcpd.leases for client leases

idmgr
=====
- Client: successfully register a Sugar client
- Server: check /library/users for a directory corresponding with the client's serial number

ejabberd
========
- Client: 2 registered clients can see each other in the "Network Neighborhood" view
- Clients: 2 registered clients can collaborate via an Activity (Chat, for example)
- Server: `ejabberdctl connected_users` reports the registered and connected clients

httpd
=====
- Client: http://schoolserver and http://schoolserver.local resolves in any browser

Moodle
======
- Client: http://schoolserver.local autologs in a registered client via the Sugar Browse Activity

Authserver
==========
- Client: Opening http://schoolserver.local:5000 in the Sugar Browse Activity will greet with the registered client's buddy name

Squid
=====
- Server: Check /library/cache size, load webpage on client, verify size of /library/cache has increased

Dansguardian
============
- Client: Try to look at porn?  No way!

IIAB (Internet in a box)
========================
- Client: http://schoolserver/iiab resolves in any browser

OLPC Backup
===========
- Server: du -sk /library/users/* indicates backups

Stats
=====
- Server: a client's rrds are in /library/sugar-stats/rrd/

Monit
=====
- Server: halt services and see if they restart

Munin
=====
- Client: access http://schoolserver/munin user=admin password=munindxs

Ajenti
======
- Client: access http://schoolserver:9990 user=root password=admin

Ajenti Wondershaper
===================
- Client: verify bandwidth edits via online speedtest or speedtest-cli

Upload Activity
===============
- N/A: /var/www/html/upload_activity.php is currently not present - WIP
