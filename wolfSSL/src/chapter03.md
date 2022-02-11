# Getting Started

## General Description

wolfSSL, formerly CyaSSL, is about 10 times smaller than yaSSL and up to 20 times smaller than OpenSSL when using the compile options described in [Chapter 2](chapter02.md#building-wolfssl). User benchmarking and feedback also reports dramatically better performance from wolfSSL vs. OpenSSL in the vast majority of standard SSL operations.

For instructions on the build process please see [Chapter 2](chapter02.md#building-wolfssl).

## Testsuite

The testsuite program is designed to test the ability of wolfSSL and its cryptography library, wolfCrypt, to run on the system.

wolfSSL needs all examples and tests to be run from the wolfSSL home directory. This is because it finds certs and keys from ./certs. To run testsuite, execute:

```sh
./testsuite/testsuite.test
```

Or when using autoconf:

```sh
make test
```

On \*nix or Windows the examples and testsuite will check to see if the current directory is the source directory and if so, attempt to change to the wolfSSL home directory. This should work in most setup cases, if not, just use the first method above and specify the full path.

On a successful run you should see output like this, with additional output for unit tests and cipher suite tests:

```text
------------------------------------------------------------------------------
 wolfSSL version 4.8.1
------------------------------------------------------------------------------
error    test passed!
MEMORY   test passed!
base64   test passed!
base16   test passed!
asn      test passed!
RANDOM   test passed!
MD5      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
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
OPENSSL  test passed!
OPENSSL (EVP MD) passed!
OPENSSL (PKEY0) passed!
OPENSSL (PKEY1) passed!
OPENSSL (EVP Sign/Verify) passed!
ECC      test passed!
logging  test passed!
mutex    test passed!
memcb    test passed!
Test complete
Alternate cert chain used
 issuer : /C=US/ST=Montana/L=Bozeman/O=Sawtooth/OU=Consulting/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 subject: /C=US/ST=Montana/L=Bozeman/O=wolfSSL/OU=Support/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 altname = example.com
Alternate cert chain used
 issuer : /C=US/ST=Montana/L=Bozeman/O=wolfSSL_2048/OU=Programming-2048/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 subject: /C=US/ST=Montana/L=Bozeman/O=wolfSSL_2048/OU=Programming-2048/CN=www.wolfssl.com/emailAddress=info@wolfssl.com
 altname = example.com
 serial number:01
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL signature algorithm is RSA-SHA256
SSL curve name is SECP256R1
Session timeout set to 500 seconds
Client Random :  serial number:f1:5c:99:43:66:3d:96:04
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL signature algorithm is RSA-SHA256
SSL curve name is SECP256R1
1DC16A2C0D3AC49FC221DD5B8346B7B38CB9899B7A402341482183Server Random : 1679E50DBBBB3DB88C90F600C4C578F4F5D3CEAEC9B16BCCA215C276B448
765A1385611D6A
Client message: hello wolfssl!
I hear you fa shizzle!
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers = TLS13-AES128-GCM-SHA256:TLS13-AES256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /tmp/output-gNQWZL

All tests passed!
```

This indicates that everything is configured and built correctly. If any of the tests fail, make sure the build system was set up correctly. Likely culprits include having the wrong endianness or not properly setting the 64-bit type. If you've set anything to the non-default settings try removing those, rebuilding wolfSSL, and then re-testing.

## Client Example

You can use the client example found in examples/client to test wolfSSL against any SSL server. To see a list of available command line runtime options, run the client with the `--help` argument:

```sh
./examples/client/client --help
```

Which returns:

```text
wolfSSL client 4.8.1 NOTE: All files relative to wolfSSL home dir
Max RSA key size in bits for build is set at : 4096
-? <num>    Help, print this usage
            0: English, 1: Japanese
--help      Help, in English
-h <host>   Host to connect to, default 127.0.0.1
-p <num>    Port to connect on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-V          Prints valid ssl version numbers, SSLv3(0) - TLS1.3(4)
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/client-cert.pem
-k <file>   Key file,                   default ./certs/client-key.pem
-A <file>   Certificate Authority file, default ./certs/ca-cert.pem
-Z <num>    Minimum DH key bits,        default 1024
-b <num>    Benchmark <num> connections and print stats
-B <num>    Benchmark throughput using <num> bytes and print stats
-d          Disable peer checks
-D          Override Date Errors example
-e          List Every cipher suite available,
-g          Send server HTTP GET
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-m          Match domain name in cert
-N          Use Non-blocking sockets
-r          Resume session
-w          Wait for bidirectional shutdown
-M <prot>   Use STARTTLS, using <prot> protocol (smtp)
-f          Fewer packet/group messages
-x          Disable client cert/key loading
-X          Driven by eXternal test case
-j          Use verify callback override
-n          Disable Extended Master Secret
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-J          Use HelloRetryRequest to choose group for KE
-K          Key Exchange for PSK not using (EC)DHE
-I          Update keys and IVs before sending data
-y          Key Share with FFDHE named groups only
-Y          Key Share with ECC named groups only
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-2          Disable DH Prime check
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```

To test against example.com:443 try the following. This is using wolfSSL compiled with the `--enable-opensslextra` and `--enable-supportedcurves` build options:

```sh
./examples/client/client -h example.com -p 443 -d -g
```

Which returns:

```text
Alternate cert chain used
 issuer : /C=US/O=DigiCert Inc/CN=DigiCert TLS RSA SHA256 2020 CA1
 subject: /C=US/ST=California/L=Los Angeles/O=Internet Corporation for Assigned Names and Numbers/CN=www.example.org
 altname = www.example.net
 altname = www.example.edu
 altname = www.example.com
 altname = example.org
 altname = example.net
 altname = example.edu
 altname = example.com
 altname = www.example.org
 serial number:0f:be:08:b0:85:4d:05:73:8a:b0:cc:e1:c9:af:ee:c9
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
SSL curve name is SECP256R1
Session timeout set to 500 seconds
Client Random : 20640B8131D8E542646D395B362354F9308057B1624C2442C0B5FCDD064BFE29
SSL connect ok, sending GET...
HTTP/1.0 200 OK
Accept-Ranges: bytes
Content-Type: text/html
Date: Thu, 14 Oct 2021 16:50:28 GMT
Last-Modified: Thu, 14 Oct 2021 16:45:10 GMT
Server: ECS (nyb/1D10)
Content-Length: 94
Connection: close
```

This tells the client to connect to (`-h`) example.com on the HTTPS port (`-p`) of 443 and sends a generic (`-g`) GET request. The (`-d`) option tells the client not to verify the server. The rest is the initial output from the server that fits into the read buffer.

If no command line arguments are given, then the client attempts to connect to the localhost on the wolfSSL default port of 11111. It also loads the client certificate in case the server wants to perform client authentication.

The client is able to benchmark a connection when using the `-b <num>` argument. When used, the client attempts to connect to the specified server/port the argument number of times and gives the average time in milliseconds that it took to perform `SSL_connect()`. For example:

```sh
/examples/client/client -b 100 -h example.com -p 443 -d
```

Returns:

```text
wolfSSL_connect avg took:  296.417 milliseconds
```

If you'd like to change the default host from localhost, or the default port from 11111, you can change these settings in `/wolfssl/test.h`. The variables wolfSSLIP and wolfSSLPort control these settings. Re-build all of the examples including testsuite when changing these settings otherwise the test programs won't be able to connect to each other.

By default, the wolfSSL example client tries to connect to the specified server using TLS 1.2. The user is able to change the SSL/TLS version which the client uses by using the `-v` command line option. The following values are available for this option:

* `-v 0` - SSL 3.0 (disabled by default)
* `-v 1` - TLS 1.0
* `-v 2` - TLS 1.1
* `-v 3` - TLS 1.2 (selected by default)
* `-v 4` - TLS 1.3

A common error users see when using the example client is -188:

```text
wolfSSL_connect error -188, ASN no signer error to confirm failure
wolfSSL error: wolfSSL_connect failed
```

This is typically caused by the wolfSSL client not being able to verify the certificate of the server it is connecting to. By default, the wolfSSL client loads the yaSSL test CA certificate as a trusted root certificate. This test CA certificate will not be able to verify an external server certificate which was signed by a different CA. As such, to solve this problem, users either need to turn off verification of the peer (server), using the `-d` option:

```sh
./examples/client/client -h myhost.com -p 443 -d
```

Or load the correct CA certificate into the wolfSSL client using the `-A` command line option:

```sh
./examples/client/client -h myhost.com -p 443 -A serverCA.pem
```

## Server Example

The server example demonstrates a simple SSL server that optionally performs client authentication. Only one client connection is accepted and then the server quits. The client example in normal mode (no command line arguments) will work just fine against the example server, but if you specify command line arguments for the client example, then a client certificate isn't loaded and the [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) will fail (unless client cert check is disabled using the `-d` option). The server will report an error "-245, peer didn't send cert". Like the example client, the server can be used with several
command line arguments as well:

```sh
./examples/server/server --help
```

Which returns:

```text
server 4.8.1 NOTE: All files relative to wolfSSL home dir
-? <num>    Help, print this usage
            0: English, 1: Japanese
--help      Help, in English
-p <num>    Port to listen on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/server-cert.pem
-k <file>   Key file,                   default ./certs/server-key.pem
-A <file>   Certificate Authority file, default ./certs/client-cert.pem
-R <file>   Create Ready file for external monitor default none
-D <file>   Diffie-Hellman Params file, default ./certs/dh2048.pem
-Z <num>    Minimum DH key bits,        default 1024
-d          Disable client cert check
-b          Bind to any interface instead of localhost only
-s          Use pre Shared keys
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-f          Fewer packet/group messages
-r          Allow one client Resumption
-N          Use Non-blocking sockets
-S <str>    Use Host Name Indication
-w          Wait for bidirectional shutdown
-x          Print server errors but do not close connection
-i          Loop indefinitely (allow repeated connections)
-e          Echo data mode (return raw bytes received)
-B <num>    Benchmark throughput using <num> bytes and print stats
-g          Return basic HTML web page
-C <num>    The number of connections to accept, default: 1
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-U          Update keys and IVs before sending
-K          Key Exchange for PSK not using (EC)DHE
-y          Pre-generate Key Share using FFDHE_2048 only
-Y          Pre-generate Key Share using P-256 only
-F          Send alert if no mutual authentication
-2          Disable DH Prime check
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```

## EchoServer Example

The echoserver example sits in an endless loop waiting for an unlimited number of client connections. Whatever the client sends the echoserver echoes back. Client authentication isn't performed so the example client can be used against the echoserver in all 3 modes. Four special commands aren't echoed back and instruct the echoserver to take a different action.

1. `quit` - If the echoserver receives the string "quit" it will shutdown.
2. `break` If the echoserver receives the string "break" it will stop the current session but continue handling requests. This is particularly useful for DTLS testing.
3. `printstats` - If the echoserver receives the string "printstats" it will print out statistics for the session cache.
4. `GET` - If the echoserver receives the string "GET" it will handle it as an http get and send back a simple page with the message "greeting from wolfSSL". This allows testing of various TLS/SSL clients like Safari, IE, Firefox, gnutls, and the like against the echoserver example.

The output of the echoserver is echoed to stdout unless `NO_MAIN_DRIVER` is defined. You can redirect output through the shell or through the first command line argument. To create a file named output.txt with the output from the echoserver run:

```sh
./examples/echoserver/echoserver output.txt
```

## EchoClient Example

The echoclient example can be run in interactive mode or batch mode with files. To run in interactive mode and write 3 strings "hello", "wolfssl", and "quit" results in:

```text
./examples/echoclient/echoclient
hello
hello
wolfssl
wolfssl
quit
sending server shutdown command: quit!
```

To use an input file, specify the filename on the command line as the first argument. To echo the contents of the file `input.txt` issue:

```sh
./examples/echoclient/echoclient input.txt
```

If you want the result to be written out to a file, you can specify the output file name as an additional command line argument. The following command will echo the contents of file `input.txt` and write the result from the server to `output.txt`:

```sh
./examples/echoclient/echoclient input.txt output.txt
```

The testsuite program does just that, but hashes the input and output files to make sure that the client and server were getting/sending the correct and expected results.

## Benchmark

Many users are curious about how the wolfSSL embedded SSL library will perform on a specific hardware device or in a specific environment. Because of the wide variety of different platforms and compilers used today in embedded, enterprise, and cloud-based environments, it is hard to give generic performance calculations across the board.

To help wolfSSL users and customers in determining SSL performance for wolfSSL / wolfCrypt, a benchmark application is provided which is bundled with wolfSSL. wolfSSL uses the wolfCrypt cryptography library for all crypto operations by default. Because the underlying crypto is a very performance-critical aspect of SSL/TLS, our benchmark application runs performance tests on wolfCrypt’s algorithms.

The benchmark utility located in wolfcrypt/benchmark (`./wolfcrypt/benchmark/benchmark`) may be used to benchmark the cryptographic functionality of wolfCrypt. Typical output may look like the following (in this output, several optional algorithms/ciphers were enabled including ECC, SHA-256, SHA-512, AES-GCM, AES-CCM, and Camellia):

```sh
./wolfcrypt/benchmark/benchmark
```

```text
------------------------------------------------------------------------------
 wolfSSL version 4.8.1
------------------------------------------------------------------------------
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
RNG                105 MB took 1.004 seconds,  104.576 MB/s Cycles per byte =  20.94
AES-128-CBC-enc    310 MB took 1.008 seconds,  307.434 MB/s Cycles per byte =   7.12
AES-128-CBC-dec    290 MB took 1.002 seconds,  289.461 MB/s Cycles per byte =   7.56
AES-192-CBC-enc    265 MB took 1.010 seconds,  262.272 MB/s Cycles per byte =   8.35
AES-192-CBC-dec    240 MB took 1.013 seconds,  236.844 MB/s Cycles per byte =   9.24
AES-256-CBC-enc    240 MB took 1.011 seconds,  237.340 MB/s Cycles per byte =   9.22
AES-256-CBC-dec    235 MB took 1.018 seconds,  230.864 MB/s Cycles per byte =   9.48
AES-128-GCM-enc    160 MB took 1.011 seconds,  158.253 MB/s Cycles per byte =  13.83
AES-128-GCM-dec    160 MB took 1.016 seconds,  157.508 MB/s Cycles per byte =  13.90
AES-192-GCM-enc    150 MB took 1.022 seconds,  146.815 MB/s Cycles per byte =  14.91
AES-192-GCM-dec    150 MB took 1.039 seconds,  144.419 MB/s Cycles per byte =  15.16
AES-256-GCM-enc    130 MB took 1.017 seconds,  127.889 MB/s Cycles per byte =  17.12
AES-256-GCM-dec    140 MB took 1.030 seconds,  135.943 MB/s Cycles per byte =  16.10
GMAC Table 4-bit   321 MB took 1.002 seconds,  320.457 MB/s Cycles per byte =   6.83
CHACHA             420 MB took 1.002 seconds,  419.252 MB/s Cycles per byte =   5.22
CHA-POLY           330 MB took 1.013 seconds,  325.735 MB/s Cycles per byte =   6.72
MD5                655 MB took 1.007 seconds,  650.701 MB/s Cycles per byte =   3.36
POLY1305          1490 MB took 1.002 seconds, 1486.840 MB/s Cycles per byte =   1.47
SHA                560 MB took 1.004 seconds,  557.620 MB/s Cycles per byte =   3.93
SHA-224            240 MB took 1.011 seconds,  237.474 MB/s Cycles per byte =   9.22
SHA-256            250 MB took 1.020 seconds,  245.081 MB/s Cycles per byte =   8.93
SHA-384            380 MB took 1.005 seconds,  377.963 MB/s Cycles per byte =   5.79
SHA-512            380 MB took 1.007 seconds,  377.260 MB/s Cycles per byte =   5.80
SHA3-224           385 MB took 1.009 seconds,  381.679 MB/s Cycles per byte =   5.74
SHA3-256           360 MB took 1.004 seconds,  358.583 MB/s Cycles per byte =   6.11
SHA3-384           270 MB took 1.020 seconds,  264.606 MB/s Cycles per byte =   8.27
SHA3-512           185 MB took 1.019 seconds,  181.573 MB/s Cycles per byte =  12.06
HMAC-MD5           665 MB took 1.004 seconds,  662.154 MB/s Cycles per byte =   3.31
HMAC-SHA           590 MB took 1.004 seconds,  587.535 MB/s Cycles per byte =   3.73
HMAC-SHA224        240 MB took 1.018 seconds,  235.850 MB/s Cycles per byte =   9.28
HMAC-SHA256        245 MB took 1.013 seconds,  241.805 MB/s Cycles per byte =   9.05
HMAC-SHA384        365 MB took 1.006 seconds,  362.678 MB/s Cycles per byte =   6.04
HMAC-SHA512        365 MB took 1.009 seconds,  361.674 MB/s Cycles per byte =   6.05
PBKDF2              30 KB took 1.000 seconds,   29.956 KB/s Cycles per byte = 74838.56
RSA     2048 public      18400 ops took 1.004 sec, avg 0.055 ms, 18335.019 ops/sec
RSA     2048 private       300 ops took 1.215 sec, avg 4.050 ms, 246.891 ops/sec
DH      2048 key gen      1746 ops took 1.000 sec, avg 0.573 ms, 1745.991 ops/sec
DH      2048 agree         900 ops took 1.060 sec, avg 1.178 ms, 849.210 ops/sec
ECC   [      SECP256R1]   256 key gen       901 ops took 1.000 sec, avg 1.110 ms, 900.779 ops/sec
ECDHE [      SECP256R1]   256 agree        1000 ops took 1.105 sec, avg 1.105 ms, 904.767 ops/sec
ECDSA [      SECP256R1]   256 sign          900 ops took 1.022 sec, avg 1.135 ms, 880.674 ops/sec
ECDSA [      SECP256R1]   256 verify       1300 ops took 1.012 sec, avg 0.779 ms, 1284.509 ops/sec
Benchmark complete
```

This is especially useful for comparing the public key speed before and after changing the math library. You can test the results using the normal math library (`./configure`), the fastmath library (`./configure --enable-fastmath`), and the fasthugemath library (`./configure --enable-fasthugemath`).

For more details and benchmark results, please refer to the wolfSSL Benchmarks page: <https://www.wolfssl.com/docs/benchmarks>

### Relative Performance

Although the performance of individual ciphers and algorithms will depend on the host platform, the following graph shows relative performance between wolfCrypt’s ciphers. These tests were conducted on a Macbook Pro (OS X 10.6.8) running a 2.2 GHz Intel Core i7.

![Benchmark](benchmark.png)

If you want to use only a subset of ciphers, you can customize which specific cipher suites and/or ciphers wolfSSL uses when making an SSL/TLS connection. For example, to force 128-bit AES, add the following line after the call to [`wolfSSL_CTX_new(SSL_CTX_new)`](group__Setup.md#function-wolfssl_ctx_new):

```c
wolfSSL_CTX_set_cipher_list(ctx, “AES128-SHA”);
```

### Benchmarking Notes

1. The processors native register size (32 vs 64-bit) can make a big difference when doing 1000+ bit public key operations.
2. **keygen** (`--enable-keygen`) will allow you to also benchmark key generation speeds when running the benchmark utility.
3. **fastmath** (`--enable-fastmath`) reduces dynamic memory usage and speeds up public key operations. If you are having trouble building on 32-bit platform with fastmath, disable shared libraries so that PIC isn’t hogging a register (also see notes in the README):

    ```sh
    ./configure --enable-fastmath --disable-shared
    make clean
    make
    ```

    **Note**: doing a `make clean` is good practice with wolfSSL when switching configure options.
4. By default, fastmath tries to use assembly optimizations if possible. If assembly optimizations don’t work, you can still use fastmath without them by adding `TFM_NO_ASM` to `CFLAGS` when building wolfSSL:

    ```sh
    ./configure --enable-fastmath C_EXTRA_FLAGS=”-DTFM_NO_ASM”
    ```

5. Using fasthugemath can try to push fastmath even more for users who are not running on embedded platforms:

    ```sh
    ./configure --enable-fasthugemath
    ```

6. With the default wolfSSL build, we have tried to find a good balance between memory usage and performance. If you are more concerned about one of the two, please refer back to [Build Options](chapter02.md#build-options) for additional wolfSSL configuration options.
7. **Bulk Transfers**: wolfSSL by default uses 128 byte I/O buffers since about 80% of SSL traffic falls within this size and to limit dynamic memory use. It can be configured to use 16K buffers (the maximum SSL size) if bulk transfers are required.

### Benchmarking on Embedded Systems

There are several build options available to make building the benchmark application on an embedded system easier. These include:

#### BENCH_EMBEDDED

Enabling this define will switch the benchmark application from using Megabytes to using Kilobytes, therefore reducing the memory usage. By default, when using this define, ciphers and algorithms will be benchmarked with 25kB. Public key algorithms will only be benchmarked over 1 iteration (as public key operations on some embedded processors can be fairly slow). These can be adjusted in `benchmark.c` by altering the variables `numBlocks` and `times` located inside the `BENCH_EMBEDDED` define.

#### USE_CERT_BUFFERS_1024

Enabling this define will switch the benchmark application from loading test keys and certificates from the file system and instead use 1024-bit key and certificate buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. It is useful to use this define when an embedded platform has no filesystem (used with [`NO_FILESYSTEM`](chapter02.md#no_filesystem)) and a slow processor where 2048-bit public key operations may not be reasonable.

#### USE_CERT_BUFFERS_2048

Enabling this define is similar to [`USE_CERT_BUFFERS_1024`](#use_cert_buffers_1024) accept that 2048-bit key and certificate buffers are used instead of 1024-bit ones. This define is useful when the processor is fast enough to do
2048-bit public key operations but when there is no filesystem available to load keys and certificates from files.

## Changing a Client Application to Use wolfSSL

This section will explain the basic steps needed to add wolfSSL to a client application, using the wolfSSL native API. For a server explanation, please see [Changing a Server Application to Use wolfSSL](#changing-a-server-application-to-use-wolfssl). A more complete walk-through with example code is located in the SSL Tutorial in Chapter 11. If you want more information about the OpenSSL compatibility layer, please see [OpenSSL Compatibility](chapter13.md#openssl-compatibility).

1. Include the wolfSSL header:

    ```c
    #include <wolfssl/ssl.h>
    ```

2. Initialize wolfSSL and the `WOLFSSL_CTX`. You can use one `WOLFSSL_CTX` no matter how many WOLFSSL objects you end up creating. Basically you'll just need to load CA certificates to verify the server you are connecting to. Basic initialization looks like:

    ```c
    wolfSSL_Init();
    WOLFSSL_CTX* ctx;
    if ((ctx = wolfSSL_CTX_new(wolfTLSv1_client_method())) == NULL)
    {
        fprintf(stderr, "wolfSSL_CTX_new error.\n");
        exit(EXIT_FAILURE);
    }
    if (wolfSSL_CTX_load_verify_locations(ctx,"./ca-cert.pem",0) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./ca-cert.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    ```

3. Create the WOLFSSL object after each TCP connect and associate the file descriptor with the session:

    ```c
    /*after connecting to socket fd*/
    WOLF SSL* ssl;
    if ((ssl = wolfSSL_new(ctx)) == NULL) {
        fprintf(stderr, "wolfSSL_new error.\n");
        exit(EXIT_FAILURE);
    }
    wolfSSL_set_fd(ssl, fd);
    ```

4. Change all calls from `read()` (or `recv()`) to [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) so:

    ```c
    result = read(fd, buffer, bytes);
    ```

    becomes:

    ```c
    result = wolfSSL_read(ssl, buffer, bytes);
    ```

5. Change all calls from `write()` (or `send()`) to [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) so:

    ```c
    result = write(fd, buffer, bytes);
    ```

    becomes

    ```c
    result = wolfSSL_write(ssl, buffer, bytes);
    ```

6. You can manually call [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) but that's not even necessary; the first call to [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) or [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) will initiate the [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) if it hasn't taken place yet.
7. Error checking. Each [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) and [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) call will return the number of bytes written upon success, 0 upon connection closure, and -1 for an error, just like `read()` and `write()`. In the event of an error you can use two calls to get more information about the error:

    ```c
    char errorString[80];
    int err = wolfSSL_get_error(ssl, 0);
    wolfSSL_ERR_error_string(err, errorString);
    ```

    If you are using non-blocking sockets, you can test for errno `EAGAIN`/`EWOULDBLOCK` or more correctly you can test the specific error code returned by [`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error) for `SSL_ERROR_WANT_READ` or`SSL_ERROR_WANT_WRITE`.
8. Cleanup. After each WOLFSSL object is done being used you can free it up by
calling:

    ```c
    wolfSSL_free(ssl);
    ```

    When you are completely done using SSL/TLS altogether you can free the `WOLFSSL_CTX` object by calling:

    ```c
    wolfSSL_CTX_free(ctx);
    wolfSSL_Cleanup();
    ```

    For an example of a client application using wolfSSL, see the client example located in the `<wolfssl_root>/examples/client.c` file.

## Changing a Server Application to Use wolfSSL

This section will explain the basic steps needed to add wolfSSL to a server application using the wolfSSL native API. For a client explanation, please see [Changing a Client Application to Use wolfSSL](#changing-a-client-application-to-use-wolfssl). A more complete walk-through, with example code, is located in the [SSL Tutorial](chapter11.md#ssl-tutorial) chapter.

1. Follow the instructions above for a client, except change the client method call in step 5 to a server one, so:

    ```c
    wolfSSL_CTX_new(wolfTLSv1_client_method());
    ```

    becomes:

    ```c
    wolfSSL_CTX_new(wolfTLSv1_server_method());
    ```

    or even:

    ```c
    wolfSSL_CTX_new(wolfSSLv23_server_method());
    ```

    To allow SSLv3 and TLSv1+ clients to connect to the server.
2. Add the server's certificate and key file to the initialization in step 5 above:

    ```c
    if (wolfSSL_CTX_use_certificate_file(ctx,"./server-cert.pem", SSL_FILETYPE_PEM) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./server-cert.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    if (wolfSSL_CTX_use_PrivateKey_file(ctx,"./server-key.pem", SSL_FILETYPE_PEM) != SSL_SUCCESS) {
        fprintf(stderr, "Error loading ./server-key.pem,"
                        " please check the file.\n");
        exit(EXIT_FAILURE);
    }
    ```

It is possible to load certificates and keys from buffers as well if there is no filesystem available. In this case, see the [`wolfSSL_CTX_use_certificate_buffer()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_buffer) and [`wolfSSL_CTX_use_PrivateKey_buffer()`](group__CertsKeys.md#function-wolfssl_ctx_use_privatekey_buffer) API documentation, linked here, for more information.

For an example of a server application using wolfSSL, see the server example located in the `<wolfssl_root>/examples/server.c` file.
