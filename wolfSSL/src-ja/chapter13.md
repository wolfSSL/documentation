

# OpenSSL互換性




## OpenSSLとの互換性



wolfSSL(以前のCyassl)は、wolfSSLネイティブAPIに加えて、OpenSSL互換性ヘッダー`wolfssl/openssl/ssl.h`を提供し、wolfSSLの使用を容易にしたり、既存のOpenSSLアプリケーションをwolfSSLに移植するのを支援します。OpenSSL互換性レイヤーの概要については、以下をご覧ください。wolfSSLがサポートするOpenSSL関数の完全なセットを表示するには、`wolfssl/openssl/ssl.h`ファイルを参照してください。


OpenSSL互換性レイヤーは、wolfSSLのネイティブAPI関数に最も一般的に使用されているOpenSSLコマンドのサブセットをマップします。これにより、多くのコードを変更せずに、アプリケーションまたはプロジェクトでOpenSSLをOpenSSLに簡単に交換できるようになります。


OpenSSL互換性のための私達のテストベッドはStunnelとLighttpdです。これは、OpenSSL互換性APIをテストする方法としてWolfsslを使ってそれらの両方をビルドすることを意味します。


互換性レイヤーを備えたwolfSSLのビルド：



1. ([`--enable-opensslextra`](chapter02.md#--enable-opensslextra))またはマクロ`OPENSSL_EXTRA`を定義することによって有効にします。




    ```sh
    ./configure --enable-opensslextra
    ```




2. 最初のwolfSSLヘッダーとして`<wolfssl/options.h>`を含めます


3. 移行のヘッダーファイルは以下にあります。

* `./wolfssl/openssl/*.h`
    *例：`<wolfssl/openssl/ssl.h>`



## WolfsslとOpenSSLの違い



多くの人々は、wolfSSL が OpenSSL とどのように比較され、組み込みプラットフォームで実行するように最適化された SSL/TLS ライブラリを使用する利点があるかについて興味があります。明らかに、OpenSSLは無料で、使用を開始するための最初のコストはありませんが、wolfSSLはあなたの柔軟性、SSL/TLSの既存のプラットフォームへのより簡単な統合、現在の標準サポート、その他の多くの機能を非常に使いやすいライセンスモデルで提供します。

以下の点は、wolfSSLとOpenSSLの間の主な違いのいくつかを概説します。



1. 2ビルド サイズが 20 ～ 100 kB の wolfSSL は、OpenSSL の最大 20 分の 1 です。 wolfSSL は、すべてのバイトが重要なリソースに制約のある環境に適しています。


2. Wolfsslは、DTLSを使用したTLS 1.3の最新規格に対応しています。wolfSSL チームは、wolfSSL を現在の標準に合わせて継続的に最新の状態に保つことに専念しています。


3. wolfSSLは、ストリーミングメディアサポートのための暗号を含む、今日利用可能な最高の現在の暗号と標準を提供しています。さらに、最近導入されたLIBOQS統合により、Quantum後の暗号化の実験を開始できます。


4. wolfSSLは、GPLV2と商業ライセンスの両方でデュアルライセンスされており、OpenSSLは複数のソースからの独自のライセンスの下でのみ利用可能です。


5. wolfSSLは、そのユーザーを気にかけている優れた会社と彼らのセキュリティについて、そして常に助けを喜んでいます。チームは、wolfSSL の改善と拡張に積極的に取り組んでいます。 wolfSSL チームは、主にモンタナ州ボーズマン、オレゴン州ポートランド、ワシントン州シアトルを拠点としており、世界中にいる他のチーム メンバーもいます。


6. wolfSSLは、実際のプラットフォームサポートと組み込み環境上の実装の成功により、リアルタイム、モバイル、および組み込みシステムのための主要なSSL/TLSライブラリです。すでにあなたの環境に移植されている可能性があります。 そうでない場合はお知らせください。喜んでお手伝いさせていただきます。


7. wolfSSLは、できるだけ簡単に環境やプラットフォームにSSLを統合するためのいくつかの抽象化レイヤーを提供しています。OOS レイヤー、カスタム I/O レイヤー、および C 標準ライブラリ抽象化レイヤーにより、統合がこれまでになく簡単になりました。

8. wolfSSLは、wolfSSL用のいくつかのサポートパッケージを提供しています。電話、電子メール、またはwolfSSL製品サポートフォーラムを介して直接利用できるように、あなたのプロジェクトをできるだけ早くあなたのプロジェクトを進歩させるのを助けるためにすばやく正確に答えられます。




## サポートされているOpenSSL構造




* `SSL_METHOD`はSSLバージョン情報を保持し、クライアントメソッドまたはサーバーのいずれかです。(ネイティブwolfSSL APIの`WOLFSSL_METHOD`と同じ)。


* `SSL_CTX`証明書を含むコンテキスト情報を保持します。(ネイティブwolfSSL APIの`WOLFSSL_CTX`と同じ)。


* `SSL`安全な接続のためにセッション情報を保持します。(ネイティブwolfSSL APIの`WOLFSSL`と同じ)。




## サポートされているOpenSSL関数



上記の3つの構造は、通常、次の方法で初期化されます。



```c
SSL_METHOD* method=SSLv3_client_method();
SSL_CTX* ctx=SSL_CTX_new(method);
SSL* ssl=SSL_new(ctx);
```



これはクライアント側のSSLバージョン3メソッドを確立し、メソッドに基づいてコンテキストを作成し、コンテキストとSSLセッションを初期化します。`SSL_METHOD`が`SSLv3_server_method()`、または利用可能な機能の1つを使用して作成されることを除いて、サーバーサイドプログラムは変わりません。サポートされている機能のリストについては、[プロトコルサポート](chapter04.md#protocol-support)セクションを参照してください。OpenSSL互換層を使用する場合、このセクションの関数は "wolf"プレフィックスを削除することで変更する必要があります。たとえば、ネイティブのwolfSSL API関数です。



```c
wolfTLSv1_client_method()
```



次のようになります



```c
TLSv1_client_method()
```



SSL接続が不要になった場合、次の呼び出しは初期化中に作成された構造を無料で解放します。



```c
SSL_CTX_free(ctx);
SSL_free(ssl);
```



`SSL_CTX_free()`には、関連する`SSL_METHOD`を解放するという追加の責任があります。`XXX_free()`関数の使用に失敗すると、リソースリークが発生します。SSLのものの代わりにシステムの`free()`を使用すると、未定義の動作が生じます。


アプリケーションが`SSL_new()`から有効なSSLポインタを持つと、SSLハンドシェイクプロセスが開始されます。クライアントのビューから、`SSL_connect()`は安全な接続を確立しようとします。



```c
SSL_set_fd(ssl, sockfd);
SSL_connect(ssl);
```



`SSL_connect()`を発行する前に、ユーザーは上記の例で有効なソケットファイル記述子、SOCKFDをwolfSSLに提供する必要があります。`sockfd`は通常、TCP `socket()`の結果であり、後にTCP `connect()`を使用して確立されます。以下は、ポート11111でローカルwolfSSLサーバーで使用する有効なクライアントサイドソケット記述子を作成します。



```c
int sockfd=socket(AF_INET, SOCK_STREAM, 0);
sockaddr_in servaddr;
memset(&servaddr, 0, sizeof(servaddr));
servaddr.sin_family=AF_INET;
servaddr.sin_port=htons(11111);
servaddr.sin_addr.s_addr=inet_addr("127.0.0.1");
connect(sockfd, (const sockaddr*)&servaddr, sizeof(servaddr));
```



接続が確立されると、クライアントはサーバーに読み書きすることができます。TCP関数`send()`および`receive()`を使用する代わりに、wolfSSLおよびYASSLはSSL関数`SSL_write()`および`SSL_read()`を使用します。ここではクライアントデモからの簡単な例です。



```c
char msg[]="hello wolfssl!";
int wrote=SSL_write(ssl, msg, sizeof(msg));
char reply[1024];
int read=SSL_read(ssl, reply, sizeof(reply));
reply[read]=0;
printf("Server response: %s\n", reply);
```



サーバーは同じ方法で接続しますが、TCP APIに類似した`SSL_connect()`の代わりに`SSL_accept()`を使用することを除きます。完全なサーバーデモプログラムについては、サーバーの例を参照してください。



## X509証明書



サーバーとクライアントの両方が、wolfSSLに** pem ** または ** der **のいずれかの証明書を提供できます。


典型的な使用法は次のようなものです。



```c
SSL_CTX_use_certificate_file(ctx, "certs/cert.pem",
SSL_FILETYPE_PEM);
SSL_CTX_use_PrivateKey_file(ctx, "certs/key.der",
SSL_FILETYPE_ASN1);
```



キーファイルは、どちらの形式でもコンテキストに表示することもできます。`SSL_FILETYPE_PEM`は、ファイルがフォーマットされていることを意味し、`SSL_FILETYPE_ASN1`はファイルがDER形式であると宣言します。キーファイルが証明書で使用するのに適していることを確認するために、次の関数を使用できます。



```c
SSL_CTX_check_private_key(ctx);
```
