# ライブラリデザイン

## ライブラリヘッダー

wolfSSL 2.0.0 RC3以降のリリースでは、ライブラリヘッダファイルを以下の場所に配置しています。

* wolfSSL: `wolfssl/`
* wolfCrypt: `wolfssl/wolfcrypt/`
* wolfSSL OpenSSL互換レイヤー: `wolfssl/openssl/`

OpenSSL互換レイヤーを使用する場合、`/wolfssl/openssl/ssl.h`ヘッダーをインクルードする必要があります。
[第13章 OpenSSL互換性](chapter13.md)も併せてご参照ください。

```c
#include <wolfssl/openssl/ssl.h>
```

wolfSSLネイティブAPIのみを使用する場合は、`/wolfssl/ssl.h`ヘッダーのみをインクルードする必要があります。

```c
#include <wolfssl/ssl.h>
```

アプリケーションとライブラリの間で有効な機能や構造体のレイアウトを一致させるため、アプリケーションは他のどのwolfSSLヘッダーよりも先にwolfSSLのビルド構成をインクルードする必要があります。
`./configure`によるビルドの場合は、最初に`wolfssl/options.h`をインクルードするか、`settings.h`がそれを自動的にインクルードするように`WOLFSSL_USE_OPTIONS_H`を定義します。

```c
#include <wolfssl/options.h>
#include <wolfssl/ssl.h>
```

