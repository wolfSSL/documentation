# 始めましょう

wolfTPM ライブラリには、wolfTPM のインストールが成功すると、すぐに使用できるようになる TPM 2.0 ラッパー テスト、ネイティブ テスト、およびサンプル ベンチマーク アプリケーションが含まれています。 以下に、サンプル アプリケーションを実行する方法について説明します。

これらのアプリケーションを実行しているハードウェア プラットフォームとインターフェイスするには、`tpm_io.c` 内の関数 `TPM2_IoCb` を参照してください。


## サンプルプログラム

これらのサンプルプログラムは、TPM 2.0 モジュールの機能をデモンストレーションしています。<br>

またサンプルプログラムは、`./examples/tpm_test.h` で定義されたハンドルを使用して、テスト用に NV に RSA および ECC鍵を作成します。<br>

PKCS #7 と TLS のサンプルプログラムでは、CSR を生成し、テスト スクリプトを使用して署名する必要があります。 以下の CSR と証明書の署名を参照してください。<br>

パラメータの暗号化を有効にするには、AES-CFB モードの場合は"`-aes`"を使用し、XOR モードの場合は"`-xor"`を使用します。 一部の TPM コマンド/応答のみがパラメーターの暗号化をサポートします。 TPM2_ API に .flags "`CMD_FLAG_ENC2"` または "`CMD_FLAG_DEC2"` が設定されている場合、コマンドはパラメーターの暗号化/復号を使用します。<br>

ST33 および NPCT75x の TPM 2.0 追加 GPIO のサンプルプログラムなど、ベンダー固有のサンプルプログラムがいくつかあります。<br>


### ネイティブAPIのテスト

ネイティブ TPM2_* API の呼び出しを示します。<br>


```
./examples/native/native_test
TPM2 Demo using Native API's
TPM2: Caps 0x30000495, Did 0x0000, Vid 0x104a, Rid 0x4e
TPM2_Startup pass
TPM2_SelfTest pass
TPM2_GetTestResult: Size 12, Rc 0x0
TPM2_IncrementalSelfTest: Rc 0x0, Alg 0x1 (Todo 0)
TPM2_GetCapability: Property FamilyIndicator 0x322e3000
TPM2_GetCapability: Property PCR Count 24
TPM2_GetCapability: Property FIRMWARE_VERSION_1 0x004a0008
TPM2_GetCapability: Property FIRMWARE_VERSION_2 0x44a01587
TPM2_GetRandom: Got 32 bytes
TPM2_StirRandom: success
TPM2_PCR_Read: Index 0, Count 1
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 1, Count 1
TPM2_PCR_Read: Index 1, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 2, Count 1
TPM2_PCR_Read: Index 2, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 3, Count 1
TPM2_PCR_Read: Index 3, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 4, Count 1
TPM2_PCR_Read: Index 4, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 5, Count 1
TPM2_PCR_Read: Index 5, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 6, Count 1
TPM2_PCR_Read: Index 6, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 7, Count 1
TPM2_PCR_Read: Index 7, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 8, Count 1
TPM2_PCR_Read: Index 8, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 9, Count 1
TPM2_PCR_Read: Index 9, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 10, Count 1
TPM2_PCR_Read: Index 10, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 11, Count 1
TPM2_PCR_Read: Index 11, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 12, Count 1
TPM2_PCR_Read: Index 12, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 13, Count 1
TPM2_PCR_Read: Index 13, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 14, Count 1
TPM2_PCR_Read: Index 14, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 15, Count 1
TPM2_PCR_Read: Index 15, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 16, Count 1
TPM2_PCR_Read: Index 16, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 17, Count 1
TPM2_PCR_Read: Index 17, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 18, Count 1
TPM2_PCR_Read: Index 18, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 19, Count 1
TPM2_PCR_Read: Index 19, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 20, Count 1
TPM2_PCR_Read: Index 20, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 21, Count 1
TPM2_PCR_Read: Index 21, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 22, Count 1
TPM2_PCR_Read: Index 22, Digest Sz 32, Update Counter 20
TPM2_PCR_Read: Index 23, Count 1
TPM2_PCR_Read: Index 23, Digest Sz 32, Update Counter 20
TPM2_PCR_Extend success
TPM2_PCR_Read: Index 0, Count 1
TPM2_PCR_Read: Index 0, Digest Sz 32, Update Counter 21
TPM2_StartAuthSession: sessionHandle 0x3000000
TPM2_PolicyGetDigest: size 32
TPM2_PCR_Read: Index 0, Digest Sz 20, Update Counter 21
wc_Hash of PCR[0]: size 32
TPM2_PolicyPCR failed 0x1c4: TPM_RC_AUTHSIZE
TPM2_PolicyRestart: Done
TPM2_HashSequenceStart: sequenceHandle 0x80000000
Hash SHA256 test success
TPM2_CreatePrimary: Endorsement 0x80000000 (314 bytes)
TPM2_CreatePrimary: Storage 0x80000002 (282 bytes)
TPM2_LoadExternal: 0x80000004
TPM2_MakeCredential: credentialBlob 68, secret 256
TPM2_ReadPublic Handle 0x80000004: pub 314, name 34, qualifiedName 34
Create HMAC-SHA256 Key success, public 48, Private 137
TPM2_Load New HMAC Key Handle 0x80000004
TPM2_PolicyCommandCode: success
TPM2_ObjectChangeAuth: private 137
TPM2_ECC_Parameters: CurveID 3, sz 256, p 32, a 32, b 32, gX 32, gY 32, n 32, h 1
TPM2_Create: New ECDSA Key: pub 88, priv 126
TPM2_Load ECDSA Key Handle 0x80000004
TPM2_Sign: ECC S 32, R 32
TPM2_VerifySignature: Tag 32802
TPM2_Create: New ECDH Key: pub 88, priv 126
TPM2_Load ECDH Key Handle 0x80000004
TPM2_ECDH_KeyGen: zPt 68, pubPt 68
TPM2_ECDH_ZGen: zPt 68
TPM2 ECC Shared Secret Pass
TPM2_Create: New RSA Key: pub 278, priv 222
TPM2_Load RSA Key Handle 0x80000004
TPM2_RSA_Encrypt: 256
TPM2_RSA_Decrypt: 68
RSA Encrypt/Decrypt test passed
TPM2_NV_DefineSpace: 0x1bfffff
TPM2_NV_ReadPublic: Sz 14, Idx 0x1bfffff, nameAlg 11, Attr 0x2020002, authPol 0, dataSz 32, name 34
Create AES128 CFB Key success, public 50, Private 142
TPM2_Load New AES Key Handle 0x80000004
Encrypt/Decrypt test success
```

### ラッパーAPIのテスト

wolfTPM2_* ラッパー API の呼び出しを示します。<br>

```
./examples/wrap/wrap_test
TPM2 Demo for Wrapper API's
Mfg STM  (2), Vendor , Fw 74.8 (1151341959), FIPS 140-2 1, CC-EAL4 0
RSA Encrypt/Decrypt Test Passed
RSA Encrypt/Decrypt OAEP Test Passed
RSA Key 0x80000000 Exported to wolf RsaKey
wolf RsaKey loaded into TPM: Handle 0x80000000
RSA Private Key Loaded into TPM: Handle 0x80000000
ECC Sign/Verify Passed
ECC DH Test Passed
ECC Verify Test Passed
ECC Key 0x80000000 Exported to wolf ecc_key
wolf ecc_key loaded into TPM: Handle 0x80000000
ECC Private Key Loaded into TPM: Handle 0x80000000
NV Test on index 0x1800200 with 1024 bytes passed
Hash SHA256 test success
HMAC SHA256 test success
Encrypt/Decrypt (known key) test success
Encrypt/Decrypt test success
```


