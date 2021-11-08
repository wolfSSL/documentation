# Callbacks

## HandShake Callback

wolfSSL (formerly CyaSSL) has an extension that allows a HandShake Callback to be set for connect or accept. This can be useful in embedded systems for debugging support when another debugger isn’t available and sniffing is impractical. To use wolfSSL HandShake Callbacks, use the extended functions, [`wolfSSL_connect_ex()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a5d2408875a1fe331e30a623f646eb70a) and [`wolfSSL_accept_ex()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a523f6fed6dc20d36b5a3a879bd0c4443):

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with [`wolfSSL_CTX_SetMacEncryptCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ab0109ef252d8aaa6431686ae02257167) and [`wolfSSL_CTX_SetDecryptVerifyCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ac4f33720644775462b34c5e07ba2e7a8).

The user can set a context per WOLFSSL object (session) with [`wolfSSL_SetMacEncryptCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#aa6e621ce15b642cc28a914f1e3419fa1) and [`wolfSSL_SetDecryptVerifyCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#af82e1440ee3196e9a976e5f975392243).  This context may be a pointer to any user-specified context, which will then in turn be passed back to the MAC/encrypt and decrypt/verify callbacks through the `void* ctx` parameter.

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

* [`wolfSSL_CTX_SetEccSignCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9fd0345508d38eec20c19362cd95264c)
* [`wolfSSL_CTX_SetEccVerifyCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a5171ed4e529ad25952da2613bdd743ed)
* `wolfSSL_CTX_SetEccSharedSecretCb()`
* [`wolfSSL_CTX_SetRsaSignCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a1439b43133dcee4dd9cda5ddf37d6519)
* [`wolfSSL_CTX_SetRsaVerifyCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#acbbbe34c7b31f19c49b1dac4dd116642)
* [`wolfSSL_CTX_SetRsaEncCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#aa1b5c0f2c0ad6fa9d89fd15a6ebad07f)
* [`wolfSSL_CTX_SetRsaDecCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a45fdf8ad76687b817ce6be01636a39f5)

The user can set a context per `WOLFSSL` object (session) with:

* [`wolfSSL_SetEccSignCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a42982be436d4235d5120304df29a7d3b)
* [`wolfSSL_SetEccVerifyCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a70777d4fe3af5c93228ec5ce478e9c5e)
* `wolfSSL_SetEccSharedSecretCtx()`
* [`wolfSSL_SetRsaSignCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a5176742435268cac9f4af058e67e5f24)
* [`wolfSSL_SetRsaVerifyCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a0f52acf05d9e716f07f621eeef0704e1)
* [`wolfSSL_SetRsaEncCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a5023a347493a3ccdf49a2c385956ff1a)
* [`wolfSSL_SetRsaDecCtx()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ace0b2cf667bd82264ba1e61c66ce3c6d)

These contexts may be pointers to any user-specified context, which will then in turn be passed back to the respective public key callback through the `void* ctx` parameter.

Example callbacks can be found in `wolfssl/test.h`, under `myEccSign()`, `myEccVerify()`, `myEccSharedSecret()`, `myRsaSign()`, `myRsaVerify()`, `myRsaEnc()`, and `myRsaDec()`.  Usage can be seen in the wolfSSL example client (`examples/client/client.c`), when using the `-P` command line option.

To use Atomic Record Layer callbacks, wolfSSL needs to be compiled using the [`--enable-pkcallbacks`](chapter02.md#enable-pkcallbacks) configure option, or by defining the `HAVE_PK_CALLBACKS` preprocessor flag.
