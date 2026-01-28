### BENCH コマンド
アルゴリズムのベンチマークに使用されます。すべてのアルゴリズムをベンチマークするには `wolfssl bench -a` を実行します。

利用可能なアルゴリズム（設定に依存）：

- aes-cbc
- aes-ctr
- 3des
- camellia
- md5
- sha
- sha256
- sha384
- sha512
- blake2b

引数：

- [algorithm] ベンチマークするアルゴリズム
- [-time] 実行時間（秒、1-10）
- [-a] または [-all] すべての利用可能なアルゴリズムをテスト
- [-in] 入力ファイル
- [-out] 出力ファイル

使用例：

```
wolfssl bench aes-cbc -time 10

wolfssl bench -a -time 5
```
