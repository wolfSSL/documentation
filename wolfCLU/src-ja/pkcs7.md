### PKCS7 コマンド

PKCS#7データを処理し、PKCS#7ファイルから証明書の抽出などの操作を可能にします。PKCS#7は、暗号で署名および/または暗号化されたデータの標準規格です。

- [-in] PKCS#7データを含む入力ファイル（必須）
- [-out] 結果を書き込む出力ファイル（デフォルトは標準出力）
- [-inform] 入力フォーマット（PEMまたはDER、デフォルトはPEM）
- [-outform] 出力フォーマット（PEMまたはDER、デフォルトはPEM）
- [-print_certs] PKCS#7ファイルから証明書を抽出して出力する

PKCS#7ファイルから証明書を抽出する例：

```
wolfssl pkcs7 -in pkcs7.pem -print_certs
```

PKCS#7データをPEMからDERフォーマットに変換する例：

```
wolfssl pkcs7 -in pkcs7.pem -outform DER -out pkcs7.der
```
