# 2	wolfSSLのポーティング
## データ型

Q：このセクションが必要なのはどういう場合？<br>
A: ポーティング対象のプラットフォームの正しいデータ型のサイズを設定するのは常に重要です。

wolfSSLは、64ビットタイプが利用可能の場合、スピードに恩恵を受けます。プラットフォーム上のsizeof（long）とsizeof（long long）の結果と一致するようにSIZEOF_LONGまたはSIZEOF_LONG_LONGを設定します。これは、settings.hファイルのカスタム定義に追加することができます。たとえば、MY_NEW_PLATFORMのサンプル定義のsettings.hで次のように指定します。


```
#ifdef MY_NEW_PLATFORM
	#define SIZEOF_LONG 4
	#define SIZEOF_LONG_LONG 8
	...
#endif
```

There are two additional data types used by wolfSSL and wolfCrypt, called “word32” and “word16”.  The default type mappings for these are:

```
#ifndef WOLFSSL_TYPES
#ifndef byte
typedef unsigned char  byte;
#endif
	typedef unsigned short word16;
typedef unsigned int   word32;
typedef byte           word24[3];
#endif
```

「word32」はコンパイラの 32 ビット型に、「word16」はコンパイラの 16 ビット型にマップする必要があります。 これらのデフォルトのマッピングがプラットフォームに対して正しくない場合は、settings.h または user_settings.h で WOLFSSL_TYPES を定義し、word32 および word16 に独自のカスタム typedef を割り当てる必要があります。

wolfSSL の fastmath ライブラリは、「fp_digit」および「fp_word」タイプを使用します。 デフォルトでは、これらはビルド構成に応じて <wolfssl/wolfcrypt/tfm.h> にマップされます。

「fp_word」は「fp_digit」の 2 倍のサイズにする必要があります。 デフォルトのケースがプラットフォームに当てはまらない場合は、settings.h または user_settings.h で WOLFSSL_BIGINT_TYPES を定義し、fp_word および fp_digit に独自のカスタム typedef を割り当てる必要があります。

一部の操作で利用可能な場合、wolfSSL は 64 ビット型を使用します。 wolfSSL ビルドは、SIZEOF_LONG と SIZEOF_LONG_LONG の設定に基づいて、word64 の正しい基本データ型を検出して設定しようとします。 2 つの 32 ビット型が一緒に使用される、真の 64 ビット型を持たない一部のプラットフォームでは、パフォーマンスが低下する可能性があります。 64 ビット型の使用をコンパイルするには、NO_64BIT を定義します。

## エンディアン

Q：このセクションが必要なのはどういう場合？<br>

A: プラットフォームがビッグエンディアンの場合です

あなたのプラットフォームはビッグエンディアン、リトルエンディアン、どちらですか？<br>
 wolfSSLはデフォルトではリトルエンディアンシステムです。システムがビッグエンディアンの場合は、wolfSSLをビルドするときにBIG_ENDIAN_ORDERを定義してください。これをsettings.hで設定する例：


```
#ifdef MY_NEW_PLATFORM
	...
	#define BIG_ENDIAN_ORDER
	...
#endif
```

## writev

Q：このセクションが必要なのはどういう場合？<br>
A: <sys/uio.h> が提供されていない場合です

デフォルトでは、wolfSSL APIはアプリケーションに対してwritev関数のセマンティクスをシミュレートするwolfSSL_writev（）を提供します。使用可能な<sys/uio.h>ヘッダーを持たないシステムでは、この機能を除外するためにNO_WRITEVを定義してください。


##	(ネットワーク) 入出力

Q：どういう場合このセクションが必要ですか？<br>
A：BSDスタイルのソケットAPIが使用できない場合。また、特別なポート層またはTCP/IPスタックを使用したい場合、静的バッファーのみを使用したい場合です。

wolfSSLはデフォルトではBSDスタイルのソケットインターフェイスを使用します。トランスポート層がBSDソケットインタフェースを提供する場合、カスタムヘッダが必要な場合を除いて、wolfSSLはそのままの状態で統合する必要があります。

