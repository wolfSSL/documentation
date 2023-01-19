

# デバッグ




## デバッグとロギング



wolfSSL(以前のCyassl)は、デバッグが制限されている環境でログメッセージを介したデバッグをサポートしています。ロギングをオンにするには、機能[`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on)を使用し、それをオフにするために[`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off)をオフにします。通常のビルド(リリースモード)では、これらの関数は効果がありません。デバッグビルドで、これらの機能がオンになっていることを確認するために`DEBUG_WOLFSSL`を定義します。


wolfSSL 2.0以降、ロギングコールバック関数はランタイムに登録されて、ログ記録の完了方法をより柔軟に提供することができます。ロギングコールバックは機能[`wolfSSL_SetLoggingCb()`](group__Logging.md#function-wolfssl_setloggingcb)に登録できます。



```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```



ログレベルは`wolfssl/wolfcrypt/logging.h`にあり、実装は`logging.c`にあります。デフォルトでは、wolfsslは`stderr`に`fprintf`でロギングします。



## エラーコード



wolfSSLは、デバッグを支援するために、有益なエラーメッセージを提供します。


各[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)および[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)呼び出しは、`read()`と`write()`と同じように、成功時に0、接続クロージャーの場合は0、およびエラーの間のバイト数を返します。エラーが発生した場合は、2つのAPIを使用して、エラーの情報を入手できます。


関数[`wolfSSL_get_error()`](group__Debug.md#function-wolfssl_get_error)は現在のエラーコードを返します。現在の`WOLFSSL`オブジェクト、および[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)または[`wolfSSL_write()`](group__IO.md#function-wolfssl_write)の結果値を引数として取得し、対応するエラーコードを返します。



```c
int err=wolfSSL_get_error(ssl, result);
```



より読み取り可能なエラーコードの説明を取得するには、[`wolfSSL_ERR_error_string()`](group__Debug.md#function-wolfssl_err_error_string)関数を使用できます。[`wolfSSL_get_error`](group__Debug.md#function-wolfssl_get_error)からのリターンコードとストレージバッファーを引数として取得し、対応するエラーの説明をストレージバッファー(以下の例の`errorString`)に配置します。



```c
char errorString[80];
wolfSSL_ERR_error_string(err, errorString);
```



ノンブロッキングソケットを使用している場合は、EEAGAIN/EWOULDBLOCKをテストするか、`SSL_ERROR_WANT_READ`または`SSL_ERROR_WANT_WRITE`の特定のエラーコードをテストできます。

wolfSSLとWolfCryptエラーコードのリストについては、付録C(エラーコード)を参照してください。
