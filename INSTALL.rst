==============================
Installing the Dextrose Server
==============================

Like the XSCE both, single and two dongle installs are supported. Performing the two dongle install requires a bit of manual configuration which we will get to.

On the XO-1.75 or XO-4 laptop
*****************************
* Flash the laptop with a stable 13.2.0 image
* In ``My Settings->Power`` turn of Automatic Power Management
* Install ansible, git; clone the DXS git repo; and run initial setup

    ::

      su -
      yum -y install ansible git
      git clone https://github.com/activitycentral/dxs.git
      cd dxs
      ./runansible xo
      reboot

    .. Note:: Depending on the type of setup (one or two dongle), you'll need to check and edit the contents of ``<dxs_root_directory>/vars/default_vars.yml``. For a one dongle setup the interfaces are eth0 and eth1 for WAN and LAN respectively. For a two dongle setup, the interfaces become eth1 and eth2.

* After rebooting (insert the ethernet dongles at this point)...

    ::

      ./runansible
      reboot

* DXS should be up and functional
