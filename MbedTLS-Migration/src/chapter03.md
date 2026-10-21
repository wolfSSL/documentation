# Porting a TLS Client

Both functions below verify the server against a CA file, check its host name,
send a request and read the reply over an already connected socket. They were
compiled against Mbed TLS 4.1 and wolfSSL 5.9.4, and each was run against the
other library's test server.

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

    ret = (int)psa_crypto_init(); /* 4.x: before any parsing */
    if (ret != PSA_SUCCESS)
        goto out;
    if ((ret = mbedtls_x509_crt_parse_file(&ca, caFile)) != 0)
        goto out;
    if ((ret = mbedtls_ssl_config_defaults(&conf, MBEDTLS_SSL_IS_CLIENT,
            MBEDTLS_SSL_TRANSPORT_STREAM, MBEDTLS_SSL_PRESET_DEFAULT)) != 0)
        goto out;
    mbedtls_ssl_conf_ca_chain(&conf, &ca, NULL);
    /* 3.6 only: mbedtls_ssl_conf_rng(&conf, mbedtls_ctr_drbg_random, &drbg); */

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

    ctx = wolfSSL_CTX_new(wolfTLS_client_method()); /* TLS 1.2 or 1.3 */
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

## What Changed

- The RNG setup and `psa_crypto_init()` are gone.
- `wolfSSL_CTX_load_verify_locations()` parses and installs the CA in one call,
  and `wolfSSL_CTX_set_verify()` makes peer verification explicit (see
  "Peer Verification Is On, and Should Stay On" in
  [Common Pitfalls](chapter04.md)).
- `wolfSSL_connect()` drives the whole handshake on a blocking socket. With a
  non-blocking one, call it again while `wolfSSL_get_error()` returns
  `WOLFSSL_ERROR_WANT_READ` or `WOLFSSL_ERROR_WANT_WRITE`.
- `wolfSSL_UseSNI()` needs SNI support, which `./configure` enables by
  default only on x86 and aarch64 hosts. On embedded targets, build with
  `--enable-sni` or define `HAVE_SNI`.
- The read loop is gone too. Since 4.0, `mbedtls_ssl_read()` returns
  `MBEDTLS_ERR_SSL_RECEIVED_NEW_SESSION_TICKET` whenever a TLS 1.3 server sends
  a ticket, while wolfSSL handles tickets internally.

On failure the wolfSSL version returns a `wolfSSL_get_error()` code, and some
of those are positive, such as `WOLFSSL_ERROR_ZERO_RETURN` when the peer closed
the connection. Check the result with `!= 0` rather than `< 0`.

Call `wolfSSL_Init()` once at startup and `wolfSSL_Cleanup()` once at shutdown,
not around each connection, because `wolfSSL_Cleanup()` also frees the session
cache.
