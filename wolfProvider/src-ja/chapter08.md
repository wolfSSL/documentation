# wolfProviderの設計

wolfProviderは次のソースファイルで構成され、すべてwolfProviderパッケージの`src`サブディレクトリの下にあります。

| ソースファイル | 説明 |
| ------ | ---------------- |
| wp_wolfprov.c | ライブラリのエントリポイント`OSSL_provider_init()`と`wolfssl_provider_init()`、プロバイダディスパッチテーブル、プロバイダパラメーター処理、およびwolfProviderのアルゴリズム実装をOpenSSLへ登録する`OSSL_ALGORITHM`配列を含みます。静的ライブラリとしてコンパイルして使用する場合の静的エントリポイントも提供します。 |
| wp_internal.c | エントロピー/RNGおよびCAST自己テスト用ミューテックスの初期化、プロバイダコンテキストのRNGアクセスとロック用ユーティリティ、デコーダースキップ処理など、wolfProviderの内部ヘルパーを含みます。 |
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
| wp_seed_src.c | フォークセーフなエントロピーのための /dev/urandom キャッシュを用いた wolfProvider SEED-SRC エントロピーソース実装|
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
| wp_sshkdf.c | wolfProvider SSHKDF (SSH 鍵導出関数) 実装|
| wp_rsa_asym.c | wolfProvider RSA 非対称暗号化実装|
| wp_rsa_kem.c | wolfProvider RSA KEM (キーカプセル化メカニズム) 実装|
| wp_rsa_kmgmt.c | wolfProvider RSA キー管理実装|
| wp_rsa_sig.c | wolfProvider RSA 署名実装|
| wp_mlkem_kmgmt.c | wolfProvider ML-KEM (FIPS 203) キー管理実装|
| wp_mlkem_kem.c | wolfProvider ML-KEM (FIPS 203) 鍵カプセル化実装|
| wp_mlx_kmgmt.c | wolfProvider ハイブリッド ML-KEM + ECDH キー管理実装|
| wp_mlx_kem.c | wolfProvider ハイブリッド ML-KEM + ECDH 鍵カプセル化実装|
| wp_mldsa_kmgmt.c | wolfProvider ML-DSA (FIPS 204) キー管理実装|
| wp_mldsa_sig.c | wolfProvider ML-DSA (FIPS 204) 署名実装|
| wp_slhdsa_kmgmt.c | wolfProvider SLH-DSA (FIPS 205) キー管理実装|
| wp_slhdsa_sig.c | wolfProvider SLH-DSA (FIPS 205) 署名実装|
| wp_lms.c | wolfProvider LMS (RFC 8554) 検証実装|
| wp_tls1_prf.c | wolfProvider TLS 1.0 PRF 実装|
| wp_tls_capa.c | wolfProvider TLS 機能の実装 |

## wolfProviderエントリーポイント

wolfProvider ライブラリへの主要なエントリポイントは、**OSSL_provider_init()** と **wolfssl_provider_init()** です。

**OSSL_provider_init()** は、プロバイダが動的にロードされた際に OpenSSL によって自動的に呼び出される標準のOpenSSLプロバイダエントリポイントです。
この関数は `wp_wolfprov.c` で定義されており、`wolfssl_provider_init()` を呼び出すラッパーとして機能します。

**wolfssl_provider_init()** は、以下の機能を実行するコア初期化関数です。

- プロバイダコンテキストをセットアップします。
- プロバイダ関数でディスパッチテーブルを初期化します。
- FIPS モード設定を処理します。
- デバッグが有効になっている場合は、デバッグをセットアップします。
- 以下の関数ポインタを含むプロバイダのディスパッチテーブルを返します。

* `wolfprov_teardown` - プロバイダのクリーンアップ
* `wolfprov_gettable_params` - パラメーターテーブルの取得
* `wolfprov_get_params` - パラメーターの取得
* `wolfprov_query` - 操作のクエリ
* `wolfssl_prov_get_capabilities` - 機能レポート

アプリケーションがwolfProviderアルゴリズムを要求すると、OpenSSLによってプロバイダがロードされます。
ディスパッチテーブルは、OpenSSLが暗号操作に適切なwolfProvider関数を呼び出すことを可能にします。

