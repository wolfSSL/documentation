# wolfSSL JNI and wolfJSSE Compilation

This chapter describes several ways to compile wolfJSSE, including using the
Unix command line (make, ant, or Maven), Windows Visual Studio, Android Studio,
and a generic IDE build.

## Unix Command Line

Before following steps in this section, please ensure that the dependencies
listed in Chapter 2 are installed.

### Building with make

The `Makefile` in the root package directory compiles the native JNI C sources
into a shared library (`./lib/libwolfssljni.so` or `./lib/libwolfssljni.dylib`)
and then invokes `ant` to build the Java sources and JAR files. The Makefile
auto-detects between OSX (Darwin) and Linux to set up include paths and the
shared library extension type. It will also auto-detect `JAVA_HOME` if not
already set. To explicitly specify a Java installation, set the `JAVA_HOME`
environment variable before running `make`.

To build and test wolfJSSE:

```
$ cd wolfssljni
$ export JUNIT_HOME=/path/to/junit/jars
$ make
$ make check
```

Available `make` targets are:

- `make` / `make build` (compiles the native JNI library and Java sources/JARs)
- `make check` (builds, then runs JUnit tests, requires `JUNIT_HOME`)
- `make native` (compiles only the native JNI shared library)
- `make clean` (cleans all Java and native artifacts)
- `make clean-native` (cleans only native artifacts)
- `make install` (installs the shared library and JAR files to `/usr/local/lib`,
  or `$PREFIX/lib` if `PREFIX` is set)
- `make uninstall` (removes installed files)

If linking against a native wolfSSL library not installed to `/usr/local`, or
a wolfSSL library with a custom name (for example when wolfSSL was compiled
with `--with-libsuffix`), these can be passed to `make`:

```
$ make WOLFSSL_INSTALL_DIR=/path/to/wolfssl/install WOLFSSL_LIBNAME=wolfssljsse
```

Preset `CFLAGS` can be passed to `make`:

```
$ make CFLAGS="-DWOLFJNI_USE_IO_SELECT"
```

On x86_64 and Aarch64 Linux hosts, `-fPIC` is automatically added to CFLAGS.

Set `V=1` to see the full compiler commands:

```
$ make V=1
```

Set `ENABLE_PATCHES=1` to automatically detect and enable JNI code that depends
on native wolfSSL pull request patches (`WOLFSSL_PR*_PATCH_APPLIED` defines).
This requires a recent build of native wolfSSL that includes those patches,
often newer than the latest tagged wolfSSL release.

```
$ make ENABLE_PATCHES=1
```

### java.sh Script

The `java.sh` script in the root package directory is a convenience wrapper
around the Makefile. It compiles only the native JNI shared library by running
`make clean-native` followed by `make native`, doing a clean rebuild of the
native library each time.

```
$ ./java.sh
```

If linking against a native wolfSSL library not installed to `/usr/local`, one
argument may be passed to `java.sh` which represents the wolfSSL installation
location. For example:

```
$ ./java.sh /path/to/wolfssl/install
```

A second optional argument specifies a custom wolfSSL library name to link
against. This is useful when wolfSSL was compiled with `--with-libsuffix`:

```
$ ./java.sh /usr/local wolfssljsse
```

`CFLAGS` can be set in the environment prior to running the script:

```
$ CFLAGS="-DWOLFJNI_USE_IO_SELECT" ./java.sh
```

## Building with ant

The Java sources can also be compiled by calling `ant` directly, after the
native JNI library has been compiled with `make native` or `java.sh`:

```
$ ant
```

Available build targets for `ant` are :

- `ant` (only builds the jar necessary for an app to use)
- `ant test` (builds the jar and tests then runs the tests, requires JUNIT setup)
- `ant examples` (builds the jar and example cases)
- `ant clean` (cleans all Java artifacts)
- `ant cleanjni` (cleans native artifacts)

To compile and run JUnit tests the command `ant test` (or `make check`) is
used:

```
$ ant test
```

This will compile the tests and main wolfJSSE code, then run the wolfSSL JNI
and wolfJSSE test suites. Results are grouped by test class, with each test
method listed along with the time it took to run in milliseconds. Tests that
are skipped, for example because a feature is not compiled into native wolfSSL,
are labeled `SKIP` instead of showing a time. After each test suite finishes,
a summary line shows the number of tests run, failures, errors, and skipped
tests. A successful build will display the message “BUILD SUCCESSFUL” at the
end.

