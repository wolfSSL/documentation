# 移植性

## 抽象化レイヤー

### C標準ライブラリ抽象化レイヤー

wolfSSLはC標準ライブラリなしでビルドでき、開発者へより高いレベルの移植性と柔軟性を提供します。
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

#### string.h

wolfSSLは`string.h`の`memcpy()`、`memset()`、`memcmp()`などのように動作するいくつかの関数を使用します。
これらはそれぞれ`XMEMCPY()`、`XMEMSET()`、`XMEMCMP()`として抽象化されています。
デフォルトでは、それらはC標準ライブラリのバージョンを指しています。
`STRING_USER`を定義することで、ユーザーは`types.h`で独自のフックを提供できます。
例えば、デフォルトでは`XMEMCPY()`は次の通りです。

```c
#define XMEMCPY(d,s,l)    memcpy((d),(s),(l))
```

`STRING_USER`を定義した後、別途用意したバージョン`my_memcpy()`を指すように設定するには以下のようにします。

```c
#define XMEMCPY(d,s,l)    my_memcpy((d),(s),(l))
```

マクロを避けたい場合、次のように示すこともできます。

```c
external void* my_memcpy(void* d, const void* s, size_t n);
```

#### math.h

wolfSSLは`math.h`の`pow()`と`log()`のように動作する2つの関数を使用します。
これらはDiffie-Hellmanでのみ必要とするため、ビルドからDHを除外すれば、独自のものを提供する必要はありません。
これらは`XPOW()`と`XLOG()`として抽象化され、`wolfcrypt/src/dh.c`にあります。

#### ファイルシステムの使用

デフォルトでは、wolfSSLは鍵と証明書をロードするためにシステムのファイルシステムを使用します。
これは`NO_FILESYSTEM`を定義することでオフにできます。
代わりに、システムが提供するものとは別のファイルシステムを使用したい場合、`ssl.c`の`XFILE()`レイヤーを使用して、ファイルシステム呼び出しを使用したいものに向けることができます。
詳細はMICRIUMの定義で提供される実装例をご参照ください。

### カスタム入出力抽象化レイヤー

wolfSSLは、SSL接続のI/Oをより高度に制御したい、あるいはTCP/IP以外の異なる転送媒体の上でSSLを実行したい場合のために、カスタムI/O抽象化レイヤーを提供します。

ユーザーは2つの関数を定義する必要があります。

1. ネットワーク送信関数
2. ネットワーク受信関数

これら2つの関数は`ssl.h`の`CallbackIOSend`と`CallbackIORecv`でプロトタイプ化されています。

```c
typedef int (*CallbackIORecv)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
typedef int (*CallbackIOSend)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
```

ユーザーは`WOLFSSL_CTX`ごとに、`wolfSSL_SetIOSend()`と`wolfSSL_SetIORecv()`を使ってこれらの関数を登録する必要があります。
例えばデフォルトの場合、`CBIORecv()`と`CBIOSend()`は`io.c`の最後に登録されています。

```c
void wolfSSL_SetIORecv(WOLFSSL_CTX *ctx, CallbackIORecv CBIORecv)
{
     ctx->CBIORecv = CBIORecv;
}

void wolfSSL_SetIOSend(WOLFSSL_CTX *ctx, CallbackIOSend CBIOSend)
{
    ctx->CBIOSend = CBIOSend;
}
```

ユーザーは`io.c`の最後で示されているように、`wolfSSL_SetIOWriteCtx()`と`wolfSSL_SetIOReadCtx()`を使用して、WOLFSSLオブジェクト（セッション）ごとにコンテキストを設定できます。
例えば、ユーザーがメモリバッファを使用している場合、コンテキストはメモリバッファへのアクセス方法を説明する構造体へのポインタかもしれません。
ユーザーによるオーバーライドがない場合、ソケットをコンテキストとして登録します。

`CBIORecv`と`CBIOSend`関数ポインタは、カスタムI/O関数を指すことができます。
`io.c`にあるデフォルトの`Send()`および`Receive()`関数である`EmbedSend()`と`EmbedReceive()`は、テンプレートやガイドとして使用できます。

`WOLFSSL_USER_IO`を定義すると、デフォルトのI/O関数`EmbedSend()`と`EmbedReceive()`の自動設定を削除できます。

### オペレーティングシステム抽象化レイヤー

wolfSSL OS抽象化レイヤーは、wolfSSLをユーザーのオペレーティングシステムに移植しやすくします。
`wolfssl/wolfcrypt/settings.h`には、OS抽象化レイヤーを起動する設定が含まれています。

OS固有の定義は、wolfCryptの場合`wolfssl/wolfcrypt/types.h`に、wolfSSLの場合`wolfssl/internal.h`にあります。

## サポートしているオペレーティングシステム

wolfSSLを定義する1つの要因は、新しいプラットフォームに簡単に移植される能力です。
そのため、wolfsslは、out-of-box のオペレーティングシステムの多くをサポートしています。
現在サポートしているオペレーティングシステムは、次の通りです。

* Win32/64
* Linux
* Mac OS X
* Solaris
* ThreadX
* VxWorks
* FreeBSD
* NetBSD
* OpenBSD
* Embedded Linux
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
* TRON/ITRON/µITRON
* Micrium µC/OS-III
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
* µT-Kernel
* RIOT
* CMSIS-RTOS
* FROSTED
* Green Hills INTEGRITY
* Keil RTX
* TOPPERS
* PetaLinux
* Apache Mynewt

## サポートしているチップメーカー

wolfSSLはARM、Intel、Motorola、mbed、Freescale、Microchip（PIC32）、STMicro（STM32F2/F4）、NXP、Analog Devices、Texas Instruments、AMDなどのチップセットをサポートしています。

## C#ラッパー

wolfSSLは、制限付きですがC#での使用をサポートしています。
ポートを含むVisual Studioプロジェクトは、`root_wolfSSL/wrapper/CSharp/`にあります。
Visual Studioプロジェクトを開いた後、ビルド -> 構成マネージャーをクリックして「アクティブソリューション構成」と「アクティブソリューションプラットフォーム」を設定します。
サポートしているアクティブソリューション構成はDLLデバッグとDLLリリースです。
サポートされているプラットフォームはWin32およびx64です。

ソリューションとプラットフォームを設定したら、プリプロセッサフラグ`HAVE_CSHARP`を追加する必要があります。
これにより、C#ラッパー及びサンプルプログラムで使用されるオプションがオンになります。

その後、ビルドするだけでソリューションをビルドを選択します。
これにより`wolfssl.dll`、`wolfSSL_CSharp.dll`および例が作成されます。
サンプルプログラムは、それらをエントリポイントとしてターゲットにして、Visual Studioでデバッグを実行することで実行できます。

作成されたC#ラッパーをC#プロジェクトに追加するには、いくつかの方法があります。
1つは、作成された`wolfssl.dll`と`wolfSSL_CSharp.dll`をディレクトリ`C:/Windows/System/`にインストールすることです。

```cs
using wolfSSL.CSharp

public some_class {

    public static main(){
    wolfssl.Init()
    ...
}
...
```

これにより、wolfSSL C#ラッパーへの呼び出しができるようになります。

もう1つの方法は、Visual Studioプロジェクトを作成し、wolfSSLにバンドルされているC#ラッパーソリューションを参照することです。
