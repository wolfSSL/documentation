### GENKEY コマンド
RSA、ECC、ED25519鍵の生成に使用されます。"-output KEYPAIR" を使用すると、-out引数に .priv を付加した秘密鍵と .pub を付加した公開鍵が作成されます。ED25519鍵を生成する場合は、wolfSSLを --enable-ed25519 でコンパイルしてください。

利用可能な鍵タイプ（設定に依存）：

- rsa
- ecc
- ed25519

引数：

- [rsa | ecc | ed25519] 生成する鍵タイプ
- [-size] 生成する鍵のサイズ（ビット）
- [-out] 出力先ファイル
- [-outform] 出力形式：DER または PEM（デフォルト：DER）
- [-output] 生成する鍵：PUB、PRIV または KEYPAIR（デフォルト：KEYPAIR）

使用例：

```
wolfssl genkey rsa -size 2048 -out mykey -outform pem -output KEYPAIR

wolfssl genkey ecc -out ecckey -outform pem -output KEYPAIR

wolfssl genkey ed25519 -out ed25519key -outform pem -output KEYPAIR
```

上記のコマンドは mykey.priv と mykey.pub ファイルを出力します。
-output オプションを PRIV のみに変更すると、秘密鍵のみを出力します。

### 典型的なワークフロー：RSA鍵から証明書まで

**ステップ1: サーバー用RSA鍵ペアを生成**

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
```

これにより `server.priv`（秘密鍵）と `server.pub`（公開鍵）が作成されます。

**ステップ2: CA用RSA鍵ペアを生成**

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
```

CSRと証明書の作成については[REQ コマンド](req.md)を、証明書の署名については[CA コマンド](ca.md)を参照してください。
