### CA コマンド
証明書への署名に使用されます。設定ファイルの基本的な解析を処理できます。

設定ファイルのディレクティブの詳細は[設定ファイル](config.md)を参照してください。

引数:

- [-in] 入力CSRファイル
- [-out] 出力先ファイル
- [-keyfile] 秘密鍵ファイル
- [-cert] CA証明書ファイル
- [-extensions] 設定ファイル内の拡張セクション
- [-md] ハッシュタイプ（sha、sha256 など）
- [-inform] CSRファイル形式（PEM/DER）
- [-config] 設定ファイル
- [-days] 証明書の有効期間（日数）
- [-selfsign] 入力証明書に関連付けられた鍵で署名

使用例:

```
wolfssl ca -config ca.conf -in test.csr -out test.pem -md sha256 -selfsign -keyfile ./key
```

### 典型的なワークフロー：CAでCSRに署名

**ステップ1: CA鍵と証明書を作成**（[GENKEY コマンド](genkey.md)と[REQ コマンド](req.md)を参照）

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
wolfssl req -new -x509 -key ca.priv -out ca.pem -days 3650 -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=Example/CN=Example CA"
```

**ステップ2: サーバー鍵とCSRを作成**

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
wolfssl req -new -key server.priv -out server.csr -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=Example/CN=example.com"
```

**ステップ3: サーバーCSRをCAで署名**

```
wolfssl ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

**ステップ4: 署名済み証明書を検証**（[VERIFY コマンド](verify.md)を参照）

```
wolfssl verify -CAfile ca.pem server-signed.pem
```

### CAでの設定ファイルの使用

`-config` オプションを使用すると、署名時に追加する証明書拡張を指定できます。

CA設定ファイルの例（`ca.conf`）：

```ini
[ca]
x509_extensions = v3_ca

[v3_ca]
basicConstraints = critical, CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
```

設定ファイルの拡張を使用してCSRに署名：

```
wolfssl ca -config ca.conf -extensions v3_ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

