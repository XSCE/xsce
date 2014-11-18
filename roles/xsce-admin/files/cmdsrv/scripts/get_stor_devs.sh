#!/bin/sh

FIRSTDEV=`ls -lav /dev |grep brw| grep disk| gawk 'NR==1' |gawk  --field-separator=' ' '{ print $10 }'`

parted /dev/$FIRSTDEV -ms print devices
