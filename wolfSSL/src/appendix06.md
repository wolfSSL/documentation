# Error Codes

## wolfSSL Error Codes

wolfSSL (formerly CyaSSL) error codes can be found in `wolfssl/ssl.h`.  For detailed descriptions of the following errors, see the OpenSSL man page for `SSL_get_error` (`man SSL_get_error`).

| Error Code Enum | Error Code | Error Description |
| --------------- | ---------- | ----------------- |
| `SSL_ERROR_WANT_READ` | 2 | |
| `SSL_ERROR_WANT_WRITE` | 3 | |
| `SSL_ERROR_WANT_CONNECT` | 7 | |
| `SSL_ERROR_WANT_ACCEPT` | 8 | |
| `SSL_ERROR_SYSCALL` | 5 | |
| `SSL_ERROR_WANT_X509_LOOKUP` | 83 | |
| `SSL_ERROR_ZERO_RETURN` | 6 | |
| `SSL_ERROR_SSL` | 85 | |

Additional wolfSSL error codes can be found in `wolfssl/error-ssl.h`

| Error Code Enum | Error Code | Error Description |
| --------------- | ---------- | ----------------- |
| `INPUT_CASE_ERROR` | -301 | process input state error |
| `PREFIX_ERROR` | -302 | bad index to key rounds |
| `MEMORY_ERROR` | -303 | out of memory |
| `VERIFY_FINISHED_ERROR` | -304 | verify problem on finished |
| `VERIFY_MAC_ERROR` | -305 | verify mac problem |
| `PARSE_ERROR` | -306 | parse error on header |
| `UNKNOWN_HANDSHAKE_TYPE` | -307 | weird handshake type |
| `SOCKET_ERROR_E` | -308 | error state on socket |
| `SOCKET_NODATA` | -309 | expected data, not there |
| `INCOMPLETE_DATA` | -310 | don't have enough data to complete task |
| `UNKNOWN_RECORD_TYPE` | -311 | unknown type in record hdr |
| `DECRYPT_ERROR` | -312 | error during decryption |
| `FATAL_ERROR` | -313 | revcd alert fatal error |
| `ENCRYPT_ERROR` | -314 | error during encryption |
| `FREAD_ERROR` | -315 | fread problem |
| `NO_PEER_KEY` | -316 | need peer's key |
| `NO_PRIVATE_KEY` | -317 | need the private key |
| `RSA_PRIVATE_ERROR` | -318 | error during rsa priv op |
| `NO_DH_PARAMS` | -319 | server missing DH params |
| `BUILD_MSG_ERROR` | -320 | build message failure |
| `BAD_HELLO` | -321 | client hello malformed |
| `DOMAIN_NAME_MISMATCH` | -322 | peer subject name mismatch |
| `WANT_READ` | -323 | want read, call again |
| `NOT_READY_ERROR` | -324 | handshake layer not ready |
| `VERSION_ERROR` | -326 | record layer version error |
| `WANT_WRITE` | -327 | want write, call again |
| `BUFFER_ERROR` | -328 | malformed buffer input |
| `VERIFY_CERT_ERROR` | -329 | verify cert error |
| `VERIFY_SIGN_ERROR` | -330 | verify sign error |
| `CLIENT_ID_ERROR` | -331 | psk client identity error |
| `SERVER_HINT_ERROR` | -332 | psk server hint error |
| `PSK_KEY_ERROR` | -333 | psk key error |
| `GETTIME_ERROR` | -337 | gettimeofday failed ??? |
| `GETITIMER_ERROR` | -338 | getitimer failed ??? |
| `SIGACT_ERROR` | -339 | sigaction failed ??? |
| `SETITIMER_ERROR` | -340 | setitimer failed ??? |
| `LENGTH_ERROR` | -341 | record layer length error |
| `PEER_KEY_ERROR` | -342 | cant decode peer key |
| `ZERO_RETURN` | -343 | peer sent close notify |
| `SIDE_ERROR` | -344 | wrong client/server type |
| `NO_PEER_CERT` | -345 | peer didn't send key |
| `ECC_CURVETYPE_ERROR` | -350 | Bad ECC Curve Type |
| `ECC_CURVE_ERROR` | -351 | Bad ECC Curve |
| `ECC_PEERKEY_ERROR` | -352 | Bad Peer ECC Key |
| `ECC_MAKEKEY_ERROR` | -353 | Bad Make ECC Key |
| `ECC_EXPORT_ERROR` | -354 | Bad ECC Export Key |
| `ECC_SHARED_ERROR` | -355 | Bad ECC Shared Secret |
| `NOT_CA_ERROR` | -357 | Not CA cert error |
| `BAD_CERT_MANAGER_ERROR` | -359 | Bad Cert Manager |
| `OCSP_CERT_REVOKED` | -360 | OCSP Certificate revoked |
| `CRL_CERT_REVOKED` | -361 | CRL Certificate revoked |
| `CRL_MISSING` | -362 | CRL Not loaded |
| `MONITOR_SETUP_E` | -363 | CRL Monitor setup error |
| `THREAD_CREATE_E` | -364 | Thread Create Error |
| `OCSP_NEED_URL` | -365 | OCSP need an URL for lookup |
| `OCSP_CERT_UNKNOWN` | -366 | OCSP responder doesn’t know |
| `OCSP_LOOKUP_FAIL` | -367 | OCSP lookup not successful |
| `MAX_CHAIN_ERROR` | -368 | max chain depth exceeded |
| `COOKIE_ERROR` | -369 | dtls cookie error |
| `SEQUENCE_ERROR` | -370 | dtls sequence error |
| `SUITES_ERROR` | -371 | suites pointer error |
| `OUT_OF_ORDER_E` | -373 | out of order message |
| `BAD_KEA_TYPE_E` | -374 | bad KEA type found |
| `SANITY_CIPHER_E` | -375 | sanity check on cipher error |
| `RECV_OVERFLOW_E` | -376 | RXCB returned more than rqed |
| `GEN_COOKIE_E` | -377 | Generate Cookie Error |
| `NO_PEER_VERIFY` | -378 | Need peer cert verify Error |
| `FWRITE_ERROR` | -379 | fwrite problem |
| `CACHE_MATCH_ERROR` | -380 | cache hrd match error |
| `UNKNOWN_SNI_HOST_NAME_E` | -381 | Unrecognized host name Error |
| `UNKNOWN_MAX_FRAG_LEN_E` | -382 | Unrecognized max frag len Error |
| `KEYUSE_SIGNATURE_E` | -383 | KeyUse digSignature error |
| `KEYUSE_ENCIPHER_E` | -385 | KeyUse KeyEncipher error |
| `EXTKEYUSE_AUTH_E` | -386 | ExtKeyUse server|client_auth |
| `SEND_OOB_READ_E` | -387 | Send Cb out of bounds read |
| `SECURE_RENEGOTIATION_E` | -388 | Invalid renegotiation info |
| `SESSION_TICKET_LEN_E` | -389 | Session Ticket too large |
| `SESSION_TICKET_EXPECT_E` | -390 | Session Ticket missing |
| `SCR_DIFFERENT_CERT_E` | -391 | SCR Different cert error |
| `SESSION_SECRET_CB_E` | -392 | Session secret CB fcn failure |
| `NO_CHANGE_CIPHER_E` | -393 | Finished before change cipher |
| `SANITY_MSG_E` | -394 | Sanity check on msg order error |
| `DUPLICATE_MST_E` | -395 | Duplicate message error |
| `SNI_UNSUPPORTED` | -396 | SSL 3.0 does not support SNI |
| `SOCKET_PEER_CLOSED_E` | -397 | Underlying transport closed |
| `BAD_TICKET_KEY_CB_SZ` | -398 |  Bad session ticket key cb size |
| `BAD_TICKET_MSG_SZ` | -399 | Bad session ticket msg size |
| `BAD_TICKET_ENCRYPT` | -400 | Bad user ticket encrypt |
| `DH_KEY_SIZE_E` | -401 | DH key too small |
| `SNI_ABSENT_ERROR` | -402 | No SNI request |
| `RSA_SIGN_FAULT` | -403 | RSA sign fault |
| `HANDSHAKE_SIZE_ERROR` | -404 | Handshake message too large |
| `UNKNOWN_ALPN_PROTOCOL_NAME_E` | -405 | Unrecognized protocol name error |
| `BAD_CERTIFICATE_STATUS_ERROR` | -406 | Bad certificate status message |
| `OCSP_INVALID_STATUS` | -407 | Invalid OCSP status |
| `OCSP_WANT_READ` | -408 | OCSP callback response |
| `RSA_KEY_SIZE_E` | -409 | RSA key too small |
| `ECC_KEY_SIZE_E` | -410 | ECC key too small |
| `DTLS_EXPORT_VER_E` | -411 | Export version error |
| `INPUT_SIZE_E` | -412 | Input size too big error |
| `CTX_INIT_MUTEX_E` | -413 | Initialize ctx mutex error |
| `EXT_MASTER_SECRET_NEEDED_E` | -414 | Need EMS enabled to resume |
| `DTLS_POOL_SZ_E` | -415 | Exceeded DTLS pool size |
| `DECODE_E` | -416 | Decode handshake message error |
| `HTTP_TIMEOUT` | -417 | HTTP timeout for OCSP or CRL req |
| `WRITE_DUP_READ_E` | -418 | Write dup write side can’t read |
| `WRITE_DUP_WRITE_E` | -419 | Write dup read side can’t write |
| `INVALID_CERT_CTX_E` | -420 | TLS cert ctx not matching |
| `BAD_KEY_SHARE_DATA` | -421 | Key share data invalid |
| `MISSING_HANDSHAKE_DATA` | -422 | Handshake message missing data |
| `BAD_BINDER` | -423 | Binder does not match |
| `EXT_NOT_ALLOWED` | -424 | Extension not allowed in msg |
| `INVALID_PARAMETER` | -425 | Security parameter invalid |
| `MCAST_HIGHWATER_CB_E` | -426 | Multicast highwater cb err |
| `ALERT_COUNT_E` | -427 | Alert count exceeded err |
| `EXT_MISSING` | -428 | Required extension not found |
| `UNSUPPORTED_EXTENSION` | -429 | TLSX not requested by client |
| `PRF_MISSING` | -430 | PRF not compiled in |
| `DTLS_RETX_OVER_TX` | -431 | Retransmit DTLS flight over |
| `DH_PARAMS_NOT_FFDHE_E` | -432 | DH params from server not FFDHE |
| `TCA_INVALID_ID_TYPE` | -433 | TLSX TCA ID type invalid |
| `TCA_ABSENT_ERROR` | -434 | TLSX TCA ID no response |

