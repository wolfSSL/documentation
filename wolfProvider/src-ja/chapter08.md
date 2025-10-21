# wolfProviderの設計

wolfProviderは次のソースファイルで構成され、すべてwolfProviderパッケージの`src`サブディレクトリの下にあります。

| ソースファイル | 説明 |
| ------ | ---------------- |
| wp_wolfprov.c | ライブラリのエントリポイントが含まれています。OpenSSL プロバイダフレームワークを使用してライブラリを動的にロードするために、OpenSSL IMPLEMENT_DYNAMIC_BIND_FN を呼び出します。コンパイルして静的ライブラリとして使用する場合は、静的エントリポイントも含みます。 |
| wp_internal.c | プロバイダアルゴリズムのコールバックの登録を処理する wolfprovider_bind() 関数が含まれています。また、その他の wolfprovider 内部機能も含みます。 |
| wp_logging.c | wolfProvider のロギングフレームワークと関数の実装 |
| wp_aes_aead.c | wolfProvider AES-AEAD (Authenticated Encryption with Associated Data) の実装 |
| wp_aes_block.c | wolfProvider AES-ECB および AES-CBC 実装 |
| wp_aes_stream.c | wolfProvider AES ストリーム暗号実装 |
| wp_aes_wrap.c | wolfProvider AES キーラッピング実装 |
| wp_cmac.c | wolfProvider CMAC (暗号ベースメッセージ認証コード) 実装 |
| wp_dec_epki2pki.c | wolfProvider 暗号化された秘密鍵から秘密鍵への変換実装 |
| wp_dec_pem2der.c | wolfProvider PEM から DER 形式への変換実装 |
| wp_des.c | wolfProvider DES 実装 |
| wp_dh_exch.c | wolfProvider DH 鍵交換実装 |
| wp_dh_kmgmt.c | wolfProvider DH 鍵管理実装 |
| wp_digests.c | wolfProvider メッセージ ダイジェスト実装 (SHA-1、SHA-2、SHA-3、...)|
| wp_drbg.c | wolfProvider DRBG (決定論的乱数ビット ジェネレーター) 実装|
| wp_ecc_kmgmt.c | wolfProvider ECC キー管理実装|
| wp_ecdh_exch.c | wolfProvider ECDH キー交換実装|
| wp_ecdsa_sig.c | wolfProvider ECDSA 署名実装|
| wp_ecx_exch.c | wolfProvider ECX キー交換実装 (X25519、X448、...)|
| wp_ecx_kmgmt.c | wolfProvider ECX キー管理実装|
| wp_ecx_sig.c | wolfProvider ECX 署名実装 (Ed25519、Ed448、...)|
| wp_file_store.c | wolfProvider ファイルストレージ実装|
| wp_fips.c | wolfProvider FIPS 検証実装|
| wp_gmac.c | wolfProvider GMAC (Galois/Counter Mode) 実装|
| wp_hkdf.c | wolfProvider HKDF (HMAC ベースの鍵導出関数) 実装|
| wp_hmac.c | wolfProvider HMAC 実装|
| wp_kbkdf.c | wolfProvider KBKDF (鍵ベースの鍵導出関数) 実装|
| wp_kdf_exch.c | wolfProvider KDF 鍵交換実装|
| wp_kdf_kmgmt.c | wolfProvider KDF 鍵管理実装|
| wp_krb5kdf.c | wolfProvider Kerberos 5 KDF 実装|
| wp_mac_kmgmt.c | wolfProvider MAC キー管理実装|
| wp_mac_sig.c | wolfProvider MAC 署名実装|
| wp_params.c | wolfProvider パラメータ処理実装|
| wp_pbkdf2.c | wolfProvider PBKDF2 (パスワードベースのキー導出関数 2) 実装|
| wp_rsa_asym.c | wolfProvider RSA 非対称暗号化実装|
| wp_rsa_kem.c | wolfProvider RSA KEM (キーカプセル化メカニズム) 実装|
| wp_rsa_kmgmt.c | wolfProvider RSA キー管理実装|
| wp_rsa_sig.c | wolfProvider RSA 署名実装|
| wp_tls1_prf.c | wolfProvider TLS 1.0 PRF 実装|
| wp_tls_capa.c | wolfProvider TLS 機能の実装 |

## wolfProviderエントリーポイント

wolfProvider ライブラリへの主要なエントリポイントは、**OSSL_provider_init()** と **wolfssl_provider_init()** です。

**OSSL_provider_init()** は、プロバイダが動的にロードされた際に OpenSSL によって自動的に呼び出される標準のOpenSSLプロバイダエントリポイントです。
この関数は `wp_wolfprov.c` で定義されており、`wolfssl_provider_init()` を呼び出すラッパーとして機能します。

**wolfssl_provider_init()** は、以下の機能を実行するコア初期化関数です。

- プロバイダーコンテキストをセットアップします。
- プロバイダー関数でディスパッチテーブルを初期化します。
- FIPS モード設定を処理します。
- デバッグが有効になっている場合は、デバッグをセットアップします。
- 以下の関数ポインタを含むプロバイダーのディスパッチテーブルを返します。

* `wolfprov_teardown` - プロバイダーのクリーンアップ
* `wolfprov_gettable_params` - パラメーターテーブルの取得
* `wolfprov_get_params` - パラメーターの取得
* `wolfprov_query` - 操作のクエリ
* `wolfssl_prov_get_capabilities` - 機能レポート

アプリケーションがwolfProviderアルゴリズムを要求すると、OpenSSLによってプロバイダーがロードされます。
ディスパッチテーブルは、OpenSSLが暗号操作に適切なwolfProvider関数を呼び出すことを可能にします。

## wolfProvider ディスパッチテーブル関数

wolfProviderディスパッチテーブルには、プロバイダー操作のさまざまな側面を処理するいくつかの主要な関数が含まれています。
各関数は、OpenSSLプロバイダフレームワークにおいて特定の目的を果たします。

**OSSLパラメータに関する注意（後述）:** OSSLパラメータは、OpenSSLがプロバイダと設定データや機能情報を交換するための標準化された方法です。
