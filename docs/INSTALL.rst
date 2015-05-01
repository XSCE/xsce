=============================================
Installing the Schoolserver Community Edition 
=============================================
Overview
--------

The XSCE team is exploring two basic ways of installing an OS:

   1. Use a native bootloader on the hardware platform to load an memory-resident OS, which in turn partitions, formats, and weaves indiviaual packages into the fabric that becomes the on-disk OS.
   2. Use a separate computer to download and copy a completely configured disk image to a disk, which is then placed in the target machine.

Installation of XSCE uses both approaches. The LiveCD is basically #1. The TinyCore Linux is a hybrid of #1 and #2. And the install of XSCE on a Raspberry Pi is just #2.

The #1 approach is to include in the downloaded image, a very small interactive program, which lets the end user select language, keyboard, disk target, root password, etc. Included with that small program is a large number of packages that need to be woven together into a final disk image. This process can take 5-60 minutes or more, depending on the speed of the processor.

The hybrid approach is to do all of the selecting, partitioning , password selection, ahead of time, and just copy the end result to the final hard disk. The second method is completed in a few minutes (we call it the TinyCore loader).

The installation does not need to be done is a single process. There is a new XSCE Administrative Console, which can be accessed by a browser on another client machine. This permits selection of options, services, languages, etc to permit additional services, and educational resources to be enabled and selected for download.

Supported Network Modes 
=======================

At the administrative console at http://schoolserver/admin (username:xsce-admin password:g0adm1n -- note the numbers 0,1) a user can select one of three server roles:

   * Lan-Conatoller (Local Area Network) - In this mode, the server configures clients with ip addresses (dhcpd - dynamic host configuration protocol), name resolution (defines schoolserver for all clients)
   * Gateway -- does dhcpd (ip addresses),name lookup (dns), firewall, local web page cache for faster retrieval the second time, content filtering to block porn(dansguardian), site "whitelists" if wanted
   * Appliance -- no firewall, no dhpcd, no dns, just a contrubutor to an already existing network
   
Based upon selection of the above mode at the Administrative Console, XSCE software will attempt to set up network connections. If appliance mode is wanted, the network adapter will be set up. If Gateway is selected, and one of the adapters discovers that it is connected to a source of ip addresses, that adapter will be the internet, and the other the wifi connector. If LanController is selected, any adapter found will be act as server to any clients that might ask to connect.

The XSCE installation attempts to determine the network topology based on the number and types of connections it discovers. In general, it looks to see if there is a connection to a gateway and whether other wireless or wired connections are present. 

A Note on Server Security
+++++++++++++++++++++++++
The first time you sign into the console would be the best time to change the password, and before then next release, there will be a GUI option which makes this easy. But at this point in time, the server's text console, or a ssh session from another computer, is the way to accomplish this. As root, issue the following command::
  
   [root@locahost ~]# passwd xsce-admin
   Changing password for user xsce-admin.
   New password: <new password>
   Retype new password: <new password>
   passwd: all authentication tokens updated successfully.   

Installation of Specific Hardware Platforms (Ordered small to Large)
===================================================================

Install on Raspberry Pi 2
-------------------------
The original image, which was used as a basis for the XSCE install came from::

   http://www.digitaldreamtime.co.uk/images/Fidora/21/

There is information for how to copy a downloaded image onto a SD card at::

   https://www.raspberrypi.org/documentation/installation/installing-images/

The fully installed XSCE image is available at::

   http://downloads.unleashkids.org/xscd/downloads/installer/rpi2

XSCE On the XO 1.5, XO-1.75, or XO-4 laptop
------------------------------------------

Gateway Installation Network Configurations
===========================================

| **One Dongle**
|    eth0 - internal wifi for gateway
|    eth1 - usb ethernet for schoolserver LAN connected to an access point

| **Two Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet for gateway
|    eth2 - usb ethernet for schoolserver LAN connected to an access point

Non-Gateway (aka "Appliance") Installation Network Configurations
================================================================

**NOTE:** Appliance installs integrate into existing networking infrastructure and do not include dhcpd, squid, dansguardian, or wondershaper.  This installation does not behave as an internet gateway.

| **XSCE Appliance - no additional interfaces**
|    eth0 - internal wifi connected to an existing LAN

| **XSCE Appliance One Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet connected to an existing LAN 

How To Install XSCE on an XO
----------------------------

* Flash the XO1.75 or XO4 laptop with a stable `13.2.4 image`_ (or the XO1.5 with `13.2.3 image`_)

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

    cd /opt
    mkdir -p schoolserver
    cd schoolserver
    git clone --branch stable --depth 1 https://github.com/XSCE/xsce
    cd xsce

* Verify all the network interfaces are visible and have the correct interface label::

    ifconfig

