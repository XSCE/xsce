Networking
==========


The schoolserver community edition has two modes of operation:

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

Selecting devices to be part of the install or changing later after being set:
------------------------------------------------------------------------------

This behavior is dependent on the setting of these four options in 
vars/local_vars.yml which you need to add:

xsce_lan_enabled: True
xsce_wan_enabled: True
user_wan_iface: auto 
user_lan_iface: auto

This gains control over the actions be able to override the stock behavour.
If you choose to do this you also have to change from the default setting 
of "auto" and "True" as outlined below: 

* If you want to force "Appliance" mode, you set xsce_lan_enabled as follows:
```
xsce_lan_enabled: False
```
The WAN adapter will be reconfigured, with any other adapters left unconfigured.

* If you want to force "LanController" mode, you set xsce_wan_enabled as follows:
```
xsce_wan_enabled: False
```
Will deactivate any WAN present, adding that device to the LAN.

* If you want to set the LAN device, to override the auto-detection edit 
vars/local_vars.yml with:
```
user_lan_iface: "<iface>"
```
Now only this device will become the LAN.

The selected setting can be verified before install, by running the following 
command:

```
./runtags network-discover
```
You will be presented with a brief summary of the proposed action that would 
be preformed by "./runtags network"


List of open ports / services
-----------------------------



+----------+---------------------------+----------------------+
|Protocol  | Port                      |Service               |            
+----------+---------------------------+----------------------+
| TCP      | 22                        |    sshd              |
+----------+---------------------------+----------------------+
| TCP      | 80                        | httpd-xs             |
+----------+---------------------------+----------------------+
| TCP      | 873                       | xs-rsync (xinetd)    |
+----------+---------------------------+----------------------+
| TCP      | 3128                      | squid / dansguardian |
+----------+---------------------------+----------------------+
| TCP      | 3130                      |       squid          |
+----------+---------------------------+----------------------+
| TCP      | 5000                      |     xs-authserver    |
+----------+---------------------------+----------------------+
| TCP      | 4369,47893,5280,5222,5223 |    ejabberd-xs       |
+----------+---------------------------+----------------------+
| TCP      | 8080                      |        idmgr         |
+----------+---------------------------+----------------------+
| TCP      | 8000                      | sugar-stats-server   |
+----------+---------------------------+----------------------+
| TCP      | 9990                      |       ajenti         |
+----------+---------------------------+----------------------+