### 認証のユースケース

#### TPM 署名のタイムスタンプ, TPM2.0 GetTime

Attestation Identity Keys (AIK) の作成と、現在のシステム アップタイムの保護されたレポートとして後で使用できる TPM 署名付きタイムスタンプの生成を示します。<br>

このサンプルプログラムでは、"authSession"(承認セッション) と"policySession"(ポリシー承認) を使用して、AIK の作成に必要な承認階層を有効にする方法を示します。 AIK は、TPM 2.0 ネイティブ API を使用して"TPM2_GetTime"コマンドを発行するために使用されます。 これにより、稼働時間のシステム レポートとして使用できる、TPM によって生成され署名されたタイムスタンプが提供されます。<br>


`./examples/timestamp/signed_timestamp`

#### TPM 署名 PCR(system) 計測, TPM2.0 Quote

TPM 署名済み構造に PCR 値を配置することにより、システム状態の証明に使用される TPM2.0 Quote の生成を示します。<br>


##### サンプルプログラムのリスト

"`./examples/pcr/`" フォルダには、プラットフォーム構成レジスタ (PCR) を操作するためのツールが含まれています。 より多くのログ出力を表示するには、`make` の前に "`./configure --enable-debug`" を使用してデバッグ出力を有効にして wolfTPM をビルドすることをお勧めします。 これらの PCR の例を使用して表示するサンプル スクリプトがあります。<br>



サンプルプログラム:

* `./examples/pcr/reset`: PCR の内容をクリアするために使用されます (制限が適用されます。以下を参照してください)。
* `./examples/pcr/extend`: PCR の内容を変更するために使用されます (拡張は暗号化操作です。以下を参照してください)。
* `./examples/pcr/quote`: PCR ダイジェストと TPM によって生成された署名を含む TPM2.0 Quote 構造を生成するために使用されます

スクリプト:

* `./examples/pcr/demo.sh` ：上記ツールをデモンストレーションするスクリプト
* `./examples/pcr/demo-quote-zip.sh` ：上記のツールを使用してシステム ファイルを測定し、その測定値を使用して TPM 署名付き証明を生成する方法を示すスクリプト


##### 技術解説

###### プラットフォーム構成レジスタ（Platform Configuration Registers = PCR)

TPM2.0 の PCR は、1 種類の書き込み操作のみを実行できる特別なレジスタです。 TPM 2.0 拡張操作は、PCR を更新する唯一の方法です。<br>

電源投入時に、TPM はすべての PCR をデフォルト状態 (PCR に応じてすべてゼロまたはすべて 1) にリセットします。 この状態から、同じハッシュ ダイジェストで PCR を拡張した場合にのみ、TPM は同じ PCR 値を生成できます。 複数の値 (複数の拡張操作) の場合、値を正しい順序で指定する必要があります。そうしないと、最終的な PCR 値が異なります。<br>

たとえば、カーネルがすべてのブートで同じである場合、Linux でメジャー ブートを実行すると、同じ PCR ダイジェストが生成されます。 ただし、同じ (A) Linux カーネル、(B) initrd イメージ、および (C) 構成ファイルをロードすると、拡張操作の順序が一貫している場合 (A-B-C など) にのみ、同じ PCR ダイジェストが生成されます。 順序が同じである限り、どちらの拡張操作が最初か最後かは問題ではありません。 たとえば、C-B-A は再現可能なダイジェストになりますが、A-B-C ダイジェストとは異なります。<br>


###### リセット

すべての PCR が等しいわけではありません。 ユーザーはすべての PCR で`拡張`操作を実行できますが、通常の実行時にそのうちの 1 つだけを`リセット`できます。 これが PCR を非常に便利なものにしている理由です。<br>

* PCR0-15 は起動時にリセットされ、再起動サイクルからのみ再度クリア (リセット) できます。<br>
* PCR16はデバッグ用のPCRです。 これは、上記のすべてのツールでデフォルトで使用される PCR です。 PCR16 でのテストと作業は安全です。<br>
* PCR17-22 は、ダイナミック ルート オブ トラスト測定 (DRTM) 用に予約されています。これは、個別に説明する高度なトピックです。<br>


###### 拡張

TPM 2.0 の`TPM2_Extend` API は、SHA1 または SHA256 暗号化操作を使用して、PCR の現在の値と、新しく提供されたハッシュ ダイジェストを組み合わせます。<br>

###### クオート

TPM 2.0 の`TPM2_Quote` API は、`TPMS_ATTEST`と呼ばれる TCG 定義の構造体に PCR ダイジェストを TPM 署名とともにカプセル化する標準操作です。 署名は、TPM のみが使用できる Attestation Identity Key (AIK) と呼ばれる TPM によって生成されたキーから生成されます。 これにより、Quote および PCR ダイジェストのソースが保証されます。 Quote と PCR は共に、システムの測定と完全性のための手段を提供します。<br>


##### サンプルプログラムの使用方法

###### Resetサンプルプログラムの使用方法

```sh
$ ./examples/pcr/reset -?
PCR index is out of range (0-23)
Expected usage:
./examples/pcr/reset [pcr]
* pcr is a PCR index between 0-23 (default 16)
Demo usage without parameters, resets PCR16.
```

###### Extendサンプルプログラムの使用方法

```sh
$ ./examples/pcr/extend -?
Incorrect arguments
Expected usage:
./examples/pcr/extend [pcr] [filename]
* pcr is a PCR index between 0-23 (default 16)
* filename points to file(data) to measure
	If wolfTPM is built with --disable-wolfcrypt the file
	must contain SHA256 digest ready for extend operation.
	Otherwise, the extend tool computes the hash using wolfcrypt.
Demo usage without parameters, extends PCR16 with known hash.
```

###### Quoteサンプルプログラムの使用方法

```sh
$ ./examples/pcr/quote -?
Incorrect arguments
Expected usage:
./examples/pcr/quote [pcr] [filename]
* pcr is a PCR index between 0-23 (default 16)
* filename for saving the TPMS_ATTEST structure to a file
Demo usage without parameters, generates quote over PCR16 and
saves the output TPMS_ATTEST structure to "quote.blob" file.
```

##### 一般的なデモ出力

すべての PCR の例は、引数なしで使用できます。 以下は `./examples/pcr/demo.sh` スクリプトの出力です:<br>


```sh
$ ./examples/pcr/reset
Demo how to reset a PCR (clear the PCR value)
wolfTPM2_Init: success
Trying to reset PCR16...
TPM2_PCR_Reset success
PCR16 digest:
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | ................
```
予想どおり、PCR16 の内容はすべてゼロに戻されました。 この時点から、システム測定用の予測可能な PCR ダイジェスト (値) を生成できます。 PCR7 はシステムの起動時にリセットされるため、起動後に PCR7 を使用する場合と同様です。 PCR16 を使用すると、システムの再起動をスキップして安全にテストできます。<br>

