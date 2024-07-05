#  Supported JCE Algorithms and Classes

wolfJCE currently supports the following algorithms and classes:

    MessageDigest Class
        MD5
        SHA-1
        SHA-256
        SHA-384
        SHA-512

    SecureRandom Class
        DEFAULT (maps to HashDRBG)
        HashDRBG

    Cipher Class
        AES/CBC/NoPadding
        AES/CBC/PKCS5Padding
        AES/GCM/NoPadding
        DESede/CBC/NoPadding
        RSA
        RSA/ECB/PKCS1Padding

    Mac Class
        HmacMD5
        HmacSHA1
        HmacSHA256
        HmacSHA384
        HmacSHA512

    Signature Class
        MD5withRSA
        SHA1withRSA
        SHA256withRSA
        SHA384withRSA
        SHA512withRSA
        SHA1withECDSA
        SHA256withECDSA
        SHA384withECDSA
        SHA512withECDSA

    KeyAgreement Class
        DiffieHellman
        DH
        ECDH

    KeyPairGenerator Class
        RSA
        EC
        DH

    CertPathValidator Class
        PKIX

    SecretKeyFactory
        PBKDF2WithHmacSHA1
        PBKDF2WithHmacSHA224
        PBKDF2WithHmacSHA256
        PBKDF2WithHmacSHA384
        PBKDF2WithHmacSHA512
        PBKDF2WithHmacSHA3-224
        PBKDF2WithHmacSHA3-256
        PBKDF2WithHmacSHA3-384
        PBKDF2WithHmacSHA3-512

    KeyStore
        WKS

