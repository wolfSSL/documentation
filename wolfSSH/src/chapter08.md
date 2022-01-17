#  Port Forwarding

##  Building wolfSSH with Port Forwarding

It is assumed that wolfSSL has already been built to be used with wolfSSH. To see building instructions for wolfSSL view Chapter 2.

To build wolfSSH with support for port forwarding use --enable-fwd, in the case of building with autotools, or define the macro `WOLFSSH_FWD` if building without autotools. An example of this would be
```
./configure --enable-fwd && make
```
##  Using wolfSSH Port Forwarding Example App

The portfwd example tool will create a "direct-tcpip" style channel. These directions assume you have OpenSSH's server running in the background with port forwarding enabled. This example forwards the port for the wolfSSL client to the server as the application. It assumes that all programs are run on the same machine in different terminals.

```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/portfwd/portfwd -p 22 -u <username> \
             -f 12345 -t 11111
src/wolfssl$ ./examples/client/client -p 12345
```

By default, the wolfSSL server listens on port 11111. The client is set to try to connect to port 12345. The portfwd logs in as user "username", opens a listener on port 12345 and connects to the server on port 11111. Packets are routed back and forth between the client and server. "Hello, wolfSSL!"

The source for portfwd provides an example on how to set up and use the port forwarding support in wolfSSH.

The echoserver will handle local and remote port forwarding. To connect with the ssh tool, using one of the following command lines. You can run either of the ssh command lines from anywhere:

```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/echoserver/echoserver
anywhere 1$ ssh -p 22222 -L 12345:localhost:11111 jill@localhost
anywhere 2$ ssh -p 22222 -R 12345:localhost:11111 jill@localhost
src/wolfssl$ ./examples/client/client -p 12345
```

This will allow port forwarding between the wolfSSL client and server like in the previous example.
