# wolfSSL 対応暗号スイート・鍵交換グループ・署名アルゴリズム一覧

## A. 暗号スイート

### A-1 TLS 1.3

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_AES_128_GCM_SHA256` | `0x13,0x01` | **有効** | `--enable-tls13` + `--enable-aesgcm` |
| `TLS_AES_256_GCM_SHA384` | `0x13,0x02` | **有効** | `--enable-tls13` + `--enable-aesgcm` + `--enable-sha384` |
| `TLS_CHACHA20_POLY1305_SHA256` | `0x13,0x03` | **有効** | `--enable-tls13` + `--enable-chacha` + `--enable-poly1305` |
| `TLS_AES_128_CCM_SHA256` | `0x13,0x04` | 無効 | `--enable-aesccm` |
| `TLS_AES_128_CCM_8_SHA256` | `0x13,0x05` | 無効 | `--enable-aesccm` |
| `TLS_SM4_GCM_SM3` | `0x00,0xC6` | 無効 | `--enable-sm4-gcm` + `--enable-sm3` |
| `TLS_SM4_CCM_SM3` | `0x00,0xC7` | 無効 | `--enable-sm4-ccm` + `--enable-sm3` |
| `TLS_SHA256_SHA256` | `0xC0,0xB4` | 無効 | `--enable-nullcipher` |
| `TLS_SHA384_SHA384` | `0xC0,0xB5` | 無効 | `--enable-nullcipher` + `--enable-sha384` |

### A-2 TLS 1.2 ECDHE-ECDSA

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2B` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2C` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA9` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x14` | **有効** | -（A-4の注記を参照） |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x09` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0A` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x23` | **有効** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x24` | **有効** | `--enable-sha384` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM` | `0xC0,0xAC` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8` | `0xC0,0xAE` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8` | `0xC0,0xAF` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x08` | 無効 | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x07` | 無効 | `--enable-arc4` |
| `TLS_ECDHE_ECDSA_WITH_NULL_SHA` | `0xC0,0x06` | 無効 | `--enable-nullcipher` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256` | `0xC0,0x5C` | 無効 | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384` | `0xC0,0x5D` | 無効 | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3` | `0xE0,0x11` | 無効 | `--enable-sm4-cbc` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_GCM_SM3` | `0xE0,0x51` | 無効 | `--enable-sm4-gcm` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CCM_SM3` | `0xE0,0x52` | 無効 | `--enable-sm4-ccm` + `--enable-sm3` + `--enable-sm2` |

### A-3 TLS 1.2 ECDHE-RSA

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2F` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x30` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA8` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x13` | **有効** | -（A-4の注記を参照） |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x13` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x14` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x27` | **有効** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x28` | **有効** | `--enable-sha384` |
| `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x12` | 無効 | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDHE_RSA_WITH_RC4_128_SHA` | `0xC0,0x11` | 無効 | `--enable-arc4` |

