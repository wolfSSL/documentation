### REQ コマンド
証明書要求または自己署名証明書の作成に使用されます。 証明書をセットアップするための .conf ファイルのいくつかの基本的な解析を処理できます。 構成ファイルが使用されていない場合、stdin は証明書情報の入力を求められます。


指定可能な引数:    

- [-in] 入力ファイル
- [-out] 出力先ファイル(デフォルト：stdout)
- [-key] 証明書要求に含める公開鍵ファイル
- [-inform] 入力ファイル形式：pem あるいは der (デフォルト：pem) 
- [-outform] 出力ファイル形式：pem あるいは der (デフォルト：pem)
- [-config] 証明書のコンフィグレーションファイル
- [-days] 有効期間（日数）
- [-x509] 自己署名証明書を生成する

使用例:

```
wolfssl ecparam -genkey -out ecc.key -name secp384r1
wolfssl req -new -x509 -days 3650 -config selfsigned.conf -key ecc.key -out ecc.cert \
-outform der -sha256
```
