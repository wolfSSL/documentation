# wolfSSL JNI and wolfJSSE Compilation

There are three ways to compile wolfJSSE listed in this chapter, including
using the Unix Command Line, Android Studio Build and Generic IDE Build.

## Unix Command Line

Before following steps in this section, please ensure that the dependencies
listed in Chapter 2 are installed.

The `java.sh` script in the root package directory is used to compile the native
JNI C source files into a shared library for either Unix/Linux or Mac OSX.
This script tries to auto-detect between OSX (Darwin) and Linux to set up
include paths and shared library extension type. This script directly calls gcc
on the JNI C source files, producing `./lib/libwolfssljni.so` or
`./lib/libwolfssljni.jnilib`.

```
$ ./java.sh

Compiling Native JNI library:
    WOLFSSL_INSTALL_DIR = /usr/local
    Detected Linux host OS
        Linux x86_64
    Java Home = /usr/lib/jvm/java-8-openjdk-amd64
    Generated ./lib/libwolfssljni.so
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

The script will attempt to auto-detect `JAVA_HOME` if not set. To explicitly
specify a Java installation, set the `JAVA_HOME` environment variable before
running.

Preset `CFLAGS` can be passed to the script via the environment:

```
$ CFLAGS="-DWOLFJNI_USE_IO_SELECT" ./java.sh
```

On Aarch64 hosts, `-fPIC` is automatically added to CFLAGS.

## Building with ant

To compile the Java sources, `ant` is used:

```
$ ant
```

Available build targets for `ant` are :

- `ant` (only builds the jar necessary for an app to use)
- `ant test` (builds the jar and tests then runs the tests, requires JUNIT setup)
- `ant examples` (builds the jar and example cases)
- `ant clean` (cleans all Java artifacts)
- `ant cleanjni` (cleans native artifacts)

These two commands will build the wolfJSSE jar and native code necessary to use
wolfJSSE in a project. To compile and run JUnit tests the command `ant test`
is used:

```
$ ant test
```

This will compile tests and the main wolfJSSE code and output with the results
of the tests will be displayed along with a summary of total tests that passed
at the end of the wolfJSSE testsuite and wolfSSL JNI testsuite. A successful
build will display the message “BUILD SUCCESSFUL” at the end.

```
[junit] WolfSSLTrustX509 Class
[junit] Testing parse all_mixed.jks ... passed
[junit] Testing loading default certs ... passed
[junit] Testing parse all.jks ... passed
[junit] Testing verify ... passed
...

build:

BUILD SUCCESSFUL
Total time: 18 seconds
```

To compile and run examples bundled with wolfJSSE the command `ant examples`
is used:

```
$ ant examples
```

## Building with Maven

wolfJSSE supports building and packaging with Maven for projects that consume
Maven packages.

First, compile the native JNI shared library using `java.sh` as described above.
This creates the native library under `./lib`:

```
$ ./java.sh
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
    <version>1.16.0-SNAPSHOT</version>
</dependency>
```

## Windows Visual Studio Build

wolfJSSE can be compiled on Windows using Visual Studio. For detailed
instructions, see the `IDE/WIN/README.md` file in the wolfssljni package.

## Android Studio Build

An example Android Studio project is located in the directory `IDE/Android`.
This is an example Android Studio project file for wolfssljni / wolfJSSE.
This project should be used for reference only.

More details on tool and version information used when testing can be found in
the `wolfssljni/IDE/Android/README.md`. The following steps outline what is
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
unzip it, rename it to `wolfssl`, and place it in the direcotry
`wolfssljni/IDE/Android/app/src/main/cpp/`.

```
$ unzip wolfssl-X.X.X.zip
$ mv wolfssl-X.X.X wolfssljni/IDE/Android/app/src/main/cpp/wolfssl
```

- OPTION B: Alternatively GitHub can be used to clone wolfSSL:

```
$ cd /IDE/Android/app/src/main/cpp/
$ git clone https://github.com/wolfssl/wolfssl
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

For exmaple, when using bcprov-ext-jdk15on-169.jar:

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
adb shell
cd sdcard
mkdir examples
mkdir examples/provider
mkdir examples/certs
exit
adb push ./examples/provider/*.bks /sdcard/examples/provider/
adb push ./examples/certs/ /sdcard/examples/
adb push ./examples/certs/intermediate/* /sdcard/examples/certs/intermediate/
```

### 5. Import and Build the Example Project with Android Studio

1) Open the Android Studio project by double clicking on the `Android` folder
in wolfssljni/IDE/. Or, from inside Android Studio, open the `Android` project
located in the wolfssljni/IDE directory.

2) Build the project and run MainActivity from app -> java/com/example.wolfssl.
This will ask for permissions to access the certificates in the /sdcard/
directory and then print out the server certificate information on success.

3) OPTIONAL: The androidTests can be run after permissions has been given.
app->java->com.wolfssl->provider.jsse.test->WolfSSLJSSETestSuite and
app->java->com.wolfssl->test->WolfSSLTestSuite

## Generic IDE Build

For generic IDE builds create a new project in the IDE, then add source files
from `src/java`. This will be the following packages:

```
com.wolfssl
com.wolfssl.provider.jsse
com.wolfssl.wolfcrypt
```

Run java.sh from the command line or have the IDE execute `java.sh` to generate
the native shim layer linking against wolfSSL.

Add native library reference to the project. It should look in the lib
directory for libwolfssl.jnilib (i.e. wolfssljni/lib/).
 
To compile test cases add the packages `com.wolfssl.provider.jsse.test` and
`com.wolfssl.test` from the directory `src/test`. The project will also need
Junit to run the tests.

If adding in optional examples then the source code in
`examples/provider/` can be added to the project. Optionally the IDE can
execute `examples/provider/ClientJSSE.sh`. One of the difficult parts to adding
in the examples is making sure the path to keystores is known to the IDE when
it runs the examples, if trying to use the default keystores.
