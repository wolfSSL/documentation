# ポスト量子暗号

wolfProviderは、OpenSSL 3のEVPインターフェースを通じてNISTのポスト量子標準をサポートします。
PQCサポートはオプトイン方式であるため、これらのアルゴリズムを必要としないアプリケーションには影響しません。

## 要件

- wolfSSL v5.9.2-stable以降
- OpenSSL 3.6以降
- 必要なPQCアルゴリズムが有効化されたwolfSSLビルド

パッケージ化されたDebianビルドは、システムのOpenSSLがOpenSSL 3.6より古いため、現在PQCを利用できません。

## サポートされるアルゴリズム

| アルゴリズム | 標準 | サポートされるパラメータセット |
| :-------- | :------- | :----------------------- |
| ML-KEM | FIPS 203 | ML-KEM-512, ML-KEM-768, ML-KEM-1024 |
| ML-DSA | FIPS 204 | ML-DSA-44, ML-DSA-65, ML-DSA-87 |
| SLH-DSA with SHA-2 | FIPS 205 | SLH-DSA-SHA2-128s, SLH-DSA-SHA2-128f, SLH-DSA-SHA2-192s, SLH-DSA-SHA2-192f, SLH-DSA-SHA2-256s, SLH-DSA-SHA2-256f |
| SLH-DSA with SHAKE | FIPS 205 | SLH-DSA-SHAKE-128s, SLH-DSA-SHAKE-128f, SLH-DSA-SHAKE-192s, SLH-DSA-SHAKE-192f, SLH-DSA-SHAKE-256s, SLH-DSA-SHAKE-256f |
| LMS | RFC 8554 / NIST SP 800-208 | LMSおよびLMOTSの公開鍵検証 |

ML-KEMは、鍵生成、カプセル化、デカプセル化、raw鍵のインポート/エクスポート、公開鍵/秘密鍵のエンコードをサポートします。
ML-DSAは、鍵生成、pure署名およびpre-hash署名、検証、コンテキスト文字列、鍵エンコードをサポートします。
SLH-DSAは、鍵生成、pure署名、検証、コンテキスト文字列、鍵エンコードをサポートします。
LMSは、公開鍵のインポートとワンショットの署名検証のみをサポートします。
秘密鍵のインポート、署名、鍵生成は公開しません。これは検証専用であるOpenSSLのLMS鍵タイプ契約に従うとともに、wolfProviderが意図的に選択した設計です。
wolfCrypt自体はLMS署名と鍵生成をサポートしていますが、LMSの葉ノード使用(ワンタイム署名)状態を強制できないインターフェースを通じて、ステートフルなLMS秘密鍵操作を公開することを回避します。

## プロバイダーアーキテクチャ

アプリケーションは、標準的なOpenSSL 3のEVPインターフェースを使用します。
wolfProviderは、各パラメータセットに対するOpenSSL鍵管理実装、ML-KEM用のKEM実装、ML-DSAおよびSLH-DSA用の署名実装を登録します。
プロバイダーはこれらの操作を対応するwolfCrypt APIに変換し、wolfCryptの鍵オブジェクトをOpenSSLの`EVP_PKEY`内部に保持します。

| ファミリー | OpenSSLインターフェース | 主な操作 |
| :----- | :----------------- | :-------------- |
| ML-KEM | `EVP_PKEY`, `EVP_PKEY_CTX`, KEM | 鍵生成、カプセル化、デカプセル化、鍵のインポート/エクスポート |
| ML-DSA | `EVP_PKEY`, `EVP_MD_CTX`, signature | 鍵生成、pure署名/pre-hash署名と検証、鍵のインポート/エクスポート |
| SLH-DSA | `EVP_PKEY`, `EVP_MD_CTX`, signature | 鍵生成、pure署名と検証、鍵のインポート/エクスポート |
| LMS | `EVP_PKEY`, `EVP_MD_CTX`, signature | 公開鍵のインポート/エクスポートおよびワンショット検証 |

ML-KEM、ML-DSA、SLH-DSAの鍵は、raw形式の公開鍵/秘密鍵パラメータに加え、DERおよびPEMエンコードをサポートします。
公開鍵にはSubjectPublicKeyInfoを、秘密鍵にはPKCS#8を使用します。暗号化されたPKCS#8秘密鍵の出力もサポートしています。
署名実装は、X.509証明書および証明書要求の操作に必要なアルゴリズム識別子を公開します。
一方、LMSはOpenSSLのraw XDR公開鍵表現を使用し、秘密鍵は公開しません。

