# デバッグ

## デバッグとロギング

wolfSSL（旧称CyaSSL）は、デバッグが制限されている環境でのログメッセージによるデバッグをサポートしています。
ロギングをオンにするには関数[`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on)を使用し、オフにするには[`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off)を使用します。
通常のビルド（リリースモード）では、これらの関数は効果がありません。
デバッグビルドでは、これらの関数が確実にオンになるように[`DEBUG_WOLFSSL`](chapter02.md#debug_wolfssl)を定義してください。
configureオプション[`--enable-debug`](chapter02.md#--enable-debug)は`DEBUG_WOLFSSL`を定義します。
これが定義されていない場合、`wolfSSL_Debugging_ON()`と`wolfSSL_SetLoggingCb()`は`NOT_COMPILED_IN`を返します。

wolfSSL 2.0以降では、ロギングの方法についてより柔軟性を提供するために、ランタイムでロギングコールバック関数を登録できます。
ロギングコールバックは関数[`wolfSSL_SetLoggingCb()`](group__Logging.md#function-wolfssl_setloggingcb)で登録できます。

```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```

ログレベルは`wolfssl/wolfcrypt/logging.h`にあり、実装は`logging.c`にあります。
デフォルトでは、wolfSSLは`fprintf`を使用して`stderr`にログを出力します。

### ログ出力の制御

ロギングコールバックが登録されていない場合、コンパイル時に出力先を変更できます。

* `WOLFSSL_DEBUG_PRINTF_FN`は`fprintf`を別のprintf形式の関数に置き換えます。また、`WOLFSSL_DEBUG_PRINTF_FIRST_ARGS`はその先頭の引数（デフォルトでは末尾のカンマを含む`stderr,`です。空に定義することもできます）を置き換えます。
* `WOLFSSL_USER_LOG(msg)`は、完全なログメッセージを1件ずつ受け取る関数またはマクロとして定義できます。

`wolfSSL_SetLoggingPrefix()`は、デフォルトの`WOLFSSL_DEBUG_PRINTF_FN`の出力で書き込まれる各メッセージの前に、角括弧で囲んで出力されるプレフィックス文字列を設定します（ロギングコールバックには渡されません）。
コンパイラがスレッドローカルストレージをサポートしている場合、プレフィックスはスレッドごとに保存されます。
これは、例えば1つのプロセス内で動作するクライアントとサーバーを区別するのに便利です。

証明書関連のデバッグメッセージは、デバッグ出力の一部です。
これらは`DEBUG_WOLFSSL`を定義するとデフォルトで有効になり、`NO_WOLFSSL_DEBUG_CERTS`で無効にできます。
`DEBUG_WOLFSSL`なしで[`WOLFSSL_DEBUG_CERTS`](chapter02.md#wolfssl_debug_certs)を定義すると、証明書メッセージのみがコンパイルされます。
この場合、証明書メッセージは`wolfSSL_CertDebugging_ON()`が呼び出されるまで実行時には出力されません（このようなビルドでは`wolfSSL_Debugging_ON()`は`NOT_COMPILED_IN`を返します）。
最初から出力するには、`WOLFSSL_CERT_LOG_ENABLED_DEFAULT`を1に定義します。
`wolfSSL_CertDebugging_OFF()`で再び無効にできます。

2つのconfigureオプションで、デバッグ出力にさらに詳細な情報を追加できます。

* `--enable-debug-code-points`は、デバッグメッセージにソースファイル名と行番号を追加します（`WOLFSSL_DEBUG_CODEPOINTS`）。
* `--enable-debug-trace-errcodes`は、ライブラリのエラーコードが発生した箇所でトレースメッセージを出力します（`WOLFSSL_DEBUG_TRACE_ERROR_CODES`）。`--enable-debug-trace-errcodes=backtrace`を指定すると、`libbacktrace`を使用してバックトレースも出力します。

### 詳細ログ

wolfSSL 5.9.4では、最も出力量の多いトレースメッセージが別の階層（`WOLFSSL_MSG_VERBOSE()`と`WOLFSSL_ENTER_VERBOSE()`）に移されました。
これらは、コンテナのヘルパー関数や名前エントリの処理など、1回のAPI呼び出しで数千回実行されることがあるコードのメッセージです。
これらは通常の`DEBUG_WOLFSSL`ビルドではコンパイル時に除外されるため、デバッグ出力の量が大幅に削減されます（ユニットテストスイートでは約62%）。
これらを表示するには、`DEBUG_WOLFSSL`に加えて`WOLFSSL_VERBOSE_LOGGING`を定義します。

```sh
./configure --enable-debug CPPFLAGS=-DWOLFSSL_VERBOSE_LOGGING
```

`WOLFSSL_VERBOSE_LOGGING`単独では何も出力されません。
このマクロは、すでにロギングを行っているビルドに詳細トレースを追加するだけです。
従来OpenSSL互換レイヤー内で同じ役割を果たしていた`WOLFSSL_DEBUG_OPENSSL`マクロは、現在はこのマクロのエイリアスとして機能します。

## エラーコード

wolfSSLは、デバッグを支援するために、有益なエラーメッセージを提供するよう努めています。

[//]: # (This is a comment. links to group__IO.md and group__Debug.md are causing lines to be truncated so I have removed references to them.)

`wolfSSL_read()`と`wolfSSL_write()`の呼び出しは、成功時には読み書きしたバイト数、接続終了時には0、エラー時には-1を返します。
これは`read()`や`write()`と同様です。
エラーが発生した場合には、以下の2つのAPIを使用してより詳しい情報を入手できます。

関数`wolfSSL_get_error()`は、現在のエラーコードを返します。
現在の`WOLFSSL`オブジェクトと`wolfSSL_read()`または`wolfSSL_write()`の結果値を引数として取り、対応するエラーコードを返します。

```c
int err = wolfSSL_get_error(ssl, result);
```

人間が読みやすいエラーコードの説明を得るには、`wolfSSL_ERR_error_string()`を使用します。
この関数は`wolfSSL_get_error`の戻り値と出力保存用のバッファを引数として取り、対応するエラーの説明をそのバッファ（以下の例では`errorString`）に出力します。

```c
char errorString[WOLFSSL_MAX_ERROR_SZ];
wolfSSL_ERR_error_string(err, errorString);
```

バッファには少なくとも`WOLFSSL_MAX_ERROR_SZ`バイト（デフォルトでは80、一部の構成では200）の領域が必要です。
代わりに、バッファ長を引数に取る`wolfSSL_ERR_error_string_n(err, buf, sizeof(buf))`を使用することもできます。
wolfCrypt関数の戻り値については、`wc_GetErrorString()`が説明文字列を返します。

ノンブロッキングソケットを使用している場合、errnoのEAGAIN/EWOULDBLOCKをテストするか、より正確には特定のエラーコード`WOLFSSL_ERROR_WANT_READ`または`WOLFSSL_ERROR_WANT_WRITE`をテストできます。

[付録F エラーコード](appendix06.md)に、wolfSSLとwolfCryptのエラーコード一覧を掲載しています。
