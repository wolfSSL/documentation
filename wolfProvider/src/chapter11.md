# Post-Quantum Cryptography

wolfProvider supports the NIST post-quantum standards through the OpenSSL 3
EVP interface. PQC support is opt-in so applications that do not need these
algorithms are unaffected.

## Requirements

- wolfSSL v5.9.2-stable or later
- OpenSSL 3.6 or later
- A wolfSSL build with the required PQC algorithms enabled

The packaged Debian build is not currently available with PQC because its
system OpenSSL is older than OpenSSL 3.6.

## Supported Algorithms

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
verification only. Private-key import, signing, and key generation are not
exposed. This follows OpenSSL's LMS key-type contract, which is
verification-only, and is also a deliberate wolfProvider design choice: it
avoids exposing stateful LMS private-key operations through an interface that
cannot enforce LMS leaf-use (one-time signature) state, even though wolfCrypt
itself supports LMS signing and key generation.

## Provider Architecture

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

ML-KEM, ML-DSA, and SLH-DSA keys support raw public and private key parameters
as well as DER and PEM encoding. Public keys use SubjectPublicKeyInfo and
private keys use PKCS#8. Encrypted PKCS#8 private key output is also supported.
The signature implementations expose the algorithm identifiers needed for
X.509 certificate and request operations. LMS instead uses OpenSSL's raw XDR
public-key representation and exposes no private key.

OpenSSL's LMS provider contract represents one LMS tree rather than a general
multi-level HSS hierarchy. Its raw public keys and signatures omit the
four-byte HSS level-count field. wolfProvider adds the required single-level
HSS wrapper only when calling wolfCrypt and removes it again at the OpenSSL
boundary, preserving OpenSSL-compatible bytes for applications.

## Sizes and Security Categories

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

## Signing and Generation Parameters

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

## Platform Optimizations

wolfProvider calls the native wolfCrypt implementations, so it benefits from
the optimized code selected by the wolfSSL build without requiring a separate
provider-specific acceleration layer. Available wolfCrypt PQC speedups include
x86-64 vectorized implementations and assembly paths for ARM32, AArch64,
ARMv7-M, and ARMv7E-M. Optimized SHA-2, SHA-3, and SHAKE operations also
accelerate the hash work used by ML-KEM, ML-DSA, SLH-DSA, and the configured
LMS parameter families.

