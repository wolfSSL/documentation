# Supported Cipher Suites, Key Exchange Groups, and Signature Algorithms

## A. Cipher Suites

### A-1. TLS 1.3

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_AES_128_GCM_SHA256` | `0x13,0x01` | **Enabled** | `--enable-tls13` + `--enable-aesgcm` |
| `TLS_AES_256_GCM_SHA384` | `0x13,0x02` | **Enabled** | `--enable-tls13` + `--enable-aesgcm` + `--enable-sha384` |
| `TLS_CHACHA20_POLY1305_SHA256` | `0x13,0x03` | **Enabled** | `--enable-tls13` + `--enable-chacha` + `--enable-poly1305` |
| `TLS_AES_128_CCM_SHA256` | `0x13,0x04` | Disabled | `--enable-aesccm` |
| `TLS_AES_128_CCM_8_SHA256` | `0x13,0x05` | Disabled | `--enable-aesccm` |
| `TLS_SM4_GCM_SM3` | `0x00,0xC6` | Disabled | `--enable-sm4-gcm` + `--enable-sm3` |
| `TLS_SM4_CCM_SM3` | `0x00,0xC7` | Disabled | `--enable-sm4-ccm` + `--enable-sm3` |
| `TLS_SHA256_SHA256` | `0xC0,0xB4` | Disabled | `--enable-nullcipher` |
| `TLS_SHA384_SHA384` | `0xC0,0xB5` | Disabled | `--enable-nullcipher` + `--enable-sha384` |

### A-2. TLS 1.2 ECDHE-ECDSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2B` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2C` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA9` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x09` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0A` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x23` | **Enabled** | — |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x24` | **Enabled** | `--enable-sha384` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM` | `0xC0,0xAC` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8` | `0xC0,0xAE` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8` | `0xC0,0xAF` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x08` | Disabled | `--enable-des3` |
| `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x07` | Disabled | `--enable-arc4` |
| `TLS_ECDHE_ECDSA_WITH_NULL_SHA` | `0xC0,0x06` | Disabled | `--enable-nullcipher` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256` | `0xC0,0x5C` | Disabled | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384` | `0xC0,0x5D` | Disabled | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3` | `0xE0,0x11` | Disabled | `--enable-sm4-cbc` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_GCM_SM3` | `0xE0,0x51` | Disabled | `--enable-sm4-gcm` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CCM_SM3` | `0xE0,0x52` | Disabled | `--enable-sm4-ccm` + `--enable-sm3` + `--enable-sm2` |

### A-3. TLS 1.2 ECDHE-RSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2F` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x30` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA8` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x13` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x14` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x27` | **Enabled** | — |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x28` | **Enabled** | `--enable-sha384` |
| `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x12` | Disabled | `--enable-des3` |
| `TLS_ECDHE_RSA_WITH_RC4_128_SHA` | `0xC0,0x11` | Disabled | `--enable-arc4` |

