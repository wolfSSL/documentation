

# WolfCryptの使用法



WolfCryptは、主にwolfSSLが使用する暗号化ライブラリです。速度、小さなフットプリント、および移植性のために最適化されています。wolfSSLは、必要に応じて他の暗号ライブラリと交換します。


例で使用される型：



```c
typedef unsigned char byte;
typedef unsigned int  word32;
```




## ハッシュ関数




### MD4




**注**：MD4は古くて安全でないと考えられています。可能であれば、異なるハッシュ関数を使用してください。


MD4を使用するには、MD4ヘッダー`wolfssl/wolfcrypt/md4.h`を含みます。使用する構造は`Md4`です。これはTypedefです。使用する前に、ハッシュの初期化は[`wc_InitMd4()`](group__MD4.md#function-wc_initmd4)呼び出しで行われなければなりません。ファイナルハッシュを取得するには、HASHと[`wc_Md4Final()`](group__MD4.md#function-wc_md4final)を更新するために[`wc_Md4Update()`](group__MD4.md#function-wc_initmd4)を使用してください。



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



`md4sum`には、バッファーのハッシュデータのダイジェストが含まれています。



### MD5




**注**：MD5は時代遅れであり、不安定であると考えられています。可能であれば、異なるハッシュ関数を使用してください。


MD5を使用するには、MD5ヘッダー`wolfssl/wolfcrypt/md5.h`が含まれます。使用する構造は`Md5`で、これはtypedefです。使用する前に、ハッシュの初期化は[`wc_InitMd5()`](group__MD5.md#function-wc_initmd5)呼び出しで行われなければなりません。[`wc_Md5Update()`](group__MD5.md#function-wc_md5update)を使用してハッシュと[`wc_Md5Final()`](group__MD5.md#function-wc_md5final)を更新して最終的なハッシュを取得します



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



`md5sum`には、バッファーのハッシュデータのダイジェストが含まれています。



### SHA/SHA-224/SHA-256/SHA-384/SHA-512




SHAを使用するには、SHAヘッダー`wolfssl/wolfcrypt/sha.h`を含めます。使用する構造は`Sha`で、typedefです。使用する前に、ハッシュの初期化は[`wc_InitSha()`](group__SHA.md#function-wc_initsha)呼び出しで行われなければなりません。[`wc_ShaUpdate()`](group__SHA.md#function-wc_shaupdate)を使用して、ハッシュと[`wc_ShaFinal()`](group__SHA.md#function-wc_shafinal)を更新して最終的なハッシュを取得します。



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



`shaSum`には、バッファーのハッシュデータのダイジェストが含まれています。


SHA-224、SHA-256、SHA-384、またはSHA-512を使用するには、上記と同じ手順に従いますが、`wolfssl/wolfcrypt/sha256.h`または`wolfssl/wolfcrypt/sha512.h`(SHA-384とSHA-512の両方)のいずれかを使用します。SHA-256、SHA-384、およびSHA-512機能は、SHA関数と同様に命名されています。


** sha-224 **の場合、関数[`wc_InitSha224()`](group__SHA.md#function-wc_initsha224)、[`wc_Sha224Update()`](group__SHA.md#function-wc_sha224update)、および[`wc_Sha224Final()`](group__SHA.md#function-wc_sha224final)が構造SHA224で使用されます。


** sha-256 **の場合、関数[`wc_InitSha256()`](group__SHA.md#function-wc_initsha256)、[`wc_Sha256Update()`](group__SHA.md#function-wc_sha256update)、および[`wc_Sha256Final()`](group__SHA.md#function-wc_sha256final)が構造SHA256で使用されます。


** SHA-384 **では、機能[`wc_InitSha384()`](group__SHA.md#function-wc_initsha384),[`wc_Sha384Update()`](group__SHA.md#function-wc_sha384update)、および[`wc_Sha384Final()`](group__SHA.md#function-wc_sha384final)は構造SHA384で使用されます。


** sha-512 **の場合、関数[`wc_InitSha512()`](group__SHA.md#function-wc_initsha512)、[`wc_Sha512Update()`](group__SHA.md#function-wc_sha512update)、および[`wc_Sha512Final()`](group__SHA.md#function-wc_sha512final)が構造SHA512で使用されます。



### blake2b



Blake2B(SHA-3ファイナリスト)を使用するには、Blake2Bヘッダー`wolfssl/wolfcrypt/blake2.h`を含みます。使用する構造は`Blake2b`です。これはTypedefです。使用する前に、ハッシュの初期化は[`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b)呼び出しで行われなければなりません。[`wc_Blake2bUpdate()`](group__BLAKE2.md#function-wc_blake2bupdate)を使用して、ハッシュと[`wc_Blake2bFinal()`](group__BLAKE2.md#function-wc_blake2bfinal)を更新して最終的なハッシュを取得します。



```c
byte digest[64];
byte input[64];     /*fill input with data to hash*/

Blake2b b2b;
wc_InitBlake2b(&b2b, 64);

wc_Blake2bUpdate(&b2b, input, sizeof(input));
wc_Blake2bFinal(&b2b, digest, 64);
```



[`wc_InitBlake2b()`](group__BLAKE2.md#function-wc_initblake2b)の2番目のパラメータは、最終ダイジェストサイズです。`digest`バッファ内のハッシュデータのダイジェストを含みます。


使用例使用例は、`blake2b_test()`関数内で、WolfCryptテストアプリケーション(`wolfcrypt/test/test.c`)にあります。



### RIPEMD-160




RIPEMD-160を使用するには、ヘッダー`wolfssl/wolfcrypt/ripemd.h`を含めます。使用する構造は`RipeMd`で、これはtypedefです。使用する前に、ハッシュの初期化は[`wc_InitRipeMd()`](group__RIPEMD.md#function-wc_initripemd)呼び出しで行われなければなりません。[`wc_RipeMdUpdate()`](group__RIPEMD.md#function-wc_ripemdupdate)を使用してハッシュと[`wc_RipeMdFinal()`](group__RIPEMD.md#function-wc_ripemdfinal)を更新して最終的なハッシュを取得します



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



`ripeMdSum`には、バッファーのハッシュデータのダイジェストが含まれています。



## キー付きハッシュ関数




### HMAC




WolfCryptは現在メッセージダイジェストニーズにHMACを提供しています。構造`Hmac`はヘッダ`wolfssl/wolfcrypt/hmac.h`にあります.HMAC初期化は[`wc_HmacSetKey()`](group__HMAC.md#function-wc_hmacsetkey)で行われます.5つの異なるタイプがHMACでサポートされています.MD5、SHA、SHA-256、SHA-384、およびSHA-512。これがSHA-256の例です。



```c
Hmac    hmac;
byte    key[24];        /*fill key with keying material*/
byte    buffer[2048];   /*fill buffer with data to digest*/
byte    hmacDigest[SHA256_DIGEST_SIZE];

wc_HmacSetKey(&hmac, SHA256, key, sizeof(key));
wc_HmacUpdate(&hmac, buffer, sizeof(buffer));
wc_HmacFinal(&hmac, hmacDigest);
```



`hmacDigest`には、バッファーのハッシュデータのダイジェストが含まれています。



### GMAC




WolfCryptは、メッセージダイジェストのニーズにもGMACを提供します。構造`Gmac`は、アプリケーションAES-GCMであるため、ヘッダー`wolfssl/wolfcrypt/aes.h`にあります。GMAC初期化は[`wc_GmacSetKey()`](group__AES.md#function-wc_gmacsetkey)で行われます。



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



`gmacDigest`には、バッファーのハッシュデータのダイジェストが含まれています。



### poly1305



WolfCryptは、メッセージダイジェストニーズに合わせてPoly1305も提供しています。構造体`Poly1305`はヘッダ`wolfssl/wolfcrypt/poly1305.h`にあります.Poly1305の初期化は[`wc_Poly1305SetKey()`](group__Poly1305.md#function-wc_poly1305setkey)で行われます.Poly1305でキーを設定するプロセスは、[`wc_Poly1305Final()`](group__Poly1305.md#function-wc_poly1305final)以降にPoly1305を使用して次にPoly1305を使用して実行する必要があります。



```c
Poly1305    pmac;
byte           key[32];        /*fill key with keying material*/
byte           buffer[2048];   /*fill buffer with data to digest*/
byte           pmacDigest[16];

wc_Poly1305SetKey(&pmac, key, sizeof(key));
wc_Poly1305Update(&pmac, buffer, sizeof(buffer));
wc_Poly1305Final(&pmac, pmacDigest);
```



`pmacDigest`には、バッファーのハッシュデータのダイジェストが含まれています。



## ブロック暗号




### AES




WolfCryptは、16バイト(128ビット)、24バイト(192ビット)、または32バイト(256ビット)のキーサイズを持つAESをサポートしています。サポートされているAESモードには、CBC、CTR、GCM、およびCCM-8が含まれます。


CBCモードは、暗号化と復号化の両方でサポートされており、[`wc_AesSetKey()`](group__AES.md#function-wc_aessetkey),[`wc_AesCbcEncrypt()`](group__AES.md#function-wc_aescbcencrypt)および[`wc_AesCbcDecrypt()`](group__AES.md#function-wc_aescbcdecrypt)の関数を介して提供されます。AESを使用するヘッダー`wolfssl/wolfcrypt/aes.h`を含めてください。AESには16バイトのブロックサイズがあり、IVも16バイトになります。関数の使用法は通常次のとおりです。



```c
Aes enc;
Aes dec;

const byte key[]={  /*some 24 byte key*/ };
const byte iv[]={ /*some 16 byte iv*/ };

byte plain[32];   /*an increment of 16, fill with data*/
byte cipher[32];

/*encrypt*/
wc_AesSetKey(&enc, key, sizeof(key), iv, AES_ENCRYPTION);
wc_AesCbcEncrypt(&enc, cipher, plain, sizeof(plain));
```



`cipher`には、プレーンテキストの暗号文が含まれています。



```c
/*decrypt*/
wc_AesSetKey(&dec, key, sizeof(key), iv, AES_DECRYPTION);
wc_AesCbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```



`plain` CipherTextから元の平文を含みます。


WolfCryptはまた、CTR(Counter)、GCM(Galois/Counter)、およびCCM-8(CBC-MACのCOUNTER)のAESの操作モードをサポートしています。CBCのようにこれらのモードを使用する場合は、`wolfssl/wolfcrypt/aes.h`ヘッダーを含めます。


GCMモードは、[`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey)、[`wc_AesGcmEncrypt()`](group__AES.md#function-wc_aesgcmencrypt)、および[`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt)関数を介した暗号化と復号化の両方で使用できます。使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesgcm_test()`関数を参照してください。


CCM-8モードは、[`wc_AesCcmSetKey()`](group__AES.md#function-wc_aesccmsetkey),[`wc_AesCcmEncrypt()`](group__AES.md#function-wc_aesccmencrypt)、および[`wc_AesCcmDecrypt()`](group__AES.md#function-wc_aesccmdecrypt)の関数を介して暗号化と復号化の両方でサポートされています。使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesccm_test()`関数を参照してください。


CTRモードは、[`wc_AesCtrEncrypt()`](group__AES.md#function-wc_aesctrencrypt)関数を介して暗号化と復号化の両方で使用できます。暗号化および復号化アクションは同一であるため、両方に同じ関数が使用されます。使用例については、ファイル`wolfcrypt/test/test.c`の関数`aes_test()`を参照してください。



#### des and 3des



WolfCryptはDESと3DESのサポートを提供します(3は無効な先頭のC識別子です)。これらを使用するには、ヘッダー`wolfssl/wolfcrypt/des.h`が含まれます。使用できる構造は`Des`および`Des3`です。3DESの場合は24)、ブロックサイズは8バイトであるため、機能を暗号化/復号化するために8バイトの増分だけを渡します。データがブロックサイズの増分になっていない場合は、必ずパディングを追加する必要があります。各`SetKey()`はまたIV(キーサイズと同じサイズの初期化ベクトル)を取ります。使用法は通常次のようなものです。



```c
Des3 enc;
Des3 dec;

const byte key[]={  /*some 24 byte key*/ };
const byte iv[] ={  /*some 24 byte iv*/  };

byte plain[24];   /*an increment of 8, fill with data*/
byte cipher[24];

/*encrypt*/
wc_Des3_SetKey(&enc, key, iv, DES_ENCRYPTION);
wc_Des3_CbcEncrypt(&enc, cipher, plain, sizeof(plain));
```



`cipher`には、プレーンテキストの暗号文が含まれています。



```c
/*decrypt*/
wc_Des3_SetKey(&dec, key, iv, DES_DECRYPTION);
wc_Des3_CbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```



`plain` CipherTextから元の平文を含みます。



#### カメリア



WolfCryptは、Camelliaブロック暗号をサポートしています。Camelliaを使用するには、ヘッダー`wolfssl/wolfcrypt/camellia.h`を含みます。使用できる構造は`Camellia`と呼ばれます。初期化は[`wc_CamelliaSetKey()`](group__Camellia.md#function-wc_camelliasetkey)から行われます.CBC暗号化/復号化は[`wc_CamelliaCbcEnrypt()`](group__Camellia.md#function-wc_CamelliacbcEncrypt)と[`wc_CamelliaCbcDecrypt()`](group__Camellia.md#function-wc_camelliacbcdecrypt)から[`wc_CamelliaEncryptDirect()`](group__Camellia.md#function-wc_camelliaencryptdirect)と[`wc_CamelliaDecryptDirect()`](group__Camellia.md#function-wc_camelliadecryptdirect)まで提供されます。


使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`のcamellia_test()関数を参照してください。



## シップシンパー




### ARC4




**注**：ARC4は古くて安全でないと考えられています。別のストリーム暗号を使用することを検討してください。


インターネットで使用される最も一般的なストリーム暗号はARC4です。WolfCryptは、ヘッダー`wolfssl/wolfcrypt/arc4.h`を通じてそれをサポートしています。ブロックサイズがなく、キーの長さが任意の長さであるため、使用法はブロック暗号よりも簡単です。以下は、ARC4の典型的な使用法です。



```c
Arc4 enc;
Arc4 dec;

const byte key[]={  /*some key any length*/};

byte plain[27];   /*no size restriction, fill with data*/
byte cipher[27];

/*encrypt*/
wc_Arc4SetKey(&enc, key, sizeof(key));
wc_Arc4Process(&enc, cipher, plain, sizeof(plain));
```



`cipher`には、プレーンテキストの暗号文が含まれています。



```c
/*decrypt*/
wc_Arc4SetKey(&dec, key, sizeof(key));
wc_Arc4Process(&dec, plain, cipher, sizeof(cipher));
```



`plain` CipherTextから元の平文を含みます。



### Chacha



20ラウンドのチャチャは、高レベルのセキュリティを維持しながら、ARC4よりわずかに高速です。WolfCryptで使用するには、ヘッダー`wolfssl/wolfcrypt/chacha.h`を含めてください。Chachaは通常32バイトキー(256ビット)を使用しますが、16バイトキー(128ビット)を使用できます。



```c
CHACHA enc;
CHACHA dec;

const byte key[]={  /*some key 32 bytes*/};
const byte iv[] ={  /*some iv 12 bytes*/ };

byte plain[37];   /*no size restriction, fill with data*/
byte cipher[37];

/*encrypt*/
wc_Chacha_SetKey(&enc, key, keySz);
wc_Chacha_SetIV(&enc, iv, counter); /*counter is the start block
                         counter is usually set as 0*/
wc_Chacha_Process(&enc, cipher, plain, sizeof(plain));
```



`cipher`には、プレーンテキストの暗号文が含まれています。



```c
/*decrypt*/
wc_Chacha_SetKey(&enc, key, keySz);
wc_Chacha_SetIV(&enc, iv, counter);
wc_Chacha_Process(&enc, plain, cipher, sizeof(cipher));
```



`plain` CipherTextから元の平文を含みます。


[`wc_Chacha_SetKey`](group__ChaCha.md#function-wc_chacha_setkey)は1回だけ設定する必要がありますが、送信された情報のパケットごとに、New IV(Nonce)で呼び出す必要があります。Counter は、暗号化/復号化プロセスを実行するときに別のブロックから開始することによって、情報の部分的な復号化/暗号化を可能にする引数として設定されますが、ほとんどの場合、0 に設定されます。 **ChaCha は、MAC アルゴリズムなしで使用しないでください (例 Poly1305、hmac).**



## 公開鍵暗号




### RSA




WolfCryptは、ヘッダー`wolfssl/wolfcrypt/rsa.h`を介してRSAのサポートを提供します。PublicとPrivateのRSAキーには2つのタイプがあります。RSA 鍵には、公開鍵と秘密鍵の 2 種類があります。 公開鍵を使用すると、秘密鍵の所有者だけが解読できるものを誰でも暗号化できます。 また、秘密鍵の所有者が何かに署名することもでき、公開鍵を持っている人は誰でも、秘密鍵の所有者だけが実際に署名したことを確認できます。使用法は通常次のようなものです。



```c
RsaKey rsaPublicKey;

byte publicKeyBuffer[] ={ /*holds the raw data from the key, maybe
                        from a file like RsaPublicKey.der*/ };
word32 idx=0;            /*where to start reading into the buffer*/

RsaPublicKeyDecode(publicKeyBuffer, &idx, &rsaPublicKey, sizeof(publicKeyBuffer));

byte in[]={ /*plain text to encrypt*/ };
byte out[128];
RNG rng;

wc_InitRng(&rng);

word32 outLen=RsaPublicEncrypt(in, sizeof(in), out, sizeof(out), &rsaPublicKey, &rng);
```



現在、`out`は、プレーンテキスト`in`から暗号文を保持します。[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)は、エラーの場合に書き込まれたバイトまたは負の数の長さを返します。[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)暗号化装置が使用するパディングにはRNG(乱数ジェネレーター)が必要であり、使用する前に初期化する必要があります。出力バッファーが渡すのに十分な大きさであることを確認するには、最初に[`wc_RsaEncryptSize()`](group__RSA.md#function-wc_rsaencryptsize)を呼び出すことができます。


エラーが発生した場合、[`wc_RsaPublicEnrypt()`](group__RSA.md#function-wc_rsapublicencrypt)、または [`wc_RsaPublicKeyDecode()`](group__RSA.md#function-wc_rsapublickeydecode) からの負数リターンは、 [`wc_ErrorString()`](group__Error.md#function-wc_errorstring) を呼び出して、発生したエラーを説明する文字列を取得できます。



```c
void wc_ErrorString(int error, char* buffer);
```



バッファーが少なくとも`MAX_ERROR_SZ`バイトであることを確認してください(80)。


復号化するために：



```c
RsaKey rsaPrivateKey;

byte privateKeyBuffer[]={ /*hold the raw data from the key, maybe
                              from a file like RsaPrivateKey.der*/ };
word32 idx=0;            /*where to start reading into the buffer*/

wc_RsaPrivateKeyDecode(privateKeyBuffer, &idx, &rsaPrivateKey,
                       sizeof(privateKeyBuffer));

byte plain[128];
word32 plainSz=wc_RsaPrivateDecrypt(out, outLen, plain,
                       sizeof(plain), &rsaPrivateKey);
```



これで、`plain`は`plainSz`バイトまたはエラーコードを保持します。wolfcryptの各タイプの完全な例については、ファイル`wolfcrypt/test/test.c`を参照してください。[`wc_RsaPrivateKeyDecode`](group__RSA.md#function-wc_rsaprivatekeydecode)関数は、raw `DER`形式のキーのみを受け入れることに注意してください。



### DH(diffie-hellman)



WolfCryptは、Header `wolfssl/wolfrypt/dh.h`を通じてDiffie-Hellmanのサポートを提供します。Diffie-HellmanキーExchangeアルゴリズムにより、2つの関係者が共有秘密キーを確立できるようになります。使用は通常、次の例に似ています。ここで、** sideA ** and ** sideB **は2つのパーティを指定します。


次の例では、`dhPublicKey`には、認証局によって署名されたDiffie-Hellmanパブリックパラメータが含まれています(または自己署名)。`privA` SIDEAの生成された秘密鍵を保持し、`pubA`はSIDEAの生成された公開鍵を保持し、`agreeA`は両側が合意したとの相互鍵を保持しています。



```c
DhKey   dhPublicKey;
word32 idx=0;  /*where to start reading into the
                   publicKeyBuffer*/
word32 pubASz, pubBSz, agreeASz;
byte   tmp[1024];
RNG    rng;

byte privA[128];
byte pubA[128];
byte agreeA[128];

wc_InitDhKey(&dhPublicKey);

byte publicKeyBuffer[]={ /*holds the raw data from the public key
                             parameters, maybe from a file like
                             dh1024.der*/ }
wc_DhKeyDecode(tmp, &idx, &dhPublicKey, publicKeyBuffer);
wc_InitRng(&rng);  /*Initialize random number generator*/
```



[`wc_DhGenerateKeyPair()`](group__Diffie-Hellman.md#function-wc_dhgeneratekeypair) DHPublickeyの初期パラメータに基づいて、パブリックおよびプライベートDHキーを生成します。



```c
wc_DhGenerateKeyPair(&dhPublicKey, &rng, privA, &privASz,
            pubA, &pubASz);
```



SIDEBがSIDEAに公開鍵(`pubB`)を送信した後、SIDEAは[`wc_DhAgree()`](group__Diffie-Hellman.md#function-wc_dhagree)関数を使用して相互合意キー(`agreeA`)を生成できます。



```c
wc_DhAgree(&dhPublicKey, agreeA, &agreeASz, privA, privASz,
           pubB, pubBSz);
```



現在、`agreeA`は、SIDEAの相互に生成されたキー(サイズ`agreeASz`バイト)を保持しています。同じプロセスがSideBで行われます。


WolfCryptのDiffie-Hellmanの完全な例については、ファイル`wolfcrypt/test/test.c`を参照してください。



### EDH(Ephemeral DIFFIE-HELLMAN)



wolfSSLサーバーは、Ephemeral Diffie-Hellmanを行うことができます。この機能を追加するためにビルドの変更は必要ありませんが、アプリケーションはEDH暗号スイートを有効にするためにサーバー側に Ephemeral グループパラメーターを登録する必要があります。これを行うために新しいAPIを使用できます。



```c
int wolfSSL_SetTmpDH(WOLFSSL* ssl, unsigned char* p,
                   int pSz,unsigned char* g,int gSz);
```



サンプルサーバーとecho サーバーは、この関数を`SetDH()`から使用しています。



### DSA(デジタル署名アルゴリズム)



WolfCryptは、ヘッダー`wolfssl/wolfcrypt/dsa.h`を介してDSAおよびDSSのサポートを提供します。DSAは、特定のデータハッシュに基づいてデジタル署名を作成できます。DSAは、SHAハッシュアルゴリズムを使用してデータブロックのハッシュを生成し、署名者の秘密鍵を使用してハッシュする署名を生成します。標準的な使用法は、次のものと似ています。


最初にDSAキー構造(`key`)を宣言し、署名される最初のメッセージ(`message`)を初期化し、DSAキーバッファ(`dsaKeyBuffer`)を初期化します(`dsaKeyBuffer`)。



```c
DsaKey key;
Byte   message[]     ={ /*message data to sign*/ }
byte   dsaKeyBuffer[]={ /*holds the raw data from the DSA key,
                            maybe from a file like dsa512.der*/ }
```



次に、SHA構造(`sha`)、乱数ジェネレーター(`rng`)、SHAハッシュ(`hash`)を保存する配列、署名(`signature`)、`idx`を保存する配列を宣言します(`dsaKeyBuffer`で読み始める場所をマークするために)、検証後の戻り値を保持するためのint(`answer`)などがあります。



```c
Sha    sha;
RNG    rng;
byte   hash[SHA_DIGEST_SIZE];
byte   signature[40];
word32 idx=0;
int    answer;
```



SHAハッシュを設定して作成します。WolfCryptのSHAアルゴリズムの詳細については、[SHA/SHA-224/SHA-256/SHA-384/SHA-512](#sha-sha-224-sha-256-sha-384-sha-512)を参照してください.`message`のSHAハッシュは、変数`hash`に格納されています。



```c
wc_InitSha(&sha);
wc_ShaUpdate(&sha, message, sizeof(message));
wc_ShaFinal(&sha, hash);
```



DSAキー構造を初期化し、構造のキー値に入力し、乱数ジェネレーター(`rng`)を初期化します。



```c
wc_InitDsaKey(&key);
wc_DsaPrivateKeyDecode(dsaKeyBuffer, &idx, &key,
                       sizeof(dsaKeyBuffer));
wc_InitRng(&rng);
```



[`wc_DsaSign()`](group__DSA.md#function-wc_dsasign)関数は、DSA秘密キー、ハッシュ値、および乱数ジェネレーターを使用して署名(`signature`)を作成します。



```c
wc_DsaSign(hash, signature, &key, &rng);
```



署名を確認するには、[`wc_DsaVerify()`](group__DSA.md#function-wc_dsaverify)を使用します。検証が成功した場合、答えは「** 1 **」に等しくなります。終了したら、[`wc_FreeDsaKey()`](group__DSA.md#function-wc_freedsakey)を使用してDSAキー構造を解放します。



```c
wc_DsaVerify(hash, signature, &key, &answer);
wc_FreeDsaKey(&key);
```
