#!/usr/bin/gawk
# pick out the network ip,mask,broadcast from the ifconfig listing
(/^.*: flags=/) {printf("%s\t",$1)}
/^ *inet / { print( $2  "\t" $4 "\t" $6);}
END {print}
