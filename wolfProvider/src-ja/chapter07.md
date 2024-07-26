# wolfProviderのロード

## OpenSSLをエンジン使用可能に構成

アプリケーションが OpenSSL エンジンを使用および使用する方法に関するドキュメントについては、OpenSSL のドキュメントを参照してください：

[OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/provider.html)
[OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/PROVIDER_add.html)

アプリケーションがエンジンの使用を消費、登録、および構成するために選択できる方法はいくつかあります。 最も単純な使用法では、OpenSSL にバンドルされているすべての PROVIDER 実装をロードして登録するには、アプリケーションで次を呼び出す必要があります (上記の OpenSSL ドキュメントから引用)：
```
/* For OpenSSL 1.0.2, need to make the “dynamic” PROVIDER available */
PROVIDER_load_dynamic();

/* Load all bundled PROVIDERs into memory and make them visible */
PROVIDER_load_builtin_providers();

/* Register all of them for every algorithm they collectively implement */
PROVIDER_register_all_complete();
```
この時点で、アプリケーションが OpenSSL 構成ファイルを読み取り/使用するように構成されている場合は、そこで追加のエンジン セットアップ手順を実行できます。 OpenSSL 構成ドキュメントについては、OpenSSL ドキュメントを参照してください：

[OpenSSL 1.0.2 ドキュメント](https://www.openssl.org/docs/man1.0.2/man3/OPENSSL_config.html)<br>
[OpenSSL 1.1.1 ドキュメント](https://www.openssl.org/docs/man1.1.1/man3/OPENSSL_config.html)

たとえば、アプリケーションは、デフォルトの OpenSSL 構成ファイル (openssl.cnf) または OPENSSL_CONF 環境変数によって設定された構成、およびデフォルトの [openssl_conf] セクションを呼び出して、読み取り、使用できます
```
OPENSSL_config(NULL);
```

OpenSSL コンフィギュレーションファイルを使用する代わりに、アプリケーションは希望の PROVIDER_* API を使用して明示的に wolfProvider を初期化および登録できます。 一例として、wolfProvider の初期化とすべてのアルゴリズムの登録は、以下を使用して行うことができます：
```
PROVIDER* e = NULL;

e = PROVIDER_by_id(“wolfprovider”);
if (e == NULL) {
printf(“Failed to find wolfProvider\n”);
/* error */
}
PROVIDER_set_default(e, PROVIDER_METHOD_ALL);

/* normal application execution / behavior */

PROVIDER_finish(e);
PROVIDER_cleanup();
```

## OpenSSL コンフィギュレーションファイルからの wolfProvider のロード

OpenSSLを使用するアプリケーションがコンフィギュレーションファイルを処理するように設定されている場合、wolfProviderはOpenSSLコンフィギュレーションファイルからロードできます。 wolfProvider ライブラリをコンフィギュレーションファイルに追加する方法の例を以下に示します。 [wolfssl_section] は、必要に応じてエンジン制御コマンド (enable_debug) を設定するように変更できます。

```
openssl_conf = openssl_init

[openssl_init]
providers = provider_section

[provider_section]
wolfSSL = wolfssl_section

[wolfssl_section]
# If using OpenSSL <= 1.0.2, change provider_id to wolfprovider
(drop the "lib").
provider_id = libwolfprovider
# dynamic_path = .libs/libwolfprovider.so
init = 1
# Use wolfProvider as the default for all algorithms it provides.
default_algorithms = ALL
# Only enable when debugging application - produces large
amounts of output.
# enable_debug = 1
```

## wolfProvider 静的エントリポイント

wolfProvider がスタティック ライブラリとして使用される場合、アプリケーションは次のエントリ ポイントを呼び出して wolfProvider をロードできます：
```
#include <wolfprovider/wp_wolfprovider.h>
PROVIDER_load_wolfprovider();
```
