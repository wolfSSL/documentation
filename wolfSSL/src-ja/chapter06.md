# コールバック

## ハンドシェイクコールバック

wolfSSLには、`connect`または`accept`のためのハンドシェイクコールバックを設定できる拡張機能があります。
これは、別のデバッガーが利用できず、スニッフィングが現実的でない場合に、組み込みシステムでのデバッグサポートに役立ちます。
wolfSSLハンドシェイクコールバックを使用するには、拡張関数[`wolfSSL_connect_ex()`](ssl_8h.md#function-wolfssl_connect_ex)と[`wolfSSL_accept_ex()`](ssl_8h.md#function-wolfssl_accept_ex)を使用します。

```c
int wolfSSL_connect_ex(WOLFSSL* ssl, HandShakeCallBack hsCb,
                       TimeoutCallBack toCb, WOLFSSL_TIMEVAL timeout);
int wolfSSL_accept_ex(WOLFSSL* ssl, HandShakeCallBack hsCb,
                      TimeoutCallBack toCb, WOLFSSL_TIMEVAL timeout);
```

これらの関数と`wolfssl/callbacks.h`は、wolfSSLを[`WOLFSSL_CALLBACKS`](chapter02.md#wolfssl_callbacks)を定義してビルドした場合にのみ利用できます。
このマクロに対応する設定オプションはないため、`CFLAGS`を使用して追加してください。

```sh
./configure CFLAGS="-DWOLFSSL_CALLBACKS"
```

`WOLFSSL_CALLBACKS`を定義すると、`LARGE_STATIC_BUFFERS`も強制的に有効になります。
タイムアウトにはPOSIXの`setitimer()`と`SIGALRM`インターフェースを使用します（「タイムアウトコールバック」節をご参照ください）。

`HandShakeCallBack`は次のように定義されています。

```c
typedef int (*HandShakeCallBack)(HandShakeInfo*);
```

`HandShakeInfo`は`wolfssl/callbacks.h`（非標準ビルドに追加される必要があります）で定義されています。

```c
typedef struct handShakeInfo_st {
    struct WOLFSSL* ssl;
    char   cipherName[MAX_CIPHERNAME_SZ + 1];    /* negotiated cipher */
    char   packetNames[MAX_PACKETS_HANDSHAKE][MAX_PACKETNAME_SZ + 1];
                                                 /* SSL packet names  */
    int    numberPackets;                        /* actual # of packets */
    int    negotiationError;                     /* cipher/parameter err */
} HandShakeInfo;
```

`ssl`メンバーは、そのコールバックが呼び出された接続を指します。
ハンドシェイク交換での最大SSLパケット数は既知であるため、動的メモリは使用されません。
パケット名は`packetNames[idx]`で`numberPackets`まで参照できます。
コールバックは、ハンドシェイクエラーが発生したかどうかに関係なく呼び出されます。
実装例はクライアントのサンプルプログラムに掲載しています。

## タイムアウトコールバック

wolfSSLハンドシェイクコールバックで使用する拡張機能は、wolfSSLタイムアウトコールバックにも使用できます。
これらの拡張機能は、コールバック（ハンドシェイクやタイムアウト）のいずれか、両方、またはどちらも使用せずに使用できます。
`TimeoutCallBack`は、次のように定義されています。

```c
typedef int (*TimeoutCallBack)(TimeoutInfo*);
```

`TimeoutInfo`は次のようになっています。

```c
typedef struct timeoutInfo_st {
    char       timeoutName[MAX_TIMEOUT_NAME_SZ + 1]; /* timeout Name */
    int        flags;                              /* for future use */
    int        numberPackets;                      /* actual # of packets */
    PacketInfo packets[MAX_PACKETS_HANDSHAKE];     /* list of all packets  */
    WOLFSSL_TIMEVAL timeoutValue;                  /* timer that caused it */
} TimeoutInfo;
```

ハンドシェイクに対する最大SSLパケット数が分かっているため、ここでもこの構造体に動的メモリは使用されません。
`WOLFSSL_TIMEVAL`は、`<sys/time.h>`が利用可能な場合（`HAVE_SYS_TIME_H`）は`struct timeval`のtypedefであり、それ以外の場合は`tv_sec`と`tv_usec`メンバーを持つ同等の構造体です。
従来の名前である`Timeval`は、`NO_OLD_TIMEVAL_NAME`が定義されていない限り、`WOLFSSL_TIMEVAL`のマクロエイリアスとして残されています。

`PacketInfo`は次のように定義されています。

```c
typedef struct packetInfo_st {
    char           packetName[MAX_PACKETNAME_SZ + 1]; /* SSL packet name */
    WOLFSSL_TIMEVAL timestamp;                       /* when it occurred    */
    unsigned char  value[MAX_VALUE_SZ];             /* if fits, it's here */
    unsigned char* bufferValue;                     /* otherwise here (non 0) */
    int            valueSz;                         /* sz of value or buffer */
} PacketInfo;
```

ここでは、動的メモリが使用される場合があります。
SSLパケットが`value`に収まる場合は、そこに配置されます。
`valueSz`は長さを保持し、`bufferValue`は0です。
パケットが`value`にとって大きすぎる場合（これは**Certificate**パケットでのみ発生するはずです）、パケットは`bufferValue`に配置されます。
この場合も`valueSz`はサイズを保持します。

**Certificate**パケットのためにメモリが割り当てられると、コールバックが戻った後に回収されます。
タイムアウトはシグナル、特に`SIGALRM`を使用して実装され、スレッドセーフです。
`ITIMER_REAL`タイプの以前のアラームが設定されている場合、その後、正しいハンドラとともにリセットされます。
古いタイマーは、wolfSSLの処理にかかる時間に合わせて時間調整されます。
既存のタイマーが渡されたタイマーよりも短い場合、既存のタイマー値が使用されます。
それでも後でリセットされます。
期限切れとなる既存のタイマーは、間隔が関連付けられている場合はリセットされます。
コールバックはタイムアウトが発生した場合にのみ実行されます。

使用例については、[第3章 入門](chapter03.md)の「クライアントサンプルプログラム」節をご参照ください。

## ユーザーアトミックレコードレイヤー処理

wolfSSLは、SSL/TLS接続中にMAC/暗号化/復号/検証機能をより詳細に制御したいユーザー向けに、アトミックレコード処理コールバックを提供します。

ユーザーは2つの関数を定義する必要があります。

1. MAC/暗号化コールバック関数
2. 復号/検証コールバック関数

これら2つの関数は`ssl.h`の`CallbackMacEncrypt`と`CallbackDecryptVerify`でプロトタイプ化されています。

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

ユーザーはこれらの関数を作成し、[`wolfSSL_CTX_SetMacEncryptCb()`](ssl_8h.md#function-wolfssl_ctx_setmacencryptcb)と[`wolfSSL_CTX_SetDecryptVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setdecryptverifycb)でwolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに登録する必要があります。

ユーザーは[`wolfSSL_SetMacEncryptCtx()`](ssl_8h.md#function-wolfssl_setmacencryptctx)と[`wolfSSL_SetDecryptVerifyCtx()`](ssl_8h.md#function-wolfssl_setdecryptverifyctx)で`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。
このコンテキストは、ユーザー指定のコンテキストへのポインタであり、`void* ctx`パラメータを通じてMAC/暗号化/復号/検証コールバックに返されます。

コールバックの実装例は、`wolfssl/test.h`の`myMacEncryptCb()`と`myDecryptVerifyCb()`に掲載しています。
使用例は、wolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で`-U`コマンドラインオプションを使用することで見ることができます。

### Encrypt-Then-MACコールバック

ブロック暗号を使用する暗号スイートでEncrypt-Then-MAC拡張（RFC 7366）がネゴシエートされた場合、wolfSSLは代わりにもう一組のコールバックを呼び出します。
これらのコールバックは、MACを計算する前に暗号化を行い、復号する前にMACを検証します。
これらのコールバックの型は、`ssl.h`で`CallbackEncryptMac`と`CallbackVerifyDecrypt`として宣言されています。

```c
typedef int (*CallbackEncryptMac)(WOLFSSL* ssl, unsigned char* macOut,
       int content, int macVerify, unsigned char* encOut,
       const unsigned char* encIn, unsigned int encSz, void* ctx);

typedef int (*CallbackVerifyDecrypt)(WOLFSSL* ssl,
       unsigned char* decOut, const unsigned char* decIn,
       unsigned int decSz, int content, int verify, unsigned int* padSz,
       void* ctx);
```

これらは`wolfSSL_CTX_SetEncryptMacCb()`と`wolfSSL_CTX_SetVerifyDecryptCb()`で登録します。
オブジェクトごとのコンテキスト設定関数は`wolfSSL_SetEncryptMacCtx()`と`wolfSSL_SetVerifyDecryptCtx()`ですが、現在のwolfSSLはこれらのコールバックに`wolfSSL_SetMacEncryptCtx()`と`wolfSSL_SetDecryptVerifyCtx()`で設定されたコンテキストを渡します。
そのため、`wolfssl/test.h`の実装例では両方の組で同じコンテキストを使用しています。
検証/復号コールバックは、復号/検証コールバックも登録されている場合にのみ使用されます。
復号/検証コールバックを登録し、かつEncrypt-Then-MACがネゴシエートされる可能性がある場合は、検証/復号コールバックも登録するか、`wolfSSL_CTX_AllowEncryptThenMac(ctx, 0)`でこの拡張を無効にしてください。
コールバックの実装例は、`wolfssl/test.h`の`myEncryptMacCb()`と`myVerifyDecryptCb()`に掲載しています。
Encrypt-Then-MACのサポートはデフォルトで有効であり、`--enable-enc-then-mac`設定オプション（`HAVE_ENCRYPT_THEN_MAC`）で制御します。

アトミックレコードレイヤーコールバックを使用するには、wolfSSLを`--enable-atomicuser`設定オプションを使用してコンパイルするか、`ATOMIC_USER`プリプロセッサフラグを定義する必要があります。

## 公開鍵コールバック

wolfSSLは、SSL/TLS接続中にDH、ECC、Ed25519、X25519、Ed448、X448、およびRSA操作をより詳細に制御したいユーザー向けに公開鍵（PK）コールバックを提供します。

公開鍵コールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`を定義してコンパイルする必要があります。
これは次の設定オプションを使用して行うことができます。

```sh
./configure --enable-pkcallbacks
```

さらに、各コールバックタイプには、特定の機能が有効になっている必要があります（例：`HAVE_DH`、`HAVE_ED25519`など）。

### DHコールバック

wolfSSLは、SSL/TLS接続中にDH鍵生成と鍵合意操作をより詳細に制御したいユーザー向けにDH（Diffie-Hellman）コールバックを提供します。

ユーザーはオプションで2つの関数を定義できます。

1. DH鍵生成コールバック
2. DH鍵合意コールバック

これらの関数は`ssl.h`の`CallbackDhGenerateKeyPair`と`CallbackDhAgree`でプロトタイプ化されています。

```c
typedef int (*CallbackDhGenerateKeyPair)(DhKey* key, WC_RNG* rng,
                                         byte* priv, word32* privSz,
                                         byte* pub, word32* pubSz);

typedef int (*CallbackDhAgree)(WOLFSSL* ssl, struct DhKey* key,
        const unsigned char* priv, unsigned int privSz,
        const unsigned char* otherPubKeyDer, unsigned int otherPubKeySz,
        unsigned char* out, word32* outlen,
        void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetDhGenerateKeyPair()`
* `wolfSSL_CTX_SetDhAgreeCb()`

ユーザーは`wolfSSL_SetDhAgreeCtx()`を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

コールバックの実装例は`wolfssl/test.h`の`myDhCallback()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

DHコールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_DH`を定義してコンパイルする必要があります。

### Ed25519コールバック

wolfSSLは、SSL/TLS接続中にEd25519署名/検証操作をより詳細に制御したいユーザー向けにEd25519コールバックを提供します。

ユーザーはオプションで2つの関数を定義できます。

1. Ed25519署名コールバック
2. Ed25519検証コールバック

これらの関数は`ssl.h`の`CallbackEd25519Sign`と`CallbackEd25519Verify`でプロトタイプ化されています。

```c
typedef int (*CallbackEd25519Sign)(WOLFSSL* ssl,
       const unsigned char* in, unsigned int inSz,
       unsigned char* out, unsigned int* outSz,
       const unsigned char* keyDer, unsigned int keySz,
       void* ctx);

typedef int (*CallbackEd25519Verify)(WOLFSSL* ssl,
       const unsigned char* sig, unsigned int sigSz,
       const unsigned char* msg, unsigned int msgSz,
       const unsigned char* keyDer, unsigned int keySz,
       int* result, void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetEd25519SignCb()`
* `wolfSSL_CTX_SetEd25519VerifyCb()`

ユーザーは以下を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

* `wolfSSL_SetEd25519SignCtx()`
* `wolfSSL_SetEd25519VerifyCtx()`

コールバックの実装例は`wolfssl/test.h`の`myEd25519Sign()`と`myEd25519Verify()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

Ed25519コールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_ED25519`を定義してコンパイルする必要があります。

### X25519コールバック

wolfSSLは、SSL/TLS接続中にX25519鍵生成と共有秘密計算をより詳細に制御したいユーザー向けにX25519コールバックを提供します。

ユーザーはオプションで2つの関数を定義できます。

1. X25519鍵生成コールバック
2. X25519共有秘密コールバック

これらの関数は`ssl.h`の`CallbackX25519KeyGen`と`CallbackX25519SharedSecret`でプロトタイプ化されています。

```c
typedef int (*CallbackX25519KeyGen)(WOLFSSL* ssl, struct curve25519_key* key,
    unsigned int keySz, void* ctx);

typedef int (*CallbackX25519SharedSecret)(WOLFSSL* ssl,
        struct curve25519_key* otherKey,
        unsigned char* pubKeyDer, unsigned int* pubKeySz,
        unsigned char* out, unsigned int* outlen,
        int side, void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetX25519KeyGenCb()`
* `wolfSSL_CTX_SetX25519SharedSecretCb()`

ユーザーは以下を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

* `wolfSSL_SetX25519KeyGenCtx()`
* `wolfSSL_SetX25519SharedSecretCtx()`

コールバックの実装例は`wolfssl/test.h`の`myX25519KeyGen()`と`myX25519SharedSecret()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

X25519コールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_CURVE25519`を定義してコンパイルする必要があります。

### Ed448コールバック

wolfSSLは、SSL/TLS接続中にEd448署名/検証操作をより詳細に制御したいユーザー向けにEd448コールバックを提供します。

ユーザーはオプションで2つの関数を定義できます。

1. Ed448署名コールバック
2. Ed448検証コールバック

これらの関数は`ssl.h`の`CallbackEd448Sign`と`CallbackEd448Verify`でプロトタイプ化されています。

```c
typedef int (*CallbackEd448Sign)(WOLFSSL* ssl,
       const unsigned char* in, unsigned int inSz,
       unsigned char* out, unsigned int* outSz,
       const unsigned char* keyDer, unsigned int keySz,
       void* ctx);

typedef int (*CallbackEd448Verify)(WOLFSSL* ssl,
       const unsigned char* sig, unsigned int sigSz,
       const unsigned char* msg, unsigned int msgSz,
       const unsigned char* keyDer, unsigned int keySz,
       int* result, void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetEd448SignCb()`
* `wolfSSL_CTX_SetEd448VerifyCb()`

ユーザーは以下を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

* `wolfSSL_SetEd448SignCtx()`
* `wolfSSL_SetEd448VerifyCtx()`

コールバックの実装例は`wolfssl/test.h`の`myEd448Sign()`と`myEd448Verify()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

Ed448コールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_ED448`を定義してコンパイルする必要があります。

### X448コールバック

wolfSSLは、SSL/TLS接続中にX448鍵生成と共有秘密操作をより詳細に制御したいユーザー向けにX448コールバックを提供します。

ユーザーはオプションで2つの関数を定義できます。

1. X448鍵生成コールバック
2. X448共有秘密コールバック

これらの関数は`ssl.h`の`CallbackX448KeyGen`と`CallbackX448SharedSecret`でプロトタイプ化されています。

```c
typedef int (*CallbackX448KeyGen)(WOLFSSL* ssl, struct curve448_key* key,
    unsigned int keySz, void* ctx);

typedef int (*CallbackX448SharedSecret)(WOLFSSL* ssl,
        struct curve448_key* otherKey,
        unsigned char* pubKeyDer, unsigned int* pubKeySz,
        unsigned char* out, unsigned int* outlen,
        int side, void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetX448KeyGenCb()`
* `wolfSSL_CTX_SetX448SharedSecretCb()`

ユーザーは以下を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

* `wolfSSL_SetX448KeyGenCtx()`
* `wolfSSL_SetX448SharedSecretCtx()`

コールバックの実装例は`wolfssl/test.h`の`myX448KeyGen()`と`myX448SharedSecret()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

X448コールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_CURVE448`を定義してコンパイルする必要があります。

### RSA PSS コールバック

wolfSSLは、SSL/TLS接続中にRSA PSS署名/検証操作をより詳細に制御したいユーザー向けにRSA PSSコールバックを提供します。

ユーザーは、必要に応じて次の3つの関数を定義できます。

1. RSA PSS署名コールバック
2. RSA PSS検証コールバック
3. RSA PSS署名チェックコールバック

これらの関数の型は、`ssl.h`で`CallbackRsaPssSign`と`CallbackRsaPssVerify`として宣言されています。
署名チェックコールバックは`CallbackRsaPssVerify`のプロトタイプを使用します。

```c
typedef int (*CallbackRsaPssSign)(WOLFSSL* ssl,
       const unsigned char* in, unsigned int inSz,
       unsigned char* out, unsigned int* outSz,
       int hash, int mgf,
       const unsigned char* keyDer, unsigned int keySz,
       void* ctx);

typedef int (*CallbackRsaPssVerify)(WOLFSSL* ssl,
       unsigned char* sig, unsigned int sigSz,
       unsigned char** out,
       int hash, int mgf,
       const unsigned char* keyDer, unsigned int keySz,
       void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetRsaPssSignCb()`
* `wolfSSL_CTX_SetRsaPssVerifyCb()`
* `wolfSSL_CTX_SetRsaPssSignCheckCb()`

ユーザーは以下を使用して`WOLFSSL`オブジェクト（セッション）ごとにコンテキストを設定できます。

* `wolfSSL_SetRsaPssSignCtx()`
* `wolfSSL_SetRsaPssVerifyCtx()`

署名チェックコールバックは、wolfSSLがRSA PSS署名を作成した後に、その署名を検証して署名障害を検出するために呼び出されます。
このコールバックには専用のコンテキスト設定関数はなく、`wolfSSL_SetRsaPssSignCtx()`で設定されたコンテキストを受け取ります。
このコールバックは`out`に復元したデータの長さを返し、wolfSSLはそのデータを署名対象のデータと照合します。
チェックを省略する場合（例えば、ハードウェアがすでに署名をチェックしている場合）は0を返します。

コールバックの実装例は`wolfssl/test.h`の`myRsaPssSign()`、`myRsaPssVerify()`、`myRsaPssSignCheck()`で提供しています。
使用例はwolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で見ることができます。

RSA PSSコールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`WC_RSA_PSS`を定義してコンパイルする必要があります。

### ECCコールバック

wolfSSLは、SSL/TLS接続中にECC鍵生成、ECDSA署名/検証、およびECDH共有秘密操作をより詳細に制御したいユーザー向けにECCコールバックを提供します。

ユーザーは、必要に応じて次の4つの関数を定義できます。

1. ECC鍵生成コールバック
2. ECC署名コールバック
3. ECC検証コールバック
4. ECC共有秘密コールバック

これらの関数の型は、`ssl.h`で`CallbackEccKeyGen`、`CallbackEccSign`、`CallbackEccVerify`、および`CallbackEccSharedSecret`として宣言されています。

```c
typedef int (*CallbackEccKeyGen)(WOLFSSL* ssl, struct ecc_key* key,
    unsigned int keySz, int ecc_curve, void* ctx);

typedef int (*CallbackEccSign)(WOLFSSL* ssl,
    const unsigned char* in, unsigned int inSz,
    unsigned char* out, word32* outSz,
    const unsigned char* keyDer, unsigned int keySz,
    void* ctx);

typedef int (*CallbackEccVerify)(WOLFSSL* ssl,
    const unsigned char* sig, unsigned int sigSz,
    const unsigned char* hash, unsigned int hashSz,
    const unsigned char* keyDer, unsigned int keySz,
    int* result, void* ctx);

typedef int (*CallbackEccSharedSecret)(WOLFSSL* ssl,
    struct ecc_key* otherKey,
    unsigned char* pubKeyDer, word32* pubKeySz,
    unsigned char* out, word32* outlen,
    int side, void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* `wolfSSL_CTX_SetEccKeyGenCb()`
* [`wolfSSL_CTX_SetEccSignCb()`](ssl_8h.md#function-wolfssl_ctx_seteccsigncb)
* [`wolfSSL_CTX_SetEccVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_seteccverifycb)
* `wolfSSL_CTX_SetEccSharedSecretCb()`

ユーザーは`WOLFSSL`オブジェクト（セッション）ごとに以下でコンテキストを設定できます。

* `wolfSSL_SetEccKeyGenCtx()`
* [`wolfSSL_SetEccSignCtx()`](ssl_8h.md#function-wolfssl_seteccsignctx)
* [`wolfSSL_SetEccVerifyCtx()`](ssl_8h.md#function-wolfssl_seteccverifyctx)
* `wolfSSL_SetEccSharedSecretCtx()`

これらのコンテキストは、ユーザー指定のコンテキストへのポインタであり、それぞれの公開鍵コールバックに`void* ctx`パラメータを通じて返されます。

コールバックの実装例は`wolfssl/test.h`の`myEccKeyGen()`、`myEccSign()`、`myEccVerify()`、および`myEccSharedSecret()`で提供しています。

ECCコールバックを使用するには、wolfSSLを`HAVE_PK_CALLBACKS`と`HAVE_ECC`を定義してコンパイルする必要があります。

### RSAコールバック

wolfSSLは、SSL/TLS接続中にRSA署名/検証および暗号化/復号操作をより詳細に制御したいユーザー向けにRSAコールバックを提供します。

ユーザーは、必要に応じて次の5つの関数を定義できます。

1. RSA署名コールバック
2. RSA検証コールバック
3. RSA署名チェックコールバック
4. RSA暗号化コールバック
5. RSA復号コールバック

これらの関数の型は、`ssl.h`で`CallbackRsaSign`、`CallbackRsaVerify`、`CallbackRsaEnc`、および`CallbackRsaDec`として宣言されています。
署名チェックコールバックは`CallbackRsaVerify`のプロトタイプを使用します。

```c
typedef int (*CallbackRsaSign)(WOLFSSL* ssl,
    const unsigned char* in, unsigned int inSz,
    unsigned char* out, word32* outSz,
    const unsigned char* keyDer, unsigned int keySz,
    void* ctx);

typedef int (*CallbackRsaVerify)(WOLFSSL* ssl,
    unsigned char* sig, unsigned int sigSz,
    unsigned char** out, const unsigned char* keyDer,
    unsigned int keySz, void* ctx);

typedef int (*CallbackRsaEnc)(WOLFSSL* ssl,
    const unsigned char* in, unsigned int inSz,
    unsigned char* out, word32* outSz,
    const unsigned char* keyDer,
    unsigned int keySz, void* ctx);

typedef int (*CallbackRsaDec)(WOLFSSL* ssl, unsigned char* in,
    unsigned int inSz, unsigned char** out,
    const unsigned char* keyDer, unsigned int keySz,
    void* ctx);
```

ユーザーはこれらの関数を作成し、wolfSSLコンテキスト（`WOLFSSL_CTX`）ごとに以下を使用して登録する必要があります。

* [`wolfSSL_CTX_SetRsaSignCb()`](ssl_8h.md#function-wolfssl_ctx_setrsasigncb)
* [`wolfSSL_CTX_SetRsaVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaverifycb)
* `wolfSSL_CTX_SetRsaSignCheckCb()`
* [`wolfSSL_CTX_SetRsaEncCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaenccb)
* [`wolfSSL_CTX_SetRsaDecCb()`](ssl_8h.md#function-wolfssl_ctx_setrsadeccb)

ユーザーは`WOLFSSL`オブジェクト（セッション）ごとに以下でコンテキストを設定できます。

* [`wolfSSL_SetRsaSignCtx()`](ssl_8h.md#function-wolfssl_setrsasignctx)
* [`wolfSSL_SetRsaVerifyCtx()`](ssl_8h.md#function-wolfssl_setrsaverifyctx)
* [`wolfSSL_SetRsaEncCtx()`](ssl_8h.md#function-wolfssl_setrsaencctx)
* [`wolfSSL_SetRsaDecCtx()`](ssl_8h.md#function-wolfssl_setrsadecctx)

署名チェックコールバックは、wolfSSLがRSA PKCS #1 v1.5署名を作成した後に、その署名を検証して署名障害を検出するために呼び出されます。
このコールバックには専用のコンテキスト設定関数はなく、`wolfSSL_SetRsaSignCtx()`で設定されたコンテキストを受け取ります。
このコールバックは`out`に復元したデータの長さを返し、wolfSSLはそのデータを署名対象のデータと比較します。
チェックを省略する場合（例えば、ハードウェアがすでに署名をチェックしている場合）は0を返します。

コールバックの実装例は`wolfssl/test.h`の`myRsaSign()`、`myRsaVerify()`、`myRsaSignCheck()`、`myRsaEnc()`、および`myRsaDec()`で提供しています。

RSAコールバックを使用するには、`HAVE_PK_CALLBACKS`を定義し、RSAを有効にして（`NO_RSA`を定義せずに）wolfSSLをコンパイルする必要があります。

### プロトコルコールバック

`HAVE_PK_CALLBACKS`は、TLSプロトコルレベルの操作に対するコールバックも有効にします。
これにより、鍵導出やレコード処理をハードウェア（例えば、セッション鍵を保持するセキュアエレメント）で実行できます。
これらのコールバックの型は`ssl.h`で宣言されています。

| コールバック型 | 登録関数 | 操作 |
| --- | --- | --- |
| `CallbackGenMasterSecret` | `wolfSSL_CTX_SetGenMasterSecretCb()` | TLS 1.2マスターシークレットの生成 |
| `CallbackGenExtMasterSecret` | `wolfSSL_CTX_SetGenExtMasterSecretCb()` | 拡張マスターシークレット（RFC 7627）の生成 |
| `CallbackGenPreMaster` | `wolfSSL_CTX_SetGenPreMasterCb()` | RSA鍵交換用のプリマスターシークレットの生成 |
| `CallbackGenSessionKey` | `wolfSSL_CTX_SetGenSessionKeyCb()` | セッション鍵の導出 |
| `CallbackEncryptKeys` | `wolfSSL_CTX_SetEncryptKeysCb()` | レコード暗号化鍵の設定 |
| `CallbackTlsFinished` | `wolfSSL_CTX_SetTlsFinishedCb()` | TLS Finishedメッセージのハッシュの計算 |
| `CallbackVerifyMac` | `wolfSSL_CTX_SetVerifyMacCb()` | 受信したブロック暗号レコードのMACの検証（TLS 1.2以前、`WOLFSSL_AEAD_ONLY`ビルドでは使用不可） |
| `CallbackHKDFExtract` | `wolfSSL_CTX_SetHKDFExtractCb()` | TLS 1.3 HKDF-Extract（`HAVE_HKDF`が必要） |
| `CallbackHKDFExpandLabel` | `wolfSSL_CTX_SetHKDFExpandLabelCb()` | TLS 1.3 HKDF-Expand-Label |
| `CallbackProcessServerSigKex` | `wolfSSL_CTX_SetProcessServerSigKexCb()` | TLS 1.2 ServerKeyExchangeのECDSA署名の検証 |
| `CallbackPerformTlsRecordProcessing` | `wolfSSL_CTX_SetPerformTlsRecordProcessingCb()` | TLS 1.2 AES-GCMまたはAES-CCMレコードの暗号化または復号 |

最初の8つには、それぞれ対応するオブジェクトごとのコンテキスト設定関数があります（例：`wolfSSL_SetGenMasterSecretCtx()`、`wolfSSL_SetHKDFExtractCtx()`）。
最後の3つはコンテキスト引数を取りません。

コールバックは、操作をwolfSSL自身に実行させることもできます。
そのためには、最初の7つは`PROTOCOLCB_UNAVAILABLE`を返し、`CallbackHKDFExpandLabel`、`CallbackProcessServerSigKex`、`CallbackPerformTlsRecordProcessing`は`NOT_COMPILED_IN`を返します。
`CallbackHKDFExtract`が登録されている場合は、その結果が常に使用されます。

コールバックの実装例は`wolfssl/test.h`の`myGenMaster()`、`myGenExtMaster()`、`myGenPreMaster()`、`myGenSessionKey()`、`mySetEncryptKeys()`、`myTlsFinished()`、`myVerifyMac()`、および`myHkdfExtract()`で提供しています。
これらの実装例は、`myHkdfExtract()`を除き`PROTOCOLCB_UNAVAILABLE`を返すため、wolfSSLは自身の実装にフォールバックします。

公開鍵コールバックとプロトコルコールバックの使用例は、wolfSSLのクライアントサンプルプログラム（`examples/client/client.c`）で`-P`コマンドラインオプションを使用することで見ることができます。

公開鍵コールバックを使用するには、wolfSSLを[`--enable-pkcallbacks`](chapter02.md#--enable-pkcallbacks)設定オプションを使用してコンパイルするか、`HAVE_PK_CALLBACKS`プリプロセッサフラグを定義する必要があります。

## 暗号コールバック（cryptocb）

wolfSSL/wolfCryptの暗号コールバックフレームワークは、ユーザーが特定の暗号アルゴリズムのデフォルト実装をオーバーライドし、実行時に独自のカスタム実装を提供できるようにします。
暗号コールバックの最も一般的なユースケースは、アルゴリズムをカスタムハードウェアアクセラレーションにオフロードすることです。
この他にも、追加のロギング/内部検査の追加、セキュアストレージからの鍵の取得、標準準拠の理由で別のライブラリから暗号を呼び出す、あるいはリモートプロシージャコールの実行にも使用できます。

### 暗号コールバックの使用方法

暗号コールバックを使用するには、次のようにします。

1. 暗号コールバックサポート付きでwolfSSLをコンパイルする
2. コールバックと一意のデバイスID（`devId`）をwolfCryptに登録する
3. `devId`をwolfCrypt API関数の引数として渡す
4. （TLSのみ）`devId`をwolfSSLコンテキストに関連付ける

#### 1. 暗号コールバックサポート付きでwolfSSLをコンパイルする

暗号コールバックのサポートは、`--enable-cryptocb`設定オプション、または`#define WOLF_CRYPTO_CB`を使用して有効にできます。

#### 2. コールバックと一意のdevIDをwolfCryptに登録する

暗号コールバックを使用するには、ユーザーはトップレベルの暗号コールバック関数をwolfCryptに登録し、このコールバック関数をwolfCryptに一意に識別するデバイスID（`devId`）を提供する必要があります。
これにより、複数の暗号コールバックを一度にwolfCryptに登録できます。
適切なコールバック関数は、`devId`パラメータを取る全てのwolfCrypt関数内部で、または`WOLFSSL_CTX`または`WOLFSSL`構造体に関連付けられた場合に、wolfSSLによって呼び出されます。

暗号コールバック関数をwolfCryptに登録するには、`wc_CryptoCb_RegisterDevice` APIを使用します。
これは(`devId`)、コールバック関数、および呼び出し時にコールバックに渡される任意のユーザーコンテキストを取ります。

```c
typedef int (*CryptoDevCallbackFunc)(int devId, wc_CryptoInfo* info, void* ctx);

WOLFSSL_API int wc_CryptoCb_RegisterDevice(int devId,
                                           CryptoDevCallbackFunc cb,
                                           void* ctx);
```

**注：** 登録された`devId`は、特別な`INVALID_DEVID`列挙値のために予約されている`-2`以外の任意の値にできます。
`devId == INVALID_DEVID`をwolfCrypt APIの引数として渡すと、コールバックが呼び出されず、代わりにデフォルトの内部実装を使用することを示します。

#### 3. `devId`をwolfCrypt API関数の引数として渡す

wolfCrypt APIの場合、`devId`を受け入れる初期化関数を使用します。

```text
wc_InitRsaKey_ex
wc_ecc_init_ex
wc_AesInit
wc_InitSha256_ex
wc_InitSha_ex
wc_HmacInit
wc_InitCmac_ex
```

これにより、wolfCryptはデフォルト実装の代わりに暗号コールバックを呼び出します。
これは使用可能なAPIのすべてを示しているわけではありません。
特定のアルゴリズムが暗号コールバックをサポートしているかどうかについては、wolfCrypt APIドキュメントをご参照ください。

#### 4. （TLSのみ）devIdをwolfSSLコンテキストに関連付ける

TLSを使用する際に暗号コールバックの使用を有効にするには、`WOLFSSL_CTX`または`WOLFSSL`構造体の初期化時に`devId`引数を渡す必要があります。

```c
wolfSSL_CTX_SetDevId(ctx, devId);
wolfSSL_SetDevId(ssl, devId);
```

これらの構造体に関連付けられたTLS接続に関連する暗号処理は、暗号コールバックを呼び出します。

### 暗号コールバックの作成

暗号コールバックが呼び出されると、どの暗号操作が要求されているか、および入力データと出力データの場所と成功/失敗をwolfCryptに伝える方法を知る必要があります。
この情報は、`wc_CryptoInfo* info`引数を通じてコールバックに中継されます。

高レベルでは、暗号コールバックは要求された操作をサポートしているかどうかを判断し、入力データに対して処理を実行し、関連する出力データで`wc_CryptoInfo *info`引数を更新し、有効なwolfCryptエラーコードを返す必要があります。

#### リクエストのタイプの判断

`wc_CryptoInfo`構造体には、異なる構造体の共用体（一部は共用体自体）が含まれており、それぞれが特定のタイプの暗号操作に対応しています。
実行される操作のタイプは`info->algo_type`によって決定され、これは`wolfssl/wolfcrypt/types.h`で定義されている`enum wc_AlgoType`のバリアントである必要があります。
この`algo_type`に基づいて、`wc_CryptoInfo`内の適切な共用体要素にアクセスして、操作に固有のパラメータを取得または設定できます。
このトップレベルの共用体を「アルゴタイプ共用体」と呼ぶことができます。

暗号リクエストのタイプを判断し、それに応じて処理するには、通常、`wc_CryptoInfo`構造体の`algo_type`フィールドに対してswitch-case文を使用します。
switchの各caseは、対称暗号、ハッシュ化、公開鍵操作などの異なる暗号操作に対応します。
`wc_AlgoType`と対応するアルゴタイプ共用体の間には一対一のマッピングがあり、それらは`wolfssl/wolfcrypt/cryptocb.h`の`wc_CryptoInfo`構造体定義にコメントされています。

暗号コールバックは成功時にゼロを返すか、失敗時に有効なwolfCryptエラーコードを返す必要があります。
サポートされていないアルゴリズムの場合、コールバックは`CRYPTOCB_UNAVAILABLE`を返す必要があり、これによりwolfCryptは内部実装にフォールバックします。

これを説明するための、簡略化した実装例を以下に示します。

```c
int myCryptoCallback(int devId, wc_CryptoInfo* info, void* ctx)
{
    int ret = CRYPTOCB_UNAVAILABLE;

    switch (info->algo_type) {
        case WC_ALGO_TYPE_HASH:
            /* Handle hashing, using algo type union: info->hash */
            ret = 0; /* or wolfCrypt error code */
            break;

        case WC_ALGO_TYPE_PK:
            /* Handle public key operations, using algo type union: info->pk */
            ret = 0; /* or wolfCrypt error code */
            break;

        case WC_ALGO_TYPE_CIPHER:
            /* Handle cipher operations, using algo type union: info->cipher */
            ret = 0; /* or wolfCrypt error code */
            break;

        /* and so on for other algo types... */
    }

    return ret; // Return success or an appropriate error code
}
```

wolfSSL 5.9.4では、コールバックが受け取るリクエストタイプとして`WC_ALGO_TYPE_KEYSTORE`を追加しました（`--enable-cryptocbutils=keystore`でビルドした場合）。
これらのリクエストは、ハードウェアキーストアに保持された鍵のライフサイクル操作です。
操作は7種類あり、平文形式とラップ形式それぞれでのインポートとエクスポート、導出、削除、および情報取得です。
`wolfssl/wolfcrypt/wc_keystore.h`の`wc_KeyStore_*` APIは、デバイスが定義する不透明な参照によって鍵を指定します。
これにより、デバイスはメモリ上に一切現れない鍵を作成、ラップ、導出、破棄できます。

いくつかの単純なアルゴタイプ共用体（RNGやシード共用体など）はさらなる処理を必要とせず、すぐに実行できます。
ただし、暗号や公開鍵タイプなどのより複雑な操作には、同じ方法で条件付きで解釈されなければならない複数の共用体バリアントが自分自身に存在します。
各共用体の変種と階層レベルは、アルゴリズムタイプの各カテゴリに固有であり、その完全な定義は`wc_CryptoInfo`構造体の定義で見つけることができます。
一般的なルールとして、共用体である各レベルには、共用体の残りの部分をどのように参照解除すべきかを知らせる何らかのタイプ指示子が含まれています。

以下は、複数のレベルの共用体デコーディングを持つ複雑なアルゴタイプ共用体の、簡略化した実装例です。
コールバックには乱数生成のサポートと、ECC鍵合意、署名、検証のサポートが含まれています。

```c
int myCryptoCallback(int devId, wc_CryptoInfo* info, void* ctx)
{
    int ret = CRYPTOCB_UNAVAILABLE;

    switch (info->algo_type) {
        case WC_ALGO_TYPE_PK:
            /* Handle public key operations, using algo type union: info->pk */
            switch (info->pk.type) { /* pk type is of type wc_PkType */
                case WC_PK_TYPE_ECDH:
                    /* use info->pk.ecdh */
                    ret = 0; /* or wolfCrypt error code */
                    break;

                case WC_PK_TYPE_ECDSA_SIGN:
                    /* use info->pk.eccsign */
                    ret = 0; /* or wolfCrypt error code */
                    break;

                case WC_PK_TYPE_ECDSA_VERIFY:
                    /* use info->pk.eccverify */
                    ret = 0; /* or wolfCrypt error code */
                    break;
            }
            break;

        case WC_ALGO_TYPE_RNG:
            /* use info->rng */
            ret = 0; /* or wolfCrypt error code */
            break;
    }

    return ret;
}
```

### リクエストの処理

各タイプのリクエストのデータ構造には、一般に入力データと出力データのポインタと関連するサイズが含まれます。
リクエストによっては、暗号鍵、ノンス、またはさらなる設定を含む追加データが含まれる場合があります。
暗号コールバックは入力データに対して操作し、関連する出力データをアルゴタイプ共用体の適切なバリアントに書き戻す必要があります。
問題のアルゴリズムタイプに対応しない共用体バリアント（例えば、`info->algo_type == WC_ALGO_TYPE_RNG`の場合に`info->cipher`を使用する）にデータを書き込むことはメモリエラーであり、未定義の動作を引き起こす可能性があります。

### 非同期暗号コールバック

暗号コールバックは、操作がデバイス上で開始されたもののまだ完了していないことを示すために、`WC_PENDING_E`を返すことができます。
その場合、アプリケーションは`wolfSSL_AsyncPoll()`を使用して操作を完了まで進めます。
`wolfSSL_AsyncPoll()`は非同期暗号サポートが有効な場合にのみ宣言されるため、[`--enable-asynccrypt`](chapter02.md#--enable-asynccrypt)設定オプション（`WOLFSSL_ASYNC_CRYPT`）で非同期暗号サポートを有効にする必要があります。
wolfSSL 5.9.4では、TLS 1.3ハンドシェイクのHKDF鍵スケジュール、トランスクリプトHMAC、AES-GCMレコードの暗号化と復号、乱数生成、ECCとX25519の鍵共有、ECDSAとEd25519の署名と検証でも、この非同期処理をサポートしました。
特にTLSレコード暗号については、`WOLF_CRYPTO_CB_ASYNC_POLL`を定義すると、完了までポーリングするモデルを使用できます。
これを定義しない場合、保留中のバルク暗号は、レコードを破損させることなく`ASYNC_OP_E`を返します。
さらに`WOLFSSL_ASYNC_CERT_YIELD`を定義すると、ピアの証明書チェーン内の各証明書を検証するたびに`WC_PENDING_E`を返すため、協調型スケジューラを実行できます。

### デバイス登録

`wc_CryptoCb_RegisterDevice()`は、すでに登録されているデバイスIDを`ALREADY_E`で拒否し、`devId == INVALID_DEVID`の場合は`BAD_FUNC_ARG`を、デバイステーブルが満杯の場合は`BUFFER_E`を返します。
このテーブルには`MAX_CRYPTO_DEVID_CALLBACKS`個（デフォルトは8）のエントリを保持できます。
`wc_CryptoCb_IsDeviceRegistered()`は、IDが使用中かどうかを返します。
デバイスの登録コマンド自体がさらに別のデバイスを登録した場合でも、中途半端に埋まったスロットが残ることはありません。
`wc_CryptoCb_UnRegisterDevice()`は登録を解除します。

### 暗号コールバック専用ビルド

あるアルゴリズムを常にデバイスが処理する場合は、そのソフトウェア実装をコンパイル対象から除外できます。
`WOLF_CRYPTO_CB_ONLY_*`マクロは、これをアルゴリズムごとに行います。
対象となるマクロは`WOLF_CRYPTO_CB_ONLY_SHA256`、`_SHA512`、`_AES`、`_RSA`、`_ECC`、`_ED25519`、`_CURVE25519`、`_CURVE448`、`_FALCON`、`_SLHDSA`、`_MLKEM`、`_MLDSA`、`_LMS`、`_XMSS`、および`_FRODOKEM`です。
`--enable-cryptocb=only`を指定すると、これらのアルゴリズムのうちビルドで有効になっているものすべてについて、これらのマクロが一度に設定されます。
[`--enable-cryptocb`](chapter02.md#--enable-cryptocb)をご参照ください。

### トラブルシューティング

一部の古いコンパイラは「匿名インライン集約体」を許可していませんが、wolfCryptはスペースを節約するために、入れ子になった`wc_CryptoInfo`匿名共用体の定義でこれを使用しています。
匿名インライン集約体の使用を無効にするには、プリプロセッサマクロ`HAVE_ANONYMOUS_INLINE_AGGREGATES`を`0`として定義します。
これにより暗号コールバックを使用できるようになりますが、`wc_CryptoInfo`構造体のサイズが大幅に増加します。

### 実装例

暗号コールバックの完全な実装例は以下のページで見つけることができます。

* [VaultIC Crypto Callbacks](https://github.com/wolfSSL/wolfssl-examples/blob/master/ccb_vaultic/ccb_vaultic.c)
* [STSAFE-A100 ECC Crypto Callbacks](https://github.com/wolfSSL/wolfssl/blob/master/wolfcrypt/src/port/st/stsafe.c)
* [TPM 2.0 wolfTPM Crypto Callbacks](https://github.com/wolfSSL/wolfTPM/blob/master/src/tpm2_cryptocb.c)
* [Generic wolfCrypt tests](https://github.com/wolfSSL/wolfssl/blob/master/wolfcrypt/test/test.c)

## その他のコールバック

wolfSSLは、`WOLFSSL_CTX`または`WOLFSSL`オブジェクトに設定するその他のコールバックもいくつか提供しています。
証明書検証コールバック（`wolfSSL_CTX_set_verify()`）については[第4章 機能](chapter04.md)の「クライアント認証」節で、PSKコールバック（`wolfSSL_CTX_set_psk_client_callback()`と`wolfSSL_CTX_set_psk_server_callback()`）については[第4章 機能](chapter04.md)の「事前共有鍵」節で説明しています。
その他のコールバックを以下の表に示します。
プロトタイプについては`wolfssl/ssl.h`をご参照ください。

| コールバック | 登録関数 | 要件 |
| --- | --- | --- |
| セッションチケットの暗号化（サーバー） | `wolfSSL_CTX_set_TicketEncCb()` | `HAVE_SESSION_TICKET`（`--enable-session-ticket`） |
| セッションチケットの受信（クライアント） | `wolfSSL_set_SessionTicket_cb()` | `HAVE_SESSION_TICKET`（`--enable-session-ticket`） |
| SNIの受信（サーバー） | `wolfSSL_CTX_set_servername_callback()` | `HAVE_SNI`（`--enable-sni`） |
| ALPNプロトコルの選択（サーバー） | `wolfSSL_CTX_set_alpn_select_cb()` | `HAVE_ALPN`（`--enable-alpn`）、および`OPENSSL_ALL`、`WOLFSSL_NGINX`、`WOLFSSL_HAPROXY`、`HAVE_LIGHTY`、`WOLFSSL_QUIC`のいずれか |
| ハンドシェイク中の証明書の選択 | `wolfSSL_CTX_set_cert_cb()` | `WOLFSSL_CERT_SETUP_CB`（`--enable-cert-setup-cb`、または`OPENSSL_EXTRA`） |
| CAキャッシュへのCA証明書の追加 | `wolfSSL_CTX_SetCACb()` | 証明書サポート（`NO_CERTS`が未定義） |
| 証明書に対応するCRLが見つからない場合 | `wolfSSL_CTX_SetCRL_Cb()` | `HAVE_CRL`（`--enable-crl`） |
| CRL取得のI/O | `wolfSSL_CTX_SetCRL_IOCb()` | `HAVE_CRL_IO`（`--enable-crl=io`） |
| OCSPリクエストのI/O | `wolfSSL_CTX_SetOCSP_Cb()` | `HAVE_OCSP`（`--enable-ocsp`） |
| TLSキーログ（NSSキーログ形式） | `wolfSSL_CTX_set_keylog_callback()` | `OPENSSL_EXTRA`と`HAVE_SECRET_CALLBACK` |
| 新しいセッションの確立 | `wolfSSL_CTX_sess_set_new_cb()` | セッションキャッシュが有効、かつ`OPENSSL_EXTRA`または`HAVE_EXT_CACHE` |

