# Frequently Asked Questions

## How do I manage the build configuration for wolfSSL?

The MOST common issue we see is a mis-configuration between APP and Library. If you compile the
wolfSSL library independent of your application you MUST include the same configure options in
the application as were used in the library.

If building with “./configure” the build system will generate the file
`<wolf-root>/wolfssl/options.h` with all the settings needed for your application.
Simply add the lines:

```
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/ssl.h>
/* other wolf headers below */
```

If building the wolfSSL sources directly the options.h will not contain any generated
configuration. In that case our recommended option is to define the preprocessor macro
“WOLFSSL_USER_SETTINGS” in your project and create your own “user_settings.h” file. Make
sure the file is somewhere in your include path. You can use the same include pattern above,
but exclude the options.h.

Here are some example “user_settings.h” you can use for reference:

* Windows: /IDE/WIN/user_settings.h
* GCC ARM: /IDE/GCC-ARM/Header/user_settings.h
* NXP ARM: /IDE/ROWLEY-CROSSWORKS-ARM/user_settings.h
* Xcode: /IDE/XCODE/user_settings.h

## How do I find the correct CA certificate to load into a client for authenticating a SSL/TLS server?

How to find and load the correct CA (root) certificate into a client application or device can be
tricky at first.  First, users need to understand how wolfSSL verifies certificate chains.
[Section 7.3](https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-7-keys-and-certificates.html) of
the [wolfSSL Manual](https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-toc.html) explains
wolfSSL’s certificate validation process:

wolfSSL requires that only the top or **“root”** certificate in a chain to be loaded as a trusted
certificate in order to verify a certificate chain SO LONG as the server sends the complete chain.
This means that if you have a certificate chain ( **A** -> **B** -> **C** ), where C is signed
by B, and B is signed by A, wolfSSL only requires that **certificate A** be loaded as a trusted
certificate in order to verify the entire chain (A->B->C) assuming that the server sends both
(B -> C) in the handshake.

Let’s look at a simple example.  If a server certificate chain looks like this:

```
A
| ---- > B
       | ---- > C
```

The wolfSSL client should already have at least root **cert “A”** loaded as a trusted root (wolfSSL_CTX_load_verify_[ locations | buffer]).  When the client receives the server
cert chain (B -> C), it uses the verify certificate (A) to verify B, and if B has not been
previously loaded into wolfSSL as a trusted root, B gets stored in wolfSSL's internal cert chain.
If B is verified successfully, then it can be used to verify C.

Following this model, as long as root cert "A" has been loaded as a trusted root into the
wolfSSL client, the server certificate chain will still be able to be verified if the server
sends (A->B->C), or (B->C).  If the server ONLY sends (C), and not the intermediate certificate,
the chain will not be able to be verified unless the wolfSSL client has already loaded both A and
B as a trusted roots. You may call wolfSSL_CTX_load_verify_[ locations | buffer] as many times as
is necessary to load all of your trusted roots, wolfSSL will keep appending them into the trust
store.

Examples:

```
// Load a PEM formatted file:
wolfSSL_CTX_load_verify_locations(ctx, fileName, NULL);

// Load a DER formatted file:
wolfSSL_CTX_der_load_verify_locations(ctx, fileName, WOLFSSL_FILETYPE_ASN1);

// Load a DER formatted buffer:
wolfSSL_CTX_load_verify_buffer(ctx, buf, bufLength, WOLFSSL_FILETYPE_ASN1)

// Load ALL PEM files in a directory
wolfSSL_CTX_load_verify_locations(ctx, NULL, directoryName);
```

## How do I put my certificate into a buffer?

To generate a certificate buffer you will find a perl script `<wolfssl-root>/gencertbuf.pl`
(short for generate certificate buffers)

1. You would want to acquire your own certificate and place it in a location that suits your
needs. (We keep our test ones in `<wolfssl-root>/certs/` directory, feel free to also place your
valid ones there also).
2. Modify the above mentioned perl script and add your new certificate(s) to the appropriate
`@fileList` (1024 for 1024 bit RSA certs, 256 for ECC 256-bit certs... etc)
3. Re-run that script to re-generate the header file `<wolfssl-root>/wolfssl/certs_test.h`

