# wolfSentryのビルド

wolfSentry は移植性を念頭に置いて作成されており、通常、ほとんどのシステムで簡単に構築できるはずです。 もしも
wolfSentry の構築に問題がある場合は、遠慮なくサポート フォーラムを通じてサポートを求めてください。
(<https://www.wolfssl.com/forums>) または [support@wolfssl.com](mailto:support@wolfssl.com) まで直接お問い合わせください。

## wolfSentry ソースコードの取得

wolfSentry の最新バージョンは、wolfSSL Web サイトから ZIP ファイルとしてダウンロードできます。

<https://www.wolfssl.com/download>

ZIP ファイルをダウンロードしたら、「unzip」コマンドを使用してファイルを解凍します。 ネイティブの行末を使用するには、
unzip を使用する場合は、`-a` 修飾子を有効にします。 unzip のマニュアル ページから、`-a` 修飾子の機能は次のとおりです。
説明された：

> [...] -a オプションを指定すると、zip で識別されるファイルがテキスト ファイル (zipinfo で「t」ラベルが付いているファイル) として識別されます。
> リスト、'b' ではなく) そのように自動的に抽出され、行末を変換し、end-
> ファイルの文字と、必要に応じて文字セット自体。 [...]

## 依存関係

デフォルトのビルドでは、wolfSentry は POSIX ランタイム、特にヒープ アロケータ、clock_gettime、stdio、セマフォ、および文字列 API に依存しています。 ただし、これらの依存関係は、さまざまなビルド時のオプションで回避できます。 特にレシピは

```sh
make STATIC=1 SINGLETHREADED=1 NO_STDIO=1 EXTRA_CFLAGS='-DWOLFSENTRY_NO_CLOCK_BUILTIN -DWOLFSENTRY_NO_MALLOC_BUILTIN'
```

少数の基本的な文字列関数のみに依存する libwolfsentry.a を生成します。 次に、アロケータと時間のコールバックを `struct で設定する必要があります
`wolfsentry_init()` に供給される wolfsentry_host_platform_interface`。

## ビルドとテスト

GNU Make をサポートするプラットフォームでは、`make` を実行すると、通常どおり wolfSentry がビルドされます。 他のプラットフォームでは、`src` ディレクトリとその `json` サブディレクトリにある C ファイルを使用してコンパイルする必要があります。

テスト スイートをビルドして実行するには、`make -j test` または `make V=1 -j test` を詳細に使用できます。


### ビルド オプション

`make` に追加できるいくつかのフラグと、ヘッダー ファイルまたは `CFLAGS` のいずれかでビルド時の定義として使用されるフラグがあります。 `make` フラグを使用するには、以下を使用できます。

```sh
make SINGLETHREADED=1 EXTRA_CFLAGS='-DWOLFSENTRY_NO_CLOCK_BUILTIN'
```

これらは、ビルド時に wolfSentry がビルドされる `wolfsentry_options.h` ファイルに保存されます。 `make` を使用していない場合は、次のテンプレートを使用してこのファイルを作成できます。

```c
#ifndef WOLFSENTRY_OPTIONS_H
#define WOLFSENTRY_OPTIONS_H

#endif /* WOLFSENTRY_OPTIONS_H */
```

次の表に、可能なオプションを示します。

| | `make` オプション | 説明 |
| | --------------| ------------|
| | 'V' | 詳細な `make` 出力 |
|| 例えば `make V=1 -j test`|
| | `USER_MAKE_CONF` | 含めるユーザー定義の Makefile |
|| 例えば `make -j USER_MAKE_CONF=Makefile.settings` |
| | `SRC_TOP` | ソース コードの最上位ディレクトリ (デフォルトは「pwd -P」) |
| | `BUILD_TOP`| 別の場所 (ソース ツリーの外部またはサブディレクトリ内) にアーティファクトを使用してビルドする |
|| 例えば `make BUILD_TOP=./build -j test`|
| | `デバッグ` | 使用するコンパイラ デバッグ フラグ (デフォルトは `-ggdb`) |
| | オプティム | 使用するオプティマイザ フラグ (デフォルトは `-O3`) |
| | `C_WARNFLAGS` | 使用する警告フラグ (デフォルト [^1] を参照) |
| | NO_STDIO | プラットフォームに「STDIO」がありません |
| | `NO_JSON` | JSON 構成サポートをコンパイルしないでください |
| | `USER_SETTINGS_FILE`| インクルードする追加のヘッダー ファイル |
| | `シングルヘッド` | シングル スレッドの使用にスレッド セーフ セマンティクスを使用しない |
|| 例えば `make -j SINGLETHREADED=1 テスト` |
| | `静的` | 静的バイナリをビルドする |
| | 剥ぎ取られた | デバッグ シンボルのバイナリを削除 |
| | `BUILD_DYNAMIC` | 動的ライブラリを構築 |
| | `VERY_QUIET` | 非常に静かなビルドを有効にする |
| | `TAR` | `make dist` の GNU tar バイナリへのパス。macOS では `gtar` に設定する必要があります |
| | `バージョン` | コンパイルするバージョン番号 (デフォルトは [^2] を参照) |

