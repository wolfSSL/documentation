#  Requirements

##  Java / JDK

wolfJSSE requires Java to be installed on the host system. There are several
JDK variants available to users and developers. wolfSSL JNI/JSSE has been tested
on the following:

- Unix/Linux:
    + Oracle JDK
    + OpenJDK
    + Zulu JDK
    + Amazon Corretto
    + Eclipse Temurin
    + Microsoft Build of OpenJDK
- Mac OSX
- Windows (Visual Studio)
- Android Studio
- Android AOSP

##  JUnit

In order to run the unit tests, JUnit 4 is required to be installed on the
development system. JUnit can be downloaded from the project website at
[www.junit.org](http://www.junit.org).

To install JUnit4 on a Unix/Linux/OSX system:

1) Download “ **junit-4.13.2.jar** ” and “ **hamcrest-all-1.3.jar** ”from [junit.org/junit4/](). At the time of writing, the above mentioned .jar files could be downloaded from the following links:

[junit-4.13.2.jar](https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar)<br/>
[hamcrest-all-1.3.jar](https://repo1.maven.org/maven2/org/hamcrest/hamcrest-all/1.3/hamcrest-all-1.3.jar)

2) Place these JAR files on your system and set **JUNIT_HOME** to point to that location. Ex:

```
$ export JUNIT_HOME=/path/to/jar/files
```

##  System Dependencies (make, gcc, and ant)

**gcc** and **ant** are used to compile native C code and Java code, respectively. The included `Makefile` drives both of these, so **make** is also required. Please ensure that these are installed on your development machine. Alternatively, you can choose to compile the Java code with **maven** instead of **ant**.

##  wolfSSL SSL/TLS Library

wolfSSL JNI/JSSE is a wrapper around the native wolfSSL library. As such, the [wolfSSL](https://www.wolfssl.com/products/wolfssl/) C library must be installed on the host platform and placed on the include and library search paths before compiling wolfSSL JNI/JSSE.

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

If building a wolfSSL FIPS or FIPS Ready release bundle, additional configure
options may be required. Reference the wolfSSL Manual and FIPS build
documentation for exact build instructions.

###  Optional Native wolfSSL Features

Some wolfJSSE features depend on additional native wolfSSL configure options:

| Feature | wolfSSL `./configure` Option |
| --- | --- |
| Pre-Shared Key (PSK) cipher suites | Enabled by `--enable-jni` |
| Secure renegotiation | `--enable-secure-renegotiation` |
| ML-KEM (FIPS 203) TLS 1.3 key exchange | `--enable-mlkem` |
| ML-DSA (FIPS 204) certificates | `--enable-mldsa` |
| Pure (non-hybrid) ML-KEM named groups | `--enable-tls-mlkem-standalone` |
| Native debug logging | `--enable-debug` |

For example, to build wolfSSL with post-quantum support for use with wolfJSSE:

```
$ ./configure --enable-jni --enable-mlkem --enable-mldsa
```
