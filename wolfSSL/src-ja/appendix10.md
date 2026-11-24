# wolfSSL 移植ガイド

## 目的

このガイドは、軽量 SSL/TLS ライブラリwolfSSLを新しい組み込みプラットフォーム、オペレーティングシステム、トランスポートメディア(TCP/IP、Bluetoothなど)に移植するエンジニア向けのリファレンスを提供します。
wolfSSLを移植する際に通常変更が必要となるwolfSSLコードベースの領域を説明しています。
本稿はあくまで「ガイド」で、技術の進化に伴い変更が必要になることもあります。
不足していると感じる箇所があれば、気兼ねなくお知らせください。
説明や補足を喜んで本ドキュメントに追加いたします。


## 対象読者

このガイドは、wolfSSLおよびwolfCryptを、現在サポートされていない新しいプラットフォームまたは環境に移植するエンジニアを対象としています。


## 序章

組み込みプラットフォームでwolfSSLを実行するには、いくつかの手順を繰り返す必要があります。
これらの手順の一部は、[第2章 wolfSSLのビルド](chapter02.md)の「非標準環境でのビルド」節で概説しています。

wolfSSLドキュメント第2章に示した手順に加えて、特定のプラットフォームに対応するために移植または変更が必要なコード領域があります。
wolfSSLはこれらの領域の多くを抽象化して、新しいプラットフォームへできるだけ簡単に移植できるようにしています。

`./wolfssl/wolfcrypt/settings.h` ファイルには、さまざまなオペレーティングシステム、TCP/IPスタック、およびチップセット (例: MBED、FREESCALE_MQX、MICROCHIP_PIC32、MICRIUM、EBSNET など) に固有の定義がいくつかあります。
wolfSSLをコンパイルして新しいプラットフォームに移植するときに、`#defines` を配置する主な場所は2つあります。

