# wolfCrypt Usage Reference

wolfCrypt is the cryptography library primarily used by wolfSSL. It is optimized for speed, small footprint, and portability. wolfSSL interchanges with other cryptography libraries as required.

Types used in the examples:

```c
typedef unsigned char byte;
typedef unsigned int  word32;
```

When the library was built with `./configure`, include `<wolfssl/options.h>` before any other wolfSSL header so that the application is compiled with the same settings as the library.

## Hash Functions

### MD4

**NOTE**:  MD4 is outdated and considered insecure. Please consider using a different hashing function if possible.

MD4 is disabled by default; enable it with [`--enable-md4`](chapter02.md#--enable-md4). To use MD4 include the MD4 header `wolfssl/wolfcrypt/md4.h`. The structure to use is `wc_Md4`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitMd4()`](group__MD4.md#function-wc_initmd4) call. Use [`wc_Md4Update()`](group__MD4.md#function-wc_md4update) to update the hash and [`wc_Md4Final()`](group__MD4.md#function-wc_md4final) to retrieve the final hash.

```c
byte md4sum[WC_MD4_DIGEST_SIZE];
byte buffer[1024];
/* fill buffer with data to hash*/

wc_Md4 md4;
wc_InitMd4(&md4);

wc_Md4Update(&md4, buffer, sizeof(buffer));  /*can be called again
                                and again*/
wc_Md4Final(&md4, md4sum);
```

`md4sum` now contains the digest of the hashed data in buffer.

### MD5

**NOTE**:  MD5 is outdated and considered insecure. Please consider using a different hashing function if possible.

MD5 has been disabled by default since wolfSSL 5.8.2; enable it with [`--enable-md5`](chapter02.md#--enable-md5). To use MD5 include the MD5 header `wolfssl/wolfcrypt/md5.h`. The structure to use is `wc_Md5`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitMd5()`](group__MD5.md#function-wc_initmd5) call. Use [`wc_Md5Update()`](group__MD5.md#function-wc_md5update) to update the hash, [`wc_Md5Final()`](group__MD5.md#function-wc_md5final) to retrieve the final hash, and [`wc_Md5Free()`](group__MD5.md#function-wc_md5free) to release the context:

```c
byte md5sum[WC_MD5_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

wc_Md5 md5;
wc_InitMd5(&md5);

wc_Md5Update(&md5, buffer, sizeof(buffer));  /*can be called again
                                and again*/
wc_Md5Final(&md5, md5sum);
wc_Md5Free(&md5);
```

`md5sum` now contains the digest of the hashed data in buffer.

### SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512

To use SHA include the SHA header `wolfssl/wolfcrypt/sha.h`. The structure to use is `wc_Sha`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitSha()`](group__SHA.md#function-wc_initsha) call. Use [`wc_ShaUpdate()`](group__SHA.md#function-wc_shaupdate) to update the hash, [`wc_ShaFinal()`](group__SHA.md#function-wc_shafinal) to retrieve the final hash, and [`wc_ShaFree()`](group__SHA.md#function-wc_shafree) to release the context:

```c
byte shaSum[WC_SHA_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

wc_Sha sha;
wc_InitSha(&sha);

wc_ShaUpdate(&sha, buffer, sizeof(buffer));  /*can be called again
                                          and again*/
wc_ShaFinal(&sha, shaSum);
wc_ShaFree(&sha);
```

`shaSum` now contains the digest of the hashed data in buffer.

To use either SHA-224, SHA-256, SHA-384, or SHA-512, follow the same steps as shown above, but use either the `wolfssl/wolfcrypt/sha256.h` or `wolfssl/wolfcrypt/sha512.h` (for both SHA-384 and SHA-512).  The SHA-256, SHA-384, and SHA-512 functions are named similarly to the SHA functions.

For **SHA-224**, the functions [`wc_InitSha224()`](group__SHA.md#function-wc_initsha224), [`wc_Sha224Update()`](group__SHA.md#function-wc_sha224update), and [`wc_Sha224Final()`](group__SHA.md#function-wc_sha224final) will be used with the structure `wc_Sha224`.

For **SHA-256**, the functions [`wc_InitSha256()`](group__SHA.md#function-wc_initsha256), [`wc_Sha256Update()`](group__SHA.md#function-wc_sha256update), and [`wc_Sha256Final()`](group__SHA.md#function-wc_sha256final) will be used with the structure `wc_Sha256`.

For **SHA-384**, the functions [`wc_InitSha384()`](group__SHA.md#function-wc_initsha384), [`wc_Sha384Update()`](group__SHA.md#function-wc_sha384update), and [`wc_Sha384Final()`](group__SHA.md#function-wc_sha384final) will be used with the structure `wc_Sha384`.

For **SHA-512**, the functions [`wc_InitSha512()`](group__SHA.md#function-wc_initsha512), [`wc_Sha512Update()`](group__SHA.md#function-wc_sha512update), and [`wc_Sha512Final()`](group__SHA.md#function-wc_sha512final) will be used with the structure `wc_Sha512`.

The truncated variants **SHA-512/224** and **SHA-512/256** are also in `wolfssl/wolfcrypt/sha512.h`. They use the `wc_Sha512` structure with `wc_InitSha512_224()`, `wc_Sha512_224Update()` and `wc_Sha512_224Final()` (or the `wc_InitSha512_256()` family). The digest sizes are `WC_SHA224_DIGEST_SIZE`, `WC_SHA256_DIGEST_SIZE`, `WC_SHA384_DIGEST_SIZE`, `WC_SHA512_DIGEST_SIZE`, `WC_SHA512_224_DIGEST_SIZE` and `WC_SHA512_256_DIGEST_SIZE`. When a context is no longer needed, release it with the matching `Free` function (`wc_Sha224Free()`, `wc_Sha256Free()`, `wc_Sha384Free()`, `wc_Sha512Free()`, `wc_Sha512_224Free()` or `wc_Sha512_256Free()`).

More than one hash context can be in progress at the same time (interleaved). Software SHA has always supported interleaving. The `NO_WOLFSSL_SHA256_INTERLEAVE` macro does not change the library; it only stops the wolfCrypt test application from exercising interleaved hash contexts on hardware ports that cannot do it (for example, it is set for the NXP LPC55S6x).

### SHA-3 / SHAKE

SHA-3 (FIPS 202) and the SHAKE128 / SHAKE256 extendable output functions are declared in `wolfssl/wolfcrypt/sha3.h`. They are enabled by default (ML-KEM, which is also on by default, requires them) and are controlled with [`--enable-sha3`](chapter02.md#--enable-sha3), `--enable-shake128` and `--enable-shake256`. The structure to use for SHA-3 is `wc_Sha3`. For SHA3-256, initialize it with [`wc_InitSha3_256()`](group__SHA.md#function-wc_initsha3_256), then use [`wc_Sha3_256_Update()`](group__SHA.md#function-wc_sha3_256_update), [`wc_Sha3_256_Final()`](group__SHA.md#function-wc_sha3_256_final) and [`wc_Sha3_256_Free()`](group__SHA.md#function-wc_sha3_256_free). SHA3-224, SHA3-384 and SHA3-512 work the same way with `224`, `384` or `512` in the function names.

```c
byte sha3Sum[WC_SHA3_256_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

wc_Sha3 sha3;
wc_InitSha3_256(&sha3, NULL, INVALID_DEVID);

wc_Sha3_256_Update(&sha3, buffer, sizeof(buffer));  /*can be called again
                                                 and again*/
wc_Sha3_256_Final(&sha3, sha3Sum);
wc_Sha3_256_Free(&sha3);
```

`sha3Sum` now contains the digest of the hashed data in buffer.

SHAKE uses the `wc_Shake` structure and produces output of any requested length, which is passed to the `Final` call. For SHAKE256, use [`wc_InitShake256()`](group__SHA.md#function-wc_initshake256), [`wc_Shake256_Update()`](group__SHA.md#function-wc_shake256_update), [`wc_Shake256_Final()`](group__SHA.md#function-wc_shake256_final) and [`wc_Shake256_Free()`](group__SHA.md#function-wc_shake256_free); the SHAKE128 functions are named the same way.

```c
byte out[64];       /*any output length*/
byte buffer[1024];
/*fill buffer with data to hash*/

wc_Shake shake;
wc_InitShake256(&shake, NULL, INVALID_DEVID);

wc_Shake256_Update(&shake, buffer, sizeof(buffer));
wc_Shake256_Final(&shake, out, sizeof(out));
wc_Shake256_Free(&shake);
```

### BLAKE2b

BLAKE2b is disabled by default; enable it with [`--enable-blake2`](chapter02.md#--enable-blake2b). To use BLAKE2b (a SHA-3 finalist) include the BLAKE2b header `wolfssl/wolfcrypt/blake2.h`. The structure to use is `Blake2b`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b) call. Use [`wc_Blake2bUpdate()`](group__BLAKE2.md#function-wc_blake2bupdate) to update the hash and [`wc_Blake2bFinal()`](group__BLAKE2.md#function-wc_blake2bfinal) to retrieve the final hash:

```c
byte digest[64];
byte input[64];     /*fill input with data to hash*/

Blake2b b2b;
wc_InitBlake2b(&b2b, 64);

wc_Blake2bUpdate(&b2b, input, sizeof(input));
wc_Blake2bFinal(&b2b, digest, 64);
```

The second parameter to [`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b) should be the final digest size. `digest` now contains the digest of the hashed data in `input`.

Example usage can be found in the wolfCrypt test application (`wolfcrypt/test/test.c`), inside the `blake2b_test()` function.

### RIPEMD-160

RIPEMD-160 is disabled by default; enable it with [`--enable-ripemd`](chapter02.md#--enable-ripemd). To use RIPEMD-160, include the header `wolfssl/wolfcrypt/ripemd.h`. The structure to use is `RipeMd`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitRipeMd()`](group__RIPEMD.md#function-wc_initripemd) call. Use [`wc_RipeMdUpdate()`](group__RIPEMD.md#function-wc_ripemdupdate) to update the hash and [`wc_RipeMdFinal()`](group__RIPEMD.md#function-wc_ripemdfinal) to retrieve the final hash

```c
byte ripeMdSum[RIPEMD_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

RipeMd ripemd;
wc_InitRipeMd(&ripemd);

wc_RipeMdUpdate(&ripemd, buffer, sizeof(buffer));  /*can be called
                                        again and again*/
wc_RipeMdFinal(&ripemd, ripeMdSum);
```

`ripeMdSum` now contains the digest of the hashed data in buffer.

## Keyed Hash Functions

### HMAC

wolfCrypt currently provides HMAC for message digest needs. The structure `Hmac` is found in the header `wolfssl/wolfcrypt/hmac.h`. HMAC initialization is done with `wc_HmacInit()` followed by [`wc_HmacSetKey()`](group__HMAC.md#function-wc_hmacsetkey), and `wc_HmacFree()` releases the context when done. Supported hash types are MD5, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512, SHA-512/224, SHA-512/256, SHA3-224, SHA3-256, SHA3-384, SHA3-512 and SM3 (each when enabled in the build; MD5 is rejected in FIPS builds). Here's an example with SHA-256.

```c
Hmac    hmac;
byte    key[24];        /*fill key with keying material*/
byte    buffer[2048];   /*fill buffer with data to digest*/
byte    hmacDigest[WC_SHA256_DIGEST_SIZE];

wc_HmacInit(&hmac, NULL, INVALID_DEVID);
wc_HmacSetKey(&hmac, WC_SHA256, key, sizeof(key));
wc_HmacUpdate(&hmac, buffer, sizeof(buffer));
wc_HmacFinal(&hmac, hmacDigest);
wc_HmacFree(&hmac);
```

`hmacDigest` now contains the digest of the hashed data in buffer.

### GMAC

wolfCrypt also provides GMAC for message digest needs. The structure `Gmac` is found in the header `wolfssl/wolfcrypt/aes.h`, as it is an application of AES-GCM. A `Gmac` holds an `Aes` object, which is initialized with [`wc_AesInit()`](group__AES.md#function-wc_aesinit) and released with [`wc_AesFree()`](group__AES.md#function-wc_aesfree). The key is set with [`wc_GmacSetKey()`](group__AES.md#function-wc_gmacsetkey). [`wc_GmacUpdate()`](group__AES.md#function-wc_gmacupdate) is a one-shot call that computes the tag over the whole buffer, not a streaming update.

```c
Gmac gmac;
byte key[16];         /*fill key with keying material*/
byte iv[12];          /*fill iv with an initialization vector*/
byte buffer[2048];    /*fill buffer with data to digest*/
byte gmacDigest[16];

wc_AesInit(&gmac.aes, NULL, INVALID_DEVID);
wc_GmacSetKey(&gmac, key, sizeof(key));
wc_GmacUpdate(&gmac, iv, sizeof(iv), buffer, sizeof(buffer),
              gmacDigest, sizeof(gmacDigest));
wc_AesFree(&gmac.aes);
```

`gmacDigest` now contains the digest of the hashed data in buffer.

### Poly1305

wolfCrypt also provides Poly1305 for message digest needs. The structure `Poly1305` is found in the header `wolfssl/wolfcrypt/poly1305.h`. Poly1305 initialization is done with [`wc_Poly1305SetKey()`](group__Poly1305.md#function-wc_poly1305setkey). The process of setting a key in Poly1305 should be done again, with a new key, when next using Poly1305 after [`wc_Poly1305Final()`](group__Poly1305.md#function-wc_poly1305final) has been called.

```c
Poly1305    pmac;
byte           key[32];        /*fill key with keying material*/
byte           buffer[2048];   /*fill buffer with data to digest*/
byte           pmacDigest[16];

wc_Poly1305SetKey(&pmac, key, sizeof(key));
wc_Poly1305Update(&pmac, buffer, sizeof(buffer));
wc_Poly1305Final(&pmac, pmacDigest);
```

`pmacDigest` now contains the digest of the hashed data in buffer.

### KMAC and cSHAKE

wolfCrypt includes the two SP 800-185 functions derived from SHA-3: cSHAKE (customizable SHAKE) and KMAC (Keccak Message Authentication Code). They are enabled with [`--enable-cshake`](chapter02.md#--enable-cshake) and [`--enable-kmac`](chapter02.md#--enable-kmac) respectively, and both are declared in `wolfssl/wolfcrypt/sha3.h`. KMAC works on a key plus an optional customization string. It can produce a fixed-length tag with `wc_Kmac128_Final()` / `wc_Kmac256_Final()`, or an output of arbitrary length with `wc_Kmac128_FinalXof()` / `wc_Kmac256_FinalXof()`.

```c
wc_Kmac kmac;
byte    key[32];        /*fill key with keying material*/
byte    buffer[2048];   /*fill buffer with data to authenticate*/
byte    tag[32];

wc_InitKmac256(&kmac, key, sizeof(key), (const byte*)"My App", 6,
               NULL, INVALID_DEVID);
wc_Kmac256_Update(&kmac, buffer, sizeof(buffer));
wc_Kmac256_Final(&kmac, tag, sizeof(tag));
wc_Kmac256_Free(&kmac);
```

`tag` now contains the KMAC256 authentication tag of the data in buffer. The one-shot functions [`wc_Kmac128Hash()`](group__SHA.md#function-wc_kmac128hash) and [`wc_Kmac256Hash()`](group__SHA.md#function-wc_kmac256hash) compute a tag in a single call.

cSHAKE follows the same pattern with the `wc_Cshake` structure: [`wc_InitCshake256()`](group__SHA.md#function-wc_initcshake256) takes a function-name string and a customization string (either may be empty), followed by `wc_Cshake256_Update()`, `wc_Cshake256_Final()` (which takes the requested output length) and `wc_Cshake256_Free()`. The one-shot [`wc_Cshake256()`](group__SHA.md#function-wc_cshake256) does all of this in one call. The cSHAKE128 functions are named the same way.

## Password Hashing

### Argon2

Argon2 (RFC 9106) is a memory-hard password hashing function. It has been available in wolfSSL since 5.9.4 with [`--enable-argon2`](chapter02.md#--enable-argon2), covering all three variants: Argon2d, Argon2i and Argon2id. The API is in `wolfssl/wolfcrypt/argon2.h`. The one-shot `wc_Argon2()` function derives a single tag from a password, salt, and the memory, time and parallelism cost parameters:

```c
byte password[] = "password";
byte salt[16];          /*fill salt with random bytes*/
byte tag[32];
int  ret;

ret = wc_Argon2(WC_ARGON2_ID, tag, sizeof(tag),
                password, sizeof(password) - 1, salt, sizeof(salt),
                4 /*parallelism*/, 65536 /*memory in KiB*/, 3 /*passes*/);
```

If an application derives many tags with the same parameters, the context API (`wc_Argon2Init()`, `wc_Argon2SetParams()`, `wc_Argon2DeriveTag()`, `wc_Argon2Free()`) is the better fit; it allocates the memory block array once and reuses it. With [`--enable-argon2-threads`](chapter02.md#--enable-argon2-threads) the segments of a slice are filled in parallel, and `wc_Argon2SetThreads()` sets the thread count for a context. Either way, threading does not change the derived tag.

## Block Ciphers

### AES

wolfCrypt provides support for AES with key sizes of 16 bytes (128 bits), 24 bytes (192 bits), or 32 bytes (256 bits). Supported AES modes include CBC, CTR, GCM (GCM-Streaming), GCM-SIV, OFB, CFB(1, 8, 128), SIV, EAX, CTS, XTS (XTS-Streaming), GMAC, CMAC, ECB, KW (KeyWrap), and CCM. CBC and GCM are enabled by default; most other modes have their own configure option, for example [`--enable-aesctr`](chapter02.md#--enable-aesctr), [`--enable-aesccm`](chapter02.md#--enable-aesccm), [`--enable-aesgcm-stream`](chapter02.md#--enable-aesgcm-stream), [`--enable-aeseax`](chapter02.md#--enable-aeseax) and [`--enable-aescts`](chapter02.md#--enable-aescts).

**NOTE**: [`wc_AesInit()`](group__AES.md#function-wc_aesinit) should always be called first to initialize the `Aes` structure, before calling other `Aes` API functions such as [`wc_AesSetKey()`](group__AES.md#function-wc_aessetkey), and [`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey).

CBC mode is supported for both encryption and decryption and is provided through the [`wc_AesSetKey()`](group__AES.md#function-wc_aessetkey), [`wc_AesCbcEncrypt()`](group__AES.md#function-wc_aescbcencrypt) and [`wc_AesCbcDecrypt()`](group__AES.md#function-wc_aescbcdecrypt) functions. Please include the header `wolfssl/wolfcrypt/aes.h` to use AES. AES has a block size of 16 bytes and the IV should also be 16 bytes. Function usage is usually as follows:

```c
Aes enc;
Aes dec;

const byte key[] = {  /*some 24 byte key*/ };
const byte iv[] = { /*some 16 byte iv*/ };

byte plain[32];   /*an increment of 16, fill with data*/
byte cipher[32];

wc_AesInit(&enc, NULL, INVALID_DEVID);
wc_AesInit(&dec, NULL, INVALID_DEVID);

/*encrypt*/
wc_AesSetKey(&enc, key, sizeof(key), iv, AES_ENCRYPTION);
wc_AesCbcEncrypt(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_AesSetKey(&dec, key, sizeof(key), iv, AES_DECRYPTION);
wc_AesCbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext. When an `Aes` object is no longer needed, release it with [`wc_AesFree()`](group__AES.md#function-wc_aesfree); some hardware ports require this:

```c
wc_AesFree(&enc);
wc_AesFree(&dec);
```

wolfCrypt also supports CTR (Counter), GCM (Galois/Counter), and CCM (Counter with CBC-MAC) modes of operation for AES.  When using these modes, like CBC, include the `wolfssl/wolfcrypt/aes.h` header.

GCM mode is available for both encryption and decryption through the [`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey), [`wc_AesGcmEncrypt()`](group__AES.md#function-wc_aesgcmencrypt), and [`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt) functions; see the AES-GCM example below.  For more usage examples, see the `aesgcm_test()` function in `<wolfssl_root>/wolfcrypt/test/test.c`.

CCM mode is supported for both encryption and decryption through the [`wc_AesCcmSetKey()`](group__AES.md#function-wc_aesccmsetkey), [`wc_AesCcmEncrypt()`](group__AES.md#function-wc_aesccmencrypt), and [`wc_AesCcmDecrypt()`](group__AES.md#function-wc_aesccmdecrypt) functions. Authentication tag sizes of 4, 6, 8, 10, 12, 14 or 16 bytes are accepted, so CCM-8 (an 8 byte tag) is one option. CCM requires [`--enable-aesccm`](chapter02.md#--enable-aesccm).  For a usage example, see the `aesccm_test()` function in `<wolfssl_root>/wolfcrypt/test/test.c`.

CTR mode is available for both encryption and decryption through the [`wc_AesCtrEncrypt()`](group__AES.md#function-wc_aesctrencrypt) function, and requires [`--enable-aesctr`](chapter02.md#--enable-aesctr). The encrypt and decrypt actions are identical so the same function is used for both. For that reason the key must be set with `AES_ENCRYPTION` for both directions, either through `wc_AesSetKey()` or with [`wc_AesCtrSetKey()`](group__AES.md#function-wc_aesctrsetkey). For a usage example, see the function `aes_ctr_test()` in file `wolfcrypt/test/test.c`.

AES-GCM-SIV (RFC 8452), a nonce misuse resistant AEAD, is available with [`--enable-aesgcm-siv`](chapter02.md#--enable-aesgcm-siv). It comes as one-shot `wc_AesGcmSivEncrypt()` and `wc_AesGcmSivDecrypt()` functions, which take the key, nonce, additional data, and input directly rather than an `Aes` object. For a usage example, see the AES-GCM-SIV test in `wolfcrypt/test/test.c`.

AES Key Wrap (RFC 3394) is provided by `wc_AesKeyWrap()` / `wc_AesKeyUnWrap()` with [`--enable-aeskeywrap`](chapter02.md#--enable-aeskeywrap). The padded variant, AES Key Wrap with Padding (RFC 5649), accepts key material that is not a multiple of 8 bytes; it is provided by `wc_AesKeyWrap_Pad()` / `wc_AesKeyUnWrap_Pad()` with `--enable-aeskeywrap=padding`.

#### AES-GCM

AES-GCM is an AEAD (authenticated encryption with additional data) mode and is enabled by default. It takes a key, a nonce (IV) that must never be reused with the same key, optional additional authenticated data (`aad`) that is authenticated but not encrypted, and produces a ciphertext of the same length as the plaintext plus an authentication tag. A 12 byte nonce and a 16 byte tag are recommended:

```c
Aes  aes;
byte key[32];        /*fill with a 16, 24 or 32 byte key*/
byte iv[12];         /*a unique 12 byte nonce for each message*/
byte aad[16];        /*additional authenticated data, may be omitted*/
byte plain[64];      /*fill with data, any length*/
byte cipher[64];
byte tag[16];
int  ret;

wc_AesInit(&aes, NULL, INVALID_DEVID);
wc_AesGcmSetKey(&aes, key, sizeof(key));
wc_AesGcmEncrypt(&aes, cipher, plain, sizeof(plain), iv, sizeof(iv),
                 tag, sizeof(tag), aad, sizeof(aad));
```

`cipher` and `tag` now hold the ciphertext and the authentication tag; both are sent to the receiver along with `iv` and `aad`. [`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt) checks the tag and returns `AES_GCM_AUTH_E` if the ciphertext, tag or additional data were altered, in which case `plain` must not be used:

```c
/*decrypt and check the tag; a non-zero return means the data was altered*/
ret = wc_AesGcmDecrypt(&aes, plain, cipher, sizeof(cipher), iv, sizeof(iv),
                       tag, sizeof(tag), aad, sizeof(aad));
wc_AesFree(&aes);
```

In FIPS builds `wc_AesGcmEncrypt()` with a caller-supplied IV is not approved; generate the IV inside the module with [`wc_AesGcmSetIV()`](group__AES.md#function-wc_aesgcmsetiv) and encrypt with [`wc_AesGcmEncrypt_ex()`](group__AES.md#function-wc_aesgcmencrypt_ex) instead.

When the data is not all available at once, the streaming API (`--enable-aesgcm-stream`, which defines `WOLFSSL_AESGCM_STREAM`) processes it in pieces. [`wc_AesGcmEncryptInit()`](group__AES.md#function-wc_aesgcmencryptinit) sets the key and IV (pass a `NULL` key to keep the current one), each call to [`wc_AesGcmEncryptUpdate()`](group__AES.md#function-wc_aesgcmencryptupdate) takes the next piece of plaintext and/or additional data (all of the additional data must be passed before the first byte of plaintext), and [`wc_AesGcmEncryptFinal()`](group__AES.md#function-wc_aesgcmencryptfinal) produces the tag. The result is identical to the one-shot call above:

```c
wc_AesInit(&aes, NULL, INVALID_DEVID);
wc_AesGcmEncryptInit(&aes, key, sizeof(key), iv, sizeof(iv));
wc_AesGcmEncryptUpdate(&aes, NULL, NULL, 0, aad, sizeof(aad));
wc_AesGcmEncryptUpdate(&aes, cipher, plain, 32, NULL, 0);
wc_AesGcmEncryptUpdate(&aes, cipher + 32, plain + 32, 32, NULL, 0);
wc_AesGcmEncryptFinal(&aes, tag, sizeof(tag));
wc_AesFree(&aes);
```

Decryption uses [`wc_AesGcmDecryptInit()`](group__AES.md#function-wc_aesgcmdecryptinit), [`wc_AesGcmDecryptUpdate()`](group__AES.md#function-wc_aesgcmdecryptupdate) and [`wc_AesGcmDecryptFinal()`](group__AES.md#function-wc_aesgcmdecryptfinal) in the same way. `wc_AesGcmDecryptFinal()` checks the tag and returns `AES_GCM_AUTH_E` on a mismatch; since the plaintext pieces are returned before the tag has been checked, they must not be trusted until it succeeds. [`wc_AesGcmInit()`](group__AES.md#function-wc_aesgcminit) can be used in place of either `Init` function.

### DES and 3DES

DES and 3DES are disabled by default; enable them with [`--enable-des3`](chapter02.md#--enable-des3). wolfCrypt provides support for DES and 3DES (Des3 since 3 is an invalid leading C identifier). To use these include the header `wolfssl/wolfcrypt/des3.h`. The structures you can use are `Des` and `Des3`. Initialization is done through [`wc_Des_SetKey()`](group__DES.md#function-wc_des_setkey) or [`wc_Des3_SetKey()`](group__DES.md#function-wc_des3_setkey). CBC encryption/decryption is provided through [`wc_Des_CbcEncrypt()`](group__DES.md#function-wc_des_cbcencrypt) / [`wc_Des_CbcDecrypt()`](group__DES.md#function-wc_des_cbcdecrypt) and [`wc_Des3_CbcEncrypt()`](group__DES.md#function-wc_des3_cbcencrypt) / [`wc_Des3_CbcDecrypt()`](group__DES.md#function-wc_des3_cbcdecrypt). Des has a key size of 8 bytes (24 for 3DES) and the block size is 8 bytes, so only pass increments of 8 bytes to encrypt/decrypt functions. If your data isn't in a block size increment you'll need to add padding to make sure it is. Each `SetKey()` also takes an IV, which is one block (8 bytes) for both DES and 3DES. Usage is usually like the following:

```c
Des3 enc;
Des3 dec;

const byte key[] = {  /*some 24 byte key*/ };
const byte iv[]  = {  /*some 8 byte iv*/  };

byte plain[24];   /*an increment of 8, fill with data*/
byte cipher[24];

/*encrypt*/
wc_Des3_SetKey(&enc, key, iv, DES_ENCRYPTION);
wc_Des3_CbcEncrypt(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_Des3_SetKey(&dec, key, iv, DES_DECRYPTION);
wc_Des3_CbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

### Camellia

wolfCrypt provides support for the Camellia block cipher, which is disabled by default; enable it with [`--enable-camellia`](chapter02.md#--enable-camellia). To use Camellia include the header `wolfssl/wolfcrypt/camellia.h`. The structure you can use is called `wc_Camellia`. Initialization is done through [`wc_CamelliaSetKey()`](group__Camellia.md#function-wc_camelliasetkey). CBC encryption/decryption is provided through [`wc_CamelliaCbcEncrypt()`](group__Camellia.md#function-wc_camelliacbcencrypt) and [`wc_CamelliaCbcDecrypt()`](group__Camellia.md#function-wc_camelliacbcdecrypt) while direct encryption/decryption is provided through [`wc_CamelliaEncryptDirect()`](group__Camellia.md#function-wc_camelliaencryptdirect) and [`wc_CamelliaDecryptDirect()`](group__Camellia.md#function-wc_camelliadecryptdirect).

For usage examples please see the camellia_test() function in `<wolfssl_root>/wolfcrypt/test/test.c`.

## Stream Ciphers

### ARC4

**NOTE**: ARC4 is outdated and considered insecure. Please consider using a different stream cipher.

ARC4 is disabled by default; enable it with [`--enable-arc4`](chapter02.md#--enable-arc4). wolfCrypt supports ARC4 through the header `wolfssl/wolfcrypt/arc4.h`.  Usage is simpler than block ciphers because there is no block size and the key length can be any length. The following is a typical usage of ARC4.

```c
Arc4 enc;
Arc4 dec;

const byte key[] = {  /*some key any length*/};

byte plain[27];   /*no size restriction, fill with data*/
byte cipher[27];

/*encrypt*/
wc_Arc4SetKey(&enc, key, sizeof(key));
wc_Arc4Process(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_Arc4SetKey(&dec, key, sizeof(key));
wc_Arc4Process(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

### ChaCha

ChaCha with 20 rounds is slightly faster than ARC4 while maintaining a high level of security.  To use it with wolfCrypt, please include the header `wolfssl/wolfcrypt/chacha.h`. ChaCha typically uses 32 byte keys (256 bit) but can also use 16 byte keys (128 bits).

```c
ChaCha enc;
ChaCha dec;

const byte key[] = {  /*some key 32 bytes*/};
const byte iv[]  = {  /*some iv 12 bytes*/ };

byte plain[37];   /*no size restriction, fill with data*/
byte cipher[37];

/*encrypt*/
wc_Chacha_SetKey(&enc, key, sizeof(key));
wc_Chacha_SetIV(&enc, iv, 0); /*the last argument is the start block
                                counter, usually 0*/
wc_Chacha_Process(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_Chacha_SetKey(&dec, key, sizeof(key));
wc_Chacha_SetIV(&dec, iv, 0);
wc_Chacha_Process(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

[`wc_Chacha_SetKey`](group__ChaCha.md#function-wc_chacha_setkey) only needs to be set once but for each packet of information sent [`wc_Chacha_SetIV()`](group__ChaCha.md#function-wc_chacha_setiv) must be called with a new iv (nonce). Counter is set as an argument to allow for partially decrypting/encrypting information by starting at a different block when performing the encrypt/decrypt process, but in most cases is set to 0. **ChaCha should not be used without a mac algorithm (e.g. Poly1305, hmac).** The combined ChaCha20-Poly1305 AEAD described below does this for you.

XChaCha20, a variant with a 24 byte nonce, is available with [`--enable-xchacha`](chapter02.md#--enable-xchacha); its key and nonce are set together with [`wc_XChacha_SetKey()`](group__ChaCha.md#function-wc_xchacha_setkey).

### ChaCha20-Poly1305

ChaCha20-Poly1305 (RFC 8439) is an AEAD that combines the ChaCha20 stream cipher with the Poly1305 authenticator. It is enabled by default and declared in `wolfssl/wolfcrypt/chacha20_poly1305.h`. The one-shot [`wc_ChaCha20Poly1305_Encrypt()`](group__ChaCha20Poly1305.md#function-wc_chacha20poly1305_encrypt) takes a 32 byte key, a 12 byte nonce that must be unique for each message under the same key, and optional additional authenticated data, and outputs the ciphertext (the same length as the plaintext) and a 16 byte tag:

```c
byte key[CHACHA20_POLY1305_AEAD_KEYSIZE];    /*32 byte key*/
byte iv[CHACHA20_POLY1305_AEAD_IV_SIZE];     /*12 byte nonce, unique per message*/
byte aad[16];                                /*additional authenticated data*/
byte plain[64];                              /*fill with data, any length*/
byte cipher[64];
byte tag[CHACHA20_POLY1305_AEAD_AUTHTAG_SIZE]; /*16 byte tag*/
int  ret;

ret = wc_ChaCha20Poly1305_Encrypt(key, iv, aad, sizeof(aad),
                                  plain, sizeof(plain), cipher, tag);
```

[`wc_ChaCha20Poly1305_Decrypt()`](group__ChaCha20Poly1305.md#function-wc_chacha20poly1305_decrypt) checks the tag before returning the plaintext, and returns `MAC_CMP_FAILED_E` if the ciphertext, tag or additional data were altered:

```c
/*decrypt and check the tag; a non-zero return means the data was altered*/
ret = wc_ChaCha20Poly1305_Decrypt(key, iv, aad, sizeof(aad),
                                  cipher, sizeof(cipher), tag, plain);
```

For data that arrives in pieces, [`wc_ChaCha20Poly1305_Init()`](group__ChaCha20Poly1305.md#function-wc_chacha20poly1305_init), `wc_ChaCha20Poly1305_UpdateAad()`, `wc_ChaCha20Poly1305_UpdateData()` and `wc_ChaCha20Poly1305_Final()` provide a streaming interface. With `--enable-xchacha`, XChaCha20-Poly1305 is available through `wc_XChaCha20Poly1305_Encrypt()` and `wc_XChaCha20Poly1305_Decrypt()`, which take a 24 byte nonce.

## Random Number Generation

wolfCrypt's random number generator is declared in `wolfssl/wolfcrypt/random.h`. The structure to use is `WC_RNG`. By default it is a Hash_DRBG (NIST SP 800-90A) seeded from the operating system's entropy source. Initialize it once with [`wc_InitRng()`](group__Random.md#function-wc_initrng), draw random bytes with [`wc_RNG_GenerateBlock()`](group__Random.md#function-wc_rng_generateblock) (at most `RNG_MAX_BLOCK_LEN`, 64 KiB, per call) or a single byte with [`wc_RNG_GenerateByte()`](group__Random.md#function-wc_rng_generatebyte), and release it with [`wc_FreeRng()`](group__Random.md#function-wc_freerng):

```c
WC_RNG rng;
byte   block[32];

wc_InitRng(&rng);                  /*returns 0 on success*/
wc_RNG_GenerateBlock(&rng, block, sizeof(block));
wc_FreeRng(&rng);
```

The same initialized `WC_RNG` can be passed to all of the public key functions below. Do not call `wc_InitRng()` again on an RNG that is already initialized without freeing it first, as that leaks resources.

## Public Key Cryptography

### RSA

wolfCrypt provides support for RSA through the header `wolfssl/wolfcrypt/rsa.h`. There are two types of RSA keys, public and private. A public key allows anyone to encrypt something that only the holder of the private key can decrypt. It also allows the private key holder to sign something and anyone with a public key can verify that only the private key holder actually signed it. Usage is usually like the following:

```c
RsaKey rsaPublicKey;

byte publicKeyBuffer[]  = { /*holds the raw data from the key, maybe
                        from a file like RsaPublicKey.der*/ };
word32 idx = 0;            /*where to start reading into the buffer*/

wc_InitRsaKey(&rsaPublicKey, NULL);
wc_RsaPublicKeyDecode(publicKeyBuffer, &idx, &rsaPublicKey, sizeof(publicKeyBuffer));

byte in[] = { /*plain text to encrypt*/ };
byte out[256];             /*256 bytes for a 2048-bit key*/
WC_RNG rng;

wc_InitRng(&rng);

int outLen = wc_RsaPublicEncrypt(in, sizeof(in), out, sizeof(out), &rsaPublicKey, &rng);
if (outLen < 0) {
    /*error*/
}
```

Now `out` holds the ciphertext from the plain text `in`. [`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt) will return the length in bytes written to out or a negative number in case of an error. [`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt) needs a RNG (Random Number Generator) for the padding used by the encryptor and it must be initialized before it can be used. This function uses PKCS #1 v1.5 padding; OAEP padding is available through [`wc_RsaPublicEncrypt_ex()`](group__RSA.md#function-wc_rsapublicencrypt_ex). To make sure that the output buffer is large enough to pass you can first call [`wc_RsaEncryptSize()`](group__RSA.md#function-wc_rsaencryptsize) which will return the number of bytes that a successful call to [`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt) will write.

In the event of an error, a negative return from [`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt), or [`wc_RsaPublicKeyDecode()`](group__RSA.md#function-wc_rsapublickeydecode) for that matter, you can call [`wc_ErrorString()`](group__Error.md#function-wc_errorstring) to get a string describing the error that occurred.

```c
void wc_ErrorString(int error, char* buffer);
```

Make sure that buffer is at least `WOLFSSL_MAX_ERROR_SZ` bytes (80).

Now to decrypt out. With RSA blinding enabled (`WC_RSA_BLINDING`, which is on by default unless the library is built with [`--disable-harden`](chapter02.md#--disable-harden)), [`wc_RsaPrivateDecrypt()`](group__RSA.md#function-wc_rsaprivatedecrypt) needs an RNG set on the key with [`wc_RsaSetRNG()`](group__RSA.md#function-wc_rsasetrng); otherwise it fails with `MISSING_RNG_E`:

```c
RsaKey rsaPrivateKey;

byte privateKeyBuffer[] = { /*hold the raw data from the key, maybe
                              from a file like RsaPrivateKey.der*/ };
idx = 0;                   /*where to start reading into the buffer*/

wc_InitRsaKey(&rsaPrivateKey, NULL);
wc_RsaPrivateKeyDecode(privateKeyBuffer, &idx, &rsaPrivateKey,
                       sizeof(privateKeyBuffer));
wc_RsaSetRNG(&rsaPrivateKey, &rng);

byte plain[256];
int plainSz = wc_RsaPrivateDecrypt(out, outLen, plain,
                       sizeof(plain), &rsaPrivateKey);
```

Now plain will hold plainSz bytes, or plainSz is a negative error code. When finished, free the keys and the RNG:

```c
wc_FreeRsaKey(&rsaPublicKey);
wc_FreeRsaKey(&rsaPrivateKey);
wc_FreeRng(&rng);
```

For complete examples of each type in wolfCrypt please see the file `wolfcrypt/test/test.c`.  Note that the [`wc_RsaPrivateKeyDecode`](group__RSA.md#function-wc_rsaprivatekeydecode) function only accepts keys in raw `DER` format.

### DH (Diffie-Hellman)

wolfCrypt provides support for Diffie-Hellman through the header `wolfssl/wolfcrypt/dh.h`.  The Diffie-Hellman key exchange algorithm allows two parties to establish a shared secret key.  Usage is usually similar to the following example, where **sideA** and **sideB** designate the two parties.

In the following example, `dhPublicKey` holds the Diffie-Hellman group parameters (p, g), for example loaded from a DER parameters file such as `certs/dh2048.der`.  `privA` holds the generated private key for sideA, `pubA` holds the generated public key for sideA, and `agreeA` holds the mutual key that both sides have agreed on. The size arguments are in/out: they hold the buffer size on input and the number of bytes written on output.

```c
DhKey  dhPublicKey;
word32 idx = 0;  /*where to start reading into the
                   publicKeyBuffer*/
WC_RNG rng;

byte   privA[256];
byte   pubA[256];
byte   agreeA[256];
byte   pubB[256];      /*public key received from sideB*/
word32 privASz = sizeof(privA);
word32 pubASz = sizeof(pubA);
word32 agreeASz = sizeof(agreeA);
word32 pubBSz = 0;     /*set to the length of the key received from sideB*/

wc_InitDhKey(&dhPublicKey);

byte publicKeyBuffer[] = { /*holds the raw data from the public key
                             parameters, maybe from a file like
                             dh2048.der*/ };
wc_DhKeyDecode(publicKeyBuffer, &idx, &dhPublicKey, sizeof(publicKeyBuffer));
wc_InitRng(&rng);  /*Initialize random number generator*/
```

[`wc_DhGenerateKeyPair()`](group__Diffie-Hellman.md#function-wc_dhgeneratekeypair) will generate a public and private DH key based on the initial public parameters in dhPublicKey.

```c
wc_DhGenerateKeyPair(&dhPublicKey, &rng, privA, &privASz,
            pubA, &pubASz);
```

After sideB sends their public key (`pubB`) to sideA, sideA can then generate the mutually-agreed key(`agreeA`) using the [`wc_DhAgree()`](group__Diffie-Hellman.md#function-wc_dhagree) function.

```c
wc_DhAgree(&dhPublicKey, agreeA, &agreeASz, privA, privASz,
           pubB, pubBSz);
```

Now, `agreeA` holds sideA's mutually-generated key (of size `agreeASz` bytes).  The same process will have been done on sideB. When finished, free the key and the RNG:

```c
wc_FreeDhKey(&dhPublicKey);
wc_FreeRng(&rng);
```

For a complete example of Diffie-Hellman in wolfCrypt, see the file `wolfcrypt/test/test.c`.

### EDH (Ephemeral Diffie-Hellman)

 A wolfSSL server can do Ephemeral Diffie-Hellman.  No build changes are needed to add this feature, though an application will have to register the ephemeral group parameters on the server side to enable the EDH cipher suites.  The following API can be used to do this:

```c
int wolfSSL_SetTmpDH(WOLFSSL* ssl, const unsigned char* p,
                   int pSz, const unsigned char* g, int gSz);
```

The parameters can also be set for every connection of a context with [`wolfSSL_CTX_SetTmpDH()`](group__CertsKeys.md#function-wolfssl_ctx_settmpdh), or loaded from a PEM or DER parameters file or buffer with [`wolfSSL_SetTmpDH_file()`](group__CertsKeys.md#function-wolfssl_settmpdh_file) and [`wolfSSL_SetTmpDH_buffer()`](group__CertsKeys.md#function-wolfssl_settmpdh_buffer) (and their `wolfSSL_CTX_` equivalents). The example server and echoserver load `certs/dh2048.pem` with `wolfSSL_SetTmpDH_file()`, and only fall back to `SetDH()` (in `wolfssl/test.h`), which calls `wolfSSL_SetTmpDH()`, when there is no filesystem.

### DSA (Digital Signature Algorithm)

DSA is disabled by default; enable it with [`--enable-dsa`](chapter02.md#--enable-dsa). wolfCrypt provides support for DSA and DSS through the header `wolfssl/wolfcrypt/dsa.h`.  DSA allows for the creation of a digital signature based on a given data hash.  DSA uses the SHA hash algorithm to generate a hash of a block of data, then signs that hash using the signer's private key.  Standard usage is similar to the following.

We first declare our DSA key structure (`key`), initialize our initial message (`message`) to be signed, and initialize our DSA key buffer (`dsaKeyBuffer`).

```c
DsaKey key;
byte   message[]      = { /*message data to sign*/ };
byte   dsaKeyBuffer[] = { /*holds the raw data from the DSA key,
                            maybe from a file like dsa2048.der*/ };
```

We then declare our SHA structure (`sha`), random number generator (`rng`), array to store our SHA hash (`hash`), array to store our signature (`signature`), `idx` (to mark where to start reading in our `dsaKeyBuffer`), and an int (`answer`) to hold our return value after verification.

```c
wc_Sha sha;
WC_RNG rng;
byte   hash[WC_SHA_DIGEST_SIZE];
byte   signature[40];
word32 idx = 0;
int    answer;
```

Set up and create the SHA hash.  For more information on wolfCrypt's SHA algorithm, see [SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512](#sha-sha-224-sha-256-sha-384-sha-512). The SHA hash of `message` is stored in the variable `hash`.

```c
wc_InitSha(&sha);
wc_ShaUpdate(&sha, message, sizeof(message));
wc_ShaFinal(&sha, hash);
wc_ShaFree(&sha);
```

Initialize the DSA key structure, populate the structure key value, and initialize the random number generator (`rng`).

```c
wc_InitDsaKey(&key);
wc_DsaPrivateKeyDecode(dsaKeyBuffer, &idx, &key,
                       sizeof(dsaKeyBuffer));
wc_InitRng(&rng);
```

The [`wc_DsaSign()`](group__DSA.md#function-wc_dsasign) function creates a signature (`signature`) using the DSA private key, hash value, and random number generator.

```c
wc_DsaSign(hash, signature, &key, &rng);
```

To verify the signature, use [`wc_DsaVerify()`](group__DSA.md#function-wc_dsaverify). If verification is successful, answer will be equal to "**1**". Once finished, free the DSA key structure using [`wc_FreeDsaKey()`](group__DSA.md#function-wc_freedsakey), and free the RNG.

```c
wc_DsaVerify(hash, signature, &key, &answer);
wc_FreeDsaKey(&key);
wc_FreeRng(&rng);
```

### ECC (ECDSA and ECDH)

Elliptic curve cryptography is enabled by default and is declared in `wolfssl/wolfcrypt/ecc.h`. The key structure is `ecc_key`, initialized with [`wc_ecc_init()`](group__ECC.md#function-wc_ecc_init) and released with [`wc_ecc_free()`](group__ECC.md#function-wc_ecc_free). [`wc_ecc_make_key_ex()`](group__ECC.md#function-wc_ecc_make_key_ex) generates a key pair; it takes the key size in bytes and a curve identifier such as `ECC_SECP256R1`, `ECC_SECP384R1` or `ECC_SECP521R1`.

ECDSA signs a hash of the message, not the message itself. [`wc_ecc_sign_hash()`](group__ECC.md#function-wc_ecc_sign_hash) writes a DER encoded signature, so the signature buffer should be `ECC_MAX_SIG_SIZE` bytes (or [`wc_ecc_sig_size()`](group__ECC.md#function-wc_ecc_sig_size) for a given key) and the actual length is returned in `sigSz`. [`wc_ecc_verify_hash()`](group__ECC.md#function-wc_ecc_verify_hash) returns 0 when it could perform the check and reports the result separately in `verified`, so both must be checked:

```c
ecc_key key;
WC_RNG  rng;
byte    hash[WC_SHA256_DIGEST_SIZE];  /*SHA-256 hash of the message*/
byte    sig[ECC_MAX_SIG_SIZE];
word32  sigSz = sizeof(sig);
int     verified = 0;
int     ret;

wc_InitRng(&rng);
wc_ecc_init(&key);
wc_ecc_make_key_ex(&rng, 32, &key, ECC_SECP256R1);

/*sign: sig receives a DER encoded ECDSA signature of sigSz bytes*/
wc_ecc_sign_hash(hash, sizeof(hash), sig, &sigSz, &rng, &key);

/*verify: the return value only reports errors, check verified as well*/
ret = wc_ecc_verify_hash(sig, sigSz, hash, sizeof(hash), &verified, &key);
if (ret == 0 && verified == 1) {
    /*signature is valid*/
}

wc_ecc_free(&key);
wc_FreeRng(&rng);
```

For ECDH, each side generates a key pair on the same curve and sends its public key to the other side, for example in ANSI X9.63 format with [`wc_ecc_export_x963()`](group__ECC.md#function-wc_ecc_export_x963). The peer's public key is loaded with [`wc_ecc_import_x963()`](group__ECC.md#function-wc_ecc_import_x963), and [`wc_ecc_shared_secret()`](group__ECC.md#function-wc_ecc_shared_secret) computes the shared secret. With the default timing resistant build (`ECC_TIMING_RESISTANT`), the private key needs an RNG set with [`wc_ecc_set_rng()`](group__ECC.md#function-wc_ecc_set_rng), otherwise `wc_ecc_shared_secret()` fails with `MISSING_RNG_E`:

```c
ecc_key priv;          /*our key pair*/
ecc_key peer;          /*the other side's public key*/
WC_RNG  rng;
byte    pub[ECC_BUFSIZE];      /*our public key, to send to the peer*/
word32  pubSz = sizeof(pub);
byte    peerPub[ECC_BUFSIZE];  /*public key received from the peer*/
word32  peerPubSz = 0;         /*set to the length received*/
byte    secret[32];
word32  secretSz = sizeof(secret);

wc_InitRng(&rng);
wc_ecc_init(&priv);
wc_ecc_init(&peer);
wc_ecc_make_key_ex(&rng, 32, &priv, ECC_SECP256R1);
wc_ecc_export_x963(&priv, pub, &pubSz);

/*send pub to the peer and receive peerPub, then:*/
wc_ecc_import_x963(peerPub, peerPubSz, &peer);
wc_ecc_set_rng(&priv, &rng);
wc_ecc_shared_secret(&priv, &peer, secret, &secretSz);

wc_ecc_free(&priv);
wc_ecc_free(&peer);
wc_FreeRng(&rng);
```

`secret` now holds `secretSz` bytes of shared secret, which is the same on both sides. It should be passed through a key derivation function (for example HKDF) before it is used as a key. For more examples, see the `ecc_test()` function in `wolfcrypt/test/test.c`.

### Curve25519 (X25519)

X25519 key agreement (RFC 7748) is disabled by default; enable it with [`--enable-curve25519`](chapter02.md#--enable-curve25519). It is declared in `wolfssl/wolfcrypt/curve25519.h` and uses the `curve25519_key` structure. Public keys are 32 bytes (`CURVE25519_KEYSIZE`) and are exchanged with [`wc_curve25519_export_public()`](group__Curve25519.md#function-wc_curve25519_export_public) and [`wc_curve25519_import_public()`](group__Curve25519.md#function-wc_curve25519_import_public):

```c
curve25519_key priv;      /*our key pair*/
curve25519_key peer;      /*the other side's public key*/
WC_RNG rng;
byte   pub[CURVE25519_KEYSIZE];      /*our public key, to send to the peer*/
word32 pubSz = sizeof(pub);
byte   peerPub[CURVE25519_KEYSIZE];  /*public key received from the peer*/
byte   secret[CURVE25519_KEYSIZE];
word32 secretSz = sizeof(secret);

wc_InitRng(&rng);
wc_curve25519_init(&priv);
wc_curve25519_init(&peer);
wc_curve25519_make_key(&rng, CURVE25519_KEYSIZE, &priv);
wc_curve25519_export_public(&priv, pub, &pubSz);

/*send pub to the peer and receive peerPub, then:*/
wc_curve25519_import_public(peerPub, sizeof(peerPub), &peer);
wc_curve25519_shared_secret(&priv, &peer, secret, &secretSz);

wc_curve25519_free(&priv);
wc_curve25519_free(&peer);
wc_FreeRng(&rng);
```

[`wc_curve25519_make_key()`](group__Curve25519.md#function-wc_curve25519_make_key) also associates the RNG with the key, for builds that use X25519 blinding (`WOLFSSL_CURVE25519_BLINDING`, the default for the C implementation). If the private key is imported instead, call [`wc_curve25519_set_rng()`](group__Curve25519.md#function-wc_curve25519_set_rng) on it in such builds before [`wc_curve25519_shared_secret()`](group__Curve25519.md#function-wc_curve25519_shared_secret).

### Ed25519

Ed25519 signatures (RFC 8032) are disabled by default; enable them with [`--enable-ed25519`](chapter02.md#--enable-ed25519). They are declared in `wolfssl/wolfcrypt/ed25519.h` and use the `ed25519_key` structure. Unlike ECDSA, Ed25519 signs the message itself, and the signature is always 64 bytes (`ED25519_SIG_SIZE`):

```c
ed25519_key key;
WC_RNG rng;
byte   msg[] = { /*message to sign, any length*/ };
byte   sig[ED25519_SIG_SIZE];
word32 sigSz = sizeof(sig);
int    verified = 0;
int    ret;

wc_InitRng(&rng);
wc_ed25519_init(&key);
wc_ed25519_make_key(&rng, ED25519_KEY_SIZE, &key);

wc_ed25519_sign_msg(msg, sizeof(msg), sig, &sigSz, &key);

ret = wc_ed25519_verify_msg(sig, sigSz, msg, sizeof(msg), &verified, &key);
if (ret == 0 && verified == 1) {
    /*signature is valid*/
}

wc_ed25519_free(&key);
wc_FreeRng(&rng);
```

The public key can be exported for the verifier with [`wc_ed25519_export_public()`](group__ED25519.md#function-wc_ed25519_export_public) and loaded with `wc_ed25519_import_public()`.

## Post-Quantum Cryptography

wolfCrypt has its own implementations of the NIST post-quantum algorithms. This section covers ML-KEM and ML-DSA; for SLH-DSA, Falcon, LMS/HSS, XMSS and their use in TLS 1.3, see [Experimenting with Post-Quantum Cryptography](appendix09.md).

### ML-KEM

ML-KEM (FIPS 203) is a key encapsulation mechanism and is enabled by default ([`--enable-mlkem`](chapter02.md#--disable-mlkem)). It is declared in `wolfssl/wolfcrypt/wc_mlkem.h` and uses the `MlKemKey` structure. The parameter set is chosen when the key is initialized with [`wc_MlKemKey_Init()`](group__ML__KEM.md#function-wc_mlkemkey_init): `WC_ML_KEM_512`, `WC_ML_KEM_768` or `WC_ML_KEM_1024`.

The receiving side generates a key pair with [`wc_MlKemKey_MakeKey()`](group__ML__KEM.md#function-wc_mlkemkey_makekey) and sends its public key to the other side. The sending side calls [`wc_MlKemKey_Encapsulate()`](group__ML__KEM.md#function-wc_mlkemkey_encapsulate) with that public key, which produces a ciphertext and a 32 byte shared secret (`WC_ML_KEM_SS_SZ`), and sends the ciphertext back. The receiving side recovers the same shared secret from the ciphertext with [`wc_MlKemKey_Decapsulate()`](group__ML__KEM.md#function-wc_mlkemkey_decapsulate). In the following example a single key plays both roles:

```c
MlKemKey key;
WC_RNG   rng;
byte     ct[WC_ML_KEM_MAX_CIPHER_TEXT_SIZE];  /*ciphertext*/
byte     ssA[WC_ML_KEM_SS_SZ];                /*shared secret, 32 bytes*/
byte     ssB[WC_ML_KEM_SS_SZ];
word32   ctSz;

wc_InitRng(&rng);
wc_MlKemKey_Init(&key, WC_ML_KEM_768, NULL, INVALID_DEVID);
wc_MlKemKey_MakeKey(&key, &rng);
wc_MlKemKey_CipherTextSize(&key, &ctSz);

/*the peer encapsulates against our public key...*/
wc_MlKemKey_Encapsulate(&key, ct, ssB, &rng);
/*...and we decapsulate the ciphertext it sends back*/
wc_MlKemKey_Decapsulate(&key, ssA, ct, ctSz);
/*ssA and ssB now hold the same shared secret*/

wc_MlKemKey_Free(&key);
wc_FreeRng(&rng);
```

In a real exchange, the public key is encoded with [`wc_MlKemKey_EncodePublicKey()`](group__ML__KEM.md#function-wc_mlkemkey_encodepublickey) (its length is given by `wc_MlKemKey_PublicKeySize()`), and the other side loads it into its own `MlKemKey`, initialized with the same parameter set, with [`wc_MlKemKey_DecodePublicKey()`](group__ML__KEM.md#function-wc_mlkemkey_decodepublickey) before encapsulating. [`wc_MlKemKey_CipherTextSize()`](group__ML__KEM.md#function-wc_mlkemkey_ciphertextsize) and [`wc_MlKemKey_SharedSecretSize()`](group__ML__KEM.md#function-wc_mlkemkey_sharedsecretsize) return the sizes for the key's parameter set.

### ML-DSA

ML-DSA (FIPS 204) is a digital signature algorithm. It is disabled by default; enable it with [`--enable-mldsa`](chapter02.md#--enable-mldsa). It is declared in `wolfssl/wolfcrypt/wc_mldsa.h` and uses the `wc_MlDsaKey` structure. After [`wc_MlDsaKey_Init()`](group__ML__DSA.md#function-wc_mldsakey_init), the parameter set is selected with [`wc_MlDsaKey_SetParams()`](group__ML__DSA.md#function-wc_mldsakey_setparams): `WC_ML_DSA_44`, `WC_ML_DSA_65` or `WC_ML_DSA_87`.

[`wc_MlDsaKey_SignCtx()`](group__ML__DSA.md#function-wc_mldsakey_signctx) and [`wc_MlDsaKey_VerifyCtx()`](group__ML__DSA.md#function-wc_mldsakey_verifyctx) sign and verify a message with a FIPS 204 context string, which may be empty (`NULL`, 0). Signatures are large: `WC_MLDSA_44_SIG_SIZE`, `WC_MLDSA_65_SIG_SIZE` and `WC_MLDSA_87_SIG_SIZE` are 2420, 3309 and 4627 bytes, and [`wc_MlDsaKey_GetSigLen()`](group__ML__DSA.md#function-wc_mldsakey_getsiglen) returns the size for a key. As with ECDSA, check both the return value and `verified`:

```c
wc_MlDsaKey key;
WC_RNG rng;
byte   msg[] = { /*message to sign, any length*/ };
byte   sig[WC_MLDSA_65_SIG_SIZE];
word32 sigSz = sizeof(sig);
int    verified = 0;
int    ret;

wc_InitRng(&rng);
wc_MlDsaKey_Init(&key, NULL, INVALID_DEVID);
wc_MlDsaKey_SetParams(&key, WC_ML_DSA_65);
wc_MlDsaKey_MakeKey(&key, &rng);

/*sign with an empty FIPS 204 context string*/
wc_MlDsaKey_SignCtx(&key, NULL, 0, sig, &sigSz, msg, sizeof(msg), &rng);

ret = wc_MlDsaKey_VerifyCtx(&key, sig, sigSz, NULL, 0, msg, sizeof(msg),
                            &verified);
if (ret == 0 && verified == 1) {
    /*signature is valid*/
}

wc_MlDsaKey_Free(&key);
wc_FreeRng(&rng);
```

The public key can be exported for the verifier with [`wc_MlDsaKey_ExportPubRaw()`](group__ML__DSA.md#function-wc_mldsakey_exportpubraw) and loaded with [`wc_MlDsaKey_ImportPubRaw()`](group__ML__DSA.md#function-wc_mldsakey_importpubraw) into a key that has the same parameter set. The older `wc_dilithium_*` API in `wolfssl/wolfcrypt/dilithium.h` is kept as a compatibility layer on top of the `wc_MlDsaKey_*` functions; new code should use the `wc_MlDsaKey_*` names.
