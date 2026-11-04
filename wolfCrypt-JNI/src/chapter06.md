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
        SHAKE128-256 (aliased also as: SHAKE128)
        SHAKE256-512 (aliased also as: SHAKE256)

    SecureRandom Class
        DEFAULT (maps to HashDRBG)
        HashDRBG (aliased also as: Hash_DRBG, DRBG)

    Cipher Class
        AES/CBC/NoPadding
        AES/CBC/PKCS5Padding
        AES/CCM/NoPadding
        AES/CFB/NoPadding (aliased also as: AES/CFB128/NoPadding)
        AES/CFB8/NoPadding
        AES/CFB1/NoPadding
        AES/CTR/NoPadding
        AES/CTS/NoPadding
        AES/ECB/NoPadding
        AES/ECB/PKCS5Padding (aliased also as: AES)
        AES/GCM/NoPadding
        AES/OFB/NoPadding
        AES/XTS/NoPadding
        AESWrap (aliased also as: AES/KW/NoPadding, AESKW)
        AESWrap_128 (aliased also as: AES_128/KW/NoPadding)
        AESWrap_192 (aliased also as: AES_192/KW/NoPadding)
        AESWrap_256 (aliased also as: AES_256/KW/NoPadding)
        AES/KW/PKCS5Padding
        AES_128/KW/PKCS5Padding
        AES_192/KW/PKCS5Padding
        AES_256/KW/PKCS5Padding
        DESede/CBC/NoPadding
        RSA
        RSA/ECB/PKCS1Padding
        RSA/ECB/NoPadding
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
        EdDSA (any Ed25519/Ed448 key)
        Ed25519
        Ed448
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
        EdDSA (defaults to Ed25519, curve overridable via init())
        Ed25519
        Ed448
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
        EdDSA (any Ed25519/Ed448 key)
        Ed25519
        Ed448
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
        PKIX (requires native wolfSSL 5.9.2 or later)

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
`MessageDigest` SHA-2 and SHAKE OIDs, `Mac` HMAC OIDs, and the Ed25519, Ed448,
ML-DSA, SLH-DSA, ML-KEM, XMSS, and LMS object identifiers), allowing lookup by
OID string. A complete list of aliases can be found in the wolfcrypt-jni
`README_JCE.md` file.

The RSA `Cipher` implementations also support `Cipher.WRAP_MODE` and
`Cipher.UNWRAP_MODE` for RSA-based key wrapping and unwrapping.

## Native wolfSSL Feature Requirements

