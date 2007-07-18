#!/usr/bin/python

"get-configtree.py finds modified configuration files (as defined by the RPM database) and copies them into a fake root. Useage: get-configtree.py [fkroot =./fkroot]"

import rpm, md5;
import os, os.path, errno;
import shutil;
import sys;

def is_modified (filename, filemd5):

   "Returns False if filename matches filemd5, True otherwise."

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

def verify ():

   "Returns a dictionary where the keys are user-modified packages, and the values are lists of user-modified configuration files belonging to those packages (as defined by the RPM database.)"

   modified_pkgs = {}

   ts = rpm.TransactionSet()
   mi = ts.dbMatch()
   for hdr in mi:
      filenames = hdr['filenames']
      fileflags = hdr['fileflags']
      filemd5s = hdr['filemd5s']
      nvr = "%s-%s-%s" % (hdr['name'], hdr['version'], hdr['release'])

      total = len(filenames)
      for i in xrange(total):
         if (fileflags[i] & rpm.RPMFILE_CONFIG):
            if is_modified(filenames[i], filemd5s[i]):
               if not nvr in modified_pkgs: modified_pkgs[nvr] = []
               modified_pkgs[nvr].append(filenames[i])

   return modified_pkgs

def safe_makedirs (path):

   "os.makedirs(path), but raises no error if path exists."

   try:
      os.makedirs(path)
   except OSError, e:
      if e.errno != errno.EEXIST:
         raise OSError, e

def get_configtree(modified_pkgs, fkroot):

   "Copies the modified configuration files defined by the output of verify() into fkroot."

   pkgs = sorted(modified_pkgs.keys())
   for p in pkgs:
      filenames = sorted(modified_pkgs[p])
      for f in filenames:
         print f
         safe_makedirs(fkroot+os.path.dirname(f))
         try:
            shutil.copy(f, fkroot+f)
         except IOError, e:
            if e.errno != errno.ENOENT and e.errno != errno.EISDIR:
               raise IOError, e

def main ():
   fkroot = "./fsroot.olpc.img"
   if len(sys.argv) > 1: fkroot = sys.argv[1]
   get_configtree(verify(), fkroot)

if __name__ == '__main__': main ()

