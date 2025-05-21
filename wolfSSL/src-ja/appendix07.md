# ポスト量子暗号の実験

wolfSSLチームは以前、実験的なポスト量子暗号アルゴリズムをwolfSSLライブラリに統合しました。
これは、Open Quantum Safeチームのliboqsと統合することで実現されました。
現在、wolfCryptはLMS、XMSS、ML-DSA、ML-KEMを実装しています。
コードサイズの削減と保守の容易さのため、wolfSSLチームはliboqsとの統合を削除しました。

この付録は、(D)TLS 1.3のコンテキストでポスト量子暗号について学び、実験したい人を対象としています。
ポスト量子アルゴリズムが重要である理由、量子の脅威に対応して私たちが行ったこと、これらの新しいアルゴリズムの実験を開始する方法について説明します。

**注意**: 一部のポスト量子アルゴリズムはまだ完全に標準化されていません。一部のOIDとコードポイントは一時的なものであり、将来変更される可能性があります。完全に標準化されるまでは、下位互換性を期待すべきではありません。

## ポスト量子暗号をわかりやすく紹介

### なぜポスト量子暗号？

今日では、量子コンピューターの開発にますます多くのリソースが割かれるようになりました。
そのため、クラウド量子コンピューティングリソースの商業化がすでに始まっています。
現時点では未だ実用レベルの暗号が解かれた報告はありません。
しかし、「あらかじめデータを収集、蓄積し、後に時間をかけて解読を進めていく」といった脅威モデルが存在します。
すなわち、暗号の復号に特化した量子コンピューターが出現するよりも早いうちに準備が必要です。

NISTが、量子コンピューターに対して脆弱になる公開鍵暗号アルゴリズムを置き換えるように設計された、新しいクラスのアルゴリズムの標準化を進めています。
この章の執筆時点で、NISTはすでにML-DSA、ML-KEM、SLH-DSAを標準化しています。
現在、標準化団体はOIDとコードポイントを記述する様々なドラフト文書を持っています。
NISTはこれらのアルゴリズムをCMVP規制フレームワークの下に置き、これらのアルゴリズムの実装のFIPS-140-3検証を可能にする作業を進めています。

### 私たちは自分自身をどのように守るのですか？

大まかに言えば、すべての TLS 1.3 接続において、認証・完全性・機密性は各接続を保護する重要な目標です。
認証は、ECDSAなどの署名スキームによって維持されます。
機密性と完全性は、ECDHEなどのキー確立アルゴリズムによって維持され、確立されたキーとAESなどの対称暗号化アルゴリズムを使用して通信ストリームを暗号化します。
したがって、TLS 1.3 プロトコルのセキュリティは、次の3種類の暗号化アルゴリズムに分解できます。

* 認証アルゴリズム
* 鍵確立アルゴリズム
* 対称暗号アルゴリズム

量子コンピュータが従来の暗号に及ぼす脅威には、2つの形態があります。
グローバーのアルゴリズムは、最新の対称暗号アルゴリズムのセキュリティを半分に低下させます。
ショアのアルゴリズムは、最新の認証および鍵確立アルゴリズムのセキュリティを完全に破壊します。
したがって、暗号処理に特化した量子コンピュータが存在する場合でも、十分に安全と考えられるAES-256対称暗号を使用して通信を保護し続けることができます。
そして、従来の認証および鍵確立アルゴリズムをポスト量子アルゴリズムに置き換えることができます。
TLS 1.3ハンドシェイク中、暗号スイートは接続の間使用される対称暗号を指定することに注意してください。
CNSA（商用国家安全保障アルゴリズムスイート）1.0と2.0はともにAES_256_GCM_SHA384暗号スイートの使用を規定しています。
鍵確立と認証については、ポスト量子KEM（鍵カプセル化メカニズム）と署名スキームがあります。

