# Examples

# wolfSSL JNI Examples

The `examples` directory contains examples for the wolfSSL thin JNI wrapper.
To view examples for the wolfSSL JSSE provider, look in the
`./examples/provider` directory.

Examples should be run from the package root directory, and using the provided
wrapper scripts. The wrapper scripts set up the correct environment variables
for use with the wolfjni jar included in the wolfssljni package.

To build examples run:
```
$ ./java.sh
$ ant
$ ant examples
```

## Notes on Debug and Logging

wolfJSSE debug logging can be enabled by using `-Dwolfjsse.debug=true` at
runtime.

wolfSSL native debug logging can be enabled by using `-Dwolfssl.debug=true` at
runtime, if native wolfSSL has been compiled with `--enable-debug`.

JDK debug logging can be enabled using the `-Djavax.net.debug=all` option.

## wolfSSL JNI Example Client and Server

Example client/server applications that use wolfSSL JNI:

**Server.java** - Example wolfSSL JNI server \
**Client.java** - Example wolfSSL JNI client

These examples can be run with the provided bash scripts:

```
$ cd <wolfssljni_root>
$ ./examples/server.sh <options>
$ ./examples/client.sh <options>
```

To view usage and available options for the examples, use the `-?`
argument:

```
$ ./examples/server.sh --help
```

## SimpleThreadedClient.java and SimpleThreadedServer.java

Multi-threaded JNI client and server examples. These demonstrate using the
wolfSSL JNI wrapper in a multi-threaded environment.

```
$ ./examples/SimpleThreadedServer.sh
$ ./examples/SimpleThreadedClient.sh -n <num_connections>
```

`SimpleThreadedServer` listens on `localhost:11111` and handles each client
connection in a separate thread. `SimpleThreadedClient` makes concurrent
connections to the server, 5 by default. It also implements a simple
application-wide client session cache, storing native `WOLFSSL_SESSION`
pointers and using them for session resumption where possible.

## X509v3CertificateGeneration.java

Example application demonstrating X.509v3 certificate generation using the
wolfSSL JNI `WolfSSLCertificate` API. Shows how to programmatically create
and sign X.509v3 certificates.

```
$ ./examples/X509v3CertificateGeneration.sh
```

Generated certificates are written to `examples/certs/generated/`.

## X509CertRequest.java

Example application demonstrating X.509 Certificate Signing Request (CSR)
generation using the wolfSSL JNI `WolfSSLCertRequest` API.

```
$ ./examples/X509CertRequest.sh
```

Generated CSRs are written to `examples/certs/generated/`.

# wolfJSSE Provider Examples

The `examples/provider` directory contains examples for the wolfSSL JSSE
provider (wolfJSSE).

Examples should be run from the package root directory, and using the provided
wrapper scripts. The wrapper scripts set up the correct environment variables
for use with the wolfJSSE provider included in the wolfssljni package. For
example to run the example JSSE server and client, after compiling wolfSSL and
wolfssljni:

```
$ cd <wolfssljni_root>
$ ./examples/provider/ServerJSSE.sh
$ ./examples/provider/ClientJSSE.sh
```

## wolfJSSE Example Client and Server

Example client/server applications that use wolfJSSE along with the SSLSocket
API.

**ServerJSSE.java** - Example wolfJSSE server \
**ClientJSSE.java** - Example wolfJSSE client

These examples can be run with the provided bash scripts:

```
$ ./examples/provider/ServerJSSE.sh <options>
$ ./examples/provider/ClientJSSE.sh <options>
```

### Post-Quantum (ML-KEM, ML-DSA) with ServerJSSE and ClientJSSE

`ServerJSSE` and `ClientJSSE` can be used to test post-quantum TLS 1.3
connections when native wolfSSL has been compiled with `--enable-mlkem` and
`--enable-mldsa`. All of the following require TLS 1.3 (`-v 4`).

The `-pqc <group>` option selects a post-quantum or hybrid named group for key
exchange. For example, to use the X25519MLKEM768 hybrid group with the default
classical certificates:

```
$ ./examples/provider/ServerJSSE.sh -v 4 -pqc X25519MLKEM768
$ ./examples/provider/ClientJSSE.sh -h 127.0.0.1 -v 4 -pqc X25519MLKEM768
```

Use `./examples/provider/ServerJSSE.sh -?` for the full list of supported
`-pqc` groups at runtime.

