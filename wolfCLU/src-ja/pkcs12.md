### PKCS12 コマンド
現在、PKCS12 の解析のみがサポートされており、PKCS12 の生成はまだサポートされていません。 デフォルトでは、wolfSSL をビルドするときに使用される --enable-wolfclu オプションは PKCS12 サポートも有効にしますが、RC2 は有効にしません。 RC2 を使用して暗号化された PKCS12 バンドルを解析する場合、wolfSSL をコンパイルするときに --enable-rc2 も使用する必要があります。

引数:

- [-in] file input for pkcs12 bundle
- [-out] 処理結果出力先のファイル(デフォルト：stdout)
- [-nodes] DES暗号化を使用しない
- [-nocerts] 証明書をプリントアウトしない
- [-nokeys] 鍵をプリントアウトしない
- [-passin] パスワードを含んだファイル
- [-passout] パスワードの出力先ファイル

使用例:

```
./wolfssl pkcs12 -nodes -passin pass:"wolfSSL test" -in ./certs/test-servercert.p12
```
