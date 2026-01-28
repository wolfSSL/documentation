### RSA コマンド

署名、検証、鍵管理を含むRSA操作を実行します。入出力にDERおよびPEM形式を処理できます。

**RSA署名**

```
wolfssl rsa -sign -inkey <priv_key> -in <filename> -out <filename>
```

**秘密鍵でRSA検証**

```
wolfssl rsa -verify -inkey <priv_key> -sigfile <filename> -out <filename>
```

**公開鍵でRSA検証**

```
wolfssl rsa -verify -inkey <pub_key> -sigfile <filename> -out <filename> -pubin
```

引数：

- [-sign] 入力データに署名
- [-verify] 署名を検証
- [-inkey] 署名/検証用の鍵ファイル
- [-in] 署名または処理する入力ファイル
- [-out] 結果の出力先ファイル（デフォルト：stdout）
- [-sigfile] 検証用の署名ファイル
- [-pubin] 公開鍵入力を期待
- [-inform] 入力形式：PEM または DER（デフォルト：PEM）
- [-outform] 出力形式：PEM または DER（デフォルト：PEM）
- [-passin] PEM暗号化ファイルのパスワード
- [-noout] 設定時に鍵を出力しない
- [-modulus] RSAモジュラス（n値）を出力

使用例：

```
wolfssl rsa -sign -inkey private.pem -in data.txt -out signature.bin

wolfssl rsa -verify -inkey public.pem -sigfile signature.bin -out verified.txt -pubin
```
