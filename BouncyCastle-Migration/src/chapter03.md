# JCE Provider Migration

This chapter covers the migration of cryptographic operations from the Bouncy
Castle JCE provider to wolfJCE.

## Prerequisites

Before starting the JCE migration, ensure that:

1. The native wolfSSL library has been compiled and installed. See the
   [wolfCrypt JNI/JCE Manual - Compilation](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/chapter03.html)
   chapter for instructions.
2. The wolfcrypt-jni JAR has been built and is available on your classpath.
3. The native wolfSSL shared library is accessible via `java.library.path`.

## Provider Installation

### Programmatic Registration

Replace the Bouncy Castle provider registration with wolfJCE:

**Before (Bouncy Castle):**

```java
import org.bouncycastle.jce.provider.BouncyCastleProvider;
Security.addProvider(new BouncyCastleProvider());
```

**After (wolfJCE):**

```java
import com.wolfssl.provider.jce.WolfCryptProvider;
Security.addProvider(new WolfCryptProvider());
```

Or, to register wolfJCE as the highest priority provider:

```java
import com.wolfssl.provider.jce.WolfCryptProvider;
Security.insertProviderAt(new WolfCryptProvider(), 1);
```

### java.security File Registration

Alternatively, wolfJCE can be registered in the `java.security` file:

**Before (Bouncy Castle):**

```
security.provider.N=org.bouncycastle.jce.provider.BouncyCastleProvider
```

**After (wolfJCE):**

```
security.provider.N=com.wolfssl.provider.jce.WolfCryptProvider
```

Where `N` is the desired provider preference order position.

## Standard JCE API Migration

The standard JCE APIs use a provider-based architecture. If your code
explicitly specifies `"BC"` as the provider in `getInstance()` calls, simply
change the provider name to `"wolfJCE"`. The API usage, method calls, and
parameters remain identical.

The following JCE service classes are supported by wolfJCE and can be migrated
by changing the provider name from `"BC"` to `"wolfJCE"`:

**JCE Service Classes**

- Cipher
- Signature
- MessageDigest
- Mac
- KeyPairGenerator
- KeyAgreement
- KeyFactory
- SecureRandom
- KeyStore(WKS)

For the complete list of supported algorithms under each service class, see
the [wolfJCE Supported Algorithms and Classes](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/chapter06.html)
documentation.

### Provider Priority: Avoiding Explicit Provider Names

If your code does not specify a provider name and instead relies on provider
priority (e.g., `Cipher.getInstance("AES/CBC/PKCS5Padding")` without a second
argument), you can configure wolfJCE as a higher-priority provider than Bouncy
Castle. The JCE framework will automatically select wolfJCE for any algorithm
it supports.

**Programmatic approach — insert wolfJCE at position 1:**

```java
Security.insertProviderAt(new WolfCryptProvider(), 1);
```

**java.security file approach — assign a lower number (higher priority):**

```
security.provider.1=com.wolfssl.provider.jce.WolfCryptProvider
```

With wolfJCE registered at a higher priority, no code changes are needed for
standard JCE API calls that do not explicitly name the `"BC"` provider.

## KeyStore Migration

wolfJCE provides a custom KeyStore type called **WolfSSLKeyStore (WKS)** that
has been designed for compatibility with wolfCrypt FIPS 140-2 and 140-3. All
cryptographic operations used internally by WKS (key protection, integrity
verification) use FIPS-approved algorithms, making it the recommended KeyStore
type for FIPS-compliant deployments.

Applications using Bouncy Castle's BKS (BouncyCastle KeyStore) format will need
to convert their KeyStores to WKS format.

### WKS Security Design

WKS protects stored keys using:

- **Encryption**: AES-CBC-256 with HMAC-SHA512 (Encrypt-then-MAC)
- **Key Derivation**: PBKDF2-HMAC-SHA512 with 128-bit random salt
  (default 210,000 iterations)
- **Integrity**: HMAC computed across all stored data, verified on load

WKS supports storing PrivateKey, SecretKey, and Certificate objects.

### Loading a WKS KeyStore