[^1]: `-Wall -Wextra -Werror -Wformat=2 -Winit-self -Wmissing-include-dirs -Wunknown-pragmas -Wshadow -Wpointer-arith -Wcast-align -Wwrite-strings -Wconversion -Wstrict-prototypes -Wold-style-definition -Wmissing-declarations -Wmissing-format-attribute -Wpointer-arith -Woverlength-strings -Wredundant-decls -Winline -Winvalid-pch -Wdouble-promotion -Wvla -Wno-missing-field-initializers -Wno -bad-function-cast -Wno-type-limits` および GCC が使用されている場合は、`-Wjump-misses-init -Wlogical-op` の追加フラグが使用されます。

[^2]: `VERSION として定義:= $(shell git rev-parse --short=8 HEAD 2>/dev/null || echo xxxxxxxx)$(shell git diff --quiet 2>/dev/null | | [ $$? -ne 1 ] || echo "-dirty")`


```
| | プリプロセッサ マクロ | 説明 |
| | ------------------- | ----------- |
| | `WOLFSENTRY_NO_STDIO` | プラットフォームに「STDIO」がありません |
| | `WOLFSENTRY_NO_JSON` | JSON 構成サポートをコンパイルしないでください |
| | `WOLFSENTRY_USER_SETTINGS_FILE` | インクルードする追加のヘッダー ファイル |
| | `WOLFSENTRY_SINGLETHREADED` | シングル スレッドの使用にスレッド セーフ セマンティクスを使用しない |
| | `CENTIJSON_USE_LOCALE` | JSON パーサーはロケール依存の文字を使用する必要があります |
| | `WOLFSENTRY_NO_PROTOCOL_NAMES` | 構成ファイルのプロトコル名のサポートを無効にする |
| | `DEBUG_JSON` | JSON パーサーにデバッグ `printf()` を追加 |
| | `WOLFSENTRY_NO_ERROR_STRINGS` | エラー文字列関数へのエラー コードを無効にする |
| | `WOLFSENTRY_NO_MALLOC_BUILTINS` | 組み込みの malloc 関数を無効にする |
| | `WOLFSENTRY_HAVE_NONGNU_ATOMICS` | アトミックは非 GNU です (`SINGLETHREADED` が設定されている場合は無視されます) |
| | `WOLFSENTRY_NO_CLOCK_BUILTIN` | Bulitin 時間関数を使用しないでください |
| | `WOLFSENTRY_LWIP` | wolfSentry は BSD ソケットではなく LWIP に対して構築されています |
| | `FREERTOS` | FreeRTOS サポートでビルド |

### ビルドオプションの例

別のビルド場所から非標準の場所にインストールします。

```sh
$make BUILD_TOP=./build INSTALL_DIR=/usr INSTALL_LIBDIR=/usr/lib64 インストール
```

libwolfsentry.a をビルドし、さまざまなアナライザー (メモリとスレッド
valgrind およびサニタイザー テストのフル バッテリー下でのテスト):

```sh
$make -j check
```

マルチスレッドをサポートせずに libwolfsentry.a をビルドしてテストします。

```sh
$make -j SINGLETHREADED=1 test
```

その他の使用可能な make フラグは、「STATIC=1」、「STRIPPED=1」、「NO_JSON=1」、および
「NO_JSON_DOM=1」、および「DEBUG」、「OPTIM」、および「C_WARNFLAGS」のデフォルト値
便利にオーバーライドすることもできます。

ユーザー提供の makefile プリアンブルを使用してビルドし、デフォルトをオーバーライドします。

```sh
$make -j USER_MAKE_CONF=Makefile.settings
```

(`Makefile.settings` には、`OPTIM := -Os` のような単純な設定を含めることができます。
追加の規則と依存メカニズムを含む、複雑な makefile コード)。

可能な限り最小で最も単純なライブラリを構築します。

```sh
make -j SINGLETHREADED=1 NO_STDIO=1 DEBUG= OPTIM=-Os EXTRA_CFLAGS='-DWOLFSENTRY_NO_CLOCK_BUILTIN -DWOLFSENTRY_NO_MALLOC_BUILTIN -DWOLFSENTRY_NO_ERROR_STRINGS -Wno-error=inline -Wno-inline'
```

ユーザー設定を使用してビルドおよびテストします。

```sh
$make -j USER_SETT