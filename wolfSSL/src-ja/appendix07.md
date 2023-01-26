

# ポスト量子暗号の実験



wolfSSLチームは、実験的なポスト量子暗号アルゴリズムをwolfSSLライブラリに統合しました。これは、Open Quantum SafeチームのLiboqsと統合することで行われました。それらの詳細については、<https://openquantumsafe.org> を参照してください。


この付録は、TLS 1.3のコンテキストで、ポスト量子暗号について学び、実験したい人を対象としています。そポスト量子アルゴリズムが重要である理由、量子の脅威に対応して私たちが行ったこと、これらの新しいアルゴリズムの実験を開始する方法について説明します。


**NOTE**：liboq が提供するポスト量子アルゴリズムは標準化されておらず、実験的なものです。それらが生産環境では使用しないことを強くお勧めします。すべての OID、コードポイント、アーティファクト形式は一時的なものであり、将来変更される予定です。下位互換性がないことに注意してください。


**注**：wolfsslが`--with-liboqs`フラグで構成されていない場合は、これらの実験的アルゴリズムは有効になっていません。



## ポスト量子暗号をわかりやすく紹介




### なぜポスト量子暗号？



最近、量子コンピューターの開発にはますます多くのリソースが専念しています。そのため、クラウド量子コンピューティングリソースの商業化がすでに始まっています。現在の最新の状態は暗号化に関連する領域にまだありませんが、「まずデータを収集、蓄積し、後に時間をかけて解読を進めていく」などの一部の脅威モデルは、暗号化に関連する量子コンピューターの出現よりも早く準備が必要であることを意味します。


NISTが、量子コンピューターに対して脆弱になる公開キー暗号アルゴリズムを置き換えるように設計された新しいクラスのアルゴリズムの標準化の道をリードしていることが広く認められています。このパッセージの執筆時点で、NISTはPQC標準化プロセスでの第3ラウンドの完了に近づいており、2022年初頭に標準化されるアルゴリズムを発表します。その後、プロセスにはもう1年かかると予測されています。プロトコルとデータ形式を説明する標準ドキュメントを作成します。その後、FIPSのような規制が開発を開始する可能性があります。



### 私たちは自分自身をどのように守るのですか？



高レベルの観点からは、TLS 1.3接続ごとに、認証と機密性は各接続を保護する2つの主な目標です。認証はECDSAなどのシグネチャスキームを介して維持されます。機密性は、ECDHEなどの重要な確立アルゴリズムによって維持され、その後、対称暗号化アルゴリズムで確立されたキーを使用して通信ストリームを暗号化する。したがって、TLS 1.3プロトコルのセキュリティを3種類の暗号化アルゴリズムに分解することができます。



* 認証アルゴリズム


* 重要な確立アルゴリズム


* 対称暗号アルゴリズム



従来の暗号に対する量子コンピューターの脅威には、2 つの形態があります。Grover のアルゴリズムは最新の対称暗号アルゴリズムのセキュリティを半分に減らしますが、Shor のアルゴリズムは最新の認証および鍵確立アルゴリズムのセキュリティを完全に破ります。その結果、対称的な暗号アルゴリズムの強度を2倍にし、従来の認証と主要な確立アルゴリズムをポスト量子暗号アルゴリズムに置き換えることにより、通信を保護し続けることができます。TLS 1.3のハンドシェーク中に、Ciphersuiteは、接続期間中に使用される対称暗号を指定することに注意してください。AES-128は一般に十分であると認められているため、AES_256_GCM_SHA384 Ciphersuiteを使用して強度を2倍にすることができます。鍵の確立と認証には、ポスト量子 KEM (Key Encapsulation Mechanisms) と署名スキームがあります。


これらは、従来のアルゴリズムとは異なる種類の数学を使用します。それらは、量子コンピューターへの耐性のために特別に設計されています。統合することを選択した認証アルゴリズムとKEMはすべて格子ベースのアルゴリズムです。


* ダイリチウム署名スキーム


* ファルコン署名スキーム


* KYBER KEM


注: SABRE KEM と NTRU KEM は非推奨となり、標準化に移行しなかったため削除されました。


注: KYBER KEM 90s の亜種は非推奨となり、NIST が標準化を検討していないため削除されました。


注: ダイリチウム署名方式の AES バリアントは非推奨となり、NIST が標準化を検討していないため削除されました。