これらは従来のアルゴリズムとは異なる種類の数学を使用します。
量子コンピュータに対する耐性を特に考慮して設計されたものです。
NISTがネットワークプロトコルでの使用のために標準化した認証アルゴリズムとKEMは、格子ベースのアルゴリズムです。

* ML-DSA（Dilithium）署名スキーム
* ML-KEM（KYBER）KEM

**注意**: SABER KEMとNTRU KEMは標準化に進まなかったため、非推奨となり削除されました。

**注意**: KYBER KEM 90sバリアントはNISTが標準化を検討していないため、非推奨となり削除されました。

**注意**: Dilithium署名スキームのAESバリアントはNISTが標準化を検討していないため、非推奨となり削除されました。

**注意**: liboqs統合が削除された際、FALCONとSPHINCS+署名スキームも削除されました。今後、独自の実装を提供する予定です。

格子ベースの暗号化の説明はこの文書の範囲を超えますが、これらのアルゴリズムに関する詳細情報はNIST提出物で確認できます。

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>

残念ながら、この章を記している時点においてこれらのアルゴリズムが量子コンピューターからの攻撃に耐えられるかどうかは、まだ分かっていません。
従来型コンピューターにおける攻撃耐性も同様です。
可能性はますます低くなっていますが、誰かが格子ベースの暗号化を破る可能性があります。
ただし、暗号化は常にこのような経緯で機能してきた歴史があります。
アルゴリズムは使い始めたときは優れていますが、弱点や脆弱性が発見され、テクノロジーは順次改善されます。
ポスト量子アルゴリズムは比較的新しいため、コミュニティからもう少し注目を集める必要があるかもしれません。

解決策の1つは、これらの新しいアルゴリズムを完全には信頼しないことです。
今のところ、ポスト量子KEMを、信頼している従来のアルゴリズムとハイブリッド化することで、このリスクを回避することができます。
FIPS準拠を第一に考えると、NIST標準曲線を使用したECCは良い選択肢になります。
このため、ポスト量子KEMを統合するだけでなく、NISTが承認した曲線上のECDSAとハイブリッド化しました。
詳しくは以下のハイブリッドグループのリストを参照してください。

## ｗolfSSLのでポスト量子暗号を始めましょう

ここではまっさらなLinux環境をもとに、量子耐性を有する安全なTLS 1.3接続を実行できるようにするまでの手順を示します。

### ビルド手順

wolfSSLリポジトリの[INSTALLファイル](https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) をご参照ください。

項目15には、構成とビルドの方法に関する説明があります。

ポスト量子暗号鍵と署名を使用して X.509 証明書を生成するには、パッチを適用した OQS OpenSSL Providerフォークが必要です。
手順は <https://github.com/wolfSSL/osp/tree/master/oqs/README.md> にあります。
事前に生成された証明書もそこで入手できます。

### 量子安全なTLS接続を確立する

次のようにして、サーバーとクライアントを別々のターミナルで実行します。

```sh
    $ examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa87_root_cert.pem \
      -c certs/mldsa44_entity_cert.pem \
      -k certs/mldsa44_entity_key.pem \
      --pqc P521_ML_KEM_1024
```

```sh
    $ examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa44_root_cert.pem \
      -c certs/mldsa87_entity_cert.pem \
      -k certs/mldsa87_entity_key.pem \
      --pqc P521_ML_KEM_1024
```

これで、対称暗号化にAES-256、認証にML-DSA署名スキーム、鍵確立にECDHEとML-KEMをハイブリッド化した完全な量子安全なTLS 1.3接続を実現しました。

その他のポスト量子の例に関する詳細情報は <https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md> で確認できます。

## 暗号アーティファクトのサイズ

すべてのサイズはバイト単位です。

### ポスト量子署名スキームのアーティファクトサイズ

PQCバリアント名 | 公開鍵サイズ | 秘密鍵サイズ | 最大署名サイズ
-------------- | ----------- | ------------ | --------------
ML_DSA_44      | 1312        | 2560         | 2420
ML_DSA_65      | 1952        | 4032         | 3309
ML_DSA_87      | 2592        | 4896         | 4627