```
    [junit] WolfSSLContext Class
    [junit]       465.26 ms  testInit
    [junit]       577.66 ms  testWolfJSSEEnabledCipherSuites
    [junit]      1135.56 ms  testJdkTlsDisabledAlgorithms
    [junit]       218.36 ms  testGetSessionContext
    [junit]         0.21 ms  testGetSSLContextFromProvider
    [junit]       205.77 ms  testGetDefaultSSLParameters
    [junit]        78.93 ms  testContextDefaultParamsExcludeAnon
    [junit]         0.18 ms  testGetSessionContextBeforeInit
    [junit]       211.86 ms  testGetSupportedSSLParameters
    [junit]         3.70 ms  testGetSocketFactory
...

BUILD SUCCESSFUL
```

To compile and run examples bundled with wolfJSSE the command `ant examples`
is used:

```
$ ant examples
```

## Building with Maven

wolfJSSE supports building and packaging with Maven for projects that consume
Maven packages.

First, compile the native JNI shared library as described above.
This creates the native library under `./lib`:

```
$ make native
```

Compile the Java sources (output to `./target/classes`):

```
$ mvn compile
```

Compile and run JUnit tests:

```
$ mvn test
```

Package the JAR file (runs tests, then creates `target/wolfssl-jsse-X.X.X-SNAPSHOT.jar`):

```
$ mvn package
```

Generate Javadoc API documentation (output to `./docs/apidocs`):

```
$ mvn javadoc:javadoc
```

Install the JAR to the local Maven repository:

```
$ mvn install
```

The JAR will be installed to a location similar to:

```
~/.m2/repository/com/wolfssl/wolfssl-jsse/X.X.X-SNAPSHOT/wolfssl-jsse-X.X.X-SNAPSHOT.jar
```

The native `libwolfssljni.so` (or `.dylib`) library must be installed on the
native library search path (e.g., `/usr/local/lib`) or the path can be set via
`LD_LIBRARY_PATH` (Linux) or `DYLD_LIBRARY_PATH` (macOS).

Applications can include wolfJSSE as a Maven dependency:

```xml
<dependency>
    <groupId>com.wolfssl</groupId>
    <artifactId>wolfssl-jsse</artifactId>
    <version>1.19.0-SNAPSHOT</version>
</dependency>
```

## Java Module System (JPMS) Build

wolfSSL JNI/JSSE supports the Java Platform Module System (JPMS) introduced in
Java 9. When built with Java 9 or later, the JAR produced is a modular JAR that
works on both the classpath and module path. When built with Java 8,
`module-info.java` is automatically excluded and a standard classpath JAR is
produced.

| JDK Used to Build | Resulting JAR |
| --- | --- |
| Java 8 | Standard JAR (classpath only) |
| Java 9+ | Modular JAR (classpath and module path) |

The modular JAR declares the module `com.wolfssl`, exports the `com.wolfssl`
and `com.wolfssl.provider.jsse` packages, and registers `WolfSSLProvider` as a
`java.security.Provider` service.

To build a modular JAR, use a JDK 9 or newer when building with either ant or
Maven. Maven uses a profile (`java9-module`) that activates automatically on
Java 9+:

```
$ export JAVA_HOME=/path/to/jdk11
$ make
```

Module support can be verified with `jar --describe-module`, which should
print output similar to:

```
$ jar --describe-module --file=lib/wolfssl-jsse.jar
com.wolfssl jar:file:///path/to/lib/wolfssl-jsse.jar!/module-info.class
exports com.wolfssl
exports com.wolfssl.provider.jsse
requires java.logging
uses java.security.Provider
provides java.security.Provider with com.wolfssl.provider.jsse.WolfSSLProvider
```

The modular JAR can be used with `jlink` to create a custom Java runtime that
includes wolfJSSE:

```
$ jlink \
    --module-path lib/wolfssl-jsse.jar \
    --add-modules com.wolfssl \
    --output custom-runtime \
    --no-header-files \
    --no-man-pages
```

## Windows Visual Studio Build

wolfJSSE can be compiled on Windows using Visual Studio. For detailed
instructions, see the `IDE/WIN/README.md` file in the wolfssljni package.

## Android Studio Build

An example Android Studio project is located in the directory `IDE/Android`.
This is an example Android Studio project file for wolfssljni / wolfJSSE.
This project should be used for reference only.

The example project uses Android Gradle Plugin 8.3.1 (Android Studio Iguana
2023.2.1 or newer), Gradle 8.4, and JDK 17 or newer, with compileSdk/targetSdk
33 and minSdk 24. More details on tool and version information can be found in
`wolfssljni/IDE/Android/README.md`. The following steps outline what is
required to run this example on an Android device or emulator.

### 1. Add Native wolfSSL Library Source Code to Project

This example project is already set up to compile and build the native
wolfSSL library source files, but the wolfSSL files themselves have not been
included in this package. You must download or link an appropriate version
of wolfSSL to this project using one of the options below.

The project looks for the directory
`wolfssljni/IDE/Android/app/src/main/cpp/wolfssl` for wolfSSL source code.
This can added in multiple ways:

