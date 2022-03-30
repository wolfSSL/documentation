#  JAR Code Signing

The Oracle JDK/JVM require that JCE providers be signed by a code signing certificate that has been issued by Oracle. The wolfcrypt-jni package’s ant build script supports code signing the generated “wolfcrypt-jni.jar” file by placing a custom properties file in the root of the package directory before compilation.

To enable automatic code signing, create a file called “codeSigning.properties” and place it in the root of the “wolfcrypt-jni” package. This is a properties file which should include the following:
```
sign.alias=<signing alias in keystore>
sign.keystore=<path to signing keystore>
sign.storepass=<keystore password>
sign.tsaurl=<timestamp server url>
```

When this file is present when “ant” or “ant test” is run, it will sign “wolfcrypt-jni.jar” using the keystore and alias provided.

## Using a Pre-Signed JAR File

wolfSSL (company) has it’s own set of code signing certificates from Oracle that allow wolfJCE to be authenticated in the Oracle JDK.  With each release of wolfJCE, wolfSSL ships a couple pre-signed versions of the ‘wolfcrypt-jni.jar”, located at:

wolfcrypt-jni-X.X.X/lib/signed/debug/wolfcrypt-jni.jar
wolfcrypt-jni-X.X.X/lib/signed/release/wolfcrypt-jni.jar

This pre-signed JAR can be used with the JUnit tests, without having to re-compile the Java source files.  To run the JUnit tests against this JAR file:

$ cd wolfcrypt-jni-X.X.X
$ cp ./lib/signed/release/wolfcrypt-jni.jar ./lib
$ ant test
