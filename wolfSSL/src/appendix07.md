# Supported Cipher Suites, Key Exchange Groups, and Signature Algorithms

## A. Cipher Suites

### A-1 TLS 1.3

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

### A-2 TLS 1.2 ECDHE-ECDSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2B` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2C` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA9` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x14` | **Enabled** | - (see note in A-4) |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x09` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0A` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x23` | **Enabled** | - |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x24` | **Enabled** | `--enable-sha384` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM` | `0xC0,0xAC` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8` | `0xC0,0xAE` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8` | `0xC0,0xAF` | Disabled | `--enable-aesccm` |
| `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x08` | Disabled | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x07` | Disabled | `--enable-arc4` |
| `TLS_ECDHE_ECDSA_WITH_NULL_SHA` | `0xC0,0x06` | Disabled | `--enable-nullcipher` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256` | `0xC0,0x5C` | Disabled | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384` | `0xC0,0x5D` | Disabled | `--enable-aria` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CBC_SM3` | `0xE0,0x11` | Disabled | `--enable-sm4-cbc` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_GCM_SM3` | `0xE0,0x51` | Disabled | `--enable-sm4-gcm` + `--enable-sm3` + `--enable-sm2` |
| `TLS_ECDHE_ECDSA_WITH_SM4_CCM_SM3` | `0xE0,0x52` | Disabled | `--enable-sm4-ccm` + `--enable-sm3` + `--enable-sm2` |

### A-3 TLS 1.2 ECDHE-RSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2F` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x30` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xA8` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x13` | **Enabled** | - (see note in A-4) |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x13` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x14` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x27` | **Enabled** | - |
| `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x28` | **Enabled** | `--enable-sha384` |
| `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x12` | Disabled | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDHE_RSA_WITH_RC4_128_SHA` | `0xC0,0x11` | Disabled | `--enable-arc4` |

### A-4 TLS 1.2 DHE-RSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9E` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9F` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAA` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256` | `0xCC,0x15` | **Enabled** | - (see note below) |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x33` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x39` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x67` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x6B` | **Enabled** | - |
| `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x16` | Disabled | `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x45` | Disabled | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x88` | Disabled | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBE` | Disabled | `--enable-camellia` |
| `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC4` | Disabled | `--enable-camellia` |

DH is enabled by default (`--enable-dh`, except in FIPS v7 and later builds), so the DHE suites are compiled in by default. A server only negotiates them when it has DH parameters, either loaded with `wolfSSL_CTX_SetTmpDH()` (or a related function) or selected from the FFDHE groups offered by the client.

The `_OLD_POLY1305` suites in A-2, A-3 and A-4 use an earlier draft version of the ChaCha20-Poly1305 suites (different nonce and padding) with the code points `0xCC,0x13` to `0xCC,0x15`; they are not the IANA registered RFC 7905 suites. They are compiled in and offered by default. Define `NO_OLD_POLY1305` to remove them.

### A-5 TLS 1.2 RSA (Static Key Exchange)

Static RSA key exchange does not provide forward secrecy and is not recommended. These suites are not compiled in by default, even with `--enable-all`. They need `WOLFSSL_STATIC_RSA`, which has no configure option (use `CPPFLAGS=-DWOLFSSL_STATIC_RSA` or `user_settings.h`); `WOLFSSL_SNIFFER` defines it automatically.

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_RSA_WITH_AES_128_GCM_SHA256` | `0x00,0x9C` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_GCM_SHA384` | `0x00,0x9D` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CBC_SHA` | `0x00,0x2F` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_CBC_SHA` | `0x00,0x35` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CBC_SHA256` | `0x00,0x3C` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_256_CBC_SHA256` | `0x00,0x3D` | Disabled | `-DWOLFSSL_STATIC_RSA` |
| `TLS_RSA_WITH_AES_128_CCM_8` | `0xC0,0xA0` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-aesccm` |
| `TLS_RSA_WITH_AES_256_CCM_8` | `0xC0,0xA1` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-aesccm` |
| `SSL_RSA_WITH_3DES_EDE_CBC_SHA` | `0x00,0x0A` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-des3` + `--enable-des3-tls-suites` |
| `SSL_RSA_WITH_RC4_128_SHA` | `0x00,0x05` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-arc4` |
| `SSL_RSA_WITH_RC4_128_MD5` | `0x00,0x04` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-arc4` + `--enable-md5` |
| `TLS_RSA_WITH_NULL_MD5` | `0x00,0x01` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` + `--enable-md5` |
| `TLS_RSA_WITH_NULL_SHA` | `0x00,0x02` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` |
| `TLS_RSA_WITH_NULL_SHA256` | `0x00,0x3B` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-nullcipher` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA` | `0x00,0x41` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA` | `0x00,0x84` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256` | `0x00,0xBA` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |
| `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256` | `0x00,0xC0` | Disabled | `-DWOLFSSL_STATIC_RSA` + `--enable-camellia` |

