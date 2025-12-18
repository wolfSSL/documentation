# よくある質問

## バージョンX.X.X.Xで検証したにも関わらず、`wolfSSL_Y.Y.Y_commercial-fips-OE-v2.7z`が届きました。

**例**

バージョン4.5.4を使用して検証しましたが、`wolfssl-4.8.1-commercial-fips-ARMv8-A-v2`を受け取りました。
なぜ4.8.1リリースが届いたのでしょうか。

**回答**

検証に使用したバージョン（例では4.5.4）は、wolfCryptモジュールのみに適用されるためです。

内部では適切なwolfCryptモジュール（例ではv4.5.4）を使用し続けながら、
機能拡張と不具合修正のため、wolfSSLバージョン（例では4.8.1）は更新されます。
ご質問がございましたら、[support@wolfssl.com](mailto:support@wolfssl.com)へお問い合わせください。

## どのようにしてFIPSモジュールを使用していることを確認できますか。

**回答**

cert 3389の場合はFIPSユーザーガイド、cert 2425の場合はセキュリティポリシーのビルド手順に従ってください。
実行時には、`wolfCrypt_GetStatus_fips()`のようなfipsにのみ存在するAPIを呼び出してください。

**参考**：`-v2`で終わるすべてのFIPSバンドルには、wolfssl-rootに`v4.1.0.-SP-and-user-guide`のようなディレクトリが付属し、そのFIPSモジュールバージョンのセキュリティポリシーとユーザーガイドの.pdfコピーが含まれています。

## 電源投入時自己テスト(POST)は、必ず毎回実行する必要がありますか。

* アプリが再起動するときにも必要でしょうか。
* 個々のプロセス/アプリケーションごとに必要でしょうか。
* デバイスの電源サイクルに応じて必要でしょうか。

**回答**

はい、上記に示した例を含むあらゆる状況において必要です。
POSTをスキップできる例外はありません。
これはNISTが求めている要件です。
詳細は <https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Module-Validation-Program/documents/fips140-2/FIPS1402IG.pdf> のセクション「9.10 Power-Up Tests for Software Module Libraries」をご参照ください。
一部を以下に引用しています。

注：「Shall」は「例外なし」を意味します。

```
AS09.08: (Levels 1, 2, 3 and 4) Power-up tests shall be performed by a
cryptographic module when the module is powered up (after being
powered off, reset, rebooted, etc.).

AS09.09: (Levels 1, 2, 3 and 4) The power-up tests shall be initiated
automatically and shall not require operator intervention.

TE.09.09.02: The tester shall power-up the module and verify that the
module performs the power-up self-tests without requiring any operator
intervention.
```

### 関連: `NO_ATTRIBUTE_CONSTRUCTOR`機能でも同様でしょうか。コンストラクタで実行しないことで、POSTをバイパスできますか。

**回答**

この機能をオンにすると（コンパイル時エラーが発生しないと仮定して）、モジュールは即座にFIPS準拠でなくなります。

1. この機能が有効になると、オペレーティングシステム自体を変更して再コンパイルし、OSが暗号モジュールを使用する新しいプロセス/アプリケーション/モジュールを開始するとき、またはOSが電源サイクル後初回ブート時に、wolfCryptモジュールの`fipsEntry()`関数への呼び出しを追加する必要があります。

2. この機能はPOSTをスキップまたはオプションにするためのものではなく、RNGが初期化された後、またはメモリゼロ（POST結果を消去する）が完了した後にOSによってPOSTを呼び出すことを可能にします。
`fipsEntry()`への呼び出しは、前述のご質問に対する回答で引用しているTE.09.09.02に従って、オペレーターの制御外のまま（オプションではない）であることが求められています。

### 関連: `NO_ATTRIBUTE_CONSTRUCTOR`機能の目的は何でしょうか。

**回答**

2つの例外ケースに対応するためです。

1. 1つ目は、OSがアプリケーション開始時にメモリを0埋めし、POST結果（合格/不合格）を消去してしまう場合です。
この場合、POSTはメモリ初期化を完了した後に呼び出される必要があります。
FIPS準拠を維持するには、この呼び出しがオプションではなく、トリガーするためにオペレーターの介入を必要としないことをCMVPに証明する必要があります。
（ユーザー空間のアプリケーションまたはカーネルモジュールに制御が戻される前に、OSによって呼び出される必要があります。）

2. 2つ目は、エントロピーソースが`attribute constructor`で利用できない場合です。
この場合、最初にRNGを初期化してから`fipsEntry()`への呼び出しを行う必要があります。
こちらも、この呼び出しがオプションではなく、トリガーするためにオペレーターの介入を必要としないことをCMVPに証明する必要があります。
（ユーザー空間のアプリケーションまたはカーネルモジュールに制御が戻される前に、OSによって呼び出される必要があります。）