### ポスト量子KEMのアーティファクトサイズ

PQCバリアント名 | 公開鍵サイズ | 秘密鍵サイズ | 暗号文サイズ | 共有秘密サイズ
-------------- | ----------- | ------------ | ----------- | --------------
ML_KEM_512     | 800         | 1632         | 768         | 32
ML_KEM_768     | 1184        | 2400         | 1088        | 32
ML_KEM_1024    | 1568        | 3168         | 1568        | 32

## 統計データ

以下の統計とベンチマークは、8コアのUbuntu 22.04.5 LTSを実行している第11世代Intel Core i7-1185G7@3-GHzで取得されました。

```text
./configure --enable-kyber \
            --enable-dilithium \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```

**注**：主に耐量子アルゴリズムをベンチマークしていますが、比較目的のために従来のアルゴリズムも残しています。

### 実行時バイナリサイズ

`tls_bench`サンプルアプリケーションのバイナリファイルは、ビルド後にストリップすると2498432バイト（約2.4M）です。
`--enable-kyber --enable-dilithium`なしでは、ビルド後にストリップすると2290912バイト（約2.2M）です。
これは207520バイト（約200K）の差です。

### TLS 1.3データ送信サイズ

サンプルサーバーとクライアントを実行し、送信されるすべての情報をWiresharkで記録することによって取得した値を以下に示します。
これには、相互認証による TLS 1.3 ハンドシェイク、"hello wolfssl!"、"I hear you fa shizzle!" メッセージが含まれます。
すべてのパケットの `tcp.len` を合計しました。

暗号スイート             | 認証                 | 鍵確立                 | 合計バイト
---------------------- | -------------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | ECC SECP256R1         | 5455
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | ML_KEM_512            | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | ML_KEM_768            | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | ML_KEM_1024           | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | P256_ML_KEM_512       | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | P384_ML_KEM_768       | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048ビット        | P521_ML_KEM_1024      | 8467
TLS_AES_256_GCM_SHA384 | ML_DSA_44            | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | ML_DSA_65            | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | ML_DSA_87            | ECC SECP256R1         | 13477

### ヒープとスタックの使用量

**注意**：これは古い情報です。これらはwolfSSLがこれらのアルゴリズムのliboqs実装を使用していた時に取得されたものです。歴史的な目的のために残されています。

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

KEM グループのメモリ使用量を示します。
サーバーのクライアント認証には TLS13-AES256-GCM-SHA384とRSA-2048を使用し、クライアントのサーバー認証は行いません。

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

### ベンチマーク

#### wolfCryptによるベンチマーク

以下のベンチマークは次の設定フラグを使用して取得されました。

```text
./configure --enable-kyber \
            --enable-dilithium \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256 -DHAVE_ECC384"
```

**注意**: 1つのコアのみが使用されています。

