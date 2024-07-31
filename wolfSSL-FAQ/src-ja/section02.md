# よくあるご質問

## wolfSSLのビルド構成を管理するにはどうすればよいですか？

よくある問題は、アプリケーションとライブラリ間の設定ミスです。
wolfSSLライブラリをアプリケーションとは独立してコンパイルする場合、アプリケーションにもライブラリで使用したのと同じ設定オプションを含める必要があります。

`./configure`でビルドする場合、ビルドシステムはアプリケーションに必要な設定を含むファイル `<wolf-root>/wolfssl/options.h` を生成します。
次の行を追加してください：

```
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/ssl.h>
/* これ以外のwolfSSL関連ヘッダは以下に追加 */
```

wolfSSLのソースを直接ビルドする場合、options.hには生成された構成が含まれません。
その場合、推奨されるオプションはプロジェクト内でプリプロセッサマクロ`WOLFSSL_USER_SETTINGS`を定義し、独自の`user_settings.h`ファイルを作成することです。
このファイルがインクルードパスにあることを確認してください。
上記と同じインクルードパターンを使用できますが、`options.h`を除外します。

リファレンスとして`user_settings.h`の例を以下で提供しています：

* Windows: /IDE/WIN/user_settings.h
* GCC ARM: /IDE/GCC-ARM/Header/user_settings.h
* NXP ARM: /IDE/ROWLEY-CROSSWORKS-ARM/user_settings.h
* Xcode: /IDE/XCODE/user_settings.h

## SSL/TLSサーバーを認証するためにクライアントにロードする正しいCA証明書を見つけるにはどうすればよいですか？