You have to run this file manually IE: `perl gencertbuf.pl` OR `./gencertbuf.pl`

## How much Flash/RAM does wolfSSL use?

wolfSSL memory usage depends on how the library is configured when it is compiled and what features
you plan on using.  Many options exist to control the amount of memory the library uses. Please
[contact us](mailto:facts@wolfssl.com) for the wolfSSL Resource Use document.

The primary factors in peak resource usage are key size and the math library used. Fast math and
a larger key size increases resource utilization.

## Is it possible to use no dynamic memory with wolfSSL and/or wolfCrypt?

wolfSSL provides two mutually exclusive options to control the usage of dynamic memory. You can
configure wolfSSL with `--enable-staticmemory` or by defining the WOLFSSL_STATIC_MEMORY macro.
However, this feature is limited to basic TLS connections and currently is not supported
in wolfCrypt.  You can also define the macro `XMALLOC_USER` to have wolfSSL use your own
malloc function.

## How do I build wolfSSL on... (*NIX, Windows, Embedded device)?

Please see section 2 of the wolfSSL Manual located
[HERE](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html)
which covers building wolfSSL.

## How do I pull wolfSSL into my IDE project? What files and headers do I need?

wolfSSL provides the necessary project files for many popular IDEs.  You can find instructions for
these IDEs in the /IDE/ directory of the wolfSSL source.

