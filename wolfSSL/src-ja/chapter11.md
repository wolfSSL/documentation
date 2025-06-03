# SSL/TLSチュートリアル

## はじめに

wolfSSL組み込みSSL/TLSライブラリは、SSLとTLSを用いて通信セキュリティを強化するために、既存のアプリケーションやデバイスに簡単に統合できます。
組み込みおよびRTOS環境を主な対象としており、優れたパフォーマンスを維持しながら最小限のフットプリントで動作します。
wolfSSLの最小ビルドサイズは、選択されたビルドオプションと使用されるプラットフォームに応じて20〜100kBの範囲です。

このチュートリアルの目的は、シンプルなアプリケーションへのSSLとTLSの統合を案内することです。
このチュートリアルを通じて、SSL/TLSについての理解も深まることを期待しています。
これからechoserverとechoclientという簡単な実装例を使用して、wolfSSLによりできるだけシンプルにアプリケーションにSSL/TLSサポートを追加する手順を示します。
echoserverとechoclientの実装例は、Richard Stevens、Bill Fenner、Andrew Rudoffによる書籍[UNIXネットワークプログラミング、第1版、第3版](http://www.unpbook.com/)を参考にしています。

このチュートリアルは、読者がGNU GCCコンパイラを使用したCコードの編集とコンパイルに慣れており、公開鍵暗号化の概念に精通していることを前提としています。
書籍「UNIXネットワークプログラミング」へのアクセスは必要ではありません。

### このチュートリアルで使用される例

* echoclient - 図5.4、124ページ
* echoserver - 図5.12、139ページ

## SSL/TLSの簡単な概要

**TLS**（Transport Layer Security）と**SSL**（Secure Sockets Layer）は、さまざまなトランスポートプロトコル間で安全な通信を可能にする暗号プロトコルです。
主に使用されるトランスポートプロトコルはTCP/IPです。
SSL/TLSの最新バージョンはTLS 1.3です。
wolfSSLはSSL 3.0、TLS 1.0、1.1、1.2、1.3に加えてDTLS 1.0、1.2、1.3をサポートしています。

SSLとTLSはOSI参照モデルのトランスポート層とアプリケーション層の間に位置し、任意のプロトコル（TCP/IP、Bluetoothなど）が下層のトランスポート媒体として機能します。
HTTPやFTP、SMTPなどのアプリケーションプロトコルは、SSLの上の層で構成されます。
SSL/TLSがOSIモデルにどのように適合するかの図と、SSL/TLSハンドシェイクプロセスの簡単な図は、[付録D SSL/TLSの概要](appendix04.md)にあります。

## ソースコードの入手

このチュートリアルで使用されるすべてのソースコードは、wolfSSLのウェブサイトからダウンロードできます。
このZIPファイルには、このチュートリアルで使用するechoserverとechoclientの両方のオリジナルコードと、完成されたソースコードが含まれています。

<https://www.wolfssl.com/documentation/ssl-tutorial-2.5.zip>


```text
/finished_src
    /certs  (Certificate files)
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

## 基本例の修正

このチュートリアルとそれに付随するソースコードは、さまざまなプラットフォームに容易に移植できるように設計されています。
そのため、またアプリケーションにSSLとTLSを追加する方法に焦点を当てるため、基本的な例はできるだけシンプルにしています。
不必要な複雑さを取り除く、または動作させるプラットフォームの範囲を広げるために、Unixネットワークプログラミングに掲載の実装例にいくつかの修正が加えられています。
このチュートリアルの移植性を高めるために何か他にできることがあると思われる場合は、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお知らせください。

以下は、上記の書籍に記載されているオリジナルのechoserverとechoclientの例に加えられた修正のリストです。

### echoserver (tcpserv04.c) への修正

* `fork()`関数の呼び出しを削除しました。これは`fork()`がWindowsでサポートされていないためです。その結果、echoserverは同時に1つのクライアントのみを受け入れます。この削除に伴い、シグナル処理も削除しました。
* `str_echo()`関数を`str_echo.c`ファイルから`tcpserv04.c`ファイルに移動しました
* クライアントのアドレスと接続ポートを表示するためにprintf文を追加しました。
    ```c
    printf("Connection from %s, port %d\n",
            inet_ntop(AF_INET, &cliaddr.sin_addr, buff, sizeof(buff)),
            ntohs(cliaddr.sin_port));
    ```
* リスニングソケットの作成後に「Address already in use」バインドエラーを排除するために、`setsockopt()`への呼び出しを追加しました。
* 新しいコンパイラの警告をクリーンアップするための軽微な調整を行いました。

### echoclient (tcpcli01.c) への修正

* `str_cli()`関数を`str_cli.c`ファイルから`tcpcli01.c`ファイルに移動しました。
* 新しいコンパイラの警告をクリーンアップするための軽微な調整を行いました。

### unp.hヘッダーへの修正

* このヘッダーは、この例に必要なもののみを含むように簡略化しました。

これらのソースコード例では、特定の関数が大文字になっていることに注意してください。
例えば、`Fputs()`や`Writen()`などです。
Unixネットワークプログラミングの著者たちは、エラーチェックを明確に処理するために、通常の関数のためのカスタムラッパー関数を書いています。
これについての詳細な説明は、_Unixネットワークプログラミング_の**セクション1.4**（11ページ）をご参照ください。

## wolfSSLのビルドとインストール

始める前に、上記の「ソースコードの入手」節を参照し、実装例のコード（`echoserver`と`echoclient`）をダウンロードしてください。
このセクションでは、wolfSSL組み込みSSL/TLSライブラリをシステムにダウンロード、設定、インストールする方法について説明します。

wolfSSLの最新バージョンをwolfSSLの[ダウンロードページ](https://www.wolfssl.jp/download/)からダウンロードしてインストールする必要があります。

利用可能なビルドオプションの完全なリストについては、[第2章 wolfSSLのビルド](chapter02.md)をご参照ください。
wolfSSLは移植性を念頭に置いて書かれており、ほとんどのシステムで簡単にビルドできるはずです。
wolfSSLのビルドに問題がある場合は、wolfSSLの[製品サポートフォーラム](https://www.wolfssl.com/forums)でサポートを求めるか、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお問い合わせください。。

Linux、\*BSD、OS X、Solaris、またはその他の \*nixライクなシステムでwolfSSLをビルドする場合、autoconfシステムを使用できます。
Windowsでの特定の指示については、wolfSSLマニュアルの[第2章 wolfSSLのビルド](chapter02.md)セクションをご参照ください。
wolfSSLを設定してビルドするには、ターミナルから次の2つのコマンドを実行します。
任意のビルドオプションを`./configure`に追加することもできます。

（例：`./configure -–enable-opensslextra`）

```sh
./configure
make
```

wolfSSLをインストールするには、以下を実行します。

```sh
sudo make install
```

これによりwolfSSLヘッダーが`/usr/local/include/wolfssl`に、wolfSSLライブラリが`/usr/local/lib`にインストールされます。
ビルドをテストするには、wolfSSLのルートディレクトリからテストスイートアプリケーションを実行します。

```sh
./testsuite/testsuite.test
```

wolfCryptとwolfSSLに対して一連のテストが実行され、正しくインストールされたかテストされます。
テストスイートアプリケーションを正常に実行できると、以下のような出力が表示されるはずです。

```text
------------------------------------------------------------------------------
 wolfSSL version 5.7.0
------------------------------------------------------------------------------
error    test passed!
MEMORY   test passed!
base64   test passed!
asn      test passed!
RANDOM   test passed!
MD5      test passed!
SHA      test passed!
SHA-224  test passed!
SHA-256  test passed!
SHA-384  test passed!
SHA-512  test passed!
SHA-512/224  test passed!
SHA-512/256  test passed!
SHA-3    test passed!
Hash     test passed!
HMAC-MD5 test passed!
HMAC-SHA test passed!
HMAC-SHA224 test passed!
HMAC-SHA256 test passed!
HMAC-SHA384 test passed!
HMAC-SHA512 test passed!
HMAC-SHA3   test passed!
HMAC-KDF    test passed!
PRF         test passed!
TLSv1.3 KDF test passed!
GMAC     test passed!
Chacha   test passed!
POLY1305 test passed!
ChaCha20-Poly1305 AEAD test passed!
AES      test passed!
AES192   test passed!
AES256   test passed!
AES-GCM  test passed!
RSA      test passed!
DH       test passed!
PWDBASED test passed!
ECC      test passed!
logging  test passed!
time     test passed!
mutex    test passed!
memcb    test passed!
Test complete

Running simple test
SSL version is TLSv1.2
SSL version is TLSv1.2
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
SSL cipher suite is TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
SSL curve name is SECP256R1
Client message: hello wolfssl!
I hear you fa shizzle!

Running TLS test
sending server shutdown command: quit!
client sent quit command: shutting down!
ciphers = TLS13-AES128-GCM-SHA256:TLS13-AES256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305-OLD:ECDHE-ECDSA-CHACHA20-POLY1305-OLD:DHE-RSA-CHACHA20-POLY1305-OLD
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  input
33bc1a4570f4f1abccd5c48aace529b01a42ab51293954a297796e90d20970f0  /var/folders/dy/888x7r7d6dgcqw4840l32tpw0000gp/T//testsuite-output-9Ymbuv

All tests passed!
```

wolfSSLがインストールされたので、実装例のコードにSSL/TLS機能を追加する修正を始めることができます。
まずechoclientにSSL/TLSを追加し、その後echoserverに進みます。

## 初回コンパイル

SSLチュートリアルのZIPファイルから実装例のechoclientとechoserverコードをコンパイルして実行するために、付属のMakefileを使用できます。
echoclientまたはechoserverディレクトリに移動（`cd`）して、次のコマンドを実行します。

```sh
make
```

これにより実装例のコードがコンパイルされ、ビルドされているものに応じてechoserverまたはechoclientという名前の実行可能ファイルが生成されます。
Makefileで使用されるGCCコマンドは以下の通りです。
提供されたMakefileを使用せずに実装例の1つをビルドする場合は、実装例のディレクトリに移動し、次のコマンドの`tcpcli01.c`（echoclient）または`tcpserv04.c`（echoserver）を正しいソースファイルに置き換えます。

```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include
```

これにより、現在の実装例が実行可能ファイルにコンパイルされ、「echoserver」または「echoclient」アプリケーションが作成されます。
コンパイル後に実装例の1つを実行するには、現在のディレクトリを目的の例のディレクトリに変更し、アプリケーションを起動します。
例えば、echoserverを起動するには次を使用します。

```sh
./echoserver
```

ローカルホストでechoclientをテストするために、2つ目のターミナルウィンドウを開きます。
アプリケーションを起動する際にはサーバーのIPアドレスを指定する必要があります。
今回の場合では、`127.0.0.1`を指定します。
現在のディレクトリを「echoclient」ディレクトリに変更(`cd`)し、次のコマンドを実行します。
なお、echoserverはすでに実行されている必要があります。

```sh
./echoclient 127.0.0.1
```

echoserverとechoclientの両方が実行されている場合、echoserverはechoclientから受け取った入力をエコーバックするはずです。
echoserverまたはechoclientを終了するには、_Ctrl + C_を使用します。
現在、これらの2つの実装例の間で行き来しているエコーデータは平文で送信されています。
わずかなスキルさえ持っていれば、誰でも簡単にクライアントとサーバーの間に介入して通信を傍受できてしまいます。

## ライブラリ

コンパイルされたwolfSSLライブラリは`libwolfssl`と名付けられます。
特に設定されていない限り、wolfSSLのビルドとインストールプロセスは、次のディレクトリの下に共有ライブラリのみを作成します。
適切なビルドオプションを使用して、共有ライブラリと静的ライブラリの両方を有効または無効にすることができます。

```sh
/usr/local/lib
```

私たちが最初に行う必要があるのは、wolfSSLライブラリを私たちの実装例のアプリケーションにリンクすることです。
GCCコマンドを修正（echoserverを例として使用）して、次の新しいコマンドを参照してください。
wolfSSLはヘッダーファイルとライブラリを標準的な場所にインストールするため、コンパイラは明示的な指示（`-l`または`-L`を使用）なしにそれらを見つけることができるはずです。
`-lwolfssl`を使用することにより、コンパイラは自動的に正しいタイプのライブラリ（静的または共有）を選択します。

```sh
gcc -o echoserver ../lib/*.c tcpserv04.c -I ../include -lm -lwolfssl
```

## ヘッダー

最初に行う必要があるのは、クライアントとサーバーの両方にwolfSSLネイティブAPIヘッダーを含めることです。
クライアントの`tcpcli01.c`ファイルとサーバーの`tcpserv04.c`ファイルの上部に次の行を追加します。

```c
#include <wolfssl/ssl.h>
```

## 起動/シャットダウン

コード内でwolfSSLを使用する前に、ライブラリと`WOLFSSL_CTX`を初期化する必要があります。
wolfSSLは[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)を呼び出すことによって初期化されます。
これはライブラリを使用して他のことを行う前に、必ず実行する必要があります。

## WOLFSSL_CTXファクトリ

`WOLFSSL_CTX`構造体（wolfSSL Context）には、証明書情報を含む各SSL/TLS接続のグローバルな値が含まれます。
単一の`WOLFSSL_CTX`は、作成された任意の数の`WOLFSSL`オブジェクトで使用できます。
これにより、信頼されたCA証明書のリストなどの特定の情報を、一度だけロードして使用できます。

新しい`WOLFSSL_CTX`を作成するには、[`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)を使用します。
この関数は、クライアントまたはサーバーが使用するSSL/TLSプロトコルを定義する引数を必要とします。
目的のプロトコルを選択するためのいくつかのオプションがあります。
wolfSSLは現在、SSL 3.0、TLS 1.0、TLS 1.1、TLS 1.2、TLS 1.3、DTLS 1.0、DTLS 1.2、DTLS 1.3をサポートしています。
これらの各プロトコルには、[`wolfSSL_CTX_new()`](group__Setup.md#function-wolfssl_ctx_new)の引数として使用できる対応する関数があります。
使用可能なクライアントとサーバーのプロトコルオプションを以下に示します。
SSL 2.0は数年間不安定であるため、wolfSSLではサポートしていません。

EchoClient:

* [`wolfSSLv3_client_method();`](group__Setup.md#function-wolfsslv3_client_method) - SSL 3.0
* [`wolfTLSv1_client_method();`](group__Setup.md#function-wolftlsv1_client_method) - TLS 1.0
* [`wolfTLSv1_1_client_method();`](group__Setup.md#function-wolftlsv1_1_client_method) - TLS 1.1
* [`wolfTLSv1_2_client_method();`](group__Setup.md#function-wolftlsv1_2_client_method) - TLS 1.2
* [`wolfTLSv1_3_client_method();`](group__Setup.md#function-wolftlsv1_3_client_method) - TLS 1.3
* [`wolfSSLv23_client_method();`](group__Setup.md#function-wolfsslv23_client_method) - SSL 3.0からTLS 1.3までの最高バージョンを使用
* [`wolfDTLSv1_client_method();`](group__Setup.md#function-wolfdtlsv1_client_method) - DTLS 1.0
* [`wolfDTLSv1_2_client_method_ex();`](ssl_8h.md#function-wolfdtlsv1_2_client_method_ex) - DTLS 1.2
* [`wolfDTLSv1_3_client_method_ex();`](ssl_8h.md#function-wolfdtlsv1_3_client_method_ex) - DTLS 1.3

EchoServer:

* [`wolfSSLv3_server_method();`](group__Setup.md#function-wolfsslv3_server_method) - SSL 3.0
* [`wolfTLSv1_server_method();`](group__Setup.md#function-wolftlsv1_server_method) - TLS 1.0
* [`wolfTLSv1_1_server_method();`](group__Setup.md#function-wolftlsv1_1_server_method) - TLS 1.1
* [`wolfTLSv1_2_server_method();`](group__Setup.md#function-wolftlsv1_2_server_method) - TLS 1.2
* [`wolfTLSv1_3_server_method();`](group__Setup.md#function-wolftlsv1_3_server_method) - TLS 1.3
* [`wolfSSLv23_server_method();`](group__Setup.md#function-wolfsslv23_server_method) - クライアントがTLS 1.0+で接続するのを許可
* [`wolfDTLSv1_server_method();`](group__Setup.md#function-wolfdtlsv1_server_method) - DTLS 1.0
* [`wolfDTLSv1_2_server_method();`](ssl_8h.md#function-wolfdtlsv1_2_server_method) - DTLS 1.2
* [`wolfDTLSv1_3_server_method();`](ssl_8h.md#function-wolfdtlsv1_3_server_method) - DTLS 1.3

echoclientがechoserverに接続するとき、サーバーの識別情報を確認できるように、CA（認証局）証明書を`WOLFSSL_CTX`にロードする必要があります。
`WOLFSSL_CTX`にCA証明書をロードするには、[`wolfSSL_CTX_load_verify_locations()`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)を使用します。
この関数は、`WOLFSSL_CTX`ポインタ、証明書ファイル、パス値の3つの引数を必要とします。
パス値はPEM形式のCA証明書を含むべきディレクトリを指します。
証明書を検索するとき、wolfSSLはパスの場所を見る前に証明書ファイルの値を調べます。
この場合、1つのCAファイルを指定するためパスを指定する必要はありません。
したがって、パス引数には0を使用します。
[`wolfSSL_CTX_load_verify_locations`](group__CertsKeys.md#function-wolfssl_ctx_load_verify_locations)関数は`SSL_SUCCESS`または`SSL_FAILURE`のいずれかを返します。

```c
wolfSSL_CTX_load_verify_locations(WOLFSSL_CTX* ctx, const char* file, const char* path)
```

これらのことをまとめると（ライブラリの初期化、プロトコルの選択、CA証明書）、次のようになります。
ここでは、TLS 1.2を使用することにします。

EchoClient:

```c
WOLFSSL_CTX* ctx;

wolfSSL_Init();/* Initialize wolfSSL */

/* Create the WOLFSSL_CTX */
if ( (ctx = wolfSSL_CTX_new(wolfTLSv1_2_client_method())) == NULL) {
    fprintf(stderr, "wolfSSL_CTX_new error.\n");
    exit(EXIT_FAILURE);
}

/* Load CA certificates into WOLFSSL_CTX */
if (wolfSSL_CTX_load_verify_locations(ctx,"../certs/ca-cert.pem",0) !=
    SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/ca-cert.pem, please check"
        "the file.\n");
    exit(EXIT_FAILURE);
}
```

上記のコードを`tcpcli01.c`の`main()`内の、「ユーザーが引数としてIPアドレスを渡してクライアントを起動したかのチェック」の後に追加します。

EchoServer:

`WOLFSSL_CTX`に証明書をロードする場合、CA証明書に加えてサーバー証明書と鍵ファイルをロードする必要があります。
これにより、サーバーはクライアントに識別情報確認のための証明書を送信できるようになります。

```c
WOLFSSL_CTX* ctx;

