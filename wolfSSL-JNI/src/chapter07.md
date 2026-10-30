#  Usage

For usage, please follow the Oracle/OpenJDK Javadocs for the classes specified
in the previous chapter. Note that you will need to explicitly request the
"wolfJSSE" provider if it has been set lower in precedence than other providers
that offer the same algorithm in the `java.security` file.

For example, to use the wolfJSSE provider with the SSLContext class for TLS 1.2
an application would create a SSLContext object like so:

```
SSLContext ctx = SSLContext.getInstance("TLSv1.2", "wolfJSSE");
```

## Security Properties

wolfJSSE supports configuration through the `java.security` file using both
standard Java Security properties and wolfJSSE-specific properties.

### Standard Java Security Properties

The following standard Java Security properties are supported by wolfJSSE:

| Property | Default | Description |
| --- | --- | --- |
| `keystore.type` | JKS | Default KeyStore type |
| `jdk.tls.disabledAlgorithms` | | Disable algorithms, protocols, key lengths (partial support) |

wolfJSSE supports the following entries in `jdk.tls.disabledAlgorithms`:
SSL/TLS protocol versions (ex: `TLSv1.1`) and minimum RSA, EC, and DH key
sizes (ex: `RSA keySize < 2048`). The DH minimum is enforced against the
Diffie-Hellman group negotiated during the handshake. Example usage:

```
jdk.tls.disabledAlgorithms=SSLv3, TLSv1.1, DH keySize < 1024, EC keySize < 224, RSA keySize < 1024
```

### wolfJSSE-Specific Security Properties

The following Security properties are specific to wolfJSSE:

| Property | Default | Description |
| ------------------------------------------------------------ | ---------- | ------------------------------ |
| `wolfjsse.enabledCipherSuites` | | Restrict enabled cipher suites |
| `wolfjsse.enabledSupportedCurves` | | Restrict enabled named groups (ECC curves and PQC/hybrid groups) |
| `wolfjsse.enabledSignatureAlgorithms` | | Restrict enabled signature algorithms |
| `wolfjsse.keystore.type.required` | | Require specific KeyStore type |
| `wolfjsse.clientSessionCache.disabled` | "false" | Disable client session cache |
| `wolfjsse.X509KeyManager.disableCache` | "false" | Disable X509KeyManager caching |
| `wolfjsse.skipFIPSCAST` | "false" | Skip FIPS CASTs during wolfJSSE init |
| `wolfssl.readWriteByteBufferPool.disabled` | "false" | Disable direct ByteBuffer pool for read/write |
| `wolfssl.readWriteByteBufferPool.size` | 16 | Set max number of ByteBuffers in per-thread pool |
| `wolfssl.readWriteByteBufferPool.bufferSize` | 17408 | Set size of individual ByteBuffers in pool |

Example cipher suite restriction:

