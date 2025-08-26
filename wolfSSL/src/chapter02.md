# Building wolfSSL

wolfSSL was written with portability in mind and should generally be easy to build on most systems. If you have difficulty building wolfSSL, please don’t hesitate to seek support through our support forums (<https://www.wolfssl.com/forums>) or contact us directly at [support@wolfssl.com](mailto:support@wolfssl.com).

This chapter explains how to build wolfSSL on Unix and Windows, and provides guidance for building wolfSSL in a non-standard environment. You will find the “getting started” guide in [Chapter 3](chapter03.md#getting-started) and an SSL tutorial in [Chapter 11](chapter11.md#ssl-tutorial).

When using the autoconf / automake system to build wolfSSL, wolfSSL uses a single Makefile to build all parts and examples of the library, which is both simpler and faster than using Makefiles recursively.

## Getting wolfSSL Source Code

The most recent version of wolfSSL can be downloaded from the wolfSSL website as a ZIP file:

<https://www.wolfssl.com/download>

After downloading the ZIP file, unzip the file using the `unzip` command. To use native line endings, enable the `-a` modifier when using unzip. From the unzip man page, the `-a` modifier functionality is described:

> [...] The -a option causes files identified by zip as text files (those with
> the ‘t’ label in zipinfo listings, rather than ‘b’) to be automatically
> extracted as such, converting line endings, end-of-file characters
> and the character set itself as necessary. [...]

**NOTE**: Beginning with the release of wolfSSL 2.0.0rc3, the directory structure of wolfSSL was changed as well as the standard install location. These changes were made to make it easier for open source projects to integrate wolfSSL. For more information on header and structure changes, please see [Library Headers](chapter09.md#library-headers) and [Structure Usage](#structure-usage).

## Building on Unix-like Systems

When building wolfSSL on Linux, \*BSD, OS X, Solaris, or other \*nix-like systems, use the autoconf system. To build wolfSSL you only need to run two commands from the wolfSSL root directory, `./configure` and `make`.

The `./configure` script sets up the build environment and you can append any number of build options to `./configure`. For a list of available build options, please see [Build Options](#build-options) or run the following command to see a list of possible options to pass to the `./configure` script:

```sh
./configure --help
```

Once `./configure` has successfully executed, to build wolfSSL, run:

```sh
make
```

To install wolfSSL run:

```sh
make install
```

You may need superuser privileges to install, in which case precede the command with sudo:

```sh
sudo make install
```

To test the build, run the testsuite program from the root wolfSSL directory:

```sh
./testsuite/testsuite.test
```

Alternatively you can use autoconf to run the testsuite as well as the standard wolfSSL API and crypto tests:

```sh
make test
```

Further details about expected output of the testsuite program can be found in the [Testsuite section](chapter03.md#testsuite). If you want to build only the wolfSSL library and not the additional items (examples, testsuite, benchmark app, etc.), you can run the following command fromthe wolfSSL root directory:

```sh
make src/libwolfssl.la
```

## Building on Windows

In addition to the instructions below, you can find instructions and tips for building wolfSSL with Visual Studio [here](https://wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio.html).

### VS 2008

Solutions are included for Visual Studio 2008 in the root directory of the install. For use with Visual Studio 2010 and later, the existing project files should be able to be converted during the import process.

**Note**:
If importing to a newer version of VS you will be asked: “Do you want to overwrite the project and its imported property sheets?” You can avoid the following by selecting “No”. Otherwise if you select “Yes”, you will see warnings about `EDITANDCONTINUE` being ignored due to `SAFESEH` specification. You will need to right click on the testsuite, sslSniffer, server, echoserver, echoclient, and client individually and modify their Properties-\>Configuration Properties-\>Linker-\>Advanced (scroll all the way to the bottom in Advanced window). Locate “Image Has Safe Exception Handlers” and click the drop down arrow on the far right. Change this to No (`/SAFESEH:NO`) for each of the aforementioned. The other option is to disable `EDITANDCONTINUE` which, we have found to be useful for debugging purposes and is therefore not recommended for production software.

### VS 2010

You will need to download Service Pack 1 to build wolfSSL solution once it has been updated. If VS reports a linker error, clean and rebuild the project; the linker error should be taken care of.

### VS 2013 (64 bit solution)

You will need to download Service Pack 4 to build wolfSSL solution once it has been updated. If VS reports a linker error, clean and rebuild the project; the linker error should be taken care of.

To test each build, choose “Build All” from the Visual Studio menu and then run the testsuite program. To edit build options in the Visual Studio project, select your desired project (wolfssl, echoclient, echoserver, etc.) and browse to the “Properties” panel.

**Note**: After the wolfSSL v3.8.0 release the build preprocessor macros were moved to a centralized file located at `IDE/WIN/user_settings.h`. This file can also be found in the project. To add features such as ECC or ChaCha20/Poly1305, add `#defines` here such as `HAVE_ECC` or `HAVE_CHACHA` / `HAVE_POLY1305`.

### Cygwin

If building wolfSSL for Windows on a Windows development machine, we recommend using the included Visual Studio project files to build wolfSSL. However, if Cygwin is required here is a short guide on how our team achieved a successful build:

1. Go to <https://www.cygwin.com/install.html> and download `setup-x86_64.exe`
2. Run `setup-x86_64.exe` and install however you choose. Click through the installation menus until you reach the "Select Packages" stage.
3. Click on the "+" icon to expand "All"
4. Now go to the "Archive" section and select "unzip" drop down, change "Skip" to 6.0-15 (or some other version).
5. Under "Devel" click "autoconf" drop down and change "Skip" to "10-1" (or some other version)
6. Under "Devel" click "automake" drop down and change "Skip" to "10-1" (or some other version)
7. Under "Devel" click the "gcc-core" drop down and change "Skip" to 7.4.0-1 (NOTE: wolfSSL has not tested GCC 9 or 10 and as they are fairly new does not recommend using them until they have had a bit more time to be fine-tuned for development).
8. Under "Devel" click the "git" drop down and change "Skip" to 2.29.0-1 (or some other version)
9. Under "Devel" click "libtool" drop down and change "Skip" to "2.4.6-5" (or some other version)
10. Under "Devel" click the "make" drop down and change "Skip" to 4.2.1-1 (or some other version)
11. Click "Next" and proceed through the rest of the installation.

The additional packages list should include:

* unzip
* autoconf
* automake
* gcc-core
* git
* libtool
* make

#### Post Install

Open a Cygwin terminal and clone wolfSSL:

```sh
git clone https://github.com/wolfssl/wolfssl.git
cd wolfssl
./autogen.sh
./configure
make
make check
```

## Building in a non-standard environment

While not officially supported, we try to help users wishing to build wolfSSL in a non-standard environment, particularly with embedded and cross-compilation systems. Below are some notes on getting started with this.

1. The source and header files need to remain in the same directory structure as they are in the wolfSSL download package.
2. Some build systems will want to explicitly know where the wolfSSL header files are located, so you may need to specify that. They are located in the `<wolfssl_root>/wolfssl` directory. Typically, you can add the `<wolfssl_root>` directory to your include path to resolve header problems.
3. wolfSSL defaults to a little endian system unless the configure process detects big endian. Since users building in a non-standard environment aren't using the configure process, `BIG_ENDIAN_ORDER` will need to be defined if using a big endian system.
4. wolfSSL benefits speed-wise from having a 64-bit type available. The configure process determines if long or long long is 64 bits and if so sets up a define. So if `sizeof(long)` is 8 bytes on your system, define `SIZEOF_LONG 8`. If it isn't but `sizeof(long long)` is 8 bytes, then define `SIZEOF_LONG_LONG 8`.
5. Try to build the library, and let us know if you run into any problems. If you need help, contact us at [info@wolfssl.com](mailto:info@wolfssl.com).
6. Some defines that can modify the build are listed in the following sub-sections, below. For more verbose descriptions of many options, please see [Build Options](#build-options).

### Building into Yocto Linux

wolfSSL also includes recipes for building wolfSSL on Yocto Linux and OpenEmbedded. These recipes are maintained within the meta-wolfSSL layer as a GitHub repository, here: <https://github.com/wolfSSL/meta-wolfssl>. Building wolfSSL on Yocto Linux will require Git and bitbake. The following steps list how to get some wolfSSL products (that recipes exist for) built on Yocto Linux.

1. **Cloning wolfSSL meta**

    This can be done through a git-clone command of the following URL:
    <https://github.com/wolfSSL/meta-wolfssl>

2. **Insert the "meta-wolfSSL" layer into the build's bblayers.conf**

    Within the `BBLAYERS` section, add the path to the location where meta-wolfssl
    was cloned into. Example:

    ```sh
    BBLAYERS ?= "... \
    /path/to/meta-wolfssl/ \
    ..."
    ```

3. **Build a wolfSSL product recipe**

    bitbake can be used to build one of the three following wolfSSL product recipes:
    *wolfssl*, *wolfssh*, and *wolfmqtt*. Simply pass one of those recipes into the bitbake
    command (example: `bitbake wolfssl`). This allows the user to personally
    confirm compilation succeeds without issues.

4. **Edit local.conf**

    The final step is to edit the build's local.conf file, which allows desired libraries to
    be included with the image being built. Edit the `IMAGE_INSTALL_append` line
    to include the name of the desired recipe(s). An example of this is shown below:

    ```sh
    IMAGE_INSTALL_append = "wolfssl wolfssh wolfmqtt"
    ```

Once the image has been built, wolfSSL's default location (or related products from recipes) will be the `/usr/lib/` directory.

Additionally, wolfSSL can be customized when building into Yocto by using the enable and disable options listed in [Build Options](#build-options). This requires creating a `.bbappend` file and placing it within the wolfSSL application/recipe layer. The contents of this file should include a line specifying content to concatenate onto the `EXTRA_OECONF` variable. An example of this is shown below to enable TLS 1.3 support through the TLS 1.3 enable option:

```sh
EXTRA_OECONF += "--enable-tls13"
```

Further documentation on building into Yocto can be found in the meta-wolfssl README, located here: <https://github.com/wolfSSL/meta-wolfssl/blob/master/README.md>

### Building with Atollic TrueSTUDIO

Versions of wolfSSL following 3.15.5 include a TrueSTUDIO project file that is used to build wolfSSL on ARM M4-Cortex devices. The TrueSTUDIO project file simplifies the process of building on STM32 devices, is free to download, and is createed by Atollic - a part of ST Microelectronics. To build the wolfSSL static library project file in TrueSTUDIO, it will require the user perform the following steps after opening TrueSTUDIO:

1. Import the project into the workspace (File > Import)
2. Build the project (Project > Build project)

The build then includes the settings located inside of `user_settings.h` at build-time. The default content of the `user_settings.h` file is minimal, and does not contain many features. Users are able to modify this file and add or remove features with options listed in the remainder of this chapter.

### Building with IAR

The `<wolfssl_root>/IDE/IAR-EWARM` directory contains the following files:

1. Workspace: `wolfssl.eww`
   The workspace includes wolfSSL-Lib library and wolfCrypt-test, wolfCrypt-benchmark
   executable projects.
2. wolfSSL-Lib Project: `lib/wolfSSL-lib.ewp`
   generates full set library of wolfCrypt and wolfSSL functions.
3. Test suites Project: `test/wolfCrypt-test.ewp`
   generates test.out test suites executable
4. Benchmark Project: `benchmark/wolfCrypt-benchmark.ewp`
   generates benchmark.out benchmark executable

These projects have been set up to generic ARM Cortex-M MPUs. In order to generate project for specific target MPU, take following steps.

1. Default Setting: Default Target of the projects are set to Cortex-M3 Simulator. user_settings.h includes default options for the projects. You can build and
download the to the simulator. Open Terminal I/O window, by "view"->"Terminal I/O", and start execution.

2. Project option settings: For each project, choose appropriate "Target" options.

3. For executable projects: Add "SystemInit" and "startup" for your MPU, choose your debug "Driver".

4. For benchmark project: Choose option for current_time function or write your own "current_time" benchmark timer with WOLFSSL_USER_CURRTIME option.

5. Build and download: Go to "Project->Make" and "Download and Debug" in Menu bar for EWARM build and download.

### Building on OS X and iOS

#### XCODE

The `<wolfssl_root>/IDE/XCODE` directory contains the following files:

1. `wolfssl.xcworkspace` -- workspace with library and testsuite client
2. `wolfssl_testsuite.xcodeproj` -- project to run the testsuite.
3. `wolfssl.xcodeproj` -- project to build OS/x and iOS libraries for wolfSSL and/or wolfCrypt
4. `wolfssl-FIPS.xcodeproj` -- project to build wolfSSL and wolfCrypt-FIPS if available
5. `user_settings.h` -- custom library settings, which are shared across projects

The library will output as `libwolfssl_osx.a` or `libwolfssl_ios.a` depending on the target. It will also copy the wolfSSL/wolfCrypt (and the CyaSSL/CtaoCrypt
compatibility) headers into an `include` directory located in
`Build/Products/Debug` or `Build/Products/Release`.

For the library and testsuite to link properly the build location needs to be configured relative to the workspace.

1. File -> Workspace Settings (or Xcode -> Preferences -> Locations -> Locations)
2. Derived Data -> Advanced
3. Custom -> Relative to Workspace
4. Products -> Build/Products

These Xcode projects define the `WOLFSSL_USER_SETTINGS` preprocessor to enable the `user_settings.h` file for setting macros across multiple projects.

If needed the Xcode preprocessors can be modified with these steps:

1. Click on the Project in "Project Navigator".
2. Click on the "Build Settings" tab.
3. Scroll down to the "Apple LLVM 6.0 - Preprocessing" section.
4. Open the disclosure for "Preprocessor Macros" and use the "+" and
"-" buttons to modify. Remember to do this for both Debug and Release.

This project should build wolfSSL and wolfCrypt using the default settings.

### Building with GCC ARM

In the `<wolfssl_root>/IDE/GCC-ARM` directory, you will find an example wolfSSL project for Cortex M series, but it can be adopted for other architectures.

1. Make sure you have `gcc-arm-none-eabi` installed.
2. Modify the `Makefile.common`:
   * Use correct toolchain path `TOOLCHAIN`.
   * Use correct architecture 'ARCHFLAGS'. See [GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc-4.7.3/gcc/ARM-Options.html) `-mcpu=name`.
   * Confirm memory map in linker.ld matches your flash/ram or comment out `SRC_LD = -T./linker.ld` in Makefile.common.
3. Use `make` to build the static library (libwolfssl.a), wolfCrypt test/benchmark and wolfSSL TLS client targets as `.elf` and `.hex` in `/Build`.

#### Building with generic makefile cross-compile

Example `Makefile.common` changes for Raspberry Pi with Cortex-A53:

1. In Makefile.common change `ARCHFLAGS` to `-mcpu=cortex-a53 -mthumb`.
2. Comment out `SRC_LD`, since custom memory map is not applicable.
3. Clear `TOOLCHAIN`, so it will use default `gcc`. Set `TOOLCHAIN =`
4. Comment out `LDFLAGS += --specs=nano.specs` and `LDFLAGS += --specs=nosys.specs` to nosys and nano.

#### Building with configure with cross-compile

The configure script in the main project directory can perform a cross-compile
build with the gcc-arm-none-eabi tools. Assuming the tools are installed in
your executable path:

```sh
./configure \
  --host=arm-none-eabi \
  CC=arm-none-eabi-gcc \
  AR=arm-none-eabi-ar \
  STRIP=arm-none-eabi-strip \
  RANLIB=arm-none-eabi-ranlib \
  --prefix=/path/to/build/wolfssl-arm \
  CFLAGS="-march=armv8-a --specs=nosys.specs \
      -DHAVE_PK_CALLBACKS -DWOLFSSL_USER_IO -DWOLFSSL_NO_SOCK -DNO_WRITEV" \
  --disable-filesystem --enable-crypttests \
  --disable-shared
make
make install
```

If you are building for a 32-bit architecture, add `-DTIME_T_NOT_64BIT` to the
list of CFLAGS.

### Building on Keil MDK-ARM

You can find detailed instructions and tips for building wolfSSL on Keil MDK-ARM [here](https://www.wolfssl.com/docs/keil-mdk-arm/).

**Note**: If MDK-ARM is not installed in the default installation location, you need to change all of the referencing path definitions in the project file to the
install location.

## Features Defined as C Pre-processor Macro

### Removing Features

The following defines can be used to remove features from wolfSSL. This can be helpful if you are trying to reduce the overall library footprint size. In addition to defining a `NO_<feature-name>` define, you can also remove the respective source file as well from the build (but not the header file).

#### NO_WOLFSSL_CLIENT

Removes calls specific to the client and is for server-only builds. You should only use this if you want to remove a few calls for the sake of size.

#### NO_WOLFSSL_SERVER

Likewise removes calls specific to the server side.

#### NO_DES3

Removes the use of DES3 encryptions. DES3 is built-in by default because some older servers still use it and it's required by SSL 3.0. `NO_DH` and `NO_AES` are the same as the two above, they are widely used.

#### NO_DSA

Removes DSA since it's being phased out of popular use.

#### NO_ERROR_STRINGS

Disables error strings. Error strings are located in `src/internal.c` for wolfSSL or `wolfcrypt/src/asn.c` for wolfCrypt.

#### NO_HMAC

Removes HMAC from the build.

**NOTE**: SSL/TLS depends on HMAC but if you are only using wolfCrypt IE build option `WOLFCRYPT_ONLY` then HMAC can be disabled in this case.

#### NO_MD4

Removes MD4 from the build, MD4 is broken and shouldn't be used.

#### NO_MD5

Removes MD5 from the build.

#### NO_SHA

Removes SHA-1 from the build.

#### NO_SHA256

Removes SHA-256 from the build.

#### NO_PSK

Turns off the use of the pre-shared key extension. It is built-in by default.

#### NO_PWDBASED

Disables password-based key derivation functions such as PBKDF1, PBKDF2, and PBKDF from PKCS #12.

#### NO_RC4

Removes the use of the ARC4 stream cipher from the build. ARC4 is built-in by default because it is still popular and widely used.

#### NO_SESSION_CACHE

Can be defined when a session cache is not needed. This should reduce memory use by nearly 3 kB.

#### NO_TLS

Turns off TLS. We do not recommend turning off TLS.

#### SMALL_SESSION_CACHE

Can be defined to limit the size of the SSL session cache used by wolfSSL. This will reduce the default session cache from 33 sessions to 6 sessions and save approximately 2.5 kB.

#### NO_RSA

Removes support for the RSA algorithm.

#### WC_NO_RSA_OAEP

Removes code for OAEP padding.

#### NO_AES_CBC

Turns off AES-CBC algorithm support.

#### NO_AES_DECRYPT

Can be set to reduce code size. Set to disable the decrypt and only support encryption.

#### WOLFCRYPT_ONLY

Enables wolfCrypt only while disabling TLS.

#### NO_CAMELLIA_CBC

Disables Camellia CBC support but only applies to TLS cipher suites only.

#### NO_AES

Disables AES algorithm support.

#### NO_AES_128

Used for AES key size selection at compile time.

#### NO_AES_192

Used for AES key size selection at compile time.

#### NO_AES_256

Used for AES key size selection at compile time.

#### NO_AESGCM_AEAD

Used for disabliing TLS cipher suites thst use AES GCM. It is used internally when no AES GCM cipher suites are enabled, but can also be used to limit cipher suites.

#### NO_ASN_TIME

Disables time checking for ASN. Note: This should be used with caution because all certificate begin/end date checking will be skipped.

#### NO_CHECK_PRIVATE_KEY

This macro disables additional private key checking that is on by default. This enables checking to validate the private key is a pair for the public key. It is supported for RSA, ECDSA, ED25519, ED448, Falcon, Dilithium and Sphincs.

#### NO_DH

Disables Diffie-Hellman (DH) support.

#### NO_ED25519_CLIENT_AUTH

Disables TLS client authentication support for ED25519. It is used to reduce memory usage during TLS if ED25519 is not used, since it requires caching messages.

#### NO_ED448_CLIENT_AUTH

Disables client authentification for ED448.

#### NO_FORCE_SCR_SAME_SUITE

By default secure renegotiation requires using the same cipher suite. This disables that requirement.

#### NO_MULTIBYTE_PRINT

Used for compiling out special characters that embedded devices may have problems with.

#### NO_OLD_SSL_NAMES

This disables some of the old OpenSSL compatibility macros for using wolfSSL and OpenSSL together.

#### NO_OLD_WC_NAMES

Removes unneeded namespace.

#### NO_OLD_POLY1305

This disables support for the old ChaCha20/Poly1305 TLS 1.2 cipher suite that is typically used for interop.

#### NO_HANDSHAKE_DONE_CB

Disables support for the handshake callback set with `wolfSSL_SetHsDoneCb`. This option is useful for reducing code size.

#### NO_STDIO_FILESYSTEM

This disables include of stdio.h. Used with portability.

#### NO_TLS_DH

Excludes TLS DH. Should not negotiate cipher suites based on ephemeral finite-field Diffie-Hellman key agreement.

#### NO_WOLFSSL_CM_VERIFY

Disables the Certificate Manager verify callback. The verify callback allows intercepting errors and overriding them. This option is useful for reducing code size.

#### NO_WOLFSSL_DIR

Disable directory support.

#### NO_WOLFSSL_RENESAS_TSIP_TLS_SESSION

For disabling only the TSIP TLS-linked Common key encryption method. Note: This is a Renesas RX TSIP specific define.

#### NO_WOLFSSL_SHA256

This applies to TLS 1.3 only. It allows SHA2-256 to be enabled and usable from wolfCrypt, but exclude it from TLS 1.3.

#### WOLFSSL_BLIND_PRIVATE_KEY

Used as a mask to blind the private key. The blinding is used to proctect aginst Rowhammer attacks.

#### WOLFSSL_DTLS13_NO_HRR_ON_RESUME

If defined, a DTLS server will not do a cookie exchange on successful client resumption: the resumption will be faster (one RTT less) and will consume less bandwidth (one ClientHello and one HelloVerifyRequest/HelloRetryRequest less). On the other hand, if a valid SessionID/ticket/psk is collected, forged clientHello messages will consume resources on the server. For DTLS 1.3, using this option also allows for the server to process Early Data/0-RTT Data. Without this, the Early Data would be dropped since the server doesn't enter stateful processing until receiving a verified ClientHello with the cookie. To allow DTLS 1.3 resumption without the cookie exchange:- Compile wolfSSL with `WOLFSSL_DTLS13_NO_HRR_ON_RESUME` defined - Call wolfSSL_dtls13_no_hrr_on_resume(ssl, 1) on the WOLFSSL object to disable the cookie exchange on resumption - Continue like with a normal connection.

#### WOLFSSL_NO_CLIENT_AUTH

Disables the caching code required for using Ed25519 and Ed448.

#### WOLFSSL_NO_CURRDIR

Portability macro for platforms that do not support ./ for test paths in wolfssl/test.h. Applies to testing tools only.

#### WOLFSSL_NO_DEF_TICKET_ENC_CB

No default ticket encryption callback, server only. The application must set its own callback to use session tickets.

#### WOLFSSL_NO_SOCK

Portability macro for disabling built-in socket support. If using TLS without sockets typically `WOLFSSL_USER_IO` would be defined and callbacks used for send/recv.

#### WOLFSSL_NO_TLS12

Define to exlude TLS 1.2.

#### WOLFSSL_PEM_TO_DER

Key and cert generation feature support for disabling PEM to DER.

#### NO_DEV_URANDOM

Disables the use of `/dev/urandom`

#### WOLFSSL_NO_SIGALG

Disables the signature algorithms extension

#### NO_RESUME_SUITE_CHECK

Disables the check of cipher suite when resuming a TLS connection

#### NO_ASN

Removes support for ASN formatted certificate processing.

#### NO_OLD_TLS

Removes support for SSLv3, TLSv1.0 and TLSv1.1

#### WOLFSSL_AEAD_ONLY

Removes support for non-AEAD algorithms. AEAD stands for “authenticated encryption with associated data” which means these algorithms (such as AES-GCM) do not just encrypt and decrypt data, they also assure confidentiality and authenticity of that data.

#### WOLFSSL_SP_NO_2048

Removes RSA/DH 2048-bit Single-Precision (SP) optimization.

#### WOLFSSL_SP_NO_3072

Removes RSA/DH 3072-bit Single-Precision (SP) optimization.

#### WOLFSSL_SP_NO_256

Removes ECC Single-Precision (SP) optimization for SECP256R1. Only applies to `WOLFSSL_SP_MATH`.


### Enabling Features macros (on by default)

#### HAVE_TLS_EXTENSIONS

Enables support for TLS extensions, which are required for most TLS builds. Enabled by default with `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### HAVE_SUPPORTED_CURVES

Enables the TLS supported curves and key share extensions used with TLS. Required with ECC, Curve25519 and Curve448. Enabled by default with `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### HAVE_EXTENDED_MASTER

Enables extended master secret PRF for calculation of session keys used with TLS v1.2 and older. The PRF method is on by default and is considered more secure. This is on by default if using `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### HAVE_ENCRYPT_THEN_MAC

Enables encrypt-then-mac support to perform mac after encryption with block ciphers. This is the default and improves security. This is on by default if using `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### HAVE_ONE_TIME_AUTH

Required if using Chacha20/Poly1305 with TLS v1.2 for setting up Poly authentication. This is on by default with ChaCha20/Poly1305 if using `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### WOLFSSL_ASN_TEMPLATE
Enables the new version of ASN parsing code that uses template-based ASN.1 processing. This parsing adheres to standard ASN.1 rules and uses a template structure to dictate encoding and decoding, allowing the parser code to generalize across templates. This is on by default if using `./configure`, but needs to be manually defined if building with `WOLFSSL_USER_SETTINGS`.

#### WOLFSSL_DEBUG_ASN_TEMPLATE
Enables debugging output when using ASN.1 templates. Only relevant when used with `WOLFSSL_ASN_TEMPLATE`.

#### WOLFSSL_ASN_TEMPLATE_TYPE_CHECK
Use ASN functions to better test compiler type issues for testing. Only relevant when used with `WOLFSSL_ASN_TEMPLATE`

### Enabling Features Disabled by Default

#### WOLFSSL_CERT_GEN

Turns on wolfSSL’s certificate generation functionality. See [Keys and Certificates](chapter07.md#keys-and-certificates) for more information.

#### WOLFSSL_DER_LOAD

Allows loading DER-formatted CA certs into the wolfSSL context (`WOLFSSL_CTX`) using the function [`wolfSSL_CTX_der_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_der_load_verify_locations).

#### WOLFSSL_DTLS

Turns on the use of DTLS, or datagram TLS. This isn't widely supported or used.

#### WOLFSSL_KEY_GEN

Turns on wolfSSL’s RSA key generation functionality. See [Keys and Certificates](chapter07.md#keys-and-certificates) for more information.

#### WOLF_PRIVATE_KEY_ID

This is used with PKCS11 to enable support for key ID and label API's. FIPS v5 and older doesn't support `WOLF_PRIVATE_KEY_ID` with Crypto Callbacks.

#### WOLFSSL_WOLFSENTRY_HOOKS

This switch adds support in the TLS layer for generic network `accept` and `connect` filter hooks, using `wolfSSL_CTX_set_AcceptFilter()` and `wolfSSL_CTX_set_ConnectFilter()`. It also activates wolfSentry integration in the example client and server applications.

#### WOLFSSL_CERT_EXT

Certificate extension, key and cert generation feature.

#### WOLFSSL_CERT_REQ

Certificate request, key, and cert generation feature.

#### WOLFSSL_SSLKEYLOGFILE

This enables the key logging used by Wireshark. It does produce a compiler warning since the master secret and client random are written to a file. This is useful for testing and not recommended for production.

#### WOLFSSL_SSLKEYLOGFILE_OUTPUT

This macro defines the filename for the key logging. It is used with `WOLFSSL_SSLKEYLOGFILE`.

#### WOLFSSL_HAVE_WOLFSCEP

Enable feature used by autoconf to see if wolfSCEP is available.

#### WOLFSSL_HAVE_MIN

This macro is for portability of the library to indicate if MIN/MAX are already defined by the platform. It prevents duplicate definitions.

#### WOLFSSL_HAVE_TLS_UNIQUE

Keeps the "Finished" messages after a TLS handshake for use as the "tls-unique" channel binding. Added in libest port: allow applications to get the 'tls-unique' Channel Binding Type (https://tools.ietf.org/html/rfc5929#section-3). This is used in the EST protocol to bind an enrollment to a TLS session through 'proof-of-possession' (https://tools.ietf.org/html/rfc7030#section-3.4 and https://tools.ietf.org/html/rfc7030#section-3.5).

#### WOLFSSL_ENCRYPTED_KEYS

Enable for encrypted keys PKCS8 support. This macro enables PKCS8 password based key encryption. Here is a link to RFC PKCS8 documentation (https://datatracker.ietf.org/doc/html/rfc5208).

#### WOLFSSL_CUSTOM_OID

Certificate feature that enables custom OID support for subject and request extensions. This also applies to parsing certificates with custom OID.

#### WOLFSSL_RIPEMD

Enables RIPEMD-160 support.

#### WOLFSSL_SHA384

Enables SHA-384 support.

#### WOLFSSL_SHA512

Enables SHA-512 support.

#### WOLFSSL_AES_DIRECT

Enables direct AES ECB mode support. On its own ECB mode is not considered secure. This feature is required for PKCS7. Warning: In nearly all use cases ECB mode is considered to be less secure. Please avoid using ECB API’s directly whenever possible.

#### DEBUG_WOLFSSL

Builds in the ability to debug. For more information regarding debugging wolfSSL, see [Debugging](chapter08.md#debugging).

#### HAVE_AESCCM

Enables AES-CCM support.

#### HAVE_AESGCM

Enables AES-GCM support.

#### WOLFSSL_AES_XTS

Enables AES-XTS support.

#### HAVE_CAMELLIA

Enables Camellia support.

#### HAVE_CHACHA

Enables ChaCha20 support.

#### HAVE_POLY1305

Enables Poly1305 support.

#### HAVE_CRL

Enables Certificate Revocation List (CRL) support.

#### HAVE_CRL_IO

Enables blocking inline HTTP request on the CRL URL. It will load the CRL into the `WOLFSSL_CTX` and apply it to all WOLFSSL objects created from it.

#### HAVE_ECC

Enables Elliptical Curve Cryptography (ECC) support.

#### HAVE_LIBZ

Is an extension that can allow for compression of data over the connection. It normally shouldn't be used, see the note below under configure notes libz.

#### OPENSSL_EXTRA

Builds even more OpenSSL compatibility into the library, and enables the wolfSSL OpenSSL compatibility layer to ease porting wolfSSL into existing applications which had been designed to work with OpenSSL. It is off by default.

#### HAVE_EXT_CACHE

Enables a feature support use of an external session cache (vs an internal one).

#### WOLFSSL_WPAS_SMALL

Enables a smaller subset of the compatibility layer for WPA supplicant support.

#### OPENSSL_ALL

Enables support for all compatibility functions for testing integration.

#### OPENSSL_COEXIST

OpenSSL compat layer. Needs old names disabled. Mode to allow wolfSSL and OpenSSL to exist together.

#### OPENSSL_VERSION_NUMBER

Specifies the version number to implement OpenSSL compatibility.

#### WOLFSSL_NGINX

OpenSSL compatibility application specific. Use, nginx `(--enable-nginx) WOLFSSL_NGINX`.

#### WOLFSSL_ERROR_CODE_OPENSSL

OpenSSL compatibility API wolfSSL_EVP_PKEY_cmp returns 0 on success and -1 on failure. This behavior is different from OpenSSL. EVP_PKEY_cmp returns:
1: two keys match
0: do not match
-1: key types are different
-2: the operation is not supported
If you want this function to behave the same as openSSL, define WOLFSSL_ERROR_CODE_OPENSSL so that WS_RETURN_CODE translates return codes to match OpenSSL equivalent behavior.

#### WOLFSSL_HARDEN_TLS

Implement the recommendations specified in RFC9325. This macro needs to be defined to the desired number of bits of security. The currently implemented values are 112 and 128 bits. The following macros disable certain checks.
- WOLFSSL_HARDEN_TLS_ALLOW_TRUNCATED_HMAC
- WOLFSSL_HARDEN_TLS_ALLOW_OLD_TLS
- WOLFSSL_HARDEN_TLS_NO_SCR_CHECK
- WOLFSSL_HARDEN_TLS_NO_PKEY_CHECK
- WOLFSSL_HARDEN_TLS_ALLOW_ALL_CIPHERSUITES

#### WOLFSSL_ASIO

OpenSSL compatibility specific macro.

#### WOLFSSL_QT

OpenSSL compatibility specific. Enable DH Extra for QT, OpenSSL all, OpenSSH, and static ephemeral.

#### WOLFSSL_HAPROXY

OpenSSL compatibility specific macro.

#### WOLFSSL_ASN_TEMPLATE

Use newer ASN template asn.c code (default). Daul algo certificate features. Dual alg cert support requires the ASN.1 template feature.

#### WOLFSSL_ASYNC_IO

Used in async cleanup.

#### WOLFSSL_ATMEL

Enables ASF hooks seeding random data using the `atmel_get_random_number` function.

#### WOLFSSL_CMAC

Additional CMAC algorithm enable. Note: requires `WOLFSSL_AES_DIRECT`.

#### WOLFSSL_ESPIDF_ERROR_PAUSE

Used only in test.c and on test error adds a delay for debugging purposes.

#### TEST_IPV6

Turns on testing of IPv6 in the test applications. wolfSSL proper is IP neutral, but the testing applications use IPv4 by default.

#### TEST_NONBLOCK_CERTS

Used only for testing a non-blocking OCSP response. Enabled with `WOLFSSL_NONBLOCK_OCSP` and `OCSP_WANT_READ`.

#### TEST_OPENSSL_COEXIST

Use when enabling the build option: `./configure --enable-opensslcoexist`.

#### TEST_PK_PRIVKEY

Used for testing PK callbacks only. In wolfssl/test.h it uses the context to pass the actual private key which is loaded and used in the PK callback.

#### TEST_BUFFER_SIZE

Allows overriding the TLS benchmarking test buffer size used with the example client/server `-B` option.

#### FORCE_BUFFER_TEST

Forces use of the test_certs.h buffers instead of using the file system. Used for internal testing only in wolfssl/test.h.

#### WOLFSSL_FORCE_MALLOC_FAIL_TEST

Define for internal testing to induce random malloc failures.

#### WOLFSSL_POST_HANDSHAKE_AUTH

TLS extension, Used for post-handshake authentification.

#### WOLFSSL_PSK_MULTI_ID_PER_CS

With TLS 1.3 PSK, when `WOLFSSL_PSK_MULTI_ID_PER_CS` is defined, multiple IDs for a cipher suite can be handled.

#### WOLFSSL_PUBLIC_ASN

This exposes the ASN.1 API's publicly that are used internally. This is useful for customers who want to use the internal asn.h API's to parse.

#### WOLFSSL_QUIC

Enables support for QUIC protocol. See (https://github.com/wolfSSL/wolfssl/blob/master/doc/QUIC.md) for more information.

#### WOLFSSL_QUIC_MAX_RECORD_CAPACITY

Defines max quic capacity as 1024*1024 -- 1 MB.

#### WOLFSSL_RENESAS_FSPSM_TLS

Not yet supported TLS related capabilities.

#### WOLFSSL_RENESAS_TSIP_TLS

This is for disabling only the TSIP TLS-linked common key encryption method.

#### WOLFSSL_SM2

Define to use SM ciphers.

#### WOLFSSL_SM3

Define to use SM ciphers.

#### WOLFSSL_SM4

Define to use SM ciphers.

#### WOLFSSL_SM4_CBC

SM setting for SM4 CBC.

#### WOLFSSL_SM4_CCM

SM settings for SM4 CCM.

#### WOLFSSL_SM4_GCM

SM settings for SM4 GCM.

#### WOLFSSL_SNIFFER_CHAIN_INPUT

The Chain Input option allows the sniffer to receive its input as a struct iovec list. Rather than a pointer to a raw packet.

#### XSLEEP_MS

Used for testing only. It allows defining a custom delay.

#### XSNPRINTF

Allows overriding the snprintf function.

#### DEFAULT_TIMEOUT_SEC

Used with `HAVE_IO_TIMEOUT` to specify the wolfio.c socket timeout in seconds. This is used by the internal socket code for OCSP and CRL HTTP.

#### HAVE_IO_TIMEOUT

Certificate revocation. IO options enable support for connect timeout, but the default is off.

#### HAVE_OCSP

Enables Online Certificate Status Protocol (OCSP) support.

#### HAVE_CSHARP

Turns on configuration options needed for C# wrapper.

#### HAVE_CURVE25519

Turns on the use of curve25519 algorithm.

#### HAVE_ED25519

Turns on use of the ed25519 algorithm.

#### WOLFSSL_DH_CONST

Turns off use of floating point values when performing Diffie Hellman operations and uses tables for `XPOW()` and `XLOG()`. Removes dependency on external math library.

#### WOLFSSL_TRUST_PEER_CERT

Turns on the use of trusted peer certificates. This allows for loading in a peer certificate to match with a connection rather than using a CA. When turned on if a trusted peer certificate is matched than the peer cert chain is not loaded and the peer is considered verified. Using CAs is preferred.

#### WOLFSSL_STATIC_MEMORY

Turns on the use of static memory buffers and functions. This allows for using static memory instead of dynamic.

#### WOLFSSL_STATIC_MEMORY_LEAN

It requires `WOLFSSL_STATIC_MEMORY` to be defined. It uses smaller type sizes for structs requiring memory pool sizes of less than 65k and limits features available, like IO buffers, to reduce footprint size.

#### WOLFSSL_SESSION_EXPORT

Turns on the use of DTLS session export and import. This allows for serializing and sending/receiving the current state of a DTLS session.

#### WOLFSSL_ARMASM

Turns on the use of ARMv8 hardware acceleration.

#### WC_RSA_NONBLOCK

Turns on fast math RSA non-blocking support for splitting RSA operations into smaller chunks of work. Feature is enabled by calling [`wc_RsaSetNonBlock()`](group__RSA.md#function-wc_rsasetnonblock) and checking for `FP_WOULDBLOCK` return code.

#### WC_RSA_BLINDING

Used to enable timing resistance.

#### WC_RSA_PSS

Enables RSA PSS padding. The only TLS 1.3 RSA padding scheme supported is PSS (per specification). PSS padding uses random padding.

#### WOLFSSL_RSA_VERIFY_ONLY

Turns on small build for RSA verify only use. Should be used with the macros [`WOLFSSL_RSA_PUBLIC_ONLY`](#wolfssl_rsa_public_only), [`WOLFSSL_RSA_VERIFY_INLINE`](#wolfssl_rsa_verify_inline), [`NO_SIG_WRAPPER`](#no_sig_wrapper), and [`WOLFCRYPT_ONLY`](#wolfcrypt_only).

#### WOLFSSL_RSA_PUBLIC_ONLY

Turns on small build for RSA public key only use. Should be used with the macro [`WOLFCRYPT_ONLY`](#wolfcrypt_only).

#### WOLFSSL_SHA3

Turns on build for SHA3 use. This is support for SHA3 Keccak for the sizes SHA3-224, SHA3-256, SHA3-384 and SHA3-512. In addition `WOLFSSL_SHA3_SMALL` can be used to trade off performance for resource use.

#### USE_ECDSA_KEYSZ_HASH_ALGO

Will choose a hash algorithm that matches the ephemeral ECDHE key size or the next highest available. This workaround resolves issues with some peers that do not properly support scenarios such as a P-256 key hashed with SHA512.

#### WOLFSSL_ALT_CERT_CHAINS

Allows CA's to be presented by peer, but not part of a valid chain. Default wolfSSL behavior is to require validation of all presented peer certificates. This also allows loading intermediate CA's as trusted and ignoring no signer failures for CA's up the chain to root. The alternate certificate chain mode only requires that the peer certificate validate to a trusted CA.

#### WOLFSSL_SYS_CA_CERTS

Allows wolfSSL to use trusted system CA certificates for verification when [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.html#function-wolfssl_ctx_load_system_ca_certs) is called, either by loading them into wolfSSL certificate manager, or by invoking system authentication APIs. See [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.html#function-wolfssl_ctx_load_system_ca_certs) for more details. This preprocessor macro is automatically set by the `--enable-sys-ca-certs` configure option.

#### WOLFSSL_APPLE_NATIVE_CERT_VERIFICATION

Enables the use of Apple's native trust APIs when authenticating TLS peer certificates. Requires [WOLFSSL_SYS_CA_CERTS](#WOLFSSL_SYS_CA_CERTS) to be defined. This macro does not need to be set by the user if building with `configure` or `CMake` on iOS or other apple devices, but should be explicitly set on MacOS if you wish to use the native verification methods.

#### WOLFSSL_CUSTOM_CURVES

Allow non-standard curves. Includes the curve "a" variable in calculation. Additional curve types can be enabled using [`HAVE_ECC_SECPR2`](#have_ecc_secpr2), [`HAVE_ECC_SECPR3`](#have_ecc_secpr3), [`HAVE_ECC_BRAINPOOL`](#have_ecc_brainpool) and [`HAVE_ECC_KOBLITZ`](#have_ecc_koblitz).

#### HAVE_COMP_KEY

Enables ECC compressed key support.

#### WOLFSSL_EXTRA_ALERTS

Enables additional alerts to be sent during a TLS connection. This feature is also enabled automatically when [`--enable-opensslextra`](#--enable-opensslextra) is used.

#### WOLFSSL_DEBUG_TLS

Enables additional debugging print outs during a TLS connection

#### HAVE_BLAKE2

Enables Blake2s algorithm support

#### HAVE_FALLBACK_SCSV

Enables Signaling Cipher Suite Value(SCSV) support on the server side. This handles the cipher suite 0x56 0x00 sent from a client to signal that no downgrade of TLS version should be allowed.

#### HAVE_AEAD

Implements the use of AEAD and is required for TLS 1.3.

#### HAVE_AES_CBC

Enable option for AES CBC.

#### HAVE_ALPN

Crypto enables the option for application-layer protocol negotiation.

#### HAVE_CAVIUM_OCTEON_SYNC

This enables the blocking (synchronous) version of the Marvell Cavium/Octeon hardware.

#### HAVE_CERTIFICATE_STATUS_REQUEST

Used for Certificate revocation as a cert status request feature.

#### HAVE_CERTIFICATE_STATUS_REQUEST_V2

Used for Certificate revocation as a cert status request feature.

#### HAVE_IO_TIMEOUT

Certificate revocation. IO options enable support for connect timeout, but the default is off.

#### HAVE_CURL

Used for building a subset of the wolfSSL library when linking with cURL.

#### HAVE_CURVE448

Define for Curve448 support. Additional macro settings can be changed. The default is to enable shared secret, key export, and import.

#### HAVE_DANE

This option is only supported with `HAVE_RPK` (Raw Public Keys) and is a placeholder for when it might be added in the future.

#### HAVE_DILITHIUM

Enable to include DILITHIUM post quantum cryptography/signature algo.

#### HAVE_ED25519_KEY_IMPORT

ED25519 config. Enables Ed255519 and Curve25519 options for granular control of sign, verify, shared secret, import, and export.

#### HAVE_EX_DATA

Enable "extra" EX data APIs for user information in CTX/WOLFSSL.

#### HAVE_EX_DATA_CLEANUP_HOOKS

Set the extra data and cleanup callback against the RSA key at an index.

#### HAVE_FALCON

Enables post-quantum crypto FALCON from OpenQuantumSafe.

#### HAVE_FIPS

Used when implementing different FIPS versions.

#### HAVE_KEYING_MATERIAL

Enables exporting keying material based on section 7.5 of RFC 8446.

#### HAVE_OID_DECODING

Included in ASN template code. Used to decode in some cases.

#### HAVE_MAX_FRAGMENT

Sets maximum fragment size. TLS extension.

#### WOLFSSL_PSK_ONE_ID

Enables support for only one PSK ID with TLS 1.3.

#### SHA256_MANY_REGISTERS

A SHA256 version that keeps all data in registers and partially unrolls loops.

#### WOLFCRYPT_HAVE_SRP

Enables wolfCrypt secure remote password support

#### WOLFSSL_MAX_STRENGTH

Enables the strongest security features only and disables any weak or deprecated features. This results in slower performance due to near constant-time execution to protect against timing-based side-channel attacks.

#### MAX_RECORD_SIZE

Determine maximum record size. 2^14 is the max size by standard.

#### MAX_CERTIFICATE_SZ

Defines the max size of a certificate message payload assumes MAX_CHAIN_DEPTH number of certificates at 2kb per certificate.

#### MAX_CHAIN_DEPTH

Defines the max chain depth.

#### MAX_CIPHER_NAME

Defines max cipher name.

#### MAX_DATE_SIZE

Defines max size of date either used as byte lastdate, or byte nextdate.

#### MAX_EARLY_DATA_SZ

Used to define the maximum early data size.

#### WOLFSSL_MAX_SEND_SZ

Define to specify max send size.

#### WOLFSSL_MAX_SUITE_SZ

Define to specify max suite size. If too small error out.

#### MAX_WOLFSSL_FILE_SIZE

4 MB allocated size limit.

#### WOLFSSL_MAXQ10XX_TLS

Lets maxq10xx know what TLS version we are using.

#### WOLFSSL_MAX_SIGALGO

Enables the ability to override maximum signature algorithms.

#### WOLFSSL_MEM_GUARD

Can assign a specified memory guard.

#### WOLFSSL_STATIC_EPHEMERAL

TLS sniffer support.

#### SSL_SNIFFER_EXPORTS

WIN32 sniffer export.

#### WOLFSSL_SNIFFER_KEYLOGFILE

The SSL Keylog file option enables the sniffer to decrypt TLS traffic using the master secret obtained from a [NSS keylog file](https://web.archive.org/web/20220531072242/https://firefox-source-docs.mozilla.org/security/nss/legacy/key_log_format/index.html). This allows the sniffer to decrypt all TLS traffic, even for TLS connections using ephemeral cipher suites. Keylog file sniffing is supported for TLS versions 1.2 and 1.3. WolfSSL can be configured to export a keylog file using the `--enable-keylog-export` configure option, independently from the sniffer feature (NOTE: never do this in a production environment, as it is inherently insecure). To enable sniffer support for keylog files, use the following configure command line and build as before: ./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_KEYLOGFILE`.

#### WOLFSSL_SNIFFER_STORE_DATA_CB

The Store Data Callback option allows the sniffer to take a callback that is called when storing the application data into a custom buffer rather than into the reallocated data pointer. The callback is called in a loop until all data is consumed. To enable this option, use the following configure command line and build as before: `./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_STORE_DATA_CB`.

#### WOLFSSL_SNIFFER_WATCH

The Session Watching option allows the sniffer to watch any packet provided without initial setup. It will start to decode all TLS sessions and when the server's certificate is detected, the certificate is given to a callback function provided by the user which should provide the appropriate private key. To enable this option, use the following configure command line and build as before: `./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_WATCH`.

#### STATIC_BUFFER_LEN

Don't fragment memory from the record header. Expands to: `RECORD_HEADER_SZ`.

#### STATIC_CHUNKS_ONLY

The user has the option to turn off the 16K output option if we are using small static buffers (the default) and SSL_write tries to write data larger than the record we have, dynamically getting it unless the user says only write in static buffer chunks.

#### WOLFSSL_DEF_PSK_CIPHER

Enables user-defined PSK cipher.

#### WOLFSSL_OLD_PRIME_CHECK

Enable feature which uses faster DH and RSA prime checking.

#### WOLFSSL_STATIC_RSA

Static ciphers are strongly discouraged and should never be used if avoidable. However there are still legacy systems that ONLY support static cipher suites. To that end if you need to connect to a legacy peer only supporting static RSA cipher suites use this to enable support for static RSA in wolfSSL. (See also [`WOLFSSL_STATIC_PSK`](#wolfssl_static_psk) and [`WOLFSSL_STATIC_DH`](#wolfssl_static_dh))

#### WOLFSSL_STATIC_PSK

Feature that enables static PSK cipher suites. Static ciphers are highly discouraged see [`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)

#### WOLFSSL_STATIC_DH

Feature that enables static ECDH cipher suites. Static ciphers are highly discouraged see [`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)

#### HAVE_NULL_CIPHER

Turns on support for NULL ciphers. This option is highly discouraged from a security standpoint however some systems are too small to perform encrypt/decrypt operations and it is better to at least authenticate messages and peers to prevent message tampering than nothing at all!

#### HAVE_ANON

Turns on support for anonymous cipher suites. (Never recommended, some valid use cases involving closed or private networks detached from the web)

#### HAVE_LIBOQS

Turn on support for the OpenQuantumSafe team's liboqs integration. Please see the appendix "Experimenting with Quantum-Safe Cryptography" in this document for more details.

#### WOLFSSL_SP_4096

Enable RSA/DH 4096-bit Single-Precision (SP) support.

#### WOLFSSL_SP_384

Enable ECC SECP384R1 Single-Precision (SP) support. Only applies to `WOLFSSL_SP_MATH`.

#### WOLFSSL_SP_1024

Enable SAKKE pairing based cryptography Single-Precision (SP) support.

#### ATOMIC_USER

Enable Atomic Record Layer callbacks.

#### BIG_ENDIAN_ORDER

Endianness - defaults to little endian, i.e., makes big-endian.

#### WOLFSSL_32BIT_MILLI_TIME

Function TimeNowInMilliseconds() returns an unsigned 32-bit value. The default behavior is to return a signed 64-bit value.

#### WOLFSSL_MAX_DHKEY_BITS

DH maximum bit size must be a multiple of 8. DH maximum bit size must not exceed 16384 or greater than `WOLFSSL_MIN_DHKEY_BITS`.

#### WOLFSSL_MIN_DHKEY_BITS

The DH minimum bit size must be a multiple of 8. For 112 bits of security, DH needs at least 2048-bit keys, and the minimum bit size must not be greater than 16000.

#### WOLFSSL_MAX_MTU

Max expected MTU. 1500 - 100 bytes to account for UDP and IP headers.

#### IGNORE_NETSCAPE_CERT_TYPE

Define to input netscape cert type but holds a place.

#### SESSION_CERTS

TLS session cache for certs.

#### WOLFSSL_DUAL_ALG_CERTS

Dual algorithm certificate required feature.

#### CRL_MAX_REVOKED_CERTS

Specifies the number of buffers to hold RevokedCerts. The default value is set to 4.

#### CRL_STATIC_REVOKED_LIST

Enables a fixed static list of RevokedCerts to allow for a binary search.

#### SESSION_INDEX

Identifies the session's location in the cache. Specifies index session/row shifts.

#### SESSION_TICKET_HINT_DEFAULT

The ticket hint default is used to set the default hint value. The Ticket Key lifetime must be longer than the ticket life hint.

#### WOLFSSL_DTLS13

Enable wolfSSL DTLS 1.3.

#### WOLFSSL_TLS13

Enable TLS 1.3 protocol implementation.

#### WOLFSSL_TLS13_IGNORE_AEAD_LIMITS

Limits specified by https://www.rfc-editor.org/rfc/rfc9147.html#name-aead-limits. We specify the limit by which we need to do a key update as the halfway point to the hard decryption fail limit.

#### WOLFSSL_TLS13_MIDDLEBOX_COMPAT

Enable middlebox compatibility in the TLS 1.3 handshake. This includes sending ChangeCipherSpec before encrypted messages and including a session ID.

#### WOLFSSL_TLS13_SHA512

Allow generation of SHA-512 digests in handshake - no ciphersuite requires SHA-512 at this time. This enables calculation of a SHA2-512 hash for the handshake messages even though its not used by TLS v1.3 yet.

#### WOLFSSL_UIP

When CONTIKI is defined, it is an implementation of UIP.

#### TLS13_MAX_TICKET_AGE

Specifies Max ticket age. For TLS 1.3, this is 7 days.

#### TLS13_TICKET_NONCE_STATIC_SZ

TLS13_TICKET_NONCE_STATIC_SZ is not supported in this `FIPS_VERSION_GE`.

#### TLS13_TICKET_NONCE_MAX_SZ

Defines version max size for ticket nonce. Max size is defined as 255 bytes.

#### WOLFSSL_TICKET_ENC_AES128_GCM

Use AES128-GCM to encrypt/decrypt session tickets in the default callback. This is server-only. If ChaCha20/Poly1305 is not compiled, this is the default algorithm.

#### WOLFSSL_TICKET_ENC_AES256_GCM

Use AES256-GCM to encrypt/decrypt session tickets in default callback. Server only.

#### WOLFSSL_TICKET_ENC_CHACHA20_POLY1305

Use ChaCha20-Poly1305 to encrypt/decrypt session tickets in the default callback. If none are defined, the default algorithm is used, and algorithms are compiled. This is server-only.

#### WOLFSSL_TICKET_EXTRA_PADDING_SZ

Defines ticket extra padding size defined as 32.

#### WOLFSSL_TICKET_HAVE_ID

Use to make sure the ticket has ID. Only add to the cache when support is built in and when the ticket contains an ID. Otherwise we have no way to actually retrieve a ticket from the cache.

#### WOLFSSL_TICKET_KEY_LIFETIME

The default lifetime is 1 hour from the issue of the first ticket with the key. It must be longer than a hint.

#### WOLFSSL_TICKET_NONCE_MALLOC

Enable dynamic allocation of ticket nonces. Need to disable the HKDF expand callbacks.

#### SHOW_CERTS

Show certs will output certs when defined. Use for embedded debugging.

#### SHOW_SECRETS

Used for debugging. It will show applicable secrets.

#### DEBUG_UNIT_TEST_CERTS

Used when debugging name constraint tests. Not static to allow use in multiple locations with complex define guards.

#### DEBUG_WOLFSSL_VERBOSE

When using the `OPENSSL_EXTRA` or `DEBUG_WOLFSSL_VERBOSE` macro, `WOLFSSL_ERROR` is mapped to the new function `WOLFSSL_ERROR_LINE`, which gets the line number and function name where `WOLFSSL_ERROR` is called.

#### SOCKET_INVALID

Used to define an invalid socket and is defined as -1.

#### WOLFSSL_SOCKET_INVALID

Used for testing and it only allows overriding the value used to indicate an invalid socket. Typically is -1.

#### WOLFSSL_SOCKET_IS_INVALID

Used in socket handling.

#### WOLFSSL_SRTP

Used to activate SRTP.

#### WOLFSSL_CIPHER_CHECK_SZ

Defined as cipher check size which needs 64-bits to confirm encrypt operation worked.

#### DTLS_CID_MAX_SIZE

DTLS 1.3 parsing code copies the record header in a static buffer to decrypt the record. Increasing the CID max size also increases this buffer, impacting the per-session runtime memory footprint. The max size for DTLS CID is 255 bytes.

#### DTLS13_EPOCH_SIZE

Portability improvement with DTLS 1.3 epoch. Implements a way to save the key bound to a DTLS epoch and setting
the right key/epoch when needed.

#### DTLS13_RETRANS_RN_SIZE

Portability improvement with DTLS 1.3. Used in DTLS 1.3 to identify size before retransmission.

#### WOLFSSL_DTLS_FRAG_POOL_SZ

Defines the allowed number of fragments per specified time.

#### WOLFSSL_CLIENT_SESSION_DEFINED

Declare opaque struct for API to use.

#### WOLFSSL_COND

Defined if this system supports signaling COND_TYPE - type that should be passed into the signaling API.

#### WOLFSSL_DTLS_CH_FRAG

Allows a server to process a fragmented second/verified (one containing a valid cookie response) ClientHello message. The first/unverified (one without a cookie extension) ClientHello MUST be unfragmented so that the DTLS server can process it statelessly. This is only implemented for DTLS 1.3. The user MUST call `wolfSSL_dtls13_allow_ch_frag()` on the server to explicitly enable this during runtime. Note: Using DTLS 1.3 + pqc without `WOLFSSL_DTLS_CH_FRAG` will probably fail In this case use `--enable-dtls-frag-ch` to enable it.

#### WOLFSSL_DTLS_MTU_ADDITIONAL_READ_BUFFER

We need additional bytes to read so that we can work with a peer who has a slightly different MTU than us.

#### WOLFSSL_DTLS_WINDOW_WORDS

Used to check storage size or to verify if an index is valid for window.

#### WOLFSSL_EXPORT_SPC_SZ

Define to specify the amount of bytes used from CipherSpecs.

#### WOLFSSL_MIN_DOWNGRADE

Specifies minimum downgrade version.

#### WOLFSSL_MIN_DTLS_DOWNGRADE

Specifies minimum DTLS downgrade version.

#### WOLFSSL_MIN_ECC_BITS

Can set minimum ECC key size allowed.

#### WOLFSSL_MIN_RSA_BITS

By default, wolfSSL restricts RSA key sizes to 1024-bits minimum. To allow the decoding of smaller, less secure RSA keys like 512-bit keys, you will need to add the compiler flag `-DWOLFSSL_MIN_RSA_BITS=512` to CFLAGS or CPPFLAGS or define it in your user-settings header.

#### WOLFSSL_MODE_AUTO_RETRY_ATTEMPTS

Used to limit the possibility of an infinite retry loop.

#### WOLFSSL_MULTICAST

DTLS multicast feature.

#### WOLFSSL_MULTICAST_PEERS

Multicast feature defined as max allowed 100 peers.

#### WOLFSSL_NAMES_STATIC

Uses static ECC structs for Position Independent Code (PIC).

#### WOLFSSL_SEND_HRR_COOKIE

TLS extension used by DTLS 1.3.

#### WOLFSSL_SEP

Feature certificate policy set extension.

#### WOLFSSL_SESSION_ID_CTX

Used to copy over application session context ID.

#### WOLFSSL_SESSION_TIMEOUT

Default session resumption cache timeout in seconds is used to define timeout manually.

#### KEEP_OUR_CERT

Used to ensure the ability to return SSL certificate.

#### KEEP_PEER_CERT

Retains peer certs. Parts of the OpenSSL compatibility layer require peer certs.

#### WOLFSSL_SIGNER_DER_CERT

This enables retention of the DER/ASN.1 used for signing. This is used by the compatibility layer an example of this is `wolfSSL_X509_STORE_get1_certs`.

#### CA_TABLE_SIZE

Used by the wolfSSL Certificate Manager signer table. The default `CA_TABLE_SIZE` is 11, but this can be adjusted based on actual needs. Each `WOLFSSL_CTX` has its own Certificate Manager (CM).

#### ECDHE_SIZE

Define to allow this to be overridden at compile-time. ECDHE server size defaults to 256 bits, which can set a predetermined ECDHE curve size. The default is 32 bytes.

#### CIPHER_NONCE

It is used as a cryptographic number, which is implemented in authentication. It is a pseudo-random number, which is an integrity-only cipher suite.

#### WOLFSSL_USE_POPEN_HOST

Uses popen for creating socket with host and post for wolfio.c socket open code used with CRL and OCSP.

#### CloseSocket

A way to override the function used for closing a socket. Used with CRL, OCSP and BIO.

#### CONFIG_POSIX_API

Enables POSIX names for networking systems calls.

#### WOLFSSL_USER_CURRTIME

Add in the option to use in test.h without the gettimeofday function using the macro `WOLFSSL_USER_CURRTIME`.

#### WOLFSSL_USER_MUTEX

Option for user-defined mutexes with `WOLFSSL_USER_MUTEX`.

#### DEFAULT_MIN_ECCKEY_BITS

Identifies the minimum number of bits in ECCkey.

#### DEFAULT_MIN_RSAKEY_BITS

Identifies the minimum number of bits in RSA key.

#### EXTERNAL_SERIAL_SIZE

A raw serial number byte that writes X509 serial numbers in unsigned binary to a buffer. For all cases, the buffer needs to be at least `EXTERNAL_SERIAL_SIZE` (32). On success, it returns `WOLFSSL_SUCCESS`. Note: this is a internal macro that cannot be user defined.

#### LARGE_STATIC_BUFFERS

Embedded callbacks require large static buffers; make sure it gives the option to enable larger buffers to 16K.

#### LIBWOLFSSL_VERSION_STRING

This is the wolfSSL version string populated for release bundles or when `./configure` is run. There is also a 32-bit HEX version of this in `LIBWOLFSSL_VERSION_HEX`. These come from wolfssl/version.h.


### Customizing or Porting wolfSSL

#### WOLFSSL_USER_SETTINGS

If defined, it allows the use of a user-specific settings file. The file must be named `user_settings.h` and exist in the include path. It is included prior to the standard `settings.h` file, so default settings can be overridden.

#### WOLFSSL_CALLBACKS

This extension allows debugging callbacks through the use of signals in an environment without a debugger. It is off by default. It can also be used to set up a timer with blocking sockets. Please see [Callbacks](chapter06.md#callbacks) for more information.

#### WOLF_CRYPTO_CB

 Enable crypto callback support. This feature is also enabled automatically when [`--enable-cryptocb`](#enable-cryptocb) is used.

#### WOLFSSL_DYN_CERT

Allow allocation of subjectCN and publicKey fields when parsing certificates even with WOLFSSL_NO_MALLOC set. If using the WOLFSSL_NO_MALLOC option with RSA certificates the public key needs to be retained for CA's for validate certificates on the peer's certificate. This appears as a ConfirmSignature error -173 BAD_FUNC_ARG, since the ca->publicKey is NULL.

#### WOLFSSL_USER_IO

Allows the user to remove automatic setting of the default I/O functions [`EmbedSend()`](wolfio_8h.md#function-embedsend) and [`EmbedReceive()`](wolfio_8h.md#function-embedrecieve). Used for custom I/O abstraction layer (see [Abstraction Layers](chapter05.md#abstraction-layers) for more details).

#### NO_FILESYSTEM

Is used if stdio isn't available to load certificates and key files. This enables the use of buffer extensions to be used instead of the file ones.

#### NO_INLINE

Disables the automatic inlining of small, heavily used functions. Turning this on will slow down wolfSSL and actually make it bigger since these are small functions, usually much smaller than function call setup/return. You’ll also need to add `wolfcrypt/src/misc.c` to the list of compiled files if you’re not using autoconf.

#### NO_DEV_RANDOM

Disables the use of the default `/dev/random` random number generator. If defined, the user needs to write an OS-specific `GenerateSeed()` function (found in `wolfcrypt/src/random.c`).

#### NO_MAIN_DRIVER

Is used in the normal build environment to determine whether a test application is called on its own or through the testsuite driver application. You'll only need to use it with the test files: `test.c`, `client.c`, `server.c`, `echoclient.c`, `echoserver.c`, and `testsuite.c`

#### NO_WRITEV

Disables simulation of `writev()` semantics.

#### SINGLE_THREADED

Is a switch that turns off the use of mutexes. wolfSSL currently only uses one for the session cache. If your use of wolfSSL is always single threaded you can turn this on.

#### USER_TICKS

Allows the user to define their own clock tick function if time(0) is not wanted. Custom function needs second accuracy, but doesn’t have to be correlated to Epoch. See `LowResTimer()` function in `wolfssl_int.c`.

#### USER_TIME

Disables the use of time.h structures in the case that the user wants (or needs) to use their own. See `wolfcrypt/src/asn.c` for implementation details. The user will need to define and/or implement `XTIME()`, `XGMTIME()`, and `XVALIDATE_DATE()`.

#### USE_CERT_BUFFERS_256

Enables 256-bit test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_CERT_BUFFERS_1024

Enables 1024-bit test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_CERT_BUFFERS_2048

Enables 2048-bit test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_CERT_BUFFERS_3072

Enables 3072-bit test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_CERT_BUFFERS_4096

Enables 4096-bit test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_CERT_BUFFERS_25519

Enables Ed25519 test certificate and key buffers located in `<wolfssl_root>/wolfssl/certs_test.h`. Helpful when testing on and porting to embedded systems with no filesystem.

#### USE_WOLFSSL_IO

This macro enables callbacks to send/recv. You can find an example of it in use here: (https://github.com/wolfSSL/wolfssl-examples/blob/master/tls/client-tls-callback.c#L6)

#### CUSTOM_RAND_GENERATE_SEED

Allows user to define custom function equivalent to `wc_GenerateSeed(byte* output, word32 sz)`.

#### CUSTOM_RAND_GENERATE_BLOCK

Allows user to define custom random number generation function. Examples of use are as follows.

```sh
./configure --disable-hashdrbg
CFLAGS="-DCUSTOM_RAND_GENERATE_BLOCK= custom_rand_generate_block"
```

Or

```c
/* RNG */
/* #define HAVE_HASHDRBG */
extern int custom_rand_generate_block(unsigned char* output, unsigned int sz);
```

#### NO_PUBLIC_GCM_SET_IV

Use this if you have done your own custom hardware port and not provided a public implementation of [`wc_AesGcmSetIV()`](group__AES.md#function-wc_aesgcmsetiv)

#### NO_PUBLIC_CCM_SET_NONCE

Use this if you have done your own custom hardware port and not provided a public implementation of `wc_AesGcmSetNonce()`

#### NO_GCM_ENCRYPT_EXTRA

Use this if you have done your own custom hardwareport and not provided an implementation of `wc_AesGcmEncrypt_ex()`

#### WOLFSSL_STM32[F1 | F2 | F4 | F7 | L4]

Use one of these defines when building for the appropriate STM32 device. Update `wolfssl-root/wolfssl/wolfcrypt/settings.h` section with regards to the wolfSSL porting guide (<https://www.wolfssl.com/docs/porting-guide/>) as appropriate.

#### WOLFSSL_STM32_CUBEMX

When using the CubeMX tool to generate Hardware Abstraction Layer (HAL) API’s use this setting to add appropriate support in wolfSSL.

#### WOLFSSL_CUBEMX_USE_LL

When using the CubeMX tool to generate APIs there are two options, HAL (Hardware Abstraction Layer) or Low Layer (LL). Use this define to control which headers are include in `wolfssl-root/wolfssl/wolfcrypt/settings.h` in the `WOLFSSL_STM32[F1/F2/F4/F7/L4]` section.

#### NO_STM32_CRYPTO

For when an STM32 part does not offer hardware crypto support

#### NO_STM32_HASH

For when an STM32 part does not offer hardware hash support

#### NO_STM32_RNG

For when an STM32 part does not offer hardware RNG support

#### XTIME_MS

Macro to map a function for use to get the time in milliseconds when using TLS 1.3. Example being:

```c
extern time_t m2mb_xtime_ms(time_t * timer);
#define XTIME_MS(tl) m2mb_xtime_ms((tl))
```

#### WOLFSSL_CIPHER_TEXT_CHECK

Define this to check for possible glitching attack against the AES encrypt
operation during a TLS connection.

#### RTTHREAD

RT-THREAD macro is used when porting rtthread IoT to wolfSSL.

#### SO_REUSEPORT

Allows local address and port reuse.

#### INTIME_RTOS

Port setting for INtime RTOS.

#### WOLFSSL_SGX

Used when porting to SGX.


### Reducing Memory or Code Usage

#### TFM_TIMING_RESISTANT

Can be defined when using fast math ([`USE_FAST_MATH`](#use_fast_math)) on systems with a small stack size. This will get rid of the large static arrays.

#### ECC_TIMING_RESISTANT

This is used as a Timing Resistance feature that enables code in ecc.c to prevent side channel and differential power analysis (DPA) attacks.

#### FUSION_RTOS

A Fusion RTOS implementation is used for tickets to represent the difference between when they are first seen and when they are sent. It returns the time in milliseconds as a 32-bit value.

#### WOLFSSL_SMALL_STACK

Can be used for devices which have a small stack size. This increases the use of dynamic memory in `wolfcrypt/src/integer.c`, but can lead to slower performance.

#### ALT_ECC_SIZE

If using fast math and RSA/DH you can define this to reduce your ECC memory consumption. Instead of using stack for ECC points it will allocate from the heap.

#### ECC_SHAMIR

Uses variation of ECC math that is slightly faster, but doubles heap usage.

#### RSA_LOW_MEM

When defined CRT is not used which saves on some memory but slows down RSA operations. It is off by default.

#### WOLFSSL_SHA3_SMALL

When SHA3 is enabled this macro will reduce build size.

#### WOLFSSL_SMALL_CERT_VERIFY

Verify the certificate signature without using DecodedCert. Doubles up on some code but allows smaller peak heap memory usage. Cannot be used with [`WOLFSSL_NONBLOCK_OCSP`](#wolfssl_nonblock_ocsp).

#### GCM_SMALL

Option to reduce AES GCM code size by calculating at runtime instead of using tables. Possible options are: `GCM_SMALL`, `GCM_WORD32` or `GCM_TABLE`.

#### CURVED25519_SMALL

Defines [`CURVE25519_SMALL`](#curve25519_small) and [`ED25519_SMALL`](#ed25519_small).

#### CURVE25519_SMALL

Use small memory option for curve25519. This uses less memory, but is slower.

#### ED25519_SMALL

Use small memory option for ed25519. This uses less memory, but is slower.

#### USE_SLOW_SHA

Reduces code size by not unrolling loops, which reduces performance for SHA.

#### USE_SLOW_SHA256

Reduces code size by not unrolling loops, which reduces performance for SHA. About 2k smaller and about 25% slower.

#### USE_SLOW_SHA512

Reduces code size by not unrolling loops, which reduces performance for SHA. Over twice as small, but 50% slower.

#### ECC_USER_CURVES

Allow user to choose ECC curve sizes that are enabled. Only the 256-bit curve is enabled by default. To enable others use `HAVE_ECC192`, `HAVE_ECC224`, etc...

#### WOLFSSL_SP_NO_MALLOC

In the SP code, always use stack, no heap XMALLOC()/XREALLOC()/XFREE() calls are made.

#### WOLFSSL_SP_NO_DYN_STACK

Disable use of dynamic stack items. Used with small code size and not small stack.

#### WOLFSSL_SP_FAST_MODEXP

Compiles in a faster mod_exp implementation at the expense of code size.

#### WC_DISABLE_RADIX_ZERO_PAD

Disable printing of leading zero in hexidecimal string output. For example, if this macro is defined, the value 8 will be printed as the string "0x8" but if it is not defined it will be printed as "0x08". Defining this macro can reduce code size.

#### WC_ASN_NAME_MAX

This allows overriding the maximum name support for an X.509 certificate field.

#### OPENSSL_EXTRA_X509_SMALL

Special small OpenSSL compat layer for certs.


### Increasing Performance

#### USE_INTEL_SPEEDUP

Enables use of Intel’s AVX/AVX2 instructions for accelerating AES, ChaCha20, Poly1305, SHA256, SHA512, ED25519 and Curve25519.

#### WOLFSSL_AESNI

Enables use of AES accelerated operations which are built into some Intel and AMD chipsets. When using this define, the `aes_asm.asm` (for Windows with at&t syntax) or `aes_asm.S` file is used to optimize via the Intel AES new instruction set (AESNI).

#### HAVE_INTEL_RDSEED

Enable Intel’s RDSEED for DRBG seed source.

#### HAVE_INTEL_RDRAND

Enable Intel’s RDRAND instruction for wolfSSL’s random source.

#### FP_ECC

Enables ECC Fixed Point Cache, which speeds up repeated operations against same private key. Can also define number of entries and LUT bits using `FP_ENTRIES` and `FP_LUT` to reduce default static memory usage.

#### WOLFSSL_ASYNC_CRYPT

This enables support for asynchronous cryptography using hardware based adapters such as the Intel QuickAssist or Marvell (Cavium) Nitrox V. The asynchronous code is not included in the public distribution and is available for evaluation by contacting us via email at facts@wolfssl.com.

#### WOLFSSL_NO_ASYNC_IO

This disables the asynchronous I/O networking. Asynchronous I/O is on by default and can take up to around 140 bytes during the handshaking process. If your network interface doesn't return `SOCKET_EWOULDBLOCK` or `SOCKET_EAGAIN` (or `WOLFSSL_CBIO_ERR_WANT_WRITE` for custom I/O callbacks) on writing you can define `WOLFSSL_NO_ASYNC_IO` to have wolfSSL not save the state while building handshake messages.

### GCM Performance Tuning

There are 4 variants of GCM performance:

* `GCM_SMALL` - Smallest footprint, slowest (FIPS validated)
* `GCM_WORD32` - Medium (FIPS validated)
* `GCM_TABLE` - Fast (FIPS validated)
* `GCM_TABLE_4BIT` - Fastest (FIPS validated)

### wolfSSL’s Math Options

There are three math libraries in wolfSSL.

* Big Integer
* Fast Math
* Single Precision Math

When building wolfSSL, only one of these must be used.

Big Integer Library is the most portable option as it is written in C without any assembly. As such it is not optimized for specific architectures. All math variables are instantiated on the heap; minimal stack usage. Unfortunately, Big Integer Library is not timing resistant.

Fast Math Library is a good option. It is implemented using both C and assembly. As such, it has optimizations for specific architectures. All math variables are instantiated on the stack, leading to less heap usage. It can be made timing resistant if the `TFM_TIMING_RESISTANT` macro is defined. We have taken it through FIPS 140-2 and 140-3 certifications.

Single Precision (SP) Math Library is our recommended library. It is implemented using both C and assembly. As such, it has optimizations for specific architectures. All math variables are instantiated on the stack, leading to less heap usage. It is always timing resistant. It is generally optimized for speed at the cost of code size, but is highly configurable to compile out unneeded code. We have taken it through DO-178C certifications.

#### Big Integer Math Library (Deprecation Planned)

This library is planned to be deprecated and removed from the wolfSSL/wolfCrypt library by the end of 2023. If desired this can be enabled with `--enable-heapmath` or `CFLAGS=-DUSE_INTEGER_HEAP_MATH`.

Forked from public domain LibTomMath library. For more information about LibTomMath, please see <https://www.libtom.net/LibTomMath/>. Please note that our fork is considerably more active and secure than the original public domain code.

This library is generally the most portable and easiest to get going with. The negatives to the normal big integer library are that it is slower, it uses a lot of heap memory as all memory is allocated from the heap, requires an `XREALLOC()` implementation, and is not timing resistant. The implementation can be found in `integer.c`.

#### Fast Math

##### USE_FAST_MATH

Forked from public domain LibTomFastMath library. For more information about LibTomFastMath, please see <https://www.libtom.net/TomsFastMath>. Please note that our fork is considerably more active and secure than the original public domain code from LibTomFastMath. We have improved performance, security and code quality. Also we have taken the FastMath code through  FIPS 140-2 and 140-3 certifications.

The FastMath library uses assembly if possible, and will speed up asymmetric private/public key operations like RSA, DH, and DSA. Assembly inclusion is dependent on compiler and processor combinations. Some combinations will need additional configure flags and some may not be possible. Help with optimizing FastMath with new assembly routines is available on a consulting basis. See the Architecture-Specific Optimizations.

For FastMath, all memory is allocated on the stack. Because the stack memory usage can be larger when using FastMath, we recommend defining [`TFM_TIMING_RESISTANT`](#tfm_timing_resistant) as well when using this option. The FastMath code is timing resistant if TFM_TIMING_RESISTANT is defined. This will reduce some of the large math windows for constant time, which use less memory. This uses less stack because there are no shortcuts and therefore less branching during private key operations. This also makes the implementation more secure as timing attacks are a real threat and can give malicious third parties enough information to reproduce the private key.

On ia32, for example, all of the registers need to be available so high optimization and omitting the frame pointer needs to be taken care of. wolfSSL will add `-O3 -fomit-frame-pointer` to GCC for non debug builds. If you're using a different compiler you may need to add these manually to `CFLAGS` during configure.

OS X will also need `-mdynamic-no-pic` added to `CFLAGS`. In addition, if building in shared mode for ia32 on OS X you'll need to pass options to `LDFLAGS` as well:

```sh
LDFLAGS="-Wl,-read_only_relocs,warning"
```

This gives warnings for some symbols instead of errors.

FastMath also changes the way dynamic and stack memory are used. The normal math library uses dynamic memory for big integers. FastMath uses fixed size buffers that hold 4096 bit integers by default, allowing for 2048 bit by 2048 bit multiplications. If you need 4096 bit by 4096 bit multiplications then change `FP_MAX_BITS` in `wolfssl/wolfcrypt/tfm.h`. As `FP_MAX_BITS` is increased, this will also increase the runtime stack usage since the buffers used in the public key operations will now be larger. `FP_MAX_BITS` needs to be double the max key size. For example if your biggest key is 2048-bit, `FP_MAX_BITS` should be 4096 and if it is 4096-bit `FP_MAX_BITS` should be 8192. If using ECC only this can be reduced to the maximum ECC key size times two. A couple of functions in the library use several temporary big integers, meaning the stack can get relatively large. This should only come into play on embedded systems or in threaded environments where the stack size is set to a low value. If stack corruption occurs with FastMath during public key operations in those environments, increase the stack size to accommodate the stack usage.

If you are enabling FastMath without using the autoconf system, you’ll need to define `USE_FAST_MATH` and add `tfm.c` to the wolfSSL build while removing `integer.c`. Defining `ALT_ECC_SIZE` will allocate ECC points only from the heap instead of the stack.

##### Architecture-Specific Optimizations

The following macros can be defined for assembly optimizations with USE_FAST_MATH.

* `TFM_ARM`
* `TFM_SSE2`
* `TFM_AVR32`
* `TFM_PPC32`
* `TFM_PPC64`
* `TFM_MIPS`
* `TFM_X86`
* `TFM_X86_64`

If none of these are defined or TFM_NO_ASM is defined, then `TFM_ISO` will be defined and ISO C portable code will be used.

##### Algorithm-Specific Optimizations

When enabled, optimized implementations for multiplication and squaring are used for the respective ECC curve.

* `TFM_ECC192`
* `TFM_ECC224`
* `TFM_ECC256`
* `TFM_ECC384`
* `TFM_ECC521`

##### TFM_SMALL_SET

Speed optimization for multiplication of smaller numbers. Includes implementations of 1-16 word Comba multiplication and squaring. Useful for improving the performance of ECC operations.

##### TFM_HUGE_SET

Speed optimization for multiplication of larger numbers. Includes implementations of 20, 24, 28, 32, 48 and 64 word Comba multiplication and squaring where bit size allows. Useful for improving the performance of RSA/DH/DSA operations.

##### TFM_SMALL_MONT_SET

Speed optimization for montgomery reduction of smaller numbers on Intel architectures. Includes implementations of 1-16 word Montgomery reduction. Useful for improving the performance of ECC operations.

#### Proprietary Single Precision (SP) Math Support

SP math is our recommended default option and has been taken through DO-178C certifications. Use these to speed up public key operations for specific keys sizes and curves that are common. Make sure to include the correct code files such as:

* `sp_c32.c`
* `sp_c64.c`
* `sp_arm32.c`
* `sp_arm64.c`
* `sp_armthumb.c`
* `sp_cortexm.c`
* `sp_int.c`
* `sp_x86_64.c`
* `sp_x86_64_asm.S`
* `sp_x86_64_asm.asm`

##### WOLFSSL_SP

Enable Single Precision math support.

#### WOLFSSL_SP_MATH

Enable only SP math and algorithms. Eliminates big integer math code such as normal (`integer.c`) or fast (`tfm.c`). Restricts key sizes and curves to only ones supported by SP.

#### WOLFSSL_SP_MATH_ALL

Enable SP math and algorithms. Implements big integer math code such as normal (`integer.c`) or fast (`tfm.c`) for key sizes and curves not supported by SP.

#### WOLFSSL_SP_SMALL

If using SP math this will use smaller versions of the code and avoid large stack variables.

##### SP_WORD_SIZE

Force 32-bit or 64-bit data type for storing one word of a number.

##### WOLFSSL_SP_NONBLOCK

Enables "non blocking" mode for Single Precision math, which will return FP_WOULDBLOCK for long operations and function must be called again until complete. Currently, this in only supported for ECC and is used in conjunction with `WC_ECC_NONBLOCK`.

##### WOLFSSL_SP_FAST_NCT_EXPTMOD

Enables the faster non-constant time modular exponentation implementation. Will only be used for public key operations; not private key operations.

##### WOLFSSL_SP_INT_NEGATIVE

Allows multi-precision numbers to be negative. (Not required for cryptographic operations.)

##### WOLFSSL_SP_INT_DIGIT_ALIGN

Enable when unaligned access of sp_int_digit pointer is not allowed.

##### WOLFSSL_HAVE_SP_RSA

Single Precision RSA for 2048, 3072 and 4096 bit.

##### WOLFSSL_HAVE_SP_DH

Single Precision DH for 2048, 3072 and 4096 bit.

##### WOLFSSL_HAVE_SP_ECC

Single Precision ECC for SECP256R1 and SECP384R1.

##### WOLFSSL_SP_LARGE_CODE

Allows Single-Precision (SP) speedups that come at the cost of larger binary size. Might not be appropriate for some embedded platforms.

##### WOLFSSL_SP_DIV_WORD_HALF

Indicates that division using a double length word isn't available. For example, on 32-bit CPUs, if you do not want to compile in a 64-bit division from a library, then defining this macro turn on an implementation where the divide is done using half word size portions.

##### WOLFSSL_SP_DIV_32

Indicates that 32-bit division isn't available and that wolfSSL should use its own Single-Precision (SP) implementation.

##### WOLFSSL_SP_DIV_64

Indicates that 64-bit division isn't available and that wolfSSL should use its own Single-Precision (SP) implementation.

##### WOLFSSL_SP_ASM

Enables Single-Precision (SP) platform specific assembly code implementation that is faster. Platform is detected.

##### WOLFSSL_SP_X86_64_ASM

Enable Single-Precision (SP) Intel x64 assembly implementation.

##### WOLFSSL_SP_ARM32_ASM

Enable Single-Precision (SP) Aarch32 assembly implementation.

##### WOLFSSL_SP_ARM64_ASM

Enable Single-Precision (SP) Aarch64 assembly implementation.

##### WOLFSSL_SP_ARM_CORTEX_M_ASM

Enable Single-Precision (SP) Cortex-M family (including Cortex-M4) assembly implementation.

##### WOLFSSL_SP_ARM_THUMB_ASM

Enable Single-Precision (SP) ARM Thumb assembly implementation (used with -mthumb).

##### WOLFSSL_SP_X86_64

Enable Single-Precision (SP) Intel x86 64-bit assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_X86

Enable Single-Precision (SP) Intel x86 assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_PPC64

Enable Single-Precision (SP) PPC64 assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_PPC

Enable Single-Precision (SP) PPC assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_MIPS64

Enable Single-Precision (SP) MIPS64 assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_MIPS

Enable Single-Precision (SP) MIPS assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_RISCV64

Enable Single-Precision (SP) RISCV64 assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_RISCV32

Enable Single-Precision (SP) RISCV32 assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

##### WOLFSSL_SP_S390X

Enable Single-Precision (SP) S390X assembly speedup macros. Only applies if `WOLFSSL_SP_MATH_ALL` is defined. See `sp_int.c`.

#### SP_INT_BITS

The number of bits to have in an sp_int. Which can determine the largest bignum that the library can handle.


### Stack or Chip Specific Defines

wolfSSL can be built for a variety of platforms and TCP/IP stacks. Most of the following defines are located in `./wolfssl/wolfcrypt/settings.h` and are commented out by default. Each can be uncommented to enable support for the specific chip or stack referenced below.

#### IPHONE

Can be defined if building for use with iOS.

#### THREADX

Can be defined when building for use with the ThreadX RTOS (<https://www.rtos.com>).

#### MICRIUM

Can be defined when building wolfSSL to enable support for Micrium’s µC/OS-III RTOS (<https://www.micrium.com>).

#### MBED

Can be defined when building for the mbed prototyping platform (<https://www.mbed.org>).

#### MICROCHIP_PIC32

Can be defined when building for Microchip’s PIC32 platform (<https://www.microchip.com>).

#### MICROCHIP_TCPIP_V5

Can be defined specifically version 5 of microchip tcp/ip stack.

#### MICROCHIP_TCPIP

Can be defined for microchip tcp/ip stack version 6 or later.

#### WOLFSSL_MICROCHIP_PIC32MZ

Can be defined for PIC32MZ hardware cryptography engine.

#### FREERTOS

Can be defined when building for FreeRTOS (<https://www.freertos.org>). If using LwIP, define [`WOLFSSL_LWIP`](#wolfssl_lwip) as well.

#### FREERTOS_WINSIM

Can be defined when building for the FreeRTOS windows simulator (<https://www.freertos.org>).

#### WOLFSSL_CHIBIOS

Can be defined when building for ChibiOS RTOS.

#### WOLFSSL_CMSIS_RTOS

Can be defined when building for Mbed CMIS-RTOS.

#### WOLFSSL_CMSIS_RTOSv2

Can be defined when building for Mbed CMIS-RTOSv2.

#### WOLFSSL_LWIP_NATIVE

Use in platforms for LWIP native.

#### WOLFSSL_DEOS

You can enable the wolfSSL support for Deos RTOS available [here](https://www.ddci.com/products_deos_do_178c_arinc_653/) using this define.

#### WOLFSSL_ESPIDF

Can be defined when building for ESP-IDF.

#### WOLFSSL_LINUXKM

Use if building for Linux Kernel Module.

#### WORD64_AVAILABLE

Portability macro to indicate 64-bit types are supported. Typically its better to use `SIZEOF_LONG_LONG` 8.

#### WOLFSSL_NUCLEUS_1_2

Use if building for Nucleus 1.2.

#### WOLFSSL_PICOTCP

use if if building with PicoTCP.

#### WOLFSSL_RENESAS_RA6M3G

Use if building with RENESAS RA6M3G.

#### WOLFSSL_RENESAS_RA6M4

use if building with RENESAS RA6M4.

#### WOLFSSL_RIOT_OS

Use if building with RIOT-OS.

#### WOLFSSL_uITRON4

Use if building for uITRON4.

#### WOLFSSL_uTKERNEL2

Use if building with uT-Kernel.

#### WOLFSSL_VXWORKS

Use if building with VxWorks.

#### DEVKITPRO

Use when building for devkitPro.

#### WOLFSSL_VXWORKS_6_x

Used only with implementation for VxWorks 6.x only.

#### WOLFSSL_WICED

Used if building for WICED Studio.

#### FREESCALE_KSDK_FREERTOS

Older name of this is `FREESCALE_FREE_RTOS` but this is used when building for Freescale KSDK FreeRTOS.

#### FREESCALE_KSDK_MQX

Used when building for Freescale KSDK MQX/RTCS/MFS.

#### FREESCALE_MQX_5_0

Used when building for Freescale Classic MQX version 5.0.

#### WOLFSSL_KEIL_TCP_NET

Configure the TCP stack (`MDK_CONF_NETWORK`). By default uses Keil TCP `WOLFSSL_KEIL_TCP_NET`. Use 0 for none or 2 for user io callbacks.

#### INTEL_GALILEO

Used when configuring ARDUINO and wolfSSL. If building for Intel Galileo platform add: `#define INTEL_GALILEO`

#### HAVE_KEIL_RTX

WolfSSL for MDK-RTX-TCP-FS Configuration.

#### EBSNET

Can be defined when using EBSnet products and RTIP.

#### WOLFSSL_EMBOS

Can be defined when building for SEGGER embOS (<https://www.segger.com/products/rtos/embos/>). If using emNET, define [`WOLFSSL_EMNET`](#wolfssl_emnet) as well.

#### WOLFSSL_EMNET

Can be defined when building for SEGGER emNET TCP/IP stack (<https://www.segger.com/products/connectivity/emnet/>).

#### WOLFSSL_LWIP

Can be defined when using wolfSSL with the LwIP TCP/IP stack (<https://savannah.nongnu.org/projects/lwip/>).

#### WOLFSSL_ISOTP

Can be defined when using wolfSSL with the ISO-TP transport protocol, typically used for CAN bus. A usage example can be found in the [wolfssl-examples repository](https://github.com/wolfssl/wolfssl-examples).

#### WOLFSSL_GAME_BUILD

Can be defined when building wolfSSL for a game console.

#### WOLFSSL_LSR

Can be defined if building for LSR.

#### FREESCALE_MQX

Can be defined when building for Freescale MQX/RTCS/MFS (<https://www.freescale.com>). This in turn defines `FREESCALE_K70_RNGA` to enable support for the Kinetis H/W Random Number Generator Accelerator

#### WOLFSSL_STM32F2

Can be defined when building for STM32F2. This define also enables STM32F2 hardware crypto and hardware RNG support in wolfSSL (<https://www.st.com/internet/mcu/subclass/1520.jsp>).

#### COMVERGE

Can be defined if using Comverge settings.

#### WOLFSSL_QL

Can be defined if using QL SEP settings.

#### WOLFSSL_EROAD

Can be defined building for EROAD.

#### WOLFSSL_IAR_ARM

Can be defined if build for IAR EWARM.

#### WOLFSSL_TIRTOS

Can be defined when building for TI-RTOS.

#### WOLFSSL_ROWLEY_ARM

Can be defined when building with Rowley CrossWorks.

#### WOLFSSL_NRF51

Can be defined when porting to Nordic nRF51.

#### WOLFSSL_NRF51_AES

Can be defined to use built-in AES hardware for AES 128 ECB encrypt when porting to Nordic nRF51.

#### WOLFSSL_CONTIKI

Can be defined to enable support for the Contiki operating system.

#### WOLFSSL_APACHE_MYNEWT

Can be defined to enable the Apache Mynewt port layer.

#### WOLFSSL_APACHE_HTTPD

Can be defined to enable support for the Apache HTTPD web server.

#### ASIO_USE_WOLFSSL

Can be defined to make wolfSSL build as an ASIO-compatible version. ASIO then relies on the `BOOST_ASIO_USE_WOLFSSL` preprocessor define.

#### WOLFSSL_CRYPTOCELL

Can be defined to enable using ARM CRYPTOCELL.

#### WOLFSSL_SIFIVE_RISC_V

Can be defined to enable using RISC-V SiFive/HiFive port.

#### WOLFSSL_MDK_ARM

Adds support for MDK ARM

#### WOLFSSL_MDK5

Adds support for MDK5 ARM

### OS Specific Defines

#### USE_WINDOWS_API

Specify use of windows library APIs’ as opposed to Unix/Linux APIs’

#### WIN32_LEAN_AND_MEAN

Adds support for the Microsoft win32 lean and mean build.

#### FREERTOS_TCP

Adds support for the FREERTOS TCP stack

#### WOLFSSL_SAFERTOS

Adds support for SafeRTOS

## Build Options

The following are options which may be appended to the `./configure` script to customize how the wolfSSL library is built.

By default, wolfSSL only builds in shared mode, with static mode being disabled. This speeds up build times by a factor of two. Either mode can be explicitly disabled or enabled if desired.

### `--enable-debug`

Enable wolfSSL debugging support. Enabling debug support allows easier debugging by compiling with debug information and defining the constant [`DEBUG_WOLFSSL`](#debug_wolfssl) which outputs messages to `stderr`. To turn debug on at runtime, call [`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on). To turn debug logging off at runtime, call [`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off). For more information, see [Debugging](chapter08.md#debugging).

### `--enable-distro`

Enable wolfSSL distro build.

### `--enable-singlethread`

Enable single threaded mode, no multi thread protections.

Enabling single threaded mode turns off multi thread protection of the session cache. Only enable single threaded mode if you know your application is single threaded or your application is multithreaded and only one thread at a time will be accessing the library.

### `--enable-dtls`

Enable wolfSSL DTLS support

Enabling DTLS support allows users of the library to also use the DTLS protocol in addition to TLS and SSL. For more information, see the [DTLS](chapter04.md#dtls) section.

### `--disable-rng`

Disable compiling and using RNG

### `--enable-sctp`

Enable wolfSSL DTLS-SCTP support

### `--enable-openssh`

Enable OpenSSH compatibility build

### `--enable-apachehttpd`

Enable Apache httpd compatibility build

### `--enable-openvpn`

Enable OpenVPN compatibility build

### `--enable-opensslextra`

Enable extra OpenSSL API compatibility, increases the size

Enabling OpenSSL Extra includes a larger set of OpenSSL compatibility functions. The basic build will enable enough functions for most TLS/SSL needs, but if you're porting an application that uses 10s or 100s of OpenSSL calls, enabling this will allow better support. The wolfSSL OpenSSL compatibility layer is under active development, so if there is a function missing which you need, please contact us and we'll try to help. For more information about the OpenSSL Compatibility Layer, please see [OpenSSL Compatibility](chapter13.md#openssl-compatibility).

### `--enable-opensslall`

Enable all OpenSSL API.

### `--enable-maxstrength`

Enable Max Strength build, allows TSLv1.2-AEAD-PFS ciphers only. This is
disabled by default because it can cause interoperability issues. It also
enables glitching detection.

### `--disable-harden`

Disable hardening, timing resistance and RSA blinding. Disabling this feature
can give performance improvements.

**NOTE** Hardening provides mitigations against side channel attacks. Only
disable this feature after careful consideration.

To disable via user_settings.h the equivalent settings would be:

* `#define WC_NO_CACHE_RESISTANT`
* `#define WC_NO_HARDEN`
* Remove the setting `WC_RSA_BLINDING` if present or un-define it
* Remove the setting `ECC_TIMING_RESISTANT` if present or un-define it
* Remove the setting `TFM_TIMING_RESISTANT` if present or un-define it

### `--enable-ipv6`

Enable testing of IPv6, wolfSSL proper is IP neutral

Enabling IPV6 changes the test applications to use IPv6 instead of IPv4. wolfSSL proper is IP neutral, either version can be used, but currently the test applications are IP dependent.

### `--enable-bump`

Enable SSL Bump build

### `--enable-leanpsk`

Enable Lean PSK build.

Very small build using PSK, and eliminating many features from the library. Approximate build size for wolfSSL on an embedded system with this enabled is 21kB.

### `--enable-leantls`

Implements a lean TLS 1.2 client only (no client auth), ECC256, AES128 and SHA256 w/o Shamir. Meant to be used by itself at the moment and not in conjunction with other build options.

Enabling produces a small footprint TLS client that supports TLS 1.2 client only (no client auth), ECC256, AES128 and SHA256 w/o Shamir. Meant to be used by itself at the moment and not in conjunction with other build options.

### `--enable-bigcache`

Enable a big session cache.

Enabling the big session cache will increase the session cache from 33 sessions to 20,027 sessions. The default session cache size of 33 is adequate for TLS clients and embedded servers. The big session cache is suitable for servers that aren't under heavy load, basically allowing 200 new sessions per minute or so.

### `--enable-hugecache`

Enable a huge session cache.

Enabling the huge session cache will increase the session cache size to 65,791 sessions. This option is for servers that are under heavy load, over 13,000 new sessions per minute are possible or over 200 new sessions per second.

### `--enable-smallcache`

Enable small session cache.

Enabling the small session cache will cause wolfSSL to only store 6 sessions. This may be useful for embedded clients or systems where the default of nearly 3kB is too much RAM. This define uses less than 500 bytes of RAM.

### `--enable-savesession`

Enable persistent session cache.

Enabling this option will allow an application to persist (save) and restore the wolfSSL session cache to/from memory buffers.

### `--enable-savecert`

Enable persistent cert cache.

Enabling this option will allow an application to persist (save) and restore the wolfSSL certificate cache to/from memory buffers.

### `--enable-atomicuser`

Enable Atomic User Record Layer.

Enabling this option will turn on User Atomic Record Layer Processing callbacks. This will allow the application to register its own MAC/encrypt and decrypt/verify callbacks.

### `--enable-pkcallbacks`

Enable Public Key Callbacks

Eabling this option will turn on Public Key callbacks, allowing the application to register its own ECC sign/verify and RSA sign/verify and encrypt/decrypt callbacks.

### `--enable-sniffer`

Enable wolfSSL sniffer support.

Enabling sniffer (SSL inspection) support will allow the collection of SSL traffic packets as well as the ability to decrypt those packets with the correct key file.

Currently the sniffer supports the following RSA ciphers:

CBC ciphers:

* AES-CBC
* Camellia-CBC
* 3DES-CBC

Stream ciphers:

* RC4

### `--enable-aesgcm`

Enable AES-GCM support.

Enabling AES-GCM will add these cipher suites to wolfSSL.  wolfSSL offers four different implementations of AES-GCM balancing speed versus memory consumption. If available, wolfSSL will use 64-bit or 32-bit math. For embedded applications, there is a speedy 8-bit version that uses RAM-based lookup tables (8KB per session) which is speed comparable to the 64-bit version and a slower 8-bit version that doesn't take up any additional RAM. The --enable-aesgcm configure option may be modified with the options `=word32`, `=table`, or `=small`, i.e. `--enable-aesgcm=table`.

### `--enable-aesccm`

Enable AES-CCM support

### `--disable-aescbc`

Used to with [`--disable-aescbc`](#--disable-aescbc) to compile out AES-CBC

AES-GCM will enable Counter with CBC-MAC Mode with 8‑byte authentication (CCM-8) for AES.

### `--enable-aescfb`

Turns on AES-CFB mode support

### `--enable-aesctr`

Enable wolfSSL AES-CTR support

Enabling AES-CTR will enable Counter mode.

### `--enable-aesni`

Enable wolfSSL Intel AES-NI support

Enabling AES-NI support will allow AES instructions to be called directly from the chip when using an AES-NI supported chip. This provides speed increases for AES functions.  See [Features](chapter04.md#features) for more details regarding AES-NI.

### `--enable-intelasm`

Enable ASM speedups for Intel and AMD processors.

Enabling the intelasm option for wolfSSL will utilize expanded capabilities of your processor that dramatically enhance AES performance. The instruction sets leveraged when configure option is enabled include AVX1, AVX2, BMI2, RDRAND, RDSEED, AESNI, and ADX. These were first introduced into Intel processors and AMD processors have started adopting them in recent years. When enabled, wolfSSL will check the processor and take advantage of the instruction sets your processor supports.

### `--enable-camellia`

Enable Camellia support

### `--enable-md2`

Enable MD2 support

### `--enable-nullcipher`

Enable wolfSSL NULL cipher support (no encryption)

### `--enable-ripemd`

Enable wolfSSL RIPEMD-160 support

### `--enable-blake2`

Enable wolfSSL BLAKE2 support

### `--enable-blake2s`

Enable wolfSSL BLAKE2s support

### `--enable-sha3`

Enabled by default on x86\_64 and Aarch64.

Enables wolfSSL SHA3 support (`=small` for small build)

### `--enable-sha512`

Enabled by default on x86\_64.

Enable wolfSSL SHA-512 support

### `--enable-sessioncerts`

Enable session cert storing

### `--enable-keygen`

Enable key generation (applies to RSA key generation only)

### `--enable-certgen`

Enable cert generation

### `--enable-certext`

Enable cert extensions (see chapter 7 on supported extensions)

### `--enable-certreq`

Enable cert request generation

### `--enable-sep`

Enable SEP extensions

### `--enable-hkdf`

Enable HKDF (HMAC-KDF)

### `--enable-x963kdf`

Enable X9.63 KDF support

### `--enable-dsa`

Enable Digital Signature Algorithm (DSA).

NIST approved digital signature algorithm along with RSA and ECDSA as defined by FIPS 186-4 and are used to generate and verify digital signatures if used in conjunction with an approved hash function as defined by the Secure Hash Standard (FIPS 180-4).

### `--enable-eccshamir`

Enabled by default on x86\_64

Enable ECC Shamir

### `--enable-ecc`

Enabled by default on x86\_64

Enable ECC.

Enabling this option will build ECC support and cipher suites into wolfSSL.

### `--enable-ecccustcurves`

Enable ECC custom curves (`=all` to enable all curve types)

### `--enable-compkey`

Enable compressed keys support

### `--enable-curve25519`

Enable Curve25519 (or `--enable-curve25519=small` for CURVE25519\_SMALL).

An elliptic curve offering 128 bits of security and to be used with ECDH key  agreement (see [Cross Compiling](#cross-compiling)). Enabling curve25519 option allows for the use of the curve25519 algorithm. The default curve25519 is set to use more memory but have a faster run time. To have the algorithm use less memory the option `--enable-curve25519=small` can be used. Although using less memory there is a trade off in speed.

### `--enable-ed25519`

Enable ED25519 (or `--enable-ed25519=small` for ED25519\_SMALL)

Enabling ed25519 option allows for the use of the ed25519 algorithm. The default ed25519 is set to use more memory but have a faster run time. To have the algorithm use less memory the option `--enable-ed25519=small` can be used. Like with curve25519 using this enable option less is a trade off between speed and memory.

### `--enable-fpecc`

Enable Fixed Point cache ECC

### `--enable-eccencrypt`

Enable ECC encrypt

### `--enable-psk`

Enable PSK (Pre Shared Keys)

### `--disable-errorstrings`

Disable the error strings table

### `--disable-oldtls`

Disable old TLS version < 1.2

### `--enable-sslv3`

Enable SSL version 3.0

### `--enable-stacksize`

Enable stack size info on examples

### `--disable-memory`

Disable memory callbacks

### `--disable-rsa`

Disable RSA

### `--enable-rsapss`

Enable RSA-PSS

### `--disable-dh`

Disable DH

### `--enable-anon`

Enable Anonymous

### `--disable-asn`

Disable ASN

### `--disable-aes`

Disable AES

### `--disable-coding`

Disable Coding base 16/64

### `--enable-base64encode`

Enabled by default on x86\_64

Enable Base64 encoding

### `--disable-des3`

Disable DES3

### `--enable-arc4`

Enable ARC4

### `--disable-md5`

Disable MD5

### `--disable-sha`

Disable SHA

### `--enable-webserver`

Enable Web Server.

This turns on functions required over the standard build that will allow full functionality for building with the yaSSL Embedded Web Server.

### `--enable-fips`

Enable FIPS 140-2 (Must have license to implement.)

### `--enable-sha224`

Enabled by default on x86\_64

Enable wolfSSL SHA-224 support

### `--disable-poly1305`

Disable wolfSSL POLY1305 support

### `--disable-chacha`

Disable CHACHA

### `--disable-hashdrbg`

Disable Hash DRBG support

### `--disable-filesystem`

Disable Filesystem support.

This makes it easier to disable filesystem use.  This option defines [`NO_FILESYSTEM`](#no_filesystem).

### `--disable-inline`

Disable inline functions.

Disabling this option disables function inlining in wolfSSL.  Function placeholders that are not linked against but, rather, the code block is inserted into the function call when function inlining is enabled.

### `--enable-ocsp`

Enable Online Certificate Status Protocol (OCSP).

Enabling this option adds OCSP (Online Certificate Status Protocol) support to wolfSSL. It is used to obtain the revocation status of x.509 certificates as described in RFC 6960.

### `--enable-ocspstapling`

Enable OCSP Stapling (`=no-multi` to disable multiple OCSP Stapling for TLS1.3 Certificate)

### `--enable-ocspstapling2`

Enable OCSP Stapling version 2

### `--enable-crl`

Enable CRL (Certificate Revocation List)

### `--enable-crl-monitor`

Enable CRL Monitor.

Enabling this option adds the ability to have wolfSSL actively monitor a specific CRL (Certificate Revocation List) directory.

### `--enable-sni`

Enable Server Name Indication (SNI).

Enabling this option will turn on the TLS Server Name Indication (SNI) extension.

### `--enable-maxfragment`

Enable Maximum Fragment Length.

Enabling this option will turn on the TLS Maximum Fragment Length extension.

### `--enable-alpn`

Enable Application Layer Protocol Negotiation (ALPN)

### `--enable-truncatedhmac`

Enable Truncated Keyed-hash MAC (HMAC).

Enabling this option will turn on the TLS Truncated HMAC extension.

### `--enable-renegotiation-indication`

Enable Renegotiation Indication.

As described in [RFC 5746](https://datatracker.ietf.org/doc/html/rfc5746), this specification prevents an SSL/TLS attack involving renegotiation splicing by tying the renegotiations to the TLS connection they are performed over.

### `--enable-secure-renegotiation`

Enable Secure Renegotiation

### `--enable-supportedcurves`

Enable Supported Elliptic Curves.

Enabling this option will turn on the TLS Supported ECC Curves extension.

### `--enable-session-ticket`

Enable Session Ticket

### `--enable-extended-master`

Enable Extended Master Secret

### `--enable-tlsx`

Enable all TLS extensions.

Enabling this option will turn on all TLS extensions currently supported by wolfSSL.

### `--enable-pkcs7`

Enable PKCS#7 support

### `--enable-pkcs11`

Enable PKCS#11 access

### `--enable-ssh`

Enable wolfSSH options

### `--enable-scep`

Enable wolfSCEP (Simple Certificate Enrollment Protocol)

As defined by the Internet Engineering Task Force, Simple Certificate Enrollment Protocol is a PKI that leverages PKCS#7 and PKCS#10 over HTTP. CERT notes that SCEP does not strongly authenticate certificate requests.

### `--enable-srp`

Enable Secure Remote Password

### `--enable-smallstack`

Enable Small Stack Usage

### `--enable-valgrind`

Enable valgrind for unit tests.

Enabling this option will turn on valgrind when running the wolfSSL unit tests. This can be useful for catching problems early on in the development cycle.

### `--enable-testcert`

Enable Test Cert.

When this option is enabled, it exposes part of the ASN certificate API that is usually not exposed.  This can be useful for testing purposes, as seen in the wolfCrypt test application (`wolfcrypt/test/test.c`).

### `--enable-iopool`

Enable I/O Pool example

### `--enable-certservice`

Enable certificate service (Windows Servers)

### `--enable-jni`

Enable wolfSSL JNI

### `--enable-lighty`

Enable lighttpd/lighty

### `--enable-stunnel`

Enable stunnel

### `--enable-md4`

Enable MD4

### `--enable-pwdbased`

Enable PWDBASED

### `--enable-scrypt`

Enable SCRYPT

### `--enable-cryptonly`

Enable wolfCrypt Only build

### `--disable-examples`

Disable building examples.

When enabled, the wolfSSL example applications will be built ([client](chapter03.md#client-example), [server](chapter03.md#server-example), [echoclient](chapter03.md#echoclient-example), [echoserver](chapter03.md#echoserver-example)).

### `--disable-crypttests`

Disable Crypt Bench/Test

### `--enable-fast-rsa`

Enable RSA using Intel IPP.

Enabling fast-rsa speeds up RSA operations by using IPP libraries. It has a larger memory consumption then the default RSA set by wolfSSL. If IPP libraries can not be found an error message will be displayed during configuration. The first location that autoconf will look is in the directory `wolfssl_root/IPP` the second is standard location for libraries on the machine such as `/usr/lib/` on linux systems.

The libraries used for RSA operations are in the directory `wolfssl-X.X.X/IPP/` where X.X.X is the current wolfSSL version number. Building from the bundled libraries is dependent on the directory location and name of IPP so the file structure of the subdirectory IPP should not be changed.

When allocating memory the fast-rsa operations have a memory tag of `DYNAMIC_TYPE_USER_CRYPTO`. This allows for viewing the memory consumption of RSA operations during run time with the fast-rsa option.

### `--enable-staticmemory`

Enable static memory use

### `--enable-mcapi`

Enable Microchip API

### `--enable-asynccrypt`

Enable Asynchronous Crypto

### `--enable-sessionexport`

Enable export and import of sessions

### `--enable-aeskeywrap`

Enable AES key wrap support

### `--enable-jobserver`

Values: `yes` (default) / `no` / `#`

When using `make` this builds wolfSSL using a multithreaded build, `yes` (default) detects the number of CPU cores and builds using a recommended amount of jobs for that count, `#` to specify an exact number. This works in a similar way to the `make -j` option.

### `--enable-shared[=PKGS]`

Building shared wolfSSL libraries [default=yes]

Disabling the shared library build will exclude a wolfSSL shared library from being built. By default only a shared library is built in order to save time and space.

### `--enable-static[=PKGS]`

Building static wolfSSL libraries [default=no]

### `--with-liboqs=PATH`

Path to OpenQuantumSafe install (default `/usr/local`).

This turns on the ability for wolfSSL to use the experimental TLS 1.3 quantum-safe KEM groups, hybrid quantum-safe KEM groups and FALCON signature scheme via wolfSSL integration with liboqs. Please see the appendix "Experimenting with Quantum-Safe Cryptography" in this document for more details.

### `--with-libz=PATH`

Optionally include libz for compression.

Enabling libz will allow compression support in wolfSSL from the libz library. Think twice about including this option and using it by calling [`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression). While compressing data before sending decreases the actual size of the messages being sent and received, the amount of data saved by compression usually takes longer in time to analyze than it does to send it raw on all but the slowest of networks.

### `--with-cavium`

Path to cavium/software directory.

### `--with-user-crypto`

Path to USER\_CRYPTO install (default `/usr/local`).

### `--enable-rsavfy`

Enables RSA verify only support (**note** requires [`--enable-cryptonly`](#--enable-cryptonly))

### `--enable-rsapub`

Default value: Enabled RSA public key only support (**note** requires [`--enable-cryptonly`](#--enable-cryptonly))

### `--enable-armasm`

Enables ARMv8 ASM support.

The default configure sets mcpu or mfpu based on 64 vs 32 bit system. It does not overwrite mcpu or mfpu setting passed in by use of CPPFLAGS. On some compilers `-mstrict-align` may be needed due to the constraiants and `-mstrict-align` is now also set by default unless a user passes in mcpu/mfpu flags with `CPPFLAGS`.

### `--disable-tlsv12`

Disable TLS 1.2 support

### `--enable-tls13`

Enable TLS 1.3 support

This build option can be combined with [`--disable-tlsv12`](#--disable-tlsv12) and [`--disable-oldtls`](#--disable-oldtlx) to produce a wolfSSL build that is only TLS 1.3.

### `--enable-all`

Enables all wolfSSL features, excluding SSL v3

### `--enable-xts`

Enables AES-XTS mode

### `--enable-asio`

Enables ASIO.

Requires that the options [`--enable-opensslextra`](#--enable-opensslextra) and [`--enable-opensslall`](#--enable-opensslall) be enabled when configuring wolfSSL. If these two options are not enabled, then the autoconf tool will automatically enable these options to enable ASIO when configuring wolfSSL.

### `--enable-qt`

Enables Qt 5.12 onwards support.

Enables wolfSSL build settings compatible with the wolfSSL Qt port. Patch file is required from wolfSSL for patching Qt source files.

### `--enable-qt-test`

Enable Qt test compatibility build.

Enables support for building wolfSSL for compatibility with running the built-in Qt tests.

### `--enable-apache-httpd`

Enables Apache httpd support

### `--enable-afalg`

Enables use of Linux module AF\_ALG for hardware accleration. Additional Xilinx use with `=xilinx`, `=xilinx-rsa`, `=xilinx-aes`, `=xilinx-sha3`

Is similar to [`--enable-devcrypto`](#--enable-devcrypto) in that it leverages a Linux kernel module (AF\_ALG) for offloading crypto operations. On some hardware the module has performance accelerations available through the Linux crypto drivers. In the case of Petalinux with Xilinx the flag `--enable-afalg=xilinx` can be used to tell wolfSSL to use the Xilinx interface for AF\_ALG.

### `--enable-devcrypto`

Enables use of Linux `/dev/crypto` for hardware acceleration.

Has the ability to receive arguments, being able to receive any combination of `aes` (all aes support), `hash` (all hash algorithms), and `cbc` (aes-cbc only). If no options are given, it will default to using `all`.

### `--enable-mcast`

Enable wolfSSL DTLS multicast support

### `--disable-pkcs12`

Disable PKCS12 code

### `--enable-fallback-scsv`

Enables Signaling Cipher Suite Value(SCSV)

### `--enable-psk-one-id`

Enables support for single PSK ID with TLS 1.3

### `--enable-cryptocb`

Enable crypto callbacks. Register a crypto callback using wc_CryptoCb_RegisterDevice and set the associated devId using wolfSSL_CTX_SetDevId.

The following two defines can be used with `--enable-cryptocb` to complie out RSA or ECC software fallback to optimize for footprint reduction when software RSA/ECC is not required.

* WOLF_CRYPTO_CB_ONLY_RSA - compiles out RSA software crypto fallback
* WOLF_CRYPTO_CB_ONLY_ECC - compiles out ECC software crypto fallback

Use of the WOLF_CRYPTO_CB_ONLY_* options requires disabling the examples. See [`--disable-examples`](#disable-examples)

### `--enable-reproducible-build`

Suppresses the binary jitter (timestamps and other non-functional metadata) to allow generation of bitwise-identical binary packages with identical hashes.

### `--enable-sys-ca-certs`
Allows wolfSSL to use trusted system CA certificates for verification when [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.html#function-wolfssl_ctx_load_system_ca_certs) is called, either by loading them into wolfSSL certificate manager, or by invoking system authentication APIs. See [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.html#function-wolfssl_ctx_load_system_ca_certs) for more details.

## Special Math Optimization Flags

### `--enable-fastmath`

Enable FastMath implementation. Both FastMath and Big Integer library are disabled if Single-Precision (SP) math is enabled.

See USE_FAST_MATH and Big Integer Math Library sections.

### `--enable-fasthugemath`

Enable fast math + huge code.

Enabling fasthugemath includes support for the FastMath library and greatly increases the code size by unrolling loops for popular key sizes during public key operations. Try using the benchmark utility before and after using fasthugemath to see if the slight speedup is worth the increased code size.

### `--enable-sp-math`

Enable Single-Precision (SP) math implementation with restricted algorithm suite. Unsupported algorithms are disabled. Overrides `--enable-sp`, `--enable-sp-math-all`, `--enable-fastmath` and `--enable-fasthugemath`.

- Replaces the math implementation with that in sp_int.c
- A minimal implementation, turns on portions of sp_int.c but not all.
- MUST combine with --enable-sp to turn on the solutions in sp_x86_64.c or sp_arm.c etc (list of files below depending on the target system) to be able to perform RSA/ECC/DH operations.
- Not to be combined with --enable-sp-math-all (below)

FILE LIST (platform dependent, chosen by configure based on system specs or can
be manually controlled when using a Makefile/IDE solution):
sp_arm32.c
sp_arm64.c
sp_armthumb.c
sp_cortexm.c
sp_dsp32.c
sp_x86_64.c
sp_x86_64_asm.S
sp_x86_64_asm.asm

### `--enable-sp-math-all`

Enabled by default. Enable Single-Precision (SP) math implementation with full algorithm suite. Unsupported algorithms are enabled, but unoptimized. Overrides `--enable-sp`, `--enable-fastmath` and `--enable-fasthugemath`.

- Replaces the math implementation with that in sp_int.c
- A FULL implementation, does not depend on --enable-sp to work
- Can be combined with --enable-sp to allow use of the implementations written in portable c assembly (non-hardware specific assembly) in sp_c32.c for 32-bit or sp_c64.c for 64-bit when possible. The rest of the time (when not possible) the implementations in sp_int.c are used. The portable C assembly gives significant performance gains on targets that do not have hardware optimizations available.
- Not to be combined with --enable-sp-math (above)

**NOTE**: If you are using asymmetric cryptography with key length in bits [256, 384, 521, 1024, 2048, 3072, 4096], you should consider using --enable-sp-math option to get maximum performance with a larger footprint size.

### `--enable-sp-asm`

Enable Single-Precision (SP) assembly implementation.

Can be used to enable Single-Precision performance improvements through assembly with Intel x86\_64 and ARM architectures.

### `--enable-sp=OPT`

Enable Single-Precision (SP) math for RSA, DH, and ECC to improve performance.

There are many possible values for OPT. Below is a list of ways to call enable-sp and the resulting macros that will be defined as a result. All of these can be combined in a coma separated list. For example, `--enable-sp=ec256,ec384`. The meaning of the macros that will be defined are defined above in the [wolfSSL’s Proprietary Single Precision (SP) Math Support] section.

**NOTE**:
1) "--enable-sp=small --enable-sp-math" can be smaller than...
2) "--enable-sp-math-all=small"...
as (1) only has implementations of specific key sizes while (2) has implementations to support all key sizes.

**NOTE**: This is for x86_64 and with no other configuration flags; your results may vary depending on your architectures and other configuration flags that you specify. For example,  WOLFSSL_SP_384 and WOLFSSL_SP_4096 will only be enabled for Intel x86_64.

#### `--enable-sp=no` or `--disable-sp`

No new macros defined. Equivalent of not using `--enable-sp`.

#### `--enable-sp` or `--enable-sp=yes`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_SP_384
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE

#### `--enable-sp=small`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_4096
* WOLFSSL_SP_384
* WOLFSSL_SP_4096
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_384

#### `--enable-sp=smallfast`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_4096
* WOLFSSL_SP_384
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_FAST_MODEXP

#### `--enable-sp=ec256` or `--enable-sp=p256` or `--enable-sp=p256`

* WOLFSSL_HAVE_SP_ECC

#### `--enable-sp=smallec256` or `--enable-sp=smallp256` or `--enable-sp=small256`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec384` or `--enable-sp=p384` or `--enable-sp=384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec384` or `--enable-sp=smallp384` or `--enable-sp=small384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec1024` or `--enable-sp=p1024` or `--enable-sp=1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec1024` or `--enable-sp=smallp1024` or `--enable-sp=small1024`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_1024
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=2048`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=small2048`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=3072`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=small3072`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa3072`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=smallrsa3072`

* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=4096` or `--enable-sp=+4096`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072

#### `--enable-sp=small4096`

* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa4096`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa4096`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=nomalloc`

* WOLFSSL_SP_NO_MALLOC

#### `--enable-sp=nonblock`

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK
* WOLFSSL_SP_SMALL

#### `asm`

Combine with other algorithm options to indicate that assembly code is turned on for those options. For example, `--enable-sp=rsa2048,asm`.

## Cross Compiling

Many users on embedded platforms cross compile wolfSSL for their environment. The easiest way to cross compile the library is to use the `./configure` system. It will generate a Makefile which can then be used to build wolfSSL.

When cross compiling, you’ll need to specify the host to `./configure`, such as:

```sh
./configure --host=arm-linux
```

You may also need to specify the compiler, linker, etc. that you want to use:

```sh
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux
```

There is a bug in the configure system which you might see when cross compiling and detecting user overriding malloc. If you get an undefined reference to `rpl_malloc` and/or `rpl_realloc`, please add the following to your `./configure` line:

```sh
ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
```

After correctly configuring wolfSSL for cross-compilation, you should be able to follow standard autoconf practices for building and installing the library:

```sh
make
sudo make install
```

If you have any additional tips or feedback about cross compiling wolfSSL, please let us know at [info@wolfssl.com](mailto:info@wolfssl.com).

### Example cross compile configure options for toolchain builds

#### armebv7-eabihf-glibc

```sh
./configure --host=armeb-linux \
        CC=armeb-linux-gcc LD=armeb-linux-ld \
        AR=armeb-linux-ar \
        RANLIB=armeb-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv5-eabi-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv6-eabihf-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv7-eabihf-glibc

```sh
./configure --host=arm-linux \
        CC=arm-linux-gcc LD=arm-linux-ld \
        AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### armv7m-uclibc

```sh
./configure --enable-static --disable-shared \--host=arm-linux CC=arm-linux-gcc \
        LD=arm-linux-ld AR=arm-linux-ar \
        RANLIB=arm-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### arm-none-eabi-gcc

```sh
./configure --host=arm-none-eabi \
        CC=arm-none-eabi-gcc LD=arm-none-eabi-ld \
        AR=arm-none-eabi-ar RANLIB=arm-none-eabi-ranlib \
        CFLAGS="-DNO_WOLFSSL_DIR \
        -DWOLFSSL_USER_IO -DNO_WRITEV \
        -mcpu=cortex-m4 -mthumb -Os \
        -specs=rdimon.specs" CPPFLAGS="-I./"
```

#### mips32--glibc

```sh
./configure --host=mips-linux \
        CC=mips-linux-gcc LD=mips-linux-ld \
        AR=mips-linux-ar \
        RANLIB=mips-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### PowerPc64le-Power8-Glibc

```sh
./configure --host=powerpc64le-buildroot-linux-gnu \
        CC=powerpc64le-buildroot-linux-gnu-gcc \
        LD=powerpc64le-buildroot-linux-gnu-ld \
        AR=powerpc64le-buildroot-linux-gnu-ar \
        RANLIB=powerpc64le-buildroot-linux-gnu-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### x86-64-core-i7-glibc

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

#### x86-64-core-i7-musl

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \CPPFLAGS="-I./"
```

#### x86-64-core-i7-uclibc

```sh
./configure --host=x86_64-linux \
        CC=x86_64-linux-gcc LD=x86_64-linux-ld \
        AR=x86_64-linux-ar \
        RANLIB=x86_64-linux-ranlib \
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
```

## Building Ports

wolfSSL has been ported to many environments and devices. A portion of these ports and accompanying documentation for them is located in the directory `wolfssl-X.X.X/IDE`, where X.X.X is the current wolfSSL version number. This directory also contains helpful information and code for IDE’s used to build wolfSSL for the environments.

PORT Lists:

* Arduino
* LPCXPRESSO
* Wiced Studio
* CSBench
* SGX Windows and Linux
  * These directories (`wolfssl/IDE/WIN-SGX` and `wolfssl/IDE/LINUX-SGX`) contain Makefiles for and Visual Studio solutions for building wolfSSL as a library to be used in an Intel SGX project.
* Hexagon
  * This directory (`wolfssl/IDE/HEXAGON`) contains a Makefile for building with the Hexagon tool chain. It can be used to build wolfSSL for offloading ECC verify operations to a DSP processor. The directory contains a README file to help with the steps required to build.
* Hexiwear
* NetBurner M68K
  * In the directory (`wolfssl/IDE/M68K`) there is a Makefile for building wolfSSL for a MCF5441X device using the Netburner RTOS.
* Renesas
  * This directory (`wolfssl/IDE/Renesas`) contains multiple builds for different Renesas devices. It also has example builds that demonstrate using hardware acceleration.
* XCode
* Eclipse
* Espressif
* IAR-EWARM
* Kinetis Design Studio (KDS)
* Rowley Crossworks ARM
* OpenSTM32
* RISCV
* Zephyr
* Mynewt
* INTIME-RTOS

## Building For NXP CAAM

### i.MX8 (Linux)

#### Known Issues
- If exiting an open HSM key store session before closing up the HSM session (wc_SECO_CloseHSM and wolfSSL_CLeanup or wolfCrypt_Cleanup) the next time the NVM is started up it segfaults. A power cycle is needed to work around it.

#### Limitations Found
- AES operations with large inputs (i.e. 1 megabyte) fails with the SECO getting “Not enough space in shared memory”.
- After creating 2 keystores the attempt to create a 3rd will fail. To reset the keystores do rm -rf /etc/seco_hsm and power cycle the device.

#### Intro
On i.MX8 devices there is a SECO hardware module available for heightened security. This module handles AES operations and key storage, limited ECC operations and key storage, and provides a RNG. wolfSSL has been expanded to make use of the SECO where possible. For some algorithms the CAAM on i.MX8 supports them but the SECO module does not yet. In these cases wolfSSL will make calls through /dev/crypto down to a Linux CAAM driver that creates jobs for the CAAM directly. There are some algorithms supported by default with the NXP Linux CAAM driver but not all algorithms that the CAAM supports. wolfSSL has expanded the Linux CAAM driver to add support for additional algorithms. To use both avenues of accessing the CAAM from the same application the “devId” associated with the different code paths can be set, either WOLFSSL_CAAM_DEVID or WOLFSSL_SECO_DEVID. These IDs are used when first initializing a structure to set which code path will be used throughout the lifetime of the structure. If using software only then the default INVALID_DEVID should be set. The exception to this is SECO items that do not use the key store; TRNG, and Hashing.


Versions of software used:

- imx-seco-libs branch imx_5.4.24_2.1.0
- NXP “repo” tool and Yocto build. Documentation on Yocto setup is here
- wolfSSL 5.2.0 + (was developed after 5.2.0 release)


#### Supported Algorithms
Supported algorithms, modes, and operations include:

- AES (ECB, CBC, CCM, GCM)
- AES CMAC
- SHA256, SHA384
- ECC 256/384 (keygen, sign, verify, ecdh)
- RSA 3072 (keygen, sign, verify)
- HMAC
- Curve25519
- TRNG


#### Building Image
##### “repo” Setup
Setting up the NXP “repo” command tool was done on Ubuntu 18.04 LTS\

```
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib
sudo apt-get install build-essential chrpath socat cpio python python3 python3-pip
sudo apt-get install python3-pexpect xz-utils debianutils iputils-ping python3-git
sudo apt-get install python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm curl
sudo apt-get install ca-certificates
```


```
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

git config --global user.name "Your Git Name"
git config --global user.email "Your Email"
```


As of Jan 11, 2022 GitHub is no longer allowing unauthenticated git connections. NXP’s repo tool has not yet taken this into account at the time that this document was created (March, 2022). To work around this redirect git://github.com/ to https://github.com/ with the following command:


```
git config --global url."https://github.com/".insteadOf git://github.com/
```


Make the desired directory to build in, for example:

```
mkdir imx-yocto-bsp
cd imx-yocto-bsp/
```

After setting up NXP’s “repo” command tool, initialize and sync a directory with the desired version of Linux. In this case 5.4.24_2.1.0.\

```
repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-zeus -m imx-5.4.24-2.1.0.xml
repo sync

DISTRO=fsl-imx-wayland MACHINE=imx8qxpc0mek source imx-setup-release.sh -b build-xwayland
```

##### Additional Yocto CAAM Layers
Next download the CAAM driver expansion layers that will apply patches to cryptodev-module, cryptodev-linux, and to files in `linux-imx/drivers/crypto/caam/*`. The base blob and ECDSA (sign/verify/keygen) is located here (https://source.codeaurora.org/external/imxsupport/imx_sec_apps/). The layer that expands that farther to have RSA black key, ECDH, and Curve25519 support is meta-imx-expand-caam. Place both of these directories into the sources directory next to the other existing meta-\* directories.


```sh
#<assuming in the build-xwayland directory from previous command>

#<either clone the current work or open from a delivered zip>
git clone -b caam_expansion https://github.com/JacobBarthelmeh/imx_sec_apps
cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
cp -r imx_sec_apps/meta-imx-expand-caam ../sources/


# or

git clone https://source.codeaurora.org/external/imxsupport/imx_sec_apps.git
#(meta-imx-expand-caam comes from wolfSSL)
unzip meta-imx-expand-caam.zip

cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
mv meta-imx-expand-caam ../sources/
```


Add those layers to the build, ecdsa first, then the CAAM expansion.

```
vim conf/bblayers.conf
BBLAYERS += "${BSPDIR}/sources/meta-imx-ecdsa-sec"
BBLAYERS += "${BSPDIR}/sources/meta-imx-expand-caam"
```


Add the desired modules and libraries to the local conf file.

```sh
vim conf/local.conf
EXTRA_IMAGE_FEATURES_append = " dev-pkgs tools-sdk tools-debug ssh-server-openssh "
IMAGE_INSTALL_append = " cryptodev-module cryptodev-linux eckey "
```


In this build, we had added debugging tools and an SSH server, which are not necessary if looking to trim down on size. The important items to add are “cryptodev-module and cryptodev-linux”. “eckey” is a demo tool from NXP for encapsulating and decapsulating blobs.

[Optional]
To add the auto loading of cryptodev module add the following line to conf/local.conf.


```
KERNEL_MODULE_AUTOLOAD += "cryptodev"
```


Otherwise the module will need to be loaded after each power cycle using “modprobe cryptodev”.


##### Build and Deploy
To kick off the build of the image use the following command. Then if using an sdcard, flash it to the card.


```
bitbake core-image-base

cd tmp/deploy/images/imx8qxpc0mek/
bzcat core-image-base-imx8qxpc0mek.sdcard.bz2 | sudo dd of=/dev/diskX bs=5m
```


Note: 5m is for Mac OS, use 5M for Linux. diskX should be replaced with the location of sdcard, i.e. disk2 on Mac or sdbX on Linux. Check to make sure of the sdcard disk number before executing.
For use with building wolfssl/examples later export the install directory using the following:

```
export　CRYPTODEV_DIR=`pwd`/tmp/sysroots-components/aarch64/cryptodev-linux/usr/include/
```


To install the toolchain for cross compiling use the following Yocto command

```
bitbake meta-toolchain
sudo ./tmp/deploy/sdk/<version>.sh
```

#### Building NXP HSM
##### Build zlib
Multiple ways to do this, one is to add it to the Yocto build one way is to build it using bitbake as follows.


```
cd build-xwayland
bitbake zlib
```


This places the results into the directory tmp/sysroots-components/aarch64/zlib/usr/

For use with building wolfssl/examples later export the install directory using the following:

```
export ZLIB_DIR=`pwd`/tmp/sysroots-components/aarch64/zlib/usr/
```

##### Build NXP HSM lib
Download the NXP HSM library, and adjust the Makefile (or environment variables) in order to find the necessary zlib.

```sh
git clone https://github.com/NXP/imx-seco-libs.git
cd imx-seco-libs
git checkout imx_5.4.24_2.1.0
```


```sh
vim Makefile


CFLAGS = -O1 -Werror -fPIC -I$(ZLIB_DIR)/include -L$(ZLIB_DIR)/lib
```


then

```
make
make install
```

For use with building wolfssl/examples later export the install directory using the following:


```sh
export HSM_DIR=`pwd`/export/usr/
```

Make install places the results in the subdirectory “export” by default.


#### Building wolfSSL

##### Building Using Autoconf

If setting up the Yocto image with development tools then wolfSSL can be built directly on the system. For a more minimalistic approach cross compiling can be used. Debug messages can be enabled with –enable-debug. Extra debug messages specific to the SECO work can be enabled by defining the macro DEBUG_SECO and for the /dev/crypto calls DEBUG_DEVCRYPTO. The extra debug messages for both make use of printf, outputting on the stdout pipe.
There are a couple key enable options for use with SECO. --enable-caam=seco, --enable-devcrypto=seco, --with-seco=/hsm-lib/export.


Example build with HSM SECO only (no devcrypto support for additional algorithms)


```sh
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

# Install dependencies for building wolfSSL
sudo apt-get install autoconf automake libtool

./autogen.sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \ --enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB"
make
```

Example building with HSM SECO and additional devcrypto support. The include path to crypto/cryptodev.h needs to be set.


```sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR" --enable-devcrypto=seco \
--enable-curve25519
make
```


There are fail safes to error out early on wolfCrypt_Init / wolfSSL_Init function calls. One case is if the cryptodev module has not been loaded or does not have the support available for the desired operations. The other case where the init operation would fail is if the NXP HSM was not able to be set up. If the application is failing on initialization, adding --enable-debug to the wolfSSL build and the function call wolfSSL_Debugging_ON() before the initialization of wolfSSL will print out useful debug messages about why it is failing.


Example building with debug options turned on


```sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR -DDEBUG_SECO -DDEBUG_DEVCRYPTO" \
--enable-devcrypto=seco --enable-curve25519
```

##### Building Using user_settings.h

These are the macros that can be enabled for building without autotools:



***CAAM***

- WOLFSSL_CAAM - Main macro switch to enable CAAM support.
- WOLF_CRYPTO_CB - CAAM support makes use of crypto callbacks
- WOLFSSL_SECO_CAAM - Enable SECO HSM use with CAAM (AES-GCM is required and used as the algo for importing plain keys into the HSM).
- WOLFSSL_HASH_KEEP - When hashing with algos like SHA256 build up the message and send it to be hashed only on a call to Final.
- WOLFSSL_CAAM_ECC - Enable CAAM ECC support.
- WOLFSSL_CAAM_CMAC - Enable CAAM CMAC support.
- WOLFSSL_CAAM_CIPHER - Enable CAAM AES support.
- WOLFSSL_CAAM_HMAC - Enable CAAM HMAC support.
- WOLFSSL_CAAM_HASH - Enable CAAM hashing support such as SHA256.
- WOLFSSL_CAAM_CURVE25519 - Enable CAAM Curve25519 support.


***cryptodev-linux***

- WOLFSSL_DEVCRYPTO - Main macro switch to enable cryptodev-linux use.
- WOLFSSL_DEVCRYPTO_HMAC - Enable support of HMAC with cryptodev-linux.
- WOLFSSL_DEVCRYPTO_RSA - Enable support of RSA with cryptodev-linux.
- WOLFSSL_DEVCRYPTO_CURVE25519 - Enable support of Curve25519 with cryptodev-linux.
- WOLFSSL_DEVCRYPTO_ECDSA - Enable support of ECDSA with cryptodev-linux.
- WOLFSSL_DEVCRYPTO_HASH_KEEP - Enable support of storing up hashes with cryptodev-linux.


***Additional files that need compiled for CAAM support are:***


- wolfssl/wolfcrypt/src/port/caam/wolfcaam_aes.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_cmac.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_rsa.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_ecdsa.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_x25519.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_hash.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_hmac.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_init.c
- wolfssl/wolfcrypt/src/port/caam/wolfcaam_seco.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_ecdsa.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_x25519.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_rsa.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_hmac.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_hash.c
- wolfssl/wolfcrypt/src/port/devcrypto/devcrypto_aes.c
- wolfssl/wolfcrypt/src/port/devcrypto/wc_devcrypto.c
- wolfssl/wolfcrypt/src/cryptocb.c

#### Examples

##### Running Testwolfcrypt

The unit tests that are bundled with wolfSSL are located in wolfcrypt/test/test.c. An example of building and running the tests on the device would be the following. Note that this uses WOLFSSL_CAAM_DEVID so it is making use of the cryptodev module and not the NXP HSM library.


```
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR \
--with-seco=$HSM_DIR --enable-caam=seco --enable-cmac --enable-aesgcm \
--enable-aesccm --enable-keygen CPPFLAGS="-DHAVE_AES_ECB -I$CRYPTODEV_DIR" \
--enable-devcrypto=seco --enable-curve25519 --enable-sha224 --enable-static \
--disable-shared --disable-filesystem
make

scp wolfcrypt/test/testwolfcrypt root@192.168.0.14:/tmp
ssh root@192.168.0.14
root@imx8qxpc0mek:~# /tmp/testwolfcrypt
------------------------------------------------------------------------------
 wolfSSL version 5.2.0
------------------------------------------------------------------------------
error	test passed!
MEMORY   test passed!
base64   test passed!
asn  	test passed!
RANDOM   test passed!
MD5  	test passed!
SHA  	test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-3	test passed!
Hash 	test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
HMAC-SHA3   test passed!
HMAC-KDF	test passed!
GMAC 	test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES  	test passed!
AES192   test passed!
AES256   test passed!
AES-GCM  test passed!
AES-CCM  test passed!
RSA  	test passed!
DH   	test passed!
PWDBASED test passed!
ECC  	test passed!
ECC buffer test passed!
CURVE25519 test passed!
CMAC 	test passed!
COMPRESS test passed!
logging  test passed!
time test passed!
mutex	test passed!
memcb	test passed!
crypto callback test passed!
Test complete
Exiting main with return code: 0
root@imx8qxpc0mek:~#
```


Additional examples are located in the wolfssl-examples repository under the caam/seco directory.


```sh
git clone https://github.com/wolfssl/wolfssl-examples
cd wolfssl-examples/caam/seco
make
```

##### Compiling Source Code [using user_settings.h]

To build a single source file linking to wolfSSL the following commands could be used. Assuming that the env. variables from the previous steps are still set.


```
source /opt/fsl-imx-xwayland/5.4-zeus/environment-setup-aarch64-poky-linux

$CC -DWOLFSSL_USER_SETTINGS -I /path/to/user_settings.h \
-I $CRYPTODEV_DIR -I $HSM_DIR/include -I ./wolfssl server-dtls.c \
libwolfssl.a $HSM_DIR/lib/hsm_lib.a $HSM_DIR/lib/seco_nvm_manager.a \
$ZLIB_DIR/lib/libz.a -lpthread -lm
```

#### API

##### API Added

***List of additional API added***

- void wc_SECO_AesSetKeyID(Aes* aes, int keyId);
This function is used to set a SECO key ID into an Aes structure. It should be called after the Aes structure has been initialized and before the structure gets used for encrypt/decrypt operations.
- int wc_SECO_AesGetKeyID(Aes* aes);
A getter function for the SECO key ID set in the Aes structure.
- void wc_SECO_CMACSetKeyID(Cmac* cmac, int keyId);
Similar to wc_SECO_AesSetKeyID but for Cmac structures.
- int wc_SECO_CMACGetKeyID(Cmac* cmac);
Getter function for the SECO key ID set in the Cmac structure.
- int wc_SECO_OpenHSM(word32 keyStoreId, word32 nonce, word16 maxUpdates, byte flag);
This function should be called before doing any operations that require the keystore. Such as ECC or AES operations. The first argument is the keystore ID, “nonce” is the specific 32bit sequence used when creating and unlocking an already existing keystore, “maxUpdates” sets the max number of times the key store can be updated, “flag” is used for optional flags and takes in whether or not the key store is being created. To create the HSM keystore the flag should be CAAM_KEYSTORE_CREATE otherwise to open an existing keystore or update it the flag should be CAAM_KEYSTORE_UPDATE.
- int wc_SECO_CloseHSM(void);
This function must be called when done with the keystore and before calling wolfCrypt_Cleanup/wolfSSL_Cleanup. It closes down the currently open keystore.
- int wc_SECO_GenerateKey(int flags, int group, byte* out, int outSz, int keyType, int keyInfo, unsigned int* keyIdOut);\
This function can be used for generating new keys in the SECO. For key generation the flag should be CAAM_GENERATE_KEY. For updating a key the flag should be CAAM_UPDATE_KEY. The keyIdOut argument is an in/out argument that gets populated on key creation and should be set as an input on key update. In the case of updating a key it should be a transient type and the group should be set to 0 for updating. Transient type is set as the keyInfo arg, possible options for keyInfo and KeyTypes are;
    - CAAM_KEY_TRANSIENT (keyInfo)
    - CAAM_KEY_PERSISTENT (keyInfo)
    - CAAM_KEYTYPE_ECDSA_P256 (keyType)
    - CAAM_KEYTYPE_ECDSA_P384 (keyType)
    - CAAM_KEYTYPE_AES128 (keyType)
- int wc_SECO_DeleteKey(unsigned int keyId, int group, int keyTypeIn);
Used to delete a key from the keystore.

##### Native wolfSSL API With CAAM Support

This is a list of native wolfSSL API that now have CAAM support with the SECO build outlined in this documentation.



For generation of any AES encrypt and decrypt operations the key can be generated using the following process. Using wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut); where groupID is a specified group number and pubOut is a 32 byte buffer, and the variable keyIdOut gets set to a the new key ID generated. This new key ID generated can then be set in an Aes structure using wc_SECO_AesSetKeyID(Aes, keyIdOut); . Once the key ID has been set in the structure and the Aes structure has been initialized as a WOLFSSL_SECO_DEVID type it will use that key ID for all encrypt and decrypt operations.

###### ***AES (ECB/CBC)***

Alternatively to generate AES ECB/CBC keys, if the Aes structure has been initialized with WOLFSSL_SECO_DEVID the function wc_AesSetKey can be called with a plain text key passed to it. The API wc_AesSetKey will then try to encrypt the key using the unique KEK and import it into the SECO HSM. If imported successfully, the value of 0 will be returned and the key ID will be set in the Aes structure.


- CBC encrypt would be done with wc_AesCbcEncrypt, decrypt with wc_AesCbcDecrypt.
- ECB encrypt would be done with wc_AesEcbEncrypt, decrypt with wc_AesEcbDecrypt.


Once finished with the Aes structure it must be free’d using wc_AesFree(Aes); .

###### ***AES-GCM***

- GCM encrypt would be done with wc_AesGcmEncrypt, decrypt with wc_AesGcmDecrypt.


The AES-GCM encrypt function takes in the Aes structure, output buffer, input buffer, input buffer size, nonce, nonce size (required to be 12 bytes), MAC or known as tag, tag size (required to be 16 bytes), additional data, additional data size (4 bytes). On encryption the input buffer is encrypted and the tag buffer is filled with a created MAC.

For AES-GCM decrypt the function takes in the Aes structure, plain text output buffer, cipher text input buffer, input buffer size, nonce, nonce size (12 bytes), previously created tag from encryption call, tag buffer size, additional data, additional data size. On decryption the tag buffer is checked to verify the message's integrity.

Once finished with the Aes structure it must be free’d using wc_AesFree(Aes); .

###### ***AES-CCM***

- CCM encrypt would be done with wc_AesCcmEncrypt, decrypt with wc_AesCcmDecrypt.


The AES-CCM encrypt function takes in the Aes structure, output buffer, input buffer, input buffer size, nonce, nonce size (required to be 12 bytes), MAC or known as tag, tag size (required to be 16 bytes), additional data, additional data size (0 bytes). The additional data buffer should be NULL and a size of 0 is required with the NXP HSM library. On encryption the input buffer is encrypted and the tag buffer is filled with a created MAC.
\
For AES-CCM decrypt the function takes in the Aes structure, plain text output buffer, cipher text input buffer, input buffer size, nonce, nonce size (12 bytes), previously created tag from encryption call, tag buffer size, additional data, additional data size. Similar to the encrypt function the additional data buffer should be NULL. On decryption the tag buffer is checked to verify the message's integrity.
\
Once finished with the Aes structure it must be free’d using wc_AesFree(Aes); .
\

###### ***AES CMAC***

For AES CMAC operations the AES key can be generated using wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut); where groupID is a specified group number and pubOut is a 32 byte buffer, and the variable keyIdOut gets set to a the new key ID generated. This new key ID generated can then be set in an Aes structure using wc_SECO_CMACSetKeyID(Cmac, keyIdOut); . Once the key ID has been set in the structure and the Aes structure has been initialized as a WOLFSSL_SECO_DEVID type it will use that key ID for all encrypt and decrypt operations.

Since the HSM library is a single shot type, each call to wc_CmacUpdate stores up the input into an internal buffer. Then once wc_CmacFinal is called the whole buffer is passed on to the hardware for creating the MAC.


###### ***RSA***

RSA operations make use of the cryptodev-linux module. This includes support for AES-ECB encrypted black private keys, which is the default when initialized with WOLFSSL_CAAM_DEVID.

Example of native wolfSSL API that would be used with the cryptodev-linux module is as follows:


```lang-c
wc_InitRsaKey_ex(key, heap-hint (can be NULL), WOLFSSL_CAAM_DEVID);
wc_MakeRsaKey(key, 3072, WC_RSA_EXPONENT, &rng);
wc_RsaSSL_Sign or wc_RsaPublicEncrypt
wc_RsaSSL_Verify or wc_RsaPrivateDecrypt
wc_FreeRsaKey(key)
```

###### ***ECC***

ECC sign and verify operations can use either the cryptodev-linux module or the NXP HSM library. ECDH operations for creating a shared secret can only be done with the cryptodev-linux module.

For use with SECO (using the NXP HSM library) the dev ID flag of WOLFSSL_SECO_DEVID should be used when initializing the ecc_key structure. For use with the cryptodev-linux module the dev ID flag WOLFSSL_CAAM_DEVID should be used. After initialization with the function wc_ecc_init_ec(key, heap-hint (can be NULL), dev ID); then both use cases follow the same function native wolfSSL function calls for sign and verify.

Example function calls after initialization of the ecc_key structure would be:


> ```lang-c
> wc_ecc_make_key(&rng, ECC_P256_KEYSIZE, key);
> wc_ecc_sign_hash(hash, hashSz, sigOut, sigOutSz, &rng, key);
> wc_ecc_verify_hash(sig, sigSz, hash, hashSz, &result, key);
> ```


And with the cryptodev-linux module (WOLFSSL_CAAM_DEVID) the ECDH function can be used:


```lang-c
wc_ecc_shared_secret(keyA, keyB, sharedSecret, sharedSecretSz);
```

###### ***Hash (Sha256, Sha384, HMAC)***

SHA256 and SHA384 operations use the NXP HSM library. HMAC operations make use of the cryptodev-linux module.

By default SHA operations try to make use of the NXP HSM library, but explicitly set them to the dev ID WOLFSSL_SECO_DEVID can be used.


```lang-c
wc_InitSha256_ex(sha256, heap-hint, WOLFSSL_SECO_DEVID);
wc_InitSha384_ex(sha384, heap-hint, WOLFSSL_SECO_DEVID);
```

Because the NXP HSM library supports a single shot operation for hashing, each call to “update” will store the buffer until a “final” function is called and then pass the whole buffer on to the hardware for creating the hash digest.

Where HMAC makes use of the cryptodev-linux the Hmac structure should be initialized using the dev ID WOLFSSL_CAAM_DEVID.


```lang-c
wc_HmacInit(hmac, heap-hint, WOLFSSL_CAAM_DEVID);
```


It then can be used like it typically would be with native wolfSSL API:

```lang-c
wc_HmacSetKey(hmac, hash-type, key, keySz);
wc_HmacUpdate(hmac, input, inputSz);
wc_HmacFinal(hmac, digestOut);
```

###### ***Curve25519***

Curve25519 point multiplication is done using the cryptodev-linux module and should be initialized with the dev ID WOLFSSL_CAAM_DEVID for use with the hardware.

Example API calls would be as follows:


```lang-c
wc_curve25519_init_ex(key, heap-hint, WOLFSSL_CAAM_DEVID);
wc_curve25519_make_key(&rng, CURVE25519_KEYSIZE,  key);
wc_curve25519_shared_secret(key, keyB, sharedSecretOut, sharedSecretOutSz);
```

###### ***RNG***

TRNG for seeding the wolfSSL HASH-DRBG makes use of the NXP HSM library. This is compiled in to the wolfcrypt/src/random.c file when wolfSSL is built with --enable-caam=seco. All RNG initializations in wolfSSL will make use of the TRNG for seeding. Standard RNG API calls would be as follows:


```lang-c
wc_InitRng(rng);
wc_RNG_GenerateBlock(rng, output, outputSz);
wc_FreeRng(rng);
```

### i.MX8 (QNX)

<Documentation available, not inserted here yet @TODO>

### i.MX6 (QNX)

<Documentation available, not inserted here yet @TODO>

### IMXRT1170 (FreeRTOS)

Example IDE Setup for use with IMXRT1170 can be found in the directory IDE/MCUEXPRESSO/RT1170


#### Build Steps

- Open MCUEXPRESSO and set the workspace to wolfssl/IDE/MCUEXPRESSO/RT1170
- File -> Open Projects From File System... -> Directory : and set the browse to wolfssl/IDE/MCUEXPRESSO/RT1170 directory then click "select directory"
- Select wolfssl_cm7, wolfcrypt_test_cm7, CSR_example, PKCS7_example
- Right click the projects -> SDK Management -> Refresh SDK Components and click "yes"
- increase the size of configTOTAL_HEAP_SIZE in FreeRTOSConfig.h to be 60240 for CSR and PKCS7 example and around 100000 for wolfcrypt_test_cm7
- (note board files need to be recreated .... this can be done by creating a new project that has the same settings and copying over the generated board/* files)
- Build the projects


#### Expanding RT1170 CAAM Driver

The files RT1170/fsl_caam_h.patch and RT1170/fsl_caam_c.patch include changes to
the existing NXP CAAM driver for use with creating/opening Blobs and generating
and using ECC black keys.

To apply the patches first create a project that has the caam driver. This will
generate the base fsl_caam.c and fsl_caam.h in the drivers directory. (i.e PKCS7_example_cm7/drivers/fls_caam.{c,h})
. Once the base files are generated then 'cd' to the drivers directory and apply
the patch (cd PKCS7_example_cm7/drivers/ && patch -p1 < ../../fsl_caam_c.patch && patch -p1 < ../../fsl_caam_h.patch)

In the patch for fsl_caam.h there are macros defined for both the ECC and Blob
expansion (CAAM_ECC_EXPANSION and CAAM_BLOB_EXPANSION). When wolfSSL code finds
that these macros are defined (the patch has been applied) then it tries to
compile in use of the expanded driver.

