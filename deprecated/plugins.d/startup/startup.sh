#!/bin/bash +x

#  Copyright 2012, One Laptop per Child
#  Author: George Hunt, Jerry Vonau
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# collect here all the separate setup independent changes to stock XO software
#  -- ordered alphabetically
# usage: source this file -- for example to install a WWW server:
#===============================================================================
#!/bin/bash
#examble install script
#source /usr/bin/xs-setup-functions
#startup
#httpd yes
#do-last
#===============================================================================
#
# notes: need to systemctl unmask before systemctl enable
set -e -u

DESTDIR=""
CFGDIR=/usr/share/xs-config/cfg
PLUGINDIR=/usr/share/xs-config/plugins.d
CFGFUNCTIONS=/etc/sysconfig/olpc-scripts/functions
MARKER=/.olpcxs-configured
PREPED=/.xsce-preped
LOG=/var/log/xs-setup.log
POSTGRESSDIR=/library/pgsql-xs
SETUPSTATEDIR=/etc/sysconfig/olpc-scripts/setup.d/installed
ISXO=`[ -f /proc/device-tree/mfg-data/MN ] && echo 1 || echo 0`
YUMERROR=10
YUM_CMD="yum -y install"
YUM_REINSTALL="yum -y reinstall"
XSARCH=`uname -i`
FEDORA=`rpm -q fedora-release|gawk 'BEGIN {FS="-";}{print $3}'`

### we need to reference these in an external config file
DEFAULTUSER='admin'
DEFAULTPASSWORD='12admin'
VNCUSER='vnc'
VNCPASSWORD='*vnc4u*'
NCATPORT=29753

function get_usb_repo()
{
    for usb in `ls /mnt`;do
        if [ -d /mnt/$usb/xs-repo ];then
	    echo "INFO using <usbkey>/xs-repo for yum cache" | tee -a $LOG
            bind_yum=`mount | grep var/cache/yum | wc | gawk '{print $2}'` 
	    if [ $bind_yum -eq 0 ];then
	        mount --bind /mnt/$usb/xs-repo /var/cache/yum
	    fi
	    # convert uname -i to match what yum uses
	    # might need to converet to using case for x64 i386 if affected
	    if [ $XSARCH = "armv7l" ];then
		YUM_ARCH=armhfp
	    else
		YUM_ARCH=$XSARCH
	    fi
            if [ -d /mnt/$usb/xs-repo/$YUM_ARCH/$FEDORA/repodata ];then
		YUM_CMD="yum -c /tmp/yum.conf -y install"
		YUM_REINSTALL="yum -c /tmp/yum.conf -y reinstall"
		cat << EOF > /tmp/yum.conf
[main]
cachedir=/var/cache/yum/\$basearch/\$releasever
keepcache=1
exactarch=1
obsoletes=1
gpgcheck=0
installonly_limit=3
#yum.repos.d=/tmp

#  This is the default, if you make this bigger yum won't see if the metadata
# is newer on the remote and so you'll "gain" the bandwidth of not having to
# download the new metadata and "pay" for it by yum not having correct
# information.
#  It is esp. important, to have correct metadata, for distributions like
# Fedora which don't keep old packages around. If you don't like this checking
# interupting your command line usage, it's much better to have something
# manually check the metadata once an hour (yum-updatesd will do this).
# metadata_expire=90m

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d

[usb-media]
name=usb-media
baseurl=file:///mnt/$usb/xs-repo/\$basearch/\$releasever
enabled=1
gpgcheck=0
cost=100

EOF
		echo "FOUND /var/cache/yum/$YUM_ARCH/$FEDORA/metadata" | tee -a $LOG
		HAVE_GATEWAY=`route -n | awk '{if($4=="UG")print $8}'`
		echo "HAVE_GATEWAY is $HAVE_GATEWAY" | tee -a $LOG
		if [ x"$HAVE_GATEWAY" = x ]; then
		    echo "no gateway - disabling on-line yum repos" | tee -a $LOG
		    YUM_CMD="yum -c /tmp/yum.conf --disablerepo=* --enablerepo=usb-media -y install"
		    YUM_REINSTALL="yum -c /tmp/yum.conf --disablerepo=* --enablerepo=usb-media -y reinstall"
		fi
	    else
		echo "INFO metadata not found - skipping repo use"| tee -a $LOG
	    fi
	    break
	else
	    echo "INFO usbkey xs-repo not found on /mnt/$usb - skipping"| tee -a $LOG
        fi
    done
}

