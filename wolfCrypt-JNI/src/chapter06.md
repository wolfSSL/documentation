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
        ML-DSA (any ML-DSA-44/65/87 key)
        ML-DSA-44
        ML-DSA-65
        ML-DSA-87
        XMSS (verify-only)
        XMSSMT (verify-only)
        LMS (aliased also as: HSS/LMS, verify-only)
        SLH-DSA (any SLH-DSA parameter set key)
        SLH-DSA-SHA2-128s
        SLH-DSA-SHA2-128f
        SLH-DSA-SHA2-192s
        SLH-DSA-SHA2-192f
        SLH-DSA-SHA2-256s
        SLH-DSA-SHA2-256f
        SLH-DSA-SHAKE-128s
        SLH-DSA-SHAKE-128f
        SLH-DSA-SHAKE-192s
        SLH-DSA-SHAKE-192f
        SLH-DSA-SHAKE-256s
        SLH-DSA-SHAKE-256f
        HASH-SLH-DSA (pre-hash, any SLH-DSA parameter set key)
        SLH-DSA-SHA2-128s-WITH-SHA256
        SLH-DSA-SHA2-128f-WITH-SHA256
        SLH-DSA-SHA2-192s-WITH-SHA512
        SLH-DSA-SHA2-192f-WITH-SHA512
        SLH-DSA-SHA2-256s-WITH-SHA512
        SLH-DSA-SHA2-256f-WITH-SHA512
        SLH-DSA-SHAKE-128s-WITH-SHAKE128
        SLH-DSA-SHAKE-128f-WITH-SHAKE128
        SLH-DSA-SHAKE-192s-WITH-SHAKE256
        SLH-DSA-SHAKE-192f-WITH-SHAKE256
        SLH-DSA-SHAKE-256s-WITH-SHAKE256
        SLH-DSA-SHAKE-256f-WITH-SHAKE256

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
        ML-DSA (defaults to ML-DSA-65, level overridable via init())
        ML-DSA-44
        ML-DSA-65
        ML-DSA-87
        SLH-DSA (defaults to SLH-DSA-SHA2-128f, set overridable via init())
        SLH-DSA-SHA2-128s
        SLH-DSA-SHA2-128f
        SLH-DSA-SHA2-192s
        SLH-DSA-SHA2-192f
        SLH-DSA-SHA2-256s
        SLH-DSA-SHA2-256f
        SLH-DSA-SHAKE-128s
        SLH-DSA-SHAKE-128f
        SLH-DSA-SHAKE-192s
        SLH-DSA-SHAKE-192f
        SLH-DSA-SHAKE-256s
        SLH-DSA-SHAKE-256f
        ML-KEM (defaults to ML-KEM-768, level overridable via init())
        ML-KEM-512
        ML-KEM-768
        ML-KEM-1024

    KeyFactory Class
        RSA
        EC
        DH (aliased also as: DiffieHellman)
        ML-DSA
        ML-DSA-44
        ML-DSA-65
        ML-DSA-87
        SLH-DSA
        SLH-DSA-SHA2-128s
        SLH-DSA-SHA2-128f
        SLH-DSA-SHA2-192s
        SLH-DSA-SHA2-192f
        SLH-DSA-SHA2-256s
        SLH-DSA-SHA2-256f
        SLH-DSA-SHAKE-128s
        SLH-DSA-SHAKE-128f
        SLH-DSA-SHAKE-192s
        SLH-DSA-SHAKE-192f
        SLH-DSA-SHAKE-256s
        SLH-DSA-SHAKE-256f
        ML-KEM
        ML-KEM-512
        ML-KEM-768
        ML-KEM-1024
        XMSS (verify-only)
        XMSSMT (verify-only)
        LMS (aliased also as: HSS/LMS)

    KEM Class (javax.crypto.KEM, requires JDK 21 or later)
        ML-KEM
        ML-KEM-512
        ML-KEM-768
        ML-KEM-1024

    CertPathValidator Class
        PKIX (with PKIXRevocationChecker via getRevocationChecker())

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
        AES
        DESede

    KeyStore Class
        WKS

    AlgorithmParameters Class
        AES
        DH (aliased also as: DiffieHellman)
        GCM (aliased also as: AES-GCM)
        RSASSA-PSS

    AlgorithmParameterGenerator Class
        DH (aliased also as: DiffieHellman)

In addition to the algorithm names above, many services are also registered
under their standard OID aliases (for example, `Cipher` AES OIDs,
`MessageDigest` SHA-2 OIDs, `Mac` HMAC OIDs, and the ML-DSA, SLH-DSA, ML-KEM,
XMSS, and LMS object identifiers), allowing lookup by OID string. A complete
list of aliases can be found in the wolfcrypt-jni `README_JCE.md` file.

The RSA `Cipher` implementations also support `Cipher.WRAP_MODE` and
`Cipher.UNWRAP_MODE` for RSA-based key wrapping and unwrapping.

## Native wolfSSL Feature Requirements

The ML-KEM, ML-DSA, SLH-DSA, XMSS/XMSS^MT, and LMS/HSS services require the
matching algorithm support to be compiled into the native wolfSSL library.
If native support is missing, wolfJCE will still compile and run normally,
but the corresponding services will not be registered. See
[Chapter 2](chapter02.md#native-feature-requirements-for-post-quantum-and-hash-based-algorithms)
for the native wolfSSL configure options required for each algorithm.

## ML-KEM (FIPS 203) Notes

wolfJCE supports ML-KEM, the Module-Lattice-Based Key Encapsulation Mechanism
from FIPS 203 (formerly Kyber). The `KeyPairGenerator`, `KeyFactory`, and key
classes work on Java 8 and later. The `KEM` service (`javax.crypto.KEM`)
requires JDK 21 or later - on earlier JDKs the KEM service is not registered,
but key generation and key encoding are still available.

To select a parameter set, either use the parameter-set-specific names
directly (ex: `KeyPairGenerator.getInstance("ML-KEM-768", "wolfJCE")`), or use
the family name `ML-KEM` (defaults to ML-KEM-768) and initialize with a
parameter spec. On JDK 11+ use `java.security.spec.NamedParameterSpec.ML_KEM_768`,
and on Java 8 use `com.wolfssl.provider.jce.WolfPQCParameterSpec.ML_KEM_768`.
As with the JDK reference implementation, ML-KEM does not accept an integer
key size via `initialize(int)`.

Generated keys report `getAlgorithm()` of `ML-KEM` (matching the JDK
reference implementation) regardless of parameter set. Public keys use X.509
SubjectPublicKeyInfo encoding and private keys use PKCS#8, per RFC 9935. On
input, wolfJCE accepts all three RFC 9935 private key CHOICE forms (`seed`,
`expandedKey`, and `both`). On output, the form is controlled by the
`jdk.mlkem.pkcs8.encoding` property (the same property the JDK reference
implementation uses), defaulting to `expandedKey`, which is importable by the
widest range of providers.

## Example Applications

The `examples/provider` directory in the wolfcrypt-jni package contains
example applications demonstrating several of the algorithm classes above,
including `MlKemExample.java` (ML-KEM encapsulation/decapsulation and key
encoding), `MlDsaExample.java`, `SlhDsaExample.java`, `XmssExample.java`,
and `CertPathBuilderExample.java`.

