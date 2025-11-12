# 鍵と証明書

X.509証明書の紹介、およびSSLとTLSでの使用方法については付録Aをご参照ください。

## サポートしているフォーマットとサイズ

wolfSSLは証明書と鍵において**PEM**および**DER**フォーマットをサポートしています。
また、PKCS#8秘密鍵（PKCS#5またはPKCS#12暗号化付き）もサポートしています。

**PEM**、つまり「Privacy Enhanced Mail」は、認証局によって証明書が発行される最も一般的なフォーマットです。
PEMファイルはBase64エンコードされたASCIIファイルで、複数のサーバー証明書、中間証明書、秘密鍵を含むことができ、通常は`.pem`、`.crt`、`.cer`、または`.key`のファイル拡張子を持ちます。
PEMファイル内の証明書は「`-----BEGIN CERTIFICATE-----`」と「`-----END CERTIFICATE-----`」のステートメントで囲まれています。

**DER**、つまり「Distinguished Encoding Rules」は、証明書のバイナリフォーマットです。
DERファイル拡張子には`.der`と`.cer`があり、テキストエディタでは表示できません。

X.509証明書はASN.1フォーマットを使用してエンコードされます。
DERフォーマットはASN.1エンコーディングです。
PEMフォーマットはBase64エンコードされ、人間が読めるヘッダーとフッターで囲まれています。
TLSは証明書をDERフォーマットで送信します。

## サポートしている証明書拡張

サポートしていない、または未知の拡張機能がクリティカルとしてマークされている場合、エラーメッセージを出力します。
それ以外の場合では、これらの拡張機能は無視されます。
証明書拡張機能の解析では、少なくとも`--enable-certext`（マクロ`WOLFSSL_CERT_EXT`）がwolfSSLライブラリのコンパイル時に使用されていることが期待されます。
以下は、一部またはすべての拡張機能が使用でき、解析に対応している証明書拡張機能の一覧です。

