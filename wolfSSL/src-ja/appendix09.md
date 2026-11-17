# ポスト量子暗号の実験

wolfSSLチームは以前、実験的なポスト量子暗号アルゴリズムをwolfSSLライブラリに統合しました。
これは、Open Quantum Safeチームのliboqsと統合することで実現されました。
現在、wolfCryptはML-KEM、ML-DSA、SLH-DSA、Falcon、FrodoKEM、およびステートフルハッシュベース署名方式（LMS/HSS、XMSS/XMSS^MT）を独自に実装しています。
そのため、コードベースを小さく保ち、ライブラリの保守を容易にするために、liboqsとの統合、およびhash-sigs（LMS/HSS）ライブラリとxmss-reference（XMSS/XMSS^MT）ライブラリとの以前の統合を削除しました。
wolfSSL 5.9.4以降、liboqsはどのアルゴリズムにも使用されておらず、`--with-liboqs` configureオプションは非推奨となり、無視されます。

この付録は、(D)TLS 1.3のコンテキストでポスト量子暗号について学び、実験したい人を対象としています。
ポスト量子アルゴリズムが重要である理由、量子の脅威に対応して私たちが行ったこと、これらの新しいアルゴリズムの実験を開始する方法について説明します。
DTLS 1.3にのみ該当する注意事項は、「DTLSでのポスト量子アルゴリズム」節に記載しています。

**注意**: 一部のポスト量子アルゴリズムはまだ完全に標準化されていません。
一部のOIDとコードポイントは一時的なものであり、将来変更される可能性があります。
完全に標準化されるまでは、下位互換性を期待すべきではありません。

## ポスト量子暗号をわかりやすく紹介

### なぜポスト量子暗号？

今日では、量子コンピューターの開発にますます多くのリソースが割かれるようになりました。
そのため、クラウド量子コンピューティングリソースの商業化がすでに始まっています。
現時点では未だ実用レベルの暗号が解かれた報告はありません。
しかし、「あらかじめデータを収集、蓄積し、後に時間をかけて解読を進めていく」といった脅威モデルが存在します。
すなわち、暗号の復号に特化した量子コンピューターが出現するよりも早いうちに準備が必要です。

NISTは量子コンピュータに対して脆弱になる公開鍵暗号アルゴリズムを置き換えるために設計された、新しいアルゴリズムの標準化を主導しています。
この文章の執筆時点において、NISTはすでにML-DSA、ML-KEM、SLH-DSAを標準化しました。
FalconはFN-DSA（FIPS 206）として標準化が進められていますが、まだドラフト段階であるため、wolfSSLではFalconを実験的なものとして扱っています。

ML-KEM (Module Lattice Key Encapsulation Mechanism) は、NISTが標準化した格子ベースの耐量子アルゴリズムです。
Kyberをベースとして標準化されました。
2者間で鍵カプセル化メカニズムを使用して、安全でないチャネル上で共有鍵を確立します。
これにより、従来型および量子コンピュータを用いた攻撃者の両方から保護できます。

ML-DSA (Module Lattice Digital Signature Algorithm) は、同じくNISTが標準化した格子ベースの耐量子デジタル署名方式です。
Dilithiumをベースとして標準化されました。
これにより、送信者はメッセージの送信元と完全性を証明する検証可能な署名を生成できます。

ML-KEMとML-DSAはどちらも、暗号の復号に特化した量子コンピュータに耐性を持つように設計された公開鍵アルゴリズムです。
これらはNISTの耐量子暗号標準(FIPS 203およびFIPS 204)の一部です。
量子コンピューティング時代に備えるために、ほとんどのケースでハイブリッド形式にてすぐに導入できます。

アルゴリズム自体は、現在ではすでにNIST標準となっています。
ML-KEM、ML-DSA、SLH-DSAはそれぞれFIPS 203、FIPS 204、FIPS 205で、ステートフルハッシュベース署名方式のLMSとXMSSはNIST SP 800-208で標準化されています。
wolfSSLが今後予定しているポスト量子FIPS認証の申請は、ML-KEM、ML-DSA、LMS、XMSS、SLH-DSAを対象としています。
まだ確定していないのは、TLSでのこれらのアルゴリズムの使用方法です。
ML-KEMグループのコードポイントはIETFドラフトのdraft-ietf-tls-mlkem（純粋なML-KEM）およびdraft-ietf-tls-ecdhe-mlkem（ハイブリッド）に、SLH-DSA署名スキームのコードポイントはdraft-reddy-tls-slhdsaに基づいています。

### 私たちは自分自身をどのように守るのですか？

大まかに言えば、すべての TLS 1.3 接続において、認証・完全性・機密性は各接続を保護する重要な目標です。
認証は、ECDSAなどの署名スキームによって維持されます。
機密性と完全性は、ECDHEなどの鍵確立アルゴリズムによって維持され、確立された鍵とAESなどの対称暗号化アルゴリズムを使用して通信ストリームを暗号化します。
したがって、TLS 1.3 プロトコルのセキュリティは、次の3種類の暗号化アルゴリズムに分解できます。

* 認証アルゴリズム
* 鍵確立アルゴリズム
* 対称暗号アルゴリズム

量子コンピュータが従来の暗号に及ぼす脅威には、2つの形態があります。
グローバーのアルゴリズムは、最新の対称暗号アルゴリズムのセキュリティを約半分に低下させます。
ショアのアルゴリズムは、最新の認証および鍵確立アルゴリズムのセキュリティを完全に破壊します。
したがって、暗号処理に特化した量子コンピュータが存在する場合でも、十分に安全と考えられるAES-256対称暗号を使用して通信を保護し続けることができます。
そして、従来の認証および鍵確立アルゴリズムをポスト量子アルゴリズムに置き換えることができます。
TLS 1.3ハンドシェイク中、暗号スイートは接続の間使用される対称暗号を指定することに注意してください。
CNSA（商用国家安全保障アルゴリズムスイート）1.0と2.0はともにAES_256_GCM_SHA384暗号スイートの使用を規定しています。
鍵確立と認証については、ポスト量子KEM（鍵カプセル化メカニズム）と署名スキームがあります。

これらは従来のアルゴリズムとは異なる種類の数学を使用します。
量子コンピュータに対する耐性を特に考慮して設計されたものです。
NISTがネットワークプロトコルでの使用のために標準化した主要な署名スキームとKEMは、格子ベースのアルゴリズムです。
署名については、ハッシュベースの代替手段としてSLH-DSA（FIPS 205）もあります。

* ML-DSA（Dilithium）署名スキーム
* ML-KEM（KYBER）KEM

**注意**: SABER KEMとNTRU KEMは標準化に進まなかったため、非推奨となり削除されました。

**注意**: KYBER KEM 90sバリアントはNISTが標準化を検討していないため、非推奨となり削除されました。

**注意**: Dilithium署名スキームのAESバリアントはNISTが標準化を検討していないため、非推奨となり削除されました。

