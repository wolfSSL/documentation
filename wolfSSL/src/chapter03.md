# Getting Started

## General Description

wolfSSL (formerly CyaSSL) is up to 20 times smaller than OpenSSL when using the compile options described in [Chapter 2](chapter02.md#building-wolfssl). User benchmarking and feedback also reports dramatically better performance from wolfSSL vs. OpenSSL in the vast majority of standard SSL operations.

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

`make test` is an alias for `make check`. It runs the testsuite, the unit tests (`tests/unit.test`) and the test scripts under the automake test harness, so the console only shows a PASS/FAIL line for each test. The output of each test is written to a log file next to it, for example `testsuite/testsuite.log`. The `testsuite.test` program on its own does not run the unit tests.

On \*nix or Windows the examples and testsuite will check to see if the current directory is the source directory and if so, attempt to change to the wolfSSL home directory. This should work in most setup cases, if not, just use the first method above and specify the full path.

On a successful run of `./testsuite/testsuite.test` you should see output like this (wolfSSL 5.9.4, default `./configure` build on macOS/arm64; the list of tests depends on the algorithms enabled in the build):

```text
------------------------------------------------------------------------------
 wolfSSL version 5.9.4
------------------------------------------------------------------------------
macro    test passed!
error    test passed!
WCFLAGS  test passed!
MEMORY   test passed!
octets   test passed!
base64   test passed!
asn      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-512/224  test passed!
SHA-512/256  test passed!
SHA-3    test passed!
RANDOM   test passed!
RNGTHRD  test passed!
RNGSVC   test passed!
RNGEPOCH test passed!
RNGLIFE  test passed!
SHAKE128 test passed!
SHAKE256 test passed!
Hash     test passed!
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
AES-CBC  test passed!
AES-GCM  test passed!
RSA      test passed!
DH       test passed!
PWDBASED test passed!
ECC      test passed!
MLKEM    test passed!
logging  test passed!
time     test passed!
mutex    test passed!
memcb    test passed!
Test complete

Running simple test
listening on port 53227
connecting to 127.0.0.1:53227
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
Client message: hello wolfssl!
I hear you fa shizzle!
listening on port 53229

Running TLS test
connecting to 127.0.0.1:53229
connecting to 127.0.0.1:53229
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers = TLS13-AES128-GCM-SHA256:TLS13-AES256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /tmp/testsuite-output-4m4wH7

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
wolfSSL client 5.9.4 NOTE: All files relative to wolfSSL home dir
Max RSA key size in bits for build is set at : INFINITE
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
-m          Match domain name in cert
-N          Use Non-blocking sockets
-r          Resume session
-w          Wait for bidirectional shutdown
-M <prot>   Use STARTTLS, using <prot> protocol (smtp)
-f          Fewer packets/group messages
-x          Disable client cert/key loading
-X          Driven by eXternal test case
-j          Use verify callback override
-S <str>    Use Host Name Indication
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
--pqc <alg> Key Share with specified post-quantum algorithm only:
            ML_KEM_512, ML_KEM_768, ML_KEM_1024,
            SecP256r1MLKEM512,
            SecP384r1MLKEM768,
            SecP521r1MLKEM1024,
            SecP256r1MLKEM768,
            SecP521r1MLKEM1024,
            SecP384r1MLKEM1024,
            X25519MLKEM512,
            X25519MLKEM768,
            X448MLKEM768
--sys-ca-certs Load system CA certs for server cert verification
--onlyPskDheKe Must use DHE key exchange with PSK
--files-are-der Specified files are in DER, not PEM format

For simpler wolfSSL TLS client examples, visit
https://github.com/wolfSSL/wolfssl-examples/tree/master/tls
```

The options shown depend on the build. For example, `-u` (DTLS) is only listed when wolfSSL is built with DTLS support.

To test against www.google.com:443 try the following:

```sh
./examples/client/client -h www.google.com -p 443 -d -g -S www.google.com
```

Which returns (wolfSSL 5.9.4, default build; the HTTP response is cut short here):

```text
connecting to www.google.com:443
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
SSL curve name is SECP256R1
SSL connect ok, sending GET...
HTTP/1.0 200 OK
Content-Type: text/html; charset=ISO-8859-1
Date: Fri, 06 Nov 2026 09:09:56 GMT
Expires: -1
Cache-Control: private, max-age=0
...
```

This tells the client to connect to (`-h`) www.google.com on the HTTPS port (`-p`) of 443 and sends a generic (`-g`) GET request. The (`-d`) option tells the client not to verify the server, and (`-S`) sends the host name in the Server Name Indication (SNI) extension, which most public servers require. The rest is the initial output from the server that fits into the read buffer. When wolfSSL is built with `--enable-opensslextra`, the client also prints details of the server certificate, such as its issuer, subject and alternative names.

If no command line arguments are given, then the client attempts to connect to the localhost on the wolfSSL default port of 11111. It also loads the client certificate in case the server wants to perform client authentication.

The client is able to benchmark a connection when using the `-b <num>` argument. When used, the client attempts to connect to the specified server/port the argument number of times and gives the average time in milliseconds that it took to perform `SSL_connect()`. For example:

```sh
./examples/client/client -b 100 -h www.google.com -p 443 -d -S www.google.com
```

Returns:

```text
connecting to www.google.com:443
wolfSSL_connect avg took:   41.054 milliseconds
```

If you'd like to change the default host from localhost, or the default port from 11111, you can change these settings in `wolfssl/test.h`. The variables wolfSSLIP and wolfSSLPort control these settings. Re-build all of the examples including testsuite when changing these settings otherwise the test programs won't be able to connect to each other.

By default, the wolfSSL example client tries to connect to the specified server using TLS 1.2. The user is able to change the SSL/TLS version which the client uses by passing the `-v` command line option. The following values are available for this option:

* `-v 0` - SSL 3.0 (disabled by default, needs `--enable-sslv3`)
* `-v 1` - TLS 1.0 (disabled by default, needs `--enable-tlsv10`)
* `-v 2` - TLS 1.1 (disabled by default, needs `--enable-oldtls`)
* `-v 3` - TLS 1.2 (selected by default)
* `-v 4` - TLS 1.3

A common error users see when using the example client is -188:

```text
wolfSSL_connect error -188, ASN no signer error to confirm failure
wolfSSL error, examples/client/client.c L 4422: wolfSSL_connect failed
```

This is typically caused by the wolfSSL client not being able to verify the certificate of the server it is connecting to. By default, the wolfSSL client loads the wolfSSL test CA certificate (`./certs/ca-cert.pem`) as a trusted root certificate. This test CA certificate will not be able to verify an external server certificate which was signed by a different CA. As such, to solve this problem, users either need to turn off verification of the peer (server), using the `-d` option:

```sh
./examples/client/client -h myhost.com -p 443 -d -S myhost.com
```

Or load the correct CA certificate into the wolfSSL client using the `-A` command line option:

```sh
./examples/client/client -h myhost.com -p 443 -A serverCA.pem -S myhost.com
```

Alternatively, the `--sys-ca-certs` option loads the CA certificates of the operating system's trust store.

## Server Example

The server example demonstrates a simple SSL server that optionally performs client authentication. Only one client connection is accepted and then the server quits. By default the server requests a client certificate and the client loads `./certs/client-cert.pem`, so the client example works against the example server with or without other command line arguments. If the client is run with `-x` (or with `-s` for PSK, in builds with PSK support), no client certificate is sent, [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) fails and the server reports the error "-345, peer did not return a certificate". To allow such connections, start the server with `-d` to disable the client certificate check. Like the example client, the server can be used with several
command line arguments as well:

```sh
./examples/server/server --help
```

Which returns:

```text
server 5.9.4 NOTE: All files relative to wolfSSL home dir
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
-f          Fewer packets/group messages
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
--pqc <alg> Key Share with specified post-quantum algorithm only:
            ML_KEM_512, ML_KEM_768, ML_KEM_1024,
            SecP256r1MLKEM512,
            SecP384r1MLKEM768,
            SecP521r1MLKEM1024,
            SecP256r1MLKEM768,
            SecP521r1MLKEM1024,
            SecP384r1MLKEM1024,
            X25519MLKEM512,
            X25519MLKEM768,
            X448MLKEM768
--force-curve [<curve>] Pre-generate a Key Share using <curve>.
                        Leave <curve> blank to list all curves.
                        Note: requires TLS1.3
--onlyPskDheKe Must use DHE key exchange with PSK

For simpler wolfSSL TLS server examples, visit
https://github.com/wolfSSL/wolfssl-examples/tree/master/tls
```

## EchoServer Example

The echoserver example sits in an endless loop waiting for an unlimited number of client connections. Whatever the client sends the echoserver echoes back. Client authentication isn't performed so the example client can be used against the echoserver in all 3 modes. Four special commands aren't echoed back and instruct the echoserver to take a different action.

1. `quit` - If the echoserver receives the string "quit" it will shutdown.
2. `break` If the echoserver receives the string "break" it will stop the current session but continue handling requests. This is particularly useful for DTLS testing.
3. `printstats` - If the echoserver receives the string "printstats" it will print out statistics for the session cache. This command is only available when wolfSSL is built with `PRINT_SESSION_STATS`.
4. `GET` - If the echoserver receives the string "GET" it will handle it as an http get and send back a simple page with the message "greetings from wolfSSL". This allows testing of various TLS/SSL clients like Safari, IE, Firefox, gnutls, and the like against the echoserver example.

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

The benchmark utility located in wolfcrypt/benchmark (`./wolfcrypt/benchmark/benchmark`) may be used to benchmark the cryptographic functionality of wolfCrypt. Typical output may look like the following (wolfSSL 5.9.4, default `./configure` build on an Apple M5 running macOS 27.2; the algorithms listed depend on the build options):

```sh
./wolfcrypt/benchmark/benchmark
```

```text
------------------------------------------------------------------------------
 wolfSSL version 5.9.4
------------------------------------------------------------------------------
Clock frequency: 1000000000 Hz
Math:   Multi-Precision: Wolf(SP) no-dyn-stack word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
RNG SHA-256 DRBG           185 MiB took 1.003 seconds,  184.426 MiB/s Cycles per byte =   5.17
RNG SHA-512 DRBG           365 MiB took 1.011 seconds,  360.988 MiB/s Cycles per byte =   2.64
AES-128-CBC-enc            410 MiB took 1.002 seconds,  409.322 MiB/s Cycles per byte =   2.33
AES-128-CBC-dec            555 MiB took 1.002 seconds,  553.772 MiB/s Cycles per byte =   1.72
AES-192-CBC-enc            350 MiB took 1.009 seconds,  346.999 MiB/s Cycles per byte =   2.75
AES-192-CBC-dec            445 MiB took 1.000 seconds,  444.947 MiB/s Cycles per byte =   2.14
AES-256-CBC-enc            305 MiB took 1.012 seconds,  301.402 MiB/s Cycles per byte =   3.16
AES-256-CBC-dec            375 MiB took 1.009 seconds,  371.520 MiB/s Cycles per byte =   2.57
AES-128-GCM-enc            250 MiB took 1.017 seconds,  245.809 MiB/s Cycles per byte =   3.88
AES-128-GCM-dec            165 MiB took 1.022 seconds,  161.425 MiB/s Cycles per byte =   5.91
AES-192-GCM-enc            225 MiB took 1.022 seconds,  220.209 MiB/s Cycles per byte =   4.33
AES-192-GCM-dec            155 MiB took 1.030 seconds,  150.413 MiB/s Cycles per byte =   6.34
AES-256-GCM-enc            205 MiB took 1.010 seconds,  203.043 MiB/s Cycles per byte =   4.70
AES-256-GCM-dec            140 MiB took 1.006 seconds,  139.127 MiB/s Cycles per byte =   6.85
GMAC Table 4-bit           650 MiB took 1.004 seconds,  647.435 MiB/s Cycles per byte =   1.47
CHACHA                     920 MiB took 1.002 seconds,  918.530 MiB/s Cycles per byte =   1.04
CHA-POLY-enc               715 MiB took 1.005 seconds,  711.090 MiB/s Cycles per byte =   1.34
CHA-POLY-dec               715 MiB took 1.001 seconds,  714.528 MiB/s Cycles per byte =   1.33
CHA-POLY-ex-enc            715 MiB took 1.006 seconds,  710.450 MiB/s Cycles per byte =   1.34
CHA-POLY-ex-dec            715 MiB took 1.004 seconds,  711.842 MiB/s Cycles per byte =   1.34
CHA-POLY-stream            710 MiB took 1.004 seconds,  707.218 MiB/s Cycles per byte =   1.35
POLY1305                  3140 MiB took 1.001 seconds, 3136.763 MiB/s Cycles per byte =   0.30
SHA                       1020 MiB took 1.000 seconds, 1019.620 MiB/s Cycles per byte =   0.94
SHA-224                    420 MiB took 1.011 seconds,  415.574 MiB/s Cycles per byte =   2.29
SHA-256                    425 MiB took 1.001 seconds,  424.512 MiB/s Cycles per byte =   2.25
SHA-384                    815 MiB took 1.004 seconds,  811.742 MiB/s Cycles per byte =   1.17
SHA-512                    810 MiB took 1.001 seconds,  809.112 MiB/s Cycles per byte =   1.18
SHA-512/224                810 MiB took 1.001 seconds,  808.822 MiB/s Cycles per byte =   1.18
SHA-512/256                820 MiB took 1.002 seconds,  818.167 MiB/s Cycles per byte =   1.17
SHA3-224                   800 MiB took 1.006 seconds,  795.431 MiB/s Cycles per byte =   1.20
SHA3-256                   740 MiB took 1.006 seconds,  735.729 MiB/s Cycles per byte =   1.30
SHA3-384                   545 MiB took 1.000 seconds,  544.920 MiB/s Cycles per byte =   1.75
SHA3-512                   400 MiB took 1.007 seconds,  397.202 MiB/s Cycles per byte =   2.40
SHAKE128                   920 MiB took 1.002 seconds,  918.619 MiB/s Cycles per byte =   1.04
SHAKE256                   725 MiB took 1.004 seconds,  722.403 MiB/s Cycles per byte =   1.32
HMAC-SHA                  1005 MiB took 1.004 seconds, 1000.948 MiB/s Cycles per byte =   0.95
HMAC-SHA224                445 MiB took 1.005 seconds,  442.654 MiB/s Cycles per byte =   2.15
HMAC-SHA256                435 MiB took 1.000 seconds,  434.933 MiB/s Cycles per byte =   2.19
HMAC-SHA384                805 MiB took 1.002 seconds,  803.179 MiB/s Cycles per byte =   1.19
HMAC-SHA512                835 MiB took 1.005 seconds,  831.031 MiB/s Cycles per byte =   1.15
HMAC-SHA3-256              745 MiB took 1.005 seconds,  741.425 MiB/s Cycles per byte =   1.29
HMAC-SHA3-384              565 MiB took 1.007 seconds,  561.258 MiB/s Cycles per byte =   1.70
HMAC-SHA3-512              400 MiB took 1.003 seconds,  398.649 MiB/s Cycles per byte =   2.39
PBKDF2                      52 KiB took 1.000 seconds,   52.168 KiB/s Cycles per byte = 18719.41
RSA     2048   public     45000 ops took 1.002 sec, avg 0.022 ms, 44918.330 ops/sec, 1001813204 cycles    22262.5 Cycles/op
RSA     2048  private       900 ops took 1.104 sec, avg 1.226 ms,   815.405 ops/sec, 1103740290 cycles  1226378.1 Cycles/op
DH      2048  key gen      4029 ops took 1.000 sec, avg 0.248 ms,  4028.818 ops/sec, 1000040018 cycles   248210.5 Cycles/op
DH      2048    agree      2000 ops took 1.044 sec, avg 0.522 ms,  1915.270 ops/sec, 1044233571 cycles   522116.8 Cycles/op
ML-KEM 512    128  key gen    194800 ops took 1.000 sec, avg 0.005 ms, 194760.624 ops/sec, 1000196207 cycles     5134.5 Cycles/op
ML-KEM 512    128    encap    171800 ops took 1.000 sec, avg 0.006 ms, 171751.394 ops/sec, 1000278450 cycles     5822.3 Cycles/op
ML-KEM 512    128    decap    128500 ops took 1.001 sec, avg 0.008 ms, 128431.043 ops/sec, 1000531132 cycles     7786.2 Cycles/op
ML-KEM 768    192  key gen    116100 ops took 1.000 sec, avg 0.009 ms, 116053.350 ops/sec, 1000397186 cycles     8616.7 Cycles/op
ML-KEM 768    192    encap    103000 ops took 1.000 sec, avg 0.010 ms, 102998.330 ops/sec, 1000011518 cycles     9708.8 Cycles/op
ML-KEM 768    192    decap     79800 ops took 1.001 sec, avg 0.013 ms, 79713.906 ops/sec, 1001074199 cycles    12544.8 Cycles/op
ML-KEM 1024   256  key gen     69600 ops took 1.001 sec, avg 0.014 ms, 69559.733 ops/sec, 1000573649 cycles    14376.1 Cycles/op
ML-KEM 1024   256    encap     62800 ops took 1.000 sec, avg 0.016 ms, 62785.555 ops/sec, 1000225082 cycles    15927.2 Cycles/op
ML-KEM 1024   256    decap     51000 ops took 1.001 sec, avg 0.020 ms, 50931.186 ops/sec, 1001346399 cycles    19634.2 Cycles/op
ECC   [      SECP256R1]   256  key gen      4900 ops took 1.018 sec, avg 0.208 ms,  4813.075 ops/sec, 1018054865 cycles   207766.3 Cycles/op
ECDHE [      SECP256R1]   256    agree      4900 ops took 1.019 sec, avg 0.208 ms,  4807.188 ops/sec, 1019301669 cycles   208020.7 Cycles/op
ECDSA [      SECP256R1]   256     sign      4700 ops took 1.006 sec, avg 0.214 ms,  4671.788 ops/sec, 1006034629 cycles   214049.9 Cycles/op
ECDSA [      SECP256R1]   256   verify      7100 ops took 1.003 sec, avg 0.141 ms,  7077.105 ops/sec, 1003229363 cycles   141299.9 Cycles/op
RNG      256 SHA256 Init/Free  68425 ops took 1.000 sec, avg 0.015 ms, 68424.527 ops/sec, 1000002084 cycles    14614.6 Cycles/op
RNG      512 SHA512 Init/Free  86827 ops took 1.000 sec, avg 0.012 ms, 86826.752 ops/sec, 999998750 cycles    11517.1 Cycles/op
Benchmark complete
```

This is especially useful for comparing the public key speed before and after changing the math library. The "Math:" line shows which math library the build uses. You can compare the default SP math library (`./configure`, which uses `sp_int.c`), the optimized SP code for common key sizes and curves (`./configure --enable-sp --enable-sp-asm`), and, if needed, the legacy fastmath library (`./configure --enable-fastmath`).

For more details and benchmark results, please refer to the wolfSSL Benchmarks page: <https://www.wolfssl.com/docs/benchmarks>

### Relative Performance

Although the performance of individual ciphers and algorithms will depend on the host platform, the following graph shows relative performance between wolfCrypt's ciphers. This is a historical graph from an early wolfSSL release, measured on a Macbook Pro (OS X 10.6.8) running a 2.2 GHz Intel Core i7, and it does not include newer algorithms such as SHA-3 or ML-KEM. For current results, see the wolfSSL Benchmarks page: <https://www.wolfssl.com/docs/benchmarks>

![Benchmark](benchmark.png)

If you want to use only a subset of ciphers, you can customize which specific cipher suites and/or ciphers wolfSSL uses when making an SSL/TLS connection. For example, to force 128-bit AES with TLS 1.2, add the following line after the call to [`wolfSSL_CTX_new(SSL_CTX_new)`](group__Setup.md#function-wolfssl_ctx_new):

```c
wolfSSL_CTX_set_cipher_list(ctx, "ECDHE-RSA-AES128-GCM-SHA256");
```

For TLS 1.3, use the TLS 1.3 suite name instead, for example `"TLS13-AES128-GCM-SHA256"`. Static RSA key exchange suites such as `AES128-SHA` are only available when wolfSSL is built with `WOLFSSL_STATIC_RSA`.

### Benchmarking Notes

1. The processors native register size (32 vs 64-bit) can make a big difference when doing 1000+ bit public key operations.
2. **keygen** (`--enable-keygen`) will allow you to also benchmark RSA key generation speeds when running the benchmark utility. ECC, DH and ML-KEM key generation are benchmarked without it.
3. **fastmath** (`--enable-fastmath`) is a legacy math library; the default SP math library is recommended. Items 3 to 5 only apply to builds that use fastmath. Fastmath reduces dynamic memory usage and speeds up public key operations. If you are having trouble building on 32-bit platform with fastmath, disable shared libraries so that PIC isn't hogging a register (also see notes in the README):

    ```sh
    ./configure --enable-fastmath --disable-shared
    make clean
    make
    ```

    **Note**: doing a `make clean` is good practice with wolfSSL when switching configure options.
4. By default, fastmath tries to use assembly optimizations if possible. If assembly optimizations don't work, you can still use fastmath without them by adding `TFM_NO_ASM` to `CFLAGS` when building wolfSSL:

    ```sh
    ./configure --enable-fastmath CFLAGS="-DTFM_NO_ASM"
    ```

5. Using fasthugemath can try to push fastmath even more for users who are not running on embedded platforms:

    ```sh
    ./configure --enable-fasthugemath
    ```

6. With the default wolfSSL build, we have tried to find a good balance between memory usage and performance. If you are more concerned about one of the two, please refer back to [Build Options](chapter02.md#build-options) for additional wolfSSL configuration options.
7. **Bulk Transfers**: By default the static part of the wolfSSL I/O buffers only holds a record header, and buffers for larger records are allocated dynamically when needed, to limit memory use. Defining `LARGE_STATIC_BUFFERS` makes the static buffers large enough for a full 16 KB record (the maximum TLS record size), which can help if bulk transfers are required.

### Benchmarking on Embedded Systems

There are several build options available to make building the benchmark application on an embedded system easier. These include:

#### BENCH_EMBEDDED

Enabling this define will switch the benchmark application from using Megabytes to using Kilobytes, therefore reducing the memory usage. By default, when using this define, ciphers and algorithms will be benchmarked with 25 blocks of 1 KiB (`NUM_BLOCKS` and `BENCH_SIZE`). Public key operations are run in batches of `BENCH_NTIMES` iterations, and key agreement in batches of `BENCH_AGREETIMES`, both 2 by default instead of 100 (as public key operations on some embedded processors can be fairly slow). Each algorithm is still run for at least one second (`BENCH_MIN_RUNTIME_SEC`). These values can be overridden at build time, for example with `-DBENCH_NTIMES=1`, and the block size and number of blocks can also be set at run time with the benchmark's `<num>` and `-blocks <num>` command line options, so there is no need to edit `benchmark.c`.

#### USE_CERT_BUFFERS_1024

Enabling this define will switch the benchmark application from loading test keys and certificates from the file system and instead use 1024-bit key and certificate buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. It is useful to use this define when an embedded platform has no filesystem (used with [`NO_FILESYSTEM`](chapter02.md#no_filesystem)) and a slow processor where 2048-bit public key operations may not be reasonable.

#### USE_CERT_BUFFERS_2048

Enabling this define is similar to [`USE_CERT_BUFFERS_1024`](#use_cert_buffers_1024) except that 2048-bit key and certificate buffers are used instead of 1024-bit ones. This define is useful when the processor is fast enough to do
2048-bit public key operations but when there is no filesystem available to load keys and certificates from files.

## Changing a Client Application to Use wolfSSL

This section will explain the basic steps needed to add wolfSSL to a client application, using the wolfSSL native API. For a server explanation, please see [Changing a Server Application to Use wolfSSL](#changing-a-server-application-to-use-wolfssl). A more complete walk-through with example code is located in the SSL Tutorial in Chapter 11. If you want more information about the OpenSSL compatibility layer, please see [OpenSSL Compatibility](chapter13.md#openssl-compatibility).

1. Include the wolfSSL headers. The build settings header must come before any other wolfSSL header so that the application and the library agree on the configuration (for example on structure layouts). For a library built with `./configure`, include `wolfssl/options.h`:

    ```c
    #include <wolfssl/options.h>
    #include <wolfssl/ssl.h>
    ```

    For a build that uses `user_settings.h`, define `WOLFSSL_USER_SETTINGS` for the application as well, and the wolfSSL headers will include `user_settings.h`. Alternatively, define `WOLFSSL_USE_OPTIONS_H` when compiling the application to have `wolfssl/options.h` included automatically.

2. Initialize wolfSSL and the `WOLFSSL_CTX`. You can use one `WOLFSSL_CTX` no matter how many WOLFSSL objects you end up creating. You'll just need to load CA certificates to verify the server you are connecting to. `wolfTLS_client_method()` (or the equivalent [`wolfSSLv23_client_method()`](group__Setup.md#function-wolfsslv23_client_method)) negotiates the highest protocol version that both sides support; use `wolfTLSv1_3_client_method()` or `wolfTLSv1_2_client_method()` to allow only one version. Basic initialization looks like:

    ```c
    wolfSSL_Init();
    WOLFSSL_CTX* ctx;
    if ((ctx = wolfSSL_CTX_new(wolfTLS_client_method())) == NULL)
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
    WOLFSSL* ssl;
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
7. Error checking. Each [`wolfSSL_read()`](group__IO.md#function-wolfssl_read) and [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) call will return the number of bytes read or written upon success, 0 upon connection closure, and -1 for an error, just like `read()` and `write()`. In the event of an error you can use two calls to get more information about the error:

    ```c
    char errorString[WOLFSSL_MAX_ERROR_SZ];
    int err = wolfSSL_get_error(ssl, 0);
    wolfSSL_ERR_error_string(err, errorString);
    ```

    If you are using non-blocking sockets, you can test for errno `EAGAIN`/`EWOULDBLOCK` or more correctly you can test the specific error code returned by [`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error) for `SSL_ERROR_WANT_READ` or`SSL_ERROR_WANT_WRITE`.
8. Cleanup. After each WOLFSSL object is done being used, call [`wolfSSL_shutdown()`](group__TLS.md#function-wolfssl_shutdown) to send a close_notify alert to the peer, and then free the object by
calling:

    ```c
    wolfSSL_shutdown(ssl);
    wolfSSL_free(ssl);
    ```

    When you are completely done using SSL/TLS altogether you can free the `WOLFSSL_CTX` object by calling:

    ```c
    wolfSSL_CTX_free(ctx);
    wolfSSL_Cleanup();
    ```

    For an example of a client application using wolfSSL, see the client example located in the `<wolfssl_root>/examples/client/client.c` file.

## Changing a Server Application to Use wolfSSL

This section will explain the basic steps needed to add wolfSSL to a server application using the wolfSSL native API. For a client explanation, please see [Changing a Client Application to Use wolfSSL](#changing-a-client-application-to-use-wolfssl). A more complete walk-through, with example code, is located in the [SSL Tutorial](chapter11.md#ssl-tutorial) chapter.

1. Follow the instructions above for a client, except change the client method call in step 2 to a server one, so:

    ```c
    wolfSSL_CTX_new(wolfTLS_client_method());
    ```

    becomes:

    ```c
    wolfSSL_CTX_new(wolfTLS_server_method());
    ```

    or the equivalent:

    ```c
    wolfSSL_CTX_new(wolfSSLv23_server_method());
    ```

    The version-flexible server method negotiates up to TLS 1.3. In a default build it accepts TLS 1.2 and TLS 1.3 clients; older protocol versions are only accepted if they are enabled when wolfSSL is built. To accept only one version, use a version-specific method such as `wolfTLSv1_3_server_method()`.
2. Add the server's certificate and key file to the initialization in step 2 above:

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

For an example of a server application using wolfSSL, see the server example located in the `<wolfssl_root>/examples/server/server.c` file.