function unmount-yum-cache()
{
    echo "called unmount-yum-cache" | tee -a $LOG
    yum_mnt=`mount | grep var/cache/yum | wc | gawk '{print $2}'`
    echo "found $yum_mnt bind mounts" | tee -a $LOG 
    if  [ $yum_mnt -gt 0 ]; then
	RELEASEVER=`ls /var/cache/yum/$YUM_ARCH`
	umnt_yum=`mount | grep cache/yum | gawk '{print $3}'`
	echo "yum mount points are $umnt_yum "
	for mnt in $umnt_yum; do
	    echo "unmounting $mnt" | tee -a $LOG
	    umount /var/cache/yum | tee -a $LOG
	done
    else
	echo "INFO /var/cache/yum is not mounted" | tee -a $LOG
    fi
}

function create-usb-repo2()
{
    echo "starting create-usb-repo2" | tee -a $LOG
    unmount-yum-cache
    usb_mnt=`mount | grep fat | gawk '{print $1}'`
    if [ x"$usb_mnt" != x ]; then
	usbkey=$(findmnt -n -o TARGET -S $usb_mnt)
	echo "found "$usbkey""
	if [ -d "$usbkey"/xs-repo -a ! -d "$usbkey"/library ]; then
	    # Try to figure out which interface is connected to a gateway
	    HAVE_GATEWAY=`route -n | awk '{if($4=="UG")print $8}'`
	    echo "HAVE_GATEWAY is $HAVE_GATEWAY" | tee -a $LOG
	    if [ x"$HAVE_GATEWAY" != x ]; then 
  		mkdir -p "$usbkey"/xs-repo/$YUM_ARCH/$RELEASEVER/local | tee -a $LOG
		yumdownloader --destdir="$usbkey"/xs-repo/$YUM_ARCH/$RELEASEVER/local xs-config* | tee -a $LOG
		createrepo "$usbkey"/xs-repo/$YUM_ARCH/$RELEASEVER | tee -a $LOG
		sleep 2
		sync
		fi
	fi
	echo "umounting "$usbkey"" | tee -a $LOG
	umount "$usbkey"
    else
	echo "INFO No external media found" | tee -a $LOG
    fi
    echo "leaving create-usb-repo2" | tee -a $LOG
}

# for the XO-1, we need to have sd card, and to turn off X11 windows
function have_sd_card {
    BLKDEVS=`ls  "/dev/mmcblk1*"`
}
#function setup_sd_card {
#}
#function setup_swap_file {
     
#}


