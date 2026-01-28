### S_CLIENT コマンド
接続テスト用の基本的なTLSクライアントです。

引数：

- [-connect] `<ip>:<port>` または `<[ipv6]>:<port>`
- [-starttls] STARTTLSのプロトコル（例：smtp）
- [-CAfile] 検証用のCAファイル名
- [-verify_return_error] 検証エラー時に接続を閉じる
- [-disable_stdin_check] 標準入力チェックを無効化

IPv6の例：

- `-connect '[::1]:11111'`
- `-connect '[fe80::63:57c0:9b88:77ca%en0]:11111'`
- `-connect '[2001:4860:4860::8888]:443'`

使用例：

```
wolfssl s_client -connect 127.0.0.1:11111

wolfssl s_client -connect example.com:443 -CAfile ./certs/ca-cert.pem

wolfssl s_client -connect '[::1]:11111'
```
