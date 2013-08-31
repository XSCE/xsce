==============================
Installing the Dextrose Server
==============================

Like the XSCE, both single and two dongle installs are supported. Performing
the two dongle install requires a bit of manual configuration which we will
get to.

On the XO-1.75 or XO-4 laptop
*****************************
* Flash the laptop with a stable 13.2.0 image

* In ``My Settings->Power`` turn of Automatic Power Management

* Install ansible, git. You'll also need to clone the latest ansible sources
  because of a bug with the packaged version.

    ::

      su -
      yum -y install ansible git # This will pull in the required dependencies
      git clone git://github.com/ansible/ansible.git
      cd ansible
      git checkout devel
      source hacking/env-setup

* clone the DXS git repo; and run initial setup

    ::

      cd ~/
      git clone https://github.com/activitycentral/dxs.git
      cd dxs
      ./runansible xo
      reboot

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

      source ~/ansible/hacking/env-setup
      cd dxs
      ./runansible # This will take a lot of time as it installs packages
      reboot

* DXS should be up and functional
