

# ポータビリティ




## 抽象化レイヤー




### C標準ライブラリ抽象化レイヤー



wolfSSL(以前のCyassl)は、C標準ライブラリなしでビルドして、開発者により高いレベルのポータビリティと柔軟性を提供することができます。ユーザーは、C標準の関数の代わりに使用したい関数をマッピングする必要があります。



#### メモリ使用



ほとんどのCプログラムは、動的メモリ割り当てに`malloc()`および`free()`を使用します。wolfSSLは、代わりに`XMALLOC()`および`XFREE()`を使用します。デフォルトでは、これらはCランタイムバージョンを指します。`XMALLOC_USER`を定義することにより、ユーザーは独自のフックを提供できます。各メモリ関数は、標準的なものについて2つの追加の引数、ヒープのヒント、および割り当てタイプを使用します。ユーザーは、これらを無視するか、好きな方法で使用できます。wolfSSLメモリ関数は`wolfssl/wolfcrypt/types.h`で見つけることができます。


wolfSSLは、コンパイル時ではなく実行時にメモリオーバーライド関数を登録する機能も提供します。`wolfssl/wolfcrypt/memory.h`はこの機能のヘッダーであり、ユーザーは次の関数を呼び出してメモリ関数をセットアップできます。



```c
int wolfSSL_SetAllocators(wolfSSL_Malloc_cb  malloc_function,
                         wolfSSL_Free_cb    free_function,
                         wolfSSL_Realloc_cb realloc_function);
```



コールバックプロトタイプについては、ヘッダー`wolfssl/wolfcrypt/memory.h`、実装については`memory.c`を参照してください。



#### string.h



wolfSSLは、`string.h`の`memcpy()`、`memset()`、および`memcmp()`のように振る舞ういくつかの機能を使用します。それらはそれぞれ`XMEMCPY()`、`XMEMSET()`、および`XMEMCMP()`に抽象化されています。デフォルトでは、C標準ライブラリバージョンを指します。`STRING_USER`を定義することで、ユーザーは`types.h`で独自のフックを提供できます。たとえば、デフォルトでは`XMEMCPY()`は次のとおりです。



```c
#define XMEMCPY(d,s,l)    memcpy((d),(s),(l))
```



`STRING_USER`を定義した後は、次のことができます。



```c
#define XMEMCPY(d,s,l)    my_memcpy((d),(s),(l))
```



またはマクロを避けたい場合：



```c
external void* my_memcpy(void* d, const void* s, size_t n);
```



あなたのバージョン`my_memcpy()`を指すようにwolfsslの抽象化レイヤーを設定する。



#### Math.H



wolfSSLは、`math.h`の`pow()` `log()`のように振る舞う2つの機能を使用しています。Difie-Hellmanのみが必要とするため、ビルドからDHを除外すると、独自のDHを提供する必要はありません。それらは`XPOW()`および`XLOG()`として`wolfcrypt/src/dh.c`に定義されます。



#### ファイルシステムの使用



デフォルトでは、wolfSSLはキーと証明書をロードするためにシステムのファイルシステムを使用します。`NO_FILESYSTEM`を定義することでオフにすることができます。代わりに項目Vを参照してください。Dが好きです。Micrium Defineによって提供される例を参照してください。



### カスタム入力/出力抽象化レイヤー



wolfSSLは、SSL接続のI/Oをより高く制御したい、またはTCP/IP以外の異なるトランスポートメディアの上にSSLを実行したい方のためのカスタムI/O抽象化レイヤを提供します。


ユーザーは2つの機能を定義する必要があります。



1. ネットワーク送信機能


2. ネットワークは機能を受信します



これらの2つの関数は、`ssl.h`の`CallbackIOSend`および`CallbackIORecv`によってプロトタイプ化されています。



```c
typedef int (*CallbackIORecv)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
typedef int (*CallbackIOSend)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
```



ユーザーは`WOLFSSL_CTX`ごとに`wolfSSL_SetIOSend()`および`wolfSSL_SetIORecv()`に登録する必要があります。たとえば、デフォルトの場合は、`CBIORecv()`と`CBIOSend()`は`io.c`の下部に登録されています。



```c
void wolfSSL_SetIORecv(WOLFSSL_CTX *ctx, CallbackIORecv CBIORecv)
{
     ctx->CBIORecv=CBIORecv;
}

void wolfSSL_SetIOSend(WOLFSSL_CTX *ctx, CallbackIOSend CBIOSend)
{
    ctx->CBIOSend=CBIOSend;
}
```