### A-4 TLS 1.2 DHE-RSA

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9E` | **有効** | - |
| `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9F` | **有効** | - |
| `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAA` | **有効** | - |
| `TLS_DHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x15` | **有効** | -（下記の注記を参照） |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x33` | **有効** | - |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x39` | **有効** | - |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x67` | **有効** | - |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x6B` | **有効** | - |
| `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x16` | 無効 | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x45` | 無効 | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x88` | 無効 | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBE` | 無効 | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC4` | 無効 | `--enable-camellia` |

DHはデフォルトで有効（`--enable-dh`。ただしFIPS v7以降のビルドを除く）であるため、DHE暗号スイートはデフォルトでビルドに含まれます。
サーバーがこれらの暗号スイートをネゴシエートするのは、`wolfSSL_CTX_SetTmpDH()`（または関連する関数）で読み込んだDHパラメータがある場合か、クライアントが提示したFFDHEグループからDHパラメータを選択した場合のみです。

A-2、A-3、A-4の`_OLD_POLY1305`暗号スイートは、ChaCha20-Poly1305暗号スイートの初期ドラフト版（ノンスとパディングが異なります）で、コードポイント`0xCC,0x13`から`0xCC,0x15`を使用します。
これらはIANAに登録されたRFC 7905の暗号スイートではありません。
これらはデフォルトでビルドに含まれ、提示されます。
削除するには`NO_OLD_POLY1305`を定義してください。

### A-5 TLS 1.2 RSA（静的鍵交換）

静的RSA鍵交換は前方秘匿性を提供しないため、推奨されません。
これらの暗号スイートは、デフォルトでは`--enable-all`を指定してもビルドに含まれません。
これらには`WOLFSSL_STATIC_RSA`が必要ですが、対応するconfigureオプションはありません（`CPPFLAGS=-DWOLFSSL_STATIC_RSA`または`user_settings.h`を使用してください）。
`WOLFSSL_SNIFFER`を定義すると、このマクロも自動的に定義されます。

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9C` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9D` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x2F` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x35` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x3C` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x3D` | 無効 | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CCM_8` | `0xC0,0xA0` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-aesccm` |
| `TLS_RSA_WITH_AES_256_CCM_8` | `0xC0,0xA1` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-aesccm` |
| `SSL_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x0A` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-des3` + `--enable-des3-tls-suites` |
| `SSL_RSA_WITH_RC4_128_SHA` | `0x00,0x05` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-arc4` |
| `SSL_RSA_WITH_RC4_128_MD5` | `0x00,0x04` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-arc4` + `--enable-md5` |
| `TLS_RSA_WITH_NULL_MD5` | `0x00,0x01` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` + `--enable-md5` |
| `TLS_RSA_WITH_NULL_SHA` | `0x00,0x02` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA256` | `0x00,0x3B` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x41` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x84` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBA` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC0` | 無効 | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |

### A-6 TLS 1.2 静的ECDH

静的ECDH鍵交換は前方秘匿性を提供しないため、推奨されません。
これらの暗号スイートには`WOLFSSL_STATIC_DH`（およびECC）が必要ですが、対応するconfigureオプションはありません（`CPPFLAGS=-DWOLFSSL_STATIC_DH`または`user_settings.h`を使用してください）。
`WOLFSSL_SNIFFER`を定義すると、このマクロも自動的に定義されます。

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x31` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x32` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x0E` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0F` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x29` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x2A` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_RC4_128_SHA` | `0xC0,0x0C` | 無効 | `-DWOLFSSL_STATIC_DH` + `--enable-arc4` |
| `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x0D` | 無効 | `-DWOLFSSL_STATIC_DH` + `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2D` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2E` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x04` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x05` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x25` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x26` | 無効 | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x02` | 無効 | `-DWOLFSSL_STATIC_DH` + `--enable-arc4` |
| `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x03` | 無効 | `-DWOLFSSL_STATIC_DH` + `--enable-des3` + `--enable-des3-tls-suites` |

### A-7 TLS 1.2 PSK

AESまたはNULL暗号を使用する純粋なPSK暗号スイートには、`WOLFSSL_STATIC_PSK`も必要です。
このマクロは`--enable-psk`では定義されません（`CPPFLAGS=-DWOLFSSL_STATIC_PSK`または`user_settings.h`を使用してください）。
`TLS_PSK_WITH_CHACHA20_POLY1305_SHA256`、DHE-PSK暗号スイート、ECDHE-PSK暗号スイートに必要なのは`--enable-psk`のみです。

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xA8` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xA9` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xAE` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xAF` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CBC_SHA` | `0x00,0x8C` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_CBC_SHA` | `0x00,0x8D` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CCM` | `0xC0,0xA4` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM` | `0xC0,0xA5` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_128_CCM_8` | `0xC0,0xA8` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM_8` | `0xC0,0xA9` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAB` | 無効 | `--enable-psk` + `--enable-chacha` |
| `TLS_PSK_WITH_NULL_SHA256` | `0x00,0xB0` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA384` | `0x00,0xB1` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA` | `0x00,0x2C` | 無効 | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |

### A-8 TLS 1.2 DHE-PSK

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xAA` | 無効 | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xAB` | 無効 | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xB2` | 無効 | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xB3` | 無効 | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_128_CCM` | `0xC0,0xA6` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_AES_256_CCM` | `0xC0,0xA7` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAD` | 無効 | `--enable-psk` + `--enable-chacha` |
| `TLS_DHE_PSK_WITH_NULL_SHA256` | `0x00,0xB4` | 無効 | `--enable-psk` + `--enable-nullcipher` |
| `TLS_DHE_PSK_WITH_NULL_SHA384` | `0x00,0xB5` | 無効 | `--enable-psk` + `--enable-nullcipher` |

