#  イントロダクション


このマニュアルは組み込み用wolfSSHライブラリの技術解説書としてお読みいただけるように書かれています。wolfSSHをビルドして起動することから始まり、ビルドオプション、機能、サポートなどの概要を提供します。

wolfSSHはC言語で書かれたSSH（セキュアシェル）サーバー実装で、wolfSSLから利用可能なwolfCryptを使用します。さらに、マルチプラットフォームで使用できるようにゼロから構築されています。また、SSHv2仕様に準拠しています。

##  プロトコル概要

SSHは２つの通信端点に多重化されたデータストリームを提供する一連の階層化されたプロトコルです。一般的には、サーバー上のシェルへの接続を保護するために利用されます。ですが、ファイルを安全にコピーしたり、Xディスプレイプロトコルをトンネリングするのにも利用されています。

##  wolfSSHをお勧めする理由

wolfSSHはANSI Cで記述された軽量のSSHv2サーバーライブラリで、サイズが軽量でありスピード、機能セットに富んでいる点から、組み込み機器、リアルタイムOSおよびリソース制約のある環境をターゲットにしています。wolfSSHは業界標準のSSH v2をサポートし、さらに先進的なアルゴリズム（ChaCha20, Poly1305, NTRU とSHA-3)も提供しています。wolfSSHを支えているのはwolfCrypt暗号化ライブラリで、このライブラリはFIPS140-2認証（認証#2425）を受けています。より詳細はwolfCrypt FIPS FAQを参照されるかあるいはinfo@wolfssl.comまでお知らせください。


### 機能（特徴）


- SSH v2.0 (サーバー機能)

- 最小フットプリント：33kB

- 実行時メモリ消費量：1.4KB ~ 2KB (受信バッファは含まず)

- ハッシュ関数: SHA-1, SHA-2 (SHA-256, SHA-384, SHA-512), BLAKE2b, Poly

- 暗号アルゴリズム：Block, Stream, and Authenticated Ciphers: AES (CBC, CTR, GCM, CCM), Camellia, ChaCha

- 公開鍵オプション: RSA, DH, EDH, NTRU

- ECDH と ECDSA で次の楕円曲線をサポート: NISTP256, NISTP384, NISTP, Curve25519, Ed

- クライアント認証をサポート(RSA key, password)

- シンプルなAPI

- PEM and DER certificate support

- ハードウエア暗号サポート: 
    - Intel AES-NI support
    - Intel AVX1/2
    - RDRAND
    - RDSEED
    - Cavium NITROX
    - STM32F2/F4 ハードウエア暗号
    - Freescale CAU / mmCAU / SEC
    - Microchip PIC32MZ

