### DGST コマンド
デジタル署名の作成と検証に使用されます。最後の引数は署名されたデータです。

サポートされているハッシュアルゴリズム：

- [-md5]
- [-sha]
- [-sha224]
- [-sha256]
- [-sha384]
- [-sha512]

引数：

- [-signature] 署名を含むファイル
- [-inform] 入力形式：pem または der
- [-verify] 署名を検証するための鍵
- [-sign] 署名を作成するための秘密鍵
- [-out] 署名の出力ファイル

**署名**

使用例：
```
wolfssl dgst -sha256 -sign keyPrivate.pem -out test.sig testfile
```

**検証**

使用例：
```
wolfssl dgst -sha256 -signature test.sig -verify keyPublic.pem testfile
```
