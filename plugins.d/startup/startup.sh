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
set -x -e -u

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

        ## Prepare config files
        CFG_TEMPLATES="rsyslog.conf motd.olpc sysctl.conf ssh/sshd_config
        sysconfig/named sysconfig/init sysconfig/squid rssh.conf php.ini
        httpd/conf.d/proxy_ajp.conf httpd/conf.d/ssl.conf"

        for i in $CFG_TEMPLATES; do
            cp -p $i.in $i
        done

        # Load new sysctl.conf settings
        sysctl -p

        #record the config file additions
        etckeeper-if-selected 'Config files copied <file.in> to <file>'

        # exit-hooks blasts school server into resolv.conf, use NM, and finese
        #ln -sf $CFGDIR/etc/dhcp/dhclient-exit-hooks $DESTDIR/etc/dhcp
        ln -sf $CFGDIR/etc/logrotate.d/* $DESTDIR/etc/logrotate.d
        ln -sf $CFGDIR/etc/profile.d/* $DESTDIR/etc/profile.d

        # sudo doesn't accept symlinks here
        install -m 440 $CFGDIR/etc/sudoers.d/* $DESTDIR/etc/sudoers.d
        install -m 440 $CFGDIR/etc/systemd/system/* $DESTDIR/etc/systemd/system

        # run setup scripts belonging to other packages
        #shopt -s nullglob
        #for i in /etc/sysconfig/olpc-scripts/setup.d/*; do
         #   [ -x $i ] && $i
        #done
        #shopt -u nullglob

        etckeeper-if-selected "disabled selinux, scripts sourced"

        # following packages are the core set of packages installed on all xs servers

        # make a non privileged user, and give her remote access
        if [ ! `grep $DEFAULTUSER /etc/passwd` ]; then
            adduser $DEFAULTUSER
            echo "$DEFAULTPASSWORD" | passwd $DEFAULTUSER --stdin
            #we've added apache to the admin group, so permit group access
            #then to let apache config system, we'll add apache to sudoers on
            #  the apply_changes script which will be written in /home/admin
            chmod 770 /home/$DEFAULTUSER
        fi
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

#do all of the yum installs in a single operation
        get_enabled_plugins
        INSTALLTHESE=""
        for mod in $PLUGIN_LIST; do
	    if [ -d $PLUGINDIR/$mod/yum ];then
                INSTALLTHESE=$INSTALLTHESE" "`ls -1 $PLUGINDIR/$mod/yum/`
	    fi
        done
        $YUM_CMD $INSTALLTHESE

        etckeeper-if-selected "after installing core packages"

    echo "startup routine completed" | tee -a $LOG
    date  2>&1 | tee -a $LOG

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
        # require that olpc user enter a password to become root
        sed -i -e '4s/^auth/#auth/' /etc/pam.d/su
        # internally we use /etc/.git as marker for first config run --
        #   --$ MARKER  is available externally
        touch $MARKER
        echo "XS configured; services should be active."
    fi

}
