#!/usr/bin/python

"For each file in the directory tree at src, creates a symlink in dst to that file at the same directory level. Will clobber defaults, but respects user configuration changes (as defined by the RPM database)."

import warnings;
import os, os.path, sys;
import rpm, md5;
import errno;
from shutil import move;
from fnmatch import fnmatch;

# global symbols
modified_configs = []

# RPM-consulting functions:
# bool is_modified(filename, filemd5)
# void find_modified_configs()

def is_modified (filename, filemd5):
   "Returns False if the contents of filename match filemd5, True otherwise."

   try:
      contents = open(filename, 'r').read()
   except IOError:
      return True

   m = md5.new()
   m.update(contents)
   if filemd5 != m.hexdigest():
      return True
   else:
      return False

def find_modified_configs ():
   "Initializes modified_configs as a set  with the full names of all modified RPM configuration files on the system."

   global modified_configs

   ts = rpm.TransactionSet()
   mi = ts.dbMatch()
   for h in mi:
      names = h['filenames']
      fileflags = h['fileflags']
      md5sums = h['filemd5s']

      total = len(names)
      for i in xrange(total):
         if (fileflags[i] & rpm.RPMFILE_CONFIG):
            if is_modified(names[i], md5sums[i]):
               modified_configs.append(names[i])

   modified_configs = set(modified_configs)

# helper functions:
# void safe_mkdir(dst)
# void safe_remove(dst)
# void force_symlink(src, dst)

def safe_mkdir (dst):
   "os.mkdir(dst), but raises no error if the directory exists."

   try:
      os.mkdir(dst)
   except OSError, e:
      if e.errno != errno.EEXIST or not os.path.isdir(dst):
         raise RuntimeError

def safe_remove (dst):
   "os.remove(dst), but riases no error if the file does not exist."

   try:
      os.remove(dst)
   except OSError, e:
      if e.errno != errno.ENOENT:
         raise RuntimeError

def force_symlink (src, dst):
   "Forces a symlink between src and dst, making backups where possible."""

   savefile = dst+".olpcsave"
   if os.path.exists(dst):
      if os.path.samefile(src, dst):
         return
      else:
         safe_remove(savefile)
         move(dst, savefile)

   os.symlink(src, dst)


# recursive tree symlinking:
# void symlink_lvl(src, dst)
# void main()

def symlink_lvl (src, dst):
   "For each file in src, creates a symlink in dst."""

   global modified_configs

   # assert
   if not (os.path.isdir(src) and os.path.isdir(dst)):
      print "%s:%s - not a directory" % (src, dst)
      raise RuntimeError

   # link
   dirs = []
   for f in os.listdir(src):
      srcname = os.path.join(src, f)
      dstname = os.path.join(dst, f)

      # directory
      if os.path.isdir(srcname):
         safe_mkdir(dstname)
         dirs.append([srcname, dstname])
      # file is user-modified
      elif dstname in modified_configs and not (os.path.exists(dstname) and os.path.samefile(srcname, dstname)):
         print("olpcwarning: "+srcname+" was not symlinked")
         savefile = dstname+".olpcnew"
         safe_remove(savefile)
         os.symlink(srcname, savefile)
      # file is safe to link
      elif not (fnmatch(f, "*.rpmnew") or fnmatch(f, "*.rpmsave")):
         force_symlink(srcname, dstname)

   # recurse
   for d in dirs:
      symlink_lvl(d[0], d[1])

def main ():
   if len(sys.argv) < 3:
      return
   find_modified_configs()
   symlink_lvl(sys.argv[1], sys.argv[2])

if __name__ == '__main__': main()
 