### 関連: `NO_ATTRIBUTE_CONSTRUCTOR`が許可されるタイミングは、誰が決定できますか。

**回答**

OE運用テスト作業中に、NVLAP認定FIPSラボと連携するwolfSSLスタッフのみが、`NO_ATTRIBUTE_CONSTRUCTOR`機能の使用有無を決定できます。
特定のOperation Environmentでこの機能が必要な場合、次のようになります。

1. そのOperation EnvironmentのFIPSユーザーガイドセクションに記載されます。

2. wolfSSLから顧客が受け取るバンドルリリースは、機能を有効にしてクリーンにビルドされます（コンパイル時エラーなし）。

3. モジュールのデフォルト設定でこの設定がオンになります。

### 関連: FIPS Ready版でも同様でしょうか。FIPS Ready版では`NO_ATTRIBUTE_CONSTRUCTOR`を使用できますか。

**回答**

「FIPS Ready」は、モジュールがすべてのFIPS要件に従っており、変更なしでCMVPに提出してFIPS認定を取得できる状態であることを意味します。
wolfSSLスタッフとNVLAP認定FIPSラボによる承認なしに`NO_ATTRIBUTE_CONSTRUCTOR`機能を使用することは、FIPS ReadyソリューションがもはやFIPS Readyリリースではないことを意味します。
wolfSSLスタッフがNVLAP認定FIPSラボと連携してレビューするまで、そのリリースは「FIPS Ready」とは見なされません。

## 基本的なテストの後に、エンドユーザー環境でどのような問題が発生する可能性がありますか。

**回答**

順にご説明します。

1. 破損・故障により、整合性テストが失敗する可能性があります。

2. 電源投入時自己テストが失敗する可能性があります。
	1. これは初期テスト後では非常に起こりにくいです。
	2. バイナリを受信した顧客が、PAAに対して間違ったハードウェアを使用している事例がありました。
	3. 正しいハードウェアを使用しているものの、PAA機能（AES-NI）がエンドポイントシステムのBIOS設定で工場出荷時に無効になっていた事例がありました。
	このケースでは、エンドユーザーがBIOS設定に入ってチップ上のAES-NI機能を有効にすることで、PAAを持つFIPSモジュールがシステムでSegmentation Faultしないようにする必要がありました。
	4. Windows: コンピューターでASLR（アドレス空間レイアウトランダム化）テストが有効になっている事例がありました。
	これはつまりOSが「FIPSモジュールを分割してメモリ内に散在させ」、それでも整合性ハッシュが同じ値となることを期待する状況です。
	これは実現できません。
	FIPSモジュールを使用するPCではASLRを全体的に無効にするか、FIPSモジュールを使用するアプリ/プログラムでASLRを無効にしてください。
	5. Windows: Windows OSでのランダム化ベースアドレス指定がなされている事例がありました。
	整合性チェックには関数アドレスも含まれるため、モジュールは毎回メモリ内の同じ場所にロードされる必要があります。

	これを解決するには、2つの手順が必要です。

	1. プロジェクトレベルでランダムベースアドレスを無効にする必要があります。

	例：<https://github.com/wolfSSL/wolfssl/blob/master/IDE/WIN10/wolfssl-fips.vcxproj#L159>

	2. システム上の他のDLLと競合しない物理的な固定アドレス（これが重要です）を割り当てる必要があります。

	例：<https://github.com/wolfSSL/wolfssl/blob/master/IDE/WIN10/wolfssl-fips.vcxproj#L158>

	**注意**：システム上の他のDLLと競合するアドレスが選択された場合、ランダムベースアドレスがfalseに設定されていても、OSは自動的にランダムベースアドレスの割り当てを許可します。

	**参考**：ベースアドレスを選択する際アドレス空間の中でより高い位置を使用することで、他のDLLと競合する可能性が低くなります。

3. 接続が長時間持続する場合、DRBG継続性/ヘルスチェックが失敗する可能性があります。
   1. wolfSSLは、（最大でも）24時間または48時間に少なくとも1回は、持続している接続をシャットダウンして新しいハンドシェイクを実行することを強く推奨します。
   2. これは一般的に優れたセキュリティプラクティスです。
   3. 8〜10分ごとに一時的鍵を再ネゴシエートすることが理想的です。
   （完全なシャットダウンと、接続を再確立するための新しいハンドシェイクを実行します。）

## FIPS 140-2から140-3では、どのような変更点がありましたか。