```
wolfjsse.enabledCipherSuites=TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

Example named group restriction, using ECC curves or post-quantum and hybrid
groups. Group names are matched case insensitively. Unknown groups and groups
not supported by the native wolfSSL build are ignored. If no usable groups
remain, connection establishment fails with an `SSLException`. See
"Named Groups" below for precedence with other named group settings.

```
wolfjsse.enabledSupportedCurves=secp256r1, secp521r1
```

Or, to restrict to post-quantum and hybrid groups:

```
wolfjsse.enabledSupportedCurves=X25519MLKEM768, SecP256r1MLKEM768, ML-KEM-768
```

Example signature algorithm restriction. Standalone scheme names such as
`ED25519`, `ED448`, and `ML-DSA-44`/`ML-DSA-65`/`ML-DSA-87` are also accepted.
Entries not supported by the native wolfSSL build are ignored. If no entry is
supported, connection establishment fails with an `SSLException`.

```
wolfjsse.enabledSignatureAlgorithms=RSA+SHA256:ECDSA+SHA256
```

When `wolfjsse.keystore.type.required` is set, wolfJSSE will not allow use of
KeyStore instances of any other type. For example, this can be set to the
wolfJCE "WKS" KeyStore type when using wolfCrypt FIPS 140-2/3, to help ensure
only FIPS validated cryptography is used to load keys and certificates.

## System Properties

wolfJSSE supports both standard Java System properties and wolfJSSE-specific
System properties. Since these are **System** properties and not **Security**
properties, they will not be read from the `java.security` file.

### Standard Java System Properties

The following standard Java System properties are supported by wolfJSSE:

| Property | Description |
| ------------------------------------------------------------ | ---------------------------------------- |
| `javax.net.ssl.keyStore` | KeyStore file for KeyManager |
| `javax.net.ssl.keyStoreType` | KeyStore type for KeyManager |
| `javax.net.ssl.keyStorePassword` | KeyStore password for KeyManager |
| `javax.net.ssl.trustStore` | KeyStore file for TrustManager |
| `javax.net.ssl.trustStoreType` | KeyStore type for TrustManager |
| `javax.net.ssl.trustStorePassword` | KeyStore password for TrustManager |
| `jdk.tls.client.enableSessionTicketExtension` | Enable client session tickets (Java 13+) |
| `jdk.tls.client.SignatureSchemes` | Client signature algorithms (partial support) |
| `jdk.tls.server.SignatureSchemes` | Server signature algorithms (partial support) |
| `jdk.tls.namedGroups` | Restrict enabled TLS named groups, client and server |
| `jdk.tls.useExtendedMasterSecret` | Enable/disable Extended Master Secret |
| `jdk.tls.trustNameService` | Enable reverse DNS lookup for hostname verification |
| `jsse.enableSNIExtension` | Enable/disable SNI extension (default: true) |

Scheme names in `jdk.tls.client.SignatureSchemes` and
`jdk.tls.server.SignatureSchemes` that are not recognized by wolfJSSE or not
supported by native wolfSSL are ignored. If no configured scheme is supported,
connection establishment fails with an `SSLException`.

### wolfJSSE-Specific System Properties

wolfJSSE supports several System properties:

| System Property | Default | To Enable | Description |
| ---------------------------------- | ------------ | ------------ | ------------------------------------------ |
| `wolfssl.debug` | "false" | "true" | Native wolfSSL debug logging |
| `wolfssljni.debug` | "false" | "true" | wolfJNI debug logging |
| `wolfjsse.debug` | "false" | "true" | wolfJSSE debug logging |
| `wolfjsse.debugFormat` | | "JSON" | Output debug logs in JSON format |
| `wolfsslengine.debug` | "false" | "true" | SSLEngine debug logging |
| `wolfsslengine.io.debug` | "false" | "true" | SSLEngine I/O bytes logging |
| `wolfjsse.autoSNI` | "false" | "true" | Auto-set SNI from hostname |
| `wolfssl.skipLibraryLoad` | "false" | "true" | Skip automatic native library loading |

## Debugging

Native wolfSSL logging (`wolfssl.debug`) only outputs messages if native wolfSSL
was compiled with `--enable-debug`.

These properties can be set at runtime:

```
java -Dwolfjsse.debug=true App
```

Or programmatically:

```java
System.setProperty("wolfjsse.debug", "true");
```

If properties are changed after `WolfSSLDebug` has been initialized, call
`WolfSSLDebug.refreshDebugFlags()` to refresh the values.

JDK debug logging can be enabled with `-Djavax.net.debug=all`.

### JSON Log Format

Debug messages can be output in JSON format for tools like DataDog:

```
java -Dwolfjsse.debug=true -Dwolfjsse.debugFormat=JSON App
```

## Native File Descriptor Events

wolfJSSE monitors native file descriptors for read/write events using either
`poll()` or `select()`.

By default, `poll()` is used unless:

- `WOLFJNI_USE_IO_SELECT` is defined when compiling the native JNI sources
  (ex: `make CFLAGS=-DWOLFJNI_USE_IO_SELECT`)
- Running on Windows, which defaults to `select()`

The `poll()` function is preferred because `select()` has undefined behavior
when file descriptor numbers exceed `FD_SETSIZE` (typically 1024). This limit
does not apply to Windows, where `FD_SETSIZE` is the number of sockets an
`fd_set` can hold rather than a limit on the socket value.

## ALPN Support

Application-Layer Protocol Negotiation (ALPN) is supported through both
`SSLSocket` and `SSLEngine`.

To get the negotiated protocol after handshake:

```java
String protocol = sslSocket.getApplicationProtocol();
```

wolfJSSE supports non-ASCII protocol names in ALPN.

## SNI Support

Server Name Indication (SNI) is supported on both client and server sides.

On the client, SNI can be configured through `SSLParameters`:

```java
SSLParameters params = sslSocket.getSSLParameters();
params.setServerNames(Arrays.asList(new SNIHostName("example.com")));
sslSocket.setSSLParameters(params);
```

The `wolfjsse.autoSNI` System property can enable automatic SNI configuration
from the hostname for `HttpsURLConnection`.

On the server, `SSLSession.getRequestedServerNames()` returns the SNI requested
by the client, and SNI matcher logic can be used with `WolfSSLSocket`.

## DTLS 1.3 Usage

DTLS 1.3 is supported through the `SSLEngine` interface only:

```java
SSLContext ctx = SSLContext.getInstance("DTLSv1.3", "wolfJSSE");
SSLEngine engine = ctx.createSSLEngine();
```

DTLS Connection ID (CID) is also supported through the native wolfSSL APIs
wrapped at the JNI level.

## Named Groups

TLS named groups (ECC curves and post-quantum ML-KEM/hybrid groups) can be
restricted using one of three sources, listed from highest to lowest
precedence. Only a single source is applied per session.

1. `SSLParameters.setNamedGroups()` (JDK 20+)
2. `jdk.tls.namedGroups` System property
3. `wolfjsse.enabledSupportedCurves` Security property (JDK 8+)

For example, to prefer the X25519MLKEM768 hybrid group with a classical
fallback:

```
java -Djdk.tls.namedGroups=X25519MLKEM768,secp256r1 App
```

Or programmatically on JDK 20+:

```java
SSLParameters params = sslSocket.getSSLParameters();
params.setNamedGroups(new String[] { "X25519MLKEM768", "secp256r1" });
sslSocket.setSSLParameters(params);
```

Group names are matched case insensitively. Both compact (`MLKEM768`,
`X25519MLKEM768`) and IETF (`ML-KEM-768`, `SecP256r1MLKEM768`) spellings are
recognized for PQC and hybrid groups. Unknown groups and groups not supported
by native wolfSSL are ignored. If no usable groups remain (for example all
groups are PQC and TLS 1.3 is not enabled), connection establishment fails
with an `SSLException`.

## Pre-Shared Key (PSK) Usage

PSK is configured on an `SSLSocket` or `SSLEngine` using `WolfSSLParameters`,
a wolfJSSE subclass of `SSLParameters`, applied with the standard
`setSSLParameters()` method. Since PSK does not use certificates, the
`SSLContext` can be initialized without a KeyManager or TrustManager.

Client side:

```java
import com.wolfssl.WolfSSLPskClientCallback;
import com.wolfssl.provider.jsse.WolfSSLParameters;

