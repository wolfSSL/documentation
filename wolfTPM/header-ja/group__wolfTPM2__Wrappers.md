---



---

## wolfTPM2 ラッパー

このモジュールでは、ラッパーと呼ばれる wolfTPM の豊富な API について説明します。

wolfTPM ラッパーは、主に 2 つのケースで使用されます。

* キーの生成や保存など、一般的な TPM 2.0 タスクを実行する
* 構成証明やパラメーター暗号化などの複雑な TPM 2.0 タスクを実行する
wolfTPM は、その多くのラッパー関数のおかげで、TPM 2.0 を迅速かつ迅速に使用できるようにします。

### 関数

|  戻り値        | 関数名および機能概要 |
| -------------- | -------------- |
| WOLFTPM_API int | **[wolfTPM2_Test](#function-wolftpm2-test)**<br>                TPM の初期化をテストし、オプションで TPM 機能を受け取ることができます。  |
| WOLFTPM_API int | **[wolfTPM2_Init](#function-wolftpm2-init)**<br>                  TPM の初期化を完了します。  |
| WOLFTPM_API int | **[wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)**<br>  現在の TPM ローカリティで、既に初期化されている TPM を使用します。  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup](#function-wolftpm2-cleanup)**<br>             TPM と wolfcrypt の初期化解除を行います。  |
| WOLFTPM_API int | **[wolfTPM2_Cleanup_ex](#function-wolftpm2-cleanup-ex)**<br>        TPM (および使用されている場合は wolfcrypt) の初期化解除。  |
| WOLFTPM_API int | **[wolfTPM2_GetTpmDevId](#function-wolftpm2-gettpmdevid)**<br>     TPM のデバイス ID を提供します。  |
| WOLFTPM_API int | **[wolfTPM2_SelfTest](#function-wolftpm2-selftest)**<br>           TPM にセルフ テストを実行するように要求します。  |
| WOLFTPM_API int | **[wolfTPM2_GetCapabilities](#function-wolftpm2-getcapabilities)**<br>   利用可能な TPM 機能を報告します。  |
| WOLFTPM_API int | **[wolfTPM2_UnsetAuth](#function-wolftpm2-unsetauth)**<br>           インデックス番号が指すTPM 認証スロットの1つをクリアします。  |
| WOLFTPM_API int | **[wolfTPM2_SetAuth](#function-wolftpm2-setauth)**<br>                指定されたインデックス、セッション ハンドル、属性、および認証を使用して、TPM 承認スロットを設定します。  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)**<br>   提供されたユーザー認証 (通常はパスワード) を使用して TPM 認証スロットを設定します。  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)**<br>         wolfTPM2ハンドルに関連付けられたユーザー認証を使用してTPM認証スロットを設定します。  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)**<br>        指定された TPM セッション ハンドル、インデックス、およびセッション属性を使用して、TPM 承認スロットを設定します。  |
| WOLFTPM_API int | **[wolfTPM2_SetAuthHandleName](#function-wolftpm2-setauthhandlename)**<br> TPM セッションで使用される名前を、wolfTPM2 ハンドルに関連付けられた名前で更新します。  |
| WOLFTPM_API int | **[wolfTPM2_StartSession](#function-wolftpm2-startsession)**<br>            TPM セッション、ポリシー、HMAC、またはトライアルを作成します。  |
| WOLFTPM_API int | **[wolfTPM2_CreateAuthSession_EkPolicy](#function-wolftpm2-createauthsession-ekpolicy)**<br> デフォルトの EK ポリシーを満たすために、ポリシー シークレットを使用して TPM セッションを作成します。  |
| WOLFTPM_API int | **[wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)**<br>  TPM 2.0 プライマリ鍵を準備および作成する単一の関数。 |
| WOLFTPM_API int | **[wolfTPM2_ChangeAuthKey](#function-wolftpm2-changeauthkey)**<br>       TPM 2.0 鍵の認証シークレットを変更します。  |
| WOLFTPM_API int | **[wolfTPM2_CreateKey](#function-wolftpm2-createkey)**<br>               TPM 2.0 鍵を準備および作成する単一の関数。  |
| WOLFTPM_API int | **[wolfTPM2_LoadKey](#function-wolftpm2-loadkey)**<br>                   TPM 2.0 鍵をロードする単一関数。  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadKey](#function-wolftpm2-createandloadkey)**<br>  1 つのステップで TPM 2.0 鍵を作成してロードする単一の関数。  |
| WOLFTPM_API int | **[wolfTPM2_CreateLoadedKey](#function-wolftpm2-createloadedkey)**<br>   単一の TPM 2.0 操作を使用して鍵を作成および読み込み、暗号化された秘密鍵マテリアルを保存します。  |
| WOLFTPM_API int | **[wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)**<br>       外部の鍵の公開部分をロードするラッパー。  |
| WOLFTPM_API int | **[wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)**<br>     外部の秘密鍵をインポートし、TPM に 1 ステップでロードする単一機能。  |
| WOLFTPM_API int | **[wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)**<br> 外部の秘密鍵をインポートし、TPM に 1 ステップでロードする単一機能。  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadpublickey)**<br>    外部 RSA鍵の公開部分をインポートするヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPublicKey_ex](#function-wolftpm2-loadrsapublickey-ex)**<br>  外部のRSA鍵の公開部分をインポートするヘルパー関数の拡張関数。  |
| WOLFTPM_API int | **[wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)**<br>  外部のRSA 秘密鍵をインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)**<br>     外部のRSA 秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)**<br>   外部のRSA 秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数の拡張関数。  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)**<br>        外部のECC鍵の公開部分をインポートするヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)**<br>  外部のECC鍵のプライベート マテリアルをインポートするヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)**<br>      外部のECC秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)**<br>        ハンドルを使用して、読み込まれた TPM オブジェクトのパブリック部分を受け取るヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_CreateKeySeal](#function-wolftpm2-createkeyseal)**<br>        このラッパーを使用すると、シークレットを TPM 2.0 鍵内に封印できます。  |
| WOLFTPM_API int | **[wolfTPM2_ComputeName](#function-wolftpm2-computename)**<br>           TPM が期待する形式でオブジェクトのパブリック領域のハッシュを生成するヘルパー関数。 |
| WOLFTPM_API int | **[wolfTPM2_SensitiveToPrivate](#function-wolftpm2-sensitivetoprivate)**<br> TPM2B_SENSITIVE を変換するヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsaley-tpmtowolf)**<br>      RSA TPM鍵を抽出し、それを wolfcrypt 鍵に変換します。 |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_TpmToPemPub](#function-wolftpm2-rsakey-tpmtopempub)**<br>  公開 RSA TPM鍵を PEM 形式の公開鍵に変換する 注: pem と tempBuf は、同じサイズの異なるバッファーである必要があります。  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsaley-wolftotpm)**<br>          RSA wolfcrypt 鍵を TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_WolfToTpm_ex](#function-wolftpm2-rsaley-wolftotpm-ex)**<br>    特定のプライマリ キーまたは階層の下で RSA wolfcrypt 鍵を TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_RsaKey_PubPemToTpm](#function-wolftpm2-rsaley-pubpemtotpm)**<br>      PEM 形式の公開鍵をファイルから TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)**<br>     　　　ECC TPM 鍵を抽出し、wolfcrypt 鍵に変換します。 |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm](#function-wolftpm2-ecckey-wolftotpm)**<br>    　　　　ECC wolfcrypt 鍵を TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToTpm_ex](#function-wolftpm2-ecckey-wolftotpm-ex)**<br>    ECC wolfcrypt 鍵を特定のプライマリ キーまたは階層の下の TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_EccKey_WolfToPubPoint](#function-wolftpm2-ecckey-wolftopubpoint)**<br>   wolfcrypt 鍵から生成された ECC 公開鍵を TPM にインポートします。  |
| WOLFTPM_API int | **[wolfTPM2_SignHash](#function-wolftpm2-signhash)**<br>                   TPM 鍵を使用して任意のデータに署名するヘルパー関数。 |
| WOLFTPM_API int | **[wolfTPM2_SignHashScheme](#function-wolftpm2-signhashscheme)**<br>       TPM 鍵を使用して任意のデータに署名し、署名スキームとハッシュ アルゴリズムを指定する高度なヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHash](#function-wolftpm2-verifyhash)**<br>      　　　　　TPM が生成した署名を検証するためのヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_VerifyHashScheme](#function-wolftpm2-verifyhashscheme)**<br>   TPM が生成した署名を検証するための高度なヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)**<br>  Diffie-Hellman 交換用の NULL 階層を持つ ECC鍵ペアを生成してからロードします。  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)**<br>        一時鍵を生成し、Z (共有シークレット) を計算します  |
| WOLFTPM_API int | **[wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)**<br>      pubPoint と読み込まれたプライベート ECC鍵を使用して Z (共有シークレット) を計算します。  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhgenkey)**<br> 一時的な ECC鍵を生成し、配列インデックスを返します (2 フェーズ メソッド)  |
| WOLFTPM_API int | **[wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhgenz)**<br>     pubPoint とカウンターを使用して Z (共有シークレット) を計算します (2 フェーズ法)  |
| WOLFTPM_API int | **[wolfTPM2_RsaEncrypt](#function-wolftpm2-rsaencrypt)**<br>  TPM 2.0 鍵を使用して RSA 暗号化を実行します。 |
| WOLFTPM_API int | **[wolfTPM2_RsaDecrypt](#function-wolftpm2-rsadecrypt)**<br>  TPM 2.0 鍵を使用して RSA 復号を実行します。  |
| WOLFTPM_API int | **[wolfTPM2_ReadPCR](#function-wolftpm2-readpcr)**<br>        指定された TPM 2.0 プラットフォーム構成レジスタ (PCR) の値を読み取る。  |
| WOLFTPM_API int | **[wolfTPM2_ExtendPCR](#function-wolftpm2-extendpcr)**<br>    ユーザー提供のダイジェストで PCR レジスタを拡張します。  |
| WOLFTPM_API int | **[wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)**<br>  TPM の NVRAM にデータを格納するために後で使用する新しい NV インデックスを作成します。  |
| WOLFTPM_API int | **[wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)**<br>  指定されたオフセットで、ユーザー データを NV インデックスに格納します。  |
| WOLFTPM_API int | **[wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)**<br>   指定されたオフセットから開始して、NV インデックスからユーザー データを読み取ります。 |
| WOLFTPM_API int | **[wolfTPM2_NVIncrement](#function-wolftpm2-mvincrement)**<br>    NV 一方向カウンターをインクリメントします。  |
| WOLFTPM_API int | **[wolfTPM2_NVOpen](#function-wolftpm2-mvopen)**<br>           NV を開き、必要な認証と名前ハッシュを入力します。  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)**<br>   既存の NV インデックスを破棄します。  |
| WOLFTPM_API int | **[wolfTPM2_NVCreate](#function-wolftpm2-mvcreate)**<br>   **非推奨です。新しい API を使用してください。**  |
| WOLFTPM_API int | **[wolfTPM2_NVWrite](#function-wolftpm2-mvwrite)**<br>     **非推奨です。新しい API を使用してください。**  |
| WOLFTPM_API int | **[wolfTPM2_NVRead](#function-wolftpm2-nvread)**<br>       **非推奨です。新しい API を使用してください。**  |
| WOLFTPM_API int | **[wolfTPM2_NVDelete](#function-wolftpm2-nvdelete)**<br>   **非推奨です。新しい API を使用してください。**  |
| WOLFTPM_API int | **[wolfTPM2_NVReadPublic](#function-wolftpm2-nvreadpublic)**<br>  最大サイズなど、nvIndex に関する公開情報を抽出します。  |
| WOLFTPM_API int | **[wolfTPM2_NVStoreKey](#function-wolftpm2-nvstorekey)**<br>   TPM 2.0 キーを TPM の NVRAM に格納するヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)**<br>   TPM の NVRAM から TPM 2.0 鍵を削除するヘルパー関数。  |
| WOLFTPM_API struct WC_RNG * | **[wolfTPM2_GetRng](#function-wolftpm2-getrng)**<br>    wolfTPM に使用される wolfcrypt RNG インスタンスを取得します。  |
| WOLFTPM_API int | **[wolfTPM2_GetRandom](#function-wolftpm2-getramdom)**<br>    TPM RNG または wolfcrypt RNG で生成された一連の乱数を取得します。  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandle](#function-wolftpm2-unloadhandle)**<br>  TPM がロードされたオブジェクトを破棄するために使用します。  |
| WOLFTPM_API int | **[wolfTPM2_Clear](#function-wolftpm2-clear)**<br>  wolfTPM と wolfcrypt を初期化解除します (有効な場合) |
| WOLFTPM_API int | **[wolfTPM2_HashStart](#function-wolftpm2-hashstart)**<br>  TPM で生成されたハッシュを開始するヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)**<br>  TPM で生成されたハッシュを新しいユーザー データで更新します。  |
| WOLFTPM_API int | **[wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)**<br>  TPM で生成されたハッシュをファイナライズし、ユーザー バッファーでダイジェスト出力を取得します。  |
| WOLFTPM_API int | **[wolfTPM2_LoadKeyedHashKey](#function-wolftpm2-loadkeyedhashkey)**<br>  通常は HMAC 操作に使用される、KeyedHash 型の新しい TPM 鍵を作成して読み込みます。 |
| WOLFTPM_API int | **[wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)**<br>  TPM で生成された hmac を開始するヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)**<br>  TPM で生成された hmac を新しいユーザー データで更新します。  |
| WOLFTPM_API int | **[wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)**<br>  TPM で生成された hmac をファイナライズし、ユーザー バッファーでダイジェスト出力を取得します。  |
| WOLFTPM_API int | **[wolfTPM2_LoadSymmetricKey](#function-wolftpm2-loadsymmetrockey)**<br>  外部対称鍵を TPM にロードします。  |
| WOLFTPM_API int | **[wolfTPM2_SetCommand](#function-wolftpm2-setcommand)**<br>   他の制限付き TPM コマンドを有効にするために使用される、ベンダー固有の TPM コマンド。  |
| WOLFTPM_API int | **[wolfTPM2_Shutdown](#function-wolftpm2-shutdown)**<br>      TPM をシャットダウンまたはリセットするためのヘルパー関数。  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles](#function-wolftpm2-unloadhandles)**<br>      後続の TPM ハンドルをアンロードするためのワンショット API。  |
| WOLFTPM_API int | **[wolfTPM2_UnloadHandles_AllTransient](#function-wolftpm2-unloadhandles-alltransient)**<br>  すべての一時的な TPM ハンドルをアンロードするためのワンショット API。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)**<br>    ユーザーが選択したオブジェクト属性に基づいて、新しい RSA 鍵の TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)**<br>    ユーザーが選択したオブジェクト属性に基づいて、新しい ECC 鍵の TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)**<br>   新しい対称鍵の TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keydhash)**<br>    新しい KeyedHash 鍵の TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)**<br>    シークレットを封印するための新しい鍵の TPM パブリック テンプレートを準備します。 |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)**<br>    RSA タイプの TPM 承認鍵を生成するための TPM 公開テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)**<br>    ECC タイプの TPM 承認鍵を生成するための TPM 公開テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)**<br>    RSA タイプの新しい TPM ストレージ 鍵を生成するための TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)**<br>    ECC タイプの新しい TPM ストレージ 鍵を生成するための TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)**<br>    RSA タイプの新しい TPM Attestation Key を生成するための TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)**<br>   ECC タイプの新しい TPM Attestation Key を生成するための TPM パブリック テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_SetKeyTemplate_Unique](#function-wolftpm2-getkeytemplate-unique)**<br>   Create または CreatePrimary で使用されるパブリック テンプレートの一意の領域を設定します。  |
| WOLFTPM_API int | **[wolfTPM2_GetNvAttributesTemplate](#function-wolftpm2-getnvattributestemplate)**<br>    TPM NV インデックス テンプレートを準備します。  |
| WOLFTPM_API int | **[wolfTPM2_CreateEK](#function-wolftpm2-createek)**<br>     ユーザーが選択したアルゴリズム、RSA または ECC に基づいて、新しい TPM 承認キーを生成します。  |
| WOLFTPM_API int | **[wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)**<br>   他の TPM キーのストレージ キーとして使用される新しい TPM プライマリ キーを生成します。  |
| WOLFTPM_API int | **[wolfTPM2_CreateAndLoadAIK](#function-wolftpm2-createandloadaik)**<br>    指定されたストレージ鍵の下に新しい TPM 構成証明鍵を生成します。  |
| WOLFTPM_API int | **[wolfTPM2_GetTime](#function-wolftpm2-gettime)**<br>                      TPM 署名付きタイムスタンプを生成するワンショット API。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_SetCustomExt](#function-wolftpm2-csr-setcustomext)**<br>    WOLFTPM2_CSR 構造体のカスタム要求拡張 oid と値の使用を設定する証明書署名要求 (CSR) 生成のヘルパー。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_SetKeyUsage](#function-wolftpm2-csr-setkeyusage)**<br>      WOLFTPM2_CSR 構造のキー使用法を設定する証明書署名要求 (CSR) 生成のヘルパー。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_SetSubject](#function-wolftpm2-csr-setsubject)**<br>        WOLFTPM2_CSR 構造体のサブジェクトを設定する証明書署名要求 (CSR) 生成のヘルパー。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_MakeAndSign_ex](#function-wolftpm2-csr-makeandsign-ex)**<br> TPM ベースの鍵 (件名と鍵の使用法が既に設定されている WOLFTPM2_KEY 構造) を使用した証明書署名要求 (CSR) 生成のヘルパー。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_MakeAndSign](#function-wolftpm2-csr-makeandsign)**<br>       sTPM ベースの鍵 (件名と鍵の使用法が既に設定されている WOLFTPM2_KEY 構造) を使用した証明書署名要求 (CSR) 生成のヘルパー。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_Generate_ex](#function-wolftpm2-csr-generate-ex)**<br> TPM ベースの鍵 (WOLFTPM2_KEY) を使用した証明書署名要求 (CSR) 生成のヘルパー。 TPM鍵に基づいて CSR または自己署名証明書を出力するためのシングル ショット API。  |
| WOLFTPM_API int | **[wolfTPM2_CSR_Generate](#function-wolftpm2-csr-generate)**<br>       TPM ベースの鍵 (WOLFTPM2_KEY) を使用した証明書署名要求 (CSR) 生成のヘルパー。 TPM鍵に基づいて CSR または自己署名証明書を出力するためのシングル ショット API。  |
| WOLFTPM_API int | **[wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)**<br>    クリプトオフロードに TPM を使用するためのリファレンス クリプト コールバック API。 このコールバック関数は、wolfTPM2_SetCryptoDevCb または wc_CryptoDev_RegisterDevice を使用して登録されます。  |
| WOLFTPM_API int | **[wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)**<br>         暗号コールバック関数を登録し、割り当てられた devId を返します。 |
| WOLFTPM_API int | **[wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)**<br>     登録された暗号コールバックをクリアします。  |
| WOLFTPM_API [WOLFTPM2_DEV]()**   | **[wolfTPM2_New](#function-wolftpm2-new)**<br>              WOLFTPM2_DEV を割り当てて初期化します。|
| WOLFTPM_API int                  | **[wolfTPM2_Free](#function-wolftpm2-free)**<br>            wolfTPM2_New によって割り当てられた WOLFTPM2_DEV をクリーンアップして解放します。  |
| WOLFTPM_API [WOLFTPM2_KEYBLOB]() | **[wolfTPM2_NewKeyBlob](#function-wolftpm2-newkeyblob)**<br> WOLFTPM2_KEYBLOB を割り当てて初期化します。  |
| WOLFTPM_API int                  | **[wolfTPM2_FreeKeyBlob](#function-wolftpm2-freekeyblob)**<br> wolfTPM2_NewKeyBlob で割り当てられた WOLFTPM2_KEYBLOB を解放します。  |
| WOLFTPM_API [TPMT_PUBLIC]()      | **[wolfTPM2_NewPublicTemplate](#function-wolftpm2-newpublictemplate)**<br>  TPMT_PUBLIC構造体を割り当てて初期化します。|           |
| WOLFTPM_API int                  | **[wolfTPM2_FreePublicTemplate](#function-wolftpm2-freepublictemplate)**<br> wolfTPM2_NewPublicTemplate で割り当てられた TPMT_PUBLIC を解放します。  |
| WOLFTPM_API [WOLFTPM2_KEY]()     | **[wolfTPM2_NewKey](#function-wolftpm2-newkey)**<br>       WOLFTPM2_KEY を割り当てて初期化します。  |
| WOLFTPM_API int                  | **[wolfTPM2_FreeKey](#function-wolftpm2-freekey)**<br>     wolfTPM2_NewKey で割り当てられた WOLFTPM2_KEY を解放します。  |
| WOLFTPM_API [WOLFTPM2_SESSION]() * | **[wolfTPM2_NewSession](#function-wolftpm2-newsession)**<br> WOLFTPM2_SESSION を割り当てて初期化します。|
| WOLFTPM_API int                  | **[wolfTPM2_FreeSession](#function-wolftpm2-freesession)**<br> wolfTPM2_NewSession で割り当てられた WOLFTPM2_SESSION を解放します。  |
| WOLFTPM_API [WOLFTPM2_CSR]() *   | **[wolfTPM2_NewCSR](#function-wolftpm2-newcsr)**<br>           WOLFTPM2_CSR を割り当てて初期化します。|
| WOLFTPM_API int                  | **[wolfTPM2_FreeCSR](#function-wolftpm2-freecsr)**<br>         wolfTPM2_NewCSR で割り当てられた WOLFTPM2_CSR を解放します。  |
| WOLFTPM_API WOLFTPM2_HANDLE *    | **[wolfTPM2_GetHandleRefFromKey](#function-wolftpm2-gethandlereffromkey)**<br>  WOLFTPM2_KEY から WOLFTPM2_HANDLE を取得します。|
| WOLFTPM_API WOLFTPM2_HANDLE *    | **[wolfTPM2_GetHandleRefFromKeyBlob](#function-wolftpm2-gethandlereffromkeyblob)**<br>  WOLFTPM2_KEYBLOB から WOLFTPM2_HANDLE を取得します。|
| WOLFTPM_API WOLFTPM2_HANDLE *    | **[wolfTPM2_GetHandleRefFromSession](#function-wolftpm2-gethandlereffromsession)**<br>  WOLFTPM2_SESSION から WOLFTPM2_HANDLE を取得します。|
| WOLFTPM_API [TPM_HANDLE](#typedef-tpm-handle) | **[wolfTPM2_GetHandleValue](#function-wolftpm2-gethandlevalue)**<br>  WOLFTPM2_HANDLE から 32 ビットのハンドル値を取得します。 |
| WOLFTPM_API int | **[wolfTPM2_SetKeyAuthPassword](#function-wolftpm2-setkeyauthpassword)**<br>   鍵の認証データを設定します。 |
| WOLFTPM_API int | **[wolfTPM2_GetKeyBlobAsBuffer](#function-wolftpm2-getkeyblobasbuffer)**<br>  キーブロブからバイナリ バッファーにデータをマーシャリングします。 これは、別のプロセスでロードするため、または電源の再投入後にディスクに保存できます。  |
| WOLFTPM_API int | **[wolfTPM2_SetKeyBlobFromBuffer](#function-wolftpm2-setkeyblobfrombuffer)**<br> データを WOLFTPM2_KEYBLOB 構造体にアンマーシャリングします。 これは、wolfTPM2_GetKeyBlobAsBuffer によって以前にマーシャリングされたキーブロブをロードするために使用できます。|

### 詳細な説明

このモジュールでは、ラッパーと呼ばれる wolfTPM の豊富な API について説明します。

wolfTPM ラッパーは、主に 2 つのケースで使用されます。

* キーの生成や保存など、一般的な TPM 2.0 タスクを実行する
* 構成証明やパラメーター暗号化などの複雑な TPM 2.0 タスクを実行する
wolfTPM は、その多くのラッパー関数のおかげで、TPM 2.0 を迅速かつ迅速に使用できるようにします。


### 関数のドキュメント

<a id="function-wolftpm2-test"></a>
#### wolfTPM2_Test

```
WOLFTPM_API int wolfTPM2_Test(
    TPM2HalIoCb ioCb,
    void * userCtx,
    WOLFTPM2_CAPS * caps
)
```

TPM の初期化をテストし、オプションで TPM 機能を受け取ることができます。

**パラメータ**: 

  * **ioCb** IOコールバック関数 (examples/tpm_io.h を参照) 
  * **userCtx** ユーザーコンテキストへのポインター (NULL指定も可) 
  * **caps** TPM機能を返却する為の[WOLFTPM2_CAPS]()構造体へのポインター(NULL指定も可)


**参考**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-init"></a>
#### wolfTPM2_Init

```
WOLFTPM_API int wolfTPM2_Init(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

TPM の初期化を完了します。

**パラメータ**: 

  * **dev** [WOLFTPM2_DEV]() 型の空の構造体へのポインター 
  * **ioCb** IO コールバック関数 (examples/tpm_io.h参照) 
  * **userCtx** ユーザーコンテキストへのポインター (NULL指定も可)


**参考**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信を確認すること) 
  * BAD_FUNC_ARG: 不正な引数


_使用例_

```cpp
int rc;
WOLFTPM2_DEV dev;

rc = wolfTPM2_Init(&dev, TPM2_IoCb, userCtx);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Init failed
    goto exit;
}
```

<a id="function-wolftpm2-openexisting"></a>
#### wolfTPM2_OpenExisting

```
WOLFTPM_API int wolfTPM2_OpenExisting(
    WOLFTPM2_DEV * dev,
    TPM2HalIoCb ioCb,
    void * userCtx
)
```

現在の TPM ローカリティで、既に初期化されている TPM を使用します。

**パラメータ**:

  * **dev** [WOLFTPM2_DEV]() 型の空の構造体へのポインター 
  * **ioCb** IO コールバック関数 (examples/tpm_io.h参照) 
  * **userCtx** ユーザーコンテキストへのポインター (NULL指定も可)


**参考**: 

  * [wolfTPM2_Init](#function-wolftpm2-init)
  * [wolfTPM2_Cleanup](#function-wolftpm2-cleanup)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信を確認すること) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-cleanup"></a>
#### wolfTPM2_Cleanup

```
WOLFTPM_API int wolfTPM2_Cleanup(
    WOLFTPM2_DEV * dev
)
```

TPM と wolfcrypt の初期化解除を行います。  

**パラメータ**:

  * **dev** データ設定済みの [WOLFTPM2_DEV]() 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信を確認すること) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

適切な doShutdown パラメータを指定して wolfTPM2_Cleanup_ex を呼び出します

_使用例_

```cpp
int rc;

rc = wolfTPM2_Cleanup(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup failed
    goto exit;
}
```

<a id="function-wolftpm2-cleanup-ex"></a>
#### wolfTPM2_Cleanup_ex

```
WOLFTPM_API int wolfTPM2_Cleanup_ex(
    WOLFTPM2_DEV * dev,
    int doShutdown
)
```

TPM (および使用されている場合は wolfcrypt) の初期化解除。

**パラメータ**:

  * **dev** データ設定済みの [WOLFTPM2_DEV]() 型の構造体へのポインター 
  * **doShutdown** フラグ値。trueを指定の場合はTPM2_Shutdownが実行される


**参考**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信を確認すること) 
  * BAD_FUNC_ARG: 不正な引数


_使用例_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_Cleanup_ex(&dev, 1);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```

<a id="function-wolftpm2-gettpmdevid"></a>
#### wolfTPM2_GetTpmDevId

```
WOLFTPM_API int wolfTPM2_GetTpmDevId(
    WOLFTPM2_DEV * dev
)
```

TPM のデバイス ID を提供します。

**パラメータ**:

  * **dev** データ設定済みの [WOLFTPM2_DEV]() 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetCapabilities](#function-wolftpm2-getcapabilities)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**戻り値**:

  * 有効なTPM デバイス IDを示す整数値 
  * あるいは、TPM初期化でDevIDを取得できない場合はINVALID_DEVIDを返します


_使用例_

```cpp
int tpmDevId;

tpmDevId = wolfTPM2_GetTpmDevId(&dev);
if (tpmDevId != INVALID_DEVID) {
    //wolfTPM2_Cleanup_ex failed
    goto exit;
}
```

<a id="function-wolftpm2-selftest"></a>
#### wolfTPM2_SelfTest

```
WOLFTPM_API int wolfTPM2_SelfTest(
    WOLFTPM2_DEV * dev
)
```

TPM にセルフ テストを実行するように要求します。

**パラメータ**:

  * **dev** データ設定済みの [WOLFTPM2_DEV]() 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_OpenExisting](#function-wolftpm2-openexisting)
  * [wolfTPM2_Test](#function-wolftpm2-test)
  * [TPM2_Init](#function-tpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信とTPMリターンコードを確認すること) 
  * BAD_FUNC_ARG: 不正な引数


_使用例_

```cpp
int rc;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_SelfTest(&dev);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_SelfTest failed
    goto exit;
}
```

<a id="function-wolftpm2-getcapabilities"></a>
#### wolfTPM2_GetCapabilities

```
WOLFTPM_API int wolfTPM2_GetCapabilities(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CAPS * caps
)
```

利用可能な TPM 機能を報告します。 

**パラメータ**:

  * **dev** データ設定済みの [WOLFTPM2_DEV]() 型の構造体へのポインター 
  * **caps** 機能を返却する為の[WOLFTPM2_CAPS]()構造体へのポインター


**参考**: 

  * [wolfTPM2_GetTpmDevId](#function-wolftpm2-gettpmdevid)
  * [wolfTPM2_SelfTest](#function-wolftpm2-selftest)
  * [wolfTPM2_Init](#function-wolftpm2-init)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO 通信とTPMリターンコードを確認すること) 
  * BAD_FUNC_ARG: 不正な引数


_使用例_

```cpp
int rc;
WOLFTPM2_CAPS caps;

//perform TPM2_Shutdown after deinitialization
rc = wolfTPM2_GetCapabilities(&dev, &caps);
if (rc != TPM_RC_SUCCESS) {
    //wolfTPM2_GetCapabilities failed
    goto exit;
}
```

<a id="function-wolftpm2-unsetauth"></a>
#### wolfTPM2_UnsetAuth

```
WOLFTPM_API int wolfTPM2_UnsetAuth(
    WOLFTPM2_DEV * dev,
    int index
)
```

インデックス番号が指すTPM 認証スロットの1つをクリアします。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM認証スロットを指定するための整数値（０～３）


**参考**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: TPM2コンテキストのロックを取得できなかった 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-setauth"></a>
#### wolfTPM2_SetAuth

```
WOLFTPM_API int wolfTPM2_SetAuth(
    WOLFTPM2_DEV * dev,
    int index,
    TPM_HANDLE sessionHandle,
    const TPM2B_AUTH * auth,
    TPMA_SESSION sessionAttributes,
    const TPM2B_NAME * name
)
```

指定されたインデックス、セッション ハンドル、属性、および認証を使用して、TPM 承認スロットを設定します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM 認証スロットを指定する整数値 (0 ～ 3) 
  * **sessionHandle** TPM_HANDLE 型の整数値 
  * **auth** TPM 承認を含む TPM2B_AUTH 型の構造体へのポインター 
  * **sessionAttributes** TPMA_SESSION 型の整数値。セッションの 1 つ以上の属性を選択します 
  * **name** [TPM2B_NAME]() 構造体へのポインター


**参考**: 

  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

wolfTPM2_SetAuthPassword など、他の wolfTPM2 ラッパーのいずれかを使用することをお勧めします。 wolfTPM2_SetAuth ラッパーは、高度なユース ケースの TPM 認証スロットを完全に制御できるためです。 ほとんどのシナリオでは、wolfTPM2_SetAuthHandle と SetAuthPassword が使用されます。

<a id="function-wolftpm2-setauthpassword"></a>
#### wolfTPM2_SetAuthPassword

```
WOLFTPM_API int wolfTPM2_SetAuthPassword(
    WOLFTPM2_DEV * dev,
    int index,
    const TPM2B_AUTH * auth
)
```

提供されたユーザー認証 (通常はパスワード) を使用して TPM 認証スロットを設定します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM 認証スロットを指定する整数値 (0 ～ 3) 
  * **auth** TPM 承認を含む TPM2B_AUTH 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

多くの場合、プライマリ キーを含む TPM鍵の読み込みと使用を承認するために使用されます。

<a id="function-wolftpm2-setauthhandle"></a>
#### wolfTPM2_SetAuthHandle

```
WOLFTPM_API int wolfTPM2_SetAuthHandle(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

wolfTPM2ハンドルに関連付けられたユーザー認証を使用してTPM認証スロットを設定します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM 認証スロットを指定する整数値 (0 ～ 3) 
  * **handle** WOLFTPM2_HANDLE 構造体へのポインター


**参考**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

このラッパーは、TPM キーを複数の操作に使用し、TPM 承認が再び必要な場合に特に役立ちます。

<a id="function-wolftpm2-setauthsession"></a>
#### wolfTPM2_SetAuthSession

```
WOLFTPM_API int wolfTPM2_SetAuthSession(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_SESSION * tpmSession,
    TPMA_SESSION sessionAttributes
)
```

指定された TPM セッション ハンドル、インデックス、およびセッション属性を使用して、TPM 承認スロットを設定します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM 認証スロットを指定する整数値 (0 ～ 3) 
  * **tpmSession** TPM_HANDLE型のセッションハンドル整数値
  * **sessionAttributes** TPMA_SESSION型の整数値,一つ以上のアトリビュートを選択する


**参考**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

このラッパーは、TPM セッション、つまりパラメータ暗号化のセッションのコンフィギュレーションに有用です。

<a id="function-wolftpm2-setauthhandlename"></a>
#### wolfTPM2_SetAuthHandleName

```
WOLFTPM_API int wolfTPM2_SetAuthHandleName(
    WOLFTPM2_DEV * dev,
    int index,
    const WOLFTPM2_HANDLE * handle
)
```

TPM セッションで使用される名前を、wolfTPM2 ハンドルに関連付けられた名前で更新します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **index** TPM 認証スロットを指定する整数値 (0 ～ 3) 
  * **handle** WOLFTPM2_HANDLE 構造体へのポインター


**参考**: 

  * [wolfTPM2_SetAuth](#function-wolftpm2-setauth)
  * [wolfTPM2_SetAuthPassword](#function-wolftpm2-setauthpassword)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

通常、このラッパーは別のラッパー（例えばwolfTPM2_NVWriteAuth）から使用され、非常に特殊なユースケースで使用されます

<a id="function-wolftpm2-startsession"></a>
#### wolfTPM2_StartSession

```
WOLFTPM_API int wolfTPM2_StartSession(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * session,
    WOLFTPM2_KEY * tpmKey,
    WOLFTPM2_HANDLE * bind,
    TPM_SE sesType,
    int encDecAlg
)
```

TPM セッション、ポリシー、HMAC、またはトライアルを作成します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **session** [WOLFTPM2_SESSION]()構造体へのポインター 
  * **tpmKey** セッションのソルトとして使用する[WOLFTPM2_KEY]() へのポインター 
  * **bind** セッションをバインドするために使用される WOLFTPM2_HANDLE へのポインタ 
  * **sesType** バイト値、セッション タイプ (HMAC、ポリシー、またはトライアル) 
  * **encDecAlg** パラメータ暗号化の場合のアルゴリズムを指定する整数値 (TPM_ALG_CFB または TPM_ALG_XOR)。 CFB または XOR 以外の値はすべて NULL と見なされ、パラメーターの暗号化は無効になります。


**参考**: 

  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

このラッパーは、パラメータ暗号化のために TPM セッションを開始するためにも使用できます。wolfTPM nvram または keygen の例を参照してください。

<a id="function-wolftpm2-createauthsession-ekpolicy"></a>
#### wolfTPM2_CreateAuthSession_EkPolicy

```
WOLFTPM_API int wolfTPM2_CreateAuthSession_EkPolicy(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_SESSION * tpmSession
)
```

デフォルトの EK ポリシーを満たすために、ポリシー シークレットを使用して TPM セッションを作成します。 

**パラメータ**: 

  * **dev** TPM2_DEV 構造体へのポインター 
  * **session** [WOLFTPM2_SESSION]()構造体へのポインター


**参考**: 

  * [wolfTPM2_SetAuthSession](#function-wolftpm2-setauthsession)
  * [wolfTPM2_StartSession](#function-wolftpm2-startsession)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数 
  * TPM_RC_FAILURE: TPM リターン コード、使用可能なハンドル、TPM IOなどを要確認


**ノート**: 

このラッパーは、EK 承認がデフォルトから変更されていない場合にのみ使用できます。

<a id="function-wolftpm2-createprimarykey"></a>
#### wolfTPM2_CreatePrimaryKey

```
WOLFTPM_API int wolfTPM2_CreatePrimaryKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_HANDLE primaryHandle,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

TPM 2.0 プライマリ鍵を準備および作成する単一の関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **primaryHandle** 4 つの TPM 2.0 プライマリ シードのいずれかを指定する整数値: TPM_RH_OWNER、TPM_RH_ENDORSEMENT、TPM_RH_PLATFORM、または TPM_RH_NULL 
  * **publicTemplate** 手動で、または wolfTPM2_GetKeyTemplate_... ラッパーの 1 つを使用して設定された [TPMT_PUBLIC]() 構造へのポインタ 
  * **auth** プライマリキーのパスワード認証を指定する文字列定数へのポインタ 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM 2.0 では、非対称 RSA または ECC プライマリ キーのみが許可されます。 その後、対称鍵と非対称鍵の両方を TPM 2.0 プライマリ キーの下に作成できます。通常、プライマリ キーは TPM 2.0 鍵の階層を作成するために使用されます。 TPM は主鍵を使用して、他の鍵をラップし、署名または復号します。

<a id="function-wolftpm2-changeauthkey"></a>
#### wolfTPM2_ChangeAuthKey

```
WOLFTPM_API int wolfTPM2_ChangeAuthKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    const byte * auth,
    int authSz
)
```

TPM 2.0 鍵の認証シークレットを変更します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される TPM 2.0 プライマリ キーを指定します 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_SetAuthHandle](#function-wolftpm2-setauthhandle)
  * [wolfTPM2_UnloadHandle](#function-wolftpm2-unloadhandle)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

PM では、プライマリ キーの認証シークレットを変更することはできません。 代わりに、wolfTPM2_CreatePrimary を使用して、新しい認証で同じ PrimaryKey を作成します。

<a id="function-wolftpm2-createkey"></a>
#### wolfTPM2_CreateKey

```
WOLFTPM_API int wolfTPM2_CreateKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

TPM 2.0 鍵を準備および作成する単一の関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **keyBlob** [WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される 2.0 プライマリ キーを指定します 
  * **publicTemplate** 手動で、または wolfTPM2_GetKeyTemplate_... ラッパーの 1 つを使用して設定された [TPMT_PUBLIC]() 構造へのポインター 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

この関数は、キー マテリアルのみを作成し、それをキーブロブ引数に格納します。 キーをロードするには、wolfTPM2_LoadKey を使用します

<a id="function-wolftpm2-loadkey"></a>
#### wolfTPM2_LoadKey

```
WOLFTPM_API int wolfTPM2_LoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent
)
```

TPM 2.0 鍵をロードする単一関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **keyBlob** [WOLFTPM2_KEYBLOB]() 型の構造体へのポインター 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される TPM 2.0 プライマリ キーを指定します


**参考**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

  * TPM 2.0 鍵をロードするには、この操作の前にその親 (プライマリ キー) もロードする必要があります。 プライマリキー作成時にロードされます。

<a id="function-wolftpm2-createandloadkey"></a>
#### wolfTPM2_CreateAndLoadKey

```
WOLFTPM_API int wolfTPM2_CreateAndLoadKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

1 つのステップで TPM 2.0 鍵を作成してロードする単一の関数。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される TPM 2.0 プライマリ キーを指定します
  * **publicTemplate** 手動で、または wolfTPM2_GetKeyTemplate_... ラッパーの 1 つを使用して設定された [TPMT_PUBLIC]() 構造へのポインタ 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値

**参考**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-createloadkey"></a>
#### wolfTPM2_CreateLoadedKey

```
WOLFTPM_API int wolfTPM2_CreateLoadedKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz
)
```

単一の TPM 2.0 操作を使用して鍵を作成および読み込み、暗号化された秘密鍵マテリアルを保存します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **keyBlob** [WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター。暗号化されたデータとして秘密鍵の素材が含まれます 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される TPM 2.0 プライマリ キーを指定します 
  * **publicTemplate** 手動で、または wolfTPM2_GetKeyTemplate_... ラッパーの 1 つを使用して設定された [TPMT_PUBLIC]() 構造へのポインター 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_CreateAndLoadKey](#function-wolftpm2-createandloadkey)
  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_LoadKey](#function-wolftpm2-loadkey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-loadpublickey"></a>
#### wolfTPM2_LoadPublicKey

```
WOLFTPM_API int wolfTPM2_LoadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub
)
```

外部の鍵の公開部分をロードするラッパー。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **pub** [TPM2B_PUBLIC]()構造体へのポインター


**参考**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * wolfTPM2_wolfTPM2_LoadPrivateKey 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

  * 鍵は、TPM が期待する形式にフォーマットする必要があります。'pub' 引数と代替ラッパーを参照してください。

<a id="function-wolftpm2-loadprivatekey"></a>
#### wolfTPM2_LoadPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

外部の秘密鍵をインポートし、TPM に 1 ステップでロードする単一機能。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL 指定が可) 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **pub** [TPM2B_PUBLIC]()構造体へのポインター 
  * **sens** [TPM2B_SENSITIVE]() 型のデータが設定された構造体へのポインター


**参考**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

秘密鍵の素材は、TPM が期待する形式で準備する必要があります。"sens"引数を参照してください

<a id="function-wolftpm2-importprivatekey"></a>
#### wolfTPM2_ImportPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const TPM2B_PUBLIC * pub,
    TPM2B_SENSITIVE * sens
)
```

外部の秘密鍵をインポートし、TPM に 1 ステップでロードする単一機能。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL 指定が可) 
  * **keyBlob** WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター 
  * **pub** [TPM2B_PUBLIC]()構造体へのポインター 
  * **sens** [TPM2B_SENSITIVE]() 型のデータが設定された構造体へのポインター


**参考**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

プライマリ キー マテリアルは、TPM が期待する形式で準備する必要があります。"sens"引数を参照してください。

<a id="function-wolftpm2-loadrsapublickey"></a>
#### wolfTPM2_LoadRsaPublicKey

```
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent
)
```

外部 RSA鍵の公開部分をインポートするヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **rsaPub** 公開鍵素材を含むバイトバッファへのポインター 
  * **rsaPubSz** バッファサイズを指定する word32 型の整数値 
  * **exponent** RSA 指数を指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_LoadRsaPublicKey_ex](#function-wolftpm2-loadrsapublickey-ex)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

パブリック部分のTPM形式を必要としないため、使用を推奨

<a id="function-wolftpm2-loadrsapublickey-ex"></a>
#### wolfTPM2_LoadRsaPublicKey_ex

```
WOLFTPM_API int wolfTPM2_LoadRsaPublicKey_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

外部のRSA鍵の公開部分をインポートするヘルパー関数の拡張関数。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **rsaPub** 公開鍵素材を含むバイトバッファへのポインター 
  * **rsaPubSz** バッファサイズを指定する word32 型の整数値 
  * **exponent** RSA 指数を指定する word32 型の整数値 
  * **scheme** RSA スキームを指定する TPMI_ALG_RSA_SCHEME タイプの値 
  * **hashAlg** TPM ハッシュアルゴリズムを指定する TPMI_ALG_HASH タイプの値


**参考**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

開発者は TPM ハッシュ アルゴリズムと RSA スキームを指定できます

<a id="function-wolftpm2-importrsaprivatekey"></a>
#### wolfTPM2_ImportRsaPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

外部のRSA 秘密鍵をインポートします。  

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL にすることができ、キーは OWNER 階層の下にインポートされます)
  * **keyBlob** WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター 
  * **rsaPub** RSA鍵の公開部分を含むバイトバッファへのポインタ 
  * **rsaPubSz** パブリック部分のバッファ サイズを指定する word32 型の整数値 
  * **exponent** RSA 指数を指定する word32 型の整数値 
  * **rsaPriv** RSA鍵のプライベートマテリアルを含むバイトバッファへのポインター 
  * **rsaPrivSz** プライベート マテリアル バッファ サイズを指定する word32 型の整数値 
  * **scheme** RSA スキームを指定する TPMI_ALG_RSA_SCHEME タイプの値 
  * **hashAlg** サポートされている TPM 2.0 ハッシュ アルゴリズムを指定する TPMI_ALG_HASH 型の整数値


**参考**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数 
  * BUFFER_E: 引数のサイズが TPM バッファで許可されているサイズよりも大きい

<a id="function-wolftpm2-loadrsaprivatekey"></a>
#### wolfTPM2_LoadRsaPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz
)
```

外部のRSA 秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL にすることができ、キーは OWNER 階層の下にインポートされます)
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **rsaPub** RSA鍵の公開部分を含むバイトバッファへのポインタ 
  * **rsaPubSz** パブリック部分のバッファ サイズを指定する word32 型の整数値 
  * **exponent** RSA 指数を指定する word32 型の整数値 
  * **rsaPriv** RSA鍵のプライベートマテリアルを含むバイトバッファへのポインター 
  * **rsaPrivSz** プライベート マテリアル バッファ サイズを指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadRsaPrivateKey_ex](#function-wolftpm2-loadrsaprivatekey-ex)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-loadrsaprivatekey-ex"></a>
#### wolfTPM2_LoadRsaPrivateKey_ex

```
WOLFTPM_API int wolfTPM2_LoadRsaPrivateKey_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    const byte * rsaPub,
    word32 rsaPubSz,
    word32 exponent,
    const byte * rsaPriv,
    word32 rsaPrivSz,
    TPMI_ALG_RSA_SCHEME scheme,
    TPMI_ALG_HASH hashAlg
)
```

外部のRSA 秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数の拡張関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL にすることができ、キーは OWNER 階層の下にインポートされます)
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **rsaPub** RSA鍵の公開部分を含むバイトバッファへのポインター 
  * **rsaPubSz** パブリック部分のバッファ サイズを指定する word32 型の整数値 
  * **exponent** RSA 指数を指定する word32 型の整数値 
  * **rsaPriv** RSA鍵のプライベートマテリアルを含むバイトバッファへのポインター 
  * **rsaPrivSz** プライベート マテリアル バッファ サイズを指定する word32 型の整数値 
  * **scheme** RSA スキームを指定する TPMI_ALG_RSA_SCHEME タイプの値 
  * **hashAlg** TPM ハッシュアルゴリズムを指定する TPMI_ALG_HASH タイプの値


**参考**: 

  * [wolfTPM2_LoadRsaPrivateKey](#function-wolftpm2-loadrsaprivatekey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)
  * [wolfTPM2_ImportRsaPrivateKey](#function-wolftpm2-importrsaprivatekey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-loadeccprivatekey"></a>
#### wolfTPM2_LoadEccPublicKey

```
WOLFTPM_API int wolfTPM2_LoadEccPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz
)
```

外部のECC鍵の公開部分をインポートするヘルパー関数。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **curveId** 整数値、受け入れられた TPM_ECC_CURVE 値の 1 つ 
  * **eccPubX** ポイント X のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubXSz** ポイント X バッファ サイズを指定する word32 型の整数値 
  * **eccPubY** ポイント Y のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubYSz** ポイント Y バッファ サイズを指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)
  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_ReadPublicKey](#function-wolftpm2-readpublickey)
  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

パブリック部分のTPM形式を必要としないため、使用を推奨

<a id="function-wolftpm2-importeccprivatekey"></a>
#### wolfTPM2_ImportEccPrivateKey

```
WOLFTPM_API int wolfTPM2_ImportEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEYBLOB * keyBlob,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

外部のECC鍵のプライベート マテリアルをインポートするヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL にすることができ、キーは OWNER 階層の下にインポートされます)
  * **keyBlob** WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター 
  * **curveId** 整数値、受け入れられた TPM_ECC_CURVE 値の 1 つ 
  * **eccPubX** ポイント X のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubXSz** ポイント X バッファ サイズを指定する word32 型の整数値 
  * **eccPubY** ポイント Y のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubYSz** ポイント Y バッファ サイズを指定する word32 型の整数値 
  * **eccPriv** プライベート マテリアルを含むバイト バッファへのポインタ 
  * **eccPrivSz** プライベート マテリアル サイズを指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_LoadEccPrivateKey](#function-wolftpm2-loadeccprivatekey)
  * wolfTPM2_LoadEccPrivateKey_ex 
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-loadeccprivatekey"></a>
#### wolfTPM2_LoadEccPrivateKey

```
WOLFTPM_API int wolfTPM2_LoadEccPrivateKey(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * key,
    int curveId,
    const byte * eccPubX,
    word32 eccPubXSz,
    const byte * eccPubY,
    word32 eccPubYSz,
    const byte * eccPriv,
    word32 eccPrivSz
)
```

外部のECC秘密鍵を 1 ステップでインポートおよびロードするヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** WOLFTPM2_HANDLE タイプの構造体へのポインター (外部キーの場合は NULL にすることができ、キーは OWNER 階層の下にインポートされます)
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **curveId** 整数値、受け入れられた TPM_ECC_CURVE 値の 1 つ 
  * **eccPubX** ポイント X のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubXSz** ポイント X バッファ サイズを指定する word32 型の整数値 
  * **eccPubY** ポイント Y のパブリック マテリアルを含むバイト バッファへのポインタ 
  * **eccPubYSz** ポイント Y バッファ サイズを指定する word32 型の整数値 
  * **eccPriv** プライベート マテリアルを含むバイト バッファへのポインタ 
  * **eccPrivSz** プライベート マテリアル サイズを指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_ImportEccPrivateKey](#function-wolftpm2-importeccprivatekey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPrivateKey](#function-wolftpm2-loadprivatekey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-readpublickey"></a>
#### wolfTPM2_ReadPublicKey

```
WOLFTPM_API int wolfTPM2_ReadPublicKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const TPM_HANDLE handle
)
```

ハンドルを使用して、読み込まれた TPM オブジェクトのパブリック部分を受け取るヘルパー関数。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **handle** ロードされた TPM オブジェクトのハンドルを指定する、TPM_HANDLE 型の整数値

**参考**: 

  * [wolfTPM2_LoadRsaPublicKey](#function-wolftpm2-loadrsapublickey)
  * [wolfTPM2_LoadEccPublicKey](#function-wolftpm2-loadeccpublickey)
  * [wolfTPM2_LoadPublicKey](#function-wolftpm2-loadpublickey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM 対称鍵の公開部分には、TPM メタデータのみが含まれます

<a id="function-wolftpm2-createkeyseal"></a>
#### wolfTPM2_CreateKeySeal

```
WOLFTPM_API int wolfTPM2_CreateKeySeal(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEYBLOB * keyBlob,
    WOLFTPM2_HANDLE * parent,
    TPMT_PUBLIC * publicTemplate,
    const byte * auth,
    int authSz,
    const byte * sealData,
    int sealSize
)
```

このラッパーを使用すると、シークレットを TPM 2.0 鍵内に封印できます。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **keyBlob** WOLFTPM2_KEYBLOB]() 型の空の構造体へのポインター 
  * **parent** WOLFTPM2_HANDLE タイプの構造体へのポインター。親 (ストレージ キー) として使用される 2.0 プライマリ キーを指定します。
  * **publicTemplate** wolfTPM2_GetKeyTemplate_KeySeal のいずれかを使用して設定された [TPMT_PUBLIC]() 構造へのポインタ 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値 
  * **sealData** シールするシークレット (ユーザー データ) を含むバイト バッファーへのポインター 
  * **sealSize** シールバッファのサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)
  * [TPM2_Unseal](#function-tpm2-unseal)
  * wolfTPM2_CreatePrimary 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

シークレットのサイズは 128 バイトを超えることはできません

<a id="function-wolftpm2-computename"></a>
#### wolfTPM2_ComputeName

```
WOLFTPM_API int wolfTPM2_ComputeName(
    const TPM2B_PUBLIC * pub,
    TPM2B_NAME * out
)
```

TPM が期待する形式でオブジェクトのパブリック領域のハッシュを生成するヘルパー関数。 

**パラメータ**:

  * **pub** TPM オブジェクトの公開部分を含んだ[TPM2B_PUBLIC]()構造体へのポインター 
  * **out** 計算された名前を格納するための [TPM2B_NAME]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

計算された TPM 名には、TPM_ALG_ID のハッシュが含まれており、パブリックはオブジェクトのものです

<a id="function-wolftpm2-sensitivetoprivate"></a>
#### wolfTPM2_SensitiveToPrivate

```
WOLFTPM_API int wolfTPM2_SensitiveToPrivate(
    TPM2B_SENSITIVE * sens,
    TPM2B_PRIVATE * priv,
    TPMI_ALG_HASH nameAlg,
    TPM2B_NAME * name,
    const WOLFTPM2_KEY * parentKey,
    TPMT_SYM_DEF_OBJECT * sym,
    TPM2B_ENCRYPTED_SECRET * symSeed
)
```

 [TPM2B_SENSITIVE]() を変換するヘルパー関数。

**パラメータ**:

  * **sens** [TPM2B_SENSITIVE]() 型の正しく設定された構造体へのポインター 
  * **priv** [TPM2B_PRIVATE]() 型の空の構造体へのポインター
  * **nameAlg** TPMI_ALG_HASH 型の整数値。有効な TPM2 ハッシュ アルゴリズムを指定します 
  * **name** [TPM2B_NAME]() 構造体へのポインター 
  * **parentKey** [WOLFTPM2_KEY]() 構造体へのポインター。parentKey が存在する場合はそれを指定します 
  * **sym** TPMT_SYM_DEF_OBJECT 型の構造体へのポインター 
  * **symSeed** [TPM2B_ENCRYPTED_SECRET]() 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_ImportPrivateKey](#function-wolftpm2-importprivatekey)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-rsakey-tpmtowolf"></a>
#### wolfTPM2_RsaKey_TpmToWolf

```
WOLFTPM_API int wolfTPM2_RsaKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    RsaKey * wolfKey
)
```

RSA TPM鍵を抽出し、それを wolfcrypt 鍵に変換します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **tpmKey** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **wolfKey** 変換されたキーを格納する RsaKey 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_WolfToTpm_ex](#function-wolftpm2-rsakey-wolftotpm-ex)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-rsakey-tpmtopempub"></a>
#### wolfTPM2_RsaKey_TpmToPemPub

```
WOLFTPM_API int wolfTPM2_RsaKey_TpmToPemPub(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * keyBlob,
    byte * pem,
    word32 * pemSz
)
```

公開 RSA TPM鍵を PEM 形式の公開鍵に変換する 注: pem と tempBuf は、同じサイズの異なるバッファーである必要があります。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **keyBlob** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **pem** PEM 会話の一時ストレージとして使用される、バイト型の配列へのポインター 
  * **pemSz** 使用済みバッファサイズを格納する整数変数へのポインター


**参考**: 

  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)
  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-rsakey-wolftotpm"></a>
#### wolfTPM2_RsaKey_WolfToTpm

```
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

RSA wolfcrypt 鍵を TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **wolfKey** wolfcrypt キーを保持する RsaKey 型の構造体へのポインター 
  * **tpmKey** インポートされた TPM キーを保持するための [WOLFTPM2_KEY]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM 2.0で使用するwolfcryptによる外部生成鍵の使用を許可します

<a id="function-wolftpm2-wolftotpm-ex"></a>
#### wolfTPM2_RsaKey_WolfToTpm_ex

```
WOLFTPM_API int wolfTPM2_RsaKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    const WOLFTPM2_KEY * parentKey,
    RsaKey * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

特定のプライマリ キーまたは階層の下で RSA wolfcrypt 鍵を TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** [WOLFTPM2_KEY]() 構造体へのポインター、主キーまたは TPM 階層を指す 
  * **wolfKey** wolfcrypt キーを保持する RsaKey 型の構造体へのポインター 
  * **tpmKey** インポートされた TPM キーを保持するための [WOLFTPM2_KEY]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

wolfTPM で wolfcrypt が生成した鍵を使用できるようにします

<a id="function-wolftpm2-rsakey-pubpemtotpm"></a>
#### wolfTPM2_RsaKey_PubPemToTpm

```
WOLFTPM_API int wolfTPM2_RsaKey_PubPemToTpm(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    const byte * pem,
    word32 pemSz
)
```

PEM 形式の公開鍵をファイルから TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **tpmKey** インポートされた TPM キーを保持するための [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **pem** PEM 形式の公開鍵素材を含む、バイト型の配列へのポインター 
  * **pemSz** PEMキーデータのサイズを指定する整数変数へのポインター


**参考**: 

  * [wolfTPM2_RsaKey_WolfToTpm](#function-wolftpm2-rsakey-wolftotpm)
  * wolfTPM2_RsaKey_TpmToPem 
  * [wolfTPM2_RsaKey_TpmToWolf](#function-wolftpm2-rsakey-tpmtowolf)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと)

<a id="function-wolftpm2-ecckey-tpmtowolf"></a>
#### wolfTPM2_EccKey_TpmToWolf

```
WOLFTPM_API int wolfTPM2_EccKey_TpmToWolf(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * tpmKey,
    ecc_key * wolfKey
)
```

ECC TPM 鍵を抽出し、wolfcrypt 鍵に変換します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **tpmKey** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **wolfKey** 変換されたキーを格納するための、ecc_key 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_EccKey_WolfToTpm](#function-wolftpm2-ecckey-wolftotpm)
  * [wolfTPM2_EccKey_WolfToTpm_ex](#function-wolftpm2-ecckey-wolftotpm-ex)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-ecckey-wolftotpm"></a>
#### wolfTPM2_EccKey_WolfToTpm

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

ECC wolfcrypt 鍵を TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **wolfKey** wolfcrypt キーを保持する、ecc_key タイプの構造体へのポインター 
  * **tpmKey** インポートされた TPM キーを保持するための [WOLFTPM2_KEY]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM 2.0で使用するwolfcryptによる外部生成鍵の使用を許可します

<a id="function-wolftpm2-wolftotpm-ex"></a>
#### wolfTPM2_EccKey_WolfToTpm_ex

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToTpm_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    ecc_key * wolfKey,
    WOLFTPM2_KEY * tpmKey
)
```

ECC wolfcrypt 鍵を特定のプライマリ キーまたは階層の下の TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** [WOLFTPM2_KEY]() 構造体へのポインター、主キーまたは TPM 階層を指す 
  * **wolfKey** wolfcrypt キーを保持する、ecc_key タイプの構造体へのポインター 
  * **tpmKey** インポートされた TPM キーを保持するための [WOLFTPM2_KEY]() 型の空の構造体へのポインター


**参考**: 

  * wolfTPM2_EccKey_WolfToTPM 
  * [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

wolfTPM で wolfcrypt が生成した鍵を使用できるようにします

<a id="function-wolftpm2-ecckey-wolftopubpoint"></a>
#### wolfTPM2_EccKey_WolfToPubPoint

```
WOLFTPM_API int wolfTPM2_EccKey_WolfToPubPoint(
    WOLFTPM2_DEV * dev,
    ecc_key * wolfKey,
    TPM2B_ECC_POINT * pubPoint
)
```

wolfcrypt 鍵から生成された ECC 公開鍵を TPM にインポートします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **wolfKey** wolfcrypt 公開 ECC キーを保持する、ecc_key タイプの構造体へのポインター 
  * **pubPoint** [TPM2B_ECC_POINT]() 型の空の構造体へのポインター


**参考**: [wolfTPM2_EccKey_TpmToWolf](#function-wolftpm2-ecckey-tpmtowolf)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM 2.0 で使用する wolfcrypt によって外部で生成された公開 ECC鍵の使用を許可します

<a id="function-wolftpm2-signhash"></a>
#### wolfTPM2_SignHash

```
WOLFTPM_API int wolfTPM2_SignHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz
)
```

TPM 鍵を使用して任意のデータに署名するヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター material 
  * **digest** 任意のデータを含むバイトバッファへのポインタ 
  * **digestSz** ダイジェスト バッファのサイズをバイト単位で指定する整数値 
  * **sig** 生成された署名を含むバイトバッファへのポインター 
  * **sigSz** 署名バッファのサイズをバイト単位で指定する整数値


**参考**: 

  * verifyHash 
  * signHashScheme 
  * verifyHashScheme 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-signhashscheme"></a>
#### wolfTPM2_SignHashScheme

```
WOLFTPM_API int wolfTPM2_SignHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * digest,
    int digestSz,
    byte * sig,
    int * sigSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

TPM 鍵を使用して任意のデータに署名し、署名スキームとハッシュ アルゴリズムを指定する高度なヘルパー関数。

**パラメータ**: 

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター material 
  * **digest** 任意のデータを含むバイトバッファへのポインタ 
  * **digestSz** ダイジェスト バッファのサイズをバイト単位で指定する整数値 
  * **sig** 生成された署名を含むバイトバッファへのポインター 
  * **sigSz** 署名バッファのサイズをバイト単位で指定する整数値 
  * **sigAlg** サポートされている TPM 2.0 署名スキームを指定する TPMI_ALG_SIG_SCHEME 型の整数値 
  * **hashAlg** サポートされている TPM 2.0 ハッシュ アルゴリズムを指定する TPMI_ALG_HASH 型の整数値


**参考**: 

  * signHash 
  * verifyHash 
  * verifyHashScheme 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-verifyhash"></a>
#### wolfTPM2_VerifyHash

```
WOLFTPM_API int wolfTPM2_VerifyHash(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz
)
```

TPM が生成した署名を検証するためのヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM 2.0 キー マテリアルを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **sig** 生成された署名を含むバイトバッファへのポインター 
  * **sigSz** 署名バッファのサイズをバイト単位で指定する整数値 
  * **digest** 符号付きデータを含むバイトバッファへのポインター 
  * **digestSz** ダイジェスト バッファのサイズをバイト単位で指定する整数値


**参考**: 

  * signHash 
  * signHashScheme 
  * verifyHashScheme 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-verifyhashscheme"></a>
#### wolfTPM2_VerifyHashScheme

```
WOLFTPM_API int wolfTPM2_VerifyHashScheme(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const byte * sig,
    int sigSz,
    const byte * digest,
    int digestSz,
    TPMI_ALG_SIG_SCHEME sigAlg,
    TPMI_ALG_HASH hashAlg
)
```

TPM が生成した署名を検証するための高度なヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM 2.0 キー マテリアルを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **sig** 生成された署名を含むバイトバッファへのポインター 
  * **sigSz** 署名バッファのサイズをバイト単位で指定する整数値 
  * **digest** 符号付きデータを含むバイトバッファへのポインター 
  * **digestSz** ダイジェスト バッファのサイズをバイト単位で指定する整数値 
  * **sigAlg** サポートされている TPM 2.0 署名スキームを指定する TPMI_ALG_SIG_SCHEME 型の整数値 
  * **hashAlg** サポートされている TPM 2.0 ハッシュ アルゴリズムを指定する TPMI_ALG_HASH 型の整数値


**参考**: 

  * signHash 
  * signHashScheme 
  * verifyHash 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-ecdhgenkey"></a>
#### wolfTPM2_ECDHGenKey

```
WOLFTPM_API int wolfTPM2_ECDHGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id,
    const byte * auth,
    int authSz
)
```

Diffie-Hellman 交換用の NULL 階層を持つ ECC鍵ペアを生成してからロードします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **ecdhKey** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **curve_id** 有効な TPM_ECC_CURVE 値を指定する整数値 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-ecdhgen"></a>
#### wolfTPM2_ECDHGen

```
WOLFTPM_API int wolfTPM2_ECDHGen(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

一時鍵を生成し、Z (共有シークレット) を計算します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **privKey** [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **pubPoint** [TPM2B_ECC_POINT]() 型の空の構造体へのポインター 
  * **out** 生成された共有シークレットを格納するバイト バッファへのポインター 
  * **outSz** 共有シークレットのサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

秘密鍵ハンドルを使用して鍵ペアを生成し、公開ポイントと共有秘密を返すワンショット API

<a id="function-wolftpm2-ecdhgenz"></a>
#### wolfTPM2_ECDHGenZ

```
WOLFTPM_API int wolfTPM2_ECDHGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * privKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

pubPoint と読み込まれたプライベート ECC鍵を使用して Z (共有シークレット) を計算します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **privKey** TPM handleを格納する[WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **pubPoint** TPM2B_ECC_POINT]() 型のデータが取り込まれた構造体へのポインター 
  * **out** 計算された共有シークレットを格納するバイト バッファへのポインター 
  * **outSz** 共有シークレットのサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-ecdhgenkey"></a>
#### wolfTPM2_ECDHEGenKey

```
WOLFTPM_API int wolfTPM2_ECDHEGenKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ecdhKey,
    int curve_id
)
```

一時的な ECC鍵を生成し、配列インデックスを返します (2 フェーズ メソッド) 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **ecdhKey** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **curve_id** 有効な TPM_ECC_CURVE 値を指定する整数値


**参考**: 

  * [wolfTPM2_ECDHEGenZ](#function-wolftpm2-ecdhegenz)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

One time use key

<a id="function-wolftpm2-ecdhgenz"></a>
#### wolfTPM2_ECDHEGenZ

```
WOLFTPM_API int wolfTPM2_ECDHEGenZ(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * parentKey,
    WOLFTPM2_KEY * ecdhKey,
    const TPM2B_ECC_POINT * pubPoint,
    byte * out,
    int * outSz
)
```

pubPoint とカウンターを使用して Z (共有シークレット) を計算します (2 フェーズメソッド)

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parentKey** プライマリキーの有効な TPM ハンドルを含む [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **ecdhKey** TPM handleを格納する[WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **pubPoint** [TPM2B_ECC_POINT]() 型の空の構造体へのポインター 
  * **out** 計算された共有シークレットを格納するバイト バッファへのポインター 
  * **outSz** 共有シークレットのサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_ECDHEGenKey](#function-wolftpm2-ecdhegenkey)
  * [wolfTPM2_ECDHGen](#function-wolftpm2-ecdhgen)
  * [wolfTPM2_ECDHGenKey](#function-wolftpm2-ecdhgenkey)
  * [wolfTPM2_ECDHGenZ](#function-wolftpm2-ecdhgenz)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

カウンター、アレイ ID は 1 回だけ使用できます

<a id="function-wolftpm2-rsaencrypt"></a>
#### wolfTPM2_RsaEncrypt

```
WOLFTPM_API int wolfTPM2_RsaEncrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * msg,
    int msgSz,
    byte * out,
    int * outSz
)
```

TPM 2.0 鍵を使用して RSA 暗号化を実行します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター material 
  * **padScheme** パディング スキームを指定する、TPM_ALG_ID 型の整数値 
  * **msg** 任意のデータを含むバイトバッファへのポインタ 
  * **msgSz** 任意のデータ バッファのサイズを指定する整数値 
  * **out** 暗号化されたデータが格納されるバイトバッファへのポインター 
  * **outSz** 暗号化されたデータ バッファのサイズを指定する整数値


**参考**: 

  * [wolfTPM2_RsaDecrypt](#function-wolftpm2-rsadecrypt)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-esadecrypt"></a>
#### wolfTPM2_RsaDecrypt

```
WOLFTPM_API int wolfTPM2_RsaDecrypt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    TPM_ALG_ID padScheme,
    const byte * in,
    int inSz,
    byte * msg,
    int * msgSz
)
```

TPM 2.0 鍵を使用して RSA 復号を実行します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** TPM キーを保持する [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **padScheme** パディング スキームを指定する、TPM_ALG_ID 型の整数値 
  * **in** 暗号化されたデータを含むバイトバッファへのポインター 
  * **inSz** 暗号化されたデータ バッファのサイズを指定する整数値 
  * **msg** 復号されたデータを含むバイトバッファへのポインター 
  * **msgSz** 暗号化されたデータ バッファのサイズへのポインター。戻り時に実際のサイズが設定される


**参考**: 

  * [wolfTPM2_RsaEncrypt](#function-wolftpm2-rsaencrypt)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-readpcr"></a>
#### wolfTPM2_ReadPCR

```
WOLFTPM_API int wolfTPM2_ReadPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    byte * digest,
    int * pDigestLen
)
```

指定された TPM 2.0 プラットフォーム構成レジスタ (PCR) の値を読み取る。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **pcrIndex** 0 から 23 までの有効な PCR インデックスを指定する整数値 (TPM の局所性は、アクセスの成功に影響を与える可能性があります) 
  * **hashAlg** アクセスする TPM_ALG_SHA256 または TPM_ALG_SHA1 レジスタを指定する整数値 
  * **digest** PCR値が格納されるバイトバッファへのポインター 
  * **pDigestLen** ダイジェスト バッファのサイズが格納される整数変数へのポインター


**参考**: [wolfTPM2_ExtendPCR](#function-wolftpm2-extendpcr)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

PCR レジスタには SHA256 用と SHA1 用の 2 つのセットがあるため、正しいハッシュ アルゴリズムを指定してください (非推奨ですが、引き続き読み取ることができます)。

<a id="function-wolftpm2-extendpcr"></a>
#### wolfTPM2_ExtendPCR

```
WOLFTPM_API int wolfTPM2_ExtendPCR(
    WOLFTPM2_DEV * dev,
    int pcrIndex,
    int hashAlg,
    const byte * digest,
    int digestLen
)
```

ユーザー提供のダイジェストで PCR レジスタを拡張します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **pcrIndex** 0 から 23 までの有効な PCR インデックスを指定する整数値 (TPM の局所性は、アクセスの成功に影響を与える可能性があります) 
  * **hashAlg** アクセスする TPM_ALG_SHA256 または TPM_ALG_SHA1 レジスタを指定する整数値 
  * **digest** PCRに拡張されるダイジェスト値を含む、バイトバッファへのポインター 
  * **digestLen** ダイジェスト バッファのサイズ


**参考**: 

  * [wolfTPM2_ReadPCR](#function-wolftpm2-readpcr)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

正しいハッシュアルゴリズムを指定してください

<a id="function-wolftpm2-nvcreateauth"></a>
#### wolfTPM2_NVCreateAuth

```
WOLFTPM_API int wolfTPM2_NVCreateAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

TPM の NVRAM にデータを格納するために後で使用する新しい NV インデックスを作成します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parent** 新しいNVインデックスのTPM階層を指定する、WOLFTPM2_HANDLEへのポインター 
  * **nv** WOLFTPM2_NV]() 型の空の構造体へのポインター。新しい NV インデックスを保持します。 
  * **nvIndex** 成功時に TPM によって与えられた NV インデックス ハンドルを保持する整数値 
  * **nvAttributes** 整数値、wolfTPM2_GetNvAttributesTemplate を使用して正しい値を作成します 
  * **maxSize** この NV インデックスで書き込まれる最大バイト数を指定する整数値 
  * **auth** この NV インデックスのパスワード認証を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)
  * [wolfTPM2_NVOpen](#function-wolftpm2-nvopen)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

これは、TPM2_NV_DefineSpace の wolfTPM2 ラッパーです。

<a id="function-wolftpm2-nvwriteauth"></a>
#### wolfTPM2_NVWriteAuth

```
WOLFTPM_API int wolfTPM2_NVWriteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

指定されたオフセットで、ユーザー データを NV インデックスに格納します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **nv** [WOLFTPM2_NV]() 型のデータが取り込まれた構造体へのポインター 
  * **nvIndex** 既存の NV インデックス ハンドル値を保持する整数値 
  * **dataBuf** TPM の NVRAM に書き込まれるユーザー データを含むバイト バッファーへのポインター 
  * **dataSz** ユーザーデータバッファのサイズをバイト単位で指定する整数値 
  * **offset** NV インデックス メモリの開始点からのオフセットを指定する word32 型の整数値。ゼロの場合もあります。


**参考**: 

  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

ユーザーデータのサイズは、wolfTPM2_CreateAuth を使用して指定された NV インデックスの maxSize 以下である必要があります

<a id="function-wolftpm2-nvreadauth"></a>
#### wolfTPM2_NVReadAuth

```
WOLFTPM_API int wolfTPM2_NVReadAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    byte * dataBuf,
    word32 * pDataSz,
    word32 offset
)
```

指定されたオフセットから開始して、NV インデックスからユーザー データを読み取ります。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **nv** [WOLFTPM2_NV]() 型のデータが取り込まれた構造体へのポインター 
  * **nvIndex** 既存の NV インデックス ハンドル値を保持する整数値 
  * **dataBuf** TPM の NVRAM からの読み取りデータを格納するために使用される、空のバイト バッファーへのポインター 
  * **pDataSz** 整数変数へのポインター。NVRAM から読み取ったデータのサイズ (バイト単位) を格納するために使用されます。 
  * **offset** NV インデックス メモリの開始点からのオフセットを指定する word32 型の整数値。ゼロの場合もあります。


**参考**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

ユーザーデータのサイズは、wolfTPM2_CreateAuth を使用して指定された NV インデックスの maxSize 以下である必要があります

<a id="function-wolftpm2-nvincrement"></a>
#### wolfTPM2_NVIncrement

```
WOLFTPM_API int wolfTPM2_NVIncrement(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv
)
```

NV 一方向カウンターをインクリメントします。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **nv** [WOLFTPM2_NV]() 型のデータが取り込まれた構造体へのポインター


**参考**: 

  * [wolfTPM2_NVOpen](#function-wolftpm2-nvopen)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-nvopen"></a>
#### wolfTPM2_NVOpen

```
WOLFTPM_API int wolfTPM2_NVOpen(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_NV * nv,
    word32 nvIndex,
    const byte * auth,
    word32 authSz
)
```

NV を開き、必要な認証と名前ハッシュを入力します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **nv** WOLFTPM2_NV]() 型の空の構造体へのポインター。新しい NV インデックスを保持します。 
  * **nvIndex** 成功時に TPM によって与えられた NV インデックス ハンドルを保持する整数値 
  * **auth** この NV インデックスのパスワード認証を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_UnloadHandle](#function-wolftpm2-unloadhandle)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-nvdeleteauth"></a>
#### wolfTPM2_NVDeleteAuth

```
WOLFTPM_API int wolfTPM2_NVDeleteAuth(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * parent,
    word32 nvIndex
)
```

既存の NV インデックスを破棄します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **parent** 新しいNVインデックスのTPM階層を指定する、WOLFTPM2_HANDLEへのポインター 
  * **nvIndex** 成功時に TPM によって与えられた NV インデックス ハンドルを保持する整数値


**参考**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-nvcreate"></a>
#### wolfTPM2_NVCreate

```
WOLFTPM_API int wolfTPM2_NVCreate(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    word32 nvAttributes,
    word32 maxSize,
    const byte * auth,
    int authSz
)
```

非推奨です。新しい API を使用してください。

**参考**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)

<a id="function-wolftpm2-nvwrite"></a>
#### wolfTPM2_NVWrite

```
WOLFTPM_API int wolfTPM2_NVWrite(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 dataSz,
    word32 offset
)
```

非推奨です。新しい API を使用してください。 

**参考**: 

  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)

<a id="function-wolftpm2-nvread"></a>
#### wolfTPM2_NVRead

```
WOLFTPM_API int wolfTPM2_NVRead(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex,
    byte * dataBuf,
    word32 * dataSz,
    word32 offset
)
```

非推奨です。新しい API を使用してください。 

**参考**: 

  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)

<a id="function-wolftpm2-nvdelete"></a>
#### wolfTPM2_NVDelete

```
WOLFTPM_API int wolfTPM2_NVDelete(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE authHandle,
    word32 nvIndex
)
```

非推奨です。新しい API を使用してください。 

**参考**: 

  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)

<a id="function-wolftpm2-nvreadpublic"></a>
#### wolfTPM2_NVReadPublic

```
WOLFTPM_API int wolfTPM2_NVReadPublic(
    WOLFTPM2_DEV * dev,
    word32 nvIndex,
    TPMS_NV_PUBLIC * nvPublic
)
```

最大サイズなど、nvIndex に関する公開情報を抽出します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **nvIndex** 成功時に TPM によって与えられた NV インデックス ハンドルを保持する整数値 
  * **nvPublic** [TPMS_NV_PUBLIC]() へのポインター。抽出された nvIndex 公開情報を格納するために使用されます。


**参考**: 

  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)
  * [wolfTPM2_NVWriteAuth](#function-wolftpm2-nvwriteauth)
  * [wolfTPM2_NVReadAuth](#function-wolftpm2-nvreadauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-nvstorekey"></a>
#### wolfTPM2_NVStoreKey

```
WOLFTPM_API int wolfTPM2_NVStoreKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key,
    TPM_HANDLE persistentHandle
)
```

TPM 2.0 キーを TPM の NVRAM に格納するヘルパー関数。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **primaryHandle** TPM 2.0 階層を指定する整数値。 通常は TPM_RH_OWNER 
  * **key** [WOLFTPM2_KEY]() 型の構造体へのポインター。格納用の TPM 2.0 キーを含みます 
  * **persistentHandle** 既存の nvIndex を指定する整数値


**参考**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-nvdeletekey"></a>
#### wolfTPM2_NVDeleteKey

```
WOLFTPM_API int wolfTPM2_NVDeleteKey(
    WOLFTPM2_DEV * dev,
    TPM_HANDLE primaryHandle,
    WOLFTPM2_KEY * key
)
```

TPM の NVRAM から TPM 2.0 鍵を削除するヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **primaryHandle** TPM 2.0 階層を指定する整数値。 通常は TPM_RH_OWNER 
  * **key** nvIndex ハンドル値を含む [WOLFTPM2_KEY]() 型の構造体へのポインター


**参考**: 

  * [wolfTPM2_NVDeleteKey](#function-wolftpm2-nvdeletekey)
  * [wolfTPM2_NVCreateAuth](#function-wolftpm2-nvcreateauth)
  * [wolfTPM2_NVDeleteAuth](#function-wolftpm2-nvdeleteauth)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getrng"></a>
#### wolfTPM2_GetRng

```
WOLFTPM_API struct WC_RNG * wolfTPM2_GetRng(
    WOLFTPM2_DEV * dev
)
```

wolfTPM に使用される wolfcrypt RNG インスタンスを取得します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター


**参考**: 

  * [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

wolfcrypt が有効で、TPM RNG の代わりに使用するように構成されている場合のみ

<a id="function-wolftpm2-getrandom"></a>
#### wolfTPM2_GetRandom

```
WOLFTPM_API int wolfTPM2_GetRandom(
    WOLFTPM2_DEV * dev,
    byte * buf,
    word32 len
)
```

TPM RNG または wolfcrypt RNG で生成された一連の乱数を取得します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **buf** 生成された乱数を格納するために使用されるバイトバッファへのポインター 
  * **len** バッファーのサイズ (バイト単位) を格納するために使用される word32 型の整数値


**参考**: 

  * [wolfTPM2_GetRandom](#function-wolftpm2-getrandom)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM RNG ソースを使用するように WOLFTPM2_USE_HW_RNG を定義します。

<a id="function-wolftpm2-unloadhandle"></a>
#### wolfTPM2_UnloadHandle

```
WOLFTPM_API int wolfTPM2_UnloadHandle(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HANDLE * handle
)
```

TPM がロードされたオブジェクトを破棄するために使用します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **handle** 有効な TPM 2.0 ハンドル値を持つ WOLFTPM2_HANDLE タイプの構造体へのポインター


**参考**: 

* [wolfTPM2_Clear](#function-wolftpm2-clear)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-clear"></a>
#### wolfTPM2_Clear

```
WOLFTPM_API int wolfTPM2_Clear(
    WOLFTPM2_DEV * dev
)
```

wolfTPM と wolfcrypt を初期化解除します (有効な場合) 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター


**参考**: 

* [wolfTPM2_Clear](#function-wolftpm2-clear)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-hashstart"></a>
#### wolfTPM2_HashStart

```
WOLFTPM_API int wolfTPM2_HashStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    TPMI_ALG_HASH hashAlg,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

TPM で生成されたハッシュを開始するヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hash** [WOLFTPM2_HASH]() 構造体へのポインター 
  * **hashAlg** 有効な TPM 2.0 ハッシュ アルゴリズムを指定する整数値 
  * **usageAuth** ハッシュを後で使用するための承認を指定する文字列定数へのポインター 
  * **usageAuthSz** i承認のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-hashupdate"></a>
#### wolfTPM2_HashUpdate

```
WOLFTPM_API int wolfTPM2_HashUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    const byte * data,
    word32 dataSz
)
```

TPM で生成されたハッシュを新しいユーザー データで更新します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hash** [WOLFTPM2_HASH]() 構造体へのポインター 
  * **data** ハッシュに追加されるユーザーデータを含むバイトバッファーへのポインター 
  * **dataSz** ユーザーデータのサイズをバイト単位で指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashFinish](#function-wolftpm2-hashfinish)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

認証が正しく設定されていることを確認してください

<a id="function-wolftpm2-hashfinish"></a>
#### wolfTPM2_HashFinish

```
WOLFTPM_API int wolfTPM2_HashFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HASH * hash,
    byte * digest,
    word32 * digestSz
)
```

TPM で生成されたハッシュをファイナライズし、ユーザー バッファーでダイジェスト出力を取得します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hash** [WOLFTPM2_HASH]() 構造体へのポインター 
  * **digest** 結果のダイジェストを格納するために使用されるバイトバッファへのポインター 
  * **digestSz** ダイジェスト バッファーのサイズへのポインター。返されると、ダイジェスト バッファーに格納されているバイト数に設定されます。


**参考**: 

  * [wolfTPM2_HashStart](#function-wolftpm2-hashstart)
  * [wolfTPM2_HashUpdate](#function-wolftpm2-hashupdate)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

認証が正しく設定されていることを確認してください

<a id="function-wolftpm2-loadkeyhashkey"></a>
#### wolfTPM2_LoadKeyedHashKey

```
WOLFTPM_API int wolfTPM2_LoadKeyedHashKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    WOLFTPM2_HANDLE * parent,
    int hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

通常は HMAC 操作に使用される、KeyedHash 型の新しい TPM 鍵を作成して読み込みます。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** 生成される鍵を格納するための[WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **parent** プライマリキーの有効な TPM ハンドルを含む [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **hashAlg** 有効な TPM 2.0 ハッシュ アルゴリズムを指定する整数値 
  * **keyBuf** 新しい KeyedHash キーの派生値を含むバイト配列へのポインター 
  * **keySz** keyBuf に格納される派生値のサイズをバイト単位で指定する整数値 
  * **usageAuth** 新しいキーの承認を指定する文字列定数へのポインター 
  * **usageAuthSz** i承認のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM を使用して HMAC を生成するには、wolfTPM2_Hmac ラッパーを使用することをお勧めします。

<a id="function-wolftpm2-hmacstart"></a>
#### wolfTPM2_HmacStart

```
WOLFTPM_API int wolfTPM2_HmacStart(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    WOLFTPM2_HANDLE * parent,
    TPMI_ALG_HASH hashAlg,
    const byte * keyBuf,
    word32 keySz,
    const byte * usageAuth,
    word32 usageAuthSz
)
```

TPM で生成された hmac を開始するヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hmac** [WOLFTPM2_HMAC]() 構造体へのポインター 
  * **parent** プライマリキーの有効な TPM ハンドルを含む [WOLFTPM2_KEY]() 型の構造体へのポインター 
  * **hashAlg** 有効な TPM 2.0 ハッシュ アルゴリズムを指定する整数値 
  * **keyBuf** 新しい KeyedHash キーの派生値を含むバイト配列へのポインター 
  * **keySz** keyBuf に格納される派生値のサイズをバイト単位で指定する整数値 
  * **usageAuth** 文字列定数へのポインター。後で hmac を使用するための承認を指定します。 
  * **usageAuthSz** i承認のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)
  * [wolfTPM2_HmacFinish](#function-wolftpm2-hmacfinish)
  * [wolfTPM2_LoadKeyedHashKey](#function-wolftpm2-loadkeyedhashkey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-hmacupdate"></a>
#### wolfTPM2_HmacUpdate

```
WOLFTPM_API int wolfTPM2_HmacUpdate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    const byte * data,
    word32 dataSz
)
```

TPM で生成された hmac を新しいユーザー データで更新します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hmac** [WOLFTPM2_HMAC]() 構造体へのポインター 
  * **data** hmac に追加されるユーザー データを含むバイト バッファーへのポインター 
  * **dataSz** ユーザーデータのサイズをバイト単位で指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * wolfTPM2_HMACFinish 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM認証が正しく設定されていることを確認してください

<a id="function-wolftpm2-hmacfinish"></a>
#### wolfTPM2_HmacFinish

```
WOLFTPM_API int wolfTPM2_HmacFinish(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_HMAC * hmac,
    byte * digest,
    word32 * digestSz
)
```

TPM で生成された hmac をファイナライズし、ユーザー バッファーでダイジェスト出力を取得します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **hmac** [WOLFTPM2_HMAC]() 構造体へのポインター 
  * **digest** 結果の hmac ダイジェストを格納するために使用されるバイト バッファへのポインター 
  * **digestSz** ダイジェストのサイズをバイト単位で指定する word32 型の整数値


**参考**: 

  * [wolfTPM2_HmacStart](#function-wolftpm2-hmacstart)
  * [wolfTPM2_HmacUpdate](#function-wolftpm2-hmacupdate)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

TPM認証が正しく設定されていることを確認してください

<a id="function-wolftpm2-loadsymmetrickey"></a>
#### wolfTPM2_LoadSymmetricKey

```
WOLFTPM_API int wolfTPM2_LoadSymmetricKey(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    int alg,
    const byte * keyBuf,
    word32 keySz
)
```

外部の対称鍵を TPM にロードします。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 型の空の構造体へのポインター 
  * **alg** 有効な TPM 2.0 対称キー アルゴリズム（ AES CFB の TPM_ALG_CFB）を指定する整数値。 
  * **keyBuf** 対称鍵の秘密情報を含むバイト配列へのポインター 
  * **keySz** eyBuf に格納されているキー マテリアルのサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_EncryptDecryptBlock](#function-wolftpm2-encryptdecryptblock)
  * [wolfTPM2_EncryptDecrypt](#function-wolftpm2-encryptdecrypt)
  * [TPM2_EncryptDecrypt2](#function-tpm2-encryptdecrypt2)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-setcommand"></a>
#### wolfTPM2_SetCommand

```
WOLFTPM_API int wolfTPM2_SetCommand(
    WOLFTPM2_DEV * dev,
    TPM_CC commandCode,
    int enableFlag
)
```

他の制限付き TPM コマンドを有効にするために使用される、ベンダー固有の TPM コマンド。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **commandCode** 有効なベンダー コマンドを表す整数値 
  * **enableFlag** 整数値、ゼロ以外の値は「有効にする」ことを表します


**参考**: [TPM2_GPIO_Config](#function-tpm2-gpio-config)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-shutdown"></a>
#### wolfTPM2_Shutdown

```
WOLFTPM_API int wolfTPM2_Shutdown(
    WOLFTPM2_DEV * dev,
    int doStartup
)
```

TPM をシャットダウンまたはリセットするためのヘルパー関数。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **doStartup** 整数値、ゼロ以外の値は「シャットダウン後にスタートアップを実行する」ことを表します


**参考**: [wolfTPM2_Init](#function-wolftpm2-init)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

doStartup が設定されている場合、TPM2_Shutdown の直後に TPM2_Startup が実行されます。

<a id="function-wolftpm2-unloadhandles"></a>
#### wolfTPM2_UnloadHandles

```
WOLFTPM_API int wolfTPM2_UnloadHandles(
    WOLFTPM2_DEV * dev,
    word32 handleStart,
    word32 handleCount
)
```

後続の TPM ハンドルをアンロードするためのワンショット API。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **handleStart** 最初の TPM ハンドルの値を指定する word32 型の整数値 
  * **handleCount** ハンドル数を指定する word32 型の整数値


**参考**: [wolfTPM2_Init](#function-wolftpm2-init)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-alltransient"></a>
#### wolfTPM2_UnloadHandles_AllTransient

```
WOLFTPM_API int wolfTPM2_UnloadHandles_AllTransient(
    WOLFTPM2_DEV * dev
)
```

すべての一時的な TPM ハンドルをアンロードするためのワンショット API。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター


**参考**: 

  * [wolfTPM2_UnloadHandles](#function-wolftpm2-unloadhandles)
  * wolfTPM2_CreatePrimary 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

プライマリキーが一時オブジェクトとして存在する場合、TPM鍵を使用する前にそれらを再作成する必要があります

<a id="function-wolftpm2-getkeytemplate-rsa"></a>
#### wolfTPM2_GetKeyTemplate_RSA

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes
)
```

ユーザーが選択したオブジェクト属性に基づいて、新しい RSA 鍵の TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** [TPMT_PUBLIC]() 型の空の構造体へのポインター。新しい RSA テンプレートを格納します。 
  * **objectAttributes** TPMA_OBJECT タイプの整数値。1 つ以上の属性（TPMA_OBJECT_fixedTPM等）を含めることができます。 


**参考**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-ecc"></a>
#### wolfTPM2_GetKeyTemplate_ECC

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC(
    TPMT_PUBLIC * publicTemplate,
    TPMA_OBJECT objectAttributes,
    TPM_ECC_CURVE curve,
    TPM_ALG_ID sigScheme
)
```

ユーザーが選択したオブジェクト属性に基づいて、新しい ECC 鍵の TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** [TPMT_PUBLIC]() 型の空の構造体へのポインター。新しい ECC キー テンプレートを格納します。 
  * **objectAttributes** TPMA_OBJECT タイプの整数値。1 つ以上の属性（TPMA_OBJECT_fixedTPM等）を含めることができます。  
  * **curve** TPM_ECC_CURVE タイプの整数値。TPM がサポートする ECC 曲線 ID を指定します。 
  * **sigScheme** TPM_ALG_ID 型の整数値。TPM がサポートする署名方式を指定します。


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-symmetric"></a>
#### wolfTPM2_GetKeyTemplate_Symmetric

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_Symmetric(
    TPMT_PUBLIC * publicTemplate,
    int keyBits,
    TPM_ALG_ID algMode,
    int isSign,
    int isDecrypt
)
```

新しい対称鍵の TPM パブリック テンプレートを準備します。

**パラメータ**:

  * **publicTemplate** [TPMT_PUBLIC]() 型の空の構造体へのポインター。新しい対称キー テンプレートを格納します。 
  * **keyBits** 整数値。対称キーのサイズを指定します。通常は 128 ビットまたは 256 ビットです。 
  * **algMode** TPM_ALG_ID 型の整数値。TPM がサポートする対称アルゴリズム（AES CFB の TPM_ALG_CFB）を指定します。  
  * **isSign** 整数値、ゼロ以外の値は「署名鍵」を表します 
  * **isDecrypt** 整数値、ゼロ以外の値は「復号鍵」を表します


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-keyedhash"></a>
#### wolfTPM2_GetKeyTemplate_KeyedHash

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeyedHash(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID hashAlg,
    int isSign,
    int isDecrypt
)
```

新しい KeyedHash 鍵の TPM パブリック テンプレートを準備します。

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター 
  * **hashAlg** TPM_ALG_ID 型の整数値。TPM がサポートするハッシュ アルゴリズム（SHA 256 の場合は TPM_ALG_SHA256）を指定します。  
  * **isSign** 整数値、ゼロ以外の値は「署名鍵」を表します 
  * **isDecrypt** 整数値、ゼロ以外の値は「復号鍵」を表します


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA](#function-wolftpm2-getkeytemplate-rsa)
  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-keyseal"></a>
#### wolfTPM2_GetKeyTemplate_KeySeal

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_KeySeal(
    TPMT_PUBLIC * publicTemplate,
    TPM_ALG_ID nameAlg
)
```

シークレットを封印するための新しい鍵の TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター 
  * **nameAlg** TPM_ALG_ID 型の整数値。TPM がサポートするハッシュ アルゴリズム（SHA 256 の場合は TPM_ALG_SHA256）を指定します。


**参考**: 

  * [wolfTPM2_GetKeyTemplate_ECC](#function-wolftpm2-getkeytemplate-ecc)
  * [wolfTPM2_GetKeyTemplate_Symmetric](#function-wolftpm2-getkeytemplate-symmetric)
  * [wolfTPM2_GetKeyTemplate_KeyedHash](#function-wolftpm2-getkeytemplate-keyedhash)
  * [wolfTPM2_GetKeyTemplate_KeySeal](#function-wolftpm2-getkeytemplate-keyseal)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

鍵封印には厳しい要件があるため、ほとんどの鍵パラメータはラッパーによって事前に決定されます。

<a id="function-wolftpm2-getkeytemplate-rsa-ek"></a>
#### wolfTPM2_GetKeyTemplate_RSA_EK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_EK(
    TPMT_PUBLIC * publicTemplate
)
```

RSA タイプの TPM 承認鍵を生成するための TPM 公開テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-ecc-ek"></a>
#### wolfTPM2_GetKeyTemplate_ECC_EK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_EK(
    TPMT_PUBLIC * publicTemplate
)
```

ECC タイプの TPM 承認鍵を生成するための TPM 公開テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-ras-srk"></a>
#### wolfTPM2_GetKeyTemplate_RSA_SRK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

RSA タイプの新しい TPM ストレージ 鍵を生成するための TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-ecc-srk"></a>
#### wolfTPM2_GetKeyTemplate_ECC_SRK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_SRK(
    TPMT_PUBLIC * publicTemplate
)
```

ECC タイプの新しい TPM ストレージ 鍵を生成するための TPM パブリック テンプレートを準備します。

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-rsa-aik"></a>
#### wolfTPM2_GetKeyTemplate_RSA_AIK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_RSA_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

RSA タイプの新しい TPM Attestation Key を生成するための TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeytemplate-ecc-aik"></a>
#### wolfTPM2_GetKeyTemplate_ECC_AIK

```
WOLFTPM_API int wolfTPM2_GetKeyTemplate_ECC_AIK(
    TPMT_PUBLIC * publicTemplate
)
```

ECC タイプの新しい TPM Attestation Key を生成するための TPM パブリック テンプレートを準備します。 

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-setkeytemplate-unique"></a>
#### wolfTPM2_SetKeyTemplate_Unique

```
WOLFTPM_API int wolfTPM2_SetKeyTemplate_Unique(
    TPMT_PUBLIC * publicTemplate,
    const byte * unique,
    int uniqueSz
)
```

Create または CreatePrimary で使用されるパブリック テンプレートの一意の領域を設定します。

**パラメータ**:

  * **publicTemplate** 新しいテンプレートを格納する [TPMT_PUBLIC]() 型の空の構造体へのポインター 
  * **unique** パブリック テンプレートの一意の領域を設定するためのバッファーへのオプションのポインター。 NULL の場合、バッファはゼロ化されます。 
  * **uniqueSz** 一意のフィールドを埋めるサイズ。 ゼロの場合、キー サイズが使用されます。


**参考**: 

  * [wolfTPM2_CreateKey](#function-wolftpm2-createkey)
  * [wolfTPM2_CreatePrimaryKey](#function-wolftpm2-createprimarykey)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getnvattributestemplate"></a>
#### wolfTPM2_GetNvAttributesTemplate

```
WOLFTPM_API int wolfTPM2_GetNvAttributesTemplate(
    TPM_HANDLE auth,
    word32 * nvAttributes
)
```

TPM NV インデックス テンプレートを準備します。 

**パラメータ**:

  * **auth** 新しい TPM NV インデックスが作成される TPM 階層を表す整数値 
  * **nvAttributes** NV 属性を格納するための空の整数変数へのポインター


**参考**: 

  * wolfTPM2_CreateAuth 
  * wolfTPM2_WriteAuth 
  * wolfTPM2_ReadAuth 
  * wolfTPM2_DeleteAuth 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-createek"></a>
#### wolfTPM2_CreateEK

```
WOLFTPM_API int wolfTPM2_CreateEK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * ekKey,
    TPM_ALG_ID alg
)
```

ユーザーが選択したアルゴリズム、RSA または ECC に基づいて、新しい TPM 承認キーを生成します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **ekKey** 新しい EK に関する情報を格納するための空の [WOLFTPM2_KEY]() 構造体へのポインター 
  * **alg** TPM_ALG_RSA または TPM_ALG_ECC のみを指定できます。上記の注を参照してください


**参考**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

EK に使用できるのは RSA と ECC のみですが、TPM で対称鍵を作成して使用できます

<a id="function-wolftpm2-createsrk"></a>
#### wolfTPM2_CreateSRK

```
WOLFTPM_API int wolfTPM2_CreateSRK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * srkKey,
    TPM_ALG_ID alg,
    const byte * auth,
    int authSz
)
```

他の TPM キーのストレージ キーとして使用される新しい TPM プライマリ キーを生成します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **srkKey** 新しい EK に関する情報を格納するための空の [WOLFTPM2_KEY]() 構造体へのポインター 
  * **alg** TPM_ALG_RSA または TPM_ALG_ECC のみを指定できます。上記の注を参照してください 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_CreateEK](#function-wolftpm2-createek)
  * [wolfTPM2_CreateAndLoadAIK](#function-wolftpm2-createandloadaik)
  * [wolfTPM2_GetKeyTemplate_RSA_SRK](#function-wolftpm2-getkeytemplate-rsa-srk)
  * [wolfTPM2_GetKeyTemplate_ECC_SRK](#function-wolftpm2-getkeytemplate-ecc-srk)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

EK に使用できるのは RSA と ECC のみですが、TPM で対称鍵を作成して使用できます

<a id="function-wolftpm2-createandloadaik"></a>
#### wolfTPM2_CreateAndLoadAIK

```
WOLFTPM_API int wolfTPM2_CreateAndLoadAIK(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * aikKey,
    TPM_ALG_ID alg,
    WOLFTPM2_KEY * srkKey,
    const byte * auth,
    int authSz
)
```

指定されたストレージ鍵の下に新しい TPM 構成証明鍵を生成します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **aikKey** 新しく生成された TPM キーを格納するための空の [WOLFTPM2_KEY]() 構造体へのポインター 
  * **alg** TPM_ALG_RSA または TPM_ALG_ECC のみを指定できます 
  * **srkKey** [WOLFTPM2_KEY]() 構造体へのポインター。ロードされたストレージ キーの有効な TPM ハンドルを指します。 
  * **auth** TPM 2.0 キーのパスワード承認を指定する文字列定数へのポインター 
  * **authSz** パスワード認証のサイズをバイト単位で指定する整数値


**参考**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_AIK](#function-wolftpm2-getkeytemplate-rsa-aik)
  * [wolfTPM2_GetKeyTemplate_ECC_AIK](#function-wolftpm2-getkeytemplate-ecc-aik)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-gettime"></a>
#### wolfTPM2_GetTime

```
WOLFTPM_API int wolfTPM2_GetTime(
    WOLFTPM2_KEY * aikKey,
    GetTime_Out * getTimeOut
)
```

TPM 署名付きタイムスタンプを生成するワンショット API。 

**パラメータ**:

  * **aikKey** [WOLFTPM2_KEY]() 構造体へのポインター。ロードされた認証キーの有効な TPM ハンドルを含みます 
  * **getTimeOut** コマンドの出力を格納するための [GetTime_Out]() 型の空の構造体へのポインター


**参考**: 

  * [wolfTPM2_CreateSRK](#function-wolftpm2-createsrk)
  * [wolfTPM2_GetKeyTemplate_RSA_EK](#function-wolftpm2-getkeytemplate-rsa-ek)
  * [wolfTPM2_GetKeyTemplate_ECC_EK](#function-wolftpm2-getkeytemplate-ecc-ek)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数


**ノート**: 

この呼び出しの前に、構成証明鍵を生成してロードする必要があります

<a id="function-wolftpm2-setcustomext"></a>
#### wolfTPM2_CSR_SetCustomExt

```
WOLFTPM_API int wolfTPM2_CSR_SetCustomExt(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CSR * csr,
    int critical,
    const char * oid,
    const byte * der,
    word32 derSz
)
```

WOLFTPM2_CSR 構造体のカスタム要求拡張 oid と値の使用を設定する証明書署名要求 (CSR) 生成のヘルパー。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター (not used) 
  * **csr** [WOLFTPM2_CSR]() 構造体へのポインター 
  * **critical** 0 の場合、拡張機能はクリティカルとマークされません。それ以外の場合、クリティカルとマークされます。 
  * **oid** 文字列としてのドット区切りの oid。 たとえば、「1.2.840.10045.3.1.7」 
  * **der** 拡張子のコンテンツの der エンコーディング 
  * **derSz** der エンコーディングのバイト単位のサイズ


**参考**: 

  * [wolfTPM2_CSR_SetSubject](#function-wolftpm2-csr-setsubject)
  * [wolfTPM2_CSR_SetKeyUsage](#function-wolftpm2-csr-setkeyusage)
  * [wolfTPM2_CSR_MakeAndSign](#function-wolftpm2-csr-makeandsign)
  * [wolfTPM2_CSR_MakeAndSign_ex](#function-wolftpm2-csr-makeandsign-ex)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-cst-setkeyusage"></a>
#### wolfTPM2_CSR_SetKeyUsage

```
WOLFTPM_API int wolfTPM2_CSR_SetKeyUsage(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CSR * csr,
    const char * keyUsage
)
```

WOLFTPM2_CSR 構造のキー使用法を設定する証明書署名要求 (CSR) 生成のヘルパー。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター (not used) 
  * **csr** [WOLFTPM2_CSR]() 構造体へのポインター 
  * **keyUsage** コンマ区切りのキー使用属性の文字列リスト。 可能な値: any、serverAuth、clientAuth、codeSigning、emailProtection、timeStamping、および OCSPSigning デフォルト: "serverAuth,clientAuth,codeSigning"


**参考**: 

  * [wolfTPM2_CSR_SetSubject](#function-wolftpm2-csr-setsubject)
  * [wolfTPM2_CSR_SetCustomExt](#function-wolftpm2-csr-setcustomext)
  * [wolfTPM2_CSR_MakeAndSign](#function-wolftpm2-csr-makeandsign)
  * [wolfTPM2_CSR_MakeAndSign_ex](#function-wolftpm2-csr-makeandsign-ex)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-csr-setsubject"></a>
#### wolfTPM2_CSR_SetSubject

```
WOLFTPM_API int wolfTPM2_CSR_SetSubject(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CSR * csr,
    const char * subject
)
```

WOLFTPM2_CSR 構造体のサブジェクトを設定する証明書署名要求 (CSR) 生成のヘルパー。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター (not used) 
  * **csr** [WOLFTPM2_CSR]() 構造体へのポインター 
  * **subject** /CN= 構文を使用した識別名文字列。 例: "/C=US/ST=Washington/L=Seattle/O=wolfSSL/OU=Development/CN=www.wolfssl.com/emailAddress=info@wolfssl.com"


**参考**: 

  * [wolfTPM2_CSR_SetKeyUsage](#function-wolftpm2-csr-setkeyusage)
  * [wolfTPM2_CSR_SetCustomExt](#function-wolftpm2-csr-setcustomext)
  * [wolfTPM2_CSR_MakeAndSign](#function-wolftpm2-csr-makeandsign)
  * [wolfTPM2_CSR_MakeAndSign_ex](#function-wolftpm2-csr-makeandsign-ex)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-csr-makeandsign-ex"></a>
#### wolfTPM2_CSR_MakeAndSign_ex

```
WOLFTPM_API int wolfTPM2_CSR_MakeAndSign_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CSR * csr,
    WOLFTPM2_KEY * key,
    int outFormat,
    byte * out,
    int outSz,
    int sigType,
    int selfSignCert,
    int devId
)
```

TPM ベースの鍵 (件名と鍵の使用法が既に設定されている WOLFTPM2_KEY 構造) を使用した証明書署名要求 (CSR) 生成のヘルパー。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **csr** [WOLFTPM2_CSR]() 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 構造体へのポインター 
  * **outFormat** WOLFSSL_FILETYPE_ASN1 または WOLFSSL_FILETYPE_PEM 
  * **out** ASN.1/DER または PEM としての CSR の宛先バッファ 
  * **outSz** 宛先バッファの最大サイズ 
  * **sigType** keyType (CTC_SHA256wRSA または CTC_SHA256wECDSA) に基づいて SHA2-256 を自動的に選択するには、0 を使用します。 可能な値のリストについては、wolfCrypt の「enum Ctc_SigType」を参照してください。 
  * **selfSignCert** 1 (ゼロ以外) に設定すると、結果は自己署名証明書になります。 ゼロ (0) は、CA によって使用される CSR (証明書署名要求) を生成します。 
  * **devId** 暗号コールバックの登録時に使用されるデバイス識別子。 INVALID_DEVID (-2) を使用して、必要な暗号化コールバックを自動的に登録します。


**参考**: 

  * [wolfTPM2_CSR_SetSubject](#function-wolftpm2-csr-setsubject)
  * [wolfTPM2_CSR_SetKeyUsage](#function-wolftpm2-csr-setkeyusage)
  * [wolfTPM2_CSR_SetCustomExt](#function-wolftpm2-csr-setcustomext)
  * [wolfTPM2_CSR_MakeAndSign](#function-wolftpm2-csr-makeandsign)


**戻り値**:

  * Success: 正の整数 (出力のサイズ) 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-csr-makeandsign"></a>
#### wolfTPM2_CSR_MakeAndSign

```
WOLFTPM_API int wolfTPM2_CSR_MakeAndSign(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_CSR * csr,
    WOLFTPM2_KEY * key,
    int outFormat,
    byte * out,
    int outSz
)
```

TPM ベースの鍵 (件名と鍵の使用法が既に設定されている WOLFTPM2_KEY 構造) を使用した証明書署名要求 (CSR) 生成のヘルパー。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **csr** [WOLFTPM2_CSR]() 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 構造体へのポインター 
  * **outFormat** WOLFSSL_FILETYPE_ASN1 または WOLFSSL_FILETYPE_PEM 
  * **out** ASN.1/DER または PEM としての CSR の宛先バッファ 
  * **outSz** 宛先バッファの最大サイズ


**参考**: 

  * [wolfTPM2_CSR_SetSubject](#function-wolftpm2-csr-setsubject)
  * [wolfTPM2_CSR_SetKeyUsage](#function-wolftpm2-csr-setkeyusage)
  * [wolfTPM2_CSR_SetCustomExt](#function-wolftpm2-csr-setcustomext)
  * [wolfTPM2_CSR_MakeAndSign_ex](#function-wolftpm2-csr-makeandsign-ex)


**戻り値**:

  * Success: 正の整数 (出力のサイズ) 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-csr-generate-ex"></a>
#### wolfTPM2_CSR_Generate_ex

```
WOLFTPM_API int wolfTPM2_CSR_Generate_ex(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const char * subject,
    const char * keyUsage,
    int outFormat,
    byte * out,
    int outSz,
    int sigType,
    int selfSignCert,
    int devId
)
```

TPM ベースの鍵 (WOLFTPM2_KEY) を使用した証明書署名要求 (CSR) 生成のヘルパー。 TPM鍵に基づいて CSR または自己署名証明書を出力するためのシングル ショット API。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** [WOLFTPM2_KEY]() 構造体へのポインター 
  * **subject** /CN= 構文を使用した識別名文字列。 例: "/C=US/ST=Washington/L=Seattle/O=wolfSSL/OU=Development/CN=www.wolfssl.com/emailAddress=info@wolfssl.com" 
  * **keyUsage** コンマ区切りのキー使用属性の文字列リスト。 可能な値: any、serverAuth、clientAuth、codeSigning、emailProtection、timeStamping、および OCSPSigning デフォルト: "serverAuth,clientAuth,codeSigning" 
  * **outFormat** WOLFSSL_FILETYPE_ASN1 または WOLFSSL_FILETYPE_PEM 
  * **out** ASN.1/DER または PEM としての CSR の宛先バッファ 
  * **outSz** 宛先バッファの最大サイズ 
  * **sigType** keyType (CTC_SHA256wRSA または CTC_SHA256wECDSA) に基づいて SHA2-256 を自動的に選択するには、0 を使用します。 可能な値のリストについては、wolfCrypt の「enum Ctc_SigType」を参照してください。 
  * **selfSignCert** 1 (ゼロ以外) に設定すると、結果は自己署名証明書になります。 ゼロ (0) は、CA によって使用される CSR (証明書署名要求) を生成します。 
  * **devId** 暗号コールバックの登録時に使用されるデバイス識別子。 INVALID_DEVID (-2) を使用して、必要な暗号化コールバックを自動的に登録します。


**参考**: 

  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)
  * [wolfTPM2_CSR_Generate](#function-wolftpm2-csr-generate)


**戻り値**:

  * Success: 正の整数 (出力のサイズ) 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-csr-generate"></a>
#### wolfTPM2_CSR_Generate

```
WOLFTPM_API int wolfTPM2_CSR_Generate(
    WOLFTPM2_DEV * dev,
    WOLFTPM2_KEY * key,
    const char * subject,
    const char * keyUsage,
    int outFormat,
    byte * out,
    int outSz
)
```

TPM ベースの鍵 (WOLFTPM2_KEY) を使用した証明書署名要求 (CSR) 生成のヘルパー。 TPM鍵に基づいて CSR または自己署名証明書を出力するためのシングル ショット API。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **key** pointer to a loaded [WOLFTPM2_KEY]() 構造体へのポインター 
  * **subject** /CN= 構文を使用した識別名文字列。 例: "/C=US/ST=Washington/L=Seattle/O=wolfSSL/OU=Development/CN=www.wolfssl.com/emailAddress=info@wolfssl.com" 
  * **keyUsage** コンマ区切りのキー使用属性の文字列リスト。 可能な値: any、serverAuth、clientAuth、codeSigning、emailProtection、timeStamping、および OCSPSigning デフォルト: "serverAuth,clientAuth,codeSigning" 
  * **outFormat** WOLFSSL_FILETYPE_ASN1 または WOLFSSL_FILETYPE_PEM 
  * **out** ASN.1/DER または PEM としての CSR の宛先バッファ 
  * **outSz** 宛先バッファの最大サイズ


**参考**: 

  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)
  * [wolfTPM2_CSR_Generate_ex](#function-wolftpm2-csr-generate-ex)


**戻り値**:

  * Success: 正の整数 (出力のサイズ) 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-cryptodevcb"></a>
#### wolfTPM2_CryptoDevCb

```
WOLFTPM_API int wolfTPM2_CryptoDevCb(
    int devId,
    wc_CryptoInfo * info,
    void * ctx
)
```

クリプトオフロードに TPM を使用するためのリファレンス クリプト コールバック API。 このコールバック関数は、wolfTPM2_SetCryptoDevCb または wc_CryptoDev_RegisterDevice を使用して登録されます。 

**パラメータ**:

  * **devId** コールバックの登録時に使用される devId。 INVALID_DEVID 以外の符号付き整数値 
  * **info** 暗号タイプとパラメーターに関する詳細情報を含む wc_CryptoInfo 構造を指す 
  * **ctx** コールバックが wolfTPM2_SetCryptoDevCb に登録されたときに提供されたユーザー コンテキスト


**参考**: 

  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * CRYPTOCB_UNAVAILABLE: TPM ハードウェアを使用せず、デフォルトのソフトウェア暗号にフォールバックします。 
  * WC_HW_E: 一般的なハードウェア障害

<a id="function-wolftpm2-setcryptodevcb"></a>
#### wolfTPM2_SetCryptoDevCb

```
WOLFTPM_API int wolfTPM2_SetCryptoDevCb(
    WOLFTPM2_DEV * dev,
    CryptoDevCallbackFunc cb,
    TpmCryptoDevCtx * tpmCtx,
    int * pDevId
)
```

暗号コールバック関数を登録し、割り当てられた devId を返します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **cb** wolfTPM2_CryptoDevCb API はテンプレートですが、独自のものを提供することもできます 
  * **tpmCtx** ユーザー指定のコンテキスト。 wolfTPM2_CryptoDevCb には [TpmCryptoDevCtx]() を使用しますが、独自のものにすることもできます。 
  * **pDevId** 自動的に割り当てられたデバイス ID へのポインター


**参考**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_ClearCryptoDevCb](#function-wolftpm2-clearcryptodevcb)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-clearcryptodevcb"></a>
#### wolfTPM2_ClearCryptoDevCb

```
WOLFTPM_API int wolfTPM2_ClearCryptoDevCb(
    WOLFTPM2_DEV * dev,
    int devId
)
```

登録された暗号コールバックをクリアします。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **devId** コールバックの登録時に使用される devId


**参考**: 

  * [wolfTPM2_CryptoDevCb](#function-wolftpm2-cryptodevcb)
  * [wolfTPM2_SetCryptoDevCb](#function-wolftpm2-setcryptodevcb)


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * TPM_RC_FAILURE: 一般的なエラー (TPM IO と TPM リターンコードを確認のこと) 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-new"></a>
#### wolfTPM2_New

```
WOLFTPM_API WOLFTPM2_DEV * wolfTPM2_New(
    void 
)
```

[WOLFTPM2_DEV]()を割り当てて初期化します。 

**参考**: 

  * [wolfTPM2_Free](#function-wolftpm2-free)

**戻り値**:

  * 新しいデバイス構造体へのポインター 
  * NULL: エラー時

<a id="function-wolftpm2-free"></a>
#### wolfTPM2_Free

```
WOLFTPM_API int wolfTPM2_Free(
    WOLFTPM2_DEV * dev
)
```

wolfTPM2_New によって割り当てられた WOLFTPM2_DEV をクリーンアップして解放します。 

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター


**参考**: 

  * [wolfTPM2_New](#function-wolftpm2-new)

**戻り値**:

  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-newkeyblob"></a>
#### wolfTPM2_NewKeyBlob

```
WOLFTPM_API WOLFTPM2_KEYBLOB * wolfTPM2_NewKeyBlob(
    void 
)
```

WOLFTPM2_KEYBLOB を割り当てて初期化します。

**参考**: 

  * [wolfTPM2_FreeKeyBlob](#function-wolftpm2-freekeyblob)

**戻り値**:

  * 新しく初期化されたポインタ [WOLFTPM2_KEYBLOB]()
  * エラーの場合は NULL

<a id="function-wolftpm2-freekeyblob"></a>
#### wolfTPM2_FreeKeyBlob

```
WOLFTPM_API int wolfTPM2_FreeKeyBlob(
    WOLFTPM2_KEYBLOB * blob
)
```

wolfTPM2_NewKeyBlob で割り当てられた WOLFTPM2_KEYBLOB を解放します。 

**パラメータ**:

  * **blob** wolfTPM2_NewKeyBlob によって割り当てられた [WOLFTPM2_KEYBLOB]() へのポインター


**参考**: 

  * [wolfTPM2_NewKeyBlob](#function-wolftpm2-newkeyblob)

**戻り値**:
  
  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-newpublictemplate"></a>
#### wolfTPM2_NewPublicTemplate

```
WOLFTPM_API TPMT_PUBLIC * wolfTPM2_NewPublicTemplate(
    void 
)
```

TPMT_PUBLIC構造体を割り当てて初期化します。

**参考**: 

  * [wolfTPM2_FreePublicTemplate](#function-wolftpm2-freepublictemplate)

**戻り値**:

  * 新しく初期化されたポインタ 
  * エラーの場合は NULL

<a id="function-wolftpm2-freepublictemplate"></a>
#### wolfTPM2_FreePublicTemplate

```
WOLFTPM_API int wolfTPM2_FreePublicTemplate(
    TPMT_PUBLIC * PublicTemplate
)
```

wolfTPM2_NewPublicTemplate で割り当てられた TPMT_PUBLIC を解放します。

**パラメータ**:

  * **PublicTemplate** wolfTPM2_NewPublicTemplate で割り当てられた [TPMT_PUBLIC]() へのポインター


**参考**: 

  * [wolfTPM2_NewPublicTemplate](#function-wolftpm2-newpublictemplate)

**戻り値**:

  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-newkey"></a>
#### wolfTPM2_NewKey

```
WOLFTPM_API WOLFTPM2_KEY * wolfTPM2_NewKey(
    void 
)
```

WOLFTPM2_KEY を割り当てて初期化します。 

**参考**: 

  * [wolfTPM2_FreeKey](#function-wolftpm2-freekey)

**戻り値**:

  * 新しく初期化されたポインタ [WOLFTPM2_KEY]()
  * エラーの場合は NULL

<a id="function-wolftpm2-freekey"></a>
#### wolfTPM2_FreeKey

```
WOLFTPM_API int wolfTPM2_FreeKey(
    WOLFTPM2_KEY * key
)
```

wolfTPM2_NewKey で割り当てられた WOLFTPM2_KEY を解放します。 

**パラメータ**:

  * **key** wolfTPM2_NewKey によって割り当てられた [WOLFTPM2_KEY]() へのポインター


**参考**: 

  * [wolfTPM2_NewKey](#function-wolftpm2-newkey)

**戻り値**:

  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-newsession"></a>
#### wolfTPM2_NewSession

```
WOLFTPM_API WOLFTPM2_SESSION * wolfTPM2_NewSession(
    void 
)
```

WOLFTPM2_SESSION を割り当てて初期化します。 

**参考**: 

  * [wolfTPM2_FreeSession](#function-wolftpm2-freesession)

**戻り値**:

  * 新しく初期化されたポインタ [WOLFTPM2_SESSION]()
  * エラーの場合は NULL

<a id="function-wolftpm2-freesession"></a>
#### wolfTPM2_FreeSession

```
WOLFTPM_API int wolfTPM2_FreeSession(
    WOLFTPM2_SESSION * session
)
```

wolfTPM2_NewSession で割り当てられた WOLFTPM2_SESSION を解放します。 

**パラメータ**:

  * **blob** wolfTPM2_NewSession によって割り当てられた [WOLFTPM2_KEYBLOB]() へのポインター


**参考**: 

  * [wolfTPM2_NewSession](#function-wolftpm2-newsession)

**戻り値**:

  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-newcsr"></a>
#### wolfTPM2_NewCSR

```
WOLFTPM_API WOLFTPM2_CSR * wolfTPM2_NewCSR(
    void 
)
```

WOLFTPM2_CSR を割り当てて初期化します。

**参考**: 

  * [wolfTPM2_FreeCSR](#function-wolftpm2-freecsr)

**戻り値**:

  * 新しく初期化されたポインタ [WOLFTPM2_CSR]()
  * エラーの場合は NULL

<a id="function-wolftpm2-freecsr"></a>
#### wolfTPM2_FreeCSR

```
WOLFTPM_API int wolfTPM2_FreeCSR(
    WOLFTPM2_CSR * csr
)
```

wolfTPM2_NewCSR で割り当てられた WOLFTPM2_CSR を解放します。

**パラメータ**:

  * **blob** wolfTPM2_NewCSR によって割り当てられた [WOLFTPM2_CSR]() へのポインター


**参考**: 

  * [wolfTPM2_NewCSR](#function-wolftpm2-newcsr)

**戻り値**:

  * TPM_RC_SUCCESS: 成功

<a id="function-wolftpm2-gethandlereffromkey"></a>
#### wolfTPM2_GetHandleRefFromKey

```
WOLFTPM_API WOLFTPM2_HANDLE * wolfTPM2_GetHandleRefFromKey(
    WOLFTPM2_KEY * key
)
```

WOLFTPM2_KEY から WOLFTPM2_HANDLE を取得します。

**パラメータ**:

  * **key** [WOLFTPM2_KEY]() 構造体へのポインター 


**戻り値**:

  * 鍵構造体内のハンドルへのポインター 
  * キーポインタが NULL の場合は NULL

<a id="function-wolftpm2-gethandlereffromkeyblob"></a>
#### wolfTPM2_GetHandleRefFromKeyBlob

```
WOLFTPM_API WOLFTPM2_HANDLE * wolfTPM2_GetHandleRefFromKeyBlob(
    WOLFTPM2_KEYBLOB * keyBlob
)
```

WOLFTPM2_KEYBLOB から WOLFTPM2_HANDLE を取得します。

**パラメータ**:

  * **key** [WOLFTPM2_KEYBLOB]() 構造体へのポインター 


**戻り値**:

  * キー blob 構造体で内のハンドルへのポインター 
  * キーポインタが NULL の場合は NULL

<a id="function-wolftpm2-gethandlereffromsession"></a>
#### wolfTPM2_GetHandleRefFromSession

```
WOLFTPM_API WOLFTPM2_HANDLE * wolfTPM2_GetHandleRefFromSession(
    WOLFTPM2_SESSION * session
)
```

WOLFTPM2_SESSION から WOLFTPM2_HANDLE を取得します。

**パラメータ**:

  * **key** pointer to a [WOLFTPM2_SESSION]() struct 


**戻り値**:

  * セッション構造体内のハンドルへのポインター 
  * キーポインタが NULL の場合は NULL

<a id="function-wolftpm2-gethandlevalue"></a>
#### wolfTPM2_GetHandleValue

```
WOLFTPM_API TPM_HANDLE wolfTPM2_GetHandleValue(
    WOLFTPM2_HANDLE * handle
)
```

WOLFTPM2_HANDLE から 32 ビットのハンドル値を取得します。 

**パラメータ**:

  * **handle** WOLFTPM2_HANDLE 構造体へのポインター 


**戻り値**:

  * TPM_HANDLE値

<a id="function-wolftpm2-setkeyauthpassword"></a>
#### wolfTPM2_SetKeyAuthPassword

```
WOLFTPM_API int wolfTPM2_SetKeyAuthPassword(
    WOLFTPM2_KEY * key,
    const byte * auth,
    int authSz
)
```

鍵の認証データを設定します。

**パラメータ**:

  * **dev** TPM2_DEV 構造体へのポインター 
  * **auth** 認証データへのポインター 
  * **authSz** 認証データの長さ (バイト単位) 


**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-getkeyblobasbuffer"></a>
#### wolfTPM2_GetKeyBlobAsBuffer

```
WOLFTPM_API int wolfTPM2_GetKeyBlobAsBuffer(
    byte * buffer,
    word32 bufferSz,
    WOLFTPM2_KEYBLOB * key
)
```

キーブロブからバイナリ バッファーにデータをマーシャリングします。 これは、別のプロセスでロードするため、または電源の再投入後にディスクに保存できます。 

**パラメータ**:

  * **buffer** マーシャリングされたキーブロブを格納するバッファへのポインター 
  * **bufferSz** 上記のバッファのサイズ 
  * **key** マーシャリングするキーブロブへのポインター


**参考**: 

  * [wolfTPM2_SetKeyBlobFromBuffer](#function-wolftpm2-setkeyblobfrombuffer)

**戻り値**:

  * 正の整数 (出力のサイズ) 
  * BUFFER_E: 提供されたバッファに十分なスペースがありません 
  * BAD_FUNC_ARG: 不正な引数

<a id="function-wolftpm2-setkeyblobfrombuffer"></a>
#### wolfTPM2_SetKeyBlobFromBuffer

```
WOLFTPM_API int wolfTPM2_SetKeyBlobFromBuffer(
    WOLFTPM2_KEYBLOB * key,
    byte * buffer,
    word32 bufferSz
)
```

データを WOLFTPM2_KEYBLOB 構造体にアンマーシャリングします。 これは、wolfTPM2_GetKeyBlobAsBuffer によって以前にマーシャリングされたキーブロブをロードするために使用できます。 

**パラメータ**:

  * **key** データをロードしてアンマーシャリングするキーブロブへのポインター 
  * **buffer** ロード元のマーシャリングされたキーブロブを含むバッファへのポインター 
  * **bufferSz** 上記のバッファのサイズ


**参考**: 

  * [wolfTPM2_GetKeyBlobAsBuffer](#function-wolftpm2-getkeyblobasbuffer)

**戻り値**:

  * TPM_RC_SUCCESS: 成功 
  * BUFFER_E: バッファーが小さすぎるか、非整列化されていない余分なデータが残っています 
  * BAD_FUNC_ARG: 不正な引数






-------------------------------

