#  Installation

There are two ways that wolfJSSE can be installed and used, either at runtime
or globally at the system level.

##  Installation at Runtime

To install and use wolfJSSE at runtime, first make sure that `libwolfssljni.so`
is on your system library search path. On Linux, you can modify this path with:

```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```

On OSX, use `DYLD_LIBRARY_PATH` instead of `LD_LIBRARY_PATH`.

Next, place the wolfSSL JNI / wolfJSSE JAR file(s) (wolfssl.jar,
wolfssl-jsse.jar) on your Java classpath. You can do this by adjusting your
system classpath settings, or at compile time and runtime of a specific
application like so:

```
$ javac -classpath <path/to/jar> ...
$ java -classpath <path/to/jar> ...
```

Finally, in your Java application, add the provider at runtime by importing the
provider class and calling `Security.addProvider()`:

```
import com.wolfssl.provider.jsse.WolfSSLProvider;

public class TestClass {
    public static void main(String args[]) {
        ...
        Security.addProvider(new WolfSSLProvider());
        ...
    }
}
```

To print a list of all installed Security Providers for verification:

```
Provider[] providers = Security.getProviders();
for (Provider prov:providers) {
    System.out.println(prov);
}
```

##  Installation at OS / System Level

###  Unix/Linux

To install the wolfJSSE provider at the system/OS level, copy the `wolfssl.jar`
and/or `wolfssl-jsse.jar` into the correct Java installation directory for your
OS and verify the `libwolfssljni.so` or `libwolfssljni.jnilib` shared library
is on your library search path.

Add the JAR files (`wolfssl.jar`, `wolfssl-jsse.jar`) and shared library
(`libwolfssljni.so`) to the following directory:

```
$JAVA_HOME/jre/lib/ext
```

On Ubuntu with OpenJDK this path may be similar to:

```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

Next, add an entry to the `java.security` file similar to the following:

```
security.provider.N=com.wolfssl.provider.jce.WolfSSLProvider
```

The java.security file will be located at:

```
$JAVA_HOME /jre/lib/security/java.security
```

Replacing “N” with the order of priority you would like wolfJSSE to have in
comparison to other providers in the file. To place the WolfSSLProvider as the
top priority provider, the following line would be added to the providers list
in the `java.security` file. You will also need to re-number the priority
numbers on the other providers listed in the java.security file. The highest
priority is `1`.

```
security.provider.1=com.wolfssl.provider.jce.WolfSSLProvider
```

###  Android OSP (AOSP)

For instructions on installing wolfJSSE as a system security provider in the
Android OSP (AOSP) source tree, please reference the separate document titled
“Installing a JSSE Provider in Android OSP”.

