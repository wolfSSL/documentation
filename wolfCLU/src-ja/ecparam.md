### ECPARAM コマンド

ECC鍵生成に使用します。


指定可能な引数：

- [-genkey] 新しい鍵を生成する
- [-out] 出力先ファイル
- [-name] 楕円曲線名（secp384r1等）


使用例: 

```
wolfssl ecparam -genkey -out new.key -name secp384r1
```