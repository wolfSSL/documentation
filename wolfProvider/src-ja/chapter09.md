# オープンソース統合に関する注意事項

wolfProvider は、一般的な OpenSSL エンジン フレームワークとアーキテクチャに準拠しています。 そのため、OpenSSL を使用するアプリケーションから、OpenSSL 構成ファイルを介して、または PROVIDER API 呼び出しを介して他のエンジン実装と同様にwolfProviderをプログラムで利用することができます。

wolfSSL は、いくつかのオープン ソース プロジェクトで wolfProvider をテストしました。 この章には、wolfProvider 統合に関する注意事項とヒントが含まれています。 この章は、wolfProvider によるすべてのオープンソース プロジェクトのサポートを網羅しているわけではなく、wolfSSL またはコミュニティが追加のオープン ソース プロジェクトで wolfProvider をテストおよび使用することを報告するにつれて拡張されます。



## cURL

cURL は、OpenSSL 構成ファイルを利用するように既にセットアップされています。 wolfProvider を利用するには:

1. wolfProvider エンジン情報を OpenSSL 設定ファイルに追加します
2. 必要に応じて、OPENSSL_CONF 環境変数が OpenSSL 構成ファイルを指すように設定します：


```
$ export OPENSSL_CONF=/path/to/openssl.cnf
```
3. OPENSSL_PROVIDERS 環境変数を wolfProvider 共有ライブラリ ファイルの場所を指すように設定します:

```
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
## stunnel

stunnel は wolfProvider でテストされています。 ノートは近日公開予定。

## OpenSSH

OpenSSH は、`--with-ssl-provider` 構成オプションを使用して、OpenSSL エンジン サポートでコンパイルする必要があります。 必要に応じて、`--with-ssl-dir=DIR` を使用して、使用されている OpenSSL ライブラリのインストール場所を指定することもできます:

```
$ cd openssh
$ ./configure --prefix=/install/path --with-ssl-dir=/path/to/openssl/install
--with-ssl-provider
$ make
$ sudo make install
```

OpenSSH には、wolfProvider を活用するための OpenSSL 構成ファイルのセットアップも必要です。 必要に応じて、OPENSSL_CONF 環境変数を構成ファイルを指すように設定できます。 OPENSSL_PROVIDERS 環境変数も、wolfProvider 共有ライブラリの場所に設定する必要があります:


```
$ export OPENSSL_CONF=/path/to/openssl.cnf
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
