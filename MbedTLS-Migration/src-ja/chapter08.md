# API 対応表

備考欄に特に記載がない限り、Mbed TLS の名前は 3.6 と 4.x の両方に当てはまります。
Mbed TLS の鍵交換のうち 2 つには、wolfSSL に相当するものがありません。
1 つは OpenThread が Thread のコミッショニングに使用する EC J-PAKE 暗号スイート（`MBEDTLS_KEY_EXCHANGE_ECJPAKE_ENABLED`）、もう 1 つは 3.6 の RSA-PSK 暗号スイート（`MBEDTLS_KEY_EXCHANGE_RSA_PSK_ENABLED`）です。

## 初期化と終了処理

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `psa_crypto_init()` | `wolfSSL_Init()` | 4.x、および `MBEDTLS_USE_PSA_CRYPTO` を有効にした 3.6 では必須。`wolfSSL_CTX_new()` は必要に応じて `wolfSSL_Init()` を呼び出す。 |
| `mbedtls_ssl_config_init()` + `mbedtls_ssl_config_defaults()` | `wolfSSL_CTX_new(method)` | ロール、トランスポート、バージョンは `method` で決まる |
| `mbedtls_ssl_conf_min_tls_version()` | `wolfSSL_CTX_SetMinVersion()` | または `wolfTLSv1_3_client_method()` などバージョン固有の `method` を使用 |
| `mbedtls_ssl_conf_rng()` | 不要 | 3.6 のみ。4.x で削除。 |
| `mbedtls_ssl_init()` + `mbedtls_ssl_setup()` | `wolfSSL_new(ctx)` | |
| `mbedtls_ssl_session_reset()` | `wolfSSL_clear()` | |
| `mbedtls_ssl_free()`, `mbedtls_ssl_config_free()` | `wolfSSL_free()`, `wolfSSL_CTX_free()` | |
| `mbedtls_psa_crypto_free()` | `wolfSSL_Cleanup()` | |

