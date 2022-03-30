#  Requirements

##  Java / JDK

wolfJSSE requires Java to be installed on the host system. There are several JDK variants available to users and developers - including the Oracle JDK, OpenJDK, Zulu JDK, and Android.

##  JUnit

In order to run the unit tests, JUnit is required to be installed on the development system. JUnit can be downloaded from the project website at [www.junit.org]().

To install JUnit on a Unix/Linux/OSX system:

1. Download “ **junit-4.13.jar** ” and “ **hamcrest-all-1.3.jar** ”from [junit.org/junit4/](). At the time of writing, the above mentioned .jar files could be downloaded from the following links:

LINK: [junit-4.13.jar](https://search.maven.org/search?q=g:junit%20AND%20a:junit)
LINK: [hamcrest-all-1.3.jar](https://search.maven.org/artifact/org.hamcrest/hamcrest-all/1.3/jar)

2. Place these JAR files on your system and set **JUNIT_HOME** to point to that location. Ex:

```
$ export JUNIT_HOME=/path/to/jar/files
```
##  gcc and ant

Both “ gcc ” and “ ant ” are used to compile native Ccode and Java code, respectively. Please ensure that these are installed on your development machine.

**Note**: The java.sh script uses a common location for the Java install location. If your Java install location is different, this could lead to an error when running java.sh. In this case, you should modify java.sh to match your environment.

Build targets for ant are :
- ant build (only builds the jar necessary for an app to use)
- ant test (builds the jar and tests then runs the tests, requires JUNIT setup)
- ant examples (builds the jar and example cases)
- ant clean (cleans all Java artifacts)
- ant cleanjni (cleans native artifacts)

##  wolfSSL Library

As a wrapper around the native wolfSSL library, the wolfSSL C library must be installed on the host platform and placed on the include and library search paths.

###  Compiling wolfSSL and wolfCrypt C Library

To compile and install wolfSSL in a Unix/Linux environment for use with wolfJSSE, please follow build instructions in the wolfSSL Manual. The most common way to compile wolfSSL is with the Autoconf system.

When using Autoconf to configure wolfSSL, the “ --enable-jni ”option will need to be used:
```
$ cd wolfssl-X.X.X
$ ./configure --enable-jni
$ make
```
Verify “ make check ” passes successfully, then install the library:
```
$ make check
$ sudo make install
```
This will install the wolfSSL library to your system default installation location. On many platforms this is:
```
/usr/local/lib
/usr/local/include
```
If wolfSSL has installed to a non-standard library installation location, you may need to update LD_LIBRARY_PATH (Unix/Linux) or DYLD_LIBRARY_PATH (OSX):
```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/wolfssl/install
```
