#  Supported JCE Algorithms and Classes

wolfJCE currently supports the following algorithms and classes:

    MessageDigest Class
        MD5
        SHA-1
        SHA-224
        SHA-256
        SHA-384
        SHA-512
        SHA3-224
        SHA3-256
        SHA3-384
        SHA3-512

    SecureRandom Class
        DEFAULT (maps to HashDRBG)
        HashDRBG (aliased also as: Hash_DRBG, DRBG)

    Cipher Class
        AES/CBC/NoPadding
        AES/CBC/PKCS5Padding
        AES/CCM/NoPadding
        AES/CTR/NoPadding
        AES/CTS/NoPadding
        AES/ECB/NoPadding
        AES/ECB/PKCS5Padding (aliased also as: AES)
        AES/GCM/NoPadding
        AES/OFB/NoPadding
        DESede/CBC/NoPadding
        RSA
        RSA/ECB/PKCS1Padding
        RSA/ECB/OAEPWithSHA-1AndMGF1Padding
        RSA/ECB/OAEPWithSHA-256AndMGF1Padding

    Mac Class
        AESCMAC (aliased also as: AES-CMAC)
        AESGMAC (aliased also as: AES-GMAC)
        HmacMD5
        HmacSHA1
        HmacSHA224
        HmacSHA256
        HmacSHA384
        HmacSHA512
        HmacSHA3-224
        HmacSHA3-256
        HmacSHA3-384
        HmacSHA3-512

    Signature Class
        MD5withRSA
        SHA1withRSA
        SHA224withRSA
        SHA256withRSA
        SHA384withRSA
        SHA512withRSA
        SHA3-224withRSA
        SHA3-256withRSA
        SHA3-384withRSA
        SHA3-512withRSA
        RSASSA-PSS
        SHA224withRSA/PSS
        SHA256withRSA/PSS
        SHA384withRSA/PSS
        SHA512withRSA/PSS
        SHA1withECDSA
        SHA224withECDSA
        SHA256withECDSA
        SHA384withECDSA
        SHA512withECDSA
        SHA3-224withECDSA
        SHA3-256withECDSA
        SHA3-384withECDSA
        SHA3-512withECDSA
        SHA256withECDSAinP1363Format
        SHA384withECDSAinP1363Format
        SHA512withECDSAinP1363Format
        SHA3-256withECDSAinP1363Format
        SHA3-384withECDSAinP1363Format
        SHA3-512withECDSAinP1363Format

    KeyAgreement Class
        DiffieHellman
        DH
        ECDH

    KeyGenerator Class
        AES
        HmacSHA1
        HmacSHA224
        HmacSHA256
        HmacSHA384
        HmacSHA512
        HmacSHA3-224
        HmacSHA3-256
        HmacSHA3-384
        HmacSHA3-512

    KeyPairGenerator Class
        RSA
        RSASSA-PSS
        EC
        DH (aliased also as: DiffieHellman)

    KeyFactory Class
        RSA
        EC
        DH (aliased also as: DiffieHellman)

    CertPathValidator Class
        PKIX

    CertPathBuilder Class
        PKIX

    SecretKeyFactory Class
        PBKDF2WithHmacSHA1
        PBKDF2WithHmacSHA224
        PBKDF2WithHmacSHA256
        PBKDF2WithHmacSHA384
        PBKDF2WithHmacSHA512
        PBKDF2WithHmacSHA3-224
        PBKDF2WithHmacSHA3-256
        PBKDF2WithHmacSHA3-384
        PBKDF2WithHmacSHA3-512

    KeyStore Class
        WKS

    AlgorithmParameters Class
        AES
        DH (aliased also as: DiffieHellman)
        GCM (aliased also as: AES-GCM)
        RSASSA-PSS

    AlgorithmParameterGenerator Class
        DH (aliased also as: DiffieHellman)

