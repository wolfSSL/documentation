# Design Differences

This chapter compares how Mbed TLS and wolfSSL are structured, to frame the
porting work in the following chapters.

| Topic | Mbed TLS | wolfSSL |
| ------------------ | ----------------------------------------- | ----------------------------------------- |
| Context model | `mbedtls_ssl_config` plus `mbedtls_ssl_context` | `WOLFSSL_CTX` plus `WOLFSSL` |
| Protocol and role | `mbedtls_ssl_config_defaults()` arguments | The method passed to `wolfSSL_CTX_new()` |
| Crypto API | Legacy (3.6) or PSA (4.x) | Native wolfCrypt `wc_*` API, optional PSA via wolfPSA |
| RNG | Wired up by the application (3.6), internal to PSA (4.x) | Created and seeded internally per session |
| Configuration | `mbedtls_config.h`, `crypto_config.h` | `./configure`, CMake or `user_settings.h` |
| Return codes | 0 on success, negative error | `WOLFSSL_SUCCESS` (1) for TLS calls, 0 for `wc_*` calls |
| Transport | `mbedtls_ssl_set_bio()` callbacks | `wolfSSL_set_fd()` or I/O callbacks |
| Hardware offload | `_ALT` (3.6) or PSA drivers (4.x) | Crypto callbacks plus in-tree ports |
| License | Apache-2.0 or GPL-2.0-or-later | GPLv3 or commercial |

## One Context for Configuration, One per Connection

An `mbedtls_ssl_config` becomes a `WOLFSSL_CTX`, and an `mbedtls_ssl_context`
becomes a `WOLFSSL`. Instead of passing endpoint, transport and preset to
`mbedtls_ssl_config_defaults()`, you pass a method to `wolfSSL_CTX_new()`:
`wolfTLS_client_method()` negotiates the highest TLS version both sides
support, and `wolfDTLSv1_3_client_method()` selects DTLS 1.3. Configure the
`WOLFSSL_CTX` once, share it across threads, and create one `WOLFSSL` per
connection.

## No RNG Plumbing

wolfSSL needs neither the 3.6 CTR-DRBG wiring nor the 4.x `psa_crypto_init()`
call: every `WOLFSSL` seeds its own RNG from the platform entropy source. On
bare metal you provide that source once, through `CUSTOM_RAND_GENERATE_SEED`
or a `wc_GenerateSeed()` port, the counterpart of
`MBEDTLS_ENTROPY_HARDWARE_ALT` or `MBEDTLS_PSA_DRIVER_GET_ENTROPY`, and wolfSSL
runs its Hash_DRBG on top. When you call wolfCrypt directly, functions that
need randomness take an explicit `WC_RNG*`.

## Memory Footprint

Mbed TLS reserves a 16 KB input and a 16 KB output buffer per connection by
default, unless you shrink them with `MBEDTLS_SSL_IN_CONTENT_LEN` and
`MBEDTLS_SSL_OUT_CONTENT_LEN`. wolfSSL allocates each record at its actual size
and frees it once processed, so peak use follows the largest record you see,
still up to 16 KB unless both sides agree on Max Fragment Length. For systems
without `malloc()`, `--enable-staticmemory` serves every allocation from pools
you provide.

Two wolfSSL blog posts measured both libraries:
[TLS 1.3 in 30.8 KB](https://www.wolfssl.com/tls-1-3-in-30-8-kb-wolfssl-vs-mbedtls/)
found wolfSSL 5% to 44% smaller in flash on a Cortex-M33, and
[an apples-to-apples benchmark](https://www.wolfssl.com/wolfssl-vs-mbedtls-an-apples-to-apples-benchmark-across-intel-arm-cortex-a-and-cortex-m-and-risc-v-targets/)
found wolfCrypt's public-key operations several times faster on Intel, ARM and
RISC-V.

## Licensing

Mbed TLS is dual licensed under Apache-2.0 and GPL-2.0-or-later. Apache-2.0 lets
you ship closed-source firmware with only notice requirements. wolfSSL is dual
licensed under GPLv3 and a commercial license, so most closed-source firmware
needs a commercial license. GPLv3 is rarely a way around it: for consumer
devices it also requires that users can install modified software, which
locked-down firmware usually cannot allow. Contact wolfSSL early, so licensing
is settled before engineering starts.
