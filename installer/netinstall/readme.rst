The install.ks files are designed to be introduced into Fedora's or CentOS's installer environment. The anaconda installer uses a method known as kickstart and we use that method to provide our information for the automated install. In a nutshell we need to get install.ks into the installer. Please refer to the kickstart documention for full details. One way is to place install.ks on a flashdrive and know the device's label. Hint with the key mounted: 
ls /dev/disk/by-label/

Now boot the install iso with the key inserted hit tab at the splash screen and append after quite:

inst.ks=hd:LABEL=<lablel>:/install.ks

replacing <label> with your device's label

There are other options that could be set but are left # out that could be enabled for a fully automated install.
Note these are intended for x86_64 and will need editing of the "arch=" to be i386 where x86_64 is seen. 
Not supported on CentOS-i386 until further testing occurs. 

If you're after a bootable usbkey use alter.sh with the net-install iso for your distro.

Feedback welcome