wolfSSLは、ユーザーがシステムにwolfSSLのI / O機能を合わせることが可能となるようにカスタムI / O抽象レイヤーを提供しています。詳細は、wolfSSLマニュアルのセクション5.1.2にあります。

単に、ビルド時オプションにWOLFSSL_USER_IOを指定して、独自のI / Oコールバック関数を、テンプレートとしてwolfSSLのデフォルトEmbedSend（）とEmbedReceive（）を参照して記述してください。これら2つの関数は./src/io.cにあります。

wolfSSLは、入出力時に動的バッファを使用します。デフォルトは0バイトです。バッファよりサイズが大きい入力レコードが受信された場合は、動的バッファを使用して要求を処理してから解放します。

ダイナミックメモリを使用せず、大きな16kBスタティックバッファを使用したい場合は、LARGE_STATIC_BUFFERSオプションを指定します。

ダイナミックバッファが使用されている時は、ユーザがバッファサイズより大きいwolfSSL_write（）を要求すると、最大MAX_RECORD_SIZEまでの動的ブロックがデータを送信するために使用されます。 RECORD_SIZEで定義されているように、バッファー・サイズのデータを最大でのみ送信したい場合は、STATIC_CHUNKS_ONLYを定義します。この定義を使用する場合、RECORD_SIZEのデフォルトは128バイトです。


## ファイルシステム

Q：どういう場合このセクションが必要ですか？<br>
A： 使用可能なファイルシステムがない場合、標準のファイルシステム機能が使用できない場合、または、カスタムファイルシステムを使用する場合です。

wolfSSLは鍵と証明書をSSLセッションまたはコンテキストにロードするためにファイルシステムを使用します。 wolfSSLでは、これらをメモリバッファからロードすることもできます。メモリバッファだけを使用する場合、ファイルシステムは必要ありません。

ライブラリをビルドするときにNO_FILESYSTEMを定義することにより、ファイルシステムの使用を無効にすることができます。この場合、ファイルではなくメモリバッファから証明書と鍵をロードする必要があります。これをsettings.hで設定する例：


```
#ifdef MY_NEW_PLATFORM
	...
	#define NO_FILESYSTEM
	...
#endif
```

テスト用の鍵と証明書バッファーは、./wolfssl/certs_test.hヘッダーファイルにあります。これらは、これらの証明書と./certsディレクトリにある証明書と同じものです。

certs_test.hヘッダーファイルは、必要に応じて./gencertbuf.plスクリプトを使用して更新できます。 gencertbuf.plには、fileList_1024とfileList_2048という2つの配列があります。鍵のサイズに応じて、それぞれの配列に追加の証明書または鍵を追加することができ、DER形式でなければなりません。上記の配列は、目的のバッファ名を持つ証明書/鍵ファイルの場所にマップされます。 gencertbuf.plを変更した後、wolfSSLルートディレクトリからそれを実行すると、./wolfssl/certs_test.hの証明書と鍵バッファが更新されます：


./gencertbuf.pl

デフォルト以外のファイルシステムを使用したい場合、ファイルシステム抽象化レイヤーは./src/ssl.cにあります。ここでは、EBSNET、FREESCALE_MQX、MICRIUMなどのさまざまなプラットフォームのファイルシステムが表示されています。 XFILE、XFOPEN、XFSEEKなどでファイルシステム関数を定義できるように、必要に応じてプラットフォームにカスタム定義を追加できます。たとえば、MicriumのμC/ OS（MICRIUM）のssl.cのファイルシステム層は次のとおりです。

```
#elif defined(MICRIUM)                                                          
#include <fs.h>                                                             
#define XFILE      FS_FILE*                                                 
#define XFOPEN     fs_fopen                                                 
#define XFSEEK     fs_fseek                                                 
#define XFTELL     fs_ftell                                                 
#define XREWIND    fs_rewind                                                
#define XFREAD     fs_fread                                                 
#define XFCLOSE    fs_fclose                                                
#define XSEEK_END  FS_SEEK_END                                              
#define XBADFILE   NULL 
```

## スレッド

