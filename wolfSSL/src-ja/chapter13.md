# OpenSSL互換性

## OpenSSLとの互換性

wolfSSLはwolfSSLネイティブAPIに加えて、OpenSSL互換性ヘッダー `wolfssl/openssl/ssl.h` を提供しています。
これを用いることで、既存のOpenSSLアプリケーションを簡単にwolfSSLに移植したり、移行したりすることができます。
OpenSSL互換性レイヤーの概要については、以下をご覧ください。
wolfSSLがサポートするOpenSSL関数の一覧は、`wolfssl/openssl/ssl.h`ファイルをご確認ください。

OpenSSL互換性レイヤーは、よく使用されるOpenSSLコマンドのサブセットをwolfSSLのネイティブAPI関数にマッピングします。
これにより、アプリケーションコードにわずかな変更を加えるだけで、OpenSSLをwolfSSLへ簡単に置き換えることができます。

私たちは、OpenSSL互換性のテストベッドとしてstunnelとLighttpdを使用しています。
これらを弊社でビルドして、OpenSSL互換APIが正しく機能するか検証しています。

互換性レイヤーを有効にしたwolfSSLのビルド手順。

1. `--enable-opensslextra`を有効化するか、マクロ`OPENSSL_EXTRA`を定義します。

    ```sh
    ./configure --enable-opensslextra
    ```
    
2. 最初のwolfSSLヘッダーとして`<wolfssl/options.h>`をインクルードします。
3. 移行用のヘッダーファイルは、以下の場所にあります。
   * `./wolfssl/openssl/*.h`
   * 例。`<wolfssl/openssl/ssl.h>`

## wolfSSLとOpenSSLの違い

wolfSSLとOpenSSLにはどのような違いがあるのか、組み込み向けに最適化されたTLSライブラリを使用することで、どのような利点がもたらされるのか、よくご質問をいただきます。
OpenSSLは確かに無料で使い始めることができますが、wolfSSLはより柔軟性が高く、既存のプラットフォームに容易にTLSなどの機能を統合できます。
このほか多くの最新アルゴリズムをサポートしており、以下に示すようなたくさんのメリットを、利用しやすいライセンスモデルでご提供しています。

ここでは、wolfSSLとOpenSSLの主な違いをいくつかご説明します。

1. wolfSSLのビルドサイズは概ね 20～100kB で、条件が揃えばOpenSSLの20分の1ほどの大きさになります。wolfSSLはリソースに制約の厳しい環境に適した選択肢です。

2. wolfSSLはDTLSを含むTLS 1.3の最新標準に対応しています。wolfSSLチームは、wolfSSLを常に最新の標準に更新し続けることに専念しています。

3. wolfSSLは、ストリーミングメディアサポート用の暗号を含め、今日利用可能な最高の暗号と標準を提供しています。さらに、liboqsの統合や各種の独自実装により、耐量子暗号アルゴリズムにも対応しています。

4. wolfSSLは、GPLv2のオープンソースライセンスと商用ライセンスのデュアルライセンスで提供していますが、OpenSSLは複数のソースに基づく独自のライセンスでのみ利用可能です。

5. wolfSSLは、ユーザーとその安全性を気にかけ、常に支援を惜しまない優れた企業によるサポートを提供しています。wolfSSLチームは主にモンタナ州ボーズマン、オレゴン州ポートランド、ワシントン州シアトルを拠点とし、その他世界中で多数のメンバーがwolfSSLの向上と拡張に積極的に取り組んでいます。

6. wolfSSLは、多様なプラットフォームサポートと組み込み環境での実装実績を有する、RTOS、モバイル、組み込みシステム向けの優れたSSL/TLSライブラリです。これらの領域ではほとんどのデバイスに対する移植が完了しています。もし実行できない環境がございましたら、気兼ねなくお知らせください。速やかに対応いたします。

7. wolfSSLは、プラットフォームへできるだけ簡単にSSL/TLSを統合するために、いくつかの抽象化レイヤーを提供しています。OSレイヤー、カスタムI/Oレイヤー、Cスタンダードライブラリ抽象化レイヤーにより、統合がこれまでになく簡単になりました。

8. wolfSSLは、複数のサポートパッケージを提供し、ユーザーに最適なものをお選びいただけるようにしています。
電話、メール、サポートフォーラムを通じてお問い合わせいただくことが可能です。ご質問には迅速かつ正確に回答し、プロジェクトをできるだけ早く進められるようお手伝いいたします。

## サポートしているOpenSSL構造体

* `SSL_METHOD` はSSLバージョン情報を保持し、クライアントメソッドかサーバーメソッドのいずれかです。
（ネイティブwolfSSL APIでの `WOLFSSL_METHOD` と同等）

