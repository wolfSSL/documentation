# Common Pitfalls

These are the issues seen most often when porting from Mbed TLS. Most of them
compile fine and fail at runtime.

## Host Name Checks Need Their Own Call

`mbedtls_ssl_set_hostname()` sends SNI and checks the server certificate
against the name. In wolfSSL, `wolfSSL_UseSNI()` only sends the extension and
`wolfSSL_check_domain_name()` enables the name check, so call both, as the
sample in [Porting a TLS Client](chapter03.md) does. Without the second call,
any certificate from a trusted CA is accepted for any host, a check Mbed TLS
3.6.3 and later enforce. Since wolfSSL 5.9.2, `wolfSSL_check_domain_name()`
accepts only fully qualified names and `localhost`, and returns
`WOLFSSL_FAILURE` for a single-label name such as `gateway` or an IP address,
where `mbedtls_ssl_set_hostname()` takes any name; use the fully qualified
name. For IP addresses, call `wolfSSL_check_ip_address()` and build with
`--enable-ip-alt-name`, or the handshake fails with `IPADDR_MISMATCH`.

## Success Is 1, Not 0

Most `wolfSSL_*` configuration and handshake calls return `WOLFSSL_SUCCESS`,
which is 1. Code ported with `if (ret != 0)` checks will treat every success as
an error, or worse, every failure (`WOLFSSL_FAILURE` is 0) as success.
wolfCrypt's `wc_*` functions follow the Mbed TLS convention of 0 on success.
`wolfSSL_read()` and `wolfSSL_write()` return a byte count, and on failure
`wolfSSL_get_error(ssl, ret)` tells you why.

## Build the Library and the Application with the Same Defines

Many wolfSSL structures change size with the feature set, so a mismatch
between library and application compiles, links and then corrupts memory.
Include `<wolfssl/options.h>` before any other wolfSSL header, or with
`user_settings.h`, define `WOLFSSL_USER_SETTINGS` for both and share one copy
of the file.

## Defaults Differ

A default `./configure` build is lean. Several features Mbed TLS enables by
default need an explicit option, among them SNI on embedded targets,
Curve25519, ALPN, session tickets, DTLS, DTLS Connection ID, PSK, AES-CCM (for
the CoAP and LwM2M `_CCM_8` suites) and Max Fragment Length. If a call returns
`NOT_COMPILED_IN` or does not exist, [Configuration Equivalents](chapter09.md)
has the option.

## Peer Verification Is On, and Should Stay On

In a default build, a wolfSSL client verifies the server, like Mbed TLS.
Builds with OpenSSL-compatible defaults, such as `--enable-all` or
`--enable-nginx`, start with `WOLFSSL_VERIFY_NONE` instead, so call
`wolfSSL_CTX_set_verify(ctx, WOLFSSL_VERIFY_PEER, NULL)` in every client. If
the CA is missing, the handshake fails with `ASN_NO_SIGNER_E` (-188); load the
right CA rather than turning verification off. On a server, add
`WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT` to match `MBEDTLS_SSL_VERIFY_REQUIRED`.
For `MBEDTLS_SSL_VERIFY_OPTIONAL`, use a verify callback that records the
error and returns 1.

## Custom I/O Callbacks Use Different Return Codes

Custom transport callbacks port almost one to one, with the signature
`int recv(WOLFSSL* ssl, char* buf, int sz, void* ctx)` and the matching send.
Return `WOLFSSL_CBIO_ERR_WANT_READ` or `WOLFSSL_CBIO_ERR_WANT_WRITE` instead of
the Mbed TLS codes, `WOLFSSL_CBIO_ERR_CONN_CLOSE` when the peer closed the
connection, and, for DTLS, `WOLFSSL_CBIO_ERR_TIMEOUT` when a timer expires.
wolfSSL treats an Mbed TLS code as a fatal error.

## PEM and DER Buffers

Mbed TLS expects a PEM buffer's length to include the terminating NUL byte.
The wolfSSL `*_buffer()` functions accept that length as well, so your buffers
work unchanged. The difference is the format: Mbed TLS detects PEM or DER from
the content, while wolfSSL takes `WOLFSSL_FILETYPE_PEM` or
`WOLFSSL_FILETYPE_ASN1` as an argument, and a DER buffer passed as PEM fails
with `ASN_NO_PEM_HEADER` (-162).

## Certificate Dates on Boards Without a Clock

Mbed TLS built without `MBEDTLS_HAVE_TIME_DATE` silently skips the validity
period check. wolfSSL always checks it, so a board with no clock fails the
handshake with `ASN_BEFORE_DATE_E` or `ASN_AFTER_DATE_E`. Provide the time with
`USER_TIME` or `TIME_OVERRIDES` (`XTIME()`), or define `NO_ASN_TIME` to skip the
check knowingly. `NO_ASN_TIME` also disables the session cache and session
tickets, so session resumption is gone too.
