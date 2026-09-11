# OpenSSLとの互換性

wolfProviderは、OpenSSL 3.xのすべてのリリースバージョンをサポートしています。
OpenSSL 3.0.6から最新の3.xリリースまでの幅広いバージョンに対して、FIPSビルドおよび非FIPSビルドの両方で継続的にテストを行っています。

一部の機能には、OpenSSLの最小バージョン要件があります。

- ポスト量子アルゴリズム（ML-KEM、ML-DSA）およびLMSを使用するには、OpenSSL 3.6以降が必要です。

OpenSSL 3.0.3から3.0.5については、上流のECX `EVP_PKEY_cmp` に関する不具合があるため推奨していません。3.0.xシリーズをご利用の場合は、OpenSSL 3.0.6以降をご使用ください。

他のOpenSSLバージョンのサポート追加を希望される場合は、[info@wolfssl.jp](mailto:info@wolfssl.jp) にご連絡ください。
