### PKCS8 コマンド

PKCS#8秘密鍵ファイルを処理します。異なるフォーマット（PEM/DER）間の変換や秘密鍵の復号化を可能にします。PKCS#8鍵の暗号化はまだサポートされていません。

- [-in] 秘密鍵を含む入力ファイル（必須）
- [-out] 処理された鍵を書き込む出力ファイル（デフォルトは標準出力）
- [-inform] 入力フォーマット（PEMまたはDER、デフォルトはPEM）
- [-outform] 出力フォーマット（PEMまたはDER、デフォルトはPEM）
- [-passin] 暗号化された入力鍵のパスワードソース
- [-traditional] 従来の（非PKCS#8）フォーマットで鍵を出力
- [-topk8] 入力をPKCS#8フォーマットに変換
- [-nocrypt] 出力鍵を暗号化しない（パスワードなし）

暗号化されたPEM鍵をDERフォーマットに変換する例：

```
wolfssl pkcs8 -in server-keyEnc.pem -passin pass:mypassword -outform DER -out key.der
```

鍵を従来のフォーマットに変換する例：

```
wolfssl pkcs8 -in server-key.pem -traditional -out traditional-key.pem
```
