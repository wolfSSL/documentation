# Introduction

wolfSSL JNI/JSSE is a provider implementation of the Java Secure Socket Extension. It also includes a thin JNI wrapper around the native wolfSSL SSL/TLS library. If you are instead looking for a JCE (Java Cryptography Extension) provider, see [wolfCrypt JNI/JCE](https://www.wolfssl.com/documentation/manuals/wolfcryptjni/). wolfSSL actively maintains both of these providers (JSSE and JCE).

The Java Secure Socket Extension ( **JSSE** ) framework supports the installation of security providers. These providers can implement a subset of the functionality used by the Java JSSE security APIs, including SSL/TLS.

This document describes wolfSSL’s JSSE provider implementation, named “ **wolfJSSE / wolfSSLProvider** ”. wolfJSSE wraps the native wolfSSL SSL/TLS library. This interface gives Java applications access to all the benefits of using wolfSSL, including current SSL/TLS standards up to [TLS 1.3](https://www.wolfssl.com/tls13), [FIPS 140-2 and 140-3](https://www.wolfssl.com/license/fips/) support, performance optimizations, hardware cryptography support, [commercial support](https://www.wolfssl.com/products/support-and-maintenance/), and more!

wolfJSSE is distributed as part of the “ **wolfssljni** ”package.
