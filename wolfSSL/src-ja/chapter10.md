# wolfCryptの使用法

wolfCryptは、主にwolfSSLが使用する暗号ライブラリです。
速度、小さなフットプリント、移植性のために最適化されています。
wolfSSLは、必要に応じて他の暗号ライブラリと交換します。

実装例で使用する型は次の通りです。

```c
typedef unsigned char byte;
typedef unsigned int  word32;
```

## ハッシュ関数

### MD4

**注意**：MD4は古く、安全でないと考えられています。
可能であれば、異なるハッシュ関数を使用してください。

MD4を使用するには、MD4ヘッダー`wolfssl/wolfcrypt/md4.h`をインクルードします。
使用する構造体は`Md4`で、これはtypedefです。
使用する前に、[`wc_InitMd4()`](group__MD4.md#function-wc_initmd4)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_Md4Update()`](group__MD4.md#function-wc_initmd4)を使用し、最終的なハッシュを取得するには[`wc_Md4Final()`](group__MD4.md#function-wc_md4final)を使用します。

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

`md4sum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### MD5

**注意**：MD5は古く、安全でないと考えられています。
可能であれば、異なるハッシュ関数を使用してください。

MD5を使用するには、MD5ヘッダー`wolfssl/wolfcrypt/md5.h`をインクルードします。
使用する構造体は`Md5`で、これはtypedefです。
使用する前に、[`wc_InitMd5()`](group__MD5.md#function-wc_initmd5)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_Md5Update()`](group__MD5.md#function-wc_md5update)を使用し、最終的なハッシュを取得するには[`wc_Md5Final()`](group__MD5.md#function-wc_md5final)を使用します。

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

`md5sum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512

SHAを使用するには、SHAヘッダー`wolfssl/wolfcrypt/sha.h`をインクルードします。
使用する構造体は`Sha`で、これはtypedefです。
使用する前に、[`wc_InitSha()`](group__SHA.md#function-wc_initsha)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_ShaUpdate()`](group__SHA.md#function-wc_shaupdate)を使用し、最終的なハッシュを取得するには[`wc_ShaFinal()`](group__SHA.md#function-wc_shafinal)を使用します。

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

`shaSum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

SHA-224、SHA-256、SHA-384、SHA-512のいずれかを使用するには、上記と同じ手順に従います。
ただし、`wolfssl/wolfcrypt/sha256.h`または`wolfssl/wolfcrypt/sha512.h`（SHA-384もこちら）のいずれかを使用します。
SHA-256、SHA-384、SHA-512関数は、SHA関数と同様に名付けられています。

**SHA-224**の場合、構造体Sha224と共に[`wc_InitSha224()`](group__SHA.md#function-wc_initsha224)、[`wc_Sha224Update()`](group__SHA.md#function-wc_sha224update)、[`wc_Sha224Final()`](group__SHA.md#function-wc_sha224final)関数が使用されます。

**SHA-256**の場合、構造体Sha256と共に[`wc_InitSha256()`](group__SHA.md#function-wc_initsha256)、[`wc_Sha256Update()`](group__SHA.md#function-wc_sha256update)、[`wc_Sha256Final()`](group__SHA.md#function-wc_sha256final)関数が使用されます。

**SHA-384**の場合、構造体Sha384と共に[`wc_InitSha384()`](group__SHA.md#function-wc_initsha384)、[`wc_Sha384Update()`](group__SHA.md#function-wc_sha384update)、[`wc_Sha384Final()`](group__SHA.md#function-wc_sha384final)関数が使用されます。

**SHA-512**の場合、構造体Sha512と共に[`wc_InitSha512()`](group__SHA.md#function-wc_initsha512)、[`wc_Sha512Update()`](group__SHA.md#function-wc_sha512update)、[`wc_Sha512Final()`](group__SHA.md#function-wc_sha512final)関数が使用されます。

SHAインターリービングはデフォルトで有効になっています。
（通常は、それをサポートするハードウェアアクセラレーションでのみ使用されます。）
無効にするには`NO_WOLFSSL_SHA256_INTERLEAVE`を定義します。
ソフトウェアSHAは常にインターリービングをサポートしています。

### BLAKE2b

BLAKE2b（SHA-3ファイナリスト）を使用するには、BLAKE2bヘッダー`wolfssl/wolfcrypt/blake2.h`をインクルードします。
使用する構造体は`Blake2b`で、これはtypedefです。
使用する前に、[`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_Blake2bUpdate()`](group__BLAKE2.md#function-wc_blake2bupdate)を使用し、最終的なハッシュを取得するには[`wc_Blake2bFinal()`](group__BLAKE2.md#function-wc_blake2bfinal)を使用します。

```c
byte digest[64];
byte input[64];     /*fill input with data to hash*/

Blake2b b2b;
wc_InitBlake2b(&b2b, 64);

wc_Blake2bUpdate(&b2b, input, sizeof(input));
wc_Blake2bFinal(&b2b, digest, 64);
```

[`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b)の2番目のパラメータは、最終的なダイジェストサイズです。
`digest`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