### A-6 TLS 1.2 Static ECDH

Static ECDH key exchange does not provide forward secrecy and is not recommended. These suites need `WOLFSSL_STATIC_DH` (and ECC), which has no configure option (use `CPPFLAGS=-DWOLFSSL_STATIC_DH` or `user_settings.h`); `WOLFSSL_SNIFFER` defines it automatically.

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x31` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x32` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA` | `0xC0,0x0E` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA` | `0xC0,0x0F` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x29` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x2A` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_RSA_WITH_RC4_128_SHA` | `0xC0,0x0C` | Disabled | `-DWOLFSSL_STATIC_DH` + `--enable-arc4` |
| `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x0D` | Disabled | `-DWOLFSSL_STATIC_DH` + `--enable-des3` + `--enable-des3-tls-suites` |
| `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256` | `0xC0,0x2D` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384` | `0xC0,0x2E` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA` | `0xC0,0x04` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA` | `0xC0,0x05` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256` | `0xC0,0x25` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384` | `0xC0,0x26` | Disabled | `-DWOLFSSL_STATIC_DH` |
| `TLS_ECDH_ECDSA_WITH_RC4_128_SHA` | `0xC0,0x02` | Disabled | `-DWOLFSSL_STATIC_DH` + `--enable-arc4` |
| `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA` | `0xC0,0x03` | Disabled | `-DWOLFSSL_STATIC_DH` + `--enable-des3` + `--enable-des3-tls-suites` |

### A-7 TLS 1.2 PSK

The pure PSK suites with AES or NULL ciphers also need `WOLFSSL_STATIC_PSK`, which `--enable-psk` does not define (use `CPPFLAGS=-DWOLFSSL_STATIC_PSK` or `user_settings.h`). `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256` and the DHE-PSK and ECDHE-PSK suites only need `--enable-psk`.

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xA8` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xA9` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xAE` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xAF` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CBC_SHA` | `0x00,0x8C` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_256_CBC_SHA` | `0x00,0x8D` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` |
| `TLS_PSK_WITH_AES_128_CCM` | `0xC0,0xA4` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM` | `0xC0,0xA5` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_128_CCM_8` | `0xC0,0xA8` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_AES_256_CCM_8` | `0xC0,0xA9` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-aesccm` |
| `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAB` | Disabled | `--enable-psk` + `--enable-chacha` |
| `TLS_PSK_WITH_NULL_SHA256` | `0x00,0xB0` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA384` | `0x00,0xB1` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |
| `TLS_PSK_WITH_NULL_SHA` | `0x00,0x2C` | Disabled | `--enable-psk` + `-DWOLFSSL_STATIC_PSK` + `--enable-nullcipher` |

