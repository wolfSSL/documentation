### VERIFY コマンド — X.509 証明書の検証

`wolfssl verify` コマンドは、**信頼された認証局（Certificate Authority: CA）** に基づいて  
X.509 証明書を **検証** するために使用されます。

本コマンドは OpenSSL の `openssl verify` コマンドと同様の
証明書チェーン検証を行いますが、
一般的な検証シナリオに焦点を当てた簡易的な機能セットとなっています。

CA 証明書を用いた検証に加え、
任意で中間証明書の指定や証明書失効リスト（CRL）による失効確認をサポートします。

---

#### 機能概要

`verify` コマンドは、X.509 証明書に対して以下の検証を行います。

- 信頼された CA による証明書署名の検証
- 証明書チェーンの検証（ルート証明書および中間証明書）
- 任意で CRL に基づく証明書失効チェック

検証に成功した場合、標準出力に `OK` が表示されます。  
検証に失敗した場合は、エラーコードおよび理由が出力されます。

---

#### コマンド構文

```sh
wolfssl verify -CAfile <ca file> \
  [-untrusted <intermediate file>] \
  [-crl_check] \
  [-partial_chain] \
  <certificate to verify>
```

#### 入力

- **CA 証明書**
  - `-CAfile` オプションで指定する、信頼されたルート CA 証明書
- **中間証明書（任意）**
  - `-untrusted` オプションで指定する中間証明書
- **検証対象証明書**
  - コマンドラインの最後の引数として指定する、検証対象の証明書

---

#### 共通オプション

| オプション | 説明 |
|------|-------------|
| `-CAfile <file>` | 検証に使用する信頼済み CA 証明書 |
| `-untrusted <file>` | 証明書チェーン構築に使用する中間証明書 |
| `-crl_check` | 証明書失効リスト（CRL）を用いた失効チェックを有効化 |
| `-partial_chain` | 不完全な証明書チェーンでも検証を許可 |

> **注意:**  
> 現在の実装では、`-untrusted` オプションで指定できる
> 中間証明書は **1 つのみ** です。

---

#### 検証時の挙動

- 最後の引数で指定された証明書は、`-CAfile` で指定された
  信頼済み CA に基づいて検証されます。
- `-untrusted` が指定された場合、その証明書は
  チェーン構築時の中間証明書として使用されます。
- `-crl_check` を指定すると、利用可能な CRL を用いて
  証明書が失効していないか確認されます。
- `-partial_chain` を指定した場合、自己署名ルート証明書までの
  完全なチェーンが存在しなくても、検証が成功する場合があります。

---

#### 注意事項

- `-CAfile` オプションは必須です。
- `-untrusted` で指定可能な中間証明書は 1 つのみです。
- CRL チェックを使用するには、wolfSSL を CRL サポート有効で
  ビルドしている必要があります。
- 本コマンドは検証のみを行い、不足している証明書や CRL を
  自動取得することはありません。

---

#### 例

CA 証明書を用いて証明書を検証する例:

```sh
wolfssl verify -CAfile ca-cert.pem server-cert.pem
```


中間証明書を指定して検証する例:

```sh
wolfssl verify -CAfile ca-cert.pem \
  -untrusted intermediate-cert.pem \
  server-cert.pem
```

CRL チェックを有効にして検証する例:

```sh
wolfssl verify -CAfile ca-cert.pem -crl_check server-cert.pem
```