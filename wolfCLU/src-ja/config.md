### 設定ファイル形式

wolfCLUは `req` および `ca` コマンドでOpenSSLスタイルの設定ファイルをサポートしています。このページでは、サポートされているディレクティブについて説明します。

## 基本構造

設定ファイルはINIスタイルの形式で、セクションとキー・バリューのペアで構成されます：

```ini
[section_name]
key = value
```

## REQコマンドの設定

### メインセクション

`[req]` セクションには主要な設定が含まれます：

| ディレクティブ | 説明 |
|---------------|------|
| `prompt` | `no` に設定すると対話的なプロンプトを無効化 |
| `default_bits` | デフォルトの鍵サイズ（ビット単位、例：2048） |
| `default_md` | デフォルトのハッシュアルゴリズム（例：sha256） |
| `default_keyfile` | デフォルトの鍵ファイルパス |
| `distinguished_name` | DN フィールドを含むセクション名 |
| `attributes` | 属性を含むセクション名 |
| `x509_extensions` | X509拡張を含むセクション名 |

### Distinguished Name セクション

distinguished name セクション（`distinguished_name` で参照）は証明書のサブジェクトフィールドを定義します：

| ディレクティブ | 説明 |
|---------------|------|
| `countryName` | 国コード（2文字、例：JP、US） |
| `stateOrProvinceName` | 都道府県名 |
| `localityName` | 市区町村名 |
| `organizationName` | 組織名 |
| `organizationalUnitName` | 部署名 |
| `commonName` または `CN` | コモンネーム（例：ドメイン名） |
| `emailAddress` | メールアドレス |
| `name` | 名前 |
| `surname` | 姓 |
| `givenName` | 名 |
| `initials` | イニシャル |
| `dnQualifier` | DN修飾子 |

各フィールドにはオプションの修飾子を設定できます：

| 修飾子 | 説明 |
|--------|------|
| `<field>_default` | 指定されない場合のデフォルト値 |
| `<field>_min` | 最小文字数 |
| `<field>_max` | 最大文字数 |

### 属性セクション

属性セクション（`attributes` で参照）はPKCS#9属性を定義します：

| ディレクティブ | 説明 |
|---------------|------|
| `challengePassword` | PKCS#9 チャレンジパスワード |
| `unstructuredName` | PKCS#9 非構造化名 |

## X509拡張セクション

拡張セクション（`x509_extensions` で参照）は証明書の拡張を定義します：

| ディレクティブ | 説明 |
|---------------|------|
| `basicConstraints` | CA制約とパス長 |
| `subjectKeyIdentifier` | サブジェクト鍵識別子 |
| `authorityKeyIdentifier` | 認証局鍵識別子 |
| `keyUsage` | 鍵用途フラグ |
| `subjectAltName` | サブジェクト代替名 |

### basicConstraints

証明書がCAかどうかと、最大パス長を定義します。

形式: `[critical, ]CA:TRUE|FALSE[, pathlen:<n>]`

| 値 | 説明 |
|----|------|
| `critical` | クリティカル拡張としてマーク |
| `CA:TRUE` | CA証明書である |
| `CA:FALSE` | CA証明書ではない |
| `pathlen:<n>` | 最大証明書パス長 |

例：
```ini
basicConstraints = critical, CA:TRUE, pathlen:0
basicConstraints = CA:FALSE
```

### keyUsage

証明書に含まれる鍵の用途を定義します。

形式: `[critical, ]<usage>[, <usage>...]`

| 値 | 説明 |
|----|------|
| `digitalSignature` | デジタル署名 |
| `nonRepudiation` | 否認防止（`contentCommitment` も可） |
| `keyEncipherment` | 鍵暗号化 |
| `dataEncipherment` | データ暗号化 |
| `keyAgreement` | 鍵共有 |
| `keyCertSign` | 証明書署名 |
| `cRLSign` | CRL署名 |
| `encipherOnly` | 暗号化のみ（keyAgreementと併用） |
| `decipherOnly` | 復号のみ（keyAgreementと併用） |

例：
```ini
keyUsage = critical, digitalSignature, keyEncipherment
keyUsage = keyCertSign, cRLSign
```

### subjectKeyIdentifier

証明書内の公開鍵を識別します。

