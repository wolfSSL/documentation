# wolfSSL 対応暗号スイート・鍵交換グループ・署名アルゴリズム一覧

## A. 暗号スイート

### A-1. TLS 1.3

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_AES_128_GCM_SHA256` | `0x13,0x01` | **有効** | `--enable-tls13` + `--enable-aesgcm` |
| `TLS_AES_256_GCM_SHA384` | `0x13,0x02` | **有効** | `--enable-tls13` + `--enable-aesgcm` + `--enable-sha384` |
| `TLS_CHACHA20_POLY1305_SHA256` | `0x13,0x03` | **有効** | `--enable-tls13` + `--enable-chacha` + `--enable-poly1305` |
| `TLS_AES_128_CCM_SHA256` | `0x13,0x04` | 無効 | `--enable-aesccm` |
| `TLS_AES_128_CCM_8_SHA256` | `0x13,0x05` | 無効 | `--enable-aesccm` |
| `TLS_SM4_GCM_SM3` | `0x00,0xC6` | 無効 | `--enable-sm4-gcm` + `--enable-sm3` |
| `TLS_SM4_CCM_SM3` | `0x00,0xC7` | 無効 | `--enable-sm4-ccm` + `--enable-sm3` |
| `TLS_SHA256_SHA256` | `0xC0,0xB4` | 無効 | `--enable-nullcipher` |
| `TLS_SHA384_SHA384` | `0xC0,0xB5` | 無効 | `--enable-nullcipher` + `--enable-sha384` |

### A-2. TLS 1.2 ECDHE-ECDSA

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2B` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2C` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA9` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x09` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0A` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x23` | **有効** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x24` | **有効** | `--enable-sha384` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM` | `0xC0,0xAC` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8` | `0xC0,0xAE` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8` | `0xC0,0xAF` | 無効 | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x08` | 無効 | `--enable-des3` |
| `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x07` | 無効 | `--enable-arc4` |
| `TLS_ECDHE_ECDSA_WITH_NULL_SHA` | `0xC0,0x06` | 無効 | `--enable-nullcipher` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256` | `0xC0,0x5C` | 無効 | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384` | `0xC0,0x5D` | 無効 | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3` | `0xE0,0x11` | 無効 | `--enable-sm4-cbc` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_GCM_SM3` | `0xE0,0x51` | 無効 | `--enable-sm4-gcm` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CCM_SM3` | `0xE0,0x52` | 無効 | `--enable-sm4-ccm` + `--enable-sm3` + `--enable-sm2` |

### A-3. TLS 1.2 ECDHE-RSA

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2F` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x30` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA8` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x13` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x14` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x27` | **有効** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x28` | **有効** | `--enable-sha384` |
| `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x12` | 無効 | `--enable-des3` |
| `TLS_ECDHE_RSA_WITH_RC4_128_SHA` | `0xC0,0x11` | 無効 | `--enable-arc4` |

### A-4. TLS 1.2 DHE-RSA

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9E` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9F` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAA` | 無効 | `--enable-dh` + `--enable-chacha` |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x33` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x39` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x67` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x6B` | 無効 | `--enable-dh` |
| `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x16` | 無効 | `--enable-dh` + `--enable-des3` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x45` | 無効 | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x88` | 無効 | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBE` | 無効 | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC4` | 無効 | `--enable-dh` + `--enable-camellia` |

### A-5. TLS 1.2 RSA（静的鍵交換）

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9C` | **有効** | — |
| `TLS_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9D` | **有効** | — |
| `TLS_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x2F` | **有効** | — |
| `TLS_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x35` | **有効** | — |
| `TLS_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x3C` | **有効** | — |
| `TLS_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x3D` | **有効** | — |
| `TLS_RSA_WITH_AES_128_CCM_8` | `0xC0,0xA0` | 無効 | `--enable-aesccm` |
| `TLS_RSA_WITH_AES_256_CCM_8` | `0xC0,0xA1` | 無効 | `--enable-aesccm` |
| `SSL_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x0A` | 無効 | `--enable-des3` |
| `SSL_RSA_WITH_RC4_128_SHA` | `0x00,0x05` | 無効 | `--enable-arc4` |
| `SSL_RSA_WITH_RC4_128_MD5` | `0x00,0x04` | 無効 | `--enable-arc4` |
| `TLS_RSA_WITH_NULL_MD5` | `0x00,0x01` | 無効 | `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA` | `0x00,0x02` | 無効 | `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA256` | `0x00,0x3B` | 無効 | `--enable-nullcipher` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x41` | 無効 | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x84` | 無効 | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBA` | 無効 | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC0` | 無効 | `--enable-camellia` |

