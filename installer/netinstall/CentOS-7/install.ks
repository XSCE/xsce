# Refers to where stage2 lives
# Use CDROM installation media (if dvd is used)
#cdrom

# Use graphical install
graphical
#text

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# System timezone
#timezone America/Winnipeg

ignoredisk --only-use=sda

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --none --initlabel

# Disk partitioning information
#autopart --type=plain

# custom layout
#part swap --fstype="swap" --ondisk=sda --size=2048
#part /boot --fstype="ext4" --ondisk=sda --size=500
#part / --fstype="ext4

# System services
# services --enabled="chronyd"

url --url=http://mirror.centos.org/centos/7.1.1503/os/x86_64/
repo --name=updates2 --baseurl=http://mirror.centos.org/centos/7.1.1503/updates/x86_64/
repo --name=epel-mirror --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=x86_64

selinux --disabled
firstboot --disable

# Network information
network  --bootproto=dhcp --device=link --ipv6=auto --activate --hostname=schoolserver

%post
#### part of automated install routine.

# make the default install path and clone
mkdir -p /opt/schoolserver
cd /opt/schoolserver

# switch this to release branch or stable once it's updated. 
#git clone --depth 1 --branch stable https://github.com/XSCE/xsce 
git clone --depth 1 --branch master https://github.com/XSCE/xsce

# prep
-include% /opt/schoolserver/xsce/installer/ks-scripts/prep.ks
# runtags download
-include% /opt/schoolserver/xsce/installer/ks-scripts/pre-load.ks
# install-console
-include% /opt/schoolserver/xsce/installer/ks-scripts/console.ks
# get rid of custom local_vars
-include% /opt/schoolserver/xsce/installer/ks-scripts/git-cleanup.ks
# xsce-prep
-include% /opt/schoolserver/xsce/installer/ks-scripts/xsce-prep.ks

%end

%packages
epel-release
wget
git
ansible
python-pip
nano
%end