```
$ ./examples/pcr/extend
Demo how to extend data into a PCR (TPM2.0 measurement)
wolfTPM2_Init: success
Hash to be used for measurement:
000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F
TPM2_PCR_Extend success
PCR16 digest:
    bb 22 75 c4 9f 28 ad 52 ca e6 d5 5e 34 a9 74 a5 | ."u..(.R...^4.t.
    8c 7a 3b a2 6f 97 6e 8e cb be 7a 53 69 18 dc 73 | .z;.o.n...zSi..s
```
PCR の古い内容 (すべてゼロ) と提供されたハッシュ (SHA256 32 バイト ダイジェスト) に基づいて、PCR は`extend`の例の最後に出力された新しい値を取得します。 この値は、`reset` が `extend` の前に起動された場合、常に同じになります。 カスタム ハッシュ ダイジェストを渡すために、`extend`ツールは、PCR インデックスを最初の引数として受け入れ (PCR16 には 16 を使用することをお勧めします)、ユーザー ファイルを 2 番目の引数として受け入れます。<br>

```
$ ./examples/pcr/quote
Demo of generating signed PCR measurement (TPM2.0 Quote)
wolfTPM2_Init: success
TPM2_CreatePrimary: 0x80000000 (314 bytes)
wolfTPM2_CreateEK: Endorsement 0x80000000 (314 bytes)
TPM2_CreatePrimary: 0x80000001 (282 bytes)
wolfTPM2_CreateSRK: Storage 0x80000001 (282 bytes)
TPM2_StartAuthSession: sessionHandle 0x3000000
TPM2_Create key: pub 280, priv 212
TPM2_Load Key Handle 0x80000002
wolfTPM2_CreateAndLoadAIK: AIK 0x80000002 (280 bytes)
TPM2_Quote: success
TPM with signature attests (type 0x8018):
    TPM signed 1 count of PCRs
    PCR digest:
    c7 d4 27 2a 57 97 7f 66 1f bd 79 30 0a 1b bf ff | ..'*W..f..y0....
    2e 43 57 cc 44 14 7a 82 11 aa 76 3f 9f 1b 3a 6c | .CW.D.z...v?..:l
    TPM generated signature:
    28 dc da 76 33 35 a5 85 2a 0c 0b e8 25 d0 f8 8d | (..v35..*...%...
    1f ce c3 3b 71 64 ed 54 e6 4d 82 af f3 83 18 8e | ...;qd.T.M......
    6e 2d 9f 9e 5a 86 4f 11 fe 13 84 94 cf 05 b9 d5 | n-..Z.O.........
    eb 5a 34 39 b2 a5 7a 5f 52 c0 f4 e7 2b 70 b7 62 | .Z49..z_R...+p.b
    6a fe 79 4e 2e 46 2e 43 d7 1c ef 2c 14 21 11 14 | j.yN.F.C...,.!..
    95 01 93 a9 85 0d 02 c7 b2 f8 75 1a bd 59 da 56 | ..........u..Y.V
    cc 43 e3 d2 aa 14 49 2a 59 26 09 9e c9 4b 1a 66 | .C....I*Y&...K.f
    cb 77 65 95 79 69 89 bd 46 46 13 3d 2c a9 78 f8 | .we.yi..FF.=,.x.
    2c ab 8a 4a 6b f2 97 67 86 37 f8 f6 9d 85 cd cf | ,..Jk..g.7......
    a4 ae c6 d3 cf c1 63 92 8c 7b 88 79 90 54 0a ba | ......c..{.y.T..
    8d c6 1c 8f 6e 6d 61 bc a9 2f 35 b0 1a 46 74 9a | ....nma../5..Ft.
    e3 7d 39 33 52 1a f5 4b 07 8d 30 53 75 b5 68 40 | .}93R..K..0Su.h@
    04 e7 a1 fc b1 93 5d 1e bc ca f4 a9 fa 75 d3 f6 | ......]......u..
    3d 4a 5b 07 23 0e f0 f4 1f 97 23 76 1a ee 66 93 | =J[.#.....#v..f.
    cd fd 9e 6f 2b d3 95 c5 51 cf f6 81 5b 97 a1 d2 | ...o+...Q...[...
    06 45 c0 30 70 ad bd 36 66 9f 95 af 60 7c d5 a2 | .E.0p..6f...`|..
```

PCR 測定値を含む TPM 署名付き構造を生成する前に、クオートのサンプルプログラムでは、TPM が動作するために必要な保証鍵 (EK) を作成することから始めます。 基本的に、他のすべての鍵のプライマリー鍵として機能します。 次に、ストレージ鍵(SRK) が生成され、その SRK の下に特別な Attestation Identity Key (AIK) が追加されます。 AIK を使用して、TPM はクオート構造に署名できます。<br>


##### システムファイルの測定手順（ローカル認証の実施）

システム管理者は、ユーザーの zip ツールが本物であること (正当なソフトウェア、正しいバージョン、改ざんされていないこと) を確認したいと考えています。 これを行うために、システム管理者は PCR16 をリセットし、その後、ファイルが変更された場合に将来の参照に使用できる zip バイナリに基づいて PCR ダイジェストを生成できます。<br>

これは `./examples/pcr/demo-quote-zip.sh` スクリプトからの出力です。<br>


```sh
$ ./examples/pcr/reset 16
...
Trying to reset PCR16...
TPM2_PCR_Reset success
...
```
これは、よく知られた PCR の初期状態です。 `extend`ツールを使用することにより、SysAdmin は`/usr/bin/zip`バイナリを SHA256 ハッシュ計算のために wolfCrypt にフィードします。これは、wolfTPM が PCR16 で`TPM2_Extend`操作を発行するために使用されます。<br>


```sh
$ ./examples/pcr/extend 16 /usr/bin/zip
...
TPM2_PCR_Extend success
PCR16 digest:
    2b bd 54 ae 08 5b 59 ef 90 42 d5 ca 5d df b5 b5 | +.T..[Y..B..]...
    74 3a 26 76 d4 39 37 eb b0 53 f5 82 67 6f b4 aa | t:&v.97..S..go..
```

拡張操作が完了すると、SysAdmin は PCR16 での測定の証明として TPM2.0 Quote を作成したいと考えています。<br>


```sh
$ ./examples/pcr/quote 16 zip.quote
...
TPM2_Quote: success
TPM with signature attests (type 0x8018):
    TPM signed 1 count of PCRs