`user_settings.h`で構成したビルドの場合は、`settings.h`が`user_settings.h`をインクルードするように、アプリケーションのコンパイル時に[`WOLFSSL_USER_SETTINGS`](chapter02.md#wolfssl_user_settings)を定義します。
構成が検出されない場合、`settings.h`は警告「No configuration for wolfSSL detected, check header order」を出力します。

## 起動と終了

すべてのアプリケーションは、ライブラリを使用する前に[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)、プログラム終了時に[`wolfSSL_Cleanup()`](group__TLS.md#function-wolfssl_cleanup)を呼び出す必要があります。
`wolfSSL_Init()`は参照カウント方式です。
最初の呼び出しで、wolfCrypt（`wolfCrypt_Init()`）、グローバルなRNGおよびRANDのミューテックス、セッションキャッシュのロック、その他のグローバルな状態を初期化します。
成功した`wolfSSL_Init()`の呼び出し1回ごとに、`wolfSSL_Cleanup()`を1回呼び出してください。
wolfCryptのみを使用するアプリケーションは、代わりに`wolfCrypt_Init()`と`wolfCrypt_Cleanup()`を呼び出す必要があります。

## 構造体の使用

wolfSSL 2.0.0 RC3リリースではヘッダーファイルの場所の変更に加え、wolfSSLのネイティブAPIとOpenSSL互換レイヤーをより明確に区別するようにしました。
これに伴い、wolfSSLのネイティブAPIで使用されるSSL/TLS構造体の名前を変更しています。
新しい構造体は以下の通りです。
なおOpenSSL互換レイヤーを使用する場合は、引き続き旧称を使用します。
詳細は [第13章 OpenSSL互換性](chapter13.md) をご参照ください。

* `WOLFSSL`         （旧称：SSL）
* `WOLFSSL_CTX`     （旧称：SSL_CTX）
* `WOLFSSL_METHOD`      （旧称：SSL_METHOD）
* `WOLFSSL_SESSION` （旧称：SSL_SESSION）
* `WOLFSSL_X509`        （旧称：X509）
* `WOLFSSL_X509_NAME`   （旧称：X509_NAME）
* `WOLFSSL_X509_CHAIN`  （旧称：X509_CHAIN）

## スレッドセーフ

wolfSSL（旧称CyaSSL）はスレッドセーフとなるよう設計しています。
グローバルデータ、静的データ、オブジェクトの共有を避けているため、複数のスレッドが競合せず同時にライブラリに入ることができます。
ただし、ユーザーはいくつかの領域で潜在的な問題を避けるよう注意する必要があります。

1. クライアントは複数のスレッド間で`WOLFSSL`オブジェクトを共有できますが、アクセスは同期する必要があります。つまり、同じSSLポインタを持つ2つの異なるスレッドから同時にRead/Writeすることはできません。あるスレッドで読み取り、別のスレッドで書き込みを行うには、wolfSSLを`--enable-writedup`を指定してビルドし、`wolfSSL_write_dup()`を使用して書き込み専用の`WOLFSSL`オブジェクトを作成します。

    wolfSSLは、共有できない関数に入ったときに他のユーザーをロックアウトするという、より積極的（制約的）な姿勢をとることもできますが、このレベルの粒度は直感に反するように思われます。
    すべてのユーザー（シングルスレッドのユーザーでさえ）はロックの負荷を負担することになり、マルチスレッドユーザーはスレッド間でオブジェクトを共有していなくてもライブラリに再入できなくなります。
    このペナルティはあまりにも大きいと考えられるため、wolfSSLは共有オブジェクトを同期する責任をユーザーに委ねています。

2. `WOLFSSL`ポインタの共有に加えて、ユーザーは構造体を[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)に渡す前に`WOLFSSL_CTX`を完全に初期化する必要があります。同じ`WOLFSSL_CTX`で複数の`WOLFSSL`構造体を作成できます。多くの設定は[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)によって`WOLFSSL`オブジェクトにコピーされますが、オブジェクトは自身の`WOLFSSL_CTX`への参照も保持しており、一部の項目（例えば証明書マネージャー（信頼するCA、CRL、OCSP）や公開鍵コールバック）は使用時にそこから読み取ります。そのため、`wolfSSL_new()`の後の（または同時の）`WOLFSSL_CTX`への変更は既存のオブジェクトに影響する可能性があります。他のスレッドが使用している間は`WOLFSSL_CTX`を変更しないでください。

    繰り返しになりますが、複数のスレッドは`WOLFSSL_CTX`への書き込みアクセスを同期させるべきであり、上記の同期と更新の問題を避けるために、単一のスレッドが`WOLFSSL_CTX`を初期化することをお勧めします。

3. 一部の最適化では、スレッドごとにメモリが割り当てられます。固定小数点ECCキャッシュが有効になっている場合（`FP_ECC`）、スレッドはスレッド終了前に`wc_ecc_fp_free()`を使用してキャッシュされたバッファを解放する必要があります。

## 入力と出力バッファ

wolfSSLは、入力と出力に動的バッファを使用しています。
静的な入力バッファと出力バッファのデフォルトサイズは`RECORD_HEADER_SZ`（5バイト）で、`wolfssl/internal.h`の[`STATIC_BUFFER_LEN`](chapter02.md#static_buffer_len)と[`LARGE_STATIC_BUFFERS`](chapter02.md#large_static_buffers)の定義によって制御されます。
静的バッファよりも大きな入力レコードを受信した場合、一時的に動的バッファが使用され、その後解放されます。
最大レコードサイズ`MAX_RECORD_SIZE`は2^14（16,384）です。

以前のwolfSSLの動作方法（動的メモリを必要としない16 KBの静的バッファ）を希望する場合は、`LARGE_STATIC_BUFFERS`を定義することで、その動作を引き続き使用できます。
`WOLFSSL_CALLBACKS`を定義した場合も、`LARGE_STATIC_BUFFERS`が有効になります。

動的バッファが使用され、ユーザーがバッファサイズより大きい[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)をリクエストした場合、`MAX_RECORD_SIZE`までの動的ブロックがデータを送信するために使用されます。
データを最大で`RECORD_SIZE`サイズのチャンクでのみ送信したいユーザーは、`STATIC_CHUNKS_ONLY`を定義してください。
これにより、wolfSSLは`RECORD_SIZE`まで拡大するI/Oバッファを使用するようになります。
`RECORD_SIZE`はデフォルトで128バイトです（DTLSが有効な場合は`MAX_MTU`、`LARGE_STATIC_BUFFERS`を定義した場合は`MAX_RECORD_SIZE`）。
ユーザーが指定する`RECORD_SIZE`は128から`MAX_RECORD_SIZE`の範囲でなければならず、範囲外の場合はビルドが失敗します。
