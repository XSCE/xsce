#!/bin/sh

WORKINGDIR=/library/working/zims/$1
SRCDIR=$WORKINGDIR/data
DESTDIR=/library/zims
ZIMFILE=/content/$1.zim
ZIMIDX=/index/$1.zim.idx

EXITCODE=0

# ZIM File

if [[ -f $DESTDIR$ZIMFILE ]]; then
    echo "$DESTDIR$ZIMFILE already exists - nothing to do"
    if [[ -f $SRCDIR$ZIMFILE ]]; then
        echo "Removing $SRCDIR$ZIMFILE"
        rm $SRCDIR$ZIMFILE
    fi
else
    if [[ -f $SRCDIR$ZIMFILE ]]; then
        echo "Moving $SRCDIR$ZIMFILE "
        mv $SRCDIR$ZIMFILE $DESTDIR$ZIMFILE; rc1=$?
    else
        echo "Can not find $SRCDIR$ZIMFILE"
        echo "Unable to move it"
        rc2=1
    fi
fi

if  [[ $rc1 > 0 || $rc2 > 0 ]]; then
    EXITCODE=1
fi

# ZIM IDX Directory

if [[ -d $DESTDIR$ZIMIDX ]]; then
    echo "$DESTDIR$ZIMIDX already exists - nothing to do"
    if [[ -d $SRCDIR$ZIMIDX ]]; then
        echo "Removing $SRCDIR$ZIMIDX"
        rm -Rf $SRCDIR$ZIMIDX
    fi
else
    if [[ -d $SRCDIR$ZIMIDX ]]; then
        echo "Moving $SRCDIR$ZIMIDX "
        mv $SRCDIR$ZIMIDX $DESTDIR$ZIMIDX; rc1=$?
    else
        echo "Can not find $SRCDIR$ZIMIDX"
        echo "Unable to move it"
        rc2=1
    fi
fi

if  [[ $rc1 > 0 || $rc2 > 0 ]]; then
    EXITCODE=1
fi

if  [[ $EXITCODE > 0 ]]; then
    exit 1
fi

echo "Removing $WORKINGDIR"
rm -Rf $WORKINGDIR

echo "Re-indexing Kiwix Library"
/usr/bin/xsce-make-kiwix-lib

exit 0
