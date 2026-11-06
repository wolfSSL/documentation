# Building wolfSSL

wolfSSL was written with portability in mind and should generally be easy to build on most systems. If you have difficulty building wolfSSL, please don't hesitate to seek support through our support forums (<https://www.wolfssl.com/forums>) or contact us directly at [support@wolfssl.com](mailto:support@wolfssl.com).

This chapter explains how to build wolfSSL on Unix and Windows, and provides guidance for building wolfSSL in a non-standard environment. You will find the "getting started" guide in [Chapter 3](chapter03.md#getting-started) and an SSL tutorial in [Chapter 11](chapter11.md#ssl-tutorial).

When using the autoconf / automake system to build wolfSSL, wolfSSL uses a single Makefile to build all parts and examples of the library, which is both simpler and faster than using Makefiles recursively.

## Getting wolfSSL Source Code

The most recent version of wolfSSL can be downloaded from the wolfSSL website as a ZIP file:

<https://www.wolfssl.com/download>

After downloading the ZIP file, unzip the file using the `unzip` command. To use native line endings, enable the `-a` modifier when using unzip. From the unzip man page, the `-a` modifier functionality is described:

> [...] The -a option causes files identified by zip as text files (those with
> the 't' label in zipinfo listings, rather than 'b') to be automatically
> extracted as such, converting line endings, end-of-file characters
> and the character set itself as necessary. [...]

The source code is also available from GitHub:

```sh
git clone https://github.com/wolfSSL/wolfssl.git
```

A git checkout does not include the `configure` script. Generate it by running `./autogen.sh` from the wolfSSL root directory before following the steps below. This requires autoconf (2.69 or later), automake (1.13.4 or later) and libtool (2.4.2 or later). The release ZIP files already contain `configure`.

**NOTE**: For the location of the wolfSSL header files, see [Library Headers](chapter09.md#library-headers). For the names of the native wolfSSL structures, see [Structure Usage](chapter09.md#structure-usage).

## Building on Unix-like Systems

When building wolfSSL on Linux, \*BSD, OS X, Solaris, or other \*nix-like systems, use the autoconf system. To build wolfSSL you only need to run two commands from the wolfSSL root directory, `./configure` and `make` (run `./autogen.sh` first if building from a git checkout).

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

`./configure` generates the header `wolfssl/options.h`, which records the build settings. Applications must `#include <wolfssl/options.h>` before any other wolfSSL header (or define `WOLFSSL_USE_OPTIONS_H`, which makes the wolfSSL headers include it automatically) so that they are compiled with the same configuration as the library.

To test the build, run the testsuite program from the root wolfSSL directory:

```sh
./testsuite/testsuite.test
```

Alternatively you can use autoconf to run the testsuite as well as the standard wolfSSL API and crypto tests:

```sh
make test
```

Further details about expected output of the testsuite program can be found in the [Testsuite section](chapter03.md#testsuite). If you want to build only the wolfSSL library and not the additional items (examples, testsuite, benchmark app, etc.), you can run the following command from the wolfSSL root directory:

```sh
make src/libwolfssl.la
```

### Building Debian and RPM Packages

After running `./configure` with the options you want, `make deb` builds a Debian package (Debian, Ubuntu, Linux Mint and derivatives) and `make rpm` builds an RPM package (RHEL, Fedora, CentOS, SUSE and openSUSE) with that configuration. `make deb-docker` and `make rpm-docker` build the same packages inside a Docker container.

## Building with CMake

wolfSSL can also be configured and built with CMake 3.16 or later (3.22 or later is recommended). The autoconf build is the primary build system; the CMake build supports the commonly used options, but not every `./configure` option.

CMake does not allow building in the source directory, so create a separate build directory. From the wolfSSL root directory:

```sh
mkdir build
cd build
cmake ..
cmake --build .
```

`cmake --build .` runs the underlying build tool (`make` by default on Unix-like systems), which can also be run directly.

Build options are set with `-D<option>=yes` or `-D<option>=no` on the `cmake` command line. For example, `cmake .. -DWOLFSSL_TLS13=no` is the equivalent of `./configure --disable-tls13`, and `cmake .. -DWOLFSSL_CURVE25519=yes` is the equivalent of `./configure --enable-curve25519`. To list every option with its description and current value, run `cmake -LH ..` from the build directory, use the CMake GUI, or look in `CMakeCache.txt` after the first run. Other useful settings:

* `-DCMAKE_BUILD_TYPE=Debug` builds with debugging information.
* `-DBUILD_SHARED_LIBS=OFF` builds a static library instead of the default shared library.
* `-DWOLFSSL_EXAMPLES=no` and `-DWOLFSSL_CRYPT_TESTS=no` skip the example applications and the wolfCrypt test and benchmark.

Like `./configure`, CMake generates `wolfssl/options.h` with the build settings. By default it is written to the build directory, not the source tree. The examples, the unit tests and the wolfCrypt test and benchmark are also built in the build directory, and running `ctest` there runs the unit tests and the wolfCrypt test.

### Installing and Using wolfSSL with CMake

`cmake --install .` installs the library, the headers (including `options.h`), a `wolfssl.pc` pkg-config file and CMake package files. Add `--prefix /path/to/install` to choose the install location, or set `CMAKE_INSTALL_PREFIX` when configuring. Other CMake projects can then find wolfSSL with `find_package()` and link to the imported `wolfssl::wolfssl` target:

```cmake
find_package(wolfssl CONFIG REQUIRED)
target_link_libraries(my_app PRIVATE wolfssl::wolfssl)
```

If wolfSSL is installed in a non-standard location, pass `-DCMAKE_PREFIX_PATH=/path/to/install` when configuring that project. A minimal example project is in `cmake/consumer`. `make install` in the autoconf build also installs CMake package files, under `$(libdir)/cmake/wolfssl`, to support `find_package(wolfssl)`; disable this with `./configure --disable-cmake-install`.

### CMake on Windows

With the CMake GUI, set "Where is the source code" to the wolfSSL root directory and "Where to build the binaries" to a build directory (for example `wolfssl/build`), click Configure, change any options, then click Generate. Open the generated `wolfssl.sln` from the build directory in Visual Studio. Alternatively, run the command line steps above from a Visual Studio developer command prompt (or after running `vcvars64.bat`).

`CMakePresets.json` in the root directory defines a `vs2022-x64` preset: `cmake --preset vs2022-x64` generates a Visual Studio 2022 x64 solution in the `build` directory. Visual Studio 2022 (17.1 or later) also uses this file when the wolfSSL folder is opened directly.

## Installing with vcpkg

wolfSSL is also available as a [vcpkg](https://github.com/microsoft/vcpkg) port, which wolfSSL keeps up to date:

```sh
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
./vcpkg install wolfssl
```

On Windows, run `bootstrap-vcpkg.bat` instead of `./bootstrap-vcpkg.sh`.

## Building on Windows

In addition to the instructions below, you can find instructions and tips for building wolfSSL with Visual Studio [here](https://wolfssl.com/wolfSSL/Docs-wolfssl-visual-studio.html). wolfSSL can also be built on Windows with CMake; see [CMake on Windows](#cmake-on-windows).

### Visual Studio

Open the solution `wolfssl64.sln` in the wolfSSL root directory. It builds the wolfSSL library (`wolfssl.vcxproj`), the testsuite, the sslSniffer and the client, server, echoclient and echoserver examples, for Win32, x64 and ARM64. The projects use the Visual Studio 2012 (v110) platform toolset; newer versions of Visual Studio can retarget them to the installed toolset.

For Visual Studio 2022, the library project `wolfssl-VS2022.vcxproj` uses the v143 toolset. The solutions `wolfcrypt/test/test-VS2022.sln` and `wolfcrypt/benchmark/benchmark-VS2022.sln` build it together with the wolfCrypt test and benchmark applications.

Solutions for FIPS builds, which need the FIPS source bundle from wolfSSL, are in `IDE/WIN10` (FIPS v2 and FIPS v5 and later), `IDE/WIN-PQ-FIPSv7` (FIPS 140-3 v7.0.0) and `IDE/WIN` (the original FIPS #2425 certificate). See the README in each directory.

To test each build, choose Build > Build Solution from the Visual Studio menu and then run the testsuite program. To edit build options in the Visual Studio project, select your desired project (wolfssl, echoclient, echoserver, etc.) and browse to the "Properties" panel.

**Note**: After the wolfSSL v3.8.0 release the build preprocessor macros were moved to a centralized file located at `IDE/WIN/user_settings.h`. This file can also be found in the project. To add features such as ChaCha20/Poly1305 or Curve25519, add `#defines` here such as `HAVE_CHACHA` / `HAVE_POLY1305` or `HAVE_CURVE25519`.

### Cygwin

If building wolfSSL for Windows on a Windows development machine, we recommend using the included Visual Studio project files to build wolfSSL. However, if Cygwin is required here is a short guide on how our team achieved a successful build:

1. Go to <https://www.cygwin.com/install.html> and download `setup-x86_64.exe`
2. Run `setup-x86_64.exe` and install however you choose. Click through the installation menus until you reach the "Select Packages" stage.
3. Click on the "+" icon to expand "All"
4. Go to the "Archive" section, click the "unzip" drop down and change "Skip" to the current version.
5. Under "Devel", do the same for each of "autoconf", "automake", "gcc-core", "git", "libtool" and "make", selecting the current version of each.
6. Click "Next" and proceed through the rest of the installation.

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

## Building with Various Vendor IDEs

Download the complete wolfSSL source code package from the wolfSSL website, extract it, and apply the following settings.

### 1. wolfSSL Library Build Project

- **Register source files to be compiled**  
  Register all `*.c` files in `./src` and all `*.c` files in the top level of `./wolfcrypt/src`. Add files from `./wolfcrypt/src/port/<vendor>/` and any assembly files (`.S` / `.asm`) only as needed for your target.  
  Exclude the following files, which are `#include`d by other source files and must not be compiled separately:

        src/ssl_*.c          (all ssl_*.c files; keep src/ssl.c itself)
        src/x509.c  src/x509_str.c
        src/bio.c  src/conf.c
        src/pk.c  src/pk_ec.c  src/pk_rsa.c
        wolfcrypt/src/evp.c  wolfcrypt/src/evp_pk.c
        wolfcrypt/src/asn_orig.c  wolfcrypt/src/asn_tsp.c
        wolfcrypt/src/asm.c
        wolfcrypt/src/misc.c  (unless NO_INLINE is defined)

- **Define configuration options**  
  Store the configuration definitions in a header file named `user_settings.h`.  
  Refer to:
    - `wolfssl/examples/configs/README.md`
    - `wolfssl/examples/configs/user_settings_template.h`

- **Register predefined macro names**  
  When `WOLFSSL_USER_SETTINGS` is defined, the above `user_settings.h` file is included at build time.

- **Register include paths**  
  Register the path to the wolfSSL source file root and the path to the above `user_settings.h`.

---

### 2. Application Executable Build Project

- Register the wolfSSL library generated in step 1 as a link target.
- Register the wolfSSL source file root path and the configuration option path (`user_settings.h`) defined in step 1 as include paths.
- Specify `"WOLFSSL_USER_SETTINGS"` as a predefined macro name.




## Building in a non-standard environment

While not officially supported, we try to help users wishing to build wolfSSL in a non-standard environment, particularly with embedded and cross-compilation systems. Below are some notes on getting started with this.

1. The source and header files need to remain in the same directory structure as they are in the wolfSSL download package.
2. Some build systems will want to explicitly know where the wolfSSL header files are located, so you may need to specify that. They are located in the `<wolfssl_root>/wolfssl` directory. Typically, you can add the `<wolfssl_root>` directory to your include path to resolve header problems.
3. wolfSSL defaults to a little endian system unless the configure process detects big endian. Since users building in a non-standard environment aren't using the configure process, `BIG_ENDIAN_ORDER` will need to be defined if using a big endian system.
4. wolfSSL benefits speed-wise from having a 64-bit type available. The configure process determines if long or long long is 64 bits and if so sets up a define. So if `sizeof(long)` is 8 bytes on your system, define `SIZEOF_LONG 8`. If it isn't but `sizeof(long long)` is 8 bytes, then define `SIZEOF_LONG_LONG 8`. If neither is defined, `wolfssl/wolfcrypt/types.h` tries to detect them: from `limits.h` when `HAVE_LIMITS_H` or `_WIN32` is defined, otherwise from common 64-bit compiler macros (such as `__x86_64__` or `__aarch64__`). A manual define is only needed when this detection fails.
5. Try to build the library, and let us know if you run into any problems. If you need help, contact us at [facts@wolfssl.com](mailto:facts@wolfssl.com).
6. Some defines that can modify the build are listed in [Features Defined as C Pre-processor Macro](#features-defined-as-c-pre-processor-macros). For more verbose descriptions of many options, please see [Build Options](#build-options).

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

    bitbake can be used to build wolfSSL product recipes such as *wolfssl*, *wolfssh*,
    *wolfmqtt*, *wolftpm*, *wolfclu*, *wolfpkcs11*, *wolfprovider* and *wolfengine*
    (see the meta-wolfssl README for the full list). Simply pass one of those recipes
    into the bitbake command (example: `bitbake wolfssl`). This allows the user to
    personally confirm compilation succeeds without issues.

4. **Edit local.conf**

    The final step is to edit the build's local.conf file, which allows desired libraries to
    be included with the image being built. Edit the `IMAGE_INSTALL:append` line
    to include the name of the desired recipe(s). An example of this is shown below:

    ```sh
    IMAGE_INSTALL:append = " wolfssl wolfssh wolfmqtt"
    ```

    Note the leading space inside the quotes: `append` does not add a separator,
    so without it the first name is joined onto the previous entry. The colon
    override syntax is used by Yocto Dunfell (3.1) and newer; older releases use
    `IMAGE_INSTALL_append` instead.

Once the image has been built, wolfSSL's default location (or related products from recipes) will be the `/usr/lib/` directory.

Additionally, wolfSSL can be customized when building into Yocto by using the enable and disable options listed in [Build Options](#build-options). This requires creating a `.bbappend` file and placing it within the wolfSSL application/recipe layer. The contents of this file should include a line specifying content to concatenate onto the `EXTRA_OECONF` variable. An example of this is shown below to enable Curve25519 support, which is disabled by default:

```sh
EXTRA_OECONF += " --enable-curve25519"
```

Further documentation on building into Yocto can be found in the meta-wolfssl README, located here: <https://github.com/wolfSSL/meta-wolfssl/blob/master/README.md>

### Building with STM32CubeIDE

For STM32 devices, wolfSSL is available as the I-CUBE-wolfSSL Cube pack for STM32CubeMX and STM32CubeIDE. Add the wolfSSL pack components to a CubeMX project ("Software Packs" -> "Select Components"), configure the pack parameters, generate the code and open the project in STM32CubeIDE. The example in `<wolfssl_root>/IDE/STM32Cube` runs the wolfCrypt test, the wolfCrypt benchmark and a TLS client/server test. See `<wolfssl_root>/IDE/STM32Cube/README.md` for installing the pack, the example projects and the configuration options.

### Building with IAR

The `<wolfssl_root>/IDE/IAR-EWARM/Projects` directory contains the following files:

1. Workspace: `wolfssl.eww`
   The workspace includes wolfSSL-Lib library and wolfCrypt-test, wolfCrypt-benchmark
   executable projects.
2. wolfSSL-Lib Project: `lib/wolfSSL-Lib.ewp`
   generates full set library of wolfCrypt and wolfSSL functions.
3. Test suites Project: `test/wolfCrypt-test.ewp`
   generates test.out test suites executable
4. Benchmark Project: `benchmark/wolfCrypt-benchmark.ewp`
   generates benchmark.out benchmark executable

Projects for use with the Segger embOS RTOS are in `<wolfssl_root>/IDE/IAR-EWARM/embOS`.

These projects have been set up for generic ARM Cortex-M MCUs. In order to generate project for specific target MCU, take following steps.

1. Default Setting: Default Target of the projects are set to Cortex-M3 Simulator. user_settings.h includes default options for the projects. You can build and
download them to the simulator. Open Terminal I/O window, by "view"->"Terminal I/O", and start execution.

2. Project option settings: For each project, choose appropriate "Target" options.

3. For executable projects: Add "SystemInit" and "startup" for your MPU, choose your debug "Driver".

4. For benchmark project: Choose option for current_time function or write your own "current_time" benchmark timer with WOLFSSL_USER_CURRTIME option.

5. Build and download: Go to "Project->Make" and "Download and Debug" in Menu bar for EWARM build and download.

### Building on OS X and iOS

#### XCODE

The `<wolfssl_root>/IDE/XCODE` directory contains the following files:

1. `wolfssl.xcworkspace` -- workspace with library and testsuite client
2. `wolfssl_testsuite.xcodeproj` -- project to run the testsuite.
3. `wolfssl.xcodeproj` -- project to build macOS, iOS and tvOS libraries for wolfSSL and/or wolfCrypt
4. `wolfssl-FIPS.xcodeproj` -- project to build wolfSSL and wolfCrypt-FIPS if available
5. `user_settings.h` -- custom library settings, which are shared across projects

The library will output as `libwolfssl_osx.a`, `libwolfssl_ios.a` or `libwolfssl_tvos.a` depending on the target. It will also copy the wolfSSL/wolfCrypt headers into an `include` directory located in
`Build/Products/Debug` or `Build/Products/Release`.

For the library and testsuite to link properly the build location needs to be configured relative to the workspace.

1. File -> Workspace Settings (or Xcode -> Settings -> Locations)
2. Derived Data -> Advanced
3. Custom -> Relative to Workspace
4. Products -> Build/Products

These Xcode projects define the `WOLFSSL_USER_SETTINGS` preprocessor to enable the `user_settings.h` file for setting macros across multiple projects.

If needed the Xcode preprocessors can be modified with these steps:

1. Click on the Project in "Project Navigator".
2. Click on the "Build Settings" tab.
3. Scroll down to the "Apple Clang - Preprocessing" section.
4. Open the disclosure for "Preprocessor Macros" and use the "+" and
"-" buttons to modify. Remember to do this for both Debug and Release.

This project should build wolfSSL and wolfCrypt using the default settings.

#### Universal framework built with configure

`<wolfssl_root>/IDE/apple-universal/build-wolfssl-framework.sh` builds wolfSSL with `./configure` as a static library for macOS, iOS, tvOS and watchOS devices and their simulators, and packages the results as an `xcframework` that can be added to an Xcode project. Extra configure options can be passed with `-c "<options>"`. The directory also contains an example multiplatform Xcode app that uses the framework; see its `README.md`.

When building with `./configure` on an Apple Silicon (ARM64) Mac, make sure the host CPU is detected as `aarch64`; if it is not, pass `--host=aarch64-apple-darwin` to `./configure`.

### Building with GCC ARM

In the `<wolfssl_root>/IDE/GCC-ARM` directory, you will find an example wolfSSL project for Cortex M series, but it can be adapted for other architectures.

1. Make sure you have `gcc-arm-none-eabi` installed.
2. Modify the `Makefile.common`:
   * Use correct toolchain path `TOOLCHAIN`.
   * Use correct architecture 'ARCHFLAGS'. See [GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html) `-mcpu=name`.
   * Confirm memory map in linker.ld matches your flash/ram or comment out `SRC_LD = -T./linker.ld` in Makefile.common.
3. Use `make` to build the static library (libwolfssl.a), wolfCrypt test/benchmark and wolfSSL TLS client and server targets as `.elf` and `.hex` in `./Build`.

#### Building with generic makefile cross-compile

Example `Makefile.common` changes for Raspberry Pi with Cortex-A53:

1. In Makefile.common change `ARCHFLAGS` to `-mcpu=cortex-a53 -mthumb`.
2. Comment out `SRC_LD`, since custom memory map is not applicable.
3. Clear `TOOLCHAIN`, so it will use default `gcc`. Set `TOOLCHAIN =`
4. Comment out the `LDFLAGS += --specs=nano.specs` and `LDFLAGS += --specs=nosys.specs` lines.

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

wolfSSL is distributed for Keil MDK 5 as the `wolfSSL::wolfSSL` CMSIS pack:

1. Install the pack with the Keil Pack Installer (under "Generic").
2. Add it to your project with Project -> Manage -> "Run-Time Environment", checking wolfCrypt CORE and wolfSSL CORE (and the test or example components if needed).
3. Define `WOLFSSL_USER_SETTINGS` (Options for Target -> C/C++ -> Preprocessor Symbols).
4. Configure the pack's `user_settings.h` with its `MDK_CONF_*` settings, for example the math library (`MDK_CONF_MATH`), RTOS (`MDK_CONF_THREAD`) and TCP stack (`MDK_CONF_NETWORK`).

Example projects (library builds, the wolfCrypt test and benchmark, and TLS client and server examples) are in `<wolfssl_root>/IDE/MDK5-ARM/Projects`. See `<wolfssl_root>/IDE/MDK5-ARM/README.md` for details.

## Features Defined as C Pre-processor Macros

### Removing Features

The following defines can be used to remove features from wolfSSL. This can be helpful if you are trying to reduce the overall library footprint size. In addition to defining a `NO_<feature-name>` define, you can also remove the respective source file as well from the build (but not the header file).

#### NO_WOLFSSL_CLIENT

Removes calls specific to the client and is for server-only builds. You should only use this if you want to remove a few calls for the sake of size.

#### NO_WOLFSSL_SERVER

Likewise removes calls specific to the server side.

#### NO_DES3

Removes 3DES (Triple-DES) support. 3DES is disabled by default when building with `./configure` (enable it with [`--enable-des3`](#--enable-des3)) or CMake (`WOLFSSL_DES3` defaults to `no`). When building with user_settings.h it is compiled in unless `NO_DES3` is defined. Defining `NO_DES3` also defines [`NO_DES3_TLS_SUITES`](#no_des3_tls_suites).

#### NO_DES3_TLS_SUITES

Removes the 3DES TLS cipher suites while keeping 3DES available in wolfCrypt. `./configure` and CMake define it by default unless `--enable-des3-tls-suites` (CMake `WOLFSSL_DES3_TLS_SUITES=yes`) is given, and it is defined automatically when `NO_DES3` is set.

#### NO_DSA

Removes DSA since it's being phased out of popular use.

#### NO_ERROR_STRINGS

Disables error strings. Error strings are located in `src/internal.c` for wolfSSL or `wolfcrypt/src/error.c` for wolfCrypt.

#### NO_HMAC

Removes HMAC from the build.

**NOTE**: SSL/TLS depends on HMAC but if you are only using wolfCrypt, i.e. with the build option `WOLFCRYPT_ONLY`, then HMAC can be disabled in this case.

#### NO_MD4

Removes MD4 from the build, MD4 is broken and shouldn't be used.

#### NO_MD5

Removes MD5 from the build.

#### STM32_NOMD5

Disables STM32 hardware MD5 acceleration. Use when STM32 crypto is enabled but MD5 should use the software implementation.

#### NO_SHA

Removes SHA-1 from the build.

#### NO_SHA256

Removes SHA-256 from the build.

#### NO_PSK

Removes pre-shared key (PSK) support: the PSK cipher suites and the TLS 1.3 external PSK callbacks. `./configure` defines `NO_PSK` unless `--enable-psk` is given (PSK is off by default); with user_settings.h PSK is compiled in unless `NO_PSK` is defined.

#### NO_PWDBASED

Disables password-based key derivation functions such as PBKDF1, PBKDF2, and PBKDF from PKCS #12.

#### NO_PKCS7_STREAM

Disables PKCS#7 streaming mode. Streaming mode allows processing PKCS#7 data incrementally.

#### NO_PKCS7_ENCRYPTED_DATA

Disables the PKCS#7 EncryptedData content type. Reduces code size when only SignedData or EnvelopedData are needed.

#### NO_PKCS7_COMPRESSED_DATA

Disables the PKCS#7 CompressedData content type. CompressedData support is only compiled in when zlib support ([`HAVE_LIBZ`](#have_libz)) is also defined; without `HAVE_LIBZ` it is silently omitted.

#### NO_PKCS8

Removes PKCS#8 key package support (`--disable-pkcs8`). PKCS#12 needs PKCS#8, so [`HAVE_PKCS8`](#have_pkcs8) stays defined unless [`NO_PKCS12`](#no_pkcs12) is also defined.

#### NO_PKCS12

Removes PKCS#12 support (`--disable-pkcs12`). See [`HAVE_PKCS12`](#have_pkcs12).

#### NO_RC4

Removes the ARC4 (RC4) stream cipher. RC4 is deprecated (RFC 7465), so `NO_RC4` is forced on in every build unless `WOLFSSL_ALLOW_RC4` is defined (`--enable-arc4` sets it).

#### NO_SESSION_CACHE

Can be defined when a session cache is not needed. This removes the session cache and the client session cache, which by default hold 33 sessions and take about 13 kB and 17 kB of memory respectively (estimates from the comments in `wolfssl/ssl_sess.h`; the exact size depends on the build options).

#### NO_CLIENT_CACHE

Removes the client session cache, which a client uses to find a previous session for a server by its ID with `wolfSSL_SetServerID()`. The main session cache is not affected.

#### NO_TLS

Builds without the TLS protocol while keeping the rest of libwolfssl (for example the certificate manager and the OpenSSL compatibility layer), for a smaller library when TLS is not needed. Set by `--disable-tls`. Unlike [`WOLFCRYPT_ONLY`](#wolfcrypt_only), which builds only wolfCrypt, the non-TLS parts of the SSL layer are still compiled.

#### SMALL_SESSION_CACHE

Can be defined to limit the size of the SSL session cache used by wolfSSL. This will reduce the default session cache from 33 sessions to 6 sessions. According to the comments in `wolfssl/ssl_sess.h`, the session cache shrinks from about 13 kB to about 2 kB and the client session cache from about 17 kB to about 3 kB.

#### NO_RSA

Removes support for the RSA algorithm.

#### WC_NO_RSA_OAEP

Removes code for OAEP padding.

#### WOLFSSL_RSA_VERIFY_INLINE

Removes the copying RSA verify functions (`wc_RsaSSL_Verify()`, `wc_RsaSSL_Verify_ex()` and `wc_RsaSSL_Verify_ex2()`), leaving only the in-place `wc_RsaSSL_VerifyInline()`, which returns a pointer into the input buffer instead of copying the output. Reduces code size and memory usage.

#### NO_RSA_BOUNDS_CHECK

Disables bounds checking on RSA input data. By default, wolfSSL checks that the input value c satisfies `1 < c < n - 1`, as required by NIST SP 800-56B.

#### WC_RSA_NO_FERMAT_CHECK

Disables the Fermat factorization proximity check during RSA key generation. By default, wolfSSL verifies that `p` and `q` are not too close together, which would make the key vulnerable to Fermat's factorization method.

#### WOLFSSL_SE050_NO_RSA

Disables RSA through the NXP SE050 secure element. Other SE050 operations remain available.

#### NO_AES_CBC

Turns off AES-CBC algorithm support.

#### NO_AES_DECRYPT

Can be set to reduce code size. Set to disable the decrypt and only support encryption.

#### WOLFCRYPT_ONLY

Enables wolfCrypt only while disabling TLS.

#### NO_CAMELLIA_CBC

Disables the Camellia-CBC TLS cipher suites only; Camellia remains available in wolfCrypt.

#### NO_AES

Disables AES algorithm support.

#### NO_AES_128

Removes support for 128-bit AES keys (`WOLFSSL_AES_128` is not defined).

#### NO_AES_192

Removes support for 192-bit AES keys (`WOLFSSL_AES_192` is not defined).

#### NO_AES_256

Removes support for 256-bit AES keys (`WOLFSSL_AES_256` is not defined).

#### NO_AESGCM_AEAD

Internal flag, defined automatically when no AES-GCM TLS cipher suite is built. Defining it yourself does not remove the AES-GCM cipher suites; to do that, leave out AES-GCM (`HAVE_AESGCM`) or restrict the cipher list at run time, for example with `wolfSSL_CTX_set_cipher_list()`.

#### NO_ASN_TIME

Disables time checking for ASN. Note: This should be used with caution because all certificate begin/end date checking will be skipped.

#### NO_BIO

Disables the BIO (Basic I/O) abstraction layer. Reduces code size when BIO functionality such as `BIO_new()`, `BIO_read()`, `BIO_write()` is not needed.

#### WOLFSSL_NO_OPENSSL_RAND_CB

With `OPENSSL_EXTRA`, removes the OpenSSL RAND method callback support (`wolfSSL_RAND_set_rand_method()`) to reduce code size. Defined automatically with `OPENSSL_EXTRA_X509_SMALL`.

#### NO_VERIFY_OID

Disables OID verification during certificate parsing.

#### NO_SKID

Disables Subject Key Identifier extension processing.

#### NO_STRICT_ECDSA_LEN

Relaxes strict ECDSA signature length checking. Allows non-minimal DER encoding of ECDSA signatures for interoperability.

#### NO_WOLFSSL_SKIP_TRAILING_PAD

Disables stripping of the block cipher padding from a decrypted traditional encrypted PEM private key (DES3 or AES-CBC, with a DEK-Info header).

#### NO_WOLFSSL_STUB

Disables stub implementations of unimplemented OpenSSL compatibility functions. Without stubs, calling unimplemented functions will result in a linker error rather than a runtime failure.

#### WOLFSSL_MLDSA_NO_ASN1

Disables ASN.1 encoding/decoding for ML-DSA keys and signatures. Uses raw format instead. The legacy name `WOLFSSL_DILITHIUM_NO_ASN1` is still accepted as an alias.

#### WOLFSSL_DISABLE_EARLY_SANITY_CHECKS

Disables early sanity checks on incoming TLS messages. May be needed for interoperability with non-compliant TLS implementations.

#### NO_CHECK_PRIVATE_KEY

Removes the check that a private key matches the public key of its certificate, for example `wolfSSL_CTX_check_private_key()` and `wolfSSL_check_private_key()`, which is compiled in by default. The check supports RSA, ECDSA, Ed25519, Ed448, Falcon, ML-DSA and SLH-DSA keys.

#### NO_CIPHER_SUITE_ALIASES

Disables cipher suite name aliases. Only the primary cipher suite name will be recognized, not alternative names.

#### NO_CHAPOL_AEAD

Disables ChaCha20-Poly1305 AEAD cipher suites. Use when ChaCha20-Poly1305 support is not desired even though the algorithms are compiled in.

#### NO_DH

Disables Diffie-Hellman (DH) support.

#### NO_ED25519_CLIENT_AUTH

Disables TLS client authentication support for ED25519. It is used to reduce memory usage during TLS if ED25519 is not used, since it requires caching messages.

#### NO_ED448_CLIENT_AUTH

Disables client authentication for ED448.

#### NO_FORCE_SCR_SAME_SUITE

By default secure renegotiation requires using the same cipher suite. This disables that requirement.

#### NO_MULTIBYTE_PRINT

Used for compiling out special characters that embedded devices may have problems with.

#### NO_OLD_SSL_NAMES

This disables some of the old OpenSSL compatibility macros for using wolfSSL and OpenSSL together.

#### NO_OLD_WC_NAMES

Removes the legacy wolfCrypt names without the `wc_`/`WC_` prefix (for example `Md5`, `MD5_DIGEST_SIZE` and `Sha256`) to avoid symbol clashes, for example with OpenSSL headers. Defined automatically with [`OPENSSL_COEXIST`](#openssl_coexist).

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

#### WOLFSSL_DTLS13_NO_HRR_ON_RESUME

If defined, a DTLS server will not do a cookie exchange on successful client resumption: the resumption will be faster (one RTT less) and will consume less bandwidth (one ClientHello and one HelloVerifyRequest/HelloRetryRequest less). On the other hand, if a valid SessionID/ticket/psk is collected, forged clientHello messages will consume resources on the server. For DTLS 1.3, using this option also allows for the server to process Early Data/0-RTT Data. Without this, the Early Data would be dropped since the server doesn't enter stateful processing until receiving a verified ClientHello with the cookie. For the DTLS 1.2 equivalent, see [`WOLFSSL_DTLS_NO_HVR_ON_RESUME`](#wolfssl_dtls_no_hvr_on_resume).

To allow DTLS 1.3 resumption without the cookie exchange:

- Compile wolfSSL with `WOLFSSL_DTLS13_NO_HRR_ON_RESUME` defined
- Call `wolfSSL_dtls13_no_hrr_on_resume(ssl, 1)` on the WOLFSSL object to disable the cookie exchange on resumption
- Continue like with a normal connection.

#### WOLFSSL_DTLS_NO_HVR_ON_RESUME

The DTLS 1.2 counterpart of [`WOLFSSL_DTLS13_NO_HRR_ON_RESUME`](#wolfssl_dtls13_no_hrr_on_resume): a DTLS 1.2 server skips the HelloVerifyRequest cookie exchange when the ClientHello resumes a valid session (by session ID or session ticket). No run-time call is needed. The same trade-off applies: resumption is one round trip faster, but forged ClientHello messages that carry a valid session ID or ticket will consume resources on the server.

#### WOLFSSL_NO_CLIENT_AUTH

Removes TLS client certificate authentication (TLS 1.2 and TLS 1.3). A client no longer sends Certificate and CertificateVerify messages in reply to a CertificateRequest. On the server, the checks that fail the handshake when a required client certificate was not sent are removed (an empty client Certificate message is still rejected). In a server-only build (`NO_WOLFSSL_CLIENT`) the server also cannot process a client Certificate message. This also removes the handshake message caching needed for Ed25519 and Ed448 client authentication; to remove only that caching, use [`NO_ED25519_CLIENT_AUTH`](#no_ed25519_client_auth) and [`NO_ED448_CLIENT_AUTH`](#no_ed448_client_auth).

#### WOLFSSL_NO_CURRDIR

Portability macro for platforms that do not support ./ for test paths in wolfssl/test.h. Applies to testing tools only.

#### WOLFSSL_NO_DEF_TICKET_ENC_CB

No default ticket encryption callback, server only. The application must set its own callback to use session tickets.

#### WOLFSSL_NO_DTLS_SIZE_CHECK

Changes how `wolfSSL_write()` handles DTLS application data that does not fit in one record (because of the MTU or the maximum fragment length). By default wolfSSL fails with `DTLS_SIZE_ERROR`; with this macro it splits the data into several records instead. It does not affect checks on received records.

#### WOLFSSL_NO_ETM_ALERT

When [`WOLFSSL_EXTRA_ALERTS`](#wolfssl_extra_alerts) is defined, suppresses the fatal `bad_record_mac` or `record_overflow` alert that is sent when an Encrypt-Then-MAC record fails MAC verification or is too long. The connection still fails (with `DECRYPT_ERROR` or `BUFFER_ERROR`); there is no fallback to MAC-then-encrypt.

#### WOLFSSL_NO_SOCK

Portability macro for disabling built-in socket support. If using TLS without sockets typically `WOLFSSL_USER_IO` would be defined and callbacks used for send/recv.

#### WOLFSSL_NO_STRICT_CIPHER_SUITE

On a TLS 1.2 (or older) client, skips the check that the cipher suite chosen in the ServerHello is one that was offered in the ClientHello and, with secure renegotiation, that it did not change during renegotiation. Not recommended: it weakens protection against a misbehaving or malicious server.

#### WOLFSSL_NO_TICKET_EXPIRE

Disables session ticket expiration checking. Session tickets will be accepted regardless of their age.

#### WOLFSSL_NO_TLS12

Define to exclude TLS 1.2. The TLS 1.2 code is compiled out, so peers can no longer negotiate it. wolfSSL 5.9.4 and later set this macro when [`--disable-tlsv12`](#--disable-tlsv12) is given.

#### WOLFSSL_NO_SIGALG

Disables the signature algorithms extension.

#### NO_RESUME_SUITE_CHECK

Disables the check that a resumed session uses the same cipher suite.

#### NO_ASN

Removes support for ASN formatted certificate processing.

#### NO_CODING

Removes Base64 and Base16 encoding and decoding (`--disable-coding`). This also removes PEM support, because [`WOLFSSL_PEM_TO_DER`](#wolfssl_pem_to_der) is not defined without it.

#### NO_CERTS

Disables all certificate processing in wolfSSL. Use for PSK-only configurations where no certificate handling is needed, significantly reducing code size.

#### WOLFSSL_NO_PEM

Removes PEM support: [`WOLFSSL_PEM_TO_DER`](#wolfssl_pem_to_der) is not defined, so the PEM to DER conversion functions are not built and certificates and keys can only be loaded in DER format (`WOLFSSL_FILETYPE_ASN1`). There is no configure option for it; define it in user_settings.h or in `CFLAGS`.

#### NO_SIG_WRAPPER

Removes the signature wrapper API in `wolfcrypt/src/signature.c` (`wc_SignatureGetSize()`, `wc_SignatureGenerate()`, `wc_SignatureVerify()` and their `Hash` and `_ex` variants). Defined automatically when RSA is disabled and ECC signing and verification are not available, by [`--enable-rsavfy`](#--enable-rsavfy), and by the `WOLFSSL_TINY_TLS13` profile.

#### NO_OLD_TLS

Removes support for SSLv3, TLSv1.0 and TLSv1.1. `./configure` and CMake define this macro by default; it is only left undefined when old TLS support is explicitly requested (for example with [`--enable-oldtls`](#--enable-oldtls), `--enable-tlsv10` or `--enable-sslv3`). With user_settings.h it is not defined automatically, so define `NO_OLD_TLS` yourself. In a build without `NO_OLD_TLS`, TLS 1.0 and SSL 3.0 additionally need `WOLFSSL_ALLOW_TLSV10` and `WOLFSSL_ALLOW_SSLV3`.

**Warning:** Leaving `NO_OLD_TLS` undefined produces a build that is **not conformant** with RFC 9846, RFC 8996 or RFC 9325. RFC 8996 deprecates TLS 1.0 and TLS 1.1, and RFC 9846 states that SSL 2.0, SSL 3.0, TLS 1.0 and TLS 1.1 "MUST NOT be negotiated for any reason". Only build without `NO_OLD_TLS` when legacy interoperability requires it, and do not claim conformance with those RFCs for such a build.

#### WOLFSSL_AEAD_ONLY

Removes the non-AEAD TLS cipher suites (CBC and stream ciphers with HMAC, including Encrypt-Then-MAC); the algorithms themselves stay in wolfCrypt. AEAD stands for "authenticated encryption with associated data" which means these algorithms (such as AES-GCM) do not just encrypt and decrypt data, they also assure the integrity and authenticity of that data.

#### WOLFSSL_SP_NO_2048

Removes RSA/DH 2048-bit Single-Precision (SP) optimization.

#### WOLFSSL_SP_NO_3072

Removes RSA/DH 3072-bit Single-Precision (SP) optimization.

#### WOLFSSL_SP_NO_256

Removes the SP P-256 (SECP256R1) implementation when `WOLFSSL_HAVE_SP_ECC` is used. With `WOLFSSL_SP_MATH` (SP-only math), it also removes P-256 from the curve table (`NO_ECC256`).

### Symmetric Cipher, Hash and KDF Options

The following defines enable optional or legacy symmetric cipher, hash and key derivation features.

#### WOLFSSL_DES_ECB

Enables DES-ECB (Electronic Codebook) mode. Off by default. Used by some legacy protocols.

#### HAVE_HKDF

Enables HKDF (HMAC-based Extract-and-Expand Key Derivation Function) per RFC 5869. Used for TLS 1.3 key derivation and general-purpose key derivation from shared secrets.

#### WOLFSSL_HMAC_COPY_HASH

Copies the hash state instead of re-initializing for each HMAC operation. Improves performance when the same key is used for multiple HMAC computations.

#### HAVE_X963_KDF

Enables ANSI X9.63 Key Derivation Function. Used for ECC-based key agreement in PKCS#7 EnvelopedData.

#### WC_RC2

Enables RC2 cipher support. Primarily needed for legacy PKCS#12 file compatibility.

#### WOLFSSL_MD2

Enables MD2 hash algorithm support. Only needed for legacy certificate compatibility. Not recommended for new applications.

### RSA Options

The following defines enable or adjust optional RSA behavior.

#### WC_RSA_DIRECT

Enables the direct RSA encrypt/decrypt API (`wc_RsaDirect`). Provides raw RSA operations without padding, useful for custom protocols.

#### WC_RSA_NO_PADDING

Enables the no-padding RSA mode. Allows RSA operations without any padding scheme applied. Use with caution - typically only for custom implementations.

#### WOLFSSL_RSA_KEY_CHECK

Enables RSA key pair consistency checking via `wc_CheckRsaKey()`. Validates that the public and private key components are mathematically consistent.

#### WOLFSSL_RSA_CHECK_D_ON_DECRYPT

Validates the RSA private exponent `d` before each decrypt operation. Provides additional security against fault injection attacks at the cost of performance.

#### WOLFSSL_RSA_DECRYPT_TO_0_LEN

Allows RSA decrypt operations to return a zero-length result (empty plaintext). By default, a zero-length decryption result is treated as an error.

#### SHOW_GEN

Enables progress indicator (dots) during RSA key generation. Useful for user feedback during long key generation operations.

#### WOLFSSL_PSS_LONG_SALT

Allows RSA-PSS signatures to use a salt length longer than the hash output length. Some implementations use salt length equal to the key size minus overhead.

#### WOLFSSL_PSS_SALT_LEN_DISCOVER

Adds `RSA_PSS_SALT_LEN_DISCOVER` as a salt length value for RSA-PSS verification. When it is passed, the verifier recovers the salt length from the decoded PSS padding (the position of the 0x01 separator) instead of requiring the caller to supply it.

#### WC_RSA_NONBLOCK_TIME

Enables time-based non-blocking RSA operations. Allows RSA operations to yield after a configurable time period. Requires [`WC_RSA_NONBLOCK`](#wc_rsa_nonblock).

#### WOLFSSL_MP_INVMOD_CONSTANT_TIME

Declares that the math library's `mp_invmod()` is constant time, so wolfCrypt calls it directly instead of using a side-channel-safe workaround: in RSA key generation `u = q^-1 mod p` is computed with `mp_invmod()` instead of as `q^(p-2) mod p`, and DSA signing skips the extra blinding of the inverse. Only define it when the `mp_invmod()` of the math backend really is constant time.

#### FP_MAX_BITS

Sets the maximum key size in bits when using fast math (`USE_FAST_MATH`). The value should be set to key size times 2. For example, for RSA 3072 set to 6144. Default is 4096 (supporting up to RSA 2048).

### Hardware and Asynchronous Crypto Options

The following defines enable hardware acceleration or asynchronous operation for specific algorithms.

#### WC_ASYNC_ENABLE_3DES

Enables asynchronous 3DES operations via the wolfSSL async crypto framework.

#### FREESCALE_LTC_DES

Enables Freescale/NXP LTC hardware DES/3DES acceleration.

#### STM32_HMAC

Enables STM32 hardware HMAC acceleration using the STM32 HASH peripheral.

#### WC_ASYNC_ENABLE_HMAC

Enables asynchronous HMAC operations via the wolfSSL async crypto framework.

#### WOLFSSL_DEVCRYPTO_HMAC

Enables HMAC acceleration via the Linux `/dev/crypto` interface.

#### WOLFSSL_KCAPI_HMAC

Enables HMAC operations through the Linux kernel crypto API (AF_ALG).

#### HAVE_MD5_CUST_API

Internal flag set by `wolfcrypt/src/md5.c` when a hardware port (STM32 HASH, PIC32MZ, i.MX6 CAAM) supplies its own `wc_InitMd5_ex()`, `wc_Md5Update()` and `wc_Md5Final()`. If you define it yourself, the software MD5 API is omitted and the application must provide these functions.

#### WC_ASYNC_ENABLE_MD5

Enables asynchronous MD5 operations via the wolfSSL async crypto framework.

#### WC_ASYNC_ENABLE_RSA

Enables asynchronous RSA operations via the wolfSSL async crypto framework. Allows RSA operations to be offloaded to hardware accelerators.

#### WOLFSSL_KCAPI_RSA

Enables RSA operations through the Linux kernel crypto API (AF_ALG). Offloads RSA to the kernel's crypto subsystem.

#### WOLFSSL_AFALG_XILINX_RSA

Enables RSA acceleration through AF_ALG on Xilinx platforms using Xilinx crypto hardware.

#### WOLFSSL_XILINX_CRYPT

Enables Xilinx hardware crypto acceleration for RSA and other algorithms on Xilinx FPGA/SoC platforms.

### PKCS#7, PKCS#8 and PKCS#12 Options

The following defines enable or adjust PKCS#7 (CMS), S/MIME, PKCS#8 and PKCS#12 support.

#### HAVE_PKCS7

Enables PKCS#7 (Cryptographic Message Syntax) support for signed data, enveloped data, encrypted data, and compressed data content types.

#### WOLFSSL_PKCS7_MAX_DECOMPRESSION

Sets the maximum decompression ratio for PKCS#7 CompressedData: the decompressed output may be at most this many times the size of the compressed input. The default is 1031 (the maximum compression factor of zlib). Prevents memory exhaustion from maliciously crafted compressed data.

#### HAVE_PKCS7_RSA_RAW_SIGN_CALLBACK

Enables a custom callback for raw RSA signing in PKCS#7. Allows HSM or external signing integration.

#### HAVE_PKCS7_ECC_RAW_SIGN_CALLBACK

Enables a custom callback for raw ECC signing in PKCS#7. Allows HSM or external signing integration.

#### HAVE_SMIME

Enables S/MIME (Secure/Multipurpose Internet Mail Extensions) support for email signing and encryption.

#### HAVE_PKCS8

Enables PKCS#8 private key format support for importing and exporting encrypted and unencrypted private keys. On by default: it is defined automatically unless [`NO_PKCS8`](#no_pkcs8) is defined, and always when `HAVE_PKCS12` is defined.

#### HAVE_PKCS12

Enables PKCS#12 (PFX) format support for bundling private keys, certificates, and CA chains into a single encrypted file. On by default: it is defined automatically unless [`NO_PKCS12`](#no_pkcs12) is defined.

### Certificate and ASN.1 Options

The following defines enable or relax optional certificate generation, parsing and validation features.

#### WOLFSSL_CERT_PIV

Enables PIV (Personal Identity Verification) certificate support for government smart card applications.

#### WOLFSSL_CERT_GEN_CACHE

Keeps the certificate decoded by `wc_SetIssuerBuffer()`, `wc_SetSubjectBuffer()`, `wc_SetAltNamesBuffer()`, `wc_SetDatesBuffer()` and similar functions cached in the `Cert` structure between calls, instead of decoding it again each time. The application must then free it with `wc_SetCert_Free()`, which becomes a public API.

#### WOLFSSL_CERT_SIGN_CB

Enables a callback function for certificate signing, allowing external signing operations (e.g., HSM).

#### WOLFSSL_CERT_NAME_ALL

Stores all certificate name components including initials, given name, and DN qualifier. Uses more memory but provides full name access.

#### WOLFSSL_MULTI_ATTRIB

Enables multi-valued Relative Distinguished Name (RDN) attributes in certificates.

#### WOLFSSL_PEM_TO_DER

Enables the PEM to DER conversion functions (`wc_PemToDer()`, `wc_KeyPemToDer()`, `wc_CertPemToDer()`, `wc_PemPubKeyToDer()` and others) and the loading of PEM format certificates and keys. Defined by default unless [`WOLFSSL_NO_PEM`](#wolfssl_no_pem) or [`NO_CODING`](#no_coding) is defined.

#### WOLFSSL_DER_TO_PEM

Enables DER to PEM format conversion functions.

#### WOLFSSL_PUB_PEM_TO_DER

Enables public key PEM to DER format conversion.

#### WOLFSSL_KEY_TO_DER

Enables `wc_RsaKeyToDer()` (RSA private key to DER) and the RSA public key DER encoding used by `wc_RsaKeyToPublicDer()`. Defined automatically when RSA is enabled together with `WOLFSSL_KEY_GEN`, `WOLFSSL_CERT_GEN`, `OPENSSL_EXTRA`, `WOLFSSL_KCAPI_RSA` or `WOLFSSL_SE050` (in FIPS and self-test builds only with `WOLFSSL_KEY_GEN`). ECC keys use `wc_EccKeyToDer()`, which does not depend on this macro.

#### ASN_BER_TO_DER

Enables BER (Basic Encoding Rules) to DER (Distinguished Encoding Rules) conversion. Required for parsing BER-encoded certificates and CMS/PKCS#7 data.

#### WOLFSSL_DUP_CERTPOL

Allows duplicate certificate policy OIDs in the certificate policies extension. By default, duplicates cause a validation error.

#### ALLOW_SELFSIGNED_INVALID_CERTSIGN

Allows a self-issued certificate that is not a CA (no cA basic constraint) to assert keyCertSign in its Key Usage extension. By default this violates RFC 5280 section 4.2.1.9 and is rejected with `KEYUSAGE_E`. This is a narrower opt-in than `ALLOW_INVALID_CERTSIGN`, which accepts such certificates whether or not they are self-issued.

#### ALLOW_V1_EXTENSIONS

Allows X.509 v1 certificates to contain extensions. Per RFC 5280, extensions are only valid in v3 certificates.

#### USE_WOLF_VALIDDATE

Uses wolfSSL's own date validation implementation instead of the platform's.

#### USE_WOLF_TM

Uses wolfSSL's own `struct tm` definition instead of the system-provided one. Needed on platforms without a standard `struct tm`.

#### WC_ASN_RUNTIME_DATE_CHECK_CONTROL

Enables runtime control of certificate date checking. Allows enabling or disabling date validation at runtime via API.

#### WOLFSSL_AFTER_DATE_CLOCK_SKEW

Sets the clock skew tolerance (in seconds) for certificate not-after date checking. Allows certificates to be valid slightly past their expiration.

#### WOLFSSL_BEFORE_DATE_CLOCK_SKEW

Sets the clock skew tolerance (in seconds) for certificate not-before date checking. Allows certificates to be accepted slightly before their validity period.

#### WOLFSSL_ALT_NAMES

Enables Subject Alternative Name (SAN) support in certificate generation and parsing.

#### WOLFSSL_ALT_NAMES_NO_REV

Stores Subject Alternative Names without reversing the order. By default, SANs are stored in reverse order.

#### WOLFSSL_IP_ALT_NAME

Generates a human-readable string form (`ipString`) of iPAddress Subject Alternative Name entries. It is needed to match an IP address against the iPAddress SAN entries during peer certificate verification, and is used by the compatibility layer and printing functions. The raw iPAddress entries are parsed (for example for name constraint checks) without this macro.

#### WOLFSSL_RID_ALT_NAME

Generates a human-readable string form (`ridString`) of registeredID Subject Alternative Name entries, used by the compatibility layer and printing functions. The raw registeredID entries are parsed without this macro.

#### WOLFSSL_EKU_OID

Enables Extended Key Usage OID support for additional OIDs beyond the standard set.

#### WOLFSSL_ACERT

Enables X.509 attribute certificate support (RFC 5755).

#### IGNORE_KEY_EXTENSIONS

Ignores key usage and extended key usage extensions during certificate validation.

#### WOLFSSL_ALLOW_CRIT_AIA

Allows the Authority Information Access (AIA) extension to be marked as critical. By default, a critical AIA causes a validation error.

#### WOLFSSL_ALLOW_CRIT_AKID

Allows the Authority Key Identifier extension to be marked as critical.

#### WOLFSSL_ALLOW_CRIT_SKID

Allows the Subject Key Identifier extension to be marked as critical.

#### WOLFSSL_ALLOW_NO_CN_IN_SAN

Restores the old hostname check: the subject CN is matched first, and the Subject Alternative Name (SAN) entries are tried only if that fails, even when the certificate has a SAN extension. By default, when a certificate has a SAN extension only the SAN entries are checked (RFC 5280 section 4.2.1.6) and the CN is ignored.

#### WC_ASN_UNKNOWN_EXT_CB

Enables a callback for handling unknown certificate extensions. The callback receives the OID and extension data for custom processing.

#### WOLFSSL_ASN_ALL

Enables all optional ASN.1 features at once.

#### WOLFSSL_ASN_CA_ISSUER

Enables parsing of the CA Issuer field in the Authority Information Access extension.

#### WOLFSSL_ASN_PRINT

Enables ASN.1 structure printing functions for debugging and inspection of DER-encoded data.

#### WOLFSSL_ASN_INT_LEAD_0_ANY

Allows any leading zero byte in ASN.1 INTEGER encoding. By default, only minimal encoding is accepted.

#### WOLFSSL_ASN_PARSE_KEYUSAGE

Enables parsing of the Key Usage extension during certificate processing.

#### WOLFSSL_ASN_TIME_STRING

Enables conversion of ASN.1 time values to human-readable string format.

#### ASN_TEMPLATE_SKIP_ISCA_CHECK

Skips the isCA check in ASN.1 template-based certificate parsing.

#### HAVE_OID_ENCODING

Enables OID (Object Identifier) encoding support for generating ASN.1 OIDs from dotted-decimal notation.

#### WOLFSSL_OLD_OID_SUM

Uses the old OID sum calculation method. For backwards compatibility with applications that depend on specific OID sum values.

#### WC_ENABLE_ASYM_KEY_IMPORT

Enables the generic RFC 5958 asymmetric key package import helpers. Defined automatically when any of Ed25519, Curve25519, Ed448 or Curve448 (with key import), Falcon, ML-DSA, ML-KEM, FrodoKEM, SLH-DSA, LMS or XMSS is enabled (LMS and XMSS only when not verify-only), so there is normally no need to define it manually.

#### WC_ENABLE_ASYM_KEY_EXPORT

Enables the generic RFC 5958 asymmetric key package export helpers. Defined automatically when any of Ed25519, Curve25519, Ed448 or Curve448 (with key export), Falcon, ML-DSA, ML-KEM, FrodoKEM, SLH-DSA, LMS or XMSS is enabled (LMS and XMSS only when not verify-only), so there is normally no need to define it manually.

#### WOLFSSL_X509_NAME_AVAILABLE

Internal flag used only inside `wolfcrypt/src/asn.c`; it makes the certificate parser also build the `WOLFSSL_X509_NAME` subject and issuer objects used by the compatibility layer. It is defined automatically when `OPENSSL_EXTRA` or `OPENSSL_EXTRA_X509_SMALL` is set without `WOLFCRYPT_ONLY`, so do not define it yourself; enable the X509_NAME API with [`OPENSSL_EXTRA`](#openssl_extra) instead.

#### WOLFSSL_HAVE_ISSUER_NAMES

Stores pointers to issuer name components, their lengths and encodings for efficient access.

#### WOLFSSL_VERIFY_CB_ALL_CERTS

Calls the certificate verify callback for all certificates in the chain, not just the peer certificate.

#### WOLFSSL_LOCAL_X509_STORE

Uses a local X509 certificate store per SSL context instead of a global one. Provides better isolation between contexts.

#### WOLFSSL_COPY_CERT

Copies the certificate buffer when loading into an SSL object instead of referencing it, ensuring the SSL object owns its own copy of the data.

#### WOLFSSL_COPY_KEY

Copies the private key buffer when loading into an SSL object instead of referencing it, ensuring the SSL object owns its own copy of the data.

### OCSP Options

The following options adjust OCSP support.

#### HAVE_OCSP_RESPONDER

Enables OCSP responder functionality. Allows wolfSSL to act as an OCSP responder that signs and sends OCSP responses.

#### WOLFSSL_OCSP_PARSE_STATUS

Enables parsing of OCSP response status fields for detailed status information.

#### WOLFSSL_OCSP_SCREEN_RESPONDER

An OCSP hardening option. Responder hosts taken from the Authority Information Access extension are refused when they resolve to internal address ranges (loopback, link-local or private networks), so an attacker supplied certificate cannot steer OCSP checks at your own services (server-side request forgery, CWE-918).

#### WOLFSSL_OCSP_FAIL_IF_NOT_SUPPORTED

A runtime OCSP hardening option, not a build macro. Pass it in the options argument of `wolfSSL_CTX_EnableOCSP()`, `wolfSSL_EnableOCSP()`, or `wolfSSL_CertManagerEnableOCSP()`. With it set, a certificate that advertises no OCSP responder is refused with `OCSP_NEED_URL` instead of the default soft-fail behavior. Without this option, a missing responder only gives the `OCSP_NO_URL` result, and any CRL check that is enabled still runs.

### Post-Quantum Options

The following defines control optional post-quantum algorithm features.

#### WOLFSSL_MLDSA_FIPS204_DRAFT

Adds the FIPS 204 draft versions of the ML-DSA parameter sets (for example `WC_ML_DSA_44_DRAFT`) in addition to the final FIPS 204 ones, and enables the no-context sign/verify API (`WOLFSSL_MLDSA_NO_CTX`) needed for draft-format signatures. Set by adding `draft` to `--enable-mldsa` (for example `--enable-mldsa=yes,draft`). The legacy name `WOLFSSL_DILITHIUM_FIPS204_DRAFT` is still accepted as an alias.

#### HAVE_SPHINCS

Obsolete. This macro enabled pre-standardization SPHINCS+ through the liboqs integration, which was removed in wolfSSL 5.9.2; defining it now does nothing. Use the native SLH-DSA (FIPS 205) implementation instead, see [`WOLFSSL_HAVE_SLHDSA`](#wolfssl_have_slhdsa).

#### WOLFSSL_HAVE_SLHDSA

Turns on the SLH-DSA stateless hash-based signature scheme (FIPS 205, the standardized form of SPHINCS+) in wolfCrypt. By default only the six SHAKE parameter sets (levels 128, 192 and 256, in small and fast variants) are built. The six SHA2 parameter sets also need `WOLFSSL_SLHDSA_SHA2`: `--enable-slhdsa=yes,sha2` builds all twelve, and options such as `sha2-128s` select individual sets. The configure flag is [`--enable-slhdsa`](#--enable-slhdsa). If TLS 1.3 or DTLS 1.3 is enabled, the draft-reddy-tls-slhdsa signature schemes can sign the handshake; the code points are in the signature algorithm reference of [Appendix G](appendix07.md#c-9-slh-dsa-fips-205). `WOLFSSL_SLHDSA_VERIFY_ONLY` (from `--enable-slhdsa=verify-only`) keeps verification only, and `WOLF_CRYPTO_CB_ONLY_SLHDSA` removes the software implementation for setups that offload the algorithm to a crypto callback device.

#### WOLFSSL_HAVE_FRODOKEM

Enables the FrodoKEM key encapsulation mechanism in wolfCrypt. It is experimental and needs `--enable-experimental`. The implementation includes fast, small and small-stack C code, assembly for x86_64, AArch64, AArch32 and Thumb2, plus ASN.1 keys and X.509 certificates. Enable it with [`--enable-frodokem`](#--enable-frodokem).

### TLS Options

The following defines enable or adjust optional TLS behavior.

#### WOLFSSL_ALTERNATIVE_DOWNGRADE

On a client that allows a version downgrade (for example with `wolfSSLv23_client_method()`), sets the record layer version of the initial ClientHello to the minimum allowed downgrade version instead of the highest supported version. Useful with servers that reject records with a newer version.

#### WOLFSSL_ALLOW_MAX_FRAGMENT_ADJUST

Allows runtime adjustment of the maximum fragment size after the initial TLS negotiation has completed.

#### WOLFSSL_ALLOW_NO_SUITES

Allows creation of SSL/CTX objects even when no cipher suites are available. Normally an error is raised if no suites match the build configuration.

#### WOLFSSL_DTLS13_SEND_MOREACK_DEFAULT

Sets the default for whether DTLS 1.3 sends ACKs to the peer immediately when it detects a disruption during the handshake: 0 (the default) or 1. Sending ACKs immediately gives minimum latency but may use more bandwidth than necessary. The macro takes a value, for example `#define WOLFSSL_DTLS13_SEND_MOREACK_DEFAULT 1`; defining it without a value does not compile. The setting can be changed per connection with [`wolfSSL_dtls13_set_send_more_acks()`](group__Setup.md#function-wolfssl_dtls13_set_send_more_acks).

#### WOLFSSL_BLIND_PRIVATE_KEY

Stores the private key held by a `WOLFSSL_CTX` or `WOLFSSL` object XOR'd with a random mask and unmasks it only while it is being used, to protect it against memory attacks such as Rowhammer.

#### WOLFSSL_JNI

Enables APIs and behaviors needed for Java JNI (wolfSSL JNI/JSSE) compatibility.

#### WOLFSSL_OPENVPN

Enables OpenVPN compatibility behaviors in wolfSSL. Required when using wolfSSL as the TLS provider for OpenVPN.

### Debugging Options

The following defines enable extra debugging output or checks for development and testing.

#### WC_PKCS7_STREAM_DEBUG

Enables debug output for PKCS#7 streaming operations.

#### WOLFSSL_DEBUG_ASN_TEMPLATE

Enables debugging output when using ASN.1 templates. Only relevant when used with `WOLFSSL_ASN_TEMPLATE`.

#### WOLFSSL_DEBUG_CERTS

Enables debug logging for certificate processing operations including parsing, validation, and chain building. It is turned on automatically with [`DEBUG_WOLFSSL`](#debug_wolfssl) unless `WOLFSSL_NO_DEBUG_CERTS` is defined. When it is defined without `DEBUG_WOLFSSL`, the certificate messages are off at run time until `wolfSSL_CertDebugging_ON()` is called, or `WOLFSSL_CERT_LOG_ENABLED_DEFAULT` is defined to 1.

#### WOLFSSL_ASN_TEMPLATE_TYPE_CHECK

Use ASN functions to better test compiler type issues for testing. Only relevant when used with `WOLFSSL_ASN_TEMPLATE`.

#### WOLFSSL_DEBUG_DTLS

Debugging aid for DTLS: stops wolfSSL from forcing the ChangeCipherSpec message into the same datagram as the Finished message, so the records can be observed separately. It adds no logging.

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

Required if using Chacha20/Poly1305 with TLS v1.2 for setting up Poly authentication. It is defined automatically whenever `HAVE_POLY1305` is defined, in both `./configure` and user_settings.h builds.

#### WOLFSSL_ASN_TEMPLATE

Enables the new version of ASN parsing code that uses template-based ASN.1 processing. This parsing adheres to standard ASN.1 rules and uses a template structure to dictate encoding and decoding, allowing the parser code to generalize across templates. This is the default for every build, including user_settings.h builds, unless `WOLFSSL_ASN_ORIGINAL` (`--enable-asn=original`) or `NO_ASN` is defined.

### Enabling Features Disabled by Default

**NOTE**: Some of the macros in this section are turned on by default in `./configure` builds, or are always defined by `wolfssl/wolfcrypt/settings.h` unless explicitly disabled. Where that is the case, the entry states the default and how to turn the feature off. With `WOLFSSL_USER_SETTINGS`, configure defaults do not apply, so macros that configure sets must be defined manually.

#### WOLFSSL_CERT_GEN

Turns on wolfSSL's certificate generation functionality. See [Keys and Certificates](chapter07.md#keys-and-certificates) for more information.

#### WOLFSSL_DER_LOAD

Allows loading DER-formatted CA certs into the wolfSSL context (`WOLFSSL_CTX`) using the function [`wolfSSL_CTX_der_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_der_load_verify_locations).

#### WOLFSSL_DTLS

Turns on DTLS (datagram TLS) 1.2 support; DTLS 1.3 also needs [`WOLFSSL_DTLS13`](#wolfssl_dtls13). Enabled with `--enable-dtls`.

#### WOLFSSL_DTLS_CID

Enables DTLS Connection ID support (RFC 9146). Allows DTLS connections to survive IP address changes by identifying connections with a CID rather than the transport address.


#### WOLFSSL_DTLS_DROP_STATS

Enables tracking of DTLS packet drop statistics for monitoring and debugging DTLS connection quality.


#### WOLFSSL_DTLS_DISALLOW_FUTURE

Rejects DTLS records whose sequence number is more than the replay window size (`DTLS_SEQ_BITS`) ahead of the next expected sequence number. By default such records are accepted and the window slides forward.

#### WOLFSSL_ALLOW_TLSV10

Allows TLS 1.0 connections. TLS 1.0 is disabled by default for security reasons. Only enable when legacy compatibility is required. Requires that `NO_OLD_TLS` is not defined; `--enable-tlsv10` arranges this by turning old TLS on.

**Warning:** Defining `WOLFSSL_ALLOW_TLSV10` produces a build that is **not conformant** with RFC 9846, RFC 8996 or RFC 9325. TLS 1.0 is deprecated by RFC 8996, and RFC 9846 states it "MUST NOT be negotiated for any reason".

#### WOLFSSL_ALLOW_SSLV3

Allows SSL 3.0 connections. SSL 3.0 is disabled by default for security reasons. Only enable when legacy compatibility is required. Requires that `NO_OLD_TLS` is not defined; `--enable-sslv3` arranges this by turning old TLS on.

**Warning:** Building with `--enable-sslv3` violates RFC 7568 and produces a build that is **not conformant** with RFC 9846, RFC 8996 or RFC 9325. RFC 7568 deprecates SSL 3.0 and states "SSLv3 MUST NOT be used."


#### WOLFSSL_ALLOW_TLS_SHA1

Lets SHA-1 signature algorithms (for example rsa_pkcs1_sha1 and ecdsa_sha1) be offered and used in TLS 1.2 and later handshakes. By default they are only offered for TLS 1.0 and 1.1, because RFC 9155 deprecates them for TLS 1.2. Cipher suites are not affected.

#### WOLFSSL_EITHER_SIDE

Allows the same `WOLFSSL_CTX` to be used for both client and server connections. By default, a context is configured for either client or server at creation time.


#### WOLFSSL_EGD_NBLOCK

Enables non-blocking EGD (Entropy Gathering Daemon) support for random number generation on systems using EGD.

#### HAVE_SNI

Enables Server Name Indication (SNI) TLS extension support (RFC 6066). Allows clients to indicate which hostname they are connecting to, enabling virtual hosting over TLS. Enabled by default in `./configure` builds on x86, x86_64 and aarch64; disable with `--disable-sni`.

#### WOLFSSL_ALWAYS_KEEP_SNI

On the server, stores the SNI host name the client sent even when the server has not set one with `wolfSSL_UseSNI()`, so the application can read it with `wolfSSL_SNI_GetRequest()` (status `WOLFSSL_SNI_FORCE_KEEP`). The same thing happens when an SNI receive callback is registered.


#### WOLFSSL_ALWAYS_VERIFY_CB

Always invokes the certificate verify callback, even when verification succeeds. By default the callback is only called on failure.

#### HAVE_TRUNCATED_HMAC

Enables the Truncated HMAC TLS extension (RFC 6066). Allows using 80-bit HMAC tags instead of the full size to reduce bandwidth.


#### HAVE_TIME_T_TYPE

Define when using `USER_TIME`, `TIME_OVERRIDES` or a similar custom time port on a platform that already has a `time_t` type. Without it wolfSSL supplies its own `time_t` (`USE_WOLF_TIME_T`, `typedef long time_t`) in those configurations. Neither configure nor CMake sets it.

#### HAVE_SECURE_RENEGOTIATION

Enables secure renegotiation support (RFC 5746). Allows TLS connections to renegotiate cipher suites and keys during an active session.

#### HAVE_SERVER_RENEGOTIATION_INFO

Enables the server-side renegotiation info extension. Indicates secure renegotiation support in server hello messages. Enabled by default in `./configure` builds; disable with `--disable-secure-renegotiation-info`.

#### HAVE_SESSION_TICKET

Enables TLS session ticket support (RFC 5077). Allows the server to issue session tickets for faster resumption without server-side session state. Required for TLS 1.3 resumption.

#### HAVE_TRUSTED_CA

Enables the Trusted CA Indication TLS extension (RFC 6066). Allows the client to indicate which CA certificates it trusts, helping the server select the appropriate certificate chain.

#### HAVE_RPK

Enables Raw Public Key support (RFC 7250). Allows using raw public keys instead of X.509 certificates in TLS, reducing handshake overhead for constrained environments.

#### HAVE_ECH

Enables Encrypted Client Hello (ECH) support. Encrypts the ClientHello to protect sensitive fields like SNI from passive observers.

#### WOLFSSL_NO_CA_NAMES

Disables sending CA names in the CertificateRequest message. Reduces handshake message size when the server has many trusted CAs.

#### WOLFSSL_NO_SERVER_GROUPS_EXT

Prevents the server from sending its supported groups in a TLS extension when the server's top preference is not in the client's list.

#### HAVE_FFDHE

Enables Finite Field Diffie-Hellman Ephemeral (FFDHE) key exchange using standardized groups from RFC 7919. You do not normally define this macro yourself: settings.h defines it automatically when DH is enabled and any of the group size macros below is defined.

#### HAVE_FFDHE_2048, HAVE_FFDHE_3072, HAVE_FFDHE_4096, HAVE_FFDHE_6144, HAVE_FFDHE_8192

Each macro enables one RFC 7919 FFDHE group (ffdhe2048 to ffdhe8192) and, through it, [`HAVE_FFDHE`](#have_ffdhe). `./configure` defines `HAVE_FFDHE_2048` by default when DH is enabled together with TLS 1.3 or the supported curves extension; disable it with `--disable-dh`. The other group sizes are off by default.

#### HAVE_SECRET_CALLBACK

Enables the TLS secret callback, allowing applications to receive TLS key material during the handshake. Used for key logging, debugging, and integration with external tools.

#### HAVE_PK_CALLBACKS

Enables public key operation callbacks, allowing applications to override the default RSA, ECC, and DH operations with custom implementations (e.g., HSM or secure element integration).

#### WOLFSSL_SNIFFER

Enables TLS packet sniffing support. Allows decrypting and inspecting TLS traffic using the wolfSSL sniffer library with the private key.

#### HAVE_WEBSERVER

Enables the small subset of the OpenSSL compatibility layer that embedded web servers need (for example the `wolfSSL_CTX_ctrl()` options, the locking callback functions and the X.509 verify error codes), and turns on [`WOLFSSL_ENCRYPTED_KEYS`](#wolfssl_encrypted_keys). Set by `--enable-webserver`.

#### HAVE_WOLF_EVENT

Enables wolf event-driven processing support for async operations. Provides an event queue for managing pending async crypto operations.

#### HAVE_WRITE_DUP

Enables `wolfSSL_write_dup()`, which makes a second, write-only `WOLFSSL` object from an established connection, so one thread can read on the original while another writes on the duplicate. Set by `--enable-writedup`.

#### WOLFSSL_HAVE_PRF

Enables access to the TLS Pseudo-Random Function (PRF). Allows applications to derive additional keying material using the TLS PRF. Exposes `wc_PRF()`, `wc_PRF_TLS()` and `wc_PRF_TLSv1()`. Defined automatically by settings.h unless `NO_KDF` or `NO_HMAC` is set.

#### WOLFSSL_REQUIRE_TCA

Client side: when the client sent the trusted_ca_keys extension and the server does not acknowledge it, fail the handshake with `TCA_ABSENT_ERROR`. RFC 6066 makes the server response optional, so by default the client continues.

#### WOLFSSL_DH_EXTRA

Adds the public and private key values to the wolfCrypt `DhKey` structure and enables `wc_DhImportKeyPair()`, `wc_DhExportKeyPair()` and DH key copy, which the OpenSSL compatibility DH APIs use. Defined automatically with `WOLFSSL_QT`, `OPENSSL_ALL`, `WOLFSSL_OPENSSH` or `WOLFSSL_STATIC_EPHEMERAL`.

#### WOLFSSL_CURVE25519_BLINDING

Enables scalar blinding of X25519 private key operations in wolfCrypt, to protect against timing side-channel attacks. It applies to all use of the key, not just TLS. An RNG must be set on the key with `wc_curve25519_set_rng()`. On by default for the C implementation (not `CURVE25519_SMALL` or assembly) when an RNG is available; turn it off with `NO_CURVE25519_BLINDING`.

#### WOLFSSL_KEY_GEN

Turns on wolfSSL's RSA key generation functionality. See [Keys and Certificates](chapter07.md#keys-and-certificates) for more information.

#### WOLF_PRIVATE_KEY_ID

This is used with PKCS11 to enable support for key ID and label API's. FIPS v5 and older doesn't support `WOLF_PRIVATE_KEY_ID` with Crypto Callbacks.

#### WOLFSSL_WOLFSENTRY_HOOKS

This switch adds support in the TLS layer for generic network `accept` and `connect` filter hooks, using `wolfSSL_CTX_set_AcceptFilter()` and `wolfSSL_CTX_set_ConnectFilter()`. It also activates wolfSentry integration in the example client and server applications.

#### WOLFSSL_CERT_EXT

Certificate extension, key and cert generation feature.

#### WOLFSSL_CERT_REQ

Certificate request, key, and cert generation feature.

#### WOLFSSL_SSLKEYLOGFILE

This enables the key logging used by Wireshark. It does produce a compiler warning since the master secret and client random are written to a file. This is useful for testing and not recommended for production. Enabled with `--enable-keylog-export`, which also sets `SHOW_SECRETS` and `HAVE_SECRET_CALLBACK`.

#### WOLFSSL_SSLKEYLOGFILE_OUTPUT

This macro defines the filename for the key logging. It is used with `WOLFSSL_SSLKEYLOGFILE`. The default is `sslkeylog.log`. Define `WOLFSSL_SSLKEYLOGFILE_USE_ENV` to prefer the path in the `SSLKEYLOGFILE` environment variable when it is set.

#### WOLFSSL_HAVE_WOLFSCEP

Enable feature used by autoconf to see if wolfSCEP is available.

#### WOLFSSL_HAVE_MIN

This macro is for portability of the library to indicate if MIN/MAX are already defined by the platform. It prevents duplicate definitions.

#### WOLFSSL_HAVE_TLS_UNIQUE

Keeps the "Finished" messages after a TLS handshake for use as the "tls-unique" channel binding. Added in libest port: allow applications to get the 'tls-unique' Channel Binding Type (https://tools.ietf.org/html/rfc5929#section-3). This is used in the EST protocol to bind an enrollment to a TLS session through 'proof-of-possession' (https://tools.ietf.org/html/rfc7030#section-3.4 and https://tools.ietf.org/html/rfc7030#section-3.5).

#### WOLFSSL_ENCRYPTED_KEYS

Enables loading and writing password-encrypted PEM private keys: traditional encrypted PEM (`Proc-Type` / `DEK-Info` headers), and encrypted PKCS#8 PEM through the password callback. The PKCS#8 encrypt/decrypt API itself (`wc_EncryptPKCS8Key()`) comes from [`HAVE_PKCS8`](#have_pkcs8). Set by [`--enable-enckeys`](#--enable-enckeys), and automatically with `OPENSSL_EXTRA`, `OPENSSL_EXTRA_X509_SMALL` or `HAVE_WEBSERVER`. Here is a link to RFC PKCS8 documentation (https://datatracker.ietf.org/doc/html/rfc5208).

#### WOLFSSL_CUSTOM_OID

Certificate feature that enables custom OID support for subject and request extensions. This also applies to parsing certificates with custom OID.

#### WOLFSSL_RIPEMD

Enables RIPEMD-160 support.

#### WOLFSSL_SHA224

Enables SHA-224 support. Enabled by default in `./configure` builds on x86_64 and aarch64; disable with `--disable-sha224`.

#### WOLFSSL_SHA384

Enables SHA-384 support. Enabled by default in `./configure` builds; disable with `--disable-sha384`.

#### WOLFSSL_SHA512

Enables SHA-512 support. Enabled by default in `./configure` builds; disable with `--disable-sha512`.

#### WOLFSSL_AES_DIRECT

Enables the single-block AES API `wc_AesEncryptDirect()` / `wc_AesDecryptDirect()` (the multi-block ECB API is [`HAVE_AES_ECB`](#have_aes_ecb)). On its own ECB mode is not considered secure. Needed by AES key wrap (and so PKCS#7), CMAC, CTR, CFB, OFB and XTS; settings.h turns it on automatically for CTR, CFB, OFB and XTS. Warning: In nearly all use cases ECB mode is considered to be less secure. Please avoid using ECB API's directly whenever possible.

#### DEBUG_WOLFSSL

Builds in the ability to debug. For more information regarding debugging wolfSSL, see [Debugging](chapter08.md#debugging).

#### HAVE_AESCCM

Enables AES-CCM support.

#### HAVE_AESGCM

Enables AES-GCM support. Enabled by default in `./configure` builds; disable with `--disable-aesgcm`.

#### WOLFSSL_AES_XTS

Enables AES-XTS support.

#### WOLFSSL_AES_128

Enables AES-128 key size support. Always defined by settings.h when AES is enabled; define [`NO_AES_128`](#no_aes_128) to remove AES-128 and reduce code size when only larger key sizes are needed.

#### WOLFSSL_AES_192

Enables AES-192 key size support. Always defined by settings.h when AES is enabled and `AES_MAX_KEY_SIZE` is at least 192; define [`NO_AES_192`](#no_aes_192) to remove AES-192 and reduce code size.

#### WOLFSSL_AES_256

Enables AES-256 key size support. Always defined by settings.h when AES is enabled and `AES_MAX_KEY_SIZE` is 256; define [`NO_AES_256`](#no_aes_256) to remove AES-256 when not needed.

#### AES_MAX_KEY_SIZE

Sets the maximum AES key size in bits. Defaults to 256. Can be set to 128 or 192 to reduce code and memory usage.

#### HAVE_AES_ECB

Enables AES-ECB (Electronic Codebook) mode. Off by default. ECB mode encrypts each block independently and is generally not recommended for most applications, but is needed by some protocols.

#### HAVE_AES_DECRYPT

Enables AES decryption support. Always defined by settings.h when AES is enabled; define [`NO_AES_DECRYPT`](#no_aes_decrypt) to save code size on platforms that only need AES encryption (e.g., GCM encryption-only).

#### WOLFSSL_AES_COUNTER

Enables AES-CTR (Counter) mode. Turns a block cipher into a stream cipher using an incrementing counter.

#### WOLFSSL_AES_CFB

Enables AES-CFB (Cipher Feedback) mode. Includes CFB-1, CFB-8, CFB-64, and CFB-128 sub-modes unless restricted by [`WOLFSSL_NO_AES_CFB_1_8`](#wolfssl_no_aes_cfb_1_8).

#### WOLFSSL_NO_AES_CFB_1_8

Disables AES-CFB-1 and AES-CFB-8 sub-modes when [`WOLFSSL_AES_CFB`](#wolfssl_aes_cfb) is enabled. Reduces code size when only CFB-64/128 are needed.

#### WOLFSSL_AES_OFB

Enables AES-OFB (Output Feedback) mode. OFB mode turns AES into a stream cipher and does not require padding.

#### WOLFSSL_AES_CTS

Enables AES-CTS (Ciphertext Stealing) mode. CTS allows encrypting data that is not a multiple of the block size without padding.

#### WOLFSSL_AES_SIV

Enables AES-SIV (Synthetic Initialization Vector) mode (RFC 5297). A nonce-misuse resistant AEAD mode that provides deterministic authenticated encryption.

#### WOLFSSL_AES_EAX

Enables AES-EAX AEAD mode. EAX is a two-pass AEAD scheme built from CTR mode and OMAC (CMAC), providing authenticated encryption with associated data.

#### HAVE_AES_KEYWRAP

Enables AES Key Wrap support (RFC 3394). Used for wrapping (encrypting) cryptographic keys for secure transport.

#### WOLFSSL_AES_CBC_LENGTH_CHECKS

Enables strict validation of input data length for AES-CBC operations. When enabled, CBC encrypt/decrypt will return an error if the input length is not a multiple of the AES block size.

#### HAVE_AESGCM_DECRYPT

Keeps AES-GCM decryption when AES block decryption is removed. Nothing defines this macro by default: GCM decryption is built whenever [`HAVE_AES_DECRYPT`](#have_aes_decrypt) or `HAVE_AESGCM_DECRYPT` is defined, so leaving it undefined does not remove GCM decryption. Define it together with [`NO_AES_DECRYPT`](#no_aes_decrypt) to keep AES-GCM decryption while removing the rest of AES decryption.

#### WOLFSSL_AESGCM_STREAM

Enables streaming AES-GCM API. Allows processing AES-GCM data incrementally rather than all at once, useful for large data or memory-constrained environments.

#### WC_AES_GCM_DEC_AUTH_EARLY

Authenticates the GCM tag before performing decryption. Provides fail-fast behavior when the authentication tag does not match, avoiding unnecessary decryption of invalid ciphertext.

#### GCM_TABLE

Use a pre-computed 8-bit (256-entry, 4 KB per key) lookup table for AES-GCM (GHASH) Galois field multiplication. Faster than [`GCM_SMALL`](#gcm_small) but uses more memory. Selected with `--enable-aesgcm=table`. See also [`GCM_TABLE_4BIT`](#gcm_table_4bit) and [`GCM_WORD32`](#gcm_word32).

#### GCM_TABLE_4BIT

Use a 4-bit (512 bytes per key) lookup table for AES-GCM (GHASH) Galois field multiplication. Smaller than [`GCM_TABLE`](#gcm_table). This is the default with `./configure` (`--enable-aesgcm` selects `4bit` unless told otherwise) and with `WOLFSSL_ARMASM`.

#### GCM_WORD32

Use a 32-bit word implementation for AES-GCM Galois field multiplication. An alternative to [`GCM_SMALL`](#gcm_small) and [`GCM_TABLE`](#gcm_table) that works well on platforms without 64-bit support.

#### WOLFSSL_AESXTS_STREAM

Enables streaming AES-XTS API. Allows processing AES-XTS data incrementally across multiple update calls rather than a single operation.

#### WC_AESXTS_STREAM_NO_REQUEST_ACCOUNTING

Disables request accounting in the streaming AES-XTS API. Removes overhead of tracking data unit boundaries when not needed.

#### WC_AES_XTS_SUPPORT_SIMULTANEOUS_ENC_AND_DEC_KEYS

Allows an AES-XTS context to hold both encryption and decryption keys simultaneously. By default, XTS contexts support only one direction at a time to save memory.

#### HAVE_CAMELLIA

Enables Camellia support.

#### HAVE_CHACHA

Enables ChaCha20 support. Enabled by default in `./configure` builds (except FIPS builds); disable with `--disable-chacha`.

#### HAVE_POLY1305

Enables Poly1305 support. Enabled by default in `./configure` builds (except FIPS builds); disable with `--disable-poly1305`.

#### POLY130564

Uses the 64-bit Poly1305 implementation for better performance on 64-bit platforms. Automatically selected on platforms with 64-bit support.

#### USE_INTEL_POLY1305_SPEEDUP

Enables Intel AVX/AVX2 optimized Poly1305 implementation for maximum throughput on Intel/AMD processors. Set automatically on x86_64 when [`USE_INTEL_SPEEDUP`](#use_intel_speedup) (`--enable-intelasm`) is defined, unless `NO_POLY1305_ASM` is defined. Includes AVX-512 code paths unless `WOLFSSL_POLY1305_NO_AVX512` is defined. Define `USE_INTEL_SPEEDUP` rather than this macro.

#### HAVE_CRL

Enables Certificate Revocation List (CRL) support.

#### HAVE_CRL_IO

Enables blocking inline HTTP request on the CRL URL. It will load the CRL into the `WOLFSSL_CTX` and apply it to all WOLFSSL objects created from it.

#### HAVE_ECC

Enables Elliptic Curve Cryptography (ECC) support. Enabled by default in `./configure` builds; disable with `--disable-ecc`.

#### HAVE_LIBZ

Is an extension that can allow for compression of data over the connection. It normally shouldn't be used, see the note below under configure notes libz.

#### OPENSSL_EXTRA

Builds even more OpenSSL compatibility into the library, and enables the wolfSSL OpenSSL compatibility layer to ease porting wolfSSL into existing applications which had been designed to work with OpenSSL. It is off by default.

#### HAVE_EXT_CACHE

Enables support for an external session cache (instead of the internal one).

#### WOLFSSL_WPAS_SMALL

Enables a smaller subset of the compatibility layer for WPA supplicant support.

#### OPENSSL_ALL

Enables support for all compatibility functions for testing integration.

#### OPENSSL_COEXIST

OpenSSL compat layer. Needs old names disabled. Mode to allow wolfSSL and OpenSSL to exist together.

#### OPENSSL_VERSION_NUMBER

Specifies the version number to implement OpenSSL compatibility.


#### OLD_HELLO_ALLOWED

Allows SSLv2-format ClientHello messages for backward compatibility with legacy clients that use the SSLv2 record format to negotiate higher protocol versions.

#### WOLFSSL_NGINX

OpenSSL compatibility application specific. Use, nginx `(--enable-nginx) WOLFSSL_NGINX`.

#### WOLFSSL_ERROR_CODE_OPENSSL

OpenSSL compatibility API wolfSSL_EVP_PKEY_cmp returns 0 on success and -1 on failure. This behavior is different from OpenSSL. EVP_PKEY_cmp returns:

- `1`: the two keys match
- `0`: the keys do not match
- `-1`: the key types are different
- `-2`: the operation is not supported

If you want this function to behave the same as openSSL, define WOLFSSL_ERROR_CODE_OPENSSL so that WS_RETURN_CODE translates return codes to match OpenSSL equivalent behavior.

#### WOLFSSL_HARDEN_TLS

Implement the recommendations specified in RFC9325. This macro needs to be defined to the desired number of bits of security. The currently implemented values are 112 and 128 bits. Enabled with `--enable-harden-tls[=112|128]` (`yes` is the same as `112`). The following macros disable certain checks.

- `WOLFSSL_HARDEN_TLS_ALLOW_TRUNCATED_HMAC`
- `WOLFSSL_HARDEN_TLS_ALLOW_OLD_TLS`
- `WOLFSSL_HARDEN_TLS_NO_SCR_CHECK`
- `WOLFSSL_HARDEN_TLS_NO_PKEY_CHECK`
- `WOLFSSL_HARDEN_TLS_ALLOW_ALL_CIPHERSUITES`

#### WOLFSSL_ASIO

OpenSSL compatibility specific macro.

#### WOLFSSL_QT

Enables the OpenSSL compatibility APIs and behaviors that the Qt framework needs (`--enable-qt`). It also turns on [`WOLFSSL_DH_EXTRA`](#wolfssl_dh_extra).


#### WOLFSSL_QNX_CAAM

Enables QNX CAAM (Cryptographic Acceleration and Assurance Module) support for hardware-accelerated crypto on QNX-based systems.

#### WOLFSSL_HAPROXY

OpenSSL compatibility specific macro.

#### WOLFSSL_ASYNC_IO

Lets TLS functions resume after a non-blocking I/O return (`WANT_READ` / `WANT_WRITE`), a pending OCSP lookup, a deferred chain verify callback, or asynchronous crypto. Defined by default by settings.h; [`WOLFSSL_NO_ASYNC_IO`](#wolfssl_no_async_io) turns it off unless async crypto, `WOLFSSL_NONBLOCK_OCSP` or `WOLFSSL_CHAIN_VERIFY_CB` needs it.


#### WOLFSSL_ASYNC_CRYPT_SW

Enables software-based async crypto simulation for testing. Simulates async behavior without requiring actual async hardware.

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

Test-only. Makes `wolfssl/ssl.h` also include the real OpenSSL headers, to check that an `--enable-opensslcoexist` build has no symbol clashes. Pass it in CFLAGS along with the OpenSSL include path; configure does not set it.

#### TEST_PK_PRIVKEY

Used for testing PK callbacks only. In wolfssl/test.h it uses the context to pass the actual private key which is loaded and used in the PK callback.

#### TEST_BUFFER_SIZE

Allows overriding the TLS benchmarking test buffer size used with the example client/server `-B` option.

#### FORCE_BUFFER_TEST

Forces use of the test_certs.h buffers instead of using the file system. Used for internal testing only in wolfssl/test.h.

#### WOLFSSL_FORCE_MALLOC_FAIL_TEST

Define for internal testing to induce random malloc failures.

#### WOLFSSL_POST_HANDSHAKE_AUTH

TLS extension, Used for post-handshake authentication.

#### WOLFSSL_PSK_MULTI_ID_PER_CS

With TLS 1.3 PSK, when `WOLFSSL_PSK_MULTI_ID_PER_CS` is defined, multiple IDs for a cipher suite can be handled.

#### WOLFSSL_PUBLIC_ASN

This exposes the ASN.1 API's publicly that are used internally. This is useful for customers who want to use the internal asn.h API's to parse.

#### WOLFSSL_QUIC

Enables support for QUIC protocol. See (https://github.com/wolfSSL/wolfssl/blob/master/doc/QUIC.md) for more information.

#### WOLFSSL_QUIC_MAX_RECORD_CAPACITY

Defines max quic capacity as 1024*1024 -- 1 MB.

#### WOLFSSL_RENESAS_FSPSM_TLS

Enables the TLS-layer offload to the Renesas FSP Security Module (for example certificate verification, master secret generation and TLS HMAC), on top of `WOLFSSL_RENESAS_FSPSM`. Not every board supports it; see the board's `user_settings.h` under `IDE/Renesas/e2studio`.


#### WOLFSSL_REFCNT_ERROR_RETURN

Internal. `wolfssl/wolfcrypt/wc_port.h` defines it when reference counts are protected by a mutex (no atomic operations), so that callers check the error the reference count functions can return. Do not define it yourself.

#### WOLFSSL_RENESAS_TSIP_TLS

Enables the TLS-layer use of Renesas TSIP (for example TLS 1.3 key exchange and key derivation, TLS HMAC and certificate verification), on top of `WOLFSSL_RENESAS_TSIP`. Leave it undefined, and define `WOLFSSL_RENESAS_TSIP_CRYPTONLY`, for wolfCrypt-only acceleration.

#### WOLFSSL_SM2

Enables SM2 elliptic curve signatures and key exchange (`--enable-sm2`, which needs ECC). The SM2, SM3 and SM4 implementations are in the separate wolfSM package (https://github.com/wolfSSL/wolfsm).

#### WOLFSSL_SM3

Enables the SM3 hash (`--enable-sm3`). Needs the wolfSM package.

#### WOLFSSL_SM4

Enables the SM4 block cipher. Set when any of the `--enable-sm4-ecb`, `--enable-sm4-cbc`, `--enable-sm4-ctr`, `--enable-sm4-gcm` or `--enable-sm4-ccm` options is used. Needs the wolfSM package.

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

#### HAVE_ED448

Enables Ed448 signatures. Enabled with [`--enable-ed448`](#--enable-ed448).

#### WOLFSSL_DH_CONST

Turns off use of floating point values when performing Diffie Hellman operations and uses tables for `XPOW()` and `XLOG()`. Removes dependency on external math library.

#### WOLFSSL_TRUST_PEER_CERT

Turns on the use of trusted peer certificates. This allows for loading in a peer certificate to match with a connection rather than using a CA. When turned on, if a trusted peer certificate is matched then the peer cert chain is not loaded and the peer is considered verified. Using CAs is preferred.

#### WOLFSSL_STATIC_MEMORY

Turns on the use of static memory buffers and functions. This allows for using static memory instead of dynamic.

#### WOLFSSL_STATIC_MEMORY_LEAN

It requires `WOLFSSL_STATIC_MEMORY` to be defined. It uses smaller type sizes for structs requiring memory pool sizes of less than 65k and limits features available, like IO buffers, to reduce footprint size.

#### WOLFSSL_SESSION_EXPORT

Turns on session export and import for TLS (`wolfSSL_tls_export()` / `wolfSSL_tls_import()`) and DTLS (`wolfSSL_dtls_export()` / `wolfSSL_dtls_import()`). This allows for serializing and sending/receiving the current state of a session. Enabled with `--enable-sessionexport`.


#### WOLFSSL_SESSION_EXPORT_DEBUG

Enables debug logging for session export and import operations. Helps diagnose issues with session serialization.


#### WOLFSSL_SESSION_EXPORT_NOPEER

Leaves the peer's network address (IP address, port and address family) out of the exported session. Without this macro, export and import save and restore the peer address through the get/set peer I/O callbacks (`wolfSSL_CTX_SetIOGetPeer()` / `wolfSSL_CTX_SetIOSetPeer()`). Set by `--enable-sessionexport=nopeer`.

#### WOLFSSL_ARMASM

Turns on the use of ARMv8 hardware acceleration.

#### WC_RSA_NONBLOCK

Turns on non-blocking RSA support for splitting RSA operations into smaller chunks of work. It is backed either by fast math (`fp_exptmod_nb`, needs `TFM_TIMING_RESISTANT`) or by SP small non-blocking math (`WOLFSSL_SP_NONBLOCK` with `WOLFSSL_SP_SMALL`, `WOLFSSL_SP_NO_MALLOC` and `RSA_LOW_MEM`). Enabled with `--enable-rsa=nonblock`. Feature is enabled by calling [`wc_RsaSetNonBlock()`](group__RSA.md#function-wc_rsasetnonblock) and checking for the `FP_WOULDBLOCK` / `MP_WOULDBLOCK` return code.

#### WC_RSA_BLINDING

Used to enable timing resistance (RSA private key blinding). Enabled by default in `./configure` builds through `--enable-harden` when the RNG is enabled; disable with `--disable-harden`.

#### WC_RSA_PSS

Enables RSA PSS padding. The only TLS 1.3 RSA padding scheme supported is PSS (per specification). PSS padding uses random padding. `./configure` turns it on whenever RSA and TLS 1.3 are enabled (the default), so it can only be left out of such a build together with TLS 1.3 (`--disable-tls13`); otherwise enable it with `--enable-rsapss`.

#### WOLFSSL_RSA_VERIFY_ONLY

Turns on small build for RSA verify only use. Should be used with the macros [`WOLFSSL_RSA_PUBLIC_ONLY`](#wolfssl_rsa_public_only), [`WOLFSSL_RSA_VERIFY_INLINE`](#wolfssl_rsa_verify_inline), [`NO_SIG_WRAPPER`](#no_sig_wrapper), and [`WOLFCRYPT_ONLY`](#wolfcrypt_only).

#### WOLFSSL_RSA_PUBLIC_ONLY

Turns on small build for RSA public key only use. Should be used with the macro [`WOLFCRYPT_ONLY`](#wolfcrypt_only).

#### WOLFSSL_SHA3

Turns on build for SHA3 use. This is support for SHA3 Keccak for the sizes SHA3-224, SHA3-256, SHA3-384 and SHA3-512. In addition `WOLFSSL_SHA3_SMALL` can be used to trade off performance for resource use. Enabled by default in `./configure` builds: directly on x86_64 and aarch64, and on other hosts because the default [`WOLFSSL_HAVE_MLKEM`](#wolfssl_have_mlkem) build needs it. Disable with `--disable-sha3`, which also turns off the default ML-KEM build.

#### USE_ECDSA_KEYSZ_HASH_ALGO

Will choose a hash algorithm that matches the ephemeral ECDHE key size or the next highest available. This workaround resolves issues with some peers that do not properly support scenarios such as a P-256 key hashed with SHA512.

#### WOLFSSL_ALT_CERT_CHAINS

Allows CA's to be presented by peer, but not part of a valid chain. Default wolfSSL behavior is to require validation of all presented peer certificates. This also allows loading intermediate CA's as trusted and ignoring no signer failures for CA's up the chain to root. The alternate certificate chain mode only requires that the peer certificate validate to a trusted CA.

#### WOLFSSL_SYS_CA_CERTS

Allows wolfSSL to use trusted system CA certificates for verification when [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs) is called, either by loading them into wolfSSL certificate manager, or by invoking system authentication APIs. See [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs) for more details. This preprocessor macro is automatically set by the `--enable-sys-ca-certs` configure option, which is enabled by default; disable it with `--disable-sys-ca-certs`.


#### WOLFSSL_SYS_CRYPTO_POLICY

Honors system-level crypto policy settings (e.g., `/etc/crypto-policies`) for restricting available algorithms and key sizes.

#### WOLFSSL_APPLE_NATIVE_CERT_VALIDATION

Enables the use of Apple's native trust APIs when authenticating TLS peer certificates. Requires [WOLFSSL_SYS_CA_CERTS](#wolfssl_sys_ca_certs) to be defined. This macro does not need to be set by the user if building with `configure` or `CMake` on iOS or other apple devices, but should be explicitly set on MacOS if you wish to use the native verification methods.


#### WOLFSSL_TEST_APPLE_NATIVE_CERT_VALIDATION

Enables testing mode for Apple native certificate validation. Used for unit testing the Apple cert validation integration.

#### WOLFSSL_CUSTOM_CURVES

Allow non-standard curves. Includes the curve "a" variable in calculation. Additional curve types can be enabled using [`HAVE_ECC_SECPR2`](#have_ecc_secpr2), [`HAVE_ECC_SECPR3`](#have_ecc_secpr3), [`HAVE_ECC_BRAINPOOL`](#have_ecc_brainpool) and [`HAVE_ECC_KOBLITZ`](#have_ecc_koblitz).

#### HAVE_ECC_SECPR2

Enables the additional prime curves secp160r2, prime192v2 and prime239v2. Set by `--enable-ecccustcurves=all` (also by `--enable-all` and `--enable-distro`).

#### HAVE_ECC_SECPR3

Enables the additional prime curves prime192v3 and prime239v3. Set by `--enable-ecccustcurves=all` (also by `--enable-all` and `--enable-distro`).

#### HAVE_ECC_BRAINPOOL

Enables the Brainpool curves brainpoolP160r1 to brainpoolP512r1. Requires `WOLFSSL_CUSTOM_CURVES` (the build stops with an error otherwise). Set by [`--enable-brainpool`](#--enable-brainpool), which is on by default whenever [`--enable-ecccustcurves`](#--enable-ecccustcurves) is used.

#### HAVE_ECC_KOBLITZ

Enables the Koblitz curves secp160k1, secp192k1, secp224k1 and secp256k1. Requires `WOLFSSL_CUSTOM_CURVES` (the build stops with an error otherwise). Set by `--enable-ecccustcurves=all` (also by `--enable-all` and `--enable-distro`).

#### HAVE_COMP_KEY

Enables ECC compressed key support.

#### WOLFSSL_EXTRA_ALERTS

Enables additional alerts to be sent during a TLS connection. This feature is also enabled automatically when [`--enable-opensslextra`](#--enable-opensslextra) is used.


#### WOLFSSL_EXTRA

Enables a few APIs without the full OpenSSL compatibility layer: `wolfSSL_get_keys()`, `wolfSSL_set_quiet_shutdown()` / `wolfSSL_CTX_set_quiet_shutdown()` and `wolfSSL_set_accept_state()`.

#### WOLFSSL_DEBUG_TLS

Enables additional debugging print outs during a TLS connection

#### WOLFSSL_DEBUG_TRACE_ERROR_CODES

Enables tracing of error code origins for debugging. Logs where error codes are generated in the wolfSSL source code.

#### WOLFSSL_DEBUG_MEMORY

Enables memory allocation debugging. Logs `malloc()` and `free()` calls with file name and line number information.

#### WOLFSSL_DEBUG_OPENSSL

Enables debug logging for the OpenSSL compatibility layer functions. Helps trace which OpenSSL compatibility APIs are being called. As of wolfSSL 5.9.4 it works as an alias for [`WOLFSSL_VERBOSE_LOGGING`](#wolfssl_verbose_logging).

#### WOLFSSL_VERBOSE_LOGGING

Lets the highest-volume trace messages (`WOLFSSL_MSG_VERBOSE()`, `WOLFSSL_ENTER_VERBOSE()`, `WOLFSSL_LEAVE_VERBOSE()`) into a `DEBUG_WOLFSSL` build. Traces on this tier can be emitted thousands of times by a single API call, so they are compiled out of a normal debug build, which keeps the debug output volume down by roughly 62%. Defined alone it does nothing; `DEBUG_WOLFSSL` is still required. See [Verbose Logging](chapter08.md#verbose-logging).

#### HAVE_BLAKE2B

Enables BLAKE2b algorithm support. Enabled with `--enable-blake2b` (`--enable-blake2` is an alias).

#### HAVE_BLAKE2S

Enables BLAKE2s algorithm support. Enabled with `--enable-blake2s`.

#### HAVE_BLAKE2

Legacy name for [`HAVE_BLAKE2B`](#have_blake2b). settings.h maps it to `HAVE_BLAKE2B`.

#### HAVE_FALLBACK_SCSV

Has no effect. This used to enable Signaling Cipher Suite Value (SCSV) support on the server side, which handles the cipher suite 0x56 0x00 sent from a client to signal that no downgrade of TLS version should be allowed. Since wolfSSL 5.9.4 the server always checks TLS_FALLBACK_SCSV (RFC 7507).

#### HAVE_AEAD

Internal. `wolfssl/internal.h` defines it automatically when an AEAD cipher is built (AES-GCM, AES-CCM, ChaCha20-Poly1305, ARIA, SM4-GCM/CCM, or the TLS 1.3 NULL ciphers). Do not define it directly.

#### HAVE_AES_CBC

Enable option for AES CBC. Always defined by settings.h when AES is enabled; define [`NO_AES_CBC`](#no_aes_cbc) to remove it.

#### HAVE_ALPN

Enables the Application-Layer Protocol Negotiation (ALPN) TLS extension (RFC 7301). Enabled with `--enable-alpn`.

#### HAVE_CAVIUM_OCTEON_SYNC

This enables the blocking (synchronous) version of the Marvell Cavium/Octeon hardware.

#### HAVE_CERTIFICATE_STATUS_REQUEST

Enables OCSP stapling with the status_request TLS extension (RFC 6066). Enabled with `--enable-ocspstapling`.

#### HAVE_CERTIFICATE_STATUS_REQUEST_V2

Enables OCSP stapling with the status_request_v2 TLS extension, which can carry multiple OCSP responses (RFC 6961). Enabled with `--enable-ocspstapling2`.

#### HAVE_CURL

Used for building a subset of the wolfSSL library when linking with cURL.

#### HAVE_CURVE448

Define for Curve448 support. Additional macro settings can be changed. The default is to enable shared secret, key export, and import.

#### HAVE_CURVE448_SHARED_SECRET

Enables Curve448 shared secret computation. On by default when [`HAVE_CURVE448`](#have_curve448) is enabled.

#### HAVE_CURVE448_KEY_EXPORT

Enables Curve448 public key export. On by default when [`HAVE_CURVE448`](#have_curve448) is enabled.

#### HAVE_CURVE448_KEY_IMPORT

Enables Curve448 public key import. On by default when [`HAVE_CURVE448`](#have_curve448) is enabled.

#### WOLFSSL_NO_ECDHX_SHARED_ZERO_CHECK

Since wolfSSL 5.9.2, Curve25519 and Curve448 shared secret computation rejects an all-zero result with `ECC_OUT_OF_RANGE_E` by default (RFC 7748 section 6.1, small-order peer points). Define `WOLFSSL_NO_ECDHX_SHARED_ZERO_CHECK` to skip this check.

#### HAVE_DANE

Placeholder for DANE (RFC 6698) support. No code references it, so defining it currently has no effect.

#### WOLFSSL_HAVE_MLKEM

Enables ML-KEM (FIPS 203) key encapsulation in wolfCrypt, and the ML-KEM and hybrid key exchange groups for TLS 1.3. Enabled by default in `./configure` builds (it turns on SHA-3 and SHAKE), unless SHA-3 or SHAKE is explicitly disabled or the build is FIPS older than v7; disable with [`--disable-mlkem`](#--disable-mlkem) (`--enable-kyber` is an alias for [`--enable-mlkem`](#--disable-mlkem)).

#### WOLFSSL_HAVE_MLDSA

Enables ML-DSA (FIPS 204) signatures in wolfCrypt. Set by [`--enable-mldsa`](#--enable-mldsa) (`--enable-dilithium` is an alias).

#### HAVE_DILITHIUM

Legacy name for [`WOLFSSL_HAVE_MLDSA`](#wolfssl_have_mldsa). settings.h maps `HAVE_DILITHIUM` to `WOLFSSL_HAVE_MLDSA`, and also defines `HAVE_DILITHIUM` whenever `WOLFSSL_HAVE_MLDSA` is set, unless `WOLFSSL_NO_DILITHIUM_LEGACY_GATES` is defined.

#### WOLFSSL_MLDSA_VERIFY_ONLY

Keeps only ML-DSA signature verification and drops key generation and signing. Turn it on with `--enable-mldsa=verify-only`.

#### WOLFSSL_MLDSA_VERIFY_SMALLEST_MEM

Uses the ML-DSA verification path with the smallest memory usage, aimed at very constrained targets like the TI C2000 C28x.

#### WOLFSSL_HAVE_LMS

Enables the LMS/HSS stateful hash-based signature scheme (RFC 8554) in wolfCrypt. Set by [`--enable-lms`](#--enable-lms), which also accepts `verify-only` (`WOLFSSL_LMS_VERIFY_ONLY`) and `small` (`WOLFSSL_WC_LMS_SMALL`). The private key changes with every signature, so signing needs the key state callbacks set with `wc_LmsKey_SetWriteCb()` and `wc_LmsKey_SetReadCb()`.

#### WOLFSSL_HAVE_XMSS

Enables the XMSS/XMSS^MT stateful hash-based signature scheme (RFC 8391) in wolfCrypt. Set by [`--enable-xmss`](#--enable-xmss), which also accepts `verify-only` (`WOLFSSL_XMSS_VERIFY_ONLY`) and `small` (`WOLFSSL_WC_XMSS_SMALL`). The private key changes with every signature, so signing needs the key state callbacks set with `wc_XmssKey_SetWriteCb()` and `wc_XmssKey_SetReadCb()`.


#### HAVE_DH_DEFAULT_PARAMS

No effect; kept for build compatibility. `--enable-defaultdhparams` (on by default) and the CMake option `WOLFSSL_DH_DEFAULT_PARAMS` still define it, but no library code reads it.

#### HAVE_ED25519_KEY_IMPORT

Enables Ed25519 key import. On by default when [`HAVE_ED25519`](#have_ed25519) is enabled; define `NO_ED25519_KEY_IMPORT` to remove it. Related macros `HAVE_ED25519_MAKE_KEY`, `HAVE_ED25519_SIGN`, `HAVE_ED25519_VERIFY` and `HAVE_ED25519_KEY_EXPORT` work the same way, each with a matching `NO_ED25519_*` macro.

#### HAVE_EX_DATA

Enable "extra" EX data APIs for user information in CTX/WOLFSSL.

#### HAVE_EX_DATA_CLEANUP_HOOKS

Adds `*_set_ex_data_with_cleanup()` variants that register a cleanup callback for ex_data on SSL, CTX, SESSION, X509, X509_STORE, X509_STORE_CTX, BIO and RSA objects (plus the generic `wolfSSL_CRYPTO_set_ex_data_with_cleanup()`).


#### HAVE_EX_DATA_CRYPTO

Enables extra data (ex_data) support for wolfCrypt objects such as RSA and ECC keys, in addition to SSL/CTX/X509 objects.

#### HAVE_FALCON

Enables the Falcon post-quantum signature scheme (levels 1 and 5). wolfSSL 5.9.4 replaced the old liboqs wrapper with a native wolfCrypt implementation that supports crypto callbacks and ARM DSP / AArch64 NEON acceleration. [`--enable-falcon`](#--enable-falcon) turns the scheme on and also picks the floating point / FFT backend and memory profile. Falcon is not standardized, so `--enable-falcon` also needs `--enable-experimental`.

#### HAVE_FIPS

Used when implementing different FIPS versions.


#### HAVE_FUZZER

Enables fuzzing callback support for security testing. Allows a callback to be set that can modify or inspect TLS records during processing.

#### HAVE_KEYING_MATERIAL

Enables exporting keying material based on section 7.5 of RFC 8446.

#### HAVE_OID_DECODING

Included in ASN template code. Used to decode in some cases.

#### HAVE_MAX_FRAGMENT

Sets maximum fragment size. TLS extension.


#### HAVE_MEMCACHED

Enables APIs and behaviors needed for memcached compatibility with wolfSSL.

#### WOLFSSL_PSK_ONE_ID

Enables support for only one PSK ID with TLS 1.3.


#### WOLFSSL_PSK_IDENTITY_ALERT

Sends a specific TLS alert when PSK identity lookup fails during the handshake, rather than a generic handshake failure.

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


#### MAX_EX_DATA

Sets the maximum number of extra data (ex_data) entries that can be stored per SSL/CTX/X509 object. Default is 5 if not defined.

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

#### WOLFSSL_STATIC_EPHEMERAL

Lets a fixed ("static") ephemeral (EC)DH key be loaded with [`wolfSSL_CTX_set_ephemeral_key()`](ssl_8h.md#function-wolfssl_ctx_set_ephemeral_key) or `wolfSSL_set_ephemeral_key()`, so the sniffer can decrypt traffic that uses ephemeral key exchange. Reusing one ephemeral key across connections gives up forward secrecy; use it only for testing, inspection or debugging. Set automatically by `--enable-sniffer`.

#### SSL_SNIFFER_EXPORTS

WIN32 sniffer export.

#### WOLFSSL_SNIFFER_KEYLOGFILE

The SSL Keylog file option enables the sniffer to decrypt TLS traffic using the master secret obtained from a [NSS keylog file](https://web.archive.org/web/20220531072242/https://firefox-source-docs.mozilla.org/security/nss/legacy/key_log_format/index.html). This allows the sniffer to decrypt all TLS traffic, even for TLS connections using ephemeral cipher suites. Keylog file sniffing is supported for TLS versions 1.2 and 1.3. wolfSSL can be configured to export a keylog file using the `--enable-keylog-export` configure option, independently from the sniffer feature (NOTE: never do this in a production environment, as it is inherently insecure). To enable sniffer support for keylog files, use the following configure command line and build as before: `./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_KEYLOGFILE`.

#### WOLFSSL_SNIFFER_STORE_DATA_CB

The Store Data Callback option allows the sniffer to take a callback that is called when storing the application data into a custom buffer rather than into the reallocated data pointer. The callback is called in a loop until all data is consumed. To enable this option, use the following configure command line and build as before: `./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_STORE_DATA_CB`.

#### WOLFSSL_SNIFFER_WATCH

The Session Watching option allows the sniffer to watch any packet provided without initial setup. It will start to decode all TLS sessions and when the server's certificate is detected, the certificate is given to a callback function provided by the user which should provide the appropriate private key. To enable this option, use the following configure command line and build as before: `./configure --enable-sniffer CPPFLAGS=-DWOLFSSL_SNIFFER_WATCH`.

#### STATIC_BUFFER_LEN

Size of the static input and output buffers in each SSL object. You can override it. By default it is `RECORD_HEADER_SZ`, so only the record header is held statically and larger buffers are allocated as needed; with [`LARGE_STATIC_BUFFERS`](#large_static_buffers) it is a full record plus overhead.

#### STATIC_CHUNKS_ONLY

The user has the option to turn off the 16K output option if we are using small static buffers (the default) and SSL_write tries to write data larger than the record we have, dynamically getting it unless the user says only write in static buffer chunks.

#### WOLFSSL_DEF_PSK_CIPHER

Second byte of the TLS 1.3 cipher suite (the first byte is `TLS13_BYTE`) used with an external PSK when the PSK callback does not name a cipher suite, for example with the callbacks set by `wolfSSL_CTX_set_psk_client_callback()` and `wolfSSL_CTX_set_psk_server_callback()` rather than their TLS 1.3 variants. Defaults to `TLS_AES_128_GCM_SHA256`; define it at compile time to override.

#### WOLFSSL_OLD_PRIME_CHECK

Enable feature which uses faster DH and RSA prime checking.


#### WOLFSSL_OLD_SET_CURVES_LIST

Uses the old-style curve list parsing for backward compatibility with applications that set curves using the older format.

#### WOLFSSL_OLD_TIMINGPADVERIFY

Uses the old timing-based padding verification for CBC cipher suites. The new method provides better constant-time behavior.

#### WOLFSSL_OLDTLS_AEAD_CIPHERSUITES

Enables AEAD cipher suites (GCM, CCM) for TLS versions prior to 1.2. These suites are normally only available in TLS 1.2 and later.


#### WOLFSSL_OLDTLS_SHA2_CIPHERSUITES

Enables SHA-2 based cipher suites for TLS versions prior to 1.2. These suites are normally only available in TLS 1.2 and later.

#### WOLFSSL_STATIC_RSA

Static ciphers are strongly discouraged and should never be used if avoidable. However there are still legacy systems that ONLY support static cipher suites. To that end if you need to connect to a legacy peer only supporting static RSA cipher suites use this to enable support for static RSA in wolfSSL. (See also [`WOLFSSL_STATIC_PSK`](#wolfssl_static_psk) and [`WOLFSSL_STATIC_DH`](#wolfssl_static_dh))


#### WOLFSSL_STRONGEST_HASH_SIG

Prefers the strongest available hash algorithm when performing signature operations during the TLS handshake.

#### WOLFSSL_STATIC_PSK

Feature that enables static PSK cipher suites. Static ciphers are highly discouraged see [`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)

#### WOLFSSL_STATIC_DH

Feature that enables static ECDH cipher suites. Static ciphers are highly discouraged see [`WOLFSSL_STATIC_RSA`](#wolfssl_static_rsa)

#### HAVE_NULL_CIPHER

Turns on support for NULL ciphers. This option is highly discouraged from a security standpoint however some systems are too small to perform encrypt/decrypt operations and it is better to at least authenticate messages and peers to prevent message tampering than nothing at all!

#### HAVE_ANON

Turns on support for anonymous cipher suites. (Never recommended, some valid use cases involving closed or private networks detached from the web)


#### HAVE_ATEXIT

Registers `wolfSSL_Cleanup()` as an `atexit()` handler for automatic cleanup when the program exits. Only takes effect with `OPENSSL_EXTRA`.

#### HAVE_LIBOQS

Removed in wolfSSL 5.9.4. liboqs is not used for any algorithm anymore; every post-quantum algorithm (ML-KEM, ML-DSA, SLH-DSA, Falcon, FrodoKEM, LMS and XMSS) is implemented natively in wolfCrypt, and defining this macro does nothing. Please see the appendix [Experimenting with Post-Quantum Cryptography](appendix09.md#experimenting-with-post-quantum-cryptography) in this document for more details.


#### HAVE_LIGHTY

Enables APIs and behaviors needed for lighttpd web server compatibility with wolfSSL.

#### WOLFSSL_SP_4096

Enable RSA/DH 4096-bit Single-Precision (SP) support.

#### WOLFSSL_SP_384

Enable ECC SECP384R1 Single-Precision (SP) support. Requires the SP ECC implementation (`WOLFSSL_HAVE_SP_ECC`, from `--enable-sp`). configure also defines `HAVE_ECC384` with it, and with [`WOLFSSL_SP_MATH`](#wolfssl_sp_math) settings.h does so automatically.

#### WOLFSSL_SP_1024

Enable SAKKE pairing based cryptography Single-Precision (SP) support.

#### ATOMIC_USER

Enable Atomic Record Layer callbacks.

#### BIG_ENDIAN_ORDER

Endianness - defaults to little endian, i.e., makes big-endian.

#### WOLFSSL_32BIT_MILLI_TIME

Function TimeNowInMilliseconds() returns an unsigned 32-bit value. The default behavior is to return a signed 64-bit value.

#### WOLFSSL_MAX_DHKEY_BITS

Maximum DH key size in bits accepted in TLS. Must be a multiple of 8, at most 16384, and not less than [`WOLFSSL_MIN_DHKEY_BITS`](#wolfssl_min_dhkey_bits). The default depends on the math library: `SP_INT_BITS` with SP math, `FP_MAX_BITS / 2` with fast math (when `FP_MAX_BITS` is at least 16384), otherwise 4096.

#### WOLFSSL_MIN_DHKEY_BITS

Minimum DH key size in bits accepted in TLS. Defaults to `DH_MIN_SIZE` (1024, or 2048 for FIPS builds). With [`WOLFSSL_HARDEN_TLS`](#wolfssl_harden_tls) set to 112 or 128 the default is 2048 or 3072, and a value below 2048 is rejected because 112 bits of security needs at least 2048-bit DH keys. Must be a multiple of 8, at most 16000, and at least `DH_MIN_SIZE`.

#### WOLFSSL_MAX_MTU

Max expected MTU. 1500 - 100 bytes to account for UDP and IP headers.

#### IGNORE_NETSCAPE_CERT_TYPE

Skip decoding of the Netscape Certificate Type certificate extension.

#### SESSION_CERTS

TLS session cache for certs.

#### WOLFSSL_DUAL_ALG_CERTS

Enables X9.146 dual key/signature (hybrid) certificates and their use in TLS 1.3. Set by `--enable-dual-alg-certs`, which needs `--enable-experimental`.

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

Enable TLS 1.3 protocol implementation. Enabled by default in `./configure` builds; disable with `--disable-tls13`.

#### WOLFSSL_TLS13_IGNORE_AEAD_LIMITS

Turns off enforcement of the TLS 1.3 and DTLS 1.3 AEAD usage limits (RFC 9846 section 5.5, RFC 9147 section 4.5.3). By default wolfSSL updates the keys once the number of records sent with one key reaches the limit for the cipher. For DTLS 1.3 it also counts records that fail decryption (limits specified by https://www.rfc-editor.org/rfc/rfc9147.html#name-aead-limits): it requests a key update at the halfway point to the hard decryption fail limit, and fails the connection when the hard limit is reached.


#### WOLFSSL_TLS13_DRAFT

Uses draft TLS 1.3 specification parameters for testing against draft implementations. Not for production use.

#### WOLFSSL_TLS13_MIDDLEBOX_COMPAT

Enable middlebox compatibility in the TLS 1.3 handshake. This includes sending ChangeCipherSpec before encrypted messages and including a session ID. Starting with wolfSSL 5.9.4 a TLS 1.3 server replies to a ClientHello that carries a non-empty legacy_session_id with a ChangeCipherSpec record (RFC 8446 Appendix D.4) in every build. The macro makes the client side do it as well: populate the session ID and send its own ChangeCipherSpec.

#### WOLFSSL_TLS13_NULL_CIPHER_IN_DEFAULT

Puts the TLS 1.3 NULL cipher suites (`TLS_SHA256_SHA256`, `TLS_SHA384_SHA384`) back in the default cipher list. As of wolfSSL 5.9.4 the suites are compiled in with `--enable-nullcipher` but not advertised unless you configure them explicitly.

#### WOLFSSL_TLS13_TICKET_CHECK_PSK_MODES

An optional RFC 9846 hardening. When set, a TLS 1.3 server only sends NewSessionTicket messages to clients that put the psk_key_exchange_modes extension in their ClientHello.

#### WOLFSSL_TLS13_SHA512

Keeps the SHA-512 transcript hash in a TLS 1.3 only build. wolfSSL 5.9.4 and later drop the TLS 1.2 transcript state (the handshake hashes go from 864 to 352 bytes) and the SHA-512 transcript from such builds unless this macro is set. Enable it with [`--enable-tls13-sha512`](#--enable-tls13-sha512) or the CMake option `WOLFSSL_TLS13_SHA512`. Requires `WOLFSSL_SHA512`. No TLS 1.3 cipher suite uses SHA-512, so in TLS 1.3 it is only used for the HelloRetryRequest cookie HMAC, and only when SHA-256 and SHA-384 are not available.

#### WOLFSSL_TLS_READ_AHEAD

Enables TLS receive read-ahead. Instead of reading one record header and one record body at a time, the receive path pulls as many bytes as the buffer can hold from each `recv()` call, which lowers the number of `recv()` calls per record. Build it in with [`--enable-readahead`](#--enable-readahead) and switch it on at runtime with `wolfSSL_set_read_ahead()` or `wolfSSL_CTX_set_read_ahead()`.

#### WOLFSSL_BUILD_MSG_NO_ZERO_COPY

Turns off the zero-copy encryption of AEAD application data that wolfSSL 5.9.4 added to the record build path (the send path runs about 1% to 3% faster with it). Define the macro to get the old copy-then-encrypt behavior back.

#### WOLFSSL_X25519_NO_MASK_PEER

wolfSSL 5.9.4 and later mask off the top bit of a peer's X25519 public value as RFC 7748 requires, in wolfCrypt and in the TLS 1.2 / 1.3 key exchange, instead of rejecting the value. Define this macro to go back to rejecting it.


#### WOLFSSL_TLS13_IGNORE_PT_ALERT_ON_ENC

Ignores plaintext alerts received when encrypted records are expected in TLS 1.3. May improve interoperability with some implementations. The tolerance starts once wolfSSL is decrypting records from the peer, and ends when the peer sends its first encrypted record or the handshake completes, whichever comes first. After that a plaintext alert is a fatal error again. Encrypted alerts are handled as usual, and ignored plaintext alerts still count toward the `WOLFSSL_ALERT_COUNT_MAX` limit.

#### WOLFSSL_TLS13_TICKET_BEFORE_FINISHED

Allows the server to send a NewSessionTicket message before receiving the client's Finished message. See TLS 1.3 specification, Section 4.6.1, Paragraph 4.

#### WOLFSSL_EARLY_DATA

Enables TLS 1.3 0-RTT (Zero Round Trip Time) early data support. Allows clients to send application data in the first flight of the handshake for faster connection establishment. Requires session resumption via PSK or session tickets.

#### WOLFSSL_EARLY_DATA_GROUP

Groups the early data message with the ClientHello when sending. Reduces the number of network round trips by combining messages.

#### WOLFSSL_CHECK_SIG_FAULTS

Verifies the ECC signature after signing to detect fault injection attacks. Useful in environments where hardware fault attacks are a concern.


#### WOLFSSL_CIPHER_INTERNALNAME

Uses wolfSSL internal cipher suite names instead of IANA-standard names when reporting cipher suite information through the API.

#### WOLFSSL_NO_CLIENT_CERT_ERROR

TLS 1.3 client side: when the server requests a certificate and the client has none, abort the handshake with a `certificate_required` alert and `NO_CERT_ERROR` (or with an `unsupported_certificate` alert when its certificate chain uses signature algorithms the server does not accept). By default the client sends an empty Certificate message (RFC 8446 section 4.4.2). Server-side enforcement is `WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT`.

#### WOLFSSL_NONBLOCK_OCSP

Enables non-blocking OCSP stapling processing. Allows OCSP lookups to be performed asynchronously during the TLS handshake.

#### WOLFSSL_TLS_OCSP_MULTI

Enables support for multiple OCSP responses in TLS, allowing stapling of OCSP responses for intermediate certificates in addition to the end-entity certificate.

#### WOLFSSL_CERT_SETUP_CB

Enables a certificate setup callback, set with `wolfSSL_CTX_set_cert_cb()`, that allows dynamic certificate and key selection during the handshake. A server invokes it while processing the ClientHello (TLS 1.2 and TLS 1.3), before cipher suite matching, so the choice can be based on the ClientHello contents; a client invokes it when it receives a CertificateRequest. Also adds `wolfSSL_get_client_suites_sigalgs()`. Set by `--enable-cert-setup-cb`.

#### WOLFSSL_RW_THREADED

Enables read/write threading support, allowing separate threads to perform TLS read and write operations concurrently on the same SSL session.

#### WOLFSSL_PRIORITIZE_PSK

During a TLS 1.3 handshake, prioritizes PSK order instead of ciphersuite order when selecting a cipher suite. The PSK callback order determines preference.

#### WOLFSSL_UIP

When CONTIKI is defined, it is an implementation of UIP.

#### TLS13_MAX_TICKET_AGE

Specifies Max ticket age. For TLS 1.3, this is 7 days.

#### TLS13_TICKET_NONCE_STATIC_SZ

Size of the static buffer that holds a TLS 1.3 ticket nonce (default 8, maximum 255). Not supported with FIPS builds older than v5.3.


#### TIME_OVERRIDES

Application provides custom time functions (`XTIME`, `XGMTIME`, etc.) instead of using the system time functions.

#### TLS13_TICKET_NONCE_MAX_SZ

Defines version max size for ticket nonce. Max size is defined as 255 bytes.

#### WOLFSSL_TICKET_ENC_AES128_GCM

Use AES128-GCM to encrypt/decrypt session tickets in the default callback. This is server-only. The default ticket cipher is ChaCha20-Poly1305 when it is compiled in and neither AES-GCM ticket macro is defined. Otherwise it is AES-256-GCM when `WOLFSSL_AES_256` is available, and AES-128-GCM only when it is not.

#### WOLFSSL_TICKET_ENC_AES256_GCM

Use AES256-GCM to encrypt/decrypt session tickets in default callback. Server only.

#### WOLFSSL_TICKET_ENC_CHACHA20_POLY1305

Use ChaCha20-Poly1305 to encrypt/decrypt session tickets in the default callback. This is also the default when ChaCha20-Poly1305 is compiled in and neither `WOLFSSL_TICKET_ENC_AES128_GCM` nor `WOLFSSL_TICKET_ENC_AES256_GCM` is defined. This is server-only.


#### WOLFSSL_TICKET_ENC_CBC_HMAC

Uses CBC+HMAC for session ticket encryption instead of an AEAD cipher. Provides an alternative for builds without AEAD support.

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


#### SHOW_SIZES

Displays sizes of major wolfSSL structures at initialization. Useful for debugging and memory analysis on constrained systems.

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

Largest connection ID wolfSSL asks to receive (and, for DTLS 1.2, sends). Default 10 bytes, maximum 255. Applies to DTLS 1.2 and 1.3 with [`WOLFSSL_DTLS_CID`](#wolfssl_dtls_cid). The DTLS parsing code copies the record header in a static buffer to decrypt the record, so increasing the CID max size also increases this buffer, impacting the per-session runtime memory footprint.

#### DTLS13_EPOCH_SIZE

Portability improvement with DTLS 1.3 epoch. Implements a way to save the key bound to a DTLS epoch and setting
the right key/epoch when needed.

#### DTLS13_RETRANS_RN_SIZE

Portability improvement with DTLS 1.3. Used in DTLS 1.3 to identify size before retransmission.

#### WOLFSSL_DTLS_FRAG_POOL_SZ

Maximum number of separate fragment buckets buffered while reassembling one DTLS handshake message. Default 10, maximum 255.


#### WOLFSSL_DTLS_MTU

Enables DTLS MTU (Maximum Transmission Unit) management APIs for controlling the maximum datagram size during DTLS communication.

#### WOLFSSL_COND

Defined if this system supports signaling COND_TYPE - type that should be passed into the signaling API.

#### WOLFSSL_DTLS_CH_FRAG

Allows a server to process a fragmented second/verified (one containing a valid cookie response) ClientHello message. The first/unverified (one without a cookie extension) ClientHello MUST be unfragmented so that the DTLS server can process it statelessly. This is only implemented for DTLS 1.3. The user MUST call `wolfSSL_dtls13_allow_ch_frag()` on the server to explicitly enable this during runtime (it defaults to on in ML-KEM builds only). Note: Using DTLS 1.3 + pqc without `WOLFSSL_DTLS_CH_FRAG` will probably fail. In this case use `--enable-dtls-frag-ch` to enable it (ML-KEM builds get it automatically). With cookies disabled through `wolfSSL_disable_cookie()`, a DTLS 1.3 server can process a fragmented first ClientHello only if it was built with this macro and `wolfSSL_dtls13_allow_ch_frag()` is on; otherwise the fragments are dropped.

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


#### WOLFSSL_MYSQL_COMPATIBLE

Enables MySQL protocol compatibility behaviors in wolfSSL. Required when using wolfSSL as the TLS provider for MySQL.

#### WOLFSSL_NAMES_STATIC

Stores name strings in lookup tables (for example cipher suite names, certificate name component names, Curve25519 and LMS/XMSS parameter names) in fixed-size arrays instead of pointers, so the tables need no relocation. This is for Position Independent Code (PIC); settings.h defines it automatically for Linux kernel module builds with relocation tables (`WC_SYM_RELOC_TABLES`, from `--enable-kernel-reloc-tables`) and for IAR ROPI builds. Static ECC curve tables are `WOLFSSL_ECC_CURVE_STATIC`.

#### WOLFSSL_SEND_HRR_COOKIE

Enables the server side of the TLS 1.3 / DTLS 1.3 HelloRetryRequest cookie extension (sending a cookie, selected at runtime with `wolfSSL_send_hrr_cookie()`). The client side (echoing a received cookie) is always built into TLS 1.3 builds with client support, see [`WOLFSSL_TLS13_COOKIE`](#wolfssl_tls13_cookie). Required for a stateless DTLS 1.3 server (`wolfDTLS_accept_stateless()`).

wolfSSL 5.9.4 made the DTLS cookie mode a single policy the application sets: `wolfSSL_enable_cookie()` and `wolfSSL_disable_cookie()` switch server cookies for DTLS 1.2, DTLS 1.3 and TLS 1.3, and `wolfSSL_disable_hrr_cookie()` just calls `wolfSSL_disable_cookie()`. Once the handshake has decided how to handle the ClientHello, the setters return `BAD_STATE_E`. Cookie secret changes are all or nothing: the new secret is fully built before the old one is freed. A secondary, verify-only cookie secret lets the application rotate secrets.

#### WOLFSSL_TLS13_COOKIE

Enables the client side cookie echo for the TLS 1.3 cookie extension, without the server side. It was split out of `WOLFSSL_SEND_HRR_COOKIE` in wolfSSL 5.9.4. You do not need to define it: `wolfssl/internal.h` defines it automatically in every TLS 1.3 build with client support (cookie support is mandatory per RFC 8446 section 9.2) and whenever `WOLFSSL_SEND_HRR_COOKIE` is defined.

#### WOLFSSL_SEP

Feature certificate policy set extension.


#### WOLFSSL_SECURE_RENEGOTIATION_ON_BY_DEFAULT

Enables secure renegotiation by default for all new SSL contexts without requiring an explicit API call.

#### WOLFSSL_SESSION_ID_CTX

Used to copy over application session context ID.

#### WOLFSSL_SESSION_TIMEOUT

Default session resumption cache timeout in seconds is used to define timeout manually.


#### WOLFSSL_SET_CIPHER_BYTES

Enables setting cipher suites by raw two-byte values instead of name strings. Useful for programmatic cipher suite configuration.

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

Internal. `wolfssl/internal.h` defines it automatically when AES, AES-GCM, ARIA, ChaCha20-Poly1305 or TLS 1.3 is built. It adds the per-record nonce buffer to the cipher state. It is not a user option.

#### CloseSocket

A way to override the function used for closing a socket. Used with CRL, OCSP and BIO.

#### CONFIG_POSIX_API

Enables POSIX names for networking systems calls.

#### WOLFSSL_USER_CURRTIME

Add in the option to use in test.h without the gettimeofday function using the macro `WOLFSSL_USER_CURRTIME`.

#### WOLFSSL_USER_MUTEX

Option for user-defined mutexes with `WOLFSSL_USER_MUTEX`.

#### DEFAULT_MIN_ECCKEY_BITS

Default minimum ECC key size (224 bits, or 256 with `WOLFSSL_MAX_STRENGTH`) used by the example client and server (`wolfssl/test.h`). For the library limit see [`WOLFSSL_MIN_ECC_BITS`](#wolfssl_min_ecc_bits).

#### DEFAULT_MIN_RSAKEY_BITS

Default minimum RSA key size (1024 bits, or 2048 with `WOLFSSL_MAX_STRENGTH`) used by the example client and server (`wolfssl/test.h`). For the library limit see [`WOLFSSL_MIN_RSA_BITS`](#wolfssl_min_rsa_bits).

#### EXTERNAL_SERIAL_SIZE

A raw serial number byte that writes X509 serial numbers in unsigned binary to a buffer. For all cases, the buffer needs to be at least `EXTERNAL_SERIAL_SIZE` (32). On success, it returns `WOLFSSL_SUCCESS`. Note: this is an internal macro that cannot be user defined.

#### LARGE_STATIC_BUFFERS

Makes the static input and output record buffers in each SSL object big enough for a full record (`RECORD_SIZE` becomes `MAX_RECORD_SIZE`, 16 KB, plus the record header and overhead), instead of the default static buffers that only hold a record header. Forced on by [`WOLFSSL_CALLBACKS`](#wolfssl_callbacks).

#### LIBWOLFSSL_VERSION_STRING

This is the wolfSSL version string populated for release bundles or when `./configure` is run. There is also a 32-bit HEX version of this in `LIBWOLFSSL_VERSION_HEX`. These come from wolfssl/version.h.


#### WOLFSSL_HAVE_ERROR_QUEUE

Internal macro, set automatically by `wolfssl/wolfcrypt/logging.h` when `OPENSSL_EXTRA` (on non-Windows builds), `DEBUG_WOLFSSL_VERBOSE` or `HAVE_MEMCACHED` is defined. It enables the OpenSSL-compatible error queue used by `wolfSSL_ERR_get_error()` and related functions. Do not define it directly; define `NO_ERROR_QUEUE` to turn the queue off in an `OPENSSL_EXTRA` build.

#### WOLFSSL_HAVE_CERT_SERVICE

Set by [`--enable-certservice`](#--enable-certservice) (which also turns on `WOLFSSL_CERT_GEN`, ECC and `OPENSSL_EXTRA`) for the wolfSSL certificate service product. It only adds the marker function `wolfSSL_cert_service()`, which that product's configure script checks for; it adds no handshake callbacks.

### Customizing or Porting wolfSSL

#### WOLFSSL_USER_SETTINGS

If defined, it allows the use of a user-specific settings file. The file must be named `user_settings.h` and exist in the include path. It is included prior to the standard `settings.h` file, so default settings can be overridden.

#### WOLFSSL_CALLBACKS

This extension allows debugging callbacks through the use of signals in an environment without a debugger. It is off by default. It can also be used to set up a timer with blocking sockets. Please see [Callbacks](chapter06.md#callbacks) for more information.

#### WOLF_CRYPTO_CB

 Enable crypto callback support. This feature is also enabled automatically when [`--enable-cryptocb`](#--enable-cryptocb) is used.

#### WOLF_CRYPTO_CB_FIND

Enable find device callback functions for looking up registered crypto devices by device ID. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### WOLF_CRYPTO_CB_CMD

Enable command callback functions that are invoked during register and unregister of crypto callback devices. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### WOLF_CRYPTO_CB_COPY

Enable copy callback for algorithm structures, allowing hash and cipher state to be copied via the crypto callback framework. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### WOLF_CRYPTO_CB_FREE

Enable free callback for algorithm structures, allowing cleanup of crypto objects via the crypto callback framework. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### WOLF_CRYPTO_CB_AES_SETKEY

Enable crypto callback support for AES key setup operations. Allows hardware to handle key scheduling. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### WOLF_CRYPTO_CB_RSA_PAD

Enable crypto callback support for RSA padding operations, allowing custom padding handling by hardware or external modules. Requires [`WOLF_CRYPTO_CB`](#wolf_crypto_cb).

#### DEBUG_CRYPTOCB

Enable debug InfoString functions for crypto callback operations. Useful for debugging which crypto operations are being routed to hardware.

#### WC_USE_DEVID

Specify a default device ID to use for crypto callbacks when no hardware-specific device (such as CAAM) is detected.

#### WC_NO_DEFAULT_DEVID

Disable automatic default device ID selection in the crypto callback framework. When defined, applications must explicitly pass a device ID for all crypto operations.

#### WOLFSSL_CAAM_DEVID

Defines the device ID constant (value 7) for NXP CAAM hardware crypto. Used in default device ID selection logic.

#### NO_SHA2_CRYPTO_CB

Disable crypto callback support for SHA-384 and SHA-512 operations. When defined, these hash operations will always use software implementations.

#### WOLF_CRYPTO_CB_ONLY_RSA

Restricts RSA operations to use only crypto callbacks, disabling all software RSA implementations. Useful when RSA should be delegated entirely to hardware.

#### WOLF_CRYPTO_CB_ONLY_ED25519, WOLF_CRYPTO_CB_ONLY_CURVE25519, WOLF_CRYPTO_CB_ONLY_CURVE448, WOLF_CRYPTO_CB_ONLY_SLHDSA

New in wolfSSL 5.9.4: crypto-callback-only modes for Ed25519, Curve25519 (`make_pub` and the generic scalar multiply included, saves about 6 KB), Curve448 and SLH-DSA (saves about 16 KB). Each macro compiles out the software implementation, so the algorithm has to be handled by a registered crypto callback device. [`--enable-cryptocb=only`](#--enable-cryptocb) sets all of the `WOLF_CRYPTO_CB_ONLY_*` flags at once.

#### WOLF_CRYPTO_CB_ASYNC_POLL

Lets crypto callback devices that run the TLS record ciphers use a poll-to-complete model. The callback can return `WC_PENDING_E` for a bulk cipher operation and the TLS layer keeps polling until it finishes. Without the macro, a pending bulk cipher returns `ASYNC_OP_E` instead of leaving a corrupted record. Needs bulk cipher async support.

#### WOLF_CRYPTO_CB_KEYSTORE

Adds `WC_ALGO_TYPE_KEYSTORE`, a crypto callback algorithm type for handling keys that live in a hardware key store. The public API is in `wolfssl/wolfcrypt/wc_keystore.h`. There are seven operations: import and export in plaintext and wrapped form, derive, delete and get-info. Keys are addressed by an opaque device-defined reference, which lets a device create, wrap, derive and destroy keys that never show up in memory. Enable it with `--enable-cryptocbutils=keystore`.

#### WOLFSSL_ASYNC_CERT_YIELD

Optional asynchronous TLS chain processing. Requires [`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt). After each certificate in a peer chain is verified the call returns `WC_PENDING_E`, giving a cooperative scheduler a chance to run in between. These yields do not queue an async device event, so they are only suitable for cooperative schedulers that call `wolfSSL_connect()` / `wolfSSL_accept()` again; leave the macro undefined for fd/event-driven async use. See `README-async.md`.

#### WOLFSSL_DYN_CERT

Allow allocation of subjectCN and publicKey fields when parsing certificates even with WOLFSSL_NO_MALLOC set. If using the WOLFSSL_NO_MALLOC option with RSA certificates the public key needs to be retained for CA's for validate certificates on the peer's certificate. This appears as a ConfirmSignature error -173 BAD_FUNC_ARG, since the ca->publicKey is NULL.

#### WOLFSSL_USER_IO

Allows the user to remove automatic setting of the default I/O functions [`EmbedSend()`](wolfio_8h.md#function-embedsend) and [`EmbedReceive()`](wolfio_8h.md#function-embedreceive). Used for custom I/O abstraction layer (see [Abstraction Layers](chapter05.md#abstraction-layers) for more details).

#### NO_FILESYSTEM

Is used if stdio isn't available to load certificates and key files. This enables the use of buffer extensions to be used instead of the file ones.

#### NO_INLINE

Disables the automatic inlining of small, heavily used functions. Turning this on will slow down wolfSSL and actually make it bigger since these are small functions, usually much smaller than function call setup/return. You'll also need to add `wolfcrypt/src/misc.c` to the list of compiled files if you're not using autoconf.

#### NO_DEV_RANDOM

Disables the use of the default `/dev/random` random number generator. If defined, the user needs to provide an OS-specific `wc_GenerateSeed()` function (see `wolfcrypt/src/random.c`), or use [`CUSTOM_RAND_GENERATE_SEED`](#custom_rand_generate_seed) / [`CUSTOM_RAND_GENERATE_BLOCK`](#custom_rand_generate_block). With [`WOLF_CRYPTO_CB`](#wolf_crypto_cb) the seed can come from a crypto callback device.

#### NO_MAIN_DRIVER

Is used in the normal build environment to determine whether a test application is called on its own or through the testsuite driver application. You'll only need to use it with the test files: `test.c`, `client.c`, `server.c`, `echoclient.c`, `echoserver.c`, and `testsuite.c`

#### NO_WRITEV

Disables simulation of `writev()` semantics.

#### SINGLE_THREADED

Is a switch that turns off the use of mutexes. wolfSSL uses mutexes for the session cache, the CA, CRL and OCSP tables, the global RNG, reference counts and more. If your use of wolfSSL is always single threaded you can turn this on.

#### WOLFSSL_CLEANUP_THREADSAFE_BY_ATOMIC_OPS

Uses atomic operations to make `wolfSSL_Cleanup()` thread-safe without requiring a mutex.

#### USER_TICKS

Allows the user to define their own clock tick function if time(0) is not wanted. Custom function needs second accuracy, but doesn't have to be correlated to Epoch. See `LowResTimer()` in `src/internal.c`.

#### USER_TIME

Disables the use of time.h structures in the case that the user wants (or needs) to use their own. With `USER_TIME` the user only provides `XTIME()` (seconds since the epoch); wolfSSL supplies its own `gmtime()` ([`WOLFSSL_GMTIME`](#wolfssl_gmtime)) and its own `time_t` / `struct tm` types (unless `HAVE_TIME_T_TYPE` / `HAVE_TM_TYPE` is defined). To override `XGMTIME()` as well, use [`TIME_OVERRIDES`](#time_overrides). `XVALIDATE_DATE()` can be overridden independently. See `wolfssl/wolfcrypt/wc_port.h`.

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

Builds wolfSSL's default socket I/O callbacks ([`EmbedSend()`](wolfio_8h.md#function-embedsend) and [`EmbedReceive()`](wolfio_8h.md#function-embedreceive)). It is defined automatically unless [`WOLFSSL_USER_IO`](#wolfssl_user_io) (or [`WOLFSSL_NO_SOCK`](#wolfssl_no_sock), [`MICRIUM`](#micrium) or [`WOLFSSL_CONTIKI`](#wolfssl_contiki)) is defined. An example that replaces the default callbacks with custom ones can be found here: (https://github.com/wolfSSL/wolfssl-examples/blob/master/tls/client-tls-callback.c#L6)

#### CUSTOM_RAND_GENERATE_SEED

Allows user to define custom function equivalent to `wc_GenerateSeed(byte* output, word32 sz)`.

#### CUSTOM_RAND_GENERATE_BLOCK

Allows user to define custom random number generation function. `random.c` calls the function directly, so its prototype must be visible when wolfSSL is compiled and the function must be linked in. Examples of use are as follows.

With configure, put the prototype in a header and add it to `CFLAGS` with `-include` (GCC and Clang). A static library does not need the function until the application is linked:

```sh
./configure --disable-hashdrbg --enable-static --disable-shared \
    CFLAGS="-DCUSTOM_RAND_GENERATE_BLOCK=custom_rand_generate_block -include /path/to/custom_rand.h"
```

Or in `user_settings.h`:

```c
/* RNG */
/* #define HAVE_HASHDRBG */
#define CUSTOM_RAND_GENERATE_BLOCK custom_rand_generate_block
extern int custom_rand_generate_block(unsigned char* output, unsigned int sz);
```

#### WC_NO_RNG

Disables all RNG (Random Number Generator) support. Use when the application provides its own random data or when no randomness is needed (e.g., deterministic operations only).

#### HAVE_HASHDRBG

Enables the Hash-based Deterministic Random Bit Generator (DRBG) per NIST SP 800-90A. This is the default RNG implementation in wolfSSL using SHA-256 as the underlying hash.

#### WC_RNG_BLOCKING

Makes RNG operations blocking, retrying on transient failures rather than returning an error. Useful on platforms where the entropy source may temporarily be unavailable.

#### WC_VERBOSE_RNG

Enables verbose debug output for RNG operations. Prints detailed information about seed generation, DRBG state, and health test results.


#### WC_X25519_NONBLOCK

Enables non-blocking X25519 key agreement operations. Allows X25519 computations to yield and resume, useful for cooperative multitasking.

#### WC_RNG_SEED_CB

Enables a custom seed callback function for the DRBG. Allows the application to provide its own entropy source via `wc_SetSeed_Cb()`.

#### WC_RNG_SEED_DEVICE

Names a device node, for example `/dev/hwrng`, that the DRBG seeds itself from before the usual seed sources are tried. It is a string definition, e.g. `-DWC_RNG_SEED_DEVICE='"/dev/hwrng"'`.

#### HAVE_WC_RNG_BANK

Enables the RNG bank facility (`rng_bank`). It pre-generates random data so later requests are answered from a buffer. The macro used to be called `WC_RNG_BANK_SUPPORT`; wolfSSL 5.9.4 renamed it and brought the facility up to SP 800-90 semantics as used in the kernel: seed pools, next-seed generation, RBG-C constructions, plus lock and debug statistics options.

#### WC_RNG_WANT_BANKREF_SUPPORT

Turns on the bank reference mechanism in the RNG bank. Needs `HAVE_WC_RNG_BANK` and never comes on in FIPS builds.

#### WC_RNG_NO_AUTO_LOCK

wolfSSL 5.9.4 gives each `WC_RNG` its own lock so a single RNG can be shared between threads. The lock is on by default where the build supports it. Define this macro, or pass [`--disable-rng-autolock`](#--disable-rng-autolock), to turn it off. TLS performance does not change either way, each `WOLFSSL` object has its own RNG.

#### WC_RNG_AUTOFORK

wolfSSL 5.9.4 installs POSIX conforming `pthread_atfork()` handlers in wolfCrypt so a forked child can keep using its `WC_RNG` without falling back to the parent's DRBG state. configure and CMake define the macro on platforms that support it (Apple platforms do not use it). The handlers need the per-instance RNG lock. Leave it undefined with [`--disable-rng-autofork`](#--disable-rng-autofork).

#### WC_PUF_BCH_T

Error-correction strength for the SRAM PUF. It picks the BCH(127,k,t) profile: t=7 (k=78), t=10 (k=64, the default, wire compatible with earlier releases), t=13 (k=50) or t=15 (k=36). A larger t corrects more bit flips per 127-bit codeword but costs entropy. Enrollment and reconstruction have to use the same `WC_PUF_BCH_T` and `WC_PUF_NUM_CODEWORDS`, so store `WC_PUF_PROFILE_ID` together with the helper data. New in wolfSSL 5.9.4.

#### WC_PUF_NUM_CODEWORDS

How many BCH codewords the SRAM PUF uses (16 by default). More codewords mean more raw SRAM and larger helper data in exchange for more total derived-key entropy. The default matches earlier releases byte for byte.

#### WC_PUF_HW_MIN_PCT and WC_PUF_HW_MAX_PCT

The Hamming weight band, in percent, a raw SRAM PUF readout has to fall in (35% to 65% by default). wolfSSL 5.9.4 made `wc_PufReadSram()` health test the readout: a degenerate one, such as all-zero or all-one 128-bit blocks, a block that repeats the previous one, or a Hamming weight outside the band, is rejected with `PUF_READ_E`, and `wc_PufEnroll()` and `wc_PufReconstruct()` will not run on top of it. Use `wc_PufCheckSram()` to check a candidate region, and widen the band if your silicon needs it. Helper data enrolled with 5.9.2 is still valid.

#### WOLFSSL_RNG_USE_FULL_SEED

Non-FIPS builds only. Passes the whole gathered seed buffer to the DRBG instead of gathering an extra `SEED_BLOCK_SZ` bytes and reserving that first block for the seed health test. The seed size is not fixed: it is `RNG_SECURITY_STRENGTH * ENTROPY_SCALE_FACTOR / 8` bytes (256 bits by default in non-FIPS builds).

#### WOLFSSL_GENSEED_FORTEST

Uses a deterministic seed source for testing purposes. WARNING: This produces predictable random output and must never be used in production.

#### WOLFSSL_KEEP_RNG_SEED_FD_OPEN

Keeps the `/dev/random` or `/dev/urandom` file descriptor open between seed operations instead of opening and closing it each time. Reduces overhead on systems with frequent reseeding.

#### CUSTOM_RAND_GENERATE

Allows the user to define a custom random word generator function. The function should return a single random word (`unsigned int`).

#### CUSTOM_RAND_GENERATE_SEED_OS

Allows the user to define a custom OS-level seed generator function, replacing the default platform-specific `GenerateSeed()` while still using the wolfSSL DRBG on top.

#### HAVE_ENTROPY_MEMUSE

Enables the memory-use based entropy source. This entropy source measures timing variations in memory access patterns (cache hits/misses) to generate entropy for DRBG seeding.

#### ENTROPY_MEMUSE_FORCE_FAILURE

Forces the memory-use entropy source to fail. Used for testing error handling paths in the entropy collection code.

#### HAVE_GETRANDOM

Indicates that the Linux `getrandom()` syscall is available for entropy collection. Automatically detected on supported platforms.

#### WOLFSSL_GETRANDOM

Enables use of the `getrandom()` syscall as the entropy source for DRBG seeding on Linux systems. More reliable than reading from `/dev/urandom` as it blocks until sufficient entropy is available.

#### FORCE_FAILURE_GETRANDOM

Forces the `getrandom()` syscall to fail. Used for testing fallback entropy source paths.

#### NO_DEV_URANDOM

Disables use of `/dev/urandom` for random seeding. When defined along with [`NO_DEV_RANDOM`](#no_dev_random), an alternative seed source must be provided.

#### HAVE_AMD_RDSEED

Enables use of AMD's RDSEED instruction for direct hardware entropy. Similar to [`HAVE_INTEL_RDSEED`](#have_intel_rdseed) but for AMD processors.

#### IDIRECT_DEV_RANDOM

On iDirect platforms, seeds the DRBG from the platform's `getRandom()` function instead of `/dev/random`.

#### WIN_REUSE_CRYPT_HANDLE

Reuses the Windows `CryptContext` handle between random number generation calls instead of acquiring and releasing it each time. Improves performance on Windows.

#### WC_RNG_SEED_APT_CUTOFF

Sets the cutoff value for the DRBG Adaptive Proportion Test (APT). The APT detects degradation in the entropy source by checking if any single value appears too frequently within a window.

#### WC_RNG_SEED_APT_WINDOW

Sets the window size for the DRBG Adaptive Proportion Test (APT). Defines how many samples are examined in each test window.

#### WC_RNG_SEED_RCT_CUTOFF

Sets the cutoff value for the DRBG Repetition Count Test (RCT). The RCT detects catastrophic entropy source failure by checking for consecutive identical outputs.

#### STM32_RNG

Enables the STM32 hardware Random Number Generator peripheral for entropy collection.

#### STM32_NUTTX_RNG

Enables STM32 hardware RNG access through the NuttX RTOS `/dev/random` interface.

#### WOLFSSL_STM32F427_RNG

Enables hardware RNG support specific to the STM32F427 microcontroller.

#### WOLFSSL_STM32_RNG_NOLIB

Enables direct register access to the STM32 RNG peripheral without using the STM32 HAL library. Useful for bare-metal deployments.

#### WOLFSSL_PIC32MZ_RNG

Enables the Microchip PIC32MZ hardware Random Number Generator for entropy collection.

#### FREESCALE_RNGA

Enables the Freescale/NXP RNGA (Random Number Generator Accelerator) hardware peripheral.

#### FREESCALE_K70_RNGA

Enables RNGA support specific to the Freescale/NXP Kinetis K70 microcontroller family.

#### FREESCALE_RNGB

Enables the Freescale/NXP RNGB (Random Number Generator version B) hardware peripheral.

#### FREESCALE_KSDK_2_0_RNGA

Enables Freescale/NXP RNGA through the KSDK 2.0 SDK driver interface.

#### FREESCALE_KSDK_2_0_TRNG

Enables Freescale/NXP TRNG (True Random Number Generator) through the KSDK 2.0 SDK driver interface.

#### MAX3266X_RNG

Enables the Maxim MAX3266X hardware Random Number Generator.

#### QAT_ENABLE_RNG

Enables hardware RNG through the Intel QuickAssist Technology (QAT) accelerator.

#### WOLFSSL_ATECC_RNG

Enables hardware RNG from the Microchip ATECC508A/ATECC608A secure element.

#### WOLFSSL_SILABS_TRNG

Enables the Silicon Labs True Random Number Generator (TRNG) for entropy collection.

#### WOLFSSL_SCE_NO_TRNG

Disables the TRNG on Renesas Secure Crypto Engine (SCE). AES and other SCE features remain available but RNG uses a software implementation.

#### WOLFSSL_SCE_TRNG_HANDLE

Specifies the Renesas SCE TRNG handle to use for random number generation.

#### WOLFSSL_SE050_NO_TRNG

Disables the TRNG on NXP SE050 secure element. Other SE050 crypto operations remain available.

#### WOLFSSL_PSA_NO_RNG

Disables RNG through the Platform Security Architecture (PSA) crypto API. Use when PSA is enabled but RNG should use a different source.

#### HAVE_IOTSAFE_HWRNG

Enables hardware RNG from an IoT-Safe compliant SIM card or secure element.

#### WOLFSSL_XILINX_CRYPT_VERSAL

Enables crypto hardware support on Xilinx Versal platforms, including the hardware TRNG for entropy collection.

#### NO_PUBLIC_GCM_SET_IV

Use this if you have done your own custom hardware port and not provided a public implementation of [`wc_AesGcmSetIV()`](group__AES.md#function-wc_aesgcmsetiv)

#### NO_PUBLIC_CCM_SET_NONCE

Use this if you have done your own custom hardware port and not provided a public implementation of [`wc_AesCcmSetNonce()`](group__AES.md#function-wc_aesccmsetnonce)

#### NO_GCM_ENCRYPT_EXTRA

Use this if you have done your own custom hardware port and not provided an implementation of `wc_AesGcmEncrypt_ex()`

#### WOLFSSL_STM32[F1 | F2 | F3 | F4 | F7 | L4 | L5 | WB | WBA | WL | G0 | G4 | H5 | H7 | H7S | U0 | U3 | U5 | MP13 | N6 | C5 | V8]

Use one of these defines when building for the appropriate STM32 device family (<https://www.st.com/>). Each of them also enables STM32 hardware crypto (`STM32_CRYPTO`), hash (`STM32_HASH`, `STM32_HMAC`) and RNG (`STM32_RNG`) support in wolfSSL, unless the matching [`NO_STM32_CRYPTO`](#no_stm32_crypto), [`NO_STM32_HASH`](#no_stm32_hash), `NO_STM32_HMAC` or [`NO_STM32_RNG`](#no_stm32_rng) is defined. Update `wolfssl-root/wolfssl/wolfcrypt/settings.h` section with regards to the wolfSSL porting guide (<https://www.wolfssl.com/docs/porting-guide/>) as appropriate.

#### WOLFSSL_STM32_CUBEMX

When using the CubeMX tool to generate Hardware Abstraction Layer (HAL) API's use this setting to add appropriate support in wolfSSL.

#### WOLFSSL_MX2_CONF_INCLUDE

STM32CubeMX2 (MX2) support, new in wolfSSL 5.9.4. If defined, wolfSSL picks up the MX2 generated configuration header on its own.

#### WOLFSSL_STM32V8

Enables hardware crypto support for the STM32V8 family (Cortex-M85, Armv8.1-M). Validated on the NUCLEO-V873XJ, this is new in wolfSSL 5.9.4.

#### WOLFSSL_CUBEMX_USE_LL

When using the CubeMX tool to generate APIs there are two options, HAL (Hardware Abstraction Layer) or Low Layer (LL). Use this define to control which headers are included in `wolfssl-root/wolfssl/wolfcrypt/settings.h` in the `WOLFSSL_STM32` family section. Currently it only selects the LL RNG header (`stm32l4xx_ll_rng.h`) for STM32L4.

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

#### INTIME_RTOS

Port setting for INtime RTOS.

#### WOLFSSL_SGX

Used when porting to SGX.


#### WOLFSSL_HEAP_TEST

Internal test macro for the static memory heap hint code. A heap hint equal to `(void*)WOLFSSL_HEAP_TEST` makes allocations fall back to the native `malloc()`. Not for production use.

#### WOLFSSL_NO_REALLOC

Disables use of `realloc()` (`XREALLOC` is undefined). Code that resizes buffers uses `XMALLOC()`, a copy and `XFREE()` instead.

### Reducing Memory or Code Usage

#### TFM_TIMING_RESISTANT

Makes fast math ([`USE_FAST_MATH`](#use_fast_math), `tfm.c`) operations constant time (timing resistant). Strongly recommended with `USE_FAST_MATH`. It also lowers stack use by avoiding the large exponentiation windows, which helps on systems with a small stack size.

#### ECC_TIMING_RESISTANT

This is used as a Timing Resistance feature that enables code in ecc.c to prevent side channel and differential power analysis (DPA) attacks.

#### WOLFSSL_WIDE_BYTE

Supports targets where `CHAR_BIT` is not 8, like the TI C2000 C28x DSP family with its 16-bit bytes. It is detected automatically from `CHAR_BIT` when `<limits.h>` is available. New in wolfSSL 5.9.4, validated on the LAUNCHXL-F28P55X.

#### WOLFSSL_NO_CONST_CMP

Removes the public `wc_ConstantCompare()` constant-time comparison wrapper that wolfSSL 5.9.4 added.

#### WC_FIPS_AESGCM_ALLOW_SHORT_NONCES

Since wolfSSL 5.9.4, FIPS builds return `FIPS_BAD_VALUE_E` when AES-GCM encryption gets an IV shorter than 12 bytes. Define this macro to allow short nonces.

#### WOLFSSL_NO_SIGNER_DER_CERT

With `OPENSSL_ALL`, `WOLFSSL_SIGNER_DER_CERT` is now defined so that `X509_STORE_get0_objects()` can return the certificates that were added. Define this macro if you do not want the DER copy of each signer kept.

#### WOLFSSL_SMALL_STACK

Can be used for devices which have a small stack size. Large local variables throughout wolfSSL and wolfCrypt (math, ciphers, ASN, TLS) are moved from the stack to the heap, at some performance cost.

#### WOLFSSL_PTHREADS

Use pthread-based mutex and threading implementations. Auto-detected on most POSIX systems.

#### WOLFSSL_MUTEX_INITIALIZER

Use static mutex initialization (e.g., `PTHREAD_MUTEX_INITIALIZER`) instead of dynamic `pthread_mutex_init`. Useful for reducing initialization overhead.

#### WC_MUTEX_OPS_INLINE

Use inlined mutex operations instead of function calls. Can improve performance on platforms where mutex operations are frequent.

#### WOLFSSL_USE_RWLOCK

Enable reader-writer lock support for improved concurrency in read-heavy workloads.

#### WOLFSSL_THREAD_NO_JOIN

Create threads without join capability (detached threads). Useful on platforms that do not support thread joining.


#### WOLFSSL_THREADED_CRYPT

Lets the application run TLS record encryption (AES-GCM only) for a connection on its own worker threads, using `wolfSSL_AsyncEncrypt()`, `wolfSSL_AsyncEncryptReady()`, `wolfSSL_AsyncEncryptStop()` and `wolfSSL_AsyncEncryptSetSignal()`. Uses pthreads. `WOLFSSL_THREADED_CRYPT_CNT` (default 16) sets the number of encryption slots. Decryption is not covered.

#### WOLFSSL_ALGO_HW_MUTEX

Enable per-algorithm hardware mutex locks for AES, hash, public-key, and RNG operations. Useful when hardware crypto engines require serialized access.

#### WOLFSSL_CRYPT_HW_MUTEX

Master control for hardware crypto mutex initialization. When enabled, provides `wolfSSL_CryptHwMutexInit`, `Lock`, and `UnLock` functions.

#### USE_WOLFSSL_MEMORY

Enable custom memory allocation hooks (`wolfSSL_SetAllocators`). On by default. Allows replacing malloc/realloc/free with custom implementations.

#### WOLFSSL_TRACK_MEMORY

Enable memory allocation tracking and statistics. Useful for profiling memory usage in wolfSSL/wolfCrypt.

#### WOLFSSL_TRACK_MEMORY_VERBOSE

Enable verbose memory tracking output with per-allocation details. Extends [`WOLFSSL_TRACK_MEMORY`](#wolfssl_track_memory).

#### WOLFSSL_MEM_FAIL_COUNT

Count malloc failures for testing. Allows testing error handling paths by failing after a specified number of allocations.

#### WOLFSSL_CHECK_MEM_ZERO

Verify that sensitive memory (key material, etc.) is properly zeroed on free. Debug tool for detecting potential key material leaks.

#### WOLFSSL_GMTIME

Provide a custom gmtime implementation for platforms without standard C library time functions.

#### STRING_USER

User provides all string function implementations. Disables built-in string function wrappers.

#### USE_WOLF_STRTOK

Use wolfSSL's built-in strtok implementation for portability on platforms without strtok_r.

#### USE_WOLF_STRSEP

Use wolfSSL's built-in strsep implementation for portability.

#### USE_WOLF_STRLCPY

Use wolfSSL's built-in strlcpy implementation for portability on platforms without BSD strlcpy.

#### USE_WOLF_STRLCAT

Use wolfSSL's built-in strlcat implementation for portability.

#### USE_WOLF_STRCASECMP

Use wolfSSL's built-in case-insensitive string comparison for portability.

#### USE_WOLF_STRNCASECMP

Use wolfSSL's built-in length-limited case-insensitive string comparison for portability.

#### USE_WOLF_STRDUP

Use wolfSSL's built-in strdup implementation for portability.

#### WOLFSSL_ATOMIC_OPS

Enable atomic operations for thread-safe reference counting and other operations without requiring full mutexes.


#### WOLFSSL_ATOMIC_INITIALIZER

Provides a static initializer for atomic variables used in thread-safe cleanup operations.

#### WOLFSSL_USER_DEFINED_ATOMICS

User-provided atomic operation implementations. Define this when the platform requires custom atomic primitives.

#### WOLFSSL_LEANPSK

Lean PSK (Pre-Shared Key) build with minimal features. Reduces code size by disabling non-essential features.

#### WOLF_C89

Enable C89 compatibility mode. Ensures the codebase compiles with strict C89/ANSI C compilers.

#### ALT_ECC_SIZE

If using fast math and RSA/DH you can define this to reduce your ECC memory consumption. Instead of using stack for ECC points it will allocate from the heap.

#### ECC_SHAMIR

Uses variation of ECC math that is slightly faster, but doubles heap usage. Enabled by default by configure ([`--enable-eccshamir`](#--disable-eccshamir)). To reduce memory, disable it with `--disable-eccshamir`, or leave it undefined in `user_settings.h`.

#### RSA_LOW_MEM

When defined CRT is not used which saves on some memory but slows down RSA operations. It is off by default.

#### WOLFSSL_SHA3_SMALL

When SHA3 is enabled this macro will reduce build size.


#### WOLFSSL_SHUTDOWNONCE

Ensures `wolfSSL_shutdown()` only sends one `close_notify` alert even if called multiple times. Prevents duplicate shutdown messages.

#### WOLFSSL_SHAKE128

Enables SHAKE128 extendable-output function (XOF) based on SHA-3. Provides variable-length output.

#### WOLFSSL_SHAKE256

Enables SHAKE256 extendable-output function (XOF) based on SHA-3. Provides variable-length output.

#### SHA3_BY_SPEC

Uses the literal FIPS 202 form of the Keccak chi step (`a ^ (~b & c)`). By default, wolfSSL uses an algebraically equivalent rewritten form.

#### WC_SHA3_NO_ASM

Disables assembly-optimized SHA-3 implementation. Forces use of the portable C implementation.

#### WC_SHA3_FAULT_HARDEN

Hardens SHA-3 against fault injection attacks by performing redundant computations and verifying consistency.

#### WC_ASYNC_ENABLE_SHA3

Enables asynchronous SHA-3 operations via the wolfSSL async crypto framework.

#### STM32_HASH_SHA3

Enables STM32 hardware SHA-3 acceleration.

#### PSOC6_HASH_SHA3

Enables Cypress/Infineon PSoC6 hardware SHA-3 acceleration.

#### WOLFSSL_SMALL_CERT_VERIFY

Verify the certificate signature without using DecodedCert. Doubles up on some code but allows smaller peak heap memory usage. Cannot be used with [`WOLFSSL_NONBLOCK_OCSP`](#wolfssl_nonblock_ocsp). It is selected by `--enable-lowresource`, `--enable-leantls` and the `cert` / `mutualauth` items of `--enable-tinytls13`. wolfSSL 5.9.4 reports a signature failure before any later parse error (CVE-2026-94418).

#### WOLFSSL_X509_TINY

A minimal-extension X.509 parser profile. The parser only looks at the extensions a chain verification needs; per-feature macros like `WOLFSSL_X509_TINY_SAN_EMAIL`, `WOLFSSL_X509_TINY_SAN_IP` and `WOLFSSL_X509_TINY_NAME_CONSTRAINTS` (which also forces on the SAN forms it checks) turn individual features back on. Shrinks the certificate parser by roughly 6% to 18%. Needs [`WOLFSSL_ASN_TEMPLATE`](#wolfssl_asn_template).

#### WOLFSSL_X509_VERIFY_ONLY

An X.509 verify-only profile. Drops certificate and key generation (unless `WOLFSSL_X509_CERT_GEN` / `WOLFSSL_X509_KEY_GEN` are also defined) and PEM parsing (define `WOLFSSL_X509_PEM` to keep PEM trust anchors).

#### WOLFSSL_NO_ASN_STRICT

Relaxes the RFC 5280 strictness in the certificate parser. wolfSSL 5.9.4 rejects a certificate with trailing bytes after the DER structure unless this macro is defined, and only the certificate itself is copied into `WOLFSSL_X509`. Even with the macro defined, unknown critical extensions, duplicate extensions and directoryName constraints on SANs are still enforced. `--enable-wolfclu` no longer defines it on FIPS builds.

#### GCM_SMALL

Option to reduce AES GCM code size by calculating at runtime instead of using tables. Possible options are: `GCM_SMALL`, `GCM_WORD32`, `GCM_TABLE` or `GCM_TABLE_4BIT`.

#### CURVED25519_SMALL

Defines [`CURVE25519_SMALL`](#curve25519_small) and [`ED25519_SMALL`](#ed25519_small).

#### CURVE25519_SMALL

Use small memory option for curve25519. This uses less memory, but is slower.

#### ED25519_SMALL

Use small memory option for ed25519. This uses less memory, but is slower.

#### USE_SLOW_SHA

Reduces code size by not unrolling loops, which reduces performance for SHA.

#### WC_HASH_DATA_ALIGNMENT

Specifies required data alignment for hash input. Some hardware backends require aligned input buffers.

#### WC_ASYNC_ENABLE_SHA

Enables asynchronous SHA-1 operations via the wolfSSL async crypto framework.

#### WOLFSSL_PIC32MZ_HASH

Enables Microchip PIC32MZ hardware hash acceleration for SHA-1 and SHA-256.

#### WOLFSSL_TI_HASH

Enables Texas Instruments hardware hash acceleration.

#### WOLFSSL_RENESAS_RX64_HASH

Enables Renesas RX64 hardware hash acceleration.

#### FREESCALE_LTC_SHA

Enables Freescale/NXP LTC (Low Power Trusted Cryptography) SHA acceleration.

#### FREESCALE_MMCAU_SHA

Enables Freescale/NXP MMCAU (Memory-Mapped Cryptographic Acceleration Unit) SHA acceleration.

#### PSOC6_HASH_SHA1

Enables Cypress/Infineon PSoC6 hardware SHA-1 acceleration.

#### USE_SLOW_SHA256

Reduces code size by not unrolling loops, which reduces performance for SHA. About 2k smaller and about 25% slower.

#### USE_SLOW_SHA512

Reduces code size by not unrolling loops, which reduces performance for SHA. Over twice as small, but 50% slower.

#### WOLFSSL_NOSHA512_224

Disables the SHA-512/224 variant. Reduces code size when SHA-512/224 is not needed.

#### WOLFSSL_NOSHA512_256

Disables the SHA-512/256 variant. Reduces code size when SHA-512/256 is not needed.

#### USE_SLOW_SHA2

Deprecated alias for [`USE_SLOW_SHA512`](#use_slow_sha512); it only affects SHA-512 and SHA-384. Use [`USE_SLOW_SHA256`](#use_slow_sha256) for SHA-256 and SHA-224.

#### WOLFSSL_HASH_FLAGS

Enables hash flags for tracking hash state (e.g., whether the hash has been finalized). Used by some hardware backends.

#### WOLFSSL_HASH_KEEP

Keeps the hash input data in memory for potential reuse. Allows re-hashing of data without re-feeding it.

#### WC_ASYNC_ENABLE_SHA512

Enables asynchronous SHA-512 operations via the wolfSSL async crypto framework.

#### WC_ASYNC_ENABLE_SHA384

Enables asynchronous SHA-384 operations via the wolfSSL async crypto framework.

#### WOLFSSL_KCAPI_HASH

Enables hash operations through the Linux kernel crypto API (AF_ALG). Offloads SHA and other hashes to the kernel.

#### WOLFSSL_SE050_HASH

Enables hash acceleration on the NXP SE050 secure element.

#### WOLFSSL_SILABS_SHA384

Enables Silicon Labs hardware acceleration for SHA-384.

#### WOLFSSL_SILABS_SHA512

Enables Silicon Labs hardware acceleration for SHA-512.

#### WOLFSSL_ARMASM_CRYPTO_SHA512

Enables ARM crypto extension instructions for SHA-512 acceleration.

#### WOLFSSL_RENESAS_RSIP

Enables Renesas RSIP (Renesas Security IP) hardware acceleration for hashing and crypto operations.

#### ECC_USER_CURVES

Allow user to choose ECC curve sizes that are enabled. Only the 256-bit curve is enabled by default. To enable others use `HAVE_ECC192`, `HAVE_ECC224`, etc...

#### WOLFSSL_SP_NO_MALLOC

In the SP code, always use stack, no heap XMALLOC()/XREALLOC()/XFREE() calls are made.

#### WOLFSSL_SP_NO_DYN_STACK

Disable use of dynamic stack items. Used with small code size and not small stack.

#### WOLFSSL_SP_FAST_MODEXP

Compiles in a faster mod_exp implementation at the expense of code size.

#### WC_DISABLE_RADIX_ZERO_PAD

Disable printing of leading zero in hexadecimal string output. For example, if this macro is defined, the value 8 will be printed as the string "0x8" but if it is not defined it will be printed as "0x08". Defining this macro can reduce code size.

#### WC_ASN_NAME_MAX

This allows overriding the maximum name support for an X.509 certificate field.

#### OPENSSL_EXTRA_X509_SMALL

Special small OpenSSL compat layer for certs.

#### OPENSSL_EXTRA_NO_ASN1

Enables OpenSSL extra compatibility APIs but excludes ASN1 object functions. Useful when ASN1 compatibility is not needed to reduce code size.

### Increasing Performance

#### USE_INTEL_SPEEDUP

Enables use of Intel's AVX/AVX2 instructions for accelerating AES, ChaCha20, Poly1305, SHA256, SHA512, SHA-3/SHAKE, ED25519, Curve25519, ML-KEM, ML-DSA, SLH-DSA, LMS, XMSS and FrodoKEM.

#### WOLFSSL_AESNI

Enables use of AES accelerated operations which are built into some Intel and AMD chipsets. When using this define, the `aes_asm.S` (GCC/Clang, AT&T syntax) or `aes_asm.asm` (MASM, Intel syntax, for Windows) file is used to optimize via the Intel AES new instruction set (AESNI). AES-GCM, AES-XTS and the AVX code paths also need `aes_gcm_asm`, `aes_xts_asm` and `aes_x86_64_asm` (`.S` or `.asm`).

#### WOLFSSL_AESNI_BY4

Enables 4-block parallel AES-NI processing. Processes four AES blocks simultaneously using AES-NI pipelining for improved throughput. Requires [`WOLFSSL_AESNI`](#wolfssl_aesni).

#### WOLFSSL_AESNI_BY6

Enables 6-block parallel AES-NI processing. Processes six AES blocks simultaneously using AES-NI pipelining for maximum throughput. Requires [`WOLFSSL_AESNI`](#wolfssl_aesni).

#### WOLFSSL_AES_SMALL_TABLES

Uses smaller AES S-box lookup tables. Reduces code/data size at the cost of slightly slower AES operations. Useful for memory-constrained embedded targets.

#### WOLFSSL_AES_NO_UNROLL

Disables loop unrolling in AES round functions. Reduces code size at the cost of performance. Useful for constrained environments where code size matters more than speed.

#### WOLFSSL_AES_TOUCH_LINES

Touch all AES table cache lines before lookups to provide side-channel resistance. Mitigates cache-timing attacks by ensuring all table entries are in cache before use.

#### WC_AES_BITSLICED

Enables bitsliced AES implementation. Uses a bitwise-parallel technique that processes multiple blocks simultaneously and provides constant-time execution for side-channel resistance.

#### AES_GCM_GMULT_NCT

Enables non-constant-time GCM GMULT implementation. Faster but not protected against cache-timing side-channel attacks. Only use when side-channel resistance is not required.

#### NO_WOLFSSL_ALLOC_ALIGN

By default, when AES-NI, AF_ALG or Xilinx AES gets a misaligned input or output buffer, wolfSSL allocates a temporary aligned copy. Define this to skip that allocation; misaligned buffers then return `BAD_ALIGN_E`.

#### WC_ASYNC_ENABLE_AES

Enables asynchronous AES operations. Allows AES encrypt/decrypt to be offloaded to hardware accelerators using the wolfSSL async crypto framework.

#### WOLFSSL_DEVCRYPTO

Enables the Linux `/dev/crypto` (cryptodev-linux) interface in `wolfcrypt/src/port/devcrypto/`. The algorithms to offload are selected with `WOLFSSL_DEVCRYPTO_AES`, `WOLFSSL_DEVCRYPTO_CBC`, `WOLFSSL_DEVCRYPTO_HASH` and related macros. Set by [`--enable-devcrypto`](#--enable-devcrypto), which takes `all`, `aes`, `cbc` or `hash`.

#### WOLFSSL_DEVCRYPTO_AES

Enables AES acceleration via Linux `/dev/crypto` interface. Requires [`WOLFSSL_DEVCRYPTO`](#wolfssl_devcrypto).

#### WOLFSSL_DEVCRYPTO_CBC

Enables AES-CBC acceleration via Linux `/dev/crypto` interface. Requires [`WOLFSSL_DEVCRYPTO`](#wolfssl_devcrypto).

#### WOLFSSL_KCAPI_AES

Enables AES operations through the Linux kernel crypto API (AF_ALG). Offloads AES to the kernel's crypto subsystem.

#### WOLFSSL_NO_KCAPI_AES_CBC

Disables AES-CBC through KCAPI when [`WOLFSSL_KCAPI_AES`](#wolfssl_kcapi_aes) is enabled. Useful when only non-CBC AES modes are needed through the kernel crypto API.

#### WOLFSSL_PSA_NO_AES

Disables AES through the Platform Security Architecture (PSA) crypto API. Use when PSA is enabled but AES should use the software implementation instead.

#### WOLFSSL_SCE_NO_AES

Disables AES through the Renesas Secure Crypto Engine (SCE). Use when SCE is enabled but AES should use the software implementation.

#### NO_IMX6_CAAM_AES

Disables AES acceleration on NXP i.MX6 CAAM (Cryptographic Acceleration and Assurance Module). Use when CAAM is enabled but AES should use the software implementation.

#### WOLFSSL_AFALG_XILINX_AES

Enables AES acceleration through AF_ALG on Xilinx platforms. Uses the Xilinx crypto hardware via the Linux AF_ALG interface.

#### NO_WOLFSSL_ESP32_CRYPT_AES

Disables ESP32 hardware AES acceleration. Use when building for ESP32 but AES should use the software implementation.

#### STM32_CRYPTO_AES_ONLY

Restricts STM32 hardware crypto to AES operations only. Other algorithms will use software implementations even when STM32 crypto hardware is available.

#### WC_DEBUG_CIPHER_LIFECYCLE

Adds lifecycle tags to AES contexts and checks them on use, catching use before init and use after free (`BAD_STATE_E`, optionally aborting). In FIPS builds it requires FIPS v6 or later.

#### WOLFSSL_HW_METRICS

Espressif ESP32 only. Counts hardware operations and software fallbacks for SHA, AES and RSA math. Print the counters with `esp_hw_show_metrics()`.

#### HAVE_INTEL_RDSEED

Enable Intel's RDSEED for DRBG seed source.

#### HAVE_INTEL_RDRAND

Enable Intel's RDRAND instruction for wolfSSL's random source.

#### FP_ECC

Enables ECC Fixed Point Cache, which speeds up repeated operations against same private key. Can also define number of entries and LUT bits using `FP_ENTRIES` and `FP_LUT` to reduce default static memory usage.

#### FP_ENTRIES

Defines the number of cache entries (default 15) for the ECC fixed-point multiplication lookup table. Requires [`FP_ECC`](#fp_ecc). Adjust to balance memory usage and performance.

#### FP_LUT

Sets the lookup table bit size (2-12, default 8) for ECC fixed-point precomputation. Larger values use more memory but provide faster verification. Requires [`FP_ECC`](#fp_ecc).

#### FP_ECC_CONTROL

Not defined by default. When defined, SM2 signature verification with SP math ([`WOLFSSL_HAVE_SP_ECC`](#wolfssl_have_sp_ecc) and [`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2)) uses the cached fixed-point path (`sp_ecc_cache_verify_sm2_256()`).

#### HAVE_ECC_CHECK_PUBKEY_ORDER

Enables ECC public key order validation during import to detect invalid keys. Auto-enabled unless [`NO_ECC_CHECK_PUBKEY_ORDER`](#no_ecc_check_pubkey_order) is defined or hardware accelerators are in use.

#### HAVE_ECC_MAKE_PUB

Enables the `wc_ecc_make_pub` function to compute a public key from a private key. Enabled by default.

#### HAVE_ECC_VERIFY_HELPER

Enables ECC signature verification helper functions. Auto-enabled unless hardware accelerators are in use.

#### NO_ECC_CHECK_PUBKEY_ORDER

Disables ECC public key order validation checks during key import. Not recommended for production use as it skips important security validation.

#### WC_NO_CACHE_RESISTANT

Disables cache-resistant operations (conditional swaps) in ECC scalar multiplication to reduce overhead. Not recommended as it may expose operations to cache-based side-channel attacks.

#### WOLFSSL_ECC_NO_SMALL_STACK

Disables `WOLFSSL_SMALL_STACK` optimizations for ECC operations, forcing stack allocation instead of heap. Useful when stack space is plentiful and heap allocation overhead is undesirable.

#### WOLFSSL_PUBLIC_ECC_ADD_DBL

Makes `ecc_projective_add_point` and `ecc_projective_dbl_point` public APIs instead of internal-only functions. Useful for applications that need direct access to ECC point arithmetic.


#### WOLFSSL_PYTHON

Enables APIs and behaviors needed for the Python wolfSSL module compatibility.

#### SQRTMOD_USE_MOD_EXP

Computes square root modulo prime for compressed key decompression using a single modular exponentiation instead of Tonelli-Shanks, which saves stack. Primes that are 1 mod 8 (P-224) are not supported, and primes that are 5 mod 8 (secp224k1) only with `HAVE_ECC_KOBLITZ` or [`WOLFSSL_CUSTOM_CURVES`](#wolfssl_custom_curves). Off by default.

#### WOLFSSL_ECIES_OLD

Uses the original wolfSSL ECIES format where the public key is not included in the shared secret material. Off by default.


#### WOLFSSL_ECDSA_MATCH_HASH

Requires the ECDSA signature hash algorithm to match the curve's preferred hash (e.g., P-256 uses SHA-256, P-384 uses SHA-384).

#### WOLFSSL_ECIES_ISO18033

Uses the ISO 18033 ECIES standard which includes the public key in the shared secret derivation. Off by default.

#### WOLFSSL_ECIES_GEN_IV

Generates a random IV for ECIES encryption instead of deriving it from the KDF output. Off by default.

#### WOLFSSL_ECIES_STATIC_GCM_NONCE

wolfSSL 5.9.4 added AES-GCM as an ECIES data encapsulation mechanism next to AES-CBC/CTR with HMAC, including ECIES crypto callbacks and `devId` threading. This macro allows the AES-GCM DEM in the default IV mode, where the GCM nonce is a fixed all-zero value. That is only safe because ECIES derives a fresh key from a fresh ephemeral key for each message. Without this macro, AES-GCM in the default IV mode returns `NOT_COMPILED_IN`. It is not needed with [`WOLFSSL_ECIES_GEN_IV`](#wolfssl_ecies_gen_iv) (random nonce) or [`WOLFSSL_ECIES_OLD`](#wolfssl_ecies_old) (KDF-derived nonce).

#### WOLFSSL_SP_521

Enables the single-precision (SP) math optimized implementation for the P-521 ECC curve. Off by default. Enabled by `--enable-sp` and its variants (for example `--enable-sp=521`, `ec521`, `p521`) on 64-bit Intel/ARM targets, by the CMake equivalent, or by defining it manually in `user_settings.h`. It is **not** auto-enabled by the headers from [`WOLFSSL_SP_MATH`](#wolfssl_sp_math) / [`WOLFSSL_SP_MATH_ALL`](#wolfssl_sp_math_all) together with `HAVE_ECC521`; defining `WOLFSSL_SP_521` instead forces `HAVE_ECC521` on, but only when [`WOLFSSL_SP_MATH`](#wolfssl_sp_math) is used and `ECC_USER_CURVES` is not defined (configure adds `-DHAVE_ECC521` itself). Note that `WOLFSSL_SP_MATH_ALL` alone still provides working (unoptimized, generic) P-521 support; `WOLFSSL_SP_521` adds the curve-specific optimized path.

#### WOLFSSL_SP_SM2

Enables single-precision (SP) math optimized implementation for the SM2 curve (Chinese cryptographic standard). configure defines it when `--enable-sm2` is used with SP ECC; with `user_settings.h` it must be defined explicitly alongside [`WOLFSSL_SM2`](#wolfssl_sm2).

#### WOLF_CRYPTO_CB_ONLY_ECC

Restricts ECC operations to use only crypto callbacks, disabling all software ECC implementations. Useful when all ECC operations should be delegated to hardware or an external module. Off by default.

#### WC_ASYNC_ENABLE_ECC

Enables asynchronous (non-blocking) ECC operations with crypto callbacks. Requires [`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt). Off by default.

#### WC_ASYNC_ENABLE_ECC_KEYGEN

Enables asynchronous ECC key generation, allowing key generation to be offloaded to hardware accelerators. Requires [`WOLFSSL_ASYNC_CRYPT`](#wolfssl_async_crypt). Off by default.

#### PLUTON_CRYPTO_ECC

Enables use of the Microsoft Pluton security processor for ECC operations. Off by default.

#### WOLFSSL_CAAM_BLACK_KEY_SM

Uses NXP CAAM secure memory for encrypted black key storage in ECC operations. Off by default.

#### WOLFSSL_KCAPI_ECC

Offloads ECC operations to the Linux Kernel Crypto API (kcAPI) for hardware acceleration. Off by default.

#### WOLFSSL_ASYNC_CRYPT

This enables support for asynchronous cryptography using hardware based adapters such as the Intel QuickAssist or Marvell (Cavium) Nitrox V. The asynchronous framework is part of wolfSSL since v5.8.4 (`wolfcrypt/src/async.c`) and is enabled with [`--enable-asynccrypt`](#--enable-asynccrypt). Without a hardware backend a software backend ([`WOLFSSL_ASYNC_CRYPT_SW`](#wolfssl_async_crypt_sw)) using wolfCrypt is used. The hardware backends are Intel QuickAssist (QAT 1.6 and 1.7 drivers) and Cavium Nitrox III and V. See `README-async.md`.

#### WOLFSSL_NO_ASYNC_IO

This disables the asynchronous I/O networking. Asynchronous I/O is on by default and can take up to around 140 bytes during the handshaking process. If your network interface doesn't return `SOCKET_EWOULDBLOCK` or `SOCKET_EAGAIN` (or `WOLFSSL_CBIO_ERR_WANT_WRITE` for custom I/O callbacks) on writing you can define `WOLFSSL_NO_ASYNC_IO` to have wolfSSL not save the state while building handshake messages.

### GCM Performance Tuning

There are 4 variants of GCM performance:

* `GCM_SMALL` - Smallest footprint, slowest (FIPS validated)
* `GCM_WORD32` - Medium (FIPS validated)
* `GCM_TABLE` - Fast (FIPS validated)
* `GCM_TABLE_4BIT` - Fastest (FIPS validated)

With configure, select one with `--enable-aesgcm=small`, `--enable-aesgcm=word32`, `--enable-aesgcm=table` or `--enable-aesgcm=4bit` (see [`--enable-aesgcm`](#--enable-aesgcm)). `--enable-lowresource` selects `GCM_SMALL`. With `user_settings.h`, define the macro directly.

### wolfSSL's Math Options

wolfSSL has the following multi-precision math options:

* Single Precision (SP) Math All ([`WOLFSSL_SP_MATH_ALL`](#wolfssl_sp_math_all), `sp_int.c`): the default
* Single Precision (SP) Math with a restricted set of key sizes and curves ([`WOLFSSL_SP_MATH`](#wolfssl_sp_math))
* Fast Math ([`USE_FAST_MATH`](#use_fast_math), `tfm.c`): legacy, disabled by default
* Big Integer (heap) Math ([`USE_INTEGER_HEAP_MATH`](#use_integer_heap_math), `integer.c`): disabled by default
* No multi-precision math library ([`NO_BIG_INT`](#no_big_int))

Only one of these can be used in a build. If none is selected, `settings.h` defines `WOLFSSL_SP_MATH_ALL`, and configure also uses SP math all by default. FIPS 140-2 builds default to Fast Math instead.

Single Precision (SP) Math Library is our recommended library and the default. It is implemented using both C and assembly. As such, it has optimizations for specific architectures. All math variables are instantiated on the stack, leading to less heap usage. It is always timing resistant. It is generally optimized for speed at the cost of code size, but is highly configurable to compile out unneeded code. We have taken it through DO-178C certifications.

Fast Math Library is the legacy back end. It is disabled by default and must be selected with [`--enable-fastmath`](#--enable-fastmath) or `USE_FAST_MATH`, and it cannot be used with `--enable-linuxkm` (it exceeds the kernel stack limit). It is implemented using both C and assembly. As such, it has optimizations for specific architectures. All math variables are instantiated on the stack, leading to less heap usage. It can be made timing resistant if the `TFM_TIMING_RESISTANT` macro is defined. We have taken it through FIPS 140-2 and 140-3 certifications.

Big Integer Library is the most portable option as it is written in C without any assembly. As such it is not optimized for specific architectures. All math variables are instantiated on the heap; minimal stack usage. Unfortunately, Big Integer Library is not timing resistant.

#### Big Integer Math Library

##### USE_INTEGER_HEAP_MATH

Selects the heap based Big Integer math library (`integer.c`). It is not enabled by default and is not timing resistant. Enable it with `--enable-heapmath` or `CFLAGS=-DUSE_INTEGER_HEAP_MATH`. It cannot be used with [`WOLFSSL_STATIC_MEMORY`](#wolfssl_static_memory).

Forked from public domain LibTomMath library. For more information about LibTomMath, please see <https://www.libtom.net/LibTomMath/>. Please note that our fork is considerably more active and secure than the original public domain code.

This library is generally the most portable and easiest to get going with. The negatives to the normal big integer library are that it is slower, it uses a lot of heap memory as all memory is allocated from the heap, requires an `XREALLOC()` implementation, and is not timing resistant. The implementation can be found in `integer.c`.

#### NO_BIG_INT

Build without any multi-precision math library. RSA, DH, DSA and ECC need one, so they have to be disabled as well. configure defines `NO_BIG_INT` when SP math, SP math all, fast math and heap math are all disabled.

#### Fast Math

##### USE_FAST_MATH

Forked from public domain LibTomFastMath library. For more information about LibTomFastMath, please see <https://www.libtom.net/TomsFastMath>. Please note that our fork is considerably more active and secure than the original public domain code from LibTomFastMath. We have improved performance, security and code quality. Also we have taken the FastMath code through  FIPS 140-2 and 140-3 certifications.

The FastMath library uses assembly if possible, and will speed up asymmetric private/public key operations like RSA, DH, and DSA. Assembly inclusion is dependent on compiler and processor combinations. Some combinations will need additional configure flags and some may not be possible. Help with optimizing FastMath with new assembly routines is available on a consulting basis. See the Architecture-Specific Optimizations.

For FastMath, all memory is allocated on the stack. Because the stack memory usage can be larger when using FastMath, we recommend defining [`TFM_TIMING_RESISTANT`](#tfm_timing_resistant) as well when using this option. The FastMath code is timing resistant if TFM_TIMING_RESISTANT is defined. This will reduce some of the large math windows for constant time, which use less memory. This uses less stack because there are no shortcuts and therefore less branching during private key operations. This also makes the implementation more secure as timing attacks are a real threat and can give malicious third parties enough information to reproduce the private key.

For GCC builds without debug, configure adds `-O2` for fast math and for SP builds that do not use one of the small `--enable-sp` variants (such as `--enable-sp=small`), and `-Os` otherwise. `--enable-fasthugemath` also adds `-funroll-loops -DTFM_SMALL_SET -DTFM_HUGE_SET`. If you're using a different compiler you may need to add optimization flags manually to `CFLAGS` during configure.

FastMath also changes the way dynamic and stack memory are used. The Big Integer (heap) math library (`integer.c`) uses dynamic memory for big integers. FastMath uses fixed size buffers that hold 4096 bit integers by default (the `tfm.h` default), allowing for 2048 bit by 2048 bit multiplications. `settings.h` raises the default to 8192 bits for x86_64 and AArch64 builds and for `OPENSSL_EXTRA` builds, and FIPS 140-2 builds also default to 8192. If you need 4096 bit by 4096 bit multiplications then change `FP_MAX_BITS` in `wolfssl/wolfcrypt/tfm.h`. As `FP_MAX_BITS` is increased, this will also increase the runtime stack usage since the buffers used in the public key operations will now be larger. `FP_MAX_BITS` needs to be double the max key size. For example if your biggest key is 2048-bit, `FP_MAX_BITS` should be 4096 and if it is 4096-bit `FP_MAX_BITS` should be 8192. If using ECC only this can be reduced to the maximum ECC key size times two. A couple of functions in the library use several temporary big integers, meaning the stack can get relatively large. This should only come into play on embedded systems or in threaded environments where the stack size is set to a low value. If stack corruption occurs with FastMath during public key operations in those environments, increase the stack size to accommodate the stack usage.

If you are enabling FastMath without using the autoconf system, you'll need to define `USE_FAST_MATH` and make sure `tfm.c` is compiled. `integer.c` and `sp_int.c` guard themselves and compile to nothing, so they do not need to be removed from the build. Defining `ALT_ECC_SIZE` will allocate ECC points only from the heap instead of the stack.

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

`TFM_X86_64` and `TFM_X86` are detected automatically from the compiler target unless `TFM_NO_ASM` is defined. `TFM_AARCH_64` is also defined automatically for Apple AArch64 builds, but it only selects 64-bit digits; there is no AArch64 assembly for fast math. If none of these are defined or TFM_NO_ASM is defined, then `TFM_ISO` will be defined and ISO C portable code will be used.

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

SP math is our recommended default option and has been taken through DO-178C certifications. `sp_int.c` is the general multi-precision code (SP math all). The other files are fixed-size implementations that speed up public key operations for specific key sizes and curves that are common. They are turned on with [`--enable-sp`](#--enable-spopt) or with [`WOLFSSL_HAVE_SP_RSA`](#wolfssl_have_sp_rsa), [`WOLFSSL_HAVE_SP_DH`](#wolfssl_have_sp_dh) and [`WOLFSSL_HAVE_SP_ECC`](#wolfssl_have_sp_ecc). Make sure to include the correct code files such as:

* `sp_c32.c`
* `sp_c64.c`
* `sp_arm32.c`
* `sp_arm64.c`
* `sp_armthumb.c`
* `sp_cortexm.c`
* `sp_dsp32.c` (Qualcomm Hexagon DSP)
* `sp_int.c`
* `sp_riscv64.c`
* `sp_x86_64.c`
* `sp_x86_64_asm.S`
* `sp_x86_64_asm.asm`
* `sp_sm2_*.c` and `sp_sm2_x86_64_asm.S` (SM2 curve, see [`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2))

##### WOLFSSL_SP_MATH

Enable only SP math and algorithms. Eliminates big integer math code such as normal (`integer.c`) or fast (`tfm.c`). Restricts key sizes and curves to only ones supported by SP.

##### WOLFSSL_SP_MATH_ALL

The default math library. `sp_int.c` provides general multi-precision math for all algorithms and key sizes, replacing `integer.c` and `tfm.c`. Key sizes and curves with an optimized SP implementation use it; other sizes use the generic code. Always constant time. Cannot be combined with [`WOLFSSL_SP_MATH`](#wolfssl_sp_math).

##### WOLFSSL_SP_SMALL

If using SP math this will use smaller versions of the code and avoid large stack variables.

##### SP_WORD_SIZE

Force the word size (8, 16, 32 or 64 bits) used to store one digit of a number.

##### WOLFSSL_SP_NONBLOCK

Enables "non blocking" mode for Single Precision math, which will return `MP_WOULDBLOCK` (`FP_WOULDBLOCK` is an alias) for long operations and function must be called again until complete. It is supported for ECC (`WC_ECC_NONBLOCK`), RSA ([`WC_RSA_NONBLOCK`](#wc_rsa_nonblock)) and DH (`WC_DH_NONBLOCK`). RSA and DH non-blocking also need [`WOLFSSL_SP_SMALL`](#wolfssl_sp_small) and [`WOLFSSL_SP_NO_MALLOC`](#wolfssl_sp_no_malloc), and cannot be used with [`WOLFSSL_SP_FAST_MODEXP`](#wolfssl_sp_fast_modexp).

##### WOLFSSL_SP_FAST_NCT_EXPTMOD

Enables the faster non-constant time modular exponentiation implementation. Will only be used for public key operations; not private key operations.

##### WOLFSSL_SP_INT_NEGATIVE

Allows multi-precision numbers to be negative. (Not required for cryptographic operations.)

##### WOLFSSL_SP_INT_DIGIT_ALIGN

Enable when unaligned access of sp_int_digit pointer is not allowed.

##### WOLFSSL_HAVE_SP_RSA

Enables Single Precision (SP) math optimizations for RSA operations, which give significant performance improvements for the common key sizes. 2048 and 3072 bit are included by default (disable with `WOLFSSL_SP_NO_2048` / `WOLFSSL_SP_NO_3072`), and 4096 bit needs `WOLFSSL_SP_4096`.

##### WOLFSSL_HAVE_SP_DH

Single Precision DH for 2048, 3072 and 4096 bit. The same `WOLFSSL_SP_NO_2048`, `WOLFSSL_SP_NO_3072` and `WOLFSSL_SP_4096` settings apply.

##### WOLFSSL_HAVE_SP_ECC

Single Precision ECC: P-256 by default (disable with `WOLFSSL_SP_NO_256`), P-384 with `WOLFSSL_SP_384`, P-521 with [`WOLFSSL_SP_521`](#wolfssl_sp_521), SM2 with [`WOLFSSL_SP_SM2`](#wolfssl_sp_sm2), and the 1024-bit SAKKE curve with `WOLFSSL_SP_1024`.

##### WOLFSSL_SP_LARGE_CODE

Allows Single-Precision (SP) speedups that come at the cost of larger binary size. Might not be appropriate for some embedded platforms.

##### WOLFSSL_SP_DIV_WORD_HALF

Indicates that division using a double length word isn't available. For example, on 32-bit CPUs, if you do not want to compile in a 64-bit division from a library, then defining this macro turn on an implementation where the divide is done using half word size portions.

##### WOLFSSL_SP_DIV_32

Avoids 64-bit divides. Defining it also defines [`WOLFSSL_SP_DIV_WORD_HALF`](#wolfssl_sp_div_word_half) (in `sp_int.h`), and the Hexagon DSP code (`sp_dsp32.c`) uses it to select a word division that does not use a 64-bit divide.

##### WOLFSSL_SP_DIV_64

Has no effect. `settings.h` defines it for some platforms, but no code tests it. On targets without a double-width divide use [`WOLFSSL_SP_DIV_WORD_HALF`](#wolfssl_sp_div_word_half).

##### WOLFSSL_SP_ASM

Enables Single-Precision (SP) platform specific assembly code implementations that are faster, for maximum performance of RSA, ECC and DH operations on supported platforms (x86_64, ARM, RISC-V). With [`--enable-sp-asm`](#--enable-sp-asm) the platform is detected by configure. It is also defined automatically when one of the platform specific `WOLFSSL_SP_*_ASM` macros below is defined.

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

##### WOLFSSL_SP_RISCV64_ASM

Enable Single-Precision (SP) RISC-V 64-bit assembly implementation (`sp_riscv64.c`). configure sets it for `--enable-sp-asm` on riscv64 targets.

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

##### SP_INT_BITS

The number of bits in an sp_int, which sets the largest number the library can handle. If it is not set, `settings.h` uses 4096 for SP math all on x86_64, AArch64 and `OPENSSL_EXTRA` builds (8192 with `WOLFSSL_MYSQL_COMPATIBLE`, larger if the FFDHE groups compiled in need it). Otherwise `sp_int.h` derives it from the enabled algorithms, for example 3072 for RSA/DH (4096 with `WOLFSSL_SP_4096`) or the largest curve size for ECC-only builds. configure can also set it, for example from `--with-max-rsa-bits`.


### Stack or Chip Specific Defines

wolfSSL can be built for a variety of platforms and TCP/IP stacks. Most of the following defines are located in `./wolfssl/wolfcrypt/settings.h` and are commented out by default. Each can be uncommented to enable support for the specific chip or stack referenced below.

#### IPHONE

Can be defined if building for use with iOS.

#### THREADX

Can be defined when building for use with the ThreadX RTOS (<https://www.rtos.com>).

#### MICRIUM

Can be defined when building wolfSSL to enable support for Micrium's uC/OS-III RTOS (<https://www.micrium.com>).

#### MBED

Can be defined when building for the mbed prototyping platform (<https://www.mbed.org>).

#### MICROCHIP_PIC32

Can be defined when building for Microchip's PIC32 platform (<https://www.microchip.com>).

#### MICROCHIP_TCPIP_V5

Can be defined for version 5 of the Microchip TCP/IP stack.

#### MICROCHIP_TCPIP

Can be defined for microchip tcp/ip stack version 6 or later.

#### MICROCHIP_TCPIP_BSD_API

Can be defined together with [`MICROCHIP_PIC32`](#microchip_pic32) when the Microchip TCP/IP stack is used through its BSD socket API. `MICROCHIP_PIC32` then does not define `WOLFSSL_USER_IO`, so wolfSSL uses its built-in socket I/O callbacks instead of requiring your own.

#### WOLFSSL_MICROCHIP_PIC32MZ

Can be defined for PIC32MZ hardware cryptography engine.

#### FREERTOS

Can be defined when building for FreeRTOS (<https://www.freertos.org>). If using LwIP, define [`WOLFSSL_LWIP`](#wolfssl_lwip) as well.

#### FREERTOS_WINSIM

Can be defined when building for the FreeRTOS windows simulator (<https://www.freertos.org>).

#### WOLFSSL_CHIBIOS

Can be defined when building for ChibiOS RTOS.

#### WOLFSSL_CMSIS_RTOS

Can be defined when building for Arm CMSIS-RTOS.

#### WOLFSSL_CMSIS_RTOSv2

Can be defined when building for Arm CMSIS-RTOS v2.

#### WOLFSSL_LWIP_NATIVE

Use in platforms for LWIP native.

#### WOLFSSL_DEOS

You can enable the wolfSSL support for Deos RTOS available [here](https://www.ddci.com/products_deos_do_178c_arinc_653/) using this define.

#### WOLFSSL_ESPIDF

Can be defined when building for ESP-IDF.

#### WOLFSSL_ESP32

Can be defined, together with [`WOLFSSL_ESPIDF`](#wolfssl_espidf), when building for an Espressif ESP32 family chip (the ESP-IDF example projects under `IDE/Espressif` define it for every ESP32 family target, such as the ESP32, ESP32-S3 and ESP32-C3). It turns on the ESP32 hardware acceleration (`WOLFSSL_ESP32_CRYPT`) for AES and SHA, and for RSA math when `ESP32_USE_RSA_PRIMITIVE` is also defined, unless `NO_ESP32_CRYPT` is defined; single algorithms can be left to software with, for example, [`NO_WOLFSSL_ESP32_CRYPT_AES`](#no_wolfssl_esp32_crypt_aes). The RNG is seeded from `esp_random()`. The old name `WOLFSSL_ESPWROOM32` also defines it.

#### WOLFSSL_ESPWROOM32SE

Can be defined, together with [`WOLFSSL_ESPIDF`](#wolfssl_espidf), when building for the ESP32-WROOM-32SE module, which has a Microchip ATECC608A secure element. `settings.h` and the RNG seed treat it like [`WOLFSSL_ESP32`](#wolfssl_esp32), and the newer ESP-IDF example `user_settings.h` files define `WOLFSSL_ESP32` for it as well. To use the ATECC608A, also define `WOLFSSL_ATECC508A` and `HAVE_PK_CALLBACKS`, as the example `IDE/Espressif/ESP-IDF/user_settings.h` does, and link the Microchip CryptoAuthLib (see `IDE/Espressif/ESP-IDF/README_32se.md`).

#### WOLFSSL_LINUXKM

Use if building for Linux Kernel Module.

#### WORD64_AVAILABLE

Portability macro to indicate 64-bit types are supported. Typically it is better to define `SIZEOF_LONG_LONG` as 8.

#### WOLFSSL_NUCLEUS_1_2

Use if building for Nucleus 1.2.

#### NUCLEUS_PLUS_2_3

Use if building for Nucleus PLUS 2.3. Unless `WOLFSSL_USER_SETTINGS` is defined, `settings.h` then includes `nucleus.h` and the Nucleus configuration header `os/networking/ssl/lite/cyassl_nucleus_defs.h`, which plays the role of `user_settings.h`. The built-in socket I/O uses the Nucleus networking API, including `select` for DTLS timeouts.

#### WOLFSSL_RENESAS_RA6M3G

Use if building with RENESAS RA6M3G.

#### WOLFSSL_RENESAS_RA6M4

use if building with RENESAS RA6M4.

#### WOLFSSL_RENESAS_TSIP

Use if building for a Renesas RX device with the Trusted Secure IP (TSIP) driver (the `r_tsip_rx` FIT module). `wolfCrypt_Init()` opens the TSIP, the RNG is seeded from the TSIP, and the ports in `wolfcrypt/src/port/Renesas/renesas_tsip_*.c` use it for AES, SHA and RSA. With crypto callbacks it also defines `WOLF_CRYPTO_CB_RSA_PAD`. For the TLS-layer use of the TSIP see [`WOLFSSL_RENESAS_TSIP_TLS`](#wolfssl_renesas_tsip_tls); `NO_WOLFSSL_RENESAS_TSIP_CRYPT_HASH` and [`NO_WOLFSSL_RENESAS_TSIP_TLS_SESSION`](#no_wolfssl_renesas_tsip_tls_session) turn parts of the acceleration off. See `wolfcrypt/src/port/Renesas/README.md` in the wolfSSL source.

#### WOLFSSL_RENESAS_SCEPROTECT

Use if building for a Renesas RA device with the Secure Crypto Engine (SCE) in protected mode, through the FSP Security Module (FSPSM) driver (`r_sce.h`). It defines `WOLFSSL_RENESAS_FSPSM_ECC` and [`HAVE_PK_CALLBACKS`](#have_pk_callbacks) for the ECC offload; the example `IDE/Renesas/e2studio/RA6M4/common/user_settings.h` also defines `WOLFSSL_RENESAS_FSPSM` and [`WOLFSSL_RENESAS_FSPSM_TLS`](#wolfssl_renesas_fspsm_tls) with it. For wolfCrypt-only use, that file defines `WOLFSSL_RENESAS_SCEPROTECT_CRYPTONLY` instead.

#### WOLFSSL_RIOT_OS

Use if building with RIOT-OS.

#### WOLFSSL_uITRON4

Use if building for uITRON4.

#### WOLFSSL_uTKERNEL2

Use if building with uT-Kernel.

#### WOLFSSL_UTASKER

Use if building for uTasker. It defines `SINGLE_THREADED`, `NO_FILESYSTEM`, `NO_WOLFSSL_DIR`, `NO_WRITEV`, `HAVE_ECC` with `ALT_ECC_SIZE` and the timing resistance options, and `WOLFSSL_USER_IO`, because the uTasker port uses raw sockets: supply your own I/O callbacks (see the wolfSSL uTasker example). The RNG uses uTasker's `fnRandom()` (`CUSTOM_RAND_GENERATE`), the string functions use the uTasker library replacements, debug messages go to `fnDebugMsg()`, and the TLS timer uses `uTaskerSystemTick`. `XTIME` must be defined in `user_settings.h` to a function that returns seconds since the Unix epoch, or the build fails.

#### WOLFSSL_VXWORKS

Use if building with VxWorks.

#### DEVKITPRO

Use when building for devkitPro.

#### DOLPHIN_EMULATOR

Use when building for the Dolphin GameCube and Wii emulator. `wc_GenerateSeed()` then seeds the RNG from the C library `rand()`, seeded with `time()`, which is not a secure entropy source, so use it only for testing. The wolfCrypt test program waits in a loop when it finishes instead of returning from `main()`, which would make the emulator panic.

#### WOLFSSL_NDS

Use when building for the Nintendo DS with devkitPro and libnds (see `IDE/NDS/README.md` in the wolfSSL source, whose configure examples also define `WOLFSSL_USER_IO`). It defines `SIZEOF_LONG_LONG` as 8, `NO_WRITEV` and the missing socket types and constants. As with [`DOLPHIN_EMULATOR`](#dolphin_emulator), the RNG seed comes from `rand()` seeded with `time()`, which is not a secure entropy source.

#### WOLFSSL_VXWORKS_6_x

Used only with implementation for VxWorks 6.x only.

#### WOLFSSL_WICED

Used if building for WICED Studio.

#### FREESCALE_KSDK_FREERTOS

Older name of this is `FREESCALE_FREE_RTOS` but this is used when building for Freescale KSDK FreeRTOS.

#### FREESCALE_KSDK_MQX

Used when building for Freescale KSDK MQX/RTCS/MFS.

#### FREESCALE_KSDK_BM

Used when building for Freescale (NXP) Kinetis KSDK bare metal, with no RTOS. It defines `WOLFSSL_USER_IO` (supply your own I/O callbacks), `SINGLE_THREADED` and `NO_FILESYSTEM`, and [`USER_TICKS`](#user_ticks) unless [`TIME_OVERRIDES`](#time_overrides) is defined, so the application provides `LowResTimer()`. It also applies the common Freescale settings, which select the TRNG or RNGA and the mmCAU or LTC hardware crypto from the SoC feature macros. On a SoC with neither a TRNG nor an RNGA, the RNG falls back to the insecure test seed (`USE_TEST_GENSEED`, which prints a build warning), so supply a real seed source, for example with [`CUSTOM_RAND_GENERATE_SEED`](#custom_rand_generate_seed).

#### FREESCALE_MQX_5_0

Used when building for Freescale Classic MQX version 5.0.

#### FREESCALE_MQX_4_0

Used when building for Freescale Classic MQX version 4.0. It defines [`FREESCALE_MQX`](#freescale_mqx), with a small change for 4.0: the time comes from `mqx_time()` declared with `<time.h>`, without `HAVE_GMTIME_R`.

#### WOLFSSL_KEIL_TCP_NET

Use the Keil MDK TCPnet/Network stack for wolfSSL's socket I/O. In the MDK5 pack's `user_settings.h` (`IDE/MDK5-ARM`) it is selected by `MDK_CONF_NETWORK` (1, the default; use 0 for none or 2 for user I/O callbacks).

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


#### WOLFSSL_IOTSAFE

Enables IoTSAFE (GSMA) applet support for secure element operations. Allows TLS keys and crypto to be handled by an IoTSAFE-compliant SIM.

#### WOLFSSL_MAXQ1065

Use with the Analog Devices (Maxim) MAXQ1065 secure authenticator; configure defines it for `--with-maxq10xx=MAXQ1065`. It defines `WOLFSSL_MAXQ10XX_CRYPTO`, `WOLFSSL_MAXQ10XX_TLS`, [`HAVE_PK_CALLBACKS`](#have_pk_callbacks), `WOLFSSL_STATIC_PSK` and `WOLFSSL_PUBLIC_ASN`, and also `NO_WOLFSSL_SERVER`, because only the client side is supported. With crypto callbacks, AES-GCM, SHA-256, ECC and the RNG use the device, and `wc_GenerateSeed()` reads the seed from it. `WOLFSSL_TICKET_NONCE_MALLOC` cannot be used with it. See `wolfcrypt/src/port/maxim/README.md` in the wolfSSL source.

#### WOLFSSL_MAXQ108X

Use with the Analog Devices (Maxim) MAXQ1080 secure authenticator; configure defines it for `--with-maxq10xx=MAXQ108x`. It has the same settings as [`WOLFSSL_MAXQ1065`](#wolfssl_maxq1065), and with crypto callbacks the device also handles RSA.

#### FREESCALE_MQX

Can be defined when building for Freescale MQX/RTCS/MFS (<https://www.freescale.com>). This in turn defines `FREESCALE_K70_RNGA` to enable support for the Kinetis H/W Random Number Generator Accelerator

#### WOLFSSL_IAR_ARM

Can be defined if building for IAR EWARM.

#### WOLFSSL_TIRTOS

Can be defined when building for TI-RTOS.

#### WOLFSSL_ROWLEY_ARM

Can be defined when building with Rowley CrossWorks.

#### WOLFSSL_NRF5x

Can be defined when porting to Nordic nRF5x. It defines `WOLFSSL_NRF51` internally along with `NO_FILESYSTEM`, `SINGLE_THREADED`, `WOLFSSL_USER_IO`, `NO_DEV_RANDOM`, `NO_WRITEV`, `NO_MAIN_DRIVER`, `NO_SESSION_CACHE` and `TFM_TIMING_RESISTANT`. The port (`wolfcrypt/src/port/nrf51.c`) seeds the RNG from the nRF RNG driver and provides an RTC based timer for the benchmark.

#### WOLFSSL_CONTIKI

Can be defined to enable support for the Contiki operating system.

#### WOLFSSL_APACHE_HTTPD

Can be defined to enable support for the Apache HTTPD web server.

#### ASIO_USE_WOLFSSL

`ASIO_USE_WOLFSSL` and `BOOST_ASIO_USE_WOLFSSL` are read by (Boost.)Asio, not by wolfSSL. Build wolfSSL with [`--enable-asio`](#--enable-asio) (or the CMake option `WOLFSSL_ASIO`), which defines [`WOLFSSL_ASIO`](#wolfssl_asio) (the macro wolfSSL itself checks), turns on `OPENSSL_EXTRA` and `OPENSSL_ALL`, and adds both Asio defines.

#### WOLFSSL_SIFIVE_RISC_V

Not checked by the wolfSSL library. It is a setting in the example project for the SiFive HiFive1 board (`IDE/RISCV/SIFIVE-HIFIVE1/user_settings.h`).

#### WOLFSSL_MDK_ARM

Adds support for MDK ARM

#### WOLFSSL_MDK5

Adds support for MDK5 ARM

#### FUSION_RTOS

Can be defined when building for Fusion RTOS. wolfSSL then uses the Fusion RTOS socket (FNS) and C library / file system (FCL) interfaces for I/O, file access and time.

#### WOLFSSL_ZEPHYR

Can be defined when building for the Zephyr RTOS. wolfSSL can be used as a Zephyr module, whose build defines this macro; see `zephyr/README.md` in the wolfSSL source.

#### WOLFSSL_BSDKM

Can be defined when building wolfSSL as a FreeBSD kernel module. configure defines it for `--enable-freebsdkm`. See `bsdkm/README.md` in the wolfSSL source.

#### WOLFSSL_XILINX

Can be defined when building for Xilinx bare metal targets. It uses the FatFs file system (`ff.h`) and the PS RTC (`XRtcPsu`) for time. For the Xilinx hardware crypto engine see [`WOLFSSL_XILINX_CRYPT`](#wolfssl_xilinx_crypt).

#### WOLFSSL_TELIT_M2MB

Can be defined when building for Telit modules with the m2mb SDK. It provides the m2mb file system, mutex, RNG seed and time ports, including `m2mb_xtime()` for `XTIME()` and `m2mb_xtime_ms()` for [`XTIME_MS`](#xtime_ms) with TLS 1.3.

#### WOLFSSL_OPTEE

Can be defined when building wolfSSL into an OP-TEE trusted application (TA). It defines `NO_FILESYSTEM`, `NO_WOLFSSL_DIR`, `NO_WRITEV`, `NO_MAIN_DRIVER` and `SINGLE_THREADED`, and uses the TEE internal API for memory, the RNG seed (`TEE_GenerateRandom()`) and timers. `NO_ASN_TIME` is defined, because the only wall clock a TA can reach belongs to the normal world, unless `WOLFSSL_OPTEE_ASN_TIME` is defined.

#### HAVE_NETX

Can be defined when using the NetX or NetX Duo TCP/IP stack. wolfSSL then uses its NetX I/O callbacks; set the socket for a session with [`wolfSSL_SetIO_NetX()`](group__IO.md#function-wolfssl_setio_netx). DTLS over NetX Duo also needs `WOLFSSL_NETX_DUO` (see [`wolfSSL_SetIO_NetX_Dtls()`](group__IO.md#function-wolfssl_setio_netx_dtls)).

#### WOLFSSL_ARDUINO

Can be defined when building for Arduino. It defines `WOLFSSL_USER_IO`, `SINGLE_THREADED`, `NO_DEV_RANDOM`, `NO_WRITEV`, `NO_WOLFSSL_DIR`, `NO_SESSION_CACHE`, `HAVE_ECC` and `NO_DH`. ESP32 boards use the normal time functions and ARM boards get `NO_ASN_TIME`; on other boards it uses [`TIME_OVERRIDES`](#time_overrides), so `XTIME` and `XGMTIME` must be defined. See `IDE/ARDUINO` in the wolfSSL source.

#### WOLFSSL_RPIPICO

Can be defined when building for the Raspberry Pi RP2040 or RP2350 with the Pico SDK. It provides `wc_pico_rng_gen_block()`; to use the Pico RNG define `WC_NO_HASHDRBG` and `CUSTOM_RAND_GENERATE_BLOCK` as `wc_pico_rng_gen_block`. See `wolfcrypt/src/port/rpi_pico/README.md` in the wolfSSL source.

### OS Specific Defines

#### USE_WINDOWS_API

Use the Windows APIs instead of the Unix/Linux APIs.

#### WIN32_LEAN_AND_MEAN

Adds support for the Microsoft win32 lean and mean build.

#### FREERTOS_TCP

Adds support for the FREERTOS TCP stack

#### WOLFSSL_SAFERTOS

Adds support for SafeRTOS

#### WOLFSSL_SOLARIS

Use when building for Solaris. `settings.h` defines it automatically when the compiler defines `sun` or `__sun` together with `__SVR4` or `__svr4__`. It defines [`WOLFSSL_DH_CONST`](#wolfssl_dh_const) to avoid a clash with `fp_zero` from the system `math.h` headers.

## Build Options

The following are options which may be appended to the `./configure` script to customize how the wolfSSL library is built.

By default, wolfSSL only builds in shared mode, with static mode being disabled. This speeds up build times by a factor of two. Either mode can be explicitly disabled or enabled if desired.

### `--enable-debug`

Enable wolfSSL debugging support. Enabling debug support allows easier debugging by compiling with debug information and defining the constant [`DEBUG_WOLFSSL`](#debug_wolfssl) which outputs messages to `stderr`. To turn debug on at runtime, call [`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on). To turn debug logging off at runtime, call [`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off). For more information, see [Debugging](chapter08.md#debugging).

### `--enable-debug-trace-errcodes`

Print a trace message each time the library raises an error code (defines `WOLFSSL_DEBUG_TRACE_ERROR_CODES`). `--enable-debug-trace-errcodes=backtrace` also prints a backtrace and links with `libbacktrace`. Off by default.

### `--enable-debug-code-points`

Include the source file name and line number in the [`--enable-debug`](#--enable-debug) messages (defines `WOLFSSL_DEBUG_CODEPOINTS`). Off by default.

### `--enable-distro`

Enable the distribution package build: builds shared and static libraries, turns on [`--enable-all`](#--enable-all), enables [`--enable-reproducible-build`](#--enable-reproducible-build) by default and disables early data. Cannot be combined with `--enable-experimental`.

### `--enable-singlethreaded`

Enable single threaded mode, no multi thread protections (defines `SINGLE_THREADED`). Single threaded mode is also selected automatically when configure cannot find a POSIX threads library.

Enabling single threaded mode turns off multi thread protection of the session cache. Only enable single threaded mode if you know your application is single threaded or your application is multithreaded and only one thread at a time will be accessing the library.

### `--disable-threadlocal`

Thread local storage is used by default when the compiler supports it (defines `HAVE_THREAD_LS`). `--disable-threadlocal` turns it off. Some features, such as the per-thread error queue, need it.

### `--enable-rwlock`

Use reader-writer locks, for example for the session cache, so that readers do not block each other (defines [`WOLFSSL_USE_RWLOCK`](#wolfssl_use_rwlock)). With POSIX threads the lock is a `pthread_rwlock_t`. Off by default.

### `--enable-dtls`

Enable wolfSSL DTLS support

Enabling DTLS support allows users of the library to also use the DTLS protocol in addition to TLS and SSL. For more information, see the [DTLS](chapter04.md#dtls) section.

### `--enable-dtls13`

Enable DTLS 1.3 (defines `WOLFSSL_DTLS13`). Off by default. DTLS and TLS 1.3 are turned on automatically, and so is the server HelloRetryRequest cookie ([`--enable-hrrcookie`](#--enable-hrrcookie)) unless `--disable-hrrcookie` is given. When ML-KEM is enabled (the default), DTLS 1.3 ClientHello fragmenting is turned on as well.

### `--enable-dtlscid`

Enable the DTLS Connection ID extension (defines `WOLFSSL_DTLS_CID`). Off by default.

### `--enable-dtls-frag-ch`

Enable fragmenting of the DTLS 1.3 ClientHello, for ClientHello messages (for example with post-quantum key shares) that do not fit in one datagram. Requires `--enable-dtls13`. Off by default, but turned on automatically when both ML-KEM and DTLS 1.3 are enabled.

### `--enable-dtls-mtu`

Allow the application to set the DTLS MTU size. Off by default.

### `--enable-srtp`

Enable DTLS-SRTP (RFC 5764). Off by default. Turns on DTLS, the SRTP KDF and the keying material exporter.

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

`--enable-opensslextra=noinstall` skips installing the `wolfssl/openssl/` compatibility headers. On its own this value does not define `OPENSSL_EXTRA`, so combine it with an option that turns the compatibility layer on, such as [`--enable-opensslall`](#--enable-opensslall).

### `--enable-opensslall`

Enable all OpenSSL API.

### `--enable-opensslcoexist`

Build wolfSSL so that it can be linked beside OpenSSL's libcrypto (defines `OPENSSL_COEXIST` and drops the old wolfSSL and wolfCrypt compatibility names). Off by default. Cannot be combined with `--enable-opensslall`.

### `--disable-openssl-compatible-defaults`

Some application builds, for example `--enable-enterprise`, `--enable-nginx`, `--enable-haproxy`, `--enable-apachehttpd` and `--enable-stunnel`, define `OPENSSL_COMPATIBLE_DEFAULTS` so that wolfSSL behaves more like OpenSSL at run time; configure also picks the macro up from `CFLAGS` or `CPPFLAGS`. When it is set, configure adds `WOLFSSL_TRUST_PEER_CERT`, `NO_SESSION_CACHE_REF`, `WOLFSSL_TLS13_NO_PEEK_HANDSHAKE_DONE`, `WOLFSSL_ALT_CERT_CHAINS`, `WOLFSSL_PRIORITIZE_PSK`, `WOLFSSL_CHECK_ALERT_ON_ERR` and `WOLFSSL_TICKET_HAVE_ID`. `--disable-openssl-compatible-defaults` removes `OPENSSL_COMPATIBLE_DEFAULTS` from the flags and skips these additions; the rest of the application build is kept.

### `--disable-oldnames`

The old names of renamed wolfSSL and wolfCrypt types, functions and macros are kept by default for backwards compatibility. `--disable-oldnames` removes them (defines `NO_OLD_RNGNAME`, [`NO_OLD_WC_NAMES`](#no_old_wc_names), [`NO_OLD_SSL_NAMES`](#no_old_ssl_names), `NO_OLD_SHA_NAMES` and `NO_OLD_MD5_NAME`). It has no effect with [`--enable-opensslcoexist`](#--enable-opensslcoexist), which already drops all of these except the old RNG name.

### `--enable-old-extdata-fmt`

Make `wolfSSL_X509_EXTENSION_get_data()` return data in a format specific to each extension type, as older wolfSSL versions did, instead of the full OCTET STRING of the extension (defines `WOLFSSL_OLD_EXTDATA_FMT`). Use it only for compatibility with applications that need the old format. Off by default.

### `--enable-maxstrength`

Enable Max Strength build, allows TLSv1.2-AEAD-PFS ciphers only. This is
disabled by default because it can cause interoperability issues. It also
enables glitching detection. It defines `WOLFSSL_MAX_STRENGTH` and
`WOLFSSL_CIPHER_TEXT_CHECK`, forces old TLS off (`NO_OLD_TLS`), and cannot be
combined with `--enable-leanpsk` or `--enable-sslv3`.

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

### `--enable-harden-tls`

Enable the TLS requirements of RFC 9325 (defines `WOLFSSL_HARDEN_TLS`). Off by default. Takes `yes`, `112` or `128`, the minimum security strength in bits; `yes` is the same as `112`. It forces old TLS off and cannot be combined with `--enable-legacy-server-connect`.

### `--enable-faultharden`

Enable fault injection hardening, for example checking a TLS ECC signature after it is made and adding redundant checks to signature verification (defines `WOLFSSL_CHECK_SIG_FAULTS`, `WOLFSSL_CHECK_VER_FAULTS`, `WC_SHA3_FAULT_HARDEN`, `WC_MLKEM_FAULT_HARDEN` and `WC_MLDSA_FAULT_HARDEN`). Off by default.

### `--enable-compileharden`

Add extra hardening compiler flags (`-Wa,-mbranches-within-32B-boundaries -falign-loops=64`). Off by default. The `-mbranches-within-32B-boundaries` assembler option is x86 specific, and configure fails if the toolchain does not accept it.

### `--enable-aes-touch-lines`

Touch every AES table cache line on each table lookup, for cache-timing resistance (defines `WOLFSSL_AES_TOUCH_LINES`; `--disable-aes-touch-lines` defines `WOLFSSL_AES_NO_TOUCH_LINES`). On by default on RISC-V, off elsewhere.

### `--enable-aes-bitsliced`

Use the bitsliced, table-free AES implementation for cache-timing resistance (defines [`WC_AES_BITSLICED`](#wc_aes_bitsliced)). It also turns on AES-ECB (`HAVE_AES_ECB`) and direct AES (`WOLFSSL_AES_DIRECT`). Off by default.

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

The option defines `WOLFSSL_LEANTLS`, `NO_WOLFSSL_SERVER`, `NO_RSA`, `NO_DH` and `NO_OLD_TLS` among others, and also turns on [`--enable-lowresource`](#--enable-lowresource). TLS 1.3 is not turned off: it stays enabled (the default), and AES-GCM is kept while TLS 1.3 is on. Add [`--disable-tls13`](#--disable-tls13) to get the TLS 1.2 only client described here.

### `--enable-lowresource`

Enable settings for low memory and flash use. Off by default. It disables the session cache and selects the small, slower variants of RSA, Curve25519, Ed25519, SHA-1, SHA-256, SHA-512, AES and AES-GCM (for example `RSA_LOW_MEM`, `CURVE25519_SMALL`, `ED25519_SMALL`, `USE_SLOW_SHA256`, `GCM_SMALL`), and drops ECC Shamir.

### `--enable-tinytls13`

Enable the tiny TLS 1.3 footprint profile. This is a TLS 1.3 only build that strips wolfSSL to a minimal handshake surface for embedded and resource constrained targets. It is expressed as a translation layer over standard wolfSSL macros (the `WOLFSSL_TINY_TLS13` umbrella in `settings.h`), so it adds no new feature flags to the core library.

The profile is selected with a comma separated list:

```sh
./configure --enable-tinytls13=LIST
```

The bare flag `--enable-tinytls13` is equivalent to `--enable-tinytls13=psk`. This profile is non FIPS and cannot be combined with a FIPS build.

#### Base profiles

* `psk` (default): a pre shared key plus ECDHE build with no X.509. The floor is X25519 key exchange, AES-128-GCM, SHA-256 and HKDF. This is the smallest configuration.
* `cert`: adds a minimal X.509 certificate chain verify on top of the floor, using ECDSA P-256 by default.

The certificate profile is a reduced security verify. It disables X.509 name constraint enforcement, relaxes ASN.1 strictness and removes CRL revocation checking to save code. It is intended for a known or pinned certificate authority, not for general public internet PKI. Configure prints a notice when the certificate profile is selected.

#### Adders

The following may be combined with a base profile in the comma separated list:

* `server`: add the TLS 1.3 server role. The default is client only.
* `mutualauth`: mutual TLS with X.509 client authentication. Implies `cert`.
* `staticmem`: serve TLS allocations from a caller provided static memory pool. Add `WOLFSSL_NO_MALLOC` separately for a true zero heap build.
* `asm`: use assembly crypto instead of the small C backend. Larger but faster.
* `p256`: use P-256 ECDHE on the PSK floor instead of X25519.
* `sha384`: add SHA-384, for example for AES-256-GCM-SHA384.
* `mldsa`: add ML-DSA-65 certificate verification (verify only).
* `rsaverify`: add RSA-PSS certificate verification. The certificate profile is ECDSA only by default.

For example, a TLS 1.3 server that verifies ECDSA certificates and also supports SHA-384:

```sh
./configure --enable-tinytls13=cert,server,sha384
```

#### Footprint

The figures below are flash (text plus data) of the linked client binary, built `-Os` with link time optimization and dead code elimination (`-flto -ffunction-sections -fdata-sections -Wl,--gc-sections`) on the SHA-256 only floor. This is what links into an application, which is much smaller than the size of `libwolfssl.a`. Toolchains: arm-none-eabi-gcc 14.2 with newlib-nano (Cortex-M33), clang `-Os` (Intel x86_64), aarch64-none-elf-gcc 14.2 with newlib (ARM aarch64).

| Configuration | Cortex-M33 | Intel x86_64 | ARM aarch64 |
| --- | --: | --: | --: |
| PSK, X25519 (floor) | 30,836 | 56,092 | 50,700 |
| PSK, P-256 | 37,347 | 66,068 | 59,292 |
| Cert, ECDSA P-256 | 62,765 | 110,817 | 95,404 |
| Mutual TLS | 66,554 | 116,789 | 99,836 |

Cost of common adders on Cortex-M33, relative to the PSK floor:

| Build | Flash (bytes) | Delta vs floor |
| --- | --: | --: |
| PSK floor (X25519) | 30,836 | 0 |
| plus static memory (zero heap) | 32,169 | +1,333 |
| plus P-256 | 37,347 | +6,511 |
| plus ML-DSA-65 verify | 43,780 | +12,944 |

Where the flash goes for a PSK P-256 client on Cortex-M33 (37,347 bytes):

| Component | Bytes |
| --- | --: |
| TLS 1.3 handshake | 7,766 |
| TLS extensions | 5,678 |
| ECC P-256 (SP math) | 5,962 |
| CTX, SSL object and API | 4,050 |
| Record layer | 3,564 |
| AES-128-GCM | 2,650 |
| HMAC, HKDF, DRBG and RNG | 2,110 |
| SHA-256 | 1,370 |
| Key schedule | 1,120 |
| Memory and cleanup | 630 |
| C library (newlib) | 952 |
| Other and inlined | 1,486 |

#### Customizing for your application

1. Start from the closest base profile. Use `psk` if your endpoints share a pre shared key and you do not need certificates. Use `cert` if you must validate an X.509 certificate from a known certificate authority.
2. Add only the adders you need. Each one is a deliberate, measured step up in size, as the tables above show. Begin with `server` if the build is a server, and add a curve or signature adder only when your peer requires it.
3. Choose the key exchange curve. The PSK floor uses X25519 and the certificate profile uses P-256. Add `p256` when you want P-256 on the PSK floor, for example to reuse the P-256 code already pulled in by an ECDSA certificate. To supply your own group instead, for example P-384 or a post quantum hybrid, select that curve yourself and define `WOLFSSL_TINY_TLS13_NO_DEFAULT_CURVE` so the profile does not force a default X25519 or P-256.
4. Choose the memory model. The default uses the system allocator. Add `staticmem` to serve TLS allocations from a fixed pool supplied with `wolfSSL_CTX_load_static_memory()`. For a target with no heap at all, also define `WOLFSSL_NO_MALLOC`.
5. Provide the platform glue for bare metal. The example template enables `WOLFSSL_USER_IO` (you supply send and receive callbacks), `NO_FILESYSTEM` and `WOLFSSL_NO_SOCK`, and expects a hardware entropy source through `CUSTOM_RAND_GENERATE_SEED`.
6. Build for size. Link your application with `-Os -flto -ffunction-sections -fdata-sections -Wl,--gc-sections` so unused code is dropped.

The same profile is available without autotools through the `WOLFSSL_TINY_TLS13` umbrella in `settings.h`. The template `examples/configs/user_settings_tinytls13.h` selects the profile and adders with `#if 0` and `#if 1` blocks. The smallest result comes from a dead code eliminated, link time optimized build:

```sh
cp ./examples/configs/user_settings_tinytls13.h user_settings.h
./configure --enable-usersettings --enable-static --disable-shared \
            --disable-examples --disable-crypttests
make
# link your application with:
#   -Os -flto -ffunction-sections -fdata-sections -Wl,--gc-sections
```

The profile is driven entirely by the `WOLFSSL_TINY_TLS13` family of macros. Each one maps to a configure list item, so a `settings.h` build and an `--enable-tinytls13` build select the same features:

| Macro | Configure item | Effect |
| --- | --- | --- |
| `WOLFSSL_TINY_TLS13` | `psk` | The base profile. TLS 1.3 only, PSK plus ECDHE, no X.509. X25519, AES-128-GCM, SHA-256 and HKDF. Every other macro implies this one. |
| `WOLFSSL_TINY_TLS13_CERT` | `cert` | Add minimal X.509 certificate chain verify (ECDSA P-256), and switch the default curve to P-256. Implies the base profile. |
| `WOLFSSL_TINY_TLS13_MUTUAL_AUTH` | `mutualauth` | Mutual TLS with X.509 client authentication. Implies `WOLFSSL_TINY_TLS13_CERT`. |
| `WOLFSSL_TINY_TLS13_SERVER` | `server` | Add the TLS 1.3 server role. The default is client only. |
| `WOLFSSL_TINY_TLS13_STATIC_MEM` | `staticmem` | Serve TLS allocations from a caller provided static memory pool. |
| `WOLFSSL_TINY_TLS13_ASM` | `asm` | Use assembly crypto instead of the small C backend. Larger but faster. |
| `WOLFSSL_TINY_TLS13_RSA_VERIFY` | `rsaverify` | Add RSA-PSS certificate verification. Pair with the certificate profile. |
| `WOLFSSL_TINY_TLS13_NO_DEFAULT_CURVE` | (none) | Suppress the automatic default curve. The profile then enables neither X25519 nor P-256, so you can select your own group (for example P-384 or a post quantum hybrid). |

The `p256`, `sha384` and `mldsa` configure items have no dedicated tiny macro; they are selected with the standard wolfSSL macros (`HAVE_ECC` with `ECC_USER_CURVES`, `WOLFSSL_SHA384`, and `WOLFSSL_HAVE_MLDSA` with `WOLFSSL_MLDSA_VERIFY_ONLY`). See `examples/configs/user_settings_tinytls13.h` for the exact blocks.

A self contained, single process TLS 1.3 handshake smoke test for the profile is provided in `examples/tls13/tls13_memio.c`. It wires an in memory client and server together with no sockets or threads, so it can validate a tiny build that has no example or test harness available.

#### Dos and don'ts

* Do use the `cert` profile only with a known or pinned certificate authority. Its verify is deliberately reduced (no name constraints, relaxed ASN.1, no CRL).
* Do not use the `cert` profile for general public internet PKI.
* Do pair `mldsa` and `rsaverify` with the `cert` profile. They are certificate verification algorithms, so on the PSK floor they only confirm the build links.
* Do supply a real hardware entropy source through `CUSTOM_RAND_GENERATE_SEED` on bare metal. The default seed sources are not present once `NO_FILESYSTEM` and similar are set.
* Do not combine the profile with a FIPS build. It is a non FIPS footprint profile.
* Do not define `WOLFSSL_NO_MALLOC` and expect the standard `make check` test suite to run, since that suite needs an allocator. Validate a zero heap build by linking it and running `examples/tls13/tls13_memio.c` instead.
* Note that AES-256-GCM-SHA384 uses a SHA-384 transcript. With an external pre shared key, provision the key for SHA-384 through the cipher suite specific PSK callback, or use the cipher on the certificate profile, otherwise the PSK binder will not match.

### `--enable-bigcache`

Enable a big session cache.

Enabling the big session cache will increase the session cache from 33 sessions to 20,027 sessions. The default session cache size of 33 is adequate for TLS clients and embedded servers.

### `--enable-hugecache`

Enable a huge session cache.

Enabling the huge session cache will increase the session cache size to 65,791 sessions. This option is for servers that are under heavy load, over 13,000 new sessions per minute are possible or over 200 new sessions per second.

### `--enable-titancache`

Enable a titan session cache (defines `TITAN_SESSION_CACHE`). Off by default.

The titan session cache holds just over 2 million sessions and turns on row level locking of the cache. It is meant for servers with a lot of memory, long session ID timeouts and high levels of traffic.

### `--enable-smallcache`

Enable small session cache.

Enabling the small session cache will cause wolfSSL to only store 6 sessions. This may be useful for embedded clients or systems where the default is too much RAM. The default cache (33 sessions) takes about 13 KB for the session cache plus 17 KB for the client cache; the small cache takes about 2 KB plus 3 KB.

### `--enable-session-cache-ref`

Restore the deprecated behavior of [`wolfSSL_get_session()`](group__IO.md#function-wolfssl_get_session) on the client side, where it returns a reference to an entry in the client session cache that stays valid after the `WOLFSSL` object is freed (defines `WOLFSSL_SESSION_CACHE_REF`). Off by default: configure defines `NO_SESSION_CACHE_REF`, and `wolfSSL_get_session()` returns the session owned by the `WOLFSSL` object, which is only valid while that object exists. Use [`wolfSSL_get1_session()`](group__Setup.md#function-wolfssl_get1_session) to get a copy that outlives it. The option is ignored, with a configure warning, when another option already defines `NO_SESSION_CACHE_REF` (for example `--enable-curl`, `--enable-wpas` or a build that defines `OPENSSL_COMPATIBLE_DEFAULTS`). Compiling with the deprecated reference prints a warning unless `WOLFSSL_SESSION_CACHE_REF_WARNED` is defined.

### `--enable-savesession`

Enable persistent session cache.

Enabling this option will allow an application to persist (save) and restore the wolfSSL session cache to/from memory buffers.

### `--enable-savecert`

Enable persistent cert cache.

Enabling this option will allow an application to persist (save) and restore the wolfSSL certificate cache to/from memory buffers.

### `--enable-atomicuser`

Enable Atomic User Record Layer.

Enabling this option will turn on User Atomic Record Layer Processing callbacks. This will allow the application to register its own MAC/encrypt and decrypt/verify callbacks.

### `--enable-context-extra-user-data`

Enable the "ex_data" APIs for storing application data in `WOLFSSL_CTX`, `WOLFSSL` and other objects (defines [`HAVE_EX_DATA`](#have_ex_data)). Off by default, but many application builds turn `HAVE_EX_DATA` on themselves. A number from 1 to 9999 also sets the number of slots per object ([`MAX_EX_DATA`](#max_ex_data)); each slot reserves one pointer in every object.

### `--enable-pkcallbacks`

Enable Public Key Callbacks

Enabling this option will turn on Public Key callbacks, allowing the application to register its own ECC sign/verify and RSA sign/verify and encrypt/decrypt callbacks.

### `--enable-cert-setup-cb`

Enable a callback that loads the TLS certificate and key dynamically during the handshake (defines `WOLFSSL_CERT_SETUP_CB`). Off by default.

### `--enable-chain-verify-cb`

Let the application replace the verification of the peer certificate chain with its own callback (defines `WOLFSSL_CHAIN_VERIFY_CB`). Off by default.

### `--enable-writedup`

Enable write duplication of `WOLFSSL` objects, so that one thread can read and another can write on the same connection (defines `HAVE_WRITE_DUP`). Off by default.

### `--enable-sniffer`

Enable wolfSSL sniffer support.

Enabling sniffer (SSL inspection) support will allow the collection of SSL traffic packets as well as the ability to decrypt those packets with the correct key file.

The option defines `WOLFSSL_SNIFFER` and `WOLFSSL_STATIC_EPHEMERAL`. It needs ECC, RSA or Curve25519, and the sniffer test program is built only when libpcap is available. The sniffer can decode TLS 1.2 and TLS 1.3 sessions that use AES-GCM, AES-CCM, ChaCha20-Poly1305, AES-CBC or Camellia-CBC (and 3DES or RC4 when those are enabled; both are off by default). Sessions that use an ephemeral (EC)DHE key exchange, as TLS 1.3 sessions do, can be decoded only when the server uses a static ephemeral key, or from an NSS keylog file when wolfSSL is built with `WOLFSSL_SNIFFER_KEYLOGFILE`. See `sslSniffer/README.md` in the wolfSSL source for details.

### `--enable-keylog-export`

Enable export of TLS secrets to an NSS keylog file (defines `WOLFSSL_SSLKEYLOGFILE`, `HAVE_SECRET_CALLBACK` and `SHOW_SECRETS`). Off by default. This is insecure and must not be used in production; configure prints a warning when it is enabled.

### `--enable-aesgcm`

Enable AES-GCM support. Enabled by default; `--disable-aesgcm` turns it off.

Enabling AES-GCM will add these cipher suites to wolfSSL.  wolfSSL offers four different implementations of AES-GCM balancing speed versus memory consumption. If available, wolfSSL will use 64-bit or 32-bit math. For embedded applications, there is a speedy 8-bit version that uses RAM-based lookup tables (8KB per session) which is speed comparable to the 64-bit version and a slower 8-bit version that doesn't take up any additional RAM. The --enable-aesgcm configure option may be modified with the options `=4bit`, `=word32`, `=table`, or `=small`, i.e. `--enable-aesgcm=table`. The default implementation is `4bit` (`GCM_TABLE_4BIT`), and `=word` is the same as `=yes`.

### `--enable-aesgcm-stream`

Enable the AES-GCM streaming API, which encrypts or decrypts in several update calls (defines `WOLFSSL_AESGCM_STREAM`). Off by default.

### `--enable-aesccm`

Enable AES-CCM support (`HAVE_AESCCM`), including Counter with CBC-MAC Mode with 8-byte authentication (CCM-8) for AES.

### `--disable-aescbc`

AES-CBC is enabled by default. `--disable-aescbc` compiles it out (defines `NO_AES_CBC`). [`--enable-she`](#--enable-she) and `--enable-aescts` require AES-CBC.

### `--enable-aescbc-length-checks`

Make AES-CBC encrypt and decrypt return an error when the input length is not a multiple of the AES block size (defines [`WOLFSSL_AES_CBC_LENGTH_CHECKS`](#wolfssl_aes_cbc_length_checks)). Off by default. configure also accepts the spelling `--enable-aescbc_length_checks`.

### `--enable-aesecb`

Enable AES-ECB support (defines `HAVE_AES_ECB`). Off by default, although the configure help text says enabled.

### `--enable-aesofb`

Enable AES-OFB mode support. Off by default.

### `--enable-aescts`

Enable AES-CTS (ciphertext stealing) mode support (defines `WOLFSSL_AES_CTS`). Off by default. Requires AES-CBC.

### `--enable-aeseax`

Enable AES-EAX mode support. Off by default.

### `--enable-aessiv`

Enable AES-SIV (RFC 5297) support (defines `WOLFSSL_AES_SIV`). Off by default.

### `--enable-aesxts`

Enable AES-XTS mode (defines `WOLFSSL_AES_XTS`). Off by default. The old name `--enable-xts` is still accepted.

### `--enable-aesxts-stream`

Enable the AES-XTS streaming API. When `--enable-aesxts` is given, this is on by default unless `--enable-armasm` is also used.

### `--enable-aescfb`

Turns on AES-CFB mode support

### `--enable-aesctr`

Enable wolfSSL AES-CTR support

Enabling AES-CTR will enable Counter mode.

### `--enable-aesni`

Enable wolfSSL Intel AES-NI support

Enabling AES-NI support will allow AES instructions to be called directly from the chip when using an AES-NI supported chip. This provides speed increases for AES functions.  See [Features](chapter04.md#features) for more details regarding AES-NI.

### `--enable-aesni-with-avx`

Enable AES-NI with additional AVX acceleration for AES. Off by default. Needs an x86 or x86_64 host.

### `--enable-intelasm`

Enable ASM speedups for Intel and AMD processors.

Enabling the intelasm option for wolfSSL will utilize expanded capabilities of your processor that dramatically enhance AES performance. The instruction sets leveraged when configure option is enabled include AVX1, AVX2, BMI2, RDRAND, RDSEED, AESNI, and ADX. These were first introduced into Intel processors and AMD processors have started adopting them in recent years. When enabled, wolfSSL will check the processor and take advantage of the instruction sets your processor supports.

### `--enable-intelrand`, `--enable-intelrdseed` and `--enable-amdrdseed`

Use a hardware random number instruction as the preferred source: `--enable-intelrand` uses Intel RDRAND for random numbers (`HAVE_INTEL_RDRAND`), `--enable-intelrdseed` uses Intel RDSEED to seed the RNG (`HAVE_INTEL_RDSEED`), and `--enable-amdrdseed` (alias `--enable-amdrand`) uses AMD RDSEED to seed the RNG (`HAVE_AMD_RDSEED`). All are off by default.

### `--disable-asm`

Assembly code is enabled by default. `--disable-asm` turns off all assembly (defines `TFM_NO_ASM` and `WOLFSSL_NO_ASM`) and builds the C implementations only.

### `--enable-all-asm`

Enable all assembly accelerations that apply to the host, for example `--enable-intelasm` on x86_64 and `--enable-armasm` on AArch64, plus the SP math assembly. Off by default, but turned on by [`--enable-all-crypto`](#--enable-all-crypto) when building with a GCC compatible compiler outside a kernel module. Cannot be combined with options that turn assembly off, such as `--disable-asm`, `--disable-intelasm` or `--disable-armasm`.

### `--enable-32bit`

Treat the CPU as 32-bit (defines `WC_32BIT_CPU`), so wolfSSL uses 32-bit machine words even when the compiler targets a 64-bit CPU. When the SP code is built in C ([`--enable-sp`](#--enable-spopt) without `--enable-sp-asm`), only the 32-bit version (`sp_c32.c`) is built. Off by default. It also stops [`--enable-all-crypto`](#--enable-all-crypto) from turning on [`--enable-all-asm`](#--enable-all-asm), and on x86_64 stops configure from defining `WOLFSSL_X86_64_BUILD`. The option does not add compiler flags: to generate 32-bit code, also pass them to configure, for example `./configure --enable-32bit CFLAGS="-m32" LDFLAGS="-m32"`. Cannot be combined with `--enable-64bit` or `--enable-16bit`.

### `--enable-64bit`

When the SP code is built in C ([`--enable-sp`](#--enable-spopt) without `--enable-sp-asm`), build only the 64-bit version (`sp_c64.c`) and leave out the 32-bit version (`sp_c32.c`). Off by default. It defines no macro, and 64-bit targets build without it, although the configure help text says it enables 64-bit support. Cannot be combined with `--enable-32bit` or `--enable-16bit`.

### `--enable-camellia`

Enable Camellia support

### `--enable-aria`

Enable ARIA cipher support (defines `HAVE_ARIA`). Off by default. ARIA is provided by the external MagicCrypto library, which configure expects in a `MagicCrypto` directory in the build directory.

### `--enable-sm2`, `--enable-sm3` and `--enable-sm4-ecb`, `--enable-sm4-cbc`, `--enable-sm4-ctr`, `--enable-sm4-gcm`, `--enable-sm4-ccm`

Enable the Chinese ShangMi algorithms: the SM2 elliptic curve signatures and key exchange (`WOLFSSL_SM2`, needs ECC), the SM3 hash (`WOLFSSL_SM3`) and the SM4 block cipher in the selected modes. All are off by default. The implementation is not in the wolfSSL source tree; it is added from the separate [wolfsm](https://github.com/wolfSSL/wolfsm) repository.

### `--enable-md2`

Enable MD2 support

### `--enable-nullcipher`

Enable wolfSSL NULL cipher support (no encryption)

### `--enable-ripemd`

Enable wolfSSL RIPEMD-160 support

### `--enable-blake2b`

Enable wolfSSL BLAKE2b support (defines `HAVE_BLAKE2B`). `--enable-blake2` is accepted as a backward compatible alias.

### `--enable-blake2s`

Enable wolfSSL BLAKE2s support

### `--enable-sha3`

Enabled by default on x86\_64, amd64 and AArch64, and on every other target whenever ML-KEM (on by default), ML-DSA, FrodoKEM or Falcon is enabled, since those turn SHA-3 and SHAKE on.

Enables wolfSSL SHA3 support (`=small` for small build, `=noasm` to disable the SHA-3 assembly)

### `--enable-shake128` and `--enable-shake256`

Enable the SHAKE128 and SHAKE256 extendable output functions. On by default whenever SHA-3 is enabled (in FIPS builds, only from FIPS v6). ML-KEM needs both and turns them back on if they are disabled.

### `--disable-sha256`

Disable SHA-256 support. SHA-256 is enabled by default.

### `--disable-sha384`

Disable SHA-384 support. SHA-384 is enabled by default.

### `--disable-sha512`

Disable wolfSSL SHA-512 support. SHA-512 is enabled by default on all targets, and is turned off by [`--enable-leanpsk`](#--enable-leanpsk), [`--enable-leantls`](#--enable-leantls) and `--enable-16bit`.

### `--disable-hmac`

HMAC is enabled by default. `--disable-hmac` compiles it out (defines [`NO_HMAC`](#no_hmac)). TLS needs HMAC, so this is only useful for wolfCrypt-only builds such as [`--enable-cryptonly`](#--enable-cryptonly). configure fails if a selected option needs HMAC, for example wolfSSH, wolfGuard or the SHA-2 variants of SLH-DSA.

### `--enable-hmac-copy`

Keep the hash states of the inner and outer padded HMAC key and copy them for each new message, instead of hashing the padded key again (defines [`WOLFSSL_HMAC_COPY_HASH`](#wolfssl_hmac_copy_hash)). Faster when many messages are authenticated with the same key, at the cost of a larger `Hmac` structure. Off by default.

### `--enable-hashflags`

Enable hash flags, used for run time options such as selecting Keccak-256 instead of SHA3-256 (defines [`WOLFSSL_HASH_FLAGS`](#wolfssl_hash_flags)). Off by default; crypto callback builds turn it on automatically.

### `--enable-she`

Enable SHE (Secure Hardware Extension) key update message generation support. SHE is an automotive security standard for secure key management in ECUs. This module provides software-based generation and verification of SHE key update messages (M1-M5) with optional hardware offload via crypto callbacks.

Two modes are available:

- `--enable-she=standard` - Standard SHE support (defines `WOLFSSL_SHE`)
- `--enable-she=extended` - Standard plus extended overrides for custom KDF constants and message headers (defines `WOLFSSL_SHE` and `WOLFSSL_SHE_EXTENDED`)

A mode is required. Plain `--enable-she` (value `yes`) neither defines `WOLFSSL_SHE` nor builds the SHE sources.

SHE automatically enables its dependencies: AES, AES-CBC, AES-direct, and CMAC. Configure fails if `--disable-aescbc` is also given.

The following defines can be used to compile out optional features:

- `NO_WC_SHE_GETUID` - Compile out `wc_SHE_GetUID` callback
- `NO_WC_SHE_GETCOUNTER` - Compile out `wc_SHE_GetCounter` callback
- `NO_WC_SHE_IMPORT_M123` - Compile out `wc_SHE_ImportM1M2M3`
- `NO_WC_SHE_EXPORTKEY` - Compile out `wc_SHE_ExportKey` callback
- `NO_WC_SHE_LOADKEY` - Compile out all `wc_SHE_LoadKey` / `wc_SHE_LoadKey_Verify` convenience wrappers
- `WC_SHE_SW_DEFAULT` - Enable software-only default UID and counter for testing without hardware

### `--enable-sessioncerts`

Enable session cert storing

### `--enable-keygen`

Enable key generation (`WOLFSSL_KEY_GEN`): RSA key generation, DSA key generation, DH parameter generation and the key to DER export functions such as `wc_RsaKeyToDer()`. Also accepts a comma separated list: `all`, or `no-dh-params` to drop DH domain parameter generation while keeping DH key generation (defines `WOLFSSL_NO_DH_GEN_PARAMS`).

### `--enable-certgen`

Enable cert generation

### `--enable-certgencache`

Keep the certificate decoded by `wc_SetIssuerBuffer()`, `wc_SetSubjectBuffer()` and similar functions cached in the `Cert` structure between calls, instead of decoding it each time (defines [`WOLFSSL_CERT_GEN_CACHE`](#wolfssl_cert_gen_cache)). Free the cache with [`wc_SetCert_Free()`](group__ASN.md#function-wc_setcert_free). Off by default.

### `--enable-certsigncb`

Enable the certificate signing callback API, so that a certificate can be signed by a TPM or HSM that holds the private key (defines `WOLFSSL_CERT_SIGN_CB`). Off by default.

### `--enable-certext`

Enable cert extensions (see chapter 7 on supported extensions)

### `--enable-certreq`

Enable cert request generation

### `--enable-sep`

Enable SEP extensions

### `--enable-hkdf`

Enable HKDF (HMAC-KDF). Enabled automatically whenever TLS 1.3 is enabled (the default).

### `--enable-hpke`

Enable Hybrid Public Key Encryption (HPKE, RFC 9180), defines `HAVE_HPKE`. Off by default. HKDF is turned on with it. [`--enable-ech`](#--enable-ech) uses HPKE.

### `--enable-x963kdf`

Enable X9.63 KDF support

### `--enable-srtp-kdf`

Enable the SRTP and SRTCP key derivation functions (defines `WC_SRTP_KDF`). Off by default. Turned on by [`--enable-srtp`](#--enable-srtp).

### `--enable-cmac`

Enable AES-CMAC (defines `WOLFSSL_CMAC`). Off by default. Turned on automatically by options that need it, such as `--enable-aessiv`, `--enable-aeseax`, `--enable-cmac-kdf` and `--enable-she`.

### `--enable-cmac-kdf`

Enable the two-step KDF with AES-CMAC from NIST SP 800-56C, `wc_KDA_KDF_twostep_cmac()` (defines `HAVE_CMAC_KDF`). Off by default. Requires the KDF code, which is on by default (`--enable-kdf`).

### `--enable-dsa`

Enable Digital Signature Algorithm (DSA).

DSA is a legacy algorithm. It was approved along with RSA and ECDSA in FIPS 186-4, but FIPS 186-5, which supersedes FIPS 186-4, no longer approves DSA for generating signatures (it may still be used to verify them). wolfSSL groups DSA with the obsolete FIPS algorithms that [`--enable-all-legacy-crypto`](#--enable-all-legacy-crypto) turns on.

### `--disable-eccshamir`

Enabled by default on all targets. `--disable-eccshamir` turns off ECC Shamir (`ECC_SHAMIR`), which is also dropped by [`--enable-lowresource`](#--enable-lowresource).

### `--disable-ecc`

ECC support and the ECC cipher suites are built into wolfSSL by default on all targets. `--disable-ecc` builds without them.

### `--enable-ecccustcurves`

Enable ECC custom curves (`=all` to enable all curve types)

### `--enable-brainpool`

Enable the Brainpool ECC curves (defines `HAVE_ECC_BRAINPOOL`). On by default whenever `--enable-ecccustcurves` is on, and requires it.

### `--with-eccminsz=BITS`

Set the minimum ECC key size that is accepted (`ECC_MIN_KEY_SZ`). The default is 224 bits, or 192 bits in FIPS builds.

### `--with-max-ecc-bits=BITS`

Set the largest ECC key size, in bits, that the build supports. Must be between 112 and 1024.

### `--enable-compkey`

Enable compressed keys support

### `--enable-curve25519`

Enable Curve25519 (or `--enable-curve25519=small` for CURVE25519\_SMALL).

An elliptic curve offering 128 bits of security and to be used with ECDH key  agreement. Enabling curve25519 option allows for the use of the curve25519 algorithm. The default curve25519 is set to use more memory but have a faster run time. To have the algorithm use less memory the option `--enable-curve25519=small` can be used. Although using less memory there is a trade off in speed.

`--enable-curve25519=nonblock` adds non-blocking key generation and shared secret computation (`WC_X25519_NONBLOCK`, which also selects the small implementation) and turns on `--enable-asynccrypt` and `--enable-asynccrypt-sw`. `--enable-curve25519=noasm` disables the x86\_64 assembly for Curve25519 and Ed25519.

### `--enable-ed25519`

Enable ED25519 (or `--enable-ed25519=small` for ED25519\_SMALL)

Enabling ed25519 option allows for the use of the ed25519 algorithm. The default ed25519 is set to use more memory but have a faster run time. To have the algorithm use less memory the option `--enable-ed25519=small` can be used. As with curve25519, the `small` option trades speed for lower memory use.

`--enable-ed25519-stream` adds the streaming verify API, for messages that are verified in several updates. Off by default.

### `--enable-curve448`

Enable Curve448 (X448) key agreement. Off by default. `--enable-curve448=small` selects the small implementation.

### `--enable-ed448`

Enable Ed448 signatures. Off by default. `--enable-ed448=small` selects the small implementation, and `--enable-ed448-stream` adds the streaming verify API. Ed448 needs SHAKE256, so SHA-3 is turned on with it.

### `--enable-fpecc`

Enable Fixed Point cache ECC

### `--enable-eccencrypt`

Enable ECC encrypt (ECIES). Takes `yes` (SEC1 standard), `geniv` (generate the IV), `iso18033` (ISO 18033 standard) or `old` (the original wolfSSL algorithm). Requires ECC and HKDF.

### `--enable-eccsi`

Enable ECCSI, Elliptic Curve-Based Certificateless Signatures for Identity-Based Encryption (RFC 6507). Off by default. Requires ECC.

### `--enable-sakke`

Enable SAKKE, Sakai-Kasahara Key Encryption (RFC 6508), a pairing based identity key exchange. Off by default. Requires ECC. `--enable-sakke=small` selects a smaller implementation.

### `--enable-psk`

Enable PSK (Pre Shared Keys)

### `--enable-cert-with-extern-psk`

Enable TLS 1.3 certificate authentication together with an external PSK (RFC 9973), defines `WOLFSSL_CERT_WITH_EXTERN_PSK`. Off by default. Needs TLS 1.3 and `--enable-psk`; without them it is turned off.

### `--disable-errorstrings`

Disable the error strings table

### `--disable-errorqueue`

The OpenSSL compatible error queue is enabled by default when the OpenSSL compatibility layer is built. `--disable-errorqueue` stops errors from being added to the queue (defines `NO_ERROR_QUEUE`).

### `--enable-error-queue-per-thread`

Keep one error queue per thread (defines `ERROR_QUEUE_PER_THREAD`). Requires thread local storage. Although the configure help text says disabled, it is turned on by default when thread local storage is available and the build is not single threaded.

### `--enable-oldtls`

Enable old TLS versions < 1.2. Off by default (`NO_OLD_TLS` is defined); `--enable-oldtls` leaves `NO_OLD_TLS` undefined. `--enable-harden-tls`, `--enable-leanpsk`, `--enable-leantls`, `--enable-cryptonly` and `--enable-maxstrength` turn old TLS off.

**Warning:** Building with `--enable-oldtls` is **not conformant** with RFC 9846, RFC 8996 or RFC 9325. RFC 8996 deprecates TLS 1.0 and TLS 1.1, and RFC 9846 states that SSL 2.0, SSL 3.0, TLS 1.0 and TLS 1.1 "MUST NOT be negotiated for any reason".

### `--enable-tlsv10`

Enable TLS version 1.0 (defines `WOLFSSL_ALLOW_TLSV10`, and enables old TLS).

**Warning:** Building with `--enable-tlsv10` is **not conformant** with RFC 9846, RFC 8996 or RFC 9325. See [`--enable-oldtls`](#--enable-oldtls) above.

### `--enable-sslv3`

Enable SSL version 3.0 (defines `WOLFSSL_ALLOW_SSLV3`, and enables old TLS).

**Warning:** Building with `--enable-sslv3` violates RFC 7568. SSL 3.0 is deprecated by RFC 7568, which states "SSLv3 MUST NOT be used."

### `--enable-stacksize`

Enable stack size info on examples

### `--disable-memory`

Disable memory callbacks

### `--enable-trackmemory`

Print memory use information when wolfCrypt and wolfSSL are cleaned up (defines `WOLFSSL_TRACK_MEMORY`; `=verbose` also defines `WOLFSSL_TRACK_MEMORY_VERBOSE`). Off by default. Requires the wolfSSL memory callbacks (do not use `--disable-memory`).

### `--enable-memorylog`

Log dynamic memory allocations (defines `WOLFSSL_MEMORY_LOG`). Off by default.

### `--enable-stacklog`

Log stack usage using compiler function instrumentation (defines `WOLFSSL_STACK_LOG` and adds `-finstrument-functions`). Off by default.

### `--disable-rsa`

Disable RSA

### `--enable-rsapss`

Enable RSA-PSS. Enabled automatically whenever RSA and TLS 1.3 are enabled (the default); defines `WC_RSA_PSS` and `WOLFSSL_PSS_LONG_SALT`.

### `--disable-oaep`

Disable RSA OAEP padding. OAEP is enabled by default.

### `--with-max-rsa-bits=BITS`

Set the largest RSA, DH and DSA key size, in bits, that the build supports. Must be between 1024 and 16384.

### `--disable-dh`

Disable DH

### `--enable-ffdhe-only`

Make a TLS client accept only the named FFDHE groups (RFC 7919) as the server's DH parameters: if the server sends other DH parameters, the client sends a fatal `handshake_failure` alert and the connection fails with `DH_PARAMS_NOT_FFDHE_E` (defines `WOLFSSL_REQUIRE_FFDHE`). Off by default. Requires DH and the Supported Curves extension.

### `--enable-anon`

Enable Anonymous

### `--disable-asn`

Disable ASN

ASN.1 support is enabled by default and uses the template based implementation. The option also takes a comma separated list: `template` (or `yes`, the default), `original` (the older, non-template code, defines `WOLFSSL_ASN_ORIGINAL`), `nocrypt` (defines `NO_ASN_CRYPT` and turns off password based cryptography), `all` (all ASN.1 features, defines `WOLFSSL_ASN_ALL`) or `no`. Configure only accepts `--disable-asn` together with `--disable-rsa` and `--enable-psk`.

### `--enable-asn-print`

Enable the ASN.1 print API, which prints the structure of DER encoded data (defines [`WOLFSSL_ASN_PRINT`](#wolfssl_asn_print)); with the examples enabled it also builds the `examples/asn1` and `examples/pem` tools. On by default when the host is Linux, macOS or FreeBSD, off for other hosts, although the configure help text says it is always enabled by default.

### `--enable-acert`

Enable attribute certificate support (defines `WOLFSSL_ACERT`). Off by default.

### `--disable-pkcs8`

Disable PKCS #8 key packages (defines `NO_PKCS8`). PKCS #8 is enabled by default.

### `--enable-enckeys`

Enable PEM encrypted private key support (defines `WOLFSSL_ENCRYPTED_KEYS`). Off by default.

### `--enable-ip-alt-name`

Enable IP address subject alternative names (defines `WOLFSSL_IP_ALT_NAME`). Off by default.

### `--enable-indef`

Enable parsing of BER messages with indefinite length encoding (defines `ASN_BER_TO_DER`). Off by default.

### `--disable-aes`

Disable AES

### `--disable-coding`

Disable Coding base 16/64

### `--enable-base64encode`

Enabled by default on x86\_64

Enable Base64 encoding

### `--enable-base16`

Enable Base16 (hex) encoding and decoding, [`Base16_Encode()`](group__Base__Encoding.md#function-base16_encode) and [`Base16_Decode()`](group__Base__Encoding.md#function-base16_decode) (defines `WOLFSSL_BASE16`). Off by default, but `settings.h` turns it on with `OPENSSL_EXTRA`, the web server, FIPS, encrypted keys and some other features, and configure turns it on for `--enable-openssh` and SM2.

### `--enable-des3`

Enable DES3. Off by default. It is turned on automatically by some application builds (for example `--enable-openssh`, `--enable-openvpn` and `--enable-wpas`) unless FIPS 140-3 is used. The 3DES TLS cipher suites also need `--enable-des3-tls-suites`.

### `--enable-arc4`

Enable ARC4

### `--enable-rc2`

Enable the RC2 cipher (defines [`WC_RC2`](#wc_rc2)), mainly to read legacy PKCS#12 files that use it. Off by default.

### `--enable-md5`

Enable MD5. Off by default. It is turned on automatically by `--enable-opensslextra`, `--enable-opensslall`, `--enable-oldtls`, `--enable-des3` and several application builds. When MD5 is off, `NO_MD5` and `NO_OLD_TLS` are defined.

### `--disable-sha`

Disable SHA

### `--enable-webserver`

Enable Web Server.

This turns on functions required over the standard build that will allow full functionality for building with the yaSSL Embedded Web Server.

### `--enable-webclient`

Enable the small HTTP client API in `wolfio.c`, for example `wolfIO_DecodeUrl()`, `wolfIO_HttpBuildRequest()` and `wolfIO_HttpProcessResponse()` (defines `HAVE_HTTP_CLIENT`). Off by default. OCSP and CRL I/O ([`--enable-ocsp`](#--enable-ocsp), `--enable-crl=io`) turn it on unless `WOLFSSL_USER_IO` is defined.

### `--enable-fips`

Enable FIPS 140-2 / 140-3 (Must have license to implement.) Takes a module version such as `v7`, `ready` or `dev`. For bring-up and debugging there is `--enable-fips=dev-no-post` (new in wolfSSL 5.9.4), which builds the development FIPS module without the power-on self test.

A few more FIPS behaviors came with wolfSSL 5.9.4: HMAC-MD5 is rejected, AES-GCM encryption with an IV shorter than 12 bytes returns `FIPS_BAD_VALUE_E` (override with `WC_FIPS_AESGCM_ALLOW_SHORT_NONCES`), a CMAC tag needs at least 64 bits, and RSA-PSS salts longer than the hash are refused (FIPS 186-5). Also, on FIPS 140-3 (v5 and later) builds `--enable-wolfclu` no longer enables MD5 or DES3, and on FIPS builds it no longer relaxes ASN.1 checking (`WOLFSSL_NO_ASN_STRICT`). It enables Ed25519 on non-FIPS builds and on FIPS v6 and later.

### `--enable-sha224`

Enabled by default on x86\_64, amd64 and AArch64, except when AF\_ALG or `/dev/crypto` is used, or in FIPS builds other than FIPS v2.

Enable wolfSSL SHA-224 support

### `--disable-poly1305`

Disable wolfSSL POLY1305 support

### `--disable-chacha`

Disable CHACHA

### `--enable-xchacha`

Enable XChaCha, the extended nonce variant of ChaCha (defines `HAVE_XCHACHA`). Off by default. Requires ChaCha.

### `--enable-ascon`

Enable the Ascon lightweight cryptography (Ascon-Hash256 and Ascon-AEAD128), defines `HAVE_ASCON`. Off by default.

### `--enable-siphash`

Enable SipHash (defines `WOLFSSL_SIPHASH`). Off by default.

### `--disable-hashdrbg`

Disable Hash DRBG support

### `--disable-sha256-drbg`

The SHA-256 Hash DRBG (NIST SP 800-90A) is built by default. `--disable-sha256-drbg` leaves it out (defines `WOLFSSL_NO_SHA256_DRBG`), so only the SHA-512 Hash DRBG is available. If both Hash DRBGs are disabled, the Hash DRBG is off as with [`--disable-hashdrbg`](#--disable-hashdrbg). It cannot be disabled at build time in a FIPS build; with FIPS v7, which also has the SHA-512 Hash DRBG, use the run time function `wc_Sha256Drbg_Disable()` instead.

### `--disable-sha512-drbg`

The SHA-512 Hash DRBG (NIST SP 800-90A, defines `WOLFSSL_DRBG_SHA512`) is built by default when SHA-512 is enabled, and new `WC_RNG` objects then use it rather than the SHA-256 Hash DRBG unless it is turned off at run time with `wc_Sha512Drbg_Disable()`. `--disable-sha512-drbg` leaves it out, so the RNG uses the SHA-256 Hash DRBG. It is always off without SHA-512, with `--enable-selftest` and with FIPS module versions before v7. In FIPS v7 builds it cannot be disabled at build time; use `wc_Sha512Drbg_Disable()` at run time instead.

### `--disable-filesystem`

Disable Filesystem support.

This makes it easier to disable filesystem use.  This option defines [`NO_FILESYSTEM`](#no_filesystem).

### `--disable-inline`

Disable inline functions.

Disabling this option disables function inlining in wolfSSL.  Inline functions are expanded at the call site instead of being called. This option defines `NO_INLINE` to turn that off, which can reduce code size. It is the default with `--enable-c89`.

### `--disable-optflags`

With a GCC compatible compiler, and unless [`--enable-debug`](#--enable-debug) or [`--enable-distro`](#--enable-distro) is used, configure adds its default optimization flags: `-O2` for the fast math and non-small SP math builds, `-Os` otherwise. `--disable-optflags` leaves them out, so the optimization level comes only from your own `CFLAGS`.

### `--disable-aligndata`

Data alignment for the ciphers is enabled by default (defines `WOLFSSL_USE_ALIGN`), so buffers such as the AES key schedule and GCM tables are aligned. `--disable-aligndata` turns it off, but `wolfssl/wolfcrypt/types.h` still defines it for AES-NI, the ARM and Intel assembly code, Xilinx, and ARM targets without unaligned access.

### `--enable-ocsp`

Enable Online Certificate Status Protocol (OCSP).

Enabling this option adds OCSP (Online Certificate Status Protocol) support to wolfSSL. It is used to obtain the revocation status of x.509 certificates as described in RFC 6960.

### `--enable-ocsp-responder`

Enable the OCSP responder API, for building OCSP responses (defines `HAVE_OCSP_RESPONDER`). Off by default.

### `--enable-ocspstapling`

Enable OCSP Stapling (`=no-multi` to disable multiple OCSP Stapling for TLS1.3 Certificate)

### `--enable-ocspstapling2`

Enable OCSP Stapling version 2

### `--enable-crl`

Enable CRL (Certificate Revocation List). `--enable-crl=io` also enables inline CRL fetching over HTTP GET (`HAVE_CRL_IO`).

### `--enable-crl-monitor`

Enable CRL Monitor.

Enabling this option adds the ability to have wolfSSL actively monitor a specific CRL (Certificate Revocation List) directory.

### `--enable-altcertchains`

Enable alternative certificate chains (defines `WOLFSSL_ALT_CERT_CHAINS`): only the peer (leaf) certificate has to validate to a trusted CA, so a CA certificate in the peer chain that has no known signer is not treated as an error. Off by default.

### `--enable-sni`

Enable Server Name Indication (SNI).

Enabling this option will turn on the TLS Server Name Indication (SNI) extension. Enabled by default on x86\_64, x86, aarch64 and amd64 (use `--disable-sni` there). It is forced on by `--enable-qt` and `--enable-quic`.

### `--enable-maxfragment`

Enable Maximum Fragment Length.

Enabling this option will turn on the TLS Maximum Fragment Length extension.

### `--enable-alpn`

Enable Application Layer Protocol Negotiation (ALPN)

### `--enable-truncatedhmac`

Enable Truncated Keyed-hash MAC (HMAC).

Enabling this option will turn on the TLS Truncated HMAC extension.

### `--enable-trustedca`

Enable the TLS Trusted CA Indication extension (defines `HAVE_TRUSTED_CA`). Off by default. Turned on by [`--enable-tlsx`](#--enable-tlsx).

### `--enable-renegotiation-indication`

Enable Renegotiation Indication.

This is a client only, "fake" form of secure renegotiation (defines `HAVE_RENEGOTIATION_INDICATION`): the client sends the `TLS_EMPTY_RENEGOTIATION_INFO_SCSV` signaling cipher suite but does not renegotiate. It cannot be combined with `--enable-secure-renegotiation`, and it turns off `--enable-secure-renegotiation-info`. The `renegotiation_info` extension handling of [RFC 5746](https://datatracker.ietf.org/doc/html/rfc5746), which prevents renegotiation splicing attacks by tying renegotiations to the TLS connection they are performed over, is provided by `--enable-secure-renegotiation-info` (on by default).

### `--enable-secure-renegotiation`

Enable Secure Renegotiation

### `--disable-secure-renegotiation-info`

The RFC 5746 `renegotiation_info` extension is enabled by default for TLS 1.2 (defines `HAVE_SERVER_RENEGOTIATION_INFO`). `--disable-secure-renegotiation-info` turns it off. It is also off when TLS 1.2 or ASN.1 is disabled, or with `--enable-renegotiation-indication`.

### `--enable-legacy-server-connect`

By default a TLS 1.2 client requires the server to acknowledge the `renegotiation_info` extension on the initial handshake (RFC 5746, RFC 9325). This option also allows connections to legacy servers that do not support secure renegotiation (defines `WOLFSSL_ALLOW_LEGACY_SERVER_CONNECT`). Off by default and not recommended. It cannot be combined with `--enable-harden-tls`.

### `--disable-supportedcurves`

The TLS Supported Elliptic Curves extension is enabled by default. `--disable-supportedcurves` turns it off. It is also turned off automatically when ECC, Curve25519 and Curve448 are all disabled.

### `--enable-session-ticket`

Enable Session Ticket

### `--enable-ticket-nonce-malloc`

Allocate TLS 1.3 session ticket nonces dynamically, so that nonces longer than the built-in buffer can be stored (defines [`WOLFSSL_TICKET_NONCE_MALLOC`](#wolfssl_ticket_nonce_malloc)). Off by default, but turned on by `--enable-curl` unless `--disable-ticket-nonce-malloc` is given.

### `--disable-extended-master`

Extended Master Secret is enabled by default (and off with `--enable-cryptonly`). `--disable-extended-master` turns it off.

### `--disable-enc-then-mac`

The TLS Encrypt-then-MAC extension is enabled by default (defines `HAVE_ENCRYPT_THEN_MAC`). `--disable-enc-then-mac` turns it off.

### `--enable-keying-material`

Enable the TLS keying material exporters of RFC 5705 (defines `HAVE_KEYING_MATERIAL`). Off by default. Turned on by options that need it, such as `--enable-srtp`, `--enable-chrony`, `--enable-wpas` and `--enable-openvpn`.

### `--enable-ech`

Enable TLS 1.3 Encrypted Client Hello (defines `HAVE_ECH`). Off by default. Unless they are explicitly disabled, it also turns on HPKE, ECC, Curve25519, SHA-256, SNI and TLS 1.3.

### `--enable-rpk`

Enable Raw Public Keys in TLS (RFC 7250), defines `HAVE_RPK`. Off by default.

### `--enable-tlsx`

Enable all TLS extensions.

Turns on SNI, Maximum Fragment Length, Truncated HMAC, ALPN, Trusted CA Indication, Encrypt-then-MAC and Supported Curves. Session tickets, OCSP stapling, ECH, early data and the other extensions have their own options.

### `--enable-pkcs7`

Enable PKCS#7 support

### `--enable-smime`

Enable S/MIME support (defines [`HAVE_SMIME`](#have_smime)). Off by default, but turned on by [`--enable-enterprise`](#--enable-enterprise) and `--enable-all-osp`. It also turns on PKCS#7 and the full OpenSSL compatibility layer ([`--enable-opensslall`](#--enable-opensslall)), and requires ASN.1 support.

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

### `--enable-smallstackcache`

With [`--enable-smallstack`](#--enable-smallstack), keep the scratch buffers that the small stack code would otherwise allocate on every call (for example in SHA-256, RSA and the RNG) allocated in the object for its lifetime (defines `WOLFSSL_SMALL_STACK_CACHE`). This trades memory for fewer allocations. It has no effect without `--enable-smallstack`. Off by default, but on by default for kernel module builds.

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

### `--disable-benchmark`

The wolfCrypt benchmark program (`wolfcrypt/benchmark/benchmark`) is built with the wolfCrypt tests by default. `--disable-benchmark` builds the tests without it. Kernel module builds turn it off.

### `--enable-staticmemory`

Enable static memory use

### `--enable-mcapi`

Enable Microchip API

### `--enable-asynccrypt`

Enable Asynchronous Crypto

When no hardware backend (Cavium, Intel QuickAssist, crypto callbacks or PK callbacks) is enabled, this also turns on the software simulator (`WOLFSSL_ASYNC_CRYPT_SW`, see [`--enable-asynccrypt-sw`](#--enable-asynccrypt-sw)).

### `--disable-asyncthreads`

With [`--enable-asynccrypt`](#--enable-asynccrypt), build the POSIX threads helpers of the asynchronous crypto layer (`wc_AsyncThreadCreate()` and related functions, used for example by the Intel QuickAssist port), and link with `-lpthread`. On by default when a POSIX threads library is found. `--disable-asyncthreads`, like any build without asynchronous crypto, defines `WC_NO_ASYNC_THREADING` instead.

### `--enable-sessionexport`

Enable export and import of sessions

### `--enable-aeskeywrap`

Enable AES key wrap support (RFC 3394). To also build AES Key Wrap with Padding (RFC 5649), pass `--enable-aeskeywrap=padding`; it is provided by `wc_AesKeyWrap_Pad()` and `wc_AesKeyWrap_Pad_ex()` and supports crypto callbacks. New in wolfSSL 5.9.4.

### `--enable-jobserver`

Values: `yes` (default) / `no` / `#`

When using `make` this builds wolfSSL using a multithreaded build, `yes` (default) detects the number of CPU cores and builds using a recommended amount of jobs for that count, `#` to specify an exact number. This works in a similar way to the `make -j` option.

### `--enable-shared[=PKGS]`

Building shared wolfSSL libraries [default=yes]

Disabling the shared library build will exclude a wolfSSL shared library from being built. By default only a shared library is built in order to save time and space.

### `--enable-static[=PKGS]`

Building static wolfSSL libraries [default=no]

### `--with-libsuffix=SUFFIX`

Add `SUFFIX` to the name of the library, for example `--with-libsuffix=custom` builds `libwolfsslcustom.so` instead of `libwolfssl.so` (and the same for the static library). Not set by default.

### `--with-liboqs=PATH`

Deprecated and ignored since wolfSSL 5.9.4. Support for liboqs is gone: Falcon, the last algorithm that still used it, has a native wolfCrypt implementation that you enable with [`--enable-falcon`](#--enable-falcon). Passing the option only prints a configure warning. Please see the appendix [Experimenting with Post-Quantum Cryptography](appendix09.md#experimenting-with-post-quantum-cryptography) in this document for more details.

### `--with-wnr=PATH`

Whitewood netRandom support has been removed. configure still accepts the option, but only to stop with the error "Whitewood netRandom support has been removed" (`--without-wnr` is accepted silently).

### `--with-libz=PATH`

Optionally include libz for compression.

Enabling libz will allow compression support in wolfSSL from the libz library. Think twice about including this option and using it by calling [`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression). While compressing data before sending decreases the actual size of the messages being sent and received, the amount of data saved by compression usually takes longer in time to analyze than it does to send it raw on all but the slowest of networks.

### `--with-cavium`

Path to cavium/software directory.

### `--with-cavium-v`, `--with-octeon-sync` and `--with-intelqa`

Further asynchronous crypto hardware backends, each taking the path to the vendor software: `--with-cavium-v=PATH` for Cavium Nitrox V, `--with-octeon-sync=PATH` for the Cavium Octeon SDK (synchronous use) and `--with-intelqa=PATH` for the Intel QuickAssist (QAT) driver.

### `--with-intelqa-sync=PATH`

Use the Intel QuickAssist (QAT) driver at `PATH` synchronously, through the crypto callbacks instead of the asynchronous crypto layer (defines `HAVE_INTEL_QA_SYNC` and builds `wolfcrypt/src/port/intel/quickassist_sync.c`). Not set by default. Requires [`--enable-cryptocb`](#--enable-cryptocb) and cannot be combined with `--with-intelqa`.

### `--enable-rsavfy`

Enables RSA verify only support (**note** requires [`--enable-cryptonly`](#--enable-cryptonly))

### `--enable-rsapub`

Enables RSA public key only support (**note** requires [`--enable-cryptonly`](#--enable-cryptonly))

### `--enable-armasm`

Enables ARMv8 ASM support. It also covers 32-bit ARM, including Thumb2 targets such as ARMv7-M.

The default configure sets mcpu or mfpu based on 64 vs 32 bit system. It does not overwrite mcpu or mfpu setting passed in by use of CPPFLAGS. On some compilers `-mstrict-align` may be needed due to the constraints and `-mstrict-align` is now also set by default unless a user passes in mcpu/mfpu flags with `CPPFLAGS`.

The option takes a comma separated list of sub-options:

* `inline`: use the inline assembly versions.
* `no-crypto`: do not use the ARMv8 cryptographic extension instructions.
* `sha512-crypto` / `sha3-crypto` (AArch64 only): use the SHA-512 and SHA-3 instructions (ARMv8.2-A); `no-sha512-crypto` / `no-sha3-crypto` turn them off.
* `sm3`, `sm4` (AArch64 only): use the SM3 and SM4 instructions.
* `barrier-sb`, `barrier-detect` (AArch64 only): use the SB speculation barrier instruction (ARMv8.5-A and later), always or when detected at run time.
* `sha256-small`, `aes-block-dup` (32-bit ARM only): smaller SHA-256 code, and duplicated (inlined) AES block code.
* `no-base`, `no-neon-impl` (32-bit ARM only): drop the base and NEON run-time fallbacks when the crypto extension is always present.

### `--with-arm-target=TARGET`

For 32-bit ARM hosts, select the ARM variant of the SP math code. `thumb` uses the Thumb code (`WOLFSSL_SP_ARM_THUMB`, or `WOLFSSL_SP_ARM_THUMB_ASM` with [`--enable-sp-asm`](#--enable-sp-asm)) and adds `-mthumb -march=armv6`; `cortex` uses the Cortex-M C code (`WOLFSSL_SP_ARM_CORTEX_M`) and adds `-mcpu=cortex-r5`. Not set by default. The option does nothing on other hosts.

### `--enable-riscv-asm`

Enable RISC-V assembly. Off by default. Takes a comma separated list of the instruction set extensions to use, for example `zbb`, `zbc`, `zbkb`, `zkned`, `zv` and the vector crypto extensions `zvbb`, `zvbc`, `zvkg` and `zvkned`.

### `--enable-ppc32-asm` and `--enable-ppc64-asm`

Enable PowerPC 32-bit or 64-bit assembly. Off by default. Both take `inline`, `inline-reg` and `small`; `--enable-ppc32-asm` also takes `spe`, and `--enable-ppc64-asm` also takes `crypto` and `power8`.

### `--disable-tlsv12`

Disable TLS 1.2 support. wolfSSL 5.9.4 and later define [`WOLFSSL_NO_TLS12`](#wolfssl_no_tls12) with this option, so the TLS 1.2 implementation is compiled out. Before that, the option only changed the configure summary and a peer could still negotiate TLS 1.2.

### `--disable-tls13`

TLS 1.3 support is enabled by default. `--disable-tls13` builds without it.

TLS 1.3 is also turned off automatically when no usable key exchange is available (none of ECC, RSA with DH, Curve25519 with Ed25519, Curve448 with Ed448, PSK or ML-KEM). To produce a wolfSSL build that is only TLS 1.3, use [`--disable-tlsv12`](#--disable-tlsv12); old TLS versions are already off by default.

### `--enable-tls13-draft18`

Accepted so that old build scripts keep working, but it does nothing: wolfSSL only implements the final TLS 1.3 (RFC 8446). The configure help text still describes it as enabling TLS 1.3 draft 18.

### `--enable-earlydata`

Enable TLS 1.3 early data (0-RTT), defines `WOLFSSL_EARLY_DATA`. Off by default. Needs TLS 1.3 and session tickets or PSK. `--enable-earlydata=group` also sends the early data together with the ClientHello (`WOLFSSL_EARLY_DATA_GROUP`).

### `--enable-postauth`

Enable TLS 1.3 post-handshake authentication (defines `WOLFSSL_POST_HANDSHAKE_AUTH`). Off by default.

### `--enable-hrrcookie`

Let the server send a Cookie extension, holding its state, in a TLS 1.3 HelloRetryRequest (defines `WOLFSSL_SEND_HRR_COOKIE`). A client always echoes back a cookie it receives. Off by default for TLS, but turned on by [`--enable-dtls13`](#--enable-dtls13).

### `--enable-tls13-middlebox-compat`

Enable client side TLS 1.3 middlebox compatibility mode (RFC 8446 Appendix D.4): the client sends a fake session ID and a ChangeCipherSpec message. The server side is always on. Off by default, and not available with ECH.

### `--enable-quic`

Enable the QUIC API on top of TLS 1.3 (defines `WOLFSSL_QUIC`). Off by default. Needs TLS 1.3 and AES-GCM, and turns on the OpenSSL compatibility layer, AES-CTR, ALPN, SNI and (outside FIPS builds) Curve25519.

### `--disable-tls`

TLS support is enabled by default. `--disable-tls` builds without the TLS layer (defines `NO_TLS`), and DTLS then defaults to off. [`--enable-cryptonly`](#--enable-cryptonly) turns TLS off too.

### `--enable-all`

Enables all wolfSSL features, excluding SSL v3

### `--enable-enterprise`

Enable a maximum interoperability feature set, comparable to a default OpenSSL build. Off by default. It turns on [`--enable-all`](#--enable-all) and [`--enable-all-quantum-crypto`](#--enable-all-quantum-crypto), but leaves RC2 and DES3 off unless they are requested.

### `--enable-all-crypto`

Enables all wolfCrypt algorithms except the quantum-resistant asymmetric ones (use [`--enable-all-quantum-crypto`](#--enable-all-quantum-crypto) for those). wolfSSL 5.9.4 stopped pulling non-FIPS or legacy algorithms into a FIPS build. Those moved to the two bundles below; you can enable or disable them explicitly alongside `--enable-all-crypto` for subtractive selection.

### `--enable-all-nonfips-crypto`

Enables every wolfCrypt algorithm that is not FIPS approved. Off by default.

### `--enable-all-legacy-crypto`

Enables every legacy wolfCrypt algorithm. Off by default.

### `--enable-all-quantum-crypto`

Turns on all the quantum-resistant asymmetric algorithms: ML-KEM, ML-DSA, SLH-DSA, LMS and XMSS. Off by default. With `--enable-experimental` it also enables FrodoKEM, Falcon and the extra PQ/T hybrid groups (the extra hybrids only on non-FIPS or pre-v7 FIPS builds).

### `--enable-asio`

Enables ASIO.

Requires that the options [`--enable-opensslextra`](#--enable-opensslextra) and [`--enable-opensslall`](#--enable-opensslall) be enabled when configuring wolfSSL. If these two options are not enabled, then the autoconf tool will automatically enable these options to enable ASIO when configuring wolfSSL.

### `--enable-qt`

Enables Qt 5.12 onwards support.

Enables wolfSSL build settings compatible with the wolfSSL Qt port. Patch file is required from wolfSSL for patching Qt source files.

### `--enable-qt-test`

Enable Qt test compatibility build.

Enables support for building wolfSSL for compatibility with running the built-in Qt tests.

### `--enable-afalg`

Enables use of Linux module AF\_ALG for hardware acceleration. Additional Xilinx use with `=xilinx`, `=xilinx-rsa`, `=xilinx-aes`, `=xilinx-sha3`

Is similar to [`--enable-devcrypto`](#--enable-devcrypto) in that it leverages a Linux kernel module (AF\_ALG) for offloading crypto operations. On some hardware the module has performance accelerations available through the Linux crypto drivers. In the case of Petalinux with Xilinx the flag `--enable-afalg=xilinx` can be used to tell wolfSSL to use the Xilinx interface for AF\_ALG.

### `--enable-devcrypto`

Enables use of Linux `/dev/crypto` for hardware acceleration.

Has the ability to receive an argument, one of `aes` (all aes support), `hash` (all hash algorithms), `hmac` (HMAC only, `WOLFSSL_DEVCRYPTO_HMAC`), `rsa` (RSA only) or `cbc` (aes-cbc only). Each value is matched on its own, so the values cannot be combined in one argument. If no options are given, it will default to using `all`.

### `--enable-mcast`

Enable wolfSSL DTLS multicast support

### `--disable-pkcs12`

Disable PKCS12 code

### `--enable-psk-one-id`

Enables support for single PSK ID with TLS 1.3

### `--enable-cryptocb`

Enable crypto callbacks. Register a crypto callback using `wc_CryptoCb_RegisterDevice` and set the associated devId using `wolfSSL_CTX_SetDevId`. wolfSSL 5.9.4 rejects registering the same device ID twice with `ALREADY_E`, and `wc_CryptoCb_IsDeviceRegistered()` tells you whether a device ID is registered. The old name `--enable-cryptodev` is a deprecated alias.

The following defines can be used with `--enable-cryptocb` to compile out the software fallback of an algorithm to optimize for footprint reduction when the software implementation is not required.

* `WOLF_CRYPTO_CB_ONLY_RSA` - compiles out RSA software crypto fallback
* `WOLF_CRYPTO_CB_ONLY_ECC` - compiles out ECC software crypto fallback
* `WOLF_CRYPTO_CB_ONLY_ED25519`, `WOLF_CRYPTO_CB_ONLY_CURVE25519`, `WOLF_CRYPTO_CB_ONLY_CURVE448` - compile out the software Ed25519 / Curve25519 / Curve448 implementations
* `WOLF_CRYPTO_CB_ONLY_SHA256`, `WOLF_CRYPTO_CB_ONLY_SHA512`, `WOLF_CRYPTO_CB_ONLY_AES` - compile out the software SHA-256 / SHA-512 / AES implementations
* `WOLF_CRYPTO_CB_ONLY_SLHDSA` - compiles out the software SLH-DSA implementation
* `WOLF_CRYPTO_CB_ONLY_MLKEM`, `WOLF_CRYPTO_CB_ONLY_MLDSA`, `WOLF_CRYPTO_CB_ONLY_FALCON`, `WOLF_CRYPTO_CB_ONLY_FRODOKEM`, `WOLF_CRYPTO_CB_ONLY_LMS`, `WOLF_CRYPTO_CB_ONLY_XMSS` - compile out the software ML-KEM / ML-DSA / Falcon / FrodoKEM / LMS / XMSS implementations

`--enable-cryptocb=only` turns on the `WOLF_CRYPTO_CB_ONLY_*` flag of every enabled algorithm listed above, so all crypto operations are offloaded. `--enable-cryptocb=no-default-devid` enables callbacks without a platform specific default device ID.

Use of the `WOLF_CRYPTO_CB_ONLY_*` options requires disabling the examples. See [`--disable-examples`](#--disable-examples)

Related options: `--enable-cryptocb-rsa-pad` (defines `WOLF_CRYPTO_CB_RSA_PAD`) passes the RSA padding parameters to the callback so that it can do the padding itself, and `--disable-cryptocb-sw-test` (defines `WC_TEST_NO_CRYPTOCB_SW_TEST`) stops the wolfCrypt tests from also testing the crypto callbacks with software crypto. Both require `--enable-cryptocb`.

### `--enable-cryptocbutils`

Enables crypto callback utilities (all of them when the option is given with no list). Requires `--enable-cryptocb`. Takes a comma separated list from `copy`, `free`, `setkey`, `export` and `keystore`. The `keystore` item adds `WC_ALGO_TYPE_KEYSTORE` and the `wc_KeyStore_*` API in `wolfssl/wolfcrypt/wc_keystore.h` for keys that live in a hardware key store; see [`WOLF_CRYPTO_CB_KEYSTORE`](#wolf_crypto_cb_keystore).

### `--enable-reproducible-build`

Suppresses the binary jitter (timestamps and other non-functional metadata) to allow generation of bitwise-identical binary packages with identical hashes.

### `--disable-sys-ca-certs`

Enabled by default (defines `WOLFSSL_SYS_CA_CERTS`); `--disable-sys-ca-certs` turns it off. It is turned off automatically when no certificate support is built, or, outside macOS and Windows, when the filesystem is disabled.

Allows wolfSSL to use trusted system CA certificates for verification when [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs) is called, either by loading them into wolfSSL certificate manager, or by invoking system authentication APIs. See [`wolfSSL_CTX_load_system_CA_certs()`](group__CertsKeys.md#function-wolfssl_ctx_load_system_ca_certs) for more details.

### `--with-sys-crypto-policy=PATH`

Build in support for a system-wide crypto policy file, such as the wolfSSL back end of the Fedora crypto-policies (defines [`WOLFSSL_SYS_CRYPTO_POLICY`](#wolfssl_sys_crypto_policy) and `WOLFSSL_CRYPTO_POLICY_FILE`). Without `PATH` the default file is `/etc/crypto-policies/back-ends/wolfssl.config`. Nothing is read at build time: the application loads the policy with `wolfSSL_crypto_policy_enable()`, which uses the configured file when passed `NULL`. Not set by default, but [`--enable-enterprise`](#--enable-enterprise) turns it on with the default path.

### `--enable-argon2`

Enable Argon2 password hashing (RFC 9106) with all three variants, Argon2d, Argon2i and Argon2id. Off by default. Only version 0x13 is implemented. Argon2 is specified in terms of BLAKE2b, so BLAKE2b is pulled in automatically; the option cannot be combined with `--disable-blake2b`. Defines `HAVE_ARGON2`.

The one-shot `wc_Argon2()` / `wc_Argon2_ex()` functions derive a single tag. For applications that derive many tags, the reusable context API (`wc_Argon2Init()`, `wc_Argon2SetParams()`, `wc_Argon2DeriveTag()`, `wc_Argon2Free()`, plus `wc_Argon2New()` / `wc_Argon2Delete()` unless `WC_NO_CONSTRUCTORS`) allocates the memory block array once and reuses it. The context API is new in wolfSSL 5.9.4.

### `--enable-argon2-threads`

Fills the segments of an Argon2 slice in parallel using threads. Off by default. The derived tag does not change. The one-shot functions use one thread per lane; with the context API the thread count comes from `wc_Argon2SetThreads()`. Requires `--enable-argon2`. Defines `WOLFSSL_ARGON2_THREADS`.

### `--enable-aesgcm-siv`

Enable AES-GCM-SIV (RFC 8452), the nonce misuse resistant AEAD. Written in C with assembly for Intel x64, ARM64, ARM32 and Thumb2. Off by default. Requires AES-GCM (`--enable-aesgcm`). Defines `WOLFSSL_AESGCM_SIV`. New in wolfSSL 5.9.4.

### `--enable-cshake`

Enable cSHAKE (SP 800-185), the customizable SHAKE extendable output function. Off by default. SHA-3 and SHAKE are enabled automatically. New in wolfSSL 5.9.4.

### `--enable-kmac`

Enable KMAC (SP 800-185), the Keccak based message authentication code. Off by default. KMAC builds on cSHAKE, so `--enable-cshake` is implied. The API is in `wolfssl/wolfcrypt/sha3.h` (`wc_InitKmac128()`, `wc_Kmac128_Update()`, `wc_Kmac128_Final()`, `wc_Kmac128_FinalXof()` and the KMAC256 equivalents). New in wolfSSL 5.9.4.

### `--enable-tsp`

Enable the RFC 3161 Time-Stamp Protocol in wolfCrypt. Off by default. Comes with an OpenSSL compatibility layer, tests, certificates and examples. The API is in `wolfssl/wolfcrypt/tsp.h` (`wc_TspRequest_*`, `wc_TspResponse_*`). `wc_TspResponse_Verify()` requires a trusted TSA certificate, and the request / TstInfo message imprint setters cross-check the digest length against the hash algorithm. Not supported with `--enable-asn=original`. Defines `WOLFSSL_TSP`. New in wolfSSL 5.9.4.

### `--enable-readahead`

Enable TLS receive read-ahead. Off by default. Each `recv()` call reads as much as the receive buffer can hold, which lowers the number of `recv()` calls per record. The feature is compiled in with this option and switched on at runtime per object or context with `wolfSSL_set_read_ahead()` / `wolfSSL_CTX_set_read_ahead()`. Defines [`WOLFSSL_TLS_READ_AHEAD`](#wolfssl_tls_read_ahead). New in wolfSSL 5.9.4.

### `--enable-tls13-sha512`

Keep the SHA-512 transcript hash in a TLS 1.3 only build. Off by default; without it, TLS 1.3 only builds drop the TLS 1.2 transcript state and the SHA-512 transcript to save memory. Defines [`WOLFSSL_TLS13_SHA512`](#wolfssl_tls13_sha512). The CMake equivalent is `WOLFSSL_TLS13_SHA512`.

### `--disable-rng-autolock`

Turns off the per-instance lock that lets one `WC_RNG` be shared between threads. The lock is on by default where the build supports it. See [`WC_RNG_NO_AUTO_LOCK`](#wc_rng_no_auto_lock).

### `--disable-rng-autofork`

Turns off the `pthread_atfork()` handlers that let a forked child keep using a `WC_RNG`. On by default where supported. See [`WC_RNG_AUTOFORK`](#wc_rng_autofork).

### `--disable-rng-autolock-default`

By default every `WC_RNG` gets the shared-use lock unless the caller asks otherwise. `--disable-rng-autolock-default` keeps the lock built in but uses it only for instances that ask for it with `wc_InitRng_ex2()` (defines `WC_RNG_AUTO_LOCK_DEFAULT_OFF`). It cannot be combined with `--disable-rng-autolock`.

### `--enable-rng-bank` and `--enable-rng-extras`

`--enable-rng-bank` builds RNG banks (defines `HAVE_WC_RNG_BANK`) and requires the RNG. `--enable-rng-extras` adds RNG locks, pools, RBGC and daemon support (defines `WC_RNG_EXTRAS`). Both are off by default, except in kernel module builds, where they default to on.

### `--with-rng-seed-device=PATH`

Seed the RNG from the device `PATH` before the default seed sources (defines `WC_RNG_SEED_DEVICE`). Without a path, `/dev/hwrng` is used. Off by default.

### `--enable-wolfEntropy`

Enable wolfEntropy, the software jitter (memory use) entropy source that is designed to be SP 800-90B certifiable. `--enable-wolfentropy` and `--enable-entropy-memuse` are aliases. Off by default, except in kernel module builds that do not use RDRAND or RDSEED.

### `--enable-noisesrc`

Enable the generic SP 800-90B noise source layer (`wc_NoiseSrc_*`) for ports that have a raw physical noise source. Off by default.

### `--enable-puf`

Enable SRAM PUF (physically unclonable function) support (defines `WOLFSSL_PUF` and `WOLFSSL_PUF_SRAM`). Off by default. The value selects the error correction profile: `small`, `balanced` (the default for `yes`), `strong` or `strongest`. HKDF is turned on with it.

### `--enable-asynccrypt-sw`

Enable the asynchronous software-based crypto simulation. Off by default. wolfSSL 5.9.4 added end-to-end support for it with `--enable-all`. Defines [`WOLFSSL_ASYNC_CRYPT_SW`](#wolfssl_async_crypt_sw).

### `--disable-mlkem`

ML-KEM (FIPS 203) / Kyber is enabled by default, except in FIPS builds older than FIPS v7 and when SHA-3, SHAKE128 or SHAKE256 is explicitly disabled. `--disable-mlkem` builds without it; `--enable-kyber` is an alias of `--enable-mlkem`. Defines `WOLFSSL_HAVE_MLKEM`. The option also takes a comma separated list, for example `512`, `768` and `1024` to select parameter sets, `make`, `encapsulate` and `decapsulate` to select operations, `small`, `noasm`, and `original` (or `kyber`) to build the original Kyber algorithm instead of ML-KEM (add `ml-kem` to keep both). The PQ/T hybrid groups use ML-KEM-768 or ML-KEM-1024, so a list that selects only `512` also needs `--enable-tls-mlkem-standalone`.

### `--enable-tls-mlkem-standalone`

Allow ML-KEM as a standalone, non-hybrid TLS 1.3 key exchange. Off by default. It is turned on automatically when ML-KEM and TLS 1.3 are enabled but ECC, Curve25519 and Curve448 are all disabled, since the hybrid groups then have no classical part.

### `--disable-pqc-hybrids`

The PQ/T hybrid key exchange groups (ML-KEM combined with ECDHE or X25519/X448) are enabled by default with ML-KEM (defines `WOLFSSL_PQC_HYBRIDS`). `--disable-pqc-hybrids` turns them off; configure then fails unless `--enable-tls-mlkem-standalone` is also given or ML-KEM is disabled.

### `--enable-extra-pqc-hybrids`

Enable the extra PQ/T hybrid group combinations (defines `WOLFSSL_EXTRA_PQC_HYBRIDS`). Off by default. Requires ML-KEM and `--enable-experimental`, and is not available in FIPS v7 builds.

### `--enable-mldsa`

Enable ML-DSA (FIPS 204) / Dilithium. Off by default. Takes a comma separated list from `all`, `make`, `sign`, `verify`, `verify-only`, `small`, `44`, `65`, `87`, `draft` (or `fips204-draft`, for the FIPS 204 draft version) and `no-ctx`. `verify-only` keeps only signature verification ([`WOLFSSL_MLDSA_VERIFY_ONLY`](#wolfssl_mldsa_verify_only)). Defines `WOLFSSL_HAVE_MLDSA` (`settings.h` also defines the legacy [`HAVE_DILITHIUM`](#have_dilithium) for compatibility). `--enable-dilithium` is an alias.

### `--enable-slhdsa`

Enable SLH-DSA (FIPS 205) stateless hash-based signatures. Plain `--enable-slhdsa` enables the six SHAKE parameter sets; `--enable-slhdsa=sha2,yes` enables all twelve. Other accepted values are `small`, `small-mem`, `128s`, `128f`, `192s`, `192f`, `256s`, `256f`, `no-s`, `no-f`, `sha2-128s` to `sha2-256f`, `no-sha2-s` and `no-sha2-f`. Off by default. Pass `--enable-slhdsa=sha2,yes,verify-only` to keep only verification. With TLS 1.3 / DTLS 1.3, the draft-reddy-tls-slhdsa signature schemes can authenticate the handshake. Defines [`WOLFSSL_HAVE_SLHDSA`](#wolfssl_have_slhdsa). New in wolfSSL 5.9.4.

### `--enable-falcon`

Enable the native wolfCrypt Falcon post-quantum signature scheme. Off by default, needs `--enable-experimental`. wolfSSL 5.9.4 replaced the liboqs wrapper: Falcon needs no external library anymore, supports crypto callbacks, ARM DSP and AArch64 NEON acceleration, and can run inside the Linux kernel. Defines [`HAVE_FALCON`](#have_falcon).

Takes a comma separated list of options:

* `asm`, `double`, `avx2`, `neon`: pick the floating point / FFT backend. The default is the integer `fpr` backend. `double` (also implied by `avx2` and `neon`) and `asm` are mutually exclusive.
* `small-mem`, `smallest-mem`: signer profiles with reduced memory usage. `smallest-mem` works in 20*n bytes (12 KB peak heap at Falcon-512, 22 KB at Falcon-1024).
* `cache-key`, `cache-basis`: opt-in per-key signing caches; with the default integer backend signing runs about twice as fast.
* `level1`, `level5`: build just one Falcon level. `wc_falcon_set_level()` returns `BAD_FUNC_ARG` for a level that is not built.
* `dynamic-keys`: keep the key buffers per level on the heap; `wc_falcon_set_level()` can then return `MEMORY_E`.
* `verify-no-malloc`: verify in a 4*n byte buffer held in the key instead of allocating one per call; a key then verifies one signature at a time.

### `--enable-frodokem`

Enable the FrodoKEM reference implementation. Off by default, needs `--enable-experimental`. It ships with fast, small and small-stack C code and assembly for x86_64, AArch64, AArch32 and Thumb2, plus ASN.1 keys and X.509 certificates. Takes an optional comma separated list: `aes` / `no-aes` and `shake` / `no-shake` select the matrix A generation (SHAKE-128 is the default), `sve` / `no-sve` and `sme` / `no-sme` select the AArch64 SVE and SME matrix acceleration, `small` / `no-small` selects the small code variant, `ephemeral` / `no-ephemeral` adds the eFrodoKEM variants, `no-640`, `no-976` and `no-1344` remove a parameter set, and `no-make-key`, `no-encapsulate` and `no-decapsulate` remove an operation. Every list item also has a standalone form: `--enable-frodokem-shake`, `--enable-frodokem-aes`, `--enable-frodokem-sve`, `--enable-frodokem-sme`, `--enable-frodokem-ephemeral`, `--enable-frodokem-small`, `--enable-frodokem-640`, `--enable-frodokem-976`, `--enable-frodokem-1344`, `--enable-frodokem-make-key`, `--enable-frodokem-encapsulate` and `--enable-frodokem-decapsulate`. Defines `WOLFSSL_HAVE_FRODOKEM`. New in wolfSSL 5.9.4.

### `--enable-lms`

Enable the stateful LMS/HSS hash-based signatures (defines `WOLFSSL_HAVE_LMS`). Off by default. Takes a comma separated list: `verify-only`, `small`, `sha256-192` and `shake256` (add parameter sets), and `no-sha256-256` (remove the SHA-256/256 sets).

### `--enable-xmss`

Enable the stateful XMSS/XMSS^MT hash-based signatures. Off by default. Takes `verify-only` and `small`.

### `--enable-dual-alg-certs`

Enable X9.146 dual key / dual signature certificates in TLS 1.3 (defines `WOLFSSL_DUAL_ALG_CERTS`). Off by default. Requires `--enable-experimental`.

### `--enable-experimental`

Allow experimental settings in the configuration (defines `WOLFSSL_EXPERIMENTAL_SETTINGS`). Off by default. Needed by [`--enable-falcon`](#--enable-falcon), [`--enable-frodokem`](#--enable-frodokem), [`--enable-extra-pqc-hybrids`](#--enable-extra-pqc-hybrids) and [`--enable-dual-alg-certs`](#--enable-dual-alg-certs). Cannot be combined with [`--enable-distro`](#--enable-distro).

### `--enable-usersettings`

Use your own `user_settings.h` instead of the feature flags that configure normally adds to the compiler command line. Configure then only defines `WOLFSSL_USER_SETTINGS` (and `WOLFSSL_USER_SETTINGS_ASM`) and builds all the source files, so the features come from `user_settings.h`, which configure must be able to find (for example in the top directory of the source tree). Off by default. See [Building in a non-standard environment](#building-in-a-non-standard-environment).

### `--enable-heapmath`

Use the legacy heap based `integer.c` math library (defines `USE_INTEGER_HEAP_MATH`) instead of the default SP math. Off by default. It turns SP math off. See [Special Math Optimization Flags](#special-math-optimization-flags).

### Kernel module options

These options build wolfSSL as an operating system kernel module:

* `--enable-linuxkm`: build the Linux kernel module (`libwolfssl.ko`). Off by default.
* `--enable-freebsdkm`: build the FreeBSD kernel module. Off by default.
* `--with-kernel-source=PATH` (or `--with-linux-source=PATH`): the root of the kernel build tree.
* `--with-linux-arch=ARCH`: the architecture (`SRCARCH`) of the Linux kernel build tree.
* `--enable-kernel-settings` (alias `--enable-linuxkm-defaults`): default settings suitable for kernel modules; implied by `--enable-linuxkm` and `--enable-freebsdkm`.
* `--enable-linuxkm-lkcapi-register=LIST`: register wolfCrypt implementations with the Linux kernel crypto API. Takes `none` (the default) or a comma separated list such as `all`, `all-kconfig`, `all-aes`, `cbc(aes)`, `gcm(aes)`, `all-sha`, `all-hmac`, `stdrng`, `ecdsa`, `ecdh`, `rsa`, `dh`, `mldsa` or `mlkem`; prefix an item with `-` to remove it.
* `--enable-freebsdkm-crypto-register`: register wolfCrypt implementations with the FreeBSD kernel opencrypto framework. Off by default.
* `--with-bsd-export-syms=LIST`: the `EXPORT_SYMS` of the FreeBSD kernel module: `YES`, `NO` (the default) or a list of symbols.
* `--enable-kernel-reloc-tables` (alias `--enable-linuxkm-pie`): containerized object build of the wolfCrypt module. Off by default.
* `--enable-kernel-benchmarks` (alias `--enable-linuxkm-benchmarks`): run the crypto benchmarks when the module is loaded. Off by default.
* `--enable-kernel-verbose-debug`, `--enable-kernel-stack-debug`: extra run time debug messages, and run time reporting of stack usage, in the kernel module. Off by default.

### Hardware and secure element options

These options enable ports to hardware crypto engines and secure elements. All are off by default.

* `--enable-caam`: NXP CAAM. See [Building For NXP CAAM](#building-for-nxp-caam).
* `--enable-sec-qoriq`: the NXP QorIQ SEC engine (T1040/T2080).
* `--enable-ele`: the NXP EdgeLock Secure Enclave.
* `--with-se050=PATH`: the NXP SE050 secure element (default path `/usr/local`).
* `--with-els-pkc=PATH`: the NXP EdgeLock ELS/PKC crypto callback port, built against the `els_pkc` checkout at `PATH`.
* `--with-mcux-sdk=PATH` and `--with-els-pkc-platform=SOC`: settings for `--with-els-pkc`. `--with-mcux-sdk` (required with `--with-els-pkc`) is the MCUXpresso SDK checkout (mcux-sdk-ng) that provides the SoC device headers the `els_pkc` platform layer includes. `--with-els-pkc-platform` selects the `els_pkc` platform layer, `rw61x` by default; that is the only platform with a known header layout, so for others pass the SoC include paths in `CPPFLAGS` and the part number in `CFLAGS`. Without `--with-els-pkc` both only print a configure warning.
* `--enable-stsafe`: the STMicroelectronics STSAFE secure element; `=a100` (the default) uses the legacy STSAFE-A1xx SDK and `=a120` uses STSELib.
* `--enable-microchip`: the Microchip/Atmel ATECC508A, ATECC608A and TA100 devices.
* `--with-cryptoauthlib[=PATH]`: link against the Microchip CryptoAuthLib (found with `pkg-config`, in `PATH`, or in `/usr` and `/usr/local`) and build the wolfSSL Microchip/Atmel port (`wolfcrypt/src/port/atmel/atmel.c`) into the library. Requires `--enable-microchip`, which takes the devices as a comma separated list of `508`, `608` and `100` (for example `--enable-microchip=608`).
* `--with-mpfs-athena=PATH`: the Microchip PolarFire SoC Athena F5200 crypto callback port, using the user-crypto (CAL) directory at `PATH`.
* `--with-maxq10xx=PART`: the Analog Devices (Maxim) MAXQ1065 or MAXQ1080 secure authenticator. `PART` is `MAXQ1065` or `MAXQ108x`; configure defines [`WOLFSSL_MAXQ1065`](#wolfssl_maxq1065) or [`WOLFSSL_MAXQ108X`](#wolfssl_maxq108x) and links `lib/libmaxq1065_api.a` or `lib/libmaxq108x_api.a` from the MAXQ SDK. See `wolfcrypt/src/port/maxim/README.md` in the wolfSSL source.
* `--with-tropic01=PATH`: the Tropic Square TROPIC01 secure element, built against the `libtropic` checkout at `PATH`, whose `build/libtropic.a` is linked (defines `WOLFSSL_TROPIC01`). Only static libraries are built.
* `--enable-rtl8735b`: a compile test, on the build host, of the Realtek AmebaPro2 (RTL8735B) hardware unique key (HUK) crypto callback port, with a shim in place of the vendor HAL headers (`WOLFSSL_RTL8735B_HOST_TEST`). On the target, the application supplies the AmebaPro2 HAL include path. Turns on crypto callbacks, and AES-ECB (`HAVE_AES_ECB`) for the whole build.
* `--enable-silabs-cryptocb`: the Silicon Labs EFR32 Secure Element crypto callback port (defines `WOLFSSL_SILABS_CRYPTOCB`). The default, `=host-test`, builds the port against a shim that needs no vendor SDK and does no crypto (`WOLFSSL_SILABS_HOST_TEST`); `=target` builds the real port for an EFR32, with the Simplicity SDK SE Manager include path passed in `CFLAGS`. Turns on crypto callbacks.
* `--enable-iotsafe`: the IoT-Safe secure applet.
* `--enable-iotsafe-hwrng`: with `--enable-iotsafe`, use the IoT-Safe applet as the RNG seed source, or as the whole RNG when the Hash DRBG is disabled (defines [`HAVE_IOTSAFE_HWRNG`](#have_iotsafe_hwrng)).
* `--enable-xilinx`: Xilinx hardened crypto.
* `--enable-kcapi`: use `libkcapi` for crypto; `--enable-kcapi-hash`, `--enable-kcapi-hmac`, `--enable-kcapi-aes`, `--enable-kcapi-rsa`, `--enable-kcapi-dh` and `--enable-kcapi-ecc` select single algorithms.
* `--enable-alterafcs`: Altera Agilex 5 SDM crypto offload via `libfcs`; `=rng` offloads only the RNG.
* `--enable-vaultic`: the WISeKey/SealSQ VaultIC secure element.
* `--enable-cuda`: AES on an NVIDIA GPU with CUDA (`wolfcrypt/src/port/cuda/aes-cuda.cu`). It sets the compiler to `nvcc` and defines `WC_CUDA` and `HAVE_CUDA`.
* `--enable-psa`: use the Platform Security Architecture (PSA) crypto interface (defines `WOLFSSL_HAVE_PSA`). `--with-psa-include=PATH` and `--with-psa-lib=PATH` add the directories of the PSA headers and library, and `--with-psa-lib-name=NAME` links the library with `-lNAME`; with `--enable-psa-lib-static` the file `PATH/NAME` from `--with-psa-lib` is linked statically instead. These options require `--enable-psa`.

### Application and integration options

These options set up wolfSSL for a specific application or wolfSSL product, usually by turning on the OpenSSL compatibility layer and the features the project needs. All are off by default.

* `--enable-all-osp`: turns on a group of these builds at once: Tailscale, wolfGuard, the web server, S/MIME, OpenSSH, lighttpd, nginx, OpenVPN, ASIO, libwebsockets, stunnel, curl and tcpdump (some of them are left out in FIPS or `--enable-sp-math` builds). Cannot be used with kernel module settings.
* Servers, proxies and networking: `--enable-nginx` (nginx), `--enable-openresty` (OpenResty; turns on `--enable-nginx`), `--enable-haproxy` (HAProxy), `--enable-hitch` (Hitch), `--enable-memcached` (memcached), `--enable-curl` (curl), `--enable-libwebsockets` (libwebsockets), `--enable-tcpdump` (tcpdump), `--enable-rsyslog` (rsyslog), `--enable-mosquitto` (Mosquitto), `--enable-openldap` (OpenLDAP).
* Security and VPN: `--enable-wpas` (wpa_supplicant), `--enable-wpas-dpp` (wpa_supplicant with DPP, the Wi-Fi Device Provisioning Protocol; turns on `--enable-wpas` and adds PKCS#7, certificate requests and all custom ECC curves), `--enable-strongswan` (strongSwan), `--enable-krb` (Kerberos 5), `--enable-libssh2` (libssh2), `--enable-libest` (libest), `--enable-tailscale` (Tailscale build dependencies), `--enable-wolfguard` (wolfGuard dependencies).
* Time, DNS and management: `--enable-chrony` (chrony), `--enable-ntp` (NTP), `--enable-bind` (BIND DNS), `--enable-net-snmp` (Net-SNMP), `--enable-sblim-sfcb` (SBLIM SFCB, the Small Footprint CIM Broker).
* Other projects: `--enable-signal` (Signal), `--enable-ffmpeg` (FFmpeg), `--enable-wolfzfs` (wolfZFS; `=kernel` for the kernel build).
* AUTOSAR: `--enable-autosar` builds the AUTOSAR crypto stack shim (Csm, CryIf and Crypto driver) with AES-CBC and random number services (defines `WOLFSSL_AUTOSAR`). `--enable-autosar-cmac` adds the AES-CMAC MAC generate and verify services and turns on CMAC (defines `WOLFSSL_AUTOSAR_CMAC`); it requires `--enable-autosar`. See `wolfcrypt/src/port/autosar/README.md` in the wolfSSL source.
* wolfSentry: `--enable-wolfsentry` turns on the wolfSentry hooks and plugins (defines [`WOLFSSL_WOLFSENTRY_HOOKS`](#wolfssl_wolfsentry_hooks), `HAVE_EX_DATA` and `HAVE_EX_DATA_CLEANUP_HOOKS`, and turns on `OPENSSL_EXTRA`). `--with-wolfsentry=PATH` gives the wolfSentry installation and also turns the option on; `--with-wolfsentry-lib=PATH` and `--with-wolfsentry-include=PATH` give the library and header directories separately (by default `PATH/lib` and `PATH/include`). The test and example programs are linked with `-lwolfsentry`.
* wolfSSL products: `--enable-wolfprovider` (wolfProvider; it turns on `--enable-opensslcoexist`, so it cannot be combined with builds that need `--enable-opensslall`), `--enable-engine` (wolfEngine; plain `--enable-engine` selects a FIPS v2 build, use `--enable-engine=no-fips` without FIPS), `--enable-wolftpm` (wolfTPM), `--enable-wolfssh` (wolfSSH, same as [`--enable-ssh`](#--enable-ssh)), `--enable-wolfclu` (wolfCLU).

### Internal, test and licensed code options

These options are for wolfSSL's own testing and build tooling, or need source code that is only available under a separate license. Most builds do not need them. All are off by default except `--enable-makeclean`.

* `--enable-selftest`: build the wolfCrypt CAVP self test (defines `HAVE_SELFTEST`; `=v2` selects the wolfCrypt 4.1.0 version, other values the 3.14.2 version). It needs the licensed `wolfcrypt/src/selftest.c`, and configure stops with an error without it.
* `--enable-do178`: build the DO-178 code (defines `HAVE_DO178`; otherwise configure defines `NO_DO178`). It needs the separately licensed DO-178 source; the public source does not check these macros.
* `--enable-fortress`: the "SSL fortress" build profile. It defines `FORTRESS`, [`WOLFSSL_ALWAYS_VERIFY_CB`](#wolfssl_always_verify_cb), [`WOLFSSL_AES_COUNTER`](#wolfssl_aes_counter), [`WOLFSSL_AES_DIRECT`](#wolfssl_aes_direct), [`WOLFSSL_DER_LOAD`](#wolfssl_der_load) and [`WOLFSSL_KEY_GEN`](#wolfssl_key_gen), and turns on the OpenSSL compatibility layer, MD5, SHA-384 and SHA-512. It requires AES, and is turned on by [`--enable-openssh`](#--enable-openssh).
* `--enable-memtest`: track memory allocations for testing (defines [`WOLFSSL_TRACK_MEMORY`](#wolfssl_track_memory) and [`WOLFSSL_DEBUG_MEMORY`](#wolfssl_debug_memory)); `=fail` also makes allocations fail at random ([`WOLFSSL_FORCE_MALLOC_FAIL_TEST`](#wolfssl_force_malloc_fail_test)).
* `--enable-puf-test`: test mode for [`--enable-puf`](#--enable-puf), in which `wc_PufSetTestData()` supplies synthetic SRAM data in place of the real SRAM readout (defines `WOLFSSL_PUF_TEST`). Not for production use.
* `--enable-swdev`: build `wc_swdev`, a software crypto callback device that is linked only into the test and example programs, to test builds that leave out software algorithms with the `WOLF_CRYPTO_CB_ONLY_*` options (defines `WOLFSSL_SWDEV` and `WOLF_CRYPTO_CB_FIND`). Requires [`--enable-cryptocb`](#--enable-cryptocb). See `tests/swdev/README.md` in the wolfSSL source.
* `--enable-crypttests-libs`: also build the wolfCrypt test and benchmark code as the libraries `libwolfcrypttest` and `libwolfcryptbench`. Their API is not stable.
* `--disable-makeclean`: by default configure runs `make clean` when it finishes; this option skips it.

### `make sbom` and `make bomsh`

Not configure options but Makefile targets, new in wolfSSL 5.9.4, for EU Cyber Resilience Act compliance. `make sbom` generates a software bill of materials in SPDX 2.3 and CycloneDX 1.6 formats; `make bomsh` generates OmniBOR build provenance.

## Special Math Optimization Flags

### `--enable-fastmath`

Enable the legacy Tom's Fast Math back end (`tfm.c`). Disabled by default. Passing `--enable-fastmath` turns off the default `--enable-sp-math-all`; if `--enable-sp-math-all` or `--enable-sp-math` is also passed explicitly, SP math takes precedence and fastmath is not used.

See USE_FAST_MATH and Big Integer Math Library sections.

### `--enable-fasthugemath`

Enable the legacy Tom's Fast Math back end + huge code. Implies `--enable-fastmath`. The SP math equivalent is `--enable-sp-math-all=huge`, which adds the huge code optimization CFLAGS and defines `WOLFSSL_SP_INT_LARGE_COMBA`.

Enabling fasthugemath includes support for the FastMath library and greatly increases the code size by unrolling loops for popular key sizes during public key operations. Try using the benchmark utility before and after using fasthugemath to see if the slight speedup is worth the increased code size.

### `--enable-sp-math`

Enable Single-Precision (SP) math implementation with restricted algorithm suite. Unsupported algorithms are disabled. Disables the default `--enable-sp-math-all` and fastmath. Cannot be combined with an explicit `--enable-sp-math-all` (configure reports an error), and requires `--enable-sp` for RSA, DH and ECC. On x86_64 and aarch64, `--enable-sp-math` turns on `--enable-sp-asm` by default, which in turn turns on `--enable-sp`.

- Replaces the math implementation with that in sp_int.c
- A minimal implementation, turns on portions of sp_int.c but not all.
- MUST combine with --enable-sp to turn on the solutions in sp_x86_64.c, sp_arm32.c, sp_arm64.c etc (list of files below depending on the target system) to be able to perform RSA/ECC/DH operations.
- Not to be combined with --enable-sp-math-all (below)

FILE LIST (platform dependent, chosen by configure based on system specs or can
be manually controlled when using a Makefile/IDE solution):

* sp_c32.c, sp_c64.c (portable C, 32-bit and 64-bit)
* sp_arm32.c
* sp_arm64.c
* sp_armthumb.c
* sp_cortexm.c
* sp_dsp32.c
* sp_riscv64.c
* sp_x86_64.c
* sp_x86_64_asm.S
* sp_x86_64_asm.asm
* sp_sm2_*.c and sp_sm2_x86_64_asm.S (SM2 variants of the above)

### `--enable-sp-math-all`

Enabled by default. Enable Single-Precision (SP) math implementation with full algorithm suite. Unsupported algorithms are enabled, but unoptimized. Overrides `--enable-fastmath` and `--enable-fasthugemath` when given explicitly. Can be combined with `--enable-sp`.

- Replaces the math implementation with that in sp_int.c
- A FULL implementation, does not depend on --enable-sp to work
- Can be combined with --enable-sp to allow use of the implementations written in portable c assembly (non-hardware specific assembly) in sp_c32.c for 32-bit or sp_c64.c for 64-bit when possible. The rest of the time (when not possible) the implementations in sp_int.c are used. The portable C assembly gives significant performance gains on targets that do not have hardware optimizations available.
- Not to be combined with --enable-sp-math (above)

Takes an optional comma separated list of options:

* `small`: smaller code (defines `WOLFSSL_SP_SMALL`).
* `huge`: larger, faster code (huge code optimization CFLAGS and `WOLFSSL_SP_INT_LARGE_COMBA`).
* `256`, `384`, `521`, `1024`, `2048`, `3072` or `4096`: the maximum key size in bits to support.
* `nomalloc`: defines `WOLFSSL_SP_NO_MALLOC`.
* `neg`: support negative numbers (defines `WOLFSSL_SP_INT_NEGATIVE`).

For example, `--enable-sp-math-all=small,2048`.

**NOTE**: If you are using asymmetric cryptography with key length in bits [256, 384, 521, 1024, 2048, 3072, 4096], you should consider `--enable-sp` (with `--enable-sp-asm` where available) for maximum performance at a larger footprint; add `--enable-sp-math` to drop the generic sp_int code when only those key sizes are needed.

### `--enable-sp-asm`

Enable Single-Precision (SP) assembly implementation.

Can be used to enable Single-Precision performance improvements through assembly with x86\_64, ARM (32-bit, Thumb, Cortex-M, AArch64) and RISC-V 64 architectures. Requires SP (`--enable-sp` is turned on automatically). Not supported for x86\_64 Windows hosts (MinGW/Cygwin).

### `--enable-sp=OPT`

Enable Single-Precision (SP) math for RSA, DH, and ECC to improve performance.

There are many possible values for OPT. Below is a list of ways to call enable-sp and the resulting macros that will be defined as a result. All of these can be combined in a comma separated list. For example, `--enable-sp=ec256,ec384`. The meaning of the macros that will be defined are defined above in the [Proprietary Single Precision (SP) Math Support](#proprietary-single-precision-sp-math-support) section.

**NOTE**:
1) "--enable-sp=small --enable-sp-math" can be smaller than...
2) "--enable-sp-math-all=small"...
as (1) only has implementations of specific key sizes while (2) has implementations to support all key sizes.

**NOTE**: This is for x86_64 and with no other configuration flags; your results may vary depending on your architectures and other configuration flags that you specify. For example, WOLFSSL_SP_384, WOLFSSL_SP_521 and WOLFSSL_SP_4096 in the `yes`, `small` and `smallfast` lists are only enabled for 64-bit Intel/ARM targets (x86_64, amd64, aarch64). WOLFSSL_SP_LARGE_CODE is likewise only defined on those targets, and only when `small` is not used; this applies to every entry below that lists it. HAVE_ECC384 and HAVE_ECC521 are defined together with WOLFSSL_SP_384 and WOLFSSL_SP_521.

#### `--enable-sp=no` or `--disable-sp`

No new macros defined. Equivalent of not using `--enable-sp`.

#### `--enable-sp` or `--enable-sp=yes`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_SP_384 and HAVE_ECC384
* WOLFSSL_SP_521 and HAVE_ECC521
* WOLFSSL_SP_4096
* WOLFSSL_SP_LARGE_CODE

(`WOLFSSL_SP_384`, `WOLFSSL_SP_521`, `WOLFSSL_SP_4096` and `WOLFSSL_SP_LARGE_CODE` are added on 64-bit Intel/ARM targets by default; see the note above. For other targets, the first three should be added manually if needed.)

#### `--enable-sp=small`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_384 and HAVE_ECC384 (64-bit Intel/ARM)
* WOLFSSL_SP_521 and HAVE_ECC521 (64-bit Intel/ARM)
* WOLFSSL_SP_4096 (64-bit Intel/ARM)

#### `--enable-sp=smallfast`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_HAVE_SP_DH
* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL
* WOLFSSL_SP_FAST_MODEXP
* WOLFSSL_SP_384 and HAVE_ECC384 (64-bit Intel/ARM)
* WOLFSSL_SP_521 and HAVE_ECC521 (64-bit Intel/ARM)
* WOLFSSL_SP_4096 (64-bit Intel/ARM)

#### `--enable-sp=ec256` or `--enable-sp=p256` or `--enable-sp=256`

* WOLFSSL_HAVE_SP_ECC

#### `--enable-sp=smallec256` or `--enable-sp=smallp256` or `--enable-sp=small256`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec384` or `--enable-sp=p384` or `--enable-sp=384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384 and HAVE_ECC384
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec384` or `--enable-sp=smallp384` or `--enable-sp=small384`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_384 and HAVE_ECC384
* WOLFSSL_SP_NO_256
* WOLFSSL_SP_SMALL

#### `--enable-sp=ec521` or `--enable-sp=p521` or `--enable-sp=521`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_521 and HAVE_ECC521
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallec521` or `--enable-sp=smallp521` or `--enable-sp=small521`

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_521 and HAVE_ECC521
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

#### `--enable-sp=sm2`

Use together with `--enable-sm2`.

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SM2
* WOLFSSL_SP_NO_256

#### `--enable-sp=smallsm2`

Use together with `--enable-sm2`.

* WOLFSSL_HAVE_SP_ECC
* WOLFSSL_SP_SM2
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
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa2048`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_3072

#### `--enable-sp=smallrsa2048`

* WOLFSSL_HAVE_SP_RSA
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
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_SMALL

#### `--enable-sp=rsa3072`

* WOLFSSL_HAVE_SP_RSA
* WOLFSSL_SP_LARGE_CODE
* WOLFSSL_SP_NO_2048

#### `--enable-sp=smallrsa3072`

* WOLFSSL_HAVE_SP_RSA
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
* WOLFSSL_SP_NO_2048
* WOLFSSL_SP_NO_3072
* WOLFSSL_SP_SMALL

#### `--enable-sp=nomalloc`

* WOLFSSL_SP_NO_MALLOC

#### `--enable-sp=nonblock`

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK
* WOLFSSL_SP_SMALL

#### `--enable-sp=nonblocklarge`

Non-blocking ECC using the larger (not small) implementation.

* WOLFSSL_SP_NO_MALLOC
* WOLFSSL_SP_NONBLOCK

#### `--enable-sp=smallstack`

* WOLFSSL_SP_SMALL_STACK

#### `--enable-sp=transposedtable` and `--enable-sp=notransposedtable`

`transposedtable` is the default: base point table lookups read one byte per block instead of scanning every entry. `notransposedtable` scans every entry of the table instead, so that no memory address depends on the index, and defines:

* WOLFSSL_SP_NO_TRANSPOSED_TABLE

#### `asm`

Combine with other algorithm options to indicate that assembly code is turned on for those options. For example, `--enable-sp=rsa2048,asm`.

#### `noasm`

Turns off the SP assembly code, for example `--enable-sp-math --enable-sp=yes,noasm` on x86_64 or aarch64, where `--enable-sp-math` otherwise turns on `--enable-sp-asm` by default.

## Cross Compiling

Many users on embedded platforms cross compile wolfSSL for their environment. The easiest way to cross compile the library is to use the `./configure` system. It will generate a Makefile which can then be used to build wolfSSL.

When cross compiling, you'll need to specify the host to `./configure`, such as:

```sh
./configure --host=arm-linux
```

You may also need to specify the compiler, linker, etc. that you want to use:

```sh
./configure --host=arm-linux CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux-ranlib
```

After correctly configuring wolfSSL for cross-compilation, you should be able to follow standard autoconf practices for building and installing the library:

```sh
make
sudo make install
```

If you have any additional tips or feedback about cross compiling wolfSSL, please let us know at [facts@wolfssl.com](mailto:facts@wolfssl.com).

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
./configure --enable-static --disable-shared \
        --host=arm-linux CC=arm-linux-gcc \
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
        CFLAGS="-DWOLFSSL_USER_IO -Os" \
        CPPFLAGS="-I./"
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

wolfSSL has been ported to many environments and devices. A portion of these ports and accompanying documentation for them is located in the directory `wolfssl-X.X.X/IDE`, where X.X.X is the current wolfSSL version number. This directory also contains helpful information and code for IDEs used to build wolfSSL for the environments.

PORT Lists:

* Arduino
* Wiced Studio
* CSBench
* SGX Windows and Linux
  * These directories (`wolfssl/IDE/WIN-SGX` and `wolfssl/IDE/LINUX-SGX`) contain Makefiles and Visual Studio solutions for building wolfSSL as a library to be used in an Intel SGX project.
* Hexagon
  * This directory (`wolfssl/IDE/HEXAGON`) contains a Makefile for building with the Hexagon tool chain. It can be used to build wolfSSL for offloading ECC verify operations to a DSP processor. The directory contains a README file to help with the steps required to build.
* Hexiwear
* NetBurner M68K
  * In the directory (`wolfssl/IDE/M68K`) there is a Makefile for building wolfSSL for a MCF5441X device using the Netburner RTOS.
* Renesas
  * This directory (`wolfssl/IDE/Renesas`) contains multiple builds for different Renesas devices. It also has example builds that demonstrate using hardware acceleration.
* XCODE (Xcode)
* Eclipse
* Espressif
* IAR-EWARM
* Rowley Crossworks ARM
* RISCV
* Zephyr (the Zephyr module itself is in the top-level `zephyr` directory)
* INTIME-RTOS
* Android
* apple-universal (Apple platforms xcframework built with configure)
* AURIX (Infineon AURIX Development Studio)
* C2000 (TI C2000 C28x)
* Gaisler-BCC (Gaisler LEON)
* GCC-ARM
* IAR-MSP430
* Infineon (ModusToolbox)
* iotsafe (IoT-SAFE)
* MCUEXPRESSO (NXP MCUXpresso, including RT1170 and RW612)
* MDK5-ARM (Keil MDK 5)
* MPLABX16 (Microchip MPLAB X with XC16)
* MQX
* MYSQL (CMake files for building wolfSSL into MySQL)
* NETOS
* PlatformIO
* QNX (including the CAAM driver)
* SimplicityStudio (Silicon Labs)
* STARCORE
* STM32Cube (STM32CubeIDE and STM32CubeMX)
* VisualDSP
* VS-AZURE-SPHERE and MSVS-2019-AZSPHERE (Microsoft Azure Sphere)
* WINCE
* WORKBENCH (Wind River Workbench with VxWorks)
* XilinxSDK (Xilinx SDK and AMD Vitis)

## Building For NXP CAAM

### i.MX8 (Linux)

#### Known Issues
- If exiting an open HSM key store session before closing up the HSM session (wc_SECO_CloseHSM and wolfSSL_Cleanup or wolfCrypt_Cleanup) the next time the NVM is started up it segfaults. A power cycle is needed to work around it.

#### Limitations Found
- AES operations with large inputs (e.g. 1 megabyte) fail with the SECO getting "Not enough space in shared memory".
- After creating 2 keystores the attempt to create a 3rd will fail. To reset the keystores do rm -rf /etc/seco_hsm and power cycle the device.

#### Intro
On i.MX8 devices there is a SECO hardware module available for heightened security. This module handles AES operations and key storage, limited ECC operations and key storage, and provides a RNG. wolfSSL has been expanded to make use of the SECO where possible. For some algorithms the CAAM on i.MX8 supports them but the SECO module does not yet. In these cases wolfSSL will make calls through /dev/crypto down to a Linux CAAM driver that creates jobs for the CAAM directly. There are some algorithms supported by default with the NXP Linux CAAM driver but not all algorithms that the CAAM supports. wolfSSL has expanded the Linux CAAM driver to add support for additional algorithms. To use both avenues of accessing the CAAM from the same application the "devId" associated with the different code paths can be set, either WOLFSSL_CAAM_DEVID or WOLFSSL_SECO_DEVID. These IDs are used when first initializing a structure to set which code path will be used throughout the lifetime of the structure. If using software only then the default INVALID_DEVID should be set. The exception to this is SECO items that do not use the key store; TRNG, and Hashing.


Versions of software used:

- imx-seco-libs branch imx_5.4.24_2.1.0
- NXP "repo" tool and Yocto build. Documentation on the Yocto setup is in the README of NXP's imx-manifest repository: <https://github.com/nxp-imx/imx-manifest>
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
##### "repo" Setup
Setting up the NXP "repo" command tool was done on Ubuntu 18.04 LTS

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


As of Jan 11, 2022 GitHub is no longer allowing unauthenticated git connections. NXP's repo tool has not yet taken this into account at the time that this document was created (March, 2022). To work around this redirect git://github.com/ to https://github.com/ with the following command:


```
git config --global url."https://github.com/".insteadOf git://github.com/
```


Make the desired directory to build in, for example:

```
mkdir imx-yocto-bsp
cd imx-yocto-bsp/
```

After setting up NXP's "repo" command tool, initialize and sync a directory with the desired version of Linux. In this case 5.4.24_2.1.0. NXP's i.MX repositories were moved from CodeAurora (source.codeaurora.org, now retired) to GitHub, so the manifest is fetched from <https://github.com/nxp-imx/imx-manifest>.

```
repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-zeus -m imx-5.4.24-2.1.0.xml
repo sync

DISTRO=fsl-imx-wayland MACHINE=imx8qxpc0mek source imx-setup-release.sh -b build-xwayland
```

##### Additional Yocto CAAM Layers
Next download the CAAM driver expansion layers that will apply patches to cryptodev-module, cryptodev-linux, and to files in `linux-imx/drivers/crypto/caam/*`. The base blob and ECDSA (sign/verify/keygen) is located here (<https://github.com/nxp-imx-support/imx_sec_apps>, formerly on source.codeaurora.org). The layer that expands that farther to have RSA black key, ECDH, and Curve25519 support is meta-imx-expand-caam. Place both of these directories into the sources directory next to the other existing meta-\* directories.


```sh
#<assuming in the build-xwayland directory from previous command>

#<either clone the current work or open from a delivered zip>
git clone -b caam_expansion https://github.com/JacobBarthelmeh/imx_sec_apps
cp -r imx_sec_apps/meta-imx-ecdsa-sec ../sources/
cp -r imx_sec_apps/meta-imx-expand-caam ../sources/


# or

git clone https://github.com/nxp-imx-support/imx_sec_apps.git
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


In this build, we had added debugging tools and an SSH server, which are not necessary if looking to trim down on size. The important items to add are "cryptodev-module and cryptodev-linux". "eckey" is a demo tool from NXP for encapsulating and decapsulating blobs.

[Optional]
To add the auto loading of cryptodev module add the following line to conf/local.conf.


```
KERNEL_MODULE_AUTOLOAD += "cryptodev"
```


Otherwise the module will need to be loaded after each power cycle using "modprobe cryptodev".


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
export CRYPTODEV_DIR=`pwd`/tmp/sysroots-components/aarch64/cryptodev-linux/usr/include/
```


To install the toolchain for cross compiling use the following Yocto command

```
bitbake meta-toolchain
sudo ./tmp/deploy/sdk/<version>.sh
```

#### Building NXP HSM
##### Build zlib
There are multiple ways to do this; one is to build it with bitbake as follows.


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

Make install places the results in the subdirectory "export" by default.


#### Building wolfSSL

##### Building Using Autoconf

If setting up the Yocto image with development tools then wolfSSL can be built directly on the system. For a more minimalistic approach cross compiling can be used. Debug messages can be enabled with `--enable-debug`. Extra debug messages specific to the SECO work can be enabled by defining the macro DEBUG_SECO and for the /dev/crypto calls DEBUG_DEVCRYPTO. The extra debug messages for both make use of printf, outputting on the stdout pipe.
There are a couple key enable options for use with SECO: `--enable-caam=seco`, `--enable-devcrypto=seco` and `--with-seco=$HSM_DIR` (where `HSM_DIR` is the `export/usr/` install directory of imx-seco-libs from the step above). configure reads the headers from `$HSM_DIR/include` and links `$HSM_DIR/lib/hsm_lib.a` and `$HSM_DIR/lib/seco_nvm_manager.a`. `--enable-caam` also turns on the crypto callbacks (`WOLF_CRYPTO_CB`) automatically.


Example build with HSM SECO only (no devcrypto support for additional algorithms)


```sh
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

# Install dependencies for building wolfSSL
sudo apt-get install autoconf automake libtool

./autogen.sh
./configure --host=aarch64-poky-linux --with-libz=$ZLIB_DIR --with-seco=$HSM_DIR \
--enable-caam=seco --enable-cmac --enable-aesgcm --enable-aesccm --enable-keygen \
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

- WOLFSSL_SECO_CAAM - Enable SECO HSM use with CAAM (AES-GCM is required and used as the algo for importing plain keys into the HSM). Defining it also defines WOLFSSL_CAAM, WOLFSSL_HASH_KEEP and WOLFSSL_NO_CAAM_BLOB.
- WOLFSSL_CAAM - Main macro switch to enable CAAM support.
- WOLF_CRYPTO_CB - CAAM support makes use of crypto callbacks. This must be defined in user_settings.h; configure adds it automatically for `--enable-caam`.
- WOLFSSL_HASH_KEEP - When hashing with algos like SHA256 build up the message and send it to be hashed only on a call to Final.

WOLFSSL_CAAM turns on the CAAM algorithm support automatically (in `wolfssl/wolfcrypt/settings.h`): WOLFSSL_CAAM_CIPHER (AES, including CMAC as WOLFSSL_CAAM_CMAC), WOLFSSL_CAAM_HASH, WOLFSSL_CAAM_ECC, WOLFSSL_CAAM_HMAC when WOLFSSL_DEVCRYPTO_HMAC is defined, and WOLFSSL_CAAM_CURVE25519 with WOLFSSL_SECO_CAAM. These are not normally set by hand. To turn individual parts off, use:

- WOLFSSL_NO_CAAM_HASH - Do not use the CAAM for hashing.
- WOLFSSL_NO_CAAM_ECC - Do not use the CAAM for ECC.
- WOLFSSL_NO_CAAM_CMAC - Do not use the CAAM for AES-CMAC.
- WOLFSSL_NO_CAAM_AESCCM - Do not use the CAAM for AES-CCM.
- WOLFSSL_NO_CAAM_BLOB - Disable CAAM blob support.
- WOLFSSL_LP_ONLY_CAAM_AES - The CAAM has only the low power AES module, so AES-GCM and AES-XTS are not done by the CAAM.


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
source /opt/fsl-imx-wayland/5.4-zeus/environment-setup-aarch64-poky-linux

$CC -DWOLFSSL_USER_SETTINGS -I /path/to/dir/containing/user_settings.h \
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
This function should be called before doing any operations that require the keystore. Such as ECC or AES operations. The first argument is the keystore ID, "nonce" is the specific 32bit sequence used when creating and unlocking an already existing keystore, "maxUpdates" sets the max number of times the key store can be updated, "flag" is used for optional flags and takes in whether or not the key store is being created. To create the HSM keystore the flag should be CAAM_KEYSTORE_CREATE otherwise to open an existing keystore or update it the flag should be CAAM_KEYSTORE_UPDATE.
- int wc_SECO_CloseHSM(void);
This function must be called when done with the keystore and before calling wolfCrypt_Cleanup/wolfSSL_Cleanup. It closes down the currently open keystore.
- int wc_SECO_GenerateKey(int flags, int group, byte* out, int outSz, int keyType, int keyInfo, unsigned int* keyIdOut);
This function can be used for generating new keys in the SECO. For key generation the flag should be CAAM_GENERATE_KEY. For updating a key the flag should be CAAM_UPDATE_KEY. The keyIdOut argument is an in/out argument that gets populated on key creation and should be set as an input on key update. In the case of updating a key it should be a transient type and the group should be set to 0 for updating. Transient type is set as the keyInfo arg, possible options for keyInfo and KeyTypes are;
    - CAAM_KEY_TRANSIENT (keyInfo)
    - CAAM_KEY_PERSISTENT (keyInfo)
    - CAAM_KEY_KEK (keyInfo, the key is used as a key encryption key)
    - CAAM_KEYTYPE_ECDSA_P256 (keyType)
    - CAAM_KEYTYPE_ECDSA_P384 (keyType)
    - CAAM_KEYTYPE_ECDSA_P521 (keyType)
    - CAAM_KEYTYPE_AES128 (keyType)
    - CAAM_KEYTYPE_AES192 (keyType)
    - CAAM_KEYTYPE_AES256 (keyType)
    - CAAM_KEYTYPE_HMAC224, CAAM_KEYTYPE_HMAC256, CAAM_KEYTYPE_HMAC384, CAAM_KEYTYPE_HMAC512 (keyType, when supported by the NXP HSM library)
- int wc_SECO_DeleteKey(unsigned int keyId, int group, int keyTypeIn);
Used to delete a key from the keystore.
- word32 wc_SECO_WrapKey(word32 keyID, byte* in, word32 inSz, byte* iv, word32 ivSz, int keyType, int keyInfo, int group);
Encrypts the plain key "in" with AES-GCM under a key encryption key and imports it into the keystore. If keyID is 0 the device's unique root KEK is used, otherwise keyID is the ID of a KEK already in the keystore. The IV must be 12 bytes. keyType, keyInfo and group are the same as for wc_SECO_GenerateKey. Returns the new key ID on success and 0 on failure.

##### Native wolfSSL API With CAAM Support

This is a list of native wolfSSL API that now have CAAM support with the SECO build outlined in this documentation.

For generation of any AES encrypt and decrypt operations the key can be generated using the following process. Using wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTYPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut); where groupID is a specified group number and pubOut is a 32 byte buffer, and the variable keyIdOut gets set to the new key ID generated. This new key ID generated can then be set in an Aes structure using wc_SECO_AesSetKeyID(Aes, keyIdOut); . Once the key ID has been set in the structure and the Aes structure has been initialized as a WOLFSSL_SECO_DEVID type it will use that key ID for all encrypt and decrypt operations.

###### ***AES (ECB/CBC)***

Alternatively to generate AES ECB/CBC keys, if the Aes structure has been initialized with WOLFSSL_SECO_DEVID the function wc_AesSetKey can be called with a plain text key passed to it. The API wc_AesSetKey will then try to encrypt the key using the unique KEK and import it into the SECO HSM. If imported successfully, the value of 0 will be returned and the key ID will be set in the Aes structure.


- CBC encrypt would be done with wc_AesCbcEncrypt, decrypt with wc_AesCbcDecrypt.
- ECB encrypt would be done with wc_AesEcbEncrypt, decrypt with wc_AesEcbDecrypt.


Once finished with the Aes structure it must be free'd using wc_AesFree(Aes); .

###### ***AES-GCM***

- GCM encrypt would be done with wc_AesGcmEncrypt, decrypt with wc_AesGcmDecrypt.


The AES-GCM encrypt function takes in the Aes structure, output buffer, input buffer, input buffer size, nonce, nonce size (required to be 12 bytes), MAC or known as tag, tag size (required to be 16 bytes), additional data, additional data size (4 bytes). On encryption the input buffer is encrypted and the tag buffer is filled with a created MAC.

For AES-GCM decrypt the function takes in the Aes structure, plain text output buffer, cipher text input buffer, input buffer size, nonce, nonce size (12 bytes), previously created tag from encryption call, tag buffer size, additional data, additional data size. On decryption the tag buffer is checked to verify the message's integrity.

Once finished with the Aes structure it must be free'd using wc_AesFree(Aes); .

###### ***AES-CCM***

- CCM encrypt would be done with wc_AesCcmEncrypt, decrypt with wc_AesCcmDecrypt.


The AES-CCM encrypt function takes in the Aes structure, output buffer, input buffer, input buffer size, nonce, nonce size (required to be 12 bytes), MAC or known as tag, tag size (required to be 16 bytes), additional data, additional data size (0 bytes). The additional data buffer should be NULL and a size of 0 is required with the NXP HSM library. On encryption the input buffer is encrypted and the tag buffer is filled with a created MAC.

For AES-CCM decrypt the function takes in the Aes structure, plain text output buffer, cipher text input buffer, input buffer size, nonce, nonce size (12 bytes), previously created tag from encryption call, tag buffer size, additional data, additional data size. Similar to the encrypt function the additional data buffer should be NULL. On decryption the tag buffer is checked to verify the message's integrity.

Once finished with the Aes structure it must be free'd using wc_AesFree(Aes); .

###### ***AES CMAC***

For AES CMAC operations the AES key can be generated using wc_SECO_GenerateKey(CAAM_GENERATE_KEY, groupID, pubOut, 0, CAAM_KEYTYPE_AES128, CAAM_KEY_PERSISTENT, &keyIdOut); where groupID is a specified group number and pubOut is a 32 byte buffer, and the variable keyIdOut gets set to the new key ID generated. This new key ID generated can then be set in a Cmac structure using wc_SECO_CMACSetKeyID(cmac, keyIdOut). Once the key ID has been set in the structure and the Cmac structure has been initialized with WOLFSSL_SECO_DEVID it will use that key ID for all CMAC operations.

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

For use with SECO (using the NXP HSM library) the dev ID flag of WOLFSSL_SECO_DEVID should be used when initializing the ecc_key structure. For use with the cryptodev-linux module the dev ID flag WOLFSSL_CAAM_DEVID should be used. After initialization with the function wc_ecc_init_ex(key, heap-hint (can be NULL), devId); then both use cases follow the same function native wolfSSL function calls for sign and verify.

Example function calls after initialization of the ecc_key structure would be:


```lang-c
wc_ecc_make_key(&rng, 32, key); /* 32 byte key size: P-256 */
wc_ecc_sign_hash(hash, hashSz, sigOut, &sigOutSz, &rng, key);
wc_ecc_verify_hash(sig, sigSz, hash, hashSz, &result, key);
```


And with the cryptodev-linux module (WOLFSSL_CAAM_DEVID) the ECDH function can be used:


```lang-c
wc_ecc_shared_secret(keyA, keyB, sharedSecret, &sharedSecretSz);
```

###### ***Hash (Sha256, Sha384, HMAC)***

SHA256 and SHA384 operations use the NXP HSM library. HMAC operations make use of the cryptodev-linux module.

By default SHA operations try to make use of the NXP HSM library, but they can also be explicitly set to the dev ID WOLFSSL_SECO_DEVID.


```lang-c
wc_InitSha256_ex(sha256, heap-hint, WOLFSSL_SECO_DEVID);
wc_InitSha384_ex(sha384, heap-hint, WOLFSSL_SECO_DEVID);
```

Because the NXP HSM library supports a single shot operation for hashing, each call to "update" will store the buffer until a "final" function is called and then pass the whole buffer on to the hardware for creating the hash digest.

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
wc_curve25519_shared_secret(key, keyB, sharedSecretOut, &sharedSecretOutSz);
```

###### ***RNG***

TRNG for seeding the wolfSSL HASH-DRBG makes use of the NXP HSM library. This is compiled in to the wolfcrypt/src/random.c file when wolfSSL is built with --enable-caam=seco. All RNG initializations in wolfSSL will make use of the TRNG for seeding. Standard RNG API calls would be as follows:


```lang-c
wc_InitRng(rng);
wc_RNG_GenerateBlock(rng, output, outputSz);
wc_FreeRng(rng);
```

### i.MX8 (QNX)

On QNX the CAAM is used through a wolfCrypt resource manager. First build wolfSSL with the configure option `--enable-caam=qnx` using the QNX toolchain, for example (set `--host` to match your target):

```sh
source ~/qnx700/qnxsdp-env.sh
./configure --host=arm-unknown-nto-qnx7.0.0eabi --enable-caam=qnx
make
```

Then run `make` in `IDE/QNX/CAAM-DRIVER` to build the resource manager, and start it on the device with root permissions. Any user with access to `/dev/wolfCrypt` can then make use of the driver. On AArch64 the driver assumes an i.MX8 QXP and uses the block of memory set aside for job ring 2.

`IDE/QNX` also contains Makefiles for the wolfSSL library and the wolfCrypt tests, TLS client and server and CMAC examples, and projects for the Momentics IDE. See `IDE/QNX/README.md` for the Momentics import steps and the list of operations supported by the driver (ECC black keys, blobs, cover keys, CMAC, AES-CTR and the TRNG).

### i.MX6 (QNX)

The steps are the same as for i.MX8 (QNX). For i.MX6Q devices build with `--enable-caam=qnx,imx6q`, which defines `WOLFSSL_IMX6Q_CAAM`: that part has only the low power AES module (no AES-GCM) and no CAAM ECC. configure also accepts `imx6ul`. The CAAM base address used by the resource manager is set in `IDE/QNX/CAAM-DRIVER/Makefile`: `-DWOLFSSL_CAAM_IMX6Q` (set by default) selects the i.MX6Q address; without it the i.MX6UL address is used.

### Other CAAM Targets

- `--enable-caam=linux` drives a CAAM job ring directly from a Linux user space process (developed on a QorIQ T1040, accelerating AES-CBC, AES-CTR, AES-ECB and the TRNG). See `wolfcrypt/src/port/caam/README.md` for the required kernel and memory setup.
- For i.MX under INTEGRITY, see `wolfcrypt/src/port/caam/caam_doc.pdf`.

### IMXRT1170 (FreeRTOS)

Example IDE Setup for use with IMXRT1170 can be found in the directory IDE/MCUEXPRESSO/RT1170


#### Build Steps

- Open MCUEXPRESSO and set the workspace to wolfssl/IDE/MCUEXPRESSO/RT1170
- File -> Open Projects From File System... -> Directory : and set the browse to wolfssl/IDE/MCUEXPRESSO/RT1170 directory then click "select directory"
- Select wolfssl_cm7 and wolfcrypt_test_cm7
- Right click the projects -> SDK Management -> Refresh SDK Components and click "yes"
- increase the size of configTOTAL_HEAP_SIZE in FreeRTOSConfig.h (`IDE/MCUEXPRESSO/README.md` uses 200000 for the wolfCrypt test and benchmark projects)
- (note board files need to be recreated .... this can be done by creating a new project that has the same settings and copying over the generated board/* files)
- Build the projects

CSR and PKCS7 examples, and an example of building with CMake, are in the cmake directory of the wolfssl-examples repository (<https://github.com/wolfssl/wolfssl-examples>).


#### Expanding RT1170 CAAM Driver

The files RT1170/fsl_caam_h.patch and RT1170/fsl_caam_c.patch include changes to
the existing NXP CAAM driver for use with creating/opening Blobs and generating
and using ECC black keys.

To apply the patches first create a project that has the caam driver. This will
generate the base fsl_caam.c and fsl_caam.h in the drivers directory (e.g. wolfcrypt_test_cm7/drivers/fsl_caam.{c,h}).
Once the base files are generated then 'cd' to the drivers directory and apply
the patch (cd wolfcrypt_test_cm7/drivers/ && patch < ../../fsl_caam_c.patch && patch < ../../fsl_caam_h.patch)

In the patch for fsl_caam.h there are macros defined for both the ECC and Blob
expansion (CAAM_ECC_EXPANSION and CAAM_BLOB_EXPANSION). When wolfSSL code finds
that these macros are defined (the patch has been applied) then it tries to
compile in use of the expanded driver.