Q：どういう場合このセクションが必要ですか？<br>
A：マルチスレッド環境でwolfSSLを使用したい場合、またはシングルスレッドモードでコンパイルしたい場合です。

wolfSSLがシングルスレッド環境でのみ使用される場合、wolfSSLをコンパイルするときにSINGLE_THREADEDを定義してwolfSSLの排他制御を無効にすることができます。これにより、wolfSSL 排他制御層を移植する必要がなくなります。

wolfSSLをマルチスレッド環境で使用する必要がある場合は、wolfSSL排他制御層を新しい環境に移植する必要があります。排他制御層は、./wolfssl/ctaocrypt/wc_port.hと./ctaocrypt/src/wc_port.cにあります。 wolfSSL_Mutexは、wc_port.cのport.hの新しいシステムと排他制御関数（InitMutex、FreeMutexなど）に定義する必要があります。 wc_port.hおよびwc_port.cで、いくつかの既存のプラットフォーム（EBSNET、FREESCALE_MQXなど）を例として検索します。


## 乱数シード

Q：どういう場合このセクションが必要ですか？<br>
A：/dev/randomまたは/dev/urandomのいずれかが利用できないか、RNGハードウェアを統合したい場合です。

デフォルトでは、wolfSSLは/dev/urandomまたは/dev/randomを使用してRNGシードを生成します。 NO_DEV_RANDOMの定義は、デフォルトのwc_GenerateSeed（）関数を無効にするwときにビルド時に指定します。これが指定されている場合は、ターゲットプラットフォームに固有の./wolfcrypt/src/random.cにカスタムwc_GenerateSeed（）関数を記述する必要があります。これにより、ハードウェアベースのランダムエントロピーソースがあれば、wolfSSLのPRNGにシードすることができます。

Wc_GenerateSeed関数をどのように記述する必要があるかの例については、wolfSSLの既存のwc_GenerateSeed関数の実装を./wolfcrypt/src/random.cで参照してください。



## メモリー

Q：どういう場合このセクションが必要ですか？<br>
A：標準のメモリ関数を使用できない場合、またはオプションの数学ライブラリ間のメモリ使用量の違いに関心があるような場合です。

wolfSSLは、デフォルトではmalloc（）とfree（）を使用しています。通常の整数演算ライブラリを使用する場合、wolfCryptはrealloc（）も使用します。

デフォルトでは、wolfSSL/wolfCryptは、通常の整数ライブラリを使用します。これは、かなりの動的メモリを使用します。 wolfSSLを構築する場合、FastMathライブラリのほうを有効にすることができます。こちらは通常速度も速く、暗号操作（すべてのスタック上）には動的メモリーを使用しません。 Fastmathを使う場合、wolfSSLはrealloc（）の実装を必要としません。 wolfSSLのSSL層はそのほかにもいくつかの処理で動的メモリを使用しているので、malloc（）とfree（）は依然として必要です。

通常の整数演算ライブラリとFastMathライブラリ間のリソース使用量（スタック/ヒープ）の比較のドキュメントを参照ご希望のかたはお知らせください。

FastMathを有効にするには、USE_FAST_MATHを定義し ./wolfcrypt/src/integer.cではなく ./wolfcrypt/src/tfm.cを使用します。 fastmathを使用するときはスタックメモリが大きいので、TFM_TIMING_RESISTANTも定義することをお勧めします。

標準のmalloc（）、free（）を、およびreallocの（）関数が利用できない場合、XMALLOC_USERを定義します。これによりターゲット環境依存のカスタムフックを　 ./wolfssl/wolfcrypt/types.h内に定義することができます。

XMALLOC_USERの使用方法の詳細については、wolfSSLマニュアルのセクション5.1.1.1を参照してください。

https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-5-portability.html

## 時計　　　　　　

Q：どういう場合にこのセクションが必要ですか？<br>
A：標準時間関数（time（）、gmtime（））が利用できない場合、またはカスタムクロックティック関数を指定する必要がある場合です。

