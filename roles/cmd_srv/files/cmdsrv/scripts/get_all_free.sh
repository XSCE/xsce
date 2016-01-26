#!/bin/sh

parted -m <<EOF
print all free
quit
EOF