### A-4. TLS 1.2 DHE-RSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9E` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9F` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAA` | Disabled | `--enable-dh` + `--enable-chacha` |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x33` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x39` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x67` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x6B` | Disabled | `--enable-dh` |
| `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x16` | Disabled | `--enable-dh` + `--enable-des3` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x45` | Disabled | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x88` | Disabled | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBE` | Disabled | `--enable-dh` + `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC4` | Disabled | `--enable-dh` + `--enable-camellia` |

### A-5. TLS 1.2 RSA (Static Key Exchange)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9C` | **Enabled** | — |
| `TLS_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9D` | **Enabled** | — |
| `TLS_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x2F` | **Enabled** | — |
| `TLS_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x35` | **Enabled** | — |
| `TLS_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x3C` | **Enabled** | — |
| `TLS_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x3D` | **Enabled** | — |
| `TLS_RSA_WITH_AES_128_CCM_8` | `0xC0,0xA0` | Disabled | `--enable-aesccm` |
| `TLS_RSA_WITH_AES_256_CCM_8` | `0xC0,0xA1` | Disabled | `--enable-aesccm` |
| `SSL_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x0A` | Disabled | `--enable-des3` |
| `SSL_RSA_WITH_RC4_128_SHA` | `0x00,0x05` | Disabled | `--enable-arc4` |
| `SSL_RSA_WITH_RC4_128_MD5` | `0x00,0x04` | Disabled | `--enable-arc4` |
| `TLS_RSA_WITH_NULL_MD5` | `0x00,0x01` | Disabled | `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA` | `0x00,0x02` | Disabled | `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA256` | `0x00,0x3B` | Disabled | `--enable-nullcipher` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x41` | Disabled | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x84` | Disabled | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBA` | Disabled | `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC0` | Disabled | `--enable-camellia` |

### A-6. TLS 1.2 Static ECDH

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x31` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x32` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x0E` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0F` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x29` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x2A` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_RSA_WITH_RC4_128_SHA` | `0xC0,0x0C` | Disabled | `--enable-staticecdh` + `--enable-arc4` |
| `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x0D` | Disabled | `--enable-staticecdh` + `--enable-des3` |
| `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2D` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2E` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x04` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x05` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x25` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x26` | Disabled | `--enable-staticecdh` |
| `TLS_ECDH_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x02` | Disabled | `--enable-staticecdh` + `--enable-arc4` |
| `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x03` | Disabled | `--enable-staticecdh` + `--enable-des3` |

### A-7. TLS 1.2 PSK

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xA8` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xA9` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xAE` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xAF` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CBC_SHA` | `0x00,0x8C` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_256_CBC_SHA` | `0x00,0x8D` | Disabled | `--enable-psk` |
| `TLS_PSK_WITH_AES_128_CCM` | `0xC0,0xA4` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM` | `0xC0,0xA5` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_128_CCM_8` | `0xC0,0xA8` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM_8` | `0xC0,0xA9` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAB` | Disabled | `--enable-psk` + `--enable-chacha` |
| `TLS_PSK_WITH_NULL_SHA256` | `0x00,0xB0` | Disabled | `--enable-psk` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA384` | `0x00,0xB1` | Disabled | `--enable-psk` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA` | `0x00,0x2C` | Disabled | `--enable-psk` + `--enable-nullcipher` |

### A-8. TLS 1.2 DHE-PSK

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xAA` | Disabled | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xAB` | Disabled | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xB2` | Disabled | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xB3` | Disabled | `--enable-psk` + `--enable-dh` |
| `TLS_DHE_PSK_WITH_AES_128_CCM` | `0xC0,0xA6` | Disabled | `--enable-psk` + `--enable-dh` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_AES_256_CCM` | `0xC0,0xA7` | Disabled | `--enable-psk` + `--enable-dh` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAD` | Disabled | `--enable-psk` + `--enable-dh` + `--enable-chacha` |
| `TLS_DHE_PSK_WITH_NULL_SHA256` | `0x00,0xB4` | Disabled | `--enable-psk` + `--enable-dh` + `--enable-nullcipher` |
| `TLS_DHE_PSK_WITH_NULL_SHA384` | `0x00,0xB5` | Disabled | `--enable-psk` + `--enable-dh` + `--enable-nullcipher` |

### A-9. TLS 1.2 ECDHE-PSK

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256` | `0xC0,0x37` | Disabled | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256` | `0xD0,0x01` | Disabled | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAC` | Disabled | `--enable-psk` + `--enable-chacha` |
| `TLS_ECDHE_PSK_WITH_NULL_SHA256` | `0xC0,0x3A` | Disabled | `--enable-psk` + `--enable-nullcipher` |

### A-10. TLS 1.2 DH_anon

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DH_anon_WITH_AES_128_CBC_SHA` | `0x00,0x34` | Disabled | `--enable-anon` |
| `TLS_DH_anon_WITH_AES_256_GCM_SHA384` | `0x00,0xA7` | Disabled | `--enable-anon` |

---

## B. Key Exchange Groups

### B-1. NIST Elliptic Curves

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `secp256r1` (P-256) | 23 | **Enabled** | `--enable-ecc` |
| `secp384r1` (P-384) | 24 | **Enabled** | `--enable-ecc` |
| `secp521r1` (P-521) | 25 | **Enabled** | `--enable-ecc` |
| `secp192r1` (P-192) | 19 | Disabled | `--enable-ecc` (TLS 1.2 only) |
| `secp224r1` (P-224) | 21 | Disabled | `--enable-ecc` (TLS 1.2 only) |

### B-2. Koblitz Curves

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `secp160k1` | 15 | Disabled | `--enable-ecccustcurves` |
| `secp192k1` | 18 | Disabled | `--enable-ecccustcurves` |
| `secp224k1` | 20 | Disabled | `--enable-ecccustcurves` |
| `secp256k1` | 22 | Disabled | `--enable-ecccustcurves` |

### B-3. Brainpool Curves

| Group Name | ID | TLS Ver. | Default | configure Option |
|------------|:--:|:--------:|:-------:|-----------------|
| `brainpoolP256r1` | 26 | 1.2 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP384r1` | 27 | 1.2 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP512r1` | 28 | 1.2 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP256r1tls13` | 31 | 1.3 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP384r1tls13` | 32 | 1.3 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `brainpoolP512r1tls13` | 33 | 1.3 | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |

### B-4. X25519 / X448

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `x25519` | 29 | Disabled | `--enable-curve25519` |
| `x448` | 30 | Disabled | `--enable-curve448` |

### B-5. FFDHE

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `ffdhe2048` | 256 | Conditionally Enabled | `--enable-dh` (Automatically enabled when TLS 1.3 + DH is enabled) |
| `ffdhe3072` | 257 | Disabled | `-DHAVE_FFDHE_3072` |
| `ffdhe4096` | 258 | Disabled | `-DHAVE_FFDHE_4096` |
| `ffdhe6144` | 259 | Disabled | `-DHAVE_FFDHE_6144` |
| `ffdhe8192` | 260 | Disabled | `-DHAVE_FFDHE_8192` |

### B-6. SM2

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `sm2p256v1` | 41 | Disabled | `--enable-sm2` |

### B-7. ML-KEM Standalone

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `ML-KEM-512` | 512 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-768` | 513 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-1024` | 514 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |

### B-8. ML-KEM Hybrid (Standard)

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM768` | 4587 | Conditionally Enabled | `--enable-mlkem` + `--enable-pqc-hybrids` |
| `X25519MLKEM768` | 4588 | Disabled | `--enable-mlkem` + `--enable-pqc-hybrids` + `--enable-curve25519` |
| `SecP384r1MLKEM1024` | 4589 | Conditionally Enabled | `--enable-mlkem` + `--enable-pqc-hybrids` |

