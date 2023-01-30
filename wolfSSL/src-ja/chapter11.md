

# SSLチュートリアル




## 序章



wolfSSL(以前のCyassl)の組み込みSSLライブラリは、SSLとTLSを追加することで、通信セキュリティを強化するために既存のアプリケーションまたはデバイスに簡単に統合できます。wolfSSLは組み込み環境およびRTOS環境を対象としており、そのため優れた性能を維持しながら最小限のフットプリントを提供します。wolfSSLの最小ビルドサイズは、選択されたビルドオプションと使用されているプラットフォームに応じて20~100KBの間の範囲です。


このチュートリアルの目標は、SSLとTLSの統合を簡単なアプリケーションに統合することです。このチュートリアルを通過するプロセスが、一般的にSSLをよりよく理解するプロセスにつながることを願っています。このチュートリアルでは、SSLサポートをアプリケーションに追加する一般的な手順を実証しながら、シンプルなEchoServerおよびEchoClientの例と組み合わせてwolfSSLを使用して、可能な限りシンプルなものを保持します。EchoServerとEchoClientの例は、リチャード・スティーブンス、ビル・フェナー、アンドリュー・ルドフによる[UNIXネットワークプログラミング、第1版、第3版](http://www.unpbook.com/)というタイトルの人気の本から参考にしました。


このチュートリアルでは、読み手がGNU GCCコンパイラを使用してCコードを編集してコンパイルすることで、公開鍵暗号化の概念に精通していることを前提としています。UNIXネットワークプログラミング本へのアクセスはこのチュートリアルには必要ありません。



### このチュートリアルで使用されている例




* EchoClient - 図5.4、124ページ


* EchoServer  - 図5.12、139ページ




## SSL/TLSのクイックサマリー



** TLS ** (トランスポート層セキュリティ) と** SSL ** (Secure Sockets Layer) は、さまざまなトランスポートプロトコルにわたって安全な通信を可能にする暗号プロトコルです。使用されるプライマリトランスポートプロトコルはTCP/IPです。SSL/TLSの最新バージョンはTLS 1.3です。wolfSSLは、DTLS 1.0と1.2に加えて、SSL 3.0、TLS 1.0,1.1,1.2,1.3をサポートしています。


SSLとTLSは、OSIモデルの輸送層とアプリケーション層の間にあり、そこでは任意の数のプロトコル(TCP/IP、Bluetoothなどを含む)が基礎となる輸送媒体として機能する場合があります。アプリケーションプロトコルはSSLの上に階層化されており、HTTP、FTP、SMTPなどのプロトコルを含めることができます。SSLがOSIモデルにどのように適合するかの図と、SSLハンドシェイクプロセスの簡単な図は、付録Aにあります。



## ソースコードを取得します



このチュートリアルで使用されているすべてのソースコードは、特に次の場所からwolfSSLのWebサイトからダウンロードできます。このダウンロードには、このチュートリアルで使用されているEchoServerとEchoClientの両方の元のソースコードと完成したソースコードが含まれています。特定の内容がリンクの下にリストされています。


<https://www.wolfssl.com/documentation/ssl-tutorial-2.3.zip>


ダウンロードしたzipファイルには次のような構造があります。



```text
/finished_src
    /echoclient (Completed echoclient code)
    /echoserver (Completed echoserver code)
    /include    (Modified unp.h)
    /lib    (Library functions)
/original_src
    /echoclient (Starting echoclient code)
    /echoserver (Starting echoserver code)
    /include    (Modified unp.h)
    /lib    (Library functions)
README
```




## 基本変形例



このチュートリアルとそれに付随するソースコードは、プラットフォーム全体で可能な限りポータブルになるように設計されています。このため、またSSLとTLSをアプリケーションに追加する方法に焦点を合わせたいため、ベースの例は可能な限り単純に保たれています。不必要な複雑さを削除するか、サポートされているプラットフォームの範囲を増やすために、UNIXネットワークプログラミングから取得した例にいくつかの変更が加えられています。このチュートリアルの移植性を高めるためにできることがあると思われる場合は、[support@wolfssl.com](mailto:support@wolfssl.com)までお知らせください。


以下は、上記の本に記載されている元のEchoServerとEchoClientな例に加えられた修正のリストです。



### EcheServerへの変更(tcpserv04.c)




* `fork()`がWindowsでサポートされていないため、`Fork()`関数への呼び出しを削除しました。この結果は、1つのクライアントのみを同時に受け入れるEchoServerです。この削除に加えて、信号処理が削除されました。


* `str_echo()`機能を`str_echo.c`ファイルから`tcpserv04.c`ファイルに移動しました


* Printfステートメントを追加して、クライアントアドレスと私たちが接続したポートを表示します。




    ```text
    printf("Connection from %s, port %d\n",
            inet_ntop(AF_INET, &cliaddr.sin_addr, buff, sizeof(buff)),
            ntohs(cliaddr.sin_port));
    ```




* リスニングソケットを作成した後、`setsockopt()`に呼び出しを追加して、「既に使用されているアドレス」バインドエラーを排除しました。


* 新しいコンパイラの警告をクリーンアップするためのマイナーな調整




### EchoClient(tcpcli01.c)の変更




* `str_cli()`機能を`str_cli.c`ファイルから`tcpcli01.c`ファイルに移動しました


* 新しいコンパイラの警告をクリーンアップするためのマイナーな調整




### Unp.hヘッダーへの変更




* このヘッダーは、この例に必要なもののみを含むように簡素化されました。



これらのソースコードの例では、特定の関数が大文字になっていることに注意してください。たとえば、`Fputs()`と`Writen()`の作者は、エラーチェックをきれいに処理するために、通常の関数にカスタムラッパー関数を書いています。これについてのより詳細な説明は、_unixネットワークプログラミング_書籍の** 1.4 **(11ページ)を参照してください。



## Wolfsslのビルドとインストール



開始する前に、上記の[ソースコードを取得します](chapter03.md#getting-the-source-code)セクションからサンプルコード(`echoserver`および`echoclient`)をダウンロードしてください。このセクションでは、システムにwolfSSL埋め込みSSLライブラリをダウンロード、構成、インストールする方法について説明します。


Wolfssl [ダウンロードページ](https://wolfssl.com/yaSSL/download/downloadForm.php)から最新バージョンのwolfSSLをダウンロードしてインストールする必要があります。


利用可能なビルドオプションの完全なリストについては、「[Building Wolfssl](https://www.yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html)ガイド」を参照してください。Wolfsslは移植性を念頭に置いて書かれており、ほとんどのシステムでビルドするのは一般的に簡単なべきです。Wolfsslをビルドするのが難しい場合は、Wolfssl [製品サポートフォーラム](https://www.wolfssl.com/forums)でのサポートをお気軽にお問い合わせください。


Linux、* BSD、OS X、Solaris、またはその他の* NIXシステムのwolfSSLをビルドするときは、AutoConfシステムを使用できます。Windows固有の指示については、wolfSSLマニュアルの[Building Wolfssl](chapter02.md#building-wolfssl)セクションを参照してください。wolfSSLを設定してビルドするには、端末から次の2つのコマンドを実行します。任意のビルドオプションを`./configure`に追加することができます(ex：`./configure -–enable-opensslextra`)。



```sh
./configure
make
```



wolfsslをインストールするには、実行してください。



```sh
sudo make install
```



これにより、wolfSSLヘッダーは`/usr/local/include/wolfssl`に、wolfSSLライブラリはシステム上の`/usr/local/lib`にインストールされます。ビルドをテストするには、wolfSSLルートディレクトリからTestSuiteアプリケーションを実行します。



```sh
./testsuite/testsuite.test
```



一連のテストがWolfCryptとwolfSSLで実行され、正しくインストールされていることが確認されます。TestSuiteアプリケーションの実行が成功した後、次のような出力が表示されるはずです。



```text
MD5      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
GMAC     test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES      test passed!
AES-GCM  test passed!
RANDOM   test passed!
RSA      test passed!
DH       test passed!
ECC      test passed!
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
Client message: hello wolfssl!
Server response: I hear you fa shizzle!
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers=DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /tmp/output-N0Xq9c

All tests passed!
```



wolfSSLがインストールされたので、SSL機能を追加するためにサンプルコードの変更を開始できます。まず、SSLをEchoClientに追加し、その後EchoServerに移動することから始めます。



## 初期コンパイル



SSLチュートリアルソースバンドルからEchoClientおよびEchoServerコードの例をコンパイルして実行するには、含まれているメイクファイルを使用できます。ディレクトリ(CD)をEchoClientまたはEchoServerディレクトリに変更して実行します。



```sh
make
```



これにより、サンプルコードがコンパイルされ、ビルドされているものに応じて、EchoServerまたはEchoClientという名前の実行可能ファイルが作成されます。MakeFileで使用されるGCCコマンドを以下に示します。付属のMakeFileを使用せずに例のいずれかを作成する場合は、ディレクトリをサンプルディレクトリに変更し、次のコマンドで`tcpcli01.c`(echoclient)または`tcpserv04.c`(echoserver)を置き換えます。例の正しいソースファイルを使用して：



```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include
```



これにより、現在の例が実行可能ファイルにコンパイルされ、「EchoServer」または「EchoClient」アプリケーションのいずれかが作成されます。コンパイルされた後に例の1つを実行するには、現在のディレクトリを目的の例ディレクトリに変更してアプリケーションを開始します。たとえば、Echoserverの使用を開始するには：



```sh
./echoserver
```



ローカルホストのEchoClientをテストするために2番目のターミナルウィンドウを開くことができ、アプリケーションを起動するときにサーバーのIPアドレスを指定する必要があります。これは私たちの場合は127.0.0.1になります。現在のディレクトリを "EchoClient"ディレクトリに変更して、次のコマンドを実行します。エコーサーバーはすでに実行されている必要があります。



```sh
./echoclient 127.0.0.1
```



EchoServerとEchoClientの両方の実行を行うと、EchoServerはEchoClientから受け取る入力をエコーバックする必要があります。EchoServerまたはEchoClientのいずれかを終了するには、_CTRL + C_を使用してアプリケーションを終了します。現在、これら 2 つの例の間でやり取りされるデータは平文で送信されており、少しのスキルがあれば誰でも簡単にクライアントとサーバーの間に自分自身を挿入して通信を聞くことができます。



## ライブラリ



wolfSSLライブラリは、一度コンパイルされると`libwolfssl`という名前であり、特に構成されていない限り、wolfSSLビルドおよびインストールプロセスは、次のディレクトリの下に共有ライブラリのみを作成します。適切なビルドオプションを使用して、共有ライブラリと静的ライブラリの両方を有効または無効にすることができます。



```sh
/usr/local/lib
```



私たちがする必要がある最初のステップは、wolfSSLライブラリを私たちのサンプルアプリケーションにリンクすることです。GCCコマンドの変更(例としてEchoServerを使用して)、次の新しいコマンドを参照してください。wolfSSLは標準的な場所にヘッダーファイルとライブラリをインストールするため、コンパイラは明示的な命令なしでそれらを見つけることができるはずです(`-l`または`-L`を使用)。`-lwolfssl`を使用することで、コンパイラは自動的に正しいタイプのライブラリ(静的または共有)を選択します。



```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include -lm -lwolfssl
```




## ヘッダー



最初に行う必要があるのは、クライアントとサーバーの両方にwolfSSLネイティブAPIヘッダーを含めることです。クライアントの`tcpcli01.c`ファイルとサーバーのtcpserv04.cファイルで、上部近くに次の行を追加します。



```c
#include <wolfssl/ssl.h>
```




## 起動/シャットダウン



コードでwolfSSLを使用する前に、ライブラリーと`WOLFSSL_CTX`を初期化する必要があります.wolfSSLは[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)を呼び出して初期化されます。


`WOLFSSL_CTX`構造(wolfSSLコンテキスト)には、証明書情報を含む各SSL接続のグローバル値が含まれています。単一の`WOLFSSL_CTX`は、作成された`WOLFSSL`オブジェクトの任意の数で使用できます。これにより、信頼できるCA証明書のリストなど、特定の情報を1回だけ読み込むことができます。


新しい`WOLFSSL_CTX`を作成するには、[`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)を使用します。この関数には、クライアントまたはサーバーが使用するSSLまたはTLSプロトコルを定義する引数が必要です。目的のプロトコルを選択するためのいくつかのオプションがあります。wolfSSLは現在、SSL 3.0、TLS 1.0、TLS 1.1、TLS 1.2、DTLS 1.0、およびDTLS 1.2をサポートしています。これらの各プロトコルには、[`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)の引数として使用できる対応する関数があります。可能なクライアントとサーバーのプロトコルオプションを以下に示します。SSL 2.0は、数年間不安定であるため、wolfSSLによってサポートされていません。


エコークライアント：



* [`wolfSSLv3_client_method();`](group__Setup.md#function-wolfsslv3_client_method) -SSL 3.0


* [`wolfTLSv1_client_method();`](group__Setup.md#function-wolftlsv1_client_method)  -  TLS 1.0


* [`wolfTLSv1_1_client_method();`](group__Setup.md#function-wolftlsv1_1_client_method) -TLS 1.1


* [`wolfTLSv1_2_client_method();`](group__Setup.md#function-wolftlsv1_2_client_method)  -  TLS 1.2


* [`wolfSSLv23_client_method();`](group__Setup.md#function-wolfsslv23_client_method)  -  SSLv3から可能な最高版を使用する -  TLS 1.2


* [`wolfDTLSv1_client_method();`](group__Setup.md#function-wolfdtlsv1_client_method) -DTLS 1.0


* [`wolfDTLSv1_2_client_method_ex();`](ssl_8h.md#function-wolfdtlsv1_2_client_method_ex) -DTLS 1.2



エコーサーバー：



* [`wolfSSLv3_server_method();`](group__Setup.md#function-wolfsslv3_server_method)  -  SSLv3


* [`wolfTLSv1_server_method();`](group__Setup.md#function-wolftlsv1_server_method)  -  TLSv1


* [`wolfTLSv1_1_server_method();`](group__Setup.md#function-wolftlsv1_1_server_method) -TLSV1.1


* [`wolfTLSv1_2_server_method();`](group__Setup.md#function-wolftlsv1_2_server_method) -TLSV1.2


* [`wolfSSLv23_server_method();`](group__Setup.md#function-wolfsslv23_server_method)-クライアントがTLSV1+に接続できるようにします


* [`wolfDTLSv1_server_method();`](group__Setup.md#function-wolfdtlsv1_server_method)  -  DTLS.


* [`wolfDTLSv1_2_server_method();`](ssl_8h.md#function-wolfdtlsv1_2_server_method) -DTLS 1.2



EchoClientがEchoServerに接続すると、CA(認証局)証明書を`WOLFSSL_CTX`にロードする必要があります。サーバーの身元を確認することができます。CA証明書を`WOLFSSL_CTX`にロードするには、[`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)を使用します。この関数には、`WOLFSSL_CTX`ポインタ、証明書ファイル、およびパス値の3つの引数が必要です。パス値は、PEM形式でCA証明書を含むべきディレクトリを指します。証明書を検索するとき、wolfsslはパスの場所を見る前に証明書ファイルの値を調べます。この場合、CAファイルを1つ指定するため、証明書パスを指定する必要はありません - パス引数に値0を使用します。[`wolfSSL_CTX_load_verify_locations`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)関数は`SSL_SUCCESS`または`SSL_FAILURE`のいずれかを返します。



```c
wolfSSL_CTX_load_verify_locations(WOLFSSL_CTX* ctx, const char* file, const char* path)
```



これらのものをまとめる(ライブラリの初期化、プロトコルの選択、CA証明書)、次のことがあります。ここでは、TLS 1.2を使用することを選択します。


エコーコイエント：



```c
  WOLFSSL_CTX* ctx;

  wolfSSL_Init();/* Initialize wolfSSL */

  /* Create the WOLFSSL_CTX */
  if ( (ctx=wolfSSL_CTX_new(wolfTLSv1_2_client_method())) == NULL){
       fprintf(stderr, "wolfSSL_CTX_new error.\n");
       exit(EXIT_FAILURE);
  }

  /* Load CA certificates into WOLFSSL_CTX */
  if (wolfSSL_CTX_load_verify_locations(ctx,"../certs/ca-cert.pem",0) !=
      SSL_SUCCESS) {
      fprintf(stderr, "Error loading ../certs/ca-cert.pem, please check
              the file.\n");
      exit(EXIT_FAILURE);
  }
```



エコーサーバー：


`WOLFSSL_CTX`に証明書をロードする場合、CA証明書に加えてサーバー証明書とキーファイルをロードする必要があります。これにより、サーバーは識別検証のためにクライアントに証明書を送信できます。



```c
  WOLFSSL_CTX* ctx;

  wolfSSL_Init();  /* Initialize wolfSSL */

  /* Create the WOLFSSL_CTX */
  if ( (ctx=wolfSSL_CTX_new(wolfTLSv1_2_server_method())) == NULL){
       fprintf(stderr, "wolfSSL_CTX_new error.\n");
       exit(EXIT_FAILURE);
  }

  /* Load CA certificates into CYASSL_CTX */
  if (wolfSSL_CTX_load_verify_locations(ctx, "../certs/ca-cert.pem", 0) !=
           SSL_SUCCESS) {
       fprintf(stderr, "Error loading ../certs/ca-cert.pem, "
           "please check the file.\n");
       exit(EXIT_FAILURE);
  }

/* Load server certificates into WOLFSSL_CTX */
  if (wolfSSL_CTX_use_certificate_file(ctx,"../certs/server-cert.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS){
      fprintf(stderr, "Error loading ../certs/server-cert.pem, please
        check the file.\n");
      exit(EXIT_FAILURE);
  }

  /* Load keys */
  if (wolfSSL_CTX_use_PrivateKey_file(ctx,"../certs/server-key.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS){
      fprintf(stderr, "Error loading ../certs/server-key.pem, please check
        the file.\n");
      exit(EXIT_FAILURE);
  }
```



上記のコードは、変数定義の両方がIPアドレス(クライアント)を持つクライアントを起動したチェックの後、`tcpcli01.c`および`tcpserv04.c`の最初に追加されるべきです。完成したコードのバージョンは、参照用のSSLチュートリアルZIPファイルに含まれています。


WOLFSSLと`WOLFSSL_CTX`が初期化されているので、アプリケーションがSSL/TLSを使用して完全に行われたときに`WOLFSSL_CTX`オブジェクトとwolfSSLライブラリが解放されていることを確認してください。クライアントとサーバーの両方で、`main()`関数の最後に次の2行を配置する必要があります(クライアント内のクライアント内の`exit()`まで)。



```c
wolfSSL_CTX_free(ctx);
wolfSSL_Cleanup();
```




## wolfsslオブジェクト




### ech



各TCP Connectの後にwolfSSLオブジェクトを作成する必要があり、ソケットファイル記述子をセッションに関連付ける必要があります。EchoClientの例では、`Connect()`への呼び出し後にこれを行います。



```c
/* Connect to socket file descriptor */
Connect(sockfd, (SA *) &servaddr, sizeof(servaddr));
```



接続直後に、[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)関数を使用して新しい`WOLFSSL`オブジェクトを作成します。ここの関数は、成功した場合は `WOLFSSL` オブジェクトへのポインタを返し、失敗した場合は `NULL` を返します。その後、ソケットファイル記述子(`sockfd`)を新しい`WOLFSSL`オブジェクト(`ssl`)に関連付けることができます。



```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if( (ssl=wolfSSL_new(ctx)) == NULL) {
    fprintf(stderr, "wolfSSL_new error.\n");
    exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, sockfd);
```



ここで注目すべきことの 1 つは、[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect) 関数を呼び出していないことです。[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)はサーバーとのSSL/TLSハンドシェイクを開始し、以前に呼び出されていなかった場合は[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)の処理中で呼び出されます。この例の場合、[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)がそれを行ってくれるので、明示的に[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)を呼びません。



### EchoServer



メインメソッドのforループの最後に、wolfSSLオブジェクトを挿入し、クライアントと同様に、ソケットファイル記述子(`connfd`)を`WOLFSSL`オブジェクト(`ssl`)に関連付けます。



```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if ( (ssl=wolfSSL_new(ctx)) == NULL) {
            fprintf(stderr, "wolfSSL_new error.\n");
            exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, connfd);
```



各TCP Connectの後にwolfSSLオブジェクトを作成する必要があり、ソケットファイル記述子をセッションに関連付ける必要があります。


[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)関数を使用して、新しいwolfSSLオブジェクトを作成します。この関数は、成功した場合は `WOLFSSL` オブジェクトへのポインタを返し、失敗した場合は `NULL` を返します。その後、ソケットファイル記述子(`sockfd`)を新しい`WOLFSSL`オブジェクト(`ssl`)に関連付けることができます。



```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if( (ssl=wolfSSL_new(ctx)) == NULL) {
    fprintf(stderr, "wolfSSL_new error.\n");
    exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, sockfd);
```




## データの送信/受信




### EchoClientで送信します



次のステップは安全にデータの送信を開始することです。echoclient の例では、`main()` 関数が送受信作業を `str_cli()` に渡すことに注意してください。`str_cli()`関数は、私たちの関数で置き換えが行われます。最初に`str_cli()`のオブジェクトにアクセスする必要があるため、別の引数を追加してSSL変数を`str_cli()`に渡します.`WOLFSSL`オブジェクトは`str_cli()`関数の内部で使用されるため、`sockfd`パラメーターを削除します。この変更後の新しい`str_cli()`関数シグネチャを以下に示します。



```c
void str_cli(FILE *fp, WOLFSSL* ssl)
```



`main()`関数では、新しい引数(`ssl`)が`str_cli()`に渡されます。



```c
str_cli(stdin, ssl);
```



`str_cli()`の内部では、`Writen()`と`Readline()`の内側に[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)および[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)の関数への呼び出しに置き換えられ、元のファイル記述子の代わりに`WOLFSSL`オブジェクト(`ssl`)が使用されます(`sockfd`)。新しい`str_cli()`関数を以下に示します。[`wolfSSL_write`](group__IO.md#function-wolfssl_write)と[`wolfSSL_read`](group__IO.md#function-wolfssl_read)へのコールが成功したかどうかを確認する必要があることに注意してください。


UNIXプログラミングブックの著者は、それが交換された後に補う必要がある`Writen()`関数にエラーチェックを書きました。New Int変数`n`を追加し、戻り値[`wolfSSL_read`](group__IO.md#function-wolfssl_read)を監視し、バッファの内容を印刷する前にRecvline、Readデータの終わりに`\0`がマークされています。



```c
void
str_cli(FILE *fp, WOLFSSL* ssl)
{
    char  sendline[MAXLINE], recvline[MAXLINE];
    int   n=0;

    while (Fgets(sendline, MAXLINE, fp) != NULL) {

        if(wolfSSL_write(ssl, sendline, strlen(sendline)) !=
                     strlen(sendline)){
            err_sys("wolfSSL_write failed");
        }

        if ((n=wolfSSL_read(ssl, recvline, MAXLINE)) <= 0)
            err_quit("wolfSSL_read error");

        recvline[n]='\0';
        Fputs(recvline, stdout);
    }
}
```



最後に行うことは、WOLFSSL オブジェクトの使用が完全に終わったら、オブジェクトを解放することです。`main()`関数では、`WOLFSSL_CTX`を解放する前の行の直前に、[`wolfSSL_free()`](group__Setup.md#function-wolfssl_free)を呼び出します。



```c
str_cli(stdin, ssl);

wolfSSL_free(ssl);      /* Free WOLFSSL object */
wolfSSL_CTX_free(ctx);  /* Free WOLFSSL_CTX object */
wolfSSL_Cleanup();      /* Free wolfSSL */
```




### EchoServerで受信します



エコー サーバーは読み書きを処理するために `str_echo()` を呼び出します (一方、クライアントは `str_cli()` を呼び出します)。クライアントと同様に、sockfdパラメーターを関数シグネチャの`WOLFSSL`オブジェクト(`ssl`)パラメーターに置き換えて、`str_echo()`を変更します。



```c
void str_echo(WOLFSSL* ssl)
```



[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)および[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)関数の呼び出しに、`Read()`および`Writen()`への呼び出しを置き換えます。戻り値のエラーチェックを含む変更された`str_echo()`関数を以下に示します。`read()`から[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)への変更に対応するために、変数`n`のタイプは`ssize_t`から`int`に変更されたことに注意してください。



```c
void
str_echo(WOLFSSL* ssl)
{
    int n;
    char buf[MAXLINE];

    while ( (n=wolfSSL_read(ssl, buf, MAXLINE)) > 0) {
        if(wolfSSL_write(ssl, buf, n) != n) {
            err_sys("wolfSSL_write failed");
        }
    }

    if( n < 0 )
        printf("wolfSSL_read error=%d\n", wolfSSL_get_error(ssl,n));
    else if( n == 0 )
        printf("The peer has closed the connection.\n");
}
```



`main()`では、FORループの最後に`str_echo()`関数を呼び出します(whileループに変更されます)。この関数の後、ループ内で、`WOLFSSL`オブジェクトを解放してCONNFDソケットを閉じるように呼び出します。



```c
str_echo(ssl);                     /* process the request */

wolfSSL_free(ssl);                 /* Free WOLFSSL object */
Close(connfd);
```



呼び出しの前に`ctx`とクリーンアップを解放します。



## シグナル処理




### エコリエント /EchoServer



ecoclientおよびecheCoserverでは、「Ctrl+C」を使用してユーザーがアプリを閉じるときの信号ハンドラーを追加する必要があります。Echoサーバーは、ループで継続的に実行されています。このため、ユーザーが「Ctrl+C」を押すと、そのループを抜け出す方法を提供する必要があります。これを行うには、最初に行う必要があることは、exit変数(クリーンアップ)がtrueに設定されたときに終了する場合に、ループを時間ループに変更することです。


まず、`#include`ステートメントの直後に、`tcpserv04.c`の上部にあるクリーンアップという新しい静的INT変数を定義します。



```c
static int cleanup;  /* To handle shutdown */
```



EchoServerループをforループからしばらくのループに変更して、EchoServerループを変更します。



```c
while(cleanup != 1)
{
    /* echo server code here */
}
```



EchoServerの場合、ハンドラが終了した後に信号が処理される前に実行されていたコールの再起動からオペレーティングシステムを無効にする必要があります。これらを無効にすると、信号が処理された後、オペレーティングシステムは`accept()`への呼び出しを再開しません。これをしなかった場合は、EchoServerがリソースを整理して終了する前に、他のクライアントが接続して切断するのを待つ必要があります。シグナルハンドラを定義して`SA_RESTART`をオフにするには、最初にEchoServerの`main()`関数内のACTとOACT構造を定義します。



```c
struct sigaction     act, oact;
```



メイン関数の[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)への呼び出しの前に、変数宣言の後に次のコードを挿入します。



```c
/* Signal handling code */
struct sigaction act, oact;         /* Declare the sigaction structs    */
act.sa_handler=sig_handler;       /* Tell act to use sig_handler      */
sigemptyset(&act.sa_mask);          /* Tells act to exclude all sa_mask *
                                     * signals during execution of      *
                                     * sig_handler.                     */
act.sa_flags=0;                   /* States that act has a special    *
                                     * flag of 0                        */
sigaction(SIGINT, &act, &oact);     /* Tells the program to use (o)act  *
                                     * on a signal or interrupt         */
```



EchoserverのSig_Handler関数を以下に示します。



```c
void sig_handler(const int sig)
{
    printf("\nSIGINT handled.\n");
    cleanup=1;
    return;
}
```



それだけです - EchoClientとEchoServerは、TLSV1.2で有効になりました!!


我々のしたこと：



* wolfSSLのヘッダーをインクルードします


* wolfSSLを初期化します


* 使用したいプロトコルを選択した`WOLFSSL_CTX`構造を作成しました


* データの送信と受信に使用する`WOLFSSL`オブジェクトを作成しました


* [`wolfSSL_write()`](group__IO.md#function-wolfssl_write)および[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)に`Writen()`および`Readline()`に通話を置き換えました


* `WOLFSSL`及び`WOLFSSL_CTX`を開放します


* シグナルハンドラでクライアントとサーバーのシャットダウンを処理していることを確認してください



SSL接続の動作を設定および制御するための多くの局面や方法があります。詳細については、追加のwolfSSLのマニュアルとリソースを参照してください。


もう一度、完成したソースコードは、このセクションの上部にあるダウンロードしたZIPファイルにあります。



## 証明書



テストのために、wolfSSLが提供する証明書を使用できます。これらはwolfSSLのダウンロードに記載されており、特にこのチュートリアルについては、`finished_src`フォルダーにあります。


生産アプリケーションの場合、信頼できる証明書当局から正しい正当な証明書を取得する必要があります。



## 結論



このチュートリアルは、wolfSSL組み込みSLライブラリを簡単なクライアントおよびサーバーアプリケーションに統合するプロセスを進めました。この例は単純ですが、SSLまたはTLSを独自のアプリケーションに追加するために同じ原則を適用することができます。wolfSSL組み込みSSLライブラリは、サイズと速度の両方で最適化されたコンパクトで効率的なパッケージで必要なすべての機能を提供します。


GPLV2および標準的な商用ライセンスの下でデュアルライセンスを取得しているため、wolfSSLソースコードを当社のWebサイトから直接ダウンロードできます。サポートフォーラム(<https://www.wolfssl.com/forums>)にお気軽に投稿してください。当社の製品の詳細については、[info@wolfssl.com](mailto:info@wolfssl.com)にお問い合わせください。

このSSLチュートリアルにあるフィードバックを歓迎します。より便利、理解しやすい、またはよりポータブルにするために、改善または強化できると思われる場合は、[support@wolfssl.com](mailto:support@yassl.com)でお知らせください。
