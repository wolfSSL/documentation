# JSSE Provider Migration

This chapter covers the migration of TLS/SSL functionality from the Bouncy
Castle JSSE provider (bcjsse) to wolfJSSE.

## Prerequisites

Before starting the JSSE migration, ensure that:

1. The native wolfSSL library has been compiled and installed. See the
   [wolfSSL JNI/JSSE Manual - Compilation](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter03.html)
   chapter for instructions.
2. The wolfssl-jni JAR (which includes wolfJSSE) has been built and is
   available on your classpath.
3. The native wolfSSL shared library is accessible via `java.library.path`.

## Provider Installation

### Programmatic Registration

**Before (Bouncy Castle JSSE):**

```java
import org.bouncycastle.jsse.provider.BouncyCastleJsseProvider;
Security.addProvider(new BouncyCastleJsseProvider());
```

**After (wolfJSSE):**

```java
import com.wolfssl.provider.jsse.WolfSSLProvider;
Security.addProvider(new WolfSSLProvider());
```

Or, to register wolfJSSE as the highest priority provider:

```java
import com.wolfssl.provider.jsse.WolfSSLProvider;
Security.insertProviderAt(new WolfSSLProvider(), 1);
```

### java.security File Registration

**Before (Bouncy Castle JSSE):**

```
security.provider.N=org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
```

**After (wolfJSSE):**

```
security.provider.N=com.wolfssl.provider.jsse.WolfSSLProvider
```

## Standard JSSE API Migration

The standard JSSE APIs follow the same provider-based architecture as JCE. If
your code explicitly specifies `"BCJSSE"` as the provider, the migration is
simply changing the provider name to `"wolfJSSE"`. The API usage, method calls,
and parameters remain identical.

The following JSSE service classes are supported by wolfJSSE and can be migrated
by changing the provider name from `"BCJSSE"` to `"wolfJSSE"`:

**JSSE Service Classes**

- SSLContext
- SSLSocket / SSLServerSocket (obtained from SSLContext)
- SSLEngine (obtained from SSLContext)
- TrustManagerFactory
- KeyManagerFactory

All downstream objects created from these classes (SSLSocketFactory,
SSLServerSocketFactory, SSLEngine, X509TrustManager, X509KeyManager) are
automatically provided by wolfJSSE once the SSLContext or factory is obtained
with the `"wolfJSSE"` provider.

For the complete list of supported TLS protocol versions and cipher suites,
see the [wolfJSSE Supported Algorithms and Classes](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter06.html)
documentation.

### Provider Priority: Avoiding Explicit Provider Names

As with JCE (see Chapter 3), if your code does not explicitly name the
`"BCJSSE"` provider, you can register wolfJSSE at a higher priority and no
code changes are needed:

```java
Security.insertProviderAt(new WolfSSLProvider(), 1);
```

Or in the `java.security` file:

```
security.provider.1=com.wolfssl.provider.jsse.WolfSSLProvider
```

## Protocol and Cipher Suite Considerations

### TLS Protocol Versions

wolfJSSE supports TLS 1.0 through TLS 1.3, depending on how the native wolfSSL
library was compiled. Verify that the TLS protocol versions your application
requires are enabled in the native wolfSSL build.

wolfSSL does have "old" TLS protocol versions disabled by default, which are
versions less than TLS 1.2. If your application requires TLS 1.0 or TLS 1.1,
you will need to compile native wolfSSL with the `--enable-oldtls`
configure option.

### Cipher Suite Names

Cipher suite names may differ between Bouncy Castle and wolfJSSE. wolfJSSE
uses standard IANA cipher suite names. Consult the
[wolfJSSE Supported Algorithms and Classes](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter06.html)
chapter for the list of supported cipher suites.

If your application explicitly sets cipher suites, verify that the suite names
used are supported by wolfJSSE.

## System Properties

wolfJSSE supports several Java system properties for configuration, including
those for specifying KeyStore and TrustStore paths. See the
[wolfSSL JNI/JSSE Manual - Usage](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter07.html)
chapter for details on supported system properties.