### A-9 TLS 1.2 ECDHE-PSK

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256` | `0xC0,0x37` | 無効 | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256` | `0xD0,0x01` | 無効 | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAC` | 無効 | `--enable-psk` + `--enable-chacha` |
| `TLS_ECDHE_PSK_WITH_NULL_SHA256` | `0xC0,0x3A` | 無効 | `--enable-psk` + `--enable-nullcipher` |

### A-10 TLS 1.2 DH_anon

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `TLS_DH_anon_WITH_AES_128_CBC_SHA` | `0x00,0x34` | 無効 | `--enable-anon` |
| `TLS_DH_anon_WITH_AES_256_GCM_SHA384` | `0x00,0xA7` | 無効 | `--enable-anon` |

### A-11 シグナリング値とプライベート値

| 名前 | Wire Value | デフォルト | configureオプション |
|------|-----------|:-------:|-----------------|
| `TLS_EMPTY_RENEGOTIATION_INFO_SCSV` | `0x00,0xFF` | 無効 | `--enable-renegotiation-indication`（クライアントが送信します。デフォルトの`--enable-secure-renegotiation-info`が有効なサーバーはこれを認識します） |
| `WDM_WITH_NULL_SHA256` | `0x00,0xFE` | 無効 | `--enable-mcast`（wolfSSL DTLSマルチキャスト。DTLSとNULL暗号も有効にします） |

`--enable-harden-tls`（RFC 9325）はDHEおよびRC4暗号スイートを除外し、`--enable-harden-tls=128`の場合は3DES暗号スイートも除外します。
このオプションは、NULL、静的RSA、静的DH、匿名の各暗号スイートとは併用できません（ビルドがエラーで停止します）。

---

## B. 鍵交換グループ

### B-1 NIST楕円曲線

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `secp256r1` (P-256) | 23 | **有効** | `--enable-ecc` |
| `secp384r1` (P-384) | 24 | **有効** | `--enable-ecc` |
| `secp521r1` (P-521) | 25 | **有効** | `--enable-ecc` |
| `secp224r1` (P-224) | 21 | **有効** | `--enable-ecc` |
| `secp192r1` (P-192) | 19 | 無効 | `--with-eccminsz=192` |
| `secp160r1` | 16 | 無効 | `--with-eccminsz=160` |
| `secp160r2` | 17 | 無効 | `--enable-ecccustcurves=all` + `--with-eccminsz=160` |

ECC鍵の最小サイズ（`ECC_MIN_KEY_SZ`、`--with-eccminsz`で設定）はデフォルトで224ビット（FIPSビルドでは192ビット）であるため、P-224より小さい曲線を使用するには最小サイズを下げる必要があります。
これらの曲線のうち、RFC 8446がTLS 1.3向けに定義しているのは`secp256r1`、`secp384r1`、`secp521r1`のみですが、wolfSSLは他の曲線をプロトコルバージョンによって除外しません。

### B-2 Koblitz曲線

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `secp160k1` | 15 | 無効 | `--enable-ecccustcurves=all` + `--with-eccminsz=160` |
| `secp192k1` | 18 | 無効 | `--enable-ecccustcurves=all` + `--with-eccminsz=192` |
| `secp224k1` | 20 | 無効 | `--enable-ecccustcurves=all` |
| `secp256k1` | 22 | 無効 | `--enable-ecccustcurves=all` |

値を指定しない`--enable-ecccustcurves`では`WOLFSSL_CUSTOM_CURVES`のみが定義されます。
Koblitz曲線（`HAVE_ECC_KOBLITZ`）には`--enable-ecccustcurves=all`（または`--enable-all`）が必要です。

### B-3 Brainpool曲線

| グループ名 | ID | TLS版 | デフォルト | configureオプション |
|------------|:--:|:--------:|:-------:|-----------------|
| `brainpoolP256r1` | 26 | 1.2 | 無効 | `--enable-ecccustcurves` |
| `brainpoolP384r1` | 27 | 1.2 | 無効 | `--enable-ecccustcurves` |
| `brainpoolP512r1` | 28 | 1.2 | 無効 | `--enable-ecccustcurves` |
| `brainpoolP256r1tls13` | 31 | 1.3 | 無効 | `--enable-ecccustcurves` |
| `brainpoolP384r1tls13` | 32 | 1.3 | 無効 | `--enable-ecccustcurves` |
| `brainpoolP512r1tls13` | 33 | 1.3 | 無効 | `--enable-ecccustcurves` |

### B-4 X25519 / X448

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `x25519` | 29 | 無効 | `--enable-curve25519` |
| `x448` | 30 | 無効 | `--enable-curve448` |

### B-5 FFDHE

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `ffdhe2048` | 256 | 条件付き有効 | `--enable-dh`（TLS 1.3+DH有効時に自動設定） |
| `ffdhe3072` | 257 | 無効 | `-DHAVE_FFDHE_3072` |
| `ffdhe4096` | 258 | 無効 | `-DHAVE_FFDHE_4096` |
| `ffdhe6144` | 259 | 無効 | `-DHAVE_FFDHE_6144` |
| `ffdhe8192` | 260 | 無効 | `-DHAVE_FFDHE_8192` |

### B-6 SM2

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `sm2p256v1` | 41 | 無効 | `--enable-sm2` |

### B-7 ML-KEMスタンドアロン

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `ML_KEM_512` (alias `MLKEM512`) | 512 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML_KEM_768` (alias `MLKEM768`) | 513 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML_KEM_1024` (alias `MLKEM1024`) | 514 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |

### B-8 ML-KEMハイブリッド（標準）

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM768` | 4587 | 条件付き有効 | `--enable-mlkem` + `--enable-pqc-hybrids` |
| `X25519MLKEM768` | 4588 | 無効 | `--enable-mlkem` + `--enable-pqc-hybrids` + `--enable-curve25519` |
| `SecP384r1MLKEM1024` | 4589 | 条件付き有効 | `--enable-mlkem` + `--enable-pqc-hybrids` |

