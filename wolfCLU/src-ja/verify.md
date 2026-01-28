### VERIFY コマンド
CAを使用してX509証明書を検証します。コマンドに渡される最後の引数は、検証する証明書ファイル名です。検証が成功すると「OK」がstdoutに出力されます。それ以外の場合は、エラー値と理由が出力されます。

引数：

- [-CAfile] 検証に使用するCAのファイル名
- [-untrusted] 検証に使用する中間証明書のファイル名（現在1つの-untrusted証明書のみサポート）
- [-crl_check] CRLチェックを使用する場合
- [-partial_chain] 中間CAでの検証を許可

使用例：

```
wolfssl verify -CAfile ./certs/ca-cert.pem ./certs/server-cert.pem

wolfssl verify -CAfile ./certs/ca-cert.pem -untrusted ./certs/intermediate.pem ./certs/server-cert.pem
```

### 典型的なワークフロー：CA署名証明書の検証

CA署名証明書を作成した後（[CA コマンド](ca.md)を参照）、検証：

```
wolfssl verify -CAfile ca.pem server-signed.pem
```

成功時の期待される出力：

```
verifying certificate file server-signed.pem
using CA file ca.pem
OK
```
