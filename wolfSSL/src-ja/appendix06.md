

# エラーコード




## wolfSSLエラーコード



wolfSSL(以前のCyassl)エラーコードは`wolfssl/ssl.h`にあります。次のエラーの詳細な説明については、`SSL_get_error`(`man SSL_get_error`)のOpenSSL Manページを参照してください。

|エラーコード列挙|エラーコード|エラー説明|
| --------------- | ---------- | ----------------- |
| `SSL_ERROR_WANT_READ` |2||
| `SSL_ERROR_WANT_WRITE` | 3 | |
| `SSL_ERROR_WANT_CONNECT` | 7 | |
| `SSL_ERROR_WANT_ACCEPT` | 8 | |
| `SSL_ERROR_SYSCALL` | 5 | |
| `SSL_ERROR_WANT_X509_LOOKUP` | 83 | |
| `SSL_ERROR_ZERO_RETURN` | 6 | |
| `SSL_ERROR_SSL` | 85 | |




追加のwolfSSLエラーコードは`wolfssl/error-ssl.h`にあります

|エラーコード列挙|エラーコード|エラー説明|
| --------------- | ---------- | ----------------- |
|`INPUT_CASE_ERROR` |-301 |プロセス入力状態エラー|
|`PREFIX_ERROR` |-302 |キーラウンドの悪いインデックス|
|`MEMORY_ERROR` |-303 |メモリ確保失敗|
|`VERIFY_FINISHED_ERROR` |-304 |Finishedメッセージ検証に失敗|
|`VERIFY_MAC_ERROR` |-305 |Mac検証に失敗|
|`PARSE_ERROR` |-306 |ヘッダーの解析エラー|
|`UNKNOWN_HANDSHAKE_TYPE` |-307 |不明なハンドシェークタイプ|
|`SOCKET_ERROR_E` |-308 |ソケットがエラー状態|
|`SOCKET_NODATA` |-309 |予想されるデータがソケットにない|
|`INCOMPLETE_DATA` |-310 |タスク完了のための十分なデータがない|
|`UNKNOWN_RECORD_TYPE` |-311 |レコードHDRに未知のタイプ |
|`DECRYPT_ERROR` |-312 |復号中のエラー|
|`FATAL_ERROR` |-313 |致命的なエラーアラートを受信|
|`ENCRYPT_ERROR` |-314 |暗号化中のエラー|
|`FREAD_ERROR` |-315 |freadでエラー|
|`NO_PEER_KEY` |-316 |ピアの鍵が存在しない|
|`NO_PRIVATE_KEY` |-317 |秘密鍵が存在しない|
|`RSA_PRIVATE_ERROR` |-318 |RSA秘密鍵操作中のエラー|
|`NO_DH_PARAMS` |-319 |サーバーがDHパラメータを送ってこない|
|`BUILD_MSG_ERROR` |-320 |メッセージの作成に失敗|
|`BAD_HELLO` |-321 |ClientHelloメッセージが不正|
|`DOMAIN_NAME_MISMATCH` |-322 |ピアのサブジェクト名がミスマッチ|
|`WANT_READ` |-323 |データ再読み取りが必要|
|`NOT_READY_ERROR` |-324 |ハンドシェイクレイヤーがReadyでない |
|`VERSION_ERROR` |-326 |レコードレイヤーバージョンエラー|
|`WANT_WRITE` |-327 |データ再送が必要|
|`BUFFER_ERROR` |-328 |不正なバッファー入力|
|`VERIFY_CERT_ERROR` |-329 |verify certエラ|
|`VERIFY_SIGN_ERROR` |-330 |verify signエラー|
|`CLIENT_ID_ERROR` |-331 |PSKクライアントIDエラー|
|`SERVER_HINT_ERROR` |-332 |PSKサーバーヒントエラー|
|`PSK_KEY_ERROR` |-333 |PSK鍵エラー|
|`GETTIME_ERROR` |-337 |GetTimeOfdayが失敗|
|`GETITIMER_ERROR` |-338 |Getitimerが失敗|
|`SIGACT_ERROR` |-339 |sigactionが失敗|
|`SETITIMER_ERROR` |-340 |setitimerが失敗|
|`LENGTH_ERROR` |-341 |レコードレイヤーの長さが不正|
|`PEER_KEY_ERROR` |-342 |ピアの鍵をデコードできず|
|`ZERO_RETURN` |-343 |ピアがclose notifyを送信|
|`SIDE_ERROR` |-344 |クライアント/サーバータイプが不正|
|`NO_PEER_CERT` |-345 |ピアが鍵を送信しなかった|
|`ECC_CURVETYPE_ERROR` |-350 |ECCカーブタイプが不正|
|`ECC_CURVE_ERROR` |-351 |ECC曲線が不正|
|`ECC_PEERKEY_ERROR` |-352 |ピアECC鍵が不正|
|`ECC_MAKEKEY_ERROR` |-353 |Make ECC鍵が不正|
|`ECC_EXPORT_ERROR` |-354 |ECCエクスポート鍵が不正|
|`ECC_SHARED_ERROR` |-355 |ECCシェアードシークレットが不正|
|`NOT_CA_ERROR` |-357 |CA証明書ではない|
|`BAD_CERT_MANAGER_ERROR` |-359 |Cert Managerが不正|
|`OCSP_CERT_REVOKED` |-360 |OCSP証明書が取り消されました|
|`CRL_CERT_REVOKED` |-361 |CRL証明書が取り消されました
|`CRL_MISSING` |-362 |CRLロードされていない|
|`MONITOR_SETUP_E` |-363 |CRLモニターセットアップエラー|
|`THREAD_CREATE_E` |-364 |スレッド作成でエラー|
|`OCSP_NEED_URL` |-365 |OCSP |検索用のURLが必要|
|`OCSP_CERT_UNKNOWN` |-366 |OCSPレスポンダーが不明|
|`OCSP_LOOKUP_FAIL` |-367 |OCSPルックアップが失敗|
|`MAX_CHAIN_ERROR` |-368 |最大チェーンの深さを超えた|
|`COOKIE_ERROR` |-369 |DTLSクッキーエラー|
|`SEQUENCE_ERROR` |-370 |DTLSシーケンスエラー|
|`SUITES_ERROR` |-371 |スイートポインタエラー|
|`OUT_OF_ORDER_E` |-373 |Out of Orderメッセージ受信|
|`BAD_KEA_TYPE_E` |-374 |悪いKEAタイプが見つかりました|
|`SANITY_CIPHER_E` |-375 |SANITYチェック暗号エラー|
|`RECV_OVERFLOW_E` |-376 |受信コールバックが要求以上のデータを返却した|
|`GEN_COOKIE_E` |-377 |クッキーエラーを生成|
|`NO_PEER_VERIFY` |-378 |検証すべきピア証明書が無い|
|`FWRITE_ERROR` |-379 |fwriteエラー|
|`CACHE_MATCH_ERROR` |-380 |キャッシュHRD不一致|
|`UNKNOWN_SNI_HOST_NAME_E` |-381 |認識されていないホスト名|
|`UNKNOWN_MAX_FRAG_LEN_E` |-382 |認識されない最大フラグ長|
|`KEYUSE_SIGNATURE_E` |-383 |KeyUse digSignatureエラー|
|`KEYUSE_ENCIPHER_E` |-385 |KeyUse KeyEncipherエラー|
|`EXTKEYUSE_AUTH_E` |-386 |ExtKeyUse server|
|`SEND_OOB_READ_E` |-387 |送信コールバックが帯域外データ受信|
|`SECURE_RENEGOTIATION_E` |-388 |無効な再ネゴシエーション情報|
|`SESSION_TICKET_LEN_E` |-389 |セッションチケットが大きすぎ|
|`SESSION_TICKET_EXPECT_E` |-390 |セッションチケットがありません|
|`SCR_DIFFERENT_CERT_E` |-391 |SCR異なる証明書エラー|
|`SESSION_SECRET_CB_E` |-392 |セッションシークレットCB FCN障害|
|`NO_CHANGE_CIPHER_E` |-393 |Cipherを変更する前に終了|
|`SANITY_MSG_E` |-394 |メッセージ順のサニティチェックでエラー|
|`DUPLICATE_MST_E` |-395 |重複メッセージエラー|
|`SNI_UNSUPPORTED` |-396 |SSL 3.0はSNIをサポートしません|
|`SOCKET_PEER_CLOSED_E` |-397 |トランスポート層がクローズされた|
|`BAD_TICKET_KEY_CB_SZ` |-398 |セッションチケットキーCBサイズ不正|
|`BAD_TICKET_MSG_SZ` |-399 |セッションチケットMSGサイズ不正|
|`BAD_TICKET_ENCRYPT` |-400 |ユーザーチケット暗号化不正|
|`DH_KEY_SIZE_E` |-401 |DHキーが小さすぎる|
|`SNI_ABSENT_ERROR` |-402 |SNIリクエストはありません|
|`RSA_SIGN_FAULT` |-403 |RSA署名障害|
|`HANDSHAKE_SIZE_ERROR` |-404 |ハンドシェークメッセージが大きすぎる|
|`UNKNOWN_ALPN_PROTOCOL_NAME_E` |-405 |認識されていないプロトコル名エラー|
|`BAD_CERTIFICATE_STATUS_ERROR` |-406 |証明書ステータスメッセージ|
|`OCSP_INVALID_STATUS` |-407 |OCSPステータスが無効です
|`OCSP_WANT_READ` |-408 |OCSPコールバック応答|
|`RSA_KEY_SIZE_E` |-409 |RSAキーが小さすぎる|
|`ECC_KEY_SIZE_E` |-410 |ECCキーが小さすぎる|
|`DTLS_EXPORT_VER_E` |-411 |バージョンエラーをエクスポートする|
|`INPUT_SIZE_E` |-412 |入力サイズ大きすぎます|
|`CTX_INIT_MUTEX_E` |-413 |CTXミューテックスエラーを初期化します|
|`EXT_MASTER_SECRET_NEEDED_E` |-414 |EMSが再開することができます|
|`DTLS_POOL_SZ_E` |-415 |DTLSプールサイズを超えました|
|`DECODE_E` |-416 |ハンドシェイクメッセージエラーをデコードします|
|`HTTP_TIMEOUT` |-417 |OCSPまたはCRL REQのHTTPタイムアウト|
|`WRITE_DUP_READ_E` |-418 |書き込みdup write sideは読めない|
|`WRITE_DUP_WRITE_E` |-419 |dup読み取りsideは書くことができません|
|`INVALID_CERT_CTX_E` |-420 |TLS CERT CTXは一致していません|
|`BAD_KEY_SHARE_DATA` |-421 |キー共有データ無効|
|`MISSING_HANDSHAKE_DATA` |-422 |ハンドシェイクメッセージ欠落データ|
|`BAD_BINDER` |-423 |バインダーが一致しません|
|`EXT_NOT_ALLOWED` |-424 |MSGでは許可されていない拡張|
|`INVALID_PARAMETER` |-425 |セキュリティパラメーター無効|
|`MCAST_HIGHWATER_CB_E` |-426 |マルチキャストハイウォーターCB err |
|`ALERT_COUNT_E` |-427 |アラート数を超えました|
|`EXT_MISSING` |-428 |必要な拡張機能が見つかりません|
|`UNSUPPORTED_EXTENSION` |-429 |TLSXはクライアントから要求されていません|
|`PRF_MISSING` |-430 ||にコンパイルされていないPRF|
|`DTLS_RETX_OVER_TX` |-431 |DTLSフライトを再送信|
|`DH_PARAMS_NOT_FFDHE_E` |-432 |ffdheではなくサーバーからのdhパラメーション|
|`TCA_INVALID_ID_TYPE` |-433 |TLSX TCA IDタイプ無効|
|`TCA_ABSENT_ERROR` |-434 |TLSX TCA ID応答なし|