使用例はwolfCryptテストアプリケーション（`wolfcrypt/test/test.c`）の`blake2b_test()`関数内にあります。

### RIPEMD-160

RIPEMD-160を使用するには、ヘッダー`wolfssl/wolfcrypt/ripemd.h`をインクルードします。
使用する構造体は`RipeMd`で、これはtypedefです。
使用する前に、[`wc_InitRipeMd()`](group__RIPEMD.md#function-wc_initripemd)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_RipeMdUpdate()`](group__RIPEMD.md#function-wc_ripemdupdate)を使用し、最終的なハッシュを取得するには[`wc_RipeMdFinal()`](group__RIPEMD.md#function-wc_ripemdfinal)を使用します。

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

`ripeMdSum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

## 鍵付きハッシュ関数

### HMAC

wolfCryptは現在、メッセージダイジェストのニーズに対してHMACを提供しています。
構造体`Hmac`はヘッダー`wolfssl/wolfcrypt/hmac.h`にあります。
HMACの初期化は[`wc_HmacSetKey()`](group__HMAC.md#function-wc_hmacsetkey)で行われます。
HMACでは、MD5、SHA、SHA-256、SHA-384、SHA-512をサポートしています。

以下は、SHA-256の例です。

```c
Hmac    hmac;
byte    key[24];        /*fill key with keying material*/
byte    buffer[2048];   /*fill buffer with data to digest*/
byte    hmacDigest[SHA256_DIGEST_SIZE];

wc_HmacSetKey(&hmac, SHA256, key, sizeof(key));
wc_HmacUpdate(&hmac, buffer, sizeof(buffer));
wc_HmacFinal(&hmac, hmacDigest);
```

`hmacDigest`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### GMAC

wolfCryptはメッセージダイジェストのニーズに対してGMACも提供しています。
構造体`Gmac`はヘッダー`wolfssl/wolfcrypt/aes.h`にあります（AES-GCMのアプリケーションです）。
GMACの初期化は[`wc_GmacSetKey()`](group__AES.md#function-wc_gmacsetkey)で行われます。

```c
Gmac gmac;
byte    key[16];         /*fill key with keying material*/
byte iv[12];         /*fill iv with an initialization vector*/
byte    buffer[2048];   /*fill buffer with data to digest*/
byte    gmacDigest[16];

wc_GmacSetKey(&gmac, key, sizeof(key));
wc_GmacUpdate(&gmac, iv, sizeof(iv), buffer, sizeof(buffer),
gmacDigest, sizeof(gmacDigest));
```

`gmacDigest`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### Poly1305

wolfCryptはメッセージダイジェストのニーズに対してPoly1305も提供しています。
構造体`Poly1305`はヘッダー`wolfssl/wolfcrypt/poly1305.h`にあります。
Poly1305の初期化は[`wc_Poly1305SetKey()`](group__Poly1305.md#function-wc_poly1305setkey)で行われます。
[`wc_Poly1305Final()`](group__Poly1305.md#function-wc_poly1305final)が呼び出された後、次にPoly1305を使用する際には、Poly1305での鍵の設定プロセスを新しい鍵で再度行う必要があります。

```c
Poly1305    pmac;
byte           key[32];        /*fill key with keying material*/
byte           buffer[2048];   /*fill buffer with data to digest*/
byte           pmacDigest[16];

wc_Poly1305SetKey(&pmac, key, sizeof(key));
wc_Poly1305Update(&pmac, buffer, sizeof(buffer));
wc_Poly1305Final(&pmac, pmacDigest);
```

`pmacDigest`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

## ブロック暗号

### AES

wolfCryptは16バイト（128ビット）、24バイト（192ビット）、32バイト（256ビット）の鍵サイズのAESをサポートしています。
サポートされるAESモードには、CBC、CTR、GCM（GCM-ストリーミング）、OFB、CFB（1、8、128）、SIV、XTS（XTS-ストリーミング）、GMAC、CMAC、ECB、KW（KeyWrap）、CCM-8が含まれます。

**注意**：[`wc_AesSetKey()`](group__AES.md#function-wc_aessetkey)や[`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey)などの他の`Aes` API関数を呼び出す前に、必ずはじめに[`wc_AesInit()`](group__AES.md#function-wc_aesinit)を呼び出し、`Aes`構造体を初期化する必要があります。

CBCモードは暗号化と復号の両方でサポートしており、[`wc_AesSetKey()`](group__AES.md#function-wc_aessetkey)、[`wc_AesCbcEncrypt()`](group__AES.md#function-wc_aescbcencrypt)、[`wc_AesCbcDecrypt()`](group__AES.md#function-wc_aescbcdecrypt)関数を通じて提供されます。
AESを使用するには、ヘッダー`wolfssl/wolfcrypt/aes.h`をインクルードしてください。
AESのブロックサイズは16バイトで、IVも16バイトである必要があります。
関数の使用方法は通常、次のとおりです。

```c
Aes enc;
Aes dec;

const byte key[] = {  /*some 24 byte key*/ };
const byte iv[] = { /*some 16 byte iv*/ };

byte plain[32];   /*an increment of 16, fill with data*/
byte cipher[32];

wc_AesInit(&enc, HEAP_HINT, INVALID_DEVID);
wc_AesInit(&dec, HEAP_HINT, INVALID_DEVID);

/*encrypt*/
wc_AesSetKey(&enc, key, sizeof(key), iv, AES_ENCRYPTION);
wc_AesCbcEncrypt(&enc, cipher, plain, sizeof(plain));
```

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_AesSetKey(&dec, key, sizeof(key), iv, AES_DECRYPTION);
wc_AesCbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

wolfCryptはAESの動作モードとしてCTR（カウンター）、GCM（ガロア/カウンター）、CCM-8（CBC-MAC付きカウンター）もサポートしています。
CBCと同様に、これらのモードを使用する場合は、ヘッダー`wolfssl/wolfcrypt/aes.h`をインクルードしてください。

GCMモードは[`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey)、[`wc_AesGcmEncrypt()`](group__AES.md#function-wc_aesgcmencrypt)、[`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt)関数を通じて暗号化と復号の両方で利用できます。
使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesgcm_test()`関数をご参照ください。

CCM-8モードは[`wc_AesCcmSetKey()`](group__AES.md#function-wc_aesccmsetkey)、[`wc_AesCcmEncrypt()`](group__AES.md#function-wc_aesccmencrypt)、[`wc_AesCcmDecrypt()`](group__AES.md#function-wc_aesccmdecrypt)関数を通じて暗号化と復号の両方でサポートしています。
使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesccm_test()`関数をご参照ください。

CTRモードは[`wc_AesCtrEncrypt()`](group__AES.md#function-wc_aesctrencrypt)関数を通じて暗号化と復号の両方で利用できます。
暗号化と復号のアクションは同一であるため、両方に同じ関数が使用されます。
使用例については、ファイル`wolfcrypt/test/test.c`の`aes_test()`関数をご参照ください。

#### DESおよび3DES

wolfCryptはDESおよび3DESをサポートしています。
（ただし、C言語では先頭に数字を使用できないため、Des3と示しています。）
これらを使用するには、ヘッダー`wolfssl/wolfcrypt/des.h`をインクルードします。
使用できる構造体は`Des`および`Des3`です。
初期化は[`wc_Des_SetKey()`](group__DES.md#function-wc_des_setkey)または[`wc_Des3_SetKey()`](group__DES.md#function-wc_des3_setkey)を通じて行われます。
CBC暗号化/復号は[`wc_Des_CbcEnrypt()`](group__DES.md#function-wc_des_cbcencrypt) / [`wc_Des_CbcDecrypt()`](group__DES.md#function-wc_dec_cbcdecrypt)および[`wc_Des3_CbcEncrypt()`](group__DES.md#function-wc_des3_cbcencrypt) / [`wc_Des3_CbcDecrypt()`](group__DES.md#function-wc_des3_cbcdecrypt)を通じて提供されます。
Desの鍵サイズは8バイト（3DESでは24）で、ブロックサイズは8バイトなので、暗号化/復号関数には8バイトの倍数のみを渡してください。
データがブロックサイズの倍数でない場合は、確実にそうなるようにパディングを追加する必要があります。
各`SetKey()`は、IV（鍵サイズと同じサイズの初期化ベクトル）も取ります。
使用方法は通常、次のとおりです。

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

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_Des3_SetKey(&dec, key, iv, DES_DECRYPTION);
wc_Des3_CbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

#### Camellia

wolfCryptはCamelliaブロック暗号をサポートしています。
Camelliaを使用するには、ヘッダー`wolfssl/wolfcrypt/camellia.h`をインクルードします。
使用できる構造体は`Camellia`と呼ばれます。
初期化は[`wc_CamelliaSetKey()`](group__Camellia.md#function-wc_camelliasetkey)を通じて行われます。
CBC暗号化/復号は[`wc_CamelliaCbcEnrypt()`](group__Camellia.md#function-wc_CamelliacbcEncrypt)および[`wc_CamelliaCbcDecrypt()`](group__Camellia.md#function-wc_camelliacbcdecrypt)を通じて提供され、直接の暗号化/復号は[`wc_CamelliaEncryptDirect()`](group__Camellia.md#function-wc_camelliaencryptdirect)および[`wc_CamelliaDecryptDirect()`](group__Camellia.md#function-wc_camelliadecryptdirect)を通じて提供されます。

使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`のcamellia_test()関数をご参照ください。

## ストリーム暗号

### ARC4

**注意**：ARC4は古く、安全でないと考えられています。
他のストリーム暗号を使用してください。

wolfCryptはヘッダー`wolfssl/wolfcrypt/arc4.h`を通じてARC4をサポートしています。
ブロックサイズがなく、鍵の長さも任意の長さにできるため、使用方法はブロック暗号よりも簡単です。
以下はARC4の典型的な使用方法です。

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

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_Arc4SetKey(&dec, key, sizeof(key));
wc_Arc4Process(&dec, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

### ChaCha

20ラウンドのChaChaはARC4よりもわずかに高速であり、高いレベルのセキュリティを維持しています。
wolfCryptで使用するには、ヘッダー`wolfssl/wolfcrypt/chacha.h`をインクルードしてください。
ChaChaは通常32バイト（256ビット）の鍵を使用しますが、16バイト（128ビット）の鍵も使用できます。

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

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_Chacha_SetKey(&enc, key, keySz);
wc_Chacha_SetIV(&enc, iv, counter);
wc_Chacha_Process(&enc, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

[`wc_Chacha_SetKey`](group__ChaCha.md#function-wc_chacha_setkey)は一度設定するだけで済みますが、送信される各情報パケットごとに新しいiv（ノンス）を使用して[`wc_Chacha_SetIV()`](group__ChaCha.md#function-wc_chacha_setiv)を呼び出す必要があります。
カウンターは、暗号化/復号プロセスを実行するときに異なるブロックから開始することで、部分的に情報を暗号化/復号できるように引数として設定されますが、ほとんどの場合は0に設定されます。

** ChaChaはMACアルゴリズム（例：Poly1305、HMAC）なしで使用しないでください。 **

## 公開鍵暗号

### RSA

wolfCryptはヘッダー`wolfssl/wolfcrypt/rsa.h`を通じてRSAをサポートしています。
RSA鍵には、公開鍵と秘密鍵の2種類があります。
公開鍵を使用すると、秘密鍵の保持者のみが復号できるように暗号化できます。
また、秘密鍵の保持者が何かに署名することを可能にし、公開鍵を持つ誰もが、秘密鍵の保持者が署名したことを確認できます。
使用方法は通常、次のとおりです。

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

これで`out`には、平文`in`からの暗号文が含まれます。
[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)は、`out`に書き込まれたバイト数を返すか、エラーの場合は負の数を返します。
[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)には、暗号化に使用されるパディング用のRNG（乱数ジェネレータ）が必要であり、使用する前に初期化する必要があります。
出力バッファが十分な大きさであることを確認するために、最初に[`wc_RsaEncryptSize()`](group__RSA.md#function-wc_rsaencryptsize)を使用します。
これにより、[`wc_RsaPublicEnrypt()`](group__RSA.md#function-wc_rsapublicencrypt)の成功した呼び出しが書き込むバイト数が返されます。

エラーが発生した場合、[`wc_RsaPublicEnrypt()`](group__RSA.md#function-wc_rsapublicencrypt)または[`wc_RsaPublicKeyDecode()`](group__RSA.md#function-wc_rsapublickeydecode)から負の戻り値が返されます。
その場合、[`wc_ErrorString()`](group__Error.md#function-wc_errorstring)を呼び出して、発生したエラーを説明する文字列を取得できます。

```c
void wc_ErrorString(int error, char* buffer);
```

バッファが少なくとも`MAX_ERROR_SZ`バイト（80）であることを確認してください。

続いて、`out`を復号します。

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

これで、`plain`には`plainSz`バイトまたはエラーコードが含まれます。
wolfCryptでの各タイプの完全な例については、ファイル`wolfcrypt/test/test.c`をご参照ください。
[`wc_RsaPrivateKeyDecode`](group__RSA.md#function-wc_rsaprivatekeydecode)関数は、生の`DER`形式の鍵のみを受け入れます。

### DH (Diffie-Hellman)

wolfCryptはヘッダー`wolfssl/wolfrypt/dh.h`を通じてDiffie-Hellmanをサポートしています。
Diffie-Hellman鍵交換アルゴリズムにより、2人の当事者間で共有秘密鍵を確立できます。
使用方法は通常、次の例のようになります。
ここで**sideA**と**sideB**は2つの当事者を示します。

以下の例では、`dhPublicKey`には認証局によって署名された（または自己署名された）Diffie-Hellman公開パラメータが含まれています。
`privA`はsideAに対して生成された秘密鍵、`pubA`はsideAに対して生成された公開鍵を保持します。
`agreeA`は、両者が合意した相互鍵を保持します。

```c
DhKey   dhPublicKey;
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

[`wc_DhGenerateKeyPair()`](group__Diffie-Hellman.md#function-wc_dhgeneratekeypair)は、dhPublicKeyの初期公開パラメータに基づいて公開鍵と秘密鍵のDH鍵を生成します。

```c
wc_DhGenerateKeyPair(&dhPublicKey, &rng, privA, &privASz,
            pubA, &pubASz);
```

sideBが彼らの公開鍵（`pubB`）をsideAに送信した後、sideAは[`wc_DhAgree()`](group__Diffie-Hellman.md#function-wc_dhagree)関数を使用して相互に合意された鍵（`agreeA`）を生成できます。

```c
wc_DhAgree(&dhPublicKey, agreeA, &agreeASz, privA, privASz,
           pubB, pubBSz);
```

これで、`agreeA`はsideAの相互に生成された鍵（サイズは`agreeASz`バイト）を保持します。
同じプロセスがsideBでも行われています。

wolfCryptでのDiffie-Hellmanの完全な実装例については、ファイル`wolfcrypt/test/test.c`をご参照ください。

### EDH (Ephemeral Diffie-Hellman)

wolfSSLサーバーはEphemeral Diffie-Hellmanを実行できます。
この機能を追加するためにビルドの変更は必要ありませんが、EDH暗号スイートを有効にするためにはサーバー側でアプリケーションが一時的なグループパラメータを登録する必要があります。
これには、次のAPIを使用します。

```c
int wolfSSL_SetTmpDH(WOLFSSL* ssl, unsigned char* p,
                   int pSz,unsigned char* g,int gSz);
```

実装例として提供しているサーバーとechoserverは、`SetDH()`からこの関数を使用します。

### DSA (デジタル署名アルゴリズム)

wolfCryptはヘッダー`wolfssl/wolfcrypt/dsa.h`を通じてDSAとDSSをサポートしています。
DSAは、与えられたデータハッシュに基づいてデジタル署名を作成することを可能にします。
DSAはSHAハッシュアルゴリズムを使用してデータブロックのハッシュを生成し、その後署名者の秘密鍵を使用してそのハッシュに署名します。
標準的な使用方法は次のようになります。

まず、DSA鍵構造（`key`）を宣言し、署名される初期メッセージ（`message`）を初期化し、DSA鍵バッファ（`dsaKeyBuffer`）を初期化します。

```c
DsaKey key;
Byte   message[]      = { /*message data to sign*/ }
byte   dsaKeyBuffer[] = { /*holds the raw data from the DSA key,
                            maybe from a file like dsa512.der*/ }
```

次に、SHA構造体（`sha`）、乱数ジェネレータ（`rng`）、SHAハッシュを格納する配列（`hash`）、署名を格納する配列（`signature`）、`idx`（`dsaKeyBuffer`の読み込み開始位置を示す）、検証後の戻り値を保持するint型の変数（`answer`）を宣言します。

```c
Sha    sha;
RNG    rng;
byte   hash[SHA_DIGEST_SIZE];
byte   signature[40];
word32 idx = 0;
int    answer;
```

SHAハッシュを設定して作成します。
wolfCryptのSHAアルゴリズムの詳細については、本章の「SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512」節をご参照ください。

`message`のSHAハッシュは、変数`hash`に格納されます。

```c
wc_InitSha(&sha);
wc_ShaUpdate(&sha, message, sizeof(message));
wc_ShaFinal(&sha, hash);
```

DSA鍵構造体を初期化し、構造体の鍵値を設定し、乱数ジェネレータ（`rng`）を初期化します。

```c
wc_InitDsaKey(&key);
wc_DsaPrivateKeyDecode(dsaKeyBuffer, &idx, &key,
                       sizeof(dsaKeyBuffer));
wc_InitRng(&rng);
```

[`wc_DsaSign()`](group__DSA.md#function-wc_dsasign)関数は、DSA秘密鍵、ハッシュ値、および乱数ジェネレータを使用して署名（`signature`）を作成します。

```c
wc_DsaSign(hash, signature, &key, &rng);
```

署名を検証するには、[`wc_DsaVerify()`](group__DSA.md#function-wc_dsaverify)を使用します。
検証が成功すると、`answer`は「**1**」となります。

完了したら、[`wc_FreeDsaKey()`](group__DSA.md#function-wc_freedsakey)を使用してDSA鍵構造体を解放します。

```c
wc_DsaVerify(hash, signature, &key, &answer);
wc_FreeDsaKey(&key);
```