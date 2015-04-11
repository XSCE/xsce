#!/bin/bash
# install livecd-tools
yum install livecd-tools

KSCFG=ks.cfg
BASE_ON= 
FSLABEL=F20XSCEL
CACHE=/opt/schoolserver/yum-packages
LOG=xsce-spin.log

livecd-creator -c $KSCFG -f $FSLABEL --title $FSLABEL --product=$FSLABEL --cache=$CACHE 
#| tee -a $LOG