ネゴシエーションパラメーターエラー

|エラーコード列挙|エラーコード|エラー説明|
| --------------- | ---------- | ----------------- |
|`UNSUPPORTED_SUITE` |-500 |サポートされていない暗号スイート|
|`MATCH_SUITE_ERROR` |-501 |暗号スイートと一致することはできません|
|`COMPRESSION_ERROR` |-502 |圧縮ミスマッチ|
|`KEY_SHARE_ERROR` |-503 |キーシェアミスマッチ|
|`POST_HAND_AUTH_ERROR` |-504 |クライアントはポストハンド認証を行いません|
|`HRR_COOKIE_ERROR` |-505 |HRR MSGクッキーミスマッチ|




## wolfcryptエラーコード



WolfCryptエラーコードは`wolfssl/wolfcrypt/error.h`にあります。

|エラーコード列挙|エラーコード|エラー説明|
| --------------- | ---------- | ----------------- |
|`OPEN_RAN_E` |-101 |ランダムデバイスを開く際にエラー|
|`READ_RAN_E` |-102 |ランダムデバイスのリード時にエラー|
|`WINCRYPT_E` |-103 |Windows Crypt initエラー|
|`CRYPTGEN_E` |-104 |Windows暗号化エラー|
|`RAN_BLOCK_E` |-105 |ランダムデバイスの読み取りでwould block|
|`BAD_MUTEX_E` |-106 |ミューテックス操作で失敗|
|`MP_INIT_E` |-110 |mp_initエラー状態|
|`MP_READ_E` |-111 |mp_readエラー状態|
|`MP_EXPTMOD_E` |-112 |MP_EXPTMODエラー状態|
|`MP_TO_E` |-113 |MP_TO_XXXエラー状態、変換できません|
|`MP_SUB_E` |-114 |MP_SUBエラー状態、減算できません
|`MP_ADD_E` |-115 |MP_ADDエラー状態、追加できません|
|`MP_MUL_E` |-116 |MP_MULエラー状態、|マイトルアップできません
|`MP_MULMOD_E` |-117 |MP_MULMODエラー状態、Morply MOD |を乗算できません
|`MP_MOD_E` |-118 |mp_modエラー状態、mod |
|`MP_INVMOD_E` |-119 |MP_INVMODエラー状態、INV MOD |を招くことはできません
|`MP_CMP_E` |-120 |MP_CMPエラー状態|
|`MP_ZERO_E` |-121 |予想されない、MPゼロ結果を得た
|`MEMORY_E` |-125 |メモリのエラー|
|`RSA_WRONG_TYPE_E` |-130 |RSA関数のRSA間違ったブロックタイプ|
|`RSA_BUFFER_E` |-131 |RSAバッファーエラー、出力が小さすぎる、または入力が大きすぎる|
|`BUFFER_E` |-132 |出力バッファーが小さすぎるか、入力が大きすぎる|
|`ALGO_ID_E` |-133 |ALGO IDエラーの設定|
|`PUBLIC_KEY_E` |-134 |公開キーエラーの設定|
|`DATE_E` |-135 |日付有効性エラー|
|`SUBJECT_E` |-136 |件名名の設定エラー|
|`ISSUER_E` |-137 |発行者名エラーの設定|
|`CA_TRUE_E` |-138 |CA Basic Constraint True Error |を設定する
|`EXTENSIONS_E` |-139 |拡張機能の設定エラー|
|`ASN_PARSE_E` |-140 |ASN解析エラー、無効な入力|
|`ASN_VERSION_E` |-141 |ASNバージョンエラー、無効な数値|
|`ASN_GETINT_E` |-142 |ASNは大きなINTエラーを取得し、データが無効なデータ|
|`ASN_RSA_KEY_E` |-143 |ASNキーINITエラー、無効な入力|
|`ASN_OBJECT_ID_E` |-144 |ASNオブジェクトIDエラー、無効なID |
|`ASN_TAG_NULL_E` |-145 |asnタグエラー、null |ではありません
|`ASN_EXPECT_0_E` |-146 |asnはゼロではなく、エラーを期待します
|`ASN_BITSTR_E` |-147 |ASNビット文字列エラー、間違ったID |
|`ASN_UNKNOWN_OID_E` |-148 |ASN OIDエラー、不明な合計ID |
|`ASN_DATE_SZ_E` |-149 |ASN日付エラー、悪いサイズ|
|`ASN_BEFORE_DATE_E` |-150 |ASN日付エラー、現在の日付|
|`ASN_AFTER_DATE_E` |-151 |ASN日付エラー、現在の日付|
|`ASN_SIG_OID_E` |-152 |ASNシグネチャエラー、OIDの不一致|
|`ASN_TIME_E` |-153 |ASNタイムエラー、不明な時間タイプ|
|`ASN_INPUT_E` |-154 |ASN入力エラー、十分なデータがありません|
|`ASN_SIG_CONFIRM_E` |-155 |ASN SIGエラー、失敗の確認|
|`ASN_SIG_HASH_E` |-156 |ASN SIGエラー、サポートされていないハッシュタイプ|
|`ASN_SIG_KEY_E` |-157 |ASN SIGエラー、サポートされていないキータイプ|
|`ASN_DH_KEY_E` |-158 |ASNキーINITエラー、無効な入力|
|`ASN_CRIT_EXT_E` |-160 |サポートされていない批判的拡張|
|`ECC_BAD_ARG_E` |-170 |間違ったタイプのECC入力引数|
|`ASN_ECC_KEY_E` |-171 |ASN ECC不良入力|
|`ECC_CURVE_OID_E` |-172 |サポートされていないECC OIDカーブタイプ|
|`BAD_FUNC_ARG` |-173 |提供された悪い関数引数|
|`NOT_COMPILED_IN` |-174 |機能がコンパイルされていない|
|`UNICODE_SIZE_E` |-175 |Unicodeパスワード|マウサー|
|`NO_PASSWORD` |-176 |ユーザーが提供するパスワードはありません|
|`ALT_NAME_E` |-177 |Alt Name Sizeの問題、大きすぎます
|`AES_GCM_AUTH_E` |-180 |AES-GCM認証チェックの失敗|
|`AES_CCM_AUTH_E` |-181 |AES-CCM認証チェック不良|
|`CAVIUM_INIT_E` |-182 |キャビウムinitタイプエラー|
|`COMPRESS_INIT_E` |-183 |init Errorを圧縮します|
|`COMPRESS_E` |-184 |エラーを圧縮する|
|`DECOMPRESS_INIT_E` |-185 |initエラーを減圧します|
|`DECOMPRESS_E` |-186 |解凍エラー|
|`BAD_ALIGN_E` |-187 |操作のための悪いアライメント、Allocのない|
|`ASN_NO_SIGNER_E` |-188 |ASN SIGエラー、証明書を検証するためのCA署名者はありません|
|`ASN_CRL_CONFIRM_E` |-189 |ASN CRL失敗を確認する署名者はありません|
|`ASN_CRL_NO_SIGNER_E` |-190 |ASN CRL失敗を確認する署名者はありません|
|`ASN_OCSP_CONFIRM_E` |-191 |ASN OCSPシグネチャーの確認失敗|
|`BAD_ENC_STATE_E` |-192 |悪いECC ENC状態操作|
|`BAD_PADDING_E` |-193 |悪いパディング、MSGは正しい長さ|
|`REQ_ATTRIBUTE_E` |-194 |CERT要求属性の設定エラー|
|`PKCS7_OID_E` |-195 |PKCS＃7、不一致のOIDエラー|
|`PKCS7_RECIP_E` |-196 |PKCS＃7、受信者エラー|
|`FIPS_NOT_ALLOWED_E` |-197 |FIPSは許可されていません|
|`ASN_NAME_INVALID_E` |-198 |ASN名制約エラー|
|`RNG_FAILURE_E` |-199 |RNGが失敗し、再生|
|`HMAC_MIN_KEYLEN_E` |-200 |FIPSモードHMAC最小キー長エラー|
|`RSA_PAD_E` |-201 |RSAパディングエラー|
|`LENGTH_ONLY_E` |-202 |出力の長さのみを返す|
|`IN_CORE_FIPS_E` |-203 |コアの整合性チェックの失敗(障害)|
|`AES_KAT_FIPS_E` |-204 |AESカット失敗|
|`DES3_KAT_FIPS_E` |-205 |DES3 KAT障害|
|`HMAC_KAT_FIPS_E` |-206 |HMAC KAT障害|
|`RSA_KAT_FIPS_E` |-207 |RSA KAT失敗|
|`DRBG_KAT_FIPS_E` |-208 |ハッシュDRBG KAT障害|
|`DRBG_CONT_FIPS_E` |-209 |ハッシュDRBG連続テスト障害|
|`AESGCM_KAT_FIPS_E` |-210 |AESGCM KAT障害|
|`THREAD_STORE_KEY_E` |-211 |スレッドローカルストレージキーは障害を作成します|
|`THREAD_STORE_SET_E` |-212 |スレッドローカルストレージキーセット障害|
|`MAC_CMP_FAILED_E` |-213 |Macの比較に失敗しました|
|`IS_POINT_E` |-214 |ECCは曲線上のポイントに失敗しました|
|`ECC_INF_E` |-215 |ECCポイントインフィニティエラー|
|`ECC_PRIV_KEY_E` |-216 |ECC秘密鍵が無効なエラー|
|`SRP_CALL_ORDER_E` |-217 |SRP機能が間違っている
|`SRP_VERIFY_E` |-218 |SRPプルーフ検証失敗|
|`SRP_BAD_KEY_E` |-219 |SRPの悪い一時的な値|
|`ASN_NO_SKID` |-220 |ASN主題のキー識別子| |
|`ASN_NO_AKID` |-221 |ASN認証鍵識別子を見つけません|
|`ASN_NO_KEYUSAGE` |-223 |ASNキー使用量は見つかりませんでした|
|`SKID_E` |-224 |件名キー識別子エラーの設定|
|`AKID_E` |-225 |権限キー識別子エラー|
|`KEYUSAGE_E` |-226 |悪いキー使用率値|
|`CERTPOLICIES_E` |-227 |証明書ポリシーの設定エラー|
|`WC_INIT_E` |-228 |wolfcryptは初期化に失敗しました|
|`SIG_VERIFY_E` |-229 |wolfcryptシグネチャーの検証エラー|
|`BAD_PKCS7_SIGNEEDS_CHECKCOND_E` |-230 |悪条件変数演算|
|`SIG_TYPE_E` |-231 |署名タイプが有効/利用可能な|
|`HASH_TYPE_E` |-232 |ハッシュタイプは有効/利用可能ではありません|
|`WC_KEY_SIZE_E` |-234 |キーサイズエラー、小さすぎるか大きすぎる|
|`ASN_COUNTRY_SIZE_E` |-235 |ASN CERT GEN、無効な国コードサイズ|
|`MISSING_RNG_E` |-236 |RNGは必要ですが、提供されていません|
|`ASN_PATHLEN_SIZE_E` |-237 |ASN CAパスの長さ大きすぎます|
|`ASN_PATHLEN_INV_E` |-238 |ASN CAパスの長さ反転誤差|
|`BAD_KEYWRAP_ALG_E` |-239 |KeyWrapのアルゴリズムエラー|
|`BAD_KEYWRAP_IV_E` |-240 |復号化されたAESキーラップIV不正|
|`WC_CLEANUP_E` |-241 |wolfcryptのクリーンアップに失敗しました|
|`ECC_CDH_KAT_FIPS_E` |-242 |ECC CDH既知の回答テスト失敗|
|`DH_CHECK_PUB_E` |-243 |DH公開キーエラーを確認します|
|`BAD_PATH_ERROR` |-244 |Opendirの悪い道|
|`ASYNC_OP_E` |-245 |非同期操作エラー|
|`ECC_PRIVATEONLY_E` |-246 |プライベートのみのECCキーの無効な使用|
|`EXTKEYUSAGE_E` |-247 |大幅なキー使用率値|
|`WC_HW_E` |-248 |ハードウェア暗号を使用するエラー|
|`WC_HW_WAIT_E` |-249 |リソースを待っているハードウェア|
|`PSS_SALTLEN_E` |-250 |PSSの塩の長さはハッシュには長すぎます|
|`PRIME_GEN_E` |-251 |プライムを見つける障害|
|`BER_INDEF_E` |-252 |無期限の長さのBERを復号することはできません|
|`RSA_OUT_OF_RANGE_E` |-253 |範囲外の暗号化への暗号文|
|`RSAPSS_PAT_FIPS_E` |-254 |RSA-PSSパット障害|
|`ECDSA_PAT_FIPS_E` |-255 |ECDSA PAT FALION |
|`DH_KAT_FIPS_E` |-256 |DH KAT障害|
|`AESCCM_KAT_FIPS_E` |-257 |AESCCM KAT障害|
|`SHA3_KAT_FIPS_E` |-258 |SHA-3 KAT障害|
|`ECDHE_KAT_FIPS_E` |-259 |ECDHE KAT失敗|
|`AES_GCM_OVERFLOW_E` |-260 |AES-GCM呼び出しカウンターオーバーフロー|
|`AES_CCM_OVERFLOW_E` |-261 |AES-CCM呼び出しカウンタオーバーフロー|
|`RSA_KEY_PAIR_E` |-262 |RSAキーペアワイズコンシステンシチェックフェイル|
|`DH_CHECK_PRIVE_E` |-263 |DH秘密鍵エラーを確認します|
|`WC_AFALG_SOCK_E` |-264 |AF_ALGソケットエラー|
|`WC_DEVCRYPTO_E` |-265 |/dev/cryptoエラー|
|`ZLIB_INIT_ERROR` |-266 |ZLIB INITエラー|
|`ZLIB_COMPRESS_ERROR` |-267 |Zlib圧縮エラー|
|`ZLIB_DECOMPRESS_ERROR` |-268 |ZLIB伸張エラー|
|`PKCS7_NO_SIGNER_E` |-269 |PKCS7署名データMSGの署名者はいません|
|`WC_PKCS7_WANT_READ_E` |-270 |PKCS7ストリーム操作では、より多くの入力が必要です|
|`CRYPTOCB_UNAVAILABLE` |-271 |Crypto Callbackが利用できません|
|`PKCS7_SIGNEEDS_CHECK` |-272 |発信者によって検証された署名のニーズ|
|`ASN_SELF_SIGNED_E` |-275 |ASN自己署名証明書エラー|
|`MIN_CODE_E` |-300 |エラー-101- -299 |