src/*.c
wolfcrypt/src/*.c
wolfssl/*.h
wolfssl/wolfcrypt/*.h
Include path wolfssl root.

Further documentation on building wolfSSL on various platforms can be found in [Section 2.4 wolfSSL Manual](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html).

## Do you have benchmarks for my specific platform?

wolfSSL provides a benchmark application that can be compiled for any platform wolfSSL supports.
The benchmark application will run benchmarks on enabled algorithms. The application source is
located in wolfcrypt/benchmark/benchmark.c.  For *nix platforms, the benchmark can be ran using
./wolfcrypt/benchmark/benchmark. The benchmark is compiled by default.

If benchmarking on an embedded platform, define `BENCH_EMBEDDED`

For more details regarding benchmarking wolfSSL, please reference the [wolfSSL and wolfCrypt Benchmarks webpage](https://www.wolfssl.com/docs/benchmarks/).

## Why are there no common cipher suites found between my client/server when connecting?

Ensure that wolfSSL was configured and built with common cipher suites on both the client
and server. You can add additional cipher suites with configure options. You can view configure
options on *nix systems with ./`configure --help`

To view default cipher suite on *nix system use this command from `<wolfssl-root>` directory:

`./examples/client/client -e`

To view default cipher suites on windows system use this command from the directory where
client.exe is located:

`./client.exe -e`

```
nmap --script ssl-enum-ciphers -p 443 www.google.com
```

## Can I use a smaller maximum I/O record size than 16kB?

TLS specifies a fixed maximum record length of 2^14 bytes (~16kB).  wolfSSL provides two
options to use a smaller maximum record size. The first option is to configure wolfSSL with
`--enable-maxfragment`. This requires the client to make an additional call when connecting to a
server. The client needs to use either `wolfSSL_CTX_UseMaxFragment` or `wolfSSL_UseMaxFragment`.
The client should use the CTX method if they plan on making multiple connections to the same
server.

The other option is to define `MAX_RECORD_SIZE`.  In order to use this, however, both the client
and server needs to have the option set.  If the client is connecting to servers outside of your
control, this is not an option to use.

## How do I extract a public key from a X.509 certificate?

wolfSSL provides this functionality in its public API.  You can call `wolfssl_x509_get_pubkey()`
to return a WOLFSSL_EVP_PKEY pointer.  WOLFSSL_EVP_PKEY is a struct with several data members
related to the key.  You can access the key directly from this pointer. The declaration of the
struct can be found in `<wolfssl/ssl.h>`.

## Do you have examples of using SSL/TLS or cryptography?

wolfSSL maintains several examples for using the library on the official wolfSSL GitHub
repository. You can download the examples by cloning the repository at
[https://github.com/wolfSSL/wolfssl-examples](https://github.com/wolfSSL/wolfssl-examples).

Some of the more heavily trafficked directories are:

- [https://github.com/wolfSSL/wolfssl-examples/tree/master/tls](https://github.com/wolfSSL/wolfssl-examples/tree/master/tls)
- [https://github.com/wolfSSL/wolfssl-examples/tree/master/dtls](https://github.com/wolfSSL/wolfssl-examples/tree/master/dtls)
- [https://github.com/wolfSSL/wolfssl-examples/tree/master/certgen](https://github.com/wolfSSL/wolfssl-examples/tree/master/certgen)

There are currently examples of using algorithms (3DES, AES, and Camellia), examples of using TLS client and server, wolfSSL CertManager, and signatures and verification.

For users looking for a command line utility for wolfSSL, see the wolfCLU repository
([https://github.com/wolfSSL/wolfCLU](https://github.com/wolfSSL/wolfCLU)).

## Why won’t my application connect to a server, I have enabled required ciphers and protocol version...?

Some servers require specific TLS extensions and specific ECC curves to be enabled or they
will ignore any connection attempt outright regardless of supported ciphers and protocol version.
If you are building wolfSSL without the configure script (Makefile project, IDE project, etc),
please make sure you have defined `HAVE_TLS_EXTENSIONS` and `HAVE_SUPPORTED_CURVES`.

## How do I sign a certificate?

Signing certificates is a key feature of many secure protocols. wolfSSL provides API that are
capable of performing this action and make the process simple and painless. The key API that
implement this functionality are listed below:

* [wc_MakeCerReq](https://www.wolfssl.com/documentation/manuals/wolfssl/group__ASN.html#function-wc_makecertreq)
* [wc_SignCert](https://www.wolfssl.com/documentation/manuals/wolfssl/group__ASN.html#function-wc_signcert)

wolfSSL also maintains an example repository that shows these API in action, and provides the
context in which to use them. This is shown in the CSR example application, which is located
within `wolfssl-examples/certgen/`. To build and run the example, it requires wolfSSL to be built
and installed as well (with certain options). wolfSSL can be downloaded from the
[download page](https://www.wolfssl.com/download/), or from a git-clone command, while the examples
can be downloaded from a git-clone of the examples repository [https://github.com/wolfSSL/wolfssl-examples](https://github.com/wolfSSL/wolfssl-examples).

An example of cloning and then building wolfSSL with the examples is shown below:

```
# Download, build, and install wolfSSL
git clone https://github.com/wolfSSL/wolfssl #(if not downloaded from the download page)
cd wolfssl
./autogen.sh
./configure --enable-certgen --enable-certreq
make
sudo make install
cd ..

# Download and build the CSR example
git clone https://github.com/wolfSSL/wolfssl-examples
cd wolfssl-examples/certgen/
make

./csr_example
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIOkUjkguP0GTizna+13jooJu55sbQBsAqqkMZqjQeO55oAoGCCqGSM49
AwEHoUQDQgAEWYTvqyt3e3nLkIWqBhjmZcxLu8XcLN+mUW+g4dO5qdGxnKEYxaz1
3/K3dXlU75e3MlCIjC5gTiEuPbs3N+eIzw==
-----END EC PRIVATE KEY-----
-----BEGIN CERTIFICATE REQUEST-----
MIIBTDCB8wIBAjCBkDELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAk9SMREwDwYDVQQH
DAhQb3J0bGFuZDEQMA4GA1UECgwHd29sZlNTTDEUMBIGA1UECwwLRGV2ZWxvcG1l
bnQxGDAWBgNVBAMMD3d3dy53b2xmc3NsLmNvbTEfMB0GCSqGSIb3DQEJARYQaW5m
b0B3b2xmc3NsLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABFmE76srd3t5
y5CFqgYY5mXMS7vF3CzfplFvoOHTuanRsZyhGMWs9d/yt3V5VO+XtzJQiIwuYE4h
Lj27NzfniM+gADAKBggqhkjOPQQDAgNIADBFAiEAy8GSm89MAU69hKfp6rwaR3Eg
IjaBzRZ4VxRl22LQ+IcCIEiP9OLVIemAfZz2D26g/3oIF2ETjjwAhh8UpZSiJmdh
-----END CERTIFICATE REQUEST-----
```
