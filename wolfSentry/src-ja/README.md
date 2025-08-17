# wolfSentry -- wolfSSL組み込みファイアウォール/IDPS

## 説明

wolfSentryは、wolfSSL組み込みIDPS（侵入検知・防止システム）です。
つまり、wolfSentryは組み込みファイアウォールエンジン（静的および完全動的の両方）であり、インターフェース、アドレスファミリー、プロトコル、ポート、その他のトラフィックパラメータによって修飾された既知のホスト/ネットブロックのプレフィックスベースおよびワイルドカード対応検索機能を提供します。
さらに、wolfSentryは動的に設定可能なロジックハブとして使用でき、ユーザー定義のイベントをユーザー定義のアクションと任意に関連付け、接続属性によってコンテキスト化します。
これにより、クライアント/サーバーの関係を詳細に追跡し、期待されるパターンに一致するトラフィックを自由に通過させる一方で、悪意の込められたトラフィックを効率的に拒否できます。

wolfSentryは、ソースツリーの`lwip/`サブディレクトリ内のパッチセットを通じてlwIPスタックと完全に統合されています。
また、インバウンドおよびアウトバウンド接続のアプリケーションレベルフィルタリングのため、wolfSSLライブラリとも統合されています。

wolfSentryエンジンは、API経由でプログラム的に、またはエンジンに提供されるJSONのテキスト入力ファイルから、あるいはJSONフラグメントで動的かつ段階的に、またはこれらの方法の任意の組み合わせで動的に設定できます。
再設定はトランザクションセマンティクスによって保護され、スレッド化されたターゲット上の高度な内部ロックにより、アトミックなポリシー移行でシームレスなサービス可用性を保証します。
またコールバックを用いることで、MQTT、syslog、DDSメッセージバスなどを通じた、トランスポートプロトコルに依存しないリモートログ記録が可能です。

wolfSentryはリソース制約のある、ベアメタル/RTOS環境で適切に機能するよう設計されました。
指定された最大メモリフットプリント内に留まり、決定論的スループットを維持するアルゴリズムを持っています。
これにより、FreeRTOS、Nucleus、NUTTX、Zephyr、VxWorks、Green Hills Integrityなどの組み込みターゲット、およびARMやその他の一般的な組み込みCPUおよびMCU上で完全なファイアウォールとIDPS機能を実現できます。
動的ファイアウォール機能を持つwolfSentryを実行するのに必要なリソースは非常に小さく、コードフットプリントに64k、揮発性状態フットプリントに32kです。
アプリケーションと関連ライブラリが有する、既存のロジックと状態を完全に活用できます。


## ドキュメント

完全なAPIリファレンスマニュアルのHTML版は、wolfSentryソースツリーのトップから`make doc-html`で生成できます。
事前に`doxygen`のインストールが必要です。

