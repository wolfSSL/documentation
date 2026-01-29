### ECC コマンド

ECC（楕円曲線暗号）鍵を使用してデータの署名・検証を行います。

引数：

- [-sign] 署名操作
- [-verify] 検証操作
- [-inkey] 入力鍵ファイル
- [-in] 署名または検証する入力ファイル
- [-out] 署名の出力ファイル（署名操作時）
- [-sigfile] 署名ファイル（検証操作時）
- [-pubin] 入力鍵が公開鍵であることを指定（検証操作時）

使用例：

ECC秘密鍵でファイルに署名：

```
wolfssl ecc -sign -inkey ecc-priv.pem -in file.txt -out file.sig
```

ECC公開鍵で署名を検証：

```
wolfssl ecc -verify -inkey ecc-pub.pem -sigfile file.sig -in file.txt -pubin
```

ECC秘密鍵で署名を検証：

```
wolfssl ecc -verify -inkey ecc-priv.pem -sigfile file.sig -in file.txt
```