### B-9 ML-KEMハイブリッド（実験的）

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM512` | 12107 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP384r1MLKEM768` | 12108 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP521r1MLKEM1024` | 12109 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `X25519MLKEM512` | 12214 | 無効 | 同上 + `--enable-curve25519` |
| `X448MLKEM768` | 12215 | 無効 | 同上 + `--enable-curve448` |
| `P256_ML_KEM_512_OLD` | 12103 | 無効 | 同上 + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |
| `P384_ML_KEM_768_OLD` | 12104 | 無効 | 同上 + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |
| `P521_ML_KEM_1024_OLD` | 12105 | 無効 | 同上 + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |

`_OLD`のIDは、NIST曲線ハイブリッドの以前のコードポイントです。
`WOLFSSL_ML_KEM_USE_OLD_IDS`を定義すると、各`_OLD` IDは対応する新しいID（12107から12109）と一緒に送信されます。

### B-10 Kyber Round 3 レガシー

| グループ名 | ID | デフォルト | configureオプション |
|------------|:--:|:-------:|-----------------|
| `KYBER_LEVEL1` | 570 | 無効 | `--enable-mlkem=yes,original` |
| `KYBER_LEVEL3` | 572 | 無効 | `--enable-mlkem=yes,original` |
| `KYBER_LEVEL5` | 573 | 無効 | `--enable-mlkem=yes,original` |
| `P256_KYBER_LEVEL1` | 12090 | 無効 | `--enable-mlkem=yes,original` |
| `P384_KYBER_LEVEL3` | 12092 | 無効 | `--enable-mlkem=yes,original` |
| `P521_KYBER_LEVEL5` | 12093 | 無効 | `--enable-mlkem=yes,original` |
| `X25519_KYBER_LEVEL1` | 12089 | 無効 | 同上 + `--enable-curve25519` |
| `X25519_KYBER_LEVEL3` | 25497 | 無効 | 同上 + `--enable-curve25519` |
| `X448_KYBER_LEVEL3` | 12176 | 無効 | 同上 + `--enable-curve448` |
| `P256_KYBER_LEVEL3` | 25498 | 無効 | `--enable-mlkem=yes,original` |

`--enable-mlkem=original`のみでは、使用可能なKyberパラメータセットはビルドされません。
`--enable-mlkem=yes,original`を使用してください。
`original`を選択すると、`ml-kem`も併せて指定しない限り（`--enable-mlkem=yes,original,ml-kem`）、ML-KEMグループは無効になります。

---

## C. 署名アルゴリズム

### C-1 ECDSA（NIST曲線）

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_secp256r1_sha256` | `0x04,0x03` | **有効** | `--enable-ecc` |
| `ecdsa_secp384r1_sha384` | `0x05,0x03` | **有効** | `--enable-ecc` + `--enable-sha384` |
| `ecdsa_secp521r1_sha512` | `0x06,0x03` | **有効** | `--enable-ecc` + `--enable-sha512` |
| `ecdsa_sha1` | `0x02,0x03` | 無効 | TLS 1.0/1.1のハンドシェイク（`--enable-oldtls`）。TLS 1.2では`-DWOLFSSL_ALLOW_TLS_SHA1`指定時のみ（RFC 9155を参照） |

