# API Mapping

Mbed TLS names apply to 3.6 and 4.x unless the notes say otherwise. Two Mbed
TLS key exchanges have no wolfSSL equivalent: the EC J-PAKE cipher suites
(`MBEDTLS_KEY_EXCHANGE_ECJPAKE_ENABLED`) that OpenThread uses for Thread
commissioning, and the 3.6 RSA-PSK suites
(`MBEDTLS_KEY_EXCHANGE_RSA_PSK_ENABLED`).

## Setup and Teardown

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `psa_crypto_init()` | `wolfSSL_Init()` | Required in 4.x, and in 3.6 with `MBEDTLS_USE_PSA_CRYPTO`; `wolfSSL_CTX_new()` calls `wolfSSL_Init()` if needed |
| `mbedtls_ssl_config_init()` + `mbedtls_ssl_config_defaults()` | `wolfSSL_CTX_new(method)` | Role, transport and version come from the method |
| `mbedtls_ssl_conf_min_tls_version()` | `wolfSSL_CTX_SetMinVersion()` | Or a version-specific method such as `wolfTLSv1_3_client_method()` |
| `mbedtls_ssl_conf_rng()` | Not needed | 3.6 only, removed in 4.x |
| `mbedtls_ssl_init()` + `mbedtls_ssl_setup()` | `wolfSSL_new(ctx)` | |
| `mbedtls_ssl_session_reset()` | `wolfSSL_clear()` | |
| `mbedtls_ssl_free()`, `mbedtls_ssl_config_free()` | `wolfSSL_free()`, `wolfSSL_CTX_free()` | |
| `mbedtls_psa_crypto_free()` | `wolfSSL_Cleanup()` | |

## Certificates, Keys and Verification

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_x509_crt_parse_file()` + `mbedtls_ssl_conf_ca_chain()` | `wolfSSL_CTX_load_verify_locations()` | |
| `mbedtls_x509_crt_parse()` + `mbedtls_ssl_conf_ca_chain()` | `wolfSSL_CTX_load_verify_buffer()` | Same buffer and length as with Mbed TLS; pass the format explicitly |
| `mbedtls_x509_crt_parse_file()` + `mbedtls_pk_parse_keyfile()` + `mbedtls_ssl_conf_own_cert()` | `wolfSSL_CTX_use_certificate_chain_file()` + `wolfSSL_CTX_use_PrivateKey_file()` | PEM only; for a DER certificate use `wolfSSL_CTX_use_certificate_file()` with `WOLFSSL_FILETYPE_ASN1`. `mbedtls_pk_parse_keyfile()` takes RNG arguments in 3.6, none in 4.x |
| Buffer variants of the above | `wolfSSL_CTX_use_certificate_chain_buffer()` + `wolfSSL_CTX_use_PrivateKey_buffer()` | PEM only; for DER use `wolfSSL_CTX_use_certificate_buffer()` with `WOLFSSL_FILETYPE_ASN1` |
| `mbedtls_ssl_conf_authmode()` | `wolfSSL_CTX_set_verify()` | REQUIRED: `WOLFSSL_VERIFY_PEER` (plus `WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT` on a server). OPTIONAL: `WOLFSSL_VERIFY_PEER` with a callback that returns 1. NONE: `WOLFSSL_VERIFY_NONE` |
| `mbedtls_ssl_conf_verify()` | Callback argument of `wolfSSL_CTX_set_verify()` | The chain arrives as DER in `store->certs[]`; parse it with `wc_InitDecodedCert()` + `wc_ParseCert()`. `store->current_cert` needs `--enable-opensslextra`. By default the callback runs only for certificates that fail verification. `WOLFSSL_ALWAYS_VERIFY_CB` also runs it on success and `WOLFSSL_VERIFY_CB_ALL_CERTS` for every intermediate; `--enable-opensslextra` sets both |
| `mbedtls_ssl_set_hostname()` | `wolfSSL_UseSNI()` + `wolfSSL_check_domain_name()` | `wolfSSL_check_ip_address()` for IP addresses; see [Common Pitfalls](chapter04.md) |
| `mbedtls_ssl_conf_sni()` (server) | `wolfSSL_CTX_set_servername_callback()` + `wolfSSL_SNI_GetRequest()` | Needs SNI |
| Opaque or secure-element key in `mbedtls_ssl_conf_own_cert()` | `wolfSSL_CTX_use_PrivateKey_Id()` / `wolfSSL_CTX_use_PrivateKey_Label()` with a device ID | Needs `--enable-cryptocb` or `--enable-pkcs11` |
| `mbedtls_ssl_get_verify_result()` | `wolfSSL_get_verify_result()` | Needs `--enable-opensslextra`; a failed check already fails the handshake |
| `mbedtls_ssl_get_peer_cert()` | `wolfSSL_get_peer_certificate()` | Returns a copy; free it with `wolfSSL_X509_free()`. Needs `--enable-opensslextra`; without it, `wolfSSL_get_peer_chain()` + `wolfSSL_get_chain_cert()` with `--enable-sessioncerts` |

## Connection and I/O

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_net_connect()`, `mbedtls_net_bind()`, `mbedtls_net_accept()` | Your socket code | wolfSSL has no socket helper API |
| `mbedtls_ssl_set_bio()` with `mbedtls_net_send()` / `mbedtls_net_recv()` | `wolfSSL_set_fd()` | |
| `mbedtls_ssl_set_bio()` with custom callbacks | `wolfSSL_CTX_SetIOSend()` / `wolfSSL_CTX_SetIORecv()` + `wolfSSL_SetIOWriteCtx()` / `wolfSSL_SetIOReadCtx()` | Per session: `wolfSSL_SSLSetIOSend()` / `wolfSSL_SSLSetIORecv()` |
| `mbedtls_ssl_handshake()` | `wolfSSL_connect()` / `wolfSSL_accept()` | Or `wolfSSL_negotiate()` for either role |
| `mbedtls_ssl_read()`, `mbedtls_ssl_write()` | `wolfSSL_read()`, `wolfSSL_write()` | |
| `mbedtls_ssl_get_bytes_avail()` | `wolfSSL_pending()` | |
| `mbedtls_ssl_close_notify()` | `wolfSSL_shutdown()` | |

