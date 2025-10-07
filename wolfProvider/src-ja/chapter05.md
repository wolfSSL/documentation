# ログ出力

wolfProviderは、情報提供とデバッグを目的としたログメッセージの出力をサポートしています。 
デバッグログ出力を有効にするには、最初にデバッグサポートを有効にしてwolfProviderをコンパイルする必要があります。 
autoconfを使用している場合、これは`./configure`に`--enable-debug`オプションを加えることで実現できます。

```
./configure --enable-debug
```

autoconf/configureを使用しない場合は、wolfProviderライブラリをコンパイルする際に `WOLFPROV_DEBUG` を定義します。

## ログ出力レベルの制御

wolfProviderは以下のログ出力レベルをサポートします。
これらは、`include/wolfprovider/wp_logging.h`で、`wolfProvider_LogType enum`の一部として定義しています。

| ログ出力レベル   | 意味 | レベル値 | 
| :---------------- |  :------------------------------|:----------------- |
| WP_LOG_ERROR    | エラーログを出力                   | 0x0001 |
| WP_LOG_ENTER    | 関数に入った際にログを出力           | 0x0002 |
| WP_LOG_LEAVE    | 関数を抜ける際にログを出力           | 0x0004 |
| WP_LOG_INFO     | 情報提供のメッセージをログを出力      | 0x0008 |
| WP_LOG_VERBOSE  | 暗号化/復号のデータを含めた詳細ログを出力 | 0x0010 |
| WP_LOG_LEVEL_DEFAULT | デフォルトのログレベル（VERBOSE以外を全て含む） | WP_LOG_ERROR &#124; WP_LOG_ENTER &#124; WP_LOG_LEAVE &#124; WP_LOG_INFO |
| WP_LOG_LEVEL_ALL WP_LOG_ERROR | 全てのログを出力 | WP_LOG_ENTER &#124; WP_LOG_LEAVE &#124; WP_LOG_INFO &#124; WP_LOG_VERBOSE |

デフォルトのwolfProviderログ出力レベルには、`WP_LOG_ERROR`、`WP_LOG_ENTER`、`WP_LOG_LEAVE`、`WP_LOG_INFO`を含みます。 
すなわち、詳細ログ(`WP_LOG_VERBOSE`) を除くすべてのログが出力されます。

ログレベルは、`PROVIDER_ctrl_cmd()`APIまたはOpenSSL構成ファイル設定のいずれかを介して、実行時に"**log_level**"エンジン制御コマンドを使用して制御できます。
例えば、"log_level"制御コマンドを使用してエラーログと情報ログのみを有効にするには、アプリケーションで次のように実装します。

```
#include <wolfprovider/wp_logging.h>

ret = PROVIDER_ctrl_cmd(e, “log_level”, WP_LOG_ERROR | WP_LOG_INFO,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set logging level\n”);
}
```

## コンポーネント単位のログ出力の制御

wolfProviderでは、コンポーネントごとにログを出力できます。
コンポーネントは`include/wolfprovider/wp_logging.h`の`wolfProvider_LogComponents`に定義しています。

| ログ対象コンポーネント | 意味 | コンポーネントを示す値 |
| :----------- |:----------- |:---------- |
| WP_LOG_RNG    | 乱数生成コンポーネント | 0x0001 |
| WP_LOG_DIGEST | ダイジェストコンポーネント (SHA-1/2/3) | 0x0002 |
| WP_LOG_MAC    | MAC機能コンポーネント (HMAC, CMAC) | 0x0004 |
| WP_LOG_CIPHER | 暗号化コンポーネント(AES, 3DES) | 0x0008 |
| WP_LOG_PK     | 公開鍵コンポーネント (RSA, ECC) | 0x0010 |
| WP_LOG_KE     | 鍵合意コンポーネント (DH, ECDH) | 0x0020 |
| WP_LOG_KDF    | パスワードベースの鍵導出コンポーネント | 0x0040 |
| WP_LOG_PROVIDER | すべてのプロバイダー固有ログを有効化 | 0x0080 |
| WP_LOG_COMPONENTS_ALL | すべてのコンポーネントログを有効化 | WP_LOG_RNG &#124; WP_LOG_DIGEST &#124; WP_LOG_MAC &#124; WP_LOG_CIPHER &#124; WP_LOG_PK &#124; WP_LOG_KE &#124; WP_LOG_PROVIDER |
| WP_LOG_COMPONENTS_DEFAULT | デフォルト構成 (すべてのログを有効化) | WP_LOG_COMPONENTS_ALL |

デフォルトでは、すべてのコンポーネントを対象としてログを出力します(`WP_LOG_COMPONENTS_DEFAULT`)。

ログ出力の対象とするコンポーネントは、`PROVIDER_ctrl_cmd()`APIまたはOpenSSL構成ファイル設定のいずれかを介して、
実行時に"**log_components**"エンジン制御コマンドを使用して制御できます。 
たとえば、DigestおよびCipherアルゴリズムのみのログ出力を有効にするには、次のようにします。

```
#include <wolfprovider/wp_logging.h>

ret = PROVIDER_ctrl_cmd(e, “log_components”, WP_LOG_DIGEST | WP_LOG_CIPHER,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set log components\n”);
}
```

## カスタムログ出力コールバックの設定

デフォルトでは、wolfProviderは **fprintf()** を使用してデバッグログメッセージを **stderr** に出力します。

ログメッセージの出力方法や出力場所を変更したい場合は、カスタムログ出力コールバック関数を記述してwolfProviderに登録します。 
その際、`include/wolfprovider/wp_logging.h`に示す`wolfProvider_Logging_cb`のプロトタイプ宣言と一致させる必要があります。

```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (*wolfProvider_Logging_cb)(const int logLevel, const int component, const char *const logMessage);
```

その後、"**set_logging_cb**"エンジン制御コマンドを使用して、コールバック関数をwolfProviderに登録できます。 
例えば、`PROVIDER_ctrl_cmd()`APIを使用してカスタムログ出力コールバック関数を設定するには次のようにします。


```
void customLogCallback(const int logLevel, const int component,
const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, “wolfProvider log message: %d\n”, logMessage);
}

int main (void)
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
