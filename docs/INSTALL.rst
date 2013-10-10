==============================
Installing the Dextrose Server
==============================

Like the XSCE_, both single and two dongle installs are supported. Performing
the two dongle install requires a bit of manual configuration which we will
get to.

On the XO-1.75 or XO-4 laptop
*****************************
* Flash the laptop with a stable `13.2.0 image`_

* In ``My Settings->Power`` turn of Automatic Power Management

* Install ansible, git. 

    ::

      su -
      wget http://xsce.activitycentral.com/repos/xs-extra/noarch/ansible-1.3.1-0.git201309161027.fc18.noarch.rpm
      yum -y localinstall ansible-1.3.1-0.git201309161027.fc18.noarch.rpm
      yum -y install git

* clone the DXS git repo; and run initial setup

    ::

      cd ~/
      git clone https://github.com/activitycentral/dxs.git
      cd dxs
      ./runansible

    .. Warning::
       Depending on the type of setup (one or two dongle), you'll need to
       check and edit the contents of
       ``<dxs_root_directory>/vars/default_vars.yml``. For a one dongle
       setup the interfaces are eth0 and eth1 for WAN and LAN respectively.
       For a two dongle setup, the interfaces become eth1 and eth2. Since
       DXS won't automatically find out which eth is LAN or WAN, a good
       practice would be to first insert the WAN dongle, so it get's its IP
       address, and then insert the LAN dongle.



* After rebooting (insert the ethernet dongles at this point)...

    ::

      cd dxs
      ./runansible # This will take a lot of time as it installs packages
      reboot

* DXS should be up and functional

.. Note::
   You may also wish to see the detailed INSTALL instructions at this link:
   ``https://sugardextrose.org/projects/dxs/wiki/Testbed-github``

.. _13.2.0 image: http://wiki.laptop.org/go/Release_notes/13.2.0#Installation
.. _detailed install instructions: https://sugardextrose.org/projects/dxs/wiki/Testbed-github
.. _XSCE: http://schoolserver.org/

Building the rpm
*****************************

* An rpm can be built by using the command

    ::
      rpmbuild -bb dxs.spec

