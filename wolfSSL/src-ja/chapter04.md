

# 機能



wolfSSL(以前のCYASSL)は、Cプログラミング言語をプライマリインターフェイスとしてサポートしていますが、Java、PHP、Perl、Pythonなどの他のいくつかのホスト言語([swig](http://swig.org/)インターフェイスを介して)もサポートしています。現在サポートされていない別のプログラミング言語でwolfSSLをホストすることに興味がある場合は、お問い合わせください。


この章では、ストリーム暗号、AES-NI、IPv6サポート、SSL検査(SNIFFER)サポートなど、wolfSSLのいくつかの機能について、より深く詳しく説明しています。



## 機能の概要



wolfSSL機能の概要については、wolfSSL製品Webページを参照してください：[https://www.wolfssl.com/products/wolfssl](https://www.wolfssl.com/products/wolfssl)



## プロトコルサポート



wolfsslは** SSL 3.0 **、** tls **(** 1.0 **、** 1.1 **、** 1.2、1.3 **)、および** dtls **(** 1.0 **および**1.2 **)。以下の機能のいずれかを使用して、使用するプロトコルを簡単に選択できます(クライアントまたはサーバーのいずれかに示すように)。wolfSSLは、数年間不安定であるため、SSL 2.0をサポートしていません。OpenSSL互換性レイヤーを使用すると、クライアントとサーバーの関数の下にはわずかに変更されます。OpenSSL互換機能については、[OpenSSL互換性](chapter13.md#openssl-compatibility)を参照してください。



### サーバー機能




* [`wolfDTLSv1_server_method()`](group__Setup.md#function-wolfdtlsv1_server_method) -DTLS 1.0


* [`wolfDTLSv1_2_server_method()`](group__Setup.md#function-wolfdtlsv1_2_server_method) -DTLS 1.2


* [`wolfSSLv3_server_method()`](group__Setup.md#function-wolfsslv3_server_method) -SSL 3.0


* [`wolfTLSv1_server_method()`](group__Setup.md#function-wolftlsv1_server_method)  -  TLS 1.0


* [`wolfTLSv1_1_server_method()`](group__Setup.md#function-wolftlsv1_1_server_method) -TLS 1.1


* [`wolfTLSv1_2_server_method()`](group__Setup.md#function-wolftlsv1_2_server_method)  -  TLS 1.2


* [`wolfTLSv1_3_server_method()`](group__Setup.md#function-wolftlsv1_3_server_method) -TLS 1.3


* [`wolfSSLv23_server_method()`](group__Setup.md#function-wolfsslv23_server_method)  -  SSLv3  -  TLS 1.2から最高のバージョンを使用する



wolfSSLは、[`wolfSSLv23_server_method()`](group__Setup.md#function-wolfsslv23_server_method)関数で堅牢なサーバーダウングレードをサポートしています。詳細については、[堅牢なクライアントとサーバーのダウングレード](#robust-client-and-server-downgrade)を参照してください。



### クライアント機能




* [`wolfDTLSv1_client_method()`](group__Setup.md#function-v1_client_method) -DTLS 1.0


* [`wolfDTLSv1_2_client_method_ex()`](ssl_8h.md#function-wolfdtlsv1_2_client_method_ex) -DTLS 1.2


* [`wolfSSLv3_client_method()`](group__Setup.md#function-wolfsslv3_client_method) -SSL 3.0


* [`wolfTLSv1_client_method()`](group__Setup.md#function-wolftlsv1_client_method)  -  TLS 1.0


* [`wolfTLSv1_1_client_method()`](group__Setup.md#function-wolftlsv1_1_client_method) -TLS 1.1


* [`wolfTLSv1_2_client_method()`](group__Setup.md#function-wolftlsv1_2_client_method)  -  TLS 1.2


* [`wolfTLSv1_3_client_method()`](group__Setup.md#function-wolftlsv1_3_client_method) -TLS 1.3


* [`wolfSSLv23_client_method()`](group__Setup.md#function-wolfsslv23_client_method)  -  SSLv3  -  TLS 1.2から最高のバージョンを使用する



wolfSSLは、[`wolfSSLv23_client_method()`](group__Setup.md#function-wolfsslv23_client_method)関数でロバストクライアントのダウングレードをサポートしています。詳細については、[堅牢なクライアントとサーバーのダウングレード](#robust-client-and-server-downgrade)を参照してください。


これらの機能の使用方法の詳細については、[入門](chapter03.md#getting-started)の章を参照してください。SSL 3.0、TLS 1.0、1.1、1.2、およびDTLSの比較については、付録Aを参照してください。



### 堅牢なクライアントとサーバーのダウングレード



wolfSSLクライアントとサーバーの両方に、堅牢なバージョンのダウングレード機能があります。どちらの側で特定のプロトコルバージョンメソッドが使用されている場合、そのバージョンのみがネゴシエートされるか、エラーが返されます。たとえば、TLS 1.0を使用してSSL 3.0のみのサーバーに接続しようとするクライアントは、接続が失敗し、同様にTLS 1.1に接続すると同様に失敗します。


この問題を解決するために、[`wolfSSLv23_client_method()`](group__Setup.md#function-wolfsslv23_client_method)関数を使用するクライアントは、必要に応じてダウングレードすることによりサーバーがサポートする最高のプロトコルバージョンをサポートします。この場合、クライアントはTLS 1.0 -TLS 1.3を実行しているサーバーに接続できます(または、wolfSSLで構成されているプロトコルバージョンに応じてSSL 3.0を含むサブセットまたはスーパーセット)。接続できない唯一のバージョンは、長年にわたって不安定であるSSL 2.0と、デフォルトで無効になっているSSL 3.0です。


同様に、[`wolfSSLv23_server_method()`](group__Setup.md#function-wolfsslv23_server_method)関数を使用するサーバーは、TLS 1.0 -TLS 1.2のプロトコルバージョンをサポートするクライアントを処理できます。wolfSSLサーバーは、セキュリティが提供されていないため、SSLV2からの接続を受け入れることができません。



### IPv6サポート



IPv6の採用者であり、組み込みのSSL実装を使用したい場合は、wolfSSLがIPv6をサポートしているかどうか疑問に思っている可能性があります。答えはイエスです。IPv6の上で実行されているWolfsSLをサポートしています。


wolfSSLはIP Neutralとして設計されており、IPv4とIPv6の両方で動作しますが、現在のテストアプリケーションはIPv4にデフォルトになります(より広い範囲のシステムに適用されます)。テストアプリケーションをIPv6に変更するには、wolfSSLをビルドしながら** --enable-IPv6 **オプションを使用します。


IPv6に関する詳細情報はここにあります。


[https://en.wikipedia.org/wiki/IPv6](https://en.wikipedia.org/wiki/IPv6)。



### DTLS




wolfSSLは、クライアントとサーバーの両方のDTLS( "データグラム" TLS)をサポートしています。現在のサポートされているバージョンはDTLS 1.0です。


TLSプロトコルは、**信頼性の高い**媒体(TCPなど)に安全な輸送チャネルを提供するように設計されています。UDPトランスポート(SIPやさまざまな電子ゲームプロトコルなど)を使用してアプリケーションレイヤープロトコルを開発し始めたため、遅延に敏感なアプリケーションに通信セキュリティを提供する方法が必要になります。この必要性は、DTLSプロトコルの作成につながります。


多くの人々がTLSとDTLSの違いがTCPとUDPと同じであると考えています。これは正しくありません。UDPは、ハンドシェイクを持たない、断固たない、そして何かが失われるなら(TCPと比較して)途中で遅れないという利点があります。一方、DTLSは、拡張SSLハンドシェイクと引き裂きを持ち、ハンドシェイクのTCPのような動作を実装する必要があります。本質的に、DTLSは安全な接続と引き換えにUDPによって提供される利点を逆にします。


DTLは、[`--enable-dtls`](chapter02.md#--enable-dtls)ビルドオプションを使用してwolfSSLをビルドするときに有効にできます。



### LWIP(軽量インターネットプロトコル)



wolfSSLは、軽量のインターネットプロトコルの実装を箱から出してサポートしています。このプロトコルを使用するには、DEFINE `WOLFSSL_LWIP`、または`settings.h`ファイルに移動して行を外してください。



```c
/*#define WOLFSSL_LWIP*/
```



LWIPの焦点は、完全なTCPスタックを提供しながら、RAMの使用量を減らすことです。その焦点は、wolfSSLがSSL/TLSニーズに理想的なマッチであるエリアであるEmbedded Systemsでの使用に最適です。



### TLSエクステンション



wolfSSLによってサポートされているTLS拡張機能のリストと、指定された拡張子に対してRFCを参照することができます。

|RFC |拡張|wolfsslタイプ|
| --- | --------- | ------------ |
|[6066](https://datatracker.ietf.org/doc/html/rfc6066) |サーバー名表示|`TLSX_SERVER_NAME` |
|[6066](https://datatracker.ietf.org/doc/html/rfc6066) |最大フラグメントレングスネゴシエーション|`TLSX_MAX_FRAGMENT_LENGTH` |
|[6066](https://datatracker.ietf.org/doc/html/rfc6066) |切り捨てられたhmac |`TLSX_TRUNCATED_HMAC` |
|[6066](https://datatracker.ietf.org/doc/html/rfc6066) |ステータスリクエスト|`TLSX_STATUS_REQUEST` |
|[7919](https://datatracker.ietf.org/doc/html/rfc7919) |サポートされているグループ|`TLSX_SUPPORTED_GROUPS` |
|[5246](https://datatracker.ietf.org/doc/html/rfc5246) |署名アルゴリズム|`TLSX_SIGNATURE_ALGORITHMS` |
|[7301](https://datatracker.ietf.org/doc/html/rfc7301) |アプリケーションレイヤープロトコル交渉|`TLSX_APPLICATION_LAYER_PROTOCOL` |
|[6961](https://datatracker.ietf.org/doc/html/rfc6961) |複数の証明書ステータスリクエスト|`TLSX_STATUS_REQUEST_V2` |
|[5077](https://datatracker.ietf.org/doc/html/rfc5077) |セッションチケット|`TLSX_SESSION_TICKET` |
|[5746](https://datatracker.ietf.org/doc/html/rfc5746) |再交渉の表示|`TLSX_RENEGOTIATION_INFO` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |キーシェア|`TLSX_KEY_SHARE` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |事前共有キー|`TLSX_PRE_SHARED_KEY` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |PSKキー交換モード|`TLSX_PSK_KEY_EXCHANGE_MODES` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |初期データ|`TLSX_EARLY_DATA` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |クッキー|`TLSX_COOKIE` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |サポートされているバージョン|`TLSX_SUPPORTED_VERSIONS` |
|[8446](https://datatracker.ietf.org/doc/html/rfc8446) |握手の承認|`TLSX_POST_HANDSHAKE_AUTH` |




## 暗号サポート




### 暗号スイート強度と適切なキーサイズの選択



どの暗号が現在使用されているかを確認するには、メソッドを呼び出すことができます.[`wolfSSL_get_ciphers()`](group__IO.md#function-wolfssl_get_ciphers)。


この関数は、現在有効な暗号スイートを返します。


暗号スイートにはさまざまな強みがあります。それらはいくつかの異なるタイプのアルゴリズム(認証、暗号化、およびメッセージ認証コード(MAC))で構成されているため、それぞれの強度は選択されたキーサイズによって異なります。


暗号スイートの強度を評価する多くの方法があります。使用される特定の方法は、プロジェクトや企業によって異なると思われ、対称および公開キーアルゴリズムのキーサイズ、アルゴリズムの種類、パフォーマンス、既知の弱点などを含めることができます。


** nist **(国立標準技術研究所)は、それぞれのさまざまなキーサイズに同等のアルゴリズム強度を提供することにより、許容可能な暗号スイートを選択することを推奨します。暗号化アルゴリズムの強度は、アルゴリズムと使用されるキーサイズに依存します。NIST Special Publication、[SP800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)は、2つのアルゴリズムが次のように同等の強度であると見なされると述べています。


> 2つのアルゴリズムは、「アルゴリズムを壊す」またはキーを決定するか(与えられたキーサイズで)キーを使用してほぼ同じである場合、2つのアルゴリズムが与えられた鍵サイズ(xとy)に対して匹敵する強さと考えられています。資源。特定のキーサイズのアルゴリズムのセキュリティ強度は、ショートカット攻撃を有していない「X」のキーサイズを持つすべてのキーを試してみるのにかかる作業量に関して説明しています(すなわち、最も効率的なもの)。攻撃はすべての可能なキーを試すことです)。


次の2つの表は、[NIST SP 800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)の表2(pg。56)と表4(pg。59)の両方に基づいており、アルゴリズム間の同等のセキュリティ強度と強度測定(NISTの提案されたアルゴリズムセキュリティ寿命に基づいています。セキュリティのビット)。


**注**：次の表「L」は有限フィールド暗号化(FFC)の公開鍵のサイズであり、「n」はFFCの秘密鍵のサイズで、「K」は重要なサイズと見なされます。整数因数分解暗号化(IFC)、および「F」は、楕円曲線暗号の重要なサイズと見なされます。

|セキュリティのビット|対称キーアルゴリズム|** FFC **キーサイズ(DSA、DHなど)|** ifc **キーサイズ(RSAなど)|** ECC **キーサイズ(ECDSAなど)|説明|
| ---------------- | ------------------------ | -------------------------------- | ---------------------------- | ------------------------------ | ----------- |
|80 |2tdeaなど|L=1024、n=160 |K=1024 |F=160-223 |2010年までセキュリティ良い|
|128 |AES-128など|L=3072、n=256 |K=3072 |F=256-383 |2030年までのセキュリティ良い|
|192 |AES-192など|L=7680、n=384 |K=7680 |f=384-511 |長期保護|
|256 |AES-256など|L=15360、n=512 |K=15360 |f=512+ |予見可能な将来のために安全な|



このテーブルをガイドとして使用して、暗号スイートを分類し始めるために、対称暗号化アルゴリズムの強度に基づいて分類します。これを行う際には、セキュリティのビットに基づいて各暗号スイートを分類することを考案することができます(対称鍵サイズを考慮してください)。



* ** low **  -  128ビット未満のセキュリティのビット


* **中**  - セキュリティのビット128ビット


* **高い**  -  128ビットより大きいセキュリティのビット



対称暗号化アルゴリズムの強度の外側では、暗号スイートの強度は、鍵交換と認証アルゴリズムキーの鍵サイズに大きく依存します。強さは暗号スイートの最も弱いリンクと同じくらい良いです。


上記の等級方法論(そして対称暗号化アルゴリズム強度に基づくだけ)に続いて、wolfSSL 2.0.0は現在、合計0個の低強度暗号スイート、12個の中強度暗号スイート、および8つの高強度暗号スイート、および8つの高強度暗号スイートをサポートしています。以下の強度の分類は、関与する他のアルゴリズムの選択された鍵サイズによって変わる可能性があります。ハッシュ関数セキュリティ強度については、[NIST SP 800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)の表3(56)を参照のこと。


場合によっては、「** export **」の暗号として参照されている暗号が表示されます。これらの暗号は、米国からの強い暗号化でソフトウェアを輸出することが違法であったときの米国履歴の期間(1992年に遅く)に由来しました。強い暗号化は、米国政府によって(核兵器、戦車、弾道ミサイルなど)によって「弾薬」として分類されました。この制限のため、エクスポートされているソフトウェアは「弱された」暗号(主により小さなキーサイズ)を含んでいます。当日、この制限は持ち上げられており、そのように輸出暗号はもはや必須の必要性ではありません。



### サポートされている暗号スイート



次の暗号スイートは、Wolfsslによってサポートされています。暗号スイートは、TLSまたはSSLハンドシェイク中に使用される認証、暗号化、およびメッセージ認証コード(MAC)アルゴリズムの組み合わせで、接続のセキュリティ設定を交渉します。


各暗号スイートは、キーエクスチェンジアルゴリズム、バルク暗号化アルゴリズム、およびメッセージ認証コードアルゴリズム(MAC)を定義します。**キーエクスチェンジアルゴリズム**(RSA、DSS、DH、EDH)は、ハンドシェイクプロセス中にクライアントとサーバーがどのように認証するかを決定します。ブロック暗号やストリーム暗号を含む**バルク暗号化アルゴリズム**(DES、3DES、AES、ARC4)は、メッセージストリームを暗号化するために使用されます。**メッセージ認証コード(MAC)アルゴリズム**(MD2、MD5、SHA-1、SHA-256、SHA-512、RIPEMD)は、メッセージダイジェストの作成に使用されるハッシュ関数です。


以下の表は、`<wolfssl_root>/wolfssl/internal.h`(約706行から始まる)にある暗号スイート(およびカテゴリ)と一致しています。次のリストにない暗号スイートをお探しの場合は、wolfSSLに追加することについてお問い合わせください。


ECC暗号スイート：



* `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_DHE_RSA_WITH_AES_256_CBC_SHA`



* `TLS_DHE_RSA_WITH_AES_128_CBC_SHA`



* `TLS_DH_anon_WITH_AES_128_CBC_SHA`


* `TLS_RSA_WITH_AES_256_CBC_SHA`



* `TLS_RSA_WITH_AES_128_CBC_SHA`



* `TLS_RSA_WITH_NULL_SHA`



* `TLS_PSK_WITH_AES_256_CBC_SHA`



* `TLS_PSK_WITH_AES_128_CBC_SHA256`



* `TLS_PSK_WITH_AES_256_CBC_SHA384`



* `TLS_PSK_WITH_AES_128_CBC_SHA`



* `TLS_PSK_WITH_NULL_SHA256`



* `TLS_PSK_WITH_NULL_SHA384`



* `TLS_PSK_WITH_NULL_SHA`



* `SSL_RSA_WITH_RC4_128_SHA`



* `SSL_RSA_WITH_RC4_128_MD5`



* `SSL_RSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA`



* `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`



* `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA`



* `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA`



* `TLS_ECDHE_RSA_WITH_RC4_128_SHA`



* `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA`



* `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`



* `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256`



* `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384`



* `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384`



* `TLS_ECDHE_PSK_WITH_NULL_SHA256`



* `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256`



* `TLS_ECDHE_ECDSA_WITH_NULL_SHA`




静的ECC暗号スイート：



* `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA`



* `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA`



* `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA`



* `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA`



* `TLS_ECDH_RSA_WITH_RC4_128_SHA`



* `TLS_ECDH_ECDSA_WITH_RC4_128_SHA`



* `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA`



* `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256`



* `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256`



* `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384`



* `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384`




blake2b暗号スイート：



* `TLS_RSA_WITH_AES_128_CBC_B2B256`



* `TLS_RSA_WITH_AES_256_CBC_B2B256`




SHA-256暗号スイート：



* `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256`



* `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256`



* `TLS_RSA_WITH_AES_256_CBC_SHA256`



* `TLS_RSA_WITH_AES_128_CBC_SHA256`



* `TLS_RSA_WITH_NULL_SHA256`



* `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256`



* `TLS_DHE_PSK_WITH_NULL_SHA256`




SHA-384暗号スイート：



* `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384`



* `TLS_DHE_PSK_WITH_NULL_SHA384`




AES-GCM暗号スイート：



* `TLS_RSA_WITH_AES_128_GCM_SHA256`



* `TLS_RSA_WITH_AES_256_GCM_SHA384`



* `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`



* `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`



* `TLS_PSK_WITH_AES_128_GCM_SHA256`



* `TLS_PSK_WITH_AES_256_GCM_SHA384`



* `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256`



* `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384`




ECC AES-GCM暗号スイート：



* `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`



* `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`



* `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256`



* `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384`



* `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`



* `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`



* `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256`



* `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384`




AES-CCM暗号スイート：



* `TLS_RSA_WITH_AES_128_CCM_8`



* `TLS_RSA_WITH_AES_256_CCM_8`



* `TLS_ECDHE_ECDSA_WITH_AES_128_CCM`



* `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8`



* `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8`



* `TLS_PSK_WITH_AES_128_CCM`



* `TLS_PSK_WITH_AES_256_CCM`



* `TLS_PSK_WITH_AES_128_CCM_8`



* `TLS_PSK_WITH_AES_256_CCM_8`



* `TLS_DHE_PSK_WITH_AES_128_CCM`



* `TLS_DHE_PSK_WITH_AES_256_CCM`




Camellia Cipher Suites：



* `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA`



* `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA`



* `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256`



* `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256`



* `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA`



* `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA`



* `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256`



* `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256`




チャチャ暗号スイート：



* `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256`



* `TLS_ECDHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256`



* `TLS_ECDHE_ECDSA_WITH_CHACHA20_OLD_POLY1305_SHA256`



* `TLS_DHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256`




再交渉表示拡張特別スイート：



* `TLS_EMPTY_RENEGOTIATION_INFO_SCSV`





### AEADスイート



wolfSSLは、AES-GCM、AES-CCM、Chacha-Poly1305などのAEADスイーツをサポートしています。これらのAEADスイートと他のスイートの大きな違いは、追加のクリアテキストデータを使用して暗号化されたデータを認証することです。これは、データを改ざんすることになる中間攻撃で男性を緩和するのに役立ちます。AEADスイートは、キー付きハッシュアルゴリズムによって生成されたタグと組み合わせたブロック暗号(または最近でもストリーム暗号)アルゴリズムの組み合わせを使用します。これらの2つのアルゴリズムを組み合わせることで、wolfSSLの暗号化と復号化プロセスによって処理され、ユーザーが簡単になります。特定のAEADスイートを使用するために必要なのは、サポートされているスイートで使用されるアルゴリズムを単純に有効にすることです。



### ブロックとストリーム暗号



Wolfsslは** AES **、** DES **、** 3DES **、** Camellia **ブロック暗号と** RC4 **、および** Chacha20 **ストリーム暗号をサポートしています。AES、DES、3DES、RC4はデフォルトで有効になっています。Camellia、およびChacha20は、([`--enable-camellia`](chapter02.md#--enable-camellia)、および[`--disable-chacha`](chapter02.md#--disable-chacha)ビルドオプションで)wolfsslをビルドするときに有効にすることができます。AESのデフォルトモードはCBCモードです。AESを使用してGCMまたはCCMモードを有効にするには、[`--enable-aesgcm`](chapter02.md#--enable-aesgcm)と[`--enable-aesccm`](chapter02.md#--enable-aesccm)ビルドオプションを使用します。特定の使用状況については、使用例と[WolfCryptの使用法](chapter10.md#wolfcrypt-usage-reference)の例をご覧ください。


SSLはRC4をデフォルトのストリーム暗号として使用しますが、妥協のために廃止されています。最近、WolfsSLはChacha20を追加しました。RC4はChachaよりも約11％パフォーマンスが高いですが、RC4は一般にChachaよりも安全性が低いと考えられています。Chachaは、トレードオフとしてセキュリティが追加されて、独自の非常に素晴らしい時間を出すことができます。


暗号性能の比較を見るには、ここにあるwolfSSLベンチマークWebページを参照してください。<https：//www.wolfssl.com/docs/benchmarks>。



#### 違いは何ですか？



ブロック暗号は、暗号のブロックサイズであるチャンクで暗号化する必要があります。たとえば、AESには16バイトのブロックサイズがあります。したがって、データの80％以上のデータを前後に暗号化している場合、データの80％以上が無駄な埋め込みであり、暗号化/復号化プロセスの速度が短縮され、必要にネットワーク帯域幅を起動することができます。基本的にブロック暗号は、大きなデータのチャンク用に設計されており、パディングを必要とするブロックサイズを有し、固定されていない変換を使用します。


ストリーム暗号は、大量または小さなデータに適しています。ブロックサイズが不要なため、データサイズが小さい場合に適しています。速度が懸念される場合、ストリーム暗号はあなたの答えです。なぜなら、それらは通常、Xorのキーストリームを含むよりシンプルな変換を使用するからです。したがって、メディアをストリーミングする必要がある場合、小さなデータを含むさまざまなデータサイズを暗号化する、または高速暗号が必要な場合は、暗号をストリーミングすることが最善の策です。



### ハッシュ機能



SHA-384、SHA-512)、** SHA-3 **(BLAKE2)、および** RIPEMD-160 **。これらの機能の詳細な使用法は、WolfCryptの使用法、[ハッシュ関数](chapter10.md#hash-functions)にあります。



### 公開鍵オプション



wolfSSLは** RSA **、** ECC **、** DSA/DSS **と** DH **公開鍵オプションをサポートしています。。これらの機能の詳細な使用法は、WolfCryptの使用法、[公開鍵暗号](chapter10.md#public-key-cryptography)にあります。



### ECCサポート



wolfSSLは、ECDH-ECDSA、ECDHE-ECDSA、ECDH-RSA、ECDHE-PSK、ECDHE-RSAを含むがこれらに限定されない楕円曲線暗号化(ECC)をサポートしています。


wolfSSLのECC実装は、`<wolfssl_root>/wolfssl/wolfcrypt/ecc.h`ヘッダーファイルと`<wolfssl_root>/wolfcrypt/src/ecc.c`ソースファイルにあります。


サポートされている暗号スイートは、上の表に示されています。ECCは、x86 \ _64以外のビルドでデフォルトで無効になりますが、`HAVE_ECC`を使用してwolfSSLをビルドするときまたはAutoCONFシステムを使用してオンにすることができます。



```sh
./configure --enable-ecc
make
make check
```



`make check`が実行される場合は、wolfSSLがチェックする多数の暗号スイートに注意してください(チェックがCipher Suitesのリストが作成されていない場合、それ自体で`./testsuite/testsuite.test`を実行します)。これらの暗号スイートのいずれかを個別にテストすることができます。たとえば、AES256-SHAでECDH-ECDSAを試すために、wolfSSLサーバーの例は次のように開始できます。



```sh
./examples/server/server -d -l ECDHE-ECDSA-AES256-SHA -c ./certs/server-ecc.pem -k ./certs/ecc-key.pem
```



(`-d`)クライアントの証明書チェックを無効にし、(`-l`)は暗号スイートリストを指定します。(`-c`)は使用する証明書であり、(`-k`)は、使用する対応する秘密鍵です。クライアントを接続するには、次のことを試してください。



```sh
./examples/client/client -A ./certs/server-ecc.pem
```



ここで、(`-A`)は、サーバーの検証に使用するCA証明書です。



### PKCSサポート



PKCS(公開キー暗号化基準)は、RSA Security、Inc。によって作成および公開された基準のグループを指します。wolfSSLは** PKCS＃1、PKCS＃3、PKCS＃5、PKCS＃7、PKCS＃8、PKCS＃のサポートを持っています9、PKCS＃10、PKCS＃11、**および** PKCS＃12。**


さらに、wolfSSLは、PKCS＃1の一部として標準化されているRSA-Probabilistic Signature Scheme(PSS)のサポートも提供しています。



#### PKCS #5, PBKDF1, PBKDF2, PKCS #12




PKCS＃5は、パスワード、塩、および繰り返し回数を合成してパスワードベースのキーを生成するパスワードベースのキー導出方法です。wolfSSLはPBKDF1とPBKDF2鍵導出機能の両方をサポートしています。キー導出関数は、基本キーおよび他のパラメータ(上述のように塩および反復回数など)から派生鍵を生成する。PBKDF1は、派生キー長がハッシュ関数出力の長さによって囲まれているキーを導出するためにハッシュ関数(MD5、SHA1など)を適用します。PBKDF2では、キーを導出するために疑似ランダム関数(HMAC-SHA-1など)が適用されます。PBKDF2の場合、派生キーの長さは無制限です。


wolfSSLは、PBKDF1およびPBKDF2に加えて、PKCS＃12のPBKDF関数もサポートしています。関数プロトタイプは次のようになります：



```c
int PBKDF2(byte* output, const byte* passwd, int pLen,
           const byte* salt,int sLen, int iterations,
           int kLen, int hashType);

int PKCS12_PBKDF(byte* output, const byte* passwd, int pLen,
                 const byte* salt, int sLen, int iterations,
                 int kLen, int hashType, int purpose);
```



`output`には派生キーが含まれ、`passwd`は長さ`pLen`のユーザーパスワードを保持します`pLen`、`salt`は長さ`sLen`、`iterations`の塩入力を保持します。md5、sha1、またはsha2にすることができます。


`./configure`を使用してwolfSSLをビルドしている場合、この機能を有効にする方法は、オプション[`--enable-pwdbased`](chapter02.md#--enable-pwdbased)を使用することです


完全な例は`<wolfSSL Root>/wolfcrypt/test.c`にあります。詳細については、次の仕様からPKCS＃5、PBKDF1、およびPBKDF2にあります。


PKCS＃5、PBKDF1、PBKDF2：[https://tools.ietf.org/html/rfc2898](https://tools.ietf.org/html/rfc2898)



#### PKCS #8




PKCS＃8は、秘密鍵情報を格納するために使用されている秘密鍵情報構文標準として設計されています。


PKCS＃8標準には、暗号化されたプライベートキーと非暗号化されていないキーの両方を保存する構文を記述する2つのバージョンがあります。wolfSSLは、暗号化されていないPKCS＃8の両方をサポートしています。サポートされている形式には、PKCS＃5バージョン1-バージョン2、およびPKCS＃12が含まれます。利用可能な暗号化の種類には、DES、3DES、RC4、およびAESが含まれます。


PKCS＃8：[https://tools.ietf.org/html/rfc5208](https://tools.ietf.org/html/rfc5208)



#### PKCS #7




PKCS＃7は、包み込まれた証明書であろうと暗号化されていないが署名されたデータの文字列であろうと、データのバンドルを転送するように設計されています。機能は、Enableオプション([`--enable-pkcs7`](chapter02.md#--enable-pkcs7))を使用するか、Macro `HAVE_PKCS7`を使用してオンになっています。関数`wc_PKCS7_AllowDegenerate()`のオンとオフの縮退したケースを切り替えるには、呼び出されます。


サポートされている機能は次のとおりです。



* 縮退した束


* Kari、Kekri、Pwri、Ori、Ktriバンドル


* 切り離された署名


* 圧縮およびファームウェアパッケージバンドル


* カスタムコールバックサポート


* 限られたストリーミング機能




##### PKCS＃7コールバック



ユーザーがPKCS7バンドルが解析された後にユーザーが自分のキーを選択できるように追加のコールバックおよびサポート機能が追加されました.CEKをアントラップするために機能`wc_PKCS7_SetWrapCEKCb()`を呼び出すことができます。この関数によって設定されたコールバックは、KariとKekriバンドルの場合に呼び出されます。KARIの場合は、kariidまたはskidがオレニオキーとともにwolfsslからユーザーに渡されます。ユーザがCEKを自分のKEKでウラフトした後、復号化された鍵はwolfsslに渡されるべきである。この例は、ファイル`signedData-EncryptionFirmwareCB.c`のwolfSSL-examplesリポジトリにあります。


PKCS7バンドルの復号化のために追加のコールバックが追加されました。復号化コールバック関数を設定するには、API `wc_PKCS7_SetDecodeEncryptedCb()`を使用できます。ユーザー定義のコンテキストを設定するには、API `wc_PKCS7_SetDecodeEncryptedCtx()`を使用する必要があります。このコールバックは、`wc_PKCS7_DecodeEncryptedData()`への通話で実行されます。



##### PKCS＃7ストリーミング



PKCS7デコード用のストリーム指向APIは、PKCS7を持つストリーミング機能がオンになっています。ストリーミングPKCS7 APIのサポートをオフにするには、マクロ`NO_PKCS7_STREAM`を定義できます。Autotoolsでこれを行う例は`./configure --enable-pkcs7 CFLAGS=-DNO_PKCS7_STREAM`です。


ストリーミングの場合は、バンドルの復号化/検証時のストリーミングのために、次の機能がサポートされています。



1. `wc_PKCS7_DecodeEncryptedData()`


2. [`wc_PKCS7_VerifySignedData()`](group__PKCS7.md#function-wc_pkcs7_verifysigneddata)


3. [`wc_PKCS7_VerifySignedData_ex()`](group__PKCS7.md#function-wc_pkcs7_verifysigneddata_ex)


4. [`wc_PKCS7_DecodeEnvelopedData()`](group__PKCS7.md#function-wc_pkcs7_decodeenvelopeddate)


5. `wc_PKCS7_DecodeAuthEnvelopedData()`



** NOTE **：[`wc_PKCS7_VerifySignedData_ex`](group__PKCS7.md#function-wc_pkcs7_verifysigneddata_ex)を呼び出したとき、引数pkimsgfootがフルバッファであることが予想されます。内部構造は、この場合に`pkiMsgHead`になる1つのバッファのストリーミングのみをサポートします。



### 特定の暗号の使用を強制します



デフォルトでは、wolfSSLは、接続の両側がサポートできる「最高の」(最高のセキュリティ)暗号スイートを選択します。128ビットAEなどの特定の暗号を強制するには、次のようなものを追加します。



```c
wolfSSL_CTX_set_cipher_list(ctx, "AES128-SHA");
```



[`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)への呼び出しの後に：



```c
ctx=wolfSSL_CTX_new(method);
wolfSSL_CTX_set_cipher_list(ctx, "AES128-SHA");
```




### OpenQuantumsafeのliboqs統合



詳細については、このドキュメントの「Quantum-Safe Cryptographyの実験」を参照してください。



## ハードウェアの高速化暗号



wolfSSLは、さまざまなプロセッサやチップの中のいくつかのハードウェアが加速された(または「支援」)暗号機能を利用することができます。次のセクションでは、wolfSSLがどのテクノロジをサポートしているかについて説明します。



### AES-NI




AESは、wolfSSLが常にサポートしてきた世界中の政府が使用する重要な暗号化基準です。Intelは、AEを実装するより速い方法である新しい一連の指示をリリースしました。wolfSSLは、生産環境向けの新しい命令セットを完全にサポートする最初のSSLライブラリです。


基本的に、IntelとAMDは、AESアルゴリズムの計算集約型部分を実行するCHIPレベルでAES命令を追加し、パフォーマンスを向上させました。現在AES-NIをサポートしているIntelのチップのリストについては、こちらをご覧ください。


[https://ark.intel.com/search/advanced/?s=t&AESTech=true](https://ark.intel.com/search/advanced/?s=t&AESTech=true)


ソフトウェアでアルゴリズムを実行する代わりに、wolfSSLに機能を追加して、チップから命令を直接呼び出すことができます。これは、AES-NIをサポートするチップセットでwolfSSLを実行している場合、AES Cryptoを5〜10倍速く実行できることを意味します。


AES-NIサポートされたチップセットで実行されている場合は、[`--enable-aesni` build option](chapter02.md#--enable-aesni)でAES-NIを有効にします。AES-NIでwolfSSLをビルドするには、GCC 4.4.3以降はアセンブリコードを使用する必要があります。wolfSSLは、同じビルドオプションを使用してAMDプロセッサのASM命令をサポートしています。


一般から特定の順序で順序付けされたAES-NIでの参照とその他の読み出しは以下のとおりです。AES-NIによるパフォーマンス向上の詳細については、Intel Software Networkページへの3番目のリンクを参照してください。



* [AES(ウィキペディア)](Wikipedia)](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)


* [AES-NI(ウィキペディア)](Wikipedia)](https://en.wikipedia.org/wiki/AES_instruction_set)


* [AES-NI(Intelソフトウェアネットワークページ)](Intel Software Network page)](https://software.intel.com/en-us/articles/intel-advanced-encryption-standard-instructions-aes-ni/)



AES-NIは、次のAES暗号モードを加速します：AES-CBC、AES-GCM、AES-CCM-8、AES-CCM、およびAES-CTR。AES-GCMは、Ghash認証のためにIntelチップに追加された128ビットの多数関数を使用することにより、さらに加速されます。



### STM32F2




wolfSSLは、STM32F2標準周辺ライブラリを介してSTM32F2ハードウェアベースの暗号化と乱数ジェネレーターを使用できます。


必要な定義については、`WOLFSSL_STM32F2`を`settings.h`に定義してください。`WOLFSSL_STM32F2`定義は、デフォルトでSTM32F2ハードウェアクリプトとRNGサポートを有効にします。これらを個別に有効にするための定義は、`STM32F2_CRYPTO`(ハードウェア暗号サポート用)および`STM32F2_RNG`(ハードウェアRNGサポート用)です。


STM32F2標準周辺ライブラリのドキュメントは、次の文書にあります。<https：//www.stech.com/internet/com/technical_resources/technical_literature/user_manual/dm00023896.pdf>



### Cavium Nitrox



wolfSSLは、Marvell(以前のCavium)Nitrox(<https://www.marvell.com/products/security-solutions.html>)をサポートしています。wolfSSLをビルドするときにMarvell Nitroxのサポートを有効にするには、次の構成オプションを使用します。



```sh
./configure --with-cavium=/home/user/cavium/software
```



[`--with-cavium=**`](chapter02.md#--with-cavium)オプションは、ライセンスされたCavium/Softwareディレクトリを指しています。Caviumがライブラリをビルドしないため、wolfSSLは`cavium_common.o`ファイルを引っ張ります。また、githubソースツリーを使用している場合は、キャビウムヘッダーがこの警告に準拠していないため、生成されたメイクファイルから`-Wredundant-decls`警告を削除する必要があります。


現在、wolfSSLはCavium RNG、AES、3DES、RC4、HMAC、およびRSAを暗号層で直接サポートしています。SSLレベルでのサポートは部分的であり、現在、AES、3DES、およびRC4を実行しています。RSAとHMACは、非ブロッキングモードでキャビウムの呼び出しが利用できるまで遅くなります。クライアントの例は、暗号テストとベンチマークと同様に、Caviumサポートをオンにします。`HAVE_CAVIUM`定義を参照してください。



### ESP32-WROOM-32




wolfSSLは、ESP32-WROOM-32ハードウェアベースの暗号化を使用できます。


必要な定義については、`WOLFSSL_ESPWROOM32`を`settings.h`に定義してください。`WOLFSSL_ESPWROOM32`の定義は、デフォルトでESP32-WROOM-32ハードウェアクリプトとRNGサポートを有効にします。現在、wolfSSLは、Crypt層でRNG、AES、SHA、RSAプリミティブをサポートしています。TLSサーバー/クライアント、WolfCryptテスト、ベンチマークを含むプロジェクトの例は、ファイルを展開した後、ESP-IDFの/Examples/Protocols Directoryで見つけることができます。



## SSL検査(Sniffer)



wolfSSL 1.5.0のリリースから始めて、wolfSSLには、SSL Sniffer(SSL検査)機能でビルドできるビルドオプションが含まれています。これは、SSLトラフィックパケットを収集し、正しいキーファイルを使用して、それらを復号化できることを意味します。SSLトラフィックを「検査」する機能は、いくつかの理由で役立ちます。その一部には以下が含まれます。



* ネットワークの問題の分析


* 内部および外部ユーザーによるネットワークの誤用を検出します


* 動きのネットワークの使用とデータの監視


* クライアント/サーバー通信のデバッグ



Snifferサポートを有効にするには、\*nixで[`--enable-sniffer`](chapter02.md#--enable-sniffer)オプションを使用してwolfSSLをビルドするか、Windowsで** vcproj **ファイルを使用します。\*nixまたは** winpcap **に** pcap **をWindowsにインストールする必要があります。`sniffer.h`で見つけることができるメインスニファー機能は、それぞれの簡単な説明とともに以下にリストされています。



* `ssl_SetPrivateKey`  - 特定のサーバーとポートの秘密鍵を設定します。


* `ssl_SetNamedPrivateKey`  - 特定のサーバー、ポート、ドメイン名の秘密鍵を設定します。


* `ssl_DecodePacket`-デコードのためにTCP/IPパケットで通過します。


* `ssl_Trace`  - デバッグトレースをTraceFileに有効/無効にします。


* `ssl_InitSniffer`  - 全体的なスニファーを初期化します。


* `ssl_FreeSniffer`  - 全体的なスニファーを解放します。


* `ssl_EnableRecovery`-失われたパケットの場合、SSLトラフィックのデコードを取得しようとするオプションを有効にします。


*  - スニファセッションのメモリ使用量を取得します。



wolfSSLのSnifferのサポートを確認し、完全な例を参照するには、wolfSSLダウンロードの`sslSniffer/sslSnifferTest`フォルダーの`snifftest`アプリを参照してください。


暗号化キーはSSLハンドシェイクにセットアップされているため、将来のアプリケーションデータをデコードするためには、スニファーによって握手をデコードする必要があることに注意してください。たとえば、wolfSSLのEcheCoserverとeCoclientで「snifftest」を使用している場合、サーバーとクライアントの間で握手が始まる前にSnifftestアプリケーションを開始する必要があります。


スニファは、AES-CBC、DES3-CBC、ARC4、およびCamellia-CBCで暗号化されたストリームのみをデコードできます。ECDHEまたはDHEキー合意が使用されている場合、ストリームは監視できません。RSAまたはECDH鍵交換のみがサポートされています。


wolfSSL Snifferを使用したCallbacksを`WOLFSSL_SNIFFER_WATCH`でオンにすることができます。SnifferWatch機能をコンパイルした状態で、関数`ssl_SetWatchKeyCallback()`を使用してカスタムコールバックを設定できます。コールバックは、ピアから送信された証明書チェーン、エラー値、および消化の検査に使用されます。コールバックから非0値が返される場合、ピアの証明書を処理するときにエラー状態が設定されます。時計コールバックの追加のサポート機能は次のとおりです。



* `ssl_SetWatchKeyCtx`：時計コールバックに渡されるカスタムユーザコンテキストを設定します。


* `ssl_SetWatchKey_buffer`：新しいDER形式キーをサーバーセッションにロードします。


* `ssl_SetWatchKey_file`：`ssl_SetWatchKey_buffer`のファイルバージョン。



スニファを収集する統計は、マクロ`WOLFSSL_SNIFFER_STATS`を定義することでコンパイルできます。統計はSSLSTATS構造体に保持され、`ssl_ReadStatistics`への呼び出しによってアプリケーションSSLSTATS構造にコピーされます.Sniffer Statisticsで使用する追加のAPIは`ssl_ResetStatistics`です(コレクションをリセットします。統計量)と`ssl_ReadResetStatistics`(現在の統計値を読み込み、内部状態をリセットします)。以下は、オンになっているときに保存されている現在の統計です。



* `sslStandardConns`


* `sslClientAuthConns`


* `sslResumedConns`


* `sslEphemeralMisses`


* `sslResumeMisses`


* `sslCiphersUnsupported`


* `sslKeysUnmatched`


* `sslKeyFails`


* `sslDecodeFails`


* `sslAlerts`


* `sslDecryptedBytes`


* `sslEncryptedBytes`


* `sslEncryptedPackets`


* `sslDecryptedPackets`


* `sslKeyMatches`


* `sslEncryptedConns`




## 圧縮



wolfSSLは、** zlib **ライブラリとのデータ圧縮をサポートしています。`./configure`ビルドシステムはこのライブラリの存在を検出しますが、他の方法でビルドしている場合は、定数`HAVE_LIBZ`を定義し、Zlib.hへのパスを含めます。


特定の暗号ではデフォルトで圧縮がオフになっています。オンにするには、SSLが接続または受け入れる前に、関数[`wolfSSL_set_compression()`](group__Setup.md#function-wolfssl_set_compression)を使用します。クライアントとサーバーの両方が、圧縮を使用するために圧縮をオンにする必要があります。


送信する前にデータを圧縮すると、送信されて受信されるメッセージの実際のサイズが減少しますが、圧縮によって保存されたデータの量は通常、最も遅いネットワークを除くすべてのもので生で送信するよりも分析に時間がかかることに注意してください。



## 事前に共有キー



wolfSSLは、静的事前共有キーを使用してこれらの暗号をサポートしています。



* `TLS_PSK_WITH_AES_256_CBC_SHA`



* `TLS_PSK_WITH_AES_128_CBC_SHA256`



* `TLS_PSK_WITH_AES_256_CBC_SHA384`



* `TLS_PSK_WITH_AES_128_CBC_SHA`



* `TLS_PSK_WITH_NULL_SHA256`



* `TLS_PSK_WITH_NULL_SHA384`



* `TLS_PSK_WITH_NULL_SHA`



* `TLS_PSK_WITH_AES_128_GCM_SHA256`



* `TLS_PSK_WITH_AES_256_GCM_SHA384`



* `TLS_PSK_WITH_AES_128_CCM`



* `TLS_PSK_WITH_AES_256_CCM`



* `TLS_PSK_WITH_AES_128_CCM_8`



* `TLS_PSK_WITH_AES_256_CCM_8`



* `TLS_PSK_WITH_CHACHA20_POLY1305`




これらのスイートは、`WOLFSSL_STATIC_PSK`オンのwolfSSLに組み込まれています。すべてのPSKスイートは、一定の`NO_PSK`でビルド時にオフにできます。実行時にこれらの暗号のみを使用するには、希望のシファースイートと関数[`wolfSSL_CTX_set_cipher_list()`](group__Setup.md#function-wolfssl_ctx_set_cipher_list)を使用します。


wolfSSLは、Ephemeral Key PSKスイートのサポートを持っています。



* `ECDHE-PSK-AES128-CBC-SHA256`



* `ECDHE-PSK-NULL-SHA256`



* `ECDHE-PSK-CHACHA20-POLY1305`



* `DHE-PSK-CHACHA20-POLY1305`



* `DHE-PSK-AES256-GCM-SHA384`



* `DHE-PSK-AES128-GCM-SHA256`



* `DHE-PSK-AES256-CBC-SHA384`



* `DHE-PSK-AES128-CBC-SHA256`



* `DHE-PSK-AES128-CBC-SHA256`




クライアントでは、関数[`wolfSSL_CTX_set_psk_client_callback()`](ssl_8h.md#function-wolfssl_ctx_set_psk_client_callback)を使用してコールバックをセットアップします。`<wolfSSL_Home>/examples/client/client.c`のクライアントの例は、クライアントのIDとキーをセットアップするための使用例を示していますが、実際のコールバックは`wolfssl/test.h`に実装されています。


サーバー側では、2つの追加のコールが必要です。



* [`wolfSSL_CTX_set_psk_server_callback()`](ssl_8h.md#function-wolfssl_ctx_set_psk_server_callback)


* [`wolfSSL_CTX_use_psk_identity_hint()`](group__CertsKeys.md#function-wolfssl_ctx_use_psk_identity_hint)



サーバーは、「wolfSSL Server」のサーバーの例で、2回目の呼び出しを使用してクライアントを支援するためにIDヒントを格納します。Server PSKコールバックの例は、`wolfssl/test.h`で`my_psk_server_cb()`にあります。


wolfSSLはアイデンティティをサポートし、最大128個のオクテットと最大64個のオクテットまでの事前共有キーをヒントします。



## クライアント認証



クライアント認証は、クライアントが接続すると認証のためにクライアントがサーバーに証明書を送信することを要求することにより、サーバーがクライアントを認証できるようにする機能です。クライアント認証には、CAからのX.509クライアント証明書が必要です(または、あなたまたはCA以外の誰かによって生成された場合、自己署名)。


デフォルトでは、wolfSSLは受信したすべての証明書を検証します - これにはクライアントとサーバーの両方が含まれます。クライアント認証をセットアップするには、サーバーは、クライアント証明書を次のように確認するために使用される信頼できるCA証明書のリストをロードする必要があります。



```c
wolfSSL_CTX_load_verify_locations(ctx, caCert, 0);
```



クライアントの検証をオンにし、その動作を制御するために、[`wolfSSL_CTX_set_verify()`](group__Setup.md#function-wolfssl_ctx_set_verify)機能が使用されます。次の例では、`SSL_VERIFY_PEER`がサーバーからクライアントへの証明書リクエストをオンにします。`SSL_VERIFY_FAIL_IF_NO_PEER_CERT`は、クライアントがサーバー側で検証する証明書を提示しない場合、サーバーに失敗するように指示します。[`wolfSSL_CTX_set_verify()`](group__Setup.md#function-wolfssl_ctx_set_verify)のその他のオプションには、`SSL_VERIFY_NONE`および`SSL_VERIFY_CLIENT_ONCE`が含まれます。



```c
wolfSSL_CTX_set_verify(ctx,SSL_VERIFY_PEER | ((usePskPlus)?
                       SSL_VERIFY_FAIL_EXCEPT_PSK :
                       SSL_VERIFY_FAIL_IF_NO_PEER_CERT),0);
```



クライアント認証の例は、wolfsslダウンロード(`/examples/server/server.c`)に含まれるサンプルサーバー(`server.c`)にあります。



## サーバー名の指示



SNIは、サーバーが単一の基礎となるネットワークアドレスで複数の「仮想」サーバーをホストする場合に役立ちます。クライアントが連絡しているサーバーの名前を提供することが望ましい場合があります。WolfsSLでSNIを有効にするには、簡単に実行できます。



```sh
./configure --enable-sni
```



クライアント側にSNIを使用するには、追加の関数呼び出しが必要です。これは、次の機能の1つである必要があります。



* [`wolfSSL_CTX_UseSNI()`](ssl_8h.md#function-wolfssl_ctx_usesni)


* [`wolfSSL_UseSNI()`](ssl_8h.md#function-wolfssl_usesni)



クライアントが同じサーバーに複数回連絡すると、[`wolfSSL_CTX_UseSNI()`](ssl_8h.md#function-wolfssl_ctx_usesni)が最も推奨されます。コンテキストレベルでのSNI拡張子を設定すると、呼び出しの瞬間から同じコンテキストから作成されたすべてのSSLオブジェクトのSNI使用法が可能になります。


[`wolfSSL_UseSNI()`](ssl_8h.md#function-wolfssl_usesni)は1つのSSLオブジェクトのみのSNI使用を有効にするため、サーバー名がセッション間で変更されたときにこの関数を使用することをお勧めします。


サーバー側では、同じ関数呼び出しの1つが必要です。wolfSSL Serverは複数の「仮想」サーバーをホストしていないため、SNIの不一致の場合に接続の終了が必要な場合にSNIの使用が役立ちます。このシナリオでは、[`wolfSSL_CTX_UseSNI()`](ssl_8h.md#function-wolfssl_ctx_usesni)がより効率的になります。サーバーは、同じコンテキストからSNIを使用して後続のすべてのSSLオブジェクトを作成するコンテキストごとに1回しか設定しないためです。



## ハンドシェイクの変更




### 握手メッセージのグループ化



wolfSSLには、ユーザーが望む場合、握手メッセージをグループ化する機能があります。これは、[`wolfSSL_CTX_set_group_messages(ctx);`](group__Setup.md#function-wolfssl_ct_set_group_messages)のコンテキストレベルで、または[`wolfSSL_set_group_messages(ssl);`](group__Setup.md#function-wolfssl_set_group_messages)のSSLオブジェクトレベルで実行できます。



## 短縮されたHMAC.



現在定義されているTLS暗号スイートは、HMACを使用してレコード層通信を認証します。TLSでは、ハッシュ関数の出力全体がMacタグとして使用されます。ただし、MACタグを形成するときにハッシュ関数の出力を80ビットに切り捨てることにより、帯域幅を節約することは、制約付き環境で望ましい場合があります。WolfsSLで切り捨てられたHMACの使用を可能にするには、簡単にできることを説明できます。



```sh
./configure --enable-truncatedhmac
```



クライアント側に切り捨てられたHMACを使用するには、追加の関数呼び出しが必要です。これは、次の機能の1つである必要があります。



* [`wolfSSL_CTX_UseTruncatedHMAC()`](ssl_8h.md#function-wolfssl_ctx_usetruncatedhmac)


* [`wolfSSL_UseTruncatedHMAC()`](ssl_8h.md#function-wolfssl_usetruncatedhmac)



クライアントがすべてのセッションに対して切り捨てられたHMACを有効にしたい場合に最も推奨されます。コンテキストレベルでの切り捨てられたHMAC拡張子を設定すると、呼び出しの瞬間と同じコンテキストから作成されたすべてのSSLオブジェクトでそれを有効にします。


[`wolfSSL_UseTruncatedHMAC()`](ssl_8h.md#function-wolfssl_usetruncatedhmac)は1つのSSLオブジェクトのみを有効にします。そのため、すべてのセッションでTruncated HMACを必要としない場合はこの機能を使用することをお勧めします。


サーバー側では、通話は不要です。サーバーは、クライアントの切り捨てられたHMACの要求に自動的に注意を払っています。


すべてのTLS拡張機能を有効にすることもできます。



```sh
./configure --enable-tlsx
```




## ユーザー暗号モジュール



ユーザーCryptoモジュールを使用すると、ユーザーがサポートされている操作中に使用したいカスタム暗号をプラグインできます(現在RSA操作がサポートされています)。モジュールの例は、IPPライブラリを使用してディレクトリ`root_wolfssl/wolfcrypt/user-crypto/`にあります。Cryptoモジュールを使用するためにwolfSSLをビルドするときの構成オプションの例は次のとおりです。



```sh
./configure --with-user-crypto
```



また



```sh
./configure --with-user-crypto=/dir/to
```



RSA操作を実行するユーザー暗号モジュールを作成するときは、`user_rsa.h`と呼ばれるRSA用のヘッダーファイルがあることが必須です。すべてのユーザー暗号操作では、ユーザーライブラリが`libusercrypto`と呼ばれます。これらはwolfSSL AutoConfツールの名前です。ユーザー暗号モジュールをリンクして使用するときに探してください。wolfSSLを備えた例では、ヘッダファイル`user_rsa.h`はディレクトリ`wolfcrypt/user-crypto/include/`にあり、作成されたライブラリはディレクトリ`wolfcrypt/user-crypto/lib/`にあります。提供されているヘッダーファイルを参照してください。


例を作成するには、IPPライブラリをインストールした後、ルートwolfSSLディレクトリから次のコマンドを実行する必要があります。



```sh
cd wolfcrypt/user-crypto/
./autogen.sh
./configure
make
sudo make install
```



wolfSSLの添付の例では、プロジェクトをビルドする前にインストールする必要があるIPPの使用が必要です。ただし、例をビルドするためのIPPライブラリを持っていなくても、ファイル名選択とAPIインターフェイスの例をユーザーに提供することを目的としています。ライブラリlibusercryptoとヘッダーファイルの両方を作成してインストールしたら、wolfSSLを使用すると、Cryptoモジュールは追加のステップを必要としません。Configure Flag [`--with-user-crypto`](chapter02.md#--with-user-crypto)を使用するだけで、一般的なwolfSSL暗号からのすべての関数呼び出しをユーザー暗号モジュールにマッピングします。


メモリの割り当ては、wolfSSLのXmallocを使用している場合は、`DYNAMIC_TYPE_USER_CRYPTO`でタグ付けする必要があります。モジュールで使用されるメモリ割り当てを分析できます。


ユーザーの暗号モジュール**は、wolfsslの設定オプションの速いRSAおよび/またはFIPSと組み合わせて使用することはできません。FIPSには、特定の認証コードを使用し、FAST-RSAを使用してRSA操作を実行するために例ユーザー暗号モジュールを使用します。



## Wolfsslのタイミング耐性



wolfSSLは、潜在的にリークタイミング情報を漏らす可能性のある比較操作を行うときに一定の時間を保証する関数「ConstantCompare」を提供します。このAPIは、タイミングベースのサイドチャネル攻撃を阻止するために、wolfSSLのTLSレベルと暗号レベルの両方で使用されます。


wolfSSL ECC実装には、ECCアルゴリズムのタイミング耐性を有効にするために、`ECC_TIMING_RESISTANT`を定義しています。同様に、定義`TFM_TIMING_RESISTANT`は、RSAアルゴリズムのタイミング耐性のFast Mathライブラリに提供されます。関数exptmodは、タイミング耐性のモンゴメリーラダーを使用します。


参照：[`--disable-harden`](chapter02.md#--disable-harden)


処理時間一定化とキャッシュ抵抗は、`--enable-harden`で有効になっています。



* `WOLFSSL_SP_CACHE_RESISTANT`：使用するアドレスをマスクするロジックを有効にします。


* `WC_RSA_BLINDING`：タイミング攻撃を防ぐために、ブラインドモードを有効にします。


* `ECC_TIMING_RESISTANT`：ECC固有の処理時間一定化。


* `TFM_TIMING_RESISTANT`：Fast Math固有の処理時間一定化。




## Fixed ABI




wolfSSLは、アプリケーションプログラミングインターフェイス(API)のサブセットに固定アプリケーションバイナリインターフェイス(ABI)を提供します。wolfSSL v4.3.0から始めて、次の機能は、wolfSSLの将来のすべてのリリースにわたって互換性があります。



* [`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)


* [`wolfTLSv1_2_client_method()`](group__Setup.md#function-wolftlsv1_2_client_method)


* [`wolfTLSv1_3_client_method()`](group__Setup.md#function-wolftlsv1_3_client_method)


* [`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)


* [`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)


* [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)


* [`wolfSSL_set_fd()`](group__Setup.md#function-wolfssl_set_fd)


* [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)


* [`wolfSSL_read()`](group__IO.md#function-wolfssl_read)


* [`wolfSSL_write()`](group__IO.md#function-wolfssl_write)


* [`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error)


* [`wolfSSL_shutdown()`](group__TLS.md#function-wolfssl_shutdown)


* [`wolfSSL_free()`](group__Setup.md#function-wolfssl_free)


* [`wolfSSL_CTX_free()`](group__Setup.md#function-wolfssl_ctx_free)


* [`wolfSSL_check_domain_name()`](group__Setup.md#function-wolfssl_check_domain_name)


* [`wolfSSL_UseALPN()`](group__Setup.md#function-wolfssl_usealpn)


* [`wolfSSL_CTX_SetMinVersion()`](group__Setup.md#function-wolfssl_ctx_setminversion)


* [`wolfSSL_pending()`](group__IO.md#function-wolfssl_pending)


* [`wolfSSL_set_timeout()`](group__Setup.md#function-wolfssl_set_timeout)


* [`wolfSSL_CTX_set_timeout()`](group__Setup.md#function-wolfssl_ctx_set_timeout)


* [`wolfSSL_get_session()`](group__IO.md#function-wolfssl_get_session)


* [`wolfSSL_set_session()`](group__Setup.md#function-wolfssl_set_session)


* [`wolfSSL_flush_sessions()`](group__IO.md#function-wolfssl_flush_sessions)


* [`wolfSSL_CTX_set_session_cache_mode()`](group__Setup.md#function-wolfssl_ctx_set_session_cache_mode)


* [`wolfSSL_get_sessionID()`](group__openSSL.md#function-wolfssl_get_sessionid)


* [`wolfSSL_UseSNI()`](ssl_8h.md#function-wolfssl_usesni)


* [`wolfSSL_CTX_UseSNI()`](ssl_8h.md#function-wolfssl_ctx_usesni)


* [`wc_ecc_init_ex()`](group__ECC.md#function-wc_ecc_init_ex)


* [`wc_ecc_make_key_ex()`](group__ECC.md#function-wc_ecc_make_key_ex)


* [`wc_ecc_sign_hash()`](group__ECC.md#function-wc_ecc_sign_hash)


* [`wc_ecc_free()`](group__ECC.md#function-wc_ecc_free)


* [`wolfSSL_SetDevId()`](ssl_8h.md#function-wolfssl_setdevid)


* [`wolfSSL_CTX_SetDevId()`](ssl_8h.md#function-wolfssl_ctx_setdevid)


* [`wolfSSL_CTX_SetEccSignCb()`](ssl_8h.md#function-wolfssl_ctx_seteccsigncb)


* [`wolfSSL_CTX_use_certificate_chain_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_chain_file)


* [`wolfSSL_CTX_use_certificate_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_certificate_file)


* [`wolfSSL_use_certificate_chain_file()`](group__openSSL.md#function-wolfssl_use_certificate_chain_file)


* [`wolfSSL_use_certificate_file()`](group__openSSL.md#function-wolfssl_use_certificate_file)


* [`wolfSSL_CTX_use_PrivateKey_file()`](group__CertsKeys.md#function-wolfssl_ctx_use_privatekey_file)


* [`wolfSSL_use_PrivateKey_file()`](group__openSSL.md#function-wolfssl_use_privatekey_file)


* [`wolfSSL_X509_load_certificate_file()`](group__CertsKeys.md#function-wolfssl_x509_load_certificate_file)


* [`wolfSSL_get_peer_certificate()`](group__CertsKeys.md#function-wolfssl_get_peer_certificate)


* [`wolfSSL_X509_NAME_oneline()`](group__CertsKeys.md#function-wolfssl_x509_name_oneline)


* [`wolfSSL_X509_get_issuer_name()`](group__CertsKeys.md#function-wolfssl_x509_get_issuer_name)


* [`wolfSSL_X509_get_subject_name()`](group__CertsKeys.md#function-wolfssl_x509_get_subject_name)


* [`wolfSSL_X509_get_next_altname()`](group__CertsKeys.md#function-wolfssl_x509_get_next_altname)


* [`wolfSSL_X509_notBefore()`](group__CertsKeys.md#function-wolfssl_x509_notbefore)


* [`wolfSSL_X509_notAfter()`](group__CertsKeys.md#function-wolfssl_x509_notafter)


* [`wc_ecc_key_new()`](group__ECC.md#function-wc_ecc_key_new)


* [`wc_ecc_key_free()`](group__ECC.md#function-wc_ecc_key_free)
