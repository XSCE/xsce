function vnc()
{
	case "$1" in
	"yes")
        # mod_ssl permits vnc to be encrypted, nmap provides ncat which listens
        #       to a port and provides feedback across network to a remote client
        touch $SETUPSTATEDIR/vnc
        yum -y groupinstall XFCE  --exclude=xscreensaver-base 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        # or yum install x11vnc-javaviewers | tee -a $LOG

        # we need a login for vnc with password that is not user changeable
        if [ ! `grep $VNCUSER /etc/passwd` ]; then
            adduser $VNCUSER
            echo "$VNCPASSWORD" | passwd $VNCUSER --stdin
            echo "alias passwd='echo \"NOT ALLOWED!. It will break VNC remote access\"' " >> /home/$VNCUSER/.bashrc
        fi

        cp -p /lib/systemd/system/vncserver\@.service /etc/systemd/system
        sed -i -e "s/<USER>/$VNCUSER/" /etc/systemd/system/vncserver\@.service

        # if httpd version is 2.4.4, use new syntax for access control
        if [ rpm -qa httpd | gawk 'BEGIN {FS="-"}{print($2);}' >= "2.4.4" ]; then
            ln -fs "$CFGDIR/etc/httpd/conf.d/novnc-2.4.conf /etc/httpd/conf.d/"
        else
            ln -fs "$CFGDIR/etc/httpd/conf.d/novnc-2.2.conf /etc/httpd/conf.d/"
        fi

        # start the websocket service (part of the novnc package)
       systemctl enable vncserverweb.service 2>&1 | tee -a $LOG
        mkdir -m 755 -p /home/$VNCUSER/.vnc
        #ln -sf $CFGDIR/etc/systemd/system/* $DESTDIR/etc/systemd/system
        ln -sf $DESTDIR/etc/systemd/system/vncserver\@.service \
            $DESTDIR/etc/systemd/system/multi-user.target.wants/vncserver\@\:1.service
        cp $CFGDIR/etc/sysconfig/vnc/xstartup /home/$VNCUSER/.vnc/
        echo "$VNCPASSWORD" | vncpasswd -f > /home/$VNCUSER/.vnc/passwd

        sed -i -e "/password = WebUtil/ c\
password = WebUtil.getQueryVar(\'password\', \'$VNCPASSWORD\');" /usr/share/novnc/vnc_auto.html

        chown -R $VNCUSER:$VNCUSER /home/$VNCUSER/.vnc
        chmod 600 /home/$VNCUSER/.vnc/passwd
        cp $CFGDIR/etc/sysconfig/vnc/self.pem /home/$VNCUSER
        chown $VNCUSER:$VNCUSER /home/$VNCUSER/self.pem
        cp /etc/httpd/conf.d/ssl.conf.in /etc/httpd/conf.d/ssl.conf
        sed -i -e 's/^<ifDefine BOGUS/#<ifDefine BOGUS/' /etc/httpd/conf.d/ssl.conf
        sed -i -e 's/^<\/ifDefine/#<\/ifDefine/' /etc/httpd/conf.d/ssl.conf
		systemctl enable vncserver\@\:1.service 2>&1 | tee -a $LOG
        systemctl start vncserver\@\:1.service 2>&1 | tee -a $LOG
        systemctl start vncserverweb.service 2>&1 | tee -a $LOG

        # disable the startup panel config screen by populating the .config directory
        mkdir -m 755 -p /home/$VNCUSER/.config/xfce4/xfconf/xfce-perchannel-xml/
        cp $CFGDIR/etc/sysconfig/vnc/xfce4-panel.xml \
            /home/$VNCUSER/.config/xfce4/xfconf/xfce-perchannel-xml/
        chown $VNCUSER:$VNCUSER \
            /home/$VNCUSER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
        # turn off the xfce4 screen saver
        #su -c '/usr/bin/xfconf-query -c xfce4-session -n -t bool -p /startup/screensaver/enabled -s false' vnc

        # explore using ncat to pass install info to vnc client
        # at XS -- "xs-setup 2>&1 | tee > (ncat -p 20000 localhost)"
        # and at VNC -- "ncat -l -k p 20000 --ssl-key /home/admin/self.pem
        #    --ssl-cert /home/admin/self.pem localhost"
        #  -l = listen
        #   -k = keep open
        ;;
	"no")
		systemctl disable vncserver\@.service 2>&1 | tee -a $LOG
		systemctl stop vncserver\@.service 2>&1 | tee -a $LOG
        rm $SETUPSTATEDIR/vnc
        ;;
	esac
}