wolfSSL_Init();  /* Initialize wolfSSL */

/* Create the WOLFSSL_CTX */
if ( (ctx = wolfSSL_CTX_new(wolfTLSv1_2_server_method())) == NULL) {
    fprintf(stderr, "wolfSSL_CTX_new error.\n");
    exit(EXIT_FAILURE);
}

/* Load CA certificates into WOLFSSL_CTX */
if (wolfSSL_CTX_load_verify_locations(ctx, "../certs/ca-cert.pem", 0) !=
         SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/ca-cert.pem, "
        "please check the file.\n");
    exit(EXIT_FAILURE);
}

/* Load server certificates into WOLFSSL_CTX */
if (wolfSSL_CTX_use_certificate_file(ctx,"../certs/server-cert.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/server-cert.pem, please"
        "check the file.\n");
    exit(EXIT_FAILURE);
}

/* Load keys */
if (wolfSSL_CTX_use_PrivateKey_file(ctx,"../certs/server-key.pem",
        SSL_FILETYPE_PEM) != SSL_SUCCESS) {
    fprintf(stderr, "Error loading ../certs/server-key.pem, please check"
        "the file.\n");
    exit(EXIT_FAILURE);
}
```

上記のコードは、`tcpserv04.c`の変数定義の後の`main()`の先頭に追加する必要があります。
完成したバージョンのコードは、SSLチュートリアルのZIPファイルに含まれています。
必要に応じて参照してください。

wolfSSLと`WOLFSSL_CTX`が初期化されたら、アプリケーションがSSL/TLSの使用を完全に終了したときに`WOLFSSL_CTX`オブジェクトとwolfSSLライブラリが解放されるようにしてください。
クライアントとサーバーの両方で、以下の2行を`main()`関数の最後（クライアントでは`exit()`の呼び出しの直前）に配置する必要があります。

```c
wolfSSL_CTX_free(ctx);
wolfSSL_Cleanup();
```

## WOLFSSLオブジェクト

### EchoClient

TCP接続の後に`WOLFSSL`オブジェクトを作成し、ソケットファイルディスクリプタをセッションに関連付ける必要があります。
echoclientの実装例では、以下に示す`Connect()`の呼び出しの後にこれを行います。

```c
/* Connect to socket file descriptor */
Connect(sockfd, (SA *) &servaddr, sizeof(servaddr));
```

接続直後に、[`wolfSSL_new()`](group__Setup.md#function-wolfssl_new)関数を使用して新しい`WOLFSSL`オブジェクトを作成します。
この関数は成功した場合は`WOLFSSL`オブジェクトへのポインタを返し、失敗した場合は`NULL`を返します。
その後、ソケットファイルディスクリプタ（`sockfd`）を新しい`WOLFSSL`オブジェクト（`ssl`）に関連付けることができます。

```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if( (ssl = wolfSSL_new(ctx)) == NULL) {
    fprintf(stderr, "wolfSSL_new error.\n");
    exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, sockfd);
