Networking
==========

THIS DOCUMENT AND THE NETWORKING SECTION OF INSTALL AND OTHER DOCS NEEDS REVISING.
==================================================================================

The schoolserver community edition has two modes of operation:

* Appliance
* Gateway

First one allows an schoolserver to behave like any other computer in the network,
exposing the configured services. 

Gateway mode allows for creating a local area network, including dhcpd, content filtering using squid and dansguardian and traffic shaping.



Selecting LAN device
--------------------

The install will try to find the LAN device himself, and if none is found, it will
default to the "appliance" mode install.

* If you want to set the LAN device, edit vars/default_vars.yml and add:

```
xsce_lan_iface: "<iface>"
```

* If you want to force "appliance" mode, you can set xsce_lan_iface as follows:

```
xsce_lan_iface: ""
```

The selected devices can be verified before install, by running the following command:

```
ansible-playbook -i ansible_hosts --connection=local xsce.yml --tags=network-discover
```

And checking then the contents of /etc/sysconfig/xs_lan_device and /etc/sysconfig/xs_wan_device

Keep in mind that, when running in appliance mode, those files will have the same content (wan = lan)


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




