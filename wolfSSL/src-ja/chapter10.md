# wolfCryptの使用法

wolfCryptは、主にwolfSSLが使用する暗号ライブラリです。
速度、小さなフットプリント、移植性のために最適化されています。
wolfSSLは、必要に応じて他の暗号ライブラリと交換します。

実装例で使用する型は次の通りです。

```c
typedef unsigned char byte;
typedef unsigned int  word32;
```

ライブラリを`./configure`でビルドした場合は、アプリケーションがライブラリと同じ設定でコンパイルされるように、他のどのwolfSSLヘッダーよりも前に`<wolfssl/options.h>`をインクルードしてください。

## 構造体のアライメント

一部のwolfCrypt構造体は、`WOLFSSL_USE_ALIGN`が定義されている場合、16バイト以上のアライメントを持つメンバーを宣言します。
`./configure`（`--enable-aligndata`）およびCMake（`WOLFSSL_ALIGN_DATA`）はデフォルトでこれを定義しますが、`--enable-usersettings`または`WOLFSSL_USER_SETTINGS`を使用する場合は例外で、`user_settings.h`の内容によって決まります。
また、AES-NI（`WOLFSSL_AESNI`）、Intel高速化（`USE_INTEL_SPEEDUP`）、ARMアセンブリ（`WOLFSSL_ARMASM`）、Xilinx（`WOLFSSL_XILINX`、`WOLFSSL_AFALG_XILINX`）、およびアラインされていないアクセスができない32ビットARMターゲットでは、wolfSSLはこれを強制的に定義します。

`user_settings.h`を使用する場合は、アプリケーションでも`WOLFSSL_USER_SETTINGS`を定義し、ライブラリと同じ`user_settings.h`を使用してください。
設定が一致しないと、アプリケーションとライブラリの間で構造体のレイアウトやアライメントが異なってしまいます。

影響を受ける構造体には、次のものがあります。

- `Aes`、`curve25519_key`、`ed25519_key`、`Rc2`、`LmsKey`、およびOpenSSL互換コンテキスト（CPUを問わず）
- 64ビットCPUでの`wc_Sha256`および`wc_Sha224`（ハードウェアポートがソフトウェアのハッシュ状態を置き換える場合を除く）
- `Hmac`、`wc_HashAlg`、`XtsAes`、`Gmac`、`Cmac`など、これらのいずれかを内包する構造体
- Xilinx Versalでの`Aes`、`ecc_key`、`RsaKey`、`wc_Sha3`、およびこれらを内包する構造体（64バイトのアライメントが必要です）
- `wc_hss_verify()`に渡される`LmsState`（Intel高速化を使用する、またはLMS SHAKEパラメータセットを使用するx86_64ビルドの場合。64バイトのアライメントが必要です）

コンパイラはこれらの構造体に対してアライメントを前提としたロード命令およびストア命令を使用する場合があるため、構造体のメモリは型のアライメント要件を満たしている必要があります。
単独で宣言された変数は、常にこの要件を満たします。
一般的な64ビットプラットフォームでは`malloc()`が返すメモリは16バイトにアラインされており、64バイトが必要なケースを除いて上記のすべてに対応できます。
32ビットプラットフォームでは、`malloc()`は8バイトにアラインされたメモリしか返さない場合があります。
より厳しいアライメントが必要な場合は、`posix_memalign()`や`aligned_alloc()`を使用できます。
より大きなバッファ内の任意のオフセットや、パックされた構造体の内部に配置された構造体は、アライメントがずれている可能性があり、例えばx86_64ではクラッシュすることがあります。

## ハッシュ関数

### MD4

**注意**：MD4は古く、安全でないと考えられています。
可能であれば、異なるハッシュ関数を使用してください。

