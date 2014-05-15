=============================================
Installing the Schoolserver Community Edition 
=============================================

The XSCE installation attempts to determine the network topology based on the number and types of connections it discovers. In general, it looks to see if there is a connection to a gateway and whether other wireless or wired connections are present. It then uses the following logic to configure networking.

Supported autodetected network configurations for XO 1.5, 1.75 and 4 targets:
=============================================================================

Gateway Installation Network Configurations
-------------------------------------------

| **One Dongle**
|    eth0 - internal wifi for gateway
|    eth1 - usb ethernet for schoolserver LAN connected to an access point

| **Two Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet for gateway
|    eth2 - usb ethernet for schoolserver LAN connected to an access point

Non-Gateway (aka "Appliance") Installation Network Configurations
-----------------------------------------------------------------

**NOTE:** Appliance installs integrate into existing networking infrastructure and do not include dhcpd, squid, dansguardian, or wondershaper.  This installation does not behave as an internet gateway.

| **XSCE Appliance - no additional interfaces**
|    eth0 - internal wifi connected to an existing LAN

| **XSCE Appliance One Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet connected to an existing LAN 


On the XO 1.5, XO-1.75, or XO-4 laptop
======================================

* Flash the laptop with a stable `13.2.0 image`_

* In ``My Settings->Power`` turn off Automatic Power Management

* Connect all the network interfaces and reboot

* Install git and ansible (for dependencies)::

    su -
    yum install -y git ansible
    
  **Note**: ansible version 1.4.1 or higher is required. Verify the version number with::
  
    ansible --version
  
  If the ansible version installed via yum is older than 1.4.1, install 1.4.1 from source::

    cd ~/
    git clone https://github.com/ansible/ansible.git
    cd ansible
    git checkout release1.4.1
    python setup.py install

* Clone the XSCE git repo and cd into it::

    cd ~/
    git clone --branch release-5.0 --depth 1 https://github.com/XSCE/xsce
    cd xsce

* Verify all the network interfaces are visible and have the correct interface label::

    ifconfig

* Optionally, verify that all network interfaces are properly autodetected::

    sh roles/common/library/xsce_facts

* From the xsce directory, run initial setup.  The XO will automatically reboot upon completion::

    ./runansible

* After rebooting::

    cd xsce/
    ./runansible # This will take a lot of time as it installs packages
    reboot

* The XSCE should be up and functional

.. _13.2.0 image: http://wiki.laptop.org/go/Release_notes/13.2.0#Installation

.. _XSCE: http://schoolserver.org/


Using tags
==========

* To avoid replaying all the playbooks, you can use tags to restrict which tasks are run: 
::

  ansible-playbook -i ansible_hosts xsce.yml --tags="facts,squid"
* Avaliable tags are:``activity-server, addons, ajenti, avahi, common, core, dhcpd, download, ejabberd, facts, gateway, httpd, idmgr, iiab, monit, moodle, munin, named, network, olpc, pathagar, portal, postgresql, services, squid, sugar-stats, wondershaper, xo``


Building the rpm
================

An rpm can be built by using the command::

    rpmbuild -bb xsce-server.spec

