==============
USB Lib README
==============

This role implements Library Box type functionality to mount and link content on a USB drive.

Automount is handled by usbmount and scripts in this role look in the root of the mounted drive for

* /share
* /Share
* /PirateShare

and if found create a symlink of the form /library/content/USBn points to /media/usbn.

There is also a patch for problems with automount on Fedora 21+
