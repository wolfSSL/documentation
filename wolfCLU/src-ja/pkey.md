### PKEY コマンド
一般的な鍵操作を処理するために使用されます。 読み込まれた鍵を stdout に出力します。

引数:

- [-in] 入力される鍵ファイル
- [-inform] 入力ファイル形式：pem あるいは der (デフォルト：pem) 
- [-pubout] 公開鍵のみプリントアウトする
- [-pubin] 公開鍵を入力として期待する

使用例:

```
./wolfssl pkey -in ./certs/server-key.pem -inform pem -pubout
```