### A-6. TLS 1.2 静的ECDH

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x31` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x32` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x0E` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0F` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x29` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x2A` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_RC4_128_SHA` | `0xC0,0x0C` | 無効 | `--enable-staticecdh` + `--enable-arc4` |
| `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x0D` | 無効 | `--enable-staticecdh` + `--enable-des3` |
| `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2D` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2E` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x04` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x05` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x25` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x26` | 無効 | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x02` | 無効 | `--enable-staticecdh` + `--enable-arc4` |
| `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x03` | 無効 | `--enable-staticecdh` + `--enable-des3` |

### A-7. TLS 1.2 PSK

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xA8` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xA9` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xAE` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xAF` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CBC_SHA` | `0x00,0x8C` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_CBC_SHA` | `0x00,0x8D` | 無効 | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CCM` | `0xC0,0xA4` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM` | `0xC0,0xA5` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_128_CCM_8` | `0xC0,0xA8` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM_8` | `0xC0,0xA9` | 無効 | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAB` | 無効 | `--enable-psk` + `--enable-chacha` |
| `TLS_PSK_WITH_NULL_SHA256` | `0x00,0xB0` | 無効 | `--enable-psk` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA384` | `0x00,0xB1` | 無効 | `--enable-psk` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA` | `0x00,0x2C` | 無効 | `--enable-psk` + `--enable-nullcipher` |

### A-8. TLS 1.2 DHE-PSK

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xAA` | 無効 | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xAB` | 無効 | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xB2` | 無効 | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xB3` | 無効 | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_128_CCM` | `0xC0,0xA6` | 無効 | `--enable-psk` + `--enable-dh` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_AES_256_CCM` | `0xC0,0xA7` | 無効 | `--enable-psk` + `--enable-dh` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAD` | 無効 | `--enable-psk` + `--enable-dh` + `--enable-chacha` |
| `TLS_DHE_PSK_WITH_NULL_SHA256` | `0x00,0xB4` | 無効 | `--enable-psk` + `--enable-dh` + `--enable-nullcipher` |
| `TLS_DHE_PSK_WITH_NULL_SHA384` | `0x00,0xB5` | 無効 | `--enable-psk` + `--enable-dh` + `--enable-nullcipher` |

### A-9. TLS 1.2 ECDHE-PSK

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256` | `0xC0,0x37` | 無効 | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256` | `0xD0,0x01` | 無効 | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAC` | 無効 | `--enable-psk` + `--enable-chacha` |
| `TLS_ECDHE_PSK_WITH_NULL_SHA256` | `0xC0,0x3A` | 無効 | `--enable-psk` + `--enable-nullcipher` |

### A-10. TLS 1.2 DH_anon

| IANA名 | Wire ID | デフォルト | configureオプション |
|--------|---------|:----------:|---------------------|
| `TLS_DH_anon_WITH_AES_128_CBC_SHA` | `0x00,0x34` | 無効 | `--enable-anon` |
| `TLS_DH_anon_WITH_AES_256_GCM_SHA384` | `0x00,0xA7` | 無効 | `--enable-anon` |

---

## B. 鍵交換グループ

### B-1. NIST楕円曲線

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `secp256r1` (P-256) | 23 | **有効** | `--enable-ecc` |
| `secp384r1` (P-384) | 24 | **有効** | `--enable-ecc` |
| `secp521r1` (P-521) | 25 | **有効** | `--enable-ecc` |
| `secp192r1` (P-192) | 19 | 無効 | `--enable-ecc`（TLS 1.2のみ） |
| `secp224r1` (P-224) | 21 | 無効 | `--enable-ecc`（TLS 1.2のみ） |

### B-2. Koblitz曲線

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `secp160k1` | 15 | 無効 | `--enable-ecccustcurves` |
| `secp192k1` | 18 | 無効 | `--enable-ecccustcurves` |
| `secp224k1` | 20 | 無効 | `--enable-ecccustcurves` |
| `secp256k1` | 22 | 無効 | `--enable-ecccustcurves` |

### B-3. Brainpool曲線