# old function name was do_first()
function startup()
{
    # for public demo, disable any functions that would change the machine state
    if [ -f /etc/sysconfig/xs-disable-config ]; then
        echo ""
        echo "======================================================"
        echo
        echo "This public demonstration server cannot be configured remotely"
        echo
        echo "======================================================"
        exit 0
    fi

    # init etckeeper and turn it off
    set-etckeeper yes
    yum-etckeeper no
    set-etckeeper no

    pushd /etc

    ## Prepare config files
    CFG_TEMPLATES="rsyslog.conf motd.olpc sysctl.conf ssh/sshd_config
    sysconfig/named sysconfig/init rssh.conf php.ini
    httpd/conf.d/proxy_ajp.conf httpd/conf.d/ssl.conf"

    for i in $CFG_TEMPLATES; do
        cp -p $i.in $i
    done

    popd

        # Load new sysctl.conf settings
        sysctl -p

        #record the config file additions
        etckeeper-if-selected 'Config files copied <file.in> to <file>'


        # run setup scripts belonging to other packages
        #shopt -s nullglob
        #for i in /etc/sysconfig/olpc-scripts/setup.d/*; do
         #   [ -x $i ] && $i
        #done
        #shopt -u nullglob

        etckeeper-if-selected "disabled selinux, scripts sourced"

        # make a non privileged user, and give her remote access
        if [ ! -d /home/$DEFAULTUSER ]; then
            adduser $DEFAULTUSER
            echo "$DEFAULTPASSWORD" | passwd $DEFAULTUSER --stdin
            #we've added apache to the admin group, so permit group access
            #then to let apache config system, we'll add apache to sudoers on
            #  the apply_changes script which will be written in /home/admin
            chmod 770 /home/$DEFAULTUSER
        fi
	### we should just change the config file.
        sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
        systemctl enable sshd.service
        systemctl restart sshd.service

        #  setup NetworkManager -- turns off xo's wifi when second adapter is added, reinit masquerade
        # Initialize the default LAN address
        #   the syntax is "ip:<number of 1's in mask>:gateway:nameserver:"
        mkdir -p /home/$DEFAULTUSER/etc/sysconfig/
        echo "172.18.96.1:19:0.0.0.0;127.0.0.1;" > /home/$DEFAULTUSER/etc/sysconfig/xs_lan_ip
        # Initialize the default WAN address
        echo "DHCP" > /home/$DEFAULTUSER/etc/sysconfig/xs_wan_ip
        # Initialize the default opendns ip address
        echo "208.67.222.222;208.67.220.220;" > /home/$DEFAULTUSER/etc/sysconfig/xs_opendns_ip
        chmod -R 770 /home/$DEFAULTUSER
        chown -R $DEFAULTUSER:$DEFAULTUSER /home/$DEFAULTUSER

    get_enabled_plugins

    # add some sysamin tools
    TOOLS=`ls $PLUGINDIR/startup/yum/`
    $YUM_CMD $TOOLS | tee -a $LOG
    
    #do all of the yum installs in a single operation
    if [ ! -e $PREPED ]; then
	# always install the following
	INSTALLTHESE="bind"
	for mod in $PLUGIN_LIST; do
	    if [ -d $PLUGINDIR/$mod/yum ];then
		INSTALLTHESE=$INSTALLTHESE" "`ls $PLUGINDIR/$mod/yum/`
	    fi
	done
	echo "installing rpms: $INSTALLTHESE" | tee -a $LOG
	$YUM_CMD $INSTALLTHESE | tee -a $LOG

	# if yum was unsuccessful, find it out now
	# "username named not found" but it's what happens otherwise
	grep named /etc/passwd
        if [ $? -ne 0 ] ; then
 	    echo "==================================================="
	    echo "\n\nYum  was not successfull\n\n" | tee -a $LOG
	    sleep 10
	    sync
	    echo "If this was an online install, check network connection"
	    echo "If this was offline, check USB drive\n\n"
 	    echo "==================================================="
            exit $YUMERROR
        fi
	etckeeper-if-selected "after installing core packages"
    fi
    echo "startup routine completed" | tee -a $LOG
    date  2>&1 | tee -a $LOG

}

