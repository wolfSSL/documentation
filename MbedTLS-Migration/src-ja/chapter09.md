# 設定オプションの対応

| Mbed TLS のオプション | wolfSSL の configure オプション | `user_settings.h` のマクロ |
| -------------------------------------- | -------------------------------------- | ------------------------ |
| `MBEDTLS_SSL_PROTO_TLS1_3` | デフォルトで有効（`--enable-tls13`） | `WOLFSSL_TLS13` |
| `MBEDTLS_SSL_PROTO_DTLS` | `--enable-dtls`（DTLS 1.3 にはさらに `--enable-dtls13`） | `WOLFSSL_DTLS`, `WOLFSSL_DTLS13` |
| `MBEDTLS_SSL_DTLS_CONNECTION_ID` | `--enable-dtlscid` | `WOLFSSL_DTLS_CID` |
| `MBEDTLS_SSL_DTLS_SRTP` | `--enable-srtp` | `WOLFSSL_SRTP` |
| `MBEDTLS_SSL_SERVER_NAME_INDICATION` | `--enable-sni`（デフォルトで有効なのは x86 および aarch64 ホストのみ） | `HAVE_SNI` |
| `MBEDTLS_SSL_ALPN` | `--enable-alpn` | `HAVE_ALPN` |
| `MBEDTLS_SSL_SESSION_TICKETS` | `--enable-session-ticket`。wolfSSL 5.9.4 以前（5.9.4 を含む）では、Mbed TLS の TLS 1.3 サーバーと通信するクライアントに `--enable-ticket-nonce-malloc` も必要。 | `HAVE_SESSION_TICKET`, `WOLFSSL_TICKET_NONCE_MALLOC` |
| `MBEDTLS_SSL_EARLY_DATA` | `--enable-earlydata` と、`--enable-session-ticket` または `--enable-psk` | `WOLFSSL_EARLY_DATA` |
| `MBEDTLS_SSL_MAX_FRAGMENT_LENGTH` | `--enable-maxfragment` | `HAVE_MAX_FRAGMENT` |
| `MBEDTLS_SSL_RENEGOTIATION` | `--enable-secure-renegotiation`。アプリケーションが `mbedtls_ssl_conf_renegotiation()` で再ネゴシエーションを有効にしている場合のみ。 | `HAVE_SECURE_RENEGOTIATION` |
| `MBEDTLS_KEY_EXCHANGE_*PSK*` | `--enable-psk`（RSA-PSK 暗号スイートは非対応） | `NO_PSK` を定義しない |
| `MBEDTLS_KEY_EXCHANGE_RSA_ENABLED`（3.6 のみ。4.x で廃止） | `CFLAGS=-DWOLFSSL_STATIC_RSA`。静的 RSA には前方秘匿性がない。 | `WOLFSSL_STATIC_RSA` |
| `MBEDTLS_CCM_C` / `PSA_WANT_ALG_CCM` | `--enable-aesccm` | `HAVE_AESCCM` |
| `PSA_WANT_ECC_MONTGOMERY_255` / `MBEDTLS_ECP_DP_CURVE25519_ENABLED` | `--enable-curve25519` | `HAVE_CURVE25519` |
| `MBEDTLS_LMS_C` | `--enable-lms` | `WOLFSSL_HAVE_LMS` |
| 相当するものなし（ML-KEM） | デフォルトで有効（`--enable-mlkem`）。単体の ML-KEM 鍵交換には `--enable-tls-mlkem-standalone` が必要。 | `WOLFSSL_HAVE_MLKEM`（`WOLFSSL_SHA3`, `WOLFSSL_SHAKE128`, `WOLFSSL_SHAKE256` も必要）。configure のデフォルトに合わせるには、`WOLFSSL_PQC_HYBRIDS` と `WOLFSSL_TLS_NO_MLKEM_STANDALONE` も定義する。 |
| 実験的な ML-DSA-87（開発ブランチのみ） | `--enable-mldsa`, `--enable-slhdsa` | `WOLFSSL_HAVE_MLDSA`, `WOLFSSL_HAVE_SLHDSA`（`WOLFSSL_SHA3`, `WOLFSSL_SHAKE128`, `WOLFSSL_SHAKE256` も必要） |
| `MBEDTLS_MEMORY_BUFFER_ALLOC_C` | `--enable-staticmemory` | `WOLFSSL_STATIC_MEMORY` |
| `MBEDTLS_THREADING_C` | デフォルトで有効（無効にするには `--enable-singlethreaded`） | 無効にするには `SINGLE_THREADED` を定義 |
| `MBEDTLS_DEBUG_C` | `--enable-debug` | `DEBUG_WOLFSSL` |
| 暗号の `MBEDTLS_*_ALT`、PSA ドライバ | `--enable-cryptocb` | `WOLF_CRYPTO_CB` |

この表のデフォルトは `./configure` と CMake に適用されます。
`user_settings.h` を使うビルドでは、TLS 1.3、ML-KEM、ハイブリッドグループ、SNI などの機能は定義した場合にのみ有効になります。
そのため、空のファイルからではなく、`examples/configs/user_settings_tls13.h`（または `user_settings_dtls13.h`、`user_settings_pq.h`）から始めてください。
これらのテンプレートはいずれもハイブリッドグループを有効にしていません。
`user_settings_pq.h` には `WOLFSSL_PQC_HYBRIDS` と `WOLFSSL_TLS_NO_MLKEM_STANDALONE` を追加してください。
TLS 1.3 と DTLS 1.3 のテンプレートでは、さらに `WOLFSSL_HAVE_MLKEM`、`WOLFSSL_SHA3`、`WOLFSSL_SHAKE128`、`WOLFSSL_SHAKE256` が必要です。
DTLS 1.3 のテンプレートには `HAVE_SNI` と `WOLFSSL_DTLS_CH_FRAG` も必要です。
DTLS 1.3 サーバーは、フラグメント化された ClientHello を受け付けるために `wolfSSL_dtls13_allow_ch_frag()` も呼び出す必要があります。
フラグメント化が許されるのは、Cookie を含む 2 回目の ClientHello のみです。
