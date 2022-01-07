#  Package Design

wolfJCE is bundled together with the “wolfcrypt-jni” JNI wrapper library. Since wolfJCE depends on the underlying JNI bindings for wolfCrypt, it is compiled into the same native library file and JAR file as wolfcrypt-jni.

For users wanting to use only the JNI wrapper, it is possible to compile a version of “wolfcrypt-jni.jar” that does not include the JCE provider classes.

wolfJCE / wolfCrypt JNI package structure:

```
wolfcrypt-jni /
AUTHORS
build.xml                          ant build script
COPYING
docs /                             Javadocs
jni /                              native C JNI binding source files
lib /                              output directory for compiled library
LICENSING
Makefile generic                   Makefile
Makefile.linux                     Linux-specific Makefile
Makefile.osx                       OSX-specific Makefile
README_JCE.md
README.md
src /
    main/java/                     Java source files
    test/java/                     Test source files
```


The wolfJCE provider source code is located in the “src/main/java/com/wolfssl/provider/jce” directory, and is part of the “**com.wolfssl.provider.jce**” Java package.
 
The wolfCrypt JNI wrapper is located in the “src/main/java/com/wolfssl/wolfcrypt” directory and is part of the “**com.wolfssl.wolfcrypt**” Java package. Users of JCE will not need to use this package directly, as it will be consumed by the wolfJCE classes.

Once wolfCrypt-JNI and wolfJCE have been compiled, the output JAR and native shared library are located in the “./lib” directory. Note, these contain BOTH the wolfCrypt JNI wrapper as well as the wolfJCE provider when a JCE build is compiled.
```
lib/
    libwolfcryptjni.so
    wolfcrypt-jni.jar
```
