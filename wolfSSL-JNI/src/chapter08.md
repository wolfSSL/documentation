# Examples

## wolfSSL JNI Examples
The /examples contains examples for the wolfSSL thin JNI wrapper. Examples should be run from the package root directory, and using the provided wrapper scripts. The wrapper scripts set up the correct environment variables for use with the wolfjni jar included in the wolfssljni package.

Example client/server applications that use wolfSSL JNI:
Server.java - Example wolfSSL JNI server
Client.java - Example wolfSSL JNI client

These examples can be run with the provided bash scripts:
```
$ cd <wolfssljni_root>
$ ./examples/server.sh <options>
$ ./examples/client.sh <options>
```

To view usage and available options for the examples, use the -? argument:
```
$ ./examples/server.sh --help
```
##  wolfJSSE Provider Examples

An example server and example client are bundled with the wolfJSSE provider. Examples should be run from the package root directory, and using the provided wrapper scripts. The wrapper scripts set up the correct environment variables for use with the wolfJSSE provider included in the wolfssljni package. For example to run the example JSSE server and client, after compiling wolfSSL and wolfssljni:
```
$ cd <wolfssljni_root>
$ ./examples/provider/ServerJSSE.sh
$ ./examples/provider/ClientJSSE.sh
```


###  wolfJSSE Example Client and Server
Example client/server applications that use wolfJSSE along with the SSLSocket API.

ServerJSSE.java - Example wolfJSSE server
ClientJSSE.java - Example wolfJSSE client

These examples can be run with the provided bash scripts:
```
$ ./examples/provider/ServerJSSE.sh <options>
$ ./examples/provider/ClientJSSE.sh <options>
```
###  ClientSSLSocket.java
Very minimal JSSE client example using SSLSocket. Does not support all the options that ClientJSSE.java does.

Example usage is:
```
$ ./examples/provider/ClientSSLSocket.sh [host] [port] [keystore] [truststore]
```
Example usage for connecting to the wolfSSL example server is:
```
$ ./examples/provider/ClientSSLSocket.sh 127.0.0.1 11111 \
  ./examples/provider/client.jks ./examples/provider/client.jks
```
The password for client.jks is: "wolfSSL test"

###  MultiThreadedSSLClient.java
Multi threaded SSLSocket example that connects a specified number of client threads to a server. Intended to test multi-threading with wolfJSSE. This example creates a specified number of client threads to a server located at 127.0.0.1:11118. This example is set up to use the SSLSocket class. It makes one connection (handshake), sends/receives data, and shuts down.

A random amount of time is injected into each client thread before:
1. The SSL/TLS handshake
2. Doing I/O operations after the handshake

The maximum amount of sleep time for each of those is "maxSleep", or 3 seconds by default. This is intended to add some randomness into the client thread operations.

Example usage:
```
$ ant examples
$ ./examples/provider/MultiThreadedSSLClient.sh -n <num_client_threads>
```
This example is designed to connect against the MultiThreadedSSLServer example:
```
$ ./examples/provider/MultiThreadedSSLServer.sh
```
This example also prints out average SSL/TLS handshake time, which is measured in milliseconds on the "startHandshake()" API call.

###  MultiThreadedSSLServer.java
SSLServerSocket example that creates a new thread per client connection. This server waits in an infinite loop for client connections, and when connected creates a new thread for each connection. This example is compiled when ant examples is run in the package root.
```
$ ant examples
$ ./examples/provider/MultiThreadedSSLServer.sh
```

For multi threaded client testing, test against MultiThreadedSSLClient.sh. For example, to connect 10 client threads:
```
$ ./examples/provider/MultiThreadedSSLClient.sh -n 10
```
###  ProviderTest.java
This example tests the wolfSSL provider installation. It lists all providers installed on the system, tries to look up the wolfSSL provider, and if found, prints out the information about the wolfSSL provider. Finally, it tests what provider is registered to provide TLS to Java.

This app can be useful for testing if wolfJSSE has been installed correctly at the system level.
```
$ ./examples/provider/ProviderTest.sh
```
Note, if wolfJSSE has not been installed at the OS system level, wolfJSSE will not show up as an installed provider when this example is run.