### B-9. ML-KEM Hybrid (Experimental)

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM512` | 12107 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP384r1MLKEM768` | 12108 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP521r1MLKEM1024` | 12109 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `X25519MLKEM512` | 12214 | Disabled | Same as above + `--enable-curve25519` |
| `X448MLKEM768` | 12215 | Disabled | Same as above + `--enable-curve448` |

### B-10. Kyber Round 3 Legacy

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `KYBER_LEVEL1` | 570 | Disabled | `--enable-mlkem=original` |
| `KYBER_LEVEL3` | 572 | Disabled | `--enable-mlkem=original` |
| `KYBER_LEVEL5` | 573 | Disabled | `--enable-mlkem=original` |
| `P256_KYBER_LEVEL1` | 12090 | Disabled | `--enable-mlkem=original` |
| `P384_KYBER_LEVEL3` | 12092 | Disabled | `--enable-mlkem=original` |
| `P521_KYBER_LEVEL5` | 12093 | Disabled | `--enable-mlkem=original` |
| `X25519_KYBER_LEVEL1` | 12089 | Disabled | Same as above + `--enable-curve25519` |
| `X25519_KYBER_LEVEL3` | 25497 | Disabled | Same as above + `--enable-curve25519` |
| `X448_KYBER_LEVEL3` | 12176 | Disabled | Same as above + `--enable-curve448` |
| `P256_KYBER_LEVEL3` | 25498 | Disabled | `--enable-mlkem=original` |

---

## C. Signature Algorithms

### C-1. ECDSA (NIST Curves)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_secp256r1_sha256` | `0x04,0x03` | **Enabled** | `--enable-ecc` |
| `ecdsa_secp384r1_sha384` | `0x05,0x03` | **Enabled** | `--enable-ecc` + `--enable-sha384` |
| `ecdsa_secp521r1_sha512` | `0x06,0x03` | **Enabled** | `--enable-ecc` + `--enable-sha512` |
| `ecdsa_sha1` | `0x02,0x03` | Conditional | `!NO_OLD_TLS` or `WOLFSSL_ALLOW_TLS_SHA1` |

### C-2. ECDSA (Brainpool, TLS 1.3 Only)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_brainpoolP256r1tls13_sha256` | `0x08,0x1A` | Disabled | `--enable-ecccustcurves` + `--enable-brainpool` |
| `ecdsa_brainpoolP384r1tls13_sha384` | `0x08,0x1B` | Disabled | Same as above + `--enable-sha384` |
| `ecdsa_brainpoolP512r1tls13_sha512` | `0x08,0x1C` | Disabled | Same as above + `--enable-sha512` |

### C-3. EdDSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ed25519` | `0x08,0x07` | Disabled | `--enable-ed25519` |
| `ed448` | `0x08,0x08` | Disabled | `--enable-ed448` |

