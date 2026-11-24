# 移植性

## 抽象化レイヤー

### C標準ライブラリ抽象化レイヤー

wolfSSL（旧称CyaSSL）はC標準ライブラリなしでビルドでき、開発者へより高いレベルの移植性と柔軟性を提供します。
ユーザーは、C標準の代わりに使用したい関数をマッピングする必要があります。

#### メモリ使用

ほとんどのCプログラムは動的メモリ割り当てに`malloc()`と`free()`を使用します。
wolfSSLは、代わりに`XMALLOC()`と`XFREE()`を使用します。
デフォルトでは、これらはCランタイムバージョンを指します。
`XMALLOC_USER`を定義することで、ユーザーは独自のフックを提供できます。
各メモリ関数は標準的なものに加えて、ヒープヒントと割り当てタイプという2つの追加引数を取ります。
ユーザーはこれらを無視するか、好きな方法で使用できます。
wolfSSLのメモリ関数は`wolfssl/wolfcrypt/types.h`にあります。

wolfSSLはコンパイル時ではなく実行時に、メモリオーバーライド関数を登録する機能も提供します。
`wolfssl/wolfcrypt/memory.h`はこの機能のヘッダーであり、ユーザーは以下の関数を呼び出してメモリ関数を設定できます。

```c
int wolfSSL_SetAllocators(wolfSSL_Malloc_cb  malloc_function,
                         wolfSSL_Free_cb    free_function,
                         wolfSSL_Realloc_cb realloc_function);
```

詳しくは`wolfssl/wolfcrypt/memory.h`のコールバックプロトタイプと、`memory.c`の実装をご参照ください。
プロトタイプはビルドによって異なります。
デフォルトでは、`malloc()`、`free()`、`realloc()`と同じ形式です。
`WOLFSSL_STATIC_MEMORY`を定義すると、各コールバックはヒープヒントと割り当てタイプ（`void* heap, int type`）も引数に取ります。
`WOLFSSL_DEBUG_MEMORY`を定義すると、各コールバックは呼び出し元の関数名と行番号（`const char* func, unsigned int line`）も引数に取ります。
現在登録されている関数は、`wolfSSL_GetAllocators()`で取得できます。

ヒープを持たないシステムについては、[第4章 機能](chapter04.md)の「静的バッファ確保オプション」節で説明している静的メモリ機能（`WOLFSSL_STATIC_MEMORY`）をご参照ください。

#### string.h

