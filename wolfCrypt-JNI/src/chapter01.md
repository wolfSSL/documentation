# Introduction

The JCE (Java Cryptography Extension) framework supports the installation of custom Cryptographic Service Providers which can in turn implement a subset of the underlying cryptographic functionality used by the Java Security API.

This document describes the details and usage of the wolfCrypt JCE provider. The wolfCrypt JCE provider (wolfJCE) wraps the native wolfCrypt cryptography library for compatibility with the Java Security API. See the Github repository [here](https://github.com/wolfSSL/wolfcrypt-jni).

The wolfcrypt-jni package contains both the wolfCrypt JNI wrapper in addition to the JCE provider. The JNI wrapper can be used independently if desired.
