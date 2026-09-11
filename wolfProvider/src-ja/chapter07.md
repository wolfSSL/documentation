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

    prov = OSSL_PROVIDER_load(NULL, "libwolfprov");
    if (prov != NULL) {
        if (OSSL_PROVIDER_get_params(prov, request))
            printf("Provider 'libwolfprov' buildinfo: %s\n", build);
        else
            ERR_print_errors_fp(stderr);
        OSSL_PROVIDER_unload(prov);
    }
    else {
        ERR_print_errors_fp(stderr);
    }
```

プロバイダーをロードすると利用可能にはなりますが、それだけですべての操作が必ずそのプロバイダーを使用するわけではありません。
特定の操作でwolfProviderを必ず使用させるには、wolfProviderが登録するプロパティ `"provider=wolfprov"`(FIPSビルドの場合は `"provider=wolfprov,fips=yes"`)を用いたプロパティクエリで、`EVP_*_fetch()` APIを通じてアルゴリズムをフェッチします。
なお、`libwolfprov` はプロバイダーを**ロード**するために使用するモジュール名であり、`provider=wolfprov` はそのアルゴリズムを**選択**するために使用するプロパティです。

wolfProviderは現在、プロバイダーのセルフテストディスパッチ(`OSSL_FUNC_PROVIDER_SELF_TEST`)を実装していません。
そのため、ロード済みプロバイダーに対する `OSSL_PROVIDER_self_test()` はwolfProviderのセルフテストを実行せず、セルフテストとして依拠すべきではありません。

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

wolfProviderを静的ライブラリとしてビルドした場合、動的にロードされるモジュールではなく、OpenSSLの組み込みプロバイダーとしてロードされます。
アプリケーションは静的wolfProvider(およびそのwolfSSLとOpenSSLの依存関係)にリンクし、wolfProviderのエントリポイントを `OSSL_PROVIDER_add_builtin()` で登録したうえで、名前を指定してロードします。

```
#include <openssl/provider.h>
#include <wolfprovider/wp_wolfprov.h>

