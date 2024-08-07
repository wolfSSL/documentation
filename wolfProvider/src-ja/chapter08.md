# wolfProvider の設計

wolfProvider は次のソース ファイルで構成され、すべて wolfProvider パッケージの"src"サブディレクトリの下にあります。

| ソースファイル | 詳細 |
| --------------- | ---------------- |
| wp_wolfprovider.c | ライブラリ エントリ ポイントが含まれます。 OpenSSL エンジン フレームワークを使用してライブラリを動的にロードするために OpenSSL IMPLEMENT_DYNAMIC_BIND_FN を呼び出します。 コンパイルしてスタティック ライブラリとして使用する場合のスタティック エントリ ポイントも含まれます |
| wp_internal.c | エンジン アルゴリズム コールバックの登録を処理する wolfprovider_bind() 関数が含まれています。 他の wolfprovider の内部機能も含まれています。 |
| wp_logging.c | wolfProvider ロギング フレームワークと関数の実装 |
| wp_openssl_bc.c | wolfProvider OpenSSL バイナリ互換抽象化レイヤー。複数の OpenSSL バージョンで wolfProvider をサポートするために使用されます。 |
| wp_aes_block.c | wolfProvider AES-ECB および AES-CBC の実装 |
| wp_aes_cbc_hmac.c | wolfProvider AES-CBC-HMAC 実装 |
| wp_aes_ccm.c | wolfProvider AES-CCM 実装 |
| wp_aes_ctr.c | wolfProvider AES-CTR 実装 |
| wp_aes_gcm.c | wolfProvider AES-GCM 実装 |
| wp_des3_cbc.c | wolfProvider 3DES-CBC の実装 |
| wp_dh.c | wolfProvider DH の実装 |
| wp_digest.c | wolfProvider メッセージ ダイジェストの実装 (SHA-1、SHA-2、SHA-3) |
| wp_ecc.c | wolfProvider ECDSA および ECDH の実装 |
| wp_mac.c | wolfProvider HMAC および CMAC の実装 |
| wp_random.c | wolfProvider RAND 実装 |
| wp_rsa.c | wolfProvider RSA 実装 |
| wp_tls_prf.c | wolfProvider TLS 1.0 PRF 実装 |

## wolfProvider エントリーポイント

wolfProvider ライブラリへの主なエントリ ポイントは、**wolfprovider_bind** () または **PROVIDER_load_wolfprovider** () のいずれかです。 wolfProvider が動的にロードされている場合、wolfprovider_bind() は OpenSSL によって自動的に呼び出されます。 PROVIDER_load_wolfprovider() は、wolfProvider が動的ではなく静的に構築および使用されている場合に、アプリケーションが呼び出す必要があるエントリ ポイントです。

## wolfProvider アルゴリズム コールバック登録

wolfProvider は、wolfCrypt FIPS でサポートされているすべてのコンポーネントに対して、アルゴリズム構造体とコールバックを OpenSSL エンジン フレームワークに登録します。 この登録は、`wp_internal.c` の `wolfprovider_bind()` 内で行われます。 `wolfprovider_bind()` は、wolfProvider エンジンを表す PROVIDER 構造体ポインタを受け取ります。 次に、個々のアルゴリズム/コンポーネントのコールバックまたは構造体が、<openssl/provider.h> の適切な API を使用してその PROVIDER 構造体に登録されます。



これらの API 呼び出しには、次のものが含まれます：
```
PROVIDER_set_id(e, wolfprovider_id)
PROVIDER_set_name(e, wolfprovider_name)
PROVIDER_set_digests(e, wp_digests)
PROVIDER_set_ciphers(e, wp_ciphers)
PROVIDER_set_RAND(e, wp_random_method)
PROVIDER_set_RSA(e, wp_rsa())
PROVIDER_set_DH(e, wp_dh_method)
PROVIDER_set_ECDSA(e, wp_ecdsa())
PROVIDER_set_pkey_meths(e, wp_pkey)
PROVIDER_set_pkey_asn1_meths(e, wp_pkey_asn1)
PROVIDER_set_EC(e, wp_ec())
PROVIDER_set_ECDH(e, wp_ecdh())
PROVIDER_set_destroy_function(e, wolfprovider_destroy)
PROVIDER_set_cmd_defns(e, wolfprovider_cmd_defns)
PROVIDER_set_ctrl_function(e, wolfprovider_ctrl)
```

上記の呼び出しで使用される各アルゴリズム/コンポーネントのコールバック関数または構造体 (例: wp_digests、wp_ciphers など) は、`wp_internal.c` またはそれぞれのアルゴリズム ソース ファイルに実装されています。
