# wolfBoot TPMサポート

wolfBootでは、TPMベースのRoot of Trust、シーリング/アンシーリング、暗号化オフローディング、TPMを使用したMeasured Bootをサポートしています。

## ビルドオプション

| 設定オプション | プリプロセッサマクロ | 説明                         |
| ------------- | ------------------ | ----------------------------------- |
| `WOLFTPM=1`   | `WOLFBOOT_TPM`     | wolfTPMサポートを有効にします |
| `WOLFBOOT_TPM_VERIFY=1` | `WOLFBOOT_TPM_VERIFY` | RSA2048およびECC256/384の暗号化オフローディングをTPMに対して有効にします。 |
| `WOLFBOOT_TPM_KEYSTORE=1` | `WOLFBOOT_TPM_KEYSTORE` | TPMベースのRoot of Trustを有効にします。NVインデックスには信頼された公開鍵のハッシュを保存する必要があります。 |
| `WOLFBOOT_TPM_KEYSTORE_NV_BASE=0x` | `WOLFBOOT_TPM_KEYSTORE_NV_BASE=0x` | プラットフォーム範囲0x1400000 - 0x17FFFFFのNVインデックス。|
| `WOLFBOOT_TPM_KEYSTORE_AUTH=secret` | `WOLFBOOT_TPM_KEYSTORE_AUTH` | NVアクセス用のパスワード |
| `MEASURED_BOOT=1` | `WOLFBOOT_MEASURED_BOOT` | Measured Bootを有効にします。wolfBootハッシュでPCRを拡張します。 |
| `MEASURED_PCR_A=16` | `WOLFBOOT_MEASURED_PCR_A=16` | 使用するPCRインデックス。[付録G](appendix07.md)を参照してください。 |
| `WOLFBOOT_TPM_SEAL=1` | `WOLFBOOT_TPM_SEAL` | 外部で署名されたPCRポリシーに基づくシーリング/アンシーリングのサポートを有効にします。 |
| `WOLFBOOT_TPM_SEAL_NV_BASE=0x01400300` | `WOLFBOOT_TPM_SEAL_NV_BASE` | プラットフォーム階層内のデフォルトのシールされたブロブストレージの場所をオーバーライドします。 |
| `WOLFBOOT_TPM_SEAL_AUTH=secret` | `WOLFBOOT_TPM_SEAL_AUTH` | シーリング/アンシーリングの秘密のためのパスワード、省略された場合はPCRポリシーが使用されます |

## Root of Trust (RoT)

