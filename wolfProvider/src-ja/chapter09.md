# その他のオープンソースソフトウェアとの統合に関する注意事項

wolfProviderは、OpenSSLプロバイダの一般的なフレームワークとアーキテクチャに準拠しています。
そのため、OpenSSL構成ファイルやAPI呼び出しを介してプロバイダーを正しくロード・初期化するあらゆるOpenSSL利用アプリケーションから、wolfProviderを利用できます。

wolfSSLは、自動化されたCI/CDワークフローを用いて数多くのオープンソースプロジェクトでwolfProviderをテストしています。
この章には、テスト済みのプロジェクトとのインテグレーションに関する注意事項とヒントを示します。

## テスト済みのオープンソースプロジェクト

以下のオープンソースプロジェクト (OSP) は、wolfProviderを用いて動作することをテスト済みです。

### ネットワーク / Webテクノロジー

* cURL - URLによるデータ転送用コマンドラインツールおよびライブラリ
* gRPC - 高性能RPCフレームワーク
* libwebsockets - WebSocket用軽量Cライブラリ
* Nginx - 高性能HTTPサーバーおよびリバースプロキシ
* Nginx (PQC) - ポスト量子TLS鍵交換グループを組み込んだNginx
* Qt5 Network - Qtネットワークモジュール
* libnice - ピアツーピアおよびWebRTC向けGLib ICE実装
* iPerf - ネットワークパフォーマンス測定ツール

### セキュリティ / 認証

* OpenSSH - セキュアシェル実装
* libssh2 - SSH2クライアントライブラリ
* libfido2 - WebAuthn用FIDO2ライブラリ
* OpenSC - スマートカードツールおよびミドルウェア
* pam-pkcs11 - PKCS#11用PAMモジュール
* OpenVPN - VPNソリューション
* Stunnel - ネットワークサービス用SSL/TLSラッパー
* hostap (wpa_supplicant / hostapd) - Wi-Fi認証 (EAP、WPA)
* Kerberos 5 (krb5) - ネットワーク認証プロトコル
* libcryptsetup - LUKSディスク暗号化
* Git over SSH - SSH経由のGitトランスポート

### システム / ネットワークツール

* systemd - システムおよびサービスマネージャー
* tcpdump - ネットワークパケットアナライザー
* rsync - ファイル同期ユーティリティ
* tnftp - 拡張FTPクライアント
* PPP - Point-to-Point Protocol実装
* Socat - 双方向データ転送用の多目的リレー
* librelp - 信頼性の高いイベントログプロトコルライブラリ
* Net-SNMP - Simple Network Management Protocol実装

### ディレクトリ / IDサービス

* OpenLDAP - 軽量ディレクトリアクセスプロトコル
* SSSD - システムセキュリティサービスデーモン
* BIND 9 - DNSサーバーおよびリゾルバ

### 暗号 / PKI

* cjose - JOSE/JWT用Cライブラリ
* libeac3 - 拡張アクセス制御ライブラリ
* libhashkit2 - コンシステントハッシュライブラリ (libmemcached)
* liboauth2 - OAuth 2.0ライブラリ
* libtss2 - TPM2ソフトウェアスタック
* tpm2-tools - TPM2ツール
* xmlsec - XMLセキュリティライブラリ
* sscep - SCEPクライアント実装

### リモートアクセス / リモートディスプレイ

* x11vnc - X11用VNCサーバー
* python3-ntp - Python NTP実装

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

上記のすべてのオープンソースプロジェクトは、wolfProvider CI/CDパイプラインで継続的にテストされています。
テストの範囲は以下の通りです。

* OpenSSL 3.xの幅広いリリース (3.0.6から最新の3.xリリースまで)
* wolfSSL masterおよび複数の安定版リリース (例: v5.9.1、v5.8.4)
* 標準モードおよび置き換え用デフォルトプロバイダーモードの両方
* FIPSビルドおよび非FIPSビルド(FIPSは専用のFIPSおよびFIPS Ready GitHub Actionsワークフローでも追加検証)
* wolfProviderの暗号処理が実際に実行されていることを確認するための障害テスト (`WOLFPROV_FORCE_FAIL=1`)
* アドレスサニタイザーおよび未定義動作サニタイザー、静的解析、ポスト量子既知解テスト (KAT)

wolfProviderは現在、60を超えるGitHub Actionsワークフローにわたって40を超えるオープンソースプロジェクトのインテグレーションを維持しており、
高速なプルリクエスト単位のティアと、より広範な夜間ティアに分かれています。

この包括的なテストにより、wolfProvider は幅広いオープンソースプロジェクトとその様々なユースケースとの互換性を維持しています。