## Errors and Debugging

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `MBEDTLS_ERR_SSL_WANT_READ` / `_WANT_WRITE` returned directly | `wolfSSL_get_error()` returns `WOLFSSL_ERROR_WANT_READ` / `_WANT_WRITE` | |
| `MBEDTLS_ERR_SSL_WANT_READ` from a custom receive callback | `WOLFSSL_CBIO_ERR_WANT_READ` | See [Common Pitfalls](chapter04.md) |
| `MBEDTLS_ERR_SSL_PEER_CLOSE_NOTIFY` | `WOLFSSL_ERROR_ZERO_RETURN` | |
| `MBEDTLS_ERR_SSL_RECEIVED_NEW_SESSION_TICKET` | Not needed | Tickets are handled internally |
| `mbedtls_strerror()` | `wolfSSL_ERR_error_string_n()`, `wc_GetErrorString()` | |
| `mbedtls_ssl_conf_dbg()` + `mbedtls_debug_set_threshold()` | `wolfSSL_SetLoggingCb()` + `wolfSSL_Debugging_ON()` | Needs `--enable-debug` |

## Sessions, PSK and Extensions

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `mbedtls_ssl_get_session()` | `wolfSSL_get1_session()` | Free with `wolfSSL_SESSION_free()`; the pointer from `wolfSSL_get_session()` is freed with the `WOLFSSL` |
| `mbedtls_ssl_set_session()` | `wolfSSL_set_session()` | |
| `mbedtls_ssl_cache_*` + `mbedtls_ssl_conf_session_cache()` | Built-in session cache | |
| `mbedtls_ssl_ticket_setup()` + `mbedtls_ssl_conf_session_tickets_cb()` | `--enable-session-ticket`, optional `wolfSSL_CTX_set_TicketEncCb()` | `mbedtls_ssl_ticket_setup()` changed its arguments in 4.x |
| `mbedtls_ssl_conf_psk()` | `wolfSSL_CTX_set_psk_client_callback()` / `wolfSSL_CTX_set_psk_server_callback()` | TLS 1.3 variants add `_tls13_` |
| `mbedtls_ssl_conf_alpn_protocols()` + `mbedtls_ssl_get_alpn_protocol()` | `wolfSSL_UseALPN()` + `wolfSSL_ALPN_GetProtocol()` | Per session; takes a comma-separated string plus `WOLFSSL_ALPN_FAILED_ON_MISMATCH` or `WOLFSSL_ALPN_CONTINUE_ON_MISMATCH`. 4.x changed the Mbed TLS list type to `const char *const *` |
| `mbedtls_ssl_conf_ciphersuites()` | `wolfSSL_CTX_set_cipher_list()` | Takes a colon-separated string |
| `mbedtls_ssl_conf_groups()` | `wolfSSL_CTX_set_groups()` or `wolfSSL_set_groups()` | Add `wolfSSL_UseKeyShare()` to choose the key share sent in the ClientHello; on its own it does not restrict the groups a HelloRetryRequest can negotiate |
| `mbedtls_ssl_conf_max_frag_len()` | `wolfSSL_UseMaxFragment()` | |

## DTLS

| Mbed TLS | wolfSSL | Notes |
| ------------------------------------- | ------------------------------------- | -------------------------- |
| `MBEDTLS_SSL_TRANSPORT_DATAGRAM` in `mbedtls_ssl_config_defaults()` | `wolfDTLS_client_method()`, `wolfDTLSv1_3_client_method()` and server equivalents | |
| `mbedtls_ssl_set_timer_cb()` | `wolfSSL_dtls_get_current_timeout()` + `wolfSSL_dtls_got_timeout()` | Only needed with non-blocking sockets or a custom receive callback, which should wait at most `wolfSSL_dtls_get_current_timeout()` seconds |
| `mbedtls_ssl_conf_handshake_timeout()` | `wolfSSL_dtls_set_timeout_init()` + `wolfSSL_dtls_set_timeout_max()` | Per session: call after `wolfSSL_new()`. Values are seconds, not milliseconds, and init must not exceed max (default 64) |
| `mbedtls_ssl_cookie_setup()` + `mbedtls_ssl_conf_dtls_cookies()` | Built in | |
| Cookie exchange on one shared UDP socket | `wolfDTLS_accept_stateless()` | Server side |
| `mbedtls_ssl_set_client_transport_id()` | `wolfSSL_dtls_set_peer()` | |
| `mbedtls_ssl_set_cid()` | `wolfSSL_dtls_cid_use()` + `wolfSSL_dtls_cid_set()` | Needs `--enable-dtlscid` |
| `mbedtls_ssl_set_mtu()` | `wolfSSL_dtls_set_mtu()` | Needs `--enable-dtls-mtu` |
