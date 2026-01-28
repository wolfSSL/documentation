### HASH コマンド
入力データのハッシュを作成するために使用されます。

利用可能なアルゴリズム（設定に依存）：

- md5
- sha
- sha256
- sha384
- sha512
- blake2b
- base64enc
- base64dec

引数：

- [algorithm] 使用するハッシュアルゴリズム
- [-in] ハッシュするファイル

使用例：

```
wolfssl hash sha256 -in somefile.txt

wolfssl hash blake2b -in somefile.txt
```
