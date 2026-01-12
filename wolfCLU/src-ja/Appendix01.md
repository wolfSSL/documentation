# Appendix A: 構成ファイルのフォーマット

## A.1 概要

wolfCLU の各種コマンド（`x509`、`req` など）は、  
OpenSSL の `openssl.cnf` と同様の **設定ファイル（configuration file）** を参照することで、以下を行います。

- Distinguished Name (DN) の定義  
- X.509 拡張の指定  
- 証明書生成時の動作制御  

## 注意事項（CA 機能の位置づけと適用範囲）

wolfCLU における CA 機能は、

- **証明書生成および検証のための診断・検証用途**
- **組み込み型製品において必要とされる  
  限られた範囲の証明書操作の提供**

を目的としています。

特に、**リソース制約のある環境**や、  
**証明書管理を外部システムに委ねる構成**において、  
wolfCLU は **実装および検証用途に適した機能**を提供します。

そのため、wolfCLU は  
本格的な認証局（CA）運用や  
証明書ライフサイクル全体の管理を目的としたツールではありません。

> **注意**  
> 本設定ファイルは OpenSSL 互換を意識した書式を採用していますが、  
> `openssl.cnf` のすべての機能を網羅するものではありません。

---

## A.2 基本構文

設定ファイルは、以下の基本ルールに従います。

### A.2.1 セクション

```
[ section_name ]
```

- セクション名は大文字・小文字を区別しません  
- セクションは任意の順序で定義できます  

### A.2.2 キーと値

```
key = value
```

- 空白は無視されます  
- 値は文字列として扱われ、数値型としての解釈は行われません  

### A.2.3 コメント

comment

```
; comment
```

- `#` および `;` はコメントとして扱われます  
- 行末コメントも可能です  

---

## A.3 設定ファイルの読み込みモデル

wolfCLU の config 処理は以下の特徴を持ちます。

- **単一ファイル読み込み**
  - `include` および `include_dir` はサポートされません
- **ネスト参照は 1 段階**
  - `section = other_section` による参照は可能
  - 無限再帰や多段参照は想定されていません
- **未定義キーは無視**
  - 未使用ディレクティブが存在してもエラーにはなりません

---

## A.4 サポートされる主要セクション

### A.4.1 `[ req ]`

証明書要求（CSR）および自己署名証明書生成時の基本動作を定義します。

例：

```
[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
```


| キー | 説明 |
|----|----|
| `default_bits` | 鍵長（RSA 使用時） |
| `distinguished_name` | DN 定義セクション |
| `x509_extensions` | 使用する拡張セクション |
| `prompt` | DN 入力を対話形式にするか |

---

### A.4.2 `[ req_distinguished_name ]`

Distinguished Name (DN) の各属性を定義します。

```
[ req_distinguished_name ]
C = US
ST = MT
L = Bozeman
O = wolfSSL Inc
OU = Engineering
CN = example.com
```

- 各キーは X.509 DN 属性として解釈されます  
- 定義されていない属性は省略されます  

---

### A.4.3 X.509 拡張セクション  
（例：`[ v3_req ]`, `[ v3_ca ]`）

証明書拡張を定義します。

**Subject Alternative Name (SAN)**

```
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = example.com
DNS.2 = www.example.com
```

**Basic Constraints**

```
basicConstraints = CA:FALSE
```

**Key Usage**

```
keyUsage = digitalSignature, keyEncipherment
```

**Extended Key Usage**

```
extendedKeyUsage = serverAuth, clientAuth
```

---

## A.5 拡張ディレクティブの対応状況

wolfCLU は以下の代表的な X.509 拡張をサポートします。

- `basicConstraints`  
- `keyUsage`  
- `extendedKeyUsage`  
- `subjectAltName`  
- `subjectKeyIdentifier`  
- `authorityKeyIdentifier`  

未対応の拡張が指定された場合でも、  
設定ファイルの読み込み自体は失敗しません。

---

## A.6 コマンドとの対応関係

| コマンド | 使用される主なセクション |
|--------|----------------------|
| `req` | `req`, `req_distinguished_name`, 拡張セクション |
| `x509` | 拡張セクション |
| `s_server` / `s_client` | 証明書読み込み用途のみ |

---

## A.7 OpenSSL との主な相違点

- `include` / `include_dir` 非対応  
- `policy` セクション非対応  
- 変数展開（`${var}`）非対応  
- engine 関連設定非対応  

これらは **意図的に実装されていない機能**であり、  
wolfCLU は **CLI 診断用途に必要な最小限の config 処理**を目的としています。

---

## A.8 最小構成例

```
[ req ]
prompt = no
distinguished_name = dn
x509_extensions = v3

[ dn ]
CN = test.example.com

[ v3 ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
```

---

## A.9 `[ ca ]` セクション

### A.9.1 基本構造

```
[ ca ]
default_ca = CA_default
```

`[ ca ]` セクションは、  
**実際に使用される CA 定義セクションを指し示すための入口**として機能します。

---

### A.9.2 CA 定義セクション（例：`[ CA_default ]`）

```
[ CA_default ]
dir = ./demoCA
certs = $dir/certs
crl_dir = $dir/crl
database = $dir/index.txt
serial = $dir/serial
certificate = $dir/cacert.pem
private_key = $dir/private/cakey.pem
default_md = sha256
policy = policy_any
x509_extensions = v3_ca
```

> **注**  
> すべてのキーが必須ではありません。  
> wolfCLU が参照しない項目は無視されます。

---

### A.9.3 サポートされる主なキー

| キー | 説明 |
|----|----|
| `certificate` | CA 証明書ファイル |
| `private_key` | CA 秘密鍵ファイル |
| `default_md` | 署名に使用するハッシュアルゴリズム |
| `x509_extensions` | 発行証明書に適用する拡張セクション |

以下のキーは OpenSSL 互換形式で記述可能ですが、  
wolfCLU では参照されない、または限定的に扱われます。

- `database`  
- `serial`  
- `crl_dir`  
- `policy`  

---

### A.9.4 ポリシーセクション（`[ policy_xxx ]`）

OpenSSL では DN 制約を定義するために使用されますが、  
wolfCLU ではポリシー内容の評価・検証は行われません。

```
[ policy_any ]
countryName = optional
stateOrProvinceName = optional
organizationName = optional
commonName = supplied
```

この記述は **設定互換性維持のために許容**されており、  
実質的な制約処理は行われません。

---

### A.9.5 wolfCLU における `[ ca ]` セクションの制約

wolfCLU の CA 処理は以下の点で OpenSSL と異なります。

- 証明書発行履歴（DB）管理を行わない  
- serial ファイルの自動更新を行わない  
- CRL 発行・管理機能を持たない  
- 再発行・失効管理を想定していない  

そのため、`[ ca ]` セクションは  
**簡易 CA として署名付き証明書を生成するための設定**として使用されます。

---

## A.10 使用される主なコマンド

| コマンド | `[ ca ]` セクションの利用 |
|--------|----------------------|
| `x509` | CA 署名付き証明書生成時 |
| `req` | CSR を CA 署名する場合 |

---
