### CRL コマンド
CA を指定して CRL ファイルを検証するために使用されます。 または、CRL を フォーマット変換 [DER|PEM] することもできます。-out が指定されておらず、-noout が使用されていない場合、このコマンドは CRL を stdout に出力します。 検証が成功すると「OK」を出力します。

引数：

- [-CAfile] CA証明書ファイル
- [-inform] 入力フォーマット：pem あるいは der 
- [-in] the CRLファイル
- [-outform] 出力フォーマット：pem あるいは der
- [-out] 出力ファイル
- [-noout] 指定がある場合には出力しません

使用例:

```
wolfssl crl -CAfile ./certs/ca-cert.pem -in ./certs/crl.der -inform DER -noout
```