OpenSSLのLMSプロバイダー契約は、一般的な複数レベルのHSS階層ではなく、単一のLMSツリーを表します。
そのためraw形式の公開鍵と署名には、4バイトのHSSレベル数フィールドが含まれません。
wolfProviderは、wolfCryptを呼び出す際にのみ必要な単一レベルのHSSラッパーを追加し、OpenSSLとの境界で再びそれを取り除くことで、アプリケーションに対してOpenSSL互換のバイト列を維持します。

## サイズとセキュリティカテゴリ

ML-KEMは常に32バイトの共有秘密を生成します。

| パラメータセット | NISTカテゴリ | 公開鍵 | 秘密鍵 | 暗号文 |
| :------------ | :------------ | ---------: | ----------: | ---------: |
| ML-KEM-512 | 1 | 800 bytes | 1,632 bytes | 768 bytes |
| ML-KEM-768 | 3 | 1,184 bytes | 2,400 bytes | 1,088 bytes |
| ML-KEM-1024 | 5 | 1,568 bytes | 3,168 bytes | 1,568 bytes |

ML-DSAの署名と鍵は、パラメータセットごとに固定サイズを持ちます。

| パラメータセット | NISTカテゴリ | 公開鍵 | 秘密鍵 | 署名 |
| :------------ | :------------ | ---------: | ----------: | --------: |
| ML-DSA-44 | 2 | 1,312 bytes | 2,560 bytes | 2,420 bytes |
| ML-DSA-65 | 3 | 1,952 bytes | 4,032 bytes | 3,309 bytes |
| ML-DSA-87 | 5 | 2,592 bytes | 4,896 bytes | 4,627 bytes |

SLH-DSAでは、同じレベルのSHA-2パラメータセットとSHAKEパラメータセットのサイズは同じです。
`s`バリアントは署名サイズの縮小を重視し、`f`バリアントは署名速度を重視します。

| パラメータセット | NISTカテゴリ | 公開鍵 | 秘密鍵 | 署名 |
| :------------- | :------------ | ---------: | ----------: | --------: |
| 128s | 1 | 32 bytes | 64 bytes | 7,856 bytes |
| 128f | 1 | 32 bytes | 64 bytes | 17,088 bytes |
| 192s | 3 | 48 bytes | 96 bytes | 16,224 bytes |
| 192f | 3 | 48 bytes | 96 bytes | 35,664 bytes |
| 256s | 5 | 64 bytes | 128 bytes | 29,792 bytes |
| 256f | 5 | 64 bytes | 128 bytes | 49,856 bytes |

## 署名および鍵生成パラメータ

ML-DSAおよびSLH-DSAは、OpenSSLの署名コンテキスト文字列パラメータを受け付けます(FIPS 204およびFIPS 205で定められた最大255バイトの制限があります)。
いずれもOpenSSLの署名パラメータを通じて、決定論的署名とランダム化署名の両方をサポートします。
ML-DSAはさらに、HashML-DSAのpre-hash署名と外部表現値の入力をサポートします。

鍵生成の実装は、OpenSSLのML-KEM、ML-DSA、SLH-DSA用シードパラメータを受け付けます。
これらの決定論的パスは、既知解テストおよびACVPテストで使用されます。
通常のアプリケーションによる鍵生成やランダム化署名では、wolfCryptの乱数生成器が使用されます。

OpenSSLは、アプリケーションに対してワンショットおよびストリーミングのdigest-signエントリポイントを提供します。
wolfProviderはHashML-DSAの入力を逐次的にハッシュ化します。
pure ML-DSAおよびSLH-DSAでは完全なメッセージが必要となるため、SLH-DSAはストリーミング入力をバッファリングし、64 MiBのメッセージサイズ制限を課しています。

## プラットフォーム最適化

wolfProviderはネイティブのwolfCrypt実装を呼び出すため、プロバイダー専用の高速化レイヤーを別途必要とせず、wolfSSLビルドで選択された最適化コードの恩恵をそのまま受けられます。
利用可能なwolfCryptのPQC高速化には、x86-64向けのベクトル化実装や、ARM32、AArch64、ARMv7-M、ARMv7E-M向けのアセンブリパスが含まれます。
最適化されたSHA-2、SHA-3、SHAKE演算も、ML-KEM、ML-DSA、SLH-DSA、および構成されたLMSパラメータファミリーで使用されるハッシュ処理を高速化します。