### A-8 TLS 1.2 DHE-PSK

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256` | `0x00,0xAA` | Disabled | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384` | `0x00,0xAB` | Disabled | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256` | `0x00,0xB2` | Disabled | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384` | `0x00,0xB3` | Disabled | `--enable-psk` |
| `TLS_DHE_PSK_WITH_AES_128_CCM` | `0xC0,0xA6` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_AES_256_CCM` | `0xC0,0xA7` | Disabled | `--enable-psk` + `--enable-aesccm` |
| `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAD` | Disabled | `--enable-psk` + `--enable-chacha` |
| `TLS_DHE_PSK_WITH_NULL_SHA256` | `0x00,0xB4` | Disabled | `--enable-psk` + `--enable-nullcipher` |
| `TLS_DHE_PSK_WITH_NULL_SHA384` | `0x00,0xB5` | Disabled | `--enable-psk` + `--enable-nullcipher` |

### A-9 TLS 1.2 ECDHE-PSK

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256` | `0xC0,0x37` | Disabled | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256` | `0xD0,0x01` | Disabled | `--enable-psk` + `--enable-supportedcurves` |
| `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256` | `0xCC,0xAC` | Disabled | `--enable-psk` + `--enable-chacha` |
| `TLS_ECDHE_PSK_WITH_NULL_SHA256` | `0xC0,0x3A` | Disabled | `--enable-psk` + `--enable-nullcipher` |

### A-10 TLS 1.2 DH_anon

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `TLS_DH_anon_WITH_AES_128_CBC_SHA` | `0x00,0x34` | Disabled | `--enable-anon` |
| `TLS_DH_anon_WITH_AES_256_GCM_SHA384` | `0x00,0xA7` | Disabled | `--enable-anon` |

### A-11 Signaling and Private Values

| Name | Wire Value | Default | configure Option |
|------|-----------|:-------:|-----------------|
| `TLS_EMPTY_RENEGOTIATION_INFO_SCSV` | `0x00,0xFF` | Disabled | `--enable-renegotiation-indication` (client sends it; servers with the default `--enable-secure-renegotiation-info` recognize it) |
| `WDM_WITH_NULL_SHA256` | `0x00,0xFE` | Disabled | `--enable-mcast` (wolfSSL DTLS multicast; also enables DTLS and the NULL cipher) |

`--enable-harden-tls` (RFC 9325) removes the DHE and RC4 suites, and with `--enable-harden-tls=128` also the 3DES suites. It cannot be combined with the NULL, static RSA, static DH or anonymous suites (the build stops with an error).

---

## B. Key Exchange Groups

### B-1 NIST Elliptic Curves

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `secp256r1` (P-256) | 23 | **Enabled** | `--enable-ecc` |
| `secp384r1` (P-384) | 24 | **Enabled** | `--enable-ecc` |
| `secp521r1` (P-521) | 25 | **Enabled** | `--enable-ecc` |
| `secp224r1` (P-224) | 21 | **Enabled** | `--enable-ecc` |
| `secp192r1` (P-192) | 19 | Disabled | `--with-eccminsz=192` |
| `secp160r1` | 16 | Disabled | `--with-eccminsz=160` |
| `secp160r2` | 17 | Disabled | `--enable-ecccustcurves=all` + `--with-eccminsz=160` |

The minimum ECC key size (`ECC_MIN_KEY_SZ`, set with `--with-eccminsz`) is 224 bits by default (192 bits in FIPS builds), so curves smaller than P-224 need a lower minimum. Of these curves, RFC 8446 only defines `secp256r1`, `secp384r1` and `secp521r1` for TLS 1.3, but wolfSSL does not filter the other curves by protocol version.

### B-2 Koblitz Curves

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `secp160k1` | 15 | Disabled | `--enable-ecccustcurves=all` + `--with-eccminsz=160` |
| `secp192k1` | 18 | Disabled | `--enable-ecccustcurves=all` + `--with-eccminsz=192` |
| `secp224k1` | 20 | Disabled | `--enable-ecccustcurves=all` |
| `secp256k1` | 22 | Disabled | `--enable-ecccustcurves=all` |

Plain `--enable-ecccustcurves` only defines `WOLFSSL_CUSTOM_CURVES`; the Koblitz curves (`HAVE_ECC_KOBLITZ`) need `--enable-ecccustcurves=all` (or `--enable-all`).

### B-3 Brainpool Curves

| Group Name | ID | TLS Ver. | Default | configure Option |
|------------|:--:|:--------:|:-------:|-----------------|
| `brainpoolP256r1` | 26 | 1.2 | Disabled | `--enable-ecccustcurves` |
| `brainpoolP384r1` | 27 | 1.2 | Disabled | `--enable-ecccustcurves` |
| `brainpoolP512r1` | 28 | 1.2 | Disabled | `--enable-ecccustcurves` |
| `brainpoolP256r1tls13` | 31 | 1.3 | Disabled | `--enable-ecccustcurves` |
| `brainpoolP384r1tls13` | 32 | 1.3 | Disabled | `--enable-ecccustcurves` |
| `brainpoolP512r1tls13` | 33 | 1.3 | Disabled | `--enable-ecccustcurves` |

### B-4 X25519 / X448

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `x25519` | 29 | Disabled | `--enable-curve25519` |
| `x448` | 30 | Disabled | `--enable-curve448` |

### B-5 FFDHE

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `ffdhe2048` | 256 | Conditionally Enabled | `--enable-dh` (Automatically enabled when TLS 1.3 + DH is enabled) |
| `ffdhe3072` | 257 | Disabled | `-DHAVE_FFDHE_3072` |
| `ffdhe4096` | 258 | Disabled | `-DHAVE_FFDHE_4096` |
| `ffdhe6144` | 259 | Disabled | `-DHAVE_FFDHE_6144` |
| `ffdhe8192` | 260 | Disabled | `-DHAVE_FFDHE_8192` |

### B-6 SM2

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `sm2p256v1` | 41 | Disabled | `--enable-sm2` |

### B-7 ML-KEM Standalone

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `ML-KEM-512` | 512 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-768` | 513 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |
| `ML-KEM-1024` | 514 | Disabled | `--enable-mlkem` + `--enable-tls-mlkem-standalone` |

