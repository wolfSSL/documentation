### ENC コマンド

入力の暗号化に使用され、(-d) で復号することもできます。


指定可能な暗号化と復号アルゴリズム：

- aes-cbc-128
- aes-cbc-192
- aes-cbc-256
- aes-ctr-128
- aes-ctr-192
- aes-ctr-256
- 3des-cbc-56
- 3des-cbc-112
- 3des-cbc-168
    
指定可能な引数：

- [-in]　対象の入力ファイル
- [-out] 出力先ファイル（デフォルト：stdout)
- [-pwd] パスワード
- [-key] 鍵データ（hex)
- [-iv]  鍵初期化ベクトル(hex)
- [-inkey] 鍵ファイル
- [-pbkdf2] KDF version2を使用する
- [-md] ハッシュアルゴリズムを指定（ md5, sha256等）
- [-d] 入力ファイルを復号する
- [-p] デバッグ出力(key / iv 等)をプリントアウトする 
- [-k] パスワード入力のオプション
- [-base64] base64エンコードされている入力を処理する
- [-nosalt] KDFにソルトを使用しない


使用例: 

```
wolfssl enc -aes-128-cbc -k Thi$i$myPa$$w0rd -in somefile.txt
```