Negotiation Parameter Errors

| Error Code Enum | Error Code | Error Description |
| --------------- | ---------- | ----------------- |
| `UNSUPPORTED_SUITE` | -500 | Unsupported cipher suite |
| `MATCH_SUITE_ERROR` | -501 | Can’t match cipher suite |
| `COMPRESSION_ERROR` | -502 | Compression mismatch |
| `KEY_SHARE_ERROR` | -503 | Key share mismatch |
| `POST_HAND_AUTH_ERROR` | -504 | Client won’t do post-hand auth |
| `HRR_COOKIE_ERROR` | -505 | HRR msg cookie mismatch |

## wolfCrypt Error Codes

wolfCrypt error codes can be found in `wolfssl/wolfcrypt/error.h`.

| Error Code Enum | Error Code | Error Description |
| --------------- | ---------- | ----------------- |
| `OPEN_RAN_E` | -101 | opening random device error |
| `READ_RAN_E` | -102 | reading random device error |
| `WINCRYPT_E` | -103 | windows crypt init error |
| `CRYPTGEN_E` | -104 | windows crypt generation error |
| `RAN_BLOCK_E` | -105 | reading random device would block |
| `BAD_MUTEX_E` | -106 | Bad mutex operation |
| `MP_INIT_E` | -110 | mp_init error state |
| `MP_READ_E` | -111 | mp_read error state |
| `MP_EXPTMOD_E` | -112 | mp_exptmod error state |
| `MP_TO_E` | -113 | mp_to_xxx error state, can't convert |
| `MP_SUB_E` | -114 | mp_sub error state, can't subtract |
| `MP_ADD_E` | -115 | mp_add error state, can't add |
| `MP_MUL_E` | -116 | mp_mul error state, can't multiply |
| `MP_MULMOD_E` | -117 | mp_mulmod error state, can't multiply mod |
| `MP_MOD_E` | -118 | mp_mod error state, can't mod |
| `MP_INVMOD_E` | -119 | mp_invmod error state, can't inv mod |
| `MP_CMP_E` | -120 | mp_cmp error state |
| `MP_ZERO_E` | -121 | got a mp zero result, not expected |
| `MEMORY_E` | -125 | out of memory error |
| `RSA_WRONG_TYPE_E` | -130 | RSA wrong block type for RSA function |
| `RSA_BUFFER_E` | -131 | RSA buffer error, output too small or input too large |
| `BUFFER_E` | -132 | output buffer too small or input too large |
| `ALGO_ID_E` | -133 | setting algo id error |
| `PUBLIC_KEY_E` | -134 | setting public key error |
| `DATE_E` | -135 | setting date validity error |
| `SUBJECT_E` | -136 | setting subject name error |
| `ISSUER_E` | -137 | setting issuer name error |
| `CA_TRUE_E` | -138 | setting CA basic constraint true error |
| `EXTENSIONS_E` | -139 | setting extensions error |
| `ASN_PARSE_E` | -140 | ASN parsing error, invalid input |
| `ASN_VERSION_E` | -141 | ASN version error, invalid number |
| `ASN_GETINT_E` | -142 | ASN get big int error, invalid data |
| `ASN_RSA_KEY_E` | -143 | ASN key init error, invalid input |
| `ASN_OBJECT_ID_E` | -144 | ASN object id error, invalid id |
| `ASN_TAG_NULL_E` | -145 | ASN tag error, not null |
| `ASN_EXPECT_0_E` | -146 | ASN expect error, not zero |
| `ASN_BITSTR_E` | -147 | ASN bit string error, wrong id |
| `ASN_UNKNOWN_OID_E` | -148 | ASN oid error, unknown sum id |
| `ASN_DATE_SZ_E` | -149 | ASN date error, bad size |
| `ASN_BEFORE_DATE_E` | -150 | ASN date error, current date before |
| `ASN_AFTER_DATE_E` | -151 | ASN date error, current date after |
| `ASN_SIG_OID_E` | -152 | ASN signature error, mismatched oid |
| `ASN_TIME_E` | -153 | ASN time error, unknown time type |
| `ASN_INPUT_E` | -154 | ASN input error, not enough data |
| `ASN_SIG_CONFIRM_E` | -155 | ASN sig error, confirm failure |
| `ASN_SIG_HASH_E` | -156 | ASN sig error, unsupported hash type |
| `ASN_SIG_KEY_E` | -157 | ASN sig error, unsupported key type |
| `ASN_DH_KEY_E` | -158 | ASN key init error, invalid input |
| `ASN_CRIT_EXT_E` | -160 | ASN unsupported critical extension |
| `ECC_BAD_ARG_E` | -170 | ECC input argument of wrong type |
| `ASN_ECC_KEY_E` | -171 | ASN ECC bad input |
| `ECC_CURVE_OID_E` | -172 | Unsupported ECC OID curve type |
| `BAD_FUNC_ARG` | -173 | Bad function argument provided |
| `NOT_COMPILED_IN` | -174 | Feature not compiled in |
| `UNICODE_SIZE_E` | -175 | Unicode password too big |
| `NO_PASSWORD` | -176 | no password provided by user |
| `ALT_NAME_E` | -177 | alt name size problem, too big |
| `AES_GCM_AUTH_E` | -180 | AES-GCM Authentication check failure |
| `AES_CCM_AUTH_E` | -181 | AES-CCM Authentication check failure |
| `CAVIUM_INIT_E` | -182 | Cavium Init type error |
| `COMPRESS_INIT_E` | -183 | Compress init error |
| `COMPRESS_E` | -184 | Compress error |
| `DECOMPRESS_INIT_E` | -185 | DeCompress init error |
| `DECOMPRESS_E` | -186 | DeCompress error |
| `BAD_ALIGN_E` | -187 | Bad alignment for operation, no alloc |
| `ASN_NO_SIGNER_E` | -188 | ASN sig error, no CA signer to verify certificate |
| `ASN_CRL_CONFIRM_E` | -189 | ASN CRL no signer to confirm failure |
| `ASN_CRL_NO_SIGNER_E` | -190 | ASN CRL no signer to confirm failure |
| `ASN_OCSP_CONFIRM_E` | -191 | ASN OCSP signature confirm failure |
| `BAD_ENC_STATE_E` | -192 | Bad ecc enc state operation |
| `BAD_PADDING_E` | -193 | Bad padding, msg not correct length |
| `REQ_ATTRIBUTE_E` | -194 | Setting cert request attributes error |
| `PKCS7_OID_E` | -195 | PKCS#7, mismatched OID error |
| `PKCS7_RECIP_E` | -196 | PKCS#7, recipient error |
| `FIPS_NOT_ALLOWED_E` | -197 | FIPS not allowed error |
| `ASN_NAME_INVALID_E` | -198 | ASN name constraint error |
| `RNG_FAILURE_E` | -199 | RNG Failed, Reinitialize |
| `HMAC_MIN_KEYLEN_E` | -200 | FIPS Mode HMAC Minimum Key Length error |
| `RSA_PAD_E` | -201 | RSA Padding Error |
| `LENGTH_ONLY_E` | -202 | Returning output length only |
| `IN_CORE_FIPS_E` | -203 | In Core Integrity check failure |
| `AES_KAT_FIPS_E` | -204 | AES KAT failure |
| `DES3_KAT_FIPS_E` | -205 | DES3 KAT failure |
| `HMAC_KAT_FIPS_E` | -206 | HMAC KAT failure |
| `RSA_KAT_FIPS_E` | -207 | RSA KAT failure |
| `DRBG_KAT_FIPS_E` | -208 | HASH DRBG KAT failure |
| `DRBG_CONT_FIPS_E` | -209 | HASH DRBG Continuous test failure |
| `AESGCM_KAT_FIPS_E` | -210 | AESGCM KAT failure |
| `THREAD_STORE_KEY_E` | -211 | Thread local storage key create failure |
| `THREAD_STORE_SET_E` | -212 | Thread local storage key set failure |
| `MAC_CMP_FAILED_E` | -213 | MAC comparison failed |
| `IS_POINT_E` | -214 | ECC is point on curve failed |
| `ECC_INF_E` | -215 | ECC point infinity error |
| `ECC_PRIV_KEY_E` | -216 | ECC private key not valid error |
| `SRP_CALL_ORDER_E` | -217 | SRP function called in the wrong order |
| `SRP_VERIFY_E` | -218 | SRP proof verification failed |
| `SRP_BAD_KEY_E` | -219 | SRP bad ephemeral values |
| `ASN_NO_SKID` | -220 | ASN no Subject Key Identifier found |
| `ASN_NO_AKID` | -221 | ASN no Authority Key Identifier found |
| `ASN_NO_KEYUSAGE` | -223 | ASN no Key Usage found |
| `SKID_E` | -224 | Setting Subject Key Identifier error |
| `AKID_E` | -225 | Setting Authority Key Identifier error |
| `KEYUSAGE_E` | -226 | Bad Key Usage value |
| `CERTPOLICIES_E` | -227 | Setting Certificate Policies error |
| `WC_INIT_E` | -228 | wolfCrypt failed to initialize |
| `SIG_VERIFY_E` | -229 | wolfCrypt signature verify error |
| `BAD_PKCS7_SIGNEEDS_CHECKCOND_E` | -230 | Bad condition variable operation |
| `SIG_TYPE_E` | -231 | Signature Type not enabled/available |
| `HASH_TYPE_E` | -232 | Hash Type not enabled/available |
| `WC_KEY_SIZE_E` | -234 | Key size error, either too small or large |
| `ASN_COUNTRY_SIZE_E` | -235 | ASN Cert Gen, invalid country code size |
| `MISSING_RNG_E` | -236 | RNG required but not provided |
| `ASN_PATHLEN_SIZE_E` | -237 | ASN CA path length too large error |
| `ASN_PATHLEN_INV_E` | -238 | ASN CA path length inversion error |
| `BAD_KEYWRAP_ALG_E` | -239 | Algorithm error with keywrap |
| `BAD_KEYWRAP_IV_E` | -240 | Decrypted AES key wrap IV incorrect |
| `WC_CLEANUP_E` | -241 | wolfCrypt cleanup failed |
| `ECC_CDH_KAT_FIPS_E` | -242 | ECC CDH known answer test failure |
| `DH_CHECK_PUB_E` | -243 | DH check public key error |
| `BAD_PATH_ERROR` | -244 | Bad path for opendir |
| `ASYNC_OP_E` | -245 | Async operation error |
| `ECC_PRIVATEONLY_E` | -246 | Invalid use of private only ECC key |
| `EXTKEYUSAGE_E` | -247 | Bad extended key usage value |
| `WC_HW_E` | -248 | Error with hardware crypto use |
| `WC_HW_WAIT_E` | -249 | Hardware waiting on resource |
| `PSS_SALTLEN_E` | -250 | PSS length of salt is too long for hash |
| `PRIME_GEN_E` | -251 | Failure finding a prime |
| `BER_INDEF_E` | -252 | Cannot decode indefinite length BER |
| `RSA_OUT_OF_RANGE_E` | -253 | Ciphertext to decrypt out of range |
| `RSAPSS_PAT_FIPS_E` | -254 | RSA-PSS PAT failure |
| `ECDSA_PAT_FIPS_E` | -255 | ECDSA PAT failure |
| `DH_KAT_FIPS_E` | -256 | DH KAT failure |
| `AESCCM_KAT_FIPS_E` | -257 | AESCCM KAT failure |
| `SHA3_KAT_FIPS_E` | -258 | SHA-3 KAT failure |
| `ECDHE_KAT_FIPS_E` | -259 | ECDHE KAT failure |
| `AES_GCM_OVERFLOW_E` | -260 | AES-GCM invocation counter overflow |
| `AES_CCM_OVERFLOW_E` | -261 | AES-CCM invocation counter overflow |
| `RSA_KEY_PAIR_E` | -262 | RSA Key Pair-Wise consistency check fail |
| `DH_CHECK_PRIVE_E` | -263 | DH check private key error |
| `WC_AFALG_SOCK_E` | -264 | AF_ALG socket error |
| `WC_DEVCRYPTO_E` | -265 | /dev/crypto error |
| `ZLIB_INIT_ERROR` | -266 | Zlib init error |
| `ZLIB_COMPRESS_ERROR` | -267 | Zlib compression error |
| `ZLIB_DECOMPRESS_ERROR` | -268 | Zlib decompression error |
| `PKCS7_NO_SIGNER_E` | -269 | No signer in PKCS7 signed data msg |
| `WC_PKCS7_WANT_READ_E` | -270 | PKCS7 stream operation wants more input |
| `CRYPTOCB_UNAVAILABLE` | -271 | Crypto callback unavailable |
| `PKCS7_SIGNEEDS_CHECK` | -272 | Signature needs verified by caller |
| `ASN_SELF_SIGNED_E` | -275 | ASN self-signed certificate error |
| `MIN_CODE_E` | -300 | errors -101 -  -299 |

## Common Error Codes and their Solution

There are several error codes that commonly happen when getting an application up and running with wolfSSL.

### `ASN_NO_SIGNER_E` (-188)

This error occurs when using a certificate and the signing CA certificate was not loaded. This can be seen using the wolfSSL example server or client against another client or server, for example connecting to Google using the wolfSSL example client:

```sh
./examples/client/client -g -h www.google.com -p 443
```

This fails with error -188 because Google’s CA certificate wasn’t loaded with the “`-A`” command line option.

### `WANT_READ` (-323)

The `WANT_READ` error happens often when using non-blocking sockets, and isn’t actually an error when using non-blocking sockets, but it is passed up to the caller as an error. When a call to receive data from the I/O callback would block as there isn’t data currently available to receive, the I/O callback returns `WANT_READ`. The caller should wait and try receiving again later. This is usually seen from calls to [`wolfSSL_read()`](group__IO.md#function-wolfssl_read), [`wolfSSL_negotiate()`](group__IO.md#function-wolfssl_negotiate), [`wolfSSL_accept()`](group__IO.md#function-wolfssl_accept), and [`wolfSSL_connect()`](group__IO.md#function-wolfssl_connect). The example client and server will indicate the `WANT_READ` incidents when debugging is enabled.