実際に選択される実装パスは、コンパイラ、プロセッサ、wolfSSLの構成に依存します。
アプリケーションは、対象システム上でwolfCryptベンチマークを実行し、どの実装が選択されたかを確認し、該当するパラメータセットを測定することが推奨されます。
構成方法とベンチマークの詳細については、wolfSSLの[PQCドキュメント](https://www.wolfssl.com/documentation/manuals/wolfssl/appendix09.html)
および[ML-KEM高速化の概要](https://www.wolfssl.com/accelerated-kyber-ml-kem/)をご参照ください。

## ビルド

ポスト量子アルゴリズムにはOpenSSL 3.6以降が必要です。古いデフォルトを使用しないよう、`OPENSSL_TAG`には最新のパッチ適用済みOpenSSL 3.6.xリリースを指定してください(既知の脆弱性がある3.6.0は使用しないでください)。

ビルドスクリプトを使用すると、OpenSSL、wolfSSL、wolfProviderをまとめて構成できます。

```sh
OPENSSL_TAG=openssl-3.6.2 ./scripts/build-wolfprovider.sh --enable-pqc
```

`--enable-pqc` はML-KEM、ML-DSA、SLH-DSAを有効にします。LMSは独立したオプションのままであり、各ファミリーを個別に選択することもできます。

```sh
./scripts/build-wolfprovider.sh --enable-mlkem
./scripts/build-wolfprovider.sh --enable-mldsa
./scripts/build-wolfprovider.sh --enable-slhdsa
./scripts/build-wolfprovider.sh --enable-lms
```

手動でビルドする場合は、対応するアルゴリズムオプションを指定してwolfSSLを構成した後、wolfProviderを構成します。

```sh
# wolfSSLソースディレクトリで、通常のwolfSSL構成に必要なオプションを追加します。
cd /path/to/wolfssl
./configure --enable-mlkem --enable-mldsa --enable-slhdsa=yes,sha2 \
    --enable-lms=verify-only,sha256-192,shake256
make
sudo make install

# wolfProviderソースディレクトリで、OpenSSL 3.6以降を指定して構成します。
cd /path/to/wolfProvider
./configure --enable-pqc --enable-lms \
    --with-openssl=/path/to/openssl \
    --with-wolfssl=/path/to/wolfssl
make
sudo make install
```

wolfSSLでアルゴリズムが有効になっていても、wolfProviderに`--enable-pqc`または個別のPQCオプションを渡さない限り、PQCコードはコンパイルされません。

wolfProviderはLMSの検証のみを行うため、`--enable-lms=verify-only,sha256-192,shake256` を指定してwolfSSLをビルドし、
LMSの署名と鍵生成をコンパイルして未使用のままにするのではなく、ビルドから完全に除外してください。
`build-wolfprovider.sh --enable-lms` のフローでは、すでにこのようにwolfSSLが構成されます。

## wolfProviderの使用

本番環境での展開には、置き換え用デフォルトモードの構成を推奨します。
これにより、wolfProviderがOpenSSLのデフォルトとなり、操作が気付かないうちにOpenSSL組み込みのプロバイダーにフォールバックすることを防ぎます。

```sh
OPENSSL_TAG=openssl-3.6.2 ./scripts/build-wolfprovider.sh --replace-default \
    --enable-pqc --enable-lms
```

アプリケーションは、wolfProviderを通常のプロバイダーとしてロードすることもできます。
このモードは相互運用性や移行に役立ちますが、すべての操作がwolfProviderで処理されることを保証するものではありません。
wolfProviderが特定の操作を実装していない場合や、構成が適用されていない場合、OpenSSLはデフォルトプロバイダーを選択することがあります。

wolfProviderをロードするには、リポジトリのプロバイダー構成ファイルを使用します。
この構成ファイルは`libwolfprov`を有効化します。`OPENSSL_CONF`をそのファイルに向けて設定してください。

```sh
export OPENSSL_CONF=/path/to/wolfProvider/provider.conf
```

wolfProviderがOpenSSLのモジュール検索パス外にインストールされている場合は、`libwolfprov.so`を含むディレクトリに`OPENSSL_MODULES`を設定してください。

```sh
export OPENSSL_MODULES=/path/to/wolfprovider/lib
```

構成を有効にした状態でコマンドを実行します。この構成では`libwolfprov`のみを有効化するため、OpenSSLは自身のデフォルトプロバイダーを暗黙に有効化しません。したがって、アプリケーションがデフォルトプロバイダーも有効化する場合(または置き換え用デフォルトモードを使用する場合)を除き、wolfProviderがサポートしない操作は暗黙にフォールバックせず失敗します。

```sh
OPENSSL_CONF=/path/to/wolfProvider/provider.conf \
    openssl list -kem-algorithms
OPENSSL_CONF=/path/to/wolfProvider/provider.conf \
    openssl list -signature-algorithms
```

## OpenSSL EVPの使用例

メンテナンスされている
[`examples/pqc_openssl_example.c`](https://github.com/wolfSSL/wolfProvider/blob/master/examples/pqc_openssl_example.c)
プログラムは、OpenSSLのEVP APIを通じて、NISTのFIPS 203からFIPS 205までの3つのアルゴリズムファミリーを実演します。

- ML-KEM-768の鍵生成、カプセル化、デカプセル化
- ML-DSA-65の鍵生成、署名、検証
- SLH-DSA-SHA2-128fの鍵生成、署名、検証

この例は、wolfProviderがいずれかのPQCファミリーで構成されている場合に、Automakeテストではなく`noinst_PROGRAMS`ターゲットとしてビルドされます。wolfProviderのCIは、`make check`の一部ではなく別のステップとして実行します。
コンパイル時のガードにより有効化されたファミリーのみが実行されるため、同じソースコードでML-KEMのみ、ML-DSAのみ、SLH-DSAのみのビルドも実演できます。
ビルド後は、wolfProviderのルートディレクトリから直接実行することもできます。

```sh
./examples/pqc_openssl_example
```

LMSはこの例には含まれていません。OpenSSLは検証機能のみを公開しており、実用的な例を作成するには固定の公開鍵と署名が必要となるためです。
代わりに、このリポジトリではOpenSSLの320件の固定検証ベクターと、プロバイダー向けの単体テストによってLMSを検証しています。

## ビルドマクロ

configureオプションは、それぞれ対応するリクエストマクロを追加します。

| configureオプション | wolfProviderリクエストマクロ | wolfSSL機能マクロ |
| :--------------- | :------------------------- | :----------------------- |
| `--enable-mlkem` | `WOLFPROV_HAVE_MLKEM` | `WOLFSSL_HAVE_MLKEM` |
| `--enable-mldsa` | `WOLFPROV_HAVE_MLDSA` | `WOLFSSL_HAVE_MLDSA` |
| `--enable-slhdsa` | `WOLFPROV_HAVE_SLHDSA` | `WOLFSSL_HAVE_SLHDSA` |
| `--enable-lms` | `WOLFPROV_HAVE_LMS` | `WOLFSSL_HAVE_LMS` |

`--enable-pqc` はML-KEM、ML-DSA、SLH-DSAを有効にします。LMSは`--enable-lms`で個別に有効化します。
configureがwolfSSLの機能を検証した後、wolfProviderは内部的に`WP_HAVE_MLKEM`、`WP_HAVE_MLDSA`、`WP_HAVE_SLHDSA`、`WP_HAVE_LMS`を使用して、
利用可能な実装をコンパイルおよび登録します。

## TLS 1.3

wolfProviderは、以下のML-KEM TLSグループを通知します。

- MLKEM512
- MLKEM768
- MLKEM1024
- X25519MLKEM768
- SecP256r1MLKEM768
- SecP384r1MLKEM1024

また、`mldsa44`、`mldsa65`、`mldsa87` のTLS 1.3署名方式も通知します。SLH-DSAはEVP経由でサポートされていますが、TLS署名方式としては通知されません。

## 検証

wolfCrypt Post Quantum v7.0.0実装は、[証明書A8437](https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/details?validation=41047)のもとでNIST CAVPアルゴリズム検証を取得しています。
この証明書は、LMS署名検証、ML-KEMの鍵生成・カプセル化・デカプセル化、ML-DSAの鍵生成・署名生成・署名検証、SLH-DSAの鍵生成・署名生成・署名検証を対象としています。
また、NISTの記録で特定されている、前提となるSHA、SHAKE、HMAC、DRBGの各実装も対象に含まれます。

この検証は、特定されたwolfCryptのバージョンおよび動作環境に適用されます。
検証済みの展開が必要な場合、wolfProviderアプリケーションは対応する検証済みのwolfCrypt配布物を使用し、そのセキュリティポリシーに従う必要があります。

CAVPはアルゴリズム実装を検証するものです。FIPS 140-3に基づく完全な暗号モジュールの検証とは別物であるため、
オープンソース版やFIPS Ready版のwolfSSLビルドを使用するだけでは、FIPS検証済みアプリケーションにはなりません。

検証済みFIPSビルドとFIPS Readyビルドは現在、PQC(ML-KEM、ML-DSA、SLH-DSA)およびLMSを拒否します。モジュール固有のCAST統合が完了するまで、FIPSまたはFIPS Ready版wolfSSLとこれらのアルゴリズムを組み合わせる構成はサポートされません。その統合が利用可能になるまでは、PQCとLMSを非FIPS版wolfSSLビルドでのみ使用してください。この制限は`scripts/build-wolfprovider.sh`によって適用されます。手動で実行した`./configure`は現在この組み合わせを拒否しないため、FIPSビルドではビルドスクリプトを使用するか、この組み合わせを避けてください。

PQCには、複数の独立したテスト層があります。

- 単体テストおよびサンプルテストは、鍵生成、インポート/エクスポート、エンコード、カプセル化、デカプセル化、署名、検証、不正な入力、
  および該当する場合はX.509操作をカバーします。LMSの単体テストは特に、raw形式の公開鍵のインポート/エクスポート、XDRデコード、
  `selection`の処理、不正な入力、およびサポート対象外のステートフルな操作の拒否をカバーします。
- OpenSSL EVPの既知解テストは、ML-KEM、ML-DSA、SLH-DSA、LMSの各ベクターファイルをwolfProviderに対して実行します。
  LMSベクターには320件の検証ケースが含まれます。
- PQC相互運用性テストは、wolfProviderとOpenSSLのデフォルトプロバイダー、および直接のwolfSSL APIを比較します。
  また、ML-KEMおよびハイブリッドTLSグループ、ML-DSA証明書認証のテストも行います。
- nginx OSPワークフローは、ML-DSA認証を用いたML-KEMおよびハイブリッドTLS 1.3鍵交換をテストします。
- 固定バージョンのlibacvp (Cisco v2.3.1) OSPワークフローは、`--enable-pqc` を指定してwolfProviderをビルドし、
  `APP_PQC_HANDLER` グループを実行した後、その完全な単体テストスイートを実行します。
  これにより、置き換え用デフォルトモードと非置き換えモードの両方で、ML-KEMおよびML-DSA用のOpenSSL ACVPハンドラーを検証します。

バージョン、nginx、libacvpの各マトリクスは、wolfSSL masterおよび最新の対象安定版リリースをカバーします。
OSPテストは、置き換え用デフォルトモードと非置き換えモードの両方で、通常時と強制障害時のケースを実行します。
PQCのKATおよびバージョンカバレッジはプルリクエストごとに実行され、より長時間を要するOSPインテグレーションワークフローはラベルによって選択され、夜間に実行されます。
KATマトリクスには、組み合わせたPQC構成に加えて、LMS単体の行も含まれます。

## 関連ドキュメント

現在の展開モデルおよび完全なビルド手順については、
[wolfProvider README](https://github.com/wolfSSL/wolfProvider/blob/master/README.md)
および[wolfProviderインテグレーションガイド](https://github.com/wolfSSL/wolfProvider/blob/master/docs/INTEGRATION_GUIDE.md)をご参照ください。
インテグレーションガイドでは、置き換え用デフォルトビルド、プロバイダー構成、テスト、トラブルシューティングについて説明しています。
検証済みの展開については、置き換え用デフォルトの要件とセキュリティポリシーに関する考慮事項を説明する
[FIPSインテグレーションガイド](https://github.com/wolfSSL/wolfProvider/blob/master/docs/FIPS_INTEGRATION_GUIDE.md)をご利用ください。

リポジトリ内の
[置き換え用デフォルトビルドワークフロー](https://github.com/wolfSSL/wolfProvider/blob/master/scripts/build-wolfprovider.sh)、
[プロバイダー構成](https://github.com/wolfSSL/wolfProvider/blob/master/provider.conf)、
[PQC EVPの例](https://github.com/wolfSSL/wolfProvider/blob/master/examples/pqc_openssl_example.c)、
[PQC KATランナー](https://github.com/wolfSSL/wolfProvider/blob/master/scripts/test-pqc-kat.sh)
は実装とともにメンテナンスされており、サポートされているオプションと検証に関する最新の例を提供しています。
