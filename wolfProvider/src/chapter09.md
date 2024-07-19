# wolfProvider Design

wolfProvider is composed of the following source files, all located under the “src” subdirectory of the wolfProvider package.

| Source File | Description |
| --------------- | ---------------- |
| we_wolfprovider.c | Contains library entry points. Calls OpenSSL IMPLEMENT_DYNAMIC_BIND_FN for dynamic loading of the library using the OpenSSL provider framework. Also includes static entry points when compiled and used as a static library. |
| we_internal.c | Includes wolfprovider_bind() function, which handles registration of provider algorithm callbacks. Also includes other wolfprovider internal functionality. |
| we_logging.c | wolfProvider logging framework and function implementations. |
| we_openssl_bc.c | wolfProvider OpenSSL binary compatibility abstraction layer, used for supporting wolfProvider across multiple OpenSSL versions. |
| we_aes_block.c | wolfProvider AES-ECB and AES-CBC implementation. |
| we_aes_cbc_hmac.c | wolfProvider AES-CBC-HMAC implementation. |
| we_aes_ccm.c | wolfProvider AES-CCM implementation. |
| we_aes_ctr.c | wolfProvider AES-CTR implementation. |
| we_aes_gcm.c | wolfProvider AES-GCM implementation. |
| we_des3_cbc.c | wolfProvider 3DES-CBC implementation. |
| we_dh.c | wolfProvider DH implementation. |
| we_digest.c | wolfProvider message digest implementations (SHA-1, SHA-2, SHA-3). |
| we_ecc.c | wolfProvider ECDSA and ECDH implementation. |
| we_mac.c | wolfProvider HMAC and CMAC implementations. |
| we_random.c | wolfProvider RAND implementation. |
| we_rsa.c | wolfProvider RSA implementation. |
| we_tls_prf.c | wolfProvider TLS 1.0 PRF implementation. |


General wolfProvider architecture is as follows, showing both dynamic and static entry points:

![wolfProvider Architecture](../png/wolfprovider_architecture.png)

## wolfProvider Entry Points

The main entry points into the wolfProvider library are either **wolfprovider_bind** () or **PROVIDER_load_wolfprovider** (). wolfprovider_bind() is called automatically by OpenSSL if wolfProvider has been loaded dynamically. PROVIDER_load_wolfprovider() is the entry point applications must call if wolfProvider has been built and used statically instead of dynamically.

## wolfProvider Algorithm Callback Registration

wolfProvider registers algorithm structures and callbacks with the OpenSSL provider framework for all supported components of wolfCrypt FIPS. This registration happens inside `wolfprovider_bind()` in `we_internal.c`. `wolfprovider_bind()` receives an PROVIDER structure pointer
representing the wolfProvider provider. Individual algorithm/component callbacks or structures are then registered with that PROVIDER structure using the appropriate API from <openssl/provider.h>.

These API calls include the following:
```
PROVIDER_set_id(e, wolfprovider_id)
PROVIDER_set_name(e, wolfprovider_name)
PROVIDER_set_digests(e, we_digests)
PROVIDER_set_ciphers(e, we_ciphers)
PROVIDER_set_RAND(e, we_random_method)
PROVIDER_set_RSA(e, we_rsa())
PROVIDER_set_DH(e, we_dh_method)
PROVIDER_set_ECDSA(e, we_ecdsa())
PROVIDER_set_pkey_meths(e, we_pkey)
PROVIDER_set_pkey_asn1_meths(e, we_pkey_asn1)
PROVIDER_set_EC(e, we_ec())
PROVIDER_set_ECDH(e, we_ecdh())
PROVIDER_set_destroy_function(e, wolfprovider_destroy)
PROVIDER_set_cmd_defns(e, wolfprovider_cmd_defns)
PROVIDER_set_ctrl_function(e, wolfprovider_ctrl)
```

Each algorithm/component callback function or structure used in the above calls (ex: we_digests, we_ciphers, etc) are implemented in either `we_internal.c` or in the respective algorithm source file.
