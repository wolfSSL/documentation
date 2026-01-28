### ENC コマンド

入力の暗号化に使用されます。-d を設定すると復号が有効になります。

利用可能な暗号化/復号アルゴリズム（設定に依存）：

- aes-cbc-128
- aes-cbc-192
- aes-cbc-256
- aes-ctr-128
- aes-ctr-192
- aes-ctr-256
- 3des-cbc-56
- 3des-cbc-112
- 3des-cbc-168
- camellia-cbc-128
- camellia-cbc-192
- camellia-cbc-256

引数：

- [-in] 入力ファイル
- [-out] 出力先ファイル（デフォルト：stdout）
- [-pwd] パスワード入力
- [-k] パスワード入力の別オプション
- [-pass] パスワードソースのオプション（例：pass:password）
- [-key] 16進数の鍵入力
- [-iv] 16進数のIV入力
- [-inkey] 鍵の入力ファイル
- [-pbkdf2] KDFバージョン2を使用
- [-md] 使用するハッシュアルゴリズムを指定（例：md5、sha256）
- [-d] 入力ファイルを復号
- [-p] デバッグ情報を表示（鍵/IVなど）
- [-base64] base64入力のデコードを処理
- [-nosalt] KDFにソルト入力を使用しない

使用例：

```
wolfssl enc -aes-128-cbc -k Thi$i$myPa$$w0rd -in somefile.txt

wolfssl enc aes-cbc-256 -pwd Thi$i$myPa$$w0rd -in somefile.txt -out encryptedfile.txt

wolfssl enc aes-cbc-256 -d -pwd Thi$i$myPa$$w0rd -in encryptedfile.txt -out decryptedfile.txt
```
