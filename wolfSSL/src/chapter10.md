# wolfCrypt Usage Reference

wolfCrypt is the cryptography library primarily used by wolfSSL. It is optimized for speed, small footprint, and portability. wolfSSL interchanges with other cryptography libraries as required.

Types used in the examples:

```c
typedef unsigned char byte;
typedef unsigned int  word32;
```

## Hash Functions

### MD4

**NOTE**:  MD4 is outdated and considered insecure. Please consider using a different hashing function if possible.

To use MD4 include the MD4 header `wolfssl/wolfcrypt/md4.h`. The structure to use is `Md4`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitMd4()`](https://www.wolfssl.com/doxygen/group__MD4.html#gabdbe7f889ba699f850b98cf4f0ec3205) call. Use [`wc_Md4Update()`](https://www.wolfssl.com/doxygen/group__MD4.html#ga2aa015e1b7b7031f7507b462772a090c) to update the hash and [`wc_Md4Final()`](https://www.wolfssl.com/doxygen/group__MD4.html#gafd0393827b3fc5be0c7f975d7b3e4140) to retrieve the final hash.

```c
byte md4sum[MD4_DIGEST_SIZE];
byte buffer[1024];
/* fill buffer with data to hash*/

Md4 md4;
wc_InitMd4(&md4);

wc_Md4Update(&md4, buffer, sizeof(buffer));  /*can be called again
                                and again*/
wc_Md4Final(&md4, md4sum);
```

`md4sum` now contains the digest of the hashed data in buffer.

### MD5

**NOTE**:  MD5 is outdated and considered insecure. Please consider using a different hashing function if possible.

To use MD5 include the MD5 header `wolfssl/wolfcrypt/md5.h`. The structure to use is `Md5`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitMd5()`](https://www.wolfssl.com/doxygen/group__MD5.html#ga5ae07c409b9e857d35a5eebf28fd0e93) call. Use [`wc_Md5Update()`](https://www.wolfssl.com/doxygen/group__MD5.html#ga18ba9588218416a1661feedce17e3490) to update the hash and [`wc_Md5Final()`](https://www.wolfssl.com/doxygen/group__MD5.html#gaf691a53845c0c309e1c6e3c7c46a2530) to retrieve the final hash

```c
byte md5sum[MD5_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

Md5 md5;
wc_InitMd5(&md5);

wc_Md5Update(&md5, buffer, sizeof(buffer));  /*can be called again
                                and again*/
wc_Md5Final(&md5, md5sum);
```

`md5sum` now contains the digest of the hashed data in buffer.

### SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512

To use SHA include the SHA header `wolfssl/wolfcrypt/sha.h`. The structure to use is `Sha`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitSha()`](https://www.wolfssl.com/doxygen/group__SHA.html#gac3337a92a220bbac72f91faf9b445f08) call. Use [`wc_ShaUpdate()`](https://www.wolfssl.com/doxygen/group__SHA.html#gabf979f479f40b61f7ada0a5fab38d997) to update the hash and [`wc_ShaFinal()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga8d87f04a62e6c7f4b20a4ab948def4aa) to retrieve the final hash:

```c
byte shaSum[SHA_DIGEST_SIZE];
byte buffer[1024];
/*fill buffer with data to hash*/

Sha sha;
wc_InitSha(&sha);

wc_ShaUpdate(&sha, buffer, sizeof(buffer));  /*can be called again 
                                          and again*/
wc_ShaFinal(&sha, shaSum);
```

`shaSum` now contains the digest of the hashed data in buffer.

To use either SHA-224, SHA-256, SHA-384, or SHA-512, follow the same steps as shown above, but use either the `wolfssl/wolfcrypt/sha256.h` or `wolfssl/wolfcrypt/sha512.h` (for both SHA-384 and SHA-512).  The SHA-256, SHA-384, and SHA-512 functions are named similarly to the SHA functions.

For **SHA-224**, the functions [`wc_InitSha224()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga975ebdd57a0f5d8ec25a653443cf4e63), [`wc_Sha224Update()`](https://www.wolfssl.com/doxygen/group__SHA.html#gae84c8f4a143cf8f707c3439c3f8e0f69), and [`wc_Sha224Final()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga5804383261c7874689ae09afb2eab419) will be used with the structure Sha224.

