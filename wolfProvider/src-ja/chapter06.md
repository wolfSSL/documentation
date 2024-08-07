# 移植性

wolfProvider は、関連する wolfCrypt および OpenSSL ライブラリの移植性を活用するように設計されています。

## スレッド対応

wolfProvider はスレッド セーフであり、必要に応じて wolfCrypt (`wc_LockMutex()`、`wc_UnLockMutex()`) のミューテックス ロック メカニズムを使用します。 wolfCrypt には、サポートされているプラットフォーム用に抽象化されたミューテックス操作があります。

## 動的メモリ使用

wolfProvider は、OpenSSL のメモリ割り当て関数を使用して、OpenSSL の動作との一貫性を維持します。 wolfProvider の内部で使用される割り当て関数には、"OPENSSL_malloc()"、"OPENSSL_free()"、"OPENSSL_zalloc()"、および"OPENSSL_realloc()"が含まれます。

## ロギング

wolfProvider はデフォルトで `fprintf()` 経由で stderr にログを記録します。 アプリケーションは、カスタム ロギング関数を登録することでこれをオーバーライドできます ([第 6 章](chapter06.md) を参照)。

ログの動作を調整するために wolfProvider をコンパイルするときに定義できる追加のマクロには、次のものがあります：

**WOLFPROVIDER_USER_LOG** - ログ出力の関数名を定義するマクロ。 ユーザーは、これを fprintf の代わりに使用するカスタム ログ関数に定義できます

**WOLFPROVIDER_LOG_PRINTF** - fprintf (stderr) を切り替えて、代わりに printf (stdout) を使用するように定義します。 WOLFPROVIDER_USER_LOG またはカスタム ロギング コールバックを使用している場合は適用されません。
