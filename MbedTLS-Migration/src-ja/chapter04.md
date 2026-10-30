# よくある落とし穴

ここでは、Mbed TLS から移植する際に最もよく見られる問題を紹介します。
その多くは、コンパイルは通るものの実行時に失敗するものです。

## ホスト名の検証には専用の呼び出しが必要

`mbedtls_ssl_set_hostname()` は、SNI の送信とサーバー証明書のホスト名の検証を両方行います。
wolfSSL ではこの 2 つが別々の関数に分かれており、`wolfSSL_UseSNI()` は SNI 拡張を送信するだけで、ホスト名の検証は `wolfSSL_check_domain_name()` を呼び出したときにだけ有効になります。
そのため、[TLS クライアントの移植](chapter03.md)のサンプルのように、両方を呼び出してください。
`wolfSSL_check_domain_name()` を呼び出さないと、ホスト名は検証されず、信頼された CA が発行した証明書であれば、別のホスト向けの証明書でも受け入れてしまいます。
Mbed TLS 3.6.3 以降では、このホスト名の検証を省略するとハンドシェイクが失敗するため、移植時に呼び出しを忘れると、Mbed TLS では保証されていた検証が失われます。

wolfSSL 5.9.2 以降、`wolfSSL_check_domain_name()` は完全修飾ドメイン名（FQDN）と `localhost` のみを受け付け、`gateway` のような単一ラベルの名前や IP アドレスに対しては `WOLFSSL_FAILURE` を返します。
一方、`mbedtls_ssl_set_hostname()` は任意の名前を受け付けるため、完全修飾名を使用してください。
IP アドレスの場合は `wolfSSL_check_ip_address()` を呼び出し、`--enable-ip-alt-name` を指定してビルドしてください。
そうしないと、ハンドシェイクが `IPADDR_MISMATCH` で失敗します。

## 成功は 0 ではなく 1

`wolfSSL_*` の設定関数やハンドシェイク関数の多くは、成功時に `WOLFSSL_SUCCESS`（値は 1）を返します。
`if (ret != 0)` のチェックのまま移植したコードは、すべての成功をエラーとして扱ってしまいます。
さらに悪いことに、すべての失敗（`WOLFSSL_FAILURE` は 0）を成功として扱ってしまいます。
wolfCrypt の `wc_*` 関数は、Mbed TLS と同じく成功時に 0 を返す規約に従います。
`wolfSSL_read()` と `wolfSSL_write()` はバイト数を返し、失敗時は `wolfSSL_get_error(ssl, ret)` で原因を取得できます。

## ライブラリとアプリケーションは同じ定義でビルドする

wolfSSL の多くの構造体は、有効にする機能によってサイズが変わります。
そのため、ライブラリとアプリケーションで定義が一致しないと、コンパイルとリンクは成功しても実行時にメモリを破壊します。
他のどの wolfSSL ヘッダーよりも先に `<wolfssl/options.h>` をインクルードしてください。
`user_settings.h` を使う場合は、ライブラリとアプリケーションの両方で `WOLFSSL_USER_SETTINGS` を定義し、同じファイルを共有してください。

## デフォルト設定が異なる

デフォルトの `./configure` ビルドは最小限の構成です。
Mbed TLS がデフォルトで有効にしている機能のいくつかは、wolfSSL では明示的なオプション指定が必要です。
たとえば、組み込みターゲットでの SNI、Curve25519、ALPN、セッションチケット、DTLS、DTLS Connection ID、PSK、AES-CCM（CoAP や LwM2M の `_CCM_8` 暗号スイート用）、Max Fragment Length などです。
関数が `NOT_COMPILED_IN` を返したり、関数自体が存在しない場合は、[設定オプションの対応](chapter09.md)で該当するオプションを確認してください。

## ピア検証は有効であり、有効のままにすべき

デフォルトのビルドでは、wolfSSL クライアントは Mbed TLS と同様にサーバーを検証します。
ただし、`--enable-all` や `--enable-nginx` のような OpenSSL 互換のデフォルトを持つビルドでは、`WOLFSSL_VERIFY_NONE` で開始します。
そのため、すべてのクライアントで `wolfSSL_CTX_set_verify(ctx, WOLFSSL_VERIFY_PEER, NULL)` を呼び出してください。
CA が見つからない場合、ハンドシェイクは `ASN_NO_SIGNER_E`（-188）で失敗します。
検証を無効にするのではなく、正しい CA を読み込んでください。
サーバー側で `MBEDTLS_SSL_VERIFY_REQUIRED` と同じ動作にするには、`WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT` を追加します。
`MBEDTLS_SSL_VERIFY_OPTIONAL` に相当する動作にするには、エラーを記録して 1 を返す検証コールバックを使用します。

## カスタム I/O コールバックの戻り値が異なる

カスタムトランスポートのコールバックは、ほぼ 1 対 1 で移植できます。
シグネチャは `int recv(WOLFSSL* ssl, char* buf, int sz, void* ctx)` で、送信側も同様です。
Mbed TLS のコードの代わりに `WOLFSSL_CBIO_ERR_WANT_READ` または `WOLFSSL_CBIO_ERR_WANT_WRITE` を返し、ピアが接続を閉じた場合は `WOLFSSL_CBIO_ERR_CONN_CLOSE` を、DTLS でタイマーが満了した場合は `WOLFSSL_CBIO_ERR_TIMEOUT` を返してください。
wolfSSL は Mbed TLS のエラーコードを認識しないため、たとえば `MBEDTLS_ERR_SSL_WANT_READ` を返すと、再試行すべき状態ではなく致命的なエラーとして扱い、接続を終了します。

## PEM と DER のバッファ

Mbed TLS では、PEM バッファの長さに終端の NUL バイトを含める必要があります。
wolfSSL の `*_buffer()` 関数もその長さを受け付けるため、既存のバッファはそのまま使えます。
違いはフォーマットの指定方法です。
Mbed TLS は内容から PEM か DER かを判別しますが、wolfSSL は引数として `WOLFSSL_FILETYPE_PEM` または `WOLFSSL_FILETYPE_ASN1` を受け取ります。
DER のバッファを PEM として渡すと `ASN_NO_PEM_HEADER`（-162）で失敗します。

## 時計を持たないボードでの証明書の有効期間

`MBEDTLS_HAVE_TIME_DATE` なしでビルドした Mbed TLS は、有効期間のチェックを黙ってスキップします。
wolfSSL は常にこのチェックを行うため、時計を持たないボードではハンドシェイクが `ASN_BEFORE_DATE_E` または `ASN_AFTER_DATE_E` で失敗します。
`USER_TIME` または `TIME_OVERRIDES`（`XTIME()`）で時刻を提供するか、意図的にチェックを省略する場合は `NO_ASN_TIME` を定義してください。
`NO_ASN_TIME` はセッションキャッシュとセッションチケットも無効にするため、セッション再開も使えなくなります。
