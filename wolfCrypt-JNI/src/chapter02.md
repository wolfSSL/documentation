#  Requirements

##  Java / JDK
wolfJCE requires Java to be installed on the host system. There are several JDK variants available to users and developers - including the Oracle JDK and OpenJDK. wolfJCE has currently been tested with OpenJDK, Oracle JDK, and Android. OpenJDK and Android do not require JCE providers to be code signed, whereas the Oracle JDK does. For details on code signing, please see [Chapter 7](chapter07.md#jar-code-signing)

For reference, the specific version of OpenJDK which wolfJCE has been tested with is:
```
$ java -version
Openjdk version “1.8.0_91”
OpenJDK Runtime Environment (build 1.8.0_91-8u91-b14-3ubuntu1~15.10.1~b14)
OpenJDK 64-Bit Server VM (build 25.91-b14, mixed mode)
```
It has also been tested with Oracle JDK 1.8.0_121, and Android 24.

##  JUnit
In order to run the unit tests, JUnit is required to be installed on the development system. JUnit can be downloaded from the project website at www.junit.org.

To install JUnit on a Unix/Linux/OSX system:
1. Download “ **junit-4.13.jar** ” and “ **hamcrest-all-1.3.jar** ”from [junit.org/junit4/](). At the time of writing, the mentioned .jar files could be downloaded from the following links:

LINK: [junit-4.13.jar](https://search.maven.org/search?q=g:junit%20AND%20a:junit)
LINK: [hamcrest-all-1.3.jar](https://search.maven.org/artifact/org.hamcrest/hamcrest-all/1.3/jar)

2. Place these JAR files on your system and set `JUNIT_HOME` to point to that location. Ex:
```
    $ export JUNIT_HOME=/path/to/jar/files
```

## make and ant

Both “make” and “ant” are used to compile native C code and Java code, respectively.

Please ensure that these are installed on your development machine.

## wolfSSL / wolfCrypt Library

As a wrapper around the native wolfCrypt library, wolfSSL must be installed on the host platform and placed on the include and library search paths. wolfJCE can be compiled against either the FIPS or non-FIPS version of the wolfSSL/wolfCrypt native library.

###  Compiling wolfSSL/wolfCrypt 

To compile and install wolfSSL in a Unix/Linux environment for use with wolfJCE, please follow build instructions in the wolfSSL Manual. The most common way to compile wolfSSL is with the Autoconf system.

You can install a wolfSSL (wolfssl-x.x.x), wolfSSL FIPS release (wolfssl-x.x.x-commercial-fips), or wolfSSL FIPS Ready release.In any of these cases, you will need the `--enable-keygen` ./configure option.

**wolfSSL Standard Build**:
```
$ cd wolfssl-x.x.x
$ ./configure --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPSv1 Build**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPSv2 Build**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v2 --enable-keygen
$ make check
$ sudo make install
```

**wolfSSL FIPS Ready Build**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=ready --enable-keygen
$ make check
$ sudo make install
```

This will install the wolfSSL library to your system default installation location. Onmany platforms this is:
```
/usr/local/lib
/usr/local/include
```
