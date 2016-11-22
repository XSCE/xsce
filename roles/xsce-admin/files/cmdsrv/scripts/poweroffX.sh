#!/bin/sh

source /etc/xsce/xsce.env

if [ "$OS" == "debian"
  /bin/sleep 3
  /sbin/shutdown -P now
else
  /usr/bin/sleep 3
  /usr/sbin/shutdown -P now
fi

exit 0
