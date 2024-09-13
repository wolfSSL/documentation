# wolfProviderのロード

## OpenSSLをエンジンを利用できるように構成

アプリケーションがOpenSSLエンジンを使用および使用する方法については、OpenSSLのドキュメントをご参照ください。

- [OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/provider.html)
- [OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/PROVIDER_add.html)

アプリケーションがエンジンを使用するための方法はいくつかあります。
最も単純なものとして、OpenSSLにバンドルされているすべてのPROVIDER実装をロードして登録し、アプリケーションで次のコードを呼び出す方法があります。
 (上記のOpenSSLドキュメントから引用しています)
```
/* For OpenSSL 1.0.2, need to make the “dynamic” PROVIDER available */
PROVIDER_load_dynamic();

/* Load all bundled PROVIDERs into memory and make them visible */
PROVIDER_load_builtin_providers();

/* Register all of them for every algorithm they collectively implement */
PROVIDER_register_all_complete();
```

アプリケーションがOpenSSL設定ファイルを使用するように設定されている場合、
追加のプロバイダー設定ステップをそこで行うことができます。
OpenSSLを構成する方法については、OpenSSLドキュメントをご覧ください。

- [OpenSSL 1.0.2 ドキュメント](https://www.openssl.org/docs/man1.0.2/man3/OPENSSL_config.html)
- [OpenSSL 1.1.1 ドキュメント](https://www.openssl.org/docs/man1.1.1/man3/OPENSSL_config.html)

アプリケーションはデフォルトのOpenSSL構成ファイル (`openssl.cnf`)や、
`OPENSSL_CONF`環境変数によって設定された構成の `[openssl_conf]` セクションを呼び出して、読み取り、使用できます。

```
OPENSSL_config(NULL);
```

OpenSSLコンフィギュレーションファイルを使用する代わりに、アプリケーションは`PROVIDER_*` APIを使用して明示的に wolfProviderの初期化やアルゴリズムの登録を行うこともできます。 
一例として、wolfProviderの初期化とすべてのアルゴリズムの登録を行う場合を以下に示します。

```
PROVIDER* e = NULL;

e = PROVIDER_by_id(“wolfprovider”);
if (e == NULL) {
    printf(“Failed to find wolfProvider\n”);
    /* error */
}
PROVIDER_set_default(e, PROVIDER_METHOD_ALL);

/* アプリケーションの実装 */

PROVIDER_finish(e);
PROVIDER_cleanup();
```

## OpenSSLコンフィギュレーションファイルによるwolfProviderのロード

OpenSSLを使用するアプリケーションがコンフィギュレーションファイルを処理するように設定されている場合、
wolfProviderはOpenSSLコンフィギュレーションファイルからロードできます。 

wolfProviderライブラリをコンフィギュレーションファイルに追加する方法の例を以下に示します。
`[wolfssl_section]`は、必要に応じてエンジン制御コマンド(`enable_debug`)を設定するように変更できます。

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

## wolfProvider静的エントリポイント

wolfProviderを静的ライブラリとして使用する場合、アプリケーションは次のエントリポイントを呼び出して
wolfProviderをロードできます。

```
#include <wolfprovider/wp_wolfprovider.h>
PROVIDER_load_wolfprovider();
```
