#!/bin/bash
EXTMEDIA=`ls /run/media/olpc`
MMC=`ls /dev | grep mmcblk0 | wc | awk '{print $1}'`
USB=`ls /dev | grep sd | wc | awk '{print $1}'`

function warn()
{
    echo "######################################################"
    echo ""
    echo ""
    echo "WARNING external SD-card or hard-disk NOT detected"
    echo "Please insert SD-card or connect your external hard"
    echo "disk before running bootsrap-xo"
    echo ""
    echo ""
    echo "#####################################################"
    echo ""
    read -p "Press [Enter] key to shutdown"
    echo ""
    echo ""
    echo "shutting down in 5 seconds"
    sleep 5
    shutdown now
}

function unsupported()
{
    echo "#####################################################"
    echo ""
    echo ""
    echo "WARNING detected external SD-card partition layout"
    echo "is unsuppoted. Please try a different SD-card"
    echo ""
    echo ""
    echo "#####################################################"
    echo ""
    read -p "Press [Enter] key to shutdown"
    echo ""
    echo ""
    echo "shutting down in 5 seconds"
    sleep 5
    shutdown now
}

function library_1st()
{
    echo "#####################################################"
    echo ""
    echo ""
    echo "WARNING detected 2 USB storage units. In order to"
    echo "protect the data on the one that will not become a"
    echo "permanent part of the XS server, please ensure the"
    echo "premanent one is inserted in a slot before the flash"
    echo "containing the XS repo."
    echo ""
    echo ""
    echo "#####################################################"
    echo ""
    echo ""
    read -p "Press [Enter] key to shutdown"
    echo ""
    echo ""
    echo "shutting down in 5 seconds"
    sleep 5
    shutdown now
}

function get_devices()
{
    FOUNDDEVS=
    BLKID=`blkid | awk '{split($0,a,":"); print a[1]}'`
    for blk in $BLKID; do 
        FOUNDDEVS="$FOUNDDEVS $blk" 
    done
}

function find_repo()
{
    MNT=`mount | grep dev/sdb | awk '{print $3}'`
    if ! [ -d $MNT/xs-repo ]; then
        library_1st
    fi
}

function togglepart()
{
    cat <<EOF | fdisk /dev/mmcblk0
t
83
w
EOF
    partprobe /dev/mmcblk0
    mkfs.ext4 -L library $MEDIADEV2
}

function partition_usb_hd()
{
    echo "placeholder"
}

MEDIAMNT=/library
if ! [ -d $MEDIAMNT ]; then
    echo "making mountpoint /library"
    mkdir $MEDIAMNT
fi

get_devices
DEVS=`echo $FOUNDDEVS | wc | awk '{print $1}'`
echo "found block devices $FOUNDDEVS"
echo "found $MMC character devices for mmcblk0"

for i in $FOUNDDEVS; do
    if [ $i = "/dev/mmcblk1p1" ]; then
        if [ $MMC = 1 ]; then
            unsupported
        elif ! [ -b /dev/mmcblk0p1 ]; then
            unsupported
        fi
        MEDIADEV2=/dev/mmcblk0p1
        DEVS=1
        break
    fi
    DEVS=$(($DEVS - 1)) 
done

if [ -c /dev/sdb ]; then
    find_repo
    MEDIADEV2=/dev/sdc
    DEVS=1
fi

if [ $MMC = 5 -a ! -c /dev/sdb ] ; then
    echo "test warn"  
    warn
fi

echo "cleaning fstab"
sed -i '/swap.img/d' /etc/fstab 
sed -i '/library/d' /etc/fstab 

MEDIASTRING=`blkid | grep mmcblk0p1 | grep vfat` 
echo "found vfat in $MEDIASTRING"
if [ x$DEVS = "x1" ]; then
#    echo "matched devs"
    for i in $MEDIASTRING; do
        test=`echo $i | awk '{split($0,a,"="); print a[1]}'`
        test2=`echo $i | awk '{split($0,a,"="); print a[2]}' | sed -e 's/"//' | sed -e 's/"//'`
#        echo "test $test"
#        echo "test2 $test2"
        case $test in 
        "UUID")
            echo "$i is $MEDIADEV2"
        ;;
        "TYPE")
            if [ $test2 = "vfat" ]; then
                MNT=`mount | grep mmcblk0p1 | awk '{print $3}'`
                echo "unmounting $MNT"
                if [ x$MNT != x ]; then
                    umount $MNT
                fi
                echo "calling togglepart"
                togglepart
                break
            fi
        ;;  
        esac
    done
else
#    echo "test2 warn "
    warn
fi

echo "populating fstab for $MEDIADEV2"
echo "$MEDIADEV2 $MEDIAMNT	ext4	defaults,noatime 	0 0" >> /etc/fstab

echo "mounting $MEDIADEV2 at $MEDIAMNT" 
mount -a

if ! [ -f $MEDIAMNT/swap.img ]; then
    echo "creating swap.img"
    dd if=/dev/zero of=$MEDIAMNT/swap.img bs=1024 count=1048576
    mkswap $MEDIAMNT/swap.img
    chown root:root $MEDIAMNT/swap.img
fi
swapon $MEDIAMNT/swap.img       
echo "$MEDIAMNT/swap.img swap 	swap	defaults 0 0" >> /etc/fstab
   
exit 0

# MEDIAFS=`blkid | grep vfat | grep mmcblk0p1`
# EXTMEDIA2=/run/media/olpc/$EXTMEDIA
# | awk '{split($0,a,":"); print a[2]}'`
