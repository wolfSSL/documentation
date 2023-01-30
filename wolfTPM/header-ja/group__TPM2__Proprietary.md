---



---

## TPM2 固有

このモジュールでは、wolfTPM のみに固有の TPM2 コマンドについて説明します。通常、これらのコマンドには、TPM 2.0 データ構造を処理するためのヘルパーが含まれています。開発時のデバッグやテストに役立つ機能もあります。

### 関数

|  戻り値        | 関数および機能概要           |
| -------------- | -------------- |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) | [TPM2_Init](#function-tpm2-init)(TPM2_CTX\* ctx, TPM2HalIoCb ioCb, void\* userCtx)<br>    HAL IO コールバックとユーザー指定のコンテキストで TPM を初期化します。 --enable-devtpm または --enable-swtpm 構成で wolfTPM を使用する場合、ioCb と userCtx は使用されません。  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) | [TPM2_Init_ex](#function-tpm2-init-ex)(TPM2_CTX\* ctx, TPM2HalIoCb ioCb, void\* userCtx,int timeoutTries)<br>         timeoutTries、HAL IO コールバック、およびユーザー指定のコンテキストで TPM を初期化します。  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc)      | [TPM2_Init_minimal](#function-tpm2-init-minimal)(TPM2_CTX\* ctx)<br>     TPM を初期化し、使用される wolfTPM2 コンテキストを設定します。 この関数は通常、Windows などのリッチ オペレーティング システムで使用されます。  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc)      | [TPM2_Cleanup](#function-tpm2-cleanup)(TPM2_CTX\* ctx)<br>               TPM と wolfcrypt を初期化解除します (初期化されている場合) |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc)      | [TPM2_ChipStartup](#function-tpm2-chipstartup)(TPM2_CTX\* ctx, int timeoutTries)<br>   TPM2 の起動が完了したことを確認し、TPM デバイス情報を抽出します。  |
| WOLFTPM_API [TPM_RC](#typedef-tpm2haliocb) | [TPM2_SetHalIoCb](#function-tpm2-sethaliocb)(TPM2_CTX\* ctx, TPM2HalIoCb ioCb, void\* userCtx)<br>    TPM 通信に必要なユーザーのコンテキストと IO コールバックを設定します。  |
| WOLFTPM_API [TPM_RC](#typedef-tpm-rc) 　　　| [TPM2_SetSessionAuth](#function-tpm2-setsessionauth)(TPM2_AUTH_SESSION\* session)<br>  TPM 承認を保持する構造体を設定します。  |
| WOLFTPM_API int 　　　　　　　　　　　　　　　| [TPM2_GetSessionAuthCount](#function-tpm2-getsessionauthcount)(TPM2_CTX\* ctx)<br>     現在設定されている TPM 承認の数を特定します。 |
| WOLFTPM_API void                           | [TPM2_SetActiveCtx](#function-tpm2-setacrivectx)(TPM2_CTX\* ctx)<br>            使用する新しい TPM2 コンテキストを設定します。  |
| WOLFTPM_API [TPM2_CTX\*](#function-tpm2-getactivectx)|[TPM2_GetActiveCtx](#function-tpm2-getactivectx)(void)<br>             使用中の TPM2 コンテキストへのポインターを提供します。  |
| WOLFTPM_API int                            | [TPM2_GetHashDigestSize](#function-tpm2-gethashdigestsize)(TPMI_ALG_HASH hashAlg)<br>      TPM 2.0 ハッシュ ダイジェストのサイズをバイト単位で決定します。  |
| WOLFTPM_API int                            | [TPM2_GetHashType](#function-tpm2-gethashtype)(TPMI_ALG_HASH hashAlg)<br>            TPM2 ハッシュ タイプを対応する wolfcrypt ハッシュ タイプに変換します。  |
| WOLFTPM_API int                            | [TPM2_GetNonce](#function-tpm2-getnonce)(byte\* nonceBuf, int nonceSz)<br>       乱数の新しいナンスを生成します。  |
| WOLFTPM_API void                           | [TPM2_SetupPCRSel](#function-tpm2-setuppcrsel)(TPML_PCR_SELECTION\* pcr, TPM_ALG_ID alg,int pcrIndex)<br>            TPM2_Quote を作成する準備をする場合などに、正しい PCR 選択を準備するためのヘルパー関数   |
| const WOLFTPM_API char *                   | [TPM2_GetRCString](#function-tpm2-getrcstring)(int rc)<br>      TPM 2.0 リターン コードの人間が判読できる文字列を取得します。  |
| const WOLFTPM_API char *                   | [TPM2_GetAlgName](#function-tpm2-getalgname) alg)(TPM_ALG_ID alg)<br>                    任意の TPM 2.0 アルゴリズムについて、人間が判読できる文字列を取得します。  |
| WOLFTPM_API int                            | [TPM2_GetCurveSize](#function-tpm2-getcurvesize)(TPM_ECC_CURVE curveID)<br>          TPM ECC 曲線のサイズをバイト単位で決定します。  |
| WOLFTPM_API int                            | [TPM2_GetTpmCurve](#function-tpm2-gettomcurve)(int curveID)<br>                wolfcrypt 曲線タイプを対応する TPM 曲線タイプに変換します。  |
| WOLFTPM_API int                            | [TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)(int curve_id)<br>              TPM 曲線タイプを対応する wolfcrypt 曲線タイプに変換します。  |
| WOLFTPM_API int                            | [TPM2_ParseAttest](#function-tpm2-parseattest)(const TPM2B_ATTEST* in, TPMS_ATTEST* out)<br>              TPM2B_ATTEST を解析し、TPMS_ATTEST 構造にデータを入力します。  |
| WOLFTPM_API int                            | [TPM2_HashNvPublic](#function-tpm2-hashnvpublic)(TPMS_NV_PUBLIC* nvPublic, byte* buffer, UINT16* size)<br>  nvPublic 構造に基づいて新しい NV インデックス名を計算します。  |
| WOLFTPM_API int                            | [TPM2_AppendPublic](#function-tpm2-appendpublic)(byte\* buf, word32 size, int\* sizeUsed, TPM2B_PUBLIC\* pub)<br>  ユーザー提供のバッファーに基づいて TPM2B_PUBLIC 構造体を設定します。  |
| WOLFTPM_API int                            | [TPM2_ParsePublic](#function-tpm2-parsepublic)(TPM2B_PUBLIC\* pub, byte\* buf, word32 size, int\* sizeUsed)<br>   TPM2B_PUBLIC 構造を解析し、ユーザー提供のバッファーに格納します。  |
| WOLFTPM_LOCAL int                          | [TPM2_GetName](#function-tpm2-getname)(TPM2_CTX\* ctx, UINT32 handleValue, int handleCnt, int idx, TPM2B_NAME\* name)<br>    TPM オブジェクトの名前を提供します  |
| WOLFTPM_API UINT16                         | [TPM2_GetVendorID](#function-tpm2-getvendorid)(void )<br>                        アクティブな TPM2 コンテキストの vendorID を提供します  |
| WOLFTPM_API void                           | [TPM2_PrintBin](#function-tpm2-printbin)(const byte\* buffer, word32 length)<br>  フォーマットされた方法でバイナリ バッファを出力するヘルパー関数  |
| WOLFTPM_API void                           | [TPM2_PrintAuth](#function-tpm2-printauth)(const TPMS_AUTH_COMMAND\* authCmd)<br>                       人間が読める方法で TPMS_AUTH_COMMAND 型の構造を出力するヘルパー関数  |
| WOLFTPM_API void                           | [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)(const TPM2B_PUBLIC\* pub)<br>                         人間が読める方法で TPM2B_PUBLIC 型の構造を出力するヘルパー関数  |

### 詳細な説明


このモジュールでは、wolfTPM のみに固有の TPM2 コマンドについて説明します。<br>

通常、これらのコマンドには、TPM 2.0 データ構造を処理するためのヘルパーが含まれています。<br>

開発時のデバッグやテストに役立つ機能もあります。<br>

### 関数のドキュメント

<a id="function-tpm2-init"></a>
#### TPM2_Init

```
WOLFTPM_API TPM_RC TPM2_Init(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

HAL IO コールバックとユーザー指定のコンテキストで TPM を初期化します。 &ndash;enable-devtpm または &ndash;enable-swtpm 構成で wolfTPM を使用する場合、ioCb と userCtx は使用されません。<br>

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 
  * **ioCb** TPM2HalIoCb (HAL IO) コールバック関数ポインタ 
  * **userCtx** ユーザーコンテキストへのポインター


**参考**: 

  * [TPM2_Startup](#function-tpm2-startup)
  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init_ex](#function-tpm2-init-ex)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー（IO関係のエラー） 
  * BAD_FUNC_ARG： 不正な引数


**ノート**: 

[TPM2_Init_minimal()](#function-tpm2-init-ex) ioCb と userCtx の両方をNULLにセットします。 その他のモードでは、TIS を使用するために ioCb を設定する必要があります。 ベアメタルおよび RTOS アプリケーションのサンプル ioCB は、examples/tpm_io.c で提供されています。

_使用例_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Init(&tpm2Ctx, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Init failed
}
```

<a id="function-tpm2-init-ex"></a>
#### TPM2_Init_ex

```
WOLFTPM_API TPM_RC TPM2_Init_ex(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx,
    int timeoutTries
)
```
timeoutTries、HAL IO コールバック、およびユーザー指定のコンテキストで TPM を初期化します。

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター  
  * **ioCb** TPM2HalIoCb (HAL IO) コールバック関数ポインター 
  * **userCtx** ユーザーコンテキストへのポインター 
  * **timeoutTries** TPM2 の起動が完了したことを確認するための試行回数を指定します


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init_minimal](#function-tpm2-init-minimal)
  * [TPM2_Init](#function-tpm2-init)
  * wolfTPM2_Init_ex 


**戻り値**:  

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM2_Init_minimal を直接使用する代わりに、TPM2_Init を使用することをお勧めします。

<a id="function-tpm2-init-minimal"></a>
#### TPM2_Init_minimal

```
WOLFTPM_API TPM_RC TPM2_Init_minimal(
    TPM2_CTX * ctx
)
```

TPM を初期化し、使用される wolfTPM2 コンテキストを設定します。 この関数は通常、Windows などのリッチ オペレーティング システムで使用されます。

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: general error (possibly IO) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM2_Init_minimal を直接使用する代わりに、TPM2_Init を使用することをお勧めします。

<a id="function-tpm2-cleanup"></a>
#### TPM2_Cleanup

```
WOLFTPM_API TPM_RC TPM2_Cleanup(
    TPM2_CTX * ctx
)
```

TPM と wolfcrypt を初期化解除します (初期化されている場合) 

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: could not acquire the lock on the wolfTPM2 context 
  * BAD_FUNC_ARG: 不正な引数（NULLを渡した）


_使用例_

```cpp
int rc;
TPM2_CTX tpm2Ctx;

rc = TPM2_Cleanup(&tpm2Ctx->dev);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_Cleanup failed
}
```

<a id="function-tpm2-chipstartup"></a>
#### TPM2_ChipStartup

```
WOLFTPM_API TPM_RC TPM2_ChipStartup(
    TPM2_CTX * ctx,
    int timeoutTries
)
```

TPM2 の起動が完了していることを確認し、TPM デバイス情報を抽出します。

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 
  * **timeoutTries** TPM2のスタートアップが完了したかをチェックする回数


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * TPM2_TIS_StartupWait 
  * TPM2_TIS_RequestLocality 
  * TPM2_TIS_GetInfo 
  * [TPM2_Init_ex](#function-tpm2-init-ex)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (IO関係のエラー？) 
  * BAD_FUNC_ARG: 不正な引数 
  * TPM_RC_TIMEOUT: タイムアウト


**ノート**: 

この関数は TPM2_Init_ex で使用されます。

<a id="function-tpm2-sethaliocb"></a>
#### TPM2_SetHalIoCb

```
WOLFTPM_API TPM_RC TPM2_SetHalIoCb(
    TPM2_CTX * ctx,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

TPM 通信に必要なユーザーのコンテキストと IO コールバックを設定します。

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター  
  * **ioCb** TPM2HalIoCb (HAL IO) コールバック関数 
  * **userCtx** ユーザーコンテキストへのポインター


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: TPM2_CTX構造体の排他ロックを取得できなかった 
  * BAD_FUNC_ARG: 不正な引数（ctxにNULLポインターを渡した）


**ノート**: 

コールバックが TPM に使用されないため、devtpm または swtpm でビルドされた場合、SetHalIoCb は失敗します。 他の構成ビルドでは、ioCb を NULL 以外の関数ポインターに設定する必要があり、userCtx はオプションです。

通常、TPM2_Init または wolfTPM2_Init を使用して HAL IO を設定します。

<a id="function-tpm2-setsessionauth"></a>
#### TPM2_SetSessionAuth

```
WOLFTPM_API TPM_RC TPM2_SetSessionAuth(
    TPM2_AUTH_SESSION * session
)
```

TPM 承認を保持する構造体を設定します。

**パラメータ**: 

  * **session** [TPM2_AUTH_SESSION]()配列へのポインター


**参考**: 

  * [TPM2_GetRCString](#function-tpm2-getrcstring)
  * [TPM2_Init](#function-tpm2-init)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**戻り値**: 

  * TPM_RC_SUCCESS: 成功
  * TPM_RC_FAILURE: TPM2_CTX構造体の排他ロックを取得できなかった 
  * BAD_FUNC_ARG: 不正な引数（ctxにNULLポインターを渡した）


TPM2_Init 関数と wolfTPM2_Init もこの初期化を実行するため、この関数を明示的に呼び出すことはまれです。TPM 2.0 コマンドは最大3つの認証スロットを持つことができるため、サイズ MAX_SESSION_NUM の配列を TPM2_SetSessionAuth に提供することをお勧めします (以下の例を参照)。

_使用例_

```cpp
int rc;
TPM2_AUTH_SESSION session[MAX_SESSION_NUM];

XMEMSET(session, 0, sizeof(session));
session[0].sessionHandle = TPM_RS_PW;

rc = TPM2_SetSessionAuth(session);
if (rc != TPM_RC_SUCCESS) {
    // TPM2_SetSessionAuth failed
}
```

<a id="function-tpm2-getsessionauthcount"></a>
#### TPM2_GetSessionAuthCount

```
WOLFTPM_API int TPM2_GetSessionAuthCount(
    TPM2_CTX * ctx
)
```

現在設定されている TPM 承認の数を確認します。 

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 

**参考**:  

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**戻り値**: 

  * アクティブなTPM 認証数 (１～３) 
  * BAD_FUNC_ARG: 不正な引数


_使用例_

```cpp
int authCount;
TPM2_CTX tpm2Ctx;

authCount = TPM2_GetSessionAuthCount(tpm2ctx);
if (authCount == BAD_FUNC_ARG) {
    // TPM2_GetSessionAuthCount failed
}
```

<a id="function-tpm2-setactivectx"></a>
#### TPM2_SetActiveCtx

```
WOLFTPM_API void TPM2_SetActiveCtx(
    TPM2_CTX * ctx
)
```

新たなTPM2_CTXを設定する。 

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター 


**参考**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


_使用例_

```cpp
TPM2_CTX tpm2Ctx;

TPM2_SetActiveCtx(tpm2ctx);
```

<a id="function-tpm2-getactivectx"></a>
#### TPM2_GetActiveCtx

```
WOLFTPM_API TPM2_CTX * TPM2_GetActiveCtx(
    void 
)
```

TPM2_CTXへのポインターを得る。

**参考**: 

  * [TPM2_CTX]()
  * [TPM2_AUTH_SESSION]()


**戻り値**:  

[TPM2_CTX]() 構造体へのポインター

_使用例_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```

<a id="function-tpm2-gethashdigestsize"></a>
#### TPM2_GetHashDigestSize

```
WOLFTPM_API int TPM2_GetHashDigestSize(
    TPMI_ALG_HASH hashAlg
)
```

TPM 2.0 ハッシュダイジェストのサイズ（バイト数）を得る。 

**パラメータ**: 

  * **hashAlg** TPM 2.0 ハッシュタイプ


**戻り値**:  

  * TPM 2.0 ハッシュダイジェストのサイズ（バイト数） 
  * ハッシュタイプが不正の場合は0を返す


_使用例_

```cpp
int digestSize = 0;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

digestSize = TPM2_GetHashDigestSize(hashAlg);
if (digestSize > 0) {
    //digestSize contains a valid value
}
```

<a id="function-tpm2-gethashtype"></a>
#### TPM2_GetHashType

```
WOLFTPM_API int TPM2_GetHashType(
    TPMI_ALG_HASH hashAlg
)
```

TPM2 ハッシュタイプは対応するwolfcryptのハッシュタイプに変換する。 

**パラメータ**: 

  * **hashAlg** TPM 2.0 ハッシュタイプ


**戻り値**: 

  * wolfcryptでの定義によるハッシュタイプの値 
  * ハッシュタイプが不正の場合は0を返す


_使用例_

```cpp
int wc_hashType;
TPMI_ALG_HASH hashAlg = TPM_ALG_SHA256;

wc_hashType = TPM2_GetHashDigestSize(hashAlg);
if (wc_hashType > 0) {
    //wc_hashType contains a valid wolfcrypt hash type
}
```

<a id="function-tpm2-getnonce"></a>
#### TPM2_GetNonce

```
WOLFTPM_API int TPM2_GetNonce(
    byte * nonceBuf,
    int nonceSz
)
```

乱数の新しいナンスを生成します。

**パラメータ**: 

  * **nonceBuf** BYTEバッファーへのポインター 
  * **nonceSz** ナンスのサイズ（バイト数）


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO での問題あるいはwolfcryptのコンフィギュレーション上の問題) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

WOLFTPM2_USE_HW_RNG が定義されている場合、TPM 乱数ジェネレーターを使用できます。

_使用例_

```cpp
int rc, nonceSize = 32;
BYTE freshNonce[32];

rc = TPM2_GetNonce(&freshNonce, nonceSize);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetNonce failed
}
```

<a id="function-tpm2-setuppcrsel"></a>
#### TPM2_SetupPCRSel

```
WOLFTPM_API void TPM2_SetupPCRSel(
    TPML_PCR_SELECTION * pcr,
    TPM_ALG_ID alg,
    int pcrIndex
)
```

正しい PCR 選択を準備するためのヘルパー関数 たとえば、TPM2_Quote を作成する準備をする場合。

**パラメータ**: 

  * **pcr** [TPML_PCR_SELECTION]()構造体へのポインター
  * **alg** ハッシュアルゴリズムを示すTPM_ALG_ID 
  * **pcrIndex** 使用するPCRレジスターを示す０から23までの値


**参考**: 

  * [TPM2_PCR_Read](#function-tpm2-pcr-read)
  * [TPM2_PCR_Extend](#function-tpm2-pcr-extend)
  * [TPM2_PCR_Reset](#function-tpm2-pcr-reset)
  * [TPM2_Quote](#function-tpm2-quote)


_使用例_

```cpp
int pcrIndex = 16; // This is a PCR register for DEBUG & testing purposes
PCR_Read_In pcrRead;

TPM2_SetupPCRSel(&pcrRead.pcrSelectionIn, TPM_ALG_SHA256, pcrIndex);
```

<a id="function-tpm2-getrcstring"></a>
#### TPM2_GetRCString

```
const WOLFTPM_API char * TPM2_GetRCString(
    int rc
)
```

TPM 2.0 リターン コードの人間が判読できる文字列を取得します。 

**パラメータ**:  

  * **rc** TPMリターンコード


**戻り値**:  

文字列定数へのポインター

_使用例_

```cpp
int rc;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    printf("wolfTPM2_Init failed 0x%x: %s\n", rc, TPM2_GetRCString(rc));
    return rc;
}
```

<a id="function-tpm2-getalgname"></a>
#### TPM2_GetAlgName

```
const WOLFTPM_API char * TPM2_GetAlgName(
    TPM_ALG_ID alg
)
```

TPM 2.0 アルゴリズムの人間が判読できる文字列を取得します。 
 

**パラメータ**: 

  * **alg** TPM 2.0 アルゴリズムを表すTPM_ALG_ID 型の値


**戻り値**:  

文字列定数へのポインター

_使用例_

```cpp
int paramEncAlg = TPM_ALG_CFB;

printf("\tUse Parameter Encryption: %s\n", TPM2_GetAlgName(paramEncAlg));
```

<a id="function-tpm2-getcurvesize"></a>
#### TPM2_GetCurveSize

```
WOLFTPM_API int TPM2_GetCurveSize(
    TPM_ECC_CURVE curveID
)
```

TPM ECC曲線のサイズ（バイト数）を返す。

**パラメータ**: 

  * **curveID** TPM ECC曲線のタイプ


**戻り値**: 

  * 不正な曲線タイプの場合は0を返す。 
  * バイト数を示す整数値


_使用例_

```cpp
int bytes;
TPM_ECC_CURVE curve = TPM_ECC_NIST_P256;

bytes = TPM2_GetCurveSize(curve);
if (bytes == 0) {
    //TPM2_GetCurveSize failed
}
```

<a id="function-tpm2-gettpmcurve"></a>
#### TPM2_GetTpmCurve

```
WOLFTPM_API int TPM2_GetTpmCurve(
    int curveID
)
```

wolfcrypt 曲線タイプを対応する TPM 曲線タイプに変換します。

**パラメータ**: 

  * **curveID** BYTEバッファーへのポインター


**参考**:  [TPM2_GetWolfCurve](#function-tpm2-getwolfcurve)

**戻り値**: 

  * wolfcrypt 曲線タイプを表す整数値 
  * 無効な曲線タイプの場合は ECC_CURVE_OID_Eを返す

_使用例_

```cpp
int tpmCurve;
int wc_curve = ECC_SECP256R1;

tpmCurve = TPM2_GetTpmCurve(curve);
\in this case tpmCurve will be TPM_ECC_NIST_P256
if (tpmCurve = ECC_CURVE_OID_E) {
    //TPM2_GetTpmCurve failed
}
```

<a id="function-tpm2-getwolfcurve"></a>
#### TPM2_GetWolfCurve

```
WOLFTPM_API int TPM2_GetWolfCurve(
    int curve_id
)
```

TPM 曲線タイプを対応する wolfcrypt 曲線タイプに変換します。 

**パラメータ**: 

  * **curve_id** BYTEバッファーへのポインター


**参考**:  [TPM2_GetTpmCurve](#function-tpm2-gettpmcurve)

**戻り値**: 

  * TPM 曲線タイプを表す整数値 
  * 無効な曲線タイプの場合は　-1 あるいは ECC_CURVE_OID_E を返す


_使用例_

```cpp
int tpmCurve = TPM_ECC_NIST_P256;
int wc_curve;

wc_curve = TPM2_GetWolfCurve(tpmCurve);
\in this case tpmCurve will be ECC_SECP256R1
if (wc_curve = ECC_CURVE_OID_E || wc_curve == -1) {
    //TPM2_GetWolfCurve failed
}
```

<a id="function-tpm2-parseattest"></a>
#### TPM2_ParseAttest

```
WOLFTPM_API int TPM2_ParseAttest(
    const TPM2B_ATTEST * in,
    TPMS_ATTEST * out
)
```

[TPM2B_ATTEST]()構造体をパースする。

**パラメータ**: 

  * **in** [TPM2B_ATTEST]() 型の構造体へのポインター 
  * **out** [TPMS_ATTEST]() 型の構造体へのポインター


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

これは、ヘルパー関数 TPM2_Packet_ParseAttest のパブリック API です。

_使用例_

```cpp
TPM2B_ATTEST in; //for example, as part of a TPM2_Quote
TPMS_ATTEST out

rc = TPM2_GetNonce(&in, &out);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParseAttest failed
}
```

<a id="function-tpm2-hashnvpublic"></a>
#### TPM2_HashNvPublic

```
WOLFTPM_API int TPM2_HashNvPublic(
    TPMS_NV_PUBLIC * nvPublic,
    byte * buffer,
    UINT16 * size
)
```

nvPublic 構造に基づいて新しい NV インデックス名を計算します。

**パラメータ**: 

  * **nvPublic** 
  * **buffer** [TPMS_ATTEST]() 型の構造体へのポインター 
  * **size** nvIndex のサイズを格納する UINT16 型の変数へのポインタ


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * エラーの場合は負の値 
  * BAD_FUNC_ARG: 不正な引数 
  * NOT_COMPILED_IN: wolfcryptが有効になっているか要確認


_使用例_

```cpp
TPMS_NV_PUBLIC nvPublic;
BYTE buffer[TPM_MAX_DIGEST_SIZE];
UINT16 size;

rc = TPM2_HashNvPublic(&nvPublic, &buffer, &size);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_HashNvPublic failed
}
```

<a id="function-tpm2-appendpublic"></a>
#### TPM2_AppendPublic

```
WOLFTPM_API int TPM2_AppendPublic(
    byte * buf,
    word32 size,
    int * sizeUsed,
    TPM2B_PUBLIC * pub
)
```

ユーザー提供のバッファに基づいて [TPM2B_PUBLIC]() 構造体を設定します。

**パラメータ**: 

  * **buf** ユーザーバッファへのポインター 
  * **size** ユーザーバッファのサイズを指定する word32 型の整数値 
  * **sizeUsed** pub->buffer の使用サイズを格納する整数変数へのポインター 
  * **pub** [TPM2B_PUBLIC]() 型の空の構造体へのポインタ


**参考**:  [TPM2_ParsePublic](#function-tpm2-parsepublic)

**戻り値**:  

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 不十分なバッファ サイズ 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

ヘルパー関数 TPM2_Packet_AppendPublic の公開 API

_使用例_

```cpp
TPM2B_PUBLIC pub; //empty
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_AppendPublic(&buffer, size, &sizeUsed, &pub);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_AppendPublic failed
}
```

<a id="function-tpm2-parsepublic"></a>
#### TPM2_ParsePublic

```
WOLFTPM_API int TPM2_ParsePublic(
    TPM2B_PUBLIC * pub,
    byte * buf,
    word32 size,
    int * sizeUsed
)
```

[TPM2B_PUBLIC]() 構造体を解析し、ユーザー指定のバッファーに格納します。

**パラメータ**: 

  * **pub** [TPM2B_PUBLIC]() 型のデータが取り込まれた構造体へのポインター 
  * **buf** 空のユーザー バッファへのポインター 
  * **size** ユーザー バッファの使用可能なサイズを指定する word32 型の整数値 
  * **sizeUsed** ユーザー バッファーの使用サイズを格納する整数変数へのポインター


**参考**:  [TPM2_AppendPublic](#function-tpm2-appendpublic)

**戻り値**:  

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: バッファサイズが不十分 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

ヘルパー関数 TPM2_Packet_ParsePublic の公開 API

_使用例_

```cpp
TPM2B_PUBLIC pub; //populated
int sizeUsed, rc;
BYTE buffer[sizeof(TPM2B_PUBLIC)];
word32 size = sizeof(buffer);

rc = TPM2_ParsePublic(&pub, buffer, size, &sizeUsed);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_ParsePublic failed
}
```

<a id="function-tpm2-getname"></a>
#### TPM2_GetName

```
WOLFTPM_LOCAL int TPM2_GetName(
    TPM2_CTX * ctx,
    UINT32 handleValue,
    int handleCnt,
    int idx,
    TPM2B_NAME * name
)
```

TPM オブジェクトの名前を提供します。

**パラメータ**: 

  * **ctx** [TPM2_CTX]() 構造体へのポインター  
  * **handleValue** 有効な TPM ハンドルを指定する UINT32 型の値 
  * **handleCnt** 現在の TPM コマンド/セッションで使用されているハンドルの総数
  * **idx** 有効な TPM 認証セッションを指定する 1 ～ 3 のインデックス値 
  * **name** [TPM2B_NAME]() 型の空の構造体へのポインター


**戻り値**: 

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

オブジェクトは、TPM ハンドルとセッション インデックスによって参照されます。

_使用例_

```cpp
int rc;
UINT32 handleValue = TRANSIENT_FIRST;
handleCount = 1;
sessionIdx = 0;
TPM2B_NAME name;

rc = TPM2_GetName(ctx, handleValue, handleCount, sessionIdx, &name);
if (rc != TPM_RC_SUCCESS) {
    //TPM2_GetName failed
}
```

<a id="function-tpm2-getvendorid"></a>
#### TPM2_GetVendorID

```
WOLFTPM_API UINT16 TPM2_GetVendorID(
    void 
)
```

アクティブな TPM2 コンテキストの vendorID を提供します。 

**参考**: 

  * TPM2_GetCapabilities 
  * TPM2_GetTpmDevId 
  * [TPM2_Init](#function-tpm2-init)


**戻り値**: 

  * ベンダー ID を指定する UINT16 型の整数値
  * TPM2 コンテキストが無効または NULL の場合は 0


**ノート**: 

TPM 初期化中に TPM デバイス情報が正しく読み取られるかどうかに依存します。

_使用例_

```cpp
TPM2_CTX *tpm2Ctx;

tpm2Ctx = TPM2_GetActiveCtx();
```

<a id="function-tpm2-printbin"></a>
#### TPM2_PrintBin

```
WOLFTPM_API void TPM2_PrintBin(
    const byte * buffer,
    word32 length
)
```

フォーマットされた方法でバイナリ バッファを出力するヘルパー関数。

**パラメータ**: 

  * **buffer** BYTE型のバッファへのポインタ 
  * **length** バッファのサイズを含む word32 型の整数値


**参考**:  

  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**ノート**: 

DEBUG_WOLFTPM を定義する必要があります

_使用例_

```cpp
BYTE buffer[] = {0x01,0x02,0x03,0x04};
length = sizeof(buffer);

TPM2_PrintBin(&buffer, length);
```

<a id="function-tpm2-printauth"></a>
#### TPM2_PrintAuth

```
WOLFTPM_API void TPM2_PrintAuth(
    const TPMS_AUTH_COMMAND * authCmd
)
```

[TPMS_AUTH_COMMAND]() 型の構造体を人間が読める形式で出力するヘルパー関数。

**パラメータ**: 

  * **authCmd** [TPMS_AUTH_COMMAND]() 型のデータが取り込まれた構造体へのポインター


**参考**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintPublicArea](#function-tpm2-printpublicarea)


**ノート**: 

DEBUG_WOLFTPM を定義する必要があります

_使用例_

```cpp
TPMS_AUTH_COMMAND authCmd; //for example, part of a TPM Authorization session

TPM2_PrintAuthCmd(&authCmd);
```

<a id="function-tpm2-printpublicarea"></a>
#### TPM2_PrintPublicArea

```
WOLFTPM_API void TPM2_PrintPublicArea(
    const TPM2B_PUBLIC * pub
)
```

[TPM2B_PUBLIC]() 型の構造を人間が読める形式で出力するヘルパー関数。 

**パラメータ**: 

  * **pub** [TPM2B_PUBLIC]() 型のデータが取り込まれた構造体へのポインター


**参考**: 

  * [TPM2_PrintBin](#function-tpm2-printbin)
  * [TPM2_PrintAuth](#function-tpm2-printauth)
  * [TPM2_Create](#function-tpm2-create)
  * [TPM2_ReadPublic](#function-tpm2-readpublic)


**ノート**: 

DEBUG_WOLFTPM を定義する必要があります

_使用例_

```cpp
TPM2B_PUBLIC pub; //for example, part of the output of a successful TPM2_Create

TPM2_PrintPublicArea(&pub);
```






-------------------------------

