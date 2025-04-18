# エラーコード

## wolfSSL エラーコード

wolfSSLのエラーコードは、`wolfssl/ssl.h`に記載しています。
以下のエラーの詳細な説明については、OpenSSLのマニュアルページ`SSL_get_error`（`man SSL_get_error`）をご参照ください。

| エラーコード列挙型 | エラーコード |
| --------------- | ---------- |
| `SSL_ERROR_WANT_READ` | 2 |
| `SSL_ERROR_WANT_WRITE` | 3 |
| `SSL_ERROR_WANT_CONNECT` | 7 |
| `SSL_ERROR_WANT_ACCEPT` | 8 |
| `SSL_ERROR_SYSCALL` | 5 |
| `SSL_ERROR_WANT_X509_LOOKUP` | 83 |
| `SSL_ERROR_ZERO_RETURN` | 6 |
| `SSL_ERROR_SSL` | 85 |

wolfSSLの追加のエラーコードは、`wolfssl/error-ssl.h`に記載しています。

| エラーコード列挙型 | エラーコード | エラーの説明 |
| --------------- | ---------- | ----------------- |
| `INPUT_CASE_ERROR` | -301 | プロセス入力状態エラー |
| `PREFIX_ERROR` | -302 | 鍵ラウンドへの不正なインデックス |
| `MEMORY_ERROR` | -303 | メモリ確保失敗 |
| `VERIFY_FINISHED_ERROR` | -304 | Finishedメッセージ検証に失敗 |
| `VERIFY_MAC_ERROR` | -305 | MAC検証に失敗 |
| `PARSE_ERROR` | -306 | ヘッダーの解析エラー |
| `UNKNOWN_HANDSHAKE_TYPE` | -307 | 不正なハンドシェイクタイプ |
| `SOCKET_ERROR_E` | -308 | ソケットがエラー状態 |
| `SOCKET_NODATA` | -309 | 予想されるデータが存在しない |
| `INCOMPLETE_DATA` | -310 | タスクを完了するのに十分なデータがない |
| `UNKNOWN_RECORD_TYPE` | -311 | レコードヘッダーの不明なタイプ |
| `DECRYPT_ERROR` | -312 | 復号中のエラー |
| `FATAL_ERROR` | -313 | 致命的なエラーアラートを受信 |
| `ENCRYPT_ERROR` | -314 | 暗号化中のエラー |
| `FREAD_ERROR` | -315 | freadでエラー |
| `NO_PEER_KEY` | -316 | ピアの鍵が存在しない |
| `NO_PRIVATE_KEY` | -317 | 秘密鍵が存在しない |
| `RSA_PRIVATE_ERROR` | -318 | RSA秘密鍵操作中のエラー |
| `NO_DH_PARAMS` | -319 | サーバーがDHパラメータを送信してこない |
| `BUILD_MSG_ERROR` | -320 | メッセージの作成に失敗 |
| `BAD_HELLO` | -321 | ClientHelloメッセージが不正 |
| `DOMAIN_NAME_MISMATCH` | -322 | ピアのサブジェクト名の不一致 |
| `WANT_READ` | -323 | データ再読み取りが必要 |
| `NOT_READY_ERROR` | -324 | ハンドシェイクレイヤーがReadyでない |
| `VERSION_ERROR` | -326 | レコードレイヤーのバージョンエラー |
| `WANT_WRITE` | -327 | データの再送が必要 |
| `BUFFER_ERROR` | -328 | 不正な形式のバッファ入力 |
| `VERIFY_CERT_ERROR` | -329 | 証明書検証エラー |
| `VERIFY_SIGN_ERROR` | -330 | 署名検証エラー |
| `CLIENT_ID_ERROR` | -331 | PSKクライアントIDエラー |
| `SERVER_HINT_ERROR` | -332 | PSKサーバーヒントエラー |
| `PSK_KEY_ERROR` | -333 | PSK鍵エラー |
| `GETTIME_ERROR` | -337 | gettimeofdayが失敗 |
| `GETITIMER_ERROR` | -338 | getitimerが失敗 |
| `SIGACT_ERROR` | -339 | sigactionが失敗 |
| `SETITIMER_ERROR` | -340 | setitimerが失敗 |
| `LENGTH_ERROR` | -341 | レコードレイヤーの長さが不正 |
| `PEER_KEY_ERROR` | -342 | ピア鍵のデコードに失敗 |
| `ZERO_RETURN` | -343 | ピアがclose notifyを送信 |
| `SIDE_ERROR` | -344 | クライアント/サーバータイプが不正 |
| `NO_PEER_CERT` | -345 | ピアが鍵を送信しなかった |
| `ECC_CURVETYPE_ERROR` | -350 | 不正なECC曲線タイプ |
| `ECC_CURVE_ERROR` | -351 | 不正なECC曲線 |
| `ECC_PEERKEY_ERROR` | -352 | 不正なピアECC鍵 |
| `ECC_MAKEKEY_ERROR` | -353 | 不正なECC鍵の作成 |
| `ECC_EXPORT_ERROR` | -354 | 不正なECCエクスポート鍵 |
| `ECC_SHARED_ERROR` | -355 | 不正なECC共有秘密 |
| `NOT_CA_ERROR` | -357 | CA証明書ではない |
| `BAD_CERT_MANAGER_ERROR` | -359 | 不正な証明書マネージャー |
| `OCSP_CERT_REVOKED` | -360 | OCSP証明書が失効 |
| `CRL_CERT_REVOKED` | -361 | CRL証明書が失効 |
| `CRL_MISSING` | -362 | CRLが読み込まれていない |
| `MONITOR_SETUP_E` | -363 | CRLモニターのセットアップエラー |
| `THREAD_CREATE_E` | -364 | スレッド作成エラー |
| `OCSP_NEED_URL` | -365 | OCSPは検索用のURLが必要 |
| `OCSP_CERT_UNKNOWN` | -366 | OCSPレスポンダーが不明 |
| `OCSP_LOOKUP_FAIL` | -367 | OCSP検索が失敗 |
| `MAX_CHAIN_ERROR` | -368 | 最大チェーン深度を超えた |
| `COOKIE_ERROR` | -369 | DTLSクッキーエラー |
| `SEQUENCE_ERROR` | -370 | DTLSシーケンスエラー |
| `SUITES_ERROR` | -371 | スイートポインタエラー |
| `OUT_OF_ORDER_E` | -373 | 順序外のメッセージ |
| `BAD_KEA_TYPE_E` | -374 | 不正なKEAタイプが見つかった |
| `SANITY_CIPHER_E` | -375 | 暗号のサニティチェックエラー |
| `RECV_OVERFLOW_E` | -376 | 受信コールバックが要求以上のデータを返却した |
| `GEN_COOKIE_E` | -377 | クッキー生成エラー |
| `NO_PEER_VERIFY` | -378 | 検証すべきピア証明書が存在しない |
| `FWRITE_ERROR` | -379 | fwriteエラー |
| `CACHE_MATCH_ERROR` | -380 | キャッシュHRD不一致 |
| `UNKNOWN_SNI_HOST_NAME_E` | -381 | 認識されないホスト名 |
| `UNKNOWN_MAX_FRAG_LEN_E` | -382 | 認識されない最大フラグメント |
| `KEYUSE_SIGNATURE_E` | -383 | KeyUse digSignatureエラー |
| `KEYUSE_ENCIPHER_E` | -385 | KeyUse KeyEncipherエラー |
| `EXTKEYUSE_AUTH_E` | -386 | ExtKeyUse server・client_auth |
| `SEND_OOB_READ_E` | -387 | 送信コールバックが境界外読み取り |
| `SECURE_RENEGOTIATION_E` | -388 | 無効な再ネゴシエーション情報 |
| `SESSION_TICKET_LEN_E` | -389 | セッションチケットが大きすぎる |
| `SESSION_TICKET_EXPECT_E` | -390 | セッションチケットがない |
| `SCR_DIFFERENT_CERT_E` | -391 | SCR異なる証明書エラー |
| `SESSION_SECRET_CB_E` | -392 | セッション秘密CB関数の失敗 |
| `NO_CHANGE_CIPHER_E` | -393 | Cipher変更前に終了 |
| `SANITY_MSG_E` | -394 | メッセージ順序のサニティチェックエラー |
| `DUPLICATE_MST_E` | -395 | 重複メッセージエラー |
| `SNI_UNSUPPORTED` | -396 | SSL 3.0はSNIをサポートしていない |
| `SOCKET_PEER_CLOSED_E` | -397 | トランスポート層がクローズされた |
| `BAD_TICKET_KEY_CB_SZ` | -398 | 不正なセッションチケット鍵cbサイズ |
| `BAD_TICKET_MSG_SZ` | -399 | 不正なセッションチケットmsgサイズ |
| `BAD_TICKET_ENCRYPT` | -400 | 不正なユーザーチケット暗号化 |
| `DH_KEY_SIZE_E` | -401 | DH鍵が小さすぎる |
| `SNI_ABSENT_ERROR` | -402 | SNIリクエストなし |
| `RSA_SIGN_FAULT` | -403 | RSA署名障害 |
| `HANDSHAKE_SIZE_ERROR` | -404 | ハンドシェイクメッセージが大きすぎる |
| `UNKNOWN_ALPN_PROTOCOL_NAME_E` | -405 | 認識されないプロトコル名 |
| `BAD_CERTIFICATE_STATUS_ERROR` | -406 | 不正な証明書ステータスメッセージ |
| `OCSP_INVALID_STATUS` | -407 | 無効なOCSPステータス |
| `OCSP_WANT_READ` | -408 | OCSPコールバックレスポンス |
| `RSA_KEY_SIZE_E` | -409 | RSA鍵が小さすぎる |
| `ECC_KEY_SIZE_E` | -410 | ECC鍵が小さすぎる |
| `DTLS_EXPORT_VER_E` | -411 | エクスポートバージョンエラー |
| `INPUT_SIZE_E` | -412 | 入力サイズが大きすぎる |
| `CTX_INIT_MUTEX_E` | -413 | コンテキストミューテックス初期化エラー |
| `EXT_MASTER_SECRET_NEEDED_E` | -414 | 再開するにはEMSを有効にする必要がある |
| `DTLS_POOL_SZ_E` | -415 | DTLSプールサイズを超えた |
| `DECODE_E` | -416 | ハンドシェイクメッセージのデコードエラー |
| `HTTP_TIMEOUT` | -417 | OCSPまたはCRLリクエストのHTTPタイムアウト |
| `WRITE_DUP_READ_E` | -418 | 書き込み複製の書き込み側が読み込めない |
| `WRITE_DUP_WRITE_E` | -419 | 書き込み複製の読み込み側が書き込めない |
| `INVALID_CERT_CTX_E` | -420 | TLS証明書コンテキストが一致しない |
| `BAD_KEY_SHARE_DATA` | -421 | 鍵共有データが無効 |
| `MISSING_HANDSHAKE_DATA` | -422 | ハンドシェイクメッセージにデータがない |
| `BAD_BINDER` | -423 | バインダーが一致しない |
| `EXT_NOT_ALLOWED` | -424 | 拡張子がメッセージで許可されていない |
| `INVALID_PARAMETER` | -425 | セキュリティパラメータが無効 |
| `MCAST_HIGHWATER_CB_E` | -426 | マルチキャストハイウォーターcbエラー |
| `ALERT_COUNT_E` | -427 | アラートカウントを超えた |
| `EXT_MISSING` | -428 | 必要な拡張機能が見つからない |
| `UNSUPPORTED_EXTENSION` | -429 | TLSXはクライアントから要求されていない |
| `PRF_MISSING` | -430 | PRFがコンパイルされていない |
| `DTLS_RETX_OVER_TX` | -431 | DTLSフライトを再送信 |
| `DH_PARAMS_NOT_FFDHE_E` | -432 | サーバーからのDHパラメータがFFDHEでない |
| `TCA_INVALID_ID_TYPE` | -433 | TLSX TCA IDタイプが無効 |
| `TCA_ABSENT_ERROR` | -434 | TLSX TCA IDレスポンスなし |