クライアントアプリケーションやデバイスに正しいCA（ルート）証明書を見つけてロードする方法は、最初はトリッキーに感じるかもしれません。
まず、ユーザーはwolfSSLが証明書チェーンをどのように検証するかを理解する必要があります。
[wolfSSLマニュアル](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/) の [セクション7.3](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/chapter07.html#_7) では、wolfSSLの証明書検証プロセスについて説明しています：

wolfSSLはサーバーが完全なチェーンを送信する限り、チェーン内のトップまたは **「ルート」** 証明書だけを信頼できる証明書としてロードする必要があります。
つまり、証明書チェーン（ **A** -> **B** -> **C** ）があり、CがBによって署名され、BがAによって署名されている場合、
wolfSSLは **証明書A** を信頼できる証明書としてロードするだけで、サーバーが（B -> C）をハンドシェイクで送信すればチェーン全体（A->B->C）を検証できます。

簡単な例を見てみましょう。サーバー証明書チェーンが次のようになっているとします：

```
A
| ---- > B
       | ---- > C
```

wolfSSLクライアントは、信頼できるルートとして少なくともルート **cert “A”** をすでにロードしている必要があります（wolfSSL_CTX_load_verify_[ locations | buffer]）。
クライアントがサーバー証明書チェーン（B -> C）を受信すると、検証証明書（A）を使用してBを検証し、BがwolfSSLに信頼できるルートとして以前にロードされていない場合、BはwolfSSLの内部証明書チェーンに保存されます。
Bが正常に検証されると、Cの検証に使用できます。

このモデルに従うと、ルート証明書「A」がwolfSSLクライアントに信頼できるルートとしてロードされていれば、サーバー証明書チェーンは（A->B->C）または（B->C）をサーバーが送信する限り、検証できます。
サーバーが（C）のみを送信し、中間証明書を送信しない場合、wolfSSLクライアントがすでにAおよびBを信頼できるルートとしてロードしていない限り、チェーンは検証できません。
必要なすべての信頼できるルートをロードするために、wolfSSL_CTX_load_verify_[ locations | buffer]を必要な回数だけ呼び出すことができます。
wolfSSLはそれらを信頼ストアに追加し続けます。

例：

```
// PEM形式のファイルをロード：
wolfSSL_CTX_load_verify_locations(ctx, fileName, NULL);

// DER形式のファイルをロード：
wolfSSL_CTX_der_load_verify_locations(ctx, fileName, WOLFSSL_FILETYPE_ASN1);

// DER形式のバッファをロード：
wolfSSL_CTX_load_verify_buffer(ctx, buf, bufLength, WOLFSSL_FILETYPE_ASN1)

// ディレクトリ内のすべてのPEMファイルをロード
wolfSSL_CTX_load_verify_locations(ctx, NULL, directoryName);
```

## 証明書をバッファに入れるにはどうすればよいですか？

証明書バッファを生成するには、`<wolfssl-root>/gencertbuf.pl`（証明書バッファ生成スクリプト）というperlスクリプトを使用します。

1. 自分の証明書を取得し、必要に応じた場所に配置します（私たちはテスト用の証明書を `<wolfssl-root>/certs/` ディレクトリに置いています。お客様の有効な証明書をそこに置いても構いません）。
2. 上記のperlスクリプトを変更し、新しい証明書を適切な `@fileList` に追加します（1024ビットRSA証明書の場合は1024、ECC 256ビット証明書の場合は256など）。
3. スクリプトを再実行して、ヘッダーファイル `<wolfssl-root>/wolfssl/certs_test.h` を再生成します。

このファイルを手動で実行する必要があります。例えば、`perl gencertbuf.pl` または `./gencertbuf.pl` で実行できます。

## wolfSSLはどれくらいのFlash/RAMを使用しますか？

wolfSSLのメモリ使用量は、ライブラリのコンパイル時の構成および使用予定の機能によって異なります。
ライブラリのメモリ使用量を制御するための多くのオプションがあります。
wolfSSLのリソース使用文書については、 [お問い合わせ](mailto:info@wolfssl.jp) ください。

ピークリソース使用量の主な要因は、鍵サイズと使用する数学ライブラリです。
高速な数学演算および大きな鍵サイズはリソース利用を増加させます。

## wolfSSLおよび/またはwolfCryptで動的メモリを使用しないことは可能ですか？

wolfSSLは、動的メモリの使用を制御するための2つの相互排他的なオプションを提供します。
wolfSSLを `--enable-staticmemory` で構成するか、WOLFSSL_STATIC_MEMORYマクロを定義することで実現できます。
ただし、この機能は基本的なTLS接続に限定されており、現在のところwolfCryptではサポートされていません。
さらに、 `XMALLOC_USER` マクロを定義して、wolfSSLが独自のmalloc関数を使用するようにすることもできます。

## wolfSSLをUNIX, Windows, 組み込みデバイスなどでビルドするにはどうすればよいですか？

wolfSSLのビルドに関する情報は、 [wolfSSLマニュアル](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/chapter02.html) のセクション2をご覧ください。

## wolfSSLをIDEプロジェクトに取り込むにはどうすればよいですか？必要なファイルとヘッダーは何ですか？

wolfSSLは多くの人気のあるIDEに必要なプロジェクトファイルを提供しています。
これらのIDEに関する説明は、wolfSSLソースの `/IDE/` ディレクトリにあります。

src/*.c
wolfcrypt/src/*.c
wolfssl/*.h
wolfssl/wolfcrypt/*.h
Include path wolfssl root.

さまざまなプラットフォームでwolfSSLをビルドするための詳細な文書は、[wolfSSLマニュアル](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html)セクション2.4をご覧ください。

## 私の特定のプラットフォーム向けのベンチマークはありますか？

wolfSSLは、サポートしているすべてのプラットフォームでコンパイル可能なベンチマークアプリケーションを提供しています。
このベンチマークアプリケーションは、有効になっているアルゴリズムのベンチマークを実行します。
アプリケーションのソースは、`wolfcrypt/benchmark/benchmark.c`にあります。
*nixプラットフォームでは、`./wolfcrypt/benchmark/benchmark`を使用してベンチマークを実行できます。
ベンチマークアプリケーションはデフォルトでコンパイルされます。

組み込みプラットフォームでベンチマークを行う場合は、`BENCH_EMBEDDED` を定義してください。

wolfSSLのベンチマークに関する詳細については、[こちらのウェブページ(英語)](https://www.wolfssl.com/docs/benchmarks/)をご覧ください。

## クライアント/サーバー間の接続時に共通の暗号スイートが見つからないのはなぜですか？

クライアントとサーバーの両方で共通の暗号スイートが設定およびビルドされていることを確認してください。
追加の暗号スイートを設定オプションで追加できます。
*nixシステムでは、`./configure --help` を使用して設定オプションを表示できます。

*nixシステムでデフォルトの暗号スイートを表示するには、 `<wolfssl-root>` ディレクトリから次のコマンドを使用します：

`./examples/client/client -e`

Windowsシステムでデフォルトの暗号スイートを表示するには、client.exeがあるディレクトリから次のコマンドを使用します：

`./client.exe -e`

```
nmap --script ssl-enum-ciphers -p 443 www.google.com
```

## 最大I/Oレコードサイズを16kBより小さくすることはできますか？

TLSは固定の最大レコード長を2^14バイト（約16kB）に指定しています。
wolfSSLは、より小さい最大レコードサイズを使用するための2つのオプションを提供します。
1つ目のオプションは、`--enable-maxfragment` でwolfSSLを構成することです。
これには、サーバーに接続するときにクライアントが追加の呼び出しを行う必要があります。
クライアントは、`wolfSSL_CTX_UseMaxFragment` または `wolfSSL_UseMaxFragment` のいずれかを使用する必要があります。
同じサーバーに複数回接続する場合、クライアントはCTXメソッドを使用する必要があります。

もう1つのオプションは、`MAX_RECORD_SIZE` を定義することです。
しかし、このオプションを使用するには、クライアントとサーバーの両方でこのオプションが設定されている必要があります。
クライアントが自分の管理外のサーバーに接続する場合、このオプションは使用できません。

## X.509証明書から公開鍵を抽出するにはどうすればよいですか？

wolfSSLは、その公開APIでこの機能を提供しています。
`wolfssl_x509_get_pubkey()` を呼び出して、WOLFSSL_EVP_PKEYポインタを返すことができます。
WOLFSSL_EVP_PKEYは、キーに関連するいくつかのデータメンバーを持つ構造体です。
このポインタから直接キーにアクセスできます。
構造体の宣言は `<wolfssl/ssl.h>` にあります。

## SSL/TLSまたは暗号化を使用する実装例はありますか？

wolfSSLは、公式のwolfSSL GitHubリポジトリでライブラリを使用するためのいくつかのサンプルコードを管理しています。
リポジトリをクローンして、これらの例をダウンロードできます。[https://github.com/wolfSSL/wolfssl-examples](https://github.com/wolfSSL/wolfssl-examples)

頻繁に利用されるディレクトリは次のとおりです：

- [https://github.com/wolfSSL/wolfssl-examples/tree/master/tls](https://github.com/wolfSSL/wolfssl-examples/tree/master/tls)
- [https://github.com/wolfSSL/wolfssl-examples/tree/master/dtls](https://github.com/wolfSSL/wolfssl-examples/tree/master/dtls)
- [https://github.com/wolfSSL/wolfssl-examples/tree/master/certgen](https://github.com/wolfSSL/wolfssl-examples/tree/master/certgen)

現在、アルゴリズム（3DES、AES、Camellia）の使用例、TLSクライアントとサーバーの使用例、wolfSSL CertManager、署名と検証の使用例があります。

wolfSSLのコマンドラインユーティリティをお探しのお客様は、wolfCLUリポジトリをご参照ください。
([https://github.com/wolfSSL/wolfCLU](https://github.com/wolfSSL/wolfCLU))。

## 必要な暗号スイートとプロトコルバージョンを有効にしていますが、アプリケーションがサーバーに接続できないのはなぜですか？

一部のサーバーは、特定のTLS拡張機能および特定のECCカーブが有効になっていることを要求し、サポートされている暗号スイートおよびプロトコルバージョンに関係なく、接続試行を完全に無視します。
wolfSSLを構成スクリプトなしでビルドしている場合（Makefileプロジェクト、IDEプロジェクトなど）、`HAVE_TLS_EXTENSIONS` および `HAVE_SUPPORTED_CURVES` を定義していることを確認してください。

## 証明書に署名するにはどうすればよいですか？

証明書への署名は、多くのセキュアプロトコルの重要な機能です。
wolfSSLは、この操作を実行できるAPIを提供し、このプロセスを簡単でストレスのないものにします。
この機能を使用するための主要なAPIを以下に示します：

* [wc_MakeCerReq](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/group__ASN.html#function-wc_makecertreq)
* [wc_SignCert](https://www.wolfssl.com/documentation/manuals/jp/wolfssl/group__ASN.html#function-wc_signcert)

wolfSSLでは、これらのAPIを使用するサンプルコードを提供しています。
これは、wolfssl-exampleリポジトリ内の、`certgen/` にあります。
サンプルコードをビルドして実行するには、特定のオプションでビルドおよびインストールされたwolfSSLが必要です。
wolfSSLは、[ダウンロードページ](https://www.wolfssl.com/download/)からダウンロードするか、git-cloneコマンドでダウンロードできます。
サンプルリポジトリは以下のGitHubページからダウンロードいただけます。
[https://github.com/wolfSSL/wolfssl-examples](https://github.com/wolfSSL/wolfssl-examples)。

wolfSSLとサンプルリポジトリをクローンしてビルドする例を以下に示します：


```
# wolfSSLをダウンロード、ビルド、インストールする
git clone https://github.com/wolfSSL/wolfssl #(ダウンロードページからダウンロードしない場合)
cd wolfssl
./autogen.sh
./configure --enable-certgen --enable-certreq
make
sudo make install
cd ..

# CSRのサンプルコードをダウンロードしてビルドする
git clone https://github.com/wolfSSL/wolfssl-examples
cd wolfssl-examples/certgen/
make

./csr_example
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIOkUjkguP0GTizna+13jooJu55sbQBsAqqkMZqjQeO55oAoGCCqGSM49
AwEHoUQDQgAEWYTvqyt3e3nLkIWqBhjmZcxLu8XcLN+mUW+g4dO5qdGxnKEYxaz1
3/K3dXlU75e3MlCIjC5gTiEuPbs3N+eIzw==
-----END EC PRIVATE KEY-----
-----BEGIN CERTIFICATE REQUEST-----
MIIBTDCB8wIBAjCBkDELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAk9SMREwDwYDVQQH
DAhQb3J0bGFuZDEQMA4GA1UECgwHd29sZlNTTDEUMBIGA1UECwwLRGV2ZWxvcG1l
bnQxGDAWBgNVBAMMD3d3dy53b2xmc3NsLmNvbTEfMB0GCSqGSIb3DQEJARYQaW5m
b0B3b2xmc3NsLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABFmE76srd3t5
y5CFqgYY5mXMS7vF3CzfplFvoOHTuanRsZyhGMWs9d/yt3V5VO+XtzJQiIwuYE4h
Lj27NzfniM+gADAKBggqhkjOPQQDAgNIADBFAiEAy8GSm89MAU69hKfp6rwaR3Eg
IjaBzRZ4VxRl22LQ+IcCIEiP9OLVIemAfZz2D26g/3oIF2ETjjwAhh8UpZSiJmdh
-----END CERTIFICATE REQUEST-----
```