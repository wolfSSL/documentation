# Microsoft Azure Key Vaultを使用したファームウェアの署名

Microsoftは、HSMに保存された鍵を使用して安全な鍵管理およびプロビジョニングツールを提供しています。
このメカニズムは、管理された鍵を使用したペイロードの署名のサポートを含む複数の目的のための鍵管理を一元化するのに役立ちます。
これはwolfBootと組み合わせて、複数台のデバイスに公開鍵をプロビジョニングするために使用できます。

## 鍵ストアの準備

wolfBootは提供される`keygen`コマンドラインツールを使用して、鍵ストアに公開鍵をインポートできます。
`keygen`は生のECC鍵とASN.1形式（.der）の両方をサポートしています。

Azureでは、デバイスをプロビジョニングするためにASN.1形式で公開鍵をダウンロードできます。
wolfBootでのファームウェア認証に使用する各公開鍵を取得するには、以下を使用します。

```sh
az keyvault key download --vault-name <vault-name> -n test-signing-key-1 -e DER -f public-key-1.der
```

鍵ストアは、`keygen`の`-i`（インポート）オプションを使用して公開鍵をインポートして作成できます。
このオプションは、鍵ストアにさらに多くの鍵を追加するために複数回繰り返すことができます。

```sh
./tools/keytools/keygen --ecc256 -i public-key-1.der [-i public-key-2.der ...]
```

## wolfBoot用のファームウェアイメージの署名

任意の外部HSMを使用した署名操作は、[付録B](appendix02.md)の関連セクションに記載されているように、3つのステップで実行されます。
このセクションでは、Azure Key Vaultを使用してファームウェアイメージに署名する手順について説明します。

### SHA256ダイジェストの取得

ステップ1では、`--sha-only`引数を加えて`./sign`ツールを呼び出し、署名するダイジェストを生成します。
Vault内で選択した署名鍵に関連付けられた公開鍵を提供する必要があります。

```sh
./tools/keytools/sign --ecc256 --sha-only --sha256 test-app/image.bin public-key-1.der 1
```

https RESTリクエストに適合させるために、取得したダイジェストはbase64を使用してエンコードする必要があります。

```sh
DIGEST=$(cat test-app/image_v1_digest.bin | base64url_encode)
```

変数`DIGEST`には、リクエストに添付できる鍵の印刷可能なエンコーディングが保存されています。

### Key Vaultを使用してダイジェストに署名するためのHTTPSリクエスト

リクエストを準備するために、まずVaultからアクセストークンを取得し、変数に保存します。

```sh
ACCESS_TOKEN=$(az account get-access-token --resource "https://vault.azure.net" --query "accessToken" -o tsv)
```

選択したKey Vaultに関連付けられたURLを使用します。

```sh
KEY_IDENTIFIER="https://<vault-name>.vault.azure.net/keys/test-signing-key"
```

cURLを使用してリクエストを実行し、結果を変数に保存します。

```sh
SIGNING_RESULT=$(curl -X POST \
    -s "${KEY_IDENTIFIER}/sign?api-version=7.4" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "Content-Type:application/json" \
    -H "Accept:application/json" \
    -d "{\"alg\":\"ES256\",\"value\":\"${DIGEST}\"}")
echo $SIGNING_RESULT
```

結果の`.value`フィールドには（base64でエンコードされた）署名が含まれています。
レスポンスから署名を抽出するには、JSONパーサーを使用できます。

```sh
SIGNATURE=$(jq -jn "$SIGNING_RESULT|.value")
```

署名はbase64からバイナリにデコードできるようになり、`sign`ツールはその署名をマニフェストヘッダーに組み込むことができます。

```sh
echo $SIGNATURE| base64url_decode > test-app/image_v1_digest.sig
```

### 最終ステップ：署名されたファームウェアイメージの作成

HSM 3ステップの第3段階では、`--manual-sign`オプションとAzure REST APIを通じて取得した署名が必要です。

```sh
./tools/keytools/sign --ecc256 --sha256 --manual-sign test-app/image.bin test-signin-key_pub.der 1 test-app/image_v1_digest.sig
```

結果のバイナリファイル`image_v1_signed.bin`には、wolfBootによって認証およびステージングできる署名付きファームウェアイメージが保存されます。
