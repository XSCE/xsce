# XSCE Networking Overview

The schoolserver community edition has three modes of operation:

* Appliance
* Gateway
* LanController

First one allows an schoolserver to behave like any other computer in the
network, exposing the configured services. Can have a single network interface.

Gateway mode allows for creating a local area network, including dhcpd, content
filtering using squid and dansguardian and traffic shaping. Requires two or more
network interface.

LanController mode allows for creating a local area network, excluding dhcpd,
content filtering using squid and dansguardian and traffic shaping.
Can have a single network interface.

The install by default finds the WAN device, defaulting to the "Appliance" mode.
The install will try to find other devices for use with the LAN and if found
defaults to "Gateway" mode. You need to make some adjustments to be able to use
LanController as it will use all available network interfaces.

### List of open ports / services

|Protocol  | Port                      |Service               |
|:--------:|:-------------------------:|----------------------|
| TCP      | 22                        |    sshd              |
| TCP      | 80                        | httpd-xs             |
| TCP      | 631                       | cups                 |
| TCP      | 873                       | xs-rsync (xinetd)    |
| TCP      | 3000                      |     kiwix-serve      |
| TCP      | 3128                      | squid / dansguardian |
| TCP      | 3130                      |       squid          |
| TCP      | 5000                      |     xs-authserver    |
| TCP      | 4369,47893,5280,5222,5223 |    ejabberd-xs       |
| TCP      | 8000                      | sugar-stats-server   |
| TCP      | 8008                      |  kalite-serve        |
| TCP      | 8080                      |        idmgr         |
| TCP      | 8089                      |    sugarizer         |
| TCP      | 27018                     |    mongodb           |
