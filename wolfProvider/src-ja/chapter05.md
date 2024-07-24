# ロギング

wolfProvider は、情報提供とデバッグを目的としたログ メッセージの出力をサポートしています。 デバッグ ロギングを有効にするには、最初にデバッグ サポートを有効にして wolfProvider をコンパイルする必要があります。 Autoconf を使用している場合、これは `./configure` に `--enable-debug` オプションを使用して行われます：
```
./configure --enable-debug
```

Autoconf/configure を使用しない場合は、wolfProvider ライブラリをコンパイルするときに `WOLFPROVIDER_DEBUG` を定義します。

## デバッグログの有効化/無効化

デバッグ サポートがライブラリにコンパイルされたら、セクション 5 で指定された wolfProvider コントロール コマンドを使用して実行時にデバッグを有効にする必要があります。 0" を指定すると、ロギングが無効になります。 `PROVIDER_ctrl_cmd()` API を使用してロギングを有効にするには:

```
int ret = 0;
ret = PROVIDER_ctrl_cmd(e, “enable_debug”, 1, NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to enable debug logging\n”);
}
```

wolfProvider がデバッグ サポートを有効にしてコンパイルされていない場合、`PROVIDER_ctrl_cmd()` で `enable_debug` を設定しようとすると失敗 (0) が返されます。

## ロギングレベルの制御

wolfProvider は以下のロギング レベルをサポートします。 これらは、"include/wolfprovider/wp_logging.h"ヘッダー ファイルで、wolfProvider_LogType enum の一部として定義されています:

| ロギングレベル   | 意味 | レベル値 | 
| :-------------- |  :------------------------------|:-------------------- |
| WP_LOG_ERROR    | エラーをロギングする              | 0x0001 |
| WP_LOG_ENTER    | 関数に入った際にロギングする       | 0x0002 |
| WP_LOG_LEAVE    | 関数を抜ける際にロギングする       | 0x0004 |
| WP_LOG_INFO     | 情報提供のメッセージをロギングする  | 0x0008 |
| WP_LOG_VERBOSE  | 暗号化/復号のデータを含めた詳細ログ | 0x0010 |
| WP_LOG_LEVEL_DEFAULT | デフォルトのログレベル（VERBOS以外を全て含む） | WP_LOG_ERROR &#124; WP_LOG_ENTER &#124; WP_LOG_LEAVE &#124; WP_LOG_INFO |
|WP_LOG_LEVEL_ALL WP_LOG_ERROR | 全ログレベルが有効 | WP_LOG_ENTER &#124; WP_LOG_LEAVE &#124; WP_LOG_INFO &#124; WP_LOG_VERBOSE |


デフォルトの wolfProvider ロギング レベルには、"WP_LOG_ERROR"、"WP_LOG_ENTER"、"WP_LOG_LEAVE"、および"WP_LOG_INFO"が含まれます。 これには、詳細ログ (`WP_LOG_VERBOSE`) を除くすべてのログ レベルが含まれます。

ログ レベルは、`PROVIDER_ctrl_cmd()` API または OpenSSL 構成ファイル設定のいずれかを介して、実行時に"**log_level**"エンジン制御コマンドを使用して制御できます。 たとえば、"log_level"制御コマンドを使用してエラー ログと情報ログのみを有効にするには、アプリケーションで次のように呼び出します:

```
#include <wolfprovider/wp_logging.h>

ret = PROVIDER_ctrl_cmd(e, “log_level”, WP_LOG_ERROR | WP_LOG_INFO,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set logging level\n”);
}
```

## コンポーネント単位のロギングの制御

wolfProvider では、コンポーネントごとにログを記録できます。 コンポーネントは `include/wolfprovider/wp_logging.h` の wolfProvider_LogComponents 列挙で定義されます:

| ログ対象コンポーネント | 意味 | コンポーネントを示す値 |
| :------------------- |:---- |:-------------------- |
| WP_LOG_RNG    | ランダム数生成コンポーネント | 0x0001 |
| WP_LOG_DIGEST | ダイジェストコンポーネント (SHA-1/2/3) | 0x0002 |
| WP_LOG_MAC    | MAC機能コンポーネント (HMAC, CMAC) | 0x0004 |
| WP_LOG_CIPHER | 暗号化コンポーネント(AES, 3DES) | 0x0008 |
| WP_LOG_PK     | 公開鍵コンポーネント (RSA, ECC) | 0x0010 |
| WP_LOG_KE     | 鍵合意コンポーネント (DH, ECDH) | 0x0020 |
| WP_LOG_PROVIDER | エンジン特有 | 0x0040 |
| WP_LOG_COMPONENTS_ALL | 全コンポーネント | WP_LOG_RNG &#124; WP_LOG_DIGEST &#124; WP_LOG_MAC &#124; WP_LOG_CIPHER &#124; WP_LOG_PK &#124; WP_LOG_KE &#124; WP_LOG_PROVIDER |
| WP_LOG_COMPONENTS_DEFAULT | デフォルトコンポーネント (all). | WP_LOG_COMPONENTS_ALL |


デフォルトの wolfProvider ロギング構成は、すべてのコンポーネントをログに記録します (`WP_LOG_COMPONENTS_DEFAULT`)。

ログに記録されたコンポーネントは、`PROVIDER_ctrl_cmd()` API または OpenSSL 構成ファイル設定のいずれかを介して、実行時に"**log_components**"エンジン制御コマンドを使用して制御できます。 たとえば、Digest および Cipher アルゴリズムのロギングのみをオンにするには、次のようにします：
```
#include <wolfprovider/wp_logging.h>

ret = PROVIDER_ctrl_cmd(e, “log_components”, WP_LOG_DIGEST | WP_LOG_CIPHER,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set log components\n”);
}
```
## カスタムロギングコールバックの設定

デフォルトでは、wolfProvider は **fprintf()** を使用してデバッグ ログ メッセージを **stderr** に出力します。

ログ メッセージの出力方法や出力場所をより詳細に制御したいアプリケーションは、カスタム ロギング コールバックを記述して wolfProvider に登録できます。 ロギング コールバックは、`include/wolfprovider/wp_logging.h` の wolfProvider_Logging_cb のプロトタイプと一致する必要があります:

```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (*wolfProvider_Logging_cb)(const int logLevel, const int component, const char *const logMessage);
```

その後、"**set_logging_cb**"エンジン制御コマンドを使用して、コールバックを wolfProvider に登録できます。 たとえば、`PROVIDER_ctrl_cmd()` API を使用してカスタム ロギング コールバックを設定するには、次のようにします:


```
void customLogCallback(const int logLevel, const int component,
const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, “wolfProvider log message: %d\n”, logMessage);
}

int **main** (void)
{
    int ret;
    PROVIDER* e;
...
    ret = PROVIDER_ctrl_cmd(e, “set_logging_cb”, 0, NULL, (void(*)(void))my_Logging_cb, 0);
    if (ret != 1) {
        /* failed to set logging callback */
    }
...
}
```
