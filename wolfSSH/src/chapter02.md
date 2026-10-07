#  Building wolfSSH

wolfSSH is written with portability in mind and should generally be easy to build on most systems. If you have difficulty building, please don't hesitate to seek support through our support forums, https://www.wolfssl.com/forums, or contact us directly at support@wolfssl.com.

This section explains how to build wolfSSH on Linux, un\*x-like (BSD, macOS) and Windows environments, and provides guidance for building in a non-standard environment. You will find a getting started guide and example in section 3.

When using the autotools system to build, wolfSSH uses a single Makefile to build all parts and examples of the library, which is both simpler and faster than using Makefiles recursively.

##  Getting the Source Code

The most recent, up to date version can be downloaded from the GitHub website here: [https://github.com/wolfSSL/wolfssh](https://github.com/wolfSSL/wolfssh).

Either click the "Download ZIP" button or use the following command in your terminal:
```
$ git clone https://github.com/wolfSSL/wolfssh.git
```
##  wolfSSH Dependencies

Since wolfSSH is dependent on wolfCrypt, a configuration of wolfSSL is necessary. wolfSSL can be downloaded here: [https://github.com/wolfSSL/wolfssl](https://github.com/wolfSSL/wolfssl). The simplest configuration of wolfSSL required for wolfSSH is the default build that can be built from the root directory of wolfSSL with the following commands:

```
$ ./autogen.sh (only if you cloned from GitHub)
$ ./configure --enable-wolfssh
$ make check
$ sudo make install
```
To use the key generation function in wolfSSH, wolfSSL will need to be configured with keygen:
```
--enable-keygen
```
If the bulk of wolfSSL code isn't desired, wolfSSL can be configured with the crypto only option:
```
--enable-cryptonly
```

wolfSSH requires wolfSSL built with `--enable-wolfssh` (which defines `WOLFSSL_WOLFSSH`); building wolfSSH against a wolfSSL without it stops with an `#error`. Some wolfSSH features need further wolfSSL options:

- X.509 certificates (`--enable-certs`) use wolfSSL's certificate manager, so wolfSSL must be built with TLS, not `--enable-cryptonly`. Add `--enable-ocsp` to allow OCSP lookups.
- Curve25519 key exchange needs `--enable-curve25519`.
- The ML-KEM hybrid key exchanges need `--enable-mlkem`.
- ML-DSA host keys and user authentication need `--enable-mldsa` and wolfSSL 5.9.2 or later.
- TPM support (`--enable-tpm`) needs wolfSSL built with `--enable-wolftpm`, and wolfTPM.
- The wolfssh client application (`--enable-sshclient`) needs a threaded wolfSSL, and wolfSSL's Base64 encoder (`--enable-base64encode`, on by default only on x86_64).

##   Building with autotools

When building on Linux, BSD, macOS, Solaris, or other un\*x-like environments, use the autotools system. To build wolfSSH run the following commands:
```
$ ./autogen.sh (only if you cloned from GitHub)
$ ./configure
$ make
$ make install
```
You can append build options to the configure command. For a list of available configure options and their purposes run:
```
$ ./configure --help
```
To build wolfSSH run:
```
$ make
```
To ensure that wolfSSH has been built correctly, check to see if all of the tests have passed with:

```
$ make check
```

To install wolfSSH run:
```
$ make install
```

You may need superuser privileges to install, in which case run the install with sudo:
```
$ sudo make install
```
If you want to build only the wolfSSH library located in wolfssh/src/ and not the
additional items (examples and tests) you can run the following command from the
wolfSSH root directory:
```
$ make src/libwolfssh.la
```
##  Build Options

The following options may be given to `./configure`. Each feature option also
defines the preprocessor macro listed for it in the "wolfSSH Preprocessor Guard
Macros" chapter.

| Option | Default | Description |
|-------------------------------|-----------|--------------------------------------------|
| `--with-wolfssl=PATH` | /usr/local | Install prefix of wolfSSL; `PATH/lib` and `PATH/include` must exist. |
| `--enable-debug` | disabled | Add debug code and logging, and turn off optimizations. |
| `--disable-inline` | enabled | Disable inline functions. |
| `--disable-examples` | enabled | Do not build the example programs. |
| `--disable-server` | enabled | Leave out the server code. Cannot be combined with `--disable-client`. |
| `--disable-client` | enabled | Leave out the client code. Cannot be combined with `--disable-server`. |
| `--enable-keygen` | disabled | Key generation API. wolfSSL needs `--enable-keygen`. |
| `--enable-keyboard-interactive` | disabled | Keyboard-interactive user authentication. |
| `--enable-scp` | disabled | SCP support. |
| `--enable-sftp` | disabled | SFTP support. |
| `--disable-sftp-zeroize` | enabled | Do not zero SFTP file data buffers before they are freed. |
| `--enable-fwd` | disabled | TCP/IP port forwarding. |
| `--disable-term` | enabled | Leave out pseudo-terminal support. |
| `--enable-shell` | disabled | Shell support in the echoserver. |
| `--enable-agent` | disabled | ssh-agent support. |
| `--enable-certs` | disabled | X.509 certificate support. |
| `--enable-ossh-certs` | disabled | OpenSSH certificate user authentication. |
| `--enable-windows-cert-store` | disabled | Load keys and certificates from the Windows certificate store. Requires `--enable-certs` and a mingw Windows host; links `crypt32` and `ncrypt`. |
| `--enable-tpm` | disabled | TPM 2.0 support through wolfTPM. |
| `--enable-smallstack` | disabled | Reduce stack usage, allocating large buffers from the heap. |
| `--enable-none-cipher` | disabled | Allow negotiating the insecure "none" cipher and MAC, which turn off encryption and integrity protection. |
| `--enable-sshd` | disabled | Build the wolfSSHd server daemon. Also turns on `--enable-shell`. |
| `--with-pam=PATH` | none | Directory of the PAM library for wolfSSHd. |
| `--enable-sshclient` | disabled | Build the wolfssh client application. |
| `--enable-all` | disabled | Turn on keygen, keyboard-interactive, scp, sftp, fwd, shell, agent, sshd, sshclient and certs. |
| `--enable-distro` | disabled | `--enable-all` plus both shared and static libraries. |

The wolfssh client application runs every session's I/O on threads, so it needs
a threaded wolfSSL. Giving `--enable-sshclient` against a single-threaded
wolfSSL is a configure error, while `--enable-all` leaves the client out instead
of failing.

`--enable-all` does not turn on `--enable-ossh-certs`,
`--enable-windows-cert-store`, `--enable-tpm`, `--enable-smallstack` or
`--enable-none-cipher`; add those explicitly.

In the build tree, `./apps/wolfssh-options` prints the name of each enabled
build option, one per line, for use by test scripts. It is not installed.

##  Building on Windows

The Visual Studio project file can be found in the directory *ide\\winvs*.

The solution file, 'wolfssh.sln', facilitates building wolfSSH and its example and test programs. The solution provides both Debug and Release builds of Static and Dynamic 32- or 64-bit libraries. The file user_settings.h should be used in the wolfSSL build to configure it.

This project assumes that the wolfSSH and wolfSSL source directories are installed side-by-side and do not have the version number in their names:

```
Projects\
wolfssh\
wolfssl\
```

The file `wolfssh\ide\winvs\user_settings.h` contains the settings used to
configure wolfSSL with the appropriate settings. This file must be copied
from the directory `wolfssh\ide\winvs` to `wolfssl\IDE\WIN`. If you change
one copy you must change both copies. The option `WOLFCRYPT_ONLY` disables
the build of the wolfSSL files and only builds the wolfCrypt algorithms. To
also keep wolfSSL, delete that option. X.509 certificate support needs the
TLS layer, so the X.509 block in that file removes `WOLFCRYPT_ONLY` along with
defining `WOLFSSH_CERTS`.

The projects link against the Windows `crypt32.lib` and `ncrypt.lib` import
libraries for the Windows certificate store support
(`WOLFSSH_WINDOWS_CERT_STORE`). To use it, define `WOLFSSH_WINDOWS_CERT_STORE`
as described in the comment block in `user_settings.h`, along with
`WOLFSSH_CERTS`.

### User Macros for Building on Windows

The solution is using user macros to indicate the location of the wolfSSL library and headers. All paths are set to the default build destinations in the wolfssl64 solution. The user macro wolfCryptDir is used as the base path for finding the libraries. It is initially set to `..\..\..\..\wolfssl`. And then, for example, the additional include directories value for the API test project is set to `$(wolfCryptDir)`.

The wolfCryptDir path must be relative to the project files, which are all one directory down

```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```
The other user macros are the directories where the wolfSSL libraries for the different builds may be found. So the user macro 'wolfCryptDllRelease64' is initially set to:
```
$(wolfCryptDir)\DLL Release\x64
```
This value is used in the debugging environment for the echoserver's 64-bit DLL Release build is set to:
```
PATH=$(wolfCryptDllRelease64);%PATH%
```
When you run the echoserver from the debugger, it finds the wolfSSL DLL in that directory.

##  Building in a non-standard environment

While not officially supported, we try to help users wishing to build wolfSSH in a non-standard environment, particularly with embedded and cross-compiled systems. Below are some notes on getting started with this:

1. The source and header files need to remain in the same directory structure as they are in the wolfSSH download package.
2. Some build systems will want to explicitly know where the wolfSSH header files are located, so you may need to specify that. They are located in the <wolfssh_root>/wolfssh directory. Typically, you can add the <wolfssh_root> directory to your include path to resolve header problems.
3. wolfSSH defaults to a little endian system unless the configure process detects big endian. Since users building in a non-standard environment aren't using the configure process, BIG_ENDIAN_ORDER will need to be defined if using a big endian system.
4. Try to build the library and let us know if you run into any problems. If you need help, contact us at support@wolfssl.com.

##  Cross Compiling
Many users on embedded platforms cross compile for their environment. The easiest way to cross compile the library is to use the configure system. It will generate a Makefile which can then be used to build wolfSSH.

When cross compiling, you'll need to specify the host to configure, such as:
```
$ ./configure --host=arm-linux
```
You may also need to specify the compiler, linker, etc. that you want to use:
```
$ ./configure --host=arm-linux CC=arm-linux-gcc AR=arm-
linux-ar
RANLIB=arm-linux
```
After correctly configuring wolfSSH for cross compilation you should be able to follow standard autoconf practices for building and installing the library:

```
$ make
$ sudo make install
```
If you have any additional tips or feedback for cross compiling wolfSSH, please let us know at facts@wolfssl.com.

##  Install to Custom Directory

To setup a custom install directory for wolfSSL use the following:
```
$ ./configure --prefix=~/wolfSSL
$ make
$ make install
```
This will place the library in ~/wolfSSL/lib and the includes in ~/wolfSSL/include. To set up a custom install directory for wolfSSH and point it at that wolfSSL install use the following:
```
$ ./configure  --prefix=~/wolfssh  --with-wolfssl=~/wolfSSL
$ make
$ make install
```
The --with-wolfssl option takes the wolfSSL install prefix and expects to find lib/ and include/ under it. It is what tells wolfSSH where to find wolfSSL. The --libdir and --includedir options set where wolfSSH's own library and headers are installed, they do not affect where wolfSSL is found.

Make sure the paths above match your actual locations.

