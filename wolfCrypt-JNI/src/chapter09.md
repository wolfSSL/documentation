#  KeyStore Implementations

wolfJCE includes one Java KeyStore implementation, WolfSSLKeyStore (WKS). It
has been designed to be compatible with wolfCrypt FIPS 140-2 / 140-3 validated
modules, using cryptography algorithms and key sizes within the FIPS validated
boundary. The WKS KeyStore type can also be used with non-FIPS versions of
wolfSSL and wolfCrypt. WolfSSLKeyStore (WKS) KeyStores can be used along with
wolfSSL JNI/JSSE as well.

## JKS to WKS Migration Guide

Users of wolfJCE may wish to migrate from existing Java KeyStore files over to
WolfSSLKeyStore (WKS) format to ensure use of FIPS 140-2/3 validated algorithms
if using wolfCrypt FIPS. This migration guide will outline some of the steps
and considerations to take into account when migrating KeyStore formats.

### FIPS 140-2 / 140-3 Algorithm Requirement Considerations

FIPS 140-2 / 140-3 validation compliance from an application perspective
typically means that all cryptography being called or used should come from a
FIPS validated cryptographic module.  Oftentimes the strictness of what
cryptography needs to be FIPS validated is decided by the end consumer of the
application or product. In some cases, not 100% of the cryptography in a system
needs to be FIPS validated. For example an end consumer may only require
cryptography used to secure data in transit be FIPS validated, and other
cryptography (such as the algorithms used for key storage on the device) do not
have the same FIPS requirements.

There are some use cases where the Java KeyStore objects and files being used
are out of scope of the FIPS validation requirement. In those cases, it may be
simpler and require fewer changes to a system to use the existing KeyStore
files on a system. Typically these will be JKS or PKCS#12 format stores, as
those are typically generated and consumed by Java applications using Oracle’s
SunJSSE and SunJCE cryptographic provider implementations.

