# wolfCrypt FIPS Ready API Documentation

以下は、wolfCrypt FIPS Ready API の概要です。
詳細については、wolfCrypt API ドキュメントをご覧ください。

## Map of API to FIPS 140-3 module services

### Digital Signature Service

| API Call | Description |
| :--- | :---- |
| InitRsaKey_fips | オプションのヒープ ヒント p で使用するRSA鍵オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| FreeRsaKey_fips | RSA鍵リソースを解放します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaSSL_Sign_fips | サイズ inLen の入力 in に対して RSA鍵署名操作を実行し、rng を使用してサイズ outLen の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaSSL_VerifyInline_fips | サイズ inLen の入力 in に一時メモリを割り当てずに RSA鍵検証を実行し、出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaSSL_Verify_fips | サイズ inLen の入力 in に対して RSA鍵検証を実行し、サイズ outLen の出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| SS_Sign_fips | サイズ inLen の入力 in に対して PSS パディングを使用して RSA鍵署名操作を実行し、rng を使用してサイズ outLen の out に出力します。 マスク生成関数 mgf を使用したハッシュアルゴリズム hash を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_SignEx_fips | サイズ inLen の入力 in に対して PSS パディングを使用して RSA鍵署名操作を実行し、rng を使用してサイズ outLen の out に出力します。 これは、マスク生成関数 mgf とソルト長の SaltLen を備えたハッシュアルゴリズム hash を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_VerifyInline_fips | サイズ inLen の入力 in に一時メモリを割り当てずに RSA鍵検証を実行し、出力 out に書き込みます。 マスク生成関数 mgf を使用したハッシュアルゴリズム hash を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_VerifyInlineEx_fips | サイズ inLen の入力 in に対して RSA鍵検証を実行し、サイズ outLen の出力 out に書き込みます。 ハッシュアルゴリズム hash とマスク生成関数 mgf およびソルト長の SaltLen を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_Verify_fips | サイズ inLen の入力 in に対して RSA鍵検証を実行し、サイズ outLen の出力 out に書き込みます。 ハッシュアルゴリズム hash とマスク生成関数 mgf を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_VerifyEx_fips | サイズ inLen の入力 in に対して RSA鍵検証を実行し、サイズ outLen の出力 out に書き込みます。 ハッシュアルゴリズム hash とマスク生成関数 mgf およびソルト長の SaltLen を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_CheckPadding_fips | ハッシュ hashType を使用して、サイズ sigSz の署名 sig をサイズ inSz の入力 in での RSA鍵検証後のパディングをチェックします。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPSS_CheckPaddingEx_fips | ハッシュ hashType と長さ saltLen の salt を使用して、サイズ sigSz の署名 sig をサイズ inSz の入力 in での RSA鍵検証後のパディングをチェックします。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaEncryptSize_fips | RSA鍵の出力サイズを取得します。成功した場合は鍵の出力サイズ(正値)、エラーの場合は負値を返します。|
|||
| wc_RsaPrivateKeyDecode | サイズ inSz のインデックス inOutIdx で始まるバッファ入力 in から RSA秘密鍵をデコードします。成功すると 0、エラーの場合は負値を返します。|
| wc_RsaPublicKeyDecode | サイズ inSz のインデックス inOutIdx で始まるバッファ入力 in から RSA公開鍵をデコードします。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_init_fips | ECC鍵オブジェクトを使用するために初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_free_fips | ECC鍵オブジェクトのリソースを解放します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_import_x963_fips | サイズ inLen の入力 in から ANSI X9.63 形式の ECC公開鍵をインポートします。成功すると 0、エラーの場合は負値を返します。|
||| 
| ecc_sign_hash_fips | 長さ inlen の入力 in に対して ECC鍵署名操作を実行し、rng を使用して長さ outlen の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_verify_hash_fips | 長さ hashlen のハッシュを使用して、サイズ siglen の sig の ECC鍵検証を実行します。 署名検証結果はresで返します。成功すると 0、エラーの場合は負値を返します。|
|||
|||
|||

