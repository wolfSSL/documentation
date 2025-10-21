# wolfProviderのロード

## OpenSSLをエンジンプロバイダーを利用できるように構成

アプリケーションがOpenSSLプロバイダーを使用するための手順については、OpenSSLドキュメントをご参照ください。

- [OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man7/provider.html)
- [OpenSSL 3.5](https://www.openssl.org/docs/man3.5/man7/provider.html)

アプリケーションがOpenSSL設定ファイルを使用するように設定されている場合、
追加のプロバイダー設定ステップをそこで行うことができます。
OpenSSLを構成する方法については、OpenSSLドキュメントをご覧ください。

- [OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man5/config.html)
- [OpenSSL 3.5](https://www.openssl.org/docs/man3.5/man5/config.html)

アプリケーションはデフォルトのOpenSSL構成ファイル (`openssl.cnf`)や、
`OPENSSL_CONF`環境変数によって設定された構成の `[openssl_conf]` セクションを呼び出して、読み取り、使用できます。

OpenSSLコンフィギュレーションファイルを使用する代わりに、アプリケーションは`OSSL_PROVIDER_*` APIを使用して明示的に wolfProviderの初期化やアルゴリズムの登録を行うこともできます。 
一例として、wolfProviderの初期化とすべてのアルゴリズムの登録を行う場合を以下に示します。

```
    OSSL_PROVIDER *prov = NULL;
    const char *build = NULL;
    OSSL_PARAM request[] = {
        { "buildinfo", OSSL_PARAM_UTF8_PTR, &build, 0, 0 },
        { NULL, 0, NULL, 0, 0 }
    };

    if ((prov = OSSL_PROVIDER_load(NULL, "libwolfprov")) != NULL
        && OSSL_PROVIDER_get_params(prov, request))
        printf("Provider 'libwolfprov' buildinfo: %s\n", build);
    else
        ERR_print_errors_fp(stderr);

    if (OSSL_PROVIDER_self_test(prov) == 0)
        printf("Provider selftest failed\n");
    else
        printf("Provider selftest passed\n");

    OSSL_PROVIDER_unload(prov);
```

## OpenSSLコンフィギュレーションファイルによるwolfProviderのロード

OpenSSLを使用するアプリケーションがコンフィギュレーションファイルを処理するように設定されている場合、
wolfProviderはOpenSSLコンフィギュレーションファイルからロードできます。 

wolfProviderライブラリをコンフィギュレーションファイルに追加する方法の例を以下に示します。

```
openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
libwolfprov = libwolfprov_sect

[libwolfprov_sect]
activate = 1
```

## wolfProvider静的エントリポイント

wolfProviderを静的ライブラリとして使用する場合、アプリケーションは次のエントリポイントを呼び出して
wolfProviderをロードできます。

```
#include <wolfprovider/wp_wolfprovider.h>
wolfssl_provider_init(const OSSL_CORE_HANDLE* handle, const OSSL_DISPATCH* in, const OSSL_DISPATCH** out, void** provCtx);
```