###  ThreadedSSLSocketClientServer.java
SSLSocket example that connects a client thread to a server thread. This example creates two threads, one server and one client. The examples are set up to use the SSLSocket and SSLServerSocket classes. They make one connection (handshake) and shut down.

Example usage:
```
$ ./examples/provider/ThreadedSSLSocketClientServer.sh
``
**Notes on Debug and Logging**

wolfJSSE debug logging can be enabled by using ` -Dwolfjsse.debug=true` at runtime.

wolfSSL native debug logging can be enabled by using `-Dwolfssl.debug=true` at runtime, if native wolfSSL has been compiled with  `--enable-debug`.

JDK debug logging can be enabled using the ` -Djavax.net.debug=all` option.

## Android Studio Example Project

The  /IDE/Android directory contains an example Android Studio project file for wolfssljni / wolfJSSE. This project should be used for reference only.

Tool and version information used when testing this project:

- Ubuntu 20.04.3 LTS
- Android Studio Arctic Fox 2020.3.1 Patch 3
- Android Gradle Plugin Version: 4.2.2
- Gradle Version: 6.9.1
- API 28: Android 9.0 (Pie)
- Emulator: Nexus 5X API 28

The following sections outline steps required to run this example on an Android device or emulator.

###  Converting JKS to BKS for Android Use

On the Android device BKS format key stores are expected. To convert the JKS example bundles to BKS use the following commands. Note: you will need
to download a version of the bcprov JAR from the Bouncy Castle website:

```
cd examples/provider
./convert-to-bks.sh <path/to/provider>
```

For example, when using bcprov-ext-jdk15on-169.jar:

```
cd examples/provider
./convert-to-bks.sh ~/Downloads/bcprov-ext-jdk15on-169.jar
```

###  Push BKS to Android Device or Emulator

Push BKS bundles up to the device along with certificates. To do this start up the emulator/device and use `adb push`. An example of this would be the
following commands from root wolfssljni directory:

```
adb shell
cd sdcard
mkdir examples
mkdir examples/provider
mkdir examples/certs
exit
adb push ./examples/provider/*.bks /sdcard/examples/provider/
adb push ./examples/certs/ /sdcard/examples/
```

###  Add Native wolfSSL Library Source Code to Project

This example project is already set up to compile and build the native wolfSSL library source files, but the wolfSSL files themselves have not been
included in this package. You must download or link an appropriate version of wolfSSL to this project using one of the options below.

The project looks for the directory
`wolfssljni/IDE/Android/app/src/main/cpp/wolfssl` for wolfSSL source code.
This can added in multiple ways:

- OPTION A: Download the latest wolfSSL library release from www.wolfssl.com,
unzip it, rename it to `wolfssl`, and place it in the direcotry
`wolfssljni/IDE/Android/app/src/main/cpp/`.

```
$ unzip wolfssl-X.X.X.zip
$ mv wolfssl-X.X.X wolfssljni/IDE/Android/app/src/main/cpp/wolfssl
```

- OPTION B: Alternatively GitHub can be used to clone wolfSSL:

```
$ cd /IDE/Android/app/src/main/cpp/
$ git clone https://github.com/wolfssl/wolfssl
$ cp wolfssl/options.h.in wolfssl/options.h
```

- OPTION C: A symbolic link to a wolfssl directory on the system by using:

```
$ cd /IDE/Android/app/src/main/cpp/
$ ln -s /path/to/local/wolfssl ./wolfssl
```

###  Importing and Building the Example Project with Android Studio

4) Open the Android Studio project by double clicking on the `Android` folder in wolfssljni/IDE/

5) Build the project and run MainActivity from app -> java/com/example.wolfssl. This will ask for permissions to access the certificates in the /sdcard/
directory and then print out the server certificate information on success.

6) OPTIONAL: The androidTests can be run after permissions has been given. app->java->com.wolfssl->provider.jsse.test->WolfSSLJSSETestSuite and
app->java->com.wolfssl->test->WolfSSLTestSuite.

For support and feature requests please contact the wolfSSL support team at support@wolfssl.com.

