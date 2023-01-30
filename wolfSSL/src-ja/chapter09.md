

# ライブラリデザイン




## ライブラリヘッダー



wolfSSL 2.0.0 RC3のリリースにより、ライブラリヘッダーファイルは次の場所にあります。



* Wolfssl：`wolfssl/`


* wolfcrypt：`wolfssl/wolfcrypt/`


* wolfSSL OpenSSL互換レイヤー：`wolfssl/openssl/`



OpenSSL互換レイヤーを使用する場合([OpenSSL互換性](chapter13.md#openssl-compatibility)参照)、`/wolfssl/openssl/ssl.h`ヘッダーを含める必要があります。



```c
#include <wolfssl/openssl/ssl.h>
```



wolfSSLネイティブAPIのみを使用する場合は、`/wolfssl/ssl.h`ヘッダーのみを含める必要があります。



```c
#include <wolfssl/ssl.h>
```




## 起動と終了



すべてのアプリケーションは、ライブラリを使用する前に[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)を呼び出し、プログラム終了時に[`wolfSSL_Cleanup()`](group__TLS.md#function-wolfssl_cleanup)を呼び出す必要があります。現在、これらの機能は、マルチユーザーモードでセッションキャッシュの共有ミューテックスを初期化して解放しますが、将来的にはより多くのことをするかもしれないので、それらを使用することは常に良い考えです。



## 構造の使用



ヘッダーファイルの場所の変更に加えて、wolfSSL 2.0.0 RC3のリリースは、ネイティブのwolfSSL APIとwolfSSL OpenSSL互換層の間でより目に見える区別を作成しました。この区別により、ネイティブのwolfSSL APIによって使用される主なSSL/TLS構造は、名前が変更されました。新しい構造は次のとおりです。OpenSSL互換層を使用するときは、前の名前はまだ使用されます([OpenSSL互換性](chapter13.md#openssl-compatibility)参照)。



* `WOLFSSL`(以前のSSL)


* `WOLFSSL_CTX`(以前はSSL_CTX)


* `WOLFSSL_METHOD`(以前はssl_method)


* `WOLFSSL_SESSION`(以前はssl_session)


* `WOLFSSL_X509`(以前はx509)


* `WOLFSSL_X509_NAME`(以前x509_name)


* `WOLFSSL_X509_CHAIN`(以前はx509_chain)




## スレッドの安全性



wolfssl(以前のCyassl)は、設計によりスレッドセーフです。wolfSSL はグローバル データ、静的データ、およびオブジェクトの共有を回避するため、複数のスレッドが競合を発生させることなくライブラリに同時に入ることができます。ユーザーは、2つの領域で潜在的な問題を回避するように注意する必要があります。



1. クライアントは、複数のスレッドにわたってwolfSSLオブジェクトを共有することができますが、アクセスは同期する必要があります。すなわち、同じSSLポインタを持つ2つの異なるスレッドから同時にRead/Writeすることはできません。


wolfSSLは、共有できない関数に入ったときにより積極的な（制限的な）スタンスを取り、他のユーザーをロックアウトする可能性がありますが、このレベルの粒度は直感に反しているようです。すべてのユーザー(シングルスレッドでさえ)はロックの負荷を負担し、マルチスレッドはスレッド間でオブジェクトを共有していなくてもライブラリーに再入力できません。このペナルティは高すぎるように思われが、wolfSSLは共有オブジェクトを同期する責任をユーザーの手に委ねます。



2. wolfSSLのポインターを共有するだけでなく、ユーザーは[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)に渡す前に`WOLFSSL_CTX`を完全に初期化するように注意する必要があります。同じ`WOLFSSL_CTX`は複数の`WOLFSSL`構造体を作成できますが、`WOLFSSL_CTX`の作成中には[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)の作成中にのみ読み取られます(または`WOLFSSL_CTX`の将来の変化(または同時的な変化)`WOLFSSL`オブジェクトが作成されると、反映されません。

3. 一部の最適化では、スレッドごとにメモリが割り当てられます。 固定小数点 ECC キャッシュが有効になっている場合 (`FP_ECC`)、スレッドは、スレッドが終了する前に `wc_ecc_fp_free()` を使用してキャッシュされたバッファを解放する必要があります。

繰り返しになりますが、複数のスレッドは`WOLFSSL_CTX`への書き込みアクセスを同期させる必要があり、単一のスレッドが`WOLFSSL_CTX`を初期化して上述の同期および更新の問題を回避することをお勧めします。



## 入力および出力バッファー



wolfSSLは、入力と出力に動的バッファーを使用するようになりました。デフォルトは0バイトになり、`wolfssl/internal.h`で`RECORD_SIZE`定義によって制御されます。静的バッファーよりもサイズが大きい入力レコードを受信した場合、動的バッファーは一時的にリクエストを処理して解放されます。静的バッファーサイズを2^16または16,384の`MAX_RECORD_SIZE`に設定できます。


wolfsslが操作された前の方法を好む場合は、ダイナミックメモリを必要としない16kbの静的バッファを使用して、`LARGE_STATIC_BUFFERS`を定義することでそのオプションを取得できます。

動的バッファーが使用され、ユーザーがバッファサイズよりも大きい[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)を要求する場合、最大`MAX_RECORD_SIZE`までの動的ブロックを使用してデータを送信します。最大`RECORD_SIZE`サイズのチャンクでデータを送信したいユーザーは、`STATIC_CHUNKS_ONLY`を定義することでこれを行うことができます。これにより、wolfSSLは、デフォルトで128バイトの`RECORD_SIZE`まで成長するI/Oバッファーを使用します。
