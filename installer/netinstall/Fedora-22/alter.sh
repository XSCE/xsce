#!/usr/bin/bash
livecd-iso-to-disk --format --reset-mbr --ks install.ks --label F22-XSCE $@
