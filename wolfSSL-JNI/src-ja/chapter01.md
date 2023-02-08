# イントロダクション

wolfSSL JNI/JSSE は、Java Secure Socket Extension のプロバイダー実装です。 また、ネイティブの wolfSSL SSL/TLS ライブラリの薄い JNI ラッパーも含んでいます。

Java Secure Socket Extension ( **JSSE** ) フレームワークは、セキュリティプロバイダのインストールをサポートしています。 セキュリティプロバイダーは、SSL/TLS など、Java JSSE セキュリティ API で使用される機能のサブセットを実装できます。

このドキュメントでは、wolfSSL の JSSE プロバイダーの実装 "**wolfJSSE**" について説明しています。 wolfJSSE は、ネイティブの wolfSSL SSL/TLS ライブラリをラップします。 このインターフェースにより、Java アプリケーションは [TLS 1.3](https://www.wolfssl.com/tls13)までの現在の SSL/TLS 標準、[FIPS 140-2 および 140-3](https://www.wolfssl.com/license/fips/) サポート、パフォーマンスの最適化、ハードウェア暗号化のサポート、[商用サポート](https://www.wolfssl.com/products/support-and-maintenance/)等々のwolfSSL を使用して得られるすべての利点を享受できます。

wolfJSSE は、"**wolfssljni**"パッケージの一部として配布されます。 このパッケージには、wolfSSL 用の薄い JNI ラッパーと wolfJSSE プロバイダーの両方が含まれています。