wolfTPM Secure Root of Trust（RoT）の例は[こちら](https://github.com/wolfSSL/wolfTPM/tree/master/examples/boot)をご覧ください。

この設計では、ロックされたプラットフォームNVハンドルを使用します。
NVには公開鍵のハッシュが保存されます。
TPMの改ざんを防ぐために、派生した「認証」値を提供することをお勧めします。
この認証値はバス上で暗号化されます。

## 暗号化オフローディング

RSA2048およびECC256/384ビットの検証は、コードサイズの削減またはパフォーマンス向上のためにTPMにオフロードできます。`WOLFBOOT_TPM_VERIFY`を使用して有効にします。

注意：TPMのRSA検証にはASN.1エンコーディングが必要なため、SIGN=RSA2048ENCを使用してください。

## Measured Boot

wolfBootイメージはハッシュ化され、指定されたPCRに拡張されます。これは後でアプリケーションで、ブートプロセスが改ざんされていないことを証明するために使用できます。
`WOLFBOOT_MEASURED_BOOT`で有効にし、API `wolfBoot_tpm2_extend`を公開します。

## 秘密のシーリングとアンシーリング

wolfTPMのシーリング/アンシーリングの例は[こちら](https://github.com/wolfSSL/wolfTPM/tree/master/examples/boot#secure-boot-encryption-key-storage)をご覧ください。

既知のPCR値は、秘密をシール/アンシールするために署名される必要があります。
認証ポリシーの署名は、`--policy`引数を使用して署名されたヘッダーに配置されます。
ヘッダーに署名されたポリシーがない場合、値はシールされません。
代わりに、PCR値とPCRポリシーダイジェストが外部で署名するために表示されます。
`./tools/keytools/sign`または`./tools/tpm/policy_sign`を使用して、ポリシーに外部で署名できます。

これにより、NVインデックスに保存されたブロブでデータをシールおよびアンシールするための2つの新しいwolfBoot APIが公開されます。

```c
int wolfBoot_seal_auth(const uint8_t* pubkey_hint, const uint8_t* policy, uint16_t policySz,
    int index, const uint8_t* secret, int secret_sz, const byte* auth, int authSz);
int wolfBoot_unseal_auth(const uint8_t* pubkey_hint, const uint8_t* policy, uint16_t policySz,
    int index, uint8_t* secret, int* secret_sz, const byte* auth, int authSz);
```

デフォルトでは、このインデックスは`(0x01400300 + index)`のNVインデックスに基づきます。
デフォルトのNVベースは`WOLFBOOT_TPM_SEAL_NV_BASE`でオーバーライドできます。

注意：TPMのRSA検証にはASN.1エンコーディングが必要なため、SIGN=RSA2048ENCを使用してください。

### シミュレータでのシール/アンシールのテスト

```sh
% cp config/examples/sim-tpm-seal.config .config
% make keytools
% make tpmtools
% echo aaa > aaa.bin
% ./tools/tpm/pcr_extend 0 aaa.bin
% ./tools/tpm/policy_create -pcr=0
# if ROT enabled
% ./tools/tpm/rot -write [-auth=TestAuth]
% make clean
$ make POLICY_FILE=policy.bin [WOLFBOOT_TPM_KEYSTORE_AUTH=TestAuth] [WOLFBOOT_TPM_SEAL_AUTH=SealAuth]

% ./wolfboot.elf get_version
Simulator assigned ./internal_flash.dd to base 0x103378000
Mfg IBM  (0), Vendor SW   TPM, Fw 8217.4131 (0x163636), FIPS 140-2 1, CC-EAL4 0
Unlocking disk...
Boot partition: 0x1033f8000
Image size 54400
Error 395 reading blob from NV index 1400300 (error TPM_RC_HANDLE)
Error 395 unsealing secret! (TPM_RC_HANDLE)
Sealed secret does not exist!
Creating new secret (32 bytes)
430dee45553c4a8b75fbc6bcd0890765c48cab760b24b1aa6b633dc0538e0159
Wrote 210 bytes to NV index 0x1400300
Read 210 bytes from NV index 0x1400300
Secret Check 32 bytes
430dee45553c4a8b75fbc6bcd0890765c48cab760b24b1aa6b633dc0538e0159
Secret 32 bytes
430dee45553c4a8b75fbc6bcd0890765c48cab760b24b1aa6b633dc0538e0159
Boot partition: 0x1033f8000
Image size 54400
TPM Root of Trust valid (id 0)
Simulator assigned ./internal_flash.dd to base 0x103543000
1

% ./wolfboot.elf get_version
Simulator assigned ./internal_flash.dd to base 0x10c01c000
Mfg IBM  (0), Vendor SW   TPM, Fw 8217.4131 (0x163636), FIPS 140-2 1, CC-EAL4 0
Unlocking disk...
Boot partition: 0x10c09c000
Image size 54400
Read 210 bytes from NV index 0x1400300
Secret 32 bytes
430dee45553c4a8b75fbc6bcd0890765c48cab760b24b1aa6b633dc0538e0159
Boot partition: 0x10c09c000
Image size 54400
TPM Root of Trust valid (id 0)
Simulator assigned ./internal_flash.dd to base 0x10c1e7000
1
```

### 実際のハードウェアでのシール/アンシールのテスト

1) ポリシー用の実際のPCRダイジェストを取得します。

2) ポリシーに署名し、ファームウェアイメージヘッダーに含めます。

#### PCR値の取得

署名されたポリシーが存在しない場合、シール機能はアクティブなPCR、PCRダイジェスト、ポリシーダイジェスト（署名用）を生成して表示します。

```sh
% make tpmtools
% ./tools/tpm/rot -write
% ./tools/tpm/pcr_reset 16
% ./wolfboot.elf get_version
Simulator assigned ./internal_flash.dd to base 0x101a64000
Mfg IBM  (0), Vendor SW   TPM, Fw 8217.4131 (0x163636), FIPS 140-2 1, CC-EAL4 0
Boot partition: 0x101ae4000
Image size 57192
Policy header not found!
Generating policy based on active PCR's!
Getting active PCR's (0-16)
PCR 16 (counter 20)
8f7ac1d5a5eac58a2305ca459f27c35705a9212c0fb2a9088b1df761f3d5f842
Found 1 active PCR's (mask 0x00010000)
PCR Digest (32 bytes):
f84085631f85333ad0338b06c82f16888b7923abaccffb881d5416e389be256c
PCR Mask (0x00010000) and PCR Policy Digest (36 bytes):
0000010034ba061436aba2e9a167a1ee46af4a9578a8c6b9f71fdece21607a0cb40468ec
Use this policy with the sign tool (--policy arg) or POLICY_FILE config
Image policy signature missing!
Boot partition: 0x101ae4000
Image size 57192
TPM Root of Trust valid (id 0)
Simulator assigned ./internal_flash.dd to base 0x101c2f000
1
```