### B-8 ML-KEM Hybrid (Standard)

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM768` | 4587 | Conditionally Enabled | `--enable-mlkem` + `--enable-pqc-hybrids` |
| `X25519MLKEM768` | 4588 | Disabled | `--enable-mlkem` + `--enable-pqc-hybrids` + `--enable-curve25519` |
| `SecP384r1MLKEM1024` | 4589 | Conditionally Enabled | `--enable-mlkem` + `--enable-pqc-hybrids` |

### B-9 ML-KEM Hybrid (Experimental)

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `SecP256r1MLKEM512` | 12107 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP384r1MLKEM768` | 12108 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `SecP521r1MLKEM1024` | 12109 | Disabled | `--enable-extra-pqc-hybrids` + `--enable-experimental` |
| `X25519MLKEM512` | 12214 | Disabled | Same as above + `--enable-curve25519` |
| `X448MLKEM768` | 12215 | Disabled | Same as above + `--enable-curve448` |
| `P256_ML_KEM_512_OLD` | 12103 | Disabled | Same as above + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |
| `P384_ML_KEM_768_OLD` | 12104 | Disabled | Same as above + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |
| `P521_ML_KEM_1024_OLD` | 12105 | Disabled | Same as above + `-DWOLFSSL_ML_KEM_USE_OLD_IDS` |

The `_OLD` IDs are earlier code points for the NIST curve hybrids. With `WOLFSSL_ML_KEM_USE_OLD_IDS`, each is sent together with the matching new ID (12107 to 12109).

### B-10 Kyber Round 3 Legacy

| Group Name | ID | Default | configure Option |
|------------|:--:|:-------:|-----------------|
| `KYBER_LEVEL1` | 570 | Disabled | `--enable-mlkem=yes,original` |
| `KYBER_LEVEL3` | 572 | Disabled | `--enable-mlkem=yes,original` |
| `KYBER_LEVEL5` | 573 | Disabled | `--enable-mlkem=yes,original` |
| `P256_KYBER_LEVEL1` | 12090 | Disabled | `--enable-mlkem=yes,original` |
| `P384_KYBER_LEVEL3` | 12092 | Disabled | `--enable-mlkem=yes,original` |
| `P521_KYBER_LEVEL5` | 12093 | Disabled | `--enable-mlkem=yes,original` |
| `X25519_KYBER_LEVEL1` | 12089 | Disabled | Same as above + `--enable-curve25519` |
| `X25519_KYBER_LEVEL3` | 25497 | Disabled | Same as above + `--enable-curve25519` |
| `X448_KYBER_LEVEL3` | 12176 | Disabled | Same as above + `--enable-curve448` |
| `P256_KYBER_LEVEL3` | 25498 | Disabled | `--enable-mlkem=yes,original` |

`--enable-mlkem=original` on its own does not build any usable Kyber parameter set; use `--enable-mlkem=yes,original`. Selecting `original` disables the ML-KEM groups unless `ml-kem` is also listed (`--enable-mlkem=yes,original,ml-kem`).

---

## C. Signature Algorithms

### C-1 ECDSA (NIST Curves)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_secp256r1_sha256` | `0x04,0x03` | **Enabled** | `--enable-ecc` |
| `ecdsa_secp384r1_sha384` | `0x05,0x03` | **Enabled** | `--enable-ecc` + `--enable-sha384` |
| `ecdsa_secp521r1_sha512` | `0x06,0x03` | **Enabled** | `--enable-ecc` + `--enable-sha512` |
| `ecdsa_sha1` | `0x02,0x03` | Disabled | TLS 1.0/1.1 handshakes (`--enable-oldtls`); TLS 1.2 only with `-DWOLFSSL_ALLOW_TLS_SHA1` (see RFC 9155) |

### C-2 ECDSA (Brainpool, TLS 1.3 Only)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ecdsa_brainpoolP256r1tls13_sha256` | `0x08,0x1A` | Disabled | `--enable-ecccustcurves` |
| `ecdsa_brainpoolP384r1tls13_sha384` | `0x08,0x1B` | Disabled | Same as above + `--enable-sha384` |
| `ecdsa_brainpoolP512r1tls13_sha512` | `0x08,0x1C` | Disabled | Same as above + `--enable-sha512` |

