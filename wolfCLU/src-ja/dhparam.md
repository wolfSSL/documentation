### DHPARAM コマンド

デフィー・ヘルマンパラメータと鍵の生成に使用されます。

引数:    

- [-genkey] 新たなDH鍵を生成します
- [-in] 鍵生成のためのパラメータを読み取るファイル
- [-out] 出力ファイル（デフォルトはstdout)
- [-check] 生成されたパラメータが有効かチェックする
- [-noout] パラメータをプリントしない

使用例: 

```
wolfssl dhparam -check -out dh.params 1024
```