...
```

TPM2.0 Quote 操作の結果は、`zip.quote` バイナリ ファイルに保存されます。 TPM 2.0 Quote の`TPMS_ATTEST`構造には、有用なクロックと時刻の情報も含まれています。 TPM 時刻認証の詳細については、`./examples/timestamp/signed_timestamp` の例を確認してください。<br>

#### リモート認証チャレンジ

PM 2.0 を使用してリモート認証チャレンジを作成し、その後応答を準備する方法を示します。<br>

##### サンプルプログラムのリスト

`./examples/attestation/` フォルダーには、特にリモート認証に関連するサンプルプログラムが含まれています。 ただし、デモンストレーションでは、wolfTPM のソース コードにも含まれている`keygen`のサンプルプログラムを使用して TPM 2.0 鍵を作成する必要があります。<br>


必要なサンプルプログラムの完全なリストを以下に示します：

* `./examples/attestation/make_credential`: リモート認証チャレンジを作成するためにサーバーによって使用されます<br>
* `./examples/attestation/activate_credential`: クライアントがチャレンジを復号して応答するために使用<br>
* `./examples/keygen/keygen`: プライマリー鍵 (PK) と認証鍵 (AK) を作成するために使用されます<br>

注: これらのサンプルプログラムではすべて、保証階層の下で保証鍵と認証鍵を使用できます。 これは、上記の 3 つの例のいずれかを実行するときに`-eh`オプションを追加することによって行われます。 EK/EH を使用する利点は、EK の秘密鍵マテリアルが TPM から離れないことです。 EK の公開部分を使用して暗号化されたものはすべて、EK の TPM 所有者によって内部的にのみ暗号化でき、EK はすべての TPM チップに対して一意です。 したがって、EK/EH を使用してリモート認証のチャレンジを作成することは、シナリオによってはより大きな価値があります。 欠点の 1 つは、EK を使用すると、認証対象のホストの ID が常に知られることです。これは、EK の秘密鍵と公開鍵のペアが TPM を識別し、シナリオによっては、プライバシーの問題が発生する可能性があるためです。 リモート認証の例では、SRK の下の AK と EK の下の AK の両方をサポートしています。 どちらを使用するかは開発者次第です。<br>


##### 技術解説

リモート認証は、クライアントが既知の状態にあるかどうかを検証する認証サーバーに証拠を提供するクライアントのプロセスです。<br>

このプロセスを実行するには、クライアントとサーバーが最初の信頼を確立する必要があります。 これは、標準の TPM 2.0 コマンド MakeCredential および ActivateCredential を使用して実現されます。<br>

1. ライアントは、TPM 2.0 Primary Attestation Key (PAK) と引用署名 Attestation Key (AK) の公開部分を転送します。<br>

2. MakeCredential は、PAK の公開部分を使用してチャレンジ (シークレット) を暗号化します。 通常、チャレンジは認証キー (AK) の公開部分のダイジェストです。<br>

この方法では、PAK と AK のプライベート部分をロードできる TPM によってのみ、チャレンジを復号できます。 PAK と AK は fixedTPM 鍵属性を使用して TPM にバインドされているため、これらの鍵をロードできる唯一の TPM は、それらが最初に作成された TPM です。<br>

3. チャレンジが作成されると、サーバーからクライアントに転送されます。<br>

4. ActivateCredential は、TPM 2.0 がロードされた PAK と AK を使用してチャレンジを復号し、シークレットを取得します。 取得すると、クライアントはサーバー チャレンジに応答できます。<br>

このようにして、クライアントはサーバーに対して、予想される TPM 2.0 システム ID と認証キーを所有していることを確認します。<br>

ノート：

* チャレンジとレスポンスを交換するためのトランスポート プロトコルは、実装固有であるため、開発者が選択する必要があります。 1 つのアプローチは、wolfSSL を使用した TLS1.3 クライアント/サーバー接続の使用です。<br>

##### サンプルプログラムの使用方法

###### リモート認証用の TPM 2.0 キーの作成

`keygen`のサンプルプログラムを使用して、必要な TPM 2.0 構成証明鍵と、プライマリ構成証明鍵 (PAK) として使用される TPM 2.0 プライマリ ストレージ 鍵を作成できます。<br>

```
$ ./examples/keygen/keygen -rsa
TPM2.0 Key generation example
	Key Blob: keyblob.bin
	Algorithm: RSA
	Template: AIK
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
RSA AIK template
Creating new RSA key...
New key created and loaded (pub 280, priv 222 bytes)
Wrote 508 bytes to keyblob.bin
Wrote 288 bytes to srk.pub
Wrote AK Name digest
```

###### クレデンシャル作成サンプルプログラムの使用方法

`make_credential`のサンプルプログラムを使用して、認証サーバーはリモート認証チャレンジを生成できます。 シークレットは、ランダムに生成された 32 バイトのシードであり、一部のリモート認証スキームで対称キーに使用できます。<br>

```
$ ./examples/attestation/make_credential
Using public key from SRK to create the challenge
Demo how to create a credential challenge for remote attestation
Credential will be stored in cred.blob
wolfTPM2_Init: success
Reading 288 bytes from srk.pub
Reading the private part of the key
Public key for encryption loaded
Read AK Name digest success
TPM2_MakeCredential success
Wrote credential blob and secret to cred.blob, 648 bytes
```
クライアントと認証サーバー間の PAK および AK パブリック パーツの転送は、交換が実装固有であるため、`make_credential` の例の一部ではありません。<br>

###### クレデンシャルのアクティベートサンプルプログラムの使用方法

`activate_credential` のサンプルプログラムを使用して、クライアントはリモート認証チャレンジを復号できます。 シークレットは平文で公開され、認証サーバーと交換できます。<br>

```
$ ./examples/attestation/activate_credential
Using default values
Demo how to create a credential blob for remote attestation
wolfTPM2_Init: success
Credential will be read from cred.blob
Loading SRK: Storage 0x81000200 (282 bytes)
SRK loaded
Reading 508 bytes from keyblob.bin
Reading the private part of the key
AK loaded at 0x80000001
Read credential blob and secret from cred.blob, 648 bytes
TPM2_ActivateCredential success
```
シークレットをプレーンで含む (または対称鍵シードとして使用される) チャレンジ レスポンスの転送は、`activate_credential`のサンプルプログラムの一部ではありません。これは、交換も実装固有であるためです。<br>


### パラメータ暗号化

#### 暗号化された承認による鍵の生成

詳細情報は、 ["鍵生成"](#key-generation)セクションの下にあります

#### 暗号化された NVRAM 認証によるキーの安全なボールト

詳細情報は、このファイルのセクションの下にあります ["Storing keys into the TPM's NVRAM"](#storing-keys-into-the-tpms-nvram)

#### 暗号化されたユーザー データを含む TPM2.0クオート

パラメータ暗号化を使用して、ホストと TPM の間のユーザー データを保護する方法を示すサンプルプログラム。<br>

このサンプルプログラムでは、Quote 操作のためにユーザーが提供できる修飾データが保護されています。 修飾データは、署名された Quote 構造に組み込まれた任意のデータです。 パラメータの暗号化を使用することで、wolfTPM はホストがそのユーザー データを暗号化された形式で TPM に、またはその逆に転送できるようにします。 したがって、中間者攻撃からデータを保護します。<br>

TPM コマンドの最初のパラメーターのみを暗号化でき、パラメーターは「TPM2B_DATA」型である必要があります。 たとえば、TPM 鍵のパスワード認証や TPM2.0 Quote の修飾データなどです。<br>

コマンド要求と応答の暗号化は、一緒に実行することも、個別に実行することもできます。 TPM とクライアント プログラムの間で、要求コマンドのパラメーターのみが暗号化される通信交換が可能です。<br>

この動作は `sessionAttributes` に依存します:<br>

・コマンドリクエストの`TPMA_SESSION_encrypt`<br>
・コマンド応答用`TPMA_SESSION_decrypt`<br>

いずれかを個別に設定することも、両方を 1 つの認証セッションで設定することもできます。 これはユーザー（開発者）次第です。<br>

`./examples/pcr/quote_paramenc`

### CSR

TPM 鍵ペアに基づいて証明書を作成するための証明書署名要求を生成します。<br>

`./examples/csr/csr`

以下の２ファイルを生成します:
`./certs/tpm-rsa-cert.csr`
`./certs/tpm-ecc-cert.csr`


### 証明書への署名

TPM で生成された CSR に基づいてテスト証明書を生成するための外部スクリプト。 通常、CSR は署名のために信頼できる CA に提供されます。<br>

`./certs/certreq.sh`

このスクリプトは、次の X.509 ファイル (これも .pem 形式) を作成します:
`./certs/ca-ecc-cert.der`
`./certs/ca-rsa-cert.der`
`./certs/client-rsa-cert.der`
`./certs/client-ecc-cert.der`
`./certs/server-rsa-cert.der`
`./certs/server-ecc-cert.der`


### PKCS #7

サンプルプログラムでは、TPM ベースの鍵を使用して PKCS #7 でデータに署名し、検証します。<br>

* 最初に実行する必要があります:
1. `./examples/csr/csr`
2. `./certs/certreq.sh`
3. `./examples/pkcs7/pkcs7`

結果はコンソールの stdout に表示されます。


### TLS サンプルプログラム

TLS のサンプルプログラムでは、TPM ベースの ECDHE (ECC エフェメラル キー) サポートを使用しています。 `CFLAGS="-DWOLFTPM2_USE_SW_ECDHE"` または `#define WOLFTPM2_USE_SW_ECDHE` を使用して無効にすることができます。 また、パフォーマンスとスケーラビリティを向上させるために、2 フェーズの「TPM2_EC_Ephemeral」および「TPM2_ZGen_2Phase」メソッドの使用も検討しています。<br>

