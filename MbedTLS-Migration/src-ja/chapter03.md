# TLS クライアントの移植

以下の 2 つの関数は、どちらも接続済みのソケット上で、CA ファイルを使ってサーバーを検証し、ホスト名を確認し、リクエストを送信して応答を読み取ります。
これらは Mbed TLS 4.1 と wolfSSL 5.9.4 でコンパイルし、それぞれ相手側ライブラリのテストサーバーに対して動作を確認しています。

## Mbed TLS 4.x

```c
#include <psa/crypto.h>
#include <mbedtls/ssl.h>
#include <mbedtls/net_sockets.h>
#include <mbedtls/x509_crt.h>

int tls_get(int fd, const char* host, const char* caFile)
{
    int ret;
    mbedtls_net_context net;
    mbedtls_ssl_context ssl;
    mbedtls_ssl_config conf;
    mbedtls_x509_crt ca;
    unsigned char buf[256];
    const char req[] = "GET / HTTP/1.0\r\n\r\n";

    mbedtls_net_init(&net);
    net.fd = fd;
    mbedtls_ssl_init(&ssl);
    mbedtls_ssl_config_init(&conf);
    mbedtls_x509_crt_init(&ca);

    ret = (int)psa_crypto_init(); /* 4.x: 証明書のパースより前に呼ぶ */
    if (ret != PSA_SUCCESS)
        goto out;
    if ((ret = mbedtls_x509_crt_parse_file(&ca, caFile)) != 0)
        goto out;
    if ((ret = mbedtls_ssl_config_defaults(&conf, MBEDTLS_SSL_IS_CLIENT,
            MBEDTLS_SSL_TRANSPORT_STREAM, MBEDTLS_SSL_PRESET_DEFAULT)) != 0)
        goto out;
    mbedtls_ssl_conf_ca_chain(&conf, &ca, NULL);
    /* 3.6 のみ: mbedtls_ssl_conf_rng(&conf, mbedtls_ctr_drbg_random, &drbg); */

    if ((ret = mbedtls_ssl_setup(&ssl, &conf)) != 0 ||
        (ret = mbedtls_ssl_set_hostname(&ssl, host)) != 0)
        goto out;
    mbedtls_ssl_set_bio(&ssl, &net, mbedtls_net_send, mbedtls_net_recv, NULL);

    while ((ret = mbedtls_ssl_handshake(&ssl)) != 0) {
        if (ret != MBEDTLS_ERR_SSL_WANT_READ &&
            ret != MBEDTLS_ERR_SSL_WANT_WRITE)
            goto out;
    }
    ret = mbedtls_ssl_write(&ssl, (const unsigned char*)req, sizeof(req) - 1);
    if (ret <= 0)
        goto out;
    do {
        ret = mbedtls_ssl_read(&ssl, buf, sizeof(buf) - 1);
    } while (ret == MBEDTLS_ERR_SSL_WANT_READ ||
             ret == MBEDTLS_ERR_SSL_RECEIVED_NEW_SESSION_TICKET);
    if (ret > 0)
        ret = 0;
    mbedtls_ssl_close_notify(&ssl);

out:
    mbedtls_ssl_free(&ssl);
    mbedtls_ssl_config_free(&conf);
    mbedtls_x509_crt_free(&ca);
    return ret;
}
```

## wolfSSL

```c
#include <wolfssl/options.h>
#include <wolfssl/ssl.h>
#include <string.h>

int tls_get(int fd, const char* host, const char* caFile)
{
    int ret = -1;
    WOLFSSL_CTX* ctx = NULL;
    WOLFSSL* ssl = NULL;
    char buf[256];
    const char req[] = "GET / HTTP/1.0\r\n\r\n";

    ctx = wolfSSL_CTX_new(wolfTLS_client_method()); /* TLS 1.2 または 1.3 */
    if (ctx == NULL)
        goto out;
    if (wolfSSL_CTX_load_verify_locations(ctx, caFile, NULL)
            != WOLFSSL_SUCCESS)
        goto out;
    wolfSSL_CTX_set_verify(ctx, WOLFSSL_VERIFY_PEER, NULL);

    ssl = wolfSSL_new(ctx);
    if (ssl == NULL)
        goto out;
    if (wolfSSL_UseSNI(ssl, WOLFSSL_SNI_HOST_NAME, host,
            (unsigned short)strlen(host)) != WOLFSSL_SUCCESS ||
        wolfSSL_check_domain_name(ssl, host) != WOLFSSL_SUCCESS ||
        wolfSSL_set_fd(ssl, fd) != WOLFSSL_SUCCESS)
        goto out;

    ret = wolfSSL_connect(ssl);
    if (ret != WOLFSSL_SUCCESS) {
        ret = wolfSSL_get_error(ssl, ret);
        goto out;
    }
    ret = wolfSSL_write(ssl, req, (int)sizeof(req) - 1);
    if (ret <= 0) {
        ret = wolfSSL_get_error(ssl, ret);
        goto out;
    }
    ret = wolfSSL_read(ssl, buf, (int)sizeof(buf) - 1);
    if (ret <= 0) {
        ret = wolfSSL_get_error(ssl, ret);
        goto out;
    }
    ret = 0;
    wolfSSL_shutdown(ssl);

out:
    wolfSSL_free(ssl);
    wolfSSL_CTX_free(ctx);
    return ret;
}
```

## 変更点

- RNG の設定と `psa_crypto_init()` は不要になります。
- `wolfSSL_CTX_load_verify_locations()` は 1 回の呼び出しで CA のパースと登録を行います。
  また、`wolfSSL_CTX_set_verify()` によってピア検証を明示的に指定します（[よくある落とし穴](chapter04.md)の「ピア検証は有効であり、有効のままにすべき」を参照）。
- ブロッキングソケットでは、`wolfSSL_connect()` がハンドシェイク全体を実行します。
  ノンブロッキングソケットでは、`wolfSSL_get_error()` が `WOLFSSL_ERROR_WANT_READ` または `WOLFSSL_ERROR_WANT_WRITE` を返す間、再度呼び出します。
- `wolfSSL_UseSNI()` には SNI サポートが必要です。
  `./configure` は x86 および aarch64 ホストでのみ SNI をデフォルトで有効にします。
  組み込みターゲットでは、`--enable-sni` を指定してビルドするか、`HAVE_SNI` を定義してください。
- 読み取りループも不要になります。
  4.0 以降の `mbedtls_ssl_read()` は、TLS 1.3 サーバーがチケットを送信するたびに `MBEDTLS_ERR_SSL_RECEIVED_NEW_SESSION_TICKET` を返しますが、wolfSSL はチケットを内部で処理します。

失敗時、wolfSSL 版の関数は `wolfSSL_get_error()` のコードを返します。
その中には、ピアが接続を閉じたときの `WOLFSSL_ERROR_ZERO_RETURN` のように正の値もあります。
戻り値は `< 0` ではなく `!= 0` で判定してください。

`wolfSSL_Init()` は起動時に 1 回、`wolfSSL_Cleanup()` は終了時に 1 回だけ呼び出してください。
`wolfSSL_Cleanup()` はセッションキャッシュも解放するため、接続ごとに呼び出さないでください。