デフォルトでは、wolfSSLは./wolfcrypt/src/asn.cで指定されているように、time（）、gmtime（）、およびValidateDate（）を使用します。これらは、XTIME、XGMTIME、XVALIDATE_DATEに抽象化されています。標準時刻関数、およびtime.hが使用できない場合、ユーザーはUSER_TIMEを定義できます。 USER_TIMEを定義した後、ユーザーは独自のXTIME、XGMTIME、およびXVALIDATE_DATE関数を定義できます。

wolfSSLは、クロックティック機能のデフォルトでtime（0）を使用します。これは、LowResTimer（）関数の内部の./src/internal.cにあります。

time（0）が望ましくない場合には、USER_TICKSを定義することでユーザー独自のclock tick関数を定義することができます。カスタム関数は秒の精度が必要ですが、EPOCHと相関させる必要はありません。 ./src/internal.cのLowResTimer（）関数を参照してください。


## C標準ライブラリ
Q：どういう場合このセクションが必要ですか？<br>
A：C標準ライブラリがない場合、またはカスタムライブラリを使用する場合です。

wolfSSLは、C標準ライブラリを使用しなくても、開発者がより高いレベルの移植性と柔軟性を得ることができます。そのようなとき、ユーザーはC標準のものの代わりに使用したい機能をマップする必要があります。

上のセクション2.8では、メモリ機能について説明しました。メモリ関数の抽象化に加えて、wolfSSLは文字列関数と数学関数も抽象化します。それぞれの関数は抽象化される関数の名前に対応してX<FUNC>の形で定義されます。

詳細については、wolfSSLマニュアルのセクション5.1をお読みください。

https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-5-portability.html

## ロギング
Q：どういう場合このセクションが必要ですか？<br>
A：デバッグメッセージを有効にしたいが、stderrは使用できません。

デフォルトでは、wolfSSLはstderrを介してデバッグ出力を提供します。デバッグメッセージを有効にするには、wolfSSLをDEBUG_WOLFSSLでコンパイルし、wolfSSL_Debugging_ON（）をアプリケーションコードから呼び出す必要があります。 wolfSSL_Debugging_OFF（）は、アプリケーション層がwolfSSLデバッグメッセージをオフにするために使用できます。

stdderが利用できない環境や、デバッグメッセージを別の出力ストリームや別の形式で出力したい場合、wolfSSLではアプリケーションはロギングコールバックに登録できます。

詳細については、wolfSSLマニュアルの第8.1節をお読みください。

https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-8-debugging.html

## 公開鍵演算

Q：どういう場合このセクションが必要ですか？<br>

A：wolfSSLで独自の公開鍵実装を使用したいとします。

wolfSSLを使用すると、SSL / TLS層が公開鍵操作を行う必要があるときに呼び出される独自の公開鍵コールバックをユーザーが書くことができます。ユーザーはオプションで6つの関数を定義できます。

- ECC符号コールバック
- ECC検証コールバック
- RSA署名コールバック
- RSA検証コールバック
- RSA暗号化コールバック
- RSA復号化コールバック

詳細は、wolfSSLマニュアルのセクション6.4を参照してください。

https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-6-callbacks.html

## アトミックレコード層処理

Q：どういう場合このセクションが必要ですか？<br>
A：TLSレコード層の独自の処理、特にMAC /暗号化と解読/検証操作を行いたい場合です。

デフォルトでは、wolfSSLは、暗号化ライブラリwolfCryptを使用して、ユーザーのTLSレコード層処理を処理します。 wolfSSLは、MAC /暗号化をより詳細に制御し、SSL / TLS接続を復号/検証したい場合、アトミックレコード処理コールバックを使用します。

ユーザーは2つの関数を定義する必要があります：

MAC /暗号化コールバック関数
コールバック関数の復号化/検証

詳細は、wolfSSLマニュアルのセクション6.3を参照してください。

https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-6-callbacks.html

## 機能

Q：どういう場合このセクションが必要ですか？<br>
A：機能を無効にする場合。

適切な定義を使用してwolfSSLをビルドするとき、機能を無効にすることができます。利用可能な定義のリストについては、wolfSSL Manualの第2章を参照してください。

https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html
