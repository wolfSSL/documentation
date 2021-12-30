#  Package Design

wolfJSSE is bundled together with the wolfSSL JNI wrapper in the “ **wolfssljni** ” package. Since wolfJSSE depends on the underlying JNI bindings for wolfSSL, it is compiled into the same native library file as the JNI wrapper.

wolfJSSE / wolfSSL JNI package structure:
```
**wolfssljni** /
build.xml ant build script
COPYING
**docs** / Javadocs
**examples** / Example apps
java.sh Script to build native C JNI sources
**lib** / output directory for compiled library
native / native C JNI binding source files
README_JSSE.md
README.md
src /
java / Java source files
test / Test source files
```
The **wolfJSSE** provider source code is located in the“src/java/com/wolfssl/provider/jsse” directory, and is part of the “ **com.wolfssl.provider.jsse** ”Java package.

The **wolfSSL JNI** wrapper is located in the “src/java/com/wolfssl”directory and is part of the “ **com.wolfssl** ” Java package. Users of JSSE will not need to use this package directly, as it will be consumed by the wolfJSSE classes.

Once wolfSSL JNI and wolfJSSE have been compiled, there are two JAR files and one native shared library that have been generated. These are located in the “./lib” directory.
```
lib/
**libwolfSSL.so** (native C JNI wrapper shared library)
**wolfssl.jar** (JAR with ONLY wolfSSL JNI Javaclasses)
**wolfssl-jsse.jar** (JAR with BOTH wolfSSL JNI and wolfJSSE classes)
```

