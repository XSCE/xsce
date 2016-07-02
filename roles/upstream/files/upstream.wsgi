#!/usr/bin/python

import sys
import os
import glob
from wsgiref.simple_server import make_server

def application(environ, start_response):
    upenv = "/library/upstream"
    block_size = 1024
    downloads_available = sorted(glob.glob(os.path.join(upenv,"history/*")))
    last = downloads_available[-1]
    fd = open(last,"r")
    status = '200 OK'
    headers = [('Content-type', 'application/zip'),
                 ('Content-Disposition','attachment; filename='+os.path.basename(last))]
    start_response(status, headers)
    if 'wsgi.file_wrapper' in environ:
        return environ['wsgi.file_wrapper'](fd, block_size)
    else:
        return iter(lambda: fd.read(block_size), '')


if __name__ == '__main__':
    httpd = make_server('', 8051, application)
    print "Serving on port 8051..."
    httpd.serve_forever()