ML-DSA certificates are loaded with the `-c` (entity cert/key) and `-A`
(trusted CA) options. The following uses mutual ML-DSA-87 authentication with
the SECP384R1MLKEM1024 hybrid group and AES-256-GCM, which matches the CNSA 2.0
(NSA Commercial National Security Algorithm Suite 2.0) requirements:

```
$ ./examples/provider/ServerJSSE.sh -v 4 \
      -pqc SECP384R1MLKEM1024 -l TLS_AES_256_GCM_SHA384 \
      -c "../provider/server-mldsa87.jks:wolfSSL test" \
      -A "../provider/ca-mldsa87.jks:wolfSSL test"
$ ./examples/provider/ClientJSSE.sh -h 127.0.0.1 -v 4 \
      -pqc SECP384R1MLKEM1024 -l TLS_AES_256_GCM_SHA384 \
      -c "../provider/client-mldsa87.jks:wolfSSL test" \
      -A "../provider/ca-mldsa87.jks:wolfSSL test"
```

For server-only ML-DSA authentication, omit `-A` on the server and `-c` on the
client, so the client uses the default classical `client.jks`.

Example ML-DSA keystores are located in `examples/provider/`:
`server-mldsa{44,65,87}.jks`, `client-mldsa{44,65,87}.jks`, and
`ca-mldsa{44,65,87}.jks` (password "wolfSSL test"). The keystore paths above
are relative to the wrapper scripts' working directory (`examples/build/`).
Loading ML-DSA private keys from a JKS requires JDK 24 or newer. Keystores can
be regenerated with `./examples/provider/update-keystore-pqc.sh` (also JDK 24+).

## ClientSSLSocket.java

Very minimal JSSE client example using SSLSocket. Does not support all the
options that ClientJSSE.java does.

Example usage is:

```
$ ./examples/provider/ClientSSLSocket.sh [host] [port] [keystore] [truststore]
```

Example usage for connecting to the wolfSSL example server is:

```
$ ./examples/provider/ClientSSLSocket.sh 127.0.0.1 11111 \
  ./examples/provider/client.jks ./examples/provider/ca-server.jks
```

The password for client.jks is: "wolfSSL test"

## MultiThreadedSSLClient.java

Multi threaded SSLSocket example that connects a specified number of client
threads to a server. Intended to test multi-threading with wolfJSSE.

This example creates a specified number of client threads to a server located
at 127.0.0.1:11118. This example is set up to use the SSLSocket class. It makes
one connection (handshake), sends/receives data, and shuts down.

A random amount of time is injected into each client thread before:

  1) The SSL/TLS handshake
  2) Doing I/O operations after the handshake

The maximum amount of sleep time for each of those is "maxSleep", or 3 seconds
by default. This is intended to add some randomness into the client thread
operations.

Example usage:

```
$ ant examples
$ ./examples/provider/MultiThreadedSSLClient.sh -n <num_client_threads>
```

This example is designed to connect against the MultiThreadedSSLServer example:

```
$ ./examples/provider/MultiThreadedSSLServer.sh
```

This example also prints out average SSL/TLS handshake time, which is measured
in milliseconds on the "startHandshake()" API call.

## MultiThreadedSSLServer.java

SSLServerSocket example that creates a new thread per client connection.

This server waits in an infinite loop for client connections, and when connected
creates a new thread for each connection. This example is compiled when
`ant examples` is run in the package root.

```
$ ant examples
$ ./examples/provider/MultiThreadedSSLServer.sh
```

For multi threaded client testing, test against MultiThreadedSSLClient.sh.
For example, to connect 10 client threads:

```
$ ./examples/provider/MultiThreadedSSLClient.sh -n 10
```

## ProviderTest.java

This example tests the wolfSSL provider installation.  It lists all providers
installed on the system, tries to look up the wolfSSL provider, and if
found, prints out the information about the wolfSSL provider. Finally, it tests
what provider is registered to provide TLS to Java.

This app can be useful for testing if wolfJSSE has been installed
correctly at the system level.

```
$ ./examples/provider/ProviderTest.sh
```

Note, if wolfJSSE has not been installed at the OS system level, wolfJSSE
will not show up as an installed provider when this example is run.

## ThreadedSSLSocketClientServer.java

SSLSocket example that connects a client thread to a server thread.

