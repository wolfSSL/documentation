# wolfProviderの設計

wolfProviderは次のソースファイルで構成され、すべてwolfProviderパッケージの`src`サブディレクトリの下にあります。

| ソースファイル | 詳細 |
| ---- | ---------------- |
| wp_wolfprovider.c | ライブラリエントリポイントが含まれます。 OpenSSLエンジンフレームワークを使用してライブラリを動的にロードするために、OpenSSL IMPLEMENT_DYNAMIC_BIND_FNを呼び出します。コンパイルして静的ライブラリとして使用する場合のスタティックエントリポイントも含みます。 |
| wp_internal.c | エンジンアルゴリズムコールバックの登録を処理する`wolfprovider_bind()`関数が含まれています。他のwolfProviderの内部機能も含みます。 |
| wp_logging.c | wolfProviderログ出力フレームワークと関数の実装 |
| wp_openssl_bc.c | wolfProvider OpenSSLバイナリ互換抽象化レイヤーです。複数のOpenSSLバージョンでwolfProviderをサポートするために使用します。 |
| wp_aes_block.c | wolfProvider AES-ECBおよびAES-CBC実装 |
| wp_aes_cbc_hmac.c | wolfProvider AES-CBC-HMAC実装 |
| wp_aes_ccm.c | wolfProvider AES-CCM実装 |
| wp_aes_ctr.c | wolfProvider AES-CTR実装 |
| wp_aes_gcm.c | wolfProvider AES-GCM実装 |
| wp_des3_cbc.c | wolfProvider 3DES-CBCの実装 |
| wp_dh.c | wolfProvider DHの実装 |
| wp_digest.c | wolfProvider メッセージダイジェストの実装(SHA-1、SHA-2、SHA-3) |
| wp_ecc.c | wolfProvider ECDSAおよびECDHの実装 |
| wp_mac.c | wolfProvider HMACおよびCMACの実装 |
| wp_random.c | wolfProvider RAND実装 |
| wp_rsa.c | wolfProvider RSA実装 |
| wp_tls_prf.c | wolfProvider TLS 1.0 PRF実装 |

## wolfProviderエントリーポイント

wolfProviderライブラリへの主なエントリポイントは、**wolfprovider_bind** () または **PROVIDER_load_wolfprovider** () のいずれかです。
wolfProviderが動的にロードされている場合、`wolfprovider_bind()`はOpenSSL によって自動的に呼び出されます。
`PROVIDER_load_wolfprovider()` はwolfProvider静的に構築および使用されている場合に、アプリケーションが呼び出す必要があるエントリポイントです。

## wolfProviderアルゴリズムコールバック登録

wolfProviderは、FIPS版wolfCryptでサポートしているすべてのコンポーネントに対して、アルゴリズム構造体とコールバックを OpenSSLエンジンフレームワークに登録します。
この登録は、`wp_internal.c` の `wolfprovider_bind()` 内で行われます。
`wolfprovider_bind()`は、wolfProvider エンジンを表す`PROVIDER`構造体ポインタを受け取ります。
次に、個々のアルゴリズム/コンポーネントのコールバックまたは構造体が、`<openssl/provider.h>`の適切なAPIを使用してその`PROVIDER`構造体に登録されます。

これらのAPI呼び出しには、以下のものが含まれます。

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

上記の呼び出しで使用される各アルゴリズム/コンポーネントのコールバック関数または構造体
(例: wp_digests、wp_ciphers など) は、`wp_internal.c` またはそれぞれのアルゴリズムソースファイルに実装しています。
