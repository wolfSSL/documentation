# ログ出力

wolfProviderは、情報提供とデバッグを目的としたログメッセージの出力をサポートしています。 
デバッグログ出力を有効にするには、最初にデバッグサポートを有効にしてwolfProviderをコンパイルする必要があります。 
autoconfを使用している場合、これは`./configure`に`--enable-debug`オプションを加えることで実現できます。

```
./configure --enable-debug
```

autoconf/configureを使用しない場合は、wolfProviderライブラリをコンパイルする際に `WOLFPROV_DEBUG` を定義します。

## ログ出力レベルの制御

wolfProviderは以下のログ出力レベルをサポートします。これらは`include/wolfprovider/wp_logging.h`ヘッダーファイル内のプリプロセッサマクロとして定義されています。

| ログ列挙値 | 説明 | 値 |
| :---------------- | :------------------------------ | :----------------- |
| WP_LOG_LEVEL_ERROR | エラーを出力 | 0x0001 |
| WP_LOG_LEVEL_ENTER | 関数に入る際にログを出力 | 0x0002 |
| WP_LOG_LEVEL_LEAVE | 関数を抜ける際にログを出力 | 0x0004 |
| WP_LOG_LEVEL_INFO | 情報メッセージを出力 | 0x0008 |
| WP_LOG_LEVEL_VERBOSE | 暗号化、復号、ダイジェスト対象のデータを含む詳細ログを出力 | 0x0010 |
| WP_LOG_LEVEL_DEBUG | wolfSSLの戻り値を含むデバッグレベルの詳細を出力 | 0x0020 |
| WP_LOG_LEVEL_TRACE | トレースレベルの非常に詳細な情報を出力 | 0x0040 |
| WP_LOG_LEVEL_DEFAULT | デフォルトのログレベル | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO |
| WP_LOG_LEVEL_ALL | すべてのログレベルを有効化 | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_ENTER &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO &#124; WP_LOG_LEVEL_VERBOSE &#124; WP_LOG_LEVEL_DEBUG &#124; WP_LOG_LEVEL_TRACE |

デフォルトのwolfProviderログ出力レベル(`WP_LOG_LEVEL_DEFAULT`)には、`WP_LOG_LEVEL_ERROR`、`WP_LOG_LEVEL_LEAVE`、`WP_LOG_LEVEL_INFO`が含まれます。

実行時に有効化できるログレベルとコンポーネントは、コンパイル時フィルター`WOLFPROV_LOG_LEVEL_FILTER`と`WOLFPROV_LOG_COMPONENTS_FILTER`によって制限されます。これらは`wp_logging.h`で定義され、デフォルト値はそれぞれ`WP_LOG_LEVEL_DEFAULT`と`WP_LOG_COMP_DEFAULT`です。ビルド時にフィルターから除外されたレベルやコンポーネントを実行時に有効化することはできません。例えば`WP_LOG_LEVEL_DEBUG`や`WP_LOG_LEVEL_VERBOSE`を有効化するには、コンパイル時に`WOLFPROV_LOG_LEVEL_FILTER`を拡張してください。

ログレベルは`wolfProv_SetLogLevel(int mask)`で制御できます。エラーログと情報ログのみを有効化する例を次に示します。

```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

int main(void)
{
    int ret = wolfProv_SetLogLevel(WP_LOG_LEVEL_ERROR | WP_LOG_LEVEL_INFO);
    if (ret != 0) {
        printf("Failed to set logging level\n");
    }
    return 0;
}
```

## コンポーネント単位のログ出力の制御

wolfProviderでは、コンポーネントごとにログを出力できます。コンポーネントは`include/wolfprovider/wp_logging.h`内のプリプロセッサマクロとして定義されています。

| ログコンポーネント列挙値 | 説明 | 値 |
| :------------------------------ | :--------------- | :-------------------------------- |
| WP_LOG_COMP_RNG | 乱数生成 | 0x0001 |
| WP_LOG_COMP_DIGEST | ダイジェスト(SHA-1/2/3) | 0x0002 |
| WP_LOG_COMP_MAC | MAC関数(HMAC、CMAC) | 0x0004 |
| WP_LOG_COMP_CIPHER | 暗号(AES、3DES) | 0x0008 |
| WP_LOG_COMP_PK | 公開鍵アルゴリズム(RSA、ECC) | 0x0010 |
| WP_LOG_COMP_KE | 鍵合意アルゴリズム(DH、ECDH) | 0x0020 |
| WP_LOG_COMP_KDF | 鍵導出アルゴリズム | 0x0040 |
| WP_LOG_COMP_PROVIDER | すべてのプロバイダー固有ログ | 0x0080 |
| WP_LOG_COMP_ALL | すべてのコンポーネントを出力 | 以下のすべてのコンポーネント |
| WP_LOG_COMP_DEFAULT | デフォルトのログ対象コンポーネント(すべて) | WP_LOG_COMP_ALL |

アルゴリズム単位の詳細なコンポーネントも利用できます。`WP_LOG_COMP_RSA`、`WP_LOG_COMP_ECC`、`WP_LOG_COMP_DH`、`WP_LOG_COMP_AES`、`WP_LOG_COMP_SHA`、`WP_LOG_COMP_HMAC`、`WP_LOG_COMP_HKDF`、`WP_LOG_COMP_SSHKDF`、`WP_LOG_COMP_PQC`などがあります。完全な一覧は`wp_logging.h`をご参照ください。

デフォルトでは、すべてのコンポーネントを対象としてログを出力します(`WP_LOG_COMP_DEFAULT`)。

ログ出力の対象コンポーネントは`wolfProv_SetLogComponents(int mask)`で制御できます。ダイジェストおよび暗号アルゴリズムのみのログ出力を有効化する例を次に示します。

```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

int main(void)
{
    int ret = wolfProv_SetLogComponents(WP_LOG_COMP_DIGEST | WP_LOG_COMP_CIPHER);
    if (ret != 0) {
        printf("Failed to set log components\n");
    }
    return 0;
}
```

## カスタムログ出力コールバックの設定

デフォルトでは、wolfProviderは **fprintf()** を使用してデバッグログメッセージを **stderr** に出力します。

ログメッセージの出力方法や出力場所を変更したい場合は、カスタムログ出力コールバック関数を記述してwolfProviderに登録します。 
その際、`include/wolfprovider/wp_logging.h`に示す`wolfProv_Logging_cb`のプロトタイプ宣言と一致させる必要があります。

```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (*wolfProv_Logging_cb)(const int logLevel, const int component, const char *const logMessage);
```

その後、`wolfProv_SetLoggingCb(wolfProv_Logging_cb logf)`を使用してコールバック関数をwolfProviderに登録できます。例を次に示します。

```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

void customLogCallback(const int logLevel, const int component,
    const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, "wolfProvider log message: %s\n", logMessage);
}

int main(void)
{
    int ret;

    ret = wolfProv_SetLoggingCb(customLogCallback);
    if (ret != 0) {
        /* failed to set logging callback */
    }

    return 0;
}
```