ユーザは、`io.c`の下部に示されているように、`wolfSSL_SetIOWriteCtx()`および`wolfSSL_SetIOReadCtx()`でwolfSSLオブジェクト(セッション)ごとにコンテキストを設定することができる。例えば、ユーザがメモリバッファを使用している場合、コンテキストはどこで説明を説明する構造へのポインタであり得る。メモリバッファにアクセスします。デフォルトの場合は、ユーザーが上書きしないで、ソケットをコンテキストとして登録します。


`CBIORecv`および`CBIOSend`関数ポインターは、カスタムI/O関数を指すことができます。`io.c`にあるデフォルトの`Send()`および`Receive()`関数、`EmbedSend()`および`EmbedReceive()`は、テンプレートとガイドとして使用できます。


`WOLFSSL_USER_IO`は、デフォルトのI/O関数`EmbedSend()`および`EmbedReceive()`の自動設定を削除するために定義できます。



### オペレーティングシステムの抽象化レイヤー



wolfSSL OS抽象化レイヤーは、ユーザーのオペレーティングシステムへのwolfSSLの簡単な移植を容易にするのに役立ちます。`wolfssl/wolfcrypt/settings.h`ファイルには、OSレイヤーをトリガーする設定が含まれています。


OS特有の定義は、WolfCryptおよびWolfsslの`wolfssl/internal.h`の`wolfssl/wolfcrypt/types.h`にあります。



## サポートされているオペレーティングシステム



wolfSSLを定義する1つの要因は、新しいプラットフォームに簡単に移植される能力です。そのため、wolfsslは、out-of-box のオペレーティングシステムの多くをサポートしています。現在サポートされているオペレーティングシステムは次のとおりです。



* Win32/64


* Linux.


* Mac OS X


* Solaris


* ThreadX


* VxWorks


* FreeBSD


* NetBSD


* OpenBSD


* 埋め込まれたLinux

* embedded Linux

* yocto linux


* OpenEmbedded


* WinCE


* Haiku


* OpenWRT


* iPhone(iOS)


* Android


* Nintendo Wii と Gamecube through DevKitPro


* QNX



* モンタヴィスタ


* ノンストップ

* TRON/ITRON/µITRON

* トロン/ ITRON /μITRON


* Micrium's µC/OS-III


* FreeRTOS


* SafeRTOS


* NXP/フリースケールMQX

* NXP/Freescale MQX

* 核


* tinyos


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



* グリーンヒルズの完全性


* keil RTX


* TOPPERS



* Petalinux


* Apache Mynewt




## サポートされたチップメーカー



wolfSSLは、ARM、Intel、Motorola、MBED、Freescale、Microchip(PIC32)、STMicro(STM32F2/F4)、NXP、Analog Devices、Texas Instruments、AMDなどを含むチップセットをサポートしています。



## C＃ラッパー



wolfSSLは、制限付きですがC＃での使用をサポートしています。ポートを含むビジュアルスタジオプロジェクトは、ディレクトリ`root_wolfSSL/wrapper/CSharp/`にあります。ビジュアルスタジオプロジェクトを開いた後、ビルド -  \>構成マネージャーをクリックして「アクティブソリューション構成」と「アクティブソリューションプラットフォーム」を設定します。」はDLLデバッグとDLLリリースです。サポートされているプラットフォームはWin32およびX64です。


ソリューションとプラットフォームを設定したら、プリプロセッサフラグ`HAVE_CSHARP`を追加する必要があります。これにより、C＃ラッパーで使用され、例で使用されるオプションがオンになります。


その後、ビルドするだけでビルドソリューションを選択します。これにより、`wolfssl.dll`、`wolfSSL_CSharp.dll`および例が作成されます。例は、それらをエントリポイントとしてターゲットにして、Visual Studioでデバッグを実行することで実行できます。


作成されたC＃ラッパーをC＃プロジェクトに追加することは、いくつかの方法で実行できます。1つの方法は、作成された`wolfssl.dll`および`wolfSSL_CSharp.dll`をディレクトリ`C:/Windows/System/`にインストールすることです。これにより、Wolfssl C＃ラッパーの呼び出しが可能になります。



```cs
using wolfSSL.CSharp

public some_class {

    public static main(){
    wolfssl.Init()
    ...
}
...
```


Wolfssl C＃ラッパーに電話をかける。別の方法は、Visual Studioプロジェクトを作成し、wolfSSLのバンドルC＃ラッパーソリューションを参照することです。
