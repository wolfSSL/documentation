#  Compilation

Before following steps in this section, please ensure that the dependencies in [Chapter 2](chapter02.md#requirements) above are installed.

Before running `make`, copy the correct “makefile” for your system, depending if you are on Linux/Unix or macOS. For example, if you were on Linux:

```
$ cd wolfcrypt-jni
$ cp makefile.linux makefile
```

If you are instead on Mac OSX:

```
$ cd wolfcrypt-jni
$ cp makefile.macosx makefile
```

Then compile the native C JNI source code with “make”. This will generate the native JNI shared library (`libwolfcryptjni.so/dylib`).

```
$ cd wolfcrypt-jni
$ make
```

To compile the Java sources, “ant” is used. There are several ant targets to compile either the JNI or JCE (includes JNI) packages, in either debug or release mode. Running regular “ant” will give usage options:

```
$ ant
...
build:
[echo] wolfCrypt JNI and JCE
[echo] ----------------------------------------------------------------------------
[echo] USAGE:
[echo] Run one of the following targets with ant:
[echo] build-jni-debug | builds debug JAR with only wolfCrypt JNI classes
[echo] build-jni-release | builds release JAR with only wolfCrypt JNI classes
[echo] build-jce-debug | builds debug JAR with JNI and JCE classes
[echo] build-jce-release | builds release JAR with JNI and JCE classes
[echo] ----------------------------------------------------------------------------
```

Use the build target that matches your needs. For example, if you want to build the wolfJCE provider in release mode, run:

```
$ ant build-jce-release
```

To run the JUnit tests, run `ant test`. This will compile only the tests that match the build that was done (JNI vs. JCE) and run those tests.

```
$ ant test
```

To clean the both Java JAR and native library, run:

```
$ ant clean
$ make clean
```

## Compiling with Maven

wolfCrypt JNI/JCE also supports building with Maven. First, compile the native JNI shared library using `make` as described above.

The included Maven Wrapper, `./mvnw` (or `mvnw.cmd` on Windows), can be used
in place of `mvn` in the commands below. It downloads the Maven release pinned
in `.mvn/wrapper/maven-wrapper.properties`, verifies its SHA-256 checksum, and
runs Maven with `--strict-checksums` so that a dependency or plugin download
that fails its checksum stops the build.

Then compile the Java sources with Maven:

```
$ mvn compile
```

To compile and run JUnit tests:

```
$ mvn test
```

To package the JAR file:

```
$ mvn package
```

To install the JAR into the local Maven repository:

```
$ mvn install
```

After installation, the package can be included as a dependency in other Maven
projects, where the version number will change depending on the current release:

```
<dependency>
    <groupId>com.wolfssl</groupId>
    <artifactId>wolfcrypt-jni</artifactId>
    <version>1.12.0-SNAPSHOT</version>
</dependency>
```

## Java 9+ Module Support (JPMS)

wolfCrypt JNI/JCE supports the Java Platform Module System (JPMS) introduced
in Java 9. This enables use with `jlink` for creating custom, minimal Java
runtimes.

**Module Information:**

- Module name: `com.wolfssl.wolfcrypt`
- Exported packages: `com.wolfssl.wolfcrypt`, `com.wolfssl.provider.jce`
- Service provider: `java.security.Provider` (WolfCryptProvider)

The `module-info.java` (located under `src/java9`) is conditionally compiled
based on the JDK version used to build. When building with Java 9 or later,
a modular JAR is produced that includes `module-info.class`. When building
with Java 8, `module-info.java` is automatically excluded from compilation
and the resulting JAR works as a standard classpath JAR.

When built with Java 9+, the wolfCrypt JNI/JCE JAR can be used with `jlink`
to create a custom Java runtime that includes the wolfCrypt module:

```
$ jlink \
    --module-path lib/wolfcrypt-jni.jar:$JAVA_HOME/jmods \
    --add-modules com.wolfssl.wolfcrypt \
    --output custom-runtime \
    --no-header-files \
    --no-man-pages

$ ./custom-runtime/bin/java --list-modules
```

Note that the native wolfCrypt JNI shared library (`libwolfcryptjni.so/dylib`)
must still be available on the native library search path at runtime.

## JDK 15+ Multi-Release JAR (EdDSA)

When built with JDK 15 or later, `wolfcrypt-jni.jar` is a multi-release JAR
(`Multi-Release: true`). Classes under `src/java15` are compiled into the
`META-INF/versions/15` layer of the JAR, so that on JDK 15 and later wolfJCE
EdDSA keys also implement the JDK `java.security.interfaces.EdECPublicKey` and
`EdECPrivateKey` interfaces. This allows wolfJCE Ed25519 and Ed448 keys to be
passed directly to other providers such as SunEC. JDK 8 through 14 and Android
use the base classes. Both `ant` and Maven build this layer automatically when
the build JDK is 15 or later.

Multi-release class selection is done by the JAR loader, so the JDK 15 classes
are only used when wolfJCE is loaded from `wolfcrypt-jni.jar`. A class
directory such as Maven's `target/classes` (used by `mvn test`) uses the base
classes. Run `mvn clean` when switching between build JDKs below and above 15.

## API Javadocs

Running `ant` will generate a set of Javadocs under the `wolfcrypt-jni/docs/javadoc`
directory. To view the Javadoc index, open the following file in a web browser:

`wolfcrypt-jni/docs/javadoc/index.html`

When using Maven, Javadocs can be generated with:

```
$ mvn javadoc:javadoc
```

This will generate Javadoc HTML under the `./docs/apidocs` directory.

