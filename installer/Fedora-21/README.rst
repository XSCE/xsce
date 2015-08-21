alter.sh uses livecd-iso-to-disk behind the curtain, which accepts the options below.  

    livecd-iso-to-disk [--help] [--noverify] [--format] [--msdos] [--reset-mbr]
                       [--efi] [--skipcopy] [--force] [--xo] [--xo-no-home]
                       [--timeout <time>] [--totaltimeout <time>]
                       [--extra-kernel-args <args>] [--multi] [--livedir <dir>]
                       [--compress] [--skipcompress] [--swap-size-mb <size>]
                       [--overlay-size-mb <size>] [--home-size-mb <size>]
                       [--delete-home] [--crypted-home] [--unencrypted-home]
                       [--updates updates.img] [--ks kickstart] [--label label]
                       <source> <target device>

alter.sh contents are:

"livecd-iso-to-disk --format --reset-mbr --ks install.ks --label F21-XSCE $@"

This presets some options for livecd-iso-to-disk namely the kickstart file to use.

"yum install livecd-tools" to install livecd-iso-to-disk.

Download F21 netinstall or DVD iso if you don't already have them 

I would not bother using the DVD.iso, would need to be updated after install while 
the netinstall will be fully updated out of the box.

then:

You choose which mode to boot the installer with.

THIS IS A DESTRUCTIVE PROCESS ALL DATA WILL BE ERASED

for uefi booting support
./alter.sh --efi  /path/to/DL/iso  /dev/sdX1

for legacy boot support
 ./alter.sh --msdos  /path/to/DL/iso  /dev/sdX1

Once the usbdisk is written the install could be further customized in the kickstart file
but ask about that before editing.

Once rebooted you should have the same as what ./install-console did for you.