```text
CPU: Intel x86_64 - avx1 avx2 rdrand rdseed bmi2 aesni adx movbe bmi1 sha
Math: 	Multi-Precision: Disabled
	Single Precision: ecc 256 384 521 rsa/dh 2048 3072 4096 asm sp_x86_64.c

ECC    SECP256R1 key gen 95600 ops took 1.000 sec, avg 0.010 ms, 95587.830 ops/sec
ECDHE  SECP256R1 agree   24800 ops took 1.003 sec, avg 0.040 ms, 24737.512 ops/sec
ECDSA  SECP256R1 sign    61400 ops took 1.001 sec, avg 0.016 ms, 61337.775 ops/sec
ECDSA  SECP256R1 verify  23000 ops took 1.001 sec, avg 0.044 ms, 22976.012 ops/sec
ML-KEM 512       key gen 284600 ops took 1.000 sec, avg 0.004 ms, 284565.467 ops/sec
ML-KEM 512       encap   270800 ops took 1.000 sec, avg 0.004 ms, 270749.585 ops/sec
ML-KEM 512       decap   172900 ops took 1.000 sec, avg 0.006 ms, 172896.249 ops/sec
ML-KEM 768       key gen 159800 ops took 1.000 sec, avg 0.006 ms, 159776.306 ops/sec
ML-KEM 768       encap   152800 ops took 1.000 sec, avg 0.007 ms, 152765.071 ops/sec
ML-KEM 768       decap   100100 ops took 1.000 sec, avg 0.010 ms, 100091.147 ops/sec
ML-KEM 1024      key gen 108300 ops took 1.000 sec, avg 0.009 ms, 108277.024 ops/sec
ML-KEM 1024      encap   104400 ops took 1.000 sec, avg 0.010 ms, 104388.900 ops/sec
ML-KEM 1024      decap   74100 ops took 1.001 sec, avg 0.014 ms, 74057.147 ops/sec
ML-DSA 44        key gen 20700 ops took 1.004 sec, avg 0.049 ms, 20617.041 ops/sec
ML-DSA 44        sign    5100 ops took 1.019 sec, avg 0.200 ms, 5003.233 ops/sec
ML-DSA 44        verify  18500 ops took 1.005 sec, avg 0.054 ms, 18403.134 ops/sec
ML-DSA 65        key gen 10200 ops took 1.007 sec, avg 0.099 ms, 10133.468 ops/sec
ML-DSA 65        sign    2900 ops took 1.004 sec, avg 0.346 ms, 2887.112 ops/sec
ML-DSA 65        verify  11600 ops took 1.005 sec, avg 0.087 ms, 11544.122 ops/sec
ML-DSA 87        key gen 7700 ops took 1.013 sec, avg 0.132 ms, 7598.278 ops/sec
ML-DSA 87        sign    2600 ops took 1.000 sec, avg 0.385 ms, 2599.634 ops/sec
ML-DSA 87        verify  7200 ops took 1.007 sec, avg 0.140 ms, 7152.274 ops/sec
```

#### wolfSSLによるベンチマーク

以下のベンチマークは次の設定フラグを使用して取得されました。

```text
./configure --enable-kyber \
            --enable-dilithium \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256"
```

**注意**: これらのベンチマークには2つのコアのみが使用されています。

