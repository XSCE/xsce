#!/bin/bash -x
# definitions of global variables:
# $FOUNDDEVS=list of devices returned by `blkid`
EXTMEDIA=`ls /run/media/olpc`
MMC=`ls /dev | grep mmcblk0 | wc | awk '{print $1}'`
USB=`ls /dev | grep sd | wc | awk '{print $1}'`
MEDIADEV2=      # need an empty device for unfound item to initialize
MINSTORAGE=4000000 # 4GBG
set -u 
function warn()
{
    set +x
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
    set +x
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
    set +x
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

function not_empty()
{
    set +x
    echo "######################################################"
    echo ""
    echo ""
    echo "WARNING external SD-card or hard-disk with 'original' (vfat) format
    echo "has data on it. Please remove all data so that formatting
    echo "may continue without unintended loss of data."
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

function get_devices()
{
    FOUNDDEVS=
    BLKID=`blkid | awk '{split($0,a,":"); print a[1]}'`
    for blk in $BLKID; do
        FOUNDDEVS="$FOUNDDEVS $blk"
    done
}

function get_label_for_dev(){
    LABEL=`blkid|grep "$1:"|gawk 'BEGIN{FS="\""}{print $2}'`
}

function get_type_for_dev(){
        TYPE=`blkid -p $1| sed -e 's/.* TYPE=\"\([a-z0-9]*\)\".*/\1/'
}
function is_mounted(){
    MOUNT=`mount | grep $1`
}

function un_mount() {
    is_mounted $1
    if [ $? -eq 0 ]; then
        umount $1
    fi
}

function get_free_for_dev(){
    NAME=
    is_mounted $1
    if [ $? -ne 0 ]; then
        NAME=`basename "$1"`
        mkdir -p "/mnt/$NAME"
        mount "$1" "/mnt/$NAME"
    fi
    FREE=`df -k $1 | grep $1 | gawk ' {print $4}'`
    if [ ! -z "$NAME" ]; then
        un_mount "/mnt/$NAME"
    fi
}

function get_used_for_dev(){
    NAME=
    is_mounted $1
    if [ $? -ne 0 ]; then
        NAME=`basename "$1"`
        mkdir -p "/mnt/$NAME"
        mount "$1" "/mnt/$NAME"
    fi
    USED=`df -k $1|grep "$1"|gawk ' {print $3}'`
    if [ ! -z "$NAME" ]; then
        un_mount "/mnt/$NAME"
    fi
}

function get_ls_for_dev(){
    NAME=
    is_mounted $1
    if [ $? -ne 0 ]; then
        NAME=`basename "$1"`
        mkdir -p "/mnt/$NAME"
        mount "$1" "/mnt/$NAME"
    fi
    LSCOUNT=`ls $1 | wc -l `
    if [ ! -z "$NAME" ]; then
        un_mount "/mnt/$NAME"
    fi
}

function togglepart()
{
    # at least for debugging, query whether sda should be partitioned
    part=`echo "$MEDIADEV2" | grep /dev/sda | sed -e 's:\(/dev/sda\).*:\1:'`
    if [ ! -z $part ]; then
        ans=read -p "do you want to partition $MEDIADEV2? (y/N)"
        if [ "$ans" != "y" ];then
            exit 1
        fi
    fi
        cat <<EOF | fdisk "$MEDIADEV2"
t
83
w
EOF
        partprobe "$MEDIABASE"
        mkfs.ext4 -L library "$MEDIADEV2"
}

function partition_usb_hd()
{
    echo "placeholder"
}

function mk_lib_mountpointd(){
    MEDIAMNT=/library
    if ! [ -d $MEDIAMNT ]; then
        echo "making mountpoint /library"
        mkdir -p $MEDIAMNT
    fi
}

function is_sd_or_hd(){
#  inputs $FOUNDDEVS  returns DEVS Outputs: MEDIADEV2, MEDIABASE
#+ 
# returns 1 if device is found, NOT 0/1 success/failure
    echo "found block devices $FOUNDDEVS"
    MEDIADEV2=
    MEDIABASE=
    EXTDEV=
    VFATDEV=
    EXFATDEV=
    EXTFREE=0
    FATFREE=0 
    for i in $FOUNDDEVS; do # cycle through all blkid's
        get_type_for_dev $i
        if [ "$TYPE" = "vfat" ]; then                        
            # ignore the vfat formatted partitions that are not empty
            get_ls_for_dev $i
            if [ $LSCOUNT -gt 1 ]; then 
                continue
            fi
            # if we happen to have 2 VFAT devices one USB and another hard disk, pick larger
            get_free_for_dev $i
            if [ $FREE -gt $MINSTORAGE ] && [ $FREE -gt $FATFREE ];then
                get_used_for_dev "$i"
                VFATDEV="$i"
                FATFREE=$FREE
            fi
        elif [ "$TYPE" = "exfat" ]; then  # exfat used for 64GB SD cards
            # the XO does not have drivers to read MS proprietary format
            # let's just assume that it is empty and needs formating to ext4
            EXFATDEV="$i"   
        elif [ "$TYPE" = "ext3" ] || [ "$TYPE" = "ext4" ]; then
            get_label_for_dev $i
            if [ "$LABEL = "Boot" ] || [ "$LABEL = "OLPCRoot" ]; then
                # ignore motherboard storage
                continue
            fi
            get_free_for_dev $i
            if [ $FREE -gt $MINSTORAGE ];then
                # use linux partition if enough space exists
                EXTDEV="$i"
                EXTFREE=$FREE
            fi
        fi
    done
    DEVS=0
    # priority: fat, exfat, then ext3 or ext4
    if [ ! -z $VFATDEV ]; then
        MEDIADEV2=$VFATDEV
    elif [ ! -z $EXFATDEV ]; then
        MEDIADEV2=$EXFATDEV
    elif [ ! -z $EXTDEV ]; then
        MEDIADEV2=$EXTDEV
    fi 
    BASE=`echo "$MEDIADEV2" | sed -e 's:\(/dev/mmcblk[0-9]\).*:\1:'`
    if [ -z "$BASE" ]; then
        BASE=`echo "$MEDIADEV2" | sed -e 's:\(/dev/sd[a-f]]\).*:\1:'`
    fi
    if [ ! -z "$BASE" ];then
        MEDIABASE=$BASE
    fi
    if [ ! -z "$MEDIADEV2" ]; then
        DEVS=1
    fi
    return $DEVS # return the number of SD cards or hard disks found
}

function un_fstab(){
    echo "cleaning fstab"
    sed -i '/swap.img/d' /etc/fstab
    sed -i '/library/d' /etc/fstab
}

function format_storage(){
#  format only empty vfat partitions
    get_type_for_dev "$MEDIADEV2"
    if [ "$TYPE" = "vfat" ]; then
        get_used_for_dev "$MEDIADEV2"
        if [ $USED -gt 50 ]; then  # error messange and don't return
            not_empty
        fi
        MNT=`mount | grep $MEDIADEV2 | awk '{print $3}'`
        echo "unmounting $MNT"
        if [ x$MNT != x ]; then
            umount $MNT
        fi
        echo "calling togglepart"
        togglepart "$MEDIADEV2"
    elif [ "$TYPE" = "extfat" ]; then
        # we don't know how to mount it, so cannot see if it is empty
        togglepart "$MEDIADEV2" 
    fi
}

function mount_storage(){
    MNT=`mount | grep $MEDIADEV2 | awk '{print $3}'`
    echo "unmounting $MNT"
    if [ x$MNT != x ]; then
        umount $MNT
    fi
    if [ ! `cat /etc/fstab | grep "$MEDIAMNT"` ]; then
        echo "populating fstab for $MEDIADEV2"
        echo "$MEDIADEV2 $MEDIAMNT	ext4	defaults,noatime 	0 0" >> /etc/fstab
    fi
    echo "mounting $MEDIADEV2 at $MEDIAMNT"
    mount -a
}

function swap_to_storage(){
    if ! [ -f $MEDIAMNT/swap.img ]; then
        echo "creating swap.img"
        dd if=/dev/zero of=$MEDIAMNT/swap.img bs=1024 count=524288
        mkswap $MEDIAMNT/swap.img
        chown root:root $MEDIAMNT/swap.img
    fi
    swapon $MEDIAMNT/swap.img
    if [ ! `cat /etc/fstab | grep swap.img` ]; then
        echo "$MEDIAMNT/swap.img swap 	swap	defaults 0 0" >> /etc/fstab
    fi
}

function use_storage(){
    mk_lib_mountpointd
    un_fstab
    format_storage
    mount_storage
    swap_to_storage
}

# if this script is not called with a parameter, execute its original function
if [ $# -eq 0 ]; then
    get_devices
    is_sd_or_hd
    # the return value is the number of devices found
    if [ $? -eq 1 ]; then
        use_storage
    else
        warn
    fi
fi
