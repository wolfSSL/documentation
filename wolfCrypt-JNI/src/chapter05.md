#  Package Design

wolfJCE is bundled together with the “wolfcrypt-jni” JNI wrapper library.
Since wolfJCE depends on the underlying JNI bindings for wolfCrypt, it is
compiled into the same native library file and JAR file as wolfcrypt-jni.

For users wanting to use only the JNI wrapper, it is possible to compile a
version of “wolfcrypt-jni.jar” that does not include the JCE provider classes.

**wolfJCE / wolfCrypt JNI package structure:**

```
wolfcrypt-jni /
    .github                        GitHub Actions workflows
    AUTHORS
    COPYING
    ChangeLog.md                   Version ChangeLog
    IDE/                           IDE Project Files
        WIN/                       Visual Studio Project Files
    LICENSING
    README.md                      Main README
    README_JCE.md                  wolfJCE README
    build.xml                      ant build script
    docs /                         Javadocs
    examples/                      Example applications and certs/keys
        certs/                     Example cert/keys/KeyStores
        provider/                  JCE example apps
    jni/                           Native C JNI binding source files
    lib/                           Compiled library artifacts
    makefile.linux                 Linux-specific Makefile
    makefile.osx                   OSX-specific Makefile
    pom.xml                        Maven build file
    rpm/                           Linux rpm files
    scripts/                       Test scripts (Facebook Infer, etc)
    src/                           Source code
        main/java                  Java source files

```

The wolfJCE provider source code is located in the
`src/main/java/com/wolfssl/provider/jce` directory, and is part of the
“**com.wolfssl.provider.jce**” Java package.
 
The wolfCrypt JNI wrapper is located in the
`src/main/java/com/wolfssl/wolfcrypt` directory and is part of the
“**com.wolfssl.wolfcrypt**” Java package. Users of JCE will not need to use
this package directly, as it will be consumed by the wolfJCE classes.

Once wolfCrypt JNI and wolfJCE have been compiled, the output JAR and native
shared library are located in the `./lib` directory. Note, these contain BOTH
the wolfCrypt JNI wrapper as well as the wolfJCE provider when a JCE build is
compiled.

```
lib/
    libwolfcryptjni.so (libwolfcryptjni.dylib)
    wolfcrypt-jni.jar
```
