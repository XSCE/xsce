
# Use CDROM installation media (if dvd is used)
cdrom

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
#part / --fstype="ext4"

# System services
# services --enabled="chronyd"

repo --name=mirror --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=updates2 --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch

selinux --disabled
firstboot --disable

# Network information
network  --bootproto=dhcp --device=link --ipv6=auto --activate --hostname=schoolserver.lan

%post
mkdir /root/debug
# ensure network cards are turned on
NICs=`ls /etc/sysconfig/network-scripts/ifcfg-*` 
for nic in $NICs ; do
    case $o in
    *lo)
        ;;
    *)
        cp $nic /root/debug/
        sed -i -e "s/ONBOOT=no/ONBOOT=yes/" $nic
        ;;
    esac
done

# make kickstart see ansible
echo "path is $PATH"
export PATH=/usr/bin:/usr/sbin:/sbin:/bin:$PATH
echo "path is $PATH"

# make the default install path and clone
mkdir -p /opt/schoolserver
cd /opt/schoolserver

$ switch this to release branch or stable once it's updated. 
#git clone --depth 1 --branch stable https://github.com/XSCE/xsce 
git clone --depth 1 --branch build_freeze https://github.com/XSCE/xsce 

cd xsce

# set install time options here
cat > /opt/schoolserver/xsce/vars/local_vars.yml  << EOF
postgresql_install: True
mysql_install: True
pathagar_install: True
EOF

### preload the new install
./runtags download,download2 > xsce-preload.log
touch /.preload

# Don't start services while in the chroot
cat > /opt/schoolserver/xsce/vars/local_vars.yml << EOF
installing: True
EOF

/opt/schoolserver/xsce/install-console > xsce-kickstart.log

# get rid of custom local_vars
git reset --hard

# run install-console on first boot
cat > /etc/rc.d/init.d/xsce-prep << EOF
#!/bin/bash
#
# xsce: Init script for xsce-prep
#
# chkconfig: 345 00 98

# description: Init script for XSCE prep.
### BEGIN INIT INFO
# X-Start-Before: display-manager
### END INIT INFO

. /etc/init.d/functions

### 
if [ -e /.xsce-booted ] ; then
    systemctl disable xsce-prep
    #/sbin/chkconfig --del xsce-prep
    #rm /etc/rc.d/init.d/xsce-prep
    exit 0
fi

# the vars/* are not found
cd /opt/schoolserver/xsce/

if [ -f  xsce-kickstart.log ] ; then
    result=`cat xsce-kickstart.log | grep failed=0 | awk '{print $6}' | wc -l`
    if [ $result -eq 1 ] ; then
        # ran to completion
        ./xsce-network > xsce-firstboot.log
        touch /.xsce-booted
        exit 0
    fi
fi
./install-console > xsce-firstboot.log
touch /.xsce-booted
exit 0

EOF

# now make xsce-prep active
chmod 755 /etc/rc.d/init.d/xsce-prep
restorecon /etc/rc.d/init.d/xsce-prep
chkconfig --add xsce-prep

%end

%packages
wget
git
ansible
python-pip
nano
%end