* Optionally, verify that all network interfaces are properly autodetected::

    sh roles/common/library/xsce_facts

* From the xsce directory, run initial setup.  The XO will automatically reboot upon completion::

    ./install-console

* After rebooting::

    cd xsce/
    ./runansible # This will take a lot of time as it installs packages
    reboot

* The XSCE should be up and functional

.. _13.2.3 image: http://wiki.laptop.org/go/Release_notes/13.2.3#Installation
.. _13.2.4 image: http://wiki.laptop.org/go/Release_notes/13.2.4#Installation

.. _XSCE: http://schoolserver.org/


Using tags
==========

* To avoid replaying all the playbooks, you can use tags to restrict which tasks are run: 

  ./runtags network (or connect to the XSCE Console by browsing to http://schoolserver/admin)
* Available tags are: ``activity-server,addons,authserver,base,centos,common,console,dhcpd,download,download2,edu-apps,ejabberd,elgg,generic,generic-apps,httpd,idmgr,iiab,iptables,kalite,kiwix,monit,moodle,munin,mysql,named,network,network-discover,olpc,once,openvpn,options,owncloud,pathagar,platform,portal,postgresql,rachel,samba,services,squid,sugar-stats,tools,vnstat,wondershaper,xo,xo-services,xovis``

Install on 32bit or 64bit Intel Machines
----------------------------------------

There are a number of options here, ranging from tried and true to new and experimental. The tried and true option is to start with a netinstall of the current OS, detailed  as "option 1" below, and gradually build the machine up from offline downloads:

Option 1
========

1. Start with a minimal install of the base OS based upon your hardware:
  * http://download.fedoraproject.org/pub/fedora/linux/releases/21/Server/x86_64/iso/Fedora-Server-netinst-x86_64-21.iso
  * http://download.fedoraproject.org/pub/fedora/linux/releases/21/Server/i386/iso/Fedora-Server-netinst-i386-21.iso

  * Copy the downloaded iso to a USB stick (use dd in linux, or UNetbootin in windows)

2. The installer is somewhat obscure:

   1. The first screen asks you to select keyboard and language
   2. The next screen is the home page; you will click on topics, go off make to selections, and then return by clicking done.
   3. Select "system"-installation destination:
       a. Device selection, click on hard disk, click checkbox for "I will configure partitioning", click done.
       b. In the left side window, under the drop down box, click <any previous OS> (unless the disk is already clean)
       c. Click on the minus (which deletes the selected partition), select the "delete all other filesystems in .. as well"
       d. Then select the drop down option "standard partition" and click the "+" at the bottom
       e. In the "add a new mount point" window, click "/"
       f. For the capacity enter the "total space" at bottom left of screen
       g. Click the done twice, and the accept changes
   4. Click on software selection, and then on lower left of that page select "minimal install", done
   5. Then click start install
   6. You will need to put in a password for root, during the install.
   7. At the end of the install, a button will appear, which asks you to reboot into the newly installed Operating System.
    
3. Once you have a console prompt, the steps are pretty straight forward:

    a. Connect the wifi unit to the adapter that will be used as the local area network (LAN), and make sure everything is under power with link lights.
    b. Issue the following commands::

         ping yahoo.com (this verifies that the server is properly connected to internet after the reboot)
         yum -y update
         yum -y install git ansible
         cd /opt
         mkdir -p schoolserver
         cd schoolserver
         git clone https://github.com/XSCE/xsce --branch stable --depth 1
         cd xsce
         ./install-console
         reboot

    c. I find it helpful to check that all the services are running on the server::

         syscemctl status NetworkManager
         systemctl status dhcpd
         systemctl status named
         ip addr (verify that the external adapter and the LAN adapter or br0 have ip addresses)

    d. At this point you can connect to the server via the wifi at http://schoolserver/admin.
    e. Decide which services need to be enabled, check the checkboxes, save the configuration, and click "install configured server'.
D. Next download any content needed for rachel, kiwix, and/or other instructional materials. There are instruction for how and where to place the downloaded materials in README files in each of the roles folders.

Option 2
========

Download the TinyCore loader image for your hardware platform from http://downloads.unleashkids.org/xsce/downloads/installer.
  * There is a netinstall image which will quickly bring your machine to 3. above.
  * The larger download named <arch>stable_<git hash>_fc21.img can bring your machine directly to 3.iii above.

Option 3
========

The livecd install method is currently in developmnt. Look for downloads at http://xsce.org/downloads/Server/images.

Experimental Install of XSCE software on Centos 7 
=================================================

At this point a TinyCore loader version of the netinstall is available. By early May 2015, a stable version of the full Centos image will be available at http://downloads/unleashkids.org/xsce/downloads/installer/experimental.

