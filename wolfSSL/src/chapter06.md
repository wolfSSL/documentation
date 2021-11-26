# Callbacks

## HandShake Callback

wolfSSL (formerly CyaSSL) has an extension that allows a HandShake Callback to be set for connect or accept. This can be useful in embedded systems for debugging support when another debugger isn’t available and sniffing is impractical. To use wolfSSL HandShake Callbacks, use the extended functions, [`wolfSSL_connect_ex()`](ssl_8h.md#function_wolfssl_connect_ex) and [`wolfSSL_accept_ex()`](ssl_8h.md#function-wolfssl_accept_ex):

```c
int wolfSSL_connect_ex(WOLFSSL*, HandShakeCallBack, TimeoutCallBack,
                       Timeval)
int wolfSSL_accept_ex(WOLFSSL*, HandShakeCallBack, TimeoutCallBack,
                      Timeval)
```

`HandShakeCallBack` is defined as:

```c
typedef int (*HandShakeCallBack)(HandShakeInfo*);
```

`HandShakeInfo` is defined in `wolfssl/callbacks.h` (which should be added to a non-standard build):

```c
typedef struct handShakeInfo_st {
    char   cipherName[MAX_CIPHERNAME_SZ + 1];  /*negotiated name */
    char   packetNames[MAX_PACKETS_HANDSHAKE][MAX_PACKETNAME_SZ+1];
                                          /* SSL packet names */
    int    numberPackets;                 /*actual # of packets  */
    int    negotiationError;              /*cipher/parameter err */
} HandShakeInfo;
```

No dynamic memory is used since the maximum number of SSL packets in a handshake exchange is known. Packet names can be accessed through `packetNames[idx]` up to `numberPackets`. The callback will be called whether or not a handshake error occurred.  Example usage is also in the client example.

## Timeout Callback

The same extensions used with wolfSSL Handshake Callbacks can be used for wolfSSL Timeout Callbacks as well. These extensions can be called with either, both, or neither callbacks (Handshake and/or Timeout). `TimeoutCallback` is defined as:

```c
typedef int (*TimeoutCallBack)(TimeoutInfo*);
```

Where `TimeoutInfo` looks like:

```c
typedef struct timeoutInfo_st {
    char       timeoutName[MAX_TIMEOUT_NAME_SZ +1]; /*timeout Name*/
    int        flags;                            /* for future use*/
    int        numberPackets;               /*actual # of packets */
    PacketInfo packets[MAX_PACKETS_HANDSHAKE];  /*list of packets */
    Timeval    timeoutValue;               /*timer that caused it */
} TimeoutInfo;
```

Again, no dynamic memory is used for this structure since a maximum number of SSL packets is known for a handshake. `Timeval` is just a typedef for struct timeval.

`PacketInfo` is defined like this:

```c
typedef struct packetInfo_st {
    char           packetName[MAX_PACKETNAME_SZ + 1]; /* SSL name */
    Timeval        timestamp;                  /* when it occured */
    unsigned char  value[MAX_VALUE_SZ];     /* if fits, it's here */
    unsigned char* bufferValue;         /* otherwise here (non 0) */
    int            valueSz;              /* sz of value or buffer */
} PacketInfo;
```

Here, dynamic memory may be used. If the SSL packet can fit in `value` then that's where it's placed. `valueSz` holds the length and `bufferValue` is 0. If the packet is too big for `value`, only **Certificate** packets should cause this, then the packet is placed in `bufferValue`. `valueSz` still holds the size.

If memory is allocated for a **Certificate** packet then it is reclaimed after the callback returns. The timeout is implemented using signals, specifically `SIGALRM`, and is thread safe. If a previous  alarm is set of type `ITIMER_REAL` then it is reset, along with the correct handler, afterwards. The old timer will be time adjusted for any time wolfSSL spends processing. If an existing timer is shorter than the passed timer, the existing timer value is used. It is still reset afterwards. An existing timer that expires will be reset if has an interval associated with it. The callback will only be issued if a timeout occurs.

See the [client example](chapter03.md#client-example) for usage.

## User Atomic Record Layer Processing

wolfSSL provides Atomic Record Processing callbacks for users who wish to have more control over MAC/encrypt and decrypt/verify functionality during the SSL/TLS connection.

The user will need to define 2 functions:

1. MAC/encrypt callback function
2. Decrypt/verify callback function

These two functions are prototyped by `CallbackMacEncrypt` and `CallbackDecryptVerify` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with [`wolfSSL_CTX_SetMacEncryptCb()`](ssl_8h.md#function-wolfssl_ctx_setmacencryptcb) and [`wolfSSL_CTX_SetDecryptVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setdecryptverifycb().

The user can set a context per WOLFSSL object (session) with [`wolfSSL_SetMacEncryptCtx()`](ssl_8h.md#function-wolfssl_setmacencryptctx) and [`wolfSSL_SetDecryptVerifyCtx()`](ssl_8h.md#function-wolfssl_setdecryptverifyctx).  This context may be a pointer to any user-specified context, which will then in turn be passed back to the MAC/encrypt and decrypt/verify callbacks through the `void* ctx` parameter.

1. Example callbacks can be found in `wolfssl/test.h`, under `myMacEncryptCb()` and `myDecryptVerifyCb()`.  Usage can be seen in the wolfSSL example client (`examples/client/client.c`), when using the `-U` command line option.

To use Atomic Record Layer callbacks, wolfSSL needs to be compiled using the `--enable-atomicuser` configure option, or by defining the `ATOMIC_USER` preprocessor flag.

## Public Key Callbacks

wolfSSL provides Public Key callbacks for users who wish to have more control over ECC sign/verify functionality as well as RSA sign/verify and encrypt/decrypt functionality during the SSL/TLS connection.

The user can optionally define 7 functions:

1. ECC sign callback
2. ECC verify callback
3. ECC shared secret callback
4. RSA sign callback
5. RSA verify callback
6. RSA encrypt callback
7. RSA decrypt callback

These two functions are prototyped by `CallbackEccSign`, `CallbackEccVerify`, `CallbackEccSharedSecret`, `CallbackRsaSign`, `CallbackRsaVerify`, `CallbackRsaEnc`, and `CallbackRsaDec` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* [`wolfSSL_CTX_SetEccSignCb()`](ssl_8h.md#function-wolfssl_ctx_seteccsigncb)
* [`wolfSSL_CTX_SetEccVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_seteccverifycb)
* `wolfSSL_CTX_SetEccSharedSecretCb()`
* [`wolfSSL_CTX_SetRsaSignCb()`](ssl_8h.md#function-wolfssl_ctx_setrsasigncb)
* [`wolfSSL_CTX_SetRsaVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaverifycb)
* [`wolfSSL_CTX_SetRsaEncCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaenccb)
* [`wolfSSL_CTX_SetRsaDecCb()`](ssl_8h.md#function-wolfssl_ctx_setrsadeccb)

The user can set a context per `WOLFSSL` object (session) with:

* [`wolfSSL_SetEccSignCtx()`](ssl_8h.md#function-wolfssl_seteccsignctx)
* [`wolfSSL_SetEccVerifyCtx()`](ssl_8h.md#function-wolfssl_seteccverifyctx)
* `wolfSSL_SetEccSharedSecretCtx()`
* [`wolfSSL_SetRsaSignCtx()`](ssl_8h.md#function-wolfssl_setrsasignctx)
* [`wolfSSL_SetRsaVerifyCtx()`](ssl_8h.md#function-wolfssl_setrsaverifyctx)
* [`wolfSSL_SetRsaEncCtx()`](ssl_8h.md#function-wolfssl_setrsaencctx)
* [`wolfSSL_SetRsaDecCtx()`](ssl_8h.md#function-wolfssl_setrsadecctx)

These contexts may be pointers to any user-specified context, which will then in turn be passed back to the respective public key callback through the `void* ctx` parameter.

Example callbacks can be found in `wolfssl/test.h`, under `myEccSign()`, `myEccVerify()`, `myEccSharedSecret()`, `myRsaSign()`, `myRsaVerify()`, `myRsaEnc()`, and `myRsaDec()`.  Usage can be seen in the wolfSSL example client (`examples/client/client.c`), when using the `-P` command line option.

To use Atomic Record Layer callbacks, wolfSSL needs to be compiled using the [`--enable-pkcallbacks`](chapter02.md#enable-pkcallbacks) configure option, or by defining the `HAVE_PK_CALLBACKS` preprocessor flag.
