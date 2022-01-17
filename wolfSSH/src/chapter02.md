#  Building wolfSSH

wolfSSH is written with portability in mind and should generally be easy to build on most systems. If you have difficulty building, please don’t hesitate to seek support through our support forums, https://www.wolfssl.com/forums, or contact us directly at support@wolfssl.com.

This section explains how to build wolfSSH on *nix-like and Windows environments, and provides guidance for building in a non-standard environment. You will find a getting started guide and example in section 3.

When using the autoconf/automake system to build, wolfSSH uses a single Makefile to build all parts and examples of the library, which is both simpler and faster than using Makefiles recursively.

##  Getting the Source Code

The most recent, up to date version can be downloaded from the GitHub website here: https://github.com/wolfSSL/wolfSSH

Either click the “Download ZIP” button or use the following command in your terminal:
```
$ git clone https://github.com/wolfSSL/wolfssh.git
```
##  wolfSSH Dependencies

Since wolfSSH is dependent on wolfCrypt, a configuration of wolfSSL is necessary. wolfSSL can be downloaded here: https://github.com/wolfSSL/wolfssl. The simplest configuration of wolfSSL required for wolfSSH is the default build that can be built from the root directory of wolfSSL with the following commands:

```
$ ./autogen.sh (only if you cloned from GitHub)
$ ./configure --enable-ssh
$ make check
$ sudo make install
```
To use the key generation function in wolfSSH, wolfSSL will need to be configured with keygen:` --enable-keygen`.

If the bulk of wolfSSL code isn't desired, wolfSSL can be configured with the crypto only option: `--enable-cryptonly`.

##   Building on *nix

When building on Linux, *BSD, OS X, Solaris, or other *nix-like environments, use the autoconf system. To build wolfSSH run the following commands:
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
##  Building on Windows

The visual studio project file can be found at: https://github.com/wolfSSL/wolfssh/blob/master/ide/winvs/wolfssh.sln

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
also keep wolfSSL, delete that option.

### User Macros for Building on Windows

The solution is using user macros to indicate the location of the wolfSSL library and headers. All paths are set to the default build destinations in the wolfssl64 solution. The user macro wolfCryptDir is used as the base path for finding the libraries. It is initially set to `..\..\..\..\wolfssl`. And then, for example, the additional include directories value for the API test project is set to `$(wolfCryptDir)`.

The wolfCryptDir path must be relative to the project files, which are all one directory down

```
wolfssh/wolfssh.vcxproj
unit-test/unit-test.vcxproj
```
The other user macros are the directories where the wolfSSL libraries for the different builds may be found. So the user macro 'wolfCryptDllRelease64' is initially set to:
```
$(wolfCryptDir)\x64\DLL Release
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
3. wolfSSH defaults to a little endian system unless the configure process detects big endian. Since users building in a non-standard environment aren’t using the configure process, BIG_ENDIAN_ORDER will need to be defined if using a big endian system.
4. Try to build the library and let us know if you run into any problems. If you need help, contact us at support@wolfssl.com.

##  Cross Compiling
Many users on embedded platforms cross compile for their environment. The easiest way to cross compile the library is to use the configure system. It will generate a Makefile which can then be used to build wolfSSH.

When cross compiling, you’ll need to specify the host to configure, such as:
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
If you have any additional tips or feedback for cross compiling wolfSSH, please let us know at info@wolfssl.com.

##  Install to Custom Directory

To setup a custom install directory for wolfSSL use the following:
```
$ ./configure --prefix=~/wolfSSL
$ make
$ make install
```
This will place the library in ~/wolfSSL/lib and the includes in ~/wolfssl/include. To set up a custom install directory for wolfSSH and specify the custom wolfSSL library and include directories use the following:
```
$ ./configure  --prefix=~/wolfssh  --libdir=~/wolfssl/lib  --includedir=~/wolfssl/include
$ make
$ make install
```
Make sure the paths above match your actual locations.