**Before (Bouncy Castle BKS):**

```java
KeyStore ks = KeyStore.getInstance("BKS", "BC");
ks.load(new FileInputStream("keystore.bks"), password);
```

**After (wolfJCE WKS):**

```java
KeyStore ks = KeyStore.getInstance("WKS", "wolfJCE");
ks.load(new FileInputStream("keystore.wks"), password);
```

### Converting Existing KeyStores to WKS

wolfJCE's `keytool` integration supports importing from JKS, PKCS12, and BKS
source keystores into WKS format.

**Converting JKS to WKS:**

```
keytool -importkeystore -srckeystore keystore.jks -srcstoretype JKS \
    -destkeystore keystore.wks -deststoretype WKS \
    -deststorepass "password" \
    -provider com.wolfssl.provider.jce.WolfCryptProvider \
    --providerpath /path/to/wolfcrypt-jni.jar
```

**Converting PKCS12 to WKS:**

```
keytool -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 \
    -destkeystore keystore.wks -deststoretype WKS \
    -deststorepass "password" \
    -provider com.wolfssl.provider.jce.WolfCryptProvider \
    --providerpath /path/to/wolfcrypt-jni.jar
```

**Converting BKS to WKS:**

BKS keystores require a two-step process since the BKS format requires the
Bouncy Castle provider to read. First convert BKS to PKCS12, then convert
PKCS12 to WKS:

```
/* Step 1: Convert BKS to PKCS12 (using Bouncy Castle) */
keytool -importkeystore -srckeystore keystore.bks -srcstoretype BKS \
    -srcproviderpath bcprov.jar \
    -destkeystore keystore.p12 -deststoretype PKCS12

/* Step 2: Convert PKCS12 to WKS (using wolfJCE) */
keytool -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 \
    -destkeystore keystore.wks -deststoretype WKS \
    -deststorepass "password" \
    -provider com.wolfssl.provider.jce.WolfCryptProvider \
    --providerpath /path/to/wolfcrypt-jni.jar
```

### Programmatic Conversion

wolfJCE also provides a utility method for programmatic conversion from JKS
or PKCS12 to WKS:

```java
import com.wolfssl.provider.jce.WolfCryptUtil;

WolfCryptUtil.convertKeyStoreToWKS(inputPath, outputPath,
    inputFormat, inputPassword, outputPassword);
```

The `inputFormat` parameter accepts "JKS", "PKCS12", or "WKS" and supports
automatic format detection.

**FIPS Note:** `WolfCryptUtil.convertKeyStoreToWKS()` internally loads and
reads the source KeyStore using the Sun/default JCE provider (for JKS and
PKCS12 formats), which is **not** FIPS validated cryptography. This conversion
should be performed as a separate offline step outside of your FIPS-compliant
code flow — for example, as a build-time or deployment-time task. Once the WKS
KeyStore has been generated, it can be loaded and used within FIPS-compliant
application code using the wolfJCE provider.

### Converting System CA Certificates

For applications that need to use the JVM's default CA certificates in WKS
format, wolfJCE includes a helper script that autodetects the Java installation
and converts the system `cacerts` file:

```
./examples/certs/systemcerts/system-cacerts-to-wks.sh
```

### WKS Configuration Properties

WKS behavior can be tuned via `java.security` properties or system properties:

| Property | Default | Description |
|---|---|---|
| `wolfjce.wks.iterationCount` | 210,000 | PBKDF2 iteration count (minimum 10,000) |
| `wolfjce.wks.maxCertChainLength` | 100 | Maximum certificate chain length |
| `wolfjce.keystore.kekCacheEnabled` | false | Enable derived key caching for performance |
| `wolfjce.keystore.kekCacheTtlSec` | 300 | Cache time-to-live in seconds |

For high-throughput applications where KeyStore operations are frequent, enabling
KEK caching can improve performance by avoiding repeated PBKDF2 key derivation.

For further details on the WKS KeyStore implementation, refer to the
[wolfCrypt JNI/JCE Manual - KeyStore Implementations](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/chapter09.html)
chapter.

