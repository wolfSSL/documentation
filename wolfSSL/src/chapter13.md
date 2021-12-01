# OpenSSL Compatibility

## Compatibility with OpenSSL

wolfSSL (formerly CyaSSL) provides an OpenSSL compatibility header, `wolfssl/openssl/ssl.h`, in addition to the wolfSSL native API, to ease the transition into using wolfSSL or to aid in porting an existing OpenSSL application over to wolfSSL.  For an overview of the OpenSSL Compatibility Layer, please continue reading below.  To view the complete set of OpenSSL functions supported by wolfSSL, please see the `wolfssl/openssl/ssl.h` file.

The OpenSSL Compatibility Layer maps a subset of the most commonly-used OpenSSL commands to wolfSSL’s native API functions.  This should allow for an easy replacement of OpenSSL by wolfSSL in your application or project without changing much code.

Our test beds for OpenSSL compatibility are stunnel and Lighttpd, which means that we build both of them with wolfSSL as a way to test our OpenSSL compatibility API.

Building wolfSSL With Compatibility Layer:

1. Enable with ([`--enable-opensslextra`](chapter02.md#enable-opensslextra)) or by defining the macro `OPENSSL_EXTRA`.

    ```sh
    ./configure --enable-opensslextra
    ```

2. Include `<wolfssl/options.h>` as first wolfSSL header
3. Header files for migration are located under:
    * `./wolfssl/openssl/*.h`
    * Ex: `<wolfssl/openssl/ssl.h>`

## Differences Between wolfSSL and OpenSSL

Many people are curious how wolfSSL compares to OpenSSL and what benefits there are to using an SSL/TLS library that has been optimized to run on embedded platforms.  Obviously, OpenSSL is free and presents no initial costs to begin using, but we believe that wolfSSL will provide you with more flexibility, an easier integration of SSL/TLS into your existing platform, current standards support, and much more – all provided under a very easy-to-use license model.

The points below outline several of the main differences between wolfSSL and OpenSSL.

1. With a 20-100 kB build size, wolfSSL is up to 20 times smaller than OpenSSL.  wolfSSL is a better choice for resource constrained environments – where every byte matters.
2. wolfSSL is up to date with the most current standards of TLS 1.3 with DTLS.  The wolfSSL team is dedicated to continually keeping wolfSSL up-to-date with current standards.
3. wolfSSL offers the best current ciphers and standards available today, including ciphers for streaming media support.  In addition, the recently-introduced liboqs integration allows for you to start experimenting with post-quantum cryptography.
4. wolfSSL is dual licensed under both the GPLv2 as well as a commercial license, where OpenSSL is available only under their unique license from multiple sources.
5. wolfSSL is backed by an outstanding company who cares about its users and about their security, and is always willing to help. The team actively works to improve and expand wolfSSL.  The wolfSSL team is based primarily out of Bozeman, MT, Portland, OR, and Seattle, WA, along with other team members located around the globe.
6. wolfSSL is the leading SSL/TLS library for real time, mobile, and embedded systems by virtue of its breadth of platform support and successful implementations on embedded environments.  Chances are we’ve already been ported to your environment.  If not, let us know and we’ll be glad to help.
7. wolfSSL offers several abstraction layers to make integrating SSL into your environment and platform as easy as possible.  With an OS layer, a custom I/O layer, and a C Standard Library abstraction layer, integration has never been so easy.
8. wolfSSL offers several support packages for wolfSSL.  Available directly through phone, email or the wolfSSL product support forums, your questions are answered quickly and accurately to help you make progress on your project as quickly as possible.

## Supported OpenSSL Structures

* `SSL_METHOD` holds SSL version information and is either a client or server method. (Same as `WOLFSSL_METHOD` in the native wolfSSL API).
* `SSL_CTX` holds context information including certificates. (Same as `WOLFSSL_CTX` in the native wolfSSL API).
* `SSL` holds session information for a secure connection. (Same as `WOLFSSL` in the native wolfSSL API).

## Supported OpenSSL Functions

The three structures shown above are usually initialized in the following way:

```c
SSL_METHOD* method = SSLv3_client_method();
SSL_CTX* ctx = SSL_CTX_new(method);
SSL* ssl = SSL_new(ctx);
```

This establishes a client side SSL version 3 method, creates a context based on the method, and initializes the SSL session with the context. A server side program is no different except that the `SSL_METHOD` is created using `SSLv3_server_method()`, or one of the available functions.  For a list of supported functions, please see the [Protocol Support](chapter04.md#protocol-support) section.  When using the OpenSSL Compatibility layer, the functions in this section should be modified by removing the “wolf” prefix.  For example, the native wolfSSL API function:

```c
wolfTLSv1_client_method()
```

Becomes:

```c
TLSv1_client_method()
```

When an SSL connection is no longer needed the following calls free the structures created during initialization.

```c
SSL_CTX_free(ctx);
SSL_free(ssl);
```

`SSL_CTX_free()` has the additional responsibility of freeing the associated `SSL_METHOD`. Failing to use the `XXX_free()` functions will result in a resource leak. Using the system's `free()` instead of the SSL ones results in undefined behavior.

Once an application has a valid SSL pointer from `SSL_new()`, the SSL handshake process can begin. From the client's view, `SSL_connect()` will attempt to establish a secure connection.

```c
SSL_set_fd(ssl, sockfd);
SSL_connect(ssl);
```

Before the `SSL_connect()` can be issued, the user must supply wolfSSL with a valid socket file descriptor, sockfd in the example above. `sockfd` is typically the result of the TCP function `socket()` which is later established using TCP `connect()`. The following creates a valid client side socket descriptor for use with a local wolfSSL server on port 11111, error handling is omitted for simplicity.

```c
int sockfd = socket(AF_INET, SOCK_STREAM, 0);
sockaddr_in servaddr;
memset(&servaddr, 0, sizeof(servaddr));
servaddr.sin_family = AF_INET;
servaddr.sin_port = htons(11111);
servaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
connect(sockfd, (const sockaddr*)&servaddr, sizeof(servaddr));
```

Once a connection is established, the client may read and write to the server. Instead of using the TCP functions `send()` and `receive()`, wolfSSL and yaSSL use the SSL functions `SSL_write()` and `SSL_read()`. Here is a simple example from the client demo:

```c
char msg[] = "hello wolfssl!";
int wrote = SSL_write(ssl, msg, sizeof(msg));
char reply[1024];
int read = SSL_read(ssl, reply, sizeof(reply));
reply[read] = 0;
printf("Server response: %s\n", reply);
```

The server connects in the same way, except that it uses `SSL_accept()` instead of `SSL_connect()`, analogous to the TCP API. See the server example for a complete server demo program.

## x509 Certificates

Both the server and client can provide wolfSSL with certificates in either **PEM** or **DER**.

Typical usage is like this:

```c
SSL_CTX_use_certificate_file(ctx, "certs/cert.pem",
SSL_FILETYPE_PEM);
SSL_CTX_use_PrivateKey_file(ctx, "certs/key.der",
SSL_FILETYPE_ASN1);
```

A key file can also be presented to the Context in either format. `SSL_FILETYPE_PEM` signifies the file is PEM formatted while `SSL_FILETYPE_ASN1` declares the file to be in DER format. To verify that the key file is appropriate for use with the certificate the following function can be used:

```c
SSL_CTX_check_private_key(ctx);
```
