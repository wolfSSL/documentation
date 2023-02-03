# Engine コントロールコマンド

wolfEngine は、アプリケーションが wolfEngine の動作を変更したり、内部設定を調整したりできるように、いくつかのエンジン制御コマンドを公開しています。 現在、次の制御コマンドがサポートされています:

| コントロールコマンド | 意味 | 設定値 |
| ----------- | --------------- | ----------- |
| enable_debug | wolfEngineのデバッグ出力を有効にします | 1 = 有効, 0 = 無効。 詳細は [Chapter 6](chapter06.md)を参照 |
| log_level | ロギングレベルを設定します | “include/wolfengine/we_logging.h”ファイルに定義されたwolfEngine_LogTypeのビットマスク値. 詳細は [Chapter 6](chapter06.md)を参照 |
| log_components | ログ出力するコンポーネントを指定します | “include/wolfengine/we_logging.h”ファイルに定義されたwolfEngine_LogComponentsのビットマスク値. 詳細は [Chapter 6](chapter06.md)を参照|
| set_logging_cb | ロギングコールバックをセットします | ログメッセージの出力に使用される関数への関数ポインタ。 関数は、we_logging.h の wolfEngine_Logging_cb プロトタイプと一致する必要があります。詳細は [Chapter 6](chapter06.md)を参照 |



エンジン制御コマンドは、`OpenSSL の ENGINE_ctrl_cmd()` API を使用して設定できます。 たとえば、デバッグ ロギングを有効にするには、次のように呼び出します:

```
int ret = 0;
ret = ENGINE_ctrl_cmd(e, “enable_debug”, 1, NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to enable debug logging\n”);
}
```
一部の制御コマンドは、OpenSSL 構成ファイルを介して設定することもできます。 OpenSSL エンジン制御コマンドの使用法に関するその他のドキュメントは、OpenSSL の man ページにあります：


[https://www.openssl.org/docs/man1.0.2/man3/engine.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)

[https://www.openssl.org/docs/man1.1.1/man3/ENGINE_ctrl_cmd.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)

[https://www.openssl.org/docs/man1.1.1/man3/ENGINE_ctrl_cmd_string.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)
