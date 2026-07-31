# Post-Quantum Cryptography


## Post-Quantum Cryptography

wolfProvider supports the NIST post-quantum standards through the OpenSSL 3
EVP interface. PQC support is opt-in so applications that do not need these
algorithms are unaffected.

### Requirements

- wolfSSL v5.9.2-stable or later
- OpenSSL 3.6 or later
- A wolfSSL build with the required PQC algorithms enabled

The packaged Debian build is not currently available with PQC because its
system OpenSSL is older than OpenSSL 3.6.

### Supported Algorithms

| Algorithm | Standard | Supported Parameter Sets |
| :-------- | :------- | :----------------------- |
| ML-KEM | FIPS 203 | ML-KEM-512, ML-KEM-768, ML-KEM-1024 |
| ML-DSA | FIPS 204 | ML-DSA-44, ML-DSA-65, ML-DSA-87 |
| SLH-DSA with SHA-2 | FIPS 205 | SLH-DSA-SHA2-128s, SLH-DSA-SHA2-128f, SLH-DSA-SHA2-192s, SLH-DSA-SHA2-192f, SLH-DSA-SHA2-256s, SLH-DSA-SHA2-256f |
| SLH-DSA with SHAKE | FIPS 205 | SLH-DSA-SHAKE-128s, SLH-DSA-SHAKE-128f, SLH-DSA-SHAKE-192s, SLH-DSA-SHAKE-192f, SLH-DSA-SHAKE-256s, SLH-DSA-SHAKE-256f |
| LMS | RFC 8554 / NIST SP 800-208 | LMS and LMOTS public-key verification |

ML-KEM supports key generation, encapsulation, decapsulation, raw key
import/export, and public/private key encoding. ML-DSA supports key generation,
pure and pre-hash signing, verification, context strings, and key encoding.
SLH-DSA supports key generation, pure signing, verification, context strings,
and key encoding. LMS supports public-key import and one-shot signature
verification; private-key import, signing, and key generation are not exposed
because OpenSSL 3.6 provides LMS as a verification-only interface.

### Provider Architecture

Applications use the standard OpenSSL 3 EVP interfaces. wolfProvider registers
OpenSSL key management implementations for each parameter set, a KEM
implementation for ML-KEM, and signature implementations for ML-DSA and
SLH-DSA. The provider translates those operations to the corresponding
wolfCrypt APIs and keeps the wolfCrypt key object inside the OpenSSL
`EVP_PKEY`.

| Family | OpenSSL Interfaces | Main Operations |
| :----- | :----------------- | :-------------- |
| ML-KEM | `EVP_PKEY`, `EVP_PKEY_CTX`, KEM | Key generation, encapsulation, decapsulation, key import/export |
| ML-DSA | `EVP_PKEY`, `EVP_MD_CTX`, signature | Key generation, pure and pre-hash sign/verify, key import/export |
| SLH-DSA | `EVP_PKEY`, `EVP_MD_CTX`, signature | Key generation, pure sign/verify, key import/export |
| LMS | `EVP_PKEY`, `EVP_MD_CTX`, signature | Public-key import/export and one-shot verification |

Keys support raw public and private key parameters as well as DER and PEM
encoding. Public keys use SubjectPublicKeyInfo and private keys use PKCS#8.
Encrypted PKCS#8 private key output is also supported. The signature
implementations expose the algorithm identifiers needed for X.509 certificate
and request operations.

### Sizes and Security Categories

ML-KEM always produces a 32-byte shared secret:

| Parameter Set | NIST Category | Public Key | Private Key | Ciphertext |
| :------------ | :------------ | ---------: | ----------: | ---------: |
| ML-KEM-512 | 1 | 800 bytes | 1,632 bytes | 768 bytes |
| ML-KEM-768 | 3 | 1,184 bytes | 2,400 bytes | 1,088 bytes |
| ML-KEM-1024 | 5 | 1,568 bytes | 3,168 bytes | 1,568 bytes |

ML-DSA signatures and keys have fixed sizes for each parameter set:

| Parameter Set | NIST Category | Public Key | Private Key | Signature |
| :------------ | :------------ | ---------: | ----------: | --------: |
| ML-DSA-44 | 2 | 1,312 bytes | 2,560 bytes | 2,420 bytes |
| ML-DSA-65 | 3 | 1,952 bytes | 4,032 bytes | 3,309 bytes |
| ML-DSA-87 | 5 | 2,592 bytes | 4,896 bytes | 4,627 bytes |