### C-4. RSA-PSS RSAE

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_rsae_sha256` | `0x08,0x04` | **Enabled** | `--enable-rsapss` (automatic with TLS 1.3) |
| `rsa_pss_rsae_sha384` | `0x08,0x05` | **Enabled** | `--enable-rsapss` + `--enable-sha384` |
| `rsa_pss_rsae_sha512` | `0x08,0x06` | **Enabled** | `--enable-rsapss` + `--enable-sha512` |

### C-5. RSA-PSS PSS (TLS 1.3 Only)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_pss_sha256` | `0x08,0x09` | **Enabled** | `--enable-tls13` + `--enable-rsapss` |
| `rsa_pss_pss_sha384` | `0x08,0x0A` | **Enabled** | Same as above + `--enable-sha384` |
| `rsa_pss_pss_sha512` | `0x08,0x0B` | **Enabled** | Same as above + `--enable-sha512` |

### C-6. RSA PKCS#1 v1.5

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pkcs1_sha256` | `0x04,0x01` | **Enabled** | — |
| `rsa_pkcs1_sha384` | `0x05,0x01` | **Enabled** | `--enable-sha384` |
| `rsa_pkcs1_sha512` | `0x06,0x01` | **Enabled** | `--enable-sha512` |
| `rsa_pkcs1_sha224` | `0x03,0x01` | Conditional | `--enable-sha224` (Enabled by default on x86_64/aarch64) |
| `rsa_pkcs1_sha1` | `0x02,0x01` | Conditional | `!NO_OLD_TLS` or `WOLFSSL_ALLOW_TLS_SHA1` |

### C-7. SM2

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `sm2sig_sm3` | `0x07,0x08` | Disabled | `--enable-sm2` + `--enable-sm3` |

### C-8. ML-DSA / Dilithium

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `mldsa44` (ML-DSA-44) | `0x09,0x04` | Disabled | `--enable-mldsa` |
| `mldsa65` (ML-DSA-65) | `0x09,0x05` | Disabled | `--enable-mldsa` |
| `mldsa87` (ML-DSA-87) | `0x09,0x06` | Disabled | `--enable-mldsa` |

---

## D. configure Option ↔ #define Reference

| configure Option | #define Macro | Notes |
|-----------------|--------------|-------|
| `--enable-tls13` | `WOLFSSL_TLS13` | Enabled by default |
| `--enable-ecc` | `HAVE_ECC` | Enabled by default |
| `--enable-aesgcm` | `HAVE_AESGCM` | Enabled by default |
| `--enable-chacha` | `HAVE_CHACHA` | Enabled by default |
| `--enable-poly1305` | `HAVE_POLY1305` | Enabled by default |
| `--enable-sha384` | `WOLFSSL_SHA384` | Enabled by default |
| `--enable-sha512` | `WOLFSSL_SHA512` | Enabled by default |
| `--enable-supportedcurves` | `HAVE_SUPPORTED_CURVES` + `HAVE_TLS_EXTENSIONS` | Enabled by default |
| `--enable-aesccm` | `HAVE_AESCCM` | |
| `--enable-dh` | `HAVE_DH` | |
| `--enable-psk` | `HAVE_PSK` | |
| `--enable-rsapss` | `WC_RSA_PSS` | Automatic when TLS 1.3 is enabled |
| `--enable-curve25519` | `HAVE_CURVE25519` | |
| `--enable-curve448` | `HAVE_CURVE448` | |
| `--enable-ed25519` | `HAVE_ED25519` | |
| `--enable-ed448` | `HAVE_ED448` | |
| `--enable-ecccustcurves` | `WOLFSSL_CUSTOM_CURVES` | |
| `--enable-brainpool` | `HAVE_ECC_BRAINPOOL` | Requires ecccustcurves |
| `--enable-des3` | Removes `NO_DES3` | |
| `--enable-arc4` | Removes `NO_RC4` | |
| `--enable-camellia` | `HAVE_CAMELLIA` | |
| `--enable-aria` | `HAVE_ARIA` | |
| `--enable-nullcipher` | `HAVE_NULL_CIPHER` | Deprecated |
| `--enable-anon` | `HAVE_ANON` | Deprecated |
| `--enable-sm2` | `WOLFSSL_SM2` | |
| `--enable-sm3` | `WOLFSSL_SM3` | |
| `--enable-sm4-gcm` | `WOLFSSL_SM4_GCM` | |
| `--enable-mlkem` | `WOLFSSL_HAVE_MLKEM` + `HAVE_PQC` | |
| `--enable-pqc-hybrids` | `WOLFSSL_PQC_HYBRIDS` | Enabled by default when mlkem is enabled |
| `--enable-mldsa` | `HAVE_DILITHIUM` | |
| `--enable-staticecdh` | `WOLFSSL_STATIC_ECDH` | No PFS, deprecated |