1. 3DESのサポートが削除されました。
3DESに依存するユースケースをアプリケーションから削除する必要があります。
2. すべてのアプリケーションは、140-3モジュールのFIPSモードで`wc_SetSeed_Cb`を呼び出す必要があります。
これはモジュールの問題を警告し、整合性チェックの更新が必要な場合にハッシュを出力するFIPSコールバックを設定した後の最初の項目である必要があります。

```c
/* 従前より使用しているコールバック呼び出し */
wolfCrypt_SetCb_fips(myFipsCb);

/* 代わりにwolfSSL_Init()または同等のAPIを呼び出すことで、
 * デフォルトでシードコールバックがセットアップされます。
 */
+#ifdef WC_RNG_SEED_CB
+   wc_SetSeed_Cb(wc_GenerateSeed);
+#endif
```

1. これはエントロピーに関する変更があったためです。
外部からロードされたエントロピーは明示的である必要があり、すべてのエントロピーソースはESV（エントロピーソース検証）スタンドアロンで検証されます。
FIPSモジュールは新しいSubmissionにおいて、エントロピー要求を実行することが許可されなくなりました。
	1. CMVPは同じエントロピーソースを複数回にわたって再検証する手間を削減したいと考えていました。
	このアイデアは、エントロピーソースが1回検証され、多くのFIPSモジュールがそのエントロピーソースを呼び出し、エントロピー要求のために1つのESV証明書を指すことができるというものです。
2. 弊社では、ESV検証済みエントロピーソースの1つを呼び出したい場合に利用可能なオプションも求めていたため、コールバックオプションが理にかなっていました。

## FIPS 140-2モジュールにリンクされているアプリケーションは、140-3モジュールでも動作するでしょうか。

**回答**

はい。
3DESサービスを除いて、wolfCrypt FIPSモジュールv2.x（cert #3389、140-2モジュール）は、wolfCrypt FIPSモジュールv5.2.1（cert #4718、140-3モジュール）と100％のAPI互換性があります。
140-2 APIに加えて、新しいサービス（TLS KDF、AES-OFB等）とより新しい拡張APIがあります。
140-3モジュールでサポートされる新しいサービスと新しいAPI定義の完全なリストについては、FIPS 140-3ユーザーガイドをご参照ください。
なお、このガイドはリクエストに応じてご提供しています。
ご希望の方は、[support@wolfssl.com](mailto:support@wolfssl.com)宛にご連絡ください。

## `wc_SetSeed_Cb()`コールバックとTLSレイヤー

ユーザー提供のシードルーチンをTLSレイヤーと併用する場合、`wc_SetSeed_Cb(user_seed_function)`は`wolfSSL_Init()`の後、アプリケーションが`wolfSSL_CTX_new()`を呼び出す前に実行する必要があります。

実装例

```c
/* FIPS環境の先頭に配置してください */
wolfCrypt_SetCb_fips(myFipsCb);
wolfSSL_Init();
wc_SetSeed_Cb(seedCb);
wolfSSL_CTX_new(&ctx);
...
```

潜在的なバグを避けるため、上記の代わりにマクロ`#define CUSTOM_RAND_GENERATE`を使用し、独自のカスタムRNGシード生成コールバックを登録することもできます。

`wc_SetSeed_Cb()`に依存しないカスタムシード生成設定の例

```c
extern unsigned int my_rng_seed_gen(void);
#undef CUSTOM_RAND_GENERATE
#define CUSTOM_RAND_GENERATE my_rng_seed_gen
/* アプリケーションレベルにおけるmy_rng_seed_gen()実装 */
```

## POST

FIPS 140-2において、POSTは「Power On Self Test」を意味していました。
すべてのアルゴリズム自己テストを実行するため、電源投入/ブート時間が遅くなっていました。

FIPS 140-3では、POSTは「Pre-Operational Self Test」を意味します。
モジュールの整合性チェック（および、整合性チェックをサポートするための最低限の自己テスト）のみを実行します。
具体的には、HMAC-SHA2-256自己テストが最初に実行され、その後整合性チェックが実行されます。
FIPS 140-3では、この段階で他の自己テストは実行されません。

## すべての`CAST()`のスレッドに関する考慮事項

スレッドで初めてCASTを呼び出すか、スレッドでサービスを初めて使用することでCASTを自動実行させると、別のスレッドが並行して同じCASTを実行しようとした場合に「`FIPS_CAST_STATE_PROCESSING`」エラーが発生する可能性があります。
このエラーは別のスレッドがCASTを積極的に実行していることを意味し、モジュールはDegradedモードに入ります。

