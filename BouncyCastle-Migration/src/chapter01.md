# Introduction

This guide provides instructions and reference material for developers migrating
Java applications from the Bouncy Castle JCE provider and/or JSSE provider to
wolfSSL's wolfJCE and wolfJSSE providers. wolfJCE and wolfJSSE are backed by
the wolfCrypt native cryptography library, which includes FIPS 140-3 validated
options for applications requiring certified cryptography.

## Audience

This guide is intended for Java developers and architects who currently use
Bouncy Castle for cryptographic operations (JCE) and/or TLS (JSSE) and are
evaluating or planning a migration to wolfJCE and/or wolfJSSE.

## Why Migrate?

Common reasons for migrating from Bouncy Castle to wolfJCE/wolfJSSE include:

- **FIPS 140-3 compliance** - wolfCrypt has FIPS 140-3 validated cryptographic
  modules, providing certified cryptography underneath the JCE and JSSE layers.
- **Performance** - wolfCrypt is written in C and can leverage hardware
  cryptography acceleration, offering performance advantages over pure-Java
  implementations.
- **Reduced footprint** - wolfCrypt's native implementation can offer a smaller
  overall footprint compared to Bouncy Castle in resource-constrained
  environments.
- **Commercial support** - wolfSSL Inc. provides commercial support, maintenance,
  and consulting services.

## Scope

This guide covers migration of:

- **JCE Provider** - Cryptographic operations including ciphers, message digests,
  MACs, signatures, key generation, key agreement, and KeyStore implementations
  (Bouncy Castle JCE Provider to wolfJCE).
- **JSSE Provider** - TLS/SSL connections including SSLContext, SSLSocket,
  SSLServerSocket, SSLEngine, TrustManager, and KeyManager implementations
  (Bouncy Castle JSSE Provider to wolfJSSE).

For detailed reference on each product, see the
[wolfCrypt JCE Provider and JNI Manual](https://www.wolfssl.com/documentation/manuals/wolfcrypt-jni-jce/)
and the
[wolfSSL JNI and wolfJSSE Manual](https://www.wolfssl.com/documentation/manuals/wolfssljni/).
