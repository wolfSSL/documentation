# Experimenting with Post-Quantum Cryptography

A while back, the wolfSSL team integrated experimental post-quantum cryptographic algorithms into the wolfSSL library. This was done by integrating with the Open Quantum Safe team's liboqs. wolfCrypt now has its own implementations of ML-KEM, ML-DSA, SLH-DSA, Falcon, FrodoKEM and the stateful hash based schemes (LMS/HSS, XMSS/XMSS^MT), so the liboqs integration, and the older integrations with the hash-sigs (LMS/HSS) and xmss-reference (XMSS/XMSS^MT) libraries, were removed to keep the code base small and the library easier to maintain. As of wolfSSL 5.9.4 liboqs is not used for any algorithm, and the `--with-liboqs` configure option is deprecated and ignored.

This appendix is intended for anyone that wants to start learning about post-quantum cryptography in the context of (D)TLS 1.3. It explains why post-quantum algorithms are important, what we have done in response to the quantum threat and how you can start experimenting with these new algorithms. Notes that only apply to DTLS 1.3 are in [Post-Quantum Algorithms with DTLS](#post-quantum-algorithms-with-dtls).

**Note**: Some of the post-quantum algorithms are not fully standardized yet. Some OIDs and codepoints are temporary and expected to change in the future. You should have no expectation of backwards compatibility until they are fully standardized.

## A Gentle Introduction to Post-Quantum Cryptography

### Why Post-Quantum Cryptography?

For some time now, many resources have been devoted to the development of quantum computers. So much so that commercialization of cloud quantum computing resources has already begun. While the current state of the art is still not in the realm of being cryptographically relevant, some threat models such as "harvest now, decrypt later" mean that preparations need to happen sooner than the appearance of cryptographically relevant quantum computers.

NIST is leading the way for standardization of a new class of algorithms designed to replace the public key cryptography algorithms that will become vulnerable to quantum computers. At the time of the writing of this passage, NIST has already standardized ML-DSA, ML-KEM, and SLH-DSA. Falcon is being standardized as FN-DSA (FIPS 206), which is still a draft, so wolfSSL treats Falcon as experimental.

ML-KEM (Module Lattice Key Encapsulation Mechanism) is a NIST-standardized, lattice-based post-quantum algorithm derived from Kyber. It enables two parties to establish a shared key over an insecure channel using a key encapsulation mechanism, protecting against both classical and quantum adversaries.

ML-DSA (Module Lattice Digital Signature Algorithm) is a NIST-standardized, lattice-based post-quantum digital signature scheme derived from Dilithium. It enables a sender to produce a verifiable signature that proves the origin and integrity of a message.

Both ML-KEM and ML-DSA are public-key algorithms designed to resist cryptographically relevant quantum computers. They are part of NIST's Post-Quantum Cryptography standards (FIPS 203 and FIPS 204) and can be deployed today, often in hybrid form, to prepare for the post-quantum era.

The algorithms themselves are now NIST standards: ML-KEM, ML-DSA and SLH-DSA in FIPS 203, FIPS 204 and FIPS 205, and the stateful hash-based schemes LMS and XMSS in NIST SP 800-208. wolfSSL's upcoming post-quantum FIPS submission covers ML-KEM, ML-DSA, LMS, XMSS and SLH-DSA. What is not final yet is their use in TLS: the codepoints of the ML-KEM groups come from the IETF drafts draft-ietf-tls-mlkem (pure ML-KEM) and draft-ietf-tls-ecdhe-mlkem (hybrids), and those of the SLH-DSA signature schemes from draft-reddy-tls-slhdsa.

### How do we Protect Ourselves?

From a high level perspective, for every TLS 1.3 connection, authentication, integrity and confidentiality are the main security goals that protect each connection. Authentication is maintained via signature schemes such as ECDSA. Confidentiality and integrity are maintained by key establishment algorithms such as ECDHE and then using the established key with symmetric encryption algorithms such as AES to encrypt a communication stream. We can thus decompose the security of the TLS 1.3 protocol into 3 types of cryptographic algorithms:

* authentication algorithms
* key establishment algorithms
* symmetric cipher algorithms

The threat of quantum computers to conventional cryptography takes two forms. Grover's algorithm reduces the security of modern symmetric cipher algorithms by approximately half while Shor's algorithm completely breaks the security of modern authentication and key establishment algorithms. As a result, we can continue to protect our communications using the AES-256 symmetric cipher which is considered sufficiently secure even in the presence of a cryptographically relevant quantum computer. We can then replace our conventional authentication and key establishment algorithms with post-quantum algorithms. Note that during TLS 1.3 handshakes, the ciphersuite specifies the symmetric cipher to be used for the duration of the connection. Both CNSA (Commercial National Security Algorithm Suite) 1.0 and 2.0 prescribe using the AES_256_GCM_SHA384 ciphersuite. For key establishment and authentication, there are post-quantum KEMs (Key Encapsulation Mechanisms) and signature schemes.

These use different kinds of math from the conventional algorithms. They are designed specifically for resistance to quantum-computers. The main signature scheme and KEM that NIST has standardized for use with network protocols are lattice-based algorithms; SLH-DSA (FIPS 205) is a hash-based alternative for signatures.

* ML-DSA (Dilithium) Signature Scheme
* ML-KEM (KYBER) KEM

**Note**: SABER KEM and NTRU KEM were deprecated and removed as they did not
          move on to standardization.

**Note**: KYBER KEM 90s variants were deprecated and removed as NIST is not
          considering them for standardization.

**Note**: Dilithium Signature Scheme's AES variants were deprecated and removed
          as NIST is not considering them for standardization.

**Note**: SPHINCS+, which wolfSSL used to take from liboqs, has been replaced
          by the native SLH-DSA (FIPS 205) implementation, enabled with
          [`--enable-slhdsa`](chapter02.md#--enable-slhdsa). Falcon used liboqs until wolfSSL 5.9.4, which
          replaced it with a native implementation of levels 1 and 5,
          enabled with `--enable-experimental --enable-falcon`. FrodoKEM,
          a key encapsulation mechanism, is available too with
          `--enable-experimental --enable-frodokem`.

Besides ML-KEM and ML-DSA, wolfSSL also supports these post-quantum algorithms:

* the SLH-DSA (FIPS 205) signature scheme in all twelve parameter sets. `--enable-slhdsa` builds the six SHAKE parameter sets; `--enable-slhdsa=yes,sha2` adds the six SHA2 parameter sets. SLH-DSA can sign TLS 1.3 and DTLS 1.3 handshakes per draft-reddy-tls-slhdsa; the code points are listed in [Appendix G](appendix07.md#c-9-slh-dsa-fips-205).
* the Falcon signature scheme (levels 1 and 5, experimental), native to wolfCrypt with crypto callbacks and ARM DSP / AArch64 NEON acceleration.
* the FrodoKEM key encapsulation mechanism (wolfCrypt only, experimental).
* the stateful hash based signature schemes LMS/HSS and XMSS/XMSS^MT, covered later in this appendix.

As of wolfSSL 5.9.4 you can also build TLS 1.3 with nothing but post-quantum algorithms: ML-KEM for the key exchange, ML-DSA or SLH-DSA for authentication, and no RSA, ECC or DH. [`--enable-all-quantum-crypto`](chapter02.md#--enable-all-quantum-crypto) turns on ML-KEM, ML-DSA, LMS, XMSS and SLH-DSA (both the SHAKE and the SHA2 parameter sets) in one go. Together with `--enable-experimental` it also turns on Falcon, FrodoKEM and the extra PQ/T hybrid groups. It does not enable the pure ML-KEM TLS groups (`--enable-tls-mlkem-standalone`).

An explanation of lattice-based cryptography would fall outside the scope of this document but more information about these algorithms can be found in their standards: FIPS 203 (<https://csrc.nist.gov/pubs/fips/203/final>), FIPS 204 (<https://csrc.nist.gov/pubs/fips/204/final>) and FIPS 205 (<https://csrc.nist.gov/pubs/fips/205/final>).

Unfortunately, it might come as a shock, but we do not actually know that these algorithms will resist attacks from quantum computers. In fact, we do not even know that these algorithms are safe against a conventional computer. It's getting less and less likely, but someone could break lattice-based cryptography. However, as security experts will tell you, this is how cryptography has always worked. Algorithms are good when we start using them, but weaknesses and vulnerabilities are discovered and technology gets better. The post-quantum algorithms are somewhat problematic in that they are relatively new and could use a bit more attention from the community.

One solution is to not put our full faith into these new algorithms. For now, we can hedge our bets by hybridizing post-quantum algorithms with the conventional algorithms that we actually trust. ECC with NIST standardized curves seems like a good candidate as we have to keep using them since FIPS 140-3 compliance is a priority. For this reason, we have not only implemented post-quantum KEMs but also hybridized them with ECDH over NIST approved curves (SecP256r1MLKEM768 and SecP384r1MLKEM1024). wolfSSL also supports the X25519 hybrid X25519MLKEM768, which is the default ClientHello key share when Curve25519 is enabled because it is the hybrid that servers are most likely to accept. Please see our list of hybrid groups below.

## Getting Started with Post-Quantum algorithms in wolfSSL

The following instructions will get you started from a clean Linux development environment and lead you step by step to performing a quantum-safe TLS 1.3 connection.

### Build Instructions

None of the post-quantum algorithms need an external library; they all build from the wolfSSL sources. A typical configuration is:

```sh
./configure --enable-mlkem --enable-mldsa --enable-slhdsa=yes,sha2
```

For the experimental algorithms, add `--enable-experimental --enable-falcon` or `--enable-experimental --enable-frodokem`. Those two options take sub-options as well; see [`--enable-falcon`](chapter02.md#--enable-falcon) and [`--enable-frodokem`](chapter02.md#--enable-frodokem).

Item 15 of the wolfSSL repo's INSTALL file (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL) covers the same ground, but it uses the older option names `--enable-kyber` and `--enable-dilithium` (aliases for `--enable-mlkem` and [`--enable-mldsa`](chapter02.md#--enable-mldsa)) and the SecP521r1MLKEM1024 group, which needs `--enable-experimental --enable-extra-pqc-hybrids`.

#### What Is Enabled by Default

* ML-KEM is enabled by default, unless SHA-3 or SHAKE is disabled. `--enable-mlkem` is only needed to pass sub-options, and [`--disable-mlkem`](chapter02.md#--disable-mlkem) turns ML-KEM off.
* The standard PQ/T hybrid groups SecP256r1MLKEM768, SecP384r1MLKEM1024 and X25519MLKEM768 come with [`--enable-pqc-hybrids`](chapter02.md#--disable-pqc-hybrids), which is on by default. X25519MLKEM768 also needs [`--enable-curve25519`](chapter02.md#--enable-curve25519), which is off by default.
* The pure ML-KEM groups ML_KEM_512, ML_KEM_768 and ML_KEM_1024 need [`--enable-tls-mlkem-standalone`](chapter02.md#--enable-tls-mlkem-standalone). The configure script only turns it on by itself when the build has no ECC, Curve25519 or Curve448 to make hybrids with.
* The extra hybrid groups SecP256r1MLKEM512, SecP384r1MLKEM768, SecP521r1MLKEM1024, X25519MLKEM512 and X448MLKEM768 need `--enable-experimental --enable-extra-pqc-hybrids`. They are not available in FIPS v7 builds.
* The round 3 Kyber groups need `--enable-mlkem=yes,original` (Kyber instead of ML-KEM) or `--enable-mlkem=yes,all` (Kyber and ML-KEM). Keep `yes` in the list: without it no Kyber or ML-KEM parameter set is built.
* If the application does not configure any groups, a wolfSSL client sends an X25519MLKEM768 key share when Curve25519 is built in, and a SecP256r1MLKEM768 key share otherwise.
* ML-DSA, SLH-DSA, LMS and XMSS are off by default. Falcon and FrodoKEM also need `--enable-experimental`.

[Appendix G](appendix07.md#b-7-ml-kem-standalone) lists all of these groups with their code points: [B-7 ML-KEM Standalone](appendix07.md#b-7-ml-kem-standalone), [B-8 ML-KEM Hybrid (Standard)](appendix07.md#b-8-ml-kem-hybrid-standard), [B-9 ML-KEM Hybrid (Experimental)](appendix07.md#b-9-ml-kem-hybrid-experimental) and [B-10 Kyber Round 3 Legacy](appendix07.md#b-10-kyber-round-3-legacy).

#### Post-Quantum Test Certificates

You do not need any extra tools to try out post-quantum authentication: the wolfSSL source tree has ready-made test certificates and keys. `certs/mldsa/` has ML-DSA certificates, including an ML-DSA-87 CA (`mldsa87-ca-cert.pem`) with an ML-DSA-65 leaf certificate (`mldsa65-leaf87ca-cert.pem`). `certs/slhdsa/` has SLH-DSA root certificates with ML-DSA-44 and SLH-DSA server and client certificates. They were generated with OpenSSL 3.5 or later, which can create ML-DSA and SLH-DSA keys and certificates natively. Older ML-DSA certificate chains made with the OQS provider, and the instructions for making them, are in the wolfSSL OSP repository: https://github.com/wolfSSL/osp/tree/master/oqs/README.md.

### Making a Quantum Safe TLS Connection

You can run the server and client like this in separate terminals, from the root of the wolfSSL source tree:

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa/mldsa87-ca-cert.pem \
      -c certs/mldsa/mldsa65-leaf87ca-cert.pem \
      -k certs/mldsa/mldsa65-leaf87ca-key.pem \
      --pqc SecP384r1MLKEM1024
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/mldsa/mldsa87-ca-cert.pem \
      -c certs/mldsa/mldsa65-leaf87ca-cert.pem \
      -k certs/mldsa/mldsa65-leaf87ca-key.pem \
      --pqc SecP384r1MLKEM1024
```

Both sides print `SSL curve name is SecP384r1MLKEM1024`, and the client prints the server's reply, `I hear you fa shizzle!`. You have just achieved a fully quantum-safe TLS 1.3 connection using AES-256 for symmetric encryption, the ML-DSA signature scheme for authentication and ECDHE hybridized with ML-KEM for key establishment. Both peers authenticate with the same ML-DSA-65 certificate, issued by the ML-DSA-87 CA.

To authenticate with SLH-DSA instead, use the SLH-DSA certificates, which have separate server and client certificates issued by an SLH-DSA-SHAKE-128s root:

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/slhdsa/root-slhdsa-shake-128s.pem \
      -c certs/slhdsa/server-slhdsa-shake-128s.pem \
      -k certs/slhdsa/server-slhdsa-shake-128s-priv.pem \
      --pqc SecP384r1MLKEM1024
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A certs/slhdsa/root-slhdsa-shake-128s.pem \
      -c certs/slhdsa/client-slhdsa-shake-128s.pem \
      -k certs/slhdsa/client-slhdsa-shake-128s-priv.pem \
      --pqc SecP384r1MLKEM1024
```

`--pqc` takes one of the group names listed in [Post Quantum Algorithm Variant Names](#post-quantum-algorithm-variant-names). The `-?` help of the examples lists every group name whatever the build, and a group that is not compiled in fails with `invalid post-quantum KEM specified`. For example, X25519MLKEM768 needs `--enable-curve25519`, and SecP521r1MLKEM1024 needs `--enable-experimental --enable-extra-pqc-hybrids`. Without `--pqc` the example client sends only classical key shares (P-256, and FFDHE 2048 when it is built in), so it does not show the library's default hybrid key share (see [Developer Notes](#developer-notes)).

Further information about other post-quantum examples can be found at https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md.

### Post-Quantum Algorithms with DTLS

The same groups and certificates work for DTLS 1.3. Configure wolfSSL with [`--enable-dtls13`](chapter02.md#--enable-dtls13) as well, and add `-u` to the example server and client commands above. ML-KEM key shares can make a ClientHello bigger than a single datagram, so when ML-KEM and DTLS 1.3 are both enabled, configure also turns on DTLS 1.3 ClientHello fragmentation (`--enable-dtls-frag-ch`, `WOLFSSL_DTLS_CH_FRAG`). If its first ClientHello would have to be fragmented, a wolfSSL client sends it with an empty key share. The server answers with a HelloRetryRequest, and the client sends its key share in the second ClientHello, which may be fragmented. The server has to allow fragmented ClientHellos with `wolfSSL_dtls13_allow_ch_frag()`; in builds with ML-KEM this is the default. A DTLS 1.3 server with cookies disabled can also process a fragmented first ClientHello, but only while `wolfSSL_dtls13_allow_ch_frag()` is on.

## Post Quantum Algorithm Variant Names

Post-Quantum algorithm variant names:

NIST Security Level   |  Algorithm    |  wolfCrypt identifier  |  TLS group name
--------------------  |  -----------  |  --------------------  |  ---------------
2                     |  ML-DSA-44    |  `WC_ML_DSA_44`        |  n/a
3                     |  ML-DSA-65    |  `WC_ML_DSA_65`        |  n/a
5                     |  ML-DSA-87    |  `WC_ML_DSA_87`        |  n/a
1                     |  ML-KEM-512   |  `WC_ML_KEM_512`       |  `ML_KEM_512`
3                     |  ML-KEM-768   |  `WC_ML_KEM_768`       |  `ML_KEM_768`
5                     |  ML-KEM-1024  |  `WC_ML_KEM_1024`      |  `ML_KEM_1024`

The wolfCrypt identifiers select the parameter set, for example with `wc_MlDsaKey_SetParams()` and `wc_MlKemKey_Init()`. The TLS group names are what you pass to `--pqc` in the example client and server, and to `wolfSSL_CTX_set1_groups_list()` / `wolfSSL_set1_groups_list()`, which also accept `MLKEM512`, `MLKEM768` and `MLKEM1024`. The pure ML-KEM groups need `--enable-tls-mlkem-standalone`.

Post-Quantum hybrid KEM names. Each hybrid combines ECDH key agreement on the named curve with ML-KEM (FIPS 203):

wolfSSL Group Name    |  Code Point  |  Combination                |  configure Options
--------------------  |  ----------  |  -------------------------  |  -----------------
`SecP256r1MLKEM768`   |  4587        |  ECDH P-256 + ML-KEM-768    |  Default
`X25519MLKEM768`      |  4588        |  X25519 + ML-KEM-768        |  Default, needs `--enable-curve25519`
`SecP384r1MLKEM1024`  |  4589        |  ECDH P-384 + ML-KEM-1024   |  Default
`SecP256r1MLKEM512`   |  12107       |  ECDH P-256 + ML-KEM-512    |  `--enable-experimental --enable-extra-pqc-hybrids`
`SecP384r1MLKEM768`   |  12108       |  ECDH P-384 + ML-KEM-768    |  `--enable-experimental --enable-extra-pqc-hybrids`
`SecP521r1MLKEM1024`  |  12109       |  ECDH P-521 + ML-KEM-1024   |  `--enable-experimental --enable-extra-pqc-hybrids`
`X25519MLKEM512`      |  12214       |  X25519 + ML-KEM-512        |  As above, plus `--enable-curve25519`
`X448MLKEM768`        |  12215       |  X448 + ML-KEM-768          |  As above, plus `--enable-curve448`

The default hybrids use the code points of draft-ietf-tls-ecdhe-mlkem; the extra hybrids use code points from the Open Quantum Safe provider. See also [Appendix G](appendix07.md#b-8-ml-kem-hybrid-standard).

## Cryptographic Artifact Sizes

All sizes are in bytes.

Post-Quantum Signature Scheme Artifact Sizes:

Parameter Set    | Public Key Size | Private Key Size | Maximum Signature Size
---------------- | --------------- | ---------------- | ----------------------
ML-DSA-44        | 1312            | 2560             | 2420
ML-DSA-65        | 1952            | 4032             | 3309
ML-DSA-87        | 2592            | 4896             | 4627
Falcon level 1   | 897             | 1281             | 666
Falcon level 5   | 1793            | 2305             | 1280

SLH-DSA Artifact Sizes (the SHA2 and SHAKE variants of a parameter set have the same sizes):

Parameter Set    | Public Key Size | Private Key Size | Signature Size
---------------- | --------------- | ---------------- | --------------
SLH-DSA-128s     | 32              | 64               | 7856
SLH-DSA-128f     | 32              | 64               | 17088
SLH-DSA-192s     | 48              | 96               | 16224
SLH-DSA-192f     | 48              | 96               | 35664
SLH-DSA-256s     | 64              | 128              | 29792
SLH-DSA-256f     | 64              | 128              | 49856

Post-Quantum KEM Artifact Sizes:

Parameter Set    | Public Key Size | Private Key Size | Ciphertext Size | Shared Secret Size
---------------- | --------------- | ---------------- | --------------- | ------------------
ML-KEM-512       | 800             | 1632             | 768             | 32
ML-KEM-768       | 1184            | 2400             | 1088            | 32
ML-KEM-1024      | 1568            | 3168             | 1568            | 32

The sizes of the LMS/HSS and XMSS/XMSS^MT keys and signatures are in [Post-Quantum Stateful Hash-Based Signatures](#post-quantum-stateful-hash-based-signatures).

## Statistics

The following statistics and benchmarks were taken with wolfSSL 5.9.4 (master branch, November 2026) on an Apple M5 (4 performance and 6 efficiency cores) running macOS 27.2, built with Apple clang 21.

wolfSSL:

```text
./configure --enable-mlkem \
            --enable-mldsa \
            --enable-tls-mlkem-standalone \
            --enable-experimental \
            --enable-extra-pqc-hybrids \
            --enable-curve25519 \
            --disable-psk \
            --disable-shared \
            --enable-armasm \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```

**Note**: We are primarily benchmarking the post-quantum algorithms, but leave some conventional algorithms for comparison purposes. The pure ML-KEM groups and the extra hybrids are enabled so that they can be measured too.

### Runtime Binary Sizes

The `tls_bench` example application binary file is 2507328 bytes after being built then stripped (Approximately 2.4M). With `--disable-mlkem` instead of `--enable-mlkem`, and without `--enable-mldsa`, `--enable-tls-mlkem-standalone`, `--enable-experimental` and `--enable-extra-pqc-hybrids`, it is 2273088 bytes after being built then stripped (Approximately 2.2M). This is a difference of 234240 bytes (Approximately 229K).

### TLS 1.3 Data Transmission Sizes

The following results were taken by running the example server and client and counting all the TCP payload bytes sent in both directions (the same as summing the `tcp.len` of all packets in Wireshark). This includes the TLS 1.3 handshake with mutual authentication, "hello wolfssl!" and "I hear you fa shizzle!" messages. Both peers use the same kind of certificate: the RSA rows use the examples' default certificates, and the ML-DSA rows use the self-signed `certs/mldsa/mldsa<N>-cert.pem` and `certs/mldsa/mldsa<N>-key.pem` on both sides. For example:

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 --pqc ML_KEM_768
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 --pqc ML_KEM_768
```

For the ML-DSA rows, `-A certs/mldsa/mldsa44-cert.pem -c certs/mldsa/mldsa44-cert.pem -k certs/mldsa/mldsa44-key.pem` (or the 65 or 87 files) was added to both commands. For the rows without `--pqc`, the client was run with `-Y` so that it sends only a P-256 key share (by default it also sends an FFDHE 2048 key share). The ClientHello lists every group the build supports, so a build with fewer groups sends slightly less data.

Ciphersuite            | Authentication       | Key Establishment     | Total Bytes
---------------------- | -------------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ECC SECP256R1         | 5230
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_512            | 6668
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_768            | 7372
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_1024           | 8236
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP256r1MLKEM768     | 7502
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | X25519MLKEM768        | 7436
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP384r1MLKEM1024    | 8430
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP256r1MLKEM512     | 6798
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP384r1MLKEM768     | 7566
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP521r1MLKEM1024    | 8502
TLS_AES_256_GCM_SHA384 | ML-DSA-44            | ECC SECP256R1         | 13918
TLS_AES_256_GCM_SHA384 | ML-DSA-44            | SecP384r1MLKEM1024    | 17118
TLS_AES_256_GCM_SHA384 | ML-DSA-65            | ECC SECP256R1         | 18754
TLS_AES_256_GCM_SHA384 | ML-DSA-65            | SecP384r1MLKEM1024    | 21954
TLS_AES_256_GCM_SHA384 | ML-DSA-87            | ECC SECP256R1         | 25306
TLS_AES_256_GCM_SHA384 | ML-DSA-87            | SecP384r1MLKEM1024    | 28506

The ML_KEM_* rows need `--enable-tls-mlkem-standalone`, the SecP256r1MLKEM512, SecP384r1MLKEM768 and SecP521r1MLKEM1024 rows need `--enable-experimental --enable-extra-pqc-hybrids`, and the X25519MLKEM768 row needs `--enable-curve25519`.

### Heap and Stack Usage

These statistics were obtained by adding the following configuration flags: `--enable-trackmemory --enable-stacksize`. The example server and client then run in a thread whose stack use is measured, and print the stack used and the heap use between wolfSSL initialization and cleanup: the number of allocations, the total number of bytes allocated and the peak number of bytes in use at any one time. The figures include loading the certificates and keys, and they change with the build options.

Memory use for server sign and client verify without server authentication of the client, TLS_AES_256_GCM_SHA384 ciphersuite and ECC SECP256R1 for key exchange. The server was run with `-d`, and the client with `-x` so that it loads no certificate of its own and with `-Y` so that it sends only a P-256 key share. The ECDSA rows use `certs/server-ecc.pem`, and the ML-DSA rows the self-signed `certs/mldsa/mldsa<N>-cert.pem`.

Authentication   | Side   | Stack Used | Allocations | Heap Total | Heap Peak
---------------- | ------ | ---------- | ----------- | ---------- | ---------
RSA 2048         | Server | 14064      | 53          | 56373      | 22214
RSA 2048         | Client | 16056      | 66          | 59229      | 20745
ECDSA P-256      | Server | 14064      | 47          | 29455      | 16106
ECDSA P-256      | Client | 16056      | 50          | 31522      | 14290
ML-DSA-44        | Server | 14064      | 52          | 170031     | 78217
ML-DSA-44        | Client | 16056      | 52          | 114087     | 53314
ML-DSA-65        | Server | 14064      | 52          | 247775     | 110817
ML-DSA-65        | Client | 16056      | 52          | 160841     | 75579
ML-DSA-87        | Server | 14064      | 52          | 367873     | 158962
ML-DSA-87        | Client | 16056      | 52          | 236231     | 111585

Memory use for KEM groups. TLS_AES_256_GCM_SHA384 ciphersuite and RSA-2048 for client authentication of the server and without server authentication of the client. The server was run with `-d` and the client with `-x`. The group was selected with `--pqc <group>` on both sides (`-t` for X25519, and `-Y` on the client for SECP256R1).

Key Establishment  | Side   | Stack Used | Allocations | Heap Total | Heap Peak
------------------ | ------ | ---------- | ----------- | ---------- | ---------
ECC SECP256R1      | Server | 14064      | 53          | 56373      | 22214
ECC SECP256R1      | Client | 16056      | 66          | 59229      | 20745
ECC X25519         | Server | 13320      | 54          | 48101      | 22181
ECC X25519         | Client | 16056      | 66          | 50881      | 20712
ML_KEM_512         | Server | 13320      | 54          | 62613      | 25854
ML_KEM_512         | Client | 16056      | 70          | 72401      | 23112
ML_KEM_768         | Server | 13320      | 54          | 68117      | 31038
ML_KEM_768         | Client | 16056      | 70          | 82577      | 28765
ML_KEM_1024        | Server | 13320      | 54          | 74965      | 37406
ML_KEM_1024        | Client | 16056      | 70          | 95281      | 36477
SecP256r1MLKEM768  | Server | 14832      | 61          | 78171      | 32546
SecP256r1MLKEM768  | Client | 16056      | 80          | 93975      | 30208
X25519MLKEM768     | Server | 13320      | 61          | 69781      | 32414
X25519MLKEM768     | Client | 16056      | 80          | 85585      | 30109
SecP384r1MLKEM1024 | Server | 18544      | 61          | 85691      | 39522
SecP384r1MLKEM1024 | Client | 19376      | 80          | 107735     | 38496
SecP256r1MLKEM512  | Server | 14832      | 61          | 72347      | 28099
SecP256r1MLKEM512  | Client | 16056      | 80          | 83095      | 24737
SecP384r1MLKEM768  | Server | 18544      | 61          | 78363      | 32674
SecP384r1MLKEM768  | Client | 19376      | 80          | 94167      | 30304
SecP521r1MLKEM1024 | Server | 24032      | 61          | 85907      | 39666
SecP521r1MLKEM1024 | Client | 24864      | 80          | 107951     | 38604

### Benchmarks

The following benchmarks were obtained with the configuration flags shown at the start of [Statistics](#statistics).

#### Benchmarks from wolfCrypt

**Note**: Only a single core is used. `-ecc` measures P-256 only; `-ecc-all`, `-p384` and `-p521` measure other curves. `-ml-kem-512`, `-ml-dsa-44` and so on select a single parameter set, and `-slhdsa`, `-falcon_level1`, `-falcon_level5`, `-lms_hss` and `-xmss_xmssmt` measure the other post-quantum algorithms when they are built in. On AArch64 the "Cycles" figures are counted with the system timer (its frequency is printed as "Clock frequency"), not in CPU core cycles.

```text
./wolfcrypt/benchmark/benchmark -ecc -x25519 -ml-kem -ml-dsa
------------------------------------------------------------------------------
 wolfSSL version 5.9.4
------------------------------------------------------------------------------
CPU: Aarch64 - aes pmull sha256 sha512 rdm sha3
Clock frequency: 1000000000 Hz
Math: 	Multi-Precision: Wolf(SP) no-dyn-stack word-size=64 bits=4096 sp_int.c
	Single Precision: ecc 256 384 521 rsa/dh 2048 3072 4096 asm sp_arm64.c
	Assembly Speedups: ARMASM ALIGN
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
ML-KEM 512    128  key gen    416000 ops took 1.000 sec, avg 0.002 ms, 415934.748 ops/sec, 1000151922 cycles     2404.2 Cycles/op
ML-KEM 512    128    encap    364000 ops took 1.000 sec, avg 0.003 ms, 363971.971 ops/sec, 1000072762 cycles     2747.5 Cycles/op
ML-KEM 512    128    decap    244200 ops took 1.000 sec, avg 0.004 ms, 244189.521 ops/sec, 1000038535 cycles     4095.2 Cycles/op
ML-KEM 768    192  key gen    293000 ops took 1.000 sec, avg 0.003 ms, 292985.051 ops/sec, 1000045870 cycles     3413.1 Cycles/op
ML-KEM 768    192    encap    244100 ops took 1.000 sec, avg 0.004 ms, 244013.374 ops/sec, 1000350401 cycles     4098.1 Cycles/op
ML-KEM 768    192    decap    167000 ops took 1.000 sec, avg 0.006 ms, 166981.129 ops/sec, 1000109070 cycles     5988.7 Cycles/op
ML-KEM 1024   256  key gen    171900 ops took 1.000 sec, avg 0.006 ms, 171855.298 ops/sec, 1000255617 cycles     5818.8 Cycles/op
ML-KEM 1024   256    encap    152200 ops took 1.000 sec, avg 0.007 ms, 152125.140 ops/sec, 1000488156 cycles     6573.5 Cycles/op
ML-KEM 1024   256    decap    111200 ops took 1.000 sec, avg 0.009 ms, 111160.087 ops/sec, 1000354818 cycles     8996.0 Cycles/op
ECDHE [      SECP256R1]   256    agree     37200 ops took 1.001 sec, avg 0.027 ms, 37161.574 ops/sec, 1001029139 cycles    26909.4 Cycles/op
ECDSA [      SECP256R1]   256     sign     91900 ops took 1.000 sec, avg 0.011 ms, 91856.375 ops/sec, 1000471181 cycles    10886.5 Cycles/op
ECDSA [      SECP256R1]   256   verify     34900 ops took 1.001 sec, avg 0.029 ms, 34861.343 ops/sec, 1001104424 cycles    28684.9 Cycles/op
CURVE  25519    agree     66500 ops took 1.001 sec, avg 0.015 ms, 66458.866 ops/sec, 1000614019 cycles    15046.8 Cycles/op
ML-DSA    44  key gen     97300 ops took 1.000 sec, avg 0.010 ms, 97285.387 ops/sec, 1000145962 cycles    10279.0 Cycles/op
ML-DSA    44     sign     32300 ops took 1.001 sec, avg 0.031 ms, 32263.539 ops/sec, 1001125275 cycles    30994.6 Cycles/op
ML-DSA    44   verify     94500 ops took 1.001 sec, avg 0.011 ms, 94446.363 ops/sec, 1000563608 cycles    10588.0 Cycles/op
ML-DSA    65  key gen     57300 ops took 1.000 sec, avg 0.017 ms, 57272.567 ops/sec, 1000474781 cycles    17460.3 Cycles/op
ML-DSA    65     sign     22000 ops took 1.002 sec, avg 0.046 ms, 21957.444 ops/sec, 1001934023 cycles    45542.5 Cycles/op
ML-DSA    65   verify     61300 ops took 1.001 sec, avg 0.016 ms, 61249.897 ops/sec, 1000813141 cycles    16326.5 Cycles/op
ML-DSA    87  key gen     37600 ops took 1.001 sec, avg 0.027 ms, 37576.295 ops/sec, 1000626661 cycles    26612.4 Cycles/op
ML-DSA    87     sign     17600 ops took 1.005 sec, avg 0.057 ms, 17512.228 ops/sec, 1005007883 cycles    57102.7 Cycles/op
ML-DSA    87   verify     37800 ops took 1.002 sec, avg 0.027 ms, 37712.765 ops/sec, 1002308693 cycles    26516.1 Cycles/op
Benchmark complete
```

#### Benchmarks from wolfSSL

`tls_bench` was run with `-g`, which runs the benchmark once for every TLS 1.3 group the build supports, and `-t 2` to run each test for 2 seconds:

```sh
./examples/benchmark/tls_bench -g -l TLS13-AES256-GCM-SHA384 -t 2
```

**Note**: Only two cores are used for these benchmarks: `tls_bench` runs one server thread and one client thread. The server authenticates with an RSA 2048-bit certificate, and the client is not authenticated.

The table shows the average time to complete a handshake ("Connect Avg") reported by each side. `tls_bench` prints the first group it runs, ECC_SECP256R1 here, as "N/A".

Group               | Server Connect Avg (ms) | Client Connect Avg (ms)
------------------- | ----------------------- | -----------------------
ECC_SECP256R1       | 0.508                   | 0.489
ECC_SECP384R1       | 0.590                   | 0.571
ECC_SECP521R1       | 0.667                   | 0.651
ECC_X25519          | 0.502                   | 0.481
FFDHE_2048          | 0.785                   | 0.766
ML_KEM_512          | 0.500                   | 0.475
ML_KEM_768          | 0.502                   | 0.476
ML_KEM_1024         | 0.513                   | 0.484
SecP256r1MLKEM768   | 0.523                   | 0.495
SecP384r1MLKEM1024  | 0.619                   | 0.574
X25519MLKEM768      | 0.530                   | 0.500
SecP256r1MLKEM512   | 0.546                   | 0.513
SecP384r1MLKEM768   | 0.655                   | 0.602
SecP521r1MLKEM1024  | 0.778                   | 0.703
X25519MLKEM512      | 0.531                   | 0.501

## Documentation

The standards can be found at the NIST website:

- ML-KEM, FIPS 203: <https://csrc.nist.gov/pubs/fips/203/final>
- ML-DSA, FIPS 204: <https://csrc.nist.gov/pubs/fips/204/final>
- SLH-DSA, FIPS 205: <https://csrc.nist.gov/pubs/fips/205/final>
- LMS and XMSS, NIST SP 800-208: <https://csrc.nist.gov/pubs/sp/800/208/final>

To measure the algorithms on your own hardware, use the wolfCrypt benchmark as shown in [Benchmarks](#benchmarks).

## Post-Quantum Stateful Hash-Based Signatures

This section covers the post-quantum stateful hash-based signature (HBS) schemes LMS/HSS and XMSS/XMSS^MT. wolfCrypt has native implementations of both. Since wolfSSL 5.9.2 they can also be used in X.509 certificates (RFC 9802): wolfSSL verifies certificates signed with HSS/LMS or XMSS/XMSS^MT, and it can generate such certificates and certificate signing requests. They are not available as TLS handshake signature algorithms.

### Motivation

Stateful HBS schemes are of growing interest for a number of reasons.
The primary motivation for stateful HBS schemes is post-quantum security. As discussed previously in this appendix, Shor's algorithm would allow a quantum computer to efficiently factorize large integers and compute discrete logarithms, thus completely breaking public-key cryptography schemes such as RSA and ECC.

In contrast, stateful HBS schemes are founded on the security of their underlying hash functions and Merkle trees (typically implemented with SHA256), which are not expected to be broken by the advent of cryptographically relevant quantum computers. For these reasons they have been recommended by NIST SP 800-208 and the NSA's CNSA 2.0 suite. See these two links for more info:

- <https://csrc.nist.gov/publications/detail/sp/800-208/final>
- <https://media.defense.gov/2022/Sep/07/2003071834/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF>

Furthermore, the CNSA 2.0 timeline has specified that post-quantum stateful HBS schemes should be used exclusively by 2030, and adoption should begin _immediately_. In fact, adoption of LMS is the earliest requirement in the CNSA 2.0 suite timeline.

However, the nature of stateful HBS schemes requires that significant care is given to their use and tracking their state. In a stateful HBS system, the private key is actually a finite set of one-time signature (OTS) keys, which may never be reused. If the same OTS key were used to sign two different messages, it would be possible for an attacker to fabricate signatures, and the security of the entire scheme would unravel. Therefore, stateful HBS schemes are not suitable for general use such as the public internet.

Instead, because of these unique strengths and characteristics, and NIST and NSA backing, stateful HBS schemes such as LMS/HSS are of particular interest for offline firmware authentication and signature verification, especially on embedded or constrained systems that are expected to have a long operational lifetime and thus need to be resilient against a cryptographically relevant quantum computer.

### LMS/HSS signatures

wolfCrypt includes a native implementation of the LMS/HSS hash-based signature scheme (RFC 8554, NIST SP 800-208). No external library is needed.

Leighton-Micali Signatures (LMS), and its multi-tree variant, the Hierarchical Signature System (HSS), is a post-quantum, stateful hash-based signature scheme. It is noted for having small public and private keys, and fast signing and verifying. Its signature sizes are larger, but are tunable via its Winternitz parameter. See these two links from RFC8554 for more details:

- LMS: <https://datatracker.ietf.org/doc/html/rfc8554>
- HSS: <https://datatracker.ietf.org/doc/html/rfc8554#section-6>

As previously discussed, the LMS/HSS signature system consists of a finite number of one-time signature (OTS) keys, and thus may only safely generate a finite number of signatures. However the number of signatures, and the signature size, are tunable via a set of defined parameters, which will be discussed next.

#### Supported Parameters

LMS/HSS signatures are defined by 3 parameters:
- levels: number of levels of Merkle trees.
- height: height of an individual Merkle tree.
- Winternitz: number of bits from hash used in a Winternitz chain. Used as a space-time tradeoff for the signature size.

wolfSSL supports these LMS/HSS parameter values:

- levels = {1..4}
- height = {5, 10, 15, 20, 25}
- Winternitz = {1, 2, 4, 8}

RFC 8554 allows up to 8 levels; wolfSSL supports up to 4 (`WOLFSSL_LMS_MAX_LEVELS`, default 4). `WOLFSSL_LMS_MAX_HEIGHT` (default 25) can lower the maximum tree height to save memory. By default the parameter sets use SHA-256 with 32-byte (SHA-256/256) hashes. The SHA-256/192 and SHAKE256 (256-bit and 192-bit output) parameter sets of NIST SP 800-208 can be added at build time; see [LMS/HSS Build Instructions](#lmshss-build-instructions).

The number of available signatures is:
- N = 2 ** (levels * height)

The parameter sets are predefined in the enum `wc_LmsParm`, and only the combinations listed there can be used, whether a key is set up with `wc_LmsKey_SetLmsParm()` or with `wc_LmsKey_SetParameters()`. Some of the SHA-256/256 parameter sets are shown in the table below; see `enum wc_LmsParm` in `wolfssl/wolfcrypt/wc_lms.h` for the full list, which also has the `WC_LMS_PARM_SHA256_192_*`, `WC_LMS_PARM_SHAKE_*` and `WC_LMS_PARM_SHAKE192_*` sets. `WC_LMS_PARM_NONE` is not a parameter set: `wc_LmsKey_SetLmsParm()` rejects it, so a parameter set must always be chosen.

parameter set |  description
--------------------  |  ---------------------------
WC_LMS_PARM_L1_H15_W2 | 1 level Merkle tree of 15 height, Winternitz 2
WC_LMS_PARM_L1_H15_W4 | same as above, Winternitz 4
WC_LMS_PARM_L2_H10_W2 | 2 level Merkle tree of 10 height, Winternitz 2
WC_LMS_PARM_L2_H10_W4 | same as above, Winternitz 4
WC_LMS_PARM_L2_H10_W8 | same as above, Winternitz 8
WC_LMS_PARM_L3_H5_W2  | 3 level Merkle tree of 5 height, Winternitz 2
WC_LMS_PARM_L3_H5_W4  | same as above, Winternitz 4
WC_LMS_PARM_L3_H5_W8  | same as above, Winternitz 8
WC_LMS_PARM_L3_H10_W4 | 3 level Merkle tree of 10 height, Winternitz 4
WC_LMS_PARM_L4_H5_W8  | 4 level Merkle tree of 5 height, Winternitz 8

The signature size and number of signatures is shown with respect to the parameter set here:

parameter set |  signature size | number of signatures
--------------------  | -------------------- | --------------------
WC_LMS_PARM_L1_H15_W2 | 4784 | 32768
WC_LMS_PARM_L1_H15_W4 | 2672 | 32768
WC_LMS_PARM_L2_H10_W2 | 9300 | 1048576
WC_LMS_PARM_L2_H10_W4 | 5076 | 1048576
WC_LMS_PARM_L2_H10_W8 | 2964 | 1048576
WC_LMS_PARM_L3_H5_W2  | 13496 | 32768
WC_LMS_PARM_L3_H5_W4  | 7160 | 32768
WC_LMS_PARM_L3_H5_W8  | 3992 | 32768
WC_LMS_PARM_L3_H10_W4 | 7640 | 1073741824
WC_LMS_PARM_L4_H5_W8  | 5340 | 1048576

As can be seen from the tables, signature sizes are primarily determined by the levels and Winternitz parameters, and height to a lesser extent:
- Larger levels values increase signature size significantly.
- Larger height values increase signature size modestly.
- Larger Winternitz values will reduce the signature size, at the expense of longer key generation and sign/verify times.

Key generation time is strongly determined by the height of the first level tree. A 3 level, 5 height tree is much faster than 1 level, 15 height at initial key gen, even if the number of available signatures is the same.

The public key is 60 bytes for the SHA-256/256 and SHAKE256/256 parameter sets and 52 bytes for the 192-bit ones. The private key that has to be stored is 64 bytes for the 256-bit parameter sets; `wc_LmsKey_GetPrivLen()` returns it for any parameter set.

#### LMS/HSS Build Instructions

Configure wolfSSL with [`--enable-lms`](chapter02.md#--enable-lms); no external library is needed. `--enable-all-quantum-crypto` enables LMS/HSS as well. `--enable-lms` takes a comma separated list of sub-options:

- `verify-only`: only signature verification is compiled in (`WOLFSSL_LMS_VERIFY_ONLY`).
- `small`: smaller code with slower signing, for when memory is limited (`WOLFSSL_WC_LMS_SMALL`).
- `sha256-192`: adds the SHA-256/192 parameter sets (`WOLFSSL_LMS_SHA256_192`).
- `shake256`: adds the SHAKE256/256 and SHAKE256/192 parameter sets (`WOLFSSL_LMS_SHAKE256`).
- `no-sha256-256`: removes the SHA-256/256 parameter sets (`WOLFSSL_NO_LMS_SHA256_256`). It must be combined with `sha256-192` or `shake256`.

For example:

```sh
./configure --enable-lms=sha256-192,shake256
```

Outside the small build, `WOLFSSL_LMS_ROOT_LEVELS` and `WOLFSSL_LMS_CACHE_BITS` (both default 5, or 7 with `WOLFSSL_LMS_LARGE_CACHES`) trade the size of the `LmsKey` object for faster signing; `wolfssl/wolfcrypt/wc_lms.h` describes them.

#### Using LMS/HSS Keys

A signing key goes through these steps:

1. [`wc_LmsKey_Init()`](group__LMS.md#function-wc_lmskey_init), then choose the parameter set with [`wc_LmsKey_SetLmsParm()`](group__LMS.md#function-wc_lmskey_setlmsparm) or [`wc_LmsKey_SetParameters()`](group__LMS.md#function-wc_lmskey_setparameters).
2. Set the private key callbacks with [`wc_LmsKey_SetWriteCb()`](group__LMS.md#function-wc_lmskey_setwritecb), [`wc_LmsKey_SetReadCb()`](group__LMS.md#function-wc_lmskey_setreadcb) and [`wc_LmsKey_SetContext()`](group__LMS.md#function-wc_lmskey_setcontext). The context pointer is passed to the callbacks, for example a file name.
3. [`wc_LmsKey_MakeKey()`](group__LMS.md#function-wc_lmskey_makekey) generates the key pair and stores the private key with the write callback. Export the public key with [`wc_LmsKey_ExportPubRaw()`](group__LMS.md#function-wc_lmskey_exportpubraw).
4. Each [`wc_LmsKey_Sign()`](group__LMS.md#function-wc_lmskey_sign) uses up one one-time key and stores the updated private key with the write callback before it returns the signature. [`wc_LmsKey_SigsLeft()`](group__LMS.md#function-wc_lmskey_sigsleft) returns non-zero while the key can still sign.
5. To carry on signing later, for example after a restart, set up a new `LmsKey` with the same parameter set and callbacks and call [`wc_LmsKey_Reload()`](group__LMS.md#function-wc_lmskey_reload). It loads the private key with the read callback and rebuilds the cached tree state, which takes about as long as key generation. A reloaded key can sign, but it holds no public key, so keep the public key that was exported after key generation.

The callbacks have these types:

```c
typedef int (*wc_lms_write_private_key_cb)(const byte* priv, word32 privSz,
    void* context);
typedef int (*wc_lms_read_private_key_cb)(byte* priv, word32 privSz,
    void* context);
```

The write callback must return `WC_LMS_RC_SAVED_TO_NV_MEMORY` only once the private key is in non-volatile storage, and the read callback returns `WC_LMS_RC_READ_TO_MEMORY` once it has filled `priv`. Any other return value makes the call fail with `IO_FAILED_E`. If storing the updated private key fails during signing, `wc_LmsKey_Sign()` erases the signature and the key cannot sign any more. Never sign with two copies of the same private key, and never go back to an older copy of the stored private key: both reuse one-time keys.

To verify, import the public key into a key of its own with [`wc_LmsKey_ImportPubRaw()`](group__LMS.md#function-wc_lmskey_importpubraw), which takes the parameter set from the public key if none was set, and call [`wc_LmsKey_Verify()`](group__LMS.md#function-wc_lmskey_verify).

The following example generates a key with the small parameter set `WC_LMS_PARM_L1_H5_W8` (32 signatures), keeps the private key in a file, signs, verifies, and reloads the key to sign again:

```c
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/wolfcrypt/error-crypt.h>
#include <wolfssl/wolfcrypt/random.h>
#include <wolfssl/wolfcrypt/wc_lms.h>
#include <stdio.h>
#include <stdlib.h>

/* The private key must be stored before wc_LmsKey_MakeKey() or
 * wc_LmsKey_Sign() returns. Only return WC_LMS_RC_SAVED_TO_NV_MEMORY once the
 * data is durable (a real application should write a new file, sync it and
 * rename it over the old one). */
static int lms_write_key(const byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "wb");
    int ok;

    if (f == NULL)
        return WC_LMS_RC_WRITE_FAIL;
    ok = (fwrite(priv, 1, privSz, f) == privSz);
    if (fclose(f) != 0)
        ok = 0;
    return ok ? WC_LMS_RC_SAVED_TO_NV_MEMORY : WC_LMS_RC_WRITE_FAIL;
}

/* Called by wc_LmsKey_Reload() to load the stored private key. */
static int lms_read_key(byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "rb");
    size_t n;

    if (f == NULL)
        return WC_LMS_RC_READ_FAIL;
    n = fread(priv, 1, privSz, f);
    fclose(f);
    return (n == privSz) ? WC_LMS_RC_READ_TO_MEMORY : WC_LMS_RC_READ_FAIL;
}

/* Set the parameters and callbacks: needed before MakeKey and Reload. */
static int lms_setup(LmsKey* key, const char* file)
{
    int ret = wc_LmsKey_Init(key, NULL, INVALID_DEVID);
    if (ret == 0)
        ret = wc_LmsKey_SetLmsParm(key, WC_LMS_PARM_L1_H5_W8);
    if (ret == 0)
        ret = wc_LmsKey_SetWriteCb(key, lms_write_key);
    if (ret == 0)
        ret = wc_LmsKey_SetReadCb(key, lms_read_key);
    if (ret == 0)
        ret = wc_LmsKey_SetContext(key, (void*)file);
    return ret;
}

int main(void)
{
    const char* file = "lms_priv.key";
    const byte  msg[] = "firmware image";
    byte   pub[HSS_MAX_PUBLIC_KEY_LEN];
    word32 pubSz = sizeof(pub);
    byte*  sig = NULL;
    word32 sigSz = 0;
    LmsKey key;
    LmsKey verifyKey;
    WC_RNG rng;
    int    ret;

    ret = wc_InitRng(&rng);
    if (ret != 0)
        return 1;

    /* Generate a new key pair. The private key is written with the write
     * callback. */
    ret = lms_setup(&key, file);
    if (ret == 0)
        ret = wc_LmsKey_MakeKey(&key, &rng);
    if (ret == 0)
        ret = wc_LmsKey_ExportPubRaw(&key, pub, &pubSz);
    if (ret == 0)
        ret = wc_LmsKey_GetSigLen(&key, &sigSz);
    if (ret == 0) {
        sig = (byte*)malloc(sigSz);
        if (sig == NULL)
            ret = MEMORY_E;
    }
    /* Each signature uses up one one-time key. The updated private key is
     * written before the signature is returned. */
    if (ret == 0)
        ret = wc_LmsKey_Sign(&key, sig, &sigSz, msg, (int)sizeof(msg));
    wc_LmsKey_Free(&key);

    /* Verify with a public-key-only object. The parameter set is taken from
     * the public key. */
    if (ret == 0)
        ret = wc_LmsKey_Init(&verifyKey, NULL, INVALID_DEVID);
    if (ret == 0) {
        ret = wc_LmsKey_ImportPubRaw(&verifyKey, pub, pubSz);
        if (ret == 0)
            ret = wc_LmsKey_Verify(&verifyKey, sig, sigSz, msg,
                (int)sizeof(msg));
        wc_LmsKey_Free(&verifyKey);
    }

    /* Later, for example after a restart: reload the stored private key and
     * carry on signing where it left off. */
    if (ret == 0)
        ret = lms_setup(&key, file);
    if (ret == 0)
        ret = wc_LmsKey_Reload(&key);
    if ((ret == 0) && (wc_LmsKey_SigsLeft(&key) == 0))
        ret = KEY_EXHAUSTED_E;
    if (ret == 0)
        ret = wc_LmsKey_Sign(&key, sig, &sigSz, msg, (int)sizeof(msg));
    wc_LmsKey_Free(&key);

    printf("LMS example %s (%d)\n", (ret == 0) ? "passed" : "failed", ret);
    free(sig);
    wc_FreeRng(&rng);
    return (ret == 0) ? 0 : 1;
}
```

#### Benchmark Data

The following benchmark data was taken on the Apple M5 system described in [Statistics](#statistics), with wolfSSL 5.9.4 configured with `./configure --enable-lms --enable-xmss --enable-armasm` and with `./configure --enable-lms --enable-xmss`, by running:

```sh
./wolfcrypt/benchmark/benchmark -lms_hss
```

Each time is the average in milliseconds, with `--enable-armasm` first and without it second. `--enable-armasm` uses the ARMv8 SHA-256 instructions, which speeds up all LMS/HSS operations. Reload is `wc_LmsKey_Reload()`. Only a single core is used.

Parameter set | Signature size | Key gen (ms)     | Reload (ms)      | Sign (ms)     | Verify (ms)
------------- | -------------- | ---------------- | ---------------- | ------------- | -------------
L1_H5_W4      | 2352           | 1.066 / 5.535    | 1.071 / 5.381    | 0.017 / 0.089 | 0.016 / 0.085
L1_H5_W8      | 1296           | 8.562 / 42.308   | 10.534 / 42.950  | 0.382 / 0.645 | 0.206 / 0.753
L2_H10_W2     | 9300           | 37.449 / 188.105 | 34.651 / 188.645 | 0.052 / 0.281 | 0.016 / 0.088
L2_H10_W4     | 5076           | 68.022 / 343.029 | 67.543 / 344.260 | 0.099 / 0.507 | 0.034 / 0.178
L3_H5_W4      | 7160           | 3.312 / 17.186   | 3.391 / 17.427   | 0.053 / 0.268 | 0.048 / 0.268
L3_H5_W8      | 3992           | 26.232 / 144.790 | 26.499 / 140.189 | 0.411 / 2.185 | 0.408 / 2.240
L3_H10_W4     | 7640           | 103.184 / 548.525 | 102.161 / 563.973 | 0.099 / 0.546 | 0.050 / 0.258
L4_H5_W8      | 5340           | 35.179 / 188.079 | 35.460 / 187.302 | 0.417 / 2.174 | 0.573 / 3.758

### XMSS/XMSS^MT signatures

wolfCrypt includes a native implementation of the XMSS and XMSS^MT stateful hash-based signature schemes from RFC 8391 (https://www.rfc-editor.org/rfc/rfc8391.html) and NIST SP 800-208. Configure wolfSSL with [`--enable-xmss`](chapter02.md#--enable-xmss); no external library is needed. `--enable-all-quantum-crypto` enables XMSS/XMSS^MT as well. `--enable-xmss` takes these sub-options:

- `verify-only`: only signature verification is compiled in (`WOLFSSL_XMSS_VERIFY_ONLY`).
- `small`: smaller code and a much smaller private key (`WOLFSSL_WC_XMSS_SMALL`). The private key then holds no tree traversal state, so signing is much slower.

Overall, XMSS/XMSS^MT is similar to LMS/HSS. For a more detailed comparison see
"LMS vs XMSS: Comparison of two Hash-Based Signature Standards" (https://eprint.iacr.org/2017/349.pdf).


XMSS^MT is the Multi-Tree generalization of XMSS,
analogous to HSS with LMS, with the distinction that the Winternitz value is fixed to `w=16` in
XMSS/XMSS^MT. The public key is slightly larger in XMSS/XMSS^MT (at 68 bytes in XMSS/XMSS^MT, vs 60 bytes in LMS/HSS), while signatures are slightly smaller.

#### Supported Parameters

wolfSSL supports the XMSS/XMSS^MT parameter sets of RFC 8391 and NIST SP 800-208 for each hash algorithm that is built in: SHA2-256 with n = 32 and n = 24, SHA2-512 (n = 64), SHAKE128 (n = 32), and SHAKE256 with n = 64, 32 and 24. FIPS builds support only the SHA2-256 and SHAKE256 sets with n = 32 and n = 24. The table below lists the SHA2-256 parameter sets with n = 32, from Tables 10 and 11 of NIST SP 800-208 (https://csrc.nist.gov/pubs/sp/800/208/final). The names of the other sets follow the same pattern, for example "XMSS-SHA2_10_192", "XMSS-SHA2_10_512", "XMSS-SHAKE_10_256", "XMSS-SHAKE256_10_256" and "XMSSMT-SHAKE256_60/12_192"; the full list is in `wolfcrypt/src/wc_xmss.c`. `WOLFSSL_XMSS_MIN_HEIGHT` and `WOLFSSL_XMSS_MAX_HEIGHT` (default 10 and 60) limit the total tree heights that are compiled in.

parameter set name      | Oid         | n   | w   | h   | d   | h/d | Sig len
----------------------- | ----------- | --- | --- | --- | --- | --- | --
XMSS                    |             |     |     |     |     |     |
"XMSS-SHA2_10_256"      |  0x00000001 |  32 |  16 |  10 |  1  |  10 | 2500
"XMSS-SHA2_16_256"      |  0x00000002 |  32 |  16 |  16 |  1  |  16 | 2692
"XMSS-SHA2_20_256"      |  0x00000003 |  32 |  16 |  20 |  1  |  20 | 2820
XMSS^MT                 |             |     |     |     |     |     |
"XMSSMT-SHA2_20/2_256"  |  0x00000001 |  32 |  16 |  20 |  2  |  10 | 4963
"XMSSMT-SHA2_20/4_256"  |  0x00000002 |  32 |  16 |  20 |  4  |   5 | 9251
"XMSSMT-SHA2_40/2_256"  |  0x00000003 |  32 |  16 |  40 |  2  |  20 | 5605
"XMSSMT-SHA2_40/4_256"  |  0x00000004 |  32 |  16 |  40 |  4  |  10 | 9893
"XMSSMT-SHA2_40/8_256"  |  0x00000005 |  32 |  16 |  40 |  8  |   5 | 18469
"XMSSMT-SHA2_60/3_256"  |  0x00000006 |  32 |  16 |  60 |  3  |  20 | 8392
"XMSSMT-SHA2_60/6_256"  |  0x00000007 |  32 |  16 |  60 |  6  |  10 | 14824
"XMSSMT-SHA2_60/12_256" |  0x00000008 |  32 |  16 |  60 |  12 |   5 | 27688

In the table above, `n` is the number of bytes in the HASH function, `w` the Winternitz value, `h` the total height of the tree system, and `d` the number of levels of trees.

Key generation time is strongly determined by the height of the
first level tree (or `h/d`), while signature length grows primarily with `d` (the number of hyper
tree levels).

Similar to LMS/HSS, the number of available signatures grows as `2**h`, where h is the
total height of the tree system.

#### Using XMSS/XMSS^MT Keys

XMSS/XMSS^MT keys are used in the same way as LMS/HSS keys, with the `wc_XmssKey_` functions, and the same rules apply to the stored private key. The differences are:

- The parameter set is chosen by name with [`wc_XmssKey_SetParamStr()`](group__XMSS.md#function-wc_xmsskey_setparamstr), for example "XMSS-SHA2_10_256" or "XMSSMT-SHA2_20/4_256".
- The callbacks return `enum wc_XmssRc`: `WC_XMSS_RC_SAVED_TO_NV_MEMORY` from the write callback and `WC_XMSS_RC_READ_TO_MEMORY` from the read callback.
- wolfCrypt does not keep the private key in memory between signatures. [`wc_XmssKey_Sign()`](group__XMSS.md#function-wc_xmsskey_sign) reads the private key with the read callback, signs, stores the updated private key with the write callback and then erases its copy, so both callbacks must be set before signing. [`wc_XmssKey_SigsLeft()`](group__XMSS.md#function-wc_xmsskey_sigsleft) also reads the stored private key, and [`wc_XmssKey_Reload()`](group__XMSS.md#function-wc_xmsskey_reload) only checks that it can be read.
- A verify-only key needs its parameter string set with `wc_XmssKey_SetParamStr()` before [`wc_XmssKey_ImportPubRaw()`](group__XMSS.md#function-wc_xmsskey_importpubraw).
- The private key format is specific to wolfSSL, and its size depends on the parameter set and on the `small` option (for "XMSS-SHA2_10_256" it is 1343 bytes by default and 136 bytes with `small`). Do not expect XMSS/XMSS^MT private keys to work with other implementations.

For example, the callbacks and the key generation look like this:

```c
static enum wc_XmssRc xmss_write_key(const byte* priv, word32 privSz,
    void* context)
{
    FILE* f = fopen((const char*)context, "wb");
    int ok;

    if (f == NULL)
        return WC_XMSS_RC_WRITE_FAIL;
    ok = (fwrite(priv, 1, privSz, f) == privSz);
    if (fclose(f) != 0)
        ok = 0;
    return ok ? WC_XMSS_RC_SAVED_TO_NV_MEMORY : WC_XMSS_RC_WRITE_FAIL;
}

static enum wc_XmssRc xmss_read_key(byte* priv, word32 privSz, void* context)
{
    FILE* f = fopen((const char*)context, "rb");
    size_t n;

    if (f == NULL)
        return WC_XMSS_RC_READ_FAIL;
    n = fread(priv, 1, privSz, f);
    fclose(f);
    return (n == privSz) ? WC_XMSS_RC_READ_TO_MEMORY : WC_XMSS_RC_READ_FAIL;
}

    /* In a function with XmssKey key, an initialized WC_RNG rng,
     * byte pub[XMSS_SHA256_PUBLEN] and word32 pubSz = sizeof(pub): */
    ret = wc_XmssKey_Init(&key, NULL, INVALID_DEVID);
    if (ret == 0)
        ret = wc_XmssKey_SetParamStr(&key, "XMSS-SHA2_10_256");
    if (ret == 0)
        ret = wc_XmssKey_SetWriteCb(&key, xmss_write_key);
    if (ret == 0)
        ret = wc_XmssKey_SetReadCb(&key, xmss_read_key);
    if (ret == 0)
        ret = wc_XmssKey_SetContext(&key, (void*)"xmss_priv.key");
    if (ret == 0)
        ret = wc_XmssKey_MakeKey(&key, &rng);
    if (ret == 0)
        ret = wc_XmssKey_ExportPubRaw(&key, pub, &pubSz);
```

#### Benchmark Data

In the following, benchmark data is shown for the SHA2-256 XMSS/XMSS^MT parameter sets. The SHA256 performance is also listed for reference, as computing the large number of required hash chains will constitute the bulk of the CPU work for XMSS/XMSS^MT. The wolfCrypt XMSS/XMSS^MT implementation uses the wolfCrypt SHA-256 code, and therefore benefits from the same ASM speedups.

The data was taken on the Apple M5 system described in [Statistics](#statistics), with the same two builds as the LMS/HSS data (with and without `--enable-armasm`), by running:

```sh
./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
```

`-xmss_xmssmt` runs the SHA2-256 parameter sets (n = 32 and n = 24); `-xmss_xmssmt_sha512`, `-xmss_xmssmt_shake128` and `-xmss_xmssmt_shake256` run the other hash families. SHA-256 ran at 2971.128 MiB/s with `--enable-armasm` and at 451.523 MiB/s without it. On x86_64, `--enable-intelasm` enables the assembly SHA-256 code.

Each time is the average in milliseconds, with `--enable-armasm` first and without it second. Only a single core is used.

Parameter set          | Signature size | Key gen (ms)        | Sign (ms)     | Verify (ms)
---------------------- | -------------- | ------------------- | ------------- | -------------
XMSS-SHA2_10_256       | 2500           | 147.243 / 706.314   | 0.659 / 3.129 | 0.081 / 0.364
XMSS-SHA2_10_192       | 1492           | 152.998 / 669.786   | 0.680 / 2.939 | 0.086 / 0.386
XMSSMT-SHA2_20/2_256   | 4963           | 298.039 / 1435.763  | 0.809 / 3.463 | 0.177 / 0.732
XMSSMT-SHA2_20/4_256   | 9251           | 18.635 / 87.609     | 0.473 / 2.214 | 0.335 / 1.472
XMSSMT-SHA2_40/4_256   | 9893           | 609.783 / 2879.408  | 0.862 / 3.975 | 0.339 / 1.590
XMSSMT-SHA2_40/8_256   | 18469          | 39.661 / 189.600    | 0.481 / 2.349 | 0.647 / 3.061
XMSSMT-SHA2_60/6_256   | 14824          | 916.980 / 4452.551  | 0.889 / 4.362 | 0.501 / 2.389
XMSSMT-SHA2_60/12_256  | 27688          | 59.256 / 298.819    | 0.471 / 2.376 | 1.007 / 4.663
XMSSMT-SHA2_20/2_192   | 2955           | 317.927 / 1407.238  | 0.826 / 3.531 | 0.166 / 0.818
XMSSMT-SHA2_20/4_192   | 5403           | 20.774 / 93.409     | 0.477 / 2.312 | 0.341 / 1.535
XMSSMT-SHA2_40/4_192   | 5885           | 641.373 / 3006.338  | 0.894 / 4.040 | 0.351 / 1.647
XMSSMT-SHA2_40/8_192   | 10781          | 38.492 / 181.952    | 0.486 / 2.262 | 0.669 / 3.202
XMSSMT-SHA2_60/6_192   | 8816           | 935.416 / 4241.281  | 0.862 / 4.085 | 0.508 / 2.212
XMSSMT-SHA2_60/12_192  | 16160          | 55.882 / 263.694    | 0.446 / 2.222 | 0.959 / 4.503

### Developer Notes

* If you are trying to thwart the "harvest now, decrypt later" threat model and you are willing to sacrifice some interoperability, then you do not want to advertise support for conventional algorithms in the Supported Groups extension. By default a wolfSSL client already sends a PQ/T hybrid key share (X25519MLKEM768 when Curve25519 is built in, otherwise SecP256r1MLKEM768; define `WOLFSSL_KEY_SHARE_DEFAULT_GROUP` to choose another group) and lists the standard hybrids first in the Supported Groups extension, but the conventional groups follow them. If your peer does not support post-quantum algorithms, they will then send a HelloRetryRequest which will then result in a connection with a conventional algorithm. To prevent this, set only your chosen groups with [`wolfSSL_CTX_set_groups()`](group__Setup.md#function-wolfssl_ctx_set_groups) or [`wolfSSL_set_groups()`](group__Setup.md#function-wolfssl_set_groups), or by name with [`wolfSSL_CTX_set1_groups_list()`](group__Setup.md#function-wolfssl_ctx_set1_groups_list) or [`wolfSSL_set1_groups_list()`](group__Setup.md#function-wolfssl_set1_groups_list), which need the OpenSSL compatibility layer (for example `--enable-opensslextra`). For example, `"SecP384r1MLKEM1024:X25519MLKEM768"`; the names are case-insensitive. The key share is then made for the first group in the list that the build supports. Only calling [`wolfSSL_UseKeyShare()`](group__Setup.md#function-wolfssl_usekeyshare) is insufficient as that will advertise your support for quantum-vulnerable algorithms.
