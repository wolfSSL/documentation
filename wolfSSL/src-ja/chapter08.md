# デバッグ

## デバッグとロギング

wolfSSLは、デバッグが制限されている環境でのログメッセージによるデバッグをサポートしています。
ロギングをオンにするには関数`wolfSSL_Debugging_ON()`を使用し、
オフにするには`wolfSSL_Debugging_OFF()`を使用します。
通常のビルド（リリースモード）では、これらの関数は効果がありません。
デバッグビルドでは、これらの関数が確実にオンになるように`DEBUG_WOLFSSL`を定義してください。

wolfSSL 2.0以降では、ロギングの方法についてより柔軟性を提供するために、ランタイムでロギングコールバック関数を登録できます。
ロギングコールバックは関数`wolfSSL_SetLoggingCb()`で登録できます。

```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```

ログレベルは`wolfssl/wolfcrypt/logging.h`にあり、実装は`logging.c`にあります。
デフォルトでは、wolfSSLは`fprintf`を使用して`stderr`にログを出力します。

## エラーコード

デバッグを支援するために、有益なエラーメッセージを提供するよう努めています。

`wolfSSL_read()`と`wolfSSL_write()`の呼び出しは、成功時にはバイト数、接続終了時には0、エラー時には-1を返します。
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
char errorString[80];
wolfSSL_ERR_error_string(err, errorString);
```

ノンブロッキングソケットを使用している場合、`errno EAGAIN/EWOULDBLOCK`をテストするか、
より正確には特定のエラーコード`SSL_ERROR_WANT_READ`または`SSL_ERROR_WANT_WRITE`をテストできます。

[付録F エラーコード](appendix06.md)に、wolfSSLとwolfCryptのエラーコード一覧を掲載しています。