上記の`0000010034ba061436aba2e9a167a1ee46af4a9578a8c6b9f71fdece21607a0cb40468ec`は鍵ツールで直接使用できます。

`echo "0000010034ba061436aba2e9a167a1ee46af4a9578a8c6b9f71fdece21607a0cb40468ec" | xxd -r -p > policy.bin`

または、署名するダイジェストを生成するために`tools/tpm/policy_create`ツールを使用します。
使用するPCRは「`-pcr=#`」を使用して設定する必要があります。PCRダイジェストは「`-pcrdigest=`」を使用して提供するか、提供されない場合はTPMから直接読み取られます。

```sh
% ./tools/tpm/policy_create -pcr=16 -pcrdigest=f84085631f85333ad0338b06c82f16888b7923abaccffb881d5416e389be256c -out=policy.bin
# OR
% ./tools/tpm/policy_create -pcrmask=0x00010000 -pcrdigest=f84085631f85333ad0338b06c82f16888b7923abaccffb881d5416e389be256c -out=policy.bin
Policy Create Tool
PCR Index(s) (SHA256): 16  (mask 0x00010000)
PCR Digest (32 bytes):
	f84085631f85333ad0338b06c82f16888b7923abaccffb881d5416e389be256c
PCR Mask (0x00010000) and PCR Policy Digest (36 bytes):
	0000010034ba061436aba2e9a167a1ee46af4a9578a8c6b9f71fdece21607a0cb40468ec
Wrote 36 bytes to policy.bin
```

#### ポリシーの署名

署名するポリシーダイジェストを含むファームウェアのビルドは次のように実行します。

```sh
% make POLICY_FILE=policy.bin
```

あるいは、`tools/tpm/policy_sign`または`tools/keytools/sign`ツールを使用してポリシーに手動で署名します。
これらのツールはTPMへのアクセスを必要とせず、ポリシーダイジェストに署名します。
結果は32ビットのPCRマスク + 署名です。

policy_signツールで署名する場合：

```sh
% ./tools/tpm/policy_sign -pcr=0 -pcrdigest=eca4e8eda468b8667244ae972b8240d3244ea72341b2bf2383e79c66643bbecc
Sign PCR Policy Tool
Signing Algorithm: ECC256
PCR Index(s) (SHA256): 0
Policy Signing Key: wolfboot_signing_private_key.der
PCR Digest (32 bytes):
	eca4e8eda468b8667244ae972b8240d3244ea72341b2bf2383e79c66643bbecc
PCR Policy Digest (32 bytes):
	2d401eb05f45ba2b15c35f628b5896cc7de9745bb6e722363e2dbee804e0500f
PCR Policy Digest (w/PolicyRef) (32 bytes):
	749b3139ece21449a7828f11ee05303b0473ff1a26cf41d6f9ff28b24c717f02
PCR Mask (0x1) and Policy Signature (68 bytes):
	01000000
	5b5f875b3f7ce78b5935abe4fc5a4d8a6e87c4b4ac0836fbab909e232b6d7ca2
	3ecfc6be723b695b951ba2886d3c7b83ab2f8cc0e96d766bc84276eaf3f213ee
Wrote PCR Mask + Signature (68 bytes) to policy.bin.sig
```

署名鍵ツールを使用する場合：

```sh
% ./tools/keytools/sign --ecc256 --policy policy.bin test-app/image.elf wolfboot_signing_private_key.der 1
wolfBoot KeyTools (Compiled C version)
wolfBoot version 1100000
Update type:          Firmware
Input image:          test-app/image.elf
Selected cipher:      ECC256
Selected hash  :      SHA256
Public key:           wolfboot_signing_private_key.der
Output  image:        test-app/image_v1_signed.bin
Target partition id : 1
image header size calculated at runtime (256 bytes)
Calculating SHA256 digest...
Signing the digest...
Opening policy file policy.bin
Signing the policy digest...
Saving policy signature to policy.bin.sig
Output image(s) successfully created.
```