int load_wolfprovider(void)
{
    OSSL_PROVIDER *prov;

    if (OSSL_PROVIDER_add_builtin(NULL, "libwolfprov",
            wolfssl_provider_init) != 1) {
        return -1;
    }
    prov = OSSL_PROVIDER_load(NULL, "libwolfprov");
    if (prov == NULL) {
        return -1;
    }
    /* use prov, then call OSSL_PROVIDER_unload(prov) when finished */
    return 0;
}
```

エントリポイント `wolfssl_provider_init()` は `wolfprovider/wp_wolfprov.h` で宣言されています。
これは `OSSL_PROVIDER_add_builtin()` に渡すものであり、アプリケーションから直接呼び出すことはありません。

## 置き換え用デフォルトモード

上記の標準的なロードモデルでは、wolfProviderはOpenSSL自身のプロバイダーと**並行して**ロードされます。
すなわち、アプリケーションは構成ファイル、`OSSL_PROVIDER_load()` / `OSSL_PROVIDER_add_builtin()` の呼び出し、あるいはプロパティクエリを通じて `libwolfprov` を有効化します。
このときOpenSSLネイティブの `default`(FIPSビルドの場合は `fips`)プロバイダーは引き続き存在し、wolfProviderが処理しない操作はOpenSSL自身の暗号処理で応答され得ます。

置き換え用デフォルトモードはこの関係を変えます。
wolfProviderはOpenSSLのデフォルトプロバイダーと並んでロードされるのではなく、それ自体が**デフォルトプロバイダーになります**。
置き換え用デフォルトモードでは、OpenSSLの組み込み `default` または `fips` プロバイダーへの要求がwolfProvider(`libwolfprov` モジュール)に解決されます。
そのため、変更を加えていないアプリケーションは、**コードの変更も、`openssl.cnf` も、環境変数の構成も一切なしに** wolfSSLの暗号処理を使用でき、置き換えられたプロバイダーについてはOpenSSLネイティブ実装へ戻る経路も存在しません。

### 仕組み

置き換え用デフォルトモードは、OpenSSLのビルド前にOpenSSLのソースファイル `crypto/provider_predefined.c` を1つ置き換えることで実現します。
このファイルは、組み込みプロバイダーの**名前**を、その名前でプロバイダーがロードされる際に使用する初期化関数へ対応付けるテーブル `ossl_predefined_providers[]` を定義しています。
標準のOpenSSLでは `default` という名前は `ossl_default_provider_init`(OpenSSL自身の暗号処理)に対応付けられています。
wolfProviderは、このテーブルを書き換えるドロップイン置換ファイル `patches/provider_predefined.c.replace-default` を同梱しており、`default` と `fips`(および静的レガシービルドでは `legacy`)の名前を、代わりに小さなローダー関数へ対応付けます。

```c
const OSSL_PROVIDER_INFO ossl_predefined_providers[] = {
    { "fips",    NULL, load_wolfprov_and_init, NULL, 0 },
    { "default", NULL, load_wolfprov_and_init, NULL, 1 },
# ifdef STATIC_LEGACY
    { "legacy",  NULL, load_wolfprov_and_init, NULL, 0 },
# endif
    { "base",    NULL, ossl_base_provider_init, NULL, 0 },
    { "null",    NULL, ossl_null_provider_init, NULL, 0 },
    { NULL, NULL, NULL, NULL, 0 }
};
```

`load_wolfprov_and_init()` はOpenSSLのDSOレイヤーを使用して `libwolfprov` を `dlopen` し、そのエントリポイント `wolfssl_provider_init` をバインドして、プロバイダーの初期化関数として呼び出します。
これ以降、OpenSSLがデフォルトプロバイダーを遅延ロードするたびに――アプリケーションがプロバイダーを明示的に選択せずに初めて暗号処理を行った時点で自動的に行われます――wolfProviderがロードされます。

2つのエントリは意図的にそのまま残されています。
OpenSSLの `base` プロバイダー(エンコーダー、デコーダー、`PEM`/`DER` シリアライズ、その他の非暗号サービス)と `null` プロバイダーは、wolfProviderがこれらの非暗号サービスを置き換えないため、元のOpenSSLの初期化関数を保持します。

またこの置換ファイルは、OpenSSL自体がFIPSモジュールとしてビルドされる場合にはコンパイルを拒否します。

```c
#ifdef FIPS_MODULE
#error "For wolfProvider replace default mode, do not build OpenSSL with FIPS"
#endif
```

これは意図的な設計です。置き換え用デフォルトモードでは、FIPSの振る舞いはOpenSSLの独立したFIPSモジュールではなく、wolfProviderの下層にあるwolfCryptから得られることを想定しています。
このため `--replace-default` はOpenSSL側の `--enable-fips-baseline` パッチとは相互排他であり、`scripts/build-wolfprovider.sh` はこの組み合わせを拒否します。

このリダイレクトはOpenSSLのビルド内に完結するため、wolfProviderは実行時にも存在している必要があります。
`load_wolfprov_and_init()` は `libwolfprov` を名前でロードするので、wolfProvider共有ライブラリは動的ローダーが見つけられる場所にインストールされていなければなりません。
存在しない場合、パッチ適用済みのOpenSSLは `Could not load libwolfprov.so. Is the libwolfprov package installed?` と報告し、プロバイダーの初期化に失敗します。
「構成が不要」であることは「依存関係が不要」を意味するわけではありません。

### 置き換え用デフォルトモードの有効化

置き換え用デフォルトの有効化には2つの部分があり、両方が必要です。

1. **wolfProviderを置き換え用デフォルト向けにビルドする。** `./configure` に `--enable-replace-default` を渡すか、`CFLAGS` に `-DWOLFPROV_REPLACE_DEFAULT` を定義します(フラグ経由でビルドを駆動するYocto系・システムパッケージ向けのビルドに便利です)。
2. **`provider_predefined.c` 置換を適用してOpenSSLをビルドする。** これによりOpenSSLの組み込み `default`/`fips` の名前がwolfProviderをロードするようになります。

ビルドスクリプトは両方を1ステップで行います。

```sh
./scripts/build-wolfprovider.sh --replace-default
```

手順1だけを行うと、置き換え用デフォルト対応のwolfProviderはビルドされますが、OpenSSLは依然として自身のデフォルトプロバイダーを使用するストックのままになります。
手順2だけを行うと、ロードすべきwolfProviderが存在しないOpenSSLにパッチを当てることになります。
2つが同期した状態を保つため、ビルドスクリプトを使用してください(あるいはインテグレーションガイドに従ってください)。
パッケージ化やシステム全体への展開を含む、権威ある手順については、wolfProviderインテグレーションガイド(`docs/INTEGRATION_GUIDE.md`)をご参照ください。

置き換え用デフォルトモードでは、wolfProviderがすでにデフォルトプロバイダーであるため、`OPENSSL_CONF` や `OPENSSL_MODULES` の構成は不要です。
`scripts/env-setup` ヘルパーはこのモードを検出し、これらの変数の設定をスキップします(標準モードでは `OPENSSL_CONF` を `provider.conf` に向けて `libwolfprov` を有効化します)。

### 置き換え用デフォルトモードを使用する理由

置き換え用デフォルトモードでビルドする主な理由は2つあります。

**1. wolfProviderが実際に暗号処理を行っていることを保証するため。** 標準的なロードモデルでは、いくつかの状況でOpenSSLが自身のデフォルトプロバイダーから要求を処理し得ます――アプリケーション(またはその依存関係)が `default` プロバイダーを明示的に要求した場合、wolfProviderが実装していないアルゴリズムの場合、あるいは構成ファイルが単に読み込まれていない場合です。
これらの場合、OpenSSLはネイティブ実装へ気付かないうちにフォールバックし、その様子はアプリケーションの挙動からは見えません。
置き換え用デフォルトモードはこのフォールバック経路を完全に取り除きます。`default`/`fips` の名前が**wolfProvider自体**であるため、フォールバックできるOpenSSLネイティブのプロバイダーが残らないからです。
これにより、アプリケーション、ライブラリ、あるいはシステム全体が、見かけ上そう見えるだけでなく、実際にwolfCryptを介して暗号処理を行っていることを検証する決定的な手段となります。
wolfProviderのCIは、まさにこの目的で、強制障害テスト(`WOLFPROV_FORCE_FAIL=1`)と組み合わせて使用しています。

**2. システム全体の置き換え。** 置き換え用デフォルトモードは、パッチ適用済みのlibcryptoにリンクする**すべての**OpenSSL利用者に対して、アプリケーションごとの構成もソース変更もなしに、wolfCryptを暗号バックエンドにします。
これは、ディストリビューションやイメージ全体――例えばYoctoイメージや、`scripts/build-wolfprovider.sh --replace-default` が置換をシステムのOpenSSLパッケージへ転送するDebianパッケージビルド――の下層でwolfCryptに差し替えることが目的の場合に使用されるモデルです。
結果として得られるシステム上のすべてのアプリケーションが、個別に再ビルドや再構成をされることなくwolfSSLの暗号処理を使用します。

置き換え用デフォルトモードは、理由(1)と同じ理由から、FIPS展開でも推奨されるモデルです。
OpenSSLのデフォルトプロバイダーへのフォールバック経路を取り除くことで、アプリケーションが誤ってOpenSSL自身のプロバイダーの非FIPSアルゴリズムを使用してしまうリスクを低減します。
これ自体がシステム全体のFIPS適合を保証するわけではありません(明示的にロードされたサードパーティのプロバイダーや、低レベルの直接呼び出しは制御外のままです)が、最も一般的な意図しないフォールバック経路を塞ぎます。
詳細については、FIPS 140-3のサポートの章およびwolfProvider FIPSインテグレーションガイドをご参照ください。

### 置き換え用デフォルトモードが有効かどうかの確認

最も確実な確認方法はOpenSSLのプロバイダー一覧です。
置き換え用デフォルトモードでは、組み込みの `default` プロバイダーが自身の名前として **wolfSSL Provider** を報告し、別個の `libwolfprov` エントリは存在しません。

```sh
$ openssl list -providers
Providers:
  default
    name: wolfSSL Provider
    version: ...
    status: active
```

標準モデルでは、同じコマンドはwolfProviderをOpenSSLの `default` とは別の `libwolfprov` プロバイダーとして表示します。
wolfProviderのスクリプトでビルドされたOpenSSLは、バージョン文字列にビルドメタデータのサフィックスも付きます(`openssl version` は例えば `OpenSSL 3.x.y+wolfProvider-nonfips` と表示します)。ただしこのサフィックス自体は、wolfProviderによってビルドされたOpenSSLであることを示すものであり、置き換え用デフォルトモードそのものを示すわけではありません。

### 置き換え用デフォルトのテスト用ビルド

`--replace-default` を必要とする別のオプション `--enable-replace-default-testing` が存在しますが、**これはwolfProvider自身の単体テスト専用であり、本番環境で使用してはなりません**。
置き換え用デフォルトのOpenSSLは、比較対象となる本物のOpenSSLデフォルトプロバイダーをもはや公開しないため、このオプションは通常は内部的なOpenSSLシンボルをいくつかエクスポートし、単体テストが本物のOpenSSLプロバイダーを別名でロードしてwolfProviderの出力と照合できるようにします。
これはテストハーネス用の補助であって展開モードではありません。有効化するとビルドスクリプトは目立つ「テスト専用」の警告を出力します。