function do_once()
{
    #things to do the first time -- only once
    if [ -e $MARKER ]; then
        echo "do_once exiting, marker exists" | tee -a $LOG
    else
        ### fix the indenting later  
    if [ -e /home/olpc/xs-setup.log ]; then
	mv /home/olpc/xs-setup.log /var/log/
    set +e
	mv /home/olpc/yum.log /var/log/
    set -e
    fi

    ###
    ### CLEANUP XS 0.4 to XS 0.5
    ###
    # Remove old configs that are unambiguously old
    OLDCONFIGS="/etc/sysconfig/network-scripts/ifcfg-dummy0
    /etc/sysconfig/network-scripts/ifcfg-br0
    /etc/sysconfig/network-scripts/ifcfg-br1
    /etc/sysconfig/network-scripts/ifcfg-br2  "
    for FPATH in $OLDCONFIGS; do
        if [ -e "$FPATH" ];then
            rm -f "$FPATH"
        fi
    done
    # Remove ifcfg-ethX files that refer to libertas devices
    # these have been replaced with wmeshX devices
    for FPATH in /etc/sysconfig/network-scripts/ifcfg-eth*; do
    # Here the implicit ls has incorporated $DESTDIR
        if grep -q '^ESSID=\"school-mesh-' "$FPATH" ;then
            rm -f "$FPATH"
        fi
    done
    # remove eth1:1 if it's the 'school server master address'
    FPATH="/etc/sysconfig/network-scripts/ifcfg-eth1:1"
    if [ -e "$FPATH" ];then
        if grep -q '^IPADDR=172.18.1.1' "$FPATH" ;then
            rm -f "$FPATH"
        fi
    fi

    # keep yum cache
    sed -i -e 's/keepcache=0/keepcache=1/' /etc/yum.conf
    if [ -f /etc/yum.repos.d/fedora.repo ]; then  # rpi uses pidora repo name
        sed -i -e 's/metadata_expire=7d/metadata_expire=never/' /etc/yum.repos.d/fedora.repo
    fi

    sed -i -e '/^enabled=/a exclude=ejabberd' /etc/yum.repos.d/fedora.repo
    sed -i -e '/^enabled=/a exclude=ejabberd' /etc/yum.repos.d/fedora-updates.repo
    sed -i -e '/^enabled=/a exclude=ejabberd' /etc/yum.repos.d/fedora-updates-testing.repo

    # use NM keyfile in place of ifcfg-rh XOs have this set already via OOB
    sed -i -e 's/ifcfg-rh/keyfile/' /etc/NetworkManager/NetworkManager.conf

    # exit-hooks blasts school server into resolv.conf, use NM, and finese
    #ln -sf $CFGDIR/etc/dhcp/dhclient-exit-hooks $DESTDIR/etc/dhcp
    #ln -sf $CFGDIR/etc/logrotate.d/* $DESTDIR/etc/logrotate.d
    ln -sf $CFGDIR/etc/profile.d/* $DESTDIR/etc/profile.d

    # sudo doesn't accept symlinks here
    install -m 440 $CFGDIR/etc/sudoers.d/* $DESTDIR/etc/sudoers.d

    # Work would be needed to get the XS components playing nice with SELinux, so
    # disable it.
    if selinuxenabled; then
        setenforce 0
        sed -i -e 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    fi
    echo "-y" > $DESTDIR/fsckoptions
    echo "do_once routine completed" | tee -a $LOG
    date  2>&1 | tee -a $LOG
    fi
}

function get_enabled_plugins()
{
    ## add sourcing external config file on usbkey
    if [ -e /etc/xs-setup.conf ]; 
    then
        source_file=/etc/xs-setup.conf
    else
        source_file=/usr/share/xs-config/cfg/etc/xs-setup.conf
    fi
    echo "using $source_file for enabled_plugins" | tee -a $LOG
    wanted_mods=`cat $source_file | grep yes | awk '{print $1}'`
    PLUGIN_LIST=
    for plugin in $wanted_mods; do
       if [ $(echo $plugin | grep \# ) ];
       then
           echo "plugin disabled $plugin" | tee -a $LOG
       else
           echo "$plugin" | tee -a $LOG
           PLUGIN_LIST="$PLUGIN_LIST $plugin" 
       fi
    done
}

function etckeeper-if-selected()
{
    if [ -e $SETUPSTATEDIR/etckeeper ] && [ $# -gt 1 ]; then
        set +e
        etckeeper commit -m $2
        set -e
    fi
}

function set-etckeeper()
{
	case "$1" in
	"yes")
        if [ ! -d /etc/.git ]; then
            pushd /etc
            etckeeper init
            popd
        fi

        if [ ! -e $SETUPSTATEDIR/etckeeper ]; then
            touch $SETUPSTATEDIR/etckeeper
        fi
        ;;
	"no")
        if [ -e $SETUPSTATEDIR/etckeeper ]; then
            rm $SETUPSTATEDIR/etckeeper
        fi
        ;;
	esac
}

function yum-etckeeper()
{
	case "$1" in
	"yes")
        set-etckeeper yes
        sed  -i -e 's/^enabled=0/enabled=1/' /etc/yum/pluginconf.d/etckeeper.conf
        ;;
	"no")
        sed  -i -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/etckeeper.conf
        ;;
	esac
}


function do-first()
{
    echo "do-first executed"
}

function do-last()
(
    do_last
)

function do_last()
{
    etckeeper-if-selected 'School Server setup changed - do_last'
    echo "do last executed" | tee -a $LOG
    date | tee -a $LOG
    if [ ! -e $MARKER ]; then
        if [ -f /tmp/yum.conf ]; then
	    rm /tmp/yum.conf
        fi
        # mlocate needs to be initialized with all the new files
        updatedb
        # require that olpc user enter a password to become root
        sed -i -e '4s/^auth/#auth/' /etc/pam.d/su
        # internally we use /etc/.git as marker for first config run --
        #   --$ MARKER  is available externally
        touch $MARKER
        echo "XS configured; services should be active." | tee -a $LOG
    else
	echo "XS configured do last already executed - marker present."	| tee -a $LOG
    fi
}