## 証明書、鍵、検証

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_x509_crt_parse_file()` + `mbedtls_ssl_conf_ca_chain()` | `wolfSSL_CTX_load_verify_locations()` | |
| `mbedtls_x509_crt_parse()` + `mbedtls_ssl_conf_ca_chain()` | `wolfSSL_CTX_load_verify_buffer()` | Mbed TLS と同じバッファと長さを使用可能。フォーマットは明示的に指定する。 |
| `mbedtls_x509_crt_parse_file()` + `mbedtls_pk_parse_keyfile()` + `mbedtls_ssl_conf_own_cert()` | `wolfSSL_CTX_use_certificate_chain_file()` + `wolfSSL_CTX_use_PrivateKey_file()` | `wolfSSL_CTX_use_certificate_chain_file()` は PEM のみ。DER 証明書には `WOLFSSL_FILETYPE_ASN1` を指定して `wolfSSL_CTX_use_certificate_file()` を使用。`mbedtls_pk_parse_keyfile()` は 3.6 では RNG の引数を取るが、4.x では取らない。 |
| 上記のバッファ版 | `wolfSSL_CTX_use_certificate_chain_buffer()` + `wolfSSL_CTX_use_PrivateKey_buffer()` | `wolfSSL_CTX_use_certificate_chain_buffer()` は PEM のみ。DER には `WOLFSSL_FILETYPE_ASN1` を指定して `wolfSSL_CTX_use_certificate_buffer()` を使用。 |
| `mbedtls_ssl_conf_authmode()` | `wolfSSL_CTX_set_verify()` | `MBEDTLS_SSL_VERIFY_REQUIRED`: `WOLFSSL_VERIFY_PEER`（サーバーではさらに `WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT`）。`MBEDTLS_SSL_VERIFY_OPTIONAL`: `WOLFSSL_VERIFY_PEER` と 1 を返すコールバック。`MBEDTLS_SSL_VERIFY_NONE`: `WOLFSSL_VERIFY_NONE`。 |
| `mbedtls_ssl_conf_verify()` | `wolfSSL_CTX_set_verify()` のコールバック引数 | wolfSSL の検証コールバックでは、証明書チェーンは DER 形式で `store->certs[]` に渡される。`wc_InitDecodedCert()` + `wc_ParseCert()` でパースする。`store->current_cert` には `--enable-opensslextra` が必要。デフォルトでは、コールバックは検証に失敗した証明書に対してのみ呼ばれる。`WOLFSSL_ALWAYS_VERIFY_CB` を定義すると成功時にも、`WOLFSSL_VERIFY_CB_ALL_CERTS` を定義するとすべての中間証明書に対して呼ばれる。`--enable-opensslextra` は両方を定義する。 |
| `mbedtls_ssl_set_hostname()` | `wolfSSL_UseSNI()` + `wolfSSL_check_domain_name()` | IP アドレスには `wolfSSL_check_ip_address()`。[よくある落とし穴](chapter04.md)を参照。 |
| `mbedtls_ssl_conf_sni()`（サーバー） | `wolfSSL_CTX_set_servername_callback()` + `wolfSSL_SNI_GetRequest()` | wolfSSL の SNI サポートが必要 |
| `mbedtls_ssl_conf_own_cert()` での不透明鍵またはセキュアエレメント内の鍵 | デバイス ID を指定した `wolfSSL_CTX_use_PrivateKey_Id()` / `wolfSSL_CTX_use_PrivateKey_Label()` | `--enable-cryptocb` または `--enable-pkcs11` が必要 |
| `mbedtls_ssl_get_verify_result()` | `wolfSSL_get_verify_result()` | `--enable-opensslextra` が必要。検証に失敗した場合はすでにハンドシェイクが失敗している。 |
| `mbedtls_ssl_get_peer_cert()` | `wolfSSL_get_peer_certificate()` | コピーを返すため、`wolfSSL_X509_free()` で解放する。`--enable-opensslextra` が必要。ない場合は `--enable-sessioncerts` を指定して `wolfSSL_get_peer_chain()` + `wolfSSL_get_chain_cert()` を使用。 |

## 接続と I/O

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_net_connect()`, `mbedtls_net_bind()`, `mbedtls_net_accept()` | アプリケーションのソケットコード | wolfSSL にはソケットのヘルパー API はない |
| `mbedtls_net_send()` / `mbedtls_net_recv()` を指定した `mbedtls_ssl_set_bio()` | `wolfSSL_set_fd()` | |
| カスタムコールバックを指定した `mbedtls_ssl_set_bio()` | `wolfSSL_CTX_SetIOSend()` / `wolfSSL_CTX_SetIORecv()` + `wolfSSL_SetIOWriteCtx()` / `wolfSSL_SetIOReadCtx()` | セッション単位では `wolfSSL_SSLSetIOSend()` / `wolfSSL_SSLSetIORecv()` |
| `mbedtls_ssl_handshake()` | `wolfSSL_connect()` / `wolfSSL_accept()` | クライアントとサーバーのどちらでも使える `wolfSSL_negotiate()` もある |
| `mbedtls_ssl_read()`, `mbedtls_ssl_write()` | `wolfSSL_read()`, `wolfSSL_write()` | |
| `mbedtls_ssl_get_bytes_avail()` | `wolfSSL_pending()` | |
| `mbedtls_ssl_close_notify()` | `wolfSSL_shutdown()` | |

## エラーとデバッグ

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| 戻り値として直接返される `MBEDTLS_ERR_SSL_WANT_READ` / `_WANT_WRITE` | `wolfSSL_get_error()` が `WOLFSSL_ERROR_WANT_READ` / `_WANT_WRITE` を返す | |
| カスタム受信コールバックから返す `MBEDTLS_ERR_SSL_WANT_READ` | `WOLFSSL_CBIO_ERR_WANT_READ` | [よくある落とし穴](chapter04.md)を参照 |
| `MBEDTLS_ERR_SSL_PEER_CLOSE_NOTIFY` | `WOLFSSL_ERROR_ZERO_RETURN` | |
| `MBEDTLS_ERR_SSL_RECEIVED_NEW_SESSION_TICKET` | 不要 | wolfSSL はチケットを内部で処理する |
| `mbedtls_strerror()` | `wolfSSL_ERR_error_string_n()`, `wc_GetErrorString()` | |
| `mbedtls_ssl_conf_dbg()` + `mbedtls_debug_set_threshold()` | `wolfSSL_SetLoggingCb()` + `wolfSSL_Debugging_ON()` | `--enable-debug` が必要 |

