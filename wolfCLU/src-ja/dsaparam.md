### DSAPARAM コマンド

DSA パラメータと鍵の作成に使用されます。 wolfSSL が `--enable-dsa` オプションを指定してコンパイルされていることを確認してください。


指定可能な引数:

- [-genkey] 新たにDSA鍵を生成する
- [-in] 鍵生成に必要なパラメータを含んでいるファイル
- [-out] 出力先ファイル (デフォルト：stdout)
- [-noout] パラメータをプリントアウトしない

使用例: 

```
wolfssl dsaparam -out dsa.params 1024
wolfssl dsaparam -in dsa.params -genkey
```
