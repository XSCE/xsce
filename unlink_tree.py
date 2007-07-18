#!/usr/bin/python

"Undoes the damage done by symlink_tree.py, as best it can. For each file in src, looks for the corresponding symlink in dst and, if it finds it, removes the symlink and copies the file at src to dst. This makes src safe to uninstall."

import warnings;
import os, os.path, stat, sys;
import errno;
from shutil import move;

def unlink_lvl (src, dst):
   "For each file in src, attempt to unlink dst."

   # assert
   if not (os.path.isdir(src) and os.path.isdir(dst)):
      print "%s:%s - not a directory" % (src, dst)
      raise RuntimeError

   # unlink
   dirs = []
   for f in os.listdir(src):
      srcname = os.path.join(src, f)
      dstname = os.path.join(dst, f)

      # directory
      if os.path.isdir(srcname) and os.path.isdir(dstname):
         dirs.append([srcname, dstname])
      else:
         # *.olpcnew symlink exists
         savefile = dstname+".olpcnew"
         if os.path.exists(savefile) and os.path.samefile(srcname, savefile):
            os.remove(savefile)

         # unlink file
         if os.path.exists(dstname) and os.path.samefile(srcname, dstname):
            os.remove(dstname)
            move(srcname, dstname)

   # recurse
   for d in dirs:
      unlink_lvl(d[0], d[1])

def main ():
   if len(sys.argv) < 3:
      return
   unlink_lvl(sys.argv[1], sys.argv[2])

if __name__ == '__main__': main()

