### REQ コマンド
証明書署名リクエスト（CSR）または自己署名証明書の作成に使用されます。証明書をセットアップするための設定ファイル（.conf）の基本的な解析を処理できます。設定ファイルが使用されていない場合、stdinで証明書情報の入力を求められます。

設定ファイルのディレクティブの詳細は[設定ファイル](config.md)を参照してください。

引数:

- [-in] 入力ファイル
- [-out] 出力先ファイル（デフォルト：stdout）
- [-key] 証明書リクエストに含める公開鍵ファイル
- [-inform] 入力ファイル形式：der または pem（デフォルト：pem）
- [-outform] 出力ファイル形式：der または pem（デフォルト：pem）
- [-config] 証明書の設定ファイル
- [-days] 有効期間（日数）
- [-x509] 自己署名証明書を生成
- [-extensions] 拡張を取得するセクションを上書き
- [-nodes] 秘密鍵出力にDES暗号化を使用しない
- [-newkey] reqで使用する秘密鍵を生成
- [-inkey] reqで使用する秘密鍵
- [-keyout] 鍵の出力先ファイル
- [-subj] サブジェクト名を指定（例：O=wolfSSL/C=JP/ST=Tokyo/L=Shinjuku/CN=example.com/OU=dev）
- [-verify] リクエストの署名を検証
- [-text] 人間が読める形式でリクエストを出力
- [-noout] 生成結果を出力しない

使用例:

```
wolfssl ecparam -genkey -out ecc.key -name secp384r1

wolfssl req -new -x509 -days 3650 -config selfsigned.conf -key ecc.key -out ecc.cert -outform der -sha256

wolfssl req -newkey rsa:2048 -keyout mykey.pem -out myreq.csr -subj "O=wolfSSL/C=JP/CN=test"
```

### 典型的なワークフロー：RSA鍵から証明書まで

**ステップ1: RSA鍵ペアを生成**（[GENKEY コマンド](genkey.md)を参照）

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
```

**ステップ2: 秘密鍵からCSRを作成**

```
wolfssl req -new -key server.priv -out server.csr -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=Example/CN=example.com"
```

**ステップ3a: 自己署名証明書を作成**

```
wolfssl req -x509 -key server.priv -in server.csr -out server.pem -days 365
```

**ステップ3b: またはCA署名証明書を作成**（[CA コマンド](ca.md)を参照）

まず、CA証明書を作成：

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
wolfssl req -new -x509 -key ca.priv -out ca.pem -days 3650 -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=Example/CN=Example CA"
```

次に、サーバーCSRをCAで署名：

```
wolfssl ca -in server.csr -out server-signed.pem -keyfile ca.priv -cert ca.pem -days 365 -md sha256
```

**ステップ4: 証明書を検証**（[VERIFY コマンド](verify.md)を参照）

```
wolfssl verify -CAfile ca.pem server-signed.pem
```
