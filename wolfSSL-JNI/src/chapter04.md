#  Installation

There are two ways that wolfJSSE can be installed and used, either at runtime or globally at the system level.

##  Installation at Runtime

To install and use wolfJSSE at runtime, first make sure that “ libwolfssljni.so ” is on your system’s library search path. On Linux, you can modify this path with:

```
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```
Next, place the wolfSSL JNI / wolfJSSE JAR file(s) ( wolfssl.jar , wolfssl-jsse.jar ) on your Java classpath. You can do this by adjusting your system classpath settings, or at compile time and runtime like so:
```
$ javac -classpath <path/to/jar> ...
$ java -classpath <path/to/jar> ...
```
Finally, in your Java application, add the provider at runtime by importing the provider class and calling Security.addPro wolfssljni/IDE/Androidvider():
```
import com.wolfssl.provider.jsse.WolfSSLProvider;

public class TestClass {
           public static void main(String args[]) {
                      …
                      Security.addProvider(new WolfSSLProvider());
                       …
           }
}
```

To print a list of all installed providers for verification, you can do:
```
Provider[] providers = Security.getProviders()
for (Provider prov:providers) {
          System.out.println(prov);
}
```
##  Installation at OS / System Level

###  Unix/Linux

To install the wolfJSSE provider at the system level, copy the wolfssl.jar and/or wolfssl-jsse.jar files into the correct Java installationdirectory for your OS and
verify the libwolfssljni.so or libwolfssljni.dylib shared library is on your library search path.

Add the JAR files ( wolfssl.jar , wolfssl-jsse.jar )and shared library ( libwolfssljni.so ) to the following directory:
```
$JAVA_HOME /jre/lib/ext
```

For example, on Ubuntu with OpenJDK this may be similar to:
```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```
Next, add an entry to the java.security file thatlooks similar to the following:
```
security.provider.N=com.wolfssl.provider.jce.WolfSSLProvider
```
The java.security file will be located at:
```
$JAVA_HOME /jre/lib/security/java.security
```
Replacing “N” with the order of precedence you would like the WolfSSLProvider to have in comparison to other providers in the file. For example, to place the WolfSSLProvider as the top priority provider, the following line would be added to the providers list in the java.security file. Youwill also need to re-number the priority numbers on the other providers listed in the java.security file.
```
security.provider.1=com.wolfssl.provider.jce.WolfSSLProvider
```
###  Android OSP (AOSP)

For instructions on installing wolfJSSE as a system security provider in the Android OSP (AOSP) source tree, please reference the separate document titled
“ Installing a JSSE Provider in Android OSP ”.