```text
wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   965.511 ms
        Tx Total    :     7.469 ms
        Rx          :     2.978 MB/s
        Tx          :   384.903 MB/s
        Connect     :    48.343 ms
        Connect Avg :     2.014 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   967.748 ms
        Tx Total    :     6.789 ms
        Rx          :     2.971 MB/s
        Tx          :   423.496 MB/s
        Connect     :    48.574 ms
        Connect Avg :     2.024 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   960.296 ms
        Tx Total    :     7.494 ms
        Rx          :     2.994 MB/s
        Tx          :   383.617 MB/s
        Connect     :    56.255 ms
        Connect Avg :     2.344 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   962.002 ms
        Tx Total    :     7.367 ms
        Rx          :     2.989 MB/s
        Tx          :   390.259 MB/s
        Connect     :    56.220 ms
        Connect Avg :     2.343 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   938.745 ms
        Tx Total    :     7.889 ms
        Rx          :     2.929 MB/s
        Tx          :   348.596 MB/s
        Connect     :    61.261 ms
        Connect Avg :     2.664 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   940.382 ms
        Tx Total    :     7.540 ms
        Rx          :     2.924 MB/s
        Tx          :   364.711 MB/s
        Connect     :    61.433 ms
        Connect Avg :     2.671 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   952.389 ms
        Tx Total    :     5.561 ms
        Rx          :     3.019 MB/s
        Tx          :   517.005 MB/s
        Connect     :    50.177 ms
        Connect Avg :     2.091 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   954.202 ms
        Tx Total    :     4.751 ms
        Rx          :     3.013 MB/s
        Tx          :   605.110 MB/s
        Connect     :    48.602 ms
        Connect Avg :     2.025 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   955.030 ms
        Tx Total    :     5.882 ms
        Rx          :     3.010 MB/s
        Tx          :   488.757 MB/s
        Connect     :    51.283 ms
        Connect Avg :     2.137 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   955.658 ms
        Tx Total    :     6.200 ms
        Rx          :     3.008 MB/s
        Tx          :   463.686 MB/s
        Connect     :    49.717 ms
        Connect Avg :     2.072 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.042 ms
        Tx Total    :     7.294 ms
        Rx          :     2.955 MB/s
        Tx          :   394.150 MB/s
        Connect     :    51.750 ms
        Connect Avg :     2.156 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.655 ms
        Tx Total    :     7.996 ms
        Rx          :     2.953 MB/s
        Tx          :   359.573 MB/s
        Connect     :    50.328 ms
        Connect Avg :     2.097 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group P256_ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   961.483 ms
        Tx Total    :     7.430 ms
        Rx          :     2.990 MB/s
        Tx          :   386.966 MB/s
        Connect     :    55.885 ms
        Connect Avg :     2.329 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group P256_ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   963.042 ms
        Tx Total    :     7.088 ms
        Rx          :     2.985 MB/s
        Tx          :   405.605 MB/s
        Connect     :    53.236 ms
        Connect Avg :     2.218 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group P384_ML_KEM_768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   927.519 ms
        Tx Total    :     7.338 ms
        Rx          :     2.965 MB/s
        Tx          :   374.747 MB/s
        Connect     :    64.464 ms
        Connect Avg :     2.803 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group P384_ML_KEM_768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   929.281 ms
        Tx Total    :     6.923 ms
        Rx          :     2.959 MB/s
        Tx          :   397.229 MB/s
        Connect     :    60.200 ms
        Connect Avg :     2.617 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group P521_ML_KEM_1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   918.122 ms
        Tx Total    :     7.598 ms
        Rx          :     2.995 MB/s
        Tx          :   361.941 MB/s
        Connect     :    79.426 ms
        Connect Avg :     3.453 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group P521_ML_KEM_1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   919.900 ms
        Tx Total    :     7.563 ms
        Rx          :     2.989 MB/s
        Tx          :   363.618 MB/s
        Connect     :    71.686 ms
        Connect Avg :     3.117 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   962.723 ms
        Tx Total    :     6.394 ms
        Rx          :     2.986 MB/s
        Tx          :   449.663 MB/s
        Connect     :    52.042 ms
        Connect Avg :     2.168 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   963.166 ms
        Tx Total    :     7.537 ms
        Rx          :     2.985 MB/s
        Tx          :   381.433 MB/s
        Connect     :    52.348 ms
        Connect Avg :     2.181 ms


wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   966.071 ms
        Tx Total    :     8.458 ms
        Rx          :     2.976 MB/s
        Tx          :   339.929 MB/s
        Connect     :    56.135 ms
        Connect Avg :     2.339 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   968.053 ms
        Tx Total    :     7.895 ms
        Rx          :     2.970 MB/s
        Tx          :   364.155 MB/s
        Connect     :    56.188 ms
        Connect Avg :     2.341 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   930.195 ms
        Tx Total    :     7.849 ms
        Rx          :     2.956 MB/s
        Tx          :   350.364 MB/s
        Connect     :    62.644 ms
        Connect Avg :     2.724 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   932.128 ms
        Tx Total    :     7.440 ms
        Rx          :     2.950 MB/s
        Tx          :   369.619 MB/s
        Connect     :    62.538 ms
        Connect Avg :     2.719 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.208 ms
        Tx Total    :     8.190 ms
        Rx          :     2.954 MB/s
        Tx          :   351.021 MB/s
        Connect     :    49.608 ms
        Connect Avg :     2.067 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   975.874 ms
        Tx Total    :     7.051 ms
        Rx          :     2.946 MB/s
        Tx          :   407.772 MB/s
        Connect     :    48.708 ms
        Connect Avg :     2.030 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   965.259 ms
        Tx Total    :     8.098 ms
        Rx          :     2.978 MB/s
        Tx          :   355.041 MB/s
        Connect     :    51.284 ms
        Connect Avg :     2.137 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   967.507 ms
        Tx Total    :     7.774 ms
        Rx          :     2.972 MB/s
        Tx          :   369.828 MB/s
        Connect     :    49.899 ms
        Connect Avg :     2.079 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   972.588 ms
        Tx Total    :     7.835 ms
        Rx          :     2.956 MB/s
        Tx          :   366.959 MB/s
        Connect     :    52.259 ms
        Connect Avg :     2.177 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   974.238 ms
        Tx Total    :     7.838 ms
        Rx          :     2.951 MB/s
        Tx          :   366.813 MB/s
        Connect     :    50.758 ms
        Connect Avg :     2.115 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   971.832 ms
        Tx Total    :     7.544 ms
        Rx          :     2.958 MB/s
        Tx          :   381.096 MB/s
        Connect     :    54.727 ms
        Connect Avg :     2.280 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   972.623 ms
        Tx Total    :     8.807 ms
        Rx          :     2.956 MB/s
        Tx          :   326.456 MB/s
        Connect     :    52.613 ms
        Connect Avg :     2.192 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_ML_KEM_768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   921.217 ms
        Tx Total    :     7.740 ms
        Rx          :     2.985 MB/s
        Tx          :   355.285 MB/s
        Connect     :    69.367 ms
        Connect Avg :     3.016 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_ML_KEM_768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   923.622 ms
        Tx Total    :     6.928 ms
        Rx          :     2.977 MB/s
        Tx          :   396.956 MB/s
        Connect     :    63.739 ms
        Connect Avg :     2.771 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_ML_KEM_1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   920.447 ms
        Tx Total    :     7.735 ms
        Rx          :     2.988 MB/s
        Tx          :   355.548 MB/s
        Connect     :    78.446 ms
        Connect Avg :     3.411 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_ML_KEM_1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   921.889 ms
        Tx Total    :     7.585 ms
        Rx          :     2.983 MB/s
        Tx          :   362.578 MB/s
        Connect     :    71.310 ms
        Connect Avg :     3.100 ms
```

