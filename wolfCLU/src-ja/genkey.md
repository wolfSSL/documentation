### GENKEY コマンド
RSA、ECC、ED25519、および DSA 鍵の生成に使用されます。 `-output KEY`を使用すると、-out 引数で与えたファイル名に .priv が追加された秘密鍵ファイルあるいは.pub が追加された公開鍵ファイルが作成されます。 ED25519 鍵を生成する場合には、wolfSSL を --enable-ed25519 でコンパイルしておく必要があります。

指定可能な引数：

- [-out] 出力先ファイル
- [rsa | ecc | ed25519] 生成する鍵のタイプ
- [-inkey] 入力ファイル
- [-size] 生成する鍵のサイズ（ビット数）
- [-outform] 出力形式（DER あるいは PEM）(デフォルト： DER)
- [-output] 生成する鍵（PUB, PRIV あるいは KEYPAIR）(デフォルト：KEYPAIR) 
- [-exponent] RSA指数サイズ

使用例:

```
wolfssl genkey rsa -size 2048 -out mykey -outform pem  -output KEYPAIR
```