格子ベースの暗号化の説明はこの文書の範囲外になりますが、これらのアルゴリズムに関する情報は<https：//csrc.nist.gov/projects/post-quantum-cryptography/round  - でのNISTの提出にあります。3-提出>。


残念ながら、ショックを受けるかもしれませんが、これらのアルゴリズムが量子コンピューターからの攻撃に抵抗できるかどうかは実際にはわかっていません。実際、これらのアルゴリズムが従来のコンピューターに対して安全であることさえわかっていません。その可能性はますます低くなりますが、誰かが格子ベースの暗号を破る可能性があります。しかし、セキュリティの専門家があなたに言うように、これは暗号化が常にどのように機能してきた形です。アルゴリズムは、使い始めは良いものですが、弱点や脆弱性が発見され、技術が向上します。ポスト量子アルゴリズムは、比較的新しく、コミュニティからもう少し注意を払う必要があるという点で、やや問題があります。


解決策の 1 つは、これらの新しいアルゴリズムを完全に信用しないことです。とりあえず、私たちは実際に信頼する従来のアルゴリズムで、質量のKEMをハイブリダイズすることで賭けをヘッジできます。NIST標準化された曲線を備えたECCは、FIPSコンプライアンスが優先事項であるため、それらを使用し続ける必要があるため、優れた候補のように見えます。このため、ポストカントゥムケムを統合しただけでなく、NIST承認の曲線を介してECDSAでハイブリダイズしました。以下のハイブリッドグループのリストをご覧ください。



## ｗolfSSLのLiboqs統合を始めましょう



次の手順では、クリーンな Linux 開発環境から開始し、段階的に安全な TLS 1.3 接続を実行できるようにします。

### ビルド手順

wolfSSL リポジトリの INSTALL ファイル (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) を参照してください。

項目 15 (TLS 1.3 用の liboq を使用したビルド [実験的]) には、構成とビルドの方法に関する説明があります。


* liboqs


* wolfssl


* OQS の OpenSSL フォークにパッチを適用


ポスト量子暗号鍵と署名を使用して X.509 証明書を生成するには、パッチを適用した OQS OpenSSL フォークが必要です。手順は https://github.com/wolfSSL/osp/tree/master/oqs/README.md にあります。ポスト量子署名スキームを使用したくない場合は、OpenSSL を構築するステップをスキップできます。

### 量子安全な TLS 接続を確立する

次のようにサーバーとクライアントを別々のターミナルで実行できます。

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


## WolfsSLとOQSのフォークのOpenSSLの間の命名規則マッピング



NIST PQCコンペティションに提出したすべてのチームは、ここでNISTで定義されているように、複数のレベルのセキュリティをサポートしました：<https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation - 基準/セキュリティ - (評価 - 基準)>


そのように、彼らは彼らの亜種を識別する方法を思いつく必要があり、各チームは彼ら自身のバリアント命名スキームを思いつく必要がありました。次の表を見ることができるように、これを行う方法についてのチーム間に調整はありませんでした。wolfSSLライブラリは、バリアントのNISTレベルベースの命名規則を使用しています。OQSチームは、各提出書の命名規則に従うことを選択しました。次の表を参照してください。


ポスト量子署名方式の命名規則:：

wolfsslバリアント名|PQC提出バリアント名
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



ポスト量子 KEM 命名規則：

wolfsslバリアント名|PQC提出バリアント名
--------------------  |  ---------------------------
KYBER_LEVEL1          |  KYBER512
KYBER_LEVEL3          |  KYBER768
KYBER_LEVEL5          |  KYBER1024


ポスト量子ハイブリッド KEM 命名規則：

wolfsslバリアント名|NIST ECC曲線とPQC提出バリアント名
--------------------  |  ----------------------------------------------
P256_KYBER_LEVEL1     |  ECDSA P-256 and KYBER512
P384_KYBER_LEVEL3     |  ECDSA P-384 and KYBER768
P521_KYBER_LEVEL5     |  ECDSA P-521 and KYBER1024




## コードポイントとOID



私たちがサポートするポストカントゥム署名アルゴリズムとKEMは、OQSプロジェクトのOpenSSLフォークによってもサポートされています。彼らの命名規則は私たちのものとは異なりますが、同じ数値OIDとコードポイントを使用し、暗号化アーティファクトが同じライブラリによって生成および処理されるという点で完全な相互運用性があります。すなわち、liboqs。コードポイントは、TLS 1.3のシガルグおよびサポートされているグループ拡張機能で使用されます。OIDは、公開キー、プライベートキー、署名の識別子として証明書およびプライベートキーで使用されます。