```

ここで注目すべき点は、[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)関数を呼び出していないことです。
[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)はサーバーとのSSL/TLSハンドシェイクを開始し、以前に呼び出されていなかった場合は[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)中に呼び出されます。
今回、明示的に[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)を呼び出すのではなく、最初の[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)にそれを行わせています。

### EchoServer

mainメソッドのforループの最後で`WOLFSSL`オブジェクトを挿入し、ソケットファイルディスクリプタ（`connfd`）を`WOLFSSL`オブジェクト（`ssl`）に関連付けます。

```c
/* Create WOLFSSL object */
WOLFSSL* ssl;

if ( (ssl = wolfSSL_new(ctx)) == NULL) {
            fprintf(stderr, "wolfSSL_new error.\n");
            exit(EXIT_FAILURE);
}

wolfSSL_set_fd(ssl, connfd);
```

繰り返しになりますが、TCP接続の後に`WOLFSSL`オブジェクトを作成し、ソケットファイルディスクリプタをセッションに関連付ける必要があります。

## データの送受信

### EchoClientでの送信

次のステップは、データを安全に送信し始めることです。
echoclientの例では、`main()`関数が送受信処理を`str_cli()`に渡していることに注意してください。
`str_cli()`関数は、私たちの関数で置き換えるところです。
まず、`str_cli()`関数で`WOLFSSL`オブジェクトにアクセスする必要があるため、引数を追加して`ssl`変数を`str_cli()`に渡します。
`WOLFSSL`オブジェクトが`str_cli()`関数内で使用されるようになるため、`sockfd`パラメータを削除します。
この修正を行った新しい`str_cli()`関数のプロトタイプを以下に示します。

```c
void str_cli(FILE *fp, WOLFSSL* ssl)
```

`main()`関数では、新しい引数（`ssl`）が`str_cli()`に渡されます。

```c
str_cli(stdin, ssl);
```

`str_cli()`関数内では、`Writen()`と`Readline()`を[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)と[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)関数の呼び出しに置き換え、元のソケットファイルディスクリプタ（`sockfd`）の代わりに`WOLFSSL`オブジェクト（`ssl`）を使用します。

新しい`str_cli()`関数を以下に示します。
[`wolfSSL_write`](group__IO.md#function-wolfssl_write)と[`wolfSSL_read`](group__IO.md#function-wolfssl_read)の呼び出しが成功したかどうかを確認する必要があることに注意してください。

Unixプログラミングの著者たちは、`Writen()`関数にエラーチェックを組み込んでいたため、それが置き換えられた後にその分を補う必要があります。
新しいint変数`n`を追加して[`wolfSSL_read`](group__IO.md#function-wolfssl_read)の戻り値を監視し、バッファの内容`recvline`を出力する前に、読み込んだデータの末尾を`\0`でマークします。

```c
void
str_cli(FILE *fp, WOLFSSL* ssl)
{
    char  sendline[MAXLINE], recvline[MAXLINE];
    int   n = 0;

    while (Fgets(sendline, MAXLINE, fp) != NULL) {

        if(wolfSSL_write(ssl, sendline, strlen(sendline)) !=
                     strlen(sendline)){
            err_sys("wolfSSL_write failed");
        }

        if ((n = wolfSSL_read(ssl, recvline, MAXLINE)) <= 0)
            err_quit("wolfSSL_read error");

        recvline[n] = '\0';
        Fputs(recvline, stdout);
    }
}
```

最後に行うことは、完全に終了するときに`WOLFSSL`オブジェクトを解放することです。
`main()`関数内の`WOLFSSL_CTX`を解放する行の直前に、[`wolfSSL_free()`](group__Setup.md#function-wolfssl_free)を呼び出します。

```c
str_cli(stdin, ssl);

