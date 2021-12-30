# Introduction

The Java Secure Socket Extension ( **JSSE** ) framework supports the installation of security providers. These providers can implement a subset of the functionality used by the Java JSSE security APIs, including SSL/TLS.

This document describes wolfSSL’s JSSE provider implementation, named “ **wolfJSSE** ”. wolfJSSE wraps the native wolfSSL SSL/TLS library, providing Java users the opportunity to take advantage of wolfSSL’s progressive features, performance, and resource optimizations. This interface gives Java applications access to all the benefits of using wolfSSL, including current SSL/TLS standards up to [TLS 1.3](https://www.wolfssl.com/tls13), [FIPS 140-2 and 140-3](https://www.wolfssl.com/license/fips/) support, performance optimizations, hardware cryptography support, [commercial support](https://www.wolfssl.com/products/support-and-maintenance/), and more!

wolfJSSE is distributed as part of the “ **wolfssljni** ”package. This package includes both a thin JNI wrapper for wolfSSL and the wolfJSSE provider.

