# 設計上の違い

本章では、Mbed TLS と wolfSSL の構造を比較し、以降の章で扱う移植作業の全体像を示します。

| 項目 | Mbed TLS | wolfSSL |
| ------------------ | ----------------------------------------- | ----------------------------------------- |
| コンテキストモデル | `mbedtls_ssl_config` と `mbedtls_ssl_context` | `WOLFSSL_CTX` と `WOLFSSL` |
| プロトコルとロール | `mbedtls_ssl_config_defaults()` の引数 | `wolfSSL_CTX_new()` に渡すメソッド |
| 暗号 API | レガシー API（3.6）または PSA（4.x） | ネイティブの wolfCrypt `wc_*` API、wolfPSA による PSA（オプション） |
| 乱数生成器（RNG） | アプリケーションが接続（3.6）、PSA 内部で管理（4.x） | セッションごとに内部で生成・シード |
| 設定 | `mbedtls_config.h`, `crypto_config.h` | `./configure`、CMake または `user_settings.h` |
| 戻り値 | 成功時 0、エラー時は負の値 | TLS 関数は `WOLFSSL_SUCCESS`（1）、`wc_*` 関数は 0 |
| トランスポート | `mbedtls_ssl_set_bio()` のコールバック | `wolfSSL_set_fd()` または I/O コールバック |
| ハードウェアオフロード | `_ALT`（3.6）または PSA ドライバ（4.x） | 暗号コールバックとツリー内のポート |
| ライセンス | Apache-2.0 または GPL-2.0-or-later | GPLv3 または商用ライセンス |

## 設定用に 1 つ、接続ごとに 1 つのコンテキスト

`mbedtls_ssl_config` は `WOLFSSL_CTX` に、`mbedtls_ssl_context` は `WOLFSSL` に置き換わります。
エンドポイント、トランスポート、プリセットを `mbedtls_ssl_config_defaults()` に渡す代わりに、`wolfSSL_CTX_new()` にメソッドを渡します。
`wolfTLS_client_method()` は双方がサポートする最も高い TLS バージョンをネゴシエートし、`wolfDTLSv1_3_client_method()` は DTLS 1.3 を選択します。
`WOLFSSL_CTX` は一度だけ設定してスレッド間で共有し、接続ごとに `WOLFSSL` を 1 つ作成します。

## RNG の接続処理は不要

wolfSSL では、3.6 の CTR-DRBG の接続処理も、4.x の `psa_crypto_init()` の呼び出しも必要ありません。
各 `WOLFSSL` は、プラットフォームのエントロピー源から自身の RNG をシードします。
ベアメタル環境では、`CUSTOM_RAND_GENERATE_SEED` または `wc_GenerateSeed()` の移植によってエントロピー源を一度だけ提供します。
これは `MBEDTLS_ENTROPY_HARDWARE_ALT` や `MBEDTLS_PSA_DRIVER_GET_ENTROPY` に相当するもので、wolfSSL はその上で Hash_DRBG を動作させます。
wolfCrypt を直接呼び出す場合、乱数を必要とする関数は明示的に `WC_RNG*` を引数に取ります。

## メモリフットプリント

Mbed TLS は、`MBEDTLS_SSL_IN_CONTENT_LEN` と `MBEDTLS_SSL_OUT_CONTENT_LEN` で縮小しない限り、デフォルトで接続ごとに 16 KB の入力バッファと 16 KB の出力バッファを確保します。
wolfSSL は各レコードを実際のサイズで割り当て、処理が終わると解放するため、ピーク使用量は受信する最大のレコードに応じて決まります。
ただし、双方が Max Fragment Length に合意しない限り、最大で 16 KB になる点は同じです。
`malloc()` を持たないシステム向けには、`--enable-staticmemory` により、すべてのメモリ割り当てをアプリケーションが用意したプールから行えます。

wolfSSL のブログ記事 2 本で、両ライブラリを計測しています。
[TLS 1.3 in 30.8 KB](https://wolfssl.jp/wolfblog/2026/10/09/tls-1-3-in-30-8-kb-wolfssl-vs-mbedtls/) では、Cortex-M33 上で wolfSSL のフラッシュ使用量が 5% から 44% 小さいという結果が得られました。
また、[同一条件でのベンチマーク](https://wolfssl.jp/wolfblog/2026/07/09/wolfssl-vs-mbedtls-an-apples-to-apples-benchmark-across-intel-arm-cortex-a-and-cortex-m-and-risc-v-targets/)では、Intel、ARM、RISC-V 上で wolfCrypt の公開鍵演算が数倍高速であることが確認されています。

## ライセンス

Mbed TLS は Apache-2.0 と GPL-2.0-or-later のデュアルライセンスです。
Apache-2.0 では、著作権表示などの要件を満たすだけでクローズドソースのファームウェアを出荷できます。
wolfSSL は GPLv3 と商用ライセンスのデュアルライセンスのため、クローズドソースのファームウェアでは、事実上、商用ライセンスが必要になります。
GPLv3 で回避できるケースはほとんどありません。
GPLv3 は、コンシューマ向け機器ではユーザーが改変したソフトウェアをインストールできることも求めますが、ロックダウンされたファームウェアでは通常それを許容できないためです。
エンジニアリング作業を始める前にライセンスの問題を解決できるよう、早めに wolfSSL までご相談ください。
