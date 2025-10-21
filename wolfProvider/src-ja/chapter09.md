# その他のオープンソースソフトウェアとの統合に関する注意事項

wolfProviderは、OpenSSLプロバイダの一般的なフレームワークとアーキテクチャに準拠しています。
そのため、OpenSSLを使用するアプリケーションからOpenSSL構成ファイルやAPI呼び出しを介して、wolfProviderを利用できます。

wolfSSLは、自動化されたCI/CDワークフローを用いていくつかのオープンソースプロジェクトでwolfProviderをテストしています。
この章には、wolfProviderとのインテグレーションに関する注意事項とヒントを示します。

## テスト済みのオープンソースプロジェクト

以下のオープンソースプロジェクトは、wolfProviderを用いて動作することをテスト済みです。

### ネットワーク / Webテクノロジー

* cURL - URLによるデータ転送用コマンドラインツール
* gRPC - 高性能RPCフレームワーク
* libwebsockets - Websocket用軽量Cライブラリ
* Nginx - 高性能HTTPサーバーおよびリバースプロキシ
* Qt5 Network - Qtネットワークモジュール

### セキュリティ / 認証

* OpenSSH - セキュアシェル実装
* libssh2 - SSH2ライブラリ
* libfido2 - WebAuthn用FIDO2 ライブラリ
* OpenSC - スマートカードツールおよびミドルウェア
* pam-pkcs11 - PKCS#11用PAM モジュール
* OpenVPN - VPNソリューション
* Stunnel - ネットワークサービス用SSLラッパー

### システム / ネットワークツール

* systemd - システムおよびサービスマネージャー
* tcpdump - ネットワークパケットアナライザー
* rsync - ファイル同期ユーティリティ
* tnftp - 拡張FTPクライアント
* iperf - ネットワークパフォーマンス測定ツール
* IPMItool - IPMI管理ツール
* PPP - ポイント to ポイントプロトコル実装

### ディレクトリ / IDサービス

* OpenLDAP - 軽量ディレクトリアクセスプロトコル
* SSSD - システムセキュリティサービスデーモン
* Net-SNMP - ネットワーク管理プロトコル実装

### 暗号 / PKI

* cjose - JWT用Cライブラリ
* libeac3 - 電子認証コンポーネント
* libhashkit2 - コンシステントハッシュライブラリ
* liboauth2 - OAuth2ライブラリ
* libtss2 - TPM2ソフトウェアスタック
* tpm2-tools - TPM2ツール
* xmlsec - XMLセキュリティライブラリ
* sscep - SCEPクライアント実装

### 開発 / テスト

* Asan - アドレスサニタイザーテスト
* Codespell - ソースコード用スペルチェッカー
* Multi-Compiler - マルチコンパイラテスト

### リモートアクセス / リモートディスプレイ

* x11vnc - X11用VNCサーバー
* python3-ntp - Python NTPライブラリ

### その他のユーティリティ

* Socat - 双方向データ転送用の多目的リレー
* Simple - シンプルなテストアプリケーション

## 一般的な設定

これらのプロジェクトのほとんどは、以下のような設定手順が必要です。

1. GitHubからクローンする
2. Autotoolsでビルドする
3. OpenSSLで設定する
4. Makeとインストール
5. wolfProviderを使用する

```
export OPENSSL_CONF=/path/to/provider.conf
export OPENSSL_MODULES=/path/to/wolfprov-install/lib
```

make (または同等のビルドスクリプト) を実行した後、`ldd /path/to/compiled/binary` を実行することで、設定されている OpenSSL のバージョンを確認できます。
これにより、リンクされているライブラリのリストが表示されます。
正しくないバージョンが存在する場合は、リビルド前に以下の4つの環境変数を組み合わせて設定すると改善される可能性があります。

```
export LD_LIBRARY_PATH="/path/to/wolfssl/install/lib:/path/to/openssl/install/lib64"
export PKG_CONFIG_PATH="/path/to/openssl/install/lib64/pkgconfig"
export LDFLAGS="-L/path/to/openssl/install/lib64"
export CPPFLAGS="-I/path/to/openssl/install/include"
```

さらに、wolfProviderはライブラリが実際にwolfProviderを使用しているかどうかを判断する機能も提供します。
`export WOLFPROV_FORCE_FAIL=1` または `WOLFPROV_FORCE_FAIL=1 /command/to/run` を実行するだけで、
コマンドがwolfProviderを経由した際に失敗するようになります。

使用しているプロジェクトがテスト済みのオープンソースプロジェクトのリストに含まれている場合は、テストスクリプトを参照できます。
これらのスクリプトは、GitHub の [wolfssl/wolfProvider](https://github.com/wolfSSL/wolfProvider) リポジトリの `.github/workflows/` にあります。

## テストと検証

上記のすべてのオープンソースプロジェクトは、wolfProvider CI/CDパイプラインで以下のものを使用して継続的にテストしています。

* OpenSSL v3.5.0
* wolfSSLのマスターリリース / 安定リリース
* 適切なエラー処理を保証するための障害テスト
* FIPSテストもJenkinsパイプラインを通じて実施しています

この包括的なテストにより、wolfProvider は幅広いオープンソースプロジェクトとその様々なユースケースとの互換性を維持しています。