Degradedモードからの唯一の回復方法は、モジュールの電源サイクルまたは整合性テストを再実行し、モジュールのリロード/電源サイクルをシミュレートすることです。
モジュールのリロードまたは電源サイクルをシミュレートするには、すべてのスレッドをシャットダウンしてから`wolfCrypt_IntegrityTest_fips()`を呼び出し、再度スレッドを開始します。

この問題を避けるには、起動時に他のFIPS固有イニシャライザーとともに`wc_RunAllCast_fips()`を呼び出します。

例：

```c
wolfCrypt_SetCb_fips(myFipsCb);

/* Alternatively call wolfSSL_Init() or comparable API
 * that sets up the seed callback by default
 */
#ifdef WC_RNG_SEED_CB
   wc_SetSeed_Cb(wc_GenerateSeed);
#endif

wc_RunAllCast_fips();
```

CASTが少なくとも1回実行されると、サービスが使用されるときに自動的にトリガーされなくなります。
アプリケーションは必要に応じて任意の時間にCASTを呼び出す（定期的にCASTが正しく終了することをチェックする）ことができますが、CASTが実行されている間のスレッド競合を避けるため、常にスレッドセーフな方法で行う必要があります。

別の方法は、パフォーマンス/ブート時間の考慮でCASTのサブセットを避けたい場合に、スレッドで使用される任意のアルゴリズムの個別のCASTを（最低限）実行することです。
CAST IDは以下の通りです。

* FIPS_CAST_AES_CBC
* FIPS_CAST_AES_GCM
* FIPS_CAST_HMAC_SHA1
* FIPS_CAST_HMAC_SHA2_256
* FIPS_CAST_HMAC_SHA2_512
* FIPS_CAST_HMAC_SHA3_256
* FIPS_CAST_DRBG
* FIPS_CAST_RSA_SIGN_PKCS1v15
* FIPS_CAST_ECC_CDH
* FIPS_CAST_ECC_PRIMITIVE_Z
* FIPS CAST_DH_PRIMITIVE_Z
* FIPS_CAST_ECDSA
* FIPS_CAST_KDF_TLS12
* FIPS_CAST_KDF_TLS13
* FIPS_CAST_KDF_SSH

例：

```c
wolfCrypt_SetCb_fips(myFipsCb);

/* Alternatively call wolfSSL_Init() or comparable API */
#ifdef WC_RNG_SEED_CB
   wc_SetSeed_Cb(wc_GenerateSeed);
#endif

/* Running just one CAST by ID */
if (wc_RunCast_fips(FIPS_CAST_RSA_SIGN_PKCS1v15) != 0){
    err_sys("RSA PKCS v1.5 CAST failed");
}
```

## `wc_SetSeedCb()`は少し特殊です

`wc_SetSeed_Cb()`はDRBGの最初のオペレーショナル使用であり、そのためコールバックが初めて設定されるときにCASTが実行されます。
CASTでの競合状態を避けるため、ユーザーはスレッドごとではなく起動時に1回シードコールバックを設定します。
あるいは、グローバルに1回設定してからスレッドが起動するまでにCASTが通過していれば、スレッドごとに1回実行することも可能です。
これは、スレッドAがエントロピーソースAを必要とし、スレッドBが異なるエントロピーソースを使用するシナリオ用です。
`wolfSSL_Init()`を呼び出すとシードコールバックが設定されるため、最初にグローバルで少なくとも1回呼び出されない限り、スレッドごとに呼び出すべきではないことにご注意ください。
スレッドごとに設定する場合のベストプラクティスは以下の通りです。

```c
int main(void) {
	int ret;

	/* always call first */
	wolfCrypt_SetCb_fips(fipsCb);

	/* alternatively just call wolfSSL_Init() or equivalent function such as wolfMikey_Init() */
#ifdef WC_RNG_SEED_CB
	{
		ret = wc_SetSeed_Cb(wc_GenerateSeed);
		if (ret != 0) {
			printf("wc_SetSeed_Cb failed with %d, %s\n",
				ret,
				wc_GetErrorString(ret));
		}
	}
#endif
}
```

戻り値をチェックすることで、関数はスレッドが開始する前にブロックし、DRBGを消費するスレッドの前にCASTが完了することにより発生する競合状態を避けることができます。

## 鍵アクセス管理

1. wolfSSL（SSL/TLS）APIのみを使用するユーザーは、この項目について心配する必要はありません。

2. 秘密鍵の読み込みや使用のためにアプリケーションからwolfCrypt API（wc_XXX）を直接使用するユーザーは、はじめに以下の関数を呼び出してこれを許可する必要があります。

