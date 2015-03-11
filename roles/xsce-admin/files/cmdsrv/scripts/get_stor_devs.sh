#!/bin/sh
# this will break on machines with LVM, but other things will too

FIRSTDEV=`ls -lav /dev |grep brw| grep 'sd\|mmc' | gawk 'NR==1' |gawk  --field-separator=' ' '{ print $10 }'`

parted /dev/$FIRSTDEV -ms print devices
