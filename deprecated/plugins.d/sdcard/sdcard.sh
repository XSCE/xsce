function sdcard()
{
	case "$1" in
    "yes")
        mountpoint = `df | gawk '/^\/dev\/mmcblk0p1 {print $7;}'`
        echo "Contents of $mountpoint"
        ls -l $mountpoint
        echo -n "you are about to delete all this data. Is this ok? (y/N)"
        read response
        case $response in
        #fall through
        [yY] ) ;;
        * ) exit 1
            ;;
        esac
        umount /dev/mmcblk0p1
        #delete all partitions on the drive
        echo "d\n1\nd\n2\nd\n3\nd\n4\nw" | fdisk /dev/mmcblk0
        fdisk -l /dev/mmcblk0 | gawk '
        /^\/dev\/mmcblk0/ {start = $2; end = $3; blocks =  $4;}
        /^Units/ {unit = $9;}
        /^Disk \/dev/ { total_bytes = $5;}
        # assume that the start is the errase block size
        END {
        if (start != 0) {
            #assume that start is equal to erase block size
            erase_block_size = start;
            SWAP_MB = 512;
            swap_size = SWAP_MB * 1024 * 1024;
            swap_num_erase_blocks = int(swap_size / (erase_block_size * 512));
            erase_blocks = int(end / start);
            swap_begin = int(erase_blocks - swap_num_erase_blocks) * 8192;
        } else {}
            exit(1)
        }'

        touch SETUPSTATEDIR/sdcard
        ;;
    "no")
        rm $SETUPSTATEDIR/sdcard
        ;;
    esac
}