wolfSSL_free(ssl);      /* Free WOLFSSL object */
wolfSSL_CTX_free(ctx);  /* Free WOLFSSL_CTX object */
wolfSSL_Cleanup();      /* Free wolfSSL */
```

### EchoServerでの受信

エコーサーバーは読み取りと書き込みを処理するために`str_echo()`を呼び出します。
（クライアントでは`str_cli()`を呼び出しました。）
クライアントと同様に、sockfdパラメータを`WOLFSSL`オブジェクト（`ssl`）パラメータに置き換えて`str_echo()`を修正します。

```c
void str_echo(WOLFSSL* ssl)
```

`Read()`と`Writen()`の呼び出しを[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)と[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)関数への呼び出しに置き換えます。
戻り値のエラーチェックを含む、修正された`str_echo()`関数を以下に示します。
`read()`から[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)への変更に対応するため、変数`n`のタイプが`ssize_t`から`int`に変更されていることに注意してください。

```c
void
str_echo(WOLFSSL* ssl)
{
    int n;
    char buf[MAXLINE];

    while ( (n = wolfSSL_read(ssl, buf, MAXLINE)) > 0) {
        if(wolfSSL_write(ssl, buf, n) != n) {
            err_sys("wolfSSL_write failed");
        }
    }

    if( n < 0 )
        printf("wolfSSL_read error = %d\n", wolfSSL_get_error(ssl,n));
    else if( n == 0 )
        printf("The peer has closed the connection.\n");
}
```

`main()`でforループ（すぐにwhileループに変更される）の最後に`str_echo()`関数を呼び出します。
この関数の後、ループ内で`WOLFSSL`オブジェクトを解放し`connfd`ソケットを閉じる呼び出しを行います。

```c
str_echo(ssl);                     /* process the request */

