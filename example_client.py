import socket

s = socket.socket()
host = socket.gethostname()
port = 5204
s.connect((host, port))
s.send("400,200\n")
for i in xrange(1, 200):
    msg = "%d,%d,3\n" % (i*2, i)
    s.send(msg)
s.close
