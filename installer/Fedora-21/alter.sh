#!/usr/bin/bash
livecd-iso-to-disk --format --reset-mbr --msdos --ks install.ks --label F21-XSCE $@