RSA が有効な場合に wolfSSL で ECC の使用を強制するには、`TLS_USE_ECC` を定義します。<br>

TPM で対称 AES/Hashing/HMAC を使用するには、`WOLFTPM_USE_SYMMETRIC` を定義します。<br>

クライアント証明書とサーバー証明書を生成するには、次を実行する必要があります:<br>


1. `./examples/keygen/keygen rsa_test_blob.raw -rsa -t`
2. `./examples/keygen/keygen ecc_test_blob.raw -ecc -t`
3. `./examples/csr/csr`
4. `./certs/certreq.sh`
5. CA ファイルを wolfTPM から wolfSSL certs ディレクトリにコピーします。
    a. `cp ./certs/ca-ecc-cert.pem ../wolfssl/certs/tpm-ca-ecc-cert.pem`
    b. `cp ./certs/ca-rsa-cert.pem ../wolfssl/certs/tpm-ca-rsa-cert.pem`

注: 「wolf-ca-rsa-cert.pem」および「wolf-ca-ecc-cert.pem」ファイルは、こちらの wolfSSL サンプル証明書から取得されます:

```
cp ../wolfssl/certs/ca-cert.pem ./certs/wolf-ca-rsa-cert.pem
cp ../wolfssl/certs/ca-ecc-cert.pem ./certs/wolf-ca-ecc-cert.pem
```

#### TLS Client

TLS 相互認証 (クライアント認証) に TPM キーと証明書を使用するサンプルプログラムを示します。<br>

このサンプルプログラムのクライアントは、デフォルトでポート 11111 の localhost に接続します。 これらは `TLS_HOST` と `TLS_PORT` を使用してオーバーライドできます。<br>

次のように wolfSSL サンプル サーバーを使用して検証できます:<br>

`./examples/server/server -b -p 11111 -g -d -i -V`

クライアント証明書を検証するには、次の wolfSSL サンプル サーバー コマンドを使用します:<br>
`./examples/server/server -b -p 11111 -g -A ./certs/tpm-ca-rsa-cert.pem -i -V`<br>
または<br>
`./examples/server/server -b -p 11111 -g -A ./certs/tpm-ca-ecc-cert.pem -i -V`<br>

次に、wolfTPM TLS クライアントのサンプルプログラムを実行します:<br>
`./examples/tls/tls_client -rsa`<br>
または<br>
`./examples/tls/tls_client -ecc`<br>


#### TLS Server

このサンプルプログラムでは、TLS サーバーに TPM キーと証明書を使用する方法を示します。<br>

デフォルトでは、ポート 11111 でリッスンし、ビルド時に `TLS_PORT` マクロを使用してオーバーライドできます。<br>

wolfTPM TLS サーバーのサンプルプログラムを実行します:<br>
`./examples/tls/tls_server -rsa`<br>
または<br>
`./examples/tls/tls_server -ecc`<br>

次に、wolfSSL サンプル クライアントを次のように実行します:<br>
`./examples/client/client -h localhost -p 11111 -g -d`<br>

サーバー証明書を検証するには、次の wolfSSL サンプル クライアント コメントを使用します:<br>
`./examples/client/client -h localhost -p 11111 -g -A ./certs/tpm-ca-rsa-cert.pem`<br>
または<br>
`./examples/client/client -h localhost -p 11111 -g -A ./certs/tpm-ca-ecc-cert.pem`<br>


または、ブラウザを使用して: `https://localhost:11111`<br>

ブラウザーでは、テスト CA の `./certs/ca-rsa-cert.pem` および `./certs/ca-ecc-cert.pem` を OS キー ストアにロードするまで、証明書の警告が表示されます。
テスト用に、ほとんどのブラウザには警告を回避するためにとにかくサイトにアクセスし続ける方法があります。<br>



### クロック

TPM クロックの更新<br>

TPM には、ユーザーに役立つ内部ハードウェア クロックがあります。 時間に関して TPM が提供できる値は 2 つあります。<br>

TPM 時間は、最後の電源投入シーケンス以降の現在の稼働時間です。 この値は変更または修正できません。 そのためのメカニズムはありません。 値は電源シーケンスごとにリセットされます。<br>

TPM クロックは、TPM の電源が投入された合計時間です。 この値は、TPM2_ClockSet コマンドを使用して変更できます。 TPM クロックは正転のみ設定できます。<br>

このようにして、ユーザーは TPM クロックを使用して相対時刻と現在時刻を追跡できます。<br>

注: 新しい時間値が TPM クロック更新間隔よりも大きな変更を行う場合、TPM は最初に時間の揮発性レジスタを更新し、次に時間の不揮発性レジスタを更新します。 これにより、コマンドがユーザーに実行を返す前にわずかな遅延が発生する場合があります。 TPM の製造元によっては、遅延が数ミリ秒から数ミリ秒まで異なる場合があります。<br>

注: このサンプルプログラムでは、オプションの引数 (TPM クロックの増分に使用されるミリ秒単位の時間値) を取ることができます。 デフォルト値は 50000ms (50 秒) です。<br>

`./examples/timestamp/clock_set`

### 鍵生成

TPM 鍵BLOB を生成してディスクに格納し、ディスクからロードして一時 TPM ハンドルにロードするサンプルプログラム。

```
$ ./examples/keygen/keygen keyblob.bin -rsa
TPM2.0 Key generation example
Loading SRK: Storage 0x81000200 (282 bytes)
Creating new RSA key...
Created new key (pub 280, priv 222 bytes)
Wrote 840 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 840 bytes from keyblob.bin
Loaded key to 0x80000001


$ ./examples/keygen/keygen keyblob.bin -ecc
TPM2.0 Key generation example
Loading SRK: Storage 0x81000200 (282 bytes)
Creating new ECC key...
Created new key (pub 88, priv 126 bytes)
Wrote 744 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 744 bytes from keyblob.bin
Loaded key to 0x80000001

./examples/keygen/keygen -sym=aescfb128
TPM2.0 Key generation example
	Key Blob: keyblob.bin
	Algorithm: SYMCIPHER
		 aescfb mode, 128 keybits
	Template: Default
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Symmetric template
Creating new SYMCIPHER key...
Created new key (pub 50, priv 142 bytes)
Wrote 198 bytes to keyblob.bin

$ ./examples/keygen/keyload
TPM2.0 Key load example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 198 bytes from keyblob.bin
Reading the private part of the key
Loaded key to 0x80000001

```
ファイル名が指定されていない場合、デフォルトのファイル名「keyblob.bin」が使用されるため、「keyload」と「keygen」をパラメーターを追加せずに使用して、TPM 2.0 鍵生成のデモを迅速に行うことができます。<br>