| グループ名 | ID | TLS版 | デフォルト | configureオプション |
|------------|:---:|:-----:|:----------:|---------------------|
| `brainpoolP256r1` | 26 | 1.2 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP384r1` | 27 | 1.2 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP512r1` | 28 | 1.2 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP256r1tls13` | 31 | 1.3 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP384r1tls13` | 32 | 1.3 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP512r1tls13` | 33 | 1.3 | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |

### B-4. X25519 / X448

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `x25519` | 29 | 無効 | `--enable-curve25519` |
| `x448` | 30 | 無効 | `--enable-curve448` |

### B-5. FFDHE

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `ffdhe2048` | 256 | 条件付き有効 | `--enable-dh`（TLS 1.3+DH有効時に自動設定） |
| `ffdhe3072` | 257 | 無効 | `-DHAVE_FFDHE_3072` |
| `ffdhe4096` | 258 | 無効 | `-DHAVE_FFDHE_4096` |
| `ffdhe6144` | 259 | 無効 | `-DHAVE_FFDHE_6144` |
| `ffdhe8192` | 260 | 無効 | `-DHAVE_FFDHE_8192` |

### B-6. SM2

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `sm2p256v1` | 41 | 無効 | `--enable-sm2` |

### B-7. ML-KEMスタンドアロン

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `ML-KEM-512` | 512 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-768` | 513 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-1024` | 514 | 無効 | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |

### B-8. ML-KEMハイブリッド（標準）

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `SecP256r1MLKEM768` | 4587 | 条件付き有効 | `--enable-mlkem` + `--enable-pqc-hybrids` |
| `X25519MLKEM768` | 4588 | 無効 | `--enable-mlkem` + `--enable-pqc-hybrids` + `--enable-curve25519` |
| `SecP384r1MLKEM1024` | 4589 | 条件付き有効 | `--enable-mlkem` + `--enable-pqc-hybrids` |

### B-9. ML-KEMハイブリッド（実験的）

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `SecP256r1MLKEM512` | 12107 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP384r1MLKEM768` | 12108 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP521r1MLKEM1024` | 12109 | 無効 | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `X25519MLKEM512` | 12214 | 無効 | 同上 + `--enable-curve25519` |
| `X448MLKEM768` | 12215 | 無効 | 同上 + `--enable-curve448` |

### B-10. Kyber Round 3 レガシー

| グループ名 | ID | デフォルト | configureオプション |
|------------|:---:|:----------:|---------------------|
| `KYBER_LEVEL1` | 570 | 無効 | `--enable-mlkem=original` |
| `KYBER_LEVEL3` | 572 | 無効 | `--enable-mlkem=original` |
| `KYBER_LEVEL5` | 573 | 無効 | `--enable-mlkem=original` |
| `P256_KYBER_LEVEL1` | 12090 | 無効 | `--enable-mlkem=original` |
| `P384_KYBER_LEVEL3` | 12092 | 無効 | `--enable-mlkem=original` |
| `P521_KYBER_LEVEL5` | 12093 | 無効 | `--enable-mlkem=original` |
| `X25519_KYBER_LEVEL1` | 12089 | 無効 | 同上 + `--enable-curve25519` |
| `X25519_KYBER_LEVEL3` | 25497 | 無効 | 同上 + `--enable-curve25519` |
| `X448_KYBER_LEVEL3` | 12176 | 無効 | 同上 + `--enable-curve448` |
| `P256_KYBER_LEVEL3` | 25498 | 無効 | `--enable-mlkem=original` |

---

## C. 署名アルゴリズム

### C-1. ECDSA（NIST曲線）

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `ecdsa_secp256r1_sha256` | `0x04,0x03` | **有効** | `--enable-ecc` |
| `ecdsa_secp384r1_sha384` | `0x05,0x03` | **有効** | `--enable-ecc` + `--enable-sha384` |
| `ecdsa_secp521r1_sha512` | `0x06,0x03` | **有効** | `--enable-ecc` + `--enable-sha512` |
| `ecdsa_sha1` | `0x02,0x03` | 条件付き | `!NO_OLD_TLS` または `WOLFSSL_ALLOW_TLS_SHA1` |

### C-2. ECDSA（Brainpool, TLS 1.3専用）

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `ecdsa_brainpoolP256r1tls13_sha256` | `0x08,0x1A` | 無効 | `--enable-ecccustcurves` + `--enable-brainpool` |
| `ecdsa_brainpoolP384r1tls13_sha384` | `0x08,0x1B` | 無効 | 同上 + `--enable-sha384` |
| `ecdsa_brainpoolP512r1tls13_sha512` | `0x08,0x1C` | 無効 | 同上 + `--enable-sha512` |

### C-3. EdDSA

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `ed25519` | `0x08,0x07` | 無効 | `--enable-ed25519` |
| `ed448` | `0x08,0x08` | 無効 | `--enable-ed448` |

### C-4. RSA-PSS RSAE

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `rsa_pss_rsae_sha256` | `0x08,0x04` | **有効** | `--enable-rsapss`（TLS 1.3時自動） |
| `rsa_pss_rsae_sha384` | `0x08,0x05` | **有効** | `--enable-rsapss` + `--enable-sha384` |
| `rsa_pss_rsae_sha512` | `0x08,0x06` | **有効** | `--enable-rsapss` + `--enable-sha512` |

### C-5. RSA-PSS PSS（TLS 1.3専用）

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `rsa_pss_pss_sha256` | `0x08,0x09` | **有効** | `--enable-tls13` + `--enable-rsapss` |
| `rsa_pss_pss_sha384` | `0x08,0x0A` | **有効** | 同上 + `--enable-sha384` |
| `rsa_pss_pss_sha512` | `0x08,0x0B` | **有効** | 同上 + `--enable-sha512` |

### C-6. RSA PKCS#1 v1.5

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `rsa_pkcs1_sha256` | `0x04,0x01` | **有効** | — |
| `rsa_pkcs1_sha384` | `0x05,0x01` | **有効** | `--enable-sha384` |
| `rsa_pkcs1_sha512` | `0x06,0x01` | **有効** | `--enable-sha512` |
| `rsa_pkcs1_sha224` | `0x03,0x01` | 条件付き | `--enable-sha224`（x86_64/aarch64でデフォルト有効） |
| `rsa_pkcs1_sha1` | `0x02,0x01` | 条件付き | `!NO_OLD_TLS` または `WOLFSSL_ALLOW_TLS_SHA1` |

### C-7. SM2

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `sm2sig_sm3` | `0x07,0x08` | 無効 | `--enable-sm2` + `--enable-sm3` |

### C-8. ML-DSA / Dilithium

| IANA名 | Wire Value | デフォルト | configureオプション |
|--------|-----------|:----------:|---------------------|
| `mldsa44` (ML-DSA-44) | `0x09,0x04` | 無効 | `--enable-mldsa` |
| `mldsa65` (ML-DSA-65) | `0x09,0x05` | 無効 | `--enable-mldsa` |
| `mldsa87` (ML-DSA-87) | `0x09,0x06` | 無効 | `--enable-mldsa` |

---

## D. configureオプション ↔ #define 対応表

| configureオプション | #define マクロ | 備考 |
|---------------------|---------------|------|
| `--enable-tls13` | `WOLFSSL_TLS13` | デフォルト有効 |
| `--enable-ecc` | `HAVE_ECC` | デフォルト有効 |
| `--enable-aesgcm` | `HAVE_AESGCM` | デフォルト有効 |
| `--enable-chacha` | `HAVE_CHACHA` | デフォルト有効 |
| `--enable-poly1305` | `HAVE_POLY1305` | デフォルト有効 |
| `--enable-sha384` | `WOLFSSL_SHA384` | デフォルト有効 |
| `--enable-sha512` | `WOLFSSL_SHA512` | デフォルト有効 |
| `--enable-supportedcurves` | `HAVE_SUPPORTED_CURVES` + `HAVE_TLS_EXTENSIONS` | デフォルト有効 |
| `--enable-aesccm` | `HAVE_AESCCM` | |
| `--enable-dh` | `HAVE_DH` | |
| `--enable-psk` | `HAVE_PSK` | |
| `--enable-rsapss` | `WC_RSA_PSS` | TLS 1.3時自動 |
| `--enable-curve25519` | `HAVE_CURVE25519` | |
| `--enable-curve448` | `HAVE_CURVE448` | |
| `--enable-ed25519` | `HAVE_ED25519` | |
| `--enable-ed448` | `HAVE_ED448` | |
| `--enable-ecccustcurves` | `WOLFSSL_CUSTOM_CURVES` | |
| `--enable-brainpool` | `HAVE_ECC_BRAINPOOL` | ecccustcurves必須 |
| `--enable-des3` | `NO_DES3`を除去 | |
| `--enable-arc4` | `NO_RC4`を除去 | |
| `--enable-camellia` | `HAVE_CAMELLIA` | |
| `--enable-aria` | `HAVE_ARIA` | |
| `--enable-nullcipher` | `HAVE_NULL_CIPHER` | 非推奨 |
| `--enable-anon` | `HAVE_ANON` | 非推奨 |
| `--enable-sm2` | `WOLFSSL_SM2` | |
| `--enable-sm3` | `WOLFSSL_SM3` | |
| `--enable-sm4-gcm` | `WOLFSSL_SM4_GCM` | |
| `--enable-mlkem` | `WOLFSSL_HAVE_MLKEM` + `HAVE_PQC` | |
| `--enable-pqc-hybrids` | `WOLFSSL_PQC_HYBRIDS` | mlkem有効時デフォルト有効 |
| `--enable-mldsa` | `HAVE_DILITHIUM` | |
| `--enable-staticecdh` | `WOLFSSL_STATIC_ECDH` | PFS無し, 非推奨 |
