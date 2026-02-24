# サンプルプログラム

# wolfSSL JNI サンプルプログラム

"examples"ディレクトリには、wolfSSL シン JNI ラッパーのサンプルプログラムが含まれています。 wolfSSL JSSE プロバイダーのサンプルプログラムは`./examples/provider` ディレクトリにあります。

サンプルプログラムは、パッケージのルート ディレクトリから、提供されたラッパー スクリプトを使用して実行する必要があります。 ラッパー スクリプトは、wolfssljni パッケージに含まれる wolfjni jar で使用するための正しい環境変数を設定します。

実装例をビルドして実行するには、以下を実行します。

```
$ ./java.sh
$ ant
$ ant examples
```

## デバッグとログに間する注意事項

実行時に `-Dwolfjsse.debug=true` を使用することで、wolfJSSE デバッグログ出力を有効にできます。

ネイティブ wolfSSL が `--enable-debug` でコンパイルされている場合、実行時に `-Dwolfssl.debug=true` を使用して wolfSSL ネイティブ デバッグログ出力を有効にできます。

`-Djavax.net.debug=all` オプションを使用して、JDK デバッグログ出力を有効にできます。



## wolfSSL JNI サンプルクライアントとサンプルサーバー

wolfSSL JNI を使用するクライアント/サーバー アプリケーションのサンプルプログラム:


**Server.java** - wolfSSL JNI サーバーサンプルプログラム<br>
**Client.java** - wolfSSL JNI クライアントサンプルプログラム

これらのサンプルプログラムは、提供されている bash スクリプトを使って実行できます：

```
$ cd <wolfssljni_root>
$ ./examples/server.sh <options>
$ ./examples/client.sh <options>
```
サンプルプログラムの使用方法と使用可能なオプションを表示するには、"-?" を指定します:

```
$ ./examples/server.sh --help
```

## SimpleThreadedClient.java and SimpleThreadedServer.java

マルチスレッドのJNIサーバ/クライアントのサンプルプログラム。

```
$ ./examples/SimpleThreadedServer.sh
$ ./examples/SimpleThreadedClient.sh
```

## X509v3CertificateGeneration.java

wolfSSL JNI `WolfSSLCertificate` APIを使用してX.509v3証明書を作成するサンプルプログラム。

```
$ ./examples/X509v3CertificateGeneration.sh
```

## X509CertRequest.java

wolfSSL JNI `WolfSSLCertRequest` APIを使用してX.509証明書発行要求(CSR)を作成するサンプルプログラム。

```
$ ./examples/X509CertRequest.sh
```

# wolfJSSE Provider サンプルプログラム

`examples/provider` ディレクトリには、wolfSSL JSSE プロバイダー (wolfJSSE) のサンプルプログラムが含まれています。

サンプルプログラムは、パッケージのルート ディレクトリから、提供されたラッパー スクリプトを使用して実行する必要があります。 ラッパー スクリプトは、wolfssljni パッケージに含まれる wolfJSSE プロバイダーで使用するための環境変数を正しく設定します。 たとえば、サンプルの JSSE サーバーとクライアントを実行するには、wolfSSL と wolfssljni をコンパイルした後:


```
$ cd <wolfssljni_root>
$ ./examples/provider/ServerJSSE.sh
$ ./examples/provider/ClientJSSE.sh
```

## wolfJSSE Example Client and Server

SSLSocket API とともに wolfJSSE を使用するクライアント/サーバー アプリケーションのサンプルプログラムです。

**ServerJSSE.java** - wolfJSSE サーバーサンプルプログラム<br>\
**ClientJSSE.java** - wolfJSSE クライアントサンプルプログラム

これらのサンプルプログラムは、提供されている bash スクリプトで実行できます：


```
$ ./examples/provider/ServerJSSE.sh <options>
$ ./examples/provider/ClientJSSE.sh <options>
```

## ClientSSLSocket.java

SSLSocket を使用した非常に最小限の JSSE クライアントのサンプルプログラムです。 ClientJSSE.java が行うすべてのオプションをサポートしているわけではありません。

使用例は次のとおりです：


```
$ ./examples/provider/ClientSSLSocket.sh [host] [port] [keystore] [truststore]
```
wolfSSL サンプル サーバーに接続するための使用例は次のとおりです:

```
$ ./examples/provider/ClientSSLSocket.sh 127.0.0.1 11111 \
  ./examples/provider/client.jks ./examples/provider/ca-server.jks
```

client.jksのパスワード は: "wolfSSL test"

## MultiThreadedSSLClient.java

指定された数のクライアントスレッドをサーバーに接続するマルチスレッド SSLSocket のサンプルプログラムです。 wolfJSSE を使用したマルチスレッドのテストを目的としています。

このサンプルプログラムでは、127.0.0.1:11118 にあるサーバーに対して、指定された数のクライアント スレッドを作成します。 このサンプルプログラムは、SSLSocket クラスを使用するように設定されています。 1 つの接続 (ハンドシェイク) を行い、データを送受信し、シャットダウンします。

次のハンドシェーク実行前に、ランダムな時間が各クライアント スレッドに挿入されます。

   1) SSL/TLS ハンドシェイク
   2) ハンドシェイク後に I/O 操作を行う

