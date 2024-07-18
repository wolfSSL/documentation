# FIPS 140-2 のサポート

wolfProvider は、FIPS で検証されたバージョンの wolfCrypt に対してコンパイルされた場合に、FIPS 140-2 で検証されたバージョンの wolfCrypt で動作するように設計されています。 この使用シナリオには、wolfSSL Inc. から入手した、適切にライセンスされ、検証されたバージョンの wolfCrypt が必要です。

wolfCrypt FIPS ライブラリは、非 FIPS モードに「切り替える」ことができないことに注意してください。 wolfCrypt FIPS と通常の wolfCrypt は、2 つの別個のソース コード パッケージです。

wolfProvider が wolfCrypt FIPS を使用するようにコンパイルされると、FIPS で検証されたアルゴリズム、モード、およびキー サイズのサポートおよび登録エンジン コールバックのみが含まれます。 OpenSSL ベースのアプリケーションが非 FIPS 検証済みアルゴリズムを呼び出す場合、実行は wolfProvider に入らず、OpenSSL 構成に基づいて、デフォルトの OpenSSL エンジンまたは他の登録済みエンジン プロバイダーによって処理される可能性があります。

**注** : FIPS 準拠を対象としており、wolfCrypt 以外の FIPS アルゴリズムが別のエンジンから呼び出される場合、それらのアルゴリズムは　wolfProvider および wolfCrypt FIPS であり、FIPS で検証されていない可能性があります。

wolfCrypt FIPS (140-2 / 140-3) の使用に関する詳細については、wolfSSL (facts@wolfssl.com) までお問い合わせください。


