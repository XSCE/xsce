text
# Use hard drive installation media
harddrive --dir=None --partition=/dev/mapper/live-base
# Firewall configuration
firewall --disabled
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts=''
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --hostname=schoolserver
# Root password
#rootpw --iscrypted <omit>
# SELinux configuration
selinux --disabled
# System services
services --enabled="sshd"
# Do not configure the X Window System
skipx
# System timezone
#timezone America/Winnipeg --isUtc
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart --type=plain
# Partition clearing information
clearpart --all --initlabel --drives=sda

%post

# run ./runtags network on first boot
systemctl enable xsce-prep

# cover new devices on first boot
cat > /etc/rc.d/init.d/xsce-prep2 << EOF
#!/bin/bash
#
# xsce: Init script for xsce-prep2
#
# chkconfig: 345 00 98

# description: Init script for XSCE prep.
### BEGIN INIT INFO
# X-Start-Before: display-manager
### END INIT INFO

. /etc/init.d/functions

### 
if [ -e /.xsce-booted2 ] ; then
    systemctl disable xsce-prep
    #/sbin/chkconfig --del xsce-prep
    #rm /etc/rc.d/init.d/xsce-prep
    exit 0
fi

# the vars/* are not found
cd /opt/schoolserver/xsce/
./runtags network > xsce-firstboot.log
touch /.xsce-booted2
exit 0
EOF

# now make xsce-prep2 active
chmod 755 /etc/rc.d/init.d/xsce-prep
chkconfig --add xsce-prep2
systemctl enable xsce-prep2
restorecon /etc/rc.d/init.d/xsce-prep2

%end