```c
wolfCrypt_SetPrivateKeyReadEnable_fips(1, WC_KEYTYPE_ALL)
```

	秘密鍵の読み込みや初回アクセスの前に実行する必要があります。

3. 鍵操作が完了したら、ユーザーは **必ず** 次を呼び出す必要があります。

```c
wolfCrypt_SetPrivateKeyReadEnable_fips(0, WC_KEYTYPE_ALL)
```

	これにより、鍵へのアクセスを再度ロックします。

4. 次のヘッダファイルをインクルードすることで、上記の長いAPI呼び出しをより短いマクロで置き換えることもできます。

```c
<wolfssl/wolfcrypt/types.h>
PRIVATE_KEY_UNLOCK()
PRIVATE_KEY_LOCK()
```

鍵アクセス管理は、以下のどちらかのスタイルで使用できます。
厳格に管理したい場合には後者が適しています。

(a) オプションで起動時に1回だけアンロック\*し、シャットダウン前に再度ロック\*\*する。

(b) 秘密鍵のロードまたは使用を含む、各呼び出しの直前と直後でアンロック・再ロックする。

\* ロックとアンロックは**スレッドローカル**であることにご注意ください。
これはセマフォであり、各アンロックは適切にロックカウントをデクリメントするために、同じスコープで対応するロックとペアにする必要があります。
代替的に「true lock」（以下に実装例を提示しています）を行うことが、適切なロック管理にとって最良のアプローチかもしれません。

\*\* 「アプリケーションは**終了前に再度ロックしなければならない**」- これはドキュメント要件であり、実行時にエラーや終了防止によって強制されるものではありません。
ただし終了前に鍵アクセスを再ロックしないと、アプリケーションは「FIPS準拠ではない」状態となります。

```c
/* true_lockはスコープに関係なく、常にロックカウンタを0に減らします。 */
static inline int true_lock(void)
{
	int i;
	int lockStatus = wolfCrypt_GetPrivateKeyReadEnable_fips(WC_KEYTYPE_ALL);
#ifdef VERBOSE_LOGGING
	printf("lockStatus (pre-loop) is %d\n", lockStatus);
#endif
	for (i = lockStatus; i > 0; i--) {
		wolfCrypt_SetPrivateKeyReadEnable_fips(0, WC_KEYTYPE_ALL);
		lockStatus = wolfCrypt_GetPrivateKeyReadEnable_fips(WC_KEYTYPE_ALL);
#ifdef VERBOSE_LOGGING
		printf("lockStatus (loop %d) is %d\n", i, lockStatus);
#endif
	}
	return lockStatus;
}
...
	if (true_lock() != 0) {
		printf("true_lock failed to lock\n");
		return error_code;
	}
```

5. アプリケーションをwolfSSL FIPS版・非FIPS版の両方にリンクできるようにするために、アプリケーションでは次のような処理を実装できます。
これにより、非FIPS版ではロック・アンロック処理を正常にスキップできるようになります。

```c
#if !defined(PRIVATE_KEY_LOCK) && !defined(PRIVATE_KEY_UNLOCK)
	#define PRIVATE_KEY_LOCK() do {} while (0)
	#define PRIVATE_KEY_UNLOCK() do {} while (0)
#endif
```

### 使用前にアンロック、使用後に再ロックが必要なAPIリスト

```
* wc_PRF
* wc_PRF_TLSv12
* wc_HKDF_Extract
* wc_HKDF_Extract_ex
* wc_HKDF_Expand
* wc_HKDF_Expand_ex
* wc_HKDF
* wc_Tls13_HKDF_Extract
* wc_Tls13_HKDF_Extract_ex
* wc_Tls13_HKDF_Expand_Label
* wc_Tls13_HKDF_Expand_Label_ex
* wc_SSH_KDF
* wc_RsaExportKey
* wc_ecc_export_x963
* wc_ecc_export_ex
* wc_ecc_export_private_only
* wc_ecc_export_private_raw
* wc_ecc_export_x963_ex
* wc_ecc_shared_secret
* wc_ecc_shared_secret_ex
* wc_DhGenerateKeyPair
* wc_DhAgree
* wc_SRTP_KDF
* wc_SRTCP_KDF
* wc_SRTCP_KDF_ex
* wc_SRTP_KDF_label
* wc_SRTCP_KDF_label
* wc_ed25519_export_private_only
* wc_ed25519_export_private
* wc_ed25519_export_key
* wc_ed448_export_private_only
* wc_ed448_export_private
* wc_ed448_export_key
* wc_PBKDF2_ex
* wc_PBKDF2
```