## セッション、PSK、拡張

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_ssl_get_session()` | `wolfSSL_get1_session()` | `wolfSSL_SESSION_free()` で解放する。`wolfSSL_get_session()` が返すポインタは `WOLFSSL` とともに解放される。 |
| `mbedtls_ssl_set_session()` | `wolfSSL_set_session()` | |
| `mbedtls_ssl_cache_*` + `mbedtls_ssl_conf_session_cache()` | wolfSSL がセッションキャッシュを自動で管理する | |
| `mbedtls_ssl_ticket_setup()` + `mbedtls_ssl_conf_session_tickets_cb()` | `--enable-session-ticket`、必要に応じて `wolfSSL_CTX_set_TicketEncCb()` | `mbedtls_ssl_ticket_setup()` は 4.x で引数が変更された |
| `mbedtls_ssl_conf_psk()` | `wolfSSL_CTX_set_psk_client_callback()` / `wolfSSL_CTX_set_psk_server_callback()` | TLS 1.3 用の wolfSSL の関数は、名前に `_tls13_` が付く |
| `mbedtls_ssl_conf_alpn_protocols()` + `mbedtls_ssl_get_alpn_protocol()` | `wolfSSL_UseALPN()` + `wolfSSL_ALPN_GetProtocol()` | `wolfSSL_UseALPN()` はセッション単位で設定し、カンマ区切りの文字列と、`WOLFSSL_ALPN_FAILED_ON_MISMATCH` または `WOLFSSL_ALPN_CONTINUE_ON_MISMATCH` を受け取る。4.x では Mbed TLS のリストの型が `const char *const *` に変更された。 |
| `mbedtls_ssl_conf_ciphersuites()` | `wolfSSL_CTX_set_cipher_list()` | `wolfSSL_CTX_set_cipher_list()` はコロン区切りの文字列を受け取る |
| `mbedtls_ssl_conf_groups()` | `wolfSSL_CTX_set_groups()` または `wolfSSL_set_groups()` | ClientHello で送信する鍵共有を選ぶには `wolfSSL_UseKeyShare()` を追加する。`wolfSSL_UseKeyShare()` 単独では、HelloRetryRequest でネゴシエートされうるグループは制限されない。 |
| `mbedtls_ssl_conf_max_frag_len()` | `wolfSSL_UseMaxFragment()` | |

## DTLS

| Mbed TLS | wolfSSL | 備考 |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_ssl_config_defaults()` での `MBEDTLS_SSL_TRANSPORT_DATAGRAM` | `wolfDTLS_client_method()`, `wolfDTLSv1_3_client_method()` および対応するサーバー用メソッド | |
| `mbedtls_ssl_set_timer_cb()` | `wolfSSL_dtls_get_current_timeout()` + `wolfSSL_dtls_got_timeout()` | これらの wolfSSL の関数は、ノンブロッキングソケットまたはカスタム受信コールバックを使う場合のみ必要。カスタム受信コールバックは、最大 `wolfSSL_dtls_get_current_timeout()` 秒まで待つようにする。 |
| `mbedtls_ssl_conf_handshake_timeout()` | `wolfSSL_dtls_set_timeout_init()` + `wolfSSL_dtls_set_timeout_max()` | これらの wolfSSL の関数はセッション単位で設定し、`wolfSSL_new()` の後に呼び出す。値はミリ秒ではなく秒単位で、`wolfSSL_dtls_set_timeout_init()` の値は `wolfSSL_dtls_set_timeout_max()` の値（デフォルト 64）を超えてはならない。 |
| `mbedtls_ssl_cookie_setup()` + `mbedtls_ssl_conf_dtls_cookies()` | wolfSSL が Cookie 交換を自動で処理する | |
| 共有の UDP ソケット 1 つでの Cookie 交換 | `wolfDTLS_accept_stateless()` | サーバー側 |
| `mbedtls_ssl_set_client_transport_id()` | `wolfSSL_dtls_set_peer()` | |
| `mbedtls_ssl_set_cid()` | `wolfSSL_dtls_cid_use()` + `wolfSSL_dtls_cid_set()` | `--enable-dtlscid` が必要 |
| `mbedtls_ssl_set_mtu()` | `wolfSSL_dtls_set_mtu()` | `--enable-dtls-mtu` が必要 |
