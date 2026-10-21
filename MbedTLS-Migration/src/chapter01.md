# Introduction

This guide helps developers move embedded and host applications from Mbed TLS
to wolfSSL. It covers the design differences that matter, a side-by-side TLS
client, the pitfalls seen most often in real migrations, and full API and
configuration mappings.

## Audience

This guide is for C developers and architects who maintain a product built on
Mbed TLS 3.6 or 4.x and are planning or evaluating a move to wolfSSL. It
assumes you know the Mbed TLS API your product uses today.

## Scope

The guide covers both Mbed TLS 3.6 and 4.x, with 4.x as the primary reference.
The TLS-layer calls (`mbedtls_ssl_*`) changed much less between 3.6 and 4.x
than the crypto layer did, so most of the guide applies to both. Where the two
versions differ, the text says so.

The guide focuses on TLS and DTLS. Code that calls Mbed TLS or PSA crypto
functions directly can move to the native wolfCrypt `wc_*` API, or keep the
PSA Crypto API on top of wolfCrypt through wolfPSA (see
[Features Beyond Mbed TLS](chapter06.md)).

## Mbed TLS Support Status

As of October 2026:

| Branch | Status |
| -------------------- | -------------------------------------------------------------------------------- |
| 2.28 LTS | End of life. The last release was 2.28.10 (March 2025). |
| 3.6 LTS | Maintained until March 2027. Latest release 3.6.7 (July 2026). |
| 4.0 | First 4.x release (October 2025), with crypto split out into TF-PSA-Crypto 1.0. |
| 4.1 LTS | Announced with fixes until March 2029. Latest release 4.1.1 (July 2026). |
| 4.2 | Current mainline release (July 2026), with TF-PSA-Crypto 1.2. |

In October 2026 the Mbed TLS team
[announced](https://lists.trustedfirmware.org/archives/list/mbed-tls@lists.trustedfirmware.org/thread/YPIGCB7WN6GCHOGEGKOJXUYAP7OK527W/)
that its current maintainers will stop working on the TLS and X.509 libraries
in April 2027. Unless new maintainers take over, security fixes and releases
for those libraries end then, which also affects the TLS and X.509 part of the
4.1 LTS branch. The crypto layer, TF-PSA-Crypto, stays actively maintained.

## How to Use This Guide

1. Read [Design Differences](chapter02.md) for the concepts that change.
2. Port your TLS setup and I/O code using
   [Porting a TLS Client](chapter03.md) and the [API Mapping](chapter08.md).
3. Build wolfSSL with the features your Mbed TLS configuration uses, using
   [Configuration Equivalents](chapter09.md) as a checklist.
4. Check your port against [Common Pitfalls](chapter04.md). Most of them
   compile fine and fail at runtime.
5. Test against your existing Mbed TLS peers, as described in
   [Getting Started](chapter07.md).
