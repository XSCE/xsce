selinux --disabled
firewall --disabled
firstboot --disabled
network --hostname=schoolserver --bootproto=dhcp --onboot=yes
services --enabled=sshd

# optional can be set with gui
# Language support
#lang en_US

# Keyboard
#keyboard us

# Timezone
#timezone --utc Europe/Zurich

# Bootloader
#bootloader --location=mbr --driveorder=sda
#zerombr

# Partition table
#clearpart --linux --drives=sda

#part /boot --size=1024 --ondisk sda
#part pv.01 --size=1    --ondisk sda --grow
#volgroup vg1 pv.01
#logvol /    --vgname=vg1 --size=10000  --name=root
#logvol swap --vgname=vg1 --recommended --name=swap --fstype=swap
#ignoredisk --only-use=sda

%post
# ensure network cards are turned on
NICs=`ls /etc/sysconfig/network-scripts/ifcfg-` 
for nic in $NICs ; do
    case $o in
    *lo)
        ;;
    *)
        sed -i -e "s/ONBOOT=no/ONBOOT=yes/" $nic
        ;;
    esac
done

# turn off the installer on the reboot
touch /.xsce-installed

# Grab the latest git - should test for gateway if left in for production
#cd /opt/schoolserver/xsce/
#git pull

# Don't start services while in the chroot
cat > /opt/schoolserver/xsce/vars/local_vars.yml << EOF
installing: True
EOF

# Run the XSCE base install
/opt/schoolserver/xsce/install-console > /opt/schoolserver/xsce/kickstart.log

# Turns off the auto config
# Debugging ks install
#touch /.xsce-prepped

##### testing only #####
cat > /opt/schoolserver/xsce/vars/local_vars.yml << EOF
moodle_enabled: True
iiab_enabled: True
pathagar_enabled: True
squid_enabled: True
rachel_enabled: True
monit_enabled: True
dansguardian_enabled: True
ejabberd_enabled: True
owncloud_enabled: True
munin_enabled: True
elgg_enabled: True
xovis_enabled: True
sugar-stats_enabled: True
samba_enabled: True
vnstat_enabled: True
xo-services_enabled: True
ajenti_enabled: True
EOF

# Wipe the install info.
#cd /opt/schoolserver/xsce/
#git reset --hard > /dev/null

%end