## ドキュメンテーション

技術文書や既知の回答テストなどのその他のリソースは、NIST PQC Webサイトにあります。

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>

アルゴリズム固有のベンチマーク情報については、OQSプロジェクトのWebサイトに掲載されています。

<https://openquantumsafe.org/benchmarking/>

## ポスト量子ステートフルハッシュベース署名

このセクションでは、最近wolfSSLがサポートを開始したLMS/HSSなどのポスト量子ステートフルハッシュベース署名(HBS)スキームについて記します。

### 動機づけ

ステートフルHBSスキームは、いくつかの理由から注目を集めています。

ステートフルHBSスキームの主な目的は、量子セキュリティの強化です。
前述したように、ショアのアルゴリズムにより、量子コンピューターは大きな整数を効率的に因数分解し、離散対数を計算することができます。
これによって、RSAやECCなどの公開鍵暗号スキームを完全に破ることができます。

対照的に、ステートフルHBSスキームは、その基礎となるハッシュ関数とマークルツリー(通常SHA256で実装)のセキュリティに基づいており、暗号に関連する量子コンピューターの登場によって破られることは予想されていません。
これらの理由から、ステートフルHBSスキームは NIST SP 800-208 および NSA の CNSA 2.0 スイートで推奨されています。
詳細については、次の2つのリンクをご参照ください。

- <https://csrc.nist.gov/publications/detail/sp/800-208/final>
- <https://media.defense.gov/2022/Sep/07/2003071834/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF>

さらにCNSA 2.0のタイムラインでは、2030年までにポスト量子ステートフルHBSスキームのみを使用する必要があり、採用は 「直ちに」 開始する必要があると規定されています。
LMS の採用は、CNSA 2.0スイートのタイムラインで最も早い要件です。