Other applications and use cases will require all cryptography on the system to
be FIPS validated. For these use cases, wolfSSL has created the WolfSSLKeyStore
(WKS) store type.  This migration guide will walk through some common areas and
considerations when switching from other KeyStore types (ex: JKS, PKCS#12) over
to the WKS type.

### WolfSSLKeyStore Format (WKS)

The WKS KeyStore format is unique and different than other Java KeyStore types.
It has been designed to use FIPS 140-2 / 140-3 validated algorithms from the
wolfCrypt FIPS module to maintain FIPS validation conformance.

The WKS implementation uses AES-CBC-256 along with HMAC-SHA512 in an
Encrypt-then-MAC format for encryption of PrivateKey and SecretKey objects. It
uses HMAC-SHA512 for KeyStore integrity. PKCS#5 PBKDF2-HMAC-SHA512 is used to
generate 96 bytes of key material which is split between a 32-byte AES-CBC-256
key and 64-byte HMAC-SHA512 key. The PBKDF2 salt is 16 bytes, randomly
generated for each key storage operation, and the AES-CBC IV is also randomly
generated for each key storage operation. The PBKDF2 iteration count defaults
to 210,000 (current OWASP recommendation), but is user overridable with the
`wolfjce.wks.iterationCount` Security property in the `java.security` file
(10,000 minimum). More details on the design of the WKS type can be found in
the WolfSSLKeyStore design document (`docs/design/WolfSSLKeyStore.md` in the
wolfcrypt-jni package).

WKS KeyStores support storage of PrivateKey, Certificate, and SecretKey objects.
PrivateKey storage includes RSA, RSASSA-PSS, ECC, ML-DSA (FIPS 204), and
SLH-DSA (FIPS 205) keys. ML-DSA and SLH-DSA key support requires native wolfSSL
to be built with the respective algorithm enabled
(see [Chapter 2](chapter02.md#native-feature-requirements-for-post-quantum-and-hash-based-algorithms)).

### WKS Security Properties

The behavior of the WKS KeyStore can be customized with the following Java
Security properties, set in the `java.security` file:

| Security Property | Default | Description |
| --- | --- | --- |
| wolfjce.wks.iterationCount | 210,000 | PBKDF2 iteration count (10,000 minimum) |
| wolfjce.wks.maxCertChainLength | 100 | Max cert chain length |
| wolfjce.wks.maxEntrySize | 10485760 | Max encoded entry size in bytes when loading WKS (10 MB default) |
| wolfjce.keystore.kekCacheEnabled | false | Enable KEK caching for performance |
| wolfjce.keystore.kekCacheTtlSec | 300 | KEK cache TTL in seconds (1 second minimum) |

### KEK Caching for Performance

The `wolfjce.keystore.kekCacheEnabled` Security property enables KEK (Key
Encryption Key) caching in the WKS KeyStore to improve performance when making
repeated `getKey()` calls. When disabled (default), each `getKey()` call
performs full PBKDF2 key derivation. When enabled, derived keys are cached in
memory with a configurable TTL (`wolfjce.keystore.kekCacheTtlSec`). The cache
is automatically cleared on entry deletion, overwrite, KeyStore reload, TTL
expiration, and garbage collection of the KeyStore object. Because
`KeyStore.getInstance()` returns the standard `java.security.KeyStore`
wrapper, the underlying WolfSSLKeyStore implementation object is not directly
accessible. To deterministically clear the cache, reload the KeyStore with
`load()` (any call to `load()` first clears the KEK cache, and loading `null`
resets the object to an empty KeyStore):

```
/* Enable KEK caching with 10 minute TTL */
Security.setProperty("wolfjce.keystore.kekCacheEnabled", "true");
Security.setProperty("wolfjce.keystore.kekCacheTtlSec", "600");

KeyStore store = KeyStore.getInstance("WKS", "wolfJCE");
store.load(new FileInputStream("keystore.wks"), password);
/* ... use KeyStore ... */

/* Explicitly clear cached keys when done (optional) */
store.load(null, null);
```

Security consideration: cached derived keys remain in memory for the TTL
duration. Only enable KEK caching in trusted environments where the performance
benefits outweigh the increased memory exposure.

### Converting Existing KeyStore Files to WKS

Existing JKS (.jks), PKCS#12 (.p12), and other Java KeyStore files will need to
be converted to WKS type. This can easily be done using the Java `keytool`
application.

For `keytool` to convert KeyStore files to WKS, it will need access to compiled
wolfCrypt JNI/JSSE library files (.so/.dylib and .jar). After compiling
wolfCrypt JNI/JCE, make sure the native JNI shared library is on the native
library search path. For Linux, add the location of `libwolfcryptjni.so` to
`LD_LIBRARY_PATH`, for example:

```
$ export LD_LIBRARY_PATH=/path/to/wolfcryptjni/lib:$LD_LIBRARY_PATH
```

If on macOS, add the location of `libwolfcryptjni.dylib` to `DYLD_LIBRARY_PATH`,
for example:

```
$ export DYLD_LIBRARY_PATH=/path/to/wolfcryptjni/lib:$DYLD_LIBRARY_PATH
```

`keytool` can then be used to convert between KeyStore types. Usage will be
similar to:

```
$ keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.wks -srcstoretype JKS -deststoretype WKS -srcstorepass "password" -deststorepass "password" -provider com.wolfssl.provider.jce.WolfCryptProvider --providerpath /path/to/wolfcryptjni/lib/wolfcrypt-jni.jar
```

The `keytool` options that need to be used are:

| keytool option | Description |
| --- | --- |
| -importkeystore | Import from source keystore to destination |
| -srckeystore | Source keystore to be read from |
| -destkeystore | Destination keystore to write to |
| -srcstoretype | Type of source keystore (ex: JKS) |
| -deststoretype | Type of destination keystore (WKS) |
| -srcstorepass | Password of source keystore |
| -deststorepass | Password for destination keystore |
| -provider | Full class name of KeyStore provider to use for conversion |
| --providerpath | Full path to JCE provider JAR file which contains provider |

After converting KeyStore files, you should have new equivalent KeyStore files but in the .wks (WolfSSLKeyStore) format.

### Converting KeyStore Files Programmatically

In addition to `keytool`, wolfJCE provides a utility method
`WolfCryptUtil.convertKeyStoreToWKS()` that can be used programmatically to
convert KeyStore formats. This method supports converting from JKS, PKCS12, and
WKS formats to WKS format, automatically detecting the input KeyStore format.
All certificates and keys from the source KeyStore are transferred to a newly
created WKS KeyStore, including both key entries (with certificate chains) and
certificate-only entries. This also applies when the input is already in WKS
format. The input stream is read to the end but not closed, and the returned
stream is always a new InputStream.

Example usage:

```
import com.wolfssl.provider.jce.WolfCryptUtil;
import java.io.InputStream;
import java.security.KeyStore;

/* Load your source KeyStore (JKS, PKCS12, or WKS) */
InputStream sourceStream = ...;
char[] oldPassword = "your_password".toCharArray();
char[] newPassword = "your_new_password".toCharArray();

/* Convert to WKS format, fail on insert errors */
InputStream wksStream = WolfCryptUtil.convertKeyStoreToWKS(sourceStream,
    oldPassword, newPassword, true);

/* Load the converted WKS KeyStore */
KeyStore wksStore = KeyStore.getInstance("WKS", "wolfJCE");
wksStore.load(wksStream, newPassword);
```

**FIPS NOTE:** This utility method will call Sun provider code for JKS and
PKCS12 parsing. This means that if using wolfCrypt FIPS, these calls will make
calls into non-FIPS compliant cryptography for the conversion. Please take this
into consideration when being used in a FIPS compliant environment. When used
with wolfCrypt FIPS, the new password must also meet FIPS minimum HMAC key
size requirements and be at least 14 characters.

### Mapping JKS and PKCS12 KeyStore Types to WKS

For applications that request `KeyStore.getInstance("JKS")` or
`KeyStore.getInstance("PKCS12")` and cannot easily be changed, wolfJCE supports
two Java Security properties, `wolfjce.mapJKStoWKS` and
`wolfjce.mapPKCS12toWKS`. When set to `true` in the `java.security` file,
wolfJCE will register a "JKS" and/or "PKCS12" KeyStore type which is actually a
WolfSSLKeyStore (WKS) implementation internally.

These properties should be used with caution - loading actual JKS or PKCS12
files through these mapped KeyStore types will fail. They are helpful when FIPS
compliance is required but existing application code gets a JKS or PKCS12
KeyStore instance, and assumes the caller has the flexibility to load a real
WKS KeyStore file into that KeyStore object. If one of these properties is set
at runtime programmatically, the wolfJCE provider services will need to be
refreshed / reloaded:

```
WolfCryptProvider prov = (WolfCryptProvider)Security.getProvider("wolfJCE");
prov.refreshServices();
```

### Viewing Contents of WolfSSLKeyStore (WKS) File

The Java `keytool` command can be used to view the contents of a WKS KeyStore
file. Usage will be similar to:

```
keytool -list -provider com.wolfssl.provider.jce.WolfCryptProvider --providerpath /path/to/wolfcryptjni/lib/wolfcrypt-jni.jar -storetype WKS -storepass "password" -keystore keystore.wks
```

### Changing Application Usage of KeyStore Type

Java application code typically either creates new KeyStore objects to store
keys and certificates into, or opens existing KeyStore files for use.

#### Creating New KeyStore Objects

Java application code will typically create new KeyStore objects with code
similar to the following, explicitly getting a KeyStore instance of type
“JKS”, or other KeyStore type:

```
import java.security.KeyStore;
...
String storePass = "mypassword";
KeyStore store = KeyStore.getInstance("JKS");
store.load(null, storePass.toCharArray());
```

To convert this code to creating a KeyStore of type “WKS”, only the type passed
to `getInstance()` will need to be updated:

```
KeyStore store = KeyStore.getInstance("WKS");
```

All application code that uses the KeyStore object should work as-is since the
WolfSSLKeyStore implementation extends `KeyStoreSpi` and implements the methods
in that abstract class.

#### Opening Existing KeyStore Files for Use

Java application code that opens existing KeyStore files for use will typically
do so with similar code to below:

```
import java.security.KeyStore;
...
String storePass = "mypassword";
KeyStore store = KeyStore.getInstance("JKS");
store.load(new FileInputStream(keystoreFilePath),
    storePass.toCharArray());
```

To convert this code to use `WKS` type, change the call to `getInstance()` to
request a KeyStore instance of `WKS`:

```
KeyStore store = KeyStore.getInstance("WKS");
```

Then, the actual KeyStore file on disk being read will need to already be in
WolfSSLKeyStore (WKS) format. See the section above about converting KeyStore
files to WKS type for instructions on how to do this.

### Converting System CA Certificate KeyStore Files

Java JDK implementations commonly ship with their own KeyStore containing known
trusted CA certificates. This will typically be either in a file called
`cacerts` or `jssecacerts`. The location of this file will vary depending on
Java version, but can typically be found at the following locations.

**cacerts:**

```
$JAVA_HOME/lib/security/cacerts         (JDK 9+)
$JAVA_HOME/jre/lib/security/cacerts     (JDK <= 8)
```

**jssecacerts:**

```
$JAVA_HOME/lib/security/jssecacerts     (JDK 9+)
$JAVA_HOME/jre/lib/security/jssecacerts (JDK <= 8)
```

The default `cacerts.jks` password is "**changeit**".  If using wolfCrypt FIPS
140-2 / 140-3 the minimum HMAC key size is 14 bytes. Since HMAC is used for the
KeyStore integrity checks and MAC on PrivateKey/SecretKey objects, KeyStore
passwords must be at least 14 characters.  Because of this restriction, when
converting system CA KeyStore files to WKS type, the password should be updated,
to something like "**changeitchangeit**" for example.

wolfCrypt JNI/JCE includes a helper bash script which has been set up to try
and detect system CA KeyStore files and convert them to WKS type. This script
is located at:

```
wolfcryptjni/examples/certs/systemcerts/system-cacerts-to-wks.sh
```

This script should be run from the directory where it resides. Successful
execution will result in local copies of the `cacerts` and/or `jssecacerts`
KeyStore files created and placed in the same directory as the script, but in
WKS format.

```
./system-cacerts-to-wks.sh
-----------------------------------------------------------------------
System CA KeyStore to WKS Conversion Script
-----------------------------------------------------------------------
JAVA_HOME already set = /path/to/java/installation
Detected Darwin/OSX host OS
Java Home = /path/to/java/installation

System cacerts found, converting from JKS to WKS:
    FROM: /path/to/java/installation/jre/lib/security/cacerts
    TO:   /path/to/wolfcryptjni/examples/certs/systemcerts/cacerts.wks
    IN PASS (default): changeit
    OUT PASS: changeitchangeit

Successfully converted JKS to WKS
```

You can then copy this `cacerts.wks` file over to your system JDK location if
desired.

### WKS KeyStore Use with wolfJSSE

wolfSSL JNI/JSSE, as of
[PR 178](https://github.com/wolfSSL/wolfssljni/pull/178) has been modified to
give preference to loading and using WolfSSLKeyStore (WKS) KeyStore types.

When auto-loading the system CA/root certificates (ex: jssecacerts, cacerts),
wolfJSSE first tries to find and load a WKS equivalent file at the same
location (ex: jssecacerts.wks, cacerts.wks).

Support for a new Java Security property has been added
(`wolfjsse.keystore.type.required`) which can be used to restrict use of
KeyStore type to the one set in this property. This can be used for example to
help conform to wolfCrypt FIPS 140-2/3 crypto usage by setting to "**WKS**"
when wolfJCE is also used and installed on the system.

The wolfJSSE provider example `ClientJSSE.java` and `ServerJSSE.java` have been
updated with a new option to specify the KeyStore type (``-ksformat`).

### Support

For support or assistance in converting JKS or other KeyStore file types over
to WolfSSLKeyStore (WKS) types, please email support@wolfssl.com.

