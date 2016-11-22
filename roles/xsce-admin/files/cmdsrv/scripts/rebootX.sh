#!/bin/sh

source /etc/xsce/xsce.env

if [ "$OS" == "debian"
	/bin/sleep 3
	/sbin/reboot
else
	/usr/bin/sleep 3
	/usr/sbin/reboot
fi
exit 0
