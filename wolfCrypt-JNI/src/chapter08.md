#  Usage

For usage, please follow the Oracle/OpenJDK Javadocs for the classes
specified in [Chapter 6](chapter06.md#supported-jce-algorithms-and-classes).
Note that you will need to explicitly request the `wolfJCE` provider if it has
been set lower in precedence than other providers that offer the same algorithm
in the `java.security` file. For example, to use the wolfJCE provider with the
MessageDigest class for SHA-1 you would create a MessageDigest object like so:

```
MessageDigest md = MessageDigest.getInstance("SHA-1", "wolfJCE");
```

## System and Security Property Support

wolfJCE supports the following Java System and Security properties for
behavior customization and debugging.

### Security Property Support

The following Java Security properties can be set in the `java.security`
file for JCE provider customization:

| Security Property | Default | To Enable | Description |
| --- | --- | --- | --- |
| wolfjce.wks.iterationCount | 210,000 | Numeric | PBKDF2 iteration count (10,000 minimum) |
| wolfjce.wks.maxCertChainLength | 100 | Integer | Max cert chain length |
| wolfjce.wks.maxEntrySize | 10485760 | Integer | Max encoded entry size in bytes when loading WKS (10 MB default) |
| wolfjce.keystore.kekCacheEnabled | false | true | Enable KEK caching in WKS KeyStore for performance |
| wolfjce.keystore.kekCacheTtlSec | 300 | Integer | KEK cache TTL in seconds (1 second minimum) |
| wolfjce.mapJKStoWKS | UNSET | true | Register fake JKS KeyStore service mapped to WKS |
| wolfjce.mapPKCS12toWKS | UNSET | true | Register fake PKCS12 KeyStore service mapped to WKS |

The WKS-related Security properties are described in more detail in
[Chapter 9](chapter09.md#keystore-implementations).

### System Property Support

The following Java System properties can be set on the command line or
programmatically for JCE provider customization:

| System Property | Default | To Enable | Description |
| --- | --- | --- | --- |
| wolfjce.debug | "false" | "true" | Enable wolfJCE debug logging |
| wolfjce.ioTimeout | UNSET | Integer (seconds) | I/O timeout for OCSP and CRL HTTP operations (0-3600) |
| wolfssl.skipLibraryLoad | "false" | "true" | Skip automatic native library loading (see [Chapter 4](chapter04.md#custom-native-library-loading)) |

**wolfjce.ioTimeout** - sets the I/O timeout (in seconds) used by native wolfSSL
for HTTP-based OCSP lookups and CRL fetching. Wraps native
`wolfIO_SetTimeout()`, and requires native wolfSSL to be compiled with
`HAVE_IO_TIMEOUT`. Valid values are 0 to 3600 inclusive, where 0 disables the
timeout (default behavior). The property is read during
`PKIXRevocationChecker.init()`, which occurs at certificate path validation
time, so it can be set or changed after provider registration and will be
picked up on the next validation. Invalid values (non-numeric, negative,
exceeding 3600) will cause revocation checker initialization to fail with
`CertPathValidatorException`. This property replaces the Sun-specific
`com.sun.security.ocsp.timeout` and `com.sun.security.crl.timeout` properties
(which use milliseconds) with a single wolfJCE-specific property in seconds
that applies to both OCSP and CRL operations.

## SecureRandom.getInstanceStrong()

When registered as the highest priority security provider, wolfJCE will
provide `SecureRandom` with the underlying `HashDRBG` algorithm.

Java applications can alternatively call the
`SecureRandom.getInstanceStrong()` API to get a "known strong SecureRandom
implementation". To provide this with wolfJCE, the `java.security` file needs
to be modified by setting the `securerandom.strongAlgorithms` property to:

```
securerandom.strongAlgorithms=HashDRBG:wolfJCE
```

Note that the `securerandom.source` property in `java.security` has no effect
on the wolfJCE provider.

## Removing Sun Cryptographic Services in Hardened Environments

For hardened JREs, such as FIPS 140-3 Java containers where non-FIPS
validated Sun cryptography must be removed but certain non-cryptographic Sun
services (ex: `CertificateFactory.X.509`, `CertStore.Collection`) are still
needed, the wolfcrypt-jni package ships example "filtered" providers under
the `examples/filtered-providers` directory. These wrap the JDK `SUN`,
`SunEC`, and `SunRsaSign` providers and expose only their non-cryptographic
services. They require Java 9 or later, are not part of the published
`wolfcrypt-jni.jar`, and build into a standalone
`lib/filtered-providers/filtered-providers.jar`. See the README.md in that
directory for build and integration details.

Please email support@wolfssl.com with any questions or feedback.
