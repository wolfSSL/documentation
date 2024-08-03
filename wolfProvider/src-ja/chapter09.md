# その他のオープンソースソフトウェアとの統合に関する注意事項

wolfProviderは、一般的なOpenSSLエンジンフレームワークとアーキテクチャに準拠しています。
そのため、OpenSSLを使用するアプリケーションからOpenSSL構成ファイルを介して、または`PROVIDER` API呼び出しを介して、他のエンジン実装と同様にwolfProviderをプログラムで利用できます。

wolfSSLは、いくつかのオープンソースプロジェクトでwolfProviderをテストしました。
この章には、wolfProviderとのインテグレーションに関する注意事項とヒントを示します。
ただし、すべてのオープンソースプロジェクトを網羅しているわけではありません。
今後も随時、wolfSSLまたはコミュニティが追加のオープンソースプロジェクトでwolfProviderの動作を確認し追記します。

## cURL

cURLはすでにOpenSSL構成ファイルを利用するようにセットアップされています。
wolfProviderを利用するには、次のステップを実行してください。

1. wolfProviderエンジン情報をOpenSSL設定ファイルに追加します
2. 必要に応じて、`OPENSSL_CONF`環境変数がOpenSSL設定ファイルを指すように設定します


```
$ export OPENSSL_CONF=/path/to/openssl.cnf
```
3. `OPENSSL_PROVIDERS` 環境変数をwolfProvider共有ライブラリファイルの場所を指すように設定します

```
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
## stunnel

stunnelはwolfProviderでテスト済みです。 詳細は追って更新いたします。

## OpenSSH

OpenSSHは、`--with-ssl-provider`構成オプションを使用して、OpenSSLエンジンサポートでコンパイルする必要があります。
必要に応じて`--with-ssl-dir=DIR`を使用して、使用されているOpenSSLライブラリのインストール場所を指定することもできます。

```
$ cd openssh
$ ./configure --prefix=/install/path --with-ssl-dir=/path/to/openssl/install
--with-ssl-provider
$ make
$ sudo make install
```

OpenSSHには、wolfProviderを活用するためのOpenSSL構成ファイルのセットアップも必要です。
必要に応じて、`OPENSSL_CONF`環境変数を構成ファイルを指すように設定できます。 
`OPENSSL_PROVIDERS`環境変数も、wolfProvider共有ライブラリの場所に設定する必要があります。

```
$ export OPENSSL_CONF=/path/to/openssl.cnf
$ export OPENSSL_PROVIDERS=/path/to/wolfprovider/library/dir
```
