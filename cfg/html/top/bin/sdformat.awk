# awk program to create the script to format an SD card correctly
#
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
	#print "erase blocks: " erase_blocks "number of swap erase blocks:" swap_num_erase_blocks;
	swap_begin = int(erase_blocks - swap_num_erase_blocks) * 8192;
	if ((end + 1) * unit != total_bytes) {
		print "Totat bytes not equal blocks * unit";
		print "end:"  end  "  unit:"  unit  "  total bytes:"  total_bytes;
		print " from fdisk:" unit * end;
		exit(1);
	}
	print ""
	print "fdisk with partition 1 starting at " start " ending at " swap_begin -1 ;
	print "  and swap partition starting at " swap_begin " and ending at " end ;
	print ""
	print "Then format with mkfs.ext4 -b 4096 -O ^has_journal -E stride=2 /dev/mmcblk0p1"
	print "  And format the swap partition with 'mkswap /dev/mmcblk0p2'"
}
}	