### C-3 EdDSA

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `ed25519` | `0x08,0x07` | Disabled | `--enable-ed25519` |
| `ed448` | `0x08,0x08` | Disabled | `--enable-ed448` |

### C-4 RSA-PSS RSAE

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_rsae_sha256` | `0x08,0x04` | **Enabled** | `--enable-rsapss` (automatic with TLS 1.3) |
| `rsa_pss_rsae_sha384` | `0x08,0x05` | **Enabled** | `--enable-rsapss` + `--enable-sha384` |
| `rsa_pss_rsae_sha512` | `0x08,0x06` | **Enabled** | `--enable-rsapss` + `--enable-sha512` |

### C-5 RSA-PSS PSS (TLS 1.3 Only)

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pss_pss_sha256` | `0x08,0x09` | **Enabled** | `--enable-tls13` + `--enable-rsapss` |
| `rsa_pss_pss_sha384` | `0x08,0x0A` | **Enabled** | Same as above + `--enable-sha384` |
| `rsa_pss_pss_sha512` | `0x08,0x0B` | **Enabled** | Same as above + `--enable-sha512` |

### C-6 RSA PKCS#1 v1.5

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `rsa_pkcs1_sha256` | `0x04,0x01` | **Enabled** | - |
| `rsa_pkcs1_sha384` | `0x05,0x01` | **Enabled** | `--enable-sha384` |
| `rsa_pkcs1_sha512` | `0x06,0x01` | **Enabled** | `--enable-sha512` |
| `rsa_pkcs1_sha224` | `0x03,0x01` | Conditional | `--enable-sha224` (Enabled by default on x86_64/aarch64) |
| `rsa_pkcs1_sha1` | `0x02,0x01` | Disabled | TLS 1.0/1.1 handshakes (`--enable-oldtls`); TLS 1.2 only with `-DWOLFSSL_ALLOW_TLS_SHA1` (see RFC 9155) |

### C-7 SM2

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `sm2sig_sm3` | `0x07,0x08` | Disabled | `--enable-sm2` + `--enable-sm3` |

### C-8 ML-DSA / Dilithium

| IANA Name | Wire Value | Default | configure Option |
|-----------|-----------|:-------:|-----------------|
| `mldsa44` (ML-DSA-44) | `0x09,0x04` | Disabled | `--enable-mldsa` |
| `mldsa65` (ML-DSA-65) | `0x09,0x05` | Disabled | `--enable-mldsa` |
| `mldsa87` (ML-DSA-87) | `0x09,0x06` | Disabled | `--enable-mldsa` |

### C-9 SLH-DSA (FIPS 205)

The wire values come from draft-reddy-tls-slhdsa and are the same ones oqs-provider uses. SLH-DSA can sign TLS 1.3 and DTLS 1.3 handshakes, new in wolfSSL 5.9.4.