### 鍵生成
| API Call | Description |
| :--- | :---- | 
| MakeRsaKey_fips |乱数発生器 rng にモジュラス長 size と指数 e を使用して RSA鍵を生成します。成功すると 0、エラーの場合は負値を返します。|
|||
| CheckProbablePrime_fips | 長さ nlen のポテンシャル係数については、サイズ pRawSz の候補数 pRaw とサイズ qRawSz の qRaw をチェックして、それらがおそらく素数であるかどうかを確認します。 両方とも、サイズ eRawSz が 1 の指数 eRaw を持つ GCD を持つ必要があります。主な候補は Miller-Rabin でチェックします。 結果は isPrime に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaExportKey_fips | RSA鍵を、eSz の e、nSz の n、dSz の d、pSz の p、qSz の q のコンポーネントとして出力します。 サイズはバッファのサイズである必要があり、数値の実際の長さに更新されます。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_make_key_fips | rng を使用して、サイズ keysize の鍵 key に対して ECC鍵生成操作を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_make_key_ex_fips |rng を使用して、楕円曲線 curve_id を持つサイズ keysize の鍵 key に対して ECC鍵生成操作を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_export_x963_fips | ECC公開鍵を ANSI X9.63 形式でサイズ outLen の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitDhKey_fips | DH鍵オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| FreeDhKey_fips | DH鍵リソースを解放します。成功すると 0、エラーの場合は負値を返します。|
|||
| DhSetKeyEx_fips | サイズ pSz の符号なしバイナリ入力 p、サイズ qSz の q、およびサイズ gSz の g から DH鍵のグループパラメーターを設定します。成功すると 0、エラーの場合は負値を返します。|
|||
| DhGenerateKeyPair_fips | DH鍵の rng を使用して、サイズ pubSz の公開鍵 pub、サイズ privSz の秘密鍵 priv を生成します。成功すると 0、エラーの場合は負値を返します。|
|||
| CheckRsaKey_fips | RSA鍵に対してペアごとの鍵検証を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| ecc_check_key_fips | ECC鍵に対してペアごとの鍵検証を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| DhCheckPubKeyEx_fips | 鍵内のドメインパラメーターまたはサイズ primeSz の素数 prime を用いて、サイズ pubSz の pub 値に対して数学的鍵検証を実行します。 |
|||
| DhCheckPrivKeyEx_fips | 鍵内のドメインパラメーターまたはサイズ primeSz の素数 prime を用いて、サイズ privSz の priv 値に対して数学的鍵検証を実行します。 |
|||
| DhCheckKeyPair_fips | ドメインパラメーターを使用して、サイズ pubSz の pub 値とサイズ privSz の priv 値の間でペアごとの鍵検証を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| HKDF_fips | ハッシュ type とサイズ inKeySz の inKey、長さ saltSz のソルト salt と infoSz の情報 info を使用して、HMAC ベースの鍵導出関数を実行します。 鍵はサイズ outSz の出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||

### 鍵合意
| API Call | Description |
| :--- | :---- |
| ecc_shared_secret_fips | privKey とペアの pubKey を使用して ECDHE 鍵合意操作を実行し、結果を長さsharedSzのsharedSecretに保存します。成功すると 0、エラーの場合は負値を返します。|
|||
| DhAgree_fips | サイズ privSz の DH秘密鍵  priv とサイズ pubSz のペアの公開鍵 otherPub を使用して、サイズ acceptSz の合意 agree を作成します。成功すると 0、エラーの場合は負値を返します。|
|||

### 鍵転送
| API Call | Description |
| :--- | :---- |
| RsaPublicEncrypt_fips | サイズ inLen の入力 in に対してRSA公開鍵を用いて暗号化し、rng を使用してサイズ outLen の出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPublicEncryptEx_fips | サイズ inLen の入力 in に対してRSA公開鍵を用いて暗号化し、rng を使用してサイズ outLen の出力 out に書き込みます。ハッシュtype のパディングを使用します。 PSS パディングを使用する場合は、サイズ labelSz のラベル labelを持つハッシュと mgf を使用します。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPrivateDecryptInline_fips | サイズ inLen の入力 in に一時メモリを割り当てずにRSA秘密鍵を用いて復号し、出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPrivateDecryptInlineEx_fips | サイズ inLen の入力 in に一時メモリを割り当てずにRSA秘密鍵を用いて復号し、出力 out に書き込みます。 typeのパディングを使用します。 PSS パディングを使用する場合は、サイズ labelSz のラベル  label を持つハッシュと mgf を使用します。 成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPrivateDecrypt_fips | サイズ inLen の入力 in に対して RSA秘密鍵を用いて復号し、サイズ outLen の出力 out に書き込みます。成功すると 0、エラーの場合は負値を返します。|
|||
| RsaPrivateDecryptEx_fips | サイズ inLen の入力 in に対して RSA秘密鍵を用いて復号し、サイズ outLen の出力 out に書き込みます。 type のパディングを使用します。 PSS パディングを使用する場合は、サイズ labelSz のラベル label を持つハッシュと mgf を使用します。成功すると 0、エラーの場合は負値を返します。|
|||