wolfSSL_free(ssl);                 /* Free WOLFSSL object */
Close(connfd);
```

exitの呼び出しの前に、必ず`ctx`を解放してクリーンアップします。

## シグナル処理

### Echoclient / Echoserver

echoclientとechoserverでは、ユーザーが「Ctrl+C」を使用してアプリを閉じる場合のシグナルハンドラを追加する必要があります。
エコーサーバーは継続的にループで実行されています。
このため、ユーザーが「Ctrl+C」を押したときにそのループを中断する手段を実装する必要があります。
これを行うにはまず、終了変数（`cleanup`）が`true`に設定されたときに終了するwhileループに変更する必要があります。

`tcpserv04.c`の`#include`文の直後に、`cleanup`という新しいstatic int変数を定義します。

```c
static int cleanup;  /* To handle shutdown */
```

echoserverループをforループからwhileループに変更します。

```c
while(cleanup != 1)
{
    /* echo server code here */
}
```

echoserverではハンドラが終了した後、シグナルが処理される前に実行していた呼び出しをOSが再開してしまわないようにする必要があります。
これを無効にすることで、シグナルが処理された後、OSは`accept()`への呼び出しを再開しません。
これを行わなければ、echoserverがリソースをクリーンアップして終了する前に、別のクライアントが接続してしまい、これを切断するのを待たなければならなくなってしまいます。
シグナルハンドラを定義し`SA_RESTART`をオフにするには、まずechoserverの`main()`関数に`act`と`oact`の構造体を定義します。

