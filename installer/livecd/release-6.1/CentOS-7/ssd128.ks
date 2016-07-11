#text
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
#skipx
# System timezone
#timezone America/Winnipeg --isUtc

# System bootloader configuration
#bootloader --location=mbr --boot-drive=sda
autopart --type=plain
# Partition clearing information
clearpart --all --initlabel --drives=sda
part /library --fstype="ext4" --ondisk=sda --size=207872
part / --fstype="ext4" --ondisk=sda --size=20480
part /boot --fstype="vfat" --ondisk=sda --size=200 --fsoptions="umask=0077,shortname=winnt"

%post
# run xsce-network on first boot
systemctl enable xsce-prep
systemctl disable xsce-installer
/sbin/chkconfig --del xsce-installer
rm /etc/rc.d/init.d/xsce-installer
rm /usr/bin/xsceinst

# disable the graphical login
ln -s --force /lib/systemd/system/multi-user.target /etc/systemd/system/default.target

%end
#%anaconda
#pwpolicy root --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
#pwpolicy user --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
#pwpolicy luks --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
#%end

