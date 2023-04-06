#  Requirements

##  Java / JDK

wolfJSSE requires Java to be installed on the host system. There are several
JDK variants available to users and developers. wolfSSL JNI/JSSE has been tested
on the following:

- Unix/Linux:
    + Oracle JDK
    + OpenJDK
    + Zulu JDK
    + Amazon Coretto
- Android

The build system for wolfSSL JNI/JSSE has not been set up to run on Microsoft
Windows yet. If this is something you are interested in, contact wolfSSL at
[facts@wolfssl.com](mailto:facts@wolfssl.com). The example Android Studio
project included, under `IDE/Android` has been tested on both Linux and Windows.

##  JUnit

In order to run the unit tests, JUnit 4 is required to be installed on the
development system. JUnit can be downloaded from the project website at
[www.junit.org](http://www.junit.org).

To install JUnit on a Unix/Linux/OSX system:

1) Download “ **junit-4.13.2.jar** ” and “ **hamcrest-all-1.3.jar** ”from [junit.org/junit4/](). At the time of writing, the above mentioned .jar files could be downloaded from the following links:

[junit-4.13.2.jar](https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar)<br/>
[hamcrest-all-1.3.jar](https://repo1.maven.org/maven2/org/hamcrest/hamcrest-all/1.3/hamcrest-all-1.3.jar)

2) Place these JAR files on your system and set **JUNIT_HOME** to point to that location. Ex:

```
$ export JUNIT_HOME=/path/to/jar/files
```

##  System Dependencies (gcc and ant)

**gcc** and **ant** are used to compile native C code and Java code, respectively. Please ensure that these are installed on your development machine.

**Note**: The `java.sh` script uses a common location for the Java install location. If your Java install location is different, this could lead to an error when running `java.sh`. In this case, you should modify `java.sh` to match your environment.

##  wolfSSL SSL/TLS Library

As a wrapper around the native wolfSSL library, the [wolfSSL](https://www.wolfssl.com/products/wolfssl/) C library must be installed on the host platform and placed on the include and library search paths before compiling wolfSSL JNI/JSSE.

###  Compiling wolfSSL and wolfCrypt C Library

To compile and install wolfSSL in a Unix/Linux environment for use with wolfJSSE, please follow build instructions in the [wolfSSL Manual](https://www.wolfssl.com/documentation/wolfssl-manual/index.html). The most common way to compile wolfSSL is using Autoconf.

When using Autoconf to configure wolfSSL, the `--enable-jni` option will need to be used:

```
$ cd wolfssl-X.X.X
$ ./configure --enable-jni
$ make
```

Verify `make check` passes successfully, then install the library:

```
$ make check
$ sudo make install
```

This will install the wolfSSL library to your system default installation location. On many platforms this is:

```
/usr/local/lib
/usr/local/include
```

If wolfSSL has been installed to a non-standard library installation location, you may need to update `LD_LIBRARY_PATH` (Unix/Linux) or `DYLD_LIBRARY_PATH` (OSX):

```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/wolfssl/install
```