The ML-KEM, ML-DSA, SLH-DSA, XMSS/XMSS^MT, LMS/HSS, Ed25519, Ed448, AES Key
Wrap, AES-XTS, AES-CFB, SHAKE, and raw RSA (`RSA/ECB/NoPadding`) services
require the matching algorithm support to be compiled into the native wolfSSL
library.
If native support is missing, wolfJCE will still compile and run normally,
but the corresponding services will not be registered. DH services are also
not registered when DH is left out of native wolfSSL or disabled at runtime,
which is the default for wolfCrypt FIPS v7 and FIPS Ready builds starting with
wolfSSL 5.9.4. See
[Chapter 2](chapter02.md#native-feature-requirements-for-optional-algorithms)
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

## AES-GCM Notes

When `AES/GCM/NoPadding` is initialized for encryption without an
`AlgorithmParameterSpec`, the 96-bit IV is generated inside native wolfCrypt
using the wolfCrypt DRBG. A `SecureRandom` passed to `init()` is not used for
this IV. `Cipher.getIV()` and `Cipher.getParameters()` return the generated IV,
which must be given to the decrypting side as a `GCMParameterSpec`.

With wolfCrypt FIPS, this internal IV generation is the approved AES-GCM
encryption path (FIPS 140-3 IG C.H). An IV supplied through `GCMParameterSpec`
is an external IV, which the wolfCrypt FIPS security policy only allows in
specific protocol cases (such as TLS 1.2). Applications that need FIPS approved
AES-GCM encryption should let the Cipher generate the IV. When using wolfCrypt
FIPS v5.2.4, or v7 and later, AES-GCM and AES-GMAC IVs shorter than 96 bits are
rejected at `init()`.

## AES-XTS Notes

`AES/XTS/NoPadding` (IEEE 1619, NIST SP 800-38E) differs from the other AES
modes in a few ways:

- The `SecretKey` is two concatenated AES keys of equal size, the data key
  followed by the tweak key: 32 bytes for AES-128-XTS or 64 bytes for
  AES-256-XTS. The two halves must differ.
- The 16-byte tweak is passed as the `IvParameterSpec`. Encryption generates a
  random tweak when none is given, and decryption requires one.
- Each `doFinal()` processes one data unit of 16 to 16,777,216 bytes. Output
  length equals input length, using ciphertext stealing for a partial last
  block instead of padding.
- `doFinal()` resets the Cipher to its initialized state, so each data unit
  should be given its own tweak with a new `init()`. For sector-based use, the
  JNI-level `AesXts.updateSector()` method takes the sector number directly.

## AES Key Wrap Notes

wolfJCE provides AES Key Wrap (RFC 3394 / NIST SP 800-38F "KW") through the
`AESWrap` Cipher family. `AESWrap_128`, `AESWrap_192`, and `AESWrap_256` fix the
key encryption key (KEK) size and carry the NIST OIDs. AES Key Wrap with
Padding (RFC 5649 "KWP") is not available in native wolfSSL.

- `WRAP_MODE`/`UNWRAP_MODE` and `ENCRYPT_MODE`/`DECRYPT_MODE` are supported.
  Input to wrap must be at least 16 bytes and a multiple of 8 bytes, and the
  wrapped output is 8 bytes longer than the input.
- `AES/KW/PKCS5Padding` pads input to the 8-byte block size before wrapping.
  This can be used to wrap keys whose encodings are not a multiple of 8 bytes,
  such as X.509 public keys and PKCS#8 private keys. This matches SunJCE on
  JDK 21 and later, but not JDK 17, which pads to 16-byte blocks.
- The 8-byte IV is the RFC 3394 integrity check value, not a nonce. The
  default value `A6A6A6A6A6A6A6A6` is used unless a different 8-byte
  `IvParameterSpec` is given, in which case the same value must be used to
  unwrap.

## EdDSA (Ed25519 / Ed448) Notes

wolfJCE supports Ed25519 and Ed448 signatures (RFC 8032). The `Ed25519` and
`Ed448` service names are curve specific, while `EdDSA` accepts a key of either
curve. The `EdDSA` `KeyPairGenerator` defaults to Ed25519, or Ed448 when
Ed25519 is not compiled into native wolfSSL. `KeyPairGenerator.initialize()`
accepts a key size (255 or 256 for Ed25519, 448 for Ed448), a
`NamedParameterSpec` (JDK 11+), or an `ECGenParameterSpec` naming `"Ed25519"`
or `"Ed448"` (Java 8).

Generated keys report `getAlgorithm()` of `EdDSA`. Public keys use X.509
SubjectPublicKeyInfo encoding (RFC 8410) and private keys use PKCS#8. wolfJCE
outputs the PKCS#8 v1 form, and accepts both the v1 form and the RFC 5958 v2
form with an embedded public key on input.

Pure EdDSA is used by default. The context and pre-hash variants (Ed25519ctx,
Ed25519ph, Ed448 with a context, and Ed448ph) are selected with
`Signature.setParameter()` using
`com.wolfssl.provider.jce.WolfCryptEdDSAParameterSpec` on any JDK, or the JDK
`java.security.spec.EdDSAParameterSpec` on JDK 15 and later. When wolfJCE is
built with JDK 15 or later and loaded from `wolfcrypt-jni.jar` on a JDK 15 or
later runtime, its EdDSA keys implement the JDK `EdECPublicKey`
and `EdECPrivateKey` interfaces and can be used directly with SunEC (see
[Chapter 3](chapter03.md#jdk-15-multi-release-jar-eddsa)).

## RSA/ECB/NoPadding Notes

`RSA/ECB/NoPadding` performs the raw RSA operation and matches SunJCE
behavior: input is zero padded on the left to the modulus size, output is
always the modulus size, and a private key may encrypt and a public key may
decrypt. Input longer than the modulus fails with `IllegalBlockSizeException`,
and input numerically at or above the modulus fails with `BadPaddingException`.
Unlike SunJCE, wolfJCE also rejects the values 0, 1, and n - 1 with
`BadPaddingException`.

More details on the algorithms above, including differences from SunJCE
behavior, can be found in the wolfcrypt-jni `README_JCE.md` file.

## Example Applications

The `examples/provider` directory in the wolfcrypt-jni package contains
example applications demonstrating several of the algorithm classes above,
including `MlKemExample.java` (ML-KEM encapsulation/decapsulation and key
encoding), `MlDsaExample.java`, `SlhDsaExample.java`, `XmssExample.java`,
`EdDSAExample.java` (Ed25519 and Ed448), `AesXtsExample.java`,
`AesKeyWrapExample.java`, `AesCfbExample.java`, `ShakeExample.java`, and
`CertPathBuilderExample.java`. Each example has a matching `.sh` script, which
can be run from any directory.