| Name | Wire Value | Default | configure Option |
|------|-----------|:-------:|-----------------|
| `slhdsa_sha2_128s` | `0x09,0x11` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_128f` | `0x09,0x12` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_192s` | `0x09,0x13` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_192f` | `0x09,0x14` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_256s` | `0x09,0x15` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_sha2_256f` | `0x09,0x16` | Disabled | `--enable-slhdsa=sha2` |
| `slhdsa_shake_128s` | `0x09,0x17` | Disabled | `--enable-slhdsa` |
| `slhdsa_shake_128f` | `0x09,0x18` | Disabled | `--enable-slhdsa` |
| `slhdsa_shake_192s` | `0x09,0x19` | Disabled | `--enable-slhdsa` |
| `slhdsa_shake_192f` | `0x09,0x1A` | Disabled | `--enable-slhdsa` |
| `slhdsa_shake_256s` | `0x09,0x1B` | Disabled | `--enable-slhdsa` |
| `slhdsa_shake_256f` | `0x09,0x1C` | Disabled | `--enable-slhdsa` |

### C-10 Falcon (Experimental)

Falcon uses the private-use code points it shared with the old liboqs integration. The algorithm itself is now implemented natively in wolfCrypt.

| Name | Wire Value | Default | configure Option |
|------|-----------|:-------:|-----------------|
| `falcon_level1` (Falcon-512) | `0xFE,0xD7` | Disabled | `--enable-falcon` + `--enable-experimental` |
| `falcon_level5` (Falcon-1024) | `0xFE,0xDA` | Disabled | `--enable-falcon` + `--enable-experimental` |

---

## D. configure Option to #define Reference

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
| `--enable-dh` | `HAVE_DH` | Enabled by default (except FIPS v7 and later) |
| `--enable-psk` | Removes `NO_PSK` | |
| `--enable-rsapss` | `WC_RSA_PSS` | Automatic when TLS 1.3 is enabled |
| `--enable-curve25519` | `HAVE_CURVE25519` | |
| `--enable-curve448` | `HAVE_CURVE448` | |
| `--enable-ed25519` | `HAVE_ED25519` | |
| `--enable-ed448` | `HAVE_ED448` | |
| `--enable-ecccustcurves` | `WOLFSSL_CUSTOM_CURVES` | `=all` also defines `HAVE_ECC_KOBLITZ`, `HAVE_ECC_SECPR2`, `HAVE_ECC_SECPR3` and `HAVE_ECC_BRAINPOOL` |
| `--enable-brainpool` | `HAVE_ECC_BRAINPOOL` | Requires ecccustcurves; enabled by default with it |
| `--enable-des3` | Removes `NO_DES3` | |
| `--enable-des3-tls-suites` | Removes `NO_DES3_TLS_SUITES` | Needed for the 3DES cipher suites; requires `--enable-des3` |
| `--enable-arc4` | Removes `NO_RC4` | |
| `--enable-md5` | Removes `NO_MD5` | Needed for the MD5 based suites |
| `--enable-camellia` | `HAVE_CAMELLIA` | |
| `--enable-aria` | `HAVE_ARIA` | |
| `--enable-nullcipher` | `HAVE_NULL_CIPHER` | Not recommended (RFC 9325) |
| `--enable-anon` | `HAVE_ANON` | Not recommended (RFC 9325) |
| `--enable-sm2` | `WOLFSSL_SM2` | |
| `--enable-sm3` | `WOLFSSL_SM3` | |
| `--enable-sm4-cbc` | `WOLFSSL_SM4_CBC` | |
| `--enable-sm4-gcm` | `WOLFSSL_SM4_GCM` | |
| `--enable-sm4-ccm` | `WOLFSSL_SM4_CCM` | |
| `--enable-mlkem` | `WOLFSSL_HAVE_MLKEM` | Enabled by default (non-FIPS or FIPS v7 and later; needs SHA-3 and SHAKE) |
| `--enable-pqc-hybrids` | `WOLFSSL_PQC_HYBRIDS` | Enabled by default when mlkem is enabled |
| `--enable-mldsa` | `WOLFSSL_HAVE_MLDSA` | `HAVE_DILITHIUM` is a legacy alias |
| `--enable-slhdsa` | `WOLFSSL_HAVE_SLHDSA` | TLS 1.3 / DTLS 1.3 authentication, new in 5.9.4 |
| `--enable-falcon` | `HAVE_FALCON` | Native implementation, needs --enable-experimental |
| `--enable-tls13-sha512` | `WOLFSSL_TLS13_SHA512` | Keeps the SHA-512 transcript in TLS 1.3 only builds |
| `--disable-tlsv12` | `WOLFSSL_NO_TLS12` | Compiles TLS 1.2 out (5.9.4 and later) |
| `--with-eccminsz=BITS` | `ECC_MIN_KEY_SZ` | Default 224 (192 with FIPS) |
| `--enable-mcast` | `WOLFSSL_MULTICAST` | Also enables DTLS and the NULL cipher |
| `--enable-renegotiation-indication` | `HAVE_RENEGOTIATION_INDICATION` | Client sends `TLS_EMPTY_RENEGOTIATION_INFO_SCSV` |
| `--enable-harden-tls` | `WOLFSSL_HARDEN_TLS` | RFC 9325 requirements; `=112` (same as `yes`) or `=128` |
| (CFLAGS) | `WOLFSSL_STATIC_RSA` | Static RSA suites, no forward secrecy |
| (CFLAGS) | `WOLFSSL_STATIC_DH` | Static ECDH suites, no forward secrecy |
| (CFLAGS) | `WOLFSSL_STATIC_PSK` | Pure PSK suites with AES or NULL ciphers |
| (CFLAGS) | `NO_OLD_POLY1305` | Removes the `_OLD_POLY1305` ChaCha20-Poly1305 suites |
| (CFLAGS) | `WOLFSSL_ALLOW_TLS_SHA1` | Offers SHA-1 signature algorithms in TLS 1.2 |
