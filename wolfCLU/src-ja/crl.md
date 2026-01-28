### CRL コマンド
CAを使用してCRLファイルを検証するか、CRLを一方の形式[DER | PEM]から他方に変換するために使用されます。-out が指定されず -noout が使用されていない場合、CRLはstdoutに出力されます。検証が成功すると「OK」が出力されます。

引数：

- [-CAfile] CAファイル名
- [-inform] 入力形式：pem または der
- [-in] 入力ファイル
- [-outform] 出力形式：pem または der
- [-out] 出力ファイル
- [-noout] 設定時は出力しない
- [-text] CRLの人間が読める形式のテキストを出力

使用例：

```
wolfssl crl -CAfile ./certs/ca-cert.pem -in ./certs/crl.der -inform DER -noout

wolfssl crl -in ./certs/crl.pem -text
```
