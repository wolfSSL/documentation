# Renesas製品におけるwolfBootの使用

対応プラットフォーム：

- Renesas RZ (RZN2L) (RSIP)
   - [chapter03.md#renesas-rzn2l](chapter03.md#renesas-rzn2l)
   - IDE/Renesas/e2studio/RZN2L/Readme.md
   - IDE/Renesas/e2studio/RZN2L/Readme_wRSIP.md
- Renesas RA (RA6M4) (SCE)
   - [chapter03.md#renesas-ra6m4](chapter03.md#renesas-ra6m4)
   - IDE/Renesas/e2studio/RA6M4/Readme.md
   - IDE/Renesas/e2studio/RA6M4/Readme_withSCE.md
- Renesas RX (RX65N/RX72N) (TSIP)
   - [chapter03.md#renesas-rx72n](chapter03.md#renesas-rx72n)
   - IDE/Renesas/e2studio/RX72N/Readme.md
   - IDE/Renesas/e2studio/RX72N/Readme_withTSIP.md

すべての実装例はe2Studioの使用をサポートしています。
Renesas RXパーツは、rx-elf-gccクロスコンパイラと例の.configファイルを使用したwolfBoot Makefileの使用をサポートしています。

## セキュリティ鍵管理ツール（SKMT）鍵ラッピング

1) Renesas鍵ラップアカウントを設定し、PGP鍵交換を行います。
<https://dlm.renesas.com/keywrap>
RenesasからPGP/GPGにインポートする必要がある公開鍵「`keywrap-pub.key`」が提供されます。

注意：RSA 4096ビット鍵は使用できません。RSA-2048またはRSA-3072を使用する必要があります。

2) 「セキュリティ鍵管理ツール」を使用して32バイトのUFPK（ユーザーファクトリプログラミング鍵）を作成します。これはランダムな32バイト値でも構いません。

例：ランダムな32バイト `B94A2B96 1C755101 74F0C967 ECFC20B3 77C7FB25 6DB627B1 BFFADEE0 5EE98AC4`

3) 32バイトバイナリファイルに「`sample.key`」をPGPで署名して暗号化します。結果は「`sample.key.gpg`」です。
GPG4Winと署名/暗号化オプションを使用します。自分のGPG鍵で署名し、Renesas公開鍵で暗号化します。

4) <https://dlm.renesas.com/keywrap> を使用して「`sample.key.gpg`」をラップします。
RenesasとRX TSIPの両方がRenesasファクトリから事前にプロビジョニングされている隠しルート鍵（HRK）を使用します。
結果は「`sample.key_enc.key`」です。

例：`00000001 6CCB9A1C 8AA58883 B1CB02DE 6C37DA60 54FB94E2 06EAE720 4D9CCF4C 6EEB288C`

## RX TSIP

1) Renesas用の鍵ツールをビルド

```sh
# Build keytools for Renesas RX (TSIP)
$ make keytools RENESAS_KEY=2
```

2) 公開鍵を新規作成またはインポート

以下の手順はECDSA P384（SECP384R1）用です。
SECP256R1の場合は、「ecc384」を「ecc256」に、「secp384r1」を「secp256r1」に置き換えてください。

新しい署名鍵を作成：

```sh
# Create new signing key
$ ./tools/keytools/keygen --ecc384 -g ./pri-ecc384.der
Keytype: ECC384
Generating key (type: ECC384)
Associated key file:   ./pri-ecc384.der
Partition ids mask:   ffffffff
Key type   :           ECC384
Public key slot:       0
Done.

# Export public portion of key as PEM
$ openssl ec -inform der -in ./pri-ecc384.der -pubout -out ./pub-ecc384.pem
```

または

公開鍵をインポート：

```sh
# Export public portion of key as DER
$ openssl ec -inform der -in ./pri-ecc384.der -pubout -outform der -out ./pub-ecc384.der

# Import public key and populate src/keystore.c
$ ./tools/keytools/keygen --ecc384 -i ./pub-ecc384.der
Keytype: ECC384
Associated key file:   ./pub-ecc384.der
Partition ids mask:   ffffffff
Key type   :           ECC384
Public key slot:       0
Done.
```

3) ラップされた公開鍵（コードファイル）の作成

Security Key Management Tool（SKMT）コマンドラインツール（CLI）を使用して、ラップされた公開鍵を作成します。

ユーザー暗号化鍵を使用して公開鍵をラップし、key_data.cとkey_data.hファイルを出力します。

```sh
$ C:\Renesas\SecurityKeyManagementTool\cli\skmt.exe -genkey -ufpk file=./sample.key -wufpk file=./sample.key_enc.key -key file=./pub-ecc384.pem -mcu RX-TSIP -keytype secp384r1-public -output include/key_data.c -filetype csource -keyname enc_pub_key
Output File: include\key_data.h
Output File: include\key_data.c
UFPK: B94A2B961C75510174F0C967ECFC20B377C7FB256DB627B1BFFADEE05EE98AC4
W-UFPK: 000000016CCB9A1C8AA58883B1CB02DE6C37DA6054FB94E206EAE7204D9CCF4C6EEB288C
IV: 6C296A040EEF5EDD687E8D3D98D146D0
Encrypted key: 5DD8D7E59E6AC85AE340BBA60AA8F8BE56C4C1FE02340C49EB8F36DA79B8D6640961FE9EAECDD6BADF083C5B6060C1D0309D28EFA25946F431979B9F9D21E77BDC5B1CC7165DE2F4AE51E418746260F518ED0C328BD3020DEC9B774DC00270B0CFBBE3DD738FDF715342CFBF2D461239
```

