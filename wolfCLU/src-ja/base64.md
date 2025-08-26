### BASE64 コマンド

base64エンコーディングを使用してデータをエンコードまたはデコードします。デフォルトでは、データはbase64にエンコードされます。base64データをデコードするには、-dオプションを使用してください。

- [-in] 読み込む入力ファイル（デフォルトは標準入力）
- [-out] 書き込む出力ファイル（デフォルトは標準出力）
- [-d] エンコードする代わりに入力データをデコードする

エンコードの例：

```
wolfssl base64 -in plain_file.txt -out encoded_file.txt
```

デコードの例：

```
wolfssl base64 -d -in encoded_file.txt -out decoded_file.txt
```