## 一般的なエラーコードとその解決策



アプリケーションをwolfsslで起動して実行するときに一般的に起こるエラーコードがいくつかあります。



### `ASN_NO_SIGNER_E` (-188)




このエラーは証明書を使用して署名CA証明書をロードしていない場合に発生します。これは、wolfSSLサンプルクライアントを使用してGoogleへの接続など、wolfSSLのサンプルサーバーまたはクライアントを別のクライアントまたはサーバーに使用して見ることができます。



```sh
./examples/client/client -g -h www.google.com -p 443
```



GoogleのCA証明書には「`-A`」コマンドラインオプションがロードされていないため、これはエラー-188で失敗します。



### `WANT_READ` (-323)



`WANT_READ`エラーは、非ブロッキングソケットを使用する場合に頻繁に発生し、非ブロッキングソケットを使用する場合は実際にはエラーではありませんが、エラーとして発信者に渡されます。I/Oコールバックからデータを受信する呼び出しが現在受信できるデータがないため、ブロックされると、I/Oコールバックは`WANT_READ`を返します。発信者は、後で待って再度受信してみてください。これは通常、[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)、[`wolfSSL_negotiate()`](group__IO.md#function-wolfssl_negotiate)、[`wolfSSL_accept()`](group__IO.md#function-wolfssl_accept)、および[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)への呼び出しから見られます。クライアントとサーバーのサンプルは、デバッグが有効になっているときの`WANT_READ`インシデントを示します。
