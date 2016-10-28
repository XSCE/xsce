import zmq
import os.path
import time

alert_param = ',"Alert": "True"}'

def application(environ, start_response):
    start_ms = time.time()

    if environ['REQUEST_METHOD'] == 'POST':
        try:
            request_body_size = int(environ.get('CONTENT_LENGTH', 0))
        except (ValueError):
            request_body_size = 0

        request_body = environ['wsgi.input'].read(request_body_size)
        # request_body holds command=<text of cmd>

        if os.path.exists("/var/run/xsce-cmdsrv.pid"):
            if os.path.exists("/var/run/xsce-cmdsrv-ready"):
                cmd = request_body.split('=')[1]
                response_body = send_command(cmd, start_ms)
            else:
                response_body = '{"Error": "XSCE-CMDSRV has started but is not ready."' + alert_param
        else:
            response_body = '{"Error": "XSCE-CMDSRV has started but is not ready."' + alert_param

        response_headers = [('Content-type', 'application/json'), ('Content-Length', str(len(response_body)))]

    else: # not a POST
        response_body = dump(environ)
        response_headers = [('Content-type', 'text/plain'),
                       ('Content-Length', str(len(response_body)))]
    status = '200 OK'
    start_response(status, response_headers)
    return [response_body]

def dump(environ):
    response_body = ['%s: %s' % (key, value) for key, value in sorted(environ.items())]
    response_body = '\n'.join(response_body)
    return response_body

def send_command(cmd, start_ms):

    REQUEST_TIMEOUT = 30000
    send_msg = cmd

    ipc_sock = "/run/cmdsrv_sock"

    try:
        context = zmq.Context()
        print "Connecting to server..."
        socket = context.socket(zmq.DEALER)
        socket.connect ("ipc://%s" % ipc_sock)
        # socket.setsockopt(zmq.SOCKOPT_LINGER, 0) this should be the default for close() and is not in python binding
        poll = zmq.Poller()
        poll.register(socket, zmq.POLLIN)

        socket.send (send_msg)
        socks = dict(poll.poll(REQUEST_TIMEOUT))

        if socket in socks and socks[socket] == zmq.POLLIN:
            reply_msg = socket.recv()
            if '"Error":' not in reply_msg:
                cur_ms = time.time()
                elapsed_ms = cur_ms - start_ms
                reply_msg = '{"Data": ' + reply_msg + ',"Resp_time": "' + str(elapsed_ms) + '"}'
        else:
            reply_msg = '{"Error": "No Response from XSCE-CMDSRV in ' + REQUEST_TIMEOUT + ' milliseconds"' + alert_param

        socket.setsockopt(zmq.LINGER, 0)
        socket.close()
        poll.unregister(socket)

    except Exception as e:
        reply_msg = '{"Error": "' + e.message + '"' + alert_param

    return reply_msg

