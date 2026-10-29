# Mbed TLS にない機能

| 機能 | Mbed TLS 3.6 / 4.x | wolfSSL |
| ---------------------------------- | ------------------------------------ | ------------------------------ |
| TLS 1.3 | 対応 | 対応 |
| DTLS 1.3（RFC 9147） | 非対応（DTLS 1.2 のみ） | 対応 |
| DTLS Connection ID（RFC 9146） | 対応 | 対応（DTLS 1.2 および 1.3） |
| ML-KEM ハイブリッド鍵交換 | 非対応 | 対応（デフォルトで有効） |
| TLS 1.3 での ML-DSA、SLH-DSA 証明書 | 非対応 | 対応 |
| LMS、XMSS | LMS 検証、実験的な LMS 署名、XMSS 非対応 | 署名と検証に対応 |
| Ed25519、Ed448 | 非対応 | 対応 |
| QUIC | 非対応 | 対応 |
| Encrypted Client Hello | 非対応 | 対応 |
| OCSP ステープリング | 非対応 | 対応（v1 および v2） |
| TLS 1.3 ポストハンドシェイク認証 | 非対応 | 対応 |
| Raw Public Key（RFC 7250） | 非対応 | 対応 |
| FIPS 140-3 認証済み暗号 | 非対応 | 対応（別途認証を受けた wolfCrypt モジュールを使用） |
| ハードウェアオフロード | `_ALT` または PSA ドライバ | 暗号コールバックと 30 を超えるツリー内ポート |

## DTLS 1.3

Mbed TLS が対応している DTLS は 1.2 のみです。
wolfSSL は DTLS 1.3（RFC 9147）を追加でサポートし、両バージョンで Connection ID も利用できます。
これにより、CoAP、LwM2M、セルラー IoT などのデータグラムトランスポートに TLS 1.3 のハンドシェイクを導入できます。
移行はメソッドの変更だけで済みます。
`--enable-dtls13` を指定したビルドでは、`wolfDTLS_client_method()` はサーバーが対応していれば DTLS 1.3 をネゴシエートし、対応していなければ DTLS 1.2 にフォールバックします。

## ポスト量子暗号

Mbed TLS のロードマップでは ML-KEM は今後の課題とされており、ML-DSA のコードは開発ブランチ上の実験的な ML-DSA-87 ドライバのみです。
wolfCrypt は NIST 標準の全アルゴリズムを、独自の実装と Intel および ARM 向けのアセンブリ最適化付きで提供しています。

- ML-KEM（FIPS 203）。TLS 1.3 では、単体の ML-KEM として、または X25519MLKEM768、SecP256r1MLKEM768、SecP384r1MLKEM1024 などのハイブリッドグループとして使用します。
- ML-DSA（FIPS 204）。証明書、TLS 1.3 の認証、CMS、証明書生成に使用します。
  SLH-DSA（FIPS 205）は証明書と TLS 1.3 の認証に使用します。
- ファームウェア署名向けのステートフルなハッシュベース署名 LMS/HSS および XMSS/XMSS^MT。
- コンパクトな格子ベース署名を必要とするアプリケーション向けの Falcon（実験的機能: `--enable-falcon --enable-experimental`）。

ML-KEM とハイブリッドグループはデフォルトで有効です。
ML-DSA と SLH-DSA には `--enable-mldsa` と `--enable-slhdsa` が必要です。
[TLS クライアントの移植](chapter03.md)のサンプルクライアントは、PQC 固有のコードを含まないにもかかわらず、デフォルト設定の wolfSSL サーバーに対して SecP256r1MLKEM768 をネゴシエートします。
`--enable-curve25519` を指定すると、優先グループは、現在ブラウザで採用されているハイブリッドである X25519MLKEM768 になります。

## FIPS 140-3

wolfCrypt は FIPS 140-3 認証を取得していますが、Mbed TLS は取得していません。
お使いのプラットフォームに適した認証については、wolfSSL までお問い合わせください。

## PSA Crypto API を使い続ける

[wolfPSA](https://github.com/wolfSSL/wolfPSA) は wolfCrypt 上に PSA Crypto API を実装しています。
そのため、Mbed TLS 4.x 向けにすでに PSA へ移植したコードの大部分は、API を変更せずに wolfCrypt 上で動作します。
ただし、PAKE 関数（およびそれに伴う EC J-PAKE）は実装されていません。

## wolfSSL 製品ファミリー

wolfCrypt は、他の wolfSSL 製品の暗号コアでもあります。
EST および SCEP による証明書登録のための [wolfCert](https://github.com/wolfSSL/wolfCert)、
[wolfMQTT](https://github.com/wolfSSL/wolfMQTT)、
[wolfSSH](https://github.com/wolfSSL/wolfssh)、
[wolfTPM](https://github.com/wolfSSL/wolfTPM)、
セキュアブートのための [wolfBoot](https://github.com/wolfSSL/wolfBoot)、
[wolfHSM](https://github.com/wolfSSL/wolfHSM)、
[wolfPKCS11](https://github.com/wolfSSL/wolfPKCS11)、
[wolfPSA](https://github.com/wolfSSL/wolfPSA)、
OpenSSL 3 向けの [wolfProvider](https://github.com/wolfSSL/wolfProvider)、
その他に [wolfIP](https://github.com/wolfSSL/wolfip)、
[wolfSentry](https://github.com/wolfSSL/wolfsentry)、
[wolfCOSE](https://github.com/wolfSSL/wolfCOSE) があります。
また、Python、Rust、C#、Java（JSSE および JCE）、Ada 向けの言語バインディングがあり、[wolfSSL OSP リポジトリ](https://github.com/wolfSSL/osp)では curl、nginx、OpenSSH などのプロジェクトへの移植を提供しています。