「keygen」のサンプルプログラムでサポートされている暗号化アルゴリズムとオプションの完全なリストを表示するには、「--help」スイッチのいずれかを使用します。<br>

秘密鍵を TPM キー BLOB としてインポートしてディスクに保存し、ディスクからロードして一時 TPM ハンドルにロードする例:<br>

```
$ ./examples/keygen/keyimport keyblob.bin -rsa
TPM2.0 Key import example
Loading SRK: Storage 0x81000200 (282 bytes)
Imported key (pub 278, priv 222 bytes)
Wrote 840 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 840 bytes from keyblob.bin
Loaded key to 0x80000001


$ ./examples/keygen/keyimport keyblob.bin -ecc
TPM2.0 Key Import example
Loading SRK: Storage 0x81000200 (282 bytes)
Imported key (pub 86, priv 126 bytes)
Wrote 744 bytes to keyblob.bin

$ ./examples/keygen/keyload keyblob.bin
TPM2.0 Key load example
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 744 bytes from keyblob.bin
Loaded key to 0x80000001
```

`keyload` ツールは、格納された鍵のファイル名である引数を 1 つだけ受け取ります。 キー スキーム (RSA または ECC) とは何かという情報が鍵 blob 内に含まれているためです。<br>

### 鍵を TPM の NVRAM に保存

これらのサンプルプログラムは、TPM を鍵の安全なボールトとして使用する方法を示しています。 TPM 鍵を TPM の NVRAM に格納するプログラムと、TPM の NVRAM から鍵を抽出するプログラムの 2 つのプログラムがあります。 どちらのサンプルプログラムでも、パラメータ暗号化を使用して 中間者攻撃から保護できます。 不揮発性メモリの場所は、コマンド ラインで「-aes」を指定すると、暗号化された形式で渡されるパスワード認証で保護されます。<br>

サンプルを実行する前に、keygen ツールを使用して生成された keyblob.bin があることを確認してください。 鍵は、RSA、ECC、または対称型の任意のタイプにすることができます。 このサンプルプログラムでは、プライベート部分とパブリック部分を保存します。 対称鍵の場合、公開部分は TPM からのメタ データです。 上記の keygen のサンプルプログラムの説明にあるキーの生成方法。<br>

パラメータ暗号化が有効な状態で RSA キーを保存してから読み取る場合の一般的な出力:<br>


```

$ ./examples/nvram/store -aes
Parameter Encryption: Enabled (AES CFB).

TPM2_StartAuthSession: sessionHandle 0x2000000
Reading 840 bytes from keyblob.bin
Storing key at TPM NV index 0x1800202 with password protection

Public part = 616 bytes
NV write of public part succeeded

Private part = 222 bytes
Stored 2-byte size marker before the private part
NV write of private part succeeded


$ ./examples/nvram/read -aes
Parameter Encryption: Enabled (AES CFB).

TPM2_StartAuthSession: sessionHandle 0x2000000
Trying to read 616 bytes of public key part from NV
Successfully read public key part from NV

Trying to read size marker of the private key part from NV
Successfully read size marker from NV

Trying to read 222 bytes of private key part from NV
Successfully read private key part from NV

Extraction of key from NVRAM at index 0x1800202 succeeded
Loading SRK: Storage 0x81000200 (282 bytes)
Trying to load the key extracted from NVRAM
Loaded key to 0x80000001

```
「読み取り」のサンプルプログラムでは、鍵の公開部分と秘密部分の両方が NVRAM に格納されている場合、抽出された鍵をロードしようとします。 「-aes」スイッチは、パラメーター暗号化の使用をトリガーします。<br>

このサンプルプログラムでは、部分的なキー マテリアル (プライベートまたはパブリック) を使用できます。 これは、「-priv」および「-pub」オプションを使用して実現されます。<br>

RSA 非対称キー ペアの秘密キーのみを NVRAM に格納し、パラメータ暗号化を有効にしない場合の典型的な出力

```

$ ./examples/nvram/store -priv
Parameter Encryption: Not enabled (try -aes or -xor).

Reading 506 bytes from keyblob.bin
Reading the private part of the key
Storing key at TPM NV index 0x1800202 with password protection

Private part = 222 bytes
Stored 2-byte size marker before the private part
NV write of private part succeeded

$ ./examples/nvram/read -priv
Parameter Encryption: Not enabled (try -aes or -xor).

Trying to read size marker of the private key part from NV
Successfully read size marker from NV

Trying to read 222 bytes of private key part from NV
Successfully read private key part from NV

Extraction of key from NVRAM at index 0x1800202 succeeded

```

「読み取り」を使用して鍵の抽出が成功した後、NV インデックスは破棄されます。 したがって、"read"を再度使用するには、"store"のサンプルプログラムも再度実行する必要があります。<br>

### シール・アンシール

TPM 2.0 は、標準のシール/アンシール手順を使用してシークレットを保護できます。 シールは、TPM 2.0 鍵を使用して、または一連の PCR 値に対して作成できます。 注: 鍵にシールされるシークレット データは、最大 128 バイトのサイズに制限されています。<br>

使用可能なサンプルプログラムは、`seal/seal`と`seal/unseal`の 2 つです。

パラメーターなしで、デモの使用が可能です。<br>

#### TPM 2.0 鍵へのデータのシール

`seal`の例を使用して、新しく生成された TPM 2.0 鍵にデータを安全に保存します。 この鍵が TPM にロードされた場合にのみ、シークレット データを読み取ることができます。<br>

シークレット メッセージのシールとアンシールの出力例を示します:<br>

```
$ ./examples/seal/seal keyblob.bin mySecretMessage
TPM2.0 Simple Seal example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Sealing the user secret into a new TPM key
Created new TPM seal key (pub 46, priv 141 bytes)
Wrote 193 bytes to keyblob.bin
Key Public Blob 46
Key Private Blob 141

$ ./examples/keygen/keyload -persistent
TPM2.0 Key load example
	Key Blob: keyblob.bin
	Use Parameter Encryption: NULL
Loading SRK: Storage 0x81000200 (282 bytes)
Reading 193 bytes from keyblob.bin
Reading the private part of the key
Loaded key to 0x80000001
Key was made persistent at 0x81000202

$ ./examples/seal/unseal message.raw
Example how to unseal data using TPM2.0
wolfTPM2_Init: success
Unsealing succeeded
Stored unsealed data to file = message.raw

$ cat message.raw
mySecretMessage
```

アンシールが成功すると、データは新しいファイルに保存されます。 ファイル名が指定されていない場合、`unseal`ツールはデータを`unseal.bin`に保存します。<br>


### GPIO コントロール

一部の TPM 2.0 モジュールには、開発者が使用できる追加の I/O 機能と追加の GPIO があります。 この余分な GPIO を使用して、セキュリティ イベントまたはシステム状態について他のサブシステムに通知できます。<br>

現在、GPIO 制御の例は、ST33 および NPCT75x TPM 2.0 モジュールをサポートしています。<br>