## wolfProvider ディスパッチテーブル関数

wolfProviderディスパッチテーブルには、プロバイダ操作のさまざまな側面を処理するいくつかの主要な関数が含まれています。
各関数は、OpenSSLプロバイダフレームワークにおいて特定の目的を果たします。

**OSSLパラメータに関する注意（後述）:** OSSLパラメータは、OpenSSLがプロバイダと設定データや機能情報を交換するための標準化された方法です。
パラメータは単純な値(整数、文字列、ブール値)または複雑な構造を表すことができ、アプリケーションによるプロバイダ機能の照会、動作の構成、状態情報の取得を可能にします。
このパラメータシステムは、プロバイダとアプリケーション間の通信に、型安全で拡張可能な仕組みを提供します。

### wolfprov_teardown

`wolfprov_teardown()`関数は、プロバイダがアンロードされる際にOpenSSLから自動的に呼び出されます。プロバイダコンテキストを解放(`wolfssl_prov_ctx_free()`)し、`wolfCrypt_Cleanup()`を呼び出してwolfCryptのリソースを解放します。

### wolfprov_gettable_params

`wolfprov_gettable_params()`関数は、プロバイダがサポートするパラメータを定義するパラメータ記述子のテーブルを返します。この関数は以下を行います。

- 取得可能なパラメータの構造と型を定義
- パラメータの名前、型、説明に関するメタデータを提供
- プロバイダから利用可能なパラメータをOpenSSLが認識できるようにする
- パラメータの検証と型チェックをサポート
- アプリケーションが利用可能なプロバイダパラメータを検出できるようにする

返されるテーブルには、アプリケーションがプロバイダの機能や構成オプションを照会するために使用できるパラメータ定義が含まれます。

### wolfprov_get_params

`wolfprov_get_params()`関数は、プロバイダから特定のパラメータ値を取得します。この関数は以下を行います。

- OpenSSLまたはアプリケーションからのパラメータ要求を受け付ける
- 要求されたパラメータの現在値を返す
- パラメータの型変換と検証を処理
- プロバイダの構成および状態情報へのアクセスを提供
- 単純なパラメータと複雑なパラメータ構造の両方をサポート

wolfProviderは、プロバイダ名(`OSSL_PROV_PARAM_NAME`)、バージョン(`OSSL_PROV_PARAM_VERSION`)、ビルド情報(`OSSL_PROV_PARAM_BUILDINFO`)、実行状態(`OSSL_PROV_PARAM_STATUS`)の4つのプロバイダパラメータを実装しています。

### wolfssl_prov_get_capabilities

`wolfssl_prov_get_capabilities()`関数は、wolfProviderのTLS関連機能をOpenSSLに通知します。この関数は以下を提供します。

- サポートされるTLS鍵交換グループ(`TLS-GROUP`機能)。従来型グループに加え、有効な場合はポスト量子およびハイブリッドグループを含む
- ML-DSAが有効な場合、サポートされるTLS署名アルゴリズム(`TLS-SIGALG`機能)

この機能情報により、OpenSSLはTLSハンドシェイク中にwolfProviderがサポートする鍵交換グループと署名アルゴリズムをネゴシエートできます。

### wolfprov_query

`wolfprov_query()`関数は、wolfProviderにおけるアルゴリズムの検出と登録の主要な仕組みです。中央ルーティング機構として以下を行います。

- 特定のアルゴリズム実装に対するOpenSSLからの要求を処理
- サポート対象のアルゴリズムが要求された際に、適切なアルゴリズム構造を返す
- 暗号操作用の操作別ディスパッチテーブルを提供
- プロバイダ内のアルゴリズム登録と検索を管理
- 対称暗号操作と非対称暗号操作の両方をサポート
- OpenSSLの要求に基づく動的なアルゴリズム検出を可能にする

OpenSSLがアルゴリズム(AES、RSA、SHA-256など)を要求すると、`wolfprov_query()`はwolfProviderがそのアルゴリズムをサポートしているかを判定し、対応する実装構造を返します。この関数は、OpenSSLのアルゴリズム要求を各ソースファイル(例えば`wp_aes_block.c`や`wp_rsa_sig.c`)にあるwolfProviderの実装へ接続する中央ルーティング機構として機能します。
