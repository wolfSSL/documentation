### VERIFY コマンド

CA が指定された X509 証明書を検証します。 コマンドに渡される最後の引数は、検証する証明書ファイルの名前です。 検証が成功すると、「OK」が stdout に出力されます。 それ以外の場合、エラー値と理由が出力されます。

引数:

- [-CAfile] 検証に使用するCA証明書ファイル
- [-crl_check] CRL検証が必要

使用例:

```
wolfssl verify -CAfile ./certs/ca-cert.pem ./certs/server-cert.pem
```