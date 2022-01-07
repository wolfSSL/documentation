#  Compilation

Before following steps in this section, please ensure that the dependencies in [Chapter 2](chapter02.md#requirements) above are installed.


First, copy the correct “makefile” for your system, depending if you are on Linux or OS X. For example, if you were on Linux:
```
$ cd wolfcrypt-jni
$ cp makefile.linux makefile
If you are instead on Mac OSX:
$ cd wolfcrypt-jni
$ cp makefile.macosx makefile
```

Then proceed to compile the native (C source) code with “make”:
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

Use the build target that matches your need. For example, if you want to build the wolfJCE provider in release mode, run:
```
$ ant build-jce-release
```

And, to run the JUnit tests, run the following command. This will compile only the tests that match the build that was done (JNI vs. JCE) and run those tests as well.
```
$ ant test
```

To clean the both Java JAR and native library:

```
$ ant clean
$ make clean
```

## API Javadocs

Running `ant` will generate a set of Javadocs under the `wolfcrypt-jni/docs`
directory.  To view the root document, open the following file in a web browser:

`wolfcrypt-jni/docs/index.html`
