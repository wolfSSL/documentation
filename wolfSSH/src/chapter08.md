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

The portfwd example can also set up remote (reverse) forwarding with the option `-r`. It asks the SSH server to listen on the `-F`/`-f` address and port, and the server tunnels each connection made there back to portfwd, which connects it to the local `-T`/`-t` target. With `-r`, a `-f` port of 0 lets the server pick the port.

```
src/wolfssl$ ./examples/server/server
src/wolfssh$ ./examples/portfwd/portfwd -p 22 -u <username> -r \
             -f 12345 -t 11111
src/wolfssl$ ./examples/client/client -p 12345
```

##  Port Forwarding API

The application controls forwarding with a forwarding callback set with `wolfSSH_CTX_SetFwdCb()`, and its context set with `wolfSSH_SetFwdCbCtx()`. The callback is consulted for every forwarding channel: an incoming "direct-tcpip" or "forwarded-tcpip" channel open is refused unless a forwarding callback is set and its `WOLFSSH_FWD_LOCAL_SETUP` call succeeds. Each successful `WOLFSSH_FWD_LOCAL_SETUP` is later matched by one `WOLFSSH_FWD_LOCAL_CLEANUP`, so the callback must not free that state twice. On a server, a "tcpip-forward" request from the client calls the forwarding callback with `WOLFSSH_FWD_REMOTE_SETUP`; for a request for port 0, the callback returns the port it allocated rather than `WS_FWD_SUCCESS`.

A client sets up remote forwarding with `wolfSSH_FwdRemoteSetup()`, which asks the server to listen on an address and port and to send connections made there back as "forwarded-tcpip" channels, and stops it with `wolfSSH_FwdRemoteCancel()`. A client refuses a "forwarded-tcpip" channel open that does not match a forward it registered with `wolfSSH_FwdRemoteSetup()`, so a client that registered none refuses them all. A registered bind address of "", "*", "0.0.0.0", or an IPv6 any-address matches on the port alone; any other address must equal the address the server reports. For a server that reports a different spelling of the address, `wolfSSH_SetFwdRemoteMatch()` can relax the match to the port alone (`WOLFSSH_FWD_MATCH_PORT`) or turn it off (`WOLFSSH_FWD_MATCH_OFF`). A client refuses "tcpip-forward" and "cancel-tcpip-forward" requests sent to it.

The functions `wolfSSH_CTX_SetFwdEnable()` and `wolfSSH_SetFwdEnable()`, which were declared but never defined, have been removed. Forwarding is enabled by building with `WOLFSSH_FWD` and setting a forwarding callback.
