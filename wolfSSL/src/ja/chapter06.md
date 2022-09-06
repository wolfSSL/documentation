

# コールバック




## ハンドシェイクコールバック



wolfSSL(以前のCyassl)には、ハンドシェイクコールバックが接続または待受に設定できるようにする拡張子があります。これは、別のデバッガが利用できず、スニッフィングが実用的でない場合に、組み込みシステムでのデバックに役立ちます。wolfSSLハンドシェイクコールバックを使用するには、拡張機能、[`wolfSSL_connect_ex()`](ssl_8h.md#function_wolfssl_connect_ex)および[`wolfSSL_accept_ex()`](ssl_8h.md#function-wolfssl_accept_ex)を使用します。



```c
int wolfSSL_connect_ex(WOLFSSL*, HandShakeCallBack, TimeoutCallBack,
                       Timeval)
int wolfSSL_accept_ex(WOLFSSL*, HandShakeCallBack, TimeoutCallBack,
                      Timeval)
```



`HandShakeCallBack`は次のように定義されています。



```c
typedef int (*HandShakeCallBack)(HandShakeInfo*);
```



`HandShakeInfo`は`wolfssl/callbacks.h`で定義されています(標準以外のビルドに追加する必要があります)：



```c
typedef struct handShakeInfo_st {
    char   cipherName[MAX_CIPHERNAME_SZ + 1];  /*negotiated name */
    char   packetNames[MAX_PACKETS_HANDSHAKE][MAX_PACKETNAME_SZ+1];
                                          /* SSL packet names */
    int    numberPackets;                 /*actual # of packets  */
    int    negotiationError;              /*cipher/parameter err */
} HandShakeInfo;
```



ハンドシェーク中のSSLパケットの最大数がわかっているため、動的メモリは使用されません。パケット名は`numberPackets`から`numberPackets`までにアクセスできます。コールバックは、ハンドシェイクエラーが発生したかどうかを呼び出します。例の使用法もクライアントの例にあります。



## タイムアウトコールバック



wolfSSLハンドシェイクコールバックで使用されているのと同じ拡張機能をwolfSSLタイムアウトコールバックにも使用できます。これらの拡張機能は、両方、またはコールバック(ハンドシェイクおよび/またはタイムアウト)で呼び出すことができます。`TimeoutCallback`は次のように定義されています。



```c
typedef int (*TimeoutCallBack)(TimeoutInfo*);
```



`TimeoutInfo`は次のようになります。



```c
typedef struct timeoutInfo_st {
    char       timeoutName[MAX_TIMEOUT_NAME_SZ +1]; /*timeout Name*/
    int        flags;                            /* for future use*/
    int        numberPackets;               /*actual # of packets */
    PacketInfo packets[MAX_PACKETS_HANDSHAKE];  /*list of packets */
    Timeval    timeoutValue;               /*timer that caused it */
} TimeoutInfo;
```



やはり、最大数のSSLパケットがハンドシェイクでわかっているので、この構造に動的メモリは使用されません。`Timeval`は、struct timevalのtypedefです。


`PacketInfo`は次のように定義されています。



```c
typedef struct packetInfo_st {
    char           packetName[MAX_PACKETNAME_SZ + 1]; /* SSL name */
    Timeval        timestamp;                  /* when it occured */
    unsigned char  value[MAX_VALUE_SZ];     /* if fits, it's here */
    unsigned char* bufferValue;         /* otherwise here (non 0) */
    int            valueSz;              /* sz of value or buffer */
} PacketInfo;
```



ここでは、動的メモリを用いてもよい。SSLパケットが`value`に収まることができる場合、それが配置されている場所です。`valueSz`は長さと`bufferValue`を保持します。パケットが`value`で大きすぎる場合は、**証明書**パケットのみがこれを引き起こすはずです.`valueSz`にはSIZEを保持します。


メモリが**証明書**パケットに割り当てられている場合、コールバックが戻ってきた後に再生されます。タイムアウトは、特に`SIGALRM`、特に`SIGALRM`を使用して実装され、スレッドセーフです。以前のアラームがタイプ`ITIMER_REAL`のセットである場合、その後、正しいハンドラーとともにリセットされます。古いタイマーは、wolfSSLが処理を支払う時期に時間調整されます。既存のタイマーが合格したタイマーよりも短い場合、既存のタイマー値が使用されます。その後はまだリセットされます。期限切れになる既存のタイマーは、それに関連付けられた間隔がある場合、リセットされます。コールバックは、タイムアウトが発生した場合にのみ発行されます。


使用法については[クライアントの例](chapter03.md#client-example)を参照してください。



## ユーザーアトミックレコードレイヤー処理



wolfSSLは、SSL/TLS接続中にMAC/暗号化、復号化/検証などの機能をより制御したユーザーにアトミックレコード処理コールバックを提供します。


ユーザーは2つの関数を定義する必要があります。



1. Mac/暗号化コールバック関数


2. 復号化/検証コールバック関数



これらの2つの関数は、`ssl.h`の`CallbackMacEncrypt`および`CallbackDecryptVerify`によってプロトタイプ化されています。



```c
typedef int (*CallbackMacEncrypt)(WOLFSSL* ssl,
    unsigned char* macOut,const unsigned char* macIn,
    unsigned int macInSz,int macContent, int macVerify,
    unsigned char* encOut, const unsigned char* encIn,
    unsigned int encSz,void* ctx);

typedef int (*CallbackDecryptVerify)(WOLFSSL* ssl,
    unsigned char* decOut, const unsigned char* decIn,
    unsigned int decSz, int content, int verify,
    unsigned int* padSz, void* ctx);
```



ユーザーは、[`wolfSSL_CTX_SetMacEncryptCb()`](ssl_8h.md#function-wolfssl_ctx_setmacencryptcb)および[`wolfSSL_CTX_SetDecryptVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setdecryptverifycb()でwolfSSLコンテキスト(`WOLFSSL_CTX`)ごとにこれらの機能を書いて登録する必要があります。


ユーザーは、[`wolfSSL_SetMacEncryptCtx()`](ssl_8h.md#function-wolfssl_setmacencryptctx)と[`wolfSSL_SetDecryptVerifyCtx()`](ssl_8h.md#function-wolfssl_setdecryptverifyctx)でwolfSSLオブジェクト(セッション)ごとにコンテキストを設定できます。このコンテキストは、ユーザー指定のコンテキストへのポインタであり得ます。これは次にMac/EncryptおよびDecrypt/Decrypt/Decrypt/Verify Callbacksに渡されます。`void* ctx`パラメータ。



1. コールバックの例は、`-U`コマンドラインオプションを使用する場合、`wolfssl/test.h`、`myMacEncryptCb()`および`myDecryptVerifyCb()`の下で、wolfSSLの例クライアント(`examples/client/client.c`)で使用できます。



Atomic Record Layer Callbacksを使用するには、wolfSSLを`--enable-atomicuser` Configureオプションを使用してコンパイルする必要があります。



## 公開キーのコールバック



wolfSSLは、SSL/TLS接続中にRSAの署名/検証機能をもっと多くの制御を希望するユーザーのための公開鍵コールバックを提供します。


ユーザーはオプションで7つの関数を定義できます。



1. ECCサインコールバック


2. ECCの確認コールバック


3. ECCはシークレットコールバックを共有しました


4. RSAサインコールバック


5. RSAはコールバックを検証します


6. RSA暗号化コールバック


7. RSA復号化コールバック



これら2つの機能は`ssl.h`に`CallbackRsaSign`,`CallbackEccVerify`,`CallbackRsaSign`,`CallbackRsaSign`,`CallbackRsaEnc`、`CallbackRsaEnc`、`CallbackRsaEnc`、`CallbackRsaSign`、`CallbackRsaEnc`、`CallbackRsaDec`、`CallbackRsaDec`、`CallbackRsaDec`



```c
typedef int (*CallbackEccSign)(WOLFSSL* ssl, const unsigned
        char* in, unsigned int inSz, unsigned char* out,
        unsigned int* outSz, const unsigned char* keyDer,
        unsigned int keySz, void* ctx);

typedef int (*CallbackEccVerify)(WOLFSSL* ssl,
    const unsigned char* sig, unsigned int sigSz,
    const unsigned char* hash, unsigned int hashSz,
    const unsigned char* keyDer, unsigned int keySz,
    int* result, void* ctx);

typedef int (*CallbackEccSharedSecret)(WOLFSSL* ssl,
        struct ecc_key* otherKey,
    unsigned char* pubKeyDer, unsigned int* pubKeySz,
    unsigned char* out, unsigned int* outlen,
    int side, void* ctx);

typedef int (*CallbackRsaSign)(WOLFSSL* ssl,
    const unsigned char* in, unsigned int inSz,
    unsigned char* out, unsigned int* outSz,
    const unsigned char* keyDer, unsigned int keySz,
    void* ctx);

typedef int (*CallbackRsaVerify)(WOLFSSL* ssl,
    unsigned char* sig, unsigned int sigSz,
    unsigned char** out, const unsigned char* keyDer,
    unsigned int keySz, void* ctx);

typedef int (*CallbackRsaEnc)(WOLFSSL* ssl,
    const unsigned char* in, unsigned int inSz,
    Unsigned char* out, unsigned int* outSz,
    const unsigned char* keyDer,
    unsigned int keySz, void* ctx);

typedef int (*CallbackRsaDec)(WOLFSSL* ssl, unsigned char* in,
    unsigned int inSz, unsigned char** out,
    const unsigned char* keyDer, unsigned int keySz,
    void* ctx);
```



ユーザーはwolfSSLコンテキストごとにこれらの機能を書いて登録する必要があります(`WOLFSSL_CTX`)。



* [`wolfSSL_CTX_SetEccSignCb()`](ssl_8h.md#function-wolfssl_ctx_seteccsigncb)


* [`wolfSSL_CTX_SetEccVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_seteccverifycb)


* `wolfSSL_CTX_SetEccSharedSecretCb()`


* [`wolfSSL_CTX_SetRsaSignCb()`](ssl_8h.md#function-wolfssl_ctx_setrsasigncb)


* [`wolfSSL_CTX_SetRsaVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaverifycb)


* [`wolfSSL_CTX_SetRsaEncCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaenccb)


* [`wolfSSL_CTX_SetRsaDecCb()`](ssl_8h.md#function-wolfssl_ctx_setrsadeccb)



ユーザーは、次のように`WOLFSSL`オブジェクト(セッション)ごとにコンテキストを設定できます。



* [`wolfSSL_SetEccSignCtx()`](ssl_8h.md#function-wolfssl_seteccsignctx)


* [`wolfSSL_SetEccVerifyCtx()`](ssl_8h.md#function-wolfssl_seteccverifyctx)


* `wolfSSL_SetEccSharedSecretCtx()`


* [`wolfSSL_SetRsaSignCtx()`](ssl_8h.md#function-wolfssl_setrsasignctx)


* [`wolfSSL_SetRsaVerifyCtx()`](ssl_8h.md#function-wolfssl_setrsaverifyctx)


* [`wolfSSL_SetRsaEncCtx()`](ssl_8h.md#function-wolfssl_setrsaencctx)


* [`wolfSSL_SetRsaDecCtx()`](ssl_8h.md#function-wolfssl_setrsadecctx)



これらのコンテキストは、ユーザー指定のコンテキストへのポインターである場合があります。これにより、`void* ctx`パラメーターを介してそれぞれの公開キーコールバックに渡されます。


コールバックの例は、`wolfssl/test.h`、`myEccSign()`、`myEccVerify()`、`myEccSharedSecret()`、`myRsaSign()`、`myRsaVerify()`、`myRsaEnc()`、および`myRsaDec()`に基づいて見つけることができます。

Atomic Record Layer Callbacksを使用するには、wolfSSLを[`--enable-pkcallbacks`](chapter02.md#--enable-pkcallbacks) Configureオプションを使用してコンパイルする必要があります。
