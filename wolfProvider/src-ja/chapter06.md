# 移植性

wolfProviderは、関連するwolfCryptおよびOpenSSLライブラリの移植性を活用するように設計しています。

## 対応プラットフォーム

wolfProviderはクロスプラットフォームであり、wolfSSLおよびOpenSSLがサポートする主要なプラットフォーム上でビルドできます。
対応プラットフォームは以下の通りです。

* Linuxおよびその他の*nix系システム。autoconfシステムを使用してビルドします([wolfProviderのビルド](chapter03.md)を参照)
* macOS
* Windows。`libwolfprov.dll`をビルドするVisual Studio 2022ソリューションを使用します([wolfProviderのビルド](chapter03.md)を参照)
* Android。`IDE/Android`以下のビルドスクリプトを使用します
* Appleプラットフォーム。`IDE/XCODE`以下のフレームワークビルドスクリプトを使用します

Linux、macOS、Windows、Androidでは、FIPSビルドと非FIPSビルドの両方をサポートしています(Androidビルドは`USE_FIPS`オプションによるFIPS Readyをサポートします)。

## スレッド対応

wolfProviderはスレッドセーフであり、必要に応じてwolfCryptのミューテックスロックメカニズム`wc_LockMutex()`、`wc_UnLockMutex()`を使用します。
wolfCryptには、サポートしているプラットフォーム用に抽象化されたミューテックス操作があります。

ただし、グローバル構成の設定関数は例外です。ログ設定関数(`wolfProv_SetLogLevel()`、`wolfProv_SetLogComponents()`、`wolfProv_SetLoggingCb()`)とFIPSチェック状態は、内部同期を行わずにプロセス全体の状態を更新します。他のスレッドがプロバイダーを使用する前に、初期化時に一度だけ設定してください。

## 動的メモリ使用

wolfProviderはOpenSSLのメモリ割り当て関数を使用して、OpenSSLの動作との一貫性を維持します。
wolfProviderの内部で使用される割り当て関数には、`OPENSSL_malloc()`、`OPENSSL_free()`、`OPENSSL_zalloc()`、`OPENSSL_realloc()`があります。

## ログ出力

wolfProviderはデフォルトで`fprintf()`によりstderrにログを出力します。
アプリケーションは、カスタムロギング関数を登録することでこれをオーバーライドできます。
詳しくは[5章](chapter05.md)をご覧ください。

wolfProviderをコンパイルする際、以下のマクロを追加することでログの動作を調整できます。

**WOLFPROV_USER_LOG** - ログ出力に使用する関数名を定義するマクロ。`fprintf`の代わりに使用するカスタムログ関数を指定できます。

**WOLFPROV_LOG_PRINTF** - `fprintf(stderr)`ではなく`printf(stdout)`を使用するよう切り替えるマクロ。`WOLFPROV_USER_LOG`またはカスタムログコールバックを使用している場合は適用されません。
