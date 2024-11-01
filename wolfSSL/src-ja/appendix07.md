

# ポスト量子暗号の実験



wolfSSLチームは、実験的なポスト量子暗号アルゴリズムをwolfSSLライブラリに統合しました。これは、Open Quantum SafeチームのLiboqsと統合することで行われました。それらの詳細については、<https://openquantumsafe.org> を参照してください。


この付録は、TLS 1.3のコンテキストで、ポスト量子暗号について学び、実験したい人を対象としています。そポスト量子アルゴリズムが重要である理由、量子の脅威に対応して私たちが行ったこと、これらの新しいアルゴリズムの実験を開始する方法について説明します。


**NOTE**：liboq が提供するポスト量子アルゴリズムは標準化されておらず、実験的なものです。それらが生産環境では使用しないことを強くお勧めします。すべての OID、コードポイント、アーティファクト形式は一時的なものであり、将来変更される予定です。下位互換性がないことに注意してください。


**注**：wolfsslが`--with-liboqs`フラグで構成されていない場合は、これらの実験的アルゴリズムは有効になっていません。



## ポスト量子暗号をわかりやすく紹介




### なぜポスト量子暗号？



今日では、量子コンピューターの開発にますます多くのリソースが割かれるようになりました。そのため、クラウド量子コンピューティングリソースの商業化がすでに始まっています。現時点では未だ実用レベルの暗号が解かれた報告はありません。しかし、「あらかじめデータを収集、蓄積し、後に時間をかけて解読を進めていく」といった脅威モデルが存在します。すなわち、暗号の復号に特化した量子コンピューターが出現するよりも早いうちに準備が必要です。


NISTが、量子コンピューターに対して脆弱になる公開鍵暗号アルゴリズムを置き換えるように設計された新しいクラスのアルゴリズムの標準化を進めています。この章の執筆時点で、NISTはPQC標準化プロセスの第3ラウンドをほぼ完了させており、2022年初頭に標準化されるアルゴリズムを発表する予定です。その後、プロトコルとデータ形式を記述した標準文書を作成するプロセスにはさらに1年かかると予測されています。さらにその後には、FIPSのような規制の策定が開始される可能性があります。



### 私たちは自分自身をどのように守るのですか？



大まかに言えば、すべての TLS 1.3 接続において、認証と機密性は各接続を保護する重要な目標です。認証は、ECDSAなどの署名スキームによって維持されます。機密性は、ECDHEなどのキー確立アルゴリズムによって維持され、確立されたキーとAESなどの対称暗号化アルゴリズムを使用して通信ストリームを暗号化します。したがって、TLS 1.3 プロトコルのセキュリティは、次の3種類の暗号化アルゴリズムに分解できます。



* 認証アルゴリズム


* キー確立アルゴリズム


* 対称暗号アルゴリズム



量子コンピュータが従来の暗号に及ぼす脅威には2つの形態があります。グローバーのアルゴリズムは、最新の対称暗号アルゴリズムのセキュリティを半分に低下させ、ショアのアルゴリズムは、最新の認証および鍵確立アルゴリズムのセキュリティを完全に破壊します。その結果、対称暗号アルゴリズムの強度を2倍にし、従来の認証および鍵確立アルゴリズムをポスト量子アルゴリズムに置き換えることで、通信を保護し続けることができます。TLS 1.3 ハンドシェイク中、暗号スイートは接続中に使用される対称暗号を指定します。AES-128は一般的に十分であると認められているため、AES_256_GCM_SHA384暗号スイートを使用することで強度を2倍にすることができます。鍵確立と認証には、ポスト量子KEM (Key Encapsulation Mechanisms) と署名スキームがあります。


これらは量子コンピュータへの耐性のため、従来のアルゴリズムとは異なる種類の数学を使用して特別に設計されます。私たちが統合することを選択した認証アルゴリズムとKEMはすべて格子ベースのアルゴリズムです。


* ダイリチウム署名スキーム


* ファルコン署名スキーム


* KYBER KEM


注: SABRE KEM と NTRU KEM は非推奨となり、標準化に移行しなかったため削除されました。


注: KYBER KEM 90s の亜種は非推奨となり、NIST が標準化を検討していないため削除されました。


注: ダイリチウム署名方式の AES バリアントは非推奨となり、NIST が標準化を検討していないため削除されました。



格子ベースの暗号化の説明はこのドキュメントの範囲外のため、これらのアルゴリズムに関する詳細は、NIST の公開文書 <https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions> をご確認ください。


残念ながら、この章を記している時点においてこれらのアルゴリズムが量子コンピューターからの攻撃に耐えられるかどうかは、まだ分かっていません。従来型コンピューターにおける攻撃耐性も同様です。可能性はますます低くなっていますが、誰かが格子ベースの暗号化を破る可能性があります。ただし、暗号化は常にこのような経緯で機能してきた歴史があります。アルゴリズムは使い始めたときは優れていますが、弱点や脆弱性が発見され、テクノロジーは順次改善されます。ポスト量子アルゴリズムは比較的新しいため、コミュニティからもう少し注目する必要があるかもしれません。


解決策の1つは、これらの新しいアルゴリズムを完全には信頼しないことです。今のところ、ポスト量子KEMを、信頼している従来のアルゴリズムとハイブリッド化することで、このリスクを回避することができます。FIPS準拠を第一に考えると、NIST標準曲線を使用したECCは良い選択肢になります。このため、ポスト量子KEMを統合するだけでなく、NISTが承認した曲線上のECDSAとハイブリッド化しました。詳しくは以下のハイブリッドグループのリストを参照してください。



## ｗolfSSLのLiboqs統合を始めましょう



ここでは、まっさらなLinux環境から安全なTLS 1.3接続を実行できるようにするまでの手順を示します。

### ビルド手順

wolfSSLリポジトリのINSTALLファイル (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) を参照してください。

項目 15 (TLS 1.3 用の liboq を使用したビルド [実験的]) には、構成とビルドの方法に関する説明があります。


* liboqs


* wolfssl


* OQS の OpenSSL フォークにパッチを適用


ポスト量子暗号鍵と署名を使用して X.509 証明書を生成するには、パッチを適用した OQS OpenSSL フォークが必要です。手順は https://github.com/wolfSSL/osp/tree/master/oqs/README.md にあります。ポスト量子署名スキームを使用したくない場合は、OpenSSL を構築するステップをスキップできます。

### 量子安全な TLS 接続を確立する

次のようにして、サーバーとクライアントを別々のターミナルで実行します。

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level5_root_cert.pem \
  -c certs/falcon_level1_entity_cert.pem \
  -k certs/falcon_level1_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level1_root_cert.pem \
  -c certs/falcon_level5_entity_cert.pem \
  -k certs/falcon_level5_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

対称暗号化に AES-256、認証に FALCON 署名方式、キー確立に KYBER KEM とハイブリッド化された ECDHE を使用して、完全に量子安全な TLS 1.3 接続を実現しました。他のポスト量子の例についての詳細は、https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md で見つけることができます。


## wolfSSLとOQSのフォークのOpenSSLの間の命名規則マッピング



