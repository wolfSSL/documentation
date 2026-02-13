# Troubleshooting and Common Issues

This chapter covers common issues encountered during migration from Bouncy
Castle to wolfJCE/wolfJSSE and their solutions.

## Native Library Loading Failures

### UnsatisfiedLinkError

```
java.lang.UnsatisfiedLinkError: no wolfssl in java.library.path
```

The native wolfSSL shared library cannot be found. Ensure:

- The wolfSSL shared library is compiled and installed.
- The library path is set correctly via `java.library.path`:

```
java -Djava.library.path=/usr/local/lib -jar myapp.jar
```

- On Linux, `LD_LIBRARY_PATH` includes the library directory.
- On macOS, `DYLD_LIBRARY_PATH` includes the library directory.

## Provider Not Found

```
java.security.NoSuchProviderException: no such provider: wolfJCE
```

Ensure that the wolfJCE provider has been registered before attempting to use
it. Verify that:

- `Security.addProvider(new WolfCryptProvider())` or
  `Security.insertProviderAt(new WolfCryptProvider(), 1)` is called before any
  cryptographic operations.
- Or, the provider is registered in the `java.security` configuration file.
- The wolfcrypt-jni JAR is on the classpath.

## Algorithm Not Available

```
java.security.NoSuchAlgorithmException: no such algorithm: <algorithm>
```

The requested algorithm may not be supported by wolfJCE/wolfJSSE, or may not
be enabled in the native wolfSSL build. Check:

- The [wolfJCE Supported Algorithms](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/chapter06.html)
  and [wolfJSSE Supported Algorithms](https://www.wolfssl.com/documentation/manuals/wolfssljni/chapter06.html)
  documentation.
- The native [wolfSSL library compile-time options](https://www.wolfssl.com/documentation/manuals/wolfssl/chapter02.html) to ensure the algorithm is enabled.

## Cipher Suite Mismatch

If TLS connections fail with handshake errors, verify that:

- The cipher suites used by the peer are supported by wolfJSSE.
- The TLS protocol version is enabled in the native wolfSSL build.
- Certificate types and key sizes are compatible.

Use wolfJSSE debug logging to diagnose handshake issues:

```
java -Dwolfssl.debug=true -Dwolfjsse.debug=true -jar myapp.jar
```

## KeyStore Format Compatibility

Bouncy Castle's BKS (BouncyCastle KeyStore) format is not supported by
wolfJCE. For FIPS 140-3 compatibility, KeyStores should be converted to WKS
(WolfSSLKeyStore) format. See the [KeyStore Migration](chapter03.md#keystore-migration) section in Chapter 3
for detailed conversion instructions.

Common KeyStore-related issues:

### Wrong KeyStore Type

```
java.security.KeyStoreException: WKS not found
```

The wolfJCE provider must be registered before loading a WKS KeyStore. Ensure
`Security.addProvider(new WolfCryptProvider())` has been called, or that the
provider is configured in `java.security`.

### BKS KeyStore Cannot Be Loaded Directly

WKS does not read BKS format files. Convert BKS keystores to PKCS12 first
(using Bouncy Castle / `keytool`), then convert PKCS12 to WKS using wolfJCE.
See Chapter 3 for the step-by-step conversion process.

### PBKDF2 Iteration Count Too Low

```
IllegalArgumentException: PBKDF2 iteration count below minimum
```

The WKS KeyStore enforces a minimum PBKDF2 iteration count of 10,000. If you
have set a custom value via `wolfjce.wks.iterationCount`, ensure it meets this
minimum.

