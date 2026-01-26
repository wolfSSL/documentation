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

## Secure Renegotiation

wolfJSSE supports secure renegotiation when the underlying native wolfSSL
library has been compiled with secure renegotiation support:

```
$ ./configure --enable-secure-renegotiation
```

Or by defining `HAVE_SECURE_RENEGOTIATION`.

