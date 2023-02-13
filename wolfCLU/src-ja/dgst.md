### DGST コマンド
署名を検証することが可能です。最後の引数は署名対象となったデータです。

サポートしているハッシュアルゴリズム:     

- [-sha]
- [-sha224]
- [-sha256]
- [-sha384]
- [-sha512]

**署名**

引数:     

- [-sign] 署名作成に必要な鍵
- [-out] 署名出力先のファイル

使用例:
```
wolfssl dgst -sign keyPrivate.pem -out test.sig testfile
```

**検証**

引数:     

- [-verify] 署名を検証する為に使用する鍵
- [-signature] 署名を含んだファイル

使用例:
```
wolfssl dgst -verify keyPublic.pem -signature test.sig testfile
```