NIST PQCコンテストに応募したすべてのチームは、NISTが定義する複数のセキュリティレベルをサポートしていました。
<https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation-criteria/security-(evaluation-criteria>


そのため、各チームはバリアントを識別する方法を考え出す必要があり、各チームが独自のバリアント命名スキームを考え出しました。次の表からわかるように、この方法についてチーム間で調整はありませんでした。wolfSSL ライブラリは、バリアントのNISTレベルベースの命名規則を使用します。OQSチームは、各応募論文の命名規則に従うことを選択しました。次の表で、当社の命名規則と応募論文の命名規則をマッピングしています。


ポスト量子署名方式の命名規則:：

wolfSSLバリアント名|PQC提出バリアント名
--------------------  |  ---------------------------
FALCON_LEVEL1         |  FALCON512
FALCON_LEVEL5         |  FALCON1024
DILITHIUM_LEVEL2      |  DILITHIUM2
DILITHIUM_LEVEL3      |  DILITHIUM3
DILITHIUM_LEVEL5      |  DILITHIUM5
SPHINCS_FAST_LEVEL1   |  SPHINCS+-SHAKE256-128f-simple
SPHINCS_FAST_LEVEL3   |  SPHINCS+-SHAKE256-192f-simple
SPHINCS_FAST_LEVEL5   |  SPHINCS+-SHAKE256-256f-simple
SPHINCS_SMALL_LEVEL1  |  SPHINCS+-SHAKE256-128s-simple
SPHINCS_SMALL_LEVEL3  |  SPHINCS+-SHAKE256-192s-simple
SPHINCS_SMALL_LEVEL5  |  SPHINCS+-SHAKE256-256s-simple



ポスト量子KEM命名規則：

wolfSSLバリアント名|PQC提出バリアント名
--------------------  |  ---------------------------
KYBER_LEVEL1          |  KYBER512
KYBER_LEVEL3          |  KYBER768
KYBER_LEVEL5          |  KYBER1024


ポスト量子ハイブリッド KEM 命名規則：

wolfSSLバリアント名|NIST ECC曲線とPQC提出バリアント名
--------------------  |  ----------------------------------------------
P256_KYBER_LEVEL1     |  ECDSA P-256 and KYBER512
P384_KYBER_LEVEL3     |  ECDSA P-384 and KYBER768
P521_KYBER_LEVEL5     |  ECDSA P-521 and KYBER1024




## コードポイントとOID



当社がサポートする耐量子署名アルゴリズムとKEMは、OQSプロジェクトのOpenSSLフォークでもサポートされています。命名規則は当社のものとは異なりますが、同じ数値OIDとコードポイントを使用し、暗号化アーティファクトが同じライブラリ (liboqs) によって生成および処理されるという点で、完全な相互運用性があります。コードポイントは、TLS 1.3のsigalgsおよびサポートされるグループ拡張で使用されます。OIDは、公開鍵、秘密鍵、署名の識別子として証明書と秘密鍵で使用されます。


TLS 1.3のための量子コードポイント

wolfSSLバリアント名|コードポイント
--------------------  |  ----------
FALCON_LEVEL1         |  65035
FALCON_LEVEL5         |  65038
DILITHIUM_LEVEL2      |  65184
DILITHIUM_LEVEL3      |  65187
DILITHIUM_LEVEL5      |  65189
KYBER_LEVEL1          |  570
KYBER_LEVEL3          |  572
KYBER_LEVEL5          |  573
P256_KYBER_LEVEL1     |  12090
P384_KYBER_LEVEL3     |  12092
P521_KYBER_LEVEL5     |  12093


証明書の Post-Quantum OID：

wolfSSLバリアント名|oid
--------------------  |  ---
FALCON_LEVEL1         |  1.3.9999.3.1
FALCON_LEVEL5         |  1.3.9999.3.4
DILITHIUM_LEVEL2      |  1.3.6.1.4.1.2.267.7.4.4
DILITHIUM_LEVEL3      |  1.3.6.1.4.1.2.267.7.6.5
DILITHIUM_LEVEL5      |  1.3.6.1.4.1.2.267.7.8.7
SPHINCS_FAST_LEVEL1   |  1.3.9999.6.7.4
SPHINCS_FAST_LEVEL3   |  1.3.9999.6.8.3
SPHINCS_FAST_LEVEL5   |  1.3.9999.6.9.3
SPHINCS_SMALL_LEVEL1  |  1.3.9999.6.7.10
SPHINCS_SMALL_LEVEL3  |  1.3.9999.6.8.7
SPHINCS_SMALL_LEVEL5  |  1.3.9999.6.9.7


## 暗号化アーティファクトサイズ



以下に示すサイズの単位はバイトです。


量子署名方式のアーティファクトサイズ：

wolfSSLバリアント名|公開鍵サイズ|秘密鍵サイズ|最大署名サイズ
-------------------- | --------------- | ---------------- | ----------------------
FALCON_LEVEL1        | 897             | 1281             | 690
FALCON_LEVEL5        | 1793            | 2305             | 1330
DILITHIUM_LEVEL2     | 1312            | 2528             | 2420
DILITHIUM_LEVEL3     | 1952            | 4000             | 3293
DILITHIUM_LEVEL5     | 2592            | 4864             | 4595
SPHINCS_FAST_LEVEL1  | 32              | 64               | 17088
SPHINCS_FAST_LEVEL3  | 48              | 96               | 35664
SPHINCS_FAST_LEVEL5  | 64              | 128              | 49856
SPHINCS_SMALL_LEVEL1 | 32              | 64               | 7856
SPHINCS_SMALL_LEVEL3 | 48              | 96               | 16224
SPHINCS_SMALL_LEVEL5 | 64              | 128              | 29792




**注**：Falconには、いくつかの署名サイズがあります。


耐量子 KEM アーティファクトのサイズ：

wolfSSLバリアント名|公開鍵サイズ|秘密鍵サイズ|暗号文サイズ|共有秘密のサイズ
-------------------- | --------------- | ---------------- | --------------- | ------------------
KYBER_LEVEL1         | 800             | 1632             | 768             | 32
KYBER_LEVEL3         | 1184            | 2400             | 1088            | 32
KYBER_LEVEL5         | 1568            | 3168             | 1568            | 32
KYBER_90S_LEVEL1     | 800             | 1632             | 768             | 32
KYBER_90S_LEVEL3     | 1184            | 2400             | 1088            | 32
KYBER_90S_LEVEL5     | 1568            | 3168             | 1568            | 32





## 統計的データ

以下の統計とベンチマークは、Ubuntu 21.10を実行している第11世代 Intel Core i7-1165G7@3-GHz(8コア) で取得しました。liboqs は、`0.7.0` の古いコードとのコンパイラの非互換性のため、メインブランチで `ba5b61a779a0db364f0e691a0a0bc8ac42e73f1b` を使用しています。特記のない限り、構成オプションは以下のとおりです。


liboqs：



```text
CFLAGS="-Os" cmake -DOQS_USE_OPENSSL=0 -DOQS_MINIMAL_BUILD="OQS_ENABLE_KEM_saber_saber;OQS_ENABLE_KEM_saber_lightsaber;OQS_ENABLE_KEM_saber_firesaber;OQS_ENABLE_KEM_kyber_1024;OQS_ENABLE_KEM_kyber_1024_90s;OQS_ENABLE_KEM_kyber_768;OQS_ENABLE_KEM_kyber_768_90s;OQS_ENABLE_KEM_kyber_512;OQS_ENABLE_KEM_kyber_512_90s;OQS_ENABLE_KEM_ntru_hps2048509;OQS_ENABLE_KEM_ntru_hps2048677;OQS_ENABLE_KEM_ntru_hps4096821;OQS_ENABLE_KEM_ntru_hrss701;OQS_ENABLE_SIG_falcon_1024;OQS_ENABLE_SIG_falcon_512;OQS_ENABLE_SIG_dilithium_2;OQS_ENABLE_SIG_dilithium_3;OQS_ENABLE_SIG_dilithium_5;OQS_ENABLE_SIG_dilithium_2_aes;OQS_ENABLE_SIG_dilithium_3_aes;OQS_ENABLE_SIG_dilithium_5_aes" ..
```



wolfssl：



```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```



**注**：主に耐量子アルゴリズムをベンチマークしていますが、比較目的のために従来のアルゴリズムを残しています。



### ランタイムバイナリサイズ



`tls_bench` サンプルプログラムのバイナリファイルは約2.4MB、`--with-liboqs` を使用しない場合には559kBです。約1.9MBの違いがあります。



### TLS 1.3データ送信サイズ



サンプルサーバーとクライアントを実行し、送信されるすべての情報をWiresharkで記録することによって取得した値を以下に示します。これには、相互認証による TLS 1.3 ハンドシェイク、"hello wolfssl!"、"I hear you fa shizzle!" メッセージが含まれます。すべてのパケットの `tcp.len` を合計しました。

ciphersuite |認証|キー施設|合計バイト
---------------------- | -------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ECC SECP256R1         | 5455
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL1          | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL3          | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL5          | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL1      | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL3      | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL5      | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER_LEVEL1     | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER_LEVEL3     | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER_LEVEL5     | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER90S_LEVEL1  | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER90S_LEVEL3  | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER90S_LEVEL5  | 8467
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | ECC SECP256R1         | 6997
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | ECC SECP256R1         | 11248
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | KYBER_LEVEL1          | 8180
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | P256_KYBER_LEVEL1     | 8308
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | KYBER_LEVEL5          | 14007
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | P521_KYBER_LEVEL5     | 14257
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL2     | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL3     | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL5     | ECC SECP256R1         | 13477



### ヒープとスタックの使用



これらの統計は、次の構成フラグを追加して取得しました。
`--enable-trackmemory --enable-stacksize`

クライアントのサーバー認証なしのサーバー署名とクライアント検証、鍵交換用の TLS13-AES256-GCM-SHA384 暗号スイートおよび ECC SECP256R1 におけるメモリ使用量を以下に示します。



```text
Server FALCON_LEVEL1

stack used     =  48960
total Allocs   =    250
heap total     = 113548
heap peak      =  40990

Client FALCON_LEVEL1

stack used     =  29935
total Allocs   =    768
heap total     = 179427
heap peak      =  41765

Server FALCON_LEVEL5

stack used     =  89088
total Allocs   =    250
heap total     = 125232
heap peak      =  45630

Client FALCON_LEVEL5

stack used     =  29935
total Allocs   =    768
heap total     = 191365
heap peak      =  47469

Server DILITHIUM_LEVEL2

stack used = 56328
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    128153
peak    Bytes    =     50250

Client DILITHIUM_LEVEL2

stack used = 30856
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    206412
peak    Bytes    =     56299

Server DILITHIUM_LEVEL3

stack used = 86216
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    140128
peak    Bytes    =     55161

Client DILITHIUM_LEVEL3

stack used = 33928
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    220633
peak    Bytes    =     61245

Server DILITHIUM_LEVEL5

stack used = 119944
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    152046
peak    Bytes    =     59829

Client DILITHIUM_LEVEL5

stack used = 40328
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    238167
peak    Bytes    =     67049

Server RSA 2048

stack used     =  52896
total Allocs   =    253
heap total     = 121784
heap peak      =  39573

Client RSA 2048

stack used     =  54640
total Allocs   =    897
heap total     = 202472
heap peak      =  41760
```



KEMグループのメモリ使用。サーバーのクライアント認証には TLS13-AES256-GCM-SHA384 暗号スイートおよび RSA-2048 を使用し、クライアントのサーバー認証は使用しません。

KEM グループのメモリ使用量を示します。サーバーのクライアント認証には TLS13-AES256-GCM-SHA384とRSA-2048を使用し、クライアントのサーバー認証は行いません。



```text
Server KYBER_LEVEL1

stack used     = 52896
total Allocs   =   206
heap total     = 66864
heap peak      = 28474

Client KYBER_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 147235
heap peak      =  44538

Server KYBER_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67888
heap peak      =  28794

Client KYBER_LEVEL3

stack used     =  54640
total Allocs   =    879
heap total     = 149411
heap peak      =  46010

Server KYBER_LEVEL5

stack used     =  52896
total Allocs   =    206
heap total     =  69232
heap peak      =  29274

Client KYBER_LEVEL5

stack used     =  54640
total Allocs   =    879
heap total     = 151907
heap peak      =  47642

Server KYBER_90S_LEVEL1

stack used     =  52896
total Allocs   =    206
heap total     =  66864
heap peak      =  28474

Client KYBER_90S_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 147235
heap peak      =  44538

Server KYBER_90S_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67888
heap peak      =  28794

Client KYBER_90S_LEVEL3

stack used     =  54640
total Allocs   =    879
heap total     = 149411
heap peak      =  46010

Server KYBER_90S_LEVEL5

stack used     =  52896
total Allocs   =    206
heap total     =  69232
heap peak      =  29274

Client KYBER_90S_LEVEL5

stack used     =  54640
total Allocs   =    879
heap total     = 151907
heap peak      =  47642

Server P256_KYBER_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118940
heap peak      =  37652

Client P256_KYBER_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 199376
heap peak      =  48932

Server P384_KYBER_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 120108
heap peak      =  38468

Client P384_KYBER_LEVEL3

stack used     =  54640
total Allocs   =    896
heap total     = 201728
heap peak      =  50468

Client Server P521_KYBER_LEVEL5

stack used     =  52896
total Allocs   =    223
heap total     = 121614
heap peak      =  39458

Client P521_KYBER_LEVEL5

stack used     =  54640
total Allocs   =    896
heap total     = 204422
heap peak      =  52172

Client Server P256_KYBER_90S_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118940
heap peak      =  37652

Client P256_KYBER_90S_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 199376
heap peak      =  48932

Server P384_KYBER_90S_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 120108
heap peak      =  38468

Client P384_KYBER_90S_LEVEL3

stack used     =  54640
total Allocs   =    896
heap total     = 201728
heap peak      =  50468

Server P521_KYBER_90S_LEVEL5

stack used     =  52896
total Allocs   =    223
heap total     = 121614
heap peak      =  39458

Client P521_KYBER_90S_LEVEL5

stack used     =  54640
total Allocs   =    896
heap total     = 204422
heap peak      =  52172

Server ECDSA SECP256R1

stack used     =  52896
total Allocs   =    253
heap total     = 121784
heap peak      =  39573

Client ECDSA SECP256R1

stack used     =  54640
total Allocs   =    897
heap total     = 202472
heap peak      =  41760
```





### LiboqsのKEMSのベンチマーク


操作|反復|トータルタイム(S)|時間(米国)：平均|ポップ。stdev |CPUサイクル：平均|ポップ。st st
----------------- | ---------- | -------------- | --------------- | ---------- | ---------------- | ----------
Kyber512          |            |                |                 |            |                  |
keygen            |     443212 |          3.000 |           6.769 |      3.282 |            20223 |       9715
encaps            |     339601 |          3.000 |           8.834 |      4.557 |            26411 |      13574
decaps            |     479954 |          3.000 |           6.251 |      3.594 |            18672 |      10669
Kyber768          |            |                |                 |            |                  |
keygen            |     277967 |          3.000 |          10.793 |      5.490 |            32274 |      16375
encaps            |     225082 |          3.000 |          13.329 |      6.301 |            39871 |      18812
decaps            |     306782 |          3.000 |           9.779 |      5.063 |            29240 |      15097
Kyber1024         |            |                |                 |            |                  |
keygen            |     216179 |          3.000 |          13.877 |      6.734 |            41513 |      20108
encaps            |     164469 |          3.000 |          18.241 |      8.353 |            54579 |      24968
decaps            |     217755 |          3.000 |          13.777 |      6.831 |            41210 |      20396
Kyber512-90s      |            |                |                 |            |                  |
keygen            |     526948 |          3.000 |           5.693 |      2.795 |            17001 |       8235
encaps            |     380383 |          3.000 |           7.887 |      4.225 |            23570 |      12569
decaps            |     638653 |          3.000 |           4.697 |      2.896 |            14020 |       8543
Kyber768-90s      |            |                |                 |            |                  |
keygen            |     394138 |          3.000 |           7.612 |      4.117 |            22746 |      12249
encaps            |     271196 |          3.000 |          11.062 |      5.881 |            33080 |      17557
decaps            |     424172 |          3.000 |           7.073 |      4.189 |            21132 |      12457
Kyber1024-90s     |            |                |                 |            |                  |
keygen            |     278748 |          3.000 |          10.762 |      5.507 |            32182 |      16420
encaps            |     202208 |          3.000 |          14.836 |      7.486 |            44385 |      22368
decaps            |     299571 |          3.000 |          10.014 |      5.489 |            29945 |      16383




### ベンチマーク



次のベンチマークは、次の設定フラグを使用して取得しました。



```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256 -DHAVE_ECC384"
```




#### wolfCryptのベンチマーク



**注**：シングルコアで測定したものです。



```text
ECC   SECP256R1 key gen    95600 ops took 1.000 sec, avg 0.010 ms, 95555.939 ops/sec
ECDHE SECP256R1 agree      26100 ops took 1.002 sec, avg 0.038 ms, 26038.522 ops/sec
ECDSA SECP256R1 sign       63400 ops took 1.001 sec, avg 0.016 ms, 63320.787 ops/sec
ECDSA SECP256R1 verify     24000 ops took 1.000 sec, avg 0.042 ms, 23994.983 ops/sec
FALCON_level1   sign        5000 ops took 1.008 sec, avg 0.202 ms, 4961.637 ops/sec
FALCON_level1   verify     27400 ops took 1.001 sec, avg 0.037 ms, 27361.394 ops/sec
FALCON_level5   sign        2600 ops took 1.030 sec, avg 0.396 ms, 2523.187 ops/sec
FALCON_level5   verify     14400 ops took 1.002 sec, avg 0.070 ms, 14376.179 ops/sec
DILITHIUM_level2 sign      16200 ops took 1.003 sec, avg 0.062 ms, 16150.689 ops/sec
DILITHIUM_level2 verify    44500 ops took 1.000 sec, avg 0.022 ms, 44478.388 ops/sec
DILITHIUM_level3 sign      10200 ops took 1.002 sec, avg 0.098 ms, 10179.570 ops/sec
DILITHIUM_level3 verify    27100 ops took 1.003 sec, avg 0.037 ms, 27017.485 ops/sec
DILITHIUM_level5 sign       8400 ops took 1.009 sec, avg 0.120 ms, 8321.684 ops/sec
DILITHIUM_level5 verify    17000 ops took 1.004 sec, avg 0.059 ms, 16933.788 ops/sec
kyber_level1-kg           143608 ops took 1.000 sec, avg 0.007 ms, 143607.555 ops/sec
kyber_level1-ed            64800 ops took 1.001 sec, avg 0.015 ms, 64725.835 ops/sec
kyber_level3-kg            89790 ops took 1.000 sec, avg 0.011 ms, 89789.550 ops/sec
kyber_level3-ed            42200 ops took 1.000 sec, avg 0.024 ms, 42190.886 ops/sec
kyber_level5-kg            69362 ops took 1.000 sec, avg 0.014 ms, 69361.587 ops/sec
kyber_level5-ed            31700 ops took 1.003 sec, avg 0.032 ms, 31606.130 ops/sec
kyber90s_level1-kg        173655 ops took 1.000 sec, avg 0.006 ms, 173654.131 ops/sec
kyber90s_level1-ed         77500 ops took 1.001 sec, avg 0.013 ms, 77424.888 ops/sec
kyber90s_level3-kg        125138 ops took 1.000 sec, avg 0.008 ms, 125138.000 ops/sec
kyber90s_level3-ed         55200 ops took 1.001 sec, avg 0.018 ms, 55153.726 ops/sec
kyber90s_level5-kg         92773 ops took 1.000 sec, avg 0.011 ms, 92772.359 ops/sec
kyber90s_level5-ed         39300 ops took 1.000 sec, avg 0.025 ms, 39283.188 ops/sec
```




#### wolfSSLのベンチマーク



**注**：2コアで測定したものです。



```text
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
    Total       : 209715200 bytes
    Num Conns   :       801
    Rx Total    :   238.549 ms
    Tx Total    :    80.893 ms
    Rx          :   419.200 MB/s
    Tx          :  1236.204 MB/s
    Connect     :   552.092 ms
    Connect Avg :     0.689 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
    Total       : 209715200 bytes
    Num Conns   :       801
    Rx Total    :   264.171 ms
    Tx Total    :    77.399 ms
    Rx          :   378.542 MB/s
    Tx          :  1292.002 MB/s
    Connect     :   550.630 ms
    Connect Avg :     0.687 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
    Total       : 164626432 bytes
    Num Conns   :       629
    Rx Total    :   207.183 ms
    Tx Total    :    68.783 ms
    Rx          :   378.892 MB/s
    Tx          :  1141.270 MB/s
    Connect     :   508.584 ms
    Connect Avg :     0.809 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
    Total       : 164626432 bytes
    Num Conns   :       629
    Rx Total    :   228.902 ms
    Tx Total    :    65.852 ms
    Rx          :   342.942 MB/s
    Tx          :  1192.073 MB/s
    Connect     :   506.299 ms
    Connect Avg :     0.805 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group FFDHE_2048:
    Total       : 125829120 bytes
    Num Conns   :       481
    Rx Total    :   158.742 ms
    Tx Total    :    53.102 ms
    Rx          :   377.971 MB/s
    Tx          :  1129.896 MB/s
    Connect     :   579.937 ms
    Connect Avg :     1.206 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group FFDHE_2048:
    Total       : 125829120 bytes
    Num Conns   :       481
    Rx Total    :   175.313 ms
    Tx Total    :    50.565 ms
    Rx          :   342.245 MB/s
    Tx          :  1186.597 MB/s
    Connect     :   582.023 ms
    Connect Avg :     1.210 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
    Total       : 225968128 bytes
    Num Conns   :       863
    Rx Total    :   258.872 ms
    Tx Total    :    87.586 ms
    Rx          :   416.229 MB/s
    Tx          :  1230.220 MB/s
    Connect     :   580.184 ms
    Connect Avg :     0.672 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
    Total       : 225968128 bytes
    Num Conns   :       863
    Rx Total    :   285.086 ms
    Tx Total    :    84.362 ms
    Rx          :   377.956 MB/s
    Tx          :  1277.233 MB/s
    Connect     :   574.039 ms
    Connect Avg :     0.665 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
    Total       : 214171648 bytes
    Num Conns   :       818
    Rx Total    :   241.450 ms
    Tx Total    :    80.798 ms
    Rx          :   422.965 MB/s
    Tx          :  1263.960 MB/s
    Connect     :   603.945 ms
    Connect Avg :     0.738 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
    Total       : 214171648 bytes
    Num Conns   :       818
    Rx Total    :   263.357 ms
    Tx Total    :    81.142 ms
    Rx          :   387.781 MB/s
    Tx          :  1258.593 MB/s
    Connect     :   596.085 ms
    Connect Avg :     0.729 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
    Total       : 206307328 bytes
    Num Conns   :       788
    Rx Total    :   249.636 ms
    Tx Total    :    84.465 ms
    Rx          :   394.073 MB/s
    Tx          :  1164.683 MB/s
    Connect     :   589.028 ms
    Connect Avg :     0.747 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
    Total       : 206307328 bytes
    Num Conns   :       788
    Rx Total    :   276.059 ms
    Tx Total    :    81.856 ms
    Rx          :   356.355 MB/s
    Tx          :  1201.798 MB/s
    Connect     :   580.463 ms
    Connect Avg :     0.737 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
    Total       : 226754560 bytes
    Num Conns   :       866
    Rx Total    :   249.504 ms
    Tx Total    :    86.285 ms
    Rx          :   433.360 MB/s
    Tx          :  1253.120 MB/s
    Connect     :   590.655 ms
    Connect Avg :     0.682 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
    Total       : 226754560 bytes
    Num Conns   :       866
    Rx Total    :   274.258 ms
    Tx Total    :    83.674 ms
    Rx          :   394.246 MB/s
    Tx          :  1292.214 MB/s
    Connect     :   585.395 ms
    Connect Avg :     0.676 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   253.840 ms
    Tx Total    :    86.227 ms
    Rx          :   391.979 MB/s
    Tx          :  1153.925 MB/s
    Connect     :   584.268 ms
    Connect Avg :     0.733 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   279.104 ms
    Tx Total    :    83.607 ms
    Rx          :   356.499 MB/s
    Tx          :  1190.096 MB/s
    Connect     :   580.950 ms
    Connect Avg :     0.729 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
    Total       : 205783040 bytes
    Num Conns   :       786
    Rx Total    :   255.324 ms
    Tx Total    :    85.233 ms
    Rx          :   384.316 MB/s
    Tx          :  1151.260 MB/s
    Connect     :   583.899 ms
    Connect Avg :     0.743 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
    Total       : 205783040 bytes
    Num Conns   :       786
    Rx Total    :   281.997 ms
    Tx Total    :    82.461 ms
    Rx          :   347.964 MB/s
    Tx          :  1189.958 MB/s
    Connect     :   579.312 ms
    Connect Avg :     0.737 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
    Total       : 182190080 bytes
    Num Conns   :       696
    Rx Total    :   219.789 ms
    Tx Total    :    75.536 ms
    Rx          :   395.266 MB/s
    Tx          :  1150.114 MB/s
    Connect     :   641.859 ms
    Connect Avg :     0.922 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
    Total       : 182190080 bytes
    Num Conns   :       696
    Rx Total    :   241.393 ms
    Tx Total    :    72.367 ms
    Rx          :   359.890 MB/s
    Tx          :  1200.483 MB/s
    Connect     :   581.373 ms
    Connect Avg :     0.835 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
    Total       : 133431296 bytes
    Num Conns   :       510
    Rx Total    :   152.666 ms
    Tx Total    :    53.693 ms
    Rx          :   416.760 MB/s
    Tx          :  1184.982 MB/s
    Connect     :   743.577 ms
    Connect Avg :     1.458 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
    Total       : 133431296 bytes
    Num Conns   :       510
    Rx Total    :   169.131 ms
    Tx Total    :    50.632 ms
    Rx          :   376.188 MB/s
    Tx          :  1256.605 MB/s
    Connect     :   611.105 ms
    Connect Avg :     1.198 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
    Total       : 191102976 bytes
    Num Conns   :       730
    Rx Total    :   211.835 ms
    Tx Total    :    72.819 ms
    Rx          :   430.170 MB/s
    Tx          :  1251.386 MB/s
    Connect     :   651.010 ms
    Connect Avg :     0.892 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
    Total       : 191102976 bytes
    Num Conns   :       730
    Rx Total    :   233.104 ms
    Tx Total    :    70.994 ms
    Rx          :   390.919 MB/s
    Tx          :  1283.561 MB/s
    Connect     :   589.063 ms
    Connect Avg :     0.807 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
    Total       : 136052736 bytes
    Num Conns   :       520
    Rx Total    :   168.780 ms
    Tx Total    :    57.603 ms
    Rx          :   384.376 MB/s
    Tx          :  1126.236 MB/s
    Connect     :   723.880 ms
    Connect Avg :     1.392 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
    Total       : 136052736 bytes
    Num Conns   :       520
    Rx Total    :   189.078 ms
    Tx Total    :    52.841 ms
    Rx          :   343.112 MB/s
    Tx          :  1227.747 MB/s
    Connect     :   594.282 ms
    Connect Avg :     1.143 ms
```




次のベンチマークは、次の設定フラグを使用して取得しました。



```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math-all \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC521"
```



**注**：2コアで測定したものです。


```text
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
    Total       :  22806528 bytes
    Num Conns   :        88
    Rx Total    :    29.526 ms
    Tx Total    :     9.423 ms
    Rx          :   368.325 MB/s
    Tx          :  1154.060 MB/s
    Connect     :   447.201 ms
    Connect Avg :     5.082 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
    Total       :  22806528 bytes
    Num Conns   :        88
    Rx Total    :    32.363 ms
    Tx Total    :     9.206 ms
    Rx          :   336.028 MB/s
    Tx          :  1181.257 MB/s
    Connect     :   442.915 ms
    Connect Avg :     5.033 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
    Total       :  10747904 bytes
    Num Conns   :        42
    Rx Total    :     8.199 ms
    Tx Total    :    30.942 ms
    Rx          :   625.096 MB/s
    Tx          :   165.633 MB/s
    Connect     :   958.292 ms
    Connect Avg :    22.816 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
    Total       :  10747904 bytes
    Num Conns   :        42
    Rx Total    :     9.919 ms
    Tx Total    :     3.685 ms
    Rx          :   516.689 MB/s
    Tx          :  1390.684 MB/s
    Connect     :   679.437 ms
    Connect Avg :    16.177 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    19.132 ms
    Tx Total    :     6.887 ms
    Rx          :   326.680 MB/s
    Tx          :   907.481 MB/s
    Connect     :   976.107 ms
    Connect Avg :    19.139 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    23.578 ms
    Tx Total    :     5.039 ms
    Rx          :   265.078 MB/s
    Tx          :  1240.273 MB/s
    Connect     :   673.107 ms
    Connect Avg :    13.198 ms
```



## ドキュメンテーション



技術文書や既知の回答テストなどのその他のリソースは、NIST PQC Webサイトにあります。


<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>


アルゴリズム固有のベンチマーク情報については、OQSプロジェクトのWebサイトに掲載されています。

<https://openquantumsafe.org/benchmarking/>

## ポスト量子ステートフルハッシュベース署名

このセクションでは、最近wolfSSLがサポートを開始したLMS/HSSなどのポスト量子ステートフルハッシュベース署名(HBS)スキームについて記します。

### 動機づけ

ステートフルHBSスキームは、さまざまな理由から関心が高まっています。
ステートフルHBSスキームの主な目的は、量子セキュリティの強化です。前述したように、ショアのアルゴリズムにより、量子コンピューターは大きな整数を効率的に因数分解し、離散対数を計算することができます。これによって、RSAやECCなどの公開鍵暗号スキームを完全に破ることができます。

対照的に、ステートフルHBSスキームは、その基礎となるハッシュ関数とマークルツリー(通常SHA256で実装)のセキュリティに基づいており、暗号に関連する量子コンピューターの登場によって破られることは予想されていません。これらの理由から、ステートフルHBSスキームは NIST SP 800-208 および NSA の CNSA 2.0 スイートで推奨されています。詳細については、次の2つのリンクをご参照ください。

- <https://csrc.nist.gov/publications/detail/sp/800-208/final>
- <https://media.defense.gov/2022/Sep/07/2003071834/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF>

さらにCNSA 2.0のタイムラインでは、2030年までにポスト量子ステートフルHBSスキームのみを使用する必要があり、採用は 「直ちに」 開始する必要があると規定されています。LMS の採用は、CNSA 2.0スイートのタイムラインで最も早い要件です。

ただし、ステートフルHBSスキームの性質上、その使用と状態の追跡には細心の注意を払う必要があります。ステートフルHBSシステムでは、秘密鍵は実際にはワンタイム署名(OTS)キーの有限セットであり、再利用されることはありません。同じOTSキーを使用して2つの異なるメッセージを署名すると、攻撃者が署名を偽造できる可能性があり、スキーム全体のセキュリティが崩壊します。したがって、ステートフルHBSスキームは、パブリックインターネットなどの一般的な使用には適していません。

LMS/HSSなどのステートフルHBSスキームは、特に長い運用寿命が期待され、暗号に関連する量子コンピューターに対して耐性が求められる組み込みシステムや制約付きシステムでのオフラインファームウェア認証と署名検証に特に役立ちます。


### LMS/HSS署名

wolfSSLは、wolfCrypt組み込み暗号エンジンにLMS/HSSハッシュベースの署名スキームのサポートを追加しています。これは、以前のlibOQS統合と同様に、hash-sigsLMS/HSSライブラリ(<https://github.com/cisco/hash-sigs>)との実験的な統合によって実現されます。

Leighton-Micali Signatures(LMS)とそのマルチツリーのバリアントであるHierarchical Signature System(HSS)は、ポスト量子、ステートフルハッシュベース署名スキームです。公開鍵と秘密鍵が小さく、署名と検証が速いことで知られています。署名のサイズは大きくなりますが、Winternitzパラメーターを介して調整できます。詳細については、RFC8554の次の2つのリンクを参照してください：

- LMS: <https://datatracker.ietf.org/doc/html/rfc8554>
- HSS: <https://datatracker.ietf.org/doc/html/rfc8554#section-6>

前述したように、LMS/HSS署名システムは有限数のワンタイム署名(OTS)鍵で構成されているため、有限数の署名しか安全に生成できません。ただし、署名の数と署名のサイズは、次に説明する一連の定義済みパラメーターを介して調整できます。

#### サポートしているパラメータ

LMS/HSS署名は3つのパラメータによって定義されます。
- levels: マークルツリーのレベル数
- height: 個々のマークルツリーの高さ
- Winternitz: ウィンターニッツチェーンで使用されるハッシュのビット数。 署名サイズの時空間トレードオフとして使用されます。

wolfSSLは、RFC8554で定義されているすべてのLMS/HSSパラメータをサポートします：

- levels = {1..8}
- height = {5, 10, 15, 20, 25}
- Winternitz = {1, 2, 4, 8}

利用可能な署名の数:
- N = 2 ** (levels * height)

便宜上、一部のパラメータセットは列挙型 `wc_LmsParm` で事前定義されています。 その値を以下の表に示します：

パラメータセット |  意味
--------------------  |  ---------------------------
WC_LMS_PARM_NONE      | 設定されていません。デフォルトを使用します (WC_LMS_PARM_L1_H15_W2)
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

ここで設定したパラメータに対する署名のサイズと署名の数を表示します：


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

表からわかるように、署名のサイズは主にレベルとWinternitz値、および比較的影響は小さいですが高さによって決まります。

- レベル値を大きくすると、署名サイズは大幅に増加します。
- 高さの値を大きくすると、署名のサイズは増加します。
- Winternitz値を大きくすると、署名のサイズは小さくなりますが、鍵の生成と署名/検証にかかる時間が長くなります。

鍵の生成時間は、第1レベルのツリーの高さによって大きく決まります。使用可能な署名の数が同じであっても、レベル3、高さ5のツリーは、初期鍵生成時にレベル1、高さ15のツリーよりもはるかに高速です

#### LMS/HSSビルド方法

wolfSSLリポジトリのINSTALLファイル (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) を参照してください。 項目17(LMS/HSSサポートのためのhash-sigsライブラリを使用した構築 [実験]) には、wolfSSLとhash-sigs LMS/HSSライブラリを設定および構築する方法についての手順が記載されています。

#### ベンチマークデータ
次のベンチマークデータは、Fedora 38(`6.2.9-300.fc38.x86_64`)上の8コアIntel i7-8700 CPU@3.20GHzで取得されました。マルチスレッドの例では4スレッドと4コアが使用されましたが、シングルスレッドの例では1コアのみが使用されました。

INSTALLファイルの項目17で説明したように、hash-sigsライブラリは2つの静的ライブラリを提供します。
- `hss_lib.a`: シングルスレッド
- `hss_lib_thread.a`: マルチスレッド

マルチスレッドバージョンではワーカースレッドが生成され、鍵生成などのCPUを集中的に使用するタスクが高速化されます。これにより、主にすべてのパラメータ値に対する鍵の生成と署名が高速化され、より大きなレベル値の検証も多少高速化されます。

なお、以下のベンチマークは次の構成オプションを有効化して取得しました。


```text
  ./configure \
    --enable-static \
    --disable-shared \
    --enable-lms=yes \
    --with-liblms=<path to hash sigs install>
```

**マルチスレッドベンチマーク**

以下は、集中的なタスクを並列化するために4スレッドを使用し、4コアを使用したマルチスレッド `hss_lib_thread.a` と共にビルドして取得したベンチマークデータです。


```text
./wolfcrypt/benchmark/benchmark -lms_hss
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
LMS/HSS L2_H10_W2  9300     sign      1500 ops took 1.075 sec, avg 0.717 ms, 1394.969 ops/sec
LMS/HSS L2_H10_W2  9300   verify      5200 ops took 1.002 sec, avg 0.193 ms, 5189.238 ops/sec
LMS/HSS L2_H10_W4  5076     sign       800 ops took 1.012 sec, avg 1.265 ms, 790.776 ops/sec
LMS/HSS L2_H10_W4  5076   verify      2500 ops took 1.003 sec, avg 0.401 ms, 2493.584 ops/sec
LMS/HSS L3_H5_W4  7160     sign      1500 ops took 1.051 sec, avg 0.701 ms, 1427.485 ops/sec
LMS/HSS L3_H5_W4  7160   verify      2700 ops took 1.024 sec, avg 0.379 ms, 2636.899 ops/sec
LMS/HSS L3_H5_W8  3992     sign       300 ops took 1.363 sec, avg 4.545 ms, 220.030 ops/sec
LMS/HSS L3_H5_W8  3992   verify       400 ops took 1.066 sec, avg 2.664 ms, 375.335 ops/sec
LMS/HSS L3_H10_W4  7640     sign       900 ops took 1.090 sec, avg 1.211 ms, 825.985 ops/sec
LMS/HSS L3_H10_W4  7640   verify      2400 ops took 1.037 sec, avg 0.432 ms, 2314.464 ops/sec
LMS/HSS L4_H5_W8  5340     sign       300 ops took 1.310 sec, avg 4.367 ms, 228.965 ops/sec
LMS/HSS L4_H5_W8  5340   verify       400 ops took 1.221 sec, avg 3.053 ms, 327.599 ops/sec
Benchmark complete
```

**シングルスレッドベンチマーク**

以下は、シングルスレッドの`hss_lib.a`と共にビルドして取得したベンチマークデータです
これは単一のコアのみを使用します。


```text
$ ./wolfcrypt/benchmark/benchmark -lms_hss
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
LMS/HSS L2_H10_W2  9300     sign       800 ops took 1.115 sec, avg 1.394 ms, 717.589 ops/sec
LMS/HSS L2_H10_W2  9300   verify      4500 ops took 1.001 sec, avg 0.223 ms, 4493.623 ops/sec
LMS/HSS L2_H10_W4  5076     sign       500 ops took 1.239 sec, avg 2.478 ms, 403.519 ops/sec
LMS/HSS L2_H10_W4  5076   verify      2100 ops took 1.006 sec, avg 0.479 ms, 2087.944 ops/sec
LMS/HSS L3_H5_W4  7160     sign       800 ops took 1.079 sec, avg 1.349 ms, 741.523 ops/sec
LMS/HSS L3_H5_W4  7160   verify      1600 ops took 1.012 sec, avg 0.632 ms, 1581.686 ops/sec
LMS/HSS L3_H5_W8  3992     sign       100 ops took 1.042 sec, avg 10.420 ms, 95.971 ops/sec
LMS/HSS L3_H5_W8  3992   verify       200 ops took 1.220 sec, avg 6.102 ms, 163.894 ops/sec
LMS/HSS L3_H10_W4  7640     sign       400 ops took 1.010 sec, avg 2.526 ms, 395.864 ops/sec
LMS/HSS L3_H10_W4  7640   verify      1500 ops took 1.052 sec, avg 0.701 ms, 1426.284 ops/sec
LMS/HSS L4_H5_W8  5340     sign       100 ops took 1.066 sec, avg 10.665 ms, 93.768 ops/sec
LMS/HSS L4_H5_W8  5340   verify       200 ops took 1.478 sec, avg 7.388 ms, 135.358 ops/sec
Benchmark complete
```


### XMSS/XMSS^MT 署名

wolfSSLは、XMSS/XMSS^MTステートフルハッシュベース署名のサポートを追加しています。LMSと同様に、これはRFC 8391 (https://www.rfc-editor.org/rfc/rfc8391.html) のxmss-reference リポジトリ (https://github.com/XMSS/xmss-reference.git) との実験的な統合によって実現されています。

xmss-referenceは、`xmss_core_fast` および `xmss_core` 実装をサポートしています。`xmss_core_fast` 実装は、トレードオフとしてより大きな秘密鍵サイズでパフォーマンスを優先するように設計されています。

当社の統合では `xmss_core_fast` を使用していますが、パッチが適用されているため、代わりに wolfCrypt SHA256実装を使用できます。

パッチは、wolfssl-examplesリポジトリの
```pq/stateful_hash_sig/0001-Patch-to-support-wolfSSL-xmss-reference-integration.patch```
で公開しています。https://github.com/wolfSSL/wolfssl-examples

全体的に、XMSS/XMSS^MTはLMS/HSSに似ています。より詳細な比較については、「LMS vs XMSS: 2 つのハッシュベース署名標準の比較」(https://eprint.iacr.org/2017/349.pdf) を参照してください。

XMSS^MTはXMSSのマルチツリー一般化であり、HSS with LMSに似ていますが、XMSS/XMSS^MTではWinternitz値が `w=16` に固定されている点が異なります。公開鍵はXMSS/XMSS^MTでは若干大きくなり(XMSS/XMSS^MTでは68 バイト、LMS/HSSでは60バイト)、署名は若干小さくなります。

#### サポートしているパラメータ

wolfSSLは、NIST SP 800-208 (https://csrc.nist.gov/pubs/sp/800/208/final) の表10および11のSHA256 XMSS/XMSS^MTパラメータセットをサポートしています。

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

上記の表で、`n` は HASH 関数のバイト数、`w` はWinternitz値、`h` はツリーシステムの合計高さ、`d` はツリーのレベルを示します。

鍵生成時間は第1レベルのツリーの高さ(または`h/d`) によって大きく左右されますが、署名の長さは主に`d` (ハイパーツリーレベルの数)とともに増加します。

LMS/HSSと同様に、使用可能な署名の数は `2**h` に比例して増加します。ここで `h` はツリー システムの合計高さです。
 
#### ベンチマークデータ

以下では、Intel x86_64およびaarch64のいくつかのXMSS/XMSS^MTパラメータセットのベンチマーク データを示します。これらのシステムでのSHA256パフォーマンスも参考として記載されています。必要なハッシュチェーンの数が多いため、XMSS/XMSS^MTのCPU 作業の大部分が計算されるためです。さらに、xmss-referenceへのパッチはwolfCryptのSHA256実装を置き換えるため、同じASMの高速化のメリットが得られます。

前述のように、XMSS統合ではxmss-referenceの`xmss_core_fast`実装を使用しています。この実装は、秘密鍵のサイズが大きいというトレードオフで、より高速なパフォーマンスを実現します。

**x86_64**

以下のx86_64ベンチマークデータは、Fedora 38 (`6.2.9-300.fc38.x86_64`) が動作するIntel i7-8700 CPU @ 3.20GHz(8コア)で取得しました。このCPUには`avx avx2`フラグがあり、`--enable-intelasm` を有効化することでハッシュ操作を高速化できます。

`--enable-intelasm` を使用する場合

```text
$./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    500 MiB took 1.009 seconds,  495.569 MiB/s Cycles per byte =   6.14
XMSS-SHA2_10_256  2500     sign       200 ops took 1.010 sec, avg 5.052 ms, 197.925 ops/sec
XMSS-SHA2_10_256  2500   verify      1600 ops took 1.011 sec, avg 0.632 ms, 1582.844 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       200 ops took 1.286 sec, avg 6.431 ms, 155.504 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       700 ops took 1.009 sec, avg 1.441 ms, 693.905 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       300 ops took 1.223 sec, avg 4.076 ms, 245.335 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       400 ops took 1.027 sec, avg 2.569 ms, 389.329 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       200 ops took 1.466 sec, avg 7.332 ms, 136.394 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       400 ops took 1.024 sec, avg 2.560 ms, 390.627 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       300 ops took 1.202 sec, avg 4.006 ms, 249.637 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       200 ops took 1.089 sec, avg 5.446 ms, 183.635 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       200 ops took 1.724 sec, avg 8.618 ms, 116.033 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       300 ops took 1.136 sec, avg 3.788 ms, 263.995 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       300 ops took 1.210 sec, avg 4.034 ms, 247.889 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       200 ops took 1.575 sec, avg 7.877 ms, 126.946 ops/sec
Benchmark complete
```

`--enable-intelasm` を使用しない場合

```text
$./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    275 MiB took 1.005 seconds,  273.549 MiB/s Cycles per byte =  11.13
XMSS-SHA2_10_256  2500     sign       200 ops took 1.356 sec, avg 6.781 ms, 147.480 ops/sec
XMSS-SHA2_10_256  2500   verify      1200 ops took 1.025 sec, avg 0.854 ms, 1170.547 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       200 ops took 1.687 sec, avg 8.436 ms, 118.546 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       600 ops took 1.187 sec, avg 1.978 ms, 505.663 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       200 ops took 1.119 sec, avg 5.593 ms, 178.785 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       300 ops took 1.086 sec, avg 3.622 ms, 276.122 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       200 ops took 1.991 sec, avg 9.954 ms, 100.460 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       300 ops took 1.043 sec, avg 3.478 ms, 287.545 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       200 ops took 1.114 sec, avg 5.572 ms, 179.454 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       200 ops took 1.495 sec, avg 7.476 ms, 133.770 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       100 ops took 1.111 sec, avg 11.114 ms, 89.975 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       200 ops took 1.070 sec, avg 5.349 ms, 186.963 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       200 ops took 1.148 sec, avg 5.739 ms, 174.247 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       100 ops took 1.080 sec, avg 10.797 ms, 92.618 ops/sec
Benchmark complete
```

**aarch64**

以下のaarch64データは、CPUフラグ`sha1 sha2 sha3 sha512`を使用してApple M1上で実行されているUbuntu(`5.15.0-71-generic`) で取得されました。`--enable-armasm` を使用してビルドすると、特に SHA ハッシュ操作が大幅に高速化されます。

`--enable-armasm`を使用する場合

```text
$ ./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                   2305 MiB took 1.001 seconds, 2303.346 MiB/s
XMSS-SHA2_10_256  2500     sign       800 ops took 1.079 sec, avg 1.349 ms, 741.447 ops/sec
XMSS-SHA2_10_256  2500   verify      6500 ops took 1.007 sec, avg 0.155 ms, 6455.445 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       700 ops took 1.155 sec, avg 1.650 ms, 606.154 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify      3100 ops took 1.021 sec, avg 0.329 ms, 3037.051 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign      1100 ops took 1.006 sec, avg 0.915 ms, 1093.191 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify      1700 ops took 1.013 sec, avg 0.596 ms, 1677.399 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       600 ops took 1.096 sec, avg 1.827 ms, 547.226 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify      1600 ops took 1.062 sec, avg 0.664 ms, 1506.946 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign      1100 ops took 1.007 sec, avg 0.916 ms, 1092.214 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       900 ops took 1.088 sec, avg 1.209 ms, 827.090 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       600 ops took 1.179 sec, avg 1.966 ms, 508.728 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify      1100 ops took 1.038 sec, avg 0.944 ms, 1059.590 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign      1100 ops took 1.015 sec, avg 0.923 ms, 1083.767 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       600 ops took 1.149 sec, avg 1.914 ms, 522.367 ops/sec
Benchmark complete
```

`--enable-armasm`を使用しない場合

```text
$ ./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    190 MiB took 1.020 seconds,  186.277 MiB/s
XMSS-SHA2_10_256  2500     sign       200 ops took 1.908 sec, avg 9.538 ms, 104.845 ops/sec
XMSS-SHA2_10_256  2500   verify       800 ops took 1.002 sec, avg 1.253 ms, 798.338 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       100 ops took 1.084 sec, avg 10.843 ms, 92.222 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       500 ops took 1.240 sec, avg 2.479 ms, 403.334 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       200 ops took 1.615 sec, avg 8.074 ms, 123.855 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       200 ops took 1.071 sec, avg 5.355 ms, 186.726 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       100 ops took 1.354 sec, avg 13.543 ms, 73.840 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       300 ops took 1.483 sec, avg 4.945 ms, 202.237 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       200 ops took 1.588 sec, avg 7.941 ms, 125.922 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       100 ops took 1.042 sec, avg 10.415 ms, 96.014 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       100 ops took 1.571 sec, avg 15.710 ms, 63.654 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       200 ops took 1.526 sec, avg 7.632 ms, 131.033 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       200 ops took 1.607 sec, avg 8.036 ms, 124.434 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       100 ops took 1.501 sec, avg 15.011 ms, 66.616 ops/sec
Benchmark complete
```
