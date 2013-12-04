==============================
Installing the Schoolserver Community Edition 
==============================

Supported autodetected network configurations for XO 1.5, 1.75 and 4 targets:

| **One Dongle**
|    eth0 - internal wifi for gateway
|    eth1 - usb ethernet for schoolserver LAN connected to an access point

| **Two Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet for gateway
|    eth2 - usb ethernet for schoolserver LAN connected to an access point

**NOTE:** Appliance installs integrate into existing networking infrastructure and do not include dhcpd, squid, dansguardian, or wondershaper.

| **XSCE Appliance - no additional interfaces**
|    eth0 - internal wifi connected to an existing LAN

| **XSCE Appliance One Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet connected to an existing LAN 


On the XO-1.75 or XO-4 laptop
=============================

* Flash the laptop with a stable `13.2.0 image`_

* In ``My Settings->Power`` turn off Automatic Power Management

* Install git and ansible (for dependencies)::

    su -
    yum install -y git ansible
    
  **Note**: ansible version 1.4.1 or higher is required. If your installed
  version is previous you can install it from sources using::

    cd ~/
    git clone https://github.com/ansible/ansible.git
    cd ansible
    git checkout release1.4.1
    python setup.py install

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

* To avoid replaying all the playbooks, you can use tags to restrict which tasks are run: 
::

  ansible-playbook -i ansible_hosts xsce.yml --tags="facts,squid" --connection=local
* Avaliable tags are:``activity-server, ajenti, avahi, common, core, dhcpd, download, ejabberd, facts, gateway, httpd, idmgr, iiab, monit, moodle, munin, named, network, olpc, pathagar, portal, postgresql, services, squid, sugar-stats, wondershaper, xo``


Building the rpm
================

An rpm can be built by using the command::

    rpmbuild -bb dxs.spec

