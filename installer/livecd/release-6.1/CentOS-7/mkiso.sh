#!/bin/bash
# install livecd-tools
yum install livecd-tools

KSCFG=centos-7-live-xsce.cfg
BASE_ON=
FSLABEL=CentOS-7-XSCE-6.1-LIVE
CACHE=/opt/schoolserver/yum-packages-CentOS
LOG=xsce-spin.log

livecd-creator -c $KSCFG -f release-$FSLABEL --title $FSLABEL --product=CentOS --releasever=7 --cache=$CACHE
#| tee -a $LOG

