### S_SERVER コマンド

テスト用のシンプルなSSL/TLSサーバーです。指定したポートでリッスンし、SSL/TLS接続を処理します。

引数：

- [-port] リッスンするポート番号
- [-key] 秘密鍵ファイル（PEM形式）
- [-cert] 証明書ファイル（PEM形式）
- [-noVerify] クライアント証明書の検証を無効化
- [-CAfile] クライアント検証用のCA証明書ファイル（PEM形式）
- [-version] SSL/TLSバージョン: 0=SSLv3, 1=TLS1.0, 2=TLS1.1, 3=TLS1.2, 4=TLS1.3
- [-naccept] 受け付ける接続数（デフォルト: 1）
- [-www] HTTPレスポンスをHTML形式で送信
- [-readyFile] 外部モニタリング用のreadyファイルを作成

使用例：

ポート4433でシンプルなTLSサーバーを起動：

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem
```

クライアント証明書検証付きでサーバーを起動：

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem -CAfile ca-cert.pem
```

複数接続を受け付けHTTPレスポンスを返すサーバーを起動：

```
wolfssl s_server -port 4433 -cert server-cert.pem -key server-key.pem -naccept 10 -www
```
