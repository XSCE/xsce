#!/bin/sh

WORKINGDIR=/library/working/$1
DESTDIR=/library/rachel/

echo "Moving www directory"
mv $WORKINGDIR/www $DESTDIR

echo "Moving bin directory"
mv $WORKINGDIR/bin $DESTDIR

echo "Removing $WORKINGDIR"
rm -Rf $WORKINGDIR

exit 0
