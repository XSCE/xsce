==============================
Installing the Schoolserver Community Edition 
==============================

Both single and two dongle installs are supported. 


On the XO-1.75 or XO-4 laptop
=============================

* Flash the laptop with a stable `13.2.0 image`_

* In ``My Settings->Power`` turn off Automatic Power Management

* Install ansible and git::

    su -
    yum install -y git ansible

* Clone the XSCE git repo and run initial setup::

    cd ~/
    git clone https://github.com/XSCE/xsce
    cd xsce/
    ./runansible

.. Warning::
   Depending on the type of setup (one or two dongle), you'll need to
   check and edit the contents of
   ``<xsce_root_directory>/vars/default_vars.yml``. For a one dongle
   setup the interfaces are eth0 and eth1 for WAN and LAN respectively.
   For a two dongle setup, the interfaces become eth1 and eth2. Since
   XSCE won't automatically find out which eth is LAN or WAN, a good
   practice would be to first insert the WAN dongle, so it gets its IP
   address, and then insert the LAN dongle.

* After rebooting (insert the ethernet dongles at this point)::

    cd xsce/
    ./runansible # This will take a lot of time as it installs packages
    reboot

* XSCE should be up and functional

.. _13.2.0 image: http://wiki.laptop.org/go/Release_notes/13.2.0#Installation

.. _XSCE: http://schoolserver.org/


Using tags
==========

* To avoid replaying all the playbooks, you can use tags to restrict what task are used: 
::

  ansible-playbook -i ansible_hosts xsce.yml --tags="facts,squid" 
* Avaliable tags are: ``common, network, gateway, core, activity-server, ajenti, dhcpd, ejabberd, facts, gateway, httpd, idmgr, iiab, monit, moodle, munin, named, network, olpc, portal, postgresql, services, squid, sugar-stats, wondershaper``


Building the rpm
================

An rpm can be built by using the command::

    rpmbuild -bb dxs.spec

