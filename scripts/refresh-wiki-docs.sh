#!/bin/bash 
# pull down repo wiki, and imbed in docs subdirectory

WIKI=xsce.wiki
REPO=https://github.com/xsce/${WIKI}.git

# this script is located in the scritps/ direcctory in the local repo
SCRIPTDIR=$(dirname $0)

if [ ! -d /tmp/${WIKI} ]; then
   mkdir -p /tmp/${WIKI}
   git clone $REPO /tmp/${WIKI}
fi

echo Files available for update:
ls -l /tmp/$WIKI

rsync -v /tmp/$WIKI/* $SCRIPTDIR/../docs