| 値 | 説明 |
|----|------|
| `hash` | 公開鍵のハッシュを使用 |

例：
```ini
subjectKeyIdentifier = hash
```

### subjectAltName

証明書サブジェクトの追加識別子を指定します。`@section_name` を使用して代替名を含むセクションを参照します。

例：
```ini
subjectAltName = @alt_names
```

#### 代替名セクション

| ディレクティブ | 説明 |
|---------------|------|
| `DNS.<n>` | DNS名（例：`DNS.1 = example.com`） |
| `IP.<n>` | IPアドレス（例：`IP.1 = 192.168.1.1`） |
| `URI.<n>` | URI（例：`URI.1 = https://example.com`） |
| `email.<n>` | メールアドレス（例：`email.1 = admin@example.com`） |
| `RID.<n>` | 登録ID / OID |

例：
```ini
[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.1
email.1 = admin@example.com
```

## CAコマンドの設定

### メインセクション

`[ca]` セクションはデフォルトのCAセクションを指定します：

```ini
[ca]
default_ca = CA_default
```

### CAセクション

CAセクション（例：`[CA_default]`）にはCA固有の設定が含まれます：

| ディレクティブ | 説明 |
|---------------|------|
| `serial` | シリアル番号を含むファイル（16進形式） |
| `new_certs_dir` | 新規証明書のディレクトリ |
| `certificate` | CA証明書ファイル |
| `private_key` | CA秘密鍵ファイル |
| `default_days` | デフォルトの有効期間（日数） |
| `default_md` | デフォルトのハッシュアルゴリズム |
| `x509_extensions` | 拡張のセクション名 |
| `policy` | DNポリシーのセクション名 |
| `database` | 証明書データベースファイル |
| `unique_subject` | 一意のサブジェクトを要求 |
| `crl_dir` | CRLのディレクトリ |
| `crl` | CRLファイル |
| `RANDFILE` | 乱数シードファイル |

## 設定例

### サーバー証明書リクエスト

```ini
[req]
prompt = no
default_bits = 2048
default_md = sha256
distinguished_name = req_dn
x509_extensions = v3_server

[req_dn]
countryName = JP
stateOrProvinceName = Tokyo
localityName = Shinjuku
organizationName = Example Corp
commonName = example.com
emailAddress = info@example.com

[v3_server]
basicConstraints = critical, CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.1
```

使用方法：
```
wolfssl req -new -config server.conf -key server.priv -out server.csr
wolfssl req -new -x509 -config server.conf -key server.priv -out server.pem -days 365
```

### CA証明書

```ini
[req]
prompt = no
default_bits = 4096
default_md = sha256
distinguished_name = ca_dn
x509_extensions = v3_ca

[ca_dn]
countryName = JP
stateOrProvinceName = Tokyo
localityName = Shinjuku
organizationName = Example Corp
commonName = Example CA

[v3_ca]
basicConstraints = critical, CA:TRUE, pathlen:1
keyUsage = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
```

使用方法：
```
wolfssl req -new -x509 -config ca.conf -key ca.priv -out ca.pem -days 3650
```

### シンプルなCSR（最小構成）

```ini
[req]
prompt = no
distinguished_name = req_dn

[req_dn]
commonName = myserver
```

使用方法：
```
wolfssl req -new -config simple.conf -key server.priv -out server.csr
```

## 制限事項

### new_certs_dirと-outオプションのパス処理

設定ファイルの`new_certs_dir`と`-out`オプションを同時に使用する場合、v0.1.9までのバージョンでパス処理のバグがあります：

- `-out`に**絶対パス**（例：`/tmp/output/signed.pem`）を指定すると、`new_certs_dir`と不正に結合され、無効なパスになります。
- **回避策:** `-out`には**相対パス**（例：`signed.pem`）を使用してください。相対パスは`new_certs_dir`ディレクトリ内に正しく配置されます。

### シリアル番号ファイル

`serial` ディレクティブは、16進形式のシリアル番号を含むファイルを指定します：

```
01
```

シリアル番号は証明書が署名されるたびにインクリメントされます。シリアルファイルを指定する設定ファイルを使用しない場合、wolfCLUは署名された各証明書にランダムなシリアル番号を生成します。