This example creates two threads, one server and one client. The examples
are set up to use the SSLSocket and SSLServerSocket classes. They make
one connection (handshake) and shut down.

Example usage:

```
$ ./examples/provider/ThreadedSSLSocketClientServer.sh
```

## DtlsClientEngine.java and DtlsServerEngine.java

Example client/server applications that demonstrate how to use SSLEngine with DTLS 1.3.

**DtlsServerEngine.java** - Example DTLS 1.3 server using SSLEngine
**DtlsClientEngine.java** - Example DTLS 1.3 client using SSLEngine

These examples show how to implement DTLS 1.3 with SSLEngine for datagram-based
secure communication. Unlike the TCP-based examples, these use DatagramSocket for
UDP transport and handle the complexities of DTLS, including session tickets
and handshake state management.

Run the examples with the provided bash scripts:

```
$ ./examples/provider/DtlsServerEngine.sh
$ ./examples/provider/DtlsClientEngine.sh
```

The client connects to the server, sends a message, and receives the echoed response.
Both examples support various command-line options that can be viewed with the -? flag.

## PSK Examples (SSLSocket and SSLEngine)

Example client/server applications that demonstrate PSK (Pre-Shared Key)
authentication using `WolfSSLParameters` with both `SSLSocket` and
`SSLEngine`. PSK callbacks and cipher suites are configured through
`WolfSSLParameters` and applied with `setSSLParameters()`.

**PskServerSocket.java** - PSK server using SSLSocket \
**PskClientSocket.java** - PSK client using SSLSocket \
**PskServerEngine.java** - PSK server using SSLEngine \
**PskClientEngine.java** - PSK client using SSLEngine

SSLSocket examples:

```
$ ./examples/provider/PskServerSocket.sh
$ ./examples/provider/PskClientSocket.sh
```

SSLEngine examples:

```
$ ./examples/provider/PskServerEngine.sh
$ ./examples/provider/PskClientEngine.sh
```

Clients accept optional `[host] [port]` arguments and servers accept an
optional `[port]` argument. The default host is `localhost` and the default
port is `11111`.

## DualProviderFIPSTest.java

This example tests using both wolfJCE (`WolfCryptProvider`) and wolfJSSE
(`WolfSSLProvider`) together with wolfCrypt FIPS or FIPS Ready. It follows the
recommended workflow described in Chapter 7: running FIPS CASTs once through
wolfJCE, setting the `wolfjsse.skipFIPSCAST` Security property, then
registering both providers.

This example is **not** compiled by `ant examples` because it depends on the
wolfcrypt-jni (wolfJCE) JAR, which is not part of the wolfssljni package. It
can be compiled and run manually:

```
$ cd <wolfssljni_root>
$ javac -classpath \
    lib/wolfssl.jar:lib/wolfssl-jsse.jar:<wolfcryptjni_root>/lib/wolfcrypt-jni.jar \
    examples/provider/DualProviderFIPSTest.java
$ ./examples/provider/DualProviderFIPSTest.sh
```

The `WOLFCRYPTJNI_DIR` environment variable can be set to point to the
wolfcrypt-jni build directory (defaults to `../../wolfcryptjni`).

## Java Remote Method Invocation (RMI) Example

Example client, server, and remote interface applications for Java Remote
Method Invocation implementation in wolfJSSE.

**RmiServer.java** - Example server, implements `RmiRemoteInterface` with methods `getMessage()`, `sendMessage()`, `getByteArray()`, `sendByteArray()`, and `getRegistryPorts()`. Creates one or more RMI registries over TLS/SSL using wolfJSSE.

**RmiClient.java** - Example client, gets an object stub from the remote registry, and makes remote method invocations including `getMessage()`, `sendMessage()`, `getByteArray()`, `sendByteArray()`, and `getRegistryPorts()`. Supports multiple concurrent client connections.

**RmiRemoteInterface.java** - Remote interface definition that both the server and client use.

**RmiTLSClientSocketFactory.java** / **RmiTLSServerSocketFactory.java** - Custom TLS socket factory implementations for RMI, using wolfJSSE for the underlying SSL/TLS connections. The server socket factory requires client certificate authentication, and the client socket factory enables HTTPS endpoint identification to verify the server certificate against the host it connects to.

Start the server and client:
```
$ ./examples/provider/rmi/RmiServer.sh
$ ./examples/provider/rmi/RmiClient.sh
```