### C-2 ECDSA（Brainpool, TLS 1.3専用）

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_brainpoolP256r1tls13_sha256` | `0x08,0x1A` | 無効 | `--enable-ecccustcurves` |
| `ecdsa_brainpoolP384r1tls13_sha384` | `0x08,0x1B` | 無効 | 同上 + `--enable-sha384` |
| `ecdsa_brainpoolP512r1tls13_sha512` | `0x08,0x1C` | 無効 | 同上 + `--enable-sha512` |

### C-3 EdDSA

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `ed25519` | `0x08,0x07` | 無効 | `--enable-ed25519` |
| `ed448` | `0x08,0x08` | 無効 | `--enable-ed448` |

### C-4 RSA-PSS RSAE

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_rsae_sha256` | `0x08,0x04` | **有効** | `--enable-rsapss`（TLS 1.3時自動） |
| `rsa_pss_rsae_sha384` | `0x08,0x05` | **有効** | `--enable-rsapss` + `--enable-sha384` |
| `rsa_pss_rsae_sha512` | `0x08,0x06` | **有効** | `--enable-rsapss` + `--enable-sha512` |

### C-5 RSA-PSS PSS（TLS 1.3専用）

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_pss_sha256` | `0x08,0x09` | **有効** | `--enable-tls13` + `--enable-rsapss` |
| `rsa_pss_pss_sha384` | `0x08,0x0A` | **有効** | 同上 + `--enable-sha384` |
| `rsa_pss_pss_sha512` | `0x08,0x0B` | **有効** | 同上 + `--enable-sha512` |

### C-6 RSA PKCS#1 v1.5

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `rsa_pkcs1_sha256` | `0x04,0x01` | **有効** | - |
| `rsa_pkcs1_sha384` | `0x05,0x01` | **有効** | `--enable-sha384` |
| `rsa_pkcs1_sha512` | `0x06,0x01` | **有効** | `--enable-sha512` |
| `rsa_pkcs1_sha224` | `0x03,0x01` | 条件付き | `--enable-sha224`（x86_64/aarch64でデフォルト有効） |
| `rsa_pkcs1_sha1` | `0x02,0x01` | 無効 | TLS 1.0/1.1のハンドシェイク（`--enable-oldtls`）。TLS 1.2では`-DWOLFSSL_ALLOW_TLS_SHA1`指定時のみ（RFC 9155を参照） |

### C-7 SM2

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `sm2sig_sm3` | `0x07,0x08` | 無効 | `--enable-sm2` + `--enable-sm3` |

### C-8 ML-DSA / Dilithium

| IANA名 | Wire Value | デフォルト | configureオプション |
|-----------|-----------|:-------:|-----------------|
| `mldsa44` (ML-DSA-44) | `0x09,0x04` | 無効 | `--enable-mldsa` |
| `mldsa65` (ML-DSA-65) | `0x09,0x05` | 無効 | `--enable-mldsa` |
| `mldsa87` (ML-DSA-87) | `0x09,0x06` | 無効 | `--enable-mldsa` |

### C-9 SLH-DSA (FIPS 205)

Wire Valueはdraft-reddy-tls-slhdsaに基づくもので、oqs-providerが使用している値と同じです。
SLH-DSAはTLS 1.3およびDTLS 1.3のハンドシェイクの署名に使用できます（wolfSSL 5.9.4で新規追加）。

| 名前 | Wire Value | デフォルト | configureオプション |
|------|-----------|:-------:|-----------------|
| `slhdsa_sha2_128s` | `0x09,0x11` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_128f` | `0x09,0x12` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_192s` | `0x09,0x13` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_192f` | `0x09,0x14` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_256s` | `0x09,0x15` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_256f` | `0x09,0x16` | 無効 | `--enable-slhdsa=sha2` |
| `slhdsa_shake_128s` | `0x09,0x17` | 無効 | `--enable-slhdsa` |
| `slhdsa_shake_128f` | `0x09,0x18` | 無効 | `--enable-slhdsa` |
| `slhdsa_shake_192s` | `0x09,0x19` | 無効 | `--enable-slhdsa` |
| `slhdsa_shake_192f` | `0x09,0x1A` | 無効 | `--enable-slhdsa` |
| `slhdsa_shake_256s` | `0x09,0x1B` | 無効 | `--enable-slhdsa` |
| `slhdsa_shake_256f` | `0x09,0x1C` | 無効 | `--enable-slhdsa` |

