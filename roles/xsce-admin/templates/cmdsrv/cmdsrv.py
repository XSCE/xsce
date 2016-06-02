#!/usr/bin/python

import zmq
import sys
from wsgiref.simple_server import make_server

def application(environ, start_response):
    inlen = str(environ['CONTENT_LENGTH'])
    cmd = environ['wsgi.input'].read(int(inlen))
    ipc_sock = "/run/cmdsrv_sock"
    context = zmq.Context()
    socket = context.socket(zmq.DEALER)
    socket.connect ("ipc://%s" % ipc_sock)

    socket.send(cmd)

    #  Get the reply.
    ret = socket.recv()
    status = '200 OK'
    headers = [('Content-type', 'text/plain'),
                 ('Content-length', str(len(ret)))]
    start_response(status, headers)
    return [ret]

if __name__ == '__main__':
    httpd = make_server('', 8051, application)
    print "Serving on port 8051..."
    httpd.serve_forever()
