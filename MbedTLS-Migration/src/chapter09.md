# Configuration Equivalents

| Mbed TLS option | wolfSSL configure option | `user_settings.h` macro |
| -------------------------------------- | -------------------------------------- | ------------------------ |
| `MBEDTLS_SSL_PROTO_TLS1_3` | On by default (`--enable-tls13`) | `WOLFSSL_TLS13` |
| `MBEDTLS_SSL_PROTO_DTLS` | `--enable-dtls` (add `--enable-dtls13` for DTLS 1.3) | `WOLFSSL_DTLS`, `WOLFSSL_DTLS13` |
| `MBEDTLS_SSL_DTLS_CONNECTION_ID` | `--enable-dtlscid` | `WOLFSSL_DTLS_CID` |
| `MBEDTLS_SSL_DTLS_SRTP` | `--enable-srtp` | `WOLFSSL_SRTP` |
| `MBEDTLS_SSL_SERVER_NAME_INDICATION` | `--enable-sni` (on by default only on x86 and aarch64 hosts) | `HAVE_SNI` |
| `MBEDTLS_SSL_ALPN` | `--enable-alpn` | `HAVE_ALPN` |
| `MBEDTLS_SSL_SESSION_TICKETS` | `--enable-session-ticket`; with wolfSSL 5.9.4 and earlier, a client that talks to Mbed TLS TLS 1.3 servers also needs `--enable-ticket-nonce-malloc` | `HAVE_SESSION_TICKET`, `WOLFSSL_TICKET_NONCE_MALLOC` |
| `MBEDTLS_SSL_EARLY_DATA` | `--enable-earlydata` plus `--enable-session-ticket` or `--enable-psk` | `WOLFSSL_EARLY_DATA` |
| `MBEDTLS_SSL_MAX_FRAGMENT_LENGTH` | `--enable-maxfragment` | `HAVE_MAX_FRAGMENT` |
| `MBEDTLS_SSL_RENEGOTIATION` | `--enable-secure-renegotiation`, only if the application enables renegotiation with `mbedtls_ssl_conf_renegotiation()` | `HAVE_SECURE_RENEGOTIATION` |
| `MBEDTLS_KEY_EXCHANGE_*PSK*` | `--enable-psk` (no RSA-PSK suites) | Leave `NO_PSK` undefined |
| `MBEDTLS_KEY_EXCHANGE_RSA_ENABLED` (3.6) | `CFLAGS=-DWOLFSSL_STATIC_RSA`; static RSA has no forward secrecy and is gone in 4.x | `WOLFSSL_STATIC_RSA` |
| `MBEDTLS_CCM_C` / `PSA_WANT_ALG_CCM` | `--enable-aesccm` | `HAVE_AESCCM` |
| `PSA_WANT_ECC_MONTGOMERY_255` / `MBEDTLS_ECP_DP_CURVE25519_ENABLED` | `--enable-curve25519` | `HAVE_CURVE25519` |
| `MBEDTLS_LMS_C` | `--enable-lms` | `WOLFSSL_HAVE_LMS` |
| No equivalent (ML-KEM) | On by default (`--enable-mlkem`); pure ML-KEM key exchange needs `--enable-tls-mlkem-standalone` | `WOLFSSL_HAVE_MLKEM` (with `WOLFSSL_SHA3`, `WOLFSSL_SHAKE128`, `WOLFSSL_SHAKE256`), `WOLFSSL_PQC_HYBRIDS` and `WOLFSSL_TLS_NO_MLKEM_STANDALONE` to match the configure default |
| Experimental ML-DSA-87 (development branch only) | `--enable-mldsa`, `--enable-slhdsa` | `WOLFSSL_HAVE_MLDSA`, `WOLFSSL_HAVE_SLHDSA` (with `WOLFSSL_SHA3`, `WOLFSSL_SHAKE128`, `WOLFSSL_SHAKE256`) |
| `MBEDTLS_MEMORY_BUFFER_ALLOC_C` | `--enable-staticmemory` | `WOLFSSL_STATIC_MEMORY` |
| `MBEDTLS_THREADING_C` | On by default (`--enable-singlethreaded` to remove) | Define `SINGLE_THREADED` to remove |
| `MBEDTLS_DEBUG_C` | `--enable-debug` | `DEBUG_WOLFSSL` |
| Crypto `MBEDTLS_*_ALT`, PSA drivers | `--enable-cryptocb` | `WOLF_CRYPTO_CB` |

The defaults in this table apply to `./configure` and CMake. In a
`user_settings.h` build, features such as TLS 1.3, ML-KEM, the hybrid groups
and SNI are on only if you define them, so start from
`examples/configs/user_settings_tls13.h` (or `user_settings_dtls13.h`,
`user_settings_pq.h`) rather than an empty file. None of these templates
enables the hybrid groups. Add `WOLFSSL_PQC_HYBRIDS` and
`WOLFSSL_TLS_NO_MLKEM_STANDALONE` to `user_settings_pq.h`; the TLS 1.3 and
DTLS 1.3 templates also need `WOLFSSL_HAVE_MLKEM`, `WOLFSSL_SHA3`,
`WOLFSSL_SHAKE128` and `WOLFSSL_SHAKE256`, and the DTLS 1.3 template needs
`HAVE_SNI` and `WOLFSSL_DTLS_CH_FRAG`. A DTLS 1.3 server must also call
`wolfSSL_dtls13_allow_ch_frag()` to accept a fragmented ClientHello. Only the
second ClientHello, which carries the cookie, may be fragmented.
