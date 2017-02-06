==============
USB Lib README
==============

This role implements Library Box type functionality to mount and link content on a USB drive.

Automount is handled by the usbmount package, and scripts in this role look in the root of the mounted drive for

* /usb
* /share
* /Share
* /PirateShare

and if found create a symlink of the form /library/www/html/local_content/USBn points to /media/usbn (which is the mount point for external USB drives).

There is also a patch for problems with automount on Fedora 21+

Please Note that as of the 4.1.8-200.fc22.x86_64 not all USB drives will mount even with this patch.
