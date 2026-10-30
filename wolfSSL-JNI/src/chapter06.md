#  Supported Algorithms and Classes

wolfJSSE extends or implements the following JSSE classes:

    javax.net.ssl.SSLContextSpi
        SSL, TLS, DEFAULT, TLSv1, TLSv1.1, TLSv1.2, TLSv1.3, DTLSv1.3
    javax.net.ssl.KeyManagerFactorySpi
        PKIX, X509, SunX509
    javax.net.ssl.TrustManagerFactorySpi
        PKIX, X509, SunX509
    javax.net.ssl.SSLEngine
    javax.net.ssl.SSLSession / ExtendedSSLSession
    javax.net.ssl.X509KeyManager / X509ExtendedKeyManager
    javax.net.ssl.X509TrustManager / X509ExtendedTrustManager
    javax.net.ssl.SSLServerSocket
    javax.net.ssl.SSLServerSocketFactory
    javax.net.ssl.SSLSocket
    javax.net.ssl.SSLSocketFactory
    javax.net.ssl.SSLSessionContext
    java.security.cert.X509Certificate
    javax.security.cert.X509Certificate

**Note:** `DTLSv1.3` is only supported through the `SSLEngine` interface.
DTLSv1.0 and DTLSv1.2 are available through the lower-level wolfSSL JNI API
but are not currently registered as JSSE SSLContext types.

The wolfJSSE `TrustManagerFactory` can be initialized with a `KeyStore` or
with `ManagerFactoryParameters`. Supported parameter types are
`CertPathTrustManagerParameters` (trust anchors are taken from the wrapped
`PKIXParameters`) and `KeyStoreBuilderParameters` (the first
`KeyStore.Builder` is used).

## Post-Quantum Cryptography

wolfJSSE supports post-quantum TLS 1.3 key exchange using ML-KEM (FIPS 203)
and post-quantum certificate authentication using ML-DSA (FIPS 204). Native
wolfSSL must be compiled with `--enable-mlkem` and `--enable-mldsa` (see
Chapter 2).

Supported ML-KEM TLS 1.3 named groups include:

| Group Type | Named Groups | Native wolfSSL Requirement |
| --- | --- | --- |
| PQ/T hybrid (IETF) | `X25519MLKEM768`, `SECP256R1MLKEM768`, `SECP384R1MLKEM1024` | `--enable-mlkem` |
| Pure ML-KEM | `ML-KEM-512`, `ML-KEM-768`, `ML-KEM-1024` | `--enable-tls-mlkem-standalone` |
| PQ/T hybrid (OQS, experimental) | `SECP256R1MLKEM512`, `SECP384R1MLKEM768`, `SECP521R1MLKEM1024`, `X25519MLKEM512`, `X448MLKEM768` | `--enable-experimental --enable-extra-pqc-hybrids` |

Named groups can be configured with `SSLParameters.setNamedGroups()` (JDK 20+),
the `jdk.tls.namedGroups` System property, or the
`wolfjsse.enabledSupportedCurves` Security property. See Chapter 7 for details
and precedence. wolfJSSE pre-generates the TLS 1.3 client key share for the
first configured group, avoiding a HelloRetryRequest when the server supports
that group.

ML-DSA certificate authentication requires a native wolfSSL release newer than
5.9.1. Loading ML-DSA private keys from a JKS KeyStore requires JDK 24 or newer
(JEP 497).

## Pre-Shared Key (PSK)

wolfJSSE supports TLS Pre-Shared Key (PSK) cipher suites through both
`SSLSocket` and `SSLEngine`. PSK callbacks and identity hints are configured
using the wolfJSSE `WolfSSLParameters` class, which extends `SSLParameters`.
See Chapter 7 for usage.

## Secure Renegotiation

wolfJSSE supports secure renegotiation when the underlying native wolfSSL
library has been compiled with secure renegotiation support:

```
$ ./configure --enable-secure-renegotiation
```

Or by defining `HAVE_SECURE_RENEGOTIATION`.

