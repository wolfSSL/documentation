### CA コマンド
証明書への署名に使用されます。このコマンドはコンフィグレーションファイルを指定し、そのファイルから基本的なコンフィグレーション内容を取得することが可能です。

指定可能な引数:

- [-in] 入力となるCSRファイル
- [-out] 出力先ファイル
- [-keyfile] 秘密鍵ファイル
- [-cert] CA証明書ファイル
- [-extensions] コンフィグレーションファイル内の解析すべきセクション
- [-md] ハッシュタイプ（sha, sha256, ...）
- [-inform] CSRファイル形式（PEM/DER）
- [-config] コンフィグレーションファイル
- [-days] 証明書に与える有効期間（日数）
- [-selfsign] 自己署名する

使用例:

```
wolfssl ca -config ca.conf -in test.csr -out test.pem -md sha256 -selfsign -keyfile ./key
```
