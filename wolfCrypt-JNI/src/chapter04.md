#  Installation

There are two ways that wolfJCE can be installed and used:


##  Installation at Runtime

To install and use wolfJCE at runtime, first make sure that “**libwolfcryptjni.so**” is on your system’s library search path. On Linux, you can modify this path with:
```
    $ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/add
```
    
Next, place the wolfCrypt JNI / wolfJCE JAR file (**wolfcrypt-jni.jar**) on your Java classpath. You can do this by adjusting your system classpath settings, or at compile time and runtime like so:
```
    $ javac -classpath <path/to/jar> ...
    $ java -classpath <path/to/jar> ...
```

Finally, in your Java application, add the provider at runtime by importing the provider class and calling Security.addProvider():
```
    import com.wolfssl.provider.jce.WolfCryptProvider;
    public class TestClass {
       public static void main(String args[]) {
          ...
          Security. **addProvider** (new **WolfCryptProvider**());
          ...
       }
    }
```

To print a list of all installed providers for verification, you can do:
```
    Provider[] providers = Security. **getProviders** ()
    for (Provider prov:providers) {
       System.out.println(prov);
    }
```

##  Installation at OS / System Level

To install the wolfJCE provider at the system level, copy the JAR into the correct Java installation directory for your OS and verify the shared library is on your library search path.
    
Add the wolfJCE JAR file (**wolfcrypt-jni.jar**) and shared library (**libwolfcryptjni.so**) to the following directory:
```
       $JAVA_HOME/jre/lib/ext directory
```


For example, on Ubuntu with OpenJDK this may be similar to:
```
/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
```

Next, add an entry to the java.security file that looks similar to the following:
```
security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider
```

The java.security file will be located at:
```
$JAVA_HOME/jre/lib/security/java.security
```

Replacing “N” with the order of precedence you would like the WolfCryptProvider to have in comparison to other providers in the file.
