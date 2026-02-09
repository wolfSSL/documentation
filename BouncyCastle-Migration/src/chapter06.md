# FIPS 140-3 Considerations

One of the most common motivations for migrating from Bouncy Castle to
wolfJCE/wolfJSSE is to leverage wolfCrypt's FIPS 140-3 validated cryptographic
module. This chapter covers important considerations when using wolfJCE and
wolfJSSE in a FIPS-compliant configuration.

## wolfCrypt FIPS 140-3 Overview

wolfCrypt has undergone several FIPS 140-3 validations, providing certified
implementations of cryptographic algorithms. When wolfJCE and wolfJSSE are
built against a FIPS-validated version of wolfCrypt, the cryptographic
operations performed through these providers use the validated module.

For more information on wolfCrypt FIPS 140-3 certificates and validated
platforms, contact wolfSSL at facts@wolfssl.com or visit
[https://www.wolfssl.com/license/fips/](https://www.wolfssl.com/license/fips/).

wolfSSL can easily add Operating Environments to existing wolfCrypt FIPS 140-3
certificates. If you have any specific needs or want to discuss this process,
wolfSSL is happy to talk through the details of how these typically work.

## Building with FIPS Support

To use FIPS 140-3 validated cryptography:

1. Obtain a wolfCrypt FIPS 140-3 release from wolfSSL (requires a commercial license).
2. Build the native wolfSSL library with FIPS support enabled.
3. Build wolfCrypt JNI/JCE (and/or wolfSSL JNI/JSSE) against the FIPS-enabled
   native library.

The wolfCrypt FIPS module enforces operational requirements including
power-on self-tests (POST) and algorithm restrictions. These are handled
automatically by the native library and are transparent to Java application
code using the JCE/JSSE APIs.

wolfCrypt FIPS 140-3 specific code (Conditional Algorithm Self Tests, in-core
integrity check, etc) can also be evaluated under wolfSSL JNI/JSSE and
wolfCrypt JNI/JCE by building the **FIPS Ready** GPLv3 variant of wolfSSL.
That can be downloaded from the [wolfSSL download page](https://wolfssl.com/download/).

## Algorithm Restrictions Under FIPS

When operating in FIPS mode, only FIPS-approved algorithms may be used. This
may affect which algorithms and KeyStore types are available through wolfJCE
compared to a non-FIPS build. Reference wolfSSL's [FIPS 140-3 certificates](https://www.wolfssl.com/license/fips/)
for lists of what algorithms are validated on each certificate.

Applications using non-approved algorithms (e.g., MD5, DES, RC4) through Bouncy
Castle will need to either remove those usages or ensure they are not called
through the FIPS-validated provider.