* `SSL_CTX` は証明書を含むコンテキスト情報を保持します。
（ネイティブwolfSSL APIでの `WOLFSSL_CTX` と同等）

* `SSL` は安全な接続のためのセッション情報を保持します。
（ネイティブwolfSSL APIでの `WOLFSSL` と同等）

## サポートしているOpenSSL関数

上記の3つの構造体は通常、次のように初期化されます。

```c
SSL_METHOD* method = SSLv3_client_method();
SSL_CTX* ctx = SSL_CTX_new(method);
SSL* ssl = SSL_new(ctx);
```

このコードは、クライアント側SSLバージョン3メソッドを確立し、そのメソッドに基づいてコンテキストを作成し、コンテキストでSSLセッションを初期化します。

サーバー側のプログラムも同様ですが、`SSL_METHOD`は`SSLv3_server_method()`、または利用可能なその他の関数を使用して作成します。
サポートしている関数についての詳細は、[第4章 機能](chapter04.md)をご参照ください。
OpenSSL互換レイヤーを使用する場合、このセクションの関数は「wolf」プレフィックスを削除する必要があります。

例えば、次に示すネイティブwolfSSL API関数であれば、

```c
wolfTLSv1_client_method()
```

以下のように変更します。

```c
TLSv1_client_method()
```

SSL/TLS接続が不要となった場合、初期化中に作成された構造体を解放するために以下の関数を実行します。

```c
SSL_CTX_free(ctx);
SSL_free(ssl);
```

`SSL_CTX_free()`には、関連する`SSL_METHOD`を解放する追加の責任があります。
`XXX_free()`関数を使用しないと、リソースリークが発生します。
SSL/TLSのものではなくシステムの`free()`を使用すると、未定義の動作が発生します。
必ず上記のようにご使用ください。

アプリケーションが`SSL_new()`から有効なSSLポインタを取得すると、SSL/TLSハンドシェイクプロセスを開始できます。
クライアントからは、`SSL_connect()`が安全な接続の確立を試みます。

```c
SSL_set_fd(ssl, sockfd);
SSL_connect(ssl);
```

`SSL_connect()`を実行する前に、ユーザーはwolfSSLに有効なソケットファイルディスクリプタ（上の例ではsockfd）を提供する必要があります。
sockfdは通常、TCPの`socket()`関数の返り値として取得され、その後TCPの`connect()`を使用して確立されます。
以下は、ポート11111のローカルwolfSSLサーバーで使用するための、有効なクライアント側ソケット記述子を作成するサンプルコードです。
簡略化のために。エラー処理は省略しています。

```c
int sockfd = socket(AF_INET, SOCK_STREAM, 0);
sockaddr_in servaddr;
memset(&servaddr, 0, sizeof(servaddr));
servaddr.sin_family = AF_INET;
servaddr.sin_port = htons(11111);
servaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
connect(sockfd, (const sockaddr*)&servaddr, sizeof(servaddr));
```

接続が確立されると、クライアントはサーバーに対して読み書きができるようになります。
TCPの`send()`と`receive()`関数の代わりに、wolfSSLはSSL関数`SSL_write()`と`SSL_read()`を使用します。
以下はクライアントデモから抜粋した簡単なサンプルコードです。

```c
char msg[] = "hello wolfssl!";
int wrote = SSL_write(ssl, msg, sizeof(msg));
char reply[1024];
int read = SSL_read(ssl, reply, sizeof(reply));
reply[read] = 0;
printf("Server response: %s\n", reply);
```

サーバーも同様に接続しますが、TCP APIに類似して、`SSL_connect()`の代わりに`SSL_accept()`を使用します。

完全なサーバー/クライアントのサンプルプログラムについては、[第3章 入門](chapter03.md)をご参照ください。

## x509証明書

wolfSSLではサーバーとクライアントの両方で、**PEM**または**DER**形式の証明書を使用できます。

一般的な使用方法は次の通りです。

```c
SSL_CTX_use_certificate_file(ctx, "certs/cert.pem",
SSL_FILETYPE_PEM);
SSL_CTX_use_PrivateKey_file(ctx, "certs/key.der",
SSL_FILETYPE_ASN1);
```

鍵ファイルもどちらの形式でも使用できます。
`SSL_FILETYPE_PEM`はファイルがPEM形式であることを示し、`SSL_FILETYPE_ASN1`はファイルがDER形式であることを宣言します。
鍵ファイルが証明書での使用に適切であることを確認するために、次の関数を使用できます。

```c
SSL_CTX_check_private_key(ctx);
```
