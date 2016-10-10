#!/bin/bash
# install livecd-tools
yum install livecd-tools

KSCFG=ks.cfg
BASE_ON=
FSLABEL=F23-XSCE-master-LIVE
CACHE=/opt/schoolserver/yum-packages-F23
LOG=xsce-spin.log

livecd-creator -c $KSCFG -f beta-$FSLABEL --title $FSLABEL --product=Fedora --releasever=23 --cache=$CACHE
#| tee -a $LOG

