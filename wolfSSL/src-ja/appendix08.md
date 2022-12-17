# wolfSSL 移植ガイド

## 目的

このガイドは、wolfSSL 軽量 SSL/TLS ライブラリを新しい組み込みプラットフォーム、オペレーティング システム、またはトランスポート メディア (TCP/IP、Bluetooth など) に移植する開発者およびエンジニア向けのリファレンスを提供します。 これは、wolfSSL を移植する際に通常変更が必要な wolfSSL コードベースの領域を呼び出します。 これは「ガイド」と見なされるべきであり、そのため、進化する作業です。 不足しているものがある場合はお知らせください。ドキュメントに指示や説明を追加させていただきます。

## 対象読者

このガイドは、デフォルトでサポートされていない新しいプラットフォームまたは環境に wolfSSL および wolfCrypt を移植する開発者またはエンジニアを対象としています。


## 序章

組み込みプラットフォームで wolfSSL を実行するには、いくつかの手順を繰り返す必要があります。 これらの手順の一部は、[セクション 2.4](chapter02.md#非標準環境での構築) で概説されています。

wolfSSL マニュアルの第 2 章の手順とは別に、特定のプラットフォームに対応するために移植または変更が必要なコードの領域があります。 wolfSSL はこれらの領域の多くを抽象化しており、wolfSSL を新しいプラットフォームに移植することをできるだけ簡単にしようとしています。

`./wolfssl/wolfcrypt/settings.h` ファイルには、さまざまなオペレーティング システム、TCP/IP スタック、およびチップセットに固有の定義がいくつかあります (例: MBED、FREESCALE_MQX、MICROCHIP_PIC32、MICRIUM、EBSNET など)。 wolfSSL をコンパイルして新しいプラットフォームに移植するときに、`#defines` を配置する主な場所が 2 つあります。

1. 通常、オペレーティング システムまたは TCP/IP スタック ポートの新しい定義は、wolfSSL の新しいポートが完成したときに `settings.h` ファイルに追加されます。 これにより、機能をオン/オフしたり、そのビルドの「デフォルト」にする必要があるビルド設定をカスタマイズしたりする簡単な方法が提供されます。 wolfSSL を新しいプラットフォームに移植する際に、このファイルに新しいカスタム定義を追加できます。 [GitHub](https://www.github.com/wolfssl/wolfssl) のマスター オープン ソース コード ブランチに wolfSSL のポートを提供することをお勧めします。 これにより、wolfSSL を最新の状態に保つことができ、wolfSSL プロジェクトが改善され前進するにつれて、さまざまなポートを最新の状態に保つことができます。

2. 自分の変更を適切な wolfSSL に戻したくないユーザー、または追加のプリプロセッサー定義で wolfSSL ビルドをカスタマイズしたいユーザーの場合、wolfSSL はカスタム `user_settings.h` ヘッダー ファイルの使用を推奨します。 wolfSSL ソース ファイルをコンパイルするときに「WOLFSSL_USER_SETTINGS」が定義されている場合、wolfSSL は「user_settings.h」と呼ばれるカスタム ヘッダー ファイルを自動的にインクルードします。 このヘッダーはユーザーが作成し、インクルード パスに配置する必要があります。 これにより、ユーザーは自分の wolfSSL ビルド用に 1 つのファイルを維持でき、新しいバージョンの wolfSSL への更新がはるかに簡単になります。

wolfSSL は、直接メール ([facts@wolfssl.com](mailto:facts@wolfssl.com)) または [GitHub プル リクエスト](https://github.com/wolfssl/ wolfssl)。


## wolfSSLの移植


### データ型

**Q: どんな場合にこのセクションが必要ですか?**

A: プラットフォームに適したデータ型のサイズを設定することは常に重要です。

wolfSSL は、64 ビット タイプを使用できるため、速度が向上します。 プラットフォームの sizeof(long) と sizeof(long long) の結果と一致するように SIZEOF_LONG と SIZEOF_LONG_LONG を定義します。 これは、`settings.h` ファイルまたは `user_settings.h` のカスタム定義に追加できます。 たとえば、`MY_NEW_PLATFORM` のサンプル定義の下にある `settings.h` では:


```c
#ifdef MY_NEW_PLATFORM
#定義 SIZEOF_LONG 4
#定義 SIZEOF_LONG_LONG 8
...
#endif
```


`word32` と `word16` と呼ばれる、wolfSSL と wolfCrypt で使用される 2 つの追加のデータ型があります。 これらのデフォルトのタイプ マッピングは次のとおりです。


```c
#ifndef WOLFSSL_TYPES
#ifndef バイト
     typedef unsigned char バイト。
#endif
typedef unsigned short word16;
     typedef unsigned int word32;
     typedef バイト word24[3];
#endif
```


「word32」はコンパイラの 32 ビット型に、「word16」はコンパイラの 16 ビット型にマップする必要があります。 これらのデフォルトのマッピングがお使いのプラットフォームで正しくない場合は、`settings.h` または `user_settings.h` で `WOLFSSL_TYPES` を定義し、word32 と word16 に独自のカスタム typedef を割り当てる必要があります。

wolfSSL の fastmath ライブラリは、`fp_digit` および `fp_word` タイプを使用します。 デフォルトでは、これらはビルド構成に応じて `<wolfssl/wolfcrypt/tfm.h>` にマッピングされます。

`fp_word` は `fp_digit` の 2 倍のサイズにする必要があります。 デフォルトのケースがプラットフォームに当てはまらない場合は、`settings.h` または `user_settings.h` で `WOLFSSL_BIGINT_TYPES` を定義し、`fp_word` と `fp_digit` に独自のカスタム typedef を割り当てる必要があります。

一部の操作で利用可能な場合、wolfSSL は 64 ビット型を使用します。 wolfSSL ビルドは、`SIZEOF_LONG` と `SIZEOF_LONG_LONG` の設定に基づいて、`word64` の正しい基本データ型を検出して設定しようとします。 2 つの 32 ビット型が一緒に使用される、真の 64 ビット型を持たない一部のプラットフォームでは、パフォーマンスが低下する可能性があります。 64 ビット型の使用をコンパイルするには、「NO_64BIT」を定義します。


### エンディアン

**Q: どんな場合にこのセクションが必要ですか?**

A: あなたのプラットフォームがビッグ エンディアンの場合です。

プラットフォームはビッグ エンディアンですか、それともリトル エンディアンですか? wolfSSL のデフォルトはリトル エンディアン システムです。 システムがビッグ エンディアンの場合、wolfSSL をビルドするときに `BIG_ENDIAN_ORDER` を定義します。 `settings.h` でこれを設定する例:


```c
#ifdef MY_NEW_PLATFORM
...
#BIG_ENDIAN_ORDER を定義
...
#endif
```



### writev


**Q: どんな場合にこのセクションが必要ですか?**

A: `<sys/uio.h>` は利用できない場合です。

デフォルトでは、wolfSSL API は、`writev()` セマンティクスをシミュレートする `wolfSSL_writev()` をアプリケーションで利用できるようにします。 `<sys/uio.h>` ヘッダーが利用できないシステムでは、`NO_WRITEV` を定義してこの機能を除外します。


＃＃＃ 入出力

**Q: どんな場合にこのセクションが必要ですか?**

A: BSD スタイルのソケット API は利用できない場合、カスタム トランスポート層または TCP/IP スタックを使用しているか、静的バッファのみを使用したい場合です。

wolfSSL はデフォルトで BSD スタイルのソケット インターフェイスを使用します。 トランスポート層が BSD ソケット インターフェイスを提供する場合、カスタム ヘッダーが必要でない限り、wolfSSL はそのまま統合する必要があります。

wolfSSL はカスタム I/O 抽象化レイヤーを提供し、ユーザーは自分のシステムに合わせて wolfSSL の I/O 機能を調整できます。 詳細は [セクション 5.1.2 にあります](chapter05.md#custom-inputoutput-abstraction-layer)。

簡単に言えば、`WOLFSSL_USER_IO` を定義してから、wolfSSL のデフォルトの `EmbedSend()` と `EmbedReceive()` をテンプレートとして使用して、独自の I/O コールバック関数を書くことができます。 これら 2 つの関数は `./src/io.c` にあります。

wolfSSL は入力と出力に動的バッファを使用します。デフォルトは 0 バイトです。 バッファよりも大きなサイズの入力レコードが受信されると、動的バッファが一時的に使用されてリクエストが処理され、その後解放されます。

動的メモリをまったく必要としない大きな 16kB の静的バッファを使用したい場合は、`LARGE_STATIC_BUFFERS` を定義してこのオプションを有効にできます。

動的バッファが使用され、ユーザーがバッファ サイズよりも大きい `wolfSSL_write()` を要求した場合、最大で `MAX_RECORD_SIZE` までの動的ブロックがデータの送信に使用されます。 `RECORD_SIZE` で定義されているように、最大で現在のバッファ サイズのチャンクでのみデータを送信したいユーザーは、`STATIC_CHUNKS_ONLY` を定義することでこれを行うことができます。 この定義を使用すると、「RECORD_SIZE」のデフォルトは 128 バイトになります。


＃＃＃ ファイルシステム

**Q: どんな場合にこのセクションが必要ですか?**

A: ファイル システムが利用できないか、標準のファイル システム機能が利用できないか、カスタム ファイル システムを使用している場合です。

wolfSSL はファイルシステムを使用して、鍵と証明書を SSL セッションまたはコンテキストにロードします。 wolfSSL では、これらをメモリ バッファからロードすることもできます。 メモリ バッファを厳密に使用する場合、ファイルシステムは必要ありません。

ライブラリをビルドするときに `NO_FILESYSTEM` を定義することで、wolfSSL によるファイルシステムの使用を無効にすることができます。 これは、ファイルではなくメモリ バッファから証明書とキーをロードする必要があることを意味します。 `settings.h` でこれを設定する例:


```c
#ifdef MY_NEW_PLATFORM
...
#NO_FILESYSTEM を定義
...
#endif
```


テスト キーと証明書のバッファは、`./wolfssl/certs_test.h` ヘッダー ファイルにあります。 これらは、`./certs` ディレクトリにある対応する証明書とキーに一致します。

`certs_test.h` ヘッダー ファイルは、必要に応じて `./gencertbuf.pl` スクリプトを使用して更新できます。 `gencertbuf.pl` の中には、`fileList_1024` と `fileList_2048` の 2 つの配列があります。 キーのサイズに応じて、追加の証明書またはキーをそれぞれのアレイに追加することができ、DER 形式である必要があります。 上記の配列は、証明書/鍵ファイルの場所を目的のバッファー名にマップします。 `gencertbuf.pl` を変更した後、wolfSSL ルート ディレクトリから実行すると、`./wolfssl/certs_test.h` の証明書とキー バッファが更新されます。


```
./gencertbuf.pl
```


デフォルト以外のファイルシステムを使用したい場合、ファイルシステム抽象化レイヤーは `./wolfssl/wolfcrypt/wc_port.h` にあります。 ここには、EBSNET、FREESCALE_MQX、MICRIUM など、さまざまなプラットフォームのファイル システム ポートが表示されます。 必要に応じて、プラットフォームのカスタム定義を追加できます。これにより、「XFILE」、「XFOPEN」、「XFSEEK」などでファイル システム関数を定義できます。たとえば、Micrium の µC/ OS(MICRIUM)は以下の通りです。


```c
#elif定義(MICRIUM)
#include <fs.h>
#XFILE FS_FILE* の定義
#XFOPEN fs_fopen を定義
#XFSEEK の定義 fs_fseek
#define XFTELL fs_ftell
#XREWIND fs_rewind を定義
#XFREAD fs_fread を定義
#XFCLOSE fs_fclose の定義
#XSEEK_END FS_SEEK_END を定義
#XBADFILE NULL を定義
```

### スレッド化

**Q: どんな場合にこのセクションが必要ですか?**

A: マルチスレッド環境で wolfSSL を使用したい、またはシングルスレッドモードでコンパイルしたい場合です。

wolfSSL がシングル スレッド環境でのみ使用される場合、wolfSSL をコンパイルするときに `SINGLE_THREADED` を定義して wolfSSL ミューテックス レイヤーを無効にすることができます。 これにより、wolfSSL ミューテックス層を移植する必要がなくなります。

wolfSSL をマルチスレッド環境で使用する必要がある場合、wolfSSL ミューテックス レイヤーを新しい環境に移植する必要があります。 ミューテックス層は `./wolfssl/wolfcrypt/wc_port.h` と `./wolfcrypt/src/wc_port.c` にあります。 `wc_port.h` で新しいシステム用に `wolfSSL_Mutex` を定義する必要があります。 `wc_port.h` と `wc_port.c` を検索して、いくつかの既存のプラットフォーム ポート レイヤー (EBSNET、FREESCALE_MQX など) の例を確認できます。


### ランダムシード

**Q: どんな場合にこのセクションが必要ですか?**

A: `/dev/random` または `/dev/urandom` が利用できないか、ハードウェア RNG に統合したい場合です。

デフォルトでは、wolfSSL は `/dev/urandom` または `/dev/random` を使用して RNG シードを生成します。 `NO_DEV_RANDOM` 定義は、wolfSSL をビルドしてデフォルトの `GenerateSeed()` 関数を無効にするときに使用できます。 これが定義されている場合、ターゲット プラットフォームに固有のカスタムの `GenerateSeed()` 関数を `./wolfcrypt/src/random.c` に記述する必要があります。 これにより、可能であれば、ハードウェアベースのランダムエントロピーソースで wolfSSL の PRNG をシードできます。

`GenerateSeed()` の記述方法の例については、`./wolfcrypt/src/random.c` にある wolfSSL の既存の `GenerateSeed()` 実装を参照してください。


### メモリー

**Q: どんな場合にこのセクションが必要ですか?**

A: 標準メモリ関数を利用できない場合、またはオプションの数学ライブラリ間のメモリ使用量の違いに関心がある場合です。

wolfSSL は、デフォルトで `malloc()` と `free()` の両方を使用します。 通常の大整数演算ライブラリを使用する場合、wolfCrypt は `realloc()` も使用します。

デフォルトでは、wolfSSL/wolfCrypt は通常の大きな整数演算ライブラリを使用しますが、これはかなりの動的メモリを使用します。 wolfSSL をビルドするとき、fastmath ライブラリを有効にすることができます。これは高速であり、暗号操作に動的メモリを使用しません (すべてスタック上)。 fastmath を使用することで、wolfSSL は `realloc()` の実装をまったく必要としなくなります。 wolfSSL の SSL レイヤーはまだ動的メモリを使用しているため、「malloc()」と「free()」が引き続き必要です。

big integer math ライブラリと fastmath ライブラリのリソース使用量 (スタック/ヒープ) の比較については、リソースの使用に関するドキュメントを参照してください。

fastmath を有効にするには、「USE_FAST_MATH」を定義し、「./wolfcrypt/src/integer.c」の代わりに「./wolfcrypt/src/tfm.c」をビルドします。 fastmath を使用するとスタックメモリが大きくなる可能性があるため、 TFM_TIMING_RESISTANT も定義することをお勧めします。

通常の `malloc()`、`free()`、およびおそらく `realloc()` 関数が利用できない場合は、`XMALLOC_USER` を定義し、`./wolfssl/wolfcrypt/types.h` でカスタム メモリ関数フックを提供します。 ターゲット環境に固有です。

`XMALLOC_USER` の使用に関する詳細については、[セクション 5.1.1.1 を読む](chapter05.md#memory-use) を参照してください。


### 時間

**Q: どんな場合にこのセクションが必要ですか?**

A: 標準の時間関数 (`time()`、`gmtime()`) が利用できない場合、またはカスタムのクロック ティック関数を指定する必要がある場合です。

デフォルトでは、wolfSSL は `./wolfcrypt/src/asn.c` で指定されているように `time()`、`gmtime()`、および `ValidateDate()` を使用します。 これらは `XTIME`、`XGMTIME`、`XVALIDATE_DATE` に抽象化されます。 標準時間関数と time.h が利用できない場合、ユーザーは USER_TIME を定義できます。 `USER_TIME` を定義した後、ユーザーは独自の `XTIME`、`XGMTIME`、および `XVALIDATE_DATE` 関数を定義できます。

wolfSSL はデフォルトでクロック ティック関数に「time(0)」を使用します。 これは、`LowResTimer()` 関数内の `./src/internal.c` にあります。

`USER_TICKS` を定義すると、`time(0)` が不要な場合、ユーザーは独自のクロック ティック関数を定義できます。 カスタム関数には 2 番目の精度が必要ですが、EPOCH に関連付ける必要はありません。 `./src/internal.c` の `LowResTimer()` 関数を参照してください。


### C 標準ライブラリ

**Q: どんな場合にこのセクションが必要ですか?**

A: C 標準ライブラリが利用できない場合、またはカスタム ライブラリがある場合です。

開発者に高いレベルの移植性と柔軟性を提供するために、C 標準ライブラリなしで wolfSSL を構築することができます。 その際、ユーザーは C 標準関数の代わりに使用したい関数をマップする必要があります。

上記のセクション 7 では、メモリ機能について説明しました。 メモリ関数の抽象化に加えて、wolfSSL は文字列関数と数学関数も抽象化します。特定の関数は通常、`X<FUNC>` の形式で定義に抽象化されます。ここで、`<FUNC>` は対象となる関数の名前です。 抽象化。

詳細については、[セクション 5.1](chapter05.md) をお読みください。

### ロギング

**Q: どんな場合にこのセクションが必要ですか?**

A: デバッグ メッセージを有効にしたいが、利用可能な stderr が無い場合です。

デフォルトでは、wolfSSL は stderr を介してデバッグ出力を提供します。 デバッグ メッセージを有効にするには、`DEBUG_WOLFSSL` を定義して wolfSSL をコンパイルし、アプリケーション コードから `wolfSSL_Debugging_ON()` を呼び出す必要があります。 `wolfSSL_Debugging_OFF()` は、アプリケーション層で wolfSSL デバッグ メッセージをオフにするために使用できます。

stderr を使用できない環境、またはデバッグ メッセージを別の出力ストリームまたは別の形式で出力したい環境では、アプリケーションがロギング コールバックを登録できます。

詳細については、[セクション 8.1](chapter08.md) をお読みください。


### 公開鍵操作

**Q: どんな場合にこのセクションが必要ですか?**

A: wolfSSL で独自の公開鍵の実装を使用したい場合です。

wolfSSL では、SSL/TLS レイヤーが公開鍵操作を行う必要があるときに呼び出される独自の公開鍵コールバックをユーザーが作成できます。 ユーザーはオプションで 6 つの機能を定義できます。



1. ECC サイン コールバック
2. ECC ベリファイ コールバック
3. RSA 署名のコールバック
4. RSA 検証コールバック
5. RSA 暗号化コールバック
6. RSA 復号化コールバック

詳細については、[セクション 6.4](chapter06.md#public-key-callbacks) をお読みください。


### アトミック レコード レイヤーの処理

**Q: どんな場合にこのセクションが必要ですか?**

A: レコード レイヤーの独自の処理、特に MAC/暗号化および復号化/検証操作を行いたい場合です。

デフォルトでは、wolfSSL はその暗号化ライブラリである wolfCrypt を使用して、ユーザーのレコード層処理を処理します。 wolfSSL は、SSL/TLS 接続中に MAC/暗号化および復号化/検証機能をより詳細に制御したいユーザーのために、アトミック レコード処理コールバックを提供します。

ユーザーは 2 つの関数を定義する必要があります。

1.MAC/暗号化コールバック機能
2. コールバック関数の復号化/検証

詳細については、[セクション 6.3](chapter06.md#user-atomic-record-layer-processing) をお読みください。

### 機能

**Q: どんな場合にこのセクションが必要ですか?**

A: 特定の機能を無効にしたい場合です。

適切な定義を使用して wolfSSL を構築するときに、機能を無効にすることができます。 利用可能な定義のリストについては、[第 2 章](chapter02.md) を参照してください。


## 次のステップ


### wolfCrypt テストアプリケーション

wolfSSL をターゲット プラットフォーム上でビルドできるようになったら、次の適切なステップは wolfCrypt テスト アプリケーションを移植することです。 このアプリケーションをターゲット システムで実行すると、NIST テスト ベクトルを使用して、すべての暗号化アルゴリズムが正しく機能していることを確認できます。

この手順をスキップして、代わりに SSL 接続の確立に直接進むと、基になる暗号化操作の失敗によって発生する問題のデバッグがより困難になる可能性があります。

wolfCrypt テスト アプリケーションは `./wolfcrypt/test/test.c` にあります。 組み込みアプリケーションに独自の `main()` 関数がある場合、`./wolfcrypt/test/test.c` をコンパイルするときに `NO_MAIN_DRIVER` を定義する必要があります。 これにより、アプリケーションの `main()` は、各暗号/アルゴリズム テストを独自に個別に呼び出すことができます。

組み込みデバイスに wolfCrypt テスト アプリケーション全体を実行するのに十分なリソースがない場合、個々のテストを `test.c` から分割して個別にコンパイルできます。 `test.c` から分離された暗号テストを抽出するときは、特定のテスト ケースに必要な正しいヘッダー ファイルがビルドに含まれていることを確認してください。


## サポート

一般的なサポートの質問は、電子メール、サポート フォーラム、または wolfSSL の Zendesk チケット トラッキング システムを介して wolfSSL に直接送信できます。

Website:	   [https://www.wolfssl.com](https://www.wolfssl.com)

Support Email:  [support@wolfssl.com](mailto:support@wolfssl.com)

Zendesk: 	   [https://wolfssl.zendesk.com](https://wolfssl.zendesk.com)

Forums:  	   [https://www.wolfssl.com/forums](https://www.wolfssl.com/forums)

wolfSSL は、ユーザーと顧客が wolfSSL を新しい環境に移植するのを支援するために、いくつかのサポート パッケージとコンサルティング サービスを提供しています。

Support Packages:  [https://www.wolfssl.com/wolfSSL/Support/support_tiers.php](https://www.wolfssl.com/wolfSSL/Support/support_tiers.php)

Consulting Services: [https://www.wolfssl.com/wolfSSL/wolfssl-consulting.html](https://www.wolfssl.com/wolfSSL/wolfssl-consulting.html)

General Inquiries: [facts@wolfssl.com](mailto:facts@wolfssl.com)


