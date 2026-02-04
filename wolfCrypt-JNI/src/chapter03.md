#  Compilation

Before following steps in this section, please ensure that the dependencies in [Chapter 2](chapter02.md#requirements) above are installed.

Before running `make`, copy the correct “makefile” for your system, depending if you are on Linux/Unix or MacOS. For example, if you were on Linux:

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

After installation, the package can be included as a dependency in other Maven projects:

```
<dependency>
    <groupId>com.wolfssl</groupId>
    <artifactId>wolfcrypt-jni</artifactId>
    <version>1.9.0-SNAPSHOT</version>
</dependency>
```

## API Javadocs

Running `ant` will generate a set of Javadocs under the `wolfcrypt-jni/docs/javadoc`
directory. To view the Javadoc index, open the following file in a web browser:

`wolfcrypt-jni/docs/javadoc/index.html`

When using Maven, Javadocs can be generated with:

```
$ mvn javadoc:javadoc
```

This will generate Javadoc HTML under the `./docs/apidocs` directory.

