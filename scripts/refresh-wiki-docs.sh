#!/bin/bash -x
# pull down repo wiki, and imbed in docs subdirectory

source /etc/xsce/xsce.env
REPONAME=xsce
REPO=https://github.com/XSCE
WIKI=xsce-wiki

# this script is located in the scritps/ direcctory in the local repo
SCRIPTDIR=$(dirname $0)

if [ ! -d /tmp/${WIKI} ]; then
   mkdir -p /tmp/${WIKI}
   git clone $REPO/$REPONAME.wiki.git /tmp/${WIKI}
fi

echo Files available for update:
ls -l /tmp/$WIKI

rsync -v /tmp/$WIKI/* $SCRIPTDIR/../docs

# convert the markdown docs to html
which pandoc
if [ $? -ne 0 ]; then
   if [ "$OS" = "CentOS" ] || [ "$OS" = "Fedora" ]; then
      yum install -y pandoc
   else
      apt-get install -y pandoc
   fi
fi
mkdir -p $SCRIPTDIR/../docs/html
for f in `ls $SCRIPTDIR/../docs`; do
    FTRIMMED=${f%.md}
    pandoc -s $SCRIPTDIR/../docs/$f -o $SCRIPTDIR/../docs/html/$FTRIMMED.html
    # make links refer to local directory
    sed -i -e "s|$REPO/$REPONAME/wiki/\(.*\)\">|./\1.html\">)|" $SCRIPTDIR/../docs/html/$FTRIMMED.html
done