For SLH-DSA, SHA-2 and SHAKE parameter sets at the same level have the same
sizes. The `s` variants favor smaller signatures, while the `f` variants favor
faster signing:

| Parameter Sets | NIST Category | Public Key | Private Key | Signature |
| :------------- | :------------ | ---------: | ----------: | --------: |
| 128s | 1 | 32 bytes | 64 bytes | 7,856 bytes |
| 128f | 1 | 32 bytes | 64 bytes | 17,088 bytes |
| 192s | 3 | 48 bytes | 96 bytes | 16,224 bytes |
| 192f | 3 | 48 bytes | 96 bytes | 35,664 bytes |
| 256s | 5 | 64 bytes | 128 bytes | 29,792 bytes |
| 256f | 5 | 64 bytes | 128 bytes | 49,856 bytes |

### Signing and Generation Parameters

ML-DSA and SLH-DSA accept the OpenSSL signature context-string parameter, with
the FIPS 204 and FIPS 205 maximum of 255 bytes. Both support deterministic and
randomized signing through OpenSSL signature parameters. ML-DSA additionally
supports HashML-DSA pre-hash signing and external representative input.

The key generation implementations accept the OpenSSL ML-KEM, ML-DSA, and
SLH-DSA seed parameters. These deterministic paths are used by known-answer
and ACVP testing. Normal application key generation and randomized signing use
wolfCrypt's random number generator.

OpenSSL presents one-shot and streaming digest-sign entry points to
applications. wolfProvider incrementally hashes HashML-DSA input. Pure ML-DSA
and SLH-DSA require the complete message; SLH-DSA therefore buffers streaming
input and enforces a 64 MiB message limit.

### Platform Optimizations

wolfProvider calls the native wolfCrypt implementations, so it benefits from
the optimized code selected by the wolfSSL build without requiring a separate
provider-specific acceleration layer. Available wolfCrypt PQC speedups include
x86-64 vectorized implementations and assembly paths for ARM32, AArch64,
ARMv7-M, and ARMv7E-M. Optimized SHA-3 and SHAKE operations also accelerate
the Keccak work used by ML-KEM and ML-DSA.