SSLContext ctx = SSLContext.getInstance("TLSv1.2", "wolfJSSE");
ctx.init(null, null, null);

SSLSocket sock = (SSLSocket)ctx.getSocketFactory().createSocket(host, port);

WolfSSLParameters params = new WolfSSLParameters();
params.setPskClientCb(new MyPskClientCallback());
params.setCipherSuites(new String[] { "TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256" });
sock.setSSLParameters(params);
sock.startHandshake();
```

On the server side, use `setPskServerCb()` with a `WolfSSLPskServerCallback`
implementation, and optionally `setPskIdentityHint()` to send an identity hint
to the client. PSK callback interfaces are the same ones used by the wolfSSL
JNI `WolfSSLSession` API. See the PSK examples in Chapter 8 for complete client
and server applications.

## FIPS Usage with wolfJCE

When wolfJSSE is used with wolfCrypt FIPS or FIPS Ready, wolfJSSE runs the
wolfCrypt FIPS CASTs (Conditional Algorithm Self Tests) when it initializes.
These run at most once per process.

Applications that register both wolfJSSE (`WolfSSLProvider`) and wolfJCE
(`WolfCryptProvider`) should avoid both providers running CASTs at the same
time on different threads, which can cause `FIPS_NOT_ALLOWED_E` errors. The
recommended order is:

1. Run CASTs once with wolfJCE `Fips.runAllCast_fips()`
2. Set the `wolfjsse.skipFIPSCAST` Security property to "true", either with
   `Security.setProperty()` or in the `java.security` file
3. Register both `WolfCryptProvider` and `WolfSSLProvider`

```java
import com.wolfssl.wolfcrypt.Fips;
import com.wolfssl.provider.jce.WolfCryptProvider;
import com.wolfssl.provider.jsse.WolfSSLProvider;

if (Fips.runAllCast_fips() != 0) {
    /* CAST failure, handle error */
}
Security.setProperty("wolfjsse.skipFIPSCAST", "true");

Security.insertProviderAt(new WolfCryptProvider(), 1);
Security.insertProviderAt(new WolfSSLProvider(), 2);
```

The `wolfjsse.skipFIPSCAST` property must be set before `WolfSSLProvider` is
constructed. See the `DualProviderFIPSTest` example in Chapter 8.

## Custom Native Library Loading

By default, wolfSSL JNI loads the native wolfSSL and wolfSSL JNI shared
libraries with `System.loadLibrary()`. Applications that need to load these
libraries with their own logic, for example when extracting native libraries
bundled inside a JAR at runtime, can set the `wolfssl.skipLibraryLoad` System
property to "true". This must be set before `WolfSSL.loadLibrary()` is called,
either directly or by the `WolfSSLProvider` constructor.

```java
System.setProperty("wolfssl.skipLibraryLoad", "true");

/* Load native libraries with custom logic */
System.load("/path/to/libwolfssl.so");
System.load("/path/to/libwolfssljni.so");

/* Then use wolfSSL as normal */
WolfSSL.loadLibrary();
```

Applications can check if library loading was skipped with
`WolfSSL.isLibraryLoadSkipped()`.

## Android Usage

### Application-Level

Register wolfJSSE programmatically in your application:

```java
import com.wolfssl.provider.jsse.WolfSSLProvider;

// Add as lowest priority
Security.addProvider(new WolfSSLProvider());

// Or insert as highest priority
Security.insertProviderAt(new WolfSSLProvider(), 1);
```

On Android, the `AndroidCAStore` KeyStore is used when available for loading
system CA certificates.

### System-Level (AOSP)

wolfJSSE can be installed as a system provider in Android AOSP. See the
`platform/android_aosp` directory and the document "Installing a JSSE Provider
in Android OSP" for details.
