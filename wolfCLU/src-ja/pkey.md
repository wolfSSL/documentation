### PKEY コマンド
汎用的な鍵操作を扱うために使用されます。読み込んだ鍵をstdoutに出力します。

引数：

- [-in] 読み込む鍵の入力ファイル
- [-out] 出力先ファイル（デフォルト：stdout）
- [-inform] 入力形式：pem または der（デフォルト：pem）
- [-outform] 出力形式：pem または der
- [-pubout] 公開鍵を出力
- [-pubin] 公開鍵の読み込みを期待

使用例：

```
wolfssl pkey -in ./certs/server-key.pem -inform pem -pubout

wolfssl pkey -in ./certs/server-key.pem -out pubkey.pem -pubout
```