### C-10 Falcon（実験的）

Falconは、以前のliboqs統合と共有していたプライベート用途のコードポイントを使用します。
アルゴリズム自体は現在、wolfCryptにネイティブに実装されています。

| 名前 | Wire Value | デフォルト | configureオプション |
|------|-----------|:-------:|-----------------|
| `falcon_level1` (Falcon-512) | `0xFE,0xD7` | 無効 | `--enable-falcon` + `--enable-experimental` |
| `falcon_level5` (Falcon-1024) | `0xFE,0xDA` | 無効 | `--enable-falcon` + `--enable-experimental` |

---

## D. configureオプションと#defineマクロの対応表

| configureオプション | #define マクロ | 備考 |
|-----------------|--------------|-------|
| `--enable-tls13` | `WOLFSSL_TLS13` | デフォルト有効 |
| `--enable-ecc` | `HAVE_ECC` | デフォルト有効 |
| `--enable-aesgcm` | `HAVE_AESGCM` | デフォルト有効 |
| `--enable-chacha` | `HAVE_CHACHA` | デフォルト有効 |
| `--enable-poly1305` | `HAVE_POLY1305` | デフォルト有効 |
| `--enable-sha384` | `WOLFSSL_SHA384` | デフォルト有効 |
| `--enable-sha512` | `WOLFSSL_SHA512` | デフォルト有効 |
| `--enable-supportedcurves` | `HAVE_SUPPORTED_CURVES` + `HAVE_TLS_EXTENSIONS` | デフォルト有効 |
| `--enable-aesccm` | `HAVE_AESCCM` | |
| `--enable-dh` | `HAVE_DH` | デフォルト有効（FIPS v7以降を除く） |
| `--enable-psk` | `NO_PSK`を削除 | |
| `--enable-rsapss` | `WC_RSA_PSS` | TLS 1.3時自動 |
| `--enable-curve25519` | `HAVE_CURVE25519` | |
| `--enable-curve448` | `HAVE_CURVE448` | |
| `--enable-ed25519` | `HAVE_ED25519` | |
| `--enable-ed448` | `HAVE_ED448` | |
| `--enable-ecccustcurves` | `WOLFSSL_CUSTOM_CURVES` | `=all`を指定すると`HAVE_ECC_KOBLITZ`、`HAVE_ECC_SECPR2`、`HAVE_ECC_SECPR3`、`HAVE_ECC_BRAINPOOL`も定義 |
| `--enable-brainpool` | `HAVE_ECC_BRAINPOOL` | ecccustcurves必須。ecccustcurves有効時はデフォルト有効 |
| `--enable-des3` | `NO_DES3`を除去 | |
| `--enable-des3-tls-suites` | `NO_DES3_TLS_SUITES`を除去 | 3DES暗号スイートに必要。`--enable-des3`必須 |
| `--enable-arc4` | `NO_RC4`を除去 | |
| `--enable-md5` | `NO_MD5`を除去 | MD5ベースの暗号スイートに必要 |
| `--enable-camellia` | `HAVE_CAMELLIA` | |
| `--enable-aria` | `HAVE_ARIA` | |
| `--enable-nullcipher` | `HAVE_NULL_CIPHER` | 非推奨（RFC 9325） |
| `--enable-anon` | `HAVE_ANON` | 非推奨（RFC 9325） |
| `--enable-sm2` | `WOLFSSL_SM2` | |
| `--enable-sm3` | `WOLFSSL_SM3` | |
| `--enable-sm4-cbc` | `WOLFSSL_SM4_CBC` | |
| `--enable-sm4-gcm` | `WOLFSSL_SM4_GCM` | |
| `--enable-sm4-ccm` | `WOLFSSL_SM4_CCM` | |
| `--enable-mlkem` | `WOLFSSL_HAVE_MLKEM` | デフォルト有効（非FIPSまたはFIPS v7以降。SHA-3とSHAKEが必要） |
| `--enable-pqc-hybrids` | `WOLFSSL_PQC_HYBRIDS` | mlkem有効時デフォルト有効 |
| `--enable-mldsa` | `WOLFSSL_HAVE_MLDSA` | `HAVE_DILITHIUM`は旧来のエイリアス |
| `--enable-slhdsa` | `WOLFSSL_HAVE_SLHDSA` | TLS 1.3 / DTLS 1.3の認証に対応、5.9.4で新規追加 |
| `--enable-falcon` | `HAVE_FALCON` | ネイティブ実装、--enable-experimentalが必要 |
| `--enable-tls13-sha512` | `WOLFSSL_TLS13_SHA512` | TLS 1.3のみのビルドでSHA-512トランスクリプトを保持 |
| `--disable-tlsv12` | `WOLFSSL_NO_TLS12` | TLS 1.2をビルドから除外（5.9.4以降） |
| `--with-eccminsz=BITS` | `ECC_MIN_KEY_SZ` | デフォルト224（FIPSでは192） |
| `--enable-mcast` | `WOLFSSL_MULTICAST` | DTLSとNULL暗号も有効化 |
| `--enable-renegotiation-indication` | `HAVE_RENEGOTIATION_INDICATION` | クライアントが`TLS_EMPTY_RENEGOTIATION_INFO_SCSV`を送信 |
| `--enable-harden-tls` | `WOLFSSL_HARDEN_TLS` | RFC 9325の要件。`=112`（`yes`と同じ）または`=128` |
| (CFLAGS) | `WOLFSSL_STATIC_RSA` | 静的RSA暗号スイート、前方秘匿性なし |
| (CFLAGS) | `WOLFSSL_STATIC_DH` | 静的ECDH暗号スイート、前方秘匿性なし |
| (CFLAGS) | `WOLFSSL_STATIC_PSK` | AESまたはNULL暗号を使用する純粋なPSK暗号スイート |
| (CFLAGS) | `NO_OLD_POLY1305` | `_OLD_POLY1305` ChaCha20-Poly1305暗号スイートを除去 |
| (CFLAGS) | `WOLFSSL_ALLOW_TLS_SHA1` | TLS 1.2でSHA-1署名アルゴリズムを提示 |