ただし、ステートフルHBSスキームの性質上、その使用と状態の追跡には細心の注意を払う必要があります。
ステートフルHBSシステムでは、秘密鍵は実際にはワンタイム署名(OTS)キーの有限セットであり、再利用されることはありません。
同じOTSキーを使用して2つの異なるメッセージを署名すると、攻撃者が署名を偽造できる可能性があり、スキーム全体のセキュリティが崩壊します。
したがって、ステートフルHBSスキームは、パブリックインターネットなどの一般的な使用には適していません。

LMS/HSSなどのステートフルHBSスキームは、特に長い運用寿命が期待され、暗号に関連する量子コンピューターに対して耐性が求められる組み込みシステムや制約付きシステムでのオフラインファームウェア認証と署名検証に特に役立ちます。

### LMS/HSS署名

wolfSSLは、wolfCrypt組み込み暗号エンジンにLMS/HSSハッシュベースの署名スキームのサポートを追加しています。
これは、以前のliboqs統合と同様に、hash-sigsLMS/HSSライブラリ(<https://github.com/cisco/hash-sigs>)との実験的な統合によって実現されます。

Leighton-Micali Signatures(LMS)とそのマルチツリーのバリアントであるHierarchical Signature System(HSS)は、ポスト量子、ステートフルハッシュベース署名スキームです。
公開鍵と秘密鍵が小さく、署名と検証が速いことで知られています。
署名のサイズは大きくなりますが、Winternitzパラメーターを介して調整できます。
詳細については、RFC8554の次の2つのリンクを参照してください：

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

wolfSSLは、[RFC 8554](https://tex2e.github.io/rfc-translater/html/rfc8554.html)で定義されているすべてのLMS/HSSパラメータをサポートしています。

- levels = {1..8}
- height = {5, 10, 15, 20, 25}
- Winternitz = {1, 2, 4, 8}

利用可能な署名の数は次の通りです。
- N = 2 ** (levels * height)

便宜上、一部のパラメータセットはenum `wc_LmsParm` で事前定義されています。
その値を以下の表に示します。

パラメータセット |  説明
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
- 高さの値を大きくすると、署名のサイズは増加します。
- Winternitz値を大きくすると、署名のサイズは小さくなりますが、鍵の生成と署名/検証にかかる時間が長くなります。

鍵の生成時間は、第1レベルのツリーの高さによって大きく決まります。
使用可能な署名の数が同じであっても、レベル3、高さ5のツリーは、初期鍵生成時にレベル1、高さ15のツリーよりもはるかに高速です

#### LMS/HSSビルド方法

wolfSSLリポジトリの[INSTALLファイル](https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) をご参照ください。
項目17には、wolfSSLとhash-sigs LMS/HSSライブラリを設定および構築する方法についての手順が記載されています。

#### ベンチマークデータ

次のベンチマークデータは、8コアIntel i7-8700 CPU@3.20GHz、Fedora 38(`6.2.9-300.fc38.x86_64`)で取得されました。
マルチスレッドの例では4スレッドと4コアが使用されましたが、シングルスレッドの例では1コアのみが使用されました。

INSTALLファイルの項目17で説明されているように、hash-sigsライブラリは2つの静的ライブラリを提供します。

- `hss_lib.a`: シングルスレッド
- `hss_lib_thread.a`: マルチスレッド

マルチスレッドバージョンではワーカースレッドが生成され、鍵生成などのCPUを集中的に使用するタスクが高速化されます。
これにより、主にすべてのパラメータ値に対する鍵の生成と署名が高速化され、より大きなレベル値の検証も多少高速化されます。

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

wolfSSLは、XMSS/XMSS^MTステートフルハッシュベース署名のサポートを追加しています。
LMSと同様に、これは[RFC 8391](https://tex2e.github.io/rfc-translater/html/rfc8391.html) のxmss-reference リポジトリ (https://github.com/XMSS/xmss-reference.git) との実験的な統合によって実現されています。

xmss-referenceは、`xmss_core_fast` および `xmss_core` 実装をサポートしています。
`xmss_core_fast` 実装は、トレードオフとしてより大きな秘密鍵サイズでパフォーマンスを優先するように設計されています。

当社の統合では `xmss_core_fast` を使用していますが、パッチが適用されているため、代わりに wolfCrypt SHA256実装を使用できます。

パッチは、[wolfssl-examplesリポジトリ](https://github.com/wolfSSL/wolfssl-examples)の
```
pq/stateful_hash_sig/0001-Patch-to-support-wolfSSL-xmss-reference-integration.patch
```
にて公開しています。

全体的に、XMSS/XMSS^MTはLMS/HSSに似ています。
より詳細な比較については、[「LMS vs XMSS: 2 つのハッシュベース署名標準の比較」](https://eprint.iacr.org/2017/349.pdf) をご参照ください。

XMSS^MTはXMSSのマルチツリー一般化であり、HSS with LMSに似ていますが、XMSS/XMSS^MTではWinternitz値が `w=16` に固定されている点が異なります。
公開鍵はXMSS/XMSS\^MTでは若干大きくなり(XMSS/XMSS\^MTでは68 バイト、LMS/HSSでは60バイト)、署名は若干小さくなります。

#### サポートしているパラメータ

wolfSSLは、[NIST SP 800-208](https://csrc.nist.gov/pubs/sp/800/208/final) の表10および11のSHA256 XMSS/XMSS^MTパラメータセットをサポートしています。

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

LMS/HSSと同様に、使用可能な署名の数は `2**h` に比例して増加します。
ここで `h` はツリー システムの合計高さです。

 
#### ベンチマークデータ

以下では、Intel x86_64およびaarch64のいくつかのXMSS/XMSS^MTパラメータセットのベンチマーク データを示します。
これらのシステムでのSHA256パフォーマンスも参考として記載されています。
必要なハッシュチェーンの数が多いため、XMSS/XMSS^MTのCPU 作業の大部分が計算されるためです。
さらに、xmss-referenceへのパッチはwolfCryptのSHA256実装を置き換えるため、同じASMの高速化のメリットが得られます。

前述のように、XMSS統合ではxmss-referenceの`xmss_core_fast`実装を使用しています。
この実装は、秘密鍵のサイズが大きいというトレードオフで、より高速なパフォーマンスを実現します。

**x86_64**

以下のx86_64ベンチマークデータは、Fedora 38 (`6.2.9-300.fc38.x86_64`) が動作するIntel i7-8700 CPU @ 3.20GHz(8コア)で取得しました。
このCPUには`avx avx2`フラグがあり、`--enable-intelasm` を有効化することでハッシュ操作を高速化できます。

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

以下のaarch64データは、CPUフラグ`sha1 sha2 sha3 sha512`を使用してApple M1上で実行されているUbuntu(`5.15.0-71-generic`) で取得されました。
`--enable-armasm` を使用してビルドすると、特に SHA ハッシュ操作が大幅に高速化されます。

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

### 開発者ノート
* 「今収穫し、後で復号する」脅威モデルを阻止しようとしていて、相互運用性の一部を犠牲にしても構わない場合は、Supported Groups拡張機能で従来のアルゴリズムのサポートを広告したくないことと思います。選択したアルゴリズムで`wolfSSL_UseKeyShare()`と`wolfSSL_set_groups()`を必ず呼び出してください。`wolfSSL_UseKeyShare()`だけを呼び出すだけでは不十分です。なぜなら、それは量子的に脆弱なアルゴリズムのサポートを広告することになるからです。ピアがポスト量子アルゴリズムをサポートしていない場合、`HelloRetryRequest`を送信し、その結果として、従来のアルゴリズムとの接続が確立されます。
