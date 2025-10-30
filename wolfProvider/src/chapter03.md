# Building wolfProvider

## Getting wolfProvider Source Code

The most recent version of wolfProvider can be obtained directly from wolfSSL Inc. Contact [facts@wolfssl.com](mailto:facts@wolfssl.com) for more information.

## wolfProvider Package Structure

The general wolfProvider package is structured as follows:

```
certs/                      (Test certificates and keys, used with unit tests)
debian/                     (Scripts for building Debian packages)
examples/                   (Code examples)
include/
    wolfprovider/           (wolfProvider header files)
IDE/                        (Integration examples)
scripts/                    (wolfProvider scripts for testing and building)
src/                        (wolfProvider source files)
test/                       (wolfProvider test files)
provider.conf               (Example OpenSSL config file using wolfProvider)
provider-fips.conf          (Example OpenSSL config file using wolfProvider FIPS)
user_settings.h             (EXAMPLE user_settings.h)
```
## Building on *nix
The quickest method is to use the `scripts/build-wolfprovider.sh` script as follows:

```
./scripts/build-wolfprovider.sh
```

It will clone, configure, compile, and install OpenSSL and wolfSSL with a default set of options. Two methods are available to override these defaults:

Setting the various environment variables prior to calling the script:

```
OPENSSL_TAG=openssl-3.2.0 WOLFSSL_TAG=v5.7.2-stable WOLFPROV_DEBUG=1 ./scripts/build-wolfprovider.sh
```

Specifying arguments for the script to parse:

```
./scripts/build-wolfprovider.sh --openssl-ver=openssl-3.2.0 --wolfssl-ver=v5.7.2-stable --debug
```

Of course, these methods can be combined to achieve the desired build combination as well.

For a full list of environment variables and script arguments do `./scripts/build-wolfprovider.sh --help`.

If desired, each component can be manually compiled using the following guide.

### Forcing use of wolfProvider via `--replace-default`
With stock OpenSSL, it's still possible to access the default provider delivered with OpenSSL, even with the proper configuration. For example, software may call into OpenSSL EVP functions with a specific provider context, similar to how the unit tests work:

```
osslLibCtx = OSSL_LIB_CTX_new();
osslProv = OSSL_PROVIDER_load(osslLibCtx, "default");
EVP_PKEY_keygen(osslLibCtx, &myKey);
```

For many use cases, this is not ideal because it allows calls to silently bypass wolfProvider and utilize OpenSSL cryptographic functions.

As an alternative, the OpenSSL build created by this repo can optionally disable the stock provider from OpenSSL and replace it with wolfProvider. We belive this to be a more robust way of ensuring wolfProvider is the crypto backend.

Use option `--replace-default` with `build-wolfprovider.sh` to enable this mode.

To check if OpenSSL contains this functionality, look for the `wolfProvider-replace-default` string in the version output for both OpenSSL and the libssl3 library as shown:

```
$ openssl version
OpenSSL 3.0.17+wolfProvider-replace-default 29 Oct 2025 (Library: OpenSSL 3.0.17+wolfProvider-replace-default 29 Oct 2025)
```

Note that libwolfssl and libwolfprov are agnostic of the `--replace-default` flag.

### Building Debian packages
*Note: wolfProvider supports Debian Bookworm only for the time being. Other versions of Debian and Ubuntu require minor porting.*

wolfProvider supports building .deb files for installation on Debian systems. To build the packages, run:

```
scripts/build-wolfprovider.sh --debian --replace-default
```

Upon build success, the .deb files are placed in the parent directory. When installing, install all `../*.deb` files with `apt` or `dpkg` to get the default replacement functionality. Alternatively, when using a pre-installed version of OpenSSL, install just the libwolfssl and libwolfprov packages from the parent directory.

### Building OpenSSL

A pre-installed version of OpenSSL may be used with wolfProvider, or OpenSSL can be recompiled for use with wolfProvider. General instructions for compiling OpenSSL on *nix-like platforms will be similar to the following. For complete and comprehensive OpenSSL build instructions, reference the OpenSSL INSTALL file and documentation.
```
git clone https://github.com/openssl/openssl.git
cd openssl
./config no-fips -shared
make
sudo make install
```

### Building wolfSSL