4) ラップされた公開鍵（フラッシュファイル）の作成

ラップされた鍵をフラッシュに書き込むためのMotorolaヘックスファイルを生成します。

```sh
$ C:\Renesas\SecurityKeyManagementTool\cli\skmt.exe -genkey -ufpk file=./sample.key -wufpk file=./sample.key_enc.key -key file=./pub-ecc384.pem -mcu RX-TSIP -keytype secp384r1-public -output pub-ecc384.srec -filetype "mot" -address FFFF0000
Output File: Y:\GitHub\wolfboot\pub-ecc384.srec
UFPK: B94A2B961C75510174F0C967ECFC20B377C7FB256DB627B1BFFADEE05EE98AC4
W-UFPK: 000000016CCB9A1C8AA58883B1CB02DE6C37DA6054FB94E206EAE7204D9CCF4C6EEB288C
IV: 9C13402DF1AF631DC2A10C2424182601
Encrypted key: C4A0B368552EB921A3AF3427FD7403BBE6CB8EE259D6CC0692AA72D46F7343F5FFE7DA97A1C811B21BF392E3834B67C3CE6F84707CCB8923D4FBB8DA003EF23C1CD785B6F58E5DB161F575F78D646434AC2BFAF207F6FFF6363C800CFF7E7BFF4857452A70C496B675D08DD6924CAB5E
```

生成されたファイルは、`0xFFFF0000`アドレスを使用する指示を含むラップされた公開鍵を含むMotorolaヘックス（S-Record）フォーマットのイメージです。

```
S00E00007075622D65636333737265D5
S315FFFF000000000000000000006CCB9A1C8AA58883C5
S315FFFF0010B1CB02DE6C37DA6054FB94E206EAE720E7
S315FFFF00204D9CCF4C6EEB288C9C13402DF1AF631D7F
S315FFFF0030C2A10C2424182601C4A0B368552EB921EA
S315FFFF0040A3AF3427FD7403BBE6CB8EE259D6CC06AE
S315FFFF005092AA72D46F7343F5FFE7DA97A1C811B27D
S315FFFF00601BF392E3834B67C3CE6F84707CCB8923ED
S315FFFF0070D4FBB8DA003EF23C1CD785B6F58E5DB1F0
S315FFFF008061F575F78D646434AC2BFAF207F6FFF66C
S315FFFF0090363C800CFF7E7BFF4857452A70C496B6D9
S311FFFF00A075D08DD6924CAB5ED6FF44C5E3
S705FFFF0000FC
```

デフォルトのフラッシュメモリアドレスは`0xFFFF0000`ですが、変更できます。

以下の2か所を設定する必要があります。

a) `user_settings.h`ビルドマクロ`RENESAS_TSIP_INSTALLEDKEY_ADDR`
b) リンカースクリプトの`.rot`セクション（例：`hal/rx72n.ld`または`hal/rx65n.ld`）。

5) .configの`PKA?=1`を編集

6) wolfBootを再ビルド

```sh
$ make clean && make wolfboot.srec
```

7) アプリケーションに署名

上記で作成した秘密鍵`pri-ecc384.der`を使用してアプリケーションに署名します。

```sh
$ ./tools/keytools/sign --ecc384 --sha256 test-app/image.bin pri-ecc384.der 1
wolfBoot KeyTools (Compiled C version)
wolfBoot version 2010000
Update type:          Firmware
Input image:          test-app/image.bin
Selected cipher:      ECC384
Selected hash  :      SHA256
Public key:           pri-ecc384.der
Output  image:        test-app/image_v1_signed.bin
Target partition id : 1
image header size overridden by config value (1024 bytes)
Calculating SHA256 digest...
Signing the digest...
Output image(s) successfully created.
```

8) `wolfboot.srec`、`pub-ecc384.srec`および署名済みアプリケーションバイナリをフラッシュに書き込み

Renesasフラッシュプログラマーを使用してファイルをフラッシュにダウンロードします。


### RX TSIPベンチマーク

| ハードウェア | クロック | アルゴリズム      | RX TSIP  | デバッグ  | リリース (-Os) | リリース (-O2) |
| ------------ | -------- | ----------------- | -------- | --------- | ------------- | ------------- |
| RX72N        | 240MHz   | ECDSA検証 P384    | 17.26 ms | 1570 ms   |  441 ms       |  313 ms       |
| RX72N        | 240MHz   | ECDSA検証 P256    |  2.73 ms |  469 ms   |  135 ms       |  107 ms       |
| RX65N        | 120MHz   | ECDSA検証 P384    | 18.57 ms | 4213 ms   | 2179 ms       | 1831 ms       |
| RX65N        | 120MHz   | ECDSA検証 P256    |  2.95 ms | 1208 ms   |  602 ms       |  517 ms       |