### 鍵付きハッシュ
| API Call | Description |
| :--- | :---- |
| HmacSetKey_fips | ハッシュ type を使用して、サイズ keySz の鍵 keyで hmac オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| HmacUpdate_fips | サイズ len の入力 data に対して hmac Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| HmacFinal_fips | hmac Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| Gmac_fips | サイズ authInSz の入力 authIn に対して GMAC を実行し、サイズ authTagSz の authTag を出力します。 長さ keySz の鍵 key を使用し、乱数発生器 rng を使用して iv に格納する長さ ivSz の IV をランダムに生成します。成功すると 0、エラーの場合は負値を返します。|
|||
| GmacVerify_fips | 長さ keySz の鍵 key と長さ ivSz の iv を使用して、サイズ authInSz の入力 authIn 上の長さ authTagSz の GMAC authTag を検証します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitCmac_fips | ハッシュ type を使用して、サイズ keySz の鍵 key で cmac オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| CmacUpdate_fips | サイズ inSz の入力 in に対して cmac Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| CmacFinal_fips | cmac Final を実行し、サイズ outSz の出力 outにダイジェストを出力します。これは実際の出力サイズで更新されます。成功すると 0、エラーの場合は負値を返します。|
|||

### メッセージダイジェスト
| API Call | Description |
| :--- | :---- |
| InitSha_fips | sha オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| ShaUpdate_fips | サイズ len の入力 data に対して SHA-Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| ShaFinal_fips | sha Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha224_fips | sha224 オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha224Update_fips | サイズ len の入力 data に対して sha224 Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha224Final_fips | sha224 Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha256_fips | sha256 オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha256Update_fips | サイズ len の入力 data に対して sha256 Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha256Final_fips | sha256 Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha384_fips | sha384 オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha384Update_fips | サイズ len の入力 data に対して sha384 Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha384Final_fips | sha384 Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha512_fips | sha512 オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha512Update_fips | サイズ len の入力 data に対して sha512 Update を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha512Final_fips | sha512 Finalを実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha3_224_fips | sha3 (224 ビット) オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_224_Update_fips | サイズ len の入力 data に対して sha3 (224 ビット) 更新を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_224_Final_fips | sha3 (224 ビット) Final を実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha3_256_fips | sha3 (256 ビット) オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_256_Update_fips | サイズ len の入力 data に対して sha3 (256 ビット) 更新を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_256_Final_fips | sha3 (256 ビット) Final を実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha3_384_fips | sha3 (384 ビット) オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_384_Update_fips | サイズ len の入力 data に対して sha3 (384 ビット) 更新を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_384_Final_fips | sha3 (384 ビット) Final を実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitSha3_512_fips | sha3 (512 ビット) オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_512_Update_fips | サイズ len の入力 data に対して sha3 (512 ビット) 更新を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Sha3_512_Final_fips | sha3 (512 ビット) Final を実行し、ダイジェストをハッシュに出力します。成功すると 0、エラーの場合は負値を返します。|
|||

### 乱数生成
| API Call | Description |
| :--- | :---- |
| InitRng_fips | RNG オブジェクトを使用できるように初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| InitRngNonce_fips | サイズ nonceSz の nonce で使用するために RNG オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| FreeRng_fips | RNG リソースを解放し、状態をゼロにします。成功すると 0、エラーの場合は負値を返します。ゼロライズサービスの一部でもあります。 |
|||
| RNG_GenerateBlock_fips | ユーザー用の RNG 出力のブロックを bufSz バイトの buf に取得します。成功すると 0、エラーの場合は負値を返します。|
|||
| RNG_HealthTest_fips | reseed が 0 の場合、entropyASz バイトのシードバッファ entropyA を使用して、outputSz バイトの予想される出力に対して RNG の一時インスタンスの出力をテストします。このとき、entropyB と entropyBSz は無視されます。 reseed が 1 の場合、テストではサイズ entropyBSz のシード バッファ entropyB を使用して RNG の一時インスタンスも再シードし、サイズが outSz バイトの予想される出力に対して RNG をテストします。成功すると 0、エラーの場合は負値を返します。|
|||