1. オペレーティングシステムまたはTCP/IPスタックに対応するための新たなマクロ定義は、通常、wolfSSLのポーティングが完了すると、`settings.h` ファイルに追加しています。
   これにより、機能のオン/オフを簡単に切り替えたり、そのビルドの「デフォルト」となるビルド設定をカスタマイズしたりできます。
   wolfSSLを新しいプラットフォームに移植する際にも、このファイルに新しいカスタム定義を追加することでお使いいただけます。
   新しいプラットフォームへの移植が完了した際、もし差し支えなければ、wolfSSLの [Gitリポジトリ](https://www.github.com/wolfssl/wolfssl) にPull Requestを送信していただけると嬉しく思います。
   これにより、wolfSSLを最新の状態に保つことができ、wolfSSLプロジェクトの改善と進展に合わせてさまざまな移植版も更新され続けます。

2. wolfSSL自体に変更を加えたくない場合、または追加のプリプロセッサ定義を使用して wolfSSLビルドをカスタマイズしたい場合、wolfSSLはカスタムヘッダーファイル`user_settings.h`の使用を推奨します。
   wolfSSLソースファイルをコンパイルするときに `WOLFSSL_USER_SETTINGS` が定義されている場合、wolfSSLはカスタムヘッダーファイル `user_settings.h` を自動的にインクルードします。
   このヘッダーはユーザーが作成し、インクルードパスに配置する必要があります。
   これにより、ユーザーはwolfSSLビルド用に1つのファイルのみを管理すればよく、wolfSSLの新しいバージョンへの更新がはるかに簡単になります。

wolfSSLでは、直接のメール ([info@wolfssl.jp](mailto:info@wolfssl.jp)) または [GitHub Pull Request](https://github.com/wolfssl/wolfssl) を通じてパッチとコード変更をご送信いただくことを推奨しています。


## wolfSSLの移植


### データ型

**Q: どんな場合にこの章の内容が役立ちますか?**

A: プラットフォームに適したデータ型のサイズを設定することは常に重要です。

wolfSSL は、64ビット型を利用できることで速度面でメリットを得ています。
プラットフォームの `sizeof(long)` と `sizeof(long long)` の結果と一致するように `SIZEOF_LONG` と `SIZEOF_LONG_LONG` を定義します。
これは、`settings.h` または `user_settings.h` のカスタム定義に追加できます。
たとえば、`settings.h`の`MY_NEW_PLATFORM`のサンプル定義の下に、次のように記述します。


```c
#ifdef MY_NEW_PLATFORM
	#define SIZEOF_LONG 4
	#define SIZEOF_LONG_LONG 8
	...
#endif
```


wolfSSLとwolfCryptでは、`word32` と `word16` という2つの追加データ型を使用します。
これらのデフォルトの型マッピングは次のとおりです。


```c
#ifndef WOLFSSL_TYPES
#ifndef byte
    typedef unsigned char  byte;
#endif
	typedef unsigned short word16;
    typedef unsigned int   word32;
    typedef byte           word24[3];
#endif
```


`word32` はコンパイラの32ビット型にマッピングし、`word16` はコンパイラの16ビット型にマッピングする必要があります。
これらのデフォルトのマッピングがプラットフォームに適していない場合は、`settings.h` または `user_settings.h` で `WOLFSSL_TYPES` を定義し、word32およびword16に独自のカスタムtypedefを割り当てる必要があります。

デフォルトの数学ライブラリであるSP Mathライブラリ（`./wolfcrypt/src/sp_int.c`、`WOLFSSL_SP_MATH_ALL`）は、`sp_int_digit` 型と `sp_int_word` 型を使用します。
これらのサイズは `SP_WORD_SIZE` によって選択されます。
`SP_WORD_SIZE` はターゲットに応じて決定されますが、必要に応じて `user_settings.h` で32または64に設定することもできます。

レガシーのfastmathバックエンド（`USE_FAST_MATH`）を使用する場合は、`<wolfssl/wolfcrypt/tfm.h>` でマッピングされている `fp_digit` 型と `fp_word` 型が使用されます。
レガシーのヒープ数学バックエンド（`USE_INTEGER_HEAP_MATH`）は、`<wolfssl/wolfcrypt/integer.h>` の `mp_digit` 型と `mp_word` 型を使用します。
word型はdigit型の2倍のサイズである必要があります。
デフォルトのケースがプラットフォームに当てはまらない場合は、`settings.h` または `user_settings.h` で `WOLFSSL_BIGINT_TYPES` を定義し、これらの型に独自のカスタムtypedefを割り当てる必要があります。

wolfSSLは、一部の操作において使用可能な場合は64ビット型を使用します。
ビルド時には、`SIZEOF_LONG` および `SIZEOF_LONG_LONG` の設定に基づいて、`word64` の正しいデータ型を検出して設定しようとします。
真の64ビット型を持たない一部のプラットフォームでは、2つの32ビット型を合わせて使用するため、パフォーマンスが低下する可能性があります。
コンパイル時に`NO_64BIT`を定義することで、64ビット型を使用しないこともできます。


### エンディアン

**Q: どんな場合にこの章の内容が役立ちますか?**

A: あなたのプラットフォームがビッグエンディアンの場合です。

お使いのプラットフォームはビッグエンディアンとリトルエンディアン、どちらでしょうか。
wolfSSLはデフォルトでリトルエンディアンを使用しています。
システムがビッグエンディアンの場合は、wolfSSL をビルドする際に `BIG_ENDIAN_ORDER` を定義します。
例えば、`settings.h` で次のように設定できます。


```c
#ifdef MY_NEW_PLATFORM
	...
	#define BIG_ENDIAN_ORDER
	...
#endif
```



### writev

**Q: どんな場合にこの章の内容が役立ちますか?**

A: `<sys/uio.h>` を利用できない場合です。

デフォルトでは、wolfSSL APIは、`writev()` セマンティクスをシミュレートする `wolfSSL_writev()` をアプリケーションに提供します。
`<sys/uio.h>` ヘッダーが利用できないシステムでは、`NO_WRITEV` を定義してこの機能を除外します。


### ネットワークI/O

**Q: どんな場合にこの章の内容が役立ちますか?**

A: BSD スタイルのソケットAPIを利用できない、あるいはカスタムトランスポート層またはTCP/IPスタックを使用している、または静的バッファーのみを使用したい場合です。

wolfSSLはデフォルトでBSDスタイルのソケットインターフェイスを使用します。
トランスポート層がBSDソケットインターフェイスを提供する場合、カスタムヘッダーが必要でない限り、wolfSSLはそのまま組み込めるはずです。

wolfSSLはカスタムI/O抽象化レイヤーを提供し、ユーザーはwolfSSLのI/O機能をシステムに合わせて調整できます。
詳細については、[第5章 移植性](chapter05.md)の「カスタム入出力抽象化レイヤー」節をご参照ください。

具体的には `WOLFSSL_USER_IO` を定義し、wolfSSLデフォルトの `EmbedSend()` と `EmbedReceive()` をテンプレートとして使用し、独自のI/Oコールバック関数を記述します。
これら2つの関数は `./src/wolfio.c`（ヘッダーは `wolfssl/wolfio.h`）にあります。
作成したコールバックは、`wolfSSL_CTX_SetIORecv()` と `wolfSSL_CTX_SetIOSend()` で登録します。
BSDスタイルのソケット層がまったく存在しない場合は、`WOLFSSL_NO_SOCK` を定義すると組み込みのソケットコードが除外されます。

wolfSSLは、入力と出力に小さな静的バッファを使用します。
このバッファは、デフォルトではレコードヘッダー（`STATIC_BUFFER_LEN`、5バイト）のみを保持できるサイズです。
バッファよりも大きいサイズの入力レコードを受信した場合、動的バッファが一時的にリクエストの処理に使用され、その後解放されます。

動的メモリを必要としない16kBの大きな静的バッファを使用する場合は、`LARGE_STATIC_BUFFERS` を定義することでこのオプションを使用できます。

動的バッファが使用され、ユーザーがバッファサイズよりも大きい `wolfSSL_write()` を要求した場合、最大 `MAX_RECORD_SIZE` までの動的ブロックを使用してデータを送信します。
`RECORD_SIZE` で定義されている現在のバッファサイズの最大のチャンクでのみデータを送信したいユーザーは、`STATIC_CHUNKS_ONLY` を定義することでこれを実現できます。
`RECORD_SIZE` のデフォルトは128バイト（DTLSビルドでは `MAX_MTU`）で、128から16384までの値に設定できます。


### ファイルシステム

**Q: どんな場合にこの章の内容が役立ちますか?**

A: ファイルシステムを利用できない、あるいは標準のファイルシステム機能を利用できない、または独自のファイルシステムを使用している場合です。

wolfSSLは、TLSセッションまたはコンテキストに鍵と証明書をロードするためにファイルシステムを使用します。
wolfSSLでは、これらをメモリバッファからロードすることもできます。
メモリバッファのみを使用する場合、ファイルシステムは必要ありません。

ライブラリをビルドするときに `NO_FILESYSTEM` を定義することで、wolfSSLによるファイルシステムの使用を無効にできます。
つまり、証明書と鍵はファイルではなくメモリバッファからロードする必要があります。
`settings.h` で、以下のように設定できます。


```c
#ifdef MY_NEW_PLATFORM
	...
	#define NO_FILESYSTEM
	...
#endif
```


テスト用の鍵と証明書バッファーは、`./wolfssl/certs_test.h` ヘッダーファイルにあります。
これらは、`./certs` ディレクトリにある対応する証明書や鍵と一致します。

`certs_test.h` ヘッダーファイルは、必要に応じて `./gencertbuf.pl` スクリプトを使用して更新できます。
`gencertbuf.pl` 内には、鍵の種類とサイズごとにまとめられた複数の配列（`fileList_ecc`、`fileList_ed`、`fileList_x`、`fileList_1024`、`fileList_2048`、`fileList_3072`、`fileList_4096`、`fileList_sm2`、`fileList_sm2_der`、`fileList_falcon`、`fileList_cn_ip`）があります。
追加の証明書または鍵をそれぞれの配列に追加できますが、DER形式である必要があります（`fileList_sm2` にはPEMファイルを指定します）。
これらの配列は、証明書・鍵ファイルの場所を目的のバッファー名にマップします。
`gencertbuf.pl` を変更した後、wolfSSLルートディレクトリから実行すると、`./wolfssl/certs_test.h` の証明書・鍵のバッファー（およびSMのバッファーについては `./wolfssl/certs_test_sm.h`）が更新されます。


```sh
./gencertbuf.pl
```


デフォルト以外のファイルシステムを使用する場合、ファイルシステム抽象化レイヤーは `./wolfssl/wolfcrypt/wc_port.h` にあります。
ここには、EBSNET、FREESCALE_MQX、MICRIUM などのさまざまなプラットフォームのファイルシステムポートがあります。
必要に応じて、プラットフォームのカスタム定義を追加できます。
これにより、`XFILE`、`XFOPEN`、`XFSEEK` などを使用してファイルシステム関数を定義できます。
たとえば、Micrium の uC/OS (MICRIUM) の `wc_port.h` のファイルシステムレイヤーは次のとおりです。


```c
#elif defined(MICRIUM)
    #include <fs_api.h>
    #define XFILE      FS_FILE*
    #define XFOPEN     fs_fopen
    #define XFSEEK     fs_fseek
    #define XFTELL     fs_ftell
    #define XFREAD     fs_fread
    #define XFWRITE    fs_fwrite
    #define XFCLOSE    fs_fclose
    #define XSEEK_SET  FS_SEEK_SET
    #define XSEEK_END  FS_SEEK_END
    #define XBADFILE   NULL
    #define XFGETS(b,s,f) -2 /* Not ported yet */
```

`wc_port.h` を編集する代わりに、`WOLFSSL_USER_FILESYSTEM` を定義し、すべての `X*` ファイルシステムマクロを `user_settings.h` で定義することもできます。

### スレッド化

**Q: どんな場合にこの章の内容が役立ちますか?**

A: マルチスレッド環境でwolfSSLを使用したい、またはシングルスレッドモードでコンパイルしたい場合です。

wolfSSLをシングルスレッド環境でのみ使用する場合、wolfSSLをコンパイルするときに `SINGLE_THREADED` を定義することでwolfSSLミューテックスレイヤーを無効にできます。
これにより、wolfSSLミューテックスレイヤーを移植する必要がなくなります。

wolfSSLをマルチスレッド環境で使用する場合、wolfSSLミューテックスレイヤーを新しい環境に移植する必要があります。
ミューテックスレイヤーは `./wolfssl/wolfcrypt/wc_port.h` および `./wolfcrypt/src/wc_port.c` にあります。
新しいシステムでは、`wc_port.h` に `wolfSSL_Mutex` を定義し、`wc_port.c` にミューテックス関数 (`wc_InitMutex`、`wc_FreeMutex`、`wc_LockMutex`、`wc_UnLockMutex`) を定義する必要があります。
`wc_port.h` と `wc_port.c` を検索すると、既存のプラットフォームポートレイヤー (EBSNET、FREESCALE_MQX など) の例を参照できます。
あるいは、`WOLFSSL_USER_MUTEX` を定義し、（例えば `user_settings.h` で）`wolfSSL_Mutex` のtypedefを用意して、ミューテックス関数を独自のコードで実装することもできます。
この場合、`wc_port.h` や `wc_port.c` を変更する必要はありません。


### ランダムシード

**Q: どんな場合にこの章の内容が役立ちますか?**

A: `/dev/random` や `/dev/urandom` を利用できない、あるいはハードウェアRNGに統合する必要がある場合です。

デフォルトでは、wolfSSLは `/dev/urandom` または `/dev/random` を使用して RNG シードを生成します（Linuxでは、`WOLFSSL_GETRANDOM` または `HAVE_GETRANDOM` が定義されている場合、代わりに `getrandom()` システムコールを使用します）。
wolfSSLをビルドするときに `NO_DEV_RANDOM` 定義を使用して、デフォルトの `wc_GenerateSeed()` 関数を無効にすることができます。
これが定義されている場合は、ターゲットプラットフォームに固有のシードソースを用意する必要があります。
これにより、ハードウェアベースのランダムエントロピーソースが利用可能な場合は、それを使用してwolfSSLのPRNGにシードを設定できます。
`./wolfcrypt/src/random.c` を変更する代わりに、`user_settings.h` で以下のいずれかを定義することもできます。

* `CUSTOM_RAND_GENERATE_SEED` - 独自のシード関数の名前です。
  この関数は `(byte* output, word32 sz)` を引数に取り、成功時に0を返します。
* `CUSTOM_RAND_GENERATE_SEED_OS` - 上記と同じですが、追加の第1引数として `OS_Seed*` を取ります。
* `CUSTOM_RAND_GENERATE_BLOCK` - 同じ `(byte* output, word32 sz)` 引数を取る関数の名前です。
  この関数は、wolfCrypt DRBGの出力を完全に置き換えます（例えばハードウェアRNGを使用する場合）。

`wc_GenerateSeed()` の記述方法の例については、`./wolfcrypt/src/random.c` にある wolfSSL の既存の `wc_GenerateSeed()` 実装を参照してください。


### メモリー

**Q: どんな場合にこの章の内容が役立ちますか?**

A: 標準のメモリ関数が利用できない、あるいはオプションの数学ライブラリ間のメモリ使用量の違いに関心がある場合です。

wolfSSL本体はデフォルトで `malloc()` と `free()` の両方を使用します。
レガシーのヒープ数学ライブラリ（`USE_INTEGER_HEAP_MATH`）を使用する場合、wolfCryptは `realloc()` も使用します。

wolfSSL/wolfCryptは、デフォルトでSP Mathライブラリ（`./wolfcrypt/src/sp_int.c`、`WOLFSSL_SP_MATH_ALL`）を使用します。
このライブラリは定数時間で動作し、デフォルトでは多倍長整数をスタック上に保持します。
スタックの少ないターゲットでは、`WOLFSSL_SMALL_STACK` を定義すると大きな変数をスタックからヒープに移動できます。
また、`WOLFSSL_SP_SMALL` を定義するとコードサイズを小さくできます。
`WOLFSSL_SP_MATH` は、SP MathライブラリをSPコードが実装している鍵長と曲線に制限します（付録Hを参照）。
レガシーのfastmathライブラリ（`USE_FAST_MATH`、`./wolfcrypt/src/tfm.c`、`--enable-fastmath`）とヒープ数学ライブラリ（`USE_INTEGER_HEAP_MATH`、`./wolfcrypt/src/integer.c`、`--enable-heapmath`）も引き続き使用できます。
fastmathを使用する場合は、`TFM_TIMING_RESISTANT` も定義してください。
wolfSSLのTLSレイヤーは引き続きある程度の動的メモリを使用するため、`malloc()` と `free()` は必要です。

数学ライブラリ間のリソース使用量（スタック/ヒープ）の比較については、弊社までお問い合わせいただければ、Resource Use ドキュメントをご覧いただけます。

数学ライブラリについては、以下のページもご覧ください。

- [wolfSSLの新たな Multi-Precision 演算ライブラリ](https://wolfssl.jp/wolfblog/2021/02/03/multi-precision-math-library/)
- [wolfSSL Math Library Comparison Matrix](https://www.wolfssl.com/wolfssl-math-library-comparison-matrix/)
- [レガシー数学ライブラリを廃止します](https://wolfssl.jp/wolfblog/2023/03/13/deprecation-of-wolfssl-normal-math-library/)

通常の `malloc()`、`free()`、および場合によっては `realloc()` 関数が使用できない場合は、`XMALLOC_USER` を定義し、`./wolfssl/wolfcrypt/types.h` にターゲット環境に固有のカスタムメモリ関数フックを用意します。
あるいは、`XMALLOC_OVERRIDE` を定義して独自の `XMALLOC`、`XFREE`、`XREALLOC` マクロを用意するか、`wolfSSL_SetAllocators()` を使用して実行時にメモリ確保関数を登録することもできます。
ヒープのないシステムでは、`WOLFSSL_STATIC_MEMORY`（`--enable-staticmemory`）を使用すると、アプリケーションが `wc_LoadStaticMemory()` で提供するバッファからwolfSSLがメモリを確保できるようになります。

`XMALLOC_USER` の使用の詳細については、[第5章 移植性](chapter05.md)の「メモリ使用」節をご参照ください。


### 時間

**Q: どんな場合にこの章の内容が役立ちますか?**

A: 標準の時間関数 (`time()`、`gmtime()`) を利用できない、あるいはカスタムのクロックティック関数を指定する必要がある場合です。

デフォルトでは、wolfSSLは `time()`、`gmtime()`、および `wc_ValidateDate()` を使用します。
これらは、`./wolfssl/wolfcrypt/wc_port.h` で `XTIME`、`XGMTIME`、および `XVALIDATE_DATE` に抽象化されています。
標準の時間関数と `time.h` を利用できない場合は、ユーザーは `USER_TIME` を定義できます。
`USER_TIME` を定義した後、ユーザーは独自の `XTIME`、`XGMTIME`、および `XVALIDATE_DATE` 関数を定義できます。
あるいは、`TIME_OVERRIDES` を使用することもできます。
この場合、標準の時間型はそのまま使用されますが、ユーザーは `XTIME` と `XGMTIME` の両方を用意する必要があります。

wolfSSLは、クロックティック関数にデフォルトで `time(0)` を使用します。
これは、`./src/internal.c` の `LowResTimer()` 関数内にあります。

`USER_TICKS` を定義すると、`time(0)` が必要ない場合にユーザーが独自のクロックティック関数を定義できるようになります。
カスタム関数には秒単位の精度が必要ですが、エポックと相関させる必要はありません。
参考として、`./src/internal.c` の `LowResTimer()` 関数を参照してください。


### C標準ライブラリ

**Q: どんな場合にこの章の内容が役立ちますか?**

A: C標準ライブラリを使用できない、あるいは独自のライブラリがある場合です。

wolfSSLは、開発者に高いレベルの移植性と柔軟性を提供するために、C標準ライブラリなしで構築できるようにしています。
その場合、ユーザーはC標準の関数の代わりに使用したい関数をマップする必要があります。

メモリ関数については、上記の「メモリー」節で説明しました。
メモリ関数の抽象化に加えて、wolfSSLは文字列関数と数学関数も抽象化します。
特定の関数は通常、`X<FUNC>` 形式の定義に抽象化されます。
`<FUNC>` は抽象化される関数の名前です。

詳細については、[5.1章](chapter05.md) をご覧ください。


### ロギング

**Q: どんな場合にこの章の内容が役立ちますか?**

A: デバッグメッセージを有効にしたいが、stderr を使用できない場合です。

デフォルトでは、wolfSSLはstderrを介してデバッグ出力を提供します。
デバッグメッセージを有効にするには、wolfSSLを `DEBUG_WOLFSSL` を定義してコンパイルし、アプリケーションコードから `wolfSSL_Debugging_ON()` を呼び出す必要があります。
同様に、アプリケーションから`wolfSSL_Debugging_OFF()` を呼び出すことで、wolfSSLデバッグメッセージをオフにすることもできます。

stderrを使用できない、あるいは別の出力ストリームや別の形式でデバッグメッセージを出力したい環境には、独自のロギングコールバック関数を登録できるようにしています。

詳細については、[8.1章](chapter08.md) をご覧ください。


### 公開鍵操作

**Q: どんな場合にこの章の内容が役立ちますか?**

A: wolfSSLで独自の公開鍵実装を使用したい場合です。

wolfSSLでは、SSL/TLSレイヤーが公開鍵操作を行う必要があるときに呼び出される、独自の公開鍵コールバックをユーザーが作成できます。
ユーザーは、必要に応じて複数のコールバックを定義できます。
例えば、次のようなコールバックがあります。

1. ECC 鍵生成、署名、検証、共有秘密コールバック
2. RSA 署名、検証、暗号化、復号コールバック（RSA-PSS 署名と検証を含む）
3. DH 鍵共有コールバック
4. Ed25519 および Ed448 署名、検証コールバック
5. X25519 および X448 鍵生成、共有秘密コールバック
6. TLS 鍵導出コールバック（例えばマスターシークレット、セッション鍵、Finished、HKDF）

詳細については、[第6章 コールバック](chapter06.md)の「公開鍵コールバック」節をご覧ください。


### アトミックレコードレイヤーの処理

**Q: どんな場合にこの章の内容が役立ちますか?**

A: レコードレイヤーの処理、特にMAC/暗号化および復号/検証操作を独自に実行したい場合です。

デフォルトでは、wolfSSLは暗号ライブラリwolfCryptを使用し、ユーザーに代わってレコードレイヤーの処理を行います。
wolfSSLは、SSL/TLS接続中に MAC/暗号化および復号/検証機能をより細かく制御したいユーザーのために、アトミックレコード処理コールバックを提供します。

ユーザーは2つの関数を定義する必要があります。

1. MAC/暗号化コールバック関数
2. 復号/検証コールバック関数

Encrypt-Then-MAC がネゴシエートされた場合は、さらに2つのコールバック、暗号化/MAC コールバック（`wolfSSL_CTX_SetEncryptMacCb()`）と検証/復号コールバック（`wolfSSL_CTX_SetVerifyDecryptCb()`）が使用されます。

詳細については、[第6章 コールバック](chapter06.md)の「ユーザーアトミックレコードレイヤー処理」節をご覧ください。


### 機能

**Q: どんな場合にこの章の内容が役立ちますか?**

A: 特定の機能を無効にしたい場合です。

wolfSSLをビルドする際、マクロ定義を使用して特定の機能を無効化できます。
使用可能なマクロ定義については、[第2章](chapter02.md) をご覧ください。


### 暗号コールバック

**Q: どんな場合にこの章の内容が役立ちますか?**

A: wolfCryptの処理をハードウェアアクセラレータ、セキュアエレメント、その他のデバイスにオフロードしたい場合です。

暗号コールバック（`WOLF_CRYPTO_CB`、`--enable-cryptocb`）を使用すると、`wc_CryptoCb_RegisterDevice()` でデバイスを登録し、wolfCryptのソースを変更することなく、暗号化、ハッシュ、公開鍵、乱数生成の各処理をそのデバイスで行えます。
付録Hに記載しているハードウェアポートの多くは、この仕組みを使用しています。
詳細については、[第6章 コールバック](chapter06.md)の「暗号コールバック（cryptocb）」節をご覧ください。


## 次のステップ


### wolfCryptテストアプリケーション

wolfSSLをターゲットプラットフォームで適切にビルドできるようになったら、次のステップとして wolfCryptテストアプリケーションを移植するのがよいでしょう。
このアプリケーションをターゲットシステムで実行すると、NISTテストベクトルを使用して、すべての暗号アルゴリズムが正しく動作しているかどうか検証されます。

このステップを省略してSSL/TLS接続に進むと、基盤となる暗号操作の失敗によって発生する問題のデバッグが難しくなる可能性があります。

wolfCryptテストアプリケーションは `./wolfcrypt/test/test.c` にあります。
組み込みアプリケーションに独自の `main()` 関数がある場合は、`./wolfcrypt/test/test.c` をコンパイルするときに `NO_MAIN_DRIVER` を定義する必要があります。
これにより、アプリケーションの `main()` が各暗号/アルゴリズム テストを個別に呼び出すことができます。

組み込みデバイスにwolfCryptテストアプリケーション全体を実行するのに十分なリソースがない場合は、個々のテストを `test.c` から切り離して個別にコンパイルできます。
`test.c` から分離された暗号テストを抽出するときは、特定のテストケースに必要な正しいヘッダーファイルがビルドに含まれていることを確認してください。


## サポート

一般的なサポートの質問は、メール、サポートフォーラム(英語)、またはwolfSSLのZendeskチケットトラッキングシステムを介してwolfSSLに直接送信できます。

Webサイト: [https://www.wolfssl.com](https://www.wolfssl.com)

サポート用メールアドレス: [support@wolfssl.com](mailto:support@wolfssl.com)

Zendesk: [https://wolfssl.zendesk.com](https://wolfssl.zendesk.com)

フォーラム: [https://www.wolfssl.com/forums](https://www.wolfssl.com/forums)

wolfSSLは、ユーザーと顧客がwolfSSLを新しい環境に移植するのを支援するために、いくつかのサポートパッケージとコンサルティングサービスを提供しています。

サポートパッケージ: [https://wolfssl.jp/license/support-packages/](https://wolfssl.jp/license/support-packages/)

お問い合わせ: [info@wolfssl.jp](mailto:info@wolfssl.jp)