ネゴシエーションパラメータエラー

| エラーコード列挙型 | エラーコード | エラーの説明 |
| --------------- | ---------- | ----------------- |
| `UNSUPPORTED_SUITE` | -500 | サポートされていない暗号スイート |
| `MATCH_SUITE_ERROR` | -501 | 暗号スイートの不一致 |
| `COMPRESSION_ERROR` | -502 | 圧縮の不一致 |
| `KEY_SHARE_ERROR` | -503 | 鍵共有の不一致 |
| `POST_HAND_AUTH_ERROR` | -504 | クライアントがポストハンド認証を行わない |
| `HRR_COOKIE_ERROR` | -505 | HRRメッセージクッキーの不一致 |

## wolfCryptエラーコード

wolfCryptのエラーコードは、`wolfssl/wolfcrypt/error.h`に記載しています。

| エラーコード列挙型 | エラーコード | エラーの説明 |
| --------------- | ---------- | ----------------- |
| `OPEN_RAN_E` | -101 | ランダムデバイスを開く際にエラー |
| `READ_RAN_E` | -102 | ランダムデバイスの読み取りエラー |
| `WINCRYPT_E` | -103 | Windows crypt初期化エラー |
| `CRYPTGEN_E` | -104 | Windows crypt暗号化エラー |
| `RAN_BLOCK_E` | -105 | ランダムデバイスの読み取りがブロックされる |
| `BAD_MUTEX_E` | -106 | ミューテックス操作で失敗 |
| `MP_INIT_E` | -110 | mp_initエラー |
| `MP_READ_E` | -111 | mp_readエラー |
| `MP_EXPTMOD_E` | -112 | mp_exptmodエラー |
| `MP_TO_E` | -113 | mp_to_xxxエラー、変換できない |
| `MP_SUB_E` | -114 | mp_subエラー、引き算できない |
| `MP_ADD_E` | -115 | mp_addエラー、足し算できない |
| `MP_MUL_E` | -116 | mp_mulエラー、掛け算できない |
| `MP_MULMOD_E` | -117 | mp_mulmodエラー、mod掛け算できない |
| `MP_MOD_E` | -118 | mp_modエラー、modできない |
| `MP_INVMOD_E` | -119 | mp_invmodエラー、invmodできない |
| `MP_CMP_E` | -120 | mp_cmpエラー |
| `MP_ZERO_E` | -121 | 予期しないmp zeroの結果を取得 |
| `MEMORY_E` | -125 | メモリ不足エラー |
| `RSA_WRONG_TYPE_E` | -130 | RSA関数に対する不正なブロックタイプ |
| `RSA_BUFFER_E` | -131 | RSAバッファエラー、出力が小さすぎるか入力が大きすぎる |
| `BUFFER_E` | -132 | 出力バッファが小さすぎるか入力が大きすぎる |
| `ALGO_ID_E` | -133 | アルゴリズムID設定エラー |
| `PUBLIC_KEY_E` | -134 | 公開鍵設定エラー |
| `DATE_E` | -135 | 日付有効性エラー |
| `SUBJECT_E` | -136 | サブジェクト名設定エラー |
| `ISSUER_E` | -137 | 発行者名設定エラー |
| `CA_TRUE_E` | -138 | CA基本制約をtrueに設定するエラー |
| `EXTENSIONS_E` | -139 | 拡張設定エラー |
| `ASN_PARSE_E` | -140 | ASN解析エラー、無効な入力 |
| `ASN_VERSION_E` | -141 | ASNバージョンエラー、無効な番号 |
| `ASN_GETINT_E` | -142 | ASN大きな整数取得エラー、無効なデータ |
| `ASN_RSA_KEY_E` | -143 | ASN鍵初期化エラー、無効な入力 |
| `ASN_OBJECT_ID_E` | -144 | ASNオブジェクトIDエラー、無効なID |
| `ASN_TAG_NULL_E` | -145 | ASNタグエラー、nullでない |
| `ASN_EXPECT_0_E` | -146 | ASN期待値エラー、ゼロでない |
| `ASN_BITSTR_E` | -147 | ASNビット文字列エラー、不正なID |
| `ASN_UNKNOWN_OID_E` | -148 | ASN OIDエラー、不明な合計ID |
| `ASN_DATE_SZ_E` | -149 | ASN日付エラー、不正なサイズ |
| `ASN_BEFORE_DATE_E` | -150 | ASN日付エラー、現在の日付が前 |
| `ASN_AFTER_DATE_E` | -151 | ASN日付エラー、現在の日付が後 |
| `ASN_SIG_OID_E` | -152 | ASN署名エラー、OIDが一致しない |
| `ASN_TIME_E` | -153 | ASN時間エラー、不明な時間タイプ |
| `ASN_INPUT_E` | -154 | ASN入力エラー、データ不足 |
| `ASN_SIG_CONFIRM_E` | -155 | ASN署名エラー、確認失敗 |
| `ASN_SIG_HASH_E` | -156 | ASN署名エラー、サポートされていないハッシュタイプ |
| `ASN_SIG_KEY_E` | -157 | ASN署名エラー、サポートされていない鍵タイプ |
| `ASN_DH_KEY_E` | -158 | ASN鍵初期化エラー、無効な入力 |
| `ASN_CRIT_EXT_E` | -160 | ASNサポートされていない重要な拡張 |
| `ECC_BAD_ARG_E` | -170 | ECC入力引数の型が間違っている |
| `ASN_ECC_KEY_E` | -171 | ASN ECC不正な入力 |
| `ECC_CURVE_OID_E` | -172 | サポートされていないECC OID曲線タイプ |
| `BAD_FUNC_ARG` | -173 | 不正な関数引数が提供された |
| `NOT_COMPILED_IN` | -174 | 機能がコンパイルされていない |
| `UNICODE_SIZE_E` | -175 | Unicodeパスワードが大きすぎる |
| `NO_PASSWORD` | -176 | ユーザーからのパスワード提供なし |
| `ALT_NAME_E` | -177 | Alt Nameのサイズ問題、大きすぎる |
| `AES_GCM_AUTH_E` | -180 | AES-GCM認証チェック失敗 |
| `AES_CCM_AUTH_E` | -181 | AES-CCM認証チェック失敗 |
| `CAVIUM_INIT_E` | -182 | Cavium初期化タイプエラー |
| `COMPRESS_INIT_E` | -183 | 圧縮初期化エラー |
| `COMPRESS_E` | -184 | 圧縮エラー |
| `DECOMPRESS_INIT_E` | -185 | 解凍初期化エラー |
| `DECOMPRESS_E` | -186 | 解凍エラー |
| `BAD_ALIGN_E` | -187 | 操作の不正なアライメント、割り当てなし |
| `ASN_NO_SIGNER_E` | -188 | ASN署名エラー、証明書を検証するCAの署名者なし |
| `ASN_CRL_CONFIRM_E` | -189 | ASN CRL失敗を確認する署名者なし |
| `ASN_CRL_NO_SIGNER_E` | -190 | ASN CRL失敗を確認する署名者なし |
| `ASN_OCSP_CONFIRM_E` | -191 | ASN OCSP署名確認失敗 |
| `BAD_ENC_STATE_E` | -192 | 不正なECC暗号化状態操作 |
| `BAD_PADDING_E` | -193 | 不正なパディング、メッセージ長が不正 |
| `REQ_ATTRIBUTE_E` | -194 | 証明書リクエスト属性設定エラー |
| `PKCS7_OID_E` | -195 | PKCS#7、OIDの不一致エラー |
| `PKCS7_RECIP_E` | -196 | PKCS#7、受信者エラー |
| `FIPS_NOT_ALLOWED_E` | -197 | FIPSは許可されていません |
| `ASN_NAME_INVALID_E` | -198 | ASN名前制約エラー |
| `RNG_FAILURE_E` | -199 | RNG失敗、再初期化 |
| `HMAC_MIN_KEYLEN_E` | -200 | FIPSモードHMAC最小鍵長エラー |
| `RSA_PAD_E` | -201 | RSAパディングエラー |
| `LENGTH_ONLY_E` | -202 | 出力長のみを返す |
| `IN_CORE_FIPS_E` | -203 | コア整合性チェック失敗 |
| `AES_KAT_FIPS_E` | -204 | AES KAT失敗 |
| `DES3_KAT_FIPS_E` | -205 | DES3 KAT失敗 |
| `HMAC_KAT_FIPS_E` | -206 | HMAC KAT失敗 |
| `RSA_KAT_FIPS_E` | -207 | RSA KAT失敗 |
| `DRBG_KAT_FIPS_E` | -208 | HASH DRBG KAT失敗 |
| `DRBG_CONT_FIPS_E` | -209 | HASH DRBG継続テスト失敗 |
| `AESGCM_KAT_FIPS_E` | -210 | AESGCM KAT失敗 |
| `THREAD_STORE_KEY_E` | -211 | スレッドローカルストレージキー作成失敗 |
| `THREAD_STORE_SET_E` | -212 | スレッドローカルストレージキー設定失敗 |
| `MAC_CMP_FAILED_E` | -213 | MAC比較失敗 |
| `IS_POINT_E` | -214 | ECC曲線上の点判定失敗 |
| `ECC_INF_E` | -215 | ECC点無限大エラー |
| `ECC_PRIV_KEY_E` | -216 | ECC秘密鍵が無効エラー |
| `SRP_CALL_ORDER_E` | -217 | SRP関数が間違った順序で呼び出された |
| `SRP_VERIFY_E` | -218 | SRP証明検証失敗 |
| `SRP_BAD_KEY_E` | -219 | SRP不正な一時値 |
| `ASN_NO_SKID` | -220 | ASNサブジェクト鍵識別子なし |
| `ASN_NO_AKID` | -221 | ASN権限鍵識別子なし |
| `ASN_NO_KEYUSAGE` | -223 | ASN鍵用途なし |
| `SKID_E` | -224 | サブジェクト鍵識別子設定エラー |
| `AKID_E` | -225 | 権限鍵識別子設定エラー |
| `KEYUSAGE_E` | -226 | 不正な鍵用途値 |
| `CERTPOLICIES_E` | -227 | 証明書ポリシー設定エラー |
| `WC_INIT_E` | -228 | wolfCrypt初期化失敗 |
| `SIG_VERIFY_E` | -229 | wolfCrypt署名検証エラー |
| `BAD_PKCS7_SIGNEEDS_CHECKCOND_E` | -230 | 不正な条件変数操作 |
| `SIG_TYPE_E` | -231 | 署名タイプが有効でない/利用不可 |
| `HASH_TYPE_E` | -232 | ハッシュタイプが有効でない/利用不可 |
| `WC_KEY_SIZE_E` | -234 | 鍵サイズエラー、小さすぎるか大きすぎる |
| `ASN_COUNTRY_SIZE_E` | -235 | ASN証明書生成、無効な国コードサイズ |
| `MISSING_RNG_E` | -236 | RNGが必要だが提供されていない |
| `ASN_PATHLEN_SIZE_E` | -237 | ASN CAパス長が大きすぎるエラー |
| `ASN_PATHLEN_INV_E` | -238 | ASN CAパス長反転エラー |
| `BAD_KEYWRAP_ALG_E` | -239 | キーラップのアルゴリズムエラー |
| `BAD_KEYWRAP_IV_E` | -240 | 復号化されたAESキーラップIVが不正 |
| `WC_CLEANUP_E` | -241 | wolfCryptクリーンアップに失敗 |
| `ECC_CDH_KAT_FIPS_E` | -242 | ECC CDH既知解テスト失敗 |
| `DH_CHECK_PUB_E` | -243 | DH公開鍵チェックエラー |
| `BAD_PATH_ERROR` | -244 | opendirのパスが不正 |
| `ASYNC_OP_E` | -245 | 非同期操作エラー |
| `ECC_PRIVATEONLY_E` | -246 | 秘密専用ECC鍵の無効な使用 |
| `EXTKEYUSAGE_E` | -247 | 不正な拡張鍵用途値 |
| `WC_HW_E` | -248 | ハードウェア暗号使用のエラー |
| `WC_HW_WAIT_E` | -249 | ハードウェアがリソース待ち |
| `PSS_SALTLEN_E` | -250 | PSSのsaltの長さがハッシュに対して長すぎる |
| `PRIME_GEN_E` | -251 | 素数発見に失敗 |
| `BER_INDEF_E` | -252 | 不定長BERをデコードできない |
| `RSA_OUT_OF_RANGE_E` | -253 | 復号する暗号文が範囲外 |
| `RSAPSS_PAT_FIPS_E` | -254 | RSA-PSS PAT失敗 |
| `ECDSA_PAT_FIPS_E` | -255 | ECDSA PAT失敗 |
| `DH_KAT_FIPS_E` | -256 | DH KAT失敗 |
| `AESCCM_KAT_FIPS_E` | -257 | AESCCM KAT失敗 |
| `SHA3_KAT_FIPS_E` | -258 | SHA-3 KAT失敗 |
| `ECDHE_KAT_FIPS_E` | -259 | ECDHE KAT失敗 |
| `AES_GCM_OVERFLOW_E` | -260 | AES-GCM呼び出しカウンターオーバーフロー |
| `AES_CCM_OVERFLOW_E` | -261 | AES-CCM呼び出しカウンターオーバーフロー |
| `RSA_KEY_PAIR_E` | -262 | RSA鍵ペアーワイズ整合性チェック失敗 |
| `DH_CHECK_PRIVE_E` | -263 | DH秘密鍵チェックエラー |
| `WC_AFALG_SOCK_E` | -264 | AF_ALGソケットエラー |
| `WC_DEVCRYPTO_E` | -265 | /dev/cryptoエラー |
| `ZLIB_INIT_ERROR` | -266 | Zlib初期化エラー |
| `ZLIB_COMPRESS_ERROR` | -267 | Zlib圧縮エラー |
| `ZLIB_DECOMPRESS_ERROR` | -268 | Zlib解凍エラー |
| `PKCS7_NO_SIGNER_E` | -269 | PKCS7署名データメッセージに署名者なし |
| `WC_PKCS7_WANT_READ_E` | -270 | PKCS7ストリーム操作でより多くの入力が必要 |
| `CRYPTOCB_UNAVAILABLE` | -271 | 暗号コールバック利用不可 |
| `PKCS7_SIGNEEDS_CHECK` | -272 | 署名は呼び出し元による検証が必要 |
| `ASN_SELF_SIGNED_E` | -275 | ASN自己署名証明書エラー |
| `MIN_CODE_E` | -300 | エラー -101 - -299 |

