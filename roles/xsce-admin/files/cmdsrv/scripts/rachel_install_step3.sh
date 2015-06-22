#!/bin/sh

VERSION=$1
WORKINGDIR=/library/working/$VERSION
DESTDIR=/library/rachel/

RACHELWORKING=$WORKINGDIR/rachelusb_32EN_3.1.4/RACHEL/bin
echo "Moving www directory"
mv $RACHELWORKING/www $DESTDIR

echo "Moving bin directory"
mv $RACHELWORKING/bin $DESTDIR

echo "Removing $WORKINGDIR"
rm -Rf $WORKINGDIR

echo $VERSION > $DESTDIR/version
exit 0