- OPTION A: Download the latest wolfSSL library release from www.wolfssl.com,
unzip it, rename it to `wolfssl`, and place it in the directory
`wolfssljni/IDE/Android/app/src/main/cpp/`.

```
$ unzip wolfssl-X.X.X.zip
$ mv wolfssl-X.X.X wolfssljni/IDE/Android/app/src/main/cpp/wolfssl
```

- OPTION B: Alternatively GitHub can be used to clone wolfSSL:

```
$ cd /IDE/Android/app/src/main/cpp/
$ git clone https://github.com/wolfssl/wolfssl
$ cd wolfssl
$ ./autogen.sh
$ cp wolfssl/options.h.in wolfssl/options.h
```

- OPTION C: A symbolic link to a wolfssl directory on the system by using:

```
$ cd /IDE/Android/app/src/main/cpp/
$ ln -s /path/to/local/wolfssl ./wolfssl
```

### 2. Update Java Symbolic Links (Only applies to Windows Users)

The following Java source directory is a Unix/Linux symlink:

```
wolfssljni/IDE/Android/app/src/main/java/com/wolfssl
```

This will not work correctly on Windows, and a new Windows symbolic link needs
to be created in this location. To do so:

1) Open Windows Command Prompt (Right click, and "Run as Administrator")
2) Navigate to `wolfssljni\IDE\Android\app\src\main\java\com`
3) Delete the existing symlink file (it shows up as a file called "wolfssl")

```
del wolfssl
```

4) Create a new relative symbolic link with `mklink`:

```
mklink /D wolfssl ..\..\..\..\..\..\..\src\java\com\wolfssl\
```

### 3. Convert Example JKS files to BKS for Android Use

On an Android device BKS format key stores are expected. To convert the
JKS example bundles to BKS use the following commands. Note: you will need
to download a version of the bcprov JAR from the Bouncy Castle website:

```
cd examples/provider
./convert-to-bks.sh <path/to/provider>
```

For example, when using bcprov-ext-jdk15on-169.jar:

```
cd examples/provider
./convert-to-bks.sh ~/Downloads/bcprov-ext-jdk15on-169.jar
```

### 4. Push BKS files to Android Device or Emulator

Push BKS bundles up to the device along with certificates. To do this start
up the emulator/device and use `adb push`. An example of this would be the
following commands from root wolfssljni directory. This step may be done
after the starting Android Studio and compiling the project, but must be done
before running the app or test cases.

```
adb shell mkdir -p /data/local/tmp/examples/provider
adb shell mkdir -p /data/local/tmp/examples/certs/intermediate
adb push ./examples/provider/*.bks /data/local/tmp/examples/provider/
adb push ./examples/certs/ /data/local/tmp/examples/
```

### 5. Import and Build the Example Project with Android Studio

1) Open the Android Studio project by double clicking on the `Android` folder
in wolfssljni/IDE/. Or, from inside Android Studio, open the `Android` project
located in the wolfssljni/IDE directory.

2) Build the project and run MainActivity from app -> java/com/example.wolfssl.
This will print out the server certificate information on success.

3) OPTIONAL: The androidTests can be run to verify functionality.
app->java->com.wolfssl->provider.jsse.test->WolfSSLJSSETestSuite and
app->java->com.wolfssl->test->WolfSSLTestSuite

### Additional Android Build Notes

The example project's `CMakeLists.txt` links native shared libraries with
16 KB ELF segment alignment (`-Wl,-z,max-page-size=16384`), required for
devices using 16 KB memory pages (Android 15+). NDK r28 and later do this by
default, but older NDKs need it set explicitly. Applications integrating
wolfSSL JNI/JSSE into their own Android build should do the same.

The example project also enables Gradle dependency verification, using
SHA-256 checksums stored in `gradle/verification-metadata.xml`. If dependency
or plugin versions are changed, this file needs to be regenerated. See
`IDE/Android/README.md` for instructions.

## Generic IDE Build

For generic IDE builds create a new project in the IDE, then add source files
from `src/java`. This will be the following packages:

```
com.wolfssl
com.wolfssl.provider.jsse
com.wolfssl.provider.jsse.adapter
```

Run java.sh from the command line or have the IDE execute `java.sh` to generate
the native shim layer linking against wolfSSL.

Add native library reference to the project. It should look in the lib
directory for libwolfssljni.so or libwolfssljni.dylib (i.e. wolfssljni/lib/).
 
To compile test cases add the packages `com.wolfssl.provider.jsse.test` and
`com.wolfssl.test` from the directory `src/test`. The project will also need
Junit to run the tests.

If adding in optional examples then the source code in
`examples/provider/` can be added to the project. Optionally the IDE can
execute `examples/provider/ClientJSSE.sh`. One of the difficult parts to adding
in the examples is making sure the path to keystores is known to the IDE when
it runs the examples, if trying to use the default keystores.