利用可能なサンプルプログラムは 4 つあります。 `gpio/gpio_config` を使用した構成。<br>

すべてのサンプルプログラムには、ヘルプ オプション `-h` があります。 各種GPIOモードについては`gpio_config -h`でご確認ください。<br>

設定が完了すると、GPIO は`gpio/gpio_set`と`gpio/gpio_read`を使用して制御できます。<br>

パラメータが指定されていない場合は、デモを使用できます。 GPIO は物理的な世界と相互作用するため、慎重に選択したオプションを使用することをお勧めします。<br>

#### GPIO コンフィグレーション

ST33 は、以下の `gpio/gpio_config` からの 6 つのモードをサポートします：

```
$ ./examples/gpio/gpio_config -h
Expected usage:
./examples/gpio/gpio_config [num] [mode]
* num is a GPIO number between 0-3 (default 0)
* mode is a number selecting the GPIO mode between 0-6 (default 3):
	0. standard - reset to the GPIO's default mode
	1. floating - input in floating configuration.
	2. pullup   - input with pull up enabled
	3. pulldown - input with pull down enabled
	4. opendrain - output in open drain configuration
	5. pushpull  - output in push pull configuration
	6. unconfigure - delete the NV index for the selected GPIO
Example usage, without parameters, configures GPIO0 as input with a pull down.
```

GPIO を出力に設定するための使用例を以下に示します：

```
$ ./examples/gpio/gpio_config 0 5
GPIO num is: 0
GPIO mode is: 5
Example how to use extra GPIO on a TPM 2.0 modules
Trying to configure GPIO0...
TPM2_GPIO_Config success
NV Index for GPIO access created
```

ST33 のプルアップを使用して GPIO を入力として構成するための使用例を以下に示します。<br>

```
$ ./examples/gpio/gpio_config 0 3
GPIO num is: 0
GPIO mode is: 3
Demo how to use extra GPIO on a TPM 2.0 modules
Trying to configure GPIO0...
TPM2_GPIO_Config success
NV Index for GPIO access created
```

#### GPIO Config (NPCT75xx)

NPCT75x は 3 つの出力モード (入力モードなし) をサポートします。以下の`gpio/gpio_config`からの情報:

```
$ ./examples/gpio/gpio_config -h
Expected usage:
./examples/gpio/gpio_config [num] [mode]
* num is a GPIO number between 3 and 4 (default 3)
* mode is either push-pull, open-drain or open-drain with pull-up
	1. pushpull  - output in push pull configuration
	2. opendrain - output in open drain configuration
	3. pullup - output in open drain with pull-up enabled
	4. unconfig - delete NV index for GPIO access
Example usage, without parameters, configures GPIO3 as push-pull output.
```

NPCT75x の GPIO 番号付けは GPIO3 から始まり、ST33 は GPIO0 から始まることに注意してください。

```
$ ./examples/gpio/gpio_nuvoton 4 1
Example for GPIO configuration of a NPTC7xx TPM 2.0 module
GPIO number: 4
GPIO mode: 1
Successfully read the current configuration
Successfully wrote new configuration
NV Index for GPIO access created
```

#### GPIO 使用方法

GPIO 構成の切り替えはシームレスです。<br>
* ST33 の場合、`gpio/gpio_config` は既存の NV インデックスの削除を処理するため、新しい GPIO 構成を選択できます。<br>
* NPCT75xx の場合、`gpio/gpio_config` は、作成された NV インデックスを削除せずに任意の GPIO を再構成できます。<br>


```
$ ./examples/gpio/gpio_set 0 -high
GPIO0 set to high level

$ ./examples/gpio/gpio_set 0 -low
GPIO0 set to low level
```

```
$ ./examples/gpio/gpio_read 0
GPIO0 is Low
```

## ベンチマーク

wolfTPM ベンチマーク アプリケーションには、サンプル アプリケーションと同じセットアップが必要です。<br>

注: 鍵生成は、階層シードからの既存のテンプレートを使用しています。

Infineon OPTIGA SLB9670 43MHz上で実行:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 16 KB took 1.140 seconds,   14.033 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
Benchmark symmetric AES-256-CFB-enc not supported!
Benchmark symmetric AES-256-CFB-dec not supported!
SHA1               138 KB took 1.009 seconds,  136.783 KB/s
SHA256             138 KB took 1.009 seconds,  136.763 KB/s
RSA     2048 key gen        5 ops took 10.981 sec, avg 2196.230 ms, 0.455 ops/sec
RSA     2048 Public       113 ops took 1.005 sec, avg 8.893 ms,   112.449 ops/sec
RSA     2048 Private        7 ops took 1.142 sec, avg 163.207 ms,   6.127 ops/sec
RSA     2048 Pub  OAEP     73 ops took 1.011 sec, avg 13.848 ms,   72.211 ops/sec
RSA     2048 Priv OAEP      6 ops took 1.004 sec, avg 167.399 ms,   5.974 ops/sec
ECC      256 key gen        5 ops took 1.157 sec, avg 231.350 ms,   4.322 ops/sec
ECDSA    256 sign          15 ops took 1.033 sec, avg 68.865 ms,   14.521 ops/sec
ECDSA    256 verify         9 ops took 1.022 sec, avg 113.539 ms,   8.808 ops/sec
ECDHE    256 agree          5 ops took 1.161 sec, avg 232.144 ms,   4.308 ops/sec
```

ST ST33TP SPI 33MHz上で実行:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 14 KB took 1.017 seconds,   13.763 KB/s
AES-128-CBC-enc     40 KB took 1.008 seconds,   39.666 KB/s
AES-128-CBC-dec     42 KB took 1.032 seconds,   40.711 KB/s
AES-256-CBC-enc     40 KB took 1.013 seconds,   39.496 KB/s
AES-256-CBC-dec     40 KB took 1.011 seconds,   39.563 KB/s
AES-128-CTR-enc     26 KB took 1.055 seconds,   24.646 KB/s
AES-128-CTR-dec     26 KB took 1.035 seconds,   25.117 KB/s
AES-256-CTR-enc     26 KB took 1.028 seconds,   25.302 KB/s
AES-256-CTR-dec     26 KB took 1.030 seconds,   25.252 KB/s
AES-128-CFB-enc     42 KB took 1.045 seconds,   40.201 KB/s
AES-128-CFB-dec     40 KB took 1.008 seconds,   39.699 KB/s
AES-256-CFB-enc     40 KB took 1.022 seconds,   39.151 KB/s
AES-256-CFB-dec     42 KB took 1.041 seconds,   40.362 KB/s
SHA1                86 KB took 1.005 seconds,   85.559 KB/s
SHA256              84 KB took 1.019 seconds,   82.467 KB/s
RSA     2048 key gen        1 ops took 7.455 sec, avg 7455.036 ms, 0.134 ops/sec
RSA     2048 Public       110 ops took 1.003 sec, avg 9.122 ms,  109.624 ops/sec
RSA     2048 Private        5 ops took 1.239 sec, avg 247.752 ms,  4.036 ops/sec
RSA     2048 Pub  OAEP     81 ops took 1.001 sec, avg 12.364 ms,  80.880 ops/sec
RSA     2048 Priv OAEP      4 ops took 1.007 sec, avg 251.780 ms,  3.972 ops/sec
ECC      256 key gen        5 ops took 1.099 sec, avg 219.770 ms,  4.550 ops/sec
ECDSA    256 sign          24 ops took 1.016 sec, avg 42.338 ms,  23.619 ops/sec
ECDSA    256 verify        14 ops took 1.036 sec, avg 74.026 ms,  13.509 ops/sec
ECDHE    256 agree          5 ops took 1.235 sec, avg 247.085 ms,  4.047 ops/sec

```