TLS 1.3のための量子コードポイント

wolfsslバリアント名|コードポイント
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

wolfsslバリアント名|oid
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



すべてのサイズはバイトです。


量子署名方式のアーティファクトサイズ：

wolfsslバリアント名|公開キーのサイズ|秘密キーサイズ|最大署名サイズ
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




**注**：Falconには、さまざまな署名サイズがあります。


ポスト量子 KEM アーティファクトのサイズ：

wolfsslバリアント名|公開キーのサイズ|秘密キーサイズ|暗号文サイズ|共有秘密のサイズ
-------------------- | --------------- | ---------------- | --------------- | ------------------
KYBER_LEVEL1         | 800             | 1632             | 768             | 32
KYBER_LEVEL3         | 1184            | 2400             | 1088            | 32
KYBER_LEVEL5         | 1568            | 3168             | 1568            | 32
KYBER_90S_LEVEL1     | 800             | 1632             | 768             | 32
KYBER_90S_LEVEL3     | 1184            | 2400             | 1088            | 32
KYBER_90S_LEVEL5     | 1568            | 3168             | 1568            | 32





## 統計的データ


次の統計データとベンチマークは、Ubuntu 21.10 を実行する 8 コアの第 11 世代 Intel Core i7-1165G7@3-GHz で取得されました。Liboqsは、`0.7.0`の古いコードとのコンパイラの非互換性により、メインブランチの`ba5b61a779a0db364f0e691a0a0bc8ac42e73f1b`にアップグレードされました。次の構成が使用されました(特に明記しない限り)。


liboqs：



```text
CFLAGS="-Os" cmake -DOQS_USE_OPENSSL=0 -DOQS_MINIMAL_BUILD="OQS_ENABLE_KEM_saber_saber;OQS_ENABLE_KEM_saber_lightsaber;OQS_ENABLE_KEM_saber_firesaber;OQS_ENABLE_KEM_kyber_1024;OQS_ENABLE_KEM_kyber_1024_90s;OQS_ENABLE_KEM_kyber_768;OQS_ENABLE_KEM_kyber_768_90s;OQS_ENABLE_KEM_kyber_512;OQS_ENABLE_KEM_kyber_512_90s;OQS_ENABLE_KEM_ntru_hps2048509;OQS_ENABLE_KEM_ntru_hps2048677;OQS_ENABLE_KEM_ntru_hps4096821;OQS_ENABLE_KEM_ntru_hrss701;OQS_ENABLE_SIG_falcon_1024;OQS_ENABLE_SIG_falcon_512" ..
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



**注**：主にポストカントゥムアルゴリズムをベンチマークしていますが、比較目的のために従来のアルゴリズムを残しています。



### ランタイムバイナリサイズ



`tls_bench`のアプリケーションバイナリファイルの例は、ビルドされてから削除された後(約2.4m)2479992バイトです。`--with-liboqs`がなければ、ビルドされてから571832バイト(約559k)があります。これは、1908160バイト(約1.9MB)の違いです。



### TLS 1.3データ送信サイズ



次の結果は、サンプルサーバーとクライアントを実行し、Wiresharkを介して送信されているすべての情報を記録することによって行われました。これには、相互認証、「こんにちはwolfSSL！」とTLS 1.3ハンドシェイクが含まれます。そして、「私はあなたのFa Shizzle」を聞きます！メッセージすべてのパケットの`tcp.len`を合計しました。

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



これらの統計は、次の構成フラグを追加することで取得されました：`--enable-trackmemory --enable-stacksize`。


サーバーサインとクライアントのメモリの使用クライアントのサーバー認証なしで、TLS13-AES256-GCM-SHA384 CipherSuiteおよびECC SECP256R1のキー交換のためのECC SECP256R1。



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



次のベンチマークは、次の設定フラグを使用して得られました。



```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256 -DHAVE_ECC384"
```




#### WolfCryptのベンチマーク



**注**：1つのコアのみが使用されます。



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




#### Wolfsslのベンチマーク



**注**：これらのベンチマークに使用されているコアのみが2つだけです。



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




次のベンチマークは、次の設定フラグを使用して得られました。



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



**注**：これらのベンチマークに使用されているコアのみが2つだけです。


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


<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>。


アルゴリズム固有のベンチマーク情報については、OQS プロジェクトの Web サイトにベンチマーク情報があります。

<https://openquantumsafe.org/benchmarking/>