wolfSSLは`string.h`の`memcpy()`、`memset()`、`memcmp()`などのように動作するいくつかの関数を使用します。
これらはそれぞれ`XMEMCPY()`、`XMEMSET()`、`XMEMCMP()`として抽象化されています。
デフォルトでは、それらはC標準ライブラリのバージョンを指しています。
[`STRING_USER`](chapter02.md#string_user)を定義することで、ユーザーは`types.h`で独自のフックを提供できます。
`STRING_USER`を定義すると、`types.h`は文字列マクロを一切定義しないため、ユーザーは`XMEMCPY`、`XMEMSET`、`XMEMCMP`、`XMEMMOVE`、`XSTRLEN`、`XSTRNCPY`、`XSTRSTR`、`XSTRNSTR`、`XSTRCMP`、`XSTRNCMP`、`XSTRNCAT`、`XSTRCASECMP`、`XSTRNCASECMP`、`XSTRTOK`、`XSTRSEP`、`XSNPRINTF`、`XSPRINTF`のすべてを用意する必要があります。
`XATOI`が定義されていない場合は`<stdlib.h>`の`atoi()`が使用されますが、これは`XATOI`を必要とする機能に限られます。
例えば、デフォルトでは`XMEMCPY()`は次の通りです。

```c
#define XMEMCPY(d,s,l)    memcpy((d),(s),(l))
```

`STRING_USER`を定義した後、別途用意したバージョン`my_memcpy()`を指すように設定するには以下のようにします。

```c
#define XMEMCPY(d,s,l)    my_memcpy((d),(s),(l))
```

あるいは、マクロの代わりに`XMEMCPY`という名前の関数を実装し、wolfSSLから参照できる場所（例えば`user_settings.h`）で宣言することもできます。

```c
extern void* XMEMCPY(void* d, const void* s, size_t n);
```

wolfSSLは常に`XMEMCPY()`を呼び出すため、`my_memcpy()`のような別の名前の関数は、上記のようにマクロで`XMEMCPY()`をその関数に対応付けた場合にのみ使用されます。

#### math.h

wolfSSLは`math.h`の`pow()`と`log()`のように動作する2つの関数を使用します。
これらはDiffie-Hellmanでのみ必要とするため、ビルドからDHを除外すれば、独自のものを提供する必要はありません。
これらは`XPOW()`と`XLOG()`として抽象化され、`wolfcrypt/src/dh.c`にあります。
`USER_MATH_LIB`を定義すると独自の`XPOW()`と`XLOG()`を提供でき、[`WOLFSSL_DH_CONST`](chapter02.md#wolfssl_dh_const)を定義するとこれらの関数自体が不要になります。

#### ファイルシステムの使用

デフォルトでは、wolfSSLは鍵と証明書をロードするためにシステムのファイルシステムを使用します。
これは[`NO_FILESYSTEM`](chapter02.md#no_filesystem)を定義することでオフにできます。
代わりに、システムが提供するものとは別のファイルシステムを使用したい場合、`wolfssl/wolfcrypt/wc_port.h`のFILESYSTEM SECTIONにある`XFILE`/`XFOPEN`/`XFREAD`/...の抽象化レイヤーを使用して、ファイルシステム呼び出しを使用したいものに向けることができます。
詳細は同ファイル内の`MICRIUM`の定義で提供される実装例をご参照ください。
`WOLFSSL_USER_FILESYSTEM`を定義すると、これらの定義をすべて独自に（例えば`user_settings.h`で）用意できます。

### カスタム入出力抽象化レイヤー

wolfSSLは、SSL接続のI/Oをより高度に制御したい、あるいはTCP/IP以外の異なる転送媒体の上でSSLを実行したい場合のために、カスタムI/O抽象化レイヤーを提供します。

ユーザーは2つの関数を定義する必要があります。

1. ネットワーク送信関数
2. ネットワーク受信関数

これら2つの関数は`wolfssl/wolfio.h`の`CallbackIOSend`と`CallbackIORecv`でプロトタイプ化されています。

```c
typedef int (*CallbackIORecv)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
typedef int (*CallbackIOSend)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
```

ユーザーは、`WOLFSSL_CTX`ごとに`wolfSSL_CTX_SetIOSend()`と`wolfSSL_CTX_SetIORecv()`を使って、あるいは`WOLFSSL`オブジェクトごとに`wolfSSL_SSLSetIOSend()`と`wolfSSL_SSLSetIORecv()`を使って、これらの関数を登録する必要があります。
旧名称の`wolfSSL_SetIOSend()`と`wolfSSL_SetIORecv()`は、`WOLFSSL_CTX`用の関数の非推奨のエイリアスです。
デフォルトの場合、`EmbedReceive()`と`EmbedSend()`は`WOLFSSL_CTX`の作成時（`src/internal.c`の`InitSSL_Ctx()`）に登録されます。
例えば、独自の関数を登録するには次のようにします。

```c
int myRecv(WOLFSSL* ssl, char* buf, int sz, void* ctx);
int mySend(WOLFSSL* ssl, char* buf, int sz, void* ctx);

wolfSSL_CTX_SetIORecv(ctx, myRecv);
wolfSSL_CTX_SetIOSend(ctx, mySend);
```

ユーザーは`src/wolfio.c`に実装されている`wolfSSL_SetIOWriteCtx()`と`wolfSSL_SetIOReadCtx()`を使用して、WOLFSSLオブジェクト（セッション）ごとにコンテキストを設定できます。
例えば、ユーザーがメモリバッファを使用している場合、コンテキストはメモリバッファの場所とアクセス方法を記述する構造体へのポインタかもしれません。
ユーザーによるオーバーライドがない場合、ソケットをコンテキストとして登録します。

受信コールバックは`buf`に格納したバイト数を返し、送信コールバックは`buf`から送信したバイト数を返します。
失敗した場合、またはまだデータを転送できない場合、コールバックは`wolfssl/error-ssl.h`の`enum IOerrors`にある次のいずれかの値を返します。

| 戻り値 | 意味 |
| --- | --- |
| `WOLFSSL_CBIO_ERR_GENERAL` (-1) | 一般的な予期しないエラー |
| `WOLFSSL_CBIO_ERR_WANT_READ` (-2) | ノンブロッキング: まだ読み取れるデータがないため、readを再度呼び出す必要があります |
| `WOLFSSL_CBIO_ERR_WANT_WRITE` (-2) | ノンブロッキング: まだデータを送信できないため、writeを再度呼び出す必要があります |
| `WOLFSSL_CBIO_ERR_CONN_RST` (-3) | 接続がリセットされました |
| `WOLFSSL_CBIO_ERR_ISR` (-4) | 割り込み |
| `WOLFSSL_CBIO_ERR_CONN_CLOSE` (-5) | 接続がクローズされたか、EPIPE |
| `WOLFSSL_CBIO_ERR_TIMEOUT` (-6) | ソケットのタイムアウト |

`src/wolfio.c`にあるデフォルトの`Send()`および`Receive()`関数である`EmbedSend()`と`EmbedReceive()`（プロトタイプは`wolfssl/wolfio.h`）は、テンプレートやガイドとして使用できます。
シンプルなメモリベースの例については、`examples/tls13/tls13_memio.c`の`mem_send()`と`mem_recv()`をご参照ください。

`WOLFSSL_USER_IO`を定義すると、デフォルトのI/O関数`EmbedSend()`と`EmbedReceive()`の自動設定を削除できます。

### オペレーティングシステム抽象化レイヤー

wolfSSL OS抽象化レイヤーは、wolfSSLをユーザーのオペレーティングシステムに移植しやすくします。
`wolfssl/wolfcrypt/settings.h`には、OS抽象化レイヤーを起動する設定が含まれています。

OS固有のスレッド、ミューテックス、ファイルシステム、時刻の抽象化は、`wolfssl/wolfcrypt/wc_port.h`と`wolfcrypt/src/wc_port.c`にあります。
メモリと文字列のマクロは`wolfssl/wolfcrypt/types.h`にあります。
wolfSSLを新しいプラットフォームに移植するための手順ガイドについては、[付録J wolfSSL 移植ガイド](appendix10.md)をご参照ください。

## サポートしているオペレーティングシステム

wolfSSLを定義する1つの要因は、新しいプラットフォームに簡単に移植される能力です。
そのため、wolfSSLは数多くのオペレーティングシステムをそのままの状態（out-of-the-box）でサポートしています。
現在サポートしているオペレーティングシステムは、次の通りです。

* Win32/64
* Linux
* macOS
* Solaris
* ThreadX
* VxWorks
* FreeBSD
* NetBSD
* OpenBSD
* embedded Linux
* Yocto Linux
* OpenEmbedded
* WinCE
* Haiku
* OpenWRT
* iPhone (iOS)
* Android
* Nintendo Wii/Gamecube（DevKitPro経由）
* QNX
* MontaVista
* NonStop
* TRON/ITRON/uITRON
* Micrium uC/OS-III
* FreeRTOS
* SafeRTOS
* NXP/Freescale MQX
* Nucleus
* TinyOS
* HP/UX
* AIX
* ARC MQX
* TI-RTOS
* uTasker
* embOS
* INtime
* Mbed
* uT-Kernel
* RIOT
* CMSIS-RTOS
* FROSTED
* Green Hills INTEGRITY
* Keil RTX
* TOPPERS
* PetaLinux
* Apache Mynewt
* Zephyr
* Espressif ESP-IDF
* Linuxカーネルモジュール（`linuxkm/`）
* FreeBSDカーネルモジュール（`bsdkm/`）
* Azure Sphere
* Deos
* Telit M2MB
* ChibiOS
* NET+OS
* Intel SGX
* Arduino
* Raspberry Pi Pico

## サポートしているチップメーカー

wolfSSLはARM、Intel、Motorola、mbed、Freescale、Microchip（PIC32、ATECC）、STMicro（STM32）、NXP、Analog Devices（Maxim）、Texas Instruments、AMD（Xilinx）、Espressif、Renesas、Infineon（Cypress）、Silicon Labs、Nordic、Nuvoton、Realtek、Altera、Raspberry Piなどのチップセットをサポートしています。
ハードウェア固有のポートは`wolfcrypt/src/port/`にあります。

## C#ラッパー

wolfSSLは、制限付きですがC#での使用をサポートしています。
ポートを含むVisual Studioプロジェクトは、`root_wolfSSL/wrapper/CSharp/`にあります。
Visual Studioプロジェクトを開いた後、ビルド -> 構成マネージャーをクリックして「アクティブソリューション構成」と「アクティブソリューションプラットフォーム」を設定します。
サポートしているアクティブソリューション構成はDLLデバッグとDLLリリースです。
サポートされているプラットフォームはWin32およびx64です。

ソリューション`wrapper/CSharp/wolfSSL_CSharp.sln`は`wrapper/CSharp/user_settings.h`を使用してwolfSSLをビルドする（プロジェクトで`WOLFSSL_USER_SETTINGS`を定義している）ため、プリプロセッサフラグを追加する必要はありません。

その後、ビルドするには「ソリューションのビルド」を選択するだけです。
これにより`wolfssl.dll`、`wolfSSL_CSharp.dll`およびサンプルプログラムが作成されます。
サンプルプログラムは、それらをスタートアッププロジェクトに設定し、Visual Studioでデバッグを実行することで実行できます。

Linuxでは、Monoでラッパーを使用できます。
`wrapper/CSharp/user_settings.h`をwolfSSLのルートディレクトリにコピーし、`./configure --enable-usersettings`でwolfSSLをビルドしてインストールした後、`mcs`でラッパーとサンプルプログラムをコンパイルします。
詳しい手順については`wrapper/CSharp/README.md`をご参照ください。

作成されたC#ラッパーをC#プロジェクトに追加するには、いくつかの方法があります。
1つは、作成された`wolfssl.dll`と`wolfSSL_CSharp.dll`をディレクトリ`C:/Windows/System/`にインストールすることです。
これにより、次のようなコードを持つプロジェクトから、wolfSSL C#ラッパーを呼び出せるようになります。

```cs
using wolfSSL.CSharp;

public class SomeClass {

    public static void Main() {
        wolfssl.Init();
        ...
    }
    ...
}
```

もう1つの方法は、Visual Studioプロジェクトを作成し、wolfSSLにバンドルされているC#ラッパーソリューションを参照することです。
