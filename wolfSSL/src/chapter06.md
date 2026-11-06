# Callbacks

## HandShake Callback

wolfSSL (formerly CyaSSL) has an extension that allows a HandShake Callback to be set for connect or accept. This can be useful in embedded systems for debugging support when another debugger isn’t available and sniffing is impractical. To use wolfSSL HandShake Callbacks, use the extended functions, [`wolfSSL_connect_ex()`](ssl_8h.md#function-wolfssl_connect_ex) and [`wolfSSL_accept_ex()`](ssl_8h.md#function-wolfssl_accept_ex):

```c
int wolfSSL_connect_ex(WOLFSSL* ssl, HandShakeCallBack hsCb,
                       TimeoutCallBack toCb, WOLFSSL_TIMEVAL timeout);
int wolfSSL_accept_ex(WOLFSSL* ssl, HandShakeCallBack hsCb,
                      TimeoutCallBack toCb, WOLFSSL_TIMEVAL timeout);
```

These functions, and `wolfssl/callbacks.h`, are only available when wolfSSL is built with [`WOLFSSL_CALLBACKS`](chapter02.md#wolfssl_callbacks) defined. There is no configure option for it, so add it through `CFLAGS`:

```sh
./configure CFLAGS="-DWOLFSSL_CALLBACKS"
```

Defining `WOLFSSL_CALLBACKS` also forces `LARGE_STATIC_BUFFERS` on. The timeout uses the POSIX `setitimer()` and `SIGALRM` interfaces, see [Timeout Callback](#timeout-callback).

`HandShakeCallBack` is defined as:

```c
typedef int (*HandShakeCallBack)(HandShakeInfo*);
```

`HandShakeInfo` is defined in `wolfssl/callbacks.h` (which should be added to a non-standard build):

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

The `ssl` member points to the connection the callback was issued for. No dynamic memory is used since the maximum number of SSL packets in a handshake exchange is known. Packet names can be accessed through `packetNames[idx]` up to `numberPackets`. The callback will be called whether or not a handshake error occurred.  Example usage is also in the client example.

## Timeout Callback

The same extensions used with wolfSSL Handshake Callbacks can be used for wolfSSL Timeout Callbacks as well. These extensions can be called with either, both, or neither callbacks (Handshake and/or Timeout). `TimeoutCallBack` is defined as:

```c
typedef int (*TimeoutCallBack)(TimeoutInfo*);
```

Where `TimeoutInfo` looks like:

```c
typedef struct timeoutInfo_st {
    char       timeoutName[MAX_TIMEOUT_NAME_SZ + 1]; /* timeout Name */
    int        flags;                              /* for future use */
    int        numberPackets;                      /* actual # of packets */
    PacketInfo packets[MAX_PACKETS_HANDSHAKE];     /* list of all packets  */
    WOLFSSL_TIMEVAL timeoutValue;                  /* timer that caused it */
} TimeoutInfo;
```

Again, no dynamic memory is used for this structure since a maximum number of SSL packets is known for a handshake. `WOLFSSL_TIMEVAL` is a typedef for `struct timeval` when `<sys/time.h>` is available (`HAVE_SYS_TIME_H`), and an equivalent structure with `tv_sec` and `tv_usec` members otherwise. The older name `Timeval` is kept as a macro alias for `WOLFSSL_TIMEVAL` unless `NO_OLD_TIMEVAL_NAME` is defined.

`PacketInfo` is defined like this:

```c
typedef struct packetInfo_st {
    char           packetName[MAX_PACKETNAME_SZ + 1]; /* SSL packet name */
    WOLFSSL_TIMEVAL timestamp;                       /* when it occurred    */
    unsigned char  value[MAX_VALUE_SZ];             /* if fits, it's here */
    unsigned char* bufferValue;                     /* otherwise here (non 0) */
    int            valueSz;                         /* sz of value or buffer */
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

Example callbacks can be found in `wolfssl/test.h`, under `myMacEncryptCb()` and `myDecryptVerifyCb()`.  Usage can be seen in the wolfSSL example client (`examples/client/client.c`), when using the `-U` command line option.

### Encrypt-Then-MAC Callbacks

When the Encrypt-Then-MAC extension (RFC 7366) is negotiated for a block cipher suite, wolfSSL calls a second pair of callbacks instead, which encrypt before computing the MAC and verify the MAC before decrypting. They are prototyped by `CallbackEncryptMac` and `CallbackVerifyDecrypt` in `ssl.h`:

```c
typedef int (*CallbackEncryptMac)(WOLFSSL* ssl, unsigned char* macOut,
       int content, int macVerify, unsigned char* encOut,
       const unsigned char* encIn, unsigned int encSz, void* ctx);

typedef int (*CallbackVerifyDecrypt)(WOLFSSL* ssl,
       unsigned char* decOut, const unsigned char* decIn,
       unsigned int decSz, int content, int verify, unsigned int* padSz,
       void* ctx);
```

Register them with `wolfSSL_CTX_SetEncryptMacCb()` and `wolfSSL_CTX_SetVerifyDecryptCb()`. The per-object context setters are `wolfSSL_SetEncryptMacCtx()` and `wolfSSL_SetVerifyDecryptCtx()`, but wolfSSL currently passes these callbacks the contexts set with `wolfSSL_SetMacEncryptCtx()` and `wolfSSL_SetDecryptVerifyCtx()`, so the example in `wolfssl/test.h` uses the same contexts for both pairs. The verify/decrypt callback is only used when a decrypt/verify callback is also registered. If you register a decrypt/verify callback and Encrypt-Then-MAC may be negotiated, register the verify/decrypt callback too, or disable the extension with `wolfSSL_CTX_AllowEncryptThenMac(ctx, 0)`. Example callbacks can be found in `wolfssl/test.h`, under `myEncryptMacCb()` and `myVerifyDecryptCb()`. Encrypt-Then-MAC support is enabled by default and controlled with the `--enable-enc-then-mac` configure option (`HAVE_ENCRYPT_THEN_MAC`).

To use Atomic Record Layer callbacks, wolfSSL needs to be compiled using the `--enable-atomicuser` configure option, or by defining the `ATOMIC_USER` preprocessor flag.

## Public Key Callbacks

wolfSSL provides Public Key (PK) callbacks for users who wish to have more control over DH, ECC, Ed25519, X25519, Ed448, X448, and RSA operations during the SSL/TLS connection.

To use Public Key callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` defined. This can be done using the configure option:

```sh
./configure --enable-pkcallbacks
```

Additionally, each callback type requires its specific feature to be enabled (e.g., `HAVE_DH`, `HAVE_ED25519`, etc.).

### DH Callbacks

wolfSSL provides DH (Diffie-Hellman) callbacks for users who wish to have more control over DH key generation and key agreement operations during the SSL/TLS connection.

The user can optionally define 2 functions:

1. DH key generation callback
2. DH key agreement callback

These functions are prototyped by `CallbackDhGenerateKeyPair` and `CallbackDhAgree` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetDhGenerateKeyPair()`
* `wolfSSL_CTX_SetDhAgreeCb()`

The user can set a context per WOLFSSL object (session) with `wolfSSL_SetDhAgreeCtx()`.

Example callbacks can be found in `wolfssl/test.h`, under `myDhCallback()`. Usage can be seen in the wolfSSL example client.

To use DH callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_DH` defined.

### Ed25519 Callbacks

wolfSSL provides Ed25519 callbacks for users who wish to have more control over Ed25519 sign/verify operations during the SSL/TLS connection.

The user can optionally define 2 functions:

1. Ed25519 sign callback
2. Ed25519 verify callback

These functions are prototyped by `CallbackEd25519Sign` and `CallbackEd25519Verify` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetEd25519SignCb()`
* `wolfSSL_CTX_SetEd25519VerifyCb()`

The user can set a context per WOLFSSL object (session) with:

* `wolfSSL_SetEd25519SignCtx()`
* `wolfSSL_SetEd25519VerifyCtx()`

Example callbacks can be found in `wolfssl/test.h`, under `myEd25519Sign()` and `myEd25519Verify()`. Usage can be seen in the wolfSSL example client.

To use Ed25519 callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_ED25519` defined.

### X25519 Callbacks

wolfSSL provides X25519 callbacks for users who wish to have more control over X25519 key generation and shared secret computation during the SSL/TLS connection.

The user can optionally define 2 functions:

1. X25519 key generation callback
2. X25519 shared secret callback

These functions are prototyped by `CallbackX25519KeyGen` and `CallbackX25519SharedSecret` in `ssl.h`:

```c
typedef int (*CallbackX25519KeyGen)(WOLFSSL* ssl, struct curve25519_key* key,
    unsigned int keySz, void* ctx);

typedef int (*CallbackX25519SharedSecret)(WOLFSSL* ssl,
        struct curve25519_key* otherKey,
        unsigned char* pubKeyDer, unsigned int* pubKeySz,
        unsigned char* out, unsigned int* outlen,
        int side, void* ctx);
```

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetX25519KeyGenCb()`
* `wolfSSL_CTX_SetX25519SharedSecretCb()`

The user can set a context per WOLFSSL object (session) with:

* `wolfSSL_SetX25519KeyGenCtx()`
* `wolfSSL_SetX25519SharedSecretCtx()`

Example callbacks can be found in `wolfssl/test.h`, under `myX25519KeyGen()` and `myX25519SharedSecret()`. Usage can be seen in the wolfSSL example client.

To use X25519 callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_CURVE25519` defined.

### Ed448 Callbacks

wolfSSL provides Ed448 callbacks for users who wish to have more control over Ed448 sign/verify operations during the SSL/TLS connection.

The user can optionally define 2 functions:

1. Ed448 sign callback
2. Ed448 verify callback

These functions are prototyped by `CallbackEd448Sign` and `CallbackEd448Verify` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetEd448SignCb()`
* `wolfSSL_CTX_SetEd448VerifyCb()`

The user can set a context per WOLFSSL object (session) with:

* `wolfSSL_SetEd448SignCtx()`
* `wolfSSL_SetEd448VerifyCtx()`

Example callbacks can be found in `wolfssl/test.h`, under `myEd448Sign()` and `myEd448Verify()`. Usage can be seen in the wolfSSL example client.

To use Ed448 callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_ED448` defined.

### X448 Callbacks

wolfSSL provides X448 callbacks for users who wish to have more control over X448 key generation and shared secret operations during the SSL/TLS connection.

The user can optionally define 2 functions:

1. X448 key generation callback
2. X448 shared secret callback

These functions are prototyped by `CallbackX448KeyGen` and `CallbackX448SharedSecret` in `ssl.h`:

```c
typedef int (*CallbackX448KeyGen)(WOLFSSL* ssl, struct curve448_key* key,
    unsigned int keySz, void* ctx);

typedef int (*CallbackX448SharedSecret)(WOLFSSL* ssl,
        struct curve448_key* otherKey,
        unsigned char* pubKeyDer, unsigned int* pubKeySz,
        unsigned char* out, unsigned int* outlen,
        int side, void* ctx);
```

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetX448KeyGenCb()`
* `wolfSSL_CTX_SetX448SharedSecretCb()`

The user can set a context per WOLFSSL object (session) with:

* `wolfSSL_SetX448KeyGenCtx()`
* `wolfSSL_SetX448SharedSecretCtx()`

Example callbacks can be found in `wolfssl/test.h`, under `myX448KeyGen()` and `myX448SharedSecret()`. Usage can be seen in the wolfSSL example client.

To use X448 callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_CURVE448` defined.

### RSA PSS Callbacks

wolfSSL provides RSA PSS callbacks for users who wish to have more control over RSA PSS sign/verify operations during the SSL/TLS connection.

The user can optionally define 3 functions:

1. RSA PSS sign callback
2. RSA PSS verify callback
3. RSA PSS sign check callback

These functions are prototyped by `CallbackRsaPssSign` and `CallbackRsaPssVerify` in `ssl.h`. The sign check callback uses the `CallbackRsaPssVerify` prototype:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetRsaPssSignCb()`
* `wolfSSL_CTX_SetRsaPssVerifyCb()`
* `wolfSSL_CTX_SetRsaPssSignCheckCb()`

The user can set a context per WOLFSSL object (session) with:

* `wolfSSL_SetRsaPssSignCtx()`
* `wolfSSL_SetRsaPssVerifyCtx()`

The sign check callback is called after wolfSSL has created an RSA PSS signature, to verify that signature and detect signing faults. It has no context setter of its own and receives the context set with `wolfSSL_SetRsaPssSignCtx()`. It returns the length of the data recovered into `out`, which wolfSSL then checks against the data that was signed, or 0 to skip the check (for example when the hardware already checks its signatures).

Example callbacks can be found in `wolfssl/test.h`, under `myRsaPssSign()`, `myRsaPssVerify()`, and `myRsaPssSignCheck()`. Usage can be seen in the wolfSSL example client.

To use RSA PSS callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `WC_RSA_PSS` defined.

### ECC Callbacks

wolfSSL provides ECC callbacks for users who wish to have more control over ECC key generation, ECDSA sign/verify and ECDH shared secret operations during the SSL/TLS connection.

The user can optionally define 4 functions:

1. ECC key generation callback
2. ECC sign callback
3. ECC verify callback
4. ECC shared secret callback

These functions are prototyped by `CallbackEccKeyGen`, `CallbackEccSign`, `CallbackEccVerify` and `CallbackEccSharedSecret` in `ssl.h`:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* `wolfSSL_CTX_SetEccKeyGenCb()`
* [`wolfSSL_CTX_SetEccSignCb()`](ssl_8h.md#function-wolfssl_ctx_seteccsigncb)
* [`wolfSSL_CTX_SetEccVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_seteccverifycb)
* `wolfSSL_CTX_SetEccSharedSecretCb()`

The user can set a context per `WOLFSSL` object (session) with:

* `wolfSSL_SetEccKeyGenCtx()`
* [`wolfSSL_SetEccSignCtx()`](ssl_8h.md#function-wolfssl_seteccsignctx)
* [`wolfSSL_SetEccVerifyCtx()`](ssl_8h.md#function-wolfssl_seteccverifyctx)
* `wolfSSL_SetEccSharedSecretCtx()`

These contexts may be pointers to any user-specified context, which will then in turn be passed back to the respective public key callback through the `void* ctx` parameter.

Example callbacks can be found in `wolfssl/test.h`, under `myEccKeyGen()`, `myEccSign()`, `myEccVerify()` and `myEccSharedSecret()`.

To use ECC callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` and `HAVE_ECC` defined.

### RSA Callbacks

wolfSSL provides RSA callbacks for users who wish to have more control over RSA sign/verify and encrypt/decrypt operations during the SSL/TLS connection.

The user can optionally define 5 functions:

1. RSA sign callback
2. RSA verify callback
3. RSA sign check callback
4. RSA encrypt callback
5. RSA decrypt callback

These functions are prototyped by `CallbackRsaSign`, `CallbackRsaVerify`, `CallbackRsaEnc` and `CallbackRsaDec` in `ssl.h`. The sign check callback uses the `CallbackRsaVerify` prototype:

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

The user needs to write and register these functions per wolfSSL context (`WOLFSSL_CTX`) with:

* [`wolfSSL_CTX_SetRsaSignCb()`](ssl_8h.md#function-wolfssl_ctx_setrsasigncb)
* [`wolfSSL_CTX_SetRsaVerifyCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaverifycb)
* `wolfSSL_CTX_SetRsaSignCheckCb()`
* [`wolfSSL_CTX_SetRsaEncCb()`](ssl_8h.md#function-wolfssl_ctx_setrsaenccb)
* [`wolfSSL_CTX_SetRsaDecCb()`](ssl_8h.md#function-wolfssl_ctx_setrsadeccb)

The user can set a context per `WOLFSSL` object (session) with:

* [`wolfSSL_SetRsaSignCtx()`](ssl_8h.md#function-wolfssl_setrsasignctx)
* [`wolfSSL_SetRsaVerifyCtx()`](ssl_8h.md#function-wolfssl_setrsaverifyctx)
* [`wolfSSL_SetRsaEncCtx()`](ssl_8h.md#function-wolfssl_setrsaencctx)
* [`wolfSSL_SetRsaDecCtx()`](ssl_8h.md#function-wolfssl_setrsadecctx)

The sign check callback is called after wolfSSL has created an RSA PKCS #1 v1.5 signature, to verify that signature and detect signing faults. It has no context setter of its own and receives the context set with `wolfSSL_SetRsaSignCtx()`. It returns the length of the data recovered into `out`, which wolfSSL then compares with the data that was signed, or 0 to skip the check (for example when the hardware already checks its signatures).

Example callbacks can be found in `wolfssl/test.h`, under `myRsaSign()`, `myRsaVerify()`, `myRsaSignCheck()`, `myRsaEnc()`, and `myRsaDec()`.

To use RSA callbacks, wolfSSL needs to be compiled with `HAVE_PK_CALLBACKS` defined and RSA enabled (`NO_RSA` not defined).

### Protocol Callbacks

`HAVE_PK_CALLBACKS` also enables callbacks for TLS protocol-level operations, which allow key derivation and record processing to be done by hardware (for example a secure element that holds the session keys). They are prototyped in `ssl.h`:

| Callback type | Register with | Operation |
| --- | --- | --- |
| `CallbackGenMasterSecret` | `wolfSSL_CTX_SetGenMasterSecretCb()` | Generate the TLS 1.2 master secret |
| `CallbackGenExtMasterSecret` | `wolfSSL_CTX_SetGenExtMasterSecretCb()` | Generate the extended master secret (RFC 7627) |
| `CallbackGenPreMaster` | `wolfSSL_CTX_SetGenPreMasterCb()` | Generate the pre-master secret for RSA key exchange |
| `CallbackGenSessionKey` | `wolfSSL_CTX_SetGenSessionKeyCb()` | Derive the session keys |
| `CallbackEncryptKeys` | `wolfSSL_CTX_SetEncryptKeysCb()` | Set up the record encryption keys |
| `CallbackTlsFinished` | `wolfSSL_CTX_SetTlsFinishedCb()` | Compute the TLS Finished message hash |
| `CallbackVerifyMac` | `wolfSSL_CTX_SetVerifyMacCb()` | Verify the MAC of a received block cipher record, TLS 1.2 and earlier (not in `WOLFSSL_AEAD_ONLY` builds) |
| `CallbackHKDFExtract` | `wolfSSL_CTX_SetHKDFExtractCb()` | TLS 1.3 HKDF-Extract (requires `HAVE_HKDF`) |
| `CallbackHKDFExpandLabel` | `wolfSSL_CTX_SetHKDFExpandLabelCb()` | TLS 1.3 HKDF-Expand-Label |
| `CallbackProcessServerSigKex` | `wolfSSL_CTX_SetProcessServerSigKexCb()` | Verify the ECDSA signature on a TLS 1.2 ServerKeyExchange |
| `CallbackPerformTlsRecordProcessing` | `wolfSSL_CTX_SetPerformTlsRecordProcessingCb()` | Encrypt or decrypt a TLS 1.2 AES-GCM or AES-CCM record |

Each of the first eight has a matching per-object context setter, for example `wolfSSL_SetGenMasterSecretCtx()` and `wolfSSL_SetHKDFExtractCtx()`. The last three take no context argument.

A callback can let wolfSSL perform the operation itself: the first seven return `PROTOCOLCB_UNAVAILABLE` for this, and `CallbackHKDFExpandLabel`, `CallbackProcessServerSigKex` and `CallbackPerformTlsRecordProcessing` return `NOT_COMPILED_IN`. When a `CallbackHKDFExtract` is registered, its result is always used.

Example callbacks can be found in `wolfssl/test.h`, under `myGenMaster()`, `myGenExtMaster()`, `myGenPreMaster()`, `myGenSessionKey()`, `mySetEncryptKeys()`, `myTlsFinished()`, `myVerifyMac()` and `myHkdfExtract()`. These examples, except `myHkdfExtract()`, return `PROTOCOLCB_UNAVAILABLE` so that wolfSSL falls back to its own implementation.

Usage of the public key and protocol callbacks can be seen in the wolfSSL example client (`examples/client/client.c`), when using the `-P` command line option.

To use Public Key callbacks, wolfSSL needs to be compiled using the [`--enable-pkcallbacks`](chapter02.md#--enable-pkcallbacks) configure option, or by defining the `HAVE_PK_CALLBACKS` preprocessor flag.


## Crypto Callbacks (cryptocb)

The Crypto callback framework in wolfSSL/wolfCrypt enables users to override the default implementation of select cryptographic algorithms and provide their own custom implementations at runtime. The most common use case for crypto callbacks is to offload an algorithm to custom hardware acceleration,  however it could also be used to add additional logging/introspection, retrieve keys from secure storage, to call crypto from another library for standards compliance reasons, or even to perform a remote procedure call.

### Using Crypto callbacks

The high level steps to use crypto callbacks are:

1. Compile wolfSSL with crypto callback support
2. Register a callback and unique device ID (`devId`) with wolfCrypt
3. Pass the `devId` as an argument to a wolfCrypt API function
4. (TLS only): associate the `devId` with a wolfSSL context


#### 1. Compile wolfSSL with crypto callback support
Support for crypto callbacks is enabled in wolfSSL via the `–-enable-cryptocb` configure option, or `#define WOLF_CRYPTO_CB`.

#### 2. Register your callback and unique devID with wolfCrypt

To use crypto callbacks, the user must register a top-level cryptographic callback function with wolfCrypt and provide a device ID (`devId`), which is an integer ID that uniquely identifies this particular callback function to wolfCrypt. This allows multiple crypto callbacks to be registered with wolfCrypt at once. The appropriate callback function will then be invoked internally by every wolfCrypt function that takes a `devId` parameter, or by wolfSSL when associated with a `WOLFSSL_CTX` or `WOLFSSL` structure.

To register a cryptographic callback function with wolfCrypt, use the `wc_CryptoCb_RegisterDevice` API. This takes a (`devId`), the callback function, and an optional user context that will be passed through to the callback when it is invoked.

```c
typedef int (*CryptoDevCallbackFunc)(int devId, wc_CryptoInfo* info, void* ctx);

WOLFSSL_API int wc_CryptoCb_RegisterDevice(int devId,
                                           CryptoDevCallbackFunc cb,
                                           void* ctx);
```

Note: A registered `devId` can be any value other than `-2`, which is reserved for the special `INVALID_DEVID` enum value. Passing `devId == INVALID_DEVID` as an argument into a wolfCrypt API indicates that no callback should be invoked and to use the default internal implementation instead.

#### 3. Pass the `devId` as an argument to a wolfCrypt API function

For wolfCrypt API’s, use the init functions that accept `devId` such as:

```text
wc_InitRsaKey_ex
wc_ecc_init_ex
wc_AesInit
wc_InitSha256_ex
wc_InitSha_ex
wc_HmacInit
wc_InitCmac_ex
```

This will cause wolfCrypt to invoke the crypto callback in place of the default implementation. This is not an exhaustive API list. Please refer to the wolfCrypt API documentation to see if a particular algorithm supports crypto callbacks.

#### 4. (TLS only): associate the devId with a wolfSSL context

To enable use of a crypto callback when using TLS, you must supply the `devId` arguments on initialization of a `WOLFSSL_CTX` or `WOLFSSL` struct.
```c
wolfSSL_CTX_SetDevId(ctx, devId);
wolfSSL_SetDevId(ssl, devId);
```
All relevant crypto for TLS connections associated with those structures will now invoke the crypto callback.

### Writing your crypto callback

When a crypto callback is invoked, it will need to know what cryptographic operation has been requested, as well as the location of the input and output data and how to communicate success/failure back to wolfCrypt. This information is relayed to the callback through the `wc_CryptoInfo* info` argument.

At a high level, a crypto callback should determine if it supports the requested operation, act on the input data, update the `wc_CryptoInfo *info` argument with any relevant output data, and return a valid wolfCrypt error code.

#### Determining the Type of Request

The `wc_CryptoInfo` structure contains a union of different structures (some of which are unions themselves), each corresponding to a specific type of cryptographic operation. The type of operation to be performed is determined by `info->algo_type`, which should be a variant of `enum wc_AlgoType` defined in `wolfssl/wolfcrypt/types.h`.  Based on this `algo_type`, the appropriate union element within `wc_CryptoInfo` can be accessed to get or set parameters specific to the operation. We can refer to this top-level union as the "algo type union".

To determine the type of cryptographic request and process it accordingly, one would typically use a switch-case statement on the `algo_type` field of the `wc_CryptoInfo` structure. Each case within the switch would correspond to a different cryptographic operation, such as a symmetric cipher, hashing, public key operations, etc. There is a one-to-one mapping between `wc_AlgoType` and the corresponding algo type union, which are commented in the `wc_CryptoInfo` struct definition in
`wolfssl/wolfcrypt/cryptocb.h`.

The crypto callback should return zero on success, or a valid wolfCrypt error code on failure. For unsupported algorithms, the callback should return `CRYPTOCB_UNAVAILABLE`, which will cause wolfCrypt to fall back to the internal implementation.

Here's a simplified example to illustrate this:

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

wolfSSL 5.9.4 adds one more request type the callback can receive: `WC_ALGO_TYPE_KEYSTORE` (built with `--enable-cryptocbutils=keystore`). These requests are lifetime operations on keys held in a hardware key store. There are seven of them: import and export in plaintext and wrapped form, derive, delete and get-info. The `wc_KeyStore_*` API in `wolfssl/wolfcrypt/wc_keystore.h` addresses keys by an opaque device-defined reference, which is how a device can create, wrap, derive and destroy keys that never appear in memory.

Some of the simpler algo type unions, such as the RNG and seed unions, require no further processing and can be immediately acted on. However, more complicated operations like cipher or public key types have multiple union variants unto themselves that must be conditionally interpreted in the same manner. The variants and levels of hierarchy of each union are specific to each category of algorithm type, the full definitions of which can be found in the definition of the `wc_CryptoInfo` structure. As a general rule, each level that is a union will contain some sort of type indicator informing how the rest of the union should be dereferenced.

Here is a simplified example for a complex algo type union with multiple levels of union decoding. The callback contains support for random number generation, as well as ECC key agreement, sign, and verify.

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

### Handling the request

The data structure for each type of request generally contains a pointer and associated size for input and output data. Depending on the request it may include additional data including cryptographic keys, nonces, or further configuration. The crypto callback should operate on the input data and write relevant output data back to the appropriate variant of the algo type union. Writing data to a union variant that does not correspond to the algorithm type in question (e.g. using `info->cipher`
when `info->algo_type == WC_ALGO_TYPE_RNG`) is a memory error and can result in undefined behavior.

### Asynchronous Crypto Callbacks

A crypto callback may return `WC_PENDING_E` to indicate that the operation was started on a device and has not completed. The application then drives the operation to completion with `wolfSSL_AsyncPoll()`. This requires asynchronous crypto support, enabled with the [`--enable-asynccrypt`](chapter02.md#--enable-asynccrypt) configure option (`WOLFSSL_ASYNC_CRYPT`), since `wolfSSL_AsyncPoll()` is only declared then. wolfSSL 5.9.4 extended the TLS 1.3 handshake to support this for the HKDF key schedule, transcript HMAC, AES-GCM record encrypt and decrypt, RNG, ECC and X25519 key shares, and ECDSA and Ed25519 sign and verify. For the TLS record ciphers specifically, define `WOLF_CRYPTO_CB_ASYNC_POLL` to use a poll-to-complete model; without it a pending bulk cipher returns `ASYNC_OP_E` rather than corrupting the record. `WOLFSSL_ASYNC_CERT_YIELD` additionally returns `WC_PENDING_E` after each certificate in a peer chain is verified so a cooperative scheduler can run.

### Device Registration

`wc_CryptoCb_RegisterDevice()` rejects a device ID that is already registered with `ALREADY_E`, returns `BAD_FUNC_ARG` for `devId == INVALID_DEVID`, and returns `BUFFER_E` when the device table is full. The table holds `MAX_CRYPTO_DEVID_CALLBACKS` entries (8 by default). `wc_CryptoCb_IsDeviceRegistered()` reports whether an ID is in use. If a device's register command registers further devices itself, it is not left holding a half-filled slot. `wc_CryptoCb_UnRegisterDevice()` removes a registration.

### Crypto-Callback-Only Builds

If a device always services an algorithm, you can compile its software implementation out. The `WOLF_CRYPTO_CB_ONLY_*` macros do this per algorithm: `WOLF_CRYPTO_CB_ONLY_SHA256`, `_SHA512`, `_AES`, `_RSA`, `_ECC`, `_ED25519`, `_CURVE25519`, `_CURVE448`, `_FALCON`, `_SLHDSA`, `_MLKEM`, `_MLDSA`, `_LMS`, `_XMSS` and `_FRODOKEM`. `--enable-cryptocb=only` sets all of them at once, for each of those algorithms that is enabled in the build. See [`--enable-cryptocb`](chapter02.md#--enable-cryptocb).

### Troubleshooting

Some older compilers don't allow "anonymous inline aggregates", which wolfCrypt uses when defining the nested `wc_CryptoInfo` anonymous unions in order to save space. To disable the use of anonymous inline aggregates, define the `HAVE_ANONYMOUS_INLINE_AGGREGATES` preprocessor macro as `0`. This will allow crypto callbacks to be used, but will dramatically increase the size of the `wc_CryptoInfo` structure.


### Examples

Full examples of crypto callbacks can be found in the following locations

* [VaultIC Crypto Callbacks](https://github.com/wolfSSL/wolfssl-examples/blob/master/ccb_vaultic/ccb_vaultic.c)
* [STSAFE-A100 ECC Crypto Callbacks](https://github.com/wolfSSL/wolfssl/blob/master/wolfcrypt/src/port/st/stsafe.c)
* [TPM 2.0 wolfTPM Crypto Callbacks](https://github.com/wolfSSL/wolfTPM/blob/master/src/tpm2_cryptocb.c)
* [Generic wolfCrypt tests](https://github.com/wolfSSL/wolfssl/blob/master/wolfcrypt/test/test.c)

## Other Callbacks

wolfSSL provides several other callbacks that are set on a `WOLFSSL_CTX` or `WOLFSSL` object. The certificate verification callback (`wolfSSL_CTX_set_verify()`) is described in [Client Authentication](chapter04.md#client-authentication), and the PSK callbacks (`wolfSSL_CTX_set_psk_client_callback()` and `wolfSSL_CTX_set_psk_server_callback()`) in [Pre-Shared Keys](chapter04.md#pre-shared-keys). The table below lists the others. See `wolfssl/ssl.h` for their prototypes.

| Callback | Register with | Requires |
| --- | --- | --- |
| Session ticket encryption (server) | `wolfSSL_CTX_set_TicketEncCb()` | `HAVE_SESSION_TICKET` (`--enable-session-ticket`) |
| Session ticket received (client) | `wolfSSL_set_SessionTicket_cb()` | `HAVE_SESSION_TICKET` (`--enable-session-ticket`) |
| SNI received (server) | `wolfSSL_CTX_set_servername_callback()` | `HAVE_SNI` (`--enable-sni`) |
| ALPN protocol selection (server) | `wolfSSL_CTX_set_alpn_select_cb()` | `HAVE_ALPN` (`--enable-alpn`) and one of `OPENSSL_ALL`, `WOLFSSL_NGINX`, `WOLFSSL_HAPROXY`, `HAVE_LIGHTY` or `WOLFSSL_QUIC` |
| Certificate selection during the handshake | `wolfSSL_CTX_set_cert_cb()` | `WOLFSSL_CERT_SETUP_CB` (`--enable-cert-setup-cb`, or `OPENSSL_EXTRA`) |
| CA certificate added to the CA cache | `wolfSSL_CTX_SetCACb()` | Certificate support (`NO_CERTS` not defined) |
| CRL missing for a certificate | `wolfSSL_CTX_SetCRL_Cb()` | `HAVE_CRL` (`--enable-crl`) |
| CRL retrieval I/O | `wolfSSL_CTX_SetCRL_IOCb()` | `HAVE_CRL_IO` (`--enable-crl=io`) |
| OCSP request I/O | `wolfSSL_CTX_SetOCSP_Cb()` | `HAVE_OCSP` (`--enable-ocsp`) |
| TLS key logging (NSS key log format) | `wolfSSL_CTX_set_keylog_callback()` | `OPENSSL_EXTRA` and `HAVE_SECRET_CALLBACK` |
| New session established | `wolfSSL_CTX_sess_set_new_cb()` | Session cache enabled and `OPENSSL_EXTRA` or `HAVE_EXT_CACHE` |


