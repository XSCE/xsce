#!/bin/bash
# rpmbuilds xs-config-$ver

    rpm=/home/Reiko/rpm
olpcimg=fsroot.olpc.img

name=xs-config
 ver=0.1.3
  nv=$name-$ver

scripts="symlink-tree.py unlink-tree.py"
olpcroot=fsroot.olpc

mkdir $nv
cp -p Makefile $nv
rsync -ar $olpcimg/ $nv/$olpcroot
cp -p $scripts $nv/$olpcroot
tar cfz $rpm/SOURCES/$nv.tar.gz $nv
rm -rf $nv
rpmbuild -ba --target noarch $name.spec