If using a FIPS-validated version of wolfSSL with wolfProvider, follow the build instructions provided with your specific FIPS validated source bundle and Security Policy. In addition to the correct “--enable-fips” configure option, wolfProvider will need wolfSSL to be compiled with “**WOLFSSL_PUBLIC_MP**” defined. For example, building the “wolfCrypt Linux FIPSv2” bundle on Linux:
```
cd wolfssl-X.X.X-commercial-fips-linuxv
./configure --enable-fips=v2 CFLAGS=”-DWOLFSSL_PUBLIC_MP”
make
./wolfcrypt/test/testwolfcrypt
< modify fips_test.c using verifyCore hash output from testwolfcrypt >
make
./wolfcrypt/test/testwolfcrypt
< all algorithms should PASS >
sudo make install
```

If available, it may be easier to instead `make` then run the `./fips-hash.sh` utility and then `make` once again. This utility automates the process of updating fips_test.c with the testwolfcrypt hash output.

To build non-FIPS wolfSSL for use with wolfProvider:
```
cd wolfssl-X.X.X

./configure --enable-opensslcoexist --enable-cmac --enable-keygen --enable-sha --enable-des3 --enable-aesctr --enable-aesccm --enable-x963kdf --enable-compkey CPPFLAGS="-DHAVE_AES_ECB -DWOLFSSL_AES_DIRECT -DWC_RSA_NO_PADDING -DWOLFSSL_PUBLIC_MP -DHAVE_PUBLIC_FFDHE -DWOLFSSL_DH_EXTRA -DWOLFSSL_PSS_LONG_SALT -DWOLFSSL_PSS_SALT_LEN_DISCOVER -DRSA_MIN_SIZE=1024" --enable-certgen --enable-aeskeywrap --enable-enckeys --enable-base16 --with-eccminsz=192
make
sudo make install
```

Add `--enable-aesgcm-stream` if available for better AES-GCM support.
Add `--enable-curve25519` to include support for X25519 Key Exchange.
Add `--enable-curve448` to include support for X448 Key Exchange.
Add `--enable-ed25519` to include support for Ed25519 signatures and certificates..
Add `--enable-ed448` to include support for Ed448 signature and certificates.

Add `--enable-pwdbased` to the configure command above if PKCS#12 is used in OpenSSL.

Add to CPPFLAGS `-DHAVE_FFDHE_6144 -DHAVE_FFDHE_8192 -DFP_MAX_BITS=16384` to enable predefined 6144-bit and 8192-bit DH parameters.

Add to `--enable-hmac-copy` if performing HMAC repeatedly with the same key to improve performance. (Available with wolfSSL 5.7.8+.)

