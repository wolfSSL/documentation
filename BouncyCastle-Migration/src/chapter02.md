# Overview of Differences

This chapter provides a high-level comparison between Bouncy Castle and the
wolfSSL Java providers (wolfJCE and wolfJSSE) to help frame the migration effort.

## Architecture Comparison

### Bouncy Castle

Bouncy Castle is a pure-Java cryptographic library that includes both a
lightweight crypto API and standard JCE/JSSE provider implementations. All
cryptographic operations are implemented in Java.

### wolfJCE / wolfJSSE

wolfJCE and wolfJSSE are JNI-based providers that wrap the native wolfCrypt and
wolfSSL C libraries, respectively. Cryptographic operations are performed in
native code, with Java providing the JCE/JSSE interface layer.

## Provider Registration

Both Bouncy Castle and wolfJCE/wolfJSSE follow the standard Java Security
architecture for provider registration. The primary difference is in the
provider class names and the requirement to load native libraries for wolfSSL
providers.

### Bouncy Castle Provider Registration

```java
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.jsse.provider.BouncyCastleJsseProvider;

Security.addProvider(new BouncyCastleProvider());
Security.addProvider(new BouncyCastleJsseProvider());
```

### wolfJCE / wolfJSSE Provider Registration

```java
import com.wolfssl.provider.jce.WolfCryptProvider;
import com.wolfssl.provider.jsse.WolfSSLProvider;

Security.addProvider(new WolfCryptProvider());
Security.addProvider(new WolfSSLProvider());
```

## Supported Algorithms

wolfJCE and wolfJSSE support a focused set of algorithms commonly required
for modern applications and FIPS 140-3 compliance. While Bouncy Castle supports
a very wide range of algorithms including many legacy and niche options,
wolfJCE/wolfJSSE focus on widely-used, standards-based algorithms.

Consult the following manuals for the current list of supported algorithms
and classes:

- [wolfJCE Supported Algorithms and Classes](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/chapter06.html)
- [wolfJSSE Supported Algorithms and Classes](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter06.html)

## KeyStore Comparison

For FIPS 140-3 deployments, WKS is the recommended KeyStore type since all
of its internal cryptographic operations use FIPS-approved algorithms from the
wolfCrypt FIPS module. See Chapter 3 for KeyStore migration details.

