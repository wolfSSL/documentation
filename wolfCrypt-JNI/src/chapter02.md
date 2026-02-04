#  Requirements

##  Java / JDK
wolfJCE requires Java to be installed on the host system. There are several JDK variants available to users and developers - including the Oracle JDK and OpenJDK. wolfJCE has currently been tested with OpenJDK, Oracle JDK, Amazon Coretto, Zulu, Temurin, Microsoft JDK, and Android. Some JDK implementations such as OpenJDK and Android do not require JCE providers to be code signed, whereas the Oracle JDK does. For details on code signing, please see [Chapter 7](chapter07.md#jar-code-signing)

##  JUnit
JUnit is required to be installed on the development system in order to run unit tests. JUnit4 can be downloaded from the project website at www.junit.org.

To install JUnit4 on a Unix/Linux/OSX system:

1) Download " **junit-4.13.2.jar** " and " **hamcrest-all-1.3.jar** "from [junit.org/junit4/](). At the time of writing, the mentioned .jar files could be downloaded from the following links:

Junit: [junit-4.13.2.jar](https://search.maven.org/search?q=g:junit%20AND%20a:junit)

Hamcrest: [hamcrest-all-1.3.jar](https://search.maven.org/artifact/org.hamcrest/hamcrest-all/1.3/jar)

2) Place these JAR files on your system and set `JUNIT_HOME` to point to the directory location they are at. For example:

```
$ export JUNIT_HOME=/path/to/jar/files
```

## make and ant

“make” and “ant” are used to compile native C code and Java code, respectively. Please ensure that these are installed on your development machine.

## wolfSSL / wolfCrypt Library

As a wrapper around the native wolfCrypt library, [wolfSSL](https://www.wolfssl.com/products/wolfssl/)  must be installed and placed on the include and library search paths. wolfJCE can be compiled against either the FIPS 140-2/3 or non-FIPS version of the wolfSSL/wolfCrypt native library.

###  Compiling wolfSSL/wolfCrypt 

To compile and install native wolfSSL in a Unix/Linux environment, please follow build instructions in the [wolfSSL Manual](https://www.wolfssl.com/documentation/manuals/wolfssl/index.html). The most common way to compile wolfSSL is with the Autoconf system using configure.

You can build and install a wolfSSL (wolfssl-x.x.x), wolfSSL FIPS release (wolfssl-x.x.x-commercial-fips), or wolfSSL FIPS Ready release. With any of these archives, you will need to use the `--enable-jni` ./configure option in addition to any other package-specific configure option requirements (ex: `--enable-fips`).

**wolfSSL Standard Build**:
```
$ cd wolfssl-x.x.x
$ ./configure --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPSv2 Build (FIPS 140-2, Certificate #3389)**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v2 --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPSv5 Build (FIPS 140-3, Certificate #4718)**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=v5 --enable-jni
$ make check
$ sudo make install
```

**wolfSSL FIPS Ready Build**:

```
$ cd wolfssl-x.x.x-commercial-fips
$ ./configure --enable-fips=ready --enable-jni
$ make check
$ sudo make install
```

This will install the wolfSSL library to your system default installation location. On many platforms this is:

```
/usr/local/lib
/usr/local/include
```
