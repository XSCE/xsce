# Common packages removed from comps
# For F14, these removals should be moved to comps itself

%packages

# save some space
-mpage
-sox
-hplip
-hpijs
-numactl
-isdn4k-utils
-autofs
# smartcards won't really work on the livecd.
-coolkey
-wget

# scanning takes quite a bit of space :/
-xsane
-xsane-gimp
-sane-backends

%end