Microchip ATTPM20 33MHz上で実行:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                  2 KB took 1.867 seconds,    1.071 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
AES-128-CFB-enc     16 KB took 1.112 seconds,   14.383 KB/s
AES-128-CFB-dec     16 KB took 1.129 seconds,   14.166 KB/s
AES-256-CFB-enc     12 KB took 1.013 seconds,   11.845 KB/s
AES-256-CFB-dec     12 KB took 1.008 seconds,   11.909 KB/s
SHA1                22 KB took 1.009 seconds,   21.797 KB/s
SHA256              22 KB took 1.034 seconds,   21.270 KB/s
RSA     2048 key gen        3 ops took 15.828 sec, avg 5275.861 ms, 0.190 ops/sec
RSA     2048 Public        22 ops took 1.034 sec, avg 47.021 ms, 21.267 ops/sec
RSA     2048 Private        9 ops took 1.059 sec, avg 117.677 ms, 8.498 ops/sec
RSA     2048 Pub  OAEP     21 ops took 1.007 sec, avg 47.959 ms, 20.851 ops/sec
RSA     2048 Priv OAEP      9 ops took 1.066 sec, avg 118.423 ms, 8.444 ops/sec
ECC      256 key gen        7 ops took 1.072 sec, avg 153.140 ms, 6.530 ops/sec
ECDSA    256 sign          18 ops took 1.056 sec, avg 58.674 ms, 17.043 ops/sec
ECDSA    256 verify        24 ops took 1.031 sec, avg 42.970 ms, 23.272 ops/sec
ECDHE    256 agree         16 ops took 1.023 sec, avg 63.934 ms, 15.641 ops/sec
```

Nations Technologies Inc. TPM 2.0 モジュール 33MHz上で実行:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                 12 KB took 1.065 seconds,   11.270 KB/s
AES-128-CBC-enc     48 KB took 1.026 seconds,   46.780 KB/s
AES-128-CBC-dec     48 KB took 1.039 seconds,   46.212 KB/s
AES-256-CBC-enc     48 KB took 1.035 seconds,   46.370 KB/s
AES-256-CBC-dec     48 KB took 1.025 seconds,   46.852 KB/s
Benchmark symmetric AES-128-CTR-enc not supported!
Benchmark symmetric AES-128-CTR-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
AES-128-CFB-enc     50 KB took 1.029 seconds,   48.591 KB/s
AES-128-CFB-dec     50 KB took 1.035 seconds,   48.294 KB/s
AES-256-CFB-enc     48 KB took 1.000 seconds,   47.982 KB/s
AES-256-CFB-dec     48 KB took 1.003 seconds,   47.855 KB/s
SHA1                80 KB took 1.009 seconds,   79.248 KB/s
SHA256              80 KB took 1.004 seconds,   79.702 KB/s
SHA384              78 KB took 1.018 seconds,   76.639 KB/s
RSA     2048 key gen        8 ops took 17.471 sec, avg 2183.823 ms, 0.458 ops/sec
RSA     2048 Public        52 ops took 1.004 sec, avg 19.303 ms, 51.805 ops/sec
RSA     2048 Private        8 ops took 1.066 sec, avg 133.243 ms, 7.505 ops/sec
RSA     2048 Pub  OAEP     51 ops took 1.001 sec, avg 19.621 ms, 50.966 ops/sec
RSA     2048 Priv OAEP      8 ops took 1.073 sec, avg 134.182 ms, 7.453 ops/sec
ECC      256 key gen       20 ops took 1.037 sec, avg 51.871 ms, 19.279 ops/sec
ECDSA    256 sign          43 ops took 1.006 sec, avg 23.399 ms, 42.736 ops/sec
ECDSA    256 verify        28 ops took 1.030 sec, avg 36.785 ms, 27.185 ops/sec
ECDHE    256 agree         26 ops took 1.010 sec, avg 38.847 ms, 25.742 ops/sec
```

Nuvoton NPCT650で実行:

```
./examples/bench/bench
TPM2 Benchmark using Wrapper API's
RNG                  8 KB took 1.291 seconds,    6.197 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
Benchmark symmetric AES-256-CTR-enc not supported!
Benchmark symmetric AES-256-CTR-dec not supported!
Benchmark symmetric AES-256-CFB-enc not supported!
Benchmark symmetric AES-256-CFB-dec not supported!
SHA1                90 KB took 1.005 seconds,   89.530 KB/s
SHA256              90 KB took 1.010 seconds,   89.139 KB/s
RSA     2048 key gen        8 ops took 35.833 sec, avg 4479.152 ms, 0.223 ops/sec
RSA     2048 Public        77 ops took 1.007 sec, avg 13.078 ms, 76.463 ops/sec
RSA     2048 Private        2 ops took 1.082 sec, avg 540.926 ms, 1.849 ops/sec
RSA     2048 Pub  OAEP     53 ops took 1.005 sec, avg 18.961 ms, 52.739 ops/sec
RSA     2048 Priv OAEP      2 ops took 1.088 sec, avg 544.075 ms, 1.838 ops/sec
ECC      256 key gen        7 ops took 1.033 sec, avg 147.608 ms, 6.775 ops/sec
ECDSA    256 sign           6 ops took 1.141 sec, avg 190.149 ms, 5.259 ops/sec
ECDSA    256 verify         4 ops took 1.061 sec, avg 265.216 ms, 3.771 ops/sec
ECDHE    256 agree          6 ops took 1.055 sec, avg 175.915 ms, 5.685 ops/sec
```

Nuvoton NPCT750 43MHz上で実行:

```
RNG                 16 KB took 1.114 seconds,   14.368 KB/s
Benchmark symmetric AES-128-CBC-enc not supported!
Benchmark symmetric AES-128-CBC-dec not supported!
Benchmark symmetric AES-256-CBC-enc not supported!
Benchmark symmetric AES-256-CBC-dec not supported!
SHA1               120 KB took 1.012 seconds,  118.618 KB/s
SHA256             122 KB took 1.012 seconds,  120.551 KB/s
SHA384             120 KB took 1.003 seconds,  119.608 KB/s
RSA     2048 key gen        5 ops took 17.043 sec, avg 3408.678 ms, 0.293 ops/sec
RSA     2048 Public       134 ops took 1.004 sec, avg 7.490 ms, 133.517 ops/sec
RSA     2048 Private       15 ops took 1.054 sec, avg 70.261 ms, 14.233 ops/sec
RSA     2048 Pub  OAEP    116 ops took 1.002 sec, avg 8.636 ms, 115.797 ops/sec
RSA     2048 Priv OAEP     15 ops took 1.061 sec, avg 70.716 ms, 14.141 ops/sec
ECC      256 key gen       12 ops took 1.008 sec, avg 84.020 ms, 11.902 ops/sec
ECDSA    256 sign          18 ops took 1.015 sec, avg 56.399 ms, 17.731 ops/sec
ECDSA    256 verify        26 ops took 1.018 sec, avg 39.164 ms, 25.533 ops/sec
ECDHE    256 agree         35 ops took 1.029 sec, avg 29.402 ms, 34.011 ops/sec
```
