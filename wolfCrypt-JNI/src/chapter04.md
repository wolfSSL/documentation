#  Installation

There are two ways that wolfJCE can be installed and used - either at runtime
inside a single Java application, or at the system level for all Java
applications to use.

##  Installation at Runtime

To install and use wolfJCE at runtime inside a single application, first make
sure that "**libwolfcryptjni.so**" (or "**libwolfcryptjni.dylib**" if on macOS)
is on your system library search path.

On Linux, you can modify this path with:

```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```

On macOS, you can use `DYLD_LIBRARY_PATH` instead:

```
$ export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/path/to/add
```

Next, place the wolfCrypt JNI/JCE JAR file (**wolfcrypt-jni.jar**) on your
Java classpath. You can do this by adjusting your system classpath settings
or at compile time and runtime like so:

```
$ javac -classpath <path/to/jar> ...
$ java -classpath <path/to/jar> ...
```

Finally, in your Java application, add the provider at runtime by importing
the provider class and calling `Security.insertProviderAt()` to insert the
wolfCryptProvider in the Java Provider list as the top most priority provider.
Note that provider location 1 is the highest priority location.

```
import com.wolfssl.provider.jce.WolfCryptProvider;

public class TestClass {
   public static void main(String args[]) {
      ...
      Security.insertProviderAt(new WolfCryptProvider(), 1);
      ...
   }
}
```

To print a list of all installed providers from a Java application for
verification, you can do:

```
Provider[] providers = Security.getProviders();
for (Provider prov:providers) {
   System.out.println(prov);
}
```

wolfJCE also registers itself as a `java.security.Provider` service
(`META-INF/services/java.security.Provider`), which allows the provider to be
discovered through the Java `ServiceLoader` mechanism and used with the Java
Platform Module System (JPMS). See
[Chapter 3](chapter03.md#java-9-module-support-jpms) for more details on module
support.

##  Installation at OS / System Level (Java <= 8)

wolfJCE can be installed at the system level so that any Java application
consuming Java Security APIs for cryptography can leverage wolfJCE.

To install the wolfJCE provider at the system level, copy the JAR into the
correct Java installation directory for your OS and JDK and verify the shared
library is on your library search path.

Add the wolfCrypt JNI/JCE JAR file (**wolfcrypt-jni.jar**) and shared library
(**libwolfcryptjni.so** or **libwolfcryptjni.dylib**) to the following
directory:

```
$JAVA_HOME/jre/lib/ext
```

For example, on Ubuntu with OpenJDK this may be similar to:

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

Next add an entry to the `java.security` file that looks similar to the
following, adding a provider entry for WolfCryptProvider:

```
security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider
```

The java.security file will be located at:

```
$JAVA_HOME/jre/lib/security/java.security
```

Replacing “N” with the order of precedence you would like the WolfCryptProvider
to have in comparison to other providers in the file.

##  Installation at OS / System Level (Java > 8)

Note that the `$JAVA_HOME/jre/lib/ext` extension mechanism was removed in
Java 9. On Java 9 and later, place `wolfcrypt-jni.jar` on the application
classpath (or module path) instead, and add the
`security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider` entry to the
`java.security` file located at `$JAVA_HOME/conf/security/java.security`.

## Custom Native Library Loading

By default, wolfCrypt JNI/JCE loads the native `wolfcryptjni` library using
`System.loadLibrary()`. This requires the native library to be located on
the system library search path.

For applications that need custom library loading behavior, such as bundling
native libraries inside a JAR file and extracting them at runtime, wolfCrypt
JNI/JCE supports skipping the automatic library loading via the
`wolfssl.skipLibraryLoad` System property. When set to `true`, wolfCrypt
JNI/JCE will skip calling `System.loadLibrary()` for the native libraries,
and the application is then responsible for loading the native libraries
before any wolfCrypt classes are accessed.

This property must be set before any wolfCrypt JNI/JCE classes are loaded by
the JVM, as the native library loading occurs in static initializer blocks:

```
/* Option 1: Set via command line */
/* java -Dwolfssl.skipLibraryLoad=true -jar myapp.jar */

/* Option 2: Load libraries manually with absolute paths, then set property.
 * This must happen at application startup, BEFORE any wolfCrypt classes
 * are accessed or loaded by the JVM. */
System.load("/path/to/libwolfssl.so");
System.load("/path/to/libwolfcryptjni.so");
System.setProperty("wolfssl.skipLibraryLoad", "true");

/* Now wolfCrypt classes can be used normally */
```

Applications can check if library loading was skipped using the
`WolfObject.isLibraryLoadSkipped()` method:

```
import com.wolfssl.wolfcrypt.WolfObject;

if (WolfObject.isLibraryLoadSkipped()) {
    System.out.println("Native library loading was skipped");
}
```