| [RFC 5280](https://tex2e.github.io/rfc-translater/html/rfc5280.html#4-2--Certificate-Extensions)からの拡張機能 | サポート |
| --- | --- |
| Authority Key Identifier | はい |
| Subject Key Identifier | はい |
| Key Usage | はい |
| Certificate Policies | はい |
| Policy Mappings | いいえ |
| Subject Alternative Name | はい |
| Issuer Alternative Name | いいえ |
| Subject Directory Attributes | いいえ |
| Basic Constraints | はい |
| Name Constraints | はい |
| Policy Constraints | はい |
| Extended Key Usage | はい |
| CRL Distribution Points | はい |
| Inihibit anyPolicy | はい |
| Freshest CRL | いいえ |

| 追加の拡張機能 | サポート |
| --- | --- |
| Netscape | はい |
| Custom OID | はい |

次のいくつかのセクションでは、個々の証明書拡張機能のサポート状況について詳しくご説明します。

#### Authority / Subject Key Identifier

デフォルトでは、鍵IDは鍵のSHA1ハッシュです。
鍵のSHA256ハッシュもサポートしています。

#### Subject Alternative Names

| Alternative Name Types | サポート |
| ---------------------- | --- |
| メール | はい |
| DNS名 | はい |
| IPアドレス | はい |
| URI | はい |

#### Key Usage

Key Usageは、証明書の解析完了後に取得・解析できます。

| Key Usage | サポート |
| --------- | --- |
| digitalSignature | はい |
| nonRepudiation | はい |
| keyEncipherment | はい |
| dataEncipherment | はい |
| keyAgreement | はい |
| keyCertSign | はい |
| cRLSign | はい |
| encipherOnly | はい |
| decipherOnly | はい |

#### Extended Key Usage

wolfSSLバージョン3.15.5以降では、不明/サポートしていないExtended Key Usageは無視されます。
3.15.5より前のバージョンでは、不明なExtended Key Usage OIDは解析エラーを出力します。

| Extended Key Usage | サポート |
| ------------------ | --- |
| anyExtendedKeyUsage | はい |
| id-kp-serverAuth | はい |
| id-kp-clientAuth | はい |
| id-kp-codeSigning | はい |
| id-kp-emailProtection | はい |
| id-kp-timeStamping | はい |
| id-kp-OCSPSigning | はい |

#### カスタムOID拡張

カスタムOID X.509拡張機能の挿入と解析はwolfSSLバージョン5.3.0で導入されました。
有効化オプション`--enable-certgen`は、マクロ`WOLFSSL_ASN_TEMPLATE`、`WOLFSSL_CUSTOM_OID`、および`HAVE_OID_ENCODING`と一緒に使用する必要があります。
`WOLFSSL_ASN_TEMPLATE`は`./configure`を使用する場合はデフォルトで定義されますが、`WOLFSSL_USER_SETTINGS`でビルドする場合は手動で定義する必要があります。

これらの設定でwolfSSLをビルドした後、`wc_SetCustomExtension()`関数を使用して`Cert`構造体にカスタム拡張機能を設定し、`wc_SetUnknownExtCallback()`を使用して`DecodedCert`構造体内の未知の拡張機能OIDを処理するためのコールバックを登録できます。

## 証明書の読み込み

証明書は通常ファイルシステムを使用して読み込まれますが、メモリバッファからの読み込みもサポートしています。
詳しくは、本章下部の「ファイルシステムなしでの証明書の使用」をご参照ください。

### CA証明書の読み込み

CA証明書ファイルは[`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)関数を使用して読み込むことができます。

```c
int wolfSSL_CTX_load_verify_locations(WOLFSSL_CTX *ctx,
                                      const char *CAfile,
                                      const char *CApath);
```


複数のCA証明書情報を`CAfile`(PEMフォーマット)にまとめて記載しておくことで、それらを一括して解析することもできます。
これは特に、クライアントが起動時に複数のルートCAを読み込む必要がある場合に便利です。
このように処理することで、CAとして単一のファイルを使用することを想定しているツールに移植しやすくしています。

**注意**：ルート証明書と中間証明書のチェーンを読み込む必要がある場合、信頼の順にそれらを読み込む必要があります。
まずルートCAを読み込み、次に中間1、次に中間2などを読み込みます。
読み込む各証明書に対して[`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)を呼び出すか、順序付けられた証明書（ファイルの先頭にルートがあり、信頼のチェーンによって順序付けられた証明書）を含むファイルで一度だけこの関数を実行します。

### クライアントまたはサーバー証明書の読み込み

単一のクライアントまたはサーバー証明書の読み込みは[`wolfSSL_CTX_use_certificate_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_file)関数で行うことができます。
この関数を証明書チェーンで使用する場合、実際の「最下位」の証明書のみが送信されます。

```c
int wolfSSL_CTX_use_certificate_file(WOLFSSL_CTX *ctx,
                                     const char *CAfile,
                                     int type);
```

`CAfile`はCA証明書ファイルであり、`type`は証明書のフォーマット（`SSL_FILETYPE_PEM`など）です。

サーバーとクライアントは[`wolfSSL_CTX_use_certificate_chain_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_chain_file)関数を使用して証明書チェーンを送信できます。
証明書チェーンファイルはPEMフォーマットである必要があり、サブジェクトの証明書（実際のクライアントまたはサーバー証明書）から始まり、中間証明書が続き、オプションで最上位のルートCA証明書で終わるように並べる必要があります。
サーバーのサンプルプログラム（`/examples/server/server.c`）では、この機能を使用しています。

**注意**：これは、検証のために証明書チェーンを読み込む場合とは正反対です。このシナリオでのファイル内容は、ファイルの先頭にエンティティ証明書があり、その次にチェーンの次の証明書が続き、ファイルの最後にルートCAがある形になります。

```c
int wolfSSL_CTX_use_certificate_chain_file(WOLFSSL_CTX *ctx,
                                 const char *file);
```

### 秘密鍵の読み込み

サーバー秘密鍵は[`wolfSSL_CTX_use_PrivateKey_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_PrivateKey_file)関数を使用して読み込むことができます。

```c
int wolfSSL_CTX_use_PrivateKey_file(WOLFSSL_CTX *ctx,
                      const char *keyFile, int type);
```

`keyFile`は秘密鍵ファイルであり、`type`は秘密鍵のフォーマット（例：`SSL_FILETYPE_PEM`）です。

### 信頼されるピア証明書の読み込み

信頼されるピア証明書の読み込みは[`wolfSSL_CTX_trust_peer_cert()`](group__Setup.md#function-wolfssl_ctx_trust_peer_cert)で行うことができます。

```c
int wolfSSL_CTX_trust_peer_cert(WOLFSSL_CTX *ctx,
                 const char *trustCert, int type);
```

`trustCert`は読み込む証明書ファイルであり、`type`は秘密鍵のフォーマット（つまり`SSL_FILETYPE_PEM`）です。

## 証明書チェーンの検証

wolfSSLでは、証明書チェーン全体を検証するために、チェーン内のトップまたは「ルート」証明書のみを信頼された証明書として読み込む必要があります。
つまり、証明書チェーン（A -> B -> C）があり、CがBによって署名され、BがAによって署名されている場合、wolfSSLはチェーン全体（A->B->C）を検証するために証明書Aのみを信頼された証明書として読み込む必要があります。

例えば、サーバー証明書チェーンが次のようになっているとき、

![証明書チェーン](certchain.png)

wolfSSLクライアントは、少なくともルート証明書（A）を信頼されたルートとして（[`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)で）あらかじめ読み込んでおく必要があります。
クライアントがサーバー証明書チェーンを受信すると、Aの署名を使用してBを検証し、Bが以前にwolfSSLに信頼されたルートとして読み込まれていない場合、BはwolfSSLの内部証明書チェーンに保存されます（wolfSSLは証明書を検証するために必要なもの、つまり共通名ハッシュ、公開鍵、鍵タイプなどのみを保存します）。
Bが有効であれば、それを使用してCを検証します。

このモデルに従えば、ルート証明書「A」がwolfSSLサーバーに信頼されたルートとして読み込まれている限り、サーバーが（A->B->C）または（B->C）を送信した場合でも、サーバー証明書チェーンは検証できます。
サーバーが中間証明書ではなく（C）のみを送信する場合、wolfSSLクライアントがすでにBを信頼されたルートとして読み込んでいない限り、チェーンは検証できません。

## サーバー証明書のドメイン名チェック

wolfSSLには、サーバー証明書のドメインを自動的にチェックするクライアント拡張機能があります。
OpenSSLモードでは、これを実行するために約十個の関数呼び出しが必要です。
wolfSSLは証明書の日付が範囲内であることをチェックし、署名を検証し、さらに[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)を呼び出す前に[`wolfSSL_check_domain_name(WOLFSSL* ssl, const char* dn)`](group__Setup.md#function-wolfssl_check_domain_name)を呼び出した場合にドメインを検証します。
wolfSSLはピアのサーバー証明書のX.509発行者名を`dn`（期待されるドメイン名）と照合します。
名前が一致すれば[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)は正常に進行しますが、名前が一致しない場合、[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)は致命的なエラーを返し、[`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error)は`DOMAIN_NAME_MISMATCH`を返します。

証明書のドメイン名をチェックすることは、サーバーが実際に名乗っているものと一致していることを検証する重要なステップです。
この拡張機能は、チェックを実行する負担を軽減するためのものです。

## ファイルシステムなしでの証明書の使用

通常、秘密鍵、証明書、CAを読み込むためにファイルシステムを使用します。
wolfSSLは完全なファイルシステムのない環境で使用されることがあるため、代わりにメモリバッファを使用するため拡張機能も提供しています。
マクロ`NO_FILESYSTEM`を定義することで、以下の関数を使用できるようになります。

* [`int wolfSSL_CTX_load_verify_buffer(WOLFSSL_CTX* ctx, const unsigned char* in,long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_buffer)
* [`int wolfSSL_CTX_use_certificate_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_buffer)
* [`int wolfSSL_CTX_use_PrivateKey_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, long sz, int format);`](group__CertsKeys.md#function-wolfssl_ctx_use_PrivateKey_buffer)
* [`int wolfSSL_CTX_use_certificate_chain_buffer(WOLFSSL_CTX* ctx, const unsigned char* in,long sz);`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_chain_buffer)
* [`int wolfSSL_CTX_trust_peer_buffer(WOLFSSL_CTX* ctx, const unsigned char* in, Long sz, int format);`](group__Setup.md#function-wolfssl_ctx_trust_peer_buffer)

これらの関数は、`*_file` の代わりに `*_buffer`という名前の対応する関数と全く同じように使用します。
そしてファイル名を提供する代わりにメモリバッファを提供します。
使用法の詳細についてはAPIドキュメントをご参照ください。

### テスト証明書と鍵バッファ

wolfSSLは過去にテスト証明書と鍵をファイル形式でのみ同梱してきました。
現在は、ファイルシステムが利用できない環境で使用するためのテスト証明書と鍵バッファも同梱しています。
これらのバッファは`USE_CERT_BUFFERS_1024`、`USE_CERT_BUFFERS_2048`、または`USE_CERT_BUFFERS_256`のいずれかを定義すると`certs_test.h`で利用できます。

## シリアル番号の取得

X.509証明書のシリアル番号は[`wolfSSL_X509_get_serial_number()`](group__openSSL.md#function-wolfssl_x509_get_serial_number)を使用してwolfSSLから抽出できます。
シリアル番号は任意の長さになる可能性があります。

```c
int wolfSSL_X509_get_serial_number(WOLFSSL_X509* x509,
            unsigned char* buffer, int* inOutSz)
```

`buffer`には入力時に最大`*inOutSz`バイトが書き込まれます。
成功した場合、0が返され、呼び出し後に`*inOutSz`には`buffer`に実際に書き込まれたバイト数が保持されます。
完全なサンプルプログラムは`wolfssl/test.h`で提供しています。

## RSA鍵生成

wolfSSLは、最大4096ビットのさまざまな長さのRSA鍵生成をサポートしています。
鍵生成はデフォルトではオフですが、`./configure`プロセスに`--enable-keygen`引数を加えることで(Windowsや非標準環境では、`WOLFSSL_KEY_GEN`を定義することで)有効化できます。
鍵の作成は簡単で、`rsa.h`から1つの関数のみを使用します。

```c
int MakeRsaKey(RsaKey* key, int size, long e, RNG* rng);
```

ここで`size`はビット単位の長さ、`e`は公開指数で、通常`e`には65537を使用するのが良いでしょう。
`wolfcrypt/test/test.c`にて、1024ビットのRSA鍵を作成する実装例を提供しています。

```c
RsaKey genKey;
RNG    rng;
int    ret;

InitRng(&rng);
InitRsaKey(&genKey, 0);

ret = MakeRsaKey(&genKey, 1024, 65537, &rng);
if (ret != 0)
    /* ret contains error */;
```

RsaKey `genKey`は、他のRsaKeyと同じように使用できます。
鍵をエクスポートする必要がある場合、wolfSSLは`asn.h`でDERとPEMの両方のフォーマットを提供しています。
いずれの場合も、まずは鍵をDERフォーマットに変換し、PEMが必要であれば汎用の`DerToPem()`関数を次のように使用します。

```c
byte der[4096];
int  derSz = RsaKeyToDer(&genKey, der, sizeof(der));
if (derSz < 0)
    /* derSz contains error */;
```

バッファ`der`には現在、鍵のDERフォーマットが含まれています。
DERバッファをPEMに変換するには、変換関数を使用します。

```c
byte pem[4096];
int  pemSz = DerToPem(der, derSz, pem, sizeof(pem),
                      PRIVATEKEY_TYPE);
if (pemSz < 0)
    /* pemSz contains error */;
```

`DerToPem()`の最後の引数はタイプパラメータを取り、通常は`PRIVATEKEY_TYPE`または`CERT_TYPE`のいずれかです。
現在バッファ`pem`には鍵のPEMフォーマットが含まれています。
サポートしているタイプは、次の通りです。

* `CA_TYPE`
* `TRUSTED_PEER_TYPE`
* `CERT_TYPE`
* `CRL_TYPE`
* `DH_PARAM_TYPE`
* `DSA_PARAM_TYPE`
* `CERTREQ_TYPE`
* `DSA_TYPE`
* `DSA_PRIVATEKEY_TYPE`
* `ECC_TYPE`
* `ECC_PRIVATEKEY_TYPE`
* `RSA_TYPE`
* `PRIVATEKEY_TYPE`
* `ED25519_TYPE`
* `EDDSA_PRIVATEKEY_TYPE`
* `PUBLICKEY_TYPE`
* `ECC_PUBLICKEY_TYPE`
* `PKCS8_PRIVATEKEY_TYPE`
* `PKCS8_ENC_PRIVATEKEY_TYPE`

### RSA鍵生成に関する注意

RSA秘密鍵には公開鍵も含まれています。
`test.c`で使用されているように、秘密鍵はwolfSSLによって秘密鍵と公開鍵の両方として使用できます。
通常、SSL/TLSに必要なのは秘密鍵と（証明書の形式の）公開鍵のみです。

必要に応じて、`RsaPublicKeyDecode()`関数を使用して別の公開鍵をwolfSSLに手動で読み込むこともできます。
そして、[`wc_RsaKeyToPublicDer()`](group__RSA.md#function-wc_rsakeytopublicder)関数を使用してRSA公開鍵をエクスポートすることもできます。

## 証明書生成

wolfSSLはX.509 v3証明書生成をサポートしています。
証明書生成はデフォルトではオフですが、`./configure`プロセスに`--enable-certgen`引数を加えることで(Windowsや非標準環境では、`WOLFSSL_CERT_GEN`を定義することで)有効化できます。

証明書を生成する前に、ユーザーは証明書のサブジェクト情報を入力する必要があります。
この情報は`wolfssl/wolfcrypt/asn_public.h`にある`Cert`という構造体に含まれています。

```c
/* for user to fill for certificate generation */
typedef struct Cert {
    int      version;                   /* x509 version  */
    byte     serial[CTC_SERIAL_SIZE];   /* serial number */
    int      sigType;                   /*signature algo type */
    CertName issuer;                    /* issuer info */
    int      daysValid;                 /* validity days */
    int      selfSigned;                /* self signed flag */
    CertName subject;                   /* subject info */
    int      isCA;                      /*is this going to be a CA*/
    ...
} Cert;
```

CertNameは次のようになります。

```c
typedef struct CertName {
char country[CTC_NAME_SIZE];
    char countryEnc;
    char state[CTC_NAME_SIZE];
    char stateEnc;
    char locality[CTC_NAME_SIZE];
    char localityEnc;
    char sur[CTC_NAME_SIZE];
    char surEnc;
    char org[CTC_NAME_SIZE];
    char orgEnc;
    char unit[CTC_NAME_SIZE];
    char unitEnc;
    char commonName[CTC_NAME_SIZE];
    char commonNameEnc;
    char email[CTC_NAME_SIZE];  /* !!!! email has to be last!!!! */
} CertName;
```

サブジェクト情報を入力する前に、次のように初期化関数を呼び出す必要があります。

```c
Cert myCert;
InitCert(&myCert);
```

`InitCert()`は、いくつかの変数にデフォルト値を設定します。
バージョンを**3** (0x02)、シリアル番号を**0**（ランダム生成）、sigTypeを`CTC_SHAwRSA`、daysValidを**500**、selfSignedを**1**（TRUE）に設定します。

サポートしている署名タイプは次の通りです。

* `CTC_SHAwDSA`
* `CTC_MD2wRSA`
* `CTC_MD5wRSA`
* `CTC_SHAwRSA`
* `CTC_SHAwECDSA`
* `CTC_SHA256wRSA`
* `CTC_SHA256wECDSA`
* `CTC_SHA384wRSA`
* `CTC_SHA384wECDSA`
* `CTC_SHA512wRSA`
* `CTC_SHA512wECDSA`

次に、以下のようにしてサブジェクト情報を初期化します。
ただし実際には、ユーザの環境に応じた値を入力します。
詳細は`wolfcrypt/test/test.c`にも掲載しています。

```c
strncpy(myCert.subject.country, "US", CTC_NAME_SIZE);
strncpy(myCert.subject.state, "OR", CTC_NAME_SIZE);
strncpy(myCert.subject.locality, "Portland", CTC_NAME_SIZE);
strncpy(myCert.subject.org, "yaSSL", CTC_NAME_SIZE);
strncpy(myCert.subject.unit, "Development", CTC_NAME_SIZE);
strncpy(myCert.subject.commonName, "www.wolfssl.com", CTC_NAME_SIZE);
strncpy(myCert.subject.email, "info@wolfssl.com", CTC_NAME_SIZE);
```

そして、上記の鍵生成例からの変数`genKey`と`rng`を使用して、自己署名証明書を生成できます。
もちろん、有効なものであればwolfSSLによって生成したものでなくとも構いません。

```c
byte derCert[4096];

int certSz = MakeSelfCert(&myCert, derCert, sizeof(derCert), &key, &rng);
if (certSz < 0)
  /* certSz contains the error */;
```

バッファ`derCert`にはDERフォーマットの証明書が含まれています。
証明書のPEMフォーマットが必要な場合は、汎用の`DerToPem()`関数を使用して、タイプを`CERT_TYPE`として指定します。

```c
byte* pem;

int pemSz = DerToPem(derCert, certSz, pem, sizeof(pemCert), CERT_TYPE);
if (pemCertSz < 0)
  /* pemCertSz contains error */;
```

サポートしているタイプは以下の通りです。

* `CA_TYPE`
* `TRUSTED_PEER_TYPE`
* `CERT_TYPE`
* `CRL_TYPE`
* `DH_PARAM_TYPE`
* `DSA_PARAM_TYPE`
* `CERTREQ_TYPE`
* `DSA_TYPE`
* `DSA_PRIVATEKEY_TYPE`
* `ECC_TYPE`
* `ECC_PRIVATEKEY_TYPE`
* `RSA_TYPE`
* `PRIVATEKEY_TYPE`
* `ED25519_TYPE`
* `EDDSA_PRIVATEKEY_TYPE`
* `PUBLICKEY_TYPE`
* `ECC_PUBLICKEY_TYPE`
* `PKCS8_PRIVATEKEY_TYPE`
* `PKCS8_ENC_PRIVATEKEY_TYPE`

これで、バッファ`pemCert`には証明書のPEMフォーマットが含まれています。

CA署名付き証明書を作成したい場合は、いくつかの手順が必要です。
前述のようにサブジェクト情報を入力した後、CA証明書から発行者情報を設定する必要があります。
これは`SetIssuer()`を使用して次のように実行できます。

```c
ret = SetIssuer(&myCert, "ca-cert.pem");
if (ret < 0)
    /* ret contains error */;
```

その後、証明書を作成し、それに署名する2段階のプロセスを実行する必要があります。
（`MakeSelfCert()`は一度にこれら両方を実行します）
発行者（`caKey`）と対象（`key`）の両方の秘密鍵が必要です。
完全な使用方法については、`test.c`の実装例をご参照ください。

```c
byte derCert[4096];

int certSz = MakeCert(&myCert, derCert, sizeof(derCert), &key, NULL, &rng);
if (certSz < 0);
   /*certSz contains the error*/;

certSz = SignCert(myCert.bodySz, myCert.sigType, derCert,
            sizeof(derCert), &caKey, NULL, &rng);
if (certSz < 0);
   /*certSz contains the error*/;
```

これで、バッファ`derCert`にはCA署名付き証明書のDERフォーマットが含まれています。
証明書のPEMフォーマットが必要な場合は、上記の自己署名の実装例をご参照ください。
`MakeCert()`と`SignCert()`は、RSA鍵またはECC鍵のいずれかを使用するための関数パラメータを提供していることに注意してください。
上記の実装例ではRSA鍵を使用し、ECC鍵パラメータにはNULLを渡しています。

## 証明書署名要求（CSR）の生成

wolfSSLはX.509 v3証明書署名要求（CSR）生成をサポートしています。
CSR生成はデフォルトではオフですが、`./configure`プロセスに`--enable-certreq --enable-certgen`引数を加えることで(Windowsや非標準環境では、`WOLFSSL_CERT_GEN`**および**`WOLFSSL_CERT_REQ`を定義することで)有効化できます。

CSRを生成する前に、ユーザーは証明書のサブジェクトに関する情報を提供する必要があります。
この情報は`wolfssl/wolfcrypt/asn_public.h`にある`Cert`という構造体に含まれています。

CertとCertName構造体の詳細については本章の「証明書生成」節をご参照ください。

サブジェクトの情報を入力する前に、次のように初期化関数を呼び出す必要があります。

```c
Cert request;
InitCert(&request);
```

`InitCert()`はいくつかの変数にデフォルト値を設定します。
バージョンを**3** (0x02)、シリアル番号を**0**（ランダム生成）、sigTypeを`CTC_SHAwRSA`、daysValidを**500**、selfSignedを**1**（TRUE）に設定します。

サポートしている署名タイプは次のとおりです。

* `CTC_SHAwDSA`
* `CTC_MD2wRSA`
* `CTC_MD5wRSA`
* `CTC_SHAwRSA`
* `CTC_SHAwECDSA`
* `CTC_SHA256wRSA`
* `CTC_SHA256wECDSA`
* `CTC_SHA384wRSA`
* `CTC_SHA384wECDSA`
* `CTC_SHA512wRSA`
* `CTC_SHA512wECDSA`

次に、以下のようにしてサブジェクト情報を初期化します。
ただし実際には、ユーザの環境に応じた値を入力します。
詳細は<https://github.com/wolfSSL/wolfssl-examples/blob/master/certgen/csr_example.c>にも掲載しています。

```c
strncpy(req.subject.country, "US", CTC_NAME_SIZE);
strncpy(req.subject.state, "OR", CTC_NAME_SIZE);
strncpy(req.subject.locality, "Portland", CTC_NAME_SIZE);
strncpy(req.subject.org, "wolfSSL", CTC_NAME_SIZE);
strncpy(req.subject.unit, "Development", CTC_NAME_SIZE);
strncpy(req.subject.commonName, "www.wolfssl.com", CTC_NAME_SIZE);
strncpy(req.subject.email, "info@wolfssl.com", CTC_NAME_SIZE);
```

そして、上記の鍵生成例からの変数`key`と`rng`を使用して、署名付きCSRを生成できます。
もちろん、有効なものであればwolfSSLによって生成したものでなくとも構いません。

```c
byte der[4096]; /* Store request in der format once made */

ret = wc_MakeCertReq(&request, der, sizeof(der), NULL, &key);
/* check ret value for error handling, <= 0 indicates a failure */
```

次に、リクエストに署名して有効にします。
上記の鍵生成例から`rng`変数を使用します。
こちらも同様に、wolfSSLによって生成したものである必要はありません。

```c
derSz = ret;

req.sigType = CTC_SHA256wECDSA;
ret = wc_SignCert(request.bodySz, request.sigType, der, sizeof(der), NULL, &key, &rng);
/* check ret value for error handling, <= 0 indicates a failure */
```

最後に、CSRをPEMフォーマットに変換して、CA機関に送信して証明書の発行に使用します。

```c
ret = wc_DerToPem(der, derSz, pem, sizeof(pem), CERTREQ_TYPE);
/* check ret value for error handling, <= 0 indicates a failure */
printf("%s", pem); /* or write to a file */
```

### 制限事項

証明書には必須のフィールドがあり、CSRでは除外されます。
CSRには「オプション」とみなされる他のフィールドもあり、証明書では必須です。
このため、すべての証明書フィールドを厳密にチェックし、すべてのフィールドを必須と見なすwolfSSL証明書解析エンジンは、現時点ではCSRの使用をサポートしていません。
したがって、CSR生成と最初からの証明書生成はサポートしていますが、wolfSSLはCSRからの証明書生成をサポートしていません。
CSRをwolfSSL解析エンジンに渡すと、現時点ではエラーが返されます。
アップデートをお待ちいただくか、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお問い合わせください。

## 生のECC鍵に変換

生のECC鍵インポートを用いて、ECC鍵をPEMからDERに変換する機能を提供しています。
これを実行するには、指定された引数で次の関数を実行します。

```c
EccKeyToDer(ecc_key*, byte* output, word32 inLen);
```

### 実装例

```c
#define FOURK_BUF 4096
byte  der[FOURK_BUF];
ecc_key userB;

EccKeyToDer(&userB, der, FOURK_BUF);
```