Add `--enable-sp=yes,asm' '--enable-sp-math-all'` to use SP Integer maths. Replace `-DFP_MAX_BITS=16384` with -DSP_INT_BITS=8192` when used.

Remove `-DWOLFSSL_PSS_LONG_SALT -DWOLFSSL_PSS_SALT_LEN_DISCOVER` and add `--enable-fips=v2` to the configure command above if building from a FIPS v2 bundle and not the git repository. Change `--enable-fips=v2` to `--enable-fips=ready` if using a FIPS Ready bundle.

If '--with-eccminsz=192' is not supported by wolfSSL, add '-DECC_MIN_KEY_SZ=192' to the CPPFLAGS.

``

If cloning wolfSSL from GitHub, you will need to run the `autogen.sh` script before running `./configure`. This will generate the configure script:
```
./autogen.sh
```

### Building wolfProvider
When building wolfProvider on Linux or other *nix-like systems, use the autoconf system. To configure and compile wolfProvider run the following two commands from the wolfProvider root directory:
```
./configure
make
```

If building wolfProvider from GitHub, run autogen.sh before running configure:
```
./autogen.sh
```

Any number of build options can be appended to ./configure. For a list of available build options, please reference the “Build Options” section below or run the following command to see a list of available build options to pass to the ./configure script:
```
./configure  --help
```

wolfProvider will use the system default OpenSSL library installation unless changed with the “--with-openssl” configure option:
```
./configure --with-openssl=/usr/local/ssl
```

The custom OpenSSL installation location may also need to be added to your library search path. On Linux, `LD_LIBRARY_PATH` is used:
```
export LD_LIBRARY_PATH=/usr/local/ssl:$LD_LIBRARY_PATH
```

To build then install wolfProvider, run:
```
make
make install
```

You may need superuser privileges to install, in which case precede the command with sudo:
```
sudo make install
```

To test the build, run the built-in tests from the root wolfProvider directory:
```
./test/unit.test
```

Or use autoconf to run the tests:
```
make check
```

If you get an error like `error while loading shared libraries: libssl.so.3` then the library cannot be found. Use the `LD_LIBRARY_PATH` environment variable as described in the section above.

## Building on WinCE

For full wolfProvider compatibility, ensure you have the following flags in your `user_settings.h` file for wolfCrypt:
```
#define WOLFSSL_CMAC
#define WOLFSSL_KEY_GEN
#undef NO_SHA
#undef NO_DES
#define WOLFSSL_AES_COUNTER
#define HAVE_AESCCM
#define HAVE_AES_ECB
#define WOLFSSL_AES_DIRECT
#define WC_RSA_NO_PADDING
#define WOLFSSL_PUBLIC_MP
#define ECC_MIN_KEY_SZ=192
```

Add wolfProvider flags to your `user_settings.h` file depending on which algorithms and features you want to use. You can find a list of wolfProvider user settings flags in the `user_settings.h` file in wolfProvider’s directory.

Build wcecompat, wolfCrypt and OpenSSL for Windows CE, and keep track of their paths.

In the wolfProvider directory, open the sources file and change the OpenSSL, wolfCrypt, and `user_settings.h` paths to the directories you are using. You will need to update the paths in the INCLUDES and TARGETLIBS sections.

Load the wolfProvider project in Visual Studio. Include either `bench.c`, or `unit.h` and `unit.c` depending on if you want to run the benchmark or unit tests.

Build the project, and you will end up with a wolfProvider.exe executable. You can run this executable with ` --help` to see a full list of options. You may need to run it with the  `--static` flag to use wolfProvider as a static provider.

## Build Options (./configure Options)

The following are options which may be appended to the `./configure` script to customize how the wolfProvider library is built.

By default, wolfProvider only builds a shared library, with building of a static library disabled. This speeds up build times by a factor of two. Either mode can be explicitly disabled or enabled if desired.

| Option            | Default Value     | Description                    |
| :---------------- | :---------------: | :----------------------------- |
| --disable-option-checking | **Disabled** | | ignore unrecognized --enable/--with options |
| --enable-silent-rules | **Disabled** | less verbose build output (undo: "make V=1") |
| --disable-silent-rules | **Disabled** | verbose build output (undo: "make V=0") |
| --enable-static | **Disabled** | Build static libraries |
| --enable-pic[=PKGS] | **Use Both** | try to use only PIC/non-PIC objects |
| --enable-shared | **Enabled** | Build shared libraries |
| --enable-fast-install[=PKGS] | **Enabled** |  optimize for fast installation |
| --enable-aix-soname=aix\|svr4\|both | **aix** | shared library versioning (aka "SONAME") variant to provide on AIX |
| --enable-dependency-tracking | **Disabled** | do not reject slow dependency extractors |
| --disable-dependency-tracking | **Disabled** | speeds up one-time build |
| --disable-libtool-lock | **Disabled** |  avoid locking (might break parallel builds) |
| --enable-debug | **Disabled** | Enable wolfProvider debugging support |
| --enable-coverage | **Disabled** | Build to generate code coverage stats |
| --enable-usersettings | **Disabled** | Use your own user_settings.h and do not add Makefile CFLAGS |
| --enable-dynamic | **Enabled** | Enable loading wolfProvider as a dynamic provider |
| --enable-singlethreaded | **Disabled** | Enable wolfProvider single threaded |
| | | |
| --with-openssl=DIR |   | OpenSSL installation location to link against. If not set, use the system default library and include paths. |
| --with-wolfssl=DIR |   | wolfSSL installation location to link against. If not set, use the system default library and include paths. |

## Build Defines

wolfProvider exposes several preprocessor defines that allow users to configure how wolfProvider is built. These are described in the table below.

| Define                           | Description |
| :------------------------------- | :----------------------------- |
| WOLFPROVIDER_USER_SETTINGS | Read user-specified defines from user_settings.h. |
| WOLFPROV_DEBUG | Output debug information |
| WP_CHECK_FORCE_FAIL | Force failure checking for testing purposes |
| WP_ALLOW_NON_FIPS | Allow certain non-FIPS algorithms in FIPS mode |
| WP_HAVE_AESCCM | AES encryption in CCM (Counter with CBC-MAC) mode |
| WP_HAVE_AESCFB | AES encryption in CFB (Cipher Feedback) mode |
| WP_HAVE_AESCBC | AES encryption in CBC (Cipher Block Chaining) mode |
| WP_HAVE_AESCTR | AES encryption in CTR (Counter) mode |
| WP_HAVE_AESCTS | AES encryption in CTS (Ciphertext Stealing) mode |
| WP_HAVE_AESECB | AES encryption in ECB (Electronic Codebook) mode |
| WP_HAVE_AESGCM | AES encryption in GCM (Galois/Counter Mode) mode |
| WP_HAVE_CMAC | CMAC (Cipher-based Message Authentication Code) support |
| WP_HAVE_DES3CBC | Triple DES encryption in CBC mode |
| WP_HAVE_DH | Diffie-Hellman key exchange support |
| WP_HAVE_DIGEST | General digest/hash algorithm support |
| WP_HAVE_ECC | General Elliptic Curve Cryptography support |
| WP_HAVE_EC_P192 | P-192 elliptic curve support |
| WP_HAVE_EC_P224 | P-224 elliptic curve support |
| WP_HAVE_EC_P256 | P-256 elliptic curve support |
| WP_HAVE_EC_P384 | P-384 elliptic curve support |
| WP_HAVE_EC_P521 | P-521 elliptic curve support |
| WP_HAVE_ECDH | ECDH (Elliptic Curve Diffie-Hellman) key exchange support |
| WP_HAVE_ECDSA | ECDSA (Elliptic Curve Digital Signature Algorithm) support |
| WP_HAVE_ECKEYGEN | Elliptic curve key generation support |
| WP_HAVE_ED25519 | Ed25519 elliptic curve signature support |
| WP_HAVE_ED448 | Ed448 elliptic curve signature support |
| WP_HAVE_GMAC | GMAC (Galois/Counter Mode Authentication) support |
| WP_HAVE_HKDF | HKDF (HMAC-based Key Derivation Function) support |
| WP_HAVE_HMAC | HMAC (Hash-based Message Authentication Code) support |
| WP_HAVE_KRB5KDF | Kerberos 5 Key Derivation Function support |
| WP_HAVE_MD5 | MD5 hash algorithm support |
| WP_HAVE_MD5_SHA1 | MD5+SHA1 combination support |
| WP_HAVE_PBE | Password-Based Encryption support |
| WP_HAVE_RANDOM | Random number generation support |
| WP_HAVE_RSA | RSA encryption and signature support |
| WP_HAVE_SHA1 | SHA1 hash algorithm support |
| WP_HAVE_SHA224 | SHA224 hash algorithm support |
| WP_HAVE_SHA256 | SHA256 hash algorithm support |
| WP_HAVE_SHA384 | SHA384 hash algorithm support |
| WP_HAVE_SHA3 | SHA3 family hash algorithm support |
| WP_HAVE_SHA3_224 | SHA3-224 hash algorithm support |
| WP_HAVE_SHA3_256 | SHA3-256 hash algorithm support |
| WP_HAVE_SHA3_384 | SHA3-384 hash algorithm support |
| WP_HAVE_SHA3_512 | SHA3-512 hash algorithm support |
| WP_HAVE_SHA512 | SHA512 hash algorithm support |
| WP_HAVE_SHA512_224 | SHA512/224 hash algorithm support |
| WP_HAVE_SHA512_256 | SHA512/256 hash algorithm support |
| WP_HAVE_SHAKE_256 | SHAKE256 extendable output function support |
| WP_HAVE_TLS1_PRF | TLS1 Pseudo-Random Function support |
| WP_HAVE_X25519 | X25519 elliptic curve support |
| WP_HAVE_X448 | X448 elliptic curve support |
| WP_RSA_PSS_ENCODING | RSA-PSS (Probabilistic Signature Scheme) encoding support |