For **SHA-256**, the functions [`wc_InitSha256()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga9327dbe0a37780f624d8c59a4e16cb60), [`wc_Sha256Update()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga085bc993e65bbf0603442287710d2aa4), and [`wc_Sha256Final()`](https://www.wolfssl.com/doxygen/group__SHA.html#gad4c5f1632656e3baab7047aba31ebe4a) will be used with the structure Sha256.

For **SHA-384**, the functions [`InitSha384()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga9710ce790d622b2fbf01909a0a9c88b0), [`wc_Sha384Update()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga8df9aa28efbf0ca33b7dd53773602088), and [`wc_Sha384Final()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga269544162e566fc97d531fad57b048f1) will be used with the structure Sha384.

For **SHA-512**, the functions [`wc_InitSha512()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga51e53c87ac9a07bedc216608d7c2eaa1), [`Sha512Update()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga9ab08a07f1fd6d104c8bd8301d715f96), and [`Sha512Final()`](https://www.wolfssl.com/doxygen/group__SHA.html#ga6c656b63a63d9626e40596759b7cd2b2) will be used with the structure Sha512.

### BLAKE2b

To use BLAKE2b (a SHA-3 finalist) include the BLAKE2b header `wolfssl/wolfcrypt/blake2.h`. The structure to use is `Blake2b`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitBlake2b()`](https://www.wolfssl.com/doxygen/group__BLAKE2.html#ga034ab85502b8e04b4c656c75152db0ca) call. Use [`wc_Blake2bUpdate()`](https://www.wolfssl.com/doxygen/group__BLAKE2.html#ga74d1c9bde68426986aac9b8861c8f778) to update the hash and [`wc_Blake2bFinal()`](https://www.wolfssl.com/doxygen/group__BLAKE2.html#gae31cb1d070a587bb88f3f31845326dd0) to retrieve the final hash:

```c
byte digest[64];
byte input[64];		/*fill input with data to hash*/

Blake2b b2b;
wc_InitBlake2b(&b2b, 64);

wc_Blake2bUpdate(&b2b, input, sizeof(input));
wc_Blake2bFinal(&b2b, digest, 64);
```

The second parameter to [`wc_InitBlake2b()`](https://www.wolfssl.com/doxygen/group__BLAKE2.html#ga034ab85502b8e04b4c656c75152db0ca) should be the final digest size. `digest` now contains the digest of the hashed data in buffer.

Example usage can be found in the wolfCrypt test application (`wolfcrypt/test/test.c`), inside the `blake2b_test()` function.


### RIPEMD-160

To use RIPEMD-160, include the header `wolfssl/wolfcrypt/ripemd.h`. The structure to use is `RipeMd`, which is a typedef. Before using, the hash initialization must be done with the [`wc_InitRipeMd()`](https://www.wolfssl.com/doxygen/group__RIPEMD.html#ga4101595eb19a3876258d818d3cc1ce46) call. Use [`wc_RipeMdUpdate()`](https://www.wolfssl.com/doxygen/group__RIPEMD.html#gae006f8b2927b65d14581c57cf02c493c) to update the hash and [`wc_RipeMdFinal()`](https://www.wolfssl.com/doxygen/group__RIPEMD.html#ga5fa78223f9769e4c4afe1cca26f32991) to retrieve the final hash

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

wolfCrypt currently provides HMAC for message digest needs. The structure `Hmac` is found in the header `wolfssl/wolfcrypt/hmac.h`. HMAC initialization is done with [`wc_HmacSetKey()`](https://www.wolfssl.com/doxygen/group__HMAC.html#ga473ec44a80e2c2a3015006bf538d4c91).  5 different types are supported with HMAC: MD5, SHA, SHA-256, SHA-384, and SHA-512. Here's an example with SHA-256.

```c
Hmac	hmac;
byte	key[24];    	/*fill key with keying material*/
byte	buffer[2048];   /*fill buffer with data to digest*/
byte	hmacDigest[SHA256_DIGEST_SIZE];

wc_HmacSetKey(&hmac, SHA256, key, sizeof(key));
wc_HmacUpdate(&hmac, buffer, sizeof(buffer));
wc_HmacFinal(&hmac, hmacDigest);
```

`hmacDigest` now contains the digest of the hashed data in buffer.

### GMAC

wolfCrypt also provides GMAC for message digest needs. The structure `Gmac` is found in the header `wolfssl/wolfcrypt/aes.h`, as it is an application AES-GCM. GMAC initialization is done with [`wc_GmacSetKey()`](https://www.wolfssl.com/doxygen/group__AES.html#ga656b05eb12dcdd9a864aff030a0f84cb).

```c
Gmac gmac;
byte	key[16];    	 /*fill key with keying material*/
byte iv[12];		 /*fill iv with an initialization vector*/
byte	buffer[2048];   /*fill buffer with data to digest*/
byte	gmacDigest[16];

wc_GmacSetKey(&gmac, key, sizeof(key));
wc_GmacUpdate(&gmac, iv, sizeof(iv), buffer, sizeof(buffer),
gmacDigest, sizeof(gmacDigest));
```

`gmacDigest` now contains the digest of the hashed data in buffer.

### Poly1305

wolfCrypt also provides Poly1305 for message digest needs. The structure `Poly1305` is found in the header `wolfssl/wolfcrypt/poly1305.h`. Poly1305 initialization is done with [`wc_Poly1305SetKey()`](https://www.wolfssl.com/doxygen/group__Poly1305.html#gab0c73a9256b4cb9d1d7aa0b4f01727bf). The process of setting a key in Poly1305 should be done again, with a new key, when next using Poly1305 after [`wc_Poly1305Final()`](https://www.wolfssl.com/doxygen/group__Poly1305.html#gadeee21a98c2c7ad7f950b0035f421939) has been called.

```c
Poly1305    pmac;
byte	       key[32];    	   /*fill key with keying material*/
byte	       buffer[2048];   /*fill buffer with data to digest*/
byte	       pmacDigest[16];

wc_Poly1305SetKey(&pmac, key, sizeof(key));
wc_Poly1305Update(&pmac, buffer, sizeof(buffer));
wc_Poly1305Final(&pmac, pmacDigest);
```

`pmacDigest` now contains the digest of the hashed data in buffer.

## Block Ciphers

### AES

wolfCrypt provides support for AES with key sizes of 16 bytes (128 bits), 24 bytes (192 bits), or 32 bytes (256 bits). Supported AES modes include CBC, CTR, GCM, and CCM-8.

CBC mode is supported for both encryption and decryption and is provided through the [`wc_AesSetKey()`](https://www.wolfssl.com/doxygen/group__AES.html#ga712dec743cae54ca3f5d3e67eedaa504), [`wc_AesCbcEncrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#ga1466f105e2e23ce9d3b044bc20bc07f2) and [`wc_AesCbcDecrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#ga87c89c64e24e60fb1a636bcc6efbae73) functions. Please include the header `wolfssl/wolfcrypt/aes.h` to use AES. AES has a block size of 16 bytes and the IV should also be 16 bytes. Function usage is usually as follows:

```c
Aes enc;
Aes dec;

const byte key[] = {  /*some 24 byte key*/ };
const byte iv[] = { /*some 16 byte iv*/ };

byte plain[32];   /*an increment of 16, fill with data*/
byte cipher[32];

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

`plain` now contains the original plaintext from the ciphertext.

wolfCrypt also supports CTR (Counter), GCM (Galois/Counter), and CCM-8 (Counter with CBC-MAC) modes of operation for AES.  When using these modes, like CBC, include the `wolfssl/wolfcrypt/aes.h` header.

GCM mode is available for both encryption and decryption through the [`wc_AesGcmSetKey()`](https://www.wolfssl.com/doxygen/group__AES.html#ga807d1fb3bb9a2f2e7a1aa269706666cc), [`wc_AesGcmEncrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#ga512cda371bd4f72c5ec836ddea29ce7a), and [`wc_AesGcmDecrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#ga278f3e5a4b8b2f341c19a0751ff2de57) functions.  For a usage example, see the `aesgcm_test()` function in `<wolfssl_root>/wolfcrypt/test/test.c`.

CCM-8 mode is supported for both encryption and decryption through the [`wc_AesCcmSetKey()`](https://www.wolfssl.com/doxygen/group__AES.html#ga7544488439c4bd369e14e9613f21df9a), [`wc_AesCcmEncrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#gad09e65d89dc98d674ed06222a0e8305a), and [`wc_AesCcmDecrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#gabd7b25bd041af0b9e5d4d5ba9512065e) functions.  For a usage example, see the `aesccm_test()` function in `<wolfssl_root>/wolfcrypt/test/test.c`.

CTR mode is available for both encryption and decryption through the [`wc_AesCtrEncrypt()`](https://www.wolfssl.com/doxygen/group__AES.html#gac483dab8a4fe8f743eefb5a53881e472) function. The encrypt and decrypt actions are identical so the same function is used for both. For a usage example, see the function `aes_test()` in file `wolfcrypt/test/test.c`.


#### DES and 3DES

wolfCrypt provides support for DES and 3DES (Des3 since 3 is an invalid leading C identifier). To use these include the header `wolfssl/wolfcrypt/des.h`. The structures you can use are `Des` and `Des3`. Initialization is done through [`wc_Des_SetKey()`](https://www.wolfssl.com/doxygen/group__DES.html#ga84096e59f0f54f696637054f8eeb1ea0) or [`wc_Des3_SetKey()`](https://www.wolfssl.com/doxygen/group__DES.html#gad15902f9dd5c881527b6baf60c130bb5). CBC encryption/decryption is provided through [`wc_Des_CbcEnrypt()`](https://www.wolfssl.com/doxygen/group__DES.html#gab7ca8e9f1c14e756c8116b098a28fa99) / [`wc_Des_CbcDecrypt()`](https://www.wolfssl.com/doxygen/group__DES.html#ga93337303f055a416be701083b16365ff) and [`wc_Des3_CbcEncrypt()`](https://www.wolfssl.com/doxygen/group__DES.html#ga23fee0de0d859d983ad57bdde68e2735) / [`wc_Des3_CbcDecrypt()`](https://www.wolfssl.com/doxygen/group__DES.html#ga9888b4c6da506b2d967ca29d21236cd2). Des has a key size of 8 bytes (24 for 3DES) and the block size is 8 bytes, so only pass increments of 8 bytes to encrypt/decrypt functions. If your data isn't in a block size increment you'll need to add padding to make sure it is. Each `SetKey()` also takes an IV (an initialization vector that is the same size as the key size). Usage is usually like the following:

```c
Des3 enc;
Des3 dec;

const byte key[] = {  /*some 24 byte key*/ };
const byte iv[]  = {  /*some 24 byte iv*/  };

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

#### Camellia

wolfCrypt provides support for the Camellia block cipher. To use Camellia include the header `wolfssl/wolfcrypt/camellia.h`. The structure you can use is called `Camellia`. Initialization is done through [`wc_CamelliaSetKey()`](https://www.wolfssl.com/doxygen/group__Camellia.html#gaad5170c0cf0e476f2cdb6a6ce7b2bc49). CBC encryption/decryption is provided through [`wc_CamelliaCbcEnrypt()`](https://www.wolfssl.com/doxygen/group__Camellia.html#ga3f0dfaad7807ac1a38f708994cf5a18b) and [`wc_CamelliaCbcDecrypt()`](https://www.wolfssl.com/doxygen/group__Camellia.html#ga427d62eb0a47298d4b6e92ed2d7a8605) while direct encryption/decryption is provided through [`wc_CamelliaEncryptDirect()`](https://www.wolfssl.com/doxygen/group__Camellia.html#ga7bab7fc9928d97432f0799b05e105c20) and [`wc_CamelliaDecryptDirect()`](https://www.wolfssl.com/doxygen/group__Camellia.html#gab5bfd093f252a586f199d1ef6503fc7f).

For usage examples please see the camellia_test() function in `<wolfssl_root>/wolfcrypt/test/test.c`.

## Stream Ciphers

### ARC4

**NOTE**: ARC4 is outdated and considered insecure. Please consider using a different stream cipher.

The most common stream cipher used on the Internet is ARC4. wolfCrypt supports it through the header `wolfssl/wolfcrypt/arc4.h`.  Usage is simpler than block ciphers because there is no block size and the key length can be any length. The following is a typical usage of ARC4.

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

### RABBIT

A newer stream cipher gaining popularity is RABBIT. This stream cipher can be used through wolfCrypt by including the header `wolfssl/wolfcrypt/rabbit.h`. RABBIT is very fast compared to ARC4, but has key constraints of 16 bytes (128 bits) and an optional IV of 8 bytes (64 bits). Otherwise usage is exactly like ARC4:

```c
Rabbit enc;
Rabbit dec;

const byte key[] = {  /*some key 16 bytes*/};
const byte iv[]  = {  /*some iv 8 bytes*/  };

byte plain[27];   /*no size restriction, fill with data*/
byte cipher[27];

/*encrypt*/
wc_RabbitSetKey(&enc, key, iv);  	/*iv can be a NULL pointer*/
wc_RabbitProcess(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_RabbitSetKey(&dec, key, iv);
wc_RabbitProcess(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

### HC-128

Another stream cipher in current use is HC-128, which is even faster than RABBIT (about 5 times faster than ARC4).  To use it with wolfCrypt, please include the header `wolfssl/wolfcrypt/hc128.h`. HC-128 also uses 16-byte keys (128 bits) but uses 16-byte IVs (128 bits) unlike RABBIT.

```c
HC128 enc;
HC128 dec;

const byte key[] = {  /*some key 16 bytes*/};
const byte iv[]  = {  /*some iv 16 bytes*/ };

byte plain[37];   /*no size restriction, fill with data*/
byte cipher[37];

/*encrypt*/
wc_Hc128_SetKey(&enc, key, iv);  	/*iv can be a NULL pointer*/
wc_Hc128_Process(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_Hc128_SetKey(&dec, key, iv);
wc_Hc128_Process(&dec, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

### ChaCha

ChaCha with 20 rounds is slightly faster than ARC4 while maintaining a high level of security.  To use it with wolfCrypt, please include the header `wolfssl/wolfcrypt/chacha.h`. ChaCha typically uses 32 byte keys (256 bit) but can also use 16 byte keys (128 bits).

```c
CHACHA enc;
CHACHA dec;

const byte key[] = {  /*some key 32 bytes*/};
const byte iv[]  = {  /*some iv 12 bytes*/ };

byte plain[37];   /*no size restriction, fill with data*/
byte cipher[37];

/*encrypt*/
wc_Chacha_SetKey(&enc, key, keySz);
wc_Chacha_SetIV(&enc, iv, counter); /*counter is the start block 
                         counter is usually set as 0*/
wc_Chacha_Process(&enc, cipher, plain, sizeof(plain));
```

`cipher` now contains the ciphertext from the plain text.

```c
/*decrypt*/
wc_Chacha_SetKey(&enc, key, keySz);
wc_Chacha_SetIV(&enc, iv, counter);
wc_Chacha_Process(&enc, plain, cipher, sizeof(cipher));
```

`plain` now contains the original plaintext from the ciphertext.

[`wc_Chacha_SetKey`](https://www.wolfssl.com/doxygen/group__ChaCha.html#gaae70ea0cd7c9c1dd37a2689970d13f16) only needs to be set once but for each packet of information sent [`wc_Chacha_SetIV()`](https://www.wolfssl.com/doxygen/group__ChaCha.html#gaf85a59f0f1d82f112cfda81998a7befd) must be called with a new iv (nonce). Counter is set as an argument to allow for partially decrypting/encrypting information by starting at a different block when performing the encrypt/decrypt process, but in most cases is set to 0. **ChaCha should not be used without a mac algorithm (e.g. Poly1305 , hmac).**

## Public Key Cryptography

### RSA

wolfCrypt provides support for RSA through the header `wolfssl/wolfcrypt/rsa.h`. There are two types of RSA keys, public and private. A public key allows anyone to encrypt something that only the holder of the private key can decrypt. It also allows the private key holder to sign something and anyone with a public key can verify that only the private key holder actually signed it. Usage is usually like the following:

```c
RsaKey rsaPublicKey;

byte publicKeyBuffer[]  = { /*holds the raw data from the key, maybe
                        from a file like RsaPublicKey.der*/ };
word32 idx = 0;            /*where to start reading into the buffer*/

RsaPublicKeyDecode(publicKeyBuffer, &idx, &rsaPublicKey, sizeof(publicKeyBuffer));

byte in[] = { /*plain text to encrypt*/ };
byte out[128];
RNG rng;

wc_InitRng(&rng);

word32 outLen = RsaPublicEncrypt(in, sizeof(in), out, sizeof(out), &rsaPublicKey, &rng);
```

Now `out` holds the ciphertext from the plain text `in`. [`wc_RsaPublicEncrypt()`](https://www.wolfssl.com/doxygen/group__RSA.html#gaf339effdd51d5eb0eb61fff07dade9b3) will return the length in bytes written to out or a negative number in case of an error. [`wc_RsaPublicEncrypt()`](https://www.wolfssl.com/doxygen/group__RSA.html#gaf339effdd51d5eb0eb61fff07dade9b3) needs a RNG (Random Number Generator) for the padding used by the encryptor and it must be initialized before it can be used. To make sure that the output buffer is large enough to pass you can first call [`wc_RsaEncryptSize()`](https://www.wolfssl.com/doxygen/group__RSA.html#gad16430ccec12d700953c2e42953eef63) which will return the number of bytes that a successful call to [`wc_RsaPublicEnrypt()`](https://www.wolfssl.com/doxygen/group__RSA.html#gaf339effdd51d5eb0eb61fff07dade9b3) will write.

In the event of an error, a negative return from [`wc_RsaPublicEnrypt()`](https://www.wolfssl.com/doxygen/group__RSA.html#gaf339effdd51d5eb0eb61fff07dade9b3), or [`wc_RsaPublicKeyDecode()`](https://www.wolfssl.com/doxygen/group__RSA.html#ga054bd3f110ed3024bfe03f35bda1f728) for that matter, you can call [`wc_ErrorString()`](https://www.wolfssl.com/doxygen/group__Error.html#ga68acc3c94319dd083ab74cc7267bc697) to get a string describing the error that occurred.

```c
void wc_ErrorString(int error, char* buffer);
```

Make sure that buffer is at least `MAX_ERROR_SZ` bytes (80).

Now to decrypt out:

```c
RsaKey rsaPrivateKey;

byte privateKeyBuffer[] = { /*hold the raw data from the key, maybe
                              from a file like RsaPrivateKey.der*/ };
word32 idx = 0;            /*where to start reading into the buffer*/

wc_RsaPrivateKeyDecode(privateKeyBuffer, &idx, &rsaPrivateKey,
                       sizeof(privateKeyBuffer));

byte plain[128];
word32 plainSz = wc_RsaPrivateDecrypt(out, outLen, plain,
   					   sizeof(plain), &rsaPrivateKey);
```

Now plain will hold plainSz bytes or an error code. For complete examples of each type in wolfCrypt please see the file `wolfcrypt/test/test.c`.  Note that the [`wc_RsaPrivateKeyDecode`](https://www.wolfssl.com/doxygen/group__RSA.html#ga49c56ab962875a5b91e8a123b9ee7b1b) function only accepts keys in raw `DER` format.

### DH (Diffie-Hellman)

wolfCrypt provides support for Diffie-Hellman through the header `wolfssl/wolfrypt/dh.h`.  The Diffie-Hellman key exchange algorithm allows two parties to establish a shared secret key.  Usage is usually similar to the following example, where **sideA** and **sideB** designate the two parties.

In the following example, `dhPublicKey` contains the Diffie-Hellman public parameters signed by a Certificate Authority (or self-signed).  `privA` holds the generated private key for sideA, `pubA` holds the generated public key for sideA, and `agreeA` holds the mutual key that both sides have agreed on.

```c
DhKey	dhPublicKey;
word32 idx = 0;  /*where to start reading into the 
                   publicKeyBuffer*/
word32 pubASz, pubBSz, agreeASz;
byte   tmp[1024];
RNG    rng;

byte privA[128];
byte pubA[128];
byte agreeA[128];

wc_InitDhKey(&dhPublicKey);

byte publicKeyBuffer[] = { /*holds the raw data from the public key
                             parameters, maybe from a file like
                             dh1024.der*/ }
wc_DhKeyDecode(tmp, &idx, &dhPublicKey, publicKeyBuffer);
wc_InitRng(&rng);  /*Initialize random number generator*/
```

[`wc_DhGenerateKeyPair()`](https://www.wolfssl.com/doxygen/group__Diffie-Hellman.html#ga7ea4a1441bfb5a0c12008bc6f11d0bfb) will generate a public and private DH key based on the initial public parameters in dhPublicKey.

```c
wc_DhGenerateKeyPair(&dhPublicKey, &rng, privA, &privASz,
            pubA, &pubASz);
```

After sideB sends their public key (`pubB`) to sideA, sideA can then generate the mutually-agreed key(`agreeA`) using the [`wc_DhAgree()`](https://www.wolfssl.com/doxygen/group__Diffie-Hellman.html#gae36725d66e00e0ee51555d0f03aa6a08) function.

```c
wc_DhAgree(&dhPublicKey, agreeA, &agreeASz, privA, privASz,
           pubB, pubBSz);
```

Now, `agreeA` holds sideA’s mutually-generated key (of size `agreeASz` bytes).  The same process will have been done on sideB.

For a complete example of Diffie-Hellman in wolfCrypt, see the file `wolfcrypt/test/test.c`.

### EDH (Ephemeral Diffie-Hellman)

 A wolfSSL server can do Ephemeral Diffie-Hellman.  No build changes are needed to add this feature, though an application will have to register the ephemeral group parameters on the server side to enable the EDH cipher suites.  A new API can be used to do this:

```c
int wolfSSL_SetTmpDH(WOLFSSL* ssl, unsigned char* p,
                   int pSz,unsigned char* g,int gSz);
```

The example server and echoserver use this function from `SetDH()`.

### DSA (Digital Signature Algorithm)

wolfCrypt provides support for DSA and DSS through the header `wolfssl/wolfcrypt/dsa.h`.  DSA allows for the creation of a digital signature based on a given data hash.  DSA uses the SHA hash algorithm to generate a hash of a block of data, then signs that hash using the signer’s private key.  Standard usage is similar to the following.

We first declare our DSA key structure (`key`), initialize our initial message (`message`) to be signed, and initialize our DSA key buffer (`dsaKeyBuffer`).

```c
DsaKey key;
Byte   message[]      = { /*message data to sign*/ }
byte   dsaKeyBuffer[] = { /*holds the raw data from the DSA key,
                            maybe from a file like dsa512.der*/ }
```

We then declare our SHA structure (`sha`), random number generator (`rng`), array to store our SHA hash (`hash`), array to store our signature (`signature`), `idx` (to mark where to start reading in our `dsaKeyBuffer`), and an int (`answer`) to hold our return value after verification.

```c
Sha    sha;
RNG    rng;
byte   hash[SHA_DIGEST_SIZE];
byte   signature[40];
word32 idx = 0;
int    answer;
```

Set up and create the SHA hash.  For more information on wolfCrypt’s SHA algorithm, see [SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512](#sha-sha-224-sha-256-sha-384-sha-512). The SHA hash of `message` is stored in the variable `hash`.

```c
wc_InitSha(&sha);
wc_ShaUpdate(&sha, message, sizeof(message));
wc_ShaFinal(&sha, hash);
```

Initialize the DSA key structure, populate the structure key value, and initialize the random number generator (`rng`).

```c
wc_InitDsaKey(&key);
wc_DsaPrivateKeyDecode(dsaKeyBuffer, &idx, &key,
                       sizeof(dsaKeyBuffer));
wc_InitRng(&rng);
```

The [`wc_DsaSign()`](https://www.wolfssl.com/doxygen/group__DSA.html#ga0628e4be8f74b4266dfb98ef4fc5c732) function creates a signature (`signature`) using the DSA private key, hash value, and random number generator.

```c
wc_DsaSign(hash, signature, &key, &rng);
```

To verify the signature, use [`wc_DsaVerify()`](https://www.wolfssl.com/doxygen/group__DSA.html#ga94e6e31bb2f6dc244ac1e03787126b04). If verification is successful, answer will be equal to “**1**”. Once finished, free the DSA key structure using [`wc_FreeDsaKey()`](https://www.wolfssl.com/doxygen/group__DSA.html#gaeb1567ea08b350c310290788a41eba9a).

```c
wc_DsaVerify(hash, signature, &key, &answer);
wc_FreeDsaKey(&key);
```