### ステータス出力
| API Call | Description |
| :--- | :---- |
| wolfCrypt_GetStatus_fips | モジュールの現在のステータスを返します。返り値 0 は、モジュールがエラーのない状態にあることを意味します。その他の返り値は、モジュールが特定のエラー状態にあることを示します。 |
|||
| wolfCrypt_GetVersion_fips | wolfCryptライブラリバージョンのnull終端文字列へのポインタを返します。 |
|||
| wolfCrypt_GetCoreHash_fips | コアハッシュのnull終端文字列へのポインタを 16 進数で返します。 |
|||

### 共通鍵暗号
| API Call | Description |
| :--- | :---- |
| AesSetKey_fips | 長さ keylen の userKey を使用して AES オブジェクトを初期化します。dir は方向(暗号化/復号)を示し、iv はオプションです。成功すると 0、エラーの場合は負値を返します。|
|||
| AesSetIV_fips | ユーザー iv を使用して AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCbcEncrypt_fips | 入力 in に対してAES CBC 暗号化を実行し、サイズ sz の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCbcDecrypt_fips | 入力 in に対してAES CBC 復号を実行し、サイズ sz の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesEcbEncrypt_fips | 入力 in に対してAES ECB 暗号化を実行し、サイズ sz の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesEcbDecrypt_fips | 入力 in に対してAES ECB 復号を実行し、サイズ sz の out に出力します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCtrEncrypt_fips | 入力 in に対してAES CTR 暗号化を実行し、サイズ sz の out に出力します。成功すると 0、エラーの場合は負値を返します。この API は CTR 復号も実行します。|
|||
| AesGcmSetKey_fips | 長さ len の鍵を使用して AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesGcmSetExtIV_fips | 外部で生成された長さ ivSz の iv を使用して AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesGcmSetIV_fips | 最初の ivFixedSz バイトとして ivFixed を使用し、残りは rng からのランダム バイトであることを使用して、長さ ivSz の内部生成された IV で AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesGcmEncrypt_fips | 入力 in からサイズ outSz の 出力 outに対して AES GCM 暗号化を実行します。 現在の IV は、長さ ivOutSz のバッファ ivOut に格納します。 認証タグは、サイズ authTagSz のバッファ authTag に格納します。 authIn からの authInSz バイトが計算されて認証タグに組み込まれます。成功すると 0、エラーの場合は負値を返します。|
|||
| AesGcmDecrypt_fips | サイズ ivSz の iv を使用して、入力 in に対して AES GCM 復号を実行し、サイズ sz の out に出力します。 サイズ authTagSz の authTag は、authInSz バイトの入力 authIn を使用してチェックします。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCcmSetKey_fips | 長さ keySz の鍵 key を使用して AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCcmSetNonce_fips | 外部で生成された長さ nonceSz の nonce を使用して AES オブジェクトを初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCcmEncrypt_fips | 入力 in からサイズ outSz の 出力 outに対して AES CCM 暗号化を実行します。 現在の IV は、長さ nonceSz のバッファ nonce に格納します。 認証タグは、サイズ authTagSz のバッファ authTag に格納します。 authIn からの authInSz バイトが計算されて認証タグに組み込まれます。成功すると 0、エラーの場合は負値を返します。|
|||
| AesCcmDecrypt_fips | サイズ nonceSz の nonce を使用して、サイズ inSz の入力 in に対して AES CCM 復号を実行し、out に出力します。 サイズ authTagSz の authTag は、authIn の入力バイトと authInSz バイトを使用してチェックします。成功すると 0、エラーの場合は負値を返します。|
|||
|Des3_SetKey_fips | des3 オブジェクトを鍵 key で初期化します。dir は方向(暗号化/復号)を示し、iv はオプションです。成功すると 0、エラーの場合は負値を返します。|
|||
| Des3_SetIV_fips | des3 オブジェクトをユーザー iv で初期化します。成功すると 0、エラーの場合は負値を返します。|
|||
| Des3_CbcEncrypt_fips | サイズ sz の入力 in から出力 out へ DES3 CBC 暗号化を実行します。成功すると 0、エラーの場合は負値を返します。|
|||
| Des3_CbcDecrypt_fips | サイズ sz の入力 in から出力 out へ DES3 CBC 復号を実行します。成功すると 0、エラーの場合は負値を返します。|
|||

### ゼロライズ
| API Call | Description |
| :--- | :---- |
| FreeRng_fips | RNG CSP を破棄します。 他のすべてのサービスは、メモリ バインドされた CSP を自動的に上書きします。成功すると 0、エラーの場合は負値を返します。|
|||
|| スタックのクリーンアップはアプリケーションの義務です。汎用コンピュータを再起動すると、RAM 内のすべての CSP がクリアされます。 |
|||
|| API Calls for Allowed Security Functions |
|||

