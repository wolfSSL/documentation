# はじめよう

第1章の「本ガイドの使い方」の手順に従い、既存の Mbed TLS の通信相手とのテストを行ってください。
移植が動作したら、新たに利用できるようになった機能を有効にしましょう。
たとえば DTLS 1.3 や、お使いのハードウェア向けの暗号コールバックです。
ML-KEM ハイブリッドグループはデフォルトで有効です。
`user_settings.h` を使うビルドについては、[設定オプションの対応](chapter09.md)を参照してください。

## 相互接続性テスト

wolfSSL の CI では、TLS、DTLS、DTLS Connection ID について Mbed TLS 3.6 との相互接続性テストを実施しています。
本ガイドのサンプルは、Mbed TLS 4.1 に対してもテスト済みです。

ホスト上で手早くテストするには、wolfSSL のサンプルクライアントとサーバーを、Mbed TLS の `ssl_client2` および `ssl_server2` プログラムと組み合わせて使います。

```sh
# wolfSSL クライアントから Mbed TLS サーバーへ接続（-g で HTTP GET を送信）
./examples/client/client -h <host> -p <port> -A <test-ca.crt> -g

# Mbed TLS クライアント用に wolfSSL サーバーを起動（-d でクライアント証明書の要求を省略）
./examples/server/server -p <port> -d

# 上記サーバーへ Mbed TLS クライアントから接続（wolfSSL のテスト CA を信頼）
ssl_client2 server_port=<port> ca_file=<wolfssl>/certs/ca-cert.pem server_name=example.com
```

Mbed TLS のテストデータに含まれる `test-ca.crt` は、`ssl_server2` が TLS 1.2 でデフォルトで使用する RSA 証明書に署名した CA の証明書です。
TLS 1.3 では `ssl_server2` は ECDSA 証明書を提示しますが、その CA である `test-ca2.crt` には wolfSSL が拒否する NULL の署名パラメータが含まれています。
そのため、代わりに `crt_file=server2-sha256.crt key_file=server2.key` を指定して起動してください。
wolfSSL のサンプルプログラムを `-?` 付きで実行すると、オプションの一覧が表示されます。

## ソースコードとリリース

wolfSSL のソースコードは [github.com/wolfSSL/wolfssl](https://github.com/wolfSSL/wolfssl) にあり、リリースアーカイブは [wolfssl.jp/download](https://www.wolfssl.jp/download/) から入手できます。