**注意**: wolfSSLが以前liboqsから取り込んでいたSPHINCS+は、ネイティブのSLH-DSA（FIPS 205）実装に置き換えられました。
SLH-DSAは[`--enable-slhdsa`](chapter02.md#--enable-slhdsa)で有効にします。
FalconはwolfSSL 5.9.4まではliboqsを使用していましたが、5.9.4でレベル1と5のネイティブ実装に置き換えられました。
このネイティブ実装は`--enable-experimental --enable-falcon`で有効にします。
鍵カプセル化メカニズムであるFrodoKEMも、`--enable-experimental --enable-frodokem`で利用できます。

wolfSSLは、ML-KEMとML-DSAに加えて、以下のポスト量子アルゴリズムもサポートしています。

* SLH-DSA（FIPS 205）署名スキーム（12個のパラメータセットすべて）。
  `--enable-slhdsa`は6つのSHAKEパラメータセットをビルドし、`--enable-slhdsa=yes,sha2`は6つのSHA2パラメータセットを追加します。
  SLH-DSAは、draft-reddy-tls-slhdsaに従ってTLS 1.3およびDTLS 1.3のハンドシェイクに署名できます。
  コードポイントは[付録G](appendix07.md#c-9-slh-dsa-fips-205)に記載しています。
* Falcon署名スキーム（レベル1と5、実験的）。
  wolfCryptのネイティブ実装で、暗号コールバックとARM DSP / AArch64 NEONによる高速化に対応しています。
* FrodoKEM鍵カプセル化メカニズム（wolfCryptのみ、実験的）。
* ステートフルハッシュベース署名方式のLMS/HSSおよびXMSS/XMSS^MT。
  この付録の後半で説明します。

wolfSSL 5.9.4以降では、ポスト量子アルゴリズムのみでTLS 1.3をビルドすることもできます。
鍵交換にはML-KEMを、認証にはML-DSAまたはSLH-DSAを使用し、RSA、ECC、DHは使用しません。
[`--enable-all-quantum-crypto`](chapter02.md#--enable-all-quantum-crypto)を指定すると、ML-KEM、ML-DSA、LMS、XMSS、SLH-DSA（SHAKEとSHA2の両方のパラメータセット）を一度に有効にします。
`--enable-experimental`と組み合わせると、Falcon、FrodoKEM、および追加のPQ/Tハイブリッドグループも有効になります。
純粋なML-KEMのTLSグループ（`--enable-tls-mlkem-standalone`）は有効になりません。

格子ベースの暗号化の説明はこの文書の範囲を超えますが、これらのアルゴリズムに関する詳細情報は、それぞれの標準であるFIPS 203（<https://csrc.nist.gov/pubs/fips/203/final>）、FIPS 204（<https://csrc.nist.gov/pubs/fips/204/final>）、FIPS 205（<https://csrc.nist.gov/pubs/fips/205/final>）で確認できます。

残念ながら、この章を記している時点においてこれらのアルゴリズムが量子コンピューターからの攻撃に耐えられるかどうかは、まだ分かっていません。
従来型コンピューターにおける攻撃耐性も同様です。
可能性はますます低くなっていますが、誰かが格子ベースの暗号化を破る可能性があります。
ただし、暗号化は常にこのような経緯で機能してきた歴史があります。
アルゴリズムは使い始めたときは優れていますが、弱点や脆弱性が発見され、テクノロジーは順次改善されます。
ポスト量子アルゴリズムは比較的新しいため、コミュニティからもう少し注目を集める必要があるかもしれません。

解決策の1つは、これらの新しいアルゴリズムを完全には信頼しないことです。
今のところ、ポスト量子アルゴリズムを、信頼している従来のアルゴリズムとハイブリッド化することで、このリスクを回避することができます。
FIPS 140-3準拠を第一に考えると、NIST標準曲線を使用したECCは引き続き使用する必要があるため、良い選択肢になります。
このため、ポスト量子KEMを実装するだけでなく、NISTが承認した曲線上のECDHとハイブリッド化しました（SecP256r1MLKEM768およびSecP384r1MLKEM1024）。
wolfSSLは、X25519とのハイブリッドであるX25519MLKEM768もサポートしています。
X25519MLKEM768はサーバーに受け入れられる可能性が最も高いハイブリッドであるため、Curve25519が有効な場合はClientHelloのデフォルトの鍵共有として使用されます。
詳しくは以下のハイブリッドグループのリストを参照してください。

## wolfSSLでポスト量子暗号を始めましょう

ここではまっさらなLinux環境をもとに、量子耐性を有する安全なTLS 1.3接続を実行できるようにするまでの手順を示します。

### ビルド手順

ポスト量子アルゴリズムはいずれも外部ライブラリを必要とせず、すべてwolfSSLのソースからビルドされます。
一般的な構成は次のとおりです。

```sh
./configure --enable-mlkem --enable-mldsa --enable-slhdsa=yes,sha2
```

実験的なアルゴリズムを使用する場合は、`--enable-experimental --enable-falcon`または`--enable-experimental --enable-frodokem`を追加します。
これら2つのオプションはサブオプションも受け付けます。
詳しくは[`--enable-falcon`](chapter02.md#--enable-falcon)および[`--enable-frodokem`](chapter02.md#--enable-frodokem)をご参照ください。

wolfSSLリポジトリのINSTALLファイル（<https://github.com/wolfSSL/wolfssl/blob/master/INSTALL>）の項目15にも同様の内容が記載されています。
ただし、そこでは古いオプション名である`--enable-kyber`と`--enable-dilithium`（それぞれ`--enable-mlkem`と[`--enable-mldsa`](chapter02.md#--enable-mldsa)の別名）が使用されており、また`--enable-experimental --enable-extra-pqc-hybrids`を必要とするSecP521r1MLKEM1024グループが使用されています。

#### デフォルトで有効になっているもの

* ML-KEMは、SHA-3またはSHAKEが無効になっていない限り、デフォルトで有効です。
  `--enable-mlkem`はサブオプションを渡す場合にのみ必要で、[`--disable-mlkem`](chapter02.md#--disable-mlkem)を指定するとML-KEMを無効にします。
* 標準のPQ/TハイブリッドグループであるSecP256r1MLKEM768、SecP384r1MLKEM1024、X25519MLKEM768は、デフォルトで有効な[`--enable-pqc-hybrids`](chapter02.md#--disable-pqc-hybrids)によって提供されます。
  X25519MLKEM768には[`--enable-curve25519`](chapter02.md#--enable-curve25519)も必要ですが、こちらはデフォルトで無効です。
* 純粋なML-KEMグループであるML_KEM_512、ML_KEM_768、ML_KEM_1024には[`--enable-tls-mlkem-standalone`](chapter02.md#--enable-tls-mlkem-standalone)が必要です。
  configureスクリプトがこのオプションを自動的に有効にするのは、ハイブリッドを構成するためのECC、Curve25519、Curve448がいずれもビルドに含まれていない場合のみです。
* 追加のハイブリッドグループであるSecP256r1MLKEM512、SecP384r1MLKEM768、SecP521r1MLKEM1024、X25519MLKEM512、X448MLKEM768には`--enable-experimental --enable-extra-pqc-hybrids`が必要です。
  これらはFIPS v7ビルドでは使用できません。
* Round 3のKyberグループには、`--enable-mlkem=yes,original`（ML-KEMの代わりにKyber）または`--enable-mlkem=yes,all`（KyberとML-KEMの両方）が必要です。
  リストには`yes`を残してください。
  `yes`がないと、KyberとML-KEMのパラメータセットが1つもビルドされません。
* アプリケーションがグループを何も設定しない場合、wolfSSLクライアントは、Curve25519が組み込まれていればX25519MLKEM768の鍵共有を、そうでなければSecP256r1MLKEM768の鍵共有を送信します。
* ML-DSA、SLH-DSA、LMS、XMSSはデフォルトで無効です。
  FalconとFrodoKEMには、さらに`--enable-experimental`も必要です。

[付録G](appendix07.md)の「B-7 ML-KEMスタンドアロン」「B-8 ML-KEMハイブリッド（標準）」「B-9 ML-KEMハイブリッド（実験的）」「B-10 Kyber Round 3 レガシー」の各節に、これらすべてのグループとそのコードポイントを記載しています。

#### ポスト量子テスト証明書

ポスト量子認証を試すのに、追加のツールは必要ありません。
wolfSSLのソースツリーには、すぐに使えるテスト証明書と鍵が含まれています。
`certs/mldsa/`にはML-DSA証明書があり、ML-DSA-87のCA（`mldsa87-ca-cert.pem`）とML-DSA-65のリーフ証明書（`mldsa65-leaf87ca-cert.pem`）も含まれています。
`certs/slhdsa/`には、SLH-DSAのルート証明書と、ML-DSA-44およびSLH-DSAのサーバー証明書とクライアント証明書があります。
これらは、ML-DSAとSLH-DSAの鍵と証明書をネイティブに作成できるOpenSSL 3.5以降で生成されました。
OQSプロバイダーで作成された以前のML-DSA証明書チェーンとその作成手順は、wolfSSL OSPリポジトリ <https://github.com/wolfSSL/osp/tree/master/oqs/README.md> にあります。

### 量子安全なTLS接続を確立する

wolfSSLソースツリーのルートから、次のようにしてサーバーとクライアントを別々のターミナルで実行します。

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa/mldsa87-ca-cert.pem \
      -c certs/mldsa/mldsa65-leaf87ca-cert.pem \
      -k certs/mldsa/mldsa65-leaf87ca-key.pem \
      --pqc SecP384r1MLKEM1024
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa/mldsa87-ca-cert.pem \
      -c certs/mldsa/mldsa65-leaf87ca-cert.pem \
      -k certs/mldsa/mldsa65-leaf87ca-key.pem \
      --pqc SecP384r1MLKEM1024
```

両側で`SSL curve name is SecP384r1MLKEM1024`と表示され、クライアントはサーバーからの応答`I hear you fa shizzle!`を表示します。
これで、対称暗号化にAES-256、認証にML-DSA署名スキーム、鍵確立にECDHEとML-KEMをハイブリッド化した完全な量子安全なTLS 1.3接続を実現しました。
両ピアは、ML-DSA-87のCAが発行した同一のML-DSA-65証明書で認証します。

代わりにSLH-DSAで認証するには、SLH-DSA証明書を使用します。
SLH-DSA証明書には、SLH-DSA-SHAKE-128sのルートが発行したサーバー証明書とクライアント証明書が別々に用意されています。

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/slhdsa/root-slhdsa-shake-128s.pem \
      -c certs/slhdsa/server-slhdsa-shake-128s.pem \
      -k certs/slhdsa/server-slhdsa-shake-128s-priv.pem \
      --pqc SecP384r1MLKEM1024
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/slhdsa/root-slhdsa-shake-128s.pem \
      -c certs/slhdsa/client-slhdsa-shake-128s.pem \
      -k certs/slhdsa/client-slhdsa-shake-128s-priv.pem \
      --pqc SecP384r1MLKEM1024
```

`--pqc`には、「ポスト量子アルゴリズムのバリアント名」節に記載されているグループ名のいずれかを指定します。
サンプルの`-?`ヘルプにはビルド構成にかかわらずすべてのグループ名が表示されますが、組み込まれていないグループを指定すると`invalid post-quantum KEM specified`で失敗します。
例えば、X25519MLKEM768には`--enable-curve25519`が、SecP521r1MLKEM1024には`--enable-experimental --enable-extra-pqc-hybrids`が必要です。
`--pqc`を指定しない場合、サンプルクライアントは従来型の鍵共有（P-256と、組み込まれている場合はFFDHE 2048）のみを送信するため、ライブラリのデフォルトのハイブリッド鍵共有は確認できません（「開発者ノート」節を参照してください）。

その他のポスト量子の例に関する詳細情報は <https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md> で確認できます。

### DTLSでのポスト量子アルゴリズム

同じグループと証明書はDTLS 1.3でも使用できます。
wolfSSLを[`--enable-dtls13`](chapter02.md#--enable-dtls13)も指定して構成し、上記のサンプルサーバーとクライアントのコマンドに`-u`を追加してください。
ML-KEMの鍵共有によってClientHelloが1つのデータグラムよりも大きくなることがあるため、ML-KEMとDTLS 1.3の両方が有効な場合、configureはDTLS 1.3のClientHelloフラグメント化（`--enable-dtls-frag-ch`、`WOLFSSL_DTLS_CH_FRAG`）も有効にします。
最初のClientHelloをフラグメント化する必要がある場合、wolfSSLクライアントはそのClientHelloを空の鍵共有で送信します。
サーバーはHelloRetryRequestで応答し、クライアントは2回目のClientHelloで鍵共有を送信します。
この2回目のClientHelloはフラグメント化される場合があります。
サーバーは`wolfSSL_dtls13_allow_ch_frag()`でフラグメント化されたClientHelloを許可する必要があります。
ML-KEMを含むビルドでは、これがデフォルトです。
クッキーを無効にしたDTLS 1.3サーバーもフラグメント化された最初のClientHelloを処理できますが、それは`wolfSSL_dtls13_allow_ch_frag()`が有効な場合に限られます。

## ポスト量子アルゴリズムのバリアント名

ポスト量子アルゴリズムのバリアント名：

NISTセキュリティレベル  |  アルゴリズム  |  wolfCrypt識別子       |  TLSグループ名
--------------------  |  -----------  |  --------------------  |  ---------------
2                     |  ML-DSA-44    |  `WC_ML_DSA_44`        |  n/a
3                     |  ML-DSA-65    |  `WC_ML_DSA_65`        |  n/a
5                     |  ML-DSA-87    |  `WC_ML_DSA_87`        |  n/a
1                     |  ML-KEM-512   |  `WC_ML_KEM_512`       |  `ML_KEM_512`
3                     |  ML-KEM-768   |  `WC_ML_KEM_768`       |  `ML_KEM_768`
5                     |  ML-KEM-1024  |  `WC_ML_KEM_1024`      |  `ML_KEM_1024`

wolfCrypt識別子は、例えば`wc_MlDsaKey_SetParams()`や`wc_MlKemKey_Init()`でパラメータセットを選択するために使用します。
TLSグループ名は、サンプルクライアントとサーバーの`--pqc`、および`wolfSSL_CTX_set1_groups_list()` / `wolfSSL_set1_groups_list()`に渡す名前です。
これらの関数は`MLKEM512`、`MLKEM768`、`MLKEM1024`も受け付けます。
純粋なML-KEMグループには`--enable-tls-mlkem-standalone`が必要です。

ポスト量子ハイブリッドKEMの名前は次のとおりです。
各ハイブリッドは、名前が示す曲線上のECDH鍵合意とML-KEM（FIPS 203）を組み合わせたものです。

wolfSSLグループ名       |  コードポイント  |  組み合わせ                 |  configureオプション
--------------------  |  ----------  |  -------------------------  |  -----------------
`SecP256r1MLKEM768`   |  4587        |  ECDH P-256 + ML-KEM-768    |  デフォルト
`X25519MLKEM768`      |  4588        |  X25519 + ML-KEM-768        |  デフォルト、`--enable-curve25519`が必要
`SecP384r1MLKEM1024`  |  4589        |  ECDH P-384 + ML-KEM-1024   |  デフォルト
`SecP256r1MLKEM512`   |  12107       |  ECDH P-256 + ML-KEM-512    |  `--enable-experimental --enable-extra-pqc-hybrids`
`SecP384r1MLKEM768`   |  12108       |  ECDH P-384 + ML-KEM-768    |  `--enable-experimental --enable-extra-pqc-hybrids`
`SecP521r1MLKEM1024`  |  12109       |  ECDH P-521 + ML-KEM-1024   |  `--enable-experimental --enable-extra-pqc-hybrids`
`X25519MLKEM512`      |  12214       |  X25519 + ML-KEM-512        |  上記に加えて`--enable-curve25519`
`X448MLKEM768`        |  12215       |  X448 + ML-KEM-768          |  上記に加えて`--enable-curve448`

デフォルトのハイブリッドはdraft-ietf-tls-ecdhe-mlkemのコードポイントを使用し、追加のハイブリッドはOpen Quantum Safeプロバイダーのコードポイントを使用します。
[付録G](appendix07.md)の「B-8 ML-KEMハイブリッド（標準）」節もご参照ください。

## 暗号アーティファクトのサイズ

すべてのサイズはバイト単位です。

ポスト量子署名スキームのアーティファクトサイズ：

パラメータセット   | 公開鍵サイズ     | 秘密鍵サイズ      | 最大署名サイズ
---------------- | --------------- | ---------------- | ----------------------
ML-DSA-44        | 1312            | 2560             | 2420
ML-DSA-65        | 1952            | 4032             | 3309
ML-DSA-87        | 2592            | 4896             | 4627
Falcon level 1   | 897             | 1281             | 666
Falcon level 5   | 1793            | 2305             | 1280

SLH-DSAのアーティファクトサイズ（同じパラメータセットのSHA2バリアントとSHAKEバリアントのサイズは同じです）：

パラメータセット   | 公開鍵サイズ     | 秘密鍵サイズ      | 署名サイズ
---------------- | --------------- | ---------------- | --------------
SLH-DSA-128s     | 32              | 64               | 7856
SLH-DSA-128f     | 32              | 64               | 17088
SLH-DSA-192s     | 48              | 96               | 16224
SLH-DSA-192f     | 48              | 96               | 35664
SLH-DSA-256s     | 64              | 128              | 29792
SLH-DSA-256f     | 64              | 128              | 49856

ポスト量子KEMのアーティファクトサイズ：

パラメータセット   | 公開鍵サイズ     | 秘密鍵サイズ      | 暗号文サイズ      | 共有秘密サイズ
---------------- | --------------- | ---------------- | --------------- | ------------------
ML-KEM-512       | 800             | 1632             | 768             | 32
ML-KEM-768       | 1184            | 2400             | 1088            | 32
ML-KEM-1024      | 1568            | 3168             | 1568            | 32

LMS/HSSおよびXMSS/XMSS^MTの鍵と署名のサイズについては、「ポスト量子ステートフルハッシュベース署名」節をご参照ください。

## 統計データ

以下の統計とベンチマークは、macOS 27.2を実行しているApple M5（高性能コア4個、高効率コア6個）上で、Apple clang 21でビルドしたwolfSSL 5.9.4（masterブランチ、2026年11月時点）を使用して取得しました。

wolfSSL：

```text
./configure --enable-mlkem \
            --enable-mldsa \
            --enable-tls-mlkem-standalone \
            --enable-experimental \
            --enable-extra-pqc-hybrids \
            --enable-curve25519 \
            --disable-psk \
            --disable-shared \
            --enable-armasm \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```

**注意**: 主に耐量子アルゴリズムをベンチマークしていますが、比較目的のために従来のアルゴリズムも残しています。
純粋なML-KEMグループと追加のハイブリッドも測定できるように有効にしています。

### 実行時バイナリサイズ

`tls_bench`サンプルアプリケーションのバイナリファイルは、ビルド後にストリップすると2507328バイト（約2.4M）です。
`--enable-mlkem`の代わりに`--disable-mlkem`を指定し、`--enable-mldsa`、`--enable-tls-mlkem-standalone`、`--enable-experimental`、`--enable-extra-pqc-hybrids`を指定しない場合は、ビルド後にストリップすると2273088バイト（約2.2M）です。
これは234240バイト（約229K）の差です。

### TLS 1.3データ送信サイズ

サンプルサーバーとクライアントを実行し、双方向に送信されたすべてのTCPペイロードのバイト数を数えて取得した値を以下に示します（Wiresharkですべてのパケットの`tcp.len`を合計した値と同じです）。
これには、相互認証による TLS 1.3 ハンドシェイク、"hello wolfssl!"、"I hear you fa shizzle!" メッセージが含まれます。
両ピアは同じ種類の証明書を使用します。
RSAの行ではサンプルのデフォルト証明書を使用し、ML-DSAの行では両側で自己署名の`certs/mldsa/mldsa<N>-cert.pem`と`certs/mldsa/mldsa<N>-key.pem`を使用しています。
例えば次のように実行します。

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 --pqc ML_KEM_768
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 --pqc ML_KEM_768
```

ML-DSAの行では、両方のコマンドに`-A certs/mldsa/mldsa44-cert.pem -c certs/mldsa/mldsa44-cert.pem -k certs/mldsa/mldsa44-key.pem`（または65もしくは87のファイル）を追加しました。
`--pqc`を指定していない行では、P-256の鍵共有のみを送信するように、クライアントを`-Y`付きで実行しました（デフォルトではFFDHE 2048の鍵共有も送信します）。
ClientHelloにはビルドがサポートするすべてのグループが列挙されるため、グループの少ないビルドでは送信されるデータ量がわずかに少なくなります。

暗号スイート             | 認証                 | 鍵確立                 | 合計バイト
---------------------- | -------------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | ECC SECP256R1         | 5230
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | ML_KEM_512            | 6668
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | ML_KEM_768            | 7372
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | ML_KEM_1024           | 8236
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | SecP256r1MLKEM768     | 7502
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | X25519MLKEM768        | 7436
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | SecP384r1MLKEM1024    | 8430
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | SecP256r1MLKEM512     | 6798
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | SecP384r1MLKEM768     | 7566
TLS_AES_256_GCM_SHA384 | RSA 2048ビット         | SecP521r1MLKEM1024    | 8502
TLS_AES_256_GCM_SHA384 | ML-DSA-44            | ECC SECP256R1         | 13918
TLS_AES_256_GCM_SHA384 | ML-DSA-44            | SecP384r1MLKEM1024    | 17118
TLS_AES_256_GCM_SHA384 | ML-DSA-65            | ECC SECP256R1         | 18754
TLS_AES_256_GCM_SHA384 | ML-DSA-65            | SecP384r1MLKEM1024    | 21954
TLS_AES_256_GCM_SHA384 | ML-DSA-87            | ECC SECP256R1         | 25306
TLS_AES_256_GCM_SHA384 | ML-DSA-87            | SecP384r1MLKEM1024    | 28506

ML_KEM_*の行には`--enable-tls-mlkem-standalone`が、SecP256r1MLKEM512、SecP384r1MLKEM768、SecP521r1MLKEM1024の行には`--enable-experimental --enable-extra-pqc-hybrids`が、X25519MLKEM768の行には`--enable-curve25519`が必要です。

### ヒープとスタックの使用量

これらの統計は、`--enable-trackmemory --enable-stacksize`構成フラグを追加して取得しました。
これにより、サンプルサーバーとクライアントはスタック使用量が計測されるスレッド内で実行され、使用したスタックと、wolfSSLの初期化からクリーンアップまでの間のヒープ使用量（割り当て回数、割り当てられた総バイト数、およびある時点で使用中だったバイト数のピーク）を出力します。
これらの数値には証明書と鍵の読み込みも含まれており、ビルドオプションによって変化します。

サーバーによるクライアント認証を行わない場合の、サーバー署名とクライアント検証、TLS_AES_256_GCM_SHA384暗号スイート、および鍵交換にECC SECP256R1を使用した際のメモリ使用量を以下に示します。
サーバーは`-d`付きで実行し、クライアントは自身の証明書を読み込まないように`-x`付きで、かつP-256の鍵共有のみを送信するように`-Y`付きで実行しました。
ECDSAの行では`certs/server-ecc.pem`を、ML-DSAの行では自己署名の`certs/mldsa/mldsa<N>-cert.pem`を使用しています。

認証              | 側     | スタック使用量 | 割り当て回数 | ヒープ合計 | ヒープピーク
---------------- | ------ | ---------- | ----------- | ---------- | ---------
RSA 2048         | サーバー | 14064      | 53          | 56373      | 22214
RSA 2048         | クライアント | 16056      | 66          | 59229      | 20745
ECDSA P-256      | サーバー | 14064      | 47          | 29455      | 16106
ECDSA P-256      | クライアント | 16056      | 50          | 31522      | 14290
ML-DSA-44        | サーバー | 14064      | 52          | 170031     | 78217
ML-DSA-44        | クライアント | 16056      | 52          | 114087     | 53314
ML-DSA-65        | サーバー | 14064      | 52          | 247775     | 110817
ML-DSA-65        | クライアント | 16056      | 52          | 160841     | 75579
ML-DSA-87        | サーバー | 14064      | 52          | 367873     | 158962
ML-DSA-87        | クライアント | 16056      | 52          | 236231     | 111585

KEMグループのメモリ使用量を以下に示します。
TLS_AES_256_GCM_SHA384暗号スイートを使用し、クライアントによるサーバー認証にはRSA-2048を使用しています。
サーバーによるクライアント認証は行っていません。
サーバーは`-d`付きで、クライアントは`-x`付きで実行しました。
グループは両側で`--pqc <group>`を指定して選択しました（X25519の場合は`-t`、SECP256R1の場合はクライアントで`-Y`を使用）。

鍵確立             | 側     | スタック使用量 | 割り当て回数 | ヒープ合計 | ヒープピーク
------------------ | ------ | ---------- | ----------- | ---------- | ---------
ECC SECP256R1      | サーバー | 14064      | 53          | 56373      | 22214
ECC SECP256R1      | クライアント | 16056      | 66          | 59229      | 20745
ECC X25519         | サーバー | 13320      | 54          | 48101      | 22181
ECC X25519         | クライアント | 16056      | 66          | 50881      | 20712
ML_KEM_512         | サーバー | 13320      | 54          | 62613      | 25854
ML_KEM_512         | クライアント | 16056      | 70          | 72401      | 23112
ML_KEM_768         | サーバー | 13320      | 54          | 68117      | 31038
ML_KEM_768         | クライアント | 16056      | 70          | 82577      | 28765
ML_KEM_1024        | サーバー | 13320      | 54          | 74965      | 37406
ML_KEM_1024        | クライアント | 16056      | 70          | 95281      | 36477
SecP256r1MLKEM768  | サーバー | 14832      | 61          | 78171      | 32546
SecP256r1MLKEM768  | クライアント | 16056      | 80          | 93975      | 30208
X25519MLKEM768     | サーバー | 13320      | 61          | 69781      | 32414
X25519MLKEM768     | クライアント | 16056      | 80          | 85585      | 30109
SecP384r1MLKEM1024 | サーバー | 18544      | 61          | 85691      | 39522
SecP384r1MLKEM1024 | クライアント | 19376      | 80          | 107735     | 38496
SecP256r1MLKEM512  | サーバー | 14832      | 61          | 72347      | 28099
SecP256r1MLKEM512  | クライアント | 16056      | 80          | 83095      | 24737
SecP384r1MLKEM768  | サーバー | 18544      | 61          | 78363      | 32674
SecP384r1MLKEM768  | クライアント | 19376      | 80          | 94167      | 30304
SecP521r1MLKEM1024 | サーバー | 24032      | 61          | 85907      | 39666
SecP521r1MLKEM1024 | クライアント | 24864      | 80          | 107951     | 38604

### ベンチマーク

以下のベンチマークは、「統計データ」節の冒頭に示した構成フラグを使用して取得しました。

#### wolfCryptによるベンチマーク

**注意**: 1つのコアのみが使用されています。
`-ecc`はP-256のみを測定します。
その他の曲線は`-ecc-all`、`-p384`、`-p521`で測定します。
`-ml-kem-512`、`-ml-dsa-44`などは単一のパラメータセットを選択し、`-slhdsa`、`-falcon_level1`、`-falcon_level5`、`-lms_hss`、`-xmss_xmssmt`は、組み込まれている場合にその他のポスト量子アルゴリズムを測定します。
AArch64では、「Cycles」の数値はCPUコアのサイクル数ではなく、システムタイマー（その周波数は「Clock frequency」として表示されます）で計測されます。

```text
./wolfcrypt/benchmark/benchmark -ecc -x25519 -ml-kem -ml-dsa
------------------------------------------------------------------------------
 wolfSSL version 5.9.4
------------------------------------------------------------------------------
CPU: Aarch64 - aes pmull sha256 sha512 rdm sha3
Clock frequency: 1000000000 Hz
Math: 	Multi-Precision: Wolf(SP) no-dyn-stack word-size=64 bits=4096 sp_int.c
	Single Precision: ecc 256 384 521 rsa/dh 2048 3072 4096 asm sp_arm64.c
	Assembly Speedups: ARMASM ALIGN
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
ML-KEM 512    128  key gen    416000 ops took 1.000 sec, avg 0.002 ms, 415934.748 ops/sec, 1000151922 cycles     2404.2 Cycles/op
ML-KEM 512    128    encap    364000 ops took 1.000 sec, avg 0.003 ms, 363971.971 ops/sec, 1000072762 cycles     2747.5 Cycles/op
ML-KEM 512    128    decap    244200 ops took 1.000 sec, avg 0.004 ms, 244189.521 ops/sec, 1000038535 cycles     4095.2 Cycles/op
ML-KEM 768    192  key gen    293000 ops took 1.000 sec, avg 0.003 ms, 292985.051 ops/sec, 1000045870 cycles     3413.1 Cycles/op
ML-KEM 768    192    encap    244100 ops took 1.000 sec, avg 0.004 ms, 244013.374 ops/sec, 1000350401 cycles     4098.1 Cycles/op
ML-KEM 768    192    decap    167000 ops took 1.000 sec, avg 0.006 ms, 166981.129 ops/sec, 1000109070 cycles     5988.7 Cycles/op
ML-KEM 1024   256  key gen    171900 ops took 1.000 sec, avg 0.006 ms, 171855.298 ops/sec, 1000255617 cycles     5818.8 Cycles/op
ML-KEM 1024   256    encap    152200 ops took 1.000 sec, avg 0.007 ms, 152125.140 ops/sec, 1000488156 cycles     6573.5 Cycles/op
ML-KEM 1024   256    decap    111200 ops took 1.000 sec, avg 0.009 ms, 111160.087 ops/sec, 1000354818 cycles     8996.0 Cycles/op
ECDHE [      SECP256R1]   256    agree     37200 ops took 1.001 sec, avg 0.027 ms, 37161.574 ops/sec, 1001029139 cycles    26909.4 Cycles/op
ECDSA [      SECP256R1]   256     sign     91900 ops took 1.000 sec, avg 0.011 ms, 91856.375 ops/sec, 1000471181 cycles    10886.5 Cycles/op
ECDSA [      SECP256R1]   256   verify     34900 ops took 1.001 sec, avg 0.029 ms, 34861.343 ops/sec, 1001104424 cycles    28684.9 Cycles/op
CURVE  25519    agree     66500 ops took 1.001 sec, avg 0.015 ms, 66458.866 ops/sec, 1000614019 cycles    15046.8 Cycles/op
ML-DSA    44  key gen     97300 ops took 1.000 sec, avg 0.010 ms, 97285.387 ops/sec, 1000145962 cycles    10279.0 Cycles/op
ML-DSA    44     sign     32300 ops took 1.001 sec, avg 0.031 ms, 32263.539 ops/sec, 1001125275 cycles    30994.6 Cycles/op
ML-DSA    44   verify     94500 ops took 1.001 sec, avg 0.011 ms, 94446.363 ops/sec, 1000563608 cycles    10588.0 Cycles/op
ML-DSA    65  key gen     57300 ops took 1.000 sec, avg 0.017 ms, 57272.567 ops/sec, 1000474781 cycles    17460.3 Cycles/op
ML-DSA    65     sign     22000 ops took 1.002 sec, avg 0.046 ms, 21957.444 ops/sec, 1001934023 cycles    45542.5 Cycles/op
ML-DSA    65   verify     61300 ops took 1.001 sec, avg 0.016 ms, 61249.897 ops/sec, 1000813141 cycles    16326.5 Cycles/op
ML-DSA    87  key gen     37600 ops took 1.001 sec, avg 0.027 ms, 37576.295 ops/sec, 1000626661 cycles    26612.4 Cycles/op
ML-DSA    87     sign     17600 ops took 1.005 sec, avg 0.057 ms, 17512.228 ops/sec, 1005007883 cycles    57102.7 Cycles/op
ML-DSA    87   verify     37800 ops took 1.002 sec, avg 0.027 ms, 37712.765 ops/sec, 1002308693 cycles    26516.1 Cycles/op
Benchmark complete
```

#### wolfSSLによるベンチマーク

`tls_bench`は、ビルドがサポートするすべてのTLS 1.3グループに対してベンチマークを1回ずつ実行する`-g`と、各テストを2秒間実行する`-t 2`を指定して実行しました。

```sh
./examples/benchmark/tls_bench -g -l TLS13-AES256-GCM-SHA384 -t 2
```

**注意**: これらのベンチマークには2つのコアのみが使用されています。
`tls_bench`は、1つのサーバースレッドと1つのクライアントスレッドを実行します。
サーバーはRSA 2048ビットの証明書で認証し、クライアントは認証されません。

以下の表は、各側が報告したハンドシェイク完了までの平均時間（「Connect Avg」）を示しています。
`tls_bench`は、最初に実行するグループ（ここではECC_SECP256R1）を「N/A」と表示します。

グループ              | サーバーConnect Avg (ms) | クライアントConnect Avg (ms)
------------------- | ----------------------- | -----------------------
ECC_SECP256R1       | 0.508                   | 0.489
ECC_SECP384R1       | 0.590                   | 0.571
ECC_SECP521R1       | 0.667                   | 0.651
ECC_X25519          | 0.502                   | 0.481
FFDHE_2048          | 0.785                   | 0.766
ML_KEM_512          | 0.500                   | 0.475
ML_KEM_768          | 0.502                   | 0.476
ML_KEM_1024         | 0.513                   | 0.484
SecP256r1MLKEM768   | 0.523                   | 0.495
SecP384r1MLKEM1024  | 0.619                   | 0.574
X25519MLKEM768      | 0.530                   | 0.500
SecP256r1MLKEM512   | 0.546                   | 0.513
SecP384r1MLKEM768   | 0.655                   | 0.602
SecP521r1MLKEM1024  | 0.778                   | 0.703
X25519MLKEM512      | 0.531                   | 0.501

## ドキュメンテーション

各標準はNISTのWebサイトで入手できます。

- ML-KEM、FIPS 203: <https://csrc.nist.gov/pubs/fips/203/final>
- ML-DSA、FIPS 204: <https://csrc.nist.gov/pubs/fips/204/final>
- SLH-DSA、FIPS 205: <https://csrc.nist.gov/pubs/fips/205/final>
- LMSおよびXMSS、NIST SP 800-208: <https://csrc.nist.gov/pubs/sp/800/208/final>

お使いのハードウェアでアルゴリズムを測定するには、「ベンチマーク」節に示したwolfCryptベンチマークを使用してください。

## ポスト量子ステートフルハッシュベース署名

このセクションでは、ポスト量子ステートフルハッシュベース署名(HBS)スキームであるLMS/HSSおよびXMSS/XMSS^MTについて記します。
wolfCryptは、両方のネイティブ実装を備えています。
wolfSSL 5.9.2以降では、これらをX.509証明書(RFC 9802)でも使用できます。
wolfSSLはHSS/LMSまたはXMSS/XMSS^MTで署名された証明書を検証でき、そのような証明書や証明書署名要求を生成することもできます。
TLSハンドシェイクの署名アルゴリズムとしては使用できません。

### 動機づけ

ステートフルHBSスキームは、いくつかの理由から注目を集めています。
ステートフルHBSスキームの主な目的は、ポスト量子セキュリティの確保です。
本付録で前述したように、ショアのアルゴリズムにより、量子コンピューターは大きな整数を効率的に因数分解し、離散対数を計算することができます。
これによって、RSAやECCなどの公開鍵暗号スキームを完全に破ることができます。

対照的に、ステートフルHBSスキームは、その基礎となるハッシュ関数とマークルツリー(通常SHA256で実装)のセキュリティに基づいており、暗号に関連する量子コンピューターの登場によって破られることは予想されていません。
これらの理由から、ステートフルHBSスキームは NIST SP 800-208 および NSA の CNSA 2.0 スイートで推奨されています。
詳細については、次の2つのリンクをご参照ください。

- <https://csrc.nist.gov/publications/detail/sp/800-208/final>
- <https://media.defense.gov/2022/Sep/07/2003071834/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF>

さらにCNSA 2.0のタイムラインでは、2030年までにポスト量子ステートフルHBSスキームのみを使用する必要があり、採用は 「直ちに」 開始する必要があると規定されています。
実際、LMS の採用は、CNSA 2.0スイートのタイムラインで最も早い要件です。

ただし、ステートフルHBSスキームの性質上、その使用と状態の追跡には細心の注意を払う必要があります。
ステートフルHBSシステムでは、秘密鍵は実際にはワンタイム署名(OTS)キーの有限セットであり、決して再利用してはなりません。
同じOTSキーを使用して2つの異なるメッセージを署名すると、攻撃者が署名を偽造できる可能性があり、スキーム全体のセキュリティが崩壊します。
したがって、ステートフルHBSスキームは、パブリックインターネットなどの一般的な使用には適していません。

その代わりに、こうした独自の長所と特性、およびNISTとNSAによる支持から、LMS/HSSなどのステートフルHBSスキームは、特に長い運用寿命が期待され、暗号に関連する量子コンピューターに対して耐性が求められる組み込みシステムや制約付きシステムでのオフラインファームウェア認証と署名検証に特に役立ちます。

### LMS/HSS署名

wolfCryptは、LMS/HSSハッシュベース署名スキーム(RFC 8554、NIST SP 800-208)のネイティブ実装を備えています。
外部ライブラリは必要ありません。

Leighton-Micali Signatures(LMS)とそのマルチツリーのバリアントであるHierarchical Signature System(HSS)は、ポスト量子、ステートフルハッシュベース署名スキームです。
公開鍵と秘密鍵が小さく、署名と検証が速いことで知られています。
署名のサイズは大きくなりますが、Winternitzパラメーターを介して調整できます。
詳細については、RFC8554の次の2つのリンクを参照してください。

- LMS: <https://datatracker.ietf.org/doc/html/rfc8554>
- HSS: <https://datatracker.ietf.org/doc/html/rfc8554#section-6>

前述したように、LMS/HSS署名システムは有限数のワンタイム署名(OTS)鍵で構成されているため、有限数の署名しか安全に生成できません。
ただし、署名の数と署名のサイズは、次に説明する一連の定義済みパラメーターを介して調整できます。

#### サポートしているパラメータ

LMS/HSS署名は3つのパラメータによって定義されます。

- levels: マークルツリーのレベル数
- height: 個々のマークルツリーの高さ
- Winternitz: ウィンターニッツチェーンで使用されるハッシュのビット数。
 署名サイズの時空間トレードオフとして使用されます。

wolfSSLは、次のLMS/HSSパラメータ値をサポートしています。

- levels = {1..4}
- height = {5, 10, 15, 20, 25}
- Winternitz = {1, 2, 4, 8}

[RFC 8554](https://tex2e.github.io/rfc-translater/html/rfc8554.html)では最大8レベルまで認められていますが、wolfSSLがサポートするのは最大4レベルまでです(`WOLFSSL_LMS_MAX_LEVELS`、デフォルトは4)。
`WOLFSSL_LMS_MAX_HEIGHT`(デフォルトは25)を使用すると、ツリーの高さの最大値を下げてメモリを節約できます。
デフォルトでは、パラメータセットは32バイト(SHA-256/256)のハッシュでSHA-256を使用します。
NIST SP 800-208のSHA-256/192およびSHAKE256(256ビットおよび192ビット出力)のパラメータセットは、ビルド時に追加できます。
「LMS/HSSビルド方法」節をご参照ください。

利用可能な署名の数は次の通りです。
- N = 2 ** (levels * height)

パラメータセットはenum `wc_LmsParm` で事前定義されており、鍵を`wc_LmsKey_SetLmsParm()`と`wc_LmsKey_SetParameters()`のどちらで設定する場合でも、そこに列挙されている組み合わせのみを使用できます。
SHA-256/256パラメータセットの一部を以下の表に示します。
完全な一覧については、`wolfssl/wolfcrypt/wc_lms.h`の`enum wc_LmsParm`をご参照ください。
そこには`WC_LMS_PARM_SHA256_192_*`、`WC_LMS_PARM_SHAKE_*`、`WC_LMS_PARM_SHAKE192_*`のセットも含まれています。
`WC_LMS_PARM_NONE`はパラメータセットではありません。
`wc_LmsKey_SetLmsParm()`はこれを拒否するため、必ずパラメータセットを選択する必要があります。

パラメータセット |  説明
--------------------  |  ---------------------------
WC_LMS_PARM_L1_H15_W2 | level:1, height:15, Winternitz:2
WC_LMS_PARM_L1_H15_W4 | level:1, height:15, Winternitz:4
WC_LMS_PARM_L2_H10_W2 | level:2, height:10, Winternitz:2
WC_LMS_PARM_L2_H10_W4 | level:2, height:10, Winternitz:4
WC_LMS_PARM_L2_H10_W8 | level:2, height:10, Winternitz:8
WC_LMS_PARM_L3_H5_W2  | level:3, height:5, Winternitz:2
WC_LMS_PARM_L3_H5_W4  | level:3, height:5, Winternitz:4
WC_LMS_PARM_L3_H5_W8  | level:3, height:5, Winternitz:8
WC_LMS_PARM_L3_H10_W4 | level:3, height:10, Winternitz:4
WC_LMS_PARM_L4_H5_W8  | level:4, height:5, Winternitz:8

ここで設定したパラメータに対する、署名のサイズと署名の数を示します。

パラメータセット |  署名サイズ | 署名数
--------------------  | -------------------- | --------------------
WC_LMS_PARM_L1_H15_W2 | 4784 | 32768
WC_LMS_PARM_L1_H15_W4 | 2672 | 32768
WC_LMS_PARM_L2_H10_W2 | 9300 | 1048576
WC_LMS_PARM_L2_H10_W4 | 5076 | 1048576
WC_LMS_PARM_L2_H10_W8 | 2964 | 1048576
WC_LMS_PARM_L3_H5_W2  | 13496 | 32768
WC_LMS_PARM_L3_H5_W4  | 7160 | 32768
WC_LMS_PARM_L3_H5_W8  | 3992 | 32768
WC_LMS_PARM_L3_H10_W4 | 7640 | 1073741824
WC_LMS_PARM_L4_H5_W8  | 5340 | 1048576

表から分かるように、署名のサイズは主にレベルとWinternitz値、および比較的影響は小さいですが高さによって決まります。

- レベル値を大きくすると、署名サイズは大幅に増加します。
- 高さの値を大きくすると、署名のサイズは緩やかに増加します。
- Winternitz値を大きくすると、署名のサイズは小さくなりますが、鍵の生成と署名/検証にかかる時間が長くなります。

鍵の生成時間は、第1レベルのツリーの高さによって大きく決まります。
使用可能な署名の数が同じであっても、レベル3、高さ5のツリーは、初期鍵生成時にレベル1、高さ15のツリーよりもはるかに高速です。

公開鍵のサイズは、SHA-256/256およびSHAKE256/256パラメータセットでは60バイト、192ビットのパラメータセットでは52バイトです。
保存しておく必要がある秘密鍵のサイズは、256ビットのパラメータセットでは64バイトです。
`wc_LmsKey_GetPrivLen()`は、どのパラメータセットについてもこのサイズを返します。

#### LMS/HSSビルド方法

[`--enable-lms`](chapter02.md#--enable-lms)を指定してwolfSSLをビルドしてください。
外部ライブラリは必要ありません。
`--enable-all-quantum-crypto`でもLMS/HSSが有効になります。
`--enable-lms`には、サブオプションをカンマ区切りのリストで指定できます。

- `verify-only`: 署名検証のみをコンパイルします(`WOLFSSL_LMS_VERIFY_ONLY`)。
- `small`: メモリが限られている場合向けに、署名が遅くなる代わりにコードを小さくします(`WOLFSSL_WC_LMS_SMALL`)。
- `sha256-192`: SHA-256/192パラメータセットを追加します(`WOLFSSL_LMS_SHA256_192`)。
- `shake256`: SHAKE256/256およびSHAKE256/192パラメータセットを追加します(`WOLFSSL_LMS_SHAKE256`)。
- `no-sha256-256`: SHA-256/256パラメータセットを除外します(`WOLFSSL_NO_LMS_SHA256_256`)。
  `sha256-192`または`shake256`と組み合わせる必要があります。

例えば、次のように指定します。

```sh
./configure --enable-lms=sha256-192,shake256
```

smallビルド以外では、`WOLFSSL_LMS_ROOT_LEVELS`と`WOLFSSL_LMS_CACHE_BITS`(どちらもデフォルトは5、`WOLFSSL_LMS_LARGE_CACHES`を定義した場合は7)によって、`LmsKey`オブジェクトのサイズと引き換えに署名を高速化できます。
これらについては`wolfssl/wolfcrypt/wc_lms.h`で説明しています。

#### LMS/HSS鍵の使用

署名鍵は、次の手順で使用します。

1. [`wc_LmsKey_Init()`](group__LMS.md#function-wc_lmskey_init)を呼び出し、[`wc_LmsKey_SetLmsParm()`](group__LMS.md#function-wc_lmskey_setlmsparm)または[`wc_LmsKey_SetParameters()`](group__LMS.md#function-wc_lmskey_setparameters)でパラメータセットを選択します。
2. [`wc_LmsKey_SetWriteCb()`](group__LMS.md#function-wc_lmskey_setwritecb)、[`wc_LmsKey_SetReadCb()`](group__LMS.md#function-wc_lmskey_setreadcb)、[`wc_LmsKey_SetContext()`](group__LMS.md#function-wc_lmskey_setcontext)で、秘密鍵のコールバックを設定します。
   コンテキストポインタ(例えばファイル名)はコールバックに渡されます。
3. [`wc_LmsKey_MakeKey()`](group__LMS.md#function-wc_lmskey_makekey)は鍵ペアを生成し、書き込みコールバックで秘密鍵を保存します。
   公開鍵は[`wc_LmsKey_ExportPubRaw()`](group__LMS.md#function-wc_lmskey_exportpubraw)でエクスポートします。
4. [`wc_LmsKey_Sign()`](group__LMS.md#function-wc_lmskey_sign)は、呼び出すたびにワンタイム鍵を1つ消費し、署名を返す前に、更新された秘密鍵を書き込みコールバックで保存します。
   [`wc_LmsKey_SigsLeft()`](group__LMS.md#function-wc_lmskey_sigsleft)は、その鍵でまだ署名できる間は0以外の値を返します。
5. 後で(例えば再起動後に)署名を続けるには、同じパラメータセットとコールバックで新しい`LmsKey`を設定し、[`wc_LmsKey_Reload()`](group__LMS.md#function-wc_lmskey_reload)を呼び出します。
   この関数は読み込みコールバックで秘密鍵を読み込み、キャッシュされたツリーの状態を再構築します。
   これには鍵生成とほぼ同じ時間がかかります。
   再読み込みした鍵で署名はできますが、公開鍵は保持していないため、鍵生成後にエクスポートした公開鍵を保管しておいてください。

コールバックの型は次の通りです。

```c
typedef int (*wc_lms_write_private_key_cb)(const byte* priv, word32 privSz,
    void* context);
typedef int (*wc_lms_read_private_key_cb)(byte* priv, word32 privSz,
    void* context);
```

書き込みコールバックは、秘密鍵が不揮発性ストレージに格納されて初めて`WC_LMS_RC_SAVED_TO_NV_MEMORY`を返すようにしてください。
読み込みコールバックは、`priv`にデータを格納した時点で`WC_LMS_RC_READ_TO_MEMORY`を返します。
それ以外の値を返すと、呼び出しは`IO_FAILED_E`で失敗します。
署名中に更新された秘密鍵の保存に失敗した場合、`wc_LmsKey_Sign()`は署名を消去し、その鍵ではそれ以上署名できなくなります。
同じ秘密鍵の2つのコピーで署名したり、保存されている秘密鍵を古いコピーに戻したりしないでください。
どちらもワンタイム鍵の再利用につながります。

検証するには、[`wc_LmsKey_ImportPubRaw()`](group__LMS.md#function-wc_lmskey_importpubraw)で公開鍵を専用の鍵オブジェクトにインポートし、[`wc_LmsKey_Verify()`](group__LMS.md#function-wc_lmskey_verify)を呼び出します。
`wc_LmsKey_ImportPubRaw()`は、パラメータセットが設定されていない場合、公開鍵からパラメータセットを取得します。

次の例では、小さなパラメータセット`WC_LMS_PARM_L1_H5_W8`(32署名)で鍵を生成し、秘密鍵をファイルに保存して、署名と検証を行い、鍵を再読み込みして再び署名します。

```c
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/wolfcrypt/error-crypt.h>
#include <wolfssl/wolfcrypt/random.h>
#include <wolfssl/wolfcrypt/wc_lms.h>
#include <stdio.h>
#include <stdlib.h>

/* The private key must be stored before wc_LmsKey_MakeKey() or
 * wc_LmsKey_Sign() returns. Only return WC_LMS_RC_SAVED_TO_NV_MEMORY once the
 * data is durable (a real application should write a new file, sync it and
 * rename it over the old one). */
static int lms_write_key(const byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "wb");
    int ok;

    if (f == NULL)
        return WC_LMS_RC_WRITE_FAIL;
    ok = (fwrite(priv, 1, privSz, f) == privSz);
    if (fclose(f) != 0)
        ok = 0;
    return ok ? WC_LMS_RC_SAVED_TO_NV_MEMORY : WC_LMS_RC_WRITE_FAIL;
}

/* Called by wc_LmsKey_Reload() to load the stored private key. */
static int lms_read_key(byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "rb");
    size_t n;

    if (f == NULL)
        return WC_LMS_RC_READ_FAIL;
    n = fread(priv, 1, privSz, f);
    fclose(f);
    return (n == privSz) ? WC_LMS_RC_READ_TO_MEMORY : WC_LMS_RC_READ_FAIL;
}

/* Set the parameters and callbacks: needed before MakeKey and Reload. */
static int lms_setup(LmsKey* key, const char* file)
{
    int ret = wc_LmsKey_Init(key, NULL, INVALID_DEVID);
    if (ret == 0)
        ret = wc_LmsKey_SetLmsParm(key, WC_LMS_PARM_L1_H5_W8);
    if (ret == 0)
        ret = wc_LmsKey_SetWriteCb(key, lms_write_key);
    if (ret == 0)
        ret = wc_LmsKey_SetReadCb(key, lms_read_key);
    if (ret == 0)
        ret = wc_LmsKey_SetContext(key, (void*)file);
    return ret;
}

int main(void)
{
    const char* file = "lms_priv.key";
    const byte  msg[] = "firmware image";
    byte   pub[HSS_MAX_PUBLIC_KEY_LEN];
    word32 pubSz = sizeof(pub);
    byte*  sig = NULL;
    word32 sigSz = 0;
    LmsKey key;
    LmsKey verifyKey;
    WC_RNG rng;
    int    ret;

    ret = wc_InitRng(&rng);
    if (ret != 0)
        return 1;

    /* Generate a new key pair. The private key is written with the write
     * callback. */
    ret = lms_setup(&key, file);
    if (ret == 0)
        ret = wc_LmsKey_MakeKey(&key, &rng);
    if (ret == 0)
        ret = wc_LmsKey_ExportPubRaw(&key, pub, &pubSz);
    if (ret == 0)
        ret = wc_LmsKey_GetSigLen(&key, &sigSz);
    if (ret == 0) {
        sig = (byte*)malloc(sigSz);
        if (sig == NULL)
            ret = MEMORY_E;
    }
    /* Each signature uses up one one-time key. The updated private key is
     * written before the signature is returned. */
    if (ret == 0)
        ret = wc_LmsKey_Sign(&key, sig, &sigSz, msg, (int)sizeof(msg));
    wc_LmsKey_Free(&key);

    /* Verify with a public-key-only object. The parameter set is taken from
     * the public key. */
    if (ret == 0)
        ret = wc_LmsKey_Init(&verifyKey, NULL, INVALID_DEVID);
    if (ret == 0) {
        ret = wc_LmsKey_ImportPubRaw(&verifyKey, pub, pubSz);
        if (ret == 0)
            ret = wc_LmsKey_Verify(&verifyKey, sig, sigSz, msg,
                (int)sizeof(msg));
        wc_LmsKey_Free(&verifyKey);
    }

    /* Later, for example after a restart: reload the stored private key and
     * carry on signing where it left off. */
    if (ret == 0)
        ret = lms_setup(&key, file);
    if (ret == 0)
        ret = wc_LmsKey_Reload(&key);
    if ((ret == 0) && (wc_LmsKey_SigsLeft(&key) == 0))
        ret = KEY_EXHAUSTED_E;
    if (ret == 0)
        ret = wc_LmsKey_Sign(&key, sig, &sigSz, msg, (int)sizeof(msg));
    wc_LmsKey_Free(&key);

    printf("LMS example %s (%d)\n", (ret == 0) ? "passed" : "failed", ret);
    free(sig);
    wc_FreeRng(&rng);
    return (ret == 0) ? 0 : 1;
}
```

#### ベンチマークデータ

次のベンチマークデータは、「統計データ」節で説明しているApple M5システム上で、`./configure --enable-lms --enable-xmss --enable-armasm`および`./configure --enable-lms --enable-xmss`で構成したwolfSSL 5.9.4を使用し、次のコマンドを実行して取得しました。

```sh
./wolfcrypt/benchmark/benchmark -lms_hss
```

各時間はミリ秒単位の平均値で、`--enable-armasm`ありの値を先に、なしの値を後に示しています。
`--enable-armasm`はARMv8のSHA-256命令を使用するため、LMS/HSSのすべての操作が高速化されます。
再読み込みは`wc_LmsKey_Reload()`の時間です。
シングルコアのみを使用しています。

パラメータセット | 署名サイズ | 鍵生成 (ms)     | 再読み込み (ms)  | 署名 (ms)     | 検証 (ms)
------------- | -------------- | ---------------- | ---------------- | ------------- | -------------
L1_H5_W4      | 2352           | 1.066 / 5.535    | 1.071 / 5.381    | 0.017 / 0.089 | 0.016 / 0.085
L1_H5_W8      | 1296           | 8.562 / 42.308   | 10.534 / 42.950  | 0.382 / 0.645 | 0.206 / 0.753
L2_H10_W2     | 9300           | 37.449 / 188.105 | 34.651 / 188.645 | 0.052 / 0.281 | 0.016 / 0.088
L2_H10_W4     | 5076           | 68.022 / 343.029 | 67.543 / 344.260 | 0.099 / 0.507 | 0.034 / 0.178
L3_H5_W4      | 7160           | 3.312 / 17.186   | 3.391 / 17.427   | 0.053 / 0.268 | 0.048 / 0.268
L3_H5_W8      | 3992           | 26.232 / 144.790 | 26.499 / 140.189 | 0.411 / 2.185 | 0.408 / 2.240
L3_H10_W4     | 7640           | 103.184 / 548.525 | 102.161 / 563.973 | 0.099 / 0.546 | 0.050 / 0.258
L4_H5_W8      | 5340           | 35.179 / 188.079 | 35.460 / 187.302 | 0.417 / 2.174 | 0.573 / 3.758

### XMSS/XMSS^MT 署名

wolfCryptは、[RFC 8391](https://tex2e.github.io/rfc-translater/html/rfc8391.html)およびNIST SP 800-208のXMSSおよびXMSS^MTステートフルハッシュベース署名スキームのネイティブ実装を備えています。
[`--enable-xmss`](chapter02.md#--enable-xmss)を指定してwolfSSLをビルドしてください。
外部ライブラリは必要ありません。
`--enable-all-quantum-crypto`でもXMSS/XMSS^MTが有効になります。
`--enable-xmss`には、次のサブオプションがあります。

- `verify-only`: 署名検証のみをコンパイルします(`WOLFSSL_XMSS_VERIFY_ONLY`)。
- `small`: コードを小さくし、秘密鍵も大幅に小さくします(`WOLFSSL_WC_XMSS_SMALL`)。
  この場合、秘密鍵はツリー走査の状態を保持しないため、署名は大幅に遅くなります。

全体的に、XMSS/XMSS^MTはLMS/HSSに似ています。
より詳細な比較については、[「LMS vs XMSS: 2 つのハッシュベース署名標準の比較」](https://eprint.iacr.org/2017/349.pdf) をご参照ください。

XMSS^MTはXMSSのマルチツリー一般化であり、HSS with LMSに似ていますが、XMSS/XMSS^MTではWinternitz値が `w=16` に固定されている点が異なります。
公開鍵はXMSS/XMSS^MT では若干大きくなり(XMSS/XMSS^MT では68バイト、LMS/HSSでは60バイト)、署名は若干小さくなります。

#### サポートしているパラメータ

wolfSSLは、組み込まれている各ハッシュアルゴリズムについて、RFC 8391およびNIST SP 800-208のXMSS/XMSS^MTパラメータセットをサポートしています。
対象は、n = 32およびn = 24のSHA2-256、SHA2-512(n = 64)、SHAKE128(n = 32)、およびn = 64、32、24のSHAKE256です。
FIPSビルドがサポートするのは、n = 32およびn = 24のSHA2-256とSHAKE256のセットのみです。
以下の表は、[NIST SP 800-208](https://csrc.nist.gov/pubs/sp/800/208/final)の表10および11から、n = 32のSHA2-256パラメータセットを示したものです。
その他のセットの名前も同じパターンに従います。
例えば、"XMSS-SHA2_10_192"、"XMSS-SHA2_10_512"、"XMSS-SHAKE_10_256"、"XMSS-SHAKE256_10_256"、"XMSSMT-SHAKE256_60/12_192"などです。
完全な一覧は`wolfcrypt/src/wc_xmss.c`にあります。
`WOLFSSL_XMSS_MIN_HEIGHT`と`WOLFSSL_XMSS_MAX_HEIGHT`(デフォルトはそれぞれ10と60)によって、コンパイルに含めるツリーの合計の高さを制限できます。

parameter set name      | Oid         | n   | w   | h   | d   | h/d | Sig len
----------------------- | ----------- | --- | --- | --- | --- | --- | --
XMSS                    |             |     |     |     |     |     |
"XMSS-SHA2_10_256"      |  0x00000001 |  32 |  16 |  10 |  1  |  10 | 2500
"XMSS-SHA2_16_256"      |  0x00000002 |  32 |  16 |  16 |  1  |  16 | 2692
"XMSS-SHA2_20_256"      |  0x00000003 |  32 |  16 |  20 |  1  |  20 | 2820
XMSS^MT                 |             |     |     |     |     |     |
"XMSSMT-SHA2_20/2_256"  |  0x00000001 |  32 |  16 |  20 |  2  |  10 | 4963
"XMSSMT-SHA2_20/4_256"  |  0x00000002 |  32 |  16 |  20 |  4  |   5 | 9251
"XMSSMT-SHA2_40/2_256"  |  0x00000003 |  32 |  16 |  40 |  2  |  20 | 5605
"XMSSMT-SHA2_40/4_256"  |  0x00000004 |  32 |  16 |  40 |  4  |  10 | 9893
"XMSSMT-SHA2_40/8_256"  |  0x00000005 |  32 |  16 |  40 |  8  |   5 | 18469
"XMSSMT-SHA2_60/3_256"  |  0x00000006 |  32 |  16 |  60 |  3  |  20 | 8392
"XMSSMT-SHA2_60/6_256"  |  0x00000007 |  32 |  16 |  60 |  6  |  10 | 14824
"XMSSMT-SHA2_60/12_256" |  0x00000008 |  32 |  16 |  60 |  12 |   5 | 27688

上記の表で、`n` は HASH 関数のバイト数、`w` はWinternitz値、`h` はツリーシステムの合計高さ、`d` はツリーのレベル数を示します。

鍵生成時間は第1レベルのツリーの高さ(または`h/d`) によって大きく左右されますが、署名の長さは主に`d` (ハイパーツリーレベルの数)とともに増加します。

LMS/HSSと同様に、使用可能な署名の数は `2**h` に比例して増加します。
ここで `h` はツリーシステムの合計高さです。

#### XMSS/XMSS^MT 鍵の使用

XMSS/XMSS^MT 鍵は、`wc_XmssKey_`関数を使用して、LMS/HSS鍵と同じ方法で使用します。
保存される秘密鍵についても同じ規則が適用されます。
相違点は次の通りです。

- パラメータセットは、[`wc_XmssKey_SetParamStr()`](group__XMSS.md#function-wc_xmsskey_setparamstr)で名前によって選択します。
  例えば、"XMSS-SHA2_10_256"や"XMSSMT-SHA2_20/4_256"のように指定します。
- コールバックは`enum wc_XmssRc`を返します。
  書き込みコールバックは`WC_XMSS_RC_SAVED_TO_NV_MEMORY`を、読み込みコールバックは`WC_XMSS_RC_READ_TO_MEMORY`を返します。
- wolfCryptは、署名と署名の間に秘密鍵をメモリ上に保持しません。
  [`wc_XmssKey_Sign()`](group__XMSS.md#function-wc_xmsskey_sign)は、読み込みコールバックで秘密鍵を読み込んで署名し、更新された秘密鍵を書き込みコールバックで保存してから、自身のコピーを消去します。
  そのため、署名の前に両方のコールバックを設定しておく必要があります。
  [`wc_XmssKey_SigsLeft()`](group__XMSS.md#function-wc_xmsskey_sigsleft)も保存されている秘密鍵を読み込みます。
  [`wc_XmssKey_Reload()`](group__XMSS.md#function-wc_xmsskey_reload)は、秘密鍵を読み込めることを確認するだけです。
- 検証専用の鍵では、[`wc_XmssKey_ImportPubRaw()`](group__XMSS.md#function-wc_xmsskey_importpubraw)の前に`wc_XmssKey_SetParamStr()`でパラメータ文字列を設定する必要があります。
- 秘密鍵の形式はwolfSSL固有であり、そのサイズはパラメータセットと`small`オプションによって異なります("XMSS-SHA2_10_256"の場合、デフォルトでは1343バイト、`small`では136バイトです)。
  XMSS/XMSS^MTの秘密鍵が他の実装で使用できるとは想定しないでください。

例えば、コールバックと鍵生成は次のようになります。

```c
static enum wc_XmssRc xmss_write_key(const byte* priv, word32 privSz,
    void* context)
{
    FILE* f = fopen((const char*)context, "wb");
    int ok;

    if (f == NULL)
        return WC_XMSS_RC_WRITE_FAIL;
    ok = (fwrite(priv, 1, privSz, f) == privSz);
    if (fclose(f) != 0)
        ok = 0;
    return ok ? WC_XMSS_RC_SAVED_TO_NV_MEMORY : WC_XMSS_RC_WRITE_FAIL;
}

static enum wc_XmssRc xmss_read_key(byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "rb");
    size_t n;

    if (f == NULL)
        return WC_XMSS_RC_READ_FAIL;
    n = fread(priv, 1, privSz, f);
    fclose(f);
    return (n == privSz) ? WC_XMSS_RC_READ_TO_MEMORY : WC_XMSS_RC_READ_FAIL;
}

    /* In a function with XmssKey key, an initialized WC_RNG rng,
     * byte pub[XMSS_SHA256_PUBLEN] and word32 pubSz = sizeof(pub): */
    ret = wc_XmssKey_Init(&key, NULL, INVALID_DEVID);
    if (ret == 0)
        ret = wc_XmssKey_SetParamStr(&key, "XMSS-SHA2_10_256");
    if (ret == 0)
        ret = wc_XmssKey_SetWriteCb(&key, xmss_write_key);
    if (ret == 0)
        ret = wc_XmssKey_SetReadCb(&key, xmss_read_key);
    if (ret == 0)
        ret = wc_XmssKey_SetContext(&key, (void*)"xmss_priv.key");
    if (ret == 0)
        ret = wc_XmssKey_MakeKey(&key, &rng);
    if (ret == 0)
        ret = wc_XmssKey_ExportPubRaw(&key, pub, &pubSz);
```

#### ベンチマークデータ

以下では、SHA2-256 XMSS/XMSS^MTパラメータセットのベンチマークデータを示します。
必要となる多数のハッシュチェーンの計算がXMSS/XMSS^MTのCPU処理の大部分を占めるため、SHA256のパフォーマンスも参考として記載しています。
wolfCryptのXMSS/XMSS^MT実装はwolfCryptのSHA-256コードを使用しているため、同じASMによる高速化の恩恵を受けます。

データは、「統計データ」節で説明しているApple M5システム上で、LMS/HSSのデータと同じ2つのビルド(`--enable-armasm`ありとなし)を使用し、次のコマンドを実行して取得しました。

```sh
./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
```

`-xmss_xmssmt`はSHA2-256パラメータセット(n = 32およびn = 24)を実行します。
`-xmss_xmssmt_sha512`、`-xmss_xmssmt_shake128`、`-xmss_xmssmt_shake256`は、その他のハッシュファミリーを実行します。
SHA-256の速度は、`--enable-armasm`ありで2971.128 MiB/s、なしで451.523 MiB/sでした。
x86_64では、`--enable-intelasm`によってアセンブリ版のSHA-256コードが有効になります。

各時間はミリ秒単位の平均値で、`--enable-armasm`ありの値を先に、なしの値を後に示しています。
シングルコアのみを使用しています。

パラメータセット      | 署名サイズ     | 鍵生成 (ms)         | 署名 (ms)     | 検証 (ms)
---------------------- | -------------- | ------------------- | ------------- | -------------
XMSS-SHA2_10_256       | 2500           | 147.243 / 706.314   | 0.659 / 3.129 | 0.081 / 0.364
XMSS-SHA2_10_192       | 1492           | 152.998 / 669.786   | 0.680 / 2.939 | 0.086 / 0.386
XMSSMT-SHA2_20/2_256   | 4963           | 298.039 / 1435.763  | 0.809 / 3.463 | 0.177 / 0.732
XMSSMT-SHA2_20/4_256   | 9251           | 18.635 / 87.609     | 0.473 / 2.214 | 0.335 / 1.472
XMSSMT-SHA2_40/4_256   | 9893           | 609.783 / 2879.408  | 0.862 / 3.975 | 0.339 / 1.590
XMSSMT-SHA2_40/8_256   | 18469          | 39.661 / 189.600    | 0.481 / 2.349 | 0.647 / 3.061
XMSSMT-SHA2_60/6_256   | 14824          | 916.980 / 4452.551  | 0.889 / 4.362 | 0.501 / 2.389
XMSSMT-SHA2_60/12_256  | 27688          | 59.256 / 298.819    | 0.471 / 2.376 | 1.007 / 4.663
XMSSMT-SHA2_20/2_192   | 2955           | 317.927 / 1407.238  | 0.826 / 3.531 | 0.166 / 0.818
XMSSMT-SHA2_20/4_192   | 5403           | 20.774 / 93.409     | 0.477 / 2.312 | 0.341 / 1.535
XMSSMT-SHA2_40/4_192   | 5885           | 641.373 / 3006.338  | 0.894 / 4.040 | 0.351 / 1.647
XMSSMT-SHA2_40/8_192   | 10781          | 38.492 / 181.952    | 0.486 / 2.262 | 0.669 / 3.202
XMSSMT-SHA2_60/6_192   | 8816           | 935.416 / 4241.281  | 0.862 / 4.085 | 0.508 / 2.212
XMSSMT-SHA2_60/12_192  | 16160          | 55.882 / 263.694    | 0.446 / 2.222 | 0.959 / 4.503

### 開発者ノート

* 「今収穫し、後で復号する」脅威モデルを阻止しようとしていて、相互運用性の一部を犠牲にしても構わない場合は、Supported Groups拡張機能で従来のアルゴリズムのサポートを広告したくないことと思います。
  wolfSSLクライアントはデフォルトで既にPQ/Tハイブリッドの鍵共有を送信し(Curve25519が組み込まれている場合はX25519MLKEM768、それ以外の場合はSecP256r1MLKEM768です。別のグループを選択するには`WOLFSSL_KEY_SHARE_DEFAULT_GROUP`を定義します)、Supported Groups拡張機能では標準のハイブリッドを先頭に列挙しますが、その後に従来のグループが続きます。
  ピアがポスト量子アルゴリズムをサポートしていない場合、ピアは`HelloRetryRequest`を送信し、その結果として、従来のアルゴリズムによる接続が確立されます。
  これを防ぐには、[`wolfSSL_CTX_set_groups()`](group__Setup.md#function-wolfssl_ctx_set_groups)または[`wolfSSL_set_groups()`](group__Setup.md#function-wolfssl_set_groups)で、あるいは名前を指定する[`wolfSSL_CTX_set1_groups_list()`](group__Setup.md#function-wolfssl_ctx_set1_groups_list)または[`wolfSSL_set1_groups_list()`](group__Setup.md#function-wolfssl_set1_groups_list)で、選択したグループのみを設定してください。
  名前を指定する2つの関数には、OpenSSL互換レイヤー(例えば`--enable-opensslextra`)が必要です。
  例えば、`"SecP384r1MLKEM1024:X25519MLKEM768"`のように指定します。
  名前の大文字と小文字は区別されません。
  鍵共有は、リスト内のグループのうち、ビルドがサポートしている最初のグループに対して作成されます。
  [`wolfSSL_UseKeyShare()`](group__Setup.md#function-wolfssl_usekeyshare)を呼び出すだけでは不十分です。
  それでは量子的に脆弱なアルゴリズムのサポートを広告することになるからです。
