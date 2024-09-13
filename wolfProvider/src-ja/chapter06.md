# 移植性

wolfProviderは、関連するwolfCryptおよびOpenSSLライブラリの移植性を活用するように設計しています。

## スレッド対応

wolfProviderはスレッドセーフであり、必要に応じてwolfCryptのミューテックスロックメカニズム`wc_LockMutex()`、`wc_UnLockMutex()`を使用します。
wolfCryptには、サポートしているプラットフォーム用に抽象化されたミューテックス操作があります。

## 動的メモリ使用

wolfProviderはOpenSSLのメモリ割り当て関数を使用して、OpenSSLの動作との一貫性を維持します。
wolfProviderの内部で使用される割り当て関数には、`OPENSSL_malloc()`、`OPENSSL_free()`、`OPENSSL_zalloc()`、`OPENSSL_realloc()`があります。

## ログ出力

wolfProviderはデフォルトで`fprintf()`によりstderrにログを出力します。
アプリケーションは、カスタムロギング関数を登録することでこれをオーバーライドできます。
詳しくは[5章](chapter05.md)をご覧ください。

wolfProviderをコンパイルする際、以下のマクロを追加することでログの動作を調整できます。

**WOLFPROVIDER_USER_LOG** - ログ出力の関数名を定義するマクロ。お客様はこれをfprintfの代わりに使用するカスタムログ関数として定義できます。

**WOLFPROVIDER_LOG_PRINTF** - `fprintf(stderr)`ではなく、代わりに`printf(stdout)`を使用するように定義します。`WOLFPROVIDER_USER_LOG`またはカスタムロギングコールバックを使用している場合は適用されません。
