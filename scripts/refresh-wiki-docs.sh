#!/bin/bash -x
# pull down repo wiki, and imbed in docs subdirectory

source /etc/xsce/xsce.env
REPONAME=xsce
REPO=https://github.com/XSCE
WIKI=xsce-wiki

# this script is located in the scritps/ direcctory in the local repo
SCRIPTDIR=$(dirname $0)
pushd $SCRIPTDIR

if [ ! -d /tmp/${WIKI} ]; then
   mkdir -p /tmp/${WIKI}
   git clone $REPO/$REPONAME.wiki.git /tmp/${WIKI}
fi

rsync -v /tmp/$WIKI/* ../docs

# convert the markdown docs to html
which pandoc
if [ $? -ne 0 ]; then
   if [ "$OS" = "CentOS" ] || [ "$OS" = "Fedora" ]; then
      yum install -y pandoc
   else
      apt-get install -y pandoc
   fi
fi
mkdir -p ../docs/html/online-help-offline
#mkdir -p ../docs/html/offline-help

for f in `ls ../docs`; do
    FTRIMMED=${f%.md}
    if [ $FTRIMMED = "Home" ]; then FTRIMMED=index;fi
    pandoc -s ../docs/$f -o ../docs/html/online-help-offline/$FTRIMMED.html
    # make links refer to local directory
    sed -i -e "s|$REPO/$REPONAME/wiki/\(.*\)\">|./\1.html\">|" ../docs/html/online-help-offline/$FTRIMMED.html
    sed -i -e "s|schoolserver.org/faq|../FAQ|" ../docs/html/online-help-offline/$FTRIMMED.html
    sed -i -e "s|$REPO/$REPONAME/blob/release-.*/\(.*\)\">|../\1.html\">|" ../docs/html/online-help-offline/$FTRIMMED.html
done

# copy the faq and other things
wget -c http://wiki.laptop.org/go/XS_Community_Edition/FAQ -P ../docs/html
wget -c http://wiki.laptop.org/go/XS_Community_Edition/Security -P ../docs/html
wget -c http://wiki.laptop.org/go/XS_Community_Edition/local_vars.yml -P ../docs/html

# fetch the embedded help pages from the admin console
#for f in `ls ../roles/xsce-admin/files/console/help`; do
#    FTRIMMED=${f%.rst}
#    pandoc -s ../roles/xsce-admin/files/console/help/$f -o ../docs/html/offline-help/$FTRIMMED.html
#    # make links refer to local directory
#    sed -i -e "s|$REPO/$REPONAME/wiki/\(.*\)\">|./\1.html\">)|" ../docs/html/$FTRIMMED.html
#done

# fetch the recent release notes
for f in `ls ../Release*`; do
#    FTRIMMED=${f%.md}
    FTRIMMED=${f:2}
    pandoc -s $f -o ../docs/html/$FTRIMMED.html
    # make links refer to local directory
    sed -i -e "s|$REPO/$REPONAME/wiki/\(.*\)\">|./\1.html\">)|" ../docs/html/$FTRIMMED.html
done
popd
