###
###  Kickstart file for OLPC XS School Server software
###

### Make it interactive - so these are 'seed' values
interactive

# Provide some defaults
lang en_US.UTF-8
keyboard us
#timezone --utc America/New_York
auth --useshadow --enablemd5
selinux --disabled
#network --device eth0 --bootproto dhcp --hostname schoolserver
firstboot --enabled

#  We enable the firewall, even though we are going to overwrite
#  what anaconda leaves behind
firewall --disabled

### X?
#skipx

## Enable/Disable some services up front
services --enabled=dhcdbd,network,sshd,haldaemon,hddtemp,smartd,anacron,crond,atd,incron,avahi-daemon,named,ntpd,aiccu,messagebus,httpd,ejabberd,xinetd,pgsql-xs --disabled=iptables,netfs,nfs,nfslock,rpcbind,rpcgssd,rpcidmapd,rpcsvcgssd,avahi-dnsconfd,radvd,ip6tables,dc_client,dc_server,squid,autofs,gpm,yum-updatesd,postgresql,dhcpd,exim

###
### disk partitioning...
###
# clear out sda without qualms...
#clearpart --drives=sda --initlabel

# Small Disk Support:       (xs #7241)
# If space >~10GiB then the sizes are
#       /boot       100 MiB
#       /             8 GiB
#       swap          2 GiB
#       /library    fills all remaining capicity
# If space is limited, partition sizes are reduced.
# Smallest supported capacity is ~5GiB when no livecd-creator --uncompressed-size argument is
# specified (defaults to 4096).
# Using livecd-creator --uncompressed-size=2048 allows installation on ~3GiB disks (not tested yet).
#bootloader --location=mbr --driveorder=sda --append="rhgb"
#part /boot --fstype ext3 --size=300 --ondisk=sda --asprimary
#part / --fstype ext3 --size=2048 --maxsize=8192  --ondisk=sda --asprimary --recommended

# size of pv.6 must be at least enough to fit /library size and swap size
#part pv.6 --size=2304 --grow --ondisk=sda --asprimary --recommended
#volgroup VolGroup00 pv.6
# Kickstart raises an error if logvol --size=0
#logvol /library --fstype ext3 --name=LogVol00 --vgname=VolGroup00 --size=100 --grow --recommended
#logvol swap --fstype swap --name=LogVol01 --vgname=VolGroup00 --maxsize=2048 --recommended

%packages 

# School server core services metapackage
@xs-server
xsau-config
xsau-release
-xs-config
-xs-release
-fedora-release
-fedora-logos
@admin-tools
-gnome-packagekit
#-selinux-policy-targeted
bitfrost
nano
%end

%post
# toggle eth0 on at boot and set dhcp
sed -i -e "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0
echo "BOOTPROTO=dhcp" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "PEERDNS=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "IPV6INIT=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0

# turn on firstboot for XS builds
#echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

%end