それぞれの最大スリープ時間は "maxSleep" で、デフォルトでは 3 秒です。 これは、クライアント スレッド操作にランダム性を追加することを目的としています。

使用例:

```
$ ant examples
$ ./examples/provider/MultiThreadedSSLClient.sh -n <num_client_threads>
```
このサンプルプログラムは、MultiThreadedSSLServer のサンプルプログラムに接続するように設計されています。


```
$ ./examples/provider/MultiThreadedSSLServer.sh
```
このサンプルプログラムでは、平均 SSL/TLS ハンドシェイク時間も出力されます。これは、"startHandshake()" API 呼び出しでミリ秒単位で測定されます。

## MultiThreadedSSLServer.java

クライアント接続ごとに新しいスレッドを作成する SSLServerSocket のサンプルプログラムです。

このサーバーはクライアント接続を無限ループで待機し、接続されると接続ごとに新しいスレッドを作成します。 このサンプルプログラムは、パッケージ ルートで"ant examples" を実行するとコンパイルされます。


```
$ ant examples
$ ./examples/provider/MultiThreadedSSLServer.sh
```
マルチスレッド クライアントのテストでは、MultiThreadedSSLClient.sh に対してテストします。
たとえば、10 個のクライアントスレッドを接続するには、次のようにします：


```
$ ./examples/provider/MultiThreadedSSLClient.sh -n 10
```

## ProviderTest.java

このサンプルプログラムでは、wolfSSL プロバイダーのインストールをテストします。 システムにインストールされているすべてのプロバイダーを一覧表示し、wolfSSL プロバイダーの検索を試み、見つかった場合は、wolfSSL プロバイダーに関する情報を出力します。 最後に、Java に TLS を提供するために登録されているプロバイダーをテストします。

このアプリは、wolfJSSE がシステムレベルで正しくインストールされているかどうかをテストするのに役立ちます。


```
$ ./examples/provider/ProviderTest.sh
```
wolfJSSE が OS システム レベルでインストールされていない場合、このサンプルプログラムを実行しても wolfJSSE はインストールされたプロバイダーとして表示されないことに注意してください。


## ThreadedSSLSocketClientServer.java

クライアント スレッドをサーバー スレッドに接続する SSLSocket のサンプルプログラム。

このサンプルプログラムでは、1 つのサーバースレッドと 1 つのクライアントスレッドの 2 つのスレッドを作成します。 サンプルプログラムは、SSLSocket および SSLServerSocket クラスを使用するように設定されています。 両スレッドで互いに通信に１つの接続 (ハンドシェイク) とシャットダウンを実行します。

使用例:

```
$ ./examples/provider/ThreadedSSLSocketClientServer.sh
```

## DtlsClientEngine.java and DtlsServerEngine.java

DTLS 1.3とSSLEngineを使用するクライアント/サーバアプリケーションのサンプルプログラム。

**DtlsServerEngine.java** - SSLEngineを使用するDTLS 1.3サーバの実装例
**DtlsClientEngine.java** - SSLEngineを使用するDTLS 1.3クライアントの実装例

これらの実装例では、データグラムベースのセキュア通信をSSLEngine/DTLS 1.3を使用して示しています。
TCPベースの実装と異なり、ここではUDPベースのデータ転送とDTLSの複雑さを吸収するため、DatagramSocketを使用しています。
また、セッションチケットやハンドシェイクステート管理にも対応しています。

Bashスクリプトによる実行例は次の通りです。

```
$ ./examples/provider/DtlsServerEngine.sh
$ ./examples/provider/DtlsClientEngine.sh
```

クライアントはサーバに接続し、メッセージを送信、サーバから送り返されたメッセージを受信します。
いずれの実装例においても、多数のコマンドライン引数をサポートしています。
詳細は`-?`フラグをつけて実行することで確認できます。

## Java Remote Method Invocation (RMI) の例

クライアントとサーバ、Java Remote Method Invocationのためのリモートインタフェースアプリケーションのサンプルプログラム。

**RmiServer.java** - サーバの実装例。`getMessage()`, `sendMessage()`, `getByteArray()`, `sendByteArray()`, `getRegistryPorts()`に対応した`RmiRemoteInterface`を実装。wolfJSSEを使用して、TLS/SSL上で1つ以上のRMIレジストリを作成。

**RmiClient.java** - クライアントの実装例。リモートリポジトリからオブジェクトスタブを取得し、 `getMessage()`, `sendMessage()`, `getByteArray()`, `sendByteArray()`, `getRegistryPorts()`を実行。 複数のクライアントによる接続に対応。

**RmiRemoteInterface.java** - サーバとクライアントの両者が使用するリモートインタフェースの定義

**RmiTLSClientSocketFactory.java** / **RmiTLSServerSocketFactory.java** - RMIのためのカスタムTLSソケット。wolfJSSEをSSL/TLS接続のもとで動作させるために使用。

サーバおよびクライアントを起動するには以下のようにします。

```
$ ./examples/provider/rmi/RmiServer.sh
$ ./examples/provider/rmi/RmiClient.sh
```
