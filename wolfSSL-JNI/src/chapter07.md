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

Example `jdk.tls.disabledAlgorithms` usage:

```
jdk.tls.disabledAlgorithms=SSLv3, TLSv1.1, DH keySize < 1024, EC keySize < 224, RSA keySize < 1024
```

### wolfJSSE-Specific Security Properties

The following Security properties are specific to wolfJSSE:

| Property | Default | Description |
| --- | --- | --- |
| `wolfjsse.enabledCipherSuites` | | Restrict enabled cipher suites |
| `wolfjsse.enabledSupportedCurves` | | Restrict enabled ECC curves |
| `wolfjsse.enabledSignatureAlgorithms` | | Restrict enabled signature algorithms |
| `wolfjsse.keystore.type.required` | | Require specific KeyStore type |
| `wolfjsse.clientSessionCache.disabled` | "false" | Disable client session cache |
| `wolfjsse.X509KeyManager.disableCache` | "false" | Disable X509KeyManager caching |

Example cipher suite restriction:

```
wolfjsse.enabledCipherSuites=TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

Example ECC curve restriction:

```
wolfjsse.enabledSupportedCurves=secp256r1, secp521r1
```

Example signature algorithm restriction:

```
wolfjsse.enabledSignatureAlgorithms=RSA+SHA256:ECDSA+SHA256
```

## System Properties

wolfJSSE supports both standard Java System properties and wolfJSSE-specific
System properties.

### Standard Java System Properties

The following standard Java System properties are supported by wolfJSSE:

| Property | Description |
| --- | --- |
| `javax.net.ssl.keyStore` | KeyStore file for KeyManager |
| `javax.net.ssl.keyStoreType` | KeyStore type for KeyManager |
| `javax.net.ssl.keyStorePassword` | KeyStore password for KeyManager |
| `javax.net.ssl.trustStore` | KeyStore file for TrustManager |
| `javax.net.ssl.trustStoreType` | KeyStore type for TrustManager |
| `javax.net.ssl.trustStorePassword` | KeyStore password for TrustManager |
| `jdk.tls.client.enableSessionTicketExtension` | Enable session tickets (Java 13+) |
| `jdk.tls.client.SignatureSchemes` | Client signature algorithms (partial support) |
| `jdk.tls.server.SignatureSchemes` | Server signature algorithms (partial support) |
| `jdk.tls.useExtendedMasterSecret` | Enable/disable Extended Master Secret |

### wolfJSSE-Specific System Properties

wolfJSSE supports several System properties:

| System Property | Default | To Enable | Description |
| --- | --- | --- | --- |
| `wolfssl.debug` | "false" | "true" | Native wolfSSL debug logging |
| `wolfssljni.debug` | "false" | "true" | wolfJNI debug logging |
| `wolfjsse.debug` | "false" | "true" | wolfJSSE debug logging |
| `wolfjsse.debugFormat` | | "JSON" | Output debug logs in JSON format |
| `wolfsslengine.debug` | "false" | "true" | SSLEngine debug logging |
| `wolfsslengine.io.debug` | "false" | "true" | SSLEngine I/O bytes logging |
| `wolfjsse.autoSNI` | "false" | Auto-set SNI from hostname |

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
- Running on Windows, which defaults to `select()`

The `poll()` function is preferred because `select()` has undefined behavior
when file descriptor numbers exceed `FD_SETSIZE` (typically 1024).

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

The `wolfjsse.autoSNI` Security property can enable automatic SNI configuration
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
