# SSL Tutorial

## Introduction

The wolfSSL embedded SSL/TLS library can easily be integrated into your existing application or device to provide enhanced communication security through the addition of SSL and TLS. wolfSSL has been targeted at embedded and RTOS environments, and as such, offers a minimal footprint while maintaining excellent performance. Minimum build sizes for wolfSSL range between 20-100kB depending on the selected build options and platform being used.

The goal of this tutorial is to walk through the integration of SSL and TLS into a simple application. Hopefully the process of going through this tutorial will also lead to a better understanding of SSL in general. This tutorial uses wolfSSL in conjunction with simple echoserver and echoclient examples to keep things as simple as possible while still demonstrating the general procedure of adding SSL support to an application. The echoserver and echoclient examples have been taken from the popular book titled [Unix Network Programming, Volume 1, 3rd Edition](http://www.unpbook.com/) by Richard Stevens, Bill Fenner, and Andrew Rudoff.

This tutorial assumes that the reader is comfortable with editing and compiling C code using the GNU GCC compiler as well as familiar with the concepts of public key encryption. Please note that access to the Unix Network Programming book is not required for this tutorial.

### Examples Used in this Tutorial

* echoclient - Figure 5.4, Page 124
* echoserver - Figure 5.12, Page 139

## Quick Summary of SSL/TLS

**TLS** (Transport Layer Security) and **SSL** (Secure Sockets Layer) are cryptographic protocols that allow for secure communication across a number of different transport protocols.  The primary transport protocol used is TCP/IP. The most recent version of SSL/TLS is TLS 1.3. wolfSSL supports SSL 3.0, TLS 1.0, 1.1, 1.2, 1.3 in addition to DTLS 1.0 and 1.2.

SSL and TLS sit between the Transport and Application layers of the OSI model, where any number of protocols (including TCP/IP, Bluetooth, etc.) may act as the underlying transport medium. Application protocols are layered on top of SSL and can include protocols such as HTTP, FTP, and SMTP. A diagram of how SSL fits into the OSI model, as well as a simple diagram of the SSL handshake process can be found in Appendix A.

## Getting the Source Code

All of the source code used in this tutorial can be downloaded from the wolfSSL website, specifically from the following location. The download contains both the original and completed source code for both the echoserver and echoclient used in this tutorial. Specific contents are listed below the link.

<https://www.wolfssl.com/documentation/ssl-tutorial-2.5.zip>

The downloaded ZIP file has the following structure:

```text
/finished_src
    /certs  (Certificate files)
    /echoclient (Completed echoclient code)
    /echoserver (Completed echoserver code)
    /include    (Modified unp.h)
    /lib    (Library functions)
/original_src
    /echoclient (Starting echoclient code)
    /echoserver (Starting echoserver code)
    /include    (Modified unp.h)
    /lib    (Library functions)
README
```

## Base Example Modifications

This tutorial, and the source code that accompanies it, have been designed to be as portable as possible across platforms. Because of this, and because we want to focus on how to add SSL and TLS into an application, the base examples have been kept as simple as possible. Several modifications have been made to the examples taken from Unix Network Programming in order to either remove unnecessary complexity or increase the range of platforms supported. If you believe there is something we could do to increase the portability of this tutorial, please let us know at [support@wolfssl.com](mailto:support@wolfssl.com).

The following is a list of modifications that were made to the original echoserver and echoclient examples found in the above listed book.

### Modifications to the echoserver (tcpserv04.c)

* Removed call to the `fork()` function because `fork()` is not supported by Windows. The result of this is an echoserver which only accepts one client simultaneously. Along with this removal, Signal handling was removed.
* Moved `str_echo()` function from `str_echo.c` file into `tcpserv04.c` file
* Added a printf statement to view the client address and the port we have connected through:

    ```text
    printf("Connection from %s, port %d\n",
            inet_ntop(AF_INET, &cliaddr.sin_addr, buff, sizeof(buff)),
            ntohs(cliaddr.sin_port));
    ```

* Added a call to `setsockopt()` after creating the listening socket to eliminate the “Address already in use” bind error.
* Minor adjustments to clean up newer compiler warnings

### Modifications to the echoclient (tcpcli01.c)

* Moved `str_cli()` function from `str_cli.c` file into `tcpcli01.c` file
* Minor adjustments to clean up newer compiler warnings

### Modifications to unp.h header

* This header was simplified to contain only what is needed for this example.

Please note that in these source code examples, certain functions will be capitalized. For example, `Fputs()` and `Writen()`. The authors of Unix Network Programming have written custom wrapper functions for normal functions in order to cleanly handle error checking. For a more thorough explanation of this, please see **Section 1.4** (page 11) in the _Unix Network Programming_ book.

## Building and Installing wolfSSL

Before we begin, download the example code (`echoserver` and `echoclient`) from the [Getting the Source Code](chapter03.md#getting-the-source-code) section, above. This section will explain how to download, configure, and install the wolfSSL embedded SSL/TLS library on your system.

You will need to download and install the most recent version of wolfSSL from the wolfSSL [download page](https://www.wolfssl.com/download/).

For a full list of available build options, see the [Building wolfSSL](https://www.wolfssl.com/documentation/manuals/wolfssl/chapter02.html) guide. wolfSSL was written with portability in mind, and should generally be easy to build on most systems. If you have difficulty building wolfSSL, please feel free to ask for support on the wolfSSL [product support forums](https://www.wolfssl.com/forums).

When building wolfSSL on Linux, *BSD, OS X, Solaris, or other *nix like systems, you can use the autoconf system. For Windows-specific instructions, please refer to the [Building wolfSSL](chapter02.md#building-wolfssl) section of the wolfSSL Manual. To configure and build wolfSSL, run the following two commands from the terminal. Any desired build options may be appended to `./configure` (ex: `./configure -–enable-opensslextra`):

```sh
./configure
make
```

To install wolfSSL, run:

```sh
sudo make install
```

This will install wolfSSL headers into `/usr/local/include/wolfssl` and the wolfSSL libraries into `/usr/local/lib` on your system. To test the build, run the testsuite application from the wolfSSL root directory:

```sh
./testsuite/testsuite.test
```

A set of tests will be run on wolfCrypt and wolfSSL to verify it has been installed correctly. After a successful run of the testsuite application, you should see output similar to the following:

```text
------------------------------------------------------------------------------
 wolfSSL version 5.7.0
------------------------------------------------------------------------------
error    test passed!
MEMORY   test passed!
base64   test passed!
asn      test passed!
RANDOM   test passed!
MD5      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-512/224  test passed!
SHA-512/256  test passed!
SHA-3    test passed!
Hash     test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
HMAC-SHA3   test passed!
HMAC-KDF    test passed!
PRF         test passed!
TLSv1.3 KDF test passed!
GMAC     test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES      test passed!
AES192   test passed!
AES256   test passed!
AES-GCM  test passed!
RSA      test passed!
DH       test passed!
PWDBASED test passed!
ECC      test passed!
logging  test passed!
time     test passed!
mutex    test passed!
memcb    test passed!
Test complete

Running simple test
SSL version is TLSv1.2
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
Client message: hello wolfssl!
I hear you fa shizzle!

Running TLS test
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers = TLS13-AES128-GCM-SHA256:TLS13-AES256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /var/folders/dy/888x7r7d6dgcqw4840l32tpw0000gp/T//testsuite-output-9Ymbuv

All tests passed!
```

Now that wolfSSL has been installed, we can begin modifying the example code to add SSL functionality. We will first begin by adding SSL to the echoclient and subsequently move on to the echoserver.

## Initial Compilation

To compile and run the example echoclient and echoserver code from the SSL Tutorial source bundle, you can use the included Makefiles. Change directory (cd) to either the echoclient or echoserver directory and run:

```sh
make
```

This will compile the example code and produce an executable named either echoserver or echoclient depending on which one is being built. The GCC command which is used in the Makefile can be seen below. If you want to build one of the examples without using the supplied Makefile, change directory to the example directory and replace `tcpcli01.c` (echoclient) or `tcpserv04.c` (echoserver) in the following command with correct source file for the example:

```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include
```

This will compile the current example into an executable, creating either an “echoserver” or “echoclient” application. To run one of the examples after it has been compiled, change your current directory to the desired example directory and start the application. For example, to start the echoserver use:

```sh
./echoserver
```

You may open a second terminal window to test the echoclient on your local host and you will need to supply the IP address of the server when starting the application, which in our case will be 127.0.0.1. Change your current directory to the “echoclient” directory and run the following command. Note that the echoserver must already be running:

```sh
./echoclient 127.0.0.1
```

Once you have both the echoserver and echoclient running, the echoserver should echo back any input that it receives from the echoclient. To exit either the echoserver or echoclient, use _Ctrl + C_ to quit the application. Currently, the data being echoed back and forth between these two examples is being sent in the clear - easily allowing anyone with a little bit of skill to inject themselves in between the client and server and listen to your communication.

## Libraries

The wolfSSL library, once compiled, is named `libwolfssl`, and unless otherwise configured the wolfSSL build and install process creates only a shared library under the following directory.  Both shared and static libraries may be enabled or disabled by using the appropriate build options:

```sh
/usr/local/lib
```

The first step we need to do is link the wolfSSL library to our example applications. Modifying the GCC command (using the echoserver as an example), gives us the following new command. Since wolfSSL installs header files and libraries in standard locations, the compiler should be able to find them without explicit instructions (using `-l` or `-L`). Note that by using `-lwolfssl` the compiler will automatically choose the correct type of library (static or shared):

```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include -lm -lwolfssl
```

## Headers

The first thing we will need to do is include the wolfSSL native API header in both the client and the server. In the `tcpcli01.c` file for the client and the `tcpserv04.c` file for the server add the following line near the top:

```c
#include <wolfssl/ssl.h>
```

## Startup/Shutdown

Before we can use wolfSSL in our code, we need to initialize the library and the `WOLFSSL_CTX`. wolfSSL is initialized by calling [`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init). This must be done first before anything else can be done with the library.

## WOLFSSL_CTX Factory

The `WOLFSSL_CTX` structure (wolfSSL Context) contains global values for each SSL connection, including certificate information. A single `WOLFSSL_CTX` can be used with any number of `WOLFSSL` objects created. This allows us to load certain information, such as a list of trusted CA certificates only once.

To create a new `WOLFSSL_CTX`, use [`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new). This function requires an argument which defines the SSL or TLS protocol for the client or server to use. There are several options for selecting the desired protocol. wolfSSL currently supports SSL 3.0, TLS 1.0, TLS 1.1, TLS 1.2, TLS 1.3, DTLS 1.0, DTLS 1.2, and DTLS 1.3. Each of these protocols have a corresponding function that can be used as an argument to [`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new). The possible client and server protocol options are shown below. SSL 2.0 is not supported by wolfSSL because it has been insecure for several years.

EchoClient:

* [`wolfSSLv3_client_method();`](group__Setup.md#function-wolfsslv3_client_method) - SSL 3.0
* [`wolfTLSv1_client_method();`](group__Setup.md#function-wolftlsv1_client_method) - TLS 1.0
* [`wolfTLSv1_1_client_method();`](group__Setup.md#function-wolftlsv1_1_client_method) - TLS 1.1
* [`wolfTLSv1_2_client_method();`](group__Setup.md#function-wolftlsv1_2_client_method) - TLS 1.2
* [`wolfTLSv1_3_client_method();`](group__Setup.md#function-wolftlsv1_3_client_method) - TLS 1.3
* [`wolfSSLv23_client_method();`](group__Setup.md#function-wolfsslv23_client_method) - Use highest version possible from SSL 3.0 - TLS 1.3
* [`wolfDTLSv1_client_method();`](group__Setup.md#function-wolfdtlsv1_client_method) - DTLS 1.0
* [`wolfDTLSv1_2_client_method_ex();`](ssl_8h.md#function-wolfdtlsv1_2_client_method_ex) - DTLS 1.2
* [`wolfDTLSv1_3_client_method_ex();`](ssl_8h.md#function-wolfdtlsv1_3_client_method_ex) - DTLS 1.3

EchoServer:

* [`wolfSSLv3_server_method();`](group__Setup.md#function-wolfsslv3_server_method) - SSL 3.0
* [`wolfTLSv1_server_method();`](group__Setup.md#function-wolftlsv1_server_method) - TLS 1.0
* [`wolfTLSv1_1_server_method();`](group__Setup.md#function-wolftlsv1_1_server_method) - TLS 1.1
* [`wolfTLSv1_2_server_method();`](group__Setup.md#function-wolftlsv1_2_server_method) - TLS 1.2
* [`wolfTLSv1_3_server_method();`](group__Setup.md#function-wolftlsv1_3_server_method) - TLS 1.3
* [`wolfSSLv23_server_method();`](group__Setup.md#function-wolfsslv23_server_method) - Allow clients to connect with TLS 1.0+
* [`wolfDTLSv1_server_method();`](group__Setup.md#function-wolfdtlsv1_server_method) - DTLS 1.0
* [`wolfDTLSv1_2_server_method();`](ssl_8h.md#function-wolfdtlsv1_2_server_method) - DTLS 1.2
* [`wolfDTLSv1_3_server_method();`](ssl_8h.md#function-wolfdtlsv1_3_server_method) - DTLS 1.3

We need to load our CA (Certificate Authority) certificate into the `WOLFSSL_CTX` so that the when the echoclient connects to the echoserver, it is able to verify the server’s identity. To load the CA certificates into the `WOLFSSL_CTX`, use [`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations). This function requires three arguments: a `WOLFSSL_CTX` pointer, a certificate file, and a path value. The path value points to a directory which should contain CA certificates in PEM format. When looking up certificates, wolfSSL will look at the certificate file value before looking in the path location. In this case, we don’t need to specify a certificate path because we will specify one CA file - as such we use the value 0 for the path argument. The [`wolfSSL_CTX_load_verify_locations`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations) function returns either `SSL_SUCCESS` or `SSL_FAILURE`:

```c
wolfSSL_CTX_load_verify_locations(WOLFSSL_CTX* ctx, const char* file, const char* path)
```

Putting these things together (library initialization, protocol selection, and CA certificate), we have the following. Here, we choose to use TLS 1.2:

EchoClient:

```c
    WOLFSSL_CTX* ctx;

    wolfSSL_Init();/* Initialize wolfSSL */

    /* Create the WOLFSSL_CTX */
    if ( (ctx = wolfSSL_CTX_new(wolfTLSv1_2_client_method())) == NULL) {
        fprintf(stderr, "wolfSSL_CTX_new error.\n");
        exit(EXIT_FAILURE);
    }

    /* Load CA certificates into WOLFSSL_CTX */
    if (wolfSSL_CTX_load_verify_locations(ctx,"../certs/ca-cert.pem",0) !=
        SSL_SUCCESS) {
        fprintf(stderr, "Error loading ../certs/ca-cert.pem, please check"
            "the file.\n");
        exit(EXIT_FAILURE);
    }
```

Add the above code to `tcpcli01.c` in `main()` after the variable definitions and the check that the user has started the client with an IP address.

EchoServer:

When loading certificates into the `WOLFSSL_CTX`, the server certificate and key file should be loaded in addition to the CA certificate. This will allow the server to send the client its certificate for identification verification:

```c
WOLFSSL_CTX* ctx;

wolfSSL_Init();  /* Initialize wolfSSL */

/* Create the WOLFSSL_CTX */
if ( (ctx = wolfSSL_CTX_new(wolfTLSv1_2_server_method())) == NULL) {
    fprintf(stderr, "wolfSSL_CTX_new error.\n");
    exit(EXIT_FAILURE);
}

/* Load CA certificates into WOLFSSL_CTX */
if (wolfSSL_CTX_load_verify_locations(ctx, "../certs/ca-cert.pem", 0) !=
         SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/ca-cert.pem, "
        "please check the file.\n");
    exit(EXIT_FAILURE);
}

/* Load server certificates into WOLFSSL_CTX */
if (wolfSSL_CTX_use_certificate_file(ctx,"../certs/server-cert.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/server-cert.pem, please"
        "check the file.\n");
    exit(EXIT_FAILURE);
}

/* Load keys */
if (wolfSSL_CTX_use_PrivateKey_file(ctx,"../certs/server-key.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/server-key.pem, please check"
        "the file.\n");
    exit(EXIT_FAILURE);
}
```

The code shown above should be added to the beginning of `tcpserv04.c` after the variable definitions in `main()`. A version of the finished code is included in the SSL tutorial ZIP file for reference.

Now that wolfSSL and the `WOLFSSL_CTX` have been initialized, make sure that the `WOLFSSL_CTX` object and the wolfSSL library are freed when the application is completely done using SSL/TLS. In both the client and the server, the following two lines should be placed at the end of the `main()` function (in the client right before the call to `exit()`):

```c
wolfSSL_CTX_free(ctx);
wolfSSL_Cleanup();
```

## WOLFSSL Object

### EchoClient

A WOLFSSL object needs to be created after each TCP Connect and the socket file descriptor needs to be associated with the session. In the echoclient example, we will do this after the call to `Connect()`, shown below:

```c
/* Connect to socket file descriptor */
Connect(sockfd, (SA *) &servaddr, sizeof(servaddr));
```

Directly after connecting, create a new `WOLFSSL` object using the [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new) function. This function returns a pointer to the `WOLFSSL` object if successful or `NULL` in the case of failure. We can then associate the socket file descriptor (`sockfd`) with the new `WOLFSSL` object (`ssl`):

```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if( (ssl = wolfSSL_new(ctx)) == NULL) {
    fprintf(stderr, "wolfSSL_new error.\n");
    exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, sockfd);
```

One thing to notice here is that we haven’t made a call to the [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) function. [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) initiates the SSL/TLS handshake with the server, and is called during [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) if it hadn't been called previously. In our case, we don’t explicitly call [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect), as we let our first [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) do it for us.

### EchoServer

At the end of the for loop in the main method, insert the WOLFSSL object and associate the socket file descriptor (`connfd`) with the `WOLFSSL` object (`ssl`), just as with the client:

```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if ( (ssl = wolfSSL_new(ctx)) == NULL) {
            fprintf(stderr, "wolfSSL_new error.\n");
            exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, connfd);
```

Again, a WOLFSSL object needs to be created after each TCP Connect and the socket file descriptor needs to be associated with the session.

## Sending/Receiving Data

### Sending with EchoClient

The next step is to begin sending data securely. Take note that in the echoclient example, the `main()` function hands off the sending and receiving work to `str_cli()`. The `str_cli()` function is where our function replacements will be made. First we need access to our `WOLFSSL` object in the `str_cli()` function, so we add another argument and pass the ssl variable to `str_cli()`. Because the `WOLFSSL` object is now going to be used inside of the `str_cli()` function, we remove the `sockfd` parameter. The new `str_cli()` function signature after this modification is shown below:

```c
void str_cli(FILE *fp, WOLFSSL* ssl)
```

In the `main()` function, the new argument (`ssl`) is passed to `str_cli()`:

```c
str_cli(stdin, ssl);
```

Inside the `str_cli()` function, `Writen()` and `Readline()` are replaced with calls to [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) and [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) functions, and the `WOLFSSL` object (`ssl`) is used instead of the original file descriptor(`sockfd`). The new `str_cli()` function is shown below. Notice that we now need to check if our calls to [`wolfSSL_write`](group__IO.md#function-wolfssl_write) and [`wolfSSL_read`](group__IO.md#function-wolfssl_read) were successful.

The authors of the Unix Programming book wrote error checking into their `Writen()` function which we must make up for after it has been replaced. We add a new int variable, `n`, to monitor the return value of [`wolfSSL_read`](group__IO.md#function-wolfssl_read) and before printing out the contents of the buffer, `recvline`, the end of our read data is marked with a `\0`:

```c
void
str_cli(FILE *fp, WOLFSSL* ssl)
{
    char  sendline[MAXLINE], recvline[MAXLINE];
    int   n = 0;

    while (Fgets(sendline, MAXLINE, fp) != NULL) {

        if(wolfSSL_write(ssl, sendline, strlen(sendline)) !=
                     strlen(sendline)){
            err_sys("wolfSSL_write failed");
        }

        if ((n = wolfSSL_read(ssl, recvline, MAXLINE)) <= 0)
            err_quit("wolfSSL_read error");

        recvline[n] = '\0';
        Fputs(recvline, stdout);
    }
}
```

The last thing to do is free the `WOLFSSL` object when we are completely done with it. In the `main()` function, right before the line to free the `WOLFSSL_CTX`, call to [`wolfSSL_free()`](group__Setup.md#function-wolfssl_free):

```c
str_cli(stdin, ssl);

wolfSSL_free(ssl);      /* Free WOLFSSL object */
wolfSSL_CTX_free(ctx);  /* Free WOLFSSL_CTX object */
wolfSSL_Cleanup();      /* Free wolfSSL */
```

### Receiving with EchoServer

The echo server makes a call to `str_echo()` to handle reading and writing (whereas the client made a call to `str_cli()`). As with the client, modify `str_echo()` by replacing the sockfd parameter with a `WOLFSSL` object (`ssl`) parameter in the function signature:

```c
void str_echo(WOLFSSL* ssl)
```

Replace the calls to `Read()` and `Writen()` with calls to the [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) and [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) functions. The modified `str_echo()` function, including error checking of return values, is shown below. Note that the type of the variable `n` has been changed from `ssize_t` to `int` in order to accommodate for the change from `read()` to [`wolfSSL_read()`](group__IO.md#function-wolfssl_read):

```c
void
str_echo(WOLFSSL* ssl)
{
    int n;
    char buf[MAXLINE];

    while ( (n = wolfSSL_read(ssl, buf, MAXLINE)) > 0) {
        if(wolfSSL_write(ssl, buf, n) != n) {
            err_sys("wolfSSL_write failed");
        }
    }

    if( n < 0 )
        printf("wolfSSL_read error = %d\n", wolfSSL_get_error(ssl,n));
    else if( n == 0 )
        printf("The peer has closed the connection.\n");
}
```

In `main()` call the `str_echo()` function at the end of the for loop (soon to be changed to a while loop). After this function, inside the loop, make calls to free the `WOLFSSL` object and close the connfd socket:

```c
str_echo(ssl);                     /* process the request */

wolfSSL_free(ssl);                 /* Free WOLFSSL object */
Close(connfd);
```

We will free the `ctx` and cleanup before the call to exit.

## Signal Handling

### Echoclient / Echoserver

In the echoclient and echoserver, we will need to add a signal handler for when the user closes the app by using “Ctrl+C”. The echo server is continually running in a loop. Because of this, we need to provide a way to break that loop when the user presses “Ctrl+C”. To do this, the first thing we need to do is change our loop to a while loop which terminates when an exit variable (cleanup) is set to true.

First, define a new static int variable called `cleanup` at the top of `tcpserv04.c` right after the `#include` statements:

```c
static int cleanup;  /* To handle shutdown */
```

Modify the echoserver loop by changing it from a for loop to a while loop:

```c
while(cleanup != 1)
{
    /* echo server code here */
}
```

For the echoserver we need to disable the operating system from restarting calls which were being executed before the signal was handled after our handler has finished. By disabling these, the operating system will not restart calls to `accept()` after the signal has been handled. If we didn’t do this, we would have to wait for another client to connect and disconnect before the echoserver would clean up resources and exit. To define the signal handler and turn off `SA_RESTART`, first define act and oact structures in the echoserver’s `main()` function:

```c
struct sigaction     act, oact;
```

Insert the following code after variable declarations, before the call to [`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init) in the main function:

```c
/* Signal handling code */
struct sigaction act, oact;         /* Declare the sigaction structs    */
act.sa_handler = sig_handler;       /* Tell act to use sig_handler      */
sigemptyset(&act.sa_mask);          /* Tells act to exclude all sa_mask *
                                     * signals during execution of      *
                                     * sig_handler.                     */
act.sa_flags = 0;                   /* States that act has a special    *
                                     * flag of 0                        */
sigaction(SIGINT, &act, &oact);     /* Tells the program to use (o)act  *
                                     * on a signal or interrupt         */
```

The echoserver’s sig_handler function is shown below:

```c
void sig_handler(const int sig)
{
    printf("\nSIGINT handled.\n");
    cleanup = 1;
    return;
}
```

That’s it - the echoclient and echoserver are now enabled with TLSv1.2!!

What we did:

* Included the wolfSSL headers
* Initialized wolfSSL
* Created a `WOLFSSL_CTX` structure in which we chose what protocol we wanted to use
* Created a `WOLFSSL` object to use for sending and receiving data
* Replaced calls to `Writen()` and `Readline()` with [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) and [`wolfSSL_read()`](group__IO.md#function-wolfssl_read)
* Freed `WOLFSSL`, `WOLFSSL_CTX`
* Made sure we handled client and server shutdown with signal handler

There are many more aspects and methods to configure and control the behavior of your SSL connections. For more detailed information, please see additional wolfSSL documentation and resources.

Once again, the completed source code can be found in the downloaded ZIP file at the top of this section.

## Certificates

For testing purposes, you may use the certificates provided by wolfSSL. These can be found in the wolfSSL download, and specifically for this tutorial, they can be found in the `finished_src` folder.

For production applications, you should obtain correct and legitimate certificates from a trusted certificate authority.

## Conclusion

This tutorial walked through the process of integrating the wolfSSL embedded SSL/TLS library into a simple client and server application. Although this example is simple, the same principles may be applied for adding SSL or TLS into your own application. The wolfSSL embedded SSL/TLS library provides all the features you would need in a compact and efficient package that has been optimized for both size and speed.

Being dual licensed under GPLv2 and standard commercial licensing, you are free to download the wolfSSL source code directly from our website. Feel free to post to our support forums (<https://www.wolfssl.com/forums>) with any questions or comments you might have. If you would like more information about our products, please contact [info@wolfssl.com](mailto:info@wolfssl.com).

We welcome any feedback you have on this SSL tutorial. If you believe it could be improved or enhanced in order to make it either more useful, easier to understand, or more portable, please let us know at [support@wolfssl.com](mailto:support@wolfssl.com).
