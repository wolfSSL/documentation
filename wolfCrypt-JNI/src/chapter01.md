# Introduction

The JCE (Java Cryptography Extension) supports the installation of custom Cryptographic Service Providers. Those providers can implement a subset of the underlying cryptographic functionality used by the Java Security API.

This manual describes the details and usage of the wolfCrypt JCE provider. The wolfCrypt JCE provider (wolfJCE) uses JNI to wrap the native wolfCrypt cryptography library for compatibility with the Java Security API. The Github repository for wolfCrypt JNI/JCE is located [here](https://github.com/wolfSSL/wolfcrypt-jni).

The wolfcrypt-jni package contains both the wolfCrypt JNI wrapper and wolfJCE JCE provider. The JNI wrapper can be used independently if desired.