## 一般的なエラーコードとその解決策

アプリケーションでwolfSSLを使用する際に起こしやすい、いくつかのエラーについてご説明します。

### `ASN_NO_SIGNER_E` (-188)

このエラーは、証明書を使用する際に、署名したCA証明書が読み込まれていない場合に発生します。
これは、wolfSSLのサンプルサーバーやクライアントを、別のクライアントやサーバーに対して使用する場合に見られることがあります。

例えば、wolfSSLのサンプルクライアントを使用してGoogleに接続する場合、次のように実行したくなるかもしれません。

```sh
./examples/client/client -g -h www.google.com -p 443
```

しかしこれは、GoogleのCA証明書が「`-A`」コマンドラインオプションで読み込まれていないため、エラー-188で失敗します。

### `WANT_READ` (-323)

`WANT_READ`エラーは、ノンブロッキングソケットを使用する場合によく発生します。
ノンブロッキングソケットを使用する場合において、実際にはエラーではありませんが、エラーとして出力されます。
I/Oコールバックからデータを受信する呼び出しが、現在受信可能なデータがないためブロックされる場合、I/Oコールバックは`WANT_READ`を返します。
呼び出し元は待機し、後で再度受信を試みてください。
これは通常、[`wolfSSL_read()`](group__IO.md#function-wolfssl_read)、[`wolfSSL_negotiate()`](group__IO.md#function-wolfssl_negotiate)、[`wolfSSL_accept()`](group__IO.md#function-wolfssl_accept)、および[`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect)の呼び出しから見られます。
サンプルクライアントとサーバーは、デバッグ出力が有効である場合に`WANT_READ`を出力します。