```c
struct sigaction     act, oact;
```

変数宣言の後、main関数の[`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init)の呼び出しの前に以下のコードを挿入します。

```c
/* Signal handling code */
struct sigaction act, oact;         /* Declare the sigaction structs    */
act.sa_handler = sig_handler;       /* Tell act to use sig_handler      */
sigemptyset(&act.sa_mask);          /* Tells act to exclude all sa_mask *
                                     * signals during execution of      *
                                     * sig_handler.                     */
act.sa_flags = 0;                   /* States that act has a special    *
                                     * flag of 0                        */
sigaction(SIGINT, &act, &oact);     /* Tells the program to use (o)act  *
                                     * on a signal or interrupt         */
```

echoserverの`sig_handler`関数を以下に示します。

```c
void sig_handler(const int sig)
{
    printf("\nSIGINT handled.\n");
    cleanup = 1;
    return;
}
```

以上で、echoclientとechoserverでTLSv1.2が有効になりました。

私たちが行ったことは、以下のとおりです。

* wolfSSLヘッダーをインクルード
* wolfSSLを初期化
* 使用したいプロトコルを選択した`WOLFSSL_CTX`構造体を作成
* データの送受信に使用する`WOLFSSL`オブジェクトを作成
* `Writen()`と`Readline()`の呼び出しを[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)と[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)に置き換え
* `WOLFSSL`、`WOLFSSL_CTX`を解放
* シグナルハンドラでクライアントとサーバーのシャットダウンを確実に処理

SSL接続の動作を設定および制御するための多くの側面とメソッドがあります。
より詳細な情報については、wolfSSLドキュメントをご参照ください。

繰り返しになりますが、完成したソースコードはこのセクションの先頭でダウンロードしたZIPファイルにあります。

## 証明書

テスト目的では、wolfSSLが提供する証明書を使用できます。
これらはwolfSSLのダウンロードに含まれており、特にこのチュートリアルでは、`finished_src`フォルダで見つけることができます。

本番アプリケーションでは、信頼できる認証局から正確で正当な証明書を取得する必要があります。

## まとめ

このチュートリアルでは、wolfSSL組み込みSSL/TLSライブラリを、簡単なクライアントとサーバーアプリケーションに統合するプロセスを説明しました。
この例はシンプルですが、ご自身のアプリケーションにSSL/TLSを追加するために同じ手順を適用できます。
wolfSSL組み込みSSL/TLSライブラリは、サイズと速度の両方に最適化されたコンパクトで効率的なパッケージで、必要とするすべての機能を提供します。

GPLv2と標準的な商用ライセンスのデュアルライセンスで提供しているため、ウェブサイトから直接wolfSSLのソースコードをダウンロードできます。
質問やコメントがあれば、サポートフォーラム（<https://www.wolfssl.com/forums>）に投稿してください。
製品についての詳細情報が必要な場合は、[info@wolfssl.jp](mailto:info@wolfssl.jp)までお問い合わせください。

このSSL/TLSチュートリアルに関するフィードバックを歓迎します。
より有用にしたり、理解しやすくしたり、移植性を高めるために改善や強化できると思われる場合は、[support@wolfssl.com](mailto:support@wolfssl.com)までお知らせください。
