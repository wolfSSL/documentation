# イントロダクション

wolfSSL JNI/JSSE は、Java Secure Socket Extension (JSSE)のプロバイダー実装です。 また、ネイティブの wolfSSL SSL/TLS ライブラリの薄い JNI ラッパーも含んでいます。代わりにJCE（Java Cryptography Extension）プロバイダーをお探しの場合は、[wolfCrypt JNI/JCE](https://www.wolfssl.com/documentation/manuals/jp/wolfcryptjni/)を参照してください。wolfSSLはこれらのプロバイダー（JSSEとJCE）の両方を積極的にメンテナンスしています。

Java Secure Socket Extension ( **JSSE** ) フレームワークは、セキュリティプロバイダのインストールをサポートしています。 セキュリティプロバイダーは、SSL/TLS など、Java JSSE セキュリティ API で使用される機能のサブセットを実装できます。

このドキュメントでは、wolfSSL の JSSE プロバイダーの実装 "**wolfJSSE / wolfProvider**" について説明しています。 wolfJSSE は、ネイティブの wolfSSL SSL/TLS ライブラリをラップします。 このインターフェースにより、Java アプリケーションは [TLS 1.3](https://wolfssl.jp/products/product-wolfssl-tls1-3/)までの現在の SSL/TLS 標準、[FIPS 140-2 および 140-3](https://wolfssl.jp/products/wolfcrypt-fips/) サポート、パフォーマンスの最適化、ハードウェア暗号化のサポート、[商用サポート](https://wolfssl.jp/license/support-packages/)等々のwolfSSL を使用して得られるすべての利点を享受できます。

wolfJSSE は、"**wolfssljni**"パッケージの一部として配布されます。