なおAPIリファレンスマニュアルのPDF版は事前生成されており、ソース配布物の`doc/`サブディレクトリに`doc/wolfSentry_refman.pdf`として含まれています。
最新版は常に[GitHub](https://raw.githubusercontent.com/wolfSSL/wolfsentry/master/doc/wolfSentry_refman.pdf)で入手可能です。
まもなく、日本語版もご提供できる予定です。


## 依存関係

デフォルトビルドでは、wolfSentryはPOSIXランタイム、特にヒープアロケータ、clock_gettime、stdio、セマフォ、pthreads、文字列APIに依存しています。
しかし、これらの依存関係は様々なビルド時オプションで回避できます。
例えば次のコマンドでは、基本的な文字列関数のいくつかと`inet_ntop()`ライブラリ関数（POSIX.1-2001から、lwIPでも実装されています）のみに依存する`libwolfsentry.a`をビルドします。

`make STATIC=1 SINGLETHREADED=1 NO_STDIO=1 EXTRA_CFLAGS="-DWOLFSENTRY_NO_CLOCK_BUILTIN -DWOLFSENTRY_NO_MALLOC_BUILTIN"`

その後、アロケータと時間のコールバックを`wolfsentry_init()`に提供される`struct wolfsentry_host_platform_interface`に設定する必要があります。

wolfSentry `Makefile`は、現代的な（v4.0+）Gnu `make`に依存しています。
ライブラリ自体はユーザー設定マクロファイルを作成し、`WOLFSENTRY_USER_SETTINGS_FILE`マクロでコンパイラにそのパスを渡すことで、`make`外の別のプロジェクト/フレームワーク内でビルドできます。


## ビルド

wolfSentryは移植性を意識して設計しており、非POSIX・C89ターゲットでも動作します。
例えば、すべての依存関係はFreeRTOS/newlib-nano/lwIPランタイムで充足します。
wolfSentryのビルド時に問題がある場合は[サポートフォーラム](<https://www.wolfssl.com/forums>)を通じてサポートを求めるか、[support@wolfssl.com](mailto:support@wolfssl.com)へ直接ご連絡ください。

現在のwolfSentryリリースは[wolfSSLウェブサイト](https://www.wolfssl.jp/download)からZIPファイルとしてダウンロードできます。
[リリース履歴を閲覧](https://github.com/wolfSSL/wolfsentry/tags)したり、最新のプレリリース更新のために[wolfSentry Gitリポジトリ](https://github.com/wolfSSL/wolfsentry)をクローンしたりすることもできます。

`make`では、環境に応じたフラグを渡すことでビルドパラメータを制御できます。
ビルド時に使用したフラグは、ビルドツリーの`wolfsentry/wolfsentry_options.h`に保存します。

なお`make`を使用しない場合は、設定を含むファイルへのパスにCマクロ`WOLFSENTRY_USER_SETTINGS_FILE`を定義する必要があります。
wolfSentryをビルドするときとアプリケーションをビルドするときの両方で必要ですので、お気をつけください。

wolfSentryがサポートしているオプション一覧を以下に示します。
bool値のフラグ（`LWIP`、`NO_STDIO`、`NO_JSON`など）はデフォルトで未定義であり、定義することで有効化されます。
マクロは`EXTRA_CFLAGS`オプションを使用するか、`USER_SETTINGS_FILE`に配置することで有効化できます。
マクロのより詳細なドキュメントは、リファレンスマニュアルの「起動/設定/シャットダウンサブシステム」節をご覧ください。

| `make`オプション | マクロオプション | 説明 |
| ------------ | ----------------- | -------- |
| `SHELL` | | `bash`への明示的/代替パスを提供 |
| `AWK` | | Gnu `awk`への明示的/代替パスを提供 |
| `V` | | 詳細な`make`出力 <br> 例：`make V=1 -j test` |
| `USER_MAKE_CONF` | | メインMakefileの先頭に含めるユーザー定義make節 <br> 例：`make -j USER_MAKE_CONF=Makefile.settings` |
| `EXTRA_CFLAGS` | | コンパイラに逐語的に渡される追加引数 |
| `EXTRA_LDFLAGS` | | リンカに逐語的に渡される追加引数 |
| `SRC_TOP` | | ソースコードのトップレベルディレクトリ（デフォルト`pwd -P`） |
| `BUILD_TOP` | | 代替場所（ソースツリーの外部またはサブディレクトリ）でアーティファクトを使用してビルド <br> 例：`make BUILD_TOP=./build -j test`|
| `DEBUG` | | 使用するコンパイラデバッグフラグ（デフォルト`-ggdb`） |
| `OPTIM` | | 使用するオプティマイザフラグ（デフォルト`-O3`） |
| `HOST` | | クロスコンパイル用のターゲットホストタプル（デフォルト未設定、つまりネイティブターゲティング） |
| `RUNTIME` | | ターゲットランタイムエコシステム -- デフォルト未設定、`FreeRTOS-lwIP`と`Linux-lwIP`が認識されます |
| `C_WARNFLAGS` | | 使用する警告フラグ（一般的に適用可能なデフォルトをオーバーライド） |
| `STATIC` | | 静的リンクされた単体テストをビルド |
| `STRIPPED` | | バイナリからデバッグシンボルを取り除く |
| `FUNCTION_SECTIONS` | | 未使用のオブジェクトコード（関数粒度）を削除して総サイズを最小化 |
| `BUILD_DYNAMIC` | | 動的リンクされたライブラリをビルド |
| `VERY_QUIET` | | ビルド中のすべての非エラー出力を抑制 |
| `TAR` | | `make dist`用のGNU tarバイナリへのパス、macOSでは`gtar`に設定すべき |
| `VERSION` | | `make dist`用にパッケージするバージョン |
| `LWIP` | `WOLFSENTRY_LWIP` | 真偽値 -- lwIP用の適切なビルド設定を有効化 |
| `NO_STDIO_STREAMS` | `WOLFSENTRY_NO_STDIO_STREAMS` | `stdio`ストリームI/Oに依存する機能を省略するよう定義 |
| | `WOLFSENTRY_NO_STDIO_H` | `stdio.h`のインクルードを抑制するよう定義 |
| `NO_ADDR_BITMASK_MATCHING` | `WOLFSENTRY_NO_ADDR_BITMASK_MATCHING` | アドレスのビットマスクマッチングサポートを省略し、プレフィックスマッチングのみをサポートするよう定義 |
| `NO_IPV6` | `WOLFSENTRY_NO_IPV6` | IPv6アドレスファミリーのサポートを省略するよう定義 |
| `NO_JSON` | `WOLFSENTRY_NO_JSON` | JSON設定サポートを省略するよう定義 |
| `NO_JSON_DOM` | `WOLFSENTRY_NO_JSON_DOM` | JSON DOM APIを省略するよう定義 |
| `CALL_TRACE` | `WOLFSENTRY_DEBUG_CALL_TRACE` | ランタイムコールスタックログ記録を有効化するよう定義（非常に詳細） |
| `USER_SETTINGS_FILE` | `WOLFSENTRY_USER_SETTINGS_FILE` | 自動生成された`wolfsentry_settings.h`を置き換える代替設定ファイル |
| `SINGLETHREADED` | `WOLFSENTRY_SINGLETHREADED` | スレッドセーフティロジックを省略し、スレッドセーフティ関数とマクロをno-opマクロに置き換えるよう定義 |
| | `WOLFSENTRY_NO_PROTOCOL_NAMES` | 定義されている場合、エラーコードとソースコードファイルを人間が読める形式でレンダリングするAPIを省略。数値的にレンダリングされます。 |
| | `WOLFSENTRY_NO_GETPROTOBY` | プロトコルとサービスの名前による検索とレンダリングを無効にするよう定義 |
| | `WOLFSENTRY_NO_ERROR_STRINGS` | 定義されている場合、エラーコードとソースコードファイルを人間が読める形式でレンダリングするAPIを省略。数値的にレンダリングされます。 |
| | `WOLFSENTRY_NO_MALLOC_BUILTINS` | 定義されている場合、組み込みヒープアロケータプリミティブを省略します；wolfSentry APIに提供される`wolfsentry_host_platform_interface`には、`struct wolfsentry_allocator`内のすべての関数の実装が含まれている必要があります。 |
| | `WOLFSENTRY_HAVE_NONGNU_ATOMICS` | gnu様式のアトミック組み込み関数が利用できない場合に定義。組み込み関数用の`WOLFSENTRY_ATOMIC_*()`マクロ定義を`WOLFSENTRY_USER_SETTINGS_FILE`で提供する必要があります（`wolfsentry_util.h`を参照）。 |
| | `WOLFSENTRY_NO_CLOCK_BUILTIN` | 定義されている場合、組み込み時間プリミティブを省略します；wolfSentry APIに提供される`wolfsentry_host_platform_interface`には、`struct wolfsentry_timecbs`内のすべての関数の実装が含まれている必要があります。 |
| | `WOLFSENTRY_NO_SEM_BUILTIN` | 定義されている場合、組み込みセマフォプリミティブを省略します；wolfSentry APIに提供される`wolfsentry_host_platform_interface`には、`struct wolfsentry_semcbs`内のすべての関数の実装が含まれている必要があります。 |
| | `WOLFSENTRY_USE_NONPOSIX_SEMAPHORES` | POSIXセマフォAPIが利用できない場合に定義。`wolfsentry_util.c`に非POSIX組み込み実装が存在しない場合は、#WOLFSENTRY_NO_SEM_BUILTINを設定する必要があり、wolfSentry APIに提供される`wolfsentry_host_platform_interface`の`wolfsentry_semcbs`スロットに完全なセマフォ実装（shimセット）を含める必要があります。 |
| | `WOLFSENTRY_SEMAPHORE_INCLUDE` | セマフォAPIを宣言するヘッダーファイルのパスに定義 |
| | `WOLFSENTRY_USE_NONPOSIX_THREADS` | POSIXスレッドAPIが利用できない場合に定義。`WOLFSENTRY_THREAD_INCLUDE`、`WOLFSENTRY_THREAD_ID_T`、`WOLFSENTRY_THREAD_GET_ID_HANDLER`を定義する必要があります。 |
| | `WOLFSENTRY_THREAD_INCLUDE` | スレッディングAPIを宣言するヘッダーファイルのパスに定義 |
| | `WOLFSENTRY_THREAD_ID_T` | POSIX `pthread_t`に類似した適切な型に定義 |
| | `WOLFSENTRY_THREAD_GET_ID_HANDLER` | POSIX `pthread_self`に類似した、`WOLFSENTRY_THREAD_ID_T`型の値を返すvoid関数の名前に定義 |
| | `FREERTOS` | FreeRTOS用にビルド |

### ビルドとセルフテストのコマンド例

Linux上で`libwolfsentry.a`をビルドしてテスト

`make -j test`

詳細ビルド

`make V=1 -j test`

代替場所（ソースツリーの外部またはサブディレクトリ）でアーティファクトを使用してビルド

`make BUILD_TOP=./build -j test`

代替ビルド場所から非標準の宛先にインストール

`make BUILD_TOP=./build INSTALL_DIR=/usr INSTALL_LIBDIR=/usr/lib64 install`

`libwolfsentry.a`をビルドして様々な設定でテスト

`make -j check`

マルチスレッドサポートなしで`libwolfsentry.a`をビルドしてテスト

`make -j SINGLETHREADED=1 test`

他の利用可能なmakeフラグは`STATIC=1`、`STRIPPED=1`、`NO_JSON=1`、`NO_JSON_DOM=1`であり、`DEBUG`、`OPTIM`、`C_WARNFLAGS`のデフォルト値もオーバーライドできます。


デフォルトをオーバーライドするためにユーザー提供のmakefileプリアンブルでビルド

`make -j USER_MAKE_CONF=Makefile.settings`

`Makefile.settings`は`OPTIM := -Os`のような単純な設定や、追加のルールと依存関係メカニズムを含む詳細なmakefileコードを含むことができます。


最小構成でビルド

`make -j SINGLETHREADED=1 NO_STDIO=1 DEBUG= OPTIM=-Os EXTRA_CFLAGS="-DWOLFSENTRY_NO_CLOCK_BUILTIN -DWOLFSENTRY_NO_MALLOC_BUILTIN -DWOLFSENTRY_NO_ERROR_STRINGS -Wno-error=inline -Wno-inline"`

ユーザー設定でビルドしてテスト

`make -j USER_SETTINGS_FILE=user_settings.h test`

FreeRTOSとlwIPソースツリーが図示のように配置されていると仮定して、ARM32上のFreeRTOS用にビルド

`make -j HOST=arm-none-eabi RUNTIME=FreeRTOS-lwIP FREERTOS_TOP=../third/FreeRTOSv202212.00 LWIP_TOP=../third/lwip EXTRA_CFLAGS=-mcpu=cortex-m7`


## プロジェクト例

`wolfsentry/examples/`サブディレクトリに、一連のサンプルポートとアプリケーションを配置しています。
具体的には、Linux D-Bus機能と統合した、TLS対応組み込みWebサーバーを実装するデモポップアップ通知システムなどがあります。

APIの使用法に関するより包括的な例は`tests/unittests.c`、特に`test_static_routes()`、`test_dynamic_rules()`、`test_json()`、`tests/test-config*.json`のJSON設定ファイルにあります。

[wolfSSLリポジトリ](https://github.com/wolfSSL/wolfssl)では、`WOLFSSL_WOLFSENTRY_HOOKS`で保護された`wolfssl/test.h`内のコードをご参照ください。
これには`wolfsentry_store_endpoints()`、`wolfSentry_NetworkFilterCallback()`、`wolfsentry_setup()`、`tcp_connect_with_wolfSentry()`が含まれます。
また、`WOLFSSL_WOLFSENTRY_HOOKS`で保護された`examples/server/server.c`と`examples/client/client.c`内のコードもお役に立つかもしれません。

wolfSSL統合でビルドするには`--enable-wolfsentry`でwolfSSLを設定し、wolfSentryが非標準の場所にインストールされている場合は`--with-wolfsentry=/インストールパス`を使用してください。
wolfSSLテストクライアント/サーバーは、`--wolfsentry-config <file>`を使用して、コマンドラインからユーザー提供のwolfSentry JSON設定をロードできます。