The exact path is compiler, processor, and wolfSSL configuration dependent.
Applications should use the wolfCrypt benchmark on the target system to
confirm which implementation was selected and measure the relevant parameter
sets. See the wolfSSL
[PQC documentation](https://www.wolfssl.com/documentation/manuals/wolfssl/appendix09.html)
and [ML-KEM acceleration overview](https://www.wolfssl.com/accelerated-kyber-ml-kem/)
for configuration and benchmark details.

## Building

Post-quantum algorithms require OpenSSL 3.6 or later. Set `OPENSSL_TAG` to the latest patched OpenSSL 3.6.x release (not 3.6.0, which has known vulnerabilities) so the build does not use an outdated default:

The build script can configure OpenSSL, wolfSSL, and wolfProvider together:

```sh
OPENSSL_TAG=openssl-3.6.2 ./scripts/build-wolfprovider.sh --enable-pqc
```

`--enable-pqc` enables ML-KEM, ML-DSA and SLH-DSA. LMS remains an independent
option, and each family can also be selected separately:

```sh
./scripts/build-wolfprovider.sh --enable-mlkem
./scripts/build-wolfprovider.sh --enable-mldsa
./scripts/build-wolfprovider.sh --enable-slhdsa
./scripts/build-wolfprovider.sh --enable-lms
```

For a manual build, configure wolfSSL with the matching algorithm options,
then configure wolfProvider:

```sh
# In the wolfSSL source directory, add the required options to the
# normal wolfSSL configuration.
cd /path/to/wolfssl
./configure --enable-mlkem --enable-mldsa --enable-slhdsa=yes,sha2 \
    --enable-lms=verify-only,sha256-192,shake256
make
sudo make install

# In the wolfProvider source directory, configure against OpenSSL 3.6 or later.
cd /path/to/wolfProvider
./configure --enable-pqc --enable-lms \
    --with-openssl=/path/to/openssl \
    --with-wolfssl=/path/to/wolfssl
make
sudo make install
```

PQC code is not compiled unless `--enable-pqc` or an individual PQC option is
passed to wolfProvider, even when wolfSSL has the algorithms enabled.

Because wolfProvider only verifies LMS, build wolfSSL with
`--enable-lms=verify-only,sha256-192,shake256` so LMS signing and key generation
are left out of the build entirely rather than compiled and unused. The
`build-wolfprovider.sh --enable-lms` flow already configures wolfSSL this way.

## Using wolfProvider

For production deployments, the recommended configuration is replace-default
mode. It makes wolfProvider the OpenSSL default and prevents operations from
silently falling back to OpenSSL's built-in provider:

```sh
OPENSSL_TAG=openssl-3.6.2 ./scripts/build-wolfprovider.sh --replace-default \
    --enable-pqc --enable-lms
```

Applications may also load wolfProvider as a normal provider. This mode is
useful for interoperability and migration, but it does not guarantee that
every operation is handled by wolfProvider: OpenSSL can select its default
provider when wolfProvider does not implement an operation or when the
configuration is not applied.

Use the repository's provider configuration to load wolfProvider. The
configuration activates `libwolfprov`; point `OPENSSL_CONF` at that file:

```sh
export OPENSSL_CONF=/path/to/wolfProvider/provider.conf
```

If wolfProvider was installed outside OpenSSL's module search path, also set
`OPENSSL_MODULES` to the directory containing `libwolfprov.so`:

```sh
export OPENSSL_MODULES=/path/to/wolfprovider/lib
```

Run commands with the configuration active. Because this configuration
activates only `libwolfprov`, OpenSSL does not implicitly activate its own
default provider, so operations that wolfProvider does not support will fail
rather than silently falling back, unless an application also activates the
default provider (or unless replace-default mode is used):

```sh
OPENSSL_CONF=/path/to/wolfProvider/provider.conf \
    openssl list -kem-algorithms
OPENSSL_CONF=/path/to/wolfProvider/provider.conf \
    openssl list -signature-algorithms
```

## OpenSSL EVP Example

The maintained
[`examples/pqc_openssl_example.c`](https://github.com/wolfSSL/wolfProvider/blob/master/examples/pqc_openssl_example.c)
program demonstrates the three NIST FIPS 203 through FIPS 205 algorithm
families through the OpenSSL EVP API:

- ML-KEM-768 key generation, encapsulation, and decapsulation
- ML-DSA-65 key generation, signing, and verification
- SLH-DSA-SHA2-128f key generation, signing, and verification

The example is built (as a `noinst_PROGRAMS` target, not an Automake test)
when wolfProvider is configured with any PQC family; wolfProvider's CI runs it
as a separate step rather than as part of `make check`. Compile-time guards run
only the enabled families, so the same source also demonstrates ML-KEM-only,
ML-DSA-only, and SLH-DSA-only builds. After building, it can be run directly
from the wolfProvider root:

```sh
./examples/pqc_openssl_example
```

LMS is not part of this example because OpenSSL exposes only verification and
a useful example would require a fixed public key and signature. The
repository instead validates LMS with OpenSSL's 320 fixed verification vectors
and focused provider unit tests.

## Build Macros

The configure options add the corresponding request macros:

| Configure Option | wolfProvider Request Macro | wolfSSL Capability Macro |
| :--------------- | :------------------------- | :----------------------- |
| `--enable-mlkem` | `WOLFPROV_HAVE_MLKEM` | `WOLFSSL_HAVE_MLKEM` |
| `--enable-mldsa` | `WOLFPROV_HAVE_MLDSA` | `WOLFSSL_HAVE_MLDSA` |
| `--enable-slhdsa` | `WOLFPROV_HAVE_SLHDSA` | `WOLFSSL_HAVE_SLHDSA` |
| `--enable-lms` | `WOLFPROV_HAVE_LMS` | `WOLFSSL_HAVE_LMS` |

`--enable-pqc` enables ML-KEM, ML-DSA and SLH-DSA. LMS is enabled separately
with `--enable-lms`. After configuration validates the wolfSSL capabilities,
wolfProvider uses `WP_HAVE_MLKEM`, `WP_HAVE_MLDSA`, `WP_HAVE_SLHDSA`, and
`WP_HAVE_LMS` internally to compile and register the available implementations.

## TLS 1.3

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

## Validation

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

Validated FIPS and FIPS-Ready builds currently reject PQC (ML-KEM, ML-DSA,
SLH-DSA) and LMS: combining a FIPS or FIPS-Ready wolfSSL build with these
algorithms is not yet supported, pending the module-specific CAST integration.
Use PQC and LMS with non-FIPS wolfSSL builds only until that integration is
available. This restriction is enforced by `scripts/build-wolfprovider.sh`; a
hand-run `./configure` does not currently reject the combination, so use the
build script (or avoid the combination) for FIPS builds.

PQC has several independent test layers:

- Unit and example tests cover key generation, import/export, encoding,
  encapsulation, decapsulation, signing, verification, malformed inputs, and
  X.509 operations where applicable. LMS unit tests specifically cover raw
  public-key import/export, XDR decoding, selection handling, malformed input,
  and rejection of unsupported stateful operations.
- OpenSSL EVP known-answer tests run the ML-KEM, ML-DSA, SLH-DSA, and LMS vector
  files against wolfProvider. The LMS vector contains 320 verification cases.
- The PQC interoperability test compares wolfProvider with OpenSSL's default
  provider and the direct wolfSSL APIs. It also tests ML-KEM and hybrid TLS
  groups plus ML-DSA certificate authentication.
- The nginx OSP workflow tests ML-KEM and hybrid TLS 1.3 key exchange with
  ML-DSA authentication.
- The pinned libacvp (Cisco v2.3.1) OSP workflow builds wolfProvider with
  `--enable-pqc`, runs its `APP_PQC_HANDLER` group, and then its complete unit
  suite, exercising the OpenSSL ACVP handlers for ML-KEM and ML-DSA in both
  replace-default and non-replace modes.

The version, nginx, and libacvp matrices cover wolfSSL master and the latest
eligible stable release. OSP tests run in replace-default and non-replace
modes, with normal and forced-failure cases. PQC KAT and version coverage runs
for pull requests, while the longer OSP integration workflows are
label-selected and run nightly. The KAT matrix also includes an LMS-only row
in addition to the combined PQC configurations.

## Further Reading

For the current deployment model and complete build guidance, see the
[wolfProvider README](https://github.com/wolfSSL/wolfProvider/blob/master/README.md)
and the [wolfProvider Integration Guide](https://github.com/wolfSSL/wolfProvider/blob/master/docs/INTEGRATION_GUIDE.md).
The integration guide covers replace-default builds, provider configuration,
testing, and troubleshooting. For validated deployments, use the
[FIPS Integration Guide](https://github.com/wolfSSL/wolfProvider/blob/master/docs/FIPS_INTEGRATION_GUIDE.md),
which explains the replace-default requirements and security-policy considerations.

The repository's
[replace-default build workflow](https://github.com/wolfSSL/wolfProvider/blob/master/scripts/build-wolfprovider.sh),
[provider configuration](https://github.com/wolfSSL/wolfProvider/blob/master/provider.conf),
[PQC EVP example](https://github.com/wolfSSL/wolfProvider/blob/master/examples/pqc_openssl_example.c),
and [PQC KAT runner](https://github.com/wolfSSL/wolfProvider/blob/master/scripts/test-pqc-kat.sh)
are maintained alongside the implementation and provide the most current
examples of supported options and validation.