The exact path is compiler, processor, and wolfSSL configuration dependent.
Applications should use the wolfCrypt benchmark on the target system to
confirm which implementation was selected and measure the relevant parameter
sets. See the wolfSSL
[PQC documentation](https://www.wolfssl.com/documentation/manuals/wolfssl/appendix09.html)
and [ML-KEM acceleration overview](https://www.wolfssl.com/accelerated-kyber-ml-kem/)
for configuration and benchmark details.

### Building

The build script can configure OpenSSL, wolfSSL, and wolfProvider together:

```sh
./scripts/build-wolfprovider.sh --enable-pqc
```

`--enable-pqc` enables all three algorithm families. Each family can also be
selected independently:

```sh
./scripts/build-wolfprovider.sh --enable-mlkem
./scripts/build-wolfprovider.sh --enable-mldsa
./scripts/build-wolfprovider.sh --enable-slhdsa
```

For a manual build, configure wolfSSL with the matching algorithm options,
then configure wolfProvider:

```sh
# Add the required options to the normal wolfSSL configuration.
./configure --enable-mlkem --enable-mldsa --enable-slhdsa
make
sudo make install

# Configure wolfProvider against OpenSSL 3.6 or later.
./configure --enable-pqc \
    --with-openssl=/path/to/openssl \
    --with-wolfssl=/path/to/wolfssl
make
sudo make install
```

PQC code is not compiled unless `--enable-pqc` or an individual PQC option is
passed to wolfProvider, even when wolfSSL has the algorithms enabled.

### Loading the Provider

Set the provider module and configuration paths to the wolfProvider
installation:

```sh
export OPENSSL_MODULES=/path/to/wolfprovider/lib
export OPENSSL_CONF=/path/to/wolfProvider/provider.conf
```

Confirm that the expected algorithms are provided by `libwolfprov`:

```sh
openssl list -kem-algorithms -provider libwolfprov
openssl list -signature-algorithms -provider libwolfprov
```

### OpenSSL EVP Example

The maintained
[`examples/pqc_openssl_example.c`](https://github.com/wolfSSL/wolfProvider/blob/master/examples/pqc_openssl_example.c)
program demonstrates all three algorithm families through the OpenSSL EVP API:

- ML-KEM-768 key generation, encapsulation, and decapsulation
- ML-DSA-65 key generation, signing, and verification
- SLH-DSA-SHA2-128f key generation, signing, and verification

The example is built and run by `make check` when wolfProvider is configured
with any PQC family. Compile-time guards run only the enabled families, so the
same source also demonstrates ML-KEM-only, ML-DSA-only, and SLH-DSA-only
builds. After building, it can also be run directly from the wolfProvider root:

```sh
./examples/pqc_openssl_example
```

The companion
[`examples/openssl_example.c`](https://github.com/wolfSSL/wolfProvider/blob/master/examples/openssl_example.c)
shows basic provider loading, build information, and self-test handling.

ML-DSA supports pure ML-DSA and HashML-DSA through OpenSSL's digest-sign
interface. SLH-DSA is a pure signature algorithm and does not accept a
separate digest name. Its streaming interface buffers the complete message
and limits it to 64 MiB.

### Build Macros

The configure options add the corresponding request macros:

| Configure Option | wolfProvider Request Macro | wolfSSL Capability Macro |
| :--------------- | :------------------------- | :----------------------- |
| `--enable-mlkem` | `WOLFPROV_HAVE_MLKEM` | `WOLFSSL_HAVE_MLKEM` |
| `--enable-mldsa` | `WOLFPROV_HAVE_MLDSA` | `WOLFSSL_HAVE_MLDSA` |
| `--enable-slhdsa` | `WOLFPROV_HAVE_SLHDSA` | `WOLFSSL_HAVE_SLHDSA` |
| `--enable-lms` | `WOLFPROV_HAVE_LMS` | `WOLFSSL_HAVE_LMS` |

`--enable-pqc` enables ML-KEM and ML-DSA. SLH-DSA and LMS are enabled separately
with `--enable-slhdsa` and `--enable-lms`. After configuration validates the wolfSSL capabilities,
wolfProvider uses `WP_HAVE_MLKEM`, `WP_HAVE_MLDSA`, `WP_HAVE_SLHDSA`, and
`WP_HAVE_LMS` internally to compile and register the available implementations.

### TLS 1.3

wolfProvider advertises these ML-KEM TLS groups:

- MLKEM512
- MLKEM768
- MLKEM1024
- X25519MLKEM768
- SecP256r1MLKEM768
- SecP384r1MLKEM1024

It also advertises the `mldsa44`, `mldsa65`, and `mldsa87` TLS 1.3 signature
schemes. SLH-DSA is supported through EVP but is not advertised as a TLS
signature scheme.

### Validation

The wolfCrypt Post Quantum v7.0.0 implementation has NIST CAVP algorithm
validation under
[certificate A8437](https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/details?validation=41047).
The certificate covers LMS signature verification; ML-KEM key generation,
encapsulation, and
decapsulation; ML-DSA key generation, signature generation, and signature
verification; and SLH-DSA key generation, signature generation, and signature
verification. It also covers the prerequisite SHA, SHAKE, HMAC, and DRBG
implementations identified by the NIST record.

This validation applies to the identified wolfCrypt version and operating
environment. A wolfProvider application must use the corresponding validated
wolfCrypt distribution and follow its security policy when a validated
deployment is required.

CAVP validates the algorithm implementations. It is distinct from validation
of a complete cryptographic module under FIPS 140-3, so using an open source or
FIPS-ready wolfSSL build does not by itself create a FIPS-validated
application.

PQC has several independent test layers:

- Unit and example tests cover key generation, import/export, encoding,
  encapsulation, decapsulation, signing, verification, malformed inputs, and
  X.509 operations where applicable.
- OpenSSL EVP known-answer tests run the ML-KEM, ML-DSA, SLH-DSA, and LMS vector
  files against wolfProvider. The LMS vector contains 320 verification cases.
- The PQC interoperability test compares wolfProvider with OpenSSL's default
  provider and the direct wolfSSL APIs. It also tests ML-KEM and hybrid TLS
  groups plus ML-DSA certificate authentication.
- The nginx OSP workflow tests ML-KEM and hybrid TLS 1.3 key exchange with
  ML-DSA authentication.
- The pinned libacvp OSP workflow runs its complete unit suite and exercises
  its OpenSSL ACVP handlers for ML-KEM, ML-DSA, and SLH-DSA.

The version, nginx, and libacvp matrices cover wolfSSL master and the latest
eligible stable release. OSP tests run in replace-default and non-replace
modes, with normal and forced-failure cases. PQC KAT and version coverage runs
for pull requests, while the longer OSP integration workflows are
label-selected and run nightly.

## Build Defines

wolfProvider exposes several preprocessor defines that allow users to configure how wolfProvider is built. These are described in the table below.

| Define                           | Description |
| :------------------------------- | :----------------------------- |
| WOLFPROVIDER_USER_SETTINGS | Read user-specified defines from user_settings.h. |
| WOLFPROV_DEBUG | Output debug information |
| WP_CHECK_FORCE_FAIL | Force failure checking for testing purposes |
| WP_ALLOW_NON_FIPS | Allow certain non-FIPS algorithms in FIPS mode |
| WP_HAVE_AESCCM | AES encryption in CCM (Counter with CBC-MAC) mode |
| WP_HAVE_AESCFB | AES encryption in CFB (Cipher Feedback) mode |
| WP_HAVE_AESCBC | AES encryption in CBC (Cipher Block Chaining) mode |
| WP_HAVE_AESCTR | AES encryption in CTR (Counter) mode |
| WP_HAVE_AESCTS | AES encryption in CTS (Ciphertext Stealing) mode |
| WP_HAVE_AESECB | AES encryption in ECB (Electronic Codebook) mode |
| WP_HAVE_AESGCM | AES encryption in GCM (Galois/Counter Mode) mode |
| WP_HAVE_CMAC | CMAC (Cipher-based Message Authentication Code) support |
| WP_HAVE_DES3CBC | Triple DES encryption in CBC mode |
| WP_HAVE_DH | Diffie-Hellman key exchange support |
| WP_HAVE_DIGEST | General digest/hash algorithm support |
| WP_HAVE_ECC | General Elliptic Curve Cryptography support |
| WP_HAVE_EC_P192 | P-192 elliptic curve support |
| WP_HAVE_EC_P224 | P-224 elliptic curve support |
| WP_HAVE_EC_P256 | P-256 elliptic curve support |
| WP_HAVE_EC_P384 | P-384 elliptic curve support |
| WP_HAVE_EC_P521 | P-521 elliptic curve support |
| WP_HAVE_ECDH | ECDH (Elliptic Curve Diffie-Hellman) key exchange support |
| WP_HAVE_ECDSA | ECDSA (Elliptic Curve Digital Signature Algorithm) support |
| WP_HAVE_ECKEYGEN | Elliptic curve key generation support |
| WP_HAVE_ED25519 | Ed25519 elliptic curve signature support |
| WP_HAVE_ED448 | Ed448 elliptic curve signature support |
| WP_HAVE_GMAC | GMAC (Galois/Counter Mode Authentication) support |
| WP_HAVE_HKDF | HKDF (HMAC-based Key Derivation Function) support |
| WP_HAVE_HMAC | HMAC (Hash-based Message Authentication Code) support |
| WP_HAVE_KRB5KDF | Kerberos 5 Key Derivation Function support |
| WP_HAVE_MD5 | MD5 hash algorithm support |
| WP_HAVE_MD5_SHA1 | MD5+SHA1 combination support |
| WP_HAVE_MLDSA | ML-DSA (FIPS 204) post-quantum signature support |
| WP_HAVE_MLKEM | ML-KEM (FIPS 203) post-quantum key encapsulation support |
| WP_HAVE_PBE | Password-Based Encryption support |
| WP_HAVE_RANDOM | Random number generation support |
| WP_HAVE_RSA | RSA encryption and signature support |
| WP_HAVE_SHA1 | SHA1 hash algorithm support |
| WP_HAVE_SHA224 | SHA224 hash algorithm support |
| WP_HAVE_SHA256 | SHA256 hash algorithm support |
| WP_HAVE_SHA384 | SHA384 hash algorithm support |
| WP_HAVE_SHA3 | SHA3 family hash algorithm support |
| WP_HAVE_SHA3_224 | SHA3-224 hash algorithm support |
| WP_HAVE_SHA3_256 | SHA3-256 hash algorithm support |
| WP_HAVE_SHA3_384 | SHA3-384 hash algorithm support |
| WP_HAVE_SHA3_512 | SHA3-512 hash algorithm support |
| WP_HAVE_SHA512 | SHA512 hash algorithm support |
| WP_HAVE_SHA512_224 | SHA512/224 hash algorithm support |
| WP_HAVE_SHA512_256 | SHA512/256 hash algorithm support |
| WP_HAVE_SHAKE_256 | SHAKE256 extendable output function support |
| WP_HAVE_SLHDSA | SLH-DSA (FIPS 205) post-quantum signature support |
| WP_HAVE_TLS1_PRF | TLS1 Pseudo-Random Function support |
| WP_HAVE_X25519 | X25519 elliptic curve support |
| WP_HAVE_X448 | X448 elliptic curve support |
| WP_RSA_PSS_ENCODING | RSA-PSS (Probabilistic Signature Scheme) encoding support |