MD4はデフォルトで無効です。
[`--enable-md4`](chapter02.md#--enable-md4)で有効にできます。
MD4を使用するには、MD4ヘッダー`wolfssl/wolfcrypt/md4.h`をインクルードします。
使用する構造体は`wc_Md4`で、これはtypedefです。
使用する前に、[`wc_InitMd4()`](group__MD4.md#function-wc_initmd4)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_Md4Update()`](group__MD4.md#function-wc_md4update)を使用し、最終的なハッシュを取得するには[`wc_Md4Final()`](group__MD4.md#function-wc_md4final)を使用します。

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

`md4sum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### MD5

**注意**：MD5は古く、安全でないと考えられています。
可能であれば、異なるハッシュ関数を使用してください。

MD5はwolfSSL 5.8.2以降、デフォルトで無効になっています。
[`--enable-md5`](chapter02.md#--enable-md5)で有効にできます。
MD5を使用するには、MD5ヘッダー`wolfssl/wolfcrypt/md5.h`をインクルードします。
使用する構造体は`wc_Md5`で、これはtypedefです。
使用する前に、[`wc_InitMd5()`](group__MD5.md#function-wc_initmd5)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_Md5Update()`](group__MD5.md#function-wc_md5update)を、最終的なハッシュを取得するには[`wc_Md5Final()`](group__MD5.md#function-wc_md5final)を、コンテキストを解放するには[`wc_Md5Free()`](group__MD5.md#function-wc_md5free)を使用します。

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

`md5sum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512

SHAを使用するには、SHAヘッダー`wolfssl/wolfcrypt/sha.h`をインクルードします。
使用する構造体は`wc_Sha`で、これはtypedefです。
使用する前に、[`wc_InitSha()`](group__SHA.md#function-wc_initsha)を実行してハッシュの初期化を行う必要があります。
ハッシュを更新するには[`wc_ShaUpdate()`](group__SHA.md#function-wc_shaupdate)を、最終的なハッシュを取得するには[`wc_ShaFinal()`](group__SHA.md#function-wc_shafinal)を、コンテキストを解放するには[`wc_ShaFree()`](group__SHA.md#function-wc_shafree)を使用します。

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

`shaSum`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

SHA-224、SHA-256、SHA-384、SHA-512のいずれかを使用するには、上記と同じ手順に従います。
ただし、`wolfssl/wolfcrypt/sha256.h`または`wolfssl/wolfcrypt/sha512.h`（SHA-384とSHA-512の両方）のいずれかを使用します。
SHA-256、SHA-384、SHA-512関数は、SHA関数と同様に名付けられています。

**SHA-224**の場合、構造体`wc_Sha224`と共に[`wc_InitSha224()`](group__SHA.md#function-wc_initsha224)、[`wc_Sha224Update()`](group__SHA.md#function-wc_sha224update)、[`wc_Sha224Final()`](group__SHA.md#function-wc_sha224final)関数が使用されます。

**SHA-256**の場合、構造体`wc_Sha256`と共に[`wc_InitSha256()`](group__SHA.md#function-wc_initsha256)、[`wc_Sha256Update()`](group__SHA.md#function-wc_sha256update)、[`wc_Sha256Final()`](group__SHA.md#function-wc_sha256final)関数が使用されます。

**SHA-384**の場合、構造体`wc_Sha384`と共に[`wc_InitSha384()`](group__SHA.md#function-wc_initsha384)、[`wc_Sha384Update()`](group__SHA.md#function-wc_sha384update)、[`wc_Sha384Final()`](group__SHA.md#function-wc_sha384final)関数が使用されます。

**SHA-512**の場合、構造体`wc_Sha512`と共に[`wc_InitSha512()`](group__SHA.md#function-wc_initsha512)、[`wc_Sha512Update()`](group__SHA.md#function-wc_sha512update)、[`wc_Sha512Final()`](group__SHA.md#function-wc_sha512final)関数が使用されます。

切り詰め版である**SHA-512/224**および**SHA-512/256**も`wolfssl/wolfcrypt/sha512.h`にあります。
これらは`wc_Sha512`構造体と共に、`wc_InitSha512_224()`、`wc_Sha512_224Update()`、`wc_Sha512_224Final()`（または`wc_InitSha512_256()`系の関数）を使用します。
ダイジェストサイズは`WC_SHA224_DIGEST_SIZE`、`WC_SHA256_DIGEST_SIZE`、`WC_SHA384_DIGEST_SIZE`、`WC_SHA512_DIGEST_SIZE`、`WC_SHA512_224_DIGEST_SIZE`、`WC_SHA512_256_DIGEST_SIZE`です。
コンテキストが不要になったら、対応する`Free`関数（`wc_Sha224Free()`、`wc_Sha256Free()`、`wc_Sha384Free()`、`wc_Sha512Free()`、`wc_Sha512_224Free()`、`wc_Sha512_256Free()`）で解放してください。

複数のハッシュコンテキストを同時に（インターリーブして）処理できます。
ソフトウェアSHAは常にインターリービングをサポートしています。
`NO_WOLFSSL_SHA256_INTERLEAVE`マクロはライブラリを変更しません。
このマクロは、インターリーブされたハッシュコンテキストを扱えないハードウェアポートにおいて、wolfCryptテストアプリケーションがインターリーブのテストを行わないようにするだけです（例えば、NXP LPC55S6xではこのマクロが設定されています）。

### SHA-3 / SHAKE

SHA-3（FIPS 202）と、拡張可能出力関数であるSHAKE128 / SHAKE256は、`wolfssl/wolfcrypt/sha3.h`で宣言されています。
これらはデフォルトで有効であり（同じくデフォルトで有効なML-KEMがこれらを必要とします）、[`--enable-sha3`](chapter02.md#--enable-sha3)、`--enable-shake128`、`--enable-shake256`で制御します。
SHA-3で使用する構造体は`wc_Sha3`です。
SHA3-256の場合は、[`wc_InitSha3_256()`](group__SHA.md#function-wc_initsha3_256)で初期化し、[`wc_Sha3_256_Update()`](group__SHA.md#function-wc_sha3_256_update)、[`wc_Sha3_256_Final()`](group__SHA.md#function-wc_sha3_256_final)、[`wc_Sha3_256_Free()`](group__SHA.md#function-wc_sha3_256_free)を使用します。
SHA3-224、SHA3-384、SHA3-512も、関数名の数字を`224`、`384`、`512`にすることで同様に使用できます。

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

`sha3Sum`には、bufferのデータのダイジェストが格納されます。

SHAKEは`wc_Shake`構造体を使用し、要求された任意の長さの出力を生成します。
出力の長さは`Final`の呼び出しに渡します。
SHAKE256の場合は、[`wc_InitShake256()`](group__SHA.md#function-wc_initshake256)、[`wc_Shake256_Update()`](group__SHA.md#function-wc_shake256_update)、[`wc_Shake256_Final()`](group__SHA.md#function-wc_shake256_final)、[`wc_Shake256_Free()`](group__SHA.md#function-wc_shake256_free)を使用します。
SHAKE128の関数名も同じ規則に従います。

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

BLAKE2bはデフォルトで無効です。
[`--enable-blake2`](chapter02.md#--enable-blake2b)で有効にできます。
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
`digest`には、`input`のデータのダイジェストが格納されます。

使用例はwolfCryptテストアプリケーション（`wolfcrypt/test/test.c`）の`blake2b_test()`関数内にあります。

### RIPEMD-160

RIPEMD-160はデフォルトで無効です。
[`--enable-ripemd`](chapter02.md#--enable-ripemd)で有効にできます。
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
HMACの初期化は、`wc_HmacInit()`の後に[`wc_HmacSetKey()`](group__HMAC.md#function-wc_hmacsetkey)を呼び出して行い、使用後は`wc_HmacFree()`でコンテキストを解放します。
サポートされるハッシュタイプは、MD5、SHA-1、SHA-224、SHA-256、SHA-384、SHA-512、SHA-512/224、SHA-512/256、SHA3-224、SHA3-256、SHA3-384、SHA3-512、SM3です（いずれもビルドで有効になっている場合に限ります。また、FIPSビルドではMD5は拒否されます）。
以下は、SHA-256の例です。

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

`hmacDigest`には、bufferのハッシュ化されたデータのダイジェストが含まれます。

### GMAC

wolfCryptはメッセージダイジェストのニーズに対してGMACも提供しています。
構造体`Gmac`はヘッダー`wolfssl/wolfcrypt/aes.h`にあります（AES-GCMのアプリケーションです）。
`Gmac`は`Aes`オブジェクトを保持しており、このオブジェクトは[`wc_AesInit()`](group__AES.md#function-wc_aesinit)で初期化し、[`wc_AesFree()`](group__AES.md#function-wc_aesfree)で解放します。
鍵は[`wc_GmacSetKey()`](group__AES.md#function-wc_gmacsetkey)で設定します。
[`wc_GmacUpdate()`](group__AES.md#function-wc_gmacupdate)はバッファ全体に対してタグを計算するワンショットの呼び出しであり、ストリーミングで更新する関数ではありません。

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

### KMACおよびcSHAKE

wolfCryptには、SHA-3から派生したSP 800-185の2つの関数であるcSHAKE（カスタマイズ可能なSHAKE）とKMAC（Keccakメッセージ認証コード）が含まれています。
これらはそれぞれ[`--enable-cshake`](chapter02.md#--enable-cshake)と[`--enable-kmac`](chapter02.md#--enable-kmac)で有効にでき、どちらも`wolfssl/wolfcrypt/sha3.h`で宣言されています。
KMACは、鍵とオプションのカスタマイズ文字列を使用して動作します。
`wc_Kmac128_Final()` / `wc_Kmac256_Final()`で固定長のタグを生成することも、`wc_Kmac128_FinalXof()` / `wc_Kmac256_FinalXof()`で任意の長さの出力を生成することもできます。

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

`tag`には、bufferのデータに対するKMAC256認証タグが格納されます。
ワンショット関数`wc_Kmac128Hash()`および`wc_Kmac256Hash()`は、1回の呼び出しでタグを計算します。

cSHAKEも、`wc_Cshake`構造体を使用して同じパターンで使用します。
`wc_InitCshake256()`は関数名文字列とカスタマイズ文字列（いずれも空でも構いません）を受け取り、その後に`wc_Cshake256_Update()`、`wc_Cshake256_Final()`（要求する出力長を受け取ります）、`wc_Cshake256_Free()`を続けて呼び出します。
ワンショットの`wc_Cshake256()`は、これらすべてを1回の呼び出しで行います。
cSHAKE128の関数名も同じ規則に従います。

## パスワードハッシュ

### Argon2

Argon2（RFC 9106）は、メモリハードなパスワードハッシュ関数です。
wolfSSL 5.9.4以降、[`--enable-argon2`](chapter02.md#--enable-argon2)で利用可能であり、Argon2d、Argon2i、Argon2idの3つのバリアントすべてに対応しています。
APIは`wolfssl/wolfcrypt/argon2.h`にあります。
ワンショットの`wc_Argon2()`関数は、パスワード、ソルト、およびメモリ、時間、並列度の各コストパラメータから単一のタグを導出します。

```c
byte password[] = "password";
byte salt[16];          /*fill salt with random bytes*/
byte tag[32];
int  ret;

ret = wc_Argon2(WC_ARGON2_ID, tag, sizeof(tag),
                password, sizeof(password) - 1, salt, sizeof(salt),
                4 /*parallelism*/, 65536 /*memory in KiB*/, 3 /*passes*/);
```

同じパラメータで多数のタグを導出するアプリケーションには、コンテキストAPI（`wc_Argon2Init()`、`wc_Argon2SetParams()`、`wc_Argon2DeriveTag()`、`wc_Argon2Free()`）の方が適しています。
コンテキストAPIはメモリブロック配列を一度だけ確保し、それを再利用します。
[`--enable-argon2-threads`](chapter02.md#--enable-argon2-threads)を使用すると、スライス内の各セグメントが並列に埋められ、`wc_Argon2SetThreads()`でコンテキストのスレッド数を設定できます。
いずれの場合も、スレッド化によって導出されるタグが変わることはありません。

## ブロック暗号

### AES

wolfCryptは16バイト（128ビット）、24バイト（192ビット）、32バイト（256ビット）の鍵サイズのAESをサポートしています。
サポートされるAESモードには、CBC、CTR、GCM（GCM-ストリーミング）、GCM-SIV、OFB、CFB（1、8、128）、SIV、EAX、CTS、XTS（XTS-ストリーミング）、GMAC、CMAC、ECB、KW（KeyWrap）、CCMが含まれます。
CBCとGCMはデフォルトで有効です。
その他のほとんどのモードには、[`--enable-aesctr`](chapter02.md#--enable-aesctr)、[`--enable-aesccm`](chapter02.md#--enable-aesccm)、[`--enable-aesgcm-stream`](chapter02.md#--enable-aesgcm-stream)、[`--enable-aeseax`](chapter02.md#--enable-aeseax)、[`--enable-aescts`](chapter02.md#--enable-aescts)などの個別のconfigureオプションがあります。

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

wc_AesInit(&enc, NULL, INVALID_DEVID);
wc_AesInit(&dec, NULL, INVALID_DEVID);

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
`Aes`オブジェクトが不要になったら、[`wc_AesFree()`](group__AES.md#function-wc_aesfree)で解放してください。
一部のハードウェアポートでは、この呼び出しが必要です。

```c
wc_AesFree(&enc);
wc_AesFree(&dec);
```

wolfCryptはAESの動作モードとしてCTR（カウンター）、GCM（ガロア/カウンター）、CCM（CBC-MAC付きカウンター）もサポートしています。
CBCと同様に、これらのモードを使用する場合は、ヘッダー`wolfssl/wolfcrypt/aes.h`をインクルードしてください。

GCMモードは[`wc_AesGcmSetKey()`](group__AES.md#function-wc_aesgcmsetkey)、[`wc_AesGcmEncrypt()`](group__AES.md#function-wc_aesgcmencrypt)、[`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt)関数を通じて暗号化と復号の両方で利用できます。
以下のAES-GCMの例をご参照ください。
その他の使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesgcm_test()`関数をご参照ください。

CCMモードは[`wc_AesCcmSetKey()`](group__AES.md#function-wc_aesccmsetkey)、[`wc_AesCcmEncrypt()`](group__AES.md#function-wc_aesccmencrypt)、[`wc_AesCcmDecrypt()`](group__AES.md#function-wc_aesccmdecrypt)関数を通じて暗号化と復号の両方でサポートしています。
認証タグのサイズとして4、6、8、10、12、14、16バイトを指定できるため、CCM-8（8バイトのタグ）も選択肢の1つです。
CCMを使用するには[`--enable-aesccm`](chapter02.md#--enable-aesccm)が必要です。
使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`の`aesccm_test()`関数をご参照ください。

CTRモードは[`wc_AesCtrEncrypt()`](group__AES.md#function-wc_aesctrencrypt)関数を通じて暗号化と復号の両方で利用でき、[`--enable-aesctr`](chapter02.md#--enable-aesctr)が必要です。
暗号化と復号のアクションは同一であるため、両方に同じ関数が使用されます。
そのため、どちらの方向でも、`wc_AesSetKey()`または`wc_AesCtrSetKey()`を使用して`AES_ENCRYPTION`で鍵を設定する必要があります。
使用例については、ファイル`wolfcrypt/test/test.c`の`aes_ctr_test()`関数をご参照ください。

ノンスの誤用に対する耐性を持つAEADであるAES-GCM-SIV（RFC 8452）は、[`--enable-aesgcm-siv`](chapter02.md#--enable-aesgcm-siv)で利用できます。
AES-GCM-SIVはワンショットの`wc_AesGcmSivEncrypt()`および`wc_AesGcmSivDecrypt()`関数として提供されており、これらの関数は`Aes`オブジェクトではなく、鍵、ノンス、追加データ、入力を直接受け取ります。
使用例については、`wolfcrypt/test/test.c`のAES-GCM-SIVテストをご参照ください。

AESキーラップ（RFC 3394）は、[`--enable-aeskeywrap`](chapter02.md#--enable-aeskeywrap)を指定すると`wc_AesKeyWrap()` / `wc_AesKeyUnWrap()`によって提供されます。
パディング付きのバリアントであるAES Key Wrap with Padding（RFC 5649）は、8バイトの倍数ではない鍵素材も受け付けます。
こちらは`--enable-aeskeywrap=padding`を指定すると`wc_AesKeyWrap_Pad()` / `wc_AesKeyUnWrap_Pad()`によって提供されます。

#### AES-GCM

AES-GCMはAEAD（追加データ付き認証暗号）モードであり、デフォルトで有効です。
AES-GCMは、鍵、ノンス（IV）、省略可能な追加認証データ（`aad`）を受け取り、平文と同じ長さの暗号文と認証タグを生成します。
ノンスは同じ鍵で決して再利用してはいけません。
`aad`は認証の対象になりますが、暗号化はされません。
12バイトのノンスと16バイトのタグを推奨します。

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

`cipher`と`tag`には、暗号文と認証タグが格納されます。
これらはどちらも、`iv`および`aad`とともに受信者に送信します。
[`wc_AesGcmDecrypt()`](group__AES.md#function-wc_aesgcmdecrypt)はタグを検証し、暗号文、タグ、追加データのいずれかが改ざんされていた場合は`AES_GCM_AUTH_E`を返します。
その場合、`plain`を使用してはいけません。

```c
/*decrypt and check the tag; a non-zero return means the data was altered*/
ret = wc_AesGcmDecrypt(&aes, plain, cipher, sizeof(cipher), iv, sizeof(iv),
                       tag, sizeof(tag), aad, sizeof(aad));
wc_AesFree(&aes);
```

FIPSビルドでは、呼び出し元が指定したIVを使用する`wc_AesGcmEncrypt()`は承認されていません。
代わりに、`wc_AesGcmSetIV()`でモジュール内部でIVを生成し、`wc_AesGcmEncrypt_ex()`で暗号化してください。

データが一度にすべて揃わない場合は、ストリーミングAPI（`--enable-aesgcm-stream`。`WOLFSSL_AESGCM_STREAM`を定義します）を使用して分割して処理できます。
`wc_AesGcmEncryptInit()`は鍵とIVを設定します（現在の鍵をそのまま使用する場合は、鍵に`NULL`を渡します）。
`wc_AesGcmEncryptUpdate()`は、呼び出しごとに平文または追加データ（あるいはその両方）の次の部分を受け取ります（追加データはすべて、平文の最初のバイトよりも前に渡す必要があります）。
`wc_AesGcmEncryptFinal()`はタグを生成します。
結果は上記のワンショット呼び出しと同一です。

```c
wc_AesInit(&aes, NULL, INVALID_DEVID);
wc_AesGcmEncryptInit(&aes, key, sizeof(key), iv, sizeof(iv));
wc_AesGcmEncryptUpdate(&aes, NULL, NULL, 0, aad, sizeof(aad));
wc_AesGcmEncryptUpdate(&aes, cipher, plain, 32, NULL, 0);
wc_AesGcmEncryptUpdate(&aes, cipher + 32, plain + 32, 32, NULL, 0);
wc_AesGcmEncryptFinal(&aes, tag, sizeof(tag));
wc_AesFree(&aes);
```

復号も同様に、`wc_AesGcmDecryptInit()`、`wc_AesGcmDecryptUpdate()`、`wc_AesGcmDecryptFinal()`を使用します。
`wc_AesGcmDecryptFinal()`はタグを検証し、一致しない場合は`AES_GCM_AUTH_E`を返します。
平文の各部分はタグの検証前に返されるため、検証が成功するまでは信頼してはいけません。
`wc_AesGcmInit()`は、どちらの`Init`関数の代わりにも使用できます。

### DESおよび3DES

DESと3DESはデフォルトで無効です。
[`--enable-des3`](chapter02.md#--enable-des3)で有効にできます。
wolfCryptはDESおよび3DESをサポートしています。
（ただし、C言語では先頭に数字を使用できないため、Des3と示しています。）
これらを使用するには、ヘッダー`wolfssl/wolfcrypt/des3.h`をインクルードします。
使用できる構造体は`Des`および`Des3`です。
初期化は[`wc_Des_SetKey()`](group__DES.md#function-wc_des_setkey)または[`wc_Des3_SetKey()`](group__DES.md#function-wc_des3_setkey)を通じて行われます。
CBC暗号化/復号は[`wc_Des_CbcEncrypt()`](group__DES.md#function-wc_des_cbcencrypt) / [`wc_Des_CbcDecrypt()`](group__DES.md#function-wc_des_cbcdecrypt)および[`wc_Des3_CbcEncrypt()`](group__DES.md#function-wc_des3_cbcencrypt) / [`wc_Des3_CbcDecrypt()`](group__DES.md#function-wc_des3_cbcdecrypt)を通じて提供されます。
Desの鍵サイズは8バイト（3DESでは24）で、ブロックサイズは8バイトなので、暗号化/復号関数には8バイトの倍数のみを渡してください。
データがブロックサイズの倍数でない場合は、確実にそうなるようにパディングを追加する必要があります。
各`SetKey()`はIVも受け取ります。
IVはDESと3DESのどちらでも1ブロック（8バイト）です。
使用方法は通常、次のとおりです。

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

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_Des3_SetKey(&dec, key, iv, DES_DECRYPTION);
wc_Des3_CbcDecrypt(&dec, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

### Camellia

wolfCryptはCamelliaブロック暗号をサポートしています。
Camelliaはデフォルトで無効です。
[`--enable-camellia`](chapter02.md#--enable-camellia)で有効にできます。
Camelliaを使用するには、ヘッダー`wolfssl/wolfcrypt/camellia.h`をインクルードします。
使用できる構造体は`wc_Camellia`と呼ばれます。
初期化は[`wc_CamelliaSetKey()`](group__Camellia.md#function-wc_camelliasetkey)を通じて行われます。
CBC暗号化/復号は[`wc_CamelliaCbcEncrypt()`](group__Camellia.md#function-wc_camelliacbcencrypt)および[`wc_CamelliaCbcDecrypt()`](group__Camellia.md#function-wc_camelliacbcdecrypt)を通じて提供され、直接の暗号化/復号は[`wc_CamelliaEncryptDirect()`](group__Camellia.md#function-wc_camelliaencryptdirect)および[`wc_CamelliaDecryptDirect()`](group__Camellia.md#function-wc_camelliadecryptdirect)を通じて提供されます。

使用例については、`<wolfssl_root>/wolfcrypt/test/test.c`のcamellia_test()関数をご参照ください。

## ストリーム暗号

### ARC4

**注意**：ARC4は古く、安全でないと考えられています。
他のストリーム暗号の使用をご検討ください。

ARC4はデフォルトで無効です。
[`--enable-arc4`](chapter02.md#--enable-arc4)で有効にできます。
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

`cipher`には、平文から生成された暗号文が入ります。

```c
/*decrypt*/
wc_Chacha_SetKey(&dec, key, sizeof(key));
wc_Chacha_SetIV(&dec, iv, 0);
wc_Chacha_Process(&dec, plain, cipher, sizeof(cipher));
```

`plain`には、暗号文を復号することで生成された平文が入ります。

[`wc_Chacha_SetKey`](group__ChaCha.md#function-wc_chacha_setkey)は一度設定するだけで済みますが、送信される各情報パケットごとに新しいiv（ノンス）を使用して[`wc_Chacha_SetIV()`](group__ChaCha.md#function-wc_chacha_setiv)を呼び出す必要があります。
カウンターは、暗号化/復号プロセスを実行するときに異なるブロックから開始することで、部分的に情報を暗号化/復号できるように引数として設定されますが、ほとんどの場合は0に設定されます。
**ChaChaはMACアルゴリズム（例：Poly1305、HMAC）なしで使用しないでください。**
後述のChaCha20-Poly1305 AEADを使用すると、これが自動的に行われます。

24バイトのノンスを使用するバリアントであるXChaCha20は、[`--enable-xchacha`](chapter02.md#--enable-xchacha)で利用できます。
XChaCha20の鍵とノンスは、`wc_XChacha_SetKey()`で同時に設定します。

### ChaCha20-Poly1305

ChaCha20-Poly1305（RFC 8439）は、ChaCha20ストリーム暗号とPoly1305認証子を組み合わせたAEADです。
デフォルトで有効であり、`wolfssl/wolfcrypt/chacha20_poly1305.h`で宣言されています。
ワンショットの[`wc_ChaCha20Poly1305_Encrypt()`](group__ChaCha20Poly1305.md#function-wc_chacha20poly1305_encrypt)は、32バイトの鍵、同じ鍵の下でメッセージごとに一意でなければならない12バイトのノンス、およびオプションの追加認証データを受け取り、暗号文（平文と同じ長さ）と16バイトのタグを出力します。

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

[`wc_ChaCha20Poly1305_Decrypt()`](group__ChaCha20Poly1305.md#function-wc_chacha20poly1305_decrypt)は平文を返す前にタグを検証し、暗号文、タグ、追加データのいずれかが改ざんされていた場合は`MAC_CMP_FAILED_E`を返します。

```c
/*decrypt and check the tag; a non-zero return means the data was altered*/
ret = wc_ChaCha20Poly1305_Decrypt(key, iv, aad, sizeof(aad),
                                  cipher, sizeof(cipher), tag, plain);
```

データが分割して届く場合は、`wc_ChaCha20Poly1305_Init()`、`wc_ChaCha20Poly1305_UpdateAad()`、`wc_ChaCha20Poly1305_UpdateData()`、`wc_ChaCha20Poly1305_Final()`によるストリーミングインターフェースを使用できます。
`--enable-xchacha`を指定すると、24バイトのノンスを受け取る`wc_XChaCha20Poly1305_Encrypt()`および`wc_XChaCha20Poly1305_Decrypt()`を通じて、XChaCha20-Poly1305を利用できます。

## 乱数生成

wolfCryptの乱数ジェネレータは`wolfssl/wolfcrypt/random.h`で宣言されています。
使用する構造体は`WC_RNG`です。
デフォルトでは、オペレーティングシステムのエントロピーソースからシードを得るHash_DRBG（NIST SP 800-90A）として動作します。
[`wc_InitRng()`](group__Random.md#function-wc_initrng)で一度だけ初期化し、[`wc_RNG_GenerateBlock()`](group__Random.md#function-wc_rng_generateblock)で乱数バイト列を取得するか（1回の呼び出しにつき最大`RNG_MAX_BLOCK_LEN`、すなわち64 KiB）、`wc_RNG_GenerateByte()`で1バイトを取得し、[`wc_FreeRng()`](group__Random.md#function-wc_freerng)で解放します。

```c
WC_RNG rng;
byte   block[32];

wc_InitRng(&rng);                  /*returns 0 on success*/
wc_RNG_GenerateBlock(&rng, block, sizeof(block));
wc_FreeRng(&rng);
```

初期化済みの同じ`WC_RNG`を、以下のすべての公開鍵関数に渡すことができます。
既に初期化されているRNGに対して、解放せずに`wc_InitRng()`を再度呼び出さないでください。
リソースリークの原因となります。

## 公開鍵暗号

### RSA

wolfCryptはヘッダー`wolfssl/wolfcrypt/rsa.h`を通じてRSAをサポートしています。
RSA鍵には、公開鍵と秘密鍵の2種類があります。
公開鍵を使えば、誰でも、秘密鍵の保持者だけが復号できる形でデータを暗号化できます。
また、秘密鍵の保持者が何かに署名することを可能にし、公開鍵を持つ誰もが、秘密鍵の保持者が署名したことを確認できます。
使用方法は通常、次のとおりです。

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

これで`out`には、平文`in`からの暗号文が含まれます。
[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)は、`out`に書き込まれたバイト数を返すか、エラーの場合は負の数を返します。
[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)には、暗号化に使用されるパディング用のRNG（乱数ジェネレータ）が必要であり、使用する前に初期化する必要があります。
この関数はPKCS #1 v1.5パディングを使用します。
OAEPパディングは[`wc_RsaPublicEncrypt_ex()`](group__RSA.md#function-wc_rsapublicencrypt_ex)で利用できます。
出力バッファが十分な大きさであることを確認するために、最初に[`wc_RsaEncryptSize()`](group__RSA.md#function-wc_rsaencryptsize)を呼び出すことができます。
これにより、[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)が成功した場合に書き込むバイト数が返されます。

エラーが発生した場合、[`wc_RsaPublicEncrypt()`](group__RSA.md#function-wc_rsapublicencrypt)または[`wc_RsaPublicKeyDecode()`](group__RSA.md#function-wc_rsapublickeydecode)から負の戻り値が返されます。
その場合、[`wc_ErrorString()`](group__Error.md#function-wc_errorstring)を呼び出して、発生したエラーを説明する文字列を取得できます。

```c
void wc_ErrorString(int error, char* buffer);
```

バッファが少なくとも`WOLFSSL_MAX_ERROR_SZ`バイト（80）であることを確認してください。

続いて、`out`を復号します。
RSAブラインディングが有効な場合（`WC_RSA_BLINDING`。ライブラリを[`--disable-harden`](chapter02.md#--disable-harden)でビルドしない限りデフォルトで有効です）、[`wc_RsaPrivateDecrypt()`](group__RSA.md#function-wc_rsaprivatedecrypt)を使用するには[`wc_RsaSetRNG()`](group__RSA.md#function-wc_rsasetrng)で鍵にRNGを設定する必要があります。
設定しない場合は`MISSING_RNG_E`で失敗します。

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

これで、`plain`には`plainSz`バイトのデータが格納されます。
エラーの場合、`plainSz`は負のエラーコードになります。
完了したら、鍵とRNGを解放します。

```c
wc_FreeRsaKey(&rsaPublicKey);
wc_FreeRsaKey(&rsaPrivateKey);
wc_FreeRng(&rng);
```

wolfCryptでの各タイプの完全な例については、ファイル`wolfcrypt/test/test.c`をご参照ください。
[`wc_RsaPrivateKeyDecode`](group__RSA.md#function-wc_rsaprivatekeydecode)関数は、生の`DER`形式の鍵のみを受け入れます。

### DH (Diffie-Hellman)

wolfCryptはヘッダー`wolfssl/wolfcrypt/dh.h`を通じてDiffie-Hellmanをサポートしています。
Diffie-Hellman鍵交換アルゴリズムにより、2人の当事者間で共有秘密鍵を確立できます。
使用方法は通常、次の例のようになります。
ここで**sideA**と**sideB**は2つの当事者を示します。

以下の例では、`dhPublicKey`はDiffie-Hellmanのグループパラメータ（p、g）を保持しています。
これは、例えば`certs/dh2048.der`のようなDER形式のパラメータファイルから読み込んだものです。
`privA`はsideAに対して生成された秘密鍵、`pubA`はsideAに対して生成された公開鍵を保持します。
`agreeA`は、両者が合意した相互鍵を保持します。
サイズを表す引数は入出力兼用で、入力時にはバッファサイズを、出力時には書き込まれたバイト数を保持します。

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
完了したら、鍵とRNGを解放します。

```c
wc_FreeDhKey(&dhPublicKey);
wc_FreeRng(&rng);
```

wolfCryptでのDiffie-Hellmanの完全な実装例については、ファイル`wolfcrypt/test/test.c`をご参照ください。

### EDH (Ephemeral Diffie-Hellman)

wolfSSLサーバーはEphemeral Diffie-Hellmanを実行できます。
この機能を追加するためにビルドの変更は必要ありませんが、EDH暗号スイートを有効にするためにはサーバー側でアプリケーションが一時的なグループパラメータを登録する必要があります。
これには、次のAPIを使用します。

```c
int wolfSSL_SetTmpDH(WOLFSSL* ssl, const unsigned char* p,
                   int pSz, const unsigned char* g, int gSz);
```

パラメータは、[`wolfSSL_CTX_SetTmpDH()`](group__CertsKeys.md#function-wolfssl_ctx_settmpdh)を使用して、コンテキストのすべての接続に対して設定することもできます。
また、[`wolfSSL_SetTmpDH_file()`](group__CertsKeys.md#function-wolfssl_settmpdh_file)および[`wolfSSL_SetTmpDH_buffer()`](group__CertsKeys.md#function-wolfssl_settmpdh_buffer)（およびそれぞれに対応する`wolfSSL_CTX_`版）を使用して、PEMまたはDER形式のパラメータファイルやバッファから読み込むこともできます。
実装例として提供しているサーバーとechoserverは、`wolfSSL_SetTmpDH_file()`で`certs/dh2048.pem`を読み込みます。
ファイルシステムが無い場合に限り、`wolfSSL_SetTmpDH()`を呼び出す`SetDH()`（`wolfssl/test.h`内）を代わりに使用します。

### DSA (デジタル署名アルゴリズム)

DSAはデフォルトで無効です。
[`--enable-dsa`](chapter02.md#--enable-dsa)で有効にできます。
wolfCryptはヘッダー`wolfssl/wolfcrypt/dsa.h`を通じてDSAとDSSをサポートしています。
DSAは、与えられたデータハッシュに基づいてデジタル署名を作成することを可能にします。
DSAはSHAハッシュアルゴリズムを使用してデータブロックのハッシュを生成し、その後署名者の秘密鍵を使用してそのハッシュに署名します。
標準的な使用方法は次のようになります。

まず、DSA鍵構造（`key`）を宣言し、署名される初期メッセージ（`message`）を初期化し、DSA鍵バッファ（`dsaKeyBuffer`）を初期化します。

```c
DsaKey key;
byte   message[]      = { /*message data to sign*/ };
byte   dsaKeyBuffer[] = { /*holds the raw data from the DSA key,
                            maybe from a file like dsa2048.der*/ };
```

次に、SHA構造体（`sha`）、乱数ジェネレータ（`rng`）、SHAハッシュを格納する配列（`hash`）、署名を格納する配列（`signature`）、`idx`（`dsaKeyBuffer`の読み込み開始位置を示す）、検証後の戻り値を保持するint型の変数（`answer`）を宣言します。

```c
wc_Sha sha;
WC_RNG rng;
byte   hash[WC_SHA_DIGEST_SIZE];
byte   signature[40];
word32 idx = 0;
int    answer;
```

SHAハッシュを設定して作成します。
wolfCryptのSHAアルゴリズムの詳細については、本章の[SHA / SHA-224 / SHA-256 / SHA-384 / SHA-512](#sha-sha-224-sha-256-sha-384-sha-512)節をご参照ください。
`message`のSHAハッシュは、変数`hash`に格納されます。

```c
wc_InitSha(&sha);
wc_ShaUpdate(&sha, message, sizeof(message));
wc_ShaFinal(&sha, hash);
wc_ShaFree(&sha);
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
完了したら、[`wc_FreeDsaKey()`](group__DSA.md#function-wc_freedsakey)を使用してDSA鍵構造体を解放し、RNGも解放します。

```c
wc_DsaVerify(hash, signature, &key, &answer);
wc_FreeDsaKey(&key);
wc_FreeRng(&rng);
```

### ECC (ECDSAおよびECDH)

楕円曲線暗号はデフォルトで有効であり、`wolfssl/wolfcrypt/ecc.h`で宣言されています。
鍵構造体は`ecc_key`で、[`wc_ecc_init()`](group__ECC.md#function-wc_ecc_init)で初期化し、[`wc_ecc_free()`](group__ECC.md#function-wc_ecc_free)で解放します。
[`wc_ecc_make_key_ex()`](group__ECC.md#function-wc_ecc_make_key_ex)は鍵ペアを生成します。
この関数は、バイト単位の鍵サイズと、`ECC_SECP256R1`、`ECC_SECP384R1`、`ECC_SECP521R1`などの曲線識別子を引数に取ります。

ECDSAはメッセージそのものではなく、メッセージのハッシュに署名します。
[`wc_ecc_sign_hash()`](group__ECC.md#function-wc_ecc_sign_hash)はDERエンコードされた署名を書き込むため、署名バッファのサイズは`ECC_MAX_SIG_SIZE`バイト（または特定の鍵に対しては[`wc_ecc_sig_size()`](group__ECC.md#function-wc_ecc_sig_size)の値）とし、実際の長さは`sigSz`に返されます。
[`wc_ecc_verify_hash()`](group__ECC.md#function-wc_ecc_verify_hash)は、検証処理を実行できた場合に0を返し、検証結果は別途`verified`に格納します。
そのため、両方を確認する必要があります。

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

ECDHでは、両者がそれぞれ同じ曲線上で鍵ペアを生成し、自身の公開鍵を相手側に送信します。
公開鍵は、例えば[`wc_ecc_export_x963()`](group__ECC.md#function-wc_ecc_export_x963)を使用してANSI X9.63形式で送信します。
相手側の公開鍵は[`wc_ecc_import_x963()`](group__ECC.md#function-wc_ecc_import_x963)で読み込み、[`wc_ecc_shared_secret()`](group__ECC.md#function-wc_ecc_shared_secret)で共有秘密を計算します。
デフォルトのタイミング耐性ビルド（`ECC_TIMING_RESISTANT`）では、`wc_ecc_set_rng()`で秘密鍵にRNGを設定する必要があります。
設定しない場合、`wc_ecc_shared_secret()`は`MISSING_RNG_E`で失敗します。

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

これで`secret`には`secretSz`バイトの共有秘密が格納され、その値は両者で同じになります。
共有秘密を鍵として使用する前に、鍵導出関数（例えばHKDF）で処理してください。
その他の例については、`wolfcrypt/test/test.c`の`ecc_test()`関数をご参照ください。

### Curve25519 (X25519)

X25519鍵合意（RFC 7748）はデフォルトで無効です。
[`--enable-curve25519`](chapter02.md#--enable-curve25519)で有効にできます。
X25519は`wolfssl/wolfcrypt/curve25519.h`で宣言されており、`curve25519_key`構造体を使用します。
公開鍵は32バイト（`CURVE25519_KEYSIZE`）で、[`wc_curve25519_export_public()`](group__Curve25519.md#function-wc_curve25519_export_public)と[`wc_curve25519_import_public()`](group__Curve25519.md#function-wc_curve25519_import_public)を使用して交換します。

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

[`wc_curve25519_make_key()`](group__Curve25519.md#function-wc_curve25519_make_key)は、X25519ブラインディング（`WOLFSSL_CURVE25519_BLINDING`。C実装ではデフォルト）を使用するビルドのために、RNGを鍵に関連付ける処理も行います。
そのようなビルドで秘密鍵を生成せずにインポートする場合は、[`wc_curve25519_shared_secret()`](group__Curve25519.md#function-wc_curve25519_shared_secret)の前に`wc_curve25519_set_rng()`を呼び出してください。

### Ed25519

Ed25519署名（RFC 8032）はデフォルトで無効です。
[`--enable-ed25519`](chapter02.md#--enable-ed25519)で有効にできます。
Ed25519は`wolfssl/wolfcrypt/ed25519.h`で宣言されており、`ed25519_key`構造体を使用します。
ECDSAとは異なり、Ed25519はメッセージそのものに署名し、署名は常に64バイト（`ED25519_SIG_SIZE`）です。

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

公開鍵は、[`wc_ed25519_export_public()`](group__ED25519.md#function-wc_ed25519_export_public)で検証者向けにエクスポートし、`wc_ed25519_import_public()`で読み込むことができます。

## 耐量子暗号

wolfCryptは、NISTの耐量子アルゴリズムを独自に実装しています。
本節ではML-KEMとML-DSAについて説明します。
SLH-DSA、Falcon、LMS/HSS、XMSS、およびTLS 1.3でのそれらの使用については、[付録I 耐量子暗号の評価](appendix09.md)をご参照ください。

### ML-KEM

ML-KEM（FIPS 203）は鍵カプセル化メカニズムであり、デフォルトで有効です（[`--enable-mlkem`](chapter02.md#--disable-mlkem)）。
ML-KEMは`wolfssl/wolfcrypt/wc_mlkem.h`で宣言されており、`MlKemKey`構造体を使用します。
パラメータセットは、[`wc_MlKemKey_Init()`](group__ML__KEM.md#function-wc_mlkemkey_init)で鍵を初期化する際に、`WC_ML_KEM_512`、`WC_ML_KEM_768`、`WC_ML_KEM_1024`のいずれかから選択します。

受信側は[`wc_MlKemKey_MakeKey()`](group__ML__KEM.md#function-wc_mlkemkey_makekey)で鍵ペアを生成し、公開鍵を相手側に送信します。
送信側はその公開鍵を使用して[`wc_MlKemKey_Encapsulate()`](group__ML__KEM.md#function-wc_mlkemkey_encapsulate)を呼び出し、暗号文と32バイトの共有秘密（`WC_ML_KEM_SS_SZ`）を生成して、暗号文を送り返します。
受信側は[`wc_MlKemKey_Decapsulate()`](group__ML__KEM.md#function-wc_mlkemkey_decapsulate)を使用して、暗号文から同じ共有秘密を復元します。
以下の例では、1つの鍵が両方の役割を担っています。

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

実際の鍵交換では、公開鍵を[`wc_MlKemKey_EncodePublicKey()`](group__ML__KEM.md#function-wc_mlkemkey_encodepublickey)でエンコードします（その長さは`wc_MlKemKey_PublicKeySize()`で取得できます）。
相手側は、同じパラメータセットで初期化した自身の`MlKemKey`に[`wc_MlKemKey_DecodePublicKey()`](group__ML__KEM.md#function-wc_mlkemkey_decodepublickey)でその公開鍵を読み込んでから、カプセル化を行います。
[`wc_MlKemKey_CipherTextSize()`](group__ML__KEM.md#function-wc_mlkemkey_ciphertextsize)と[`wc_MlKemKey_SharedSecretSize()`](group__ML__KEM.md#function-wc_mlkemkey_sharedsecretsize)は、鍵のパラメータセットに応じたサイズを返します。

### ML-DSA

ML-DSA（FIPS 204）はデジタル署名アルゴリズムです。
ML-DSAはデフォルトで無効です。
[`--enable-mldsa`](chapter02.md#--enable-mldsa)で有効にできます。
ML-DSAは`wolfssl/wolfcrypt/wc_mldsa.h`で宣言されており、`wc_MlDsaKey`構造体を使用します。
[`wc_MlDsaKey_Init()`](group__ML__DSA.md#function-wc_mldsakey_init)の後、[`wc_MlDsaKey_SetParams()`](group__ML__DSA.md#function-wc_mldsakey_setparams)でパラメータセットを`WC_ML_DSA_44`、`WC_ML_DSA_65`、`WC_ML_DSA_87`のいずれかから選択します。

[`wc_MlDsaKey_SignCtx()`](group__ML__DSA.md#function-wc_mldsakey_signctx)と[`wc_MlDsaKey_VerifyCtx()`](group__ML__DSA.md#function-wc_mldsakey_verifyctx)は、FIPS 204のコンテキスト文字列を使用してメッセージの署名と検証を行います。
コンテキスト文字列は空（`NULL`、0）でも構いません。
署名のサイズは大きく、`WC_MLDSA_44_SIG_SIZE`、`WC_MLDSA_65_SIG_SIZE`、`WC_MLDSA_87_SIG_SIZE`はそれぞれ2420、3309、4627バイトです。
[`wc_MlDsaKey_GetSigLen()`](group__ML__DSA.md#function-wc_mldsakey_getsiglen)は、鍵に応じた署名サイズを返します。
ECDSAと同様に、戻り値と`verified`の両方を確認してください。

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

公開鍵は、[`wc_MlDsaKey_ExportPubRaw()`](group__ML__DSA.md#function-wc_mldsakey_exportpubraw)で検証者向けにエクスポートし、同じパラメータセットを持つ鍵に[`wc_MlDsaKey_ImportPubRaw()`](group__ML__DSA.md#function-wc_mldsakey_importpubraw)で読み込むことができます。
`wolfssl/wolfcrypt/dilithium.h`の旧来の`wc_dilithium_*` APIは、`wc_MlDsaKey_*`関数をラップする互換レイヤーとして残されています。
新しいコードでは`wc_MlDsaKey_*`の名前を使用してください。
