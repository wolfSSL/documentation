# Experimenting with Post-Quantum Cryptography

The wolfSSL team has integrated experimental post-quantum cryptographic algorithms into the wolfSSL library. This was done by integrating with the Open Quantum Safe team's liboqs. You can find more information about them at <https://openquantumsafe.org>

This appendix is intended for anyone that wants to start learning about and experimenting with post-quantum cryptography in the context of TLS 1.3. It explains why post-quantum algorithms are important, what we have done in response to the quantum threat and how you can start experimenting with these new algorithms.

**Note**: The post-quantum algorithms provided by liboqs are not standardized and experimental. It is highly advised that they NOT be used in production environments. All OIDs, codepoints and artifact formats are temporary and expected to change in the future. You should have no expectation of backwards compatibility.

**Note**: These experimental algorithms are not enabled and completely inaccessible if wolfSSL is not configured with the `--with-liboqs` flag.

## A Gentle Introduction to Post-Quantum Cryptography

### Why Post-Quantum Cryptography?

Recently, more and more resources have been devoted to the development of quantum computers. So much so that commercialization of cloud quantum computing resources has already begun. While the current state of the art is still not in the realm of being a cryptographically relevant, some threat models such as "harvest now, decrypt later" mean that preparations need to happen sooner than the appearance of cryptographically relevant quantum computers.

It is widely acknowledged that NIST is leading the way for standardization of a new class of algorithms designed to replace the public key cryptography algorithms that will become vulnerable to quantum computers. At the time of the writing of this passage, NIST is nearing completion of its third round in the PQC standardization process and will announce the algorithms that are to be standardized in early 2022. It is then projected that it will take another year for the process to produce standards documents describing the protocol and data formats. After that, FIPS-like regulations will likely begin development.

### How do we Protect Ourselves?

From a high level perspective, for every TLS 1.3 connection, authentication and confidentiality are the two main goals that protect each connection. Authentication is maintained via signature schemes such as ECDSA. Confidentiality is maintained by key establishment algorithms such as ECDHE and then using the established key with symmetric encryption algorithms such AES to encrypt a communication stream. We can thus decompose the security of the TLS 1.3 protocol into 3 types of cryptographic algorithms:

* authentication algorithms
* key establishment algorithms
* symmetric cipher algorithms

The threat of quantum computers to conventional cryptography takes two forms. Grover’s algorithm reduces the security of modern symmetric cipher algorithms by half while Shor’s algorithm completely breaks the security of modern authentication and key establishment algorithms. As a result, we can continue to protect our communications by doubling the strength of our symmetric cipher algorithms and replacing our conventional authentication and key establishment algorithms with post-quantum algorithms. Note that during TLS 1.3 handshakes, the ciphersuite specifies the symmetric cipher to be used for the duration of the connection. Since AES-128 is generally accepted to be sufficient, we can double our strength by using the AES_256_GCM_SHA384 ciphersuite. For key establishment and authentication, there are post-quantum KEMs (Key Encapsulation Mechanisms) and signature schemes.

These use different kinds of math from the conventional algorithms. They are designed specifically for resistance to quantum-computers. The authentication algorithms and KEMs we have chosen to integrate are all lattice-based algorithms.

* Dilithium Signature Scheme
* FALCON Signature Scheme
* KYBER KEM
* SABER KEM
* NTRU KEM

An explanation of lattice-based cryptography would fall outside the scope of this document but more information about these algorithms can be found in their NIST submissions at <https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.

Unfortunately, it might come as a shock, but we do not actually know that these algorithms will resist attacks from quantum computers. In fact, we do not even know that these algorithms are safe against a conventional computer. Its getting less and less likely, but someone could break lattice-based cryptography. However, as security experts will tell you, this is how cryptography has always worked. Algorithms are good when we start using them, but weaknesses and vulnerabilities are discovered and technology gets better. The post-quantum algorithms are somewhat problematic in that they are relatively new and could use a bit more attention from the community.

One solution is to not put our full faith into these new algorithms. For now, we can hedge our bets by hybridizing post-quantum KEMs with the conventional algorithms that we actually trust. ECC with NIST standardized curves seem like good candidates as we have to keep using them since FIPS compliance is a priority. For this reason, we have not only integrated post-quantum KEMs but also hybridized them with ECDSA over NIST approved curves. Please see our list of hybrid groups below.

## Getting Started with wolfSSL's liboqs Integration

The following instructions will get you started from a clean Linux development environment and lead you step by step to performing a quantum-safe TLS 1.3 connection.

### Build Instructions

Please see the wolfSSL repo's INSTALL file (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL). Item 15 (Building with liboqs for TLS 1.3 [EXPERIMENTAL]) has instructions on how to configure and build:

- liboqs
- wolfssl
- patched OQS's OpenSSL fork

You will need the patched OQS OpenSSL fork in order to generate X.509
certificates with post-quantum cryptographic keys and signatures. Instructions
can be found at https://github.com/wolfSSL/osp/tree/master/oqs/README.md. If you
do not want to use post-quantum signature schemes, you can skip the step of
building OpenSSL.

### Making a Quantum Safe TLS Connection

You can run the server and client like this in separate terminals:

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level5_root_cert.pem \
  -c certs/falcon_level1_entity_cert.pem \
  -k certs/falcon_level1_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level1_root_cert.pem \
  -c certs/falcon_level5_entity_cert.pem \
  -k certs/falcon_level5_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

You have just achieved a fully quantum-safe TLS 1.3 connection using AES-256 for symmetric encryption, the FALCON signature scheme for authentication and ECDHE hybridized with KYBER KEM for key establishment.

Further information about other post-quantum examples can be found at
https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md.


## Naming Convention Mappings Between wolfSSL and OQS's fork of OpenSSL

All the teams that made submission to the NIST PQC competition supported multiple levels of security as defined by NIST here: <https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation-criteria/security-(evaluation-criteria)>

As such, they had to come up with ways to identify their variants and each team came up with their own variant naming scheme. As you can see in the following tables, there was no co-ordination between the teams on how to do this. The wolfSSL library uses a NIST-level-based naming convention of the variants. The OQS team chose to follow the naming conventions of each of the submission papers. Please see the following tables mapping our naming conventions with those of the submission papers.

Post-Quantum Signature Scheme Naming Convention:

wolfSSL Variant Name  |  PQC Submission Variant Name
--------------------  |  ---------------------------
FALCON_LEVEL1         |  FALCON512
FALCON_LEVEL5         |  FALCON1024
DILITHIUM_LEVEL2      |  DILITHIUM2
DILITHIUM_LEVEL3      |  DILITHIUM3
DILITHIUM_LEVEL5      |  DILITHIUM5
DILITHIUM_AES_LEVEL2  |  DILITHIUM2_AES
DILITHIUM_AES_LEVEL3  |  DILITHIUM3_AES
DILITHIUM_AES_LEVEL5  |  DILITHIUM5_AES
SPHINCS_FAST_LEVEL1   |  SPHINCS+-SHAKE256-128f-simple
SPHINCS_FAST_LEVEL3   |  SPHINCS+-SHAKE256-192f-simple
SPHINCS_FAST_LEVEL5   |  SPHINCS+-SHAKE256-256f-simple
SPHINCS_SMALL_LEVEL1  |  SPHINCS+-SHAKE256-128s-simple
SPHINCS_SMALL_LEVEL3  |  SPHINCS+-SHAKE256-192s-simple
SPHINCS_SMALL_LEVEL5  |  SPHINCS+-SHAKE256-256s-simple

Post-Quantum KEM Naming Convention:

wolfSSL Variant Name  |  PQC Submission Variant Name
--------------------  |  ---------------------------
KYBER_LEVEL1          |  KYBER512
KYBER_LEVEL3          |  KYBER768
KYBER_LEVEL5          |  KYBER1024
KYBER_90S_LEVEL1      |  KYBER90S512
KYBER_90S_LEVEL3      |  KYBER90S768
KYBER_90S_LEVEL5      |  KYBER90S1024
NTRU_HPS_LEVEL1       |  NTRU_HPS2048509
NTRU_HPS_LEVEL3       |  NTRU_HPS2048677
NTRU_HPS_LEVEL5       |  NTRU_HPS4096821
NTRU_HRSS_LEVEL3      |  NTRU_HRSS701
SABER_LEVEL1          |  LIGHTSABER
SABER_LEVEL3          |  SABER
SABER_LEVEL5          |  FIRESABER

Post-Quantum Hybrid KEM Naming Convention:

wolfSSL Variant Name  |  NIST ECC Curve and PQC Submission Variant Name
--------------------  |  ----------------------------------------------
P256_KYBER_LEVEL1     |  ECDSA P-256 and KYBER512
P384_KYBER_LEVEL3     |  ECDSA P-384 and KYBER768
P521_KYBER_LEVEL5     |  ECDSA P-521 and KYBER1024
P256_KYBER90S_LEVEL1  |  ECDSA P-256 and KYBER90S512
P384_KYBER90S_LEVEL3  |  ECDSA P-384 and KYBER90S768
P521_KYBER90S_LEVEL5  |  ECDSA P-521 and KYBER90S1024
P256_NTRU_HPS_LEVEL1  |  ECDSA P-256 and NTRU_HPS2048509
P384_NTRU_HPS_LEVEL3  |  ECDSA P-384 and NTRU_HPS2048677
P521_NTRU_HPS_LEVEL5  |  ECDSA P-521 and NTRU_HPS4096821
P384_NTRU_HRSS_LEVEL3 |  ECDSA P-384 and NTRU_HRSS701
P256_SABER_LEVEL1     |  ECDSA P-256 and LIGHTSABER
P384_SABER_LEVEL3     |  ECDSA P-384 and SABER
P521_SABER_LEVEL5     |  ECDSA P-521 and FIRESABER

## Codepoints and OIDs

The post-quantum signature algorithm and KEMs that we support are also supported by the OQS project's fork of OpenSSL. While their naming conventions are different from ours, we have full interoperability in that we use the same numeric OIDs and codepoints and the cryptographic artifacts are generated and processed by the same library; namely liboqs. The codepoints are used in the sigalgs and supported groups extensions in TLS 1.3. The OIDs are used in certificates and private keys as identifiers of public keys, private keys and signatures.

Post-Quantum Codepoints for TLS 1.3:

wolfSSL Variant Name  |  Codepoints
--------------------  |  ----------
FALCON_LEVEL1         |  65035
FALCON_LEVEL5         |  65038
DILITHIUM_LEVEL2      |  65184
DILITHIUM_LEVEL3      |  65187
DILITHIUM_LEVEL5      |  65189
DILITHIUM_AES_LEVEL2  |  65191
DILITHIUM_AES_LEVEL3  |  65194
DILITHIUM_AES_LEVEL5  |  65196
KYBER_LEVEL1          |  570
KYBER_LEVEL3          |  572
KYBER_LEVEL5          |  573
KYBER_90S_LEVEL1      |  574
KYBER_90S_LEVEL3      |  575
KYBER_90S_LEVEL5      |  576
NTRU_HPS_LEVEL1       |  532
NTRU_HPS_LEVEL3       |  533
NTRU_HPS_LEVEL5       |  534
NTRU_HRSS_LEVEL3      |  535
SABER_LEVEL1          |  536
SABER_LEVEL3          |  537
SABER_LEVEL5          |  538
P256_KYBER_LEVEL1     |  12090
P384_KYBER_LEVEL3     |  12092
P521_KYBER_LEVEL5     |  12093
P256_KYBER90S_LEVEL1  |  12094
P384_KYBER90S_LEVEL3  |  12095
P521_KYBER90S_LEVEL5  |  12096
P256_NTRU_HPS_LEVEL1  |  12052
P384_NTRU_HPS_LEVEL3  |  12053
P521_NTRU_HPS_LEVEL5  |  12054
P384_NTRU_HRSS_LEVEL3 |  12055
P256_SABER_LEVEL1     |  12056
P384_SABER_LEVEL3     |  12057
P521_SABER_LEVEL5     |  12058

Post-Quantum OIDs for Certificates:

wolfSSL Variant Name  |  OID
--------------------  |  ---
FALCON_LEVEL1         |  1.3.9999.3.1
FALCON_LEVEL5         |  1.3.9999.3.4
DILITHIUM_LEVEL2      |  1.3.6.1.4.1.2.267.7.4.4
DILITHIUM_LEVEL3      |  1.3.6.1.4.1.2.267.7.6.5
DILITHIUM_LEVEL5      |  1.3.6.1.4.1.2.267.7.8.7
DILITHIUM_AES_LEVEL2  |  1.3.6.1.4.1.2.267.11.4.4
DILITHIUM_AES_LEVEL3  |  1.3.6.1.4.1.2.267.11.6.5
DILITHIUM_AES_LEVEL5  |  1.3.6.1.4.1.2.267.11.8.7
SPHINCS_FAST_LEVEL1   |  1.3.9999.6.7.4
SPHINCS_FAST_LEVEL3   |  1.3.9999.6.8.3
SPHINCS_FAST_LEVEL5   |  1.3.9999.6.9.3
SPHINCS_SMALL_LEVEL1  |  1.3.9999.6.7.10
SPHINCS_SMALL_LEVEL3  |  1.3.9999.6.8.7
SPHINCS_SMALL_LEVEL5  |  1.3.9999.6.9.7

## Cryptographic Artifact Sizes

All sizes are in bytes.

Post-Quantum Signature Scheme Artifact Sizes:

wolfSSL Variant Name | Public Key Size | Private Key Size | Maximum Signature Size
-------------------- | --------------- | ---------------- | ----------------------
FALCON_LEVEL1        | 897             | 1281             | 690
FALCON_LEVEL5        | 1793            | 2305             | 1330
DILITHIUM_LEVEL2     | 1312            | 2528             | 2420
DILITHIUM_LEVEL3     | 1952            | 4000             | 3293
DILITHIUM_LEVEL5     | 2592            | 4864             | 4595
DILITHIUM_AES_LEVEL2 | 1312            | 2528             | 2420
DILITHIUM_AES_LEVEL3 | 1952            | 4000             | 3293
DILITHIUM_AES_LEVEL5 | 2592            | 4864             | 4595
SPHINCS_FAST_LEVEL1  | 32              | 64               | 17088
SPHINCS_FAST_LEVEL3  | 48              | 96               | 35664
SPHINCS_FAST_LEVEL5  | 64              | 128              | 49856
SPHINCS_SMALL_LEVEL1 | 32              | 64               | 7856
SPHINCS_SMALL_LEVEL3 | 48              | 96               | 16224
SPHINCS_SMALL_LEVEL5 | 64              | 128              | 29792

**Note**: FALCON has variable signature sizes.

Post-Quantum KEM Artifact Sizes:

wolfSSL Variant Name | Public Key Size | Private Key Size | Ciphertext Size | Shared Secret Size
-------------------- | --------------- | ---------------- | --------------- | ------------------
KYBER_LEVEL1         | 800             | 1632             | 768             | 32
KYBER_LEVEL3         | 1184            | 2400             | 1088            | 32
KYBER_LEVEL5         | 1568            | 3168             | 1568            | 32
KYBER_90S_LEVEL1     | 800             | 1632             | 768             | 32
KYBER_90S_LEVEL3     | 1184            | 2400             | 1088            | 32
KYBER_90S_LEVEL5     | 1568            | 3168             | 1568            | 32
NTRU_HPS_LEVEL1      | 699             | 935              | 699             | 32
NTRU_HPS_LEVEL3      | 930             | 1234             | 930             | 32
NTRU_HPS_LEVEL5      | 1230            | 1590             | 1230            | 32
NTRU_HRSS_LEVEL3     | 1138            | 1450             | 1138            | 32
SABER_LEVEL1         | 672             | 1568             | 736             | 32
SABER_LEVEL3         | 992             | 2304             | 1088            | 32
SABER_LEVEL5         | 1312            | 3040             | 1472            | 32

## Statistics

The following statistics and benchmarks were taken on an 11th GenIntel Core i7-1165G7@3-GHz with 8 cores running Ubuntu 21.10. liboqs was upgraded to `ba5b61a779a0db364f0e691a0a0bc8ac42e73f1b` on their main branch due to compiler incompatibilities with the older code in `0.7.0`. The following configurations were used (unless otherwise noted):

liboqs:

```text
CFLAGS="-Os" cmake -DOQS_USE_OPENSSL=0 -DOQS_MINIMAL_BUILD="OQS_ENABLE_KEM_saber_saber;OQS_ENABLE_KEM_saber_lightsaber;OQS_ENABLE_KEM_saber_firesaber;OQS_ENABLE_KEM_kyber_1024;OQS_ENABLE_KEM_kyber_1024_90s;OQS_ENABLE_KEM_kyber_768;OQS_ENABLE_KEM_kyber_768_90s;OQS_ENABLE_KEM_kyber_512;OQS_ENABLE_KEM_kyber_512_90s;OQS_ENABLE_KEM_ntru_hps2048509;OQS_ENABLE_KEM_ntru_hps2048677;OQS_ENABLE_KEM_ntru_hps4096821;OQS_ENABLE_KEM_ntru_hrss701;OQS_ENABLE_SIG_falcon_1024;OQS_ENABLE_SIG_falcon_512;OQS_ENABLE_SIG_dilithium_2;OQS_ENABLE_SIG_dilithium_3;OQS_ENABLE_SIG_dilithium_5;OQS_ENABLE_SIG_dilithium_2_aes;OQS_ENABLE_SIG_dilithium_3_aes;OQS_ENABLE_SIG_dilithium_5_aes" ..
```

wolfSSL:

```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```

**Note**: We are primarily benchmarking the post-quantum algorithms, but leave some conventional algorithms for comparisson purposes.

### Runtime Binary Sizes

The `tls_bench` example application binary file is 2479992 bytes after being built then stripped (Approximately 2.4M).  Without the `--with-liboqs` it is 571832 bytes after being built then stripped (Approximately 559K). This is a difference of 1908160 bytes (Approximately 1.9Mb).

### TLS 1.3 Data Transmission Sizes

The following results were taken by running the example server and client and recording all information being transmitted via wireshark. This includes the TLS 1.3 handshake with mutual authentication, "hello wolfssl!" and "I hear you fa shizzle!" messages. The `tcp.len` of all packets were summed:

Ciphersuite            | Authentication       | Key Establishment     | Total Bytes
---------------------- | -------------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ECC SECP256R1         | 5455
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL1          | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL3          | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_LEVEL5          | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL1      | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL3      | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | KYBER_90S_LEVEL5      | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | NTRU_HPS_LEVEL1       | 6463
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | NTRU_HPS_LEVEL3       | 6925
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | NTRU_HPS_LEVEL5       | 7525
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | NTRU_HRSS_LEVEL3      | 7341
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SABER_LEVEL1          | 6473
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SABER_LEVEL3          | 7145
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SABER_LEVEL5          | 7849
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER_LEVEL1     | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER_LEVEL3     | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER_LEVEL5     | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER90S_LEVEL1  | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER90S_LEVEL3  | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER90S_LEVEL5  | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_NTRU_HPS_LEVEL1  | 6593
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_NTRU_HPS_LEVEL3  | 7119
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_NTRU_HPS_LEVEL5  | 7791
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_NTRU_HRSS_LEVEL3 | 7535
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_SABER_LEVEL1     | 6603
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_SABER_LEVEL3     | 7339
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_SABER_LEVEL5     | 8115
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | ECC SECP256R1         | 6997
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | ECC SECP256R1         | 11248
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | KYBER_LEVEL1          | 8180
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | P256_KYBER_LEVEL1     | 8308
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | KYBER_LEVEL5          | 14007
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | P521_KYBER_LEVEL5     | 14257
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL2     | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL3     | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL5     | ECC SECP256R1         | 13477
TLS_AES_256_GCM_SHA384 | DILITHIUM_AES_LEVEL2 | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | DILITHIUM_AES_LEVEL3 | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | DILITHIUM_AES_LEVEL5 | ECC SECP256R1         | 13477

### Heap and Stack Usage

These statistics were obtained by adding the following configuration flags: `--enable-trackmemory --enable-stacksize`.

Memory use for server sign and client verify without server authentication of the client, TLS13-AES256-GCM-SHA384 ciphersuite and ECC SECP256R1 for key exchange.

```text
Server FALCON_LEVEL1

stack used     =  48960
total Allocs   =    250
heap total     = 113548
heap peak      =  40990

Client FALCON_LEVEL1

stack used     =  29935
total Allocs   =    768
heap total     = 179427
heap peak      =  41765

Server FALCON_LEVEL5

stack used     =  89088
total Allocs   =    250
heap total     = 125232
heap peak      =  45630

Client FALCON_LEVEL5

stack used     =  29935
total Allocs   =    768
heap total     = 191365
heap peak      =  47469

Server DILITHIUM_LEVEL2

stack used = 56328
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    128153
peak    Bytes    =     50250

Client DILITHIUM_LEVEL2

stack used = 30856
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    206412
peak    Bytes    =     56299

Server DILITHIUM_LEVEL3

stack used = 86216
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    140128
peak    Bytes    =     55161

Client DILITHIUM_LEVEL3

stack used = 33928
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    220633
peak    Bytes    =     61245

Server DILITHIUM_LEVEL5

stack used = 119944
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    152046
peak    Bytes    =     59829

Client DILITHIUM_LEVEL5

stack used = 40328
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    238167
peak    Bytes    =     67049

Server DILITHIUM_AES_LEVEL2

stack used = 59400
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    128153
peak    Bytes    =     50250

Client DILITHIUM_AES_LEVEL2

stack used = 45448
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    206412
peak    Bytes    =     56299

Server DILITHIUM_AES_LEVEL3

stack used = 87048
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    140128
peak    Bytes    =     55161

Client DILITHIUM_AES_LEVEL3

stack used = 66952
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    220633
peak    Bytes    =     61245

Server DILITHIUM_AES_LEVEL5

stack used = 130056
total   Allocs   =       243
total   Deallocs =       243
total   Bytes    =    152046
peak    Bytes    =     59829

Client DILITHIUM_AES_LEVEL5

stack used = 102024
total   Allocs   =       805
total   Deallocs =       805
total   Bytes    =    238167
peak    Bytes    =     67049

Server RSA 2048

stack used     =  52896
total Allocs   =    253
heap total     = 121784
heap peak      =  39573

Client RSA 2048

stack used     =  54640
total Allocs   =    897
heap total     = 202472
heap peak      =  41760
```

Memory use for KEM groups. TLS13-AES256-GCM-SHA384 ciphersuite and RSA-2048 for client authentication of the server and without server authentication of the client.

```text
Server KYBER_LEVEL1

stack used     = 52896
total Allocs   =   206
heap total     = 66864
heap peak      = 28474

Client KYBER_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 147235
heap peak      =  44538

Server KYBER_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67888
heap peak      =  28794

Client KYBER_LEVEL3

stack used     =  54640
total Allocs   =    879
heap total     = 149411
heap peak      =  46010

Server KYBER_LEVEL5

stack used     =  52896
total Allocs   =    206
heap total     =  69232
heap peak      =  29274

Client KYBER_LEVEL5

stack used     =  54640
total Allocs   =    879
heap total     = 151907
heap peak      =  47642

Server KYBER_90S_LEVEL1

stack used     =  52896
total Allocs   =    206
heap total     =  66864
heap peak      =  28474

Client KYBER_90S_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 147235
heap peak      =  44538

Server KYBER_90S_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67888
heap peak      =  28794

Client KYBER_90S_LEVEL3

stack used     =  54640
total Allocs   =    879
heap total     = 149411
heap peak      =  46010

Server KYBER_90S_LEVEL5

stack used     =  52896
total Allocs   =    206
heap total     =  69232
heap peak      =  29274

Client KYBER_90S_LEVEL5

stack used     =  54640
total Allocs   =    879
heap total     = 151907
heap peak      =  47642

Server NTRU_HPS_LEVEL1

stack used     =  52896
total Allocs   =    206
heap total     =  66625
heap peak      =  28405

Client NTRU_HPS_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 146198
heap peak      =  43671

Server NTRU_HPS_LEVEL3

stack used     =  54400
total Allocs   =    206
heap total     =  67318
heap peak      =  28636

Client NTRU_HPS_LEVEL3

stack used     =  56512
total Allocs   =    879
heap total     = 147421
heap peak      =  44432

Server NTRU_HPS_LEVEL5

stack used     =  66528
total Allocs   =    206
heap total     =  68218
heap peak      =  28936

Client NTRU_HPS_LEVEL5

stack used     =  69856
total Allocs   =    879
heap total     = 148977
heap peak      =  45388

Server NTRU_HRSS_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67942
heap peak      =  28844

Client NTRU_HRSS_LEVEL3

stack used     =  54688
total Allocs   =    879
heap total     = 148469
heap peak      =  45064

Server SABER_LEVEL1

stack used     =  52896
total Allocs   =    206
heap total     =  66672
heap peak      =  28442

Client SABER_LEVEL1

stack used     =  54640
total Allocs   =    879
heap total     = 146851
heap peak      =  44314

Server SABER_LEVEL3

stack used     =  52896
total Allocs   =    206
heap total     =  67696
heap peak      =  28794

Client SABER_LEVEL3

stack used     =  54640
total Allocs   =    879
heap total     = 148931
heap peak      =  45722

Server SABER_LEVEL5

stack used     =  52896
total Allocs   =    206
heap total     =  68784
heap peak      =  29178

Client SABER_LEVEL5

stack used     =  54640
total Allocs   =    879
heap total     = 151075
heap peak      =  47162

Server P256_NTRU_HPS_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118701
heap peak      =  37482

Client P256_NTRU_HPS_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 198339
heap peak      =  48065

Server P384_NTRU_HPS_LEVEL3

stack used     =  54400
total Allocs   =    223
heap total     = 119538
heap peak      =  38056

Client P384_NTRU_HPS_LEVEL3

stack used     =  56512
total Allocs   =    896
heap total     = 199738
heap peak      =  48890

Server P521_NTRU_HPS_LEVEL5

stack used     =  66528
total Allocs   =    223
heap total     = 120600
heap peak      =  38782

Client P521_NTRU_HPS_LEVEL5

stack used     =  69856
total Allocs   =    896
heap total     = 201492
heap peak      =  49918

Server P384_NTRU_HRSS_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 120162
heap peak      =  38472

Client P384_NTRU_HRSS_LEVEL3

stack used     =  54688
total Allocs   =    896
heap total     = 200786
heap peak      =  49522

Server P256_SABER_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118748
heap peak      =  37492

Client P256_SABER_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 198992
heap peak      =  48708

Server P384_SABER_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 119916
heap peak      =  38276

Client P384_SABER_LEVEL3

stack used     =  54640
total Allocs   =    896
heap total     = 201248
heap peak      =  50180

Server P521_SABER_LEVEL5

stack used     =  52896
total Allocs   =    223
heap total     = 121166
heap peak      =  39106

Client P521_SABER_LEVEL5

stack used     =  54640
total Allocs   =    896
heap total     = 203590
heap peak      =  51692

Server P256_KYBER_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118940
heap peak      =  37652

Client P256_KYBER_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 199376
heap peak      =  48932

Server P384_KYBER_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 120108
heap peak      =  38468

Client P384_KYBER_LEVEL3

stack used     =  54640
total Allocs   =    896
heap total     = 201728
heap peak      =  50468

Client Server P521_KYBER_LEVEL5

stack used     =  52896
total Allocs   =    223
heap total     = 121614
heap peak      =  39458

Client P521_KYBER_LEVEL5

stack used     =  54640
total Allocs   =    896
heap total     = 204422
heap peak      =  52172

Client Server P256_KYBER_90S_LEVEL1

stack used     =  52896
total Allocs   =    223
heap total     = 118940
heap peak      =  37652

Client P256_KYBER_90S_LEVEL1

stack used     =  54640
total Allocs   =    896
heap total     = 199376
heap peak      =  48932

Server P384_KYBER_90S_LEVEL3

stack used     =  52896
total Allocs   =    223
heap total     = 120108
heap peak      =  38468

Client P384_KYBER_90S_LEVEL3

stack used     =  54640
total Allocs   =    896
heap total     = 201728
heap peak      =  50468

Server P521_KYBER_90S_LEVEL5

stack used     =  52896
total Allocs   =    223
heap total     = 121614
heap peak      =  39458

Client P521_KYBER_90S_LEVEL5

stack used     =  54640
total Allocs   =    896
heap total     = 204422
heap peak      =  52172

Server ECDSA SECP256R1

stack used     =  52896
total Allocs   =    253
heap total     = 121784
heap peak      =  39573

Client ECDSA SECP256R1

stack used     =  54640
total Allocs   =    897
heap total     = 202472
heap peak      =  41760
```

### Benchmarks for KEMs from liboqs

Operation         | Iterations | Total time (s) | Time (us): mean | pop. stdev | CPU cycles: mean | pop. stdev
----------------- | ---------- | -------------- | --------------- | ---------- | ---------------- | ----------
Kyber512          |            |                |                 |            |                  |
keygen            |     443212 |          3.000 |           6.769 |      3.282 |            20223 |       9715
encaps            |     339601 |          3.000 |           8.834 |      4.557 |            26411 |      13574
decaps            |     479954 |          3.000 |           6.251 |      3.594 |            18672 |      10669
Kyber768          |            |                |                 |            |                  |
keygen            |     277967 |          3.000 |          10.793 |      5.490 |            32274 |      16375
encaps            |     225082 |          3.000 |          13.329 |      6.301 |            39871 |      18812
decaps            |     306782 |          3.000 |           9.779 |      5.063 |            29240 |      15097
Kyber1024         |            |                |                 |            |                  |
keygen            |     216179 |          3.000 |          13.877 |      6.734 |            41513 |      20108
encaps            |     164469 |          3.000 |          18.241 |      8.353 |            54579 |      24968
decaps            |     217755 |          3.000 |          13.777 |      6.831 |            41210 |      20396
Kyber512-90s      |            |                |                 |            |                  |
keygen            |     526948 |          3.000 |           5.693 |      2.795 |            17001 |       8235
encaps            |     380383 |          3.000 |           7.887 |      4.225 |            23570 |      12569
decaps            |     638653 |          3.000 |           4.697 |      2.896 |            14020 |       8543
Kyber768-90s      |            |                |                 |            |                  |
keygen            |     394138 |          3.000 |           7.612 |      4.117 |            22746 |      12249
encaps            |     271196 |          3.000 |          11.062 |      5.881 |            33080 |      17557
decaps            |     424172 |          3.000 |           7.073 |      4.189 |            21132 |      12457
Kyber1024-90s     |            |                |                 |            |                  |
keygen            |     278748 |          3.000 |          10.762 |      5.507 |            32182 |      16420
encaps            |     202208 |          3.000 |          14.836 |      7.486 |            44385 |      22368
decaps            |     299571 |          3.000 |          10.014 |      5.489 |            29945 |      16383
NTRU-HPS-2048-509 |            |                |                 |            |                  |
keygen            |      46301 |          3.000 |          64.795 |     16.701 |           194015 |      50000
encaps            |      78698 |          3.000 |          38.121 |      8.310 |           114118 |      24821
decaps            |     366144 |          3.000 |           8.194 |      3.948 |            24492 |      11728
NTRU-HPS-2048-677 |            |                |                 |            |                  |
keygen            |      31879 |          3.000 |          94.107 |     19.639 |           281801 |      58801
encaps            |      58821 |          3.000 |          51.003 |     12.376 |           152701 |      37024
decaps            |     251427 |          3.000 |          11.932 |      4.449 |            35680 |      13249
NTRU-HPS-4096-821 |            |                |                 |            |                  |
keygen            |      23351 |          3.000 |         128.477 |     15.517 |           384748 |      46459
encaps            |      49048 |          3.000 |          61.165 |     12.461 |           183130 |      37276
decaps            |     191469 |          3.000 |          15.668 |      6.390 |            46875 |      19078
NTRU-HRSS-701     |            |                |                 |            |                  |
keygen            |      41514 |          3.000 |          72.266 |     10.830 |           216388 |      32400
encaps            |     122047 |          3.000 |          24.581 |      6.468 |            73562 |      19290
decaps            |     233589 |          3.000 |          12.843 |      4.211 |            38414 |      12537
LightSaber-KEM    |            |                |                 |            |                  |
keygen            |     264788 |          3.000 |          11.330 |      3.336 |            33884 |       9908
encaps            |     225726 |          3.000 |          13.290 |      4.130 |            39756 |      12298
decaps            |     250495 |          3.000 |          11.976 |      3.569 |            35817 |      10594
Saber-KEM         |            |                |                 |            |                  |
keygen            |     166950 |          3.000 |          17.970 |      6.209 |            53771 |      18539
encaps            |     143690 |          3.000 |          20.878 |      6.585 |            62483 |      19681
decaps            |     150820 |          3.000 |          19.891 |      4.133 |            59522 |      12307
FireSaber-KEM     |            |                |                 |            |                  |
keygen            |     114294 |          3.000 |          26.248 |      7.019 |            78564 |      20972
encaps            |      99143 |          3.000 |          30.260 |      7.699 |            90581 |      23027
decaps            |     105066 |          3.000 |          28.554 |      6.322 |            85470 |      18906

### Benchmarks

The following benchmarks were obtained with the following configuration flags:

```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256 -DHAVE_ECC384"
```

#### Benchmarks from wolfCrypt

**Note**: Only a single core is used.

```text
ECC   SECP256R1 key gen    95600 ops took 1.000 sec, avg 0.010 ms, 95555.939 ops/sec
ECDHE SECP256R1 agree      26100 ops took 1.002 sec, avg 0.038 ms, 26038.522 ops/sec
ECDSA SECP256R1 sign       63400 ops took 1.001 sec, avg 0.016 ms, 63320.787 ops/sec
ECDSA SECP256R1 verify     24000 ops took 1.000 sec, avg 0.042 ms, 23994.983 ops/sec
FALCON_level1   sign        5000 ops took 1.008 sec, avg 0.202 ms, 4961.637 ops/sec
FALCON_level1   verify     27400 ops took 1.001 sec, avg 0.037 ms, 27361.394 ops/sec
FALCON_level5   sign        2600 ops took 1.030 sec, avg 0.396 ms, 2523.187 ops/sec
FALCON_level5   verify     14400 ops took 1.002 sec, avg 0.070 ms, 14376.179 ops/sec
DILITHIUM_level2 sign      16200 ops took 1.003 sec, avg 0.062 ms, 16150.689 ops/sec
DILITHIUM_level2 verify    44500 ops took 1.000 sec, avg 0.022 ms, 44478.388 ops/sec
DILITHIUM_level3 sign      10200 ops took 1.002 sec, avg 0.098 ms, 10179.570 ops/sec
DILITHIUM_level3 verify    27100 ops took 1.003 sec, avg 0.037 ms, 27017.485 ops/sec
DILITHIUM_level5 sign       8400 ops took 1.009 sec, avg 0.120 ms, 8321.684 ops/sec
DILITHIUM_level5 verify    17000 ops took 1.004 sec, avg 0.059 ms, 16933.788 ops/sec
DILITHIUM_AES_level2 sign   2400 ops took 1.023 sec, avg 0.426 ms, 2346.733 ops/sec
DILITHIUM_AES_level2 verify 6600 ops took 1.001 sec, avg 0.152 ms, 6590.957 ops/sec
DILITHIUM_AES_level3 sign   1500 ops took 1.026 sec, avg 0.684 ms, 1461.933 ops/sec
DILITHIUM_AES_level3 verify 3900 ops took 1.012 sec, avg 0.260 ms, 3851.921 ops/sec
DILITHIUM_AES_level5 sign   1100 ops took 1.008 sec, avg 0.916 ms, 1091.518 ops/sec
DILITHIUM_AES_level5 verify 2200 ops took 1.034 sec, avg 0.470 ms, 2127.939 ops/sec
kyber_level1-kg           143608 ops took 1.000 sec, avg 0.007 ms, 143607.555 ops/sec
kyber_level1-ed            64800 ops took 1.001 sec, avg 0.015 ms, 64725.835 ops/sec
kyber_level3-kg            89790 ops took 1.000 sec, avg 0.011 ms, 89789.550 ops/sec
kyber_level3-ed            42200 ops took 1.000 sec, avg 0.024 ms, 42190.886 ops/sec
kyber_level5-kg            69362 ops took 1.000 sec, avg 0.014 ms, 69361.587 ops/sec
kyber_level5-ed            31700 ops took 1.003 sec, avg 0.032 ms, 31606.130 ops/sec
kyber90s_level1-kg        173655 ops took 1.000 sec, avg 0.006 ms, 173654.131 ops/sec
kyber90s_level1-ed         77500 ops took 1.001 sec, avg 0.013 ms, 77424.888 ops/sec
kyber90s_level3-kg        125138 ops took 1.000 sec, avg 0.008 ms, 125138.000 ops/sec
kyber90s_level3-ed         55200 ops took 1.001 sec, avg 0.018 ms, 55153.726 ops/sec
kyber90s_level5-kg         92773 ops took 1.000 sec, avg 0.011 ms, 92772.359 ops/sec
kyber90s_level5-ed         39300 ops took 1.000 sec, avg 0.025 ms, 39283.188 ops/sec
saber_level1-kg            86059 ops took 1.000 sec, avg 0.012 ms, 86058.220 ops/sec
saber_level1-ed            39000 ops took 1.002 sec, avg 0.026 ms, 38918.772 ops/sec
saber_level3-kg            54885 ops took 1.000 sec, avg 0.018 ms, 54884.621 ops/sec
saber_level3-ed            24600 ops took 1.001 sec, avg 0.041 ms, 24578.348 ops/sec
saber_level5-kg            37044 ops took 1.000 sec, avg 0.027 ms, 37043.073 ops/sec
saber_level5-ed            16800 ops took 1.005 sec, avg 0.060 ms, 16711.448 ops/sec
ntruHPS_level1-kg          15230 ops took 1.000 sec, avg 0.066 ms, 15229.786 ops/sec
ntruHPS_level1-ed          21600 ops took 1.003 sec, avg 0.046 ms, 21525.585 ops/sec
ntruHPS_level3-kg          10423 ops took 1.000 sec, avg 0.096 ms, 10422.468 ops/sec
ntruHPS_level3-ed          16000 ops took 1.005 sec, avg 0.063 ms, 15915.107 ops/sec
ntruHPS_level5-kg           7792 ops took 1.000 sec, avg 0.128 ms, 7791.166 ops/sec
ntruHPS_level5-ed          12800 ops took 1.005 sec, avg 0.079 ms, 12732.759 ops/sec
ntruHRSS_level3-kg         14293 ops took 1.000 sec, avg 0.070 ms, 14292.813 ops/sec
ntruHRSS_level3-ed         26200 ops took 1.001 sec, avg 0.038 ms, 26169.901 ops/sec
```

#### Benchmarks from wolfSSL

**Note**: Only two cores are used for these benchmarks.

```text
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
    Total       : 209715200 bytes
    Num Conns   :       801
    Rx Total    :   238.549 ms
    Tx Total    :    80.893 ms
    Rx          :   419.200 MB/s
    Tx          :  1236.204 MB/s
    Connect     :   552.092 ms
    Connect Avg :     0.689 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
    Total       : 209715200 bytes
    Num Conns   :       801
    Rx Total    :   264.171 ms
    Tx Total    :    77.399 ms
    Rx          :   378.542 MB/s
    Tx          :  1292.002 MB/s
    Connect     :   550.630 ms
    Connect Avg :     0.687 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
    Total       : 164626432 bytes
    Num Conns   :       629
    Rx Total    :   207.183 ms
    Tx Total    :    68.783 ms
    Rx          :   378.892 MB/s
    Tx          :  1141.270 MB/s
    Connect     :   508.584 ms
    Connect Avg :     0.809 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
    Total       : 164626432 bytes
    Num Conns   :       629
    Rx Total    :   228.902 ms
    Tx Total    :    65.852 ms
    Rx          :   342.942 MB/s
    Tx          :  1192.073 MB/s
    Connect     :   506.299 ms
    Connect Avg :     0.805 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group FFDHE_2048:
    Total       : 125829120 bytes
    Num Conns   :       481
    Rx Total    :   158.742 ms
    Tx Total    :    53.102 ms
    Rx          :   377.971 MB/s
    Tx          :  1129.896 MB/s
    Connect     :   579.937 ms
    Connect Avg :     1.206 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group FFDHE_2048:
    Total       : 125829120 bytes
    Num Conns   :       481
    Rx Total    :   175.313 ms
    Tx Total    :    50.565 ms
    Rx          :   342.245 MB/s
    Tx          :  1186.597 MB/s
    Connect     :   582.023 ms
    Connect Avg :     1.210 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL1:
    Total       : 223870976 bytes
    Num Conns   :       855
    Rx Total    :   206.061 ms
    Tx Total    :    73.457 ms
    Rx          :   518.050 MB/s
    Tx          :  1453.236 MB/s
    Connect     :   653.398 ms
    Connect Avg :     0.764 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL1:
    Total       : 223870976 bytes
    Num Conns   :       855
    Rx Total    :   225.233 ms
    Tx Total    :    73.139 ms
    Rx          :   473.954 MB/s
    Tx          :  1459.555 MB/s
    Connect     :   593.594 ms
    Connect Avg :     0.694 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL3:
    Total       : 201326592 bytes
    Num Conns   :       769
    Rx Total    :   229.987 ms
    Tx Total    :    77.896 ms
    Rx          :   417.415 MB/s
    Tx          :  1232.414 MB/s
    Connect     :   626.743 ms
    Connect Avg :     0.815 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL3:
    Total       : 201326592 bytes
    Num Conns   :       769
    Rx Total    :   255.993 ms
    Tx Total    :    73.714 ms
    Rx          :   375.010 MB/s
    Tx          :  1302.339 MB/s
    Connect     :   546.414 ms
    Connect Avg :     0.711 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL5:
    Total       : 184811520 bytes
    Num Conns   :       706
    Rx Total    :   240.630 ms
    Tx Total    :    80.439 ms
    Rx          :   366.227 MB/s
    Tx          :  1095.556 MB/s
    Connect     :   615.752 ms
    Connect Avg :     0.872 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL5:
    Total       : 184811520 bytes
    Num Conns   :       706
    Rx Total    :   265.831 ms
    Tx Total    :    76.551 ms
    Rx          :   331.507 MB/s
    Tx          :  1151.190 MB/s
    Connect     :   518.052 ms
    Connect Avg :     0.734 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HRSS_LEVEL3:
    Total       : 200015872 bytes
    Num Conns   :       764
    Rx Total    :   254.178 ms
    Tx Total    :    84.765 ms
    Rx          :   375.229 MB/s
    Tx          :  1125.170 MB/s
    Connect     :   593.726 ms
    Connect Avg :     0.777 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HRSS_LEVEL3:
    Total       : 200015872 bytes
    Num Conns   :       764
    Rx Total    :   283.824 ms
    Tx Total    :    78.988 ms
    Rx          :   336.036 MB/s
    Tx          :  1207.468 MB/s
    Connect     :   534.100 ms
    Connect Avg :     0.699 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL1:
    Total       : 231997440 bytes
    Num Conns   :       886
    Rx Total    :   238.008 ms
    Tx Total    :    83.135 ms
    Rx          :   464.794 MB/s
    Tx          :  1330.669 MB/s
    Connect     :   606.426 ms
    Connect Avg :     0.684 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL1:
    Total       : 231997440 bytes
    Num Conns   :       886
    Rx Total    :   260.860 ms
    Tx Total    :    81.655 ms
    Rx          :   424.078 MB/s
    Tx          :  1354.781 MB/s
    Connect     :   595.205 ms
    Connect Avg :     0.672 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   261.907 ms
    Tx Total    :    89.980 ms
    Rx          :   379.906 MB/s
    Tx          :  1105.803 MB/s
    Connect     :   575.366 ms
    Connect Avg :     0.722 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   293.557 ms
    Tx Total    :    82.148 ms
    Rx          :   338.946 MB/s
    Tx          :  1211.234 MB/s
    Connect     :   562.923 ms
    Connect Avg :     0.706 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL5:
    Total       : 202637312 bytes
    Num Conns   :       774
    Rx Total    :   261.647 ms
    Tx Total    :    86.347 ms
    Rx          :   369.296 MB/s
    Tx          :  1119.027 MB/s
    Connect     :   578.236 ms
    Connect Avg :     0.747 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL5:
    Total       : 202637312 bytes
    Num Conns   :       774
    Rx Total    :   291.510 ms
    Tx Total    :    80.714 ms
    Rx          :   331.463 MB/s
    Tx          :  1197.121 MB/s
    Connect     :   562.333 ms
    Connect Avg :     0.727 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
    Total       : 225968128 bytes
    Num Conns   :       863
    Rx Total    :   258.872 ms
    Tx Total    :    87.586 ms
    Rx          :   416.229 MB/s
    Tx          :  1230.220 MB/s
    Connect     :   580.184 ms
    Connect Avg :     0.672 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
    Total       : 225968128 bytes
    Num Conns   :       863
    Rx Total    :   285.086 ms
    Tx Total    :    84.362 ms
    Rx          :   377.956 MB/s
    Tx          :  1277.233 MB/s
    Connect     :   574.039 ms
    Connect Avg :     0.665 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
    Total       : 214171648 bytes
    Num Conns   :       818
    Rx Total    :   241.450 ms
    Tx Total    :    80.798 ms
    Rx          :   422.965 MB/s
    Tx          :  1263.960 MB/s
    Connect     :   603.945 ms
    Connect Avg :     0.738 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
    Total       : 214171648 bytes
    Num Conns   :       818
    Rx Total    :   263.357 ms
    Tx Total    :    81.142 ms
    Rx          :   387.781 MB/s
    Tx          :  1258.593 MB/s
    Connect     :   596.085 ms
    Connect Avg :     0.729 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
    Total       : 206307328 bytes
    Num Conns   :       788
    Rx Total    :   249.636 ms
    Tx Total    :    84.465 ms
    Rx          :   394.073 MB/s
    Tx          :  1164.683 MB/s
    Connect     :   589.028 ms
    Connect Avg :     0.747 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
    Total       : 206307328 bytes
    Num Conns   :       788
    Rx Total    :   276.059 ms
    Tx Total    :    81.856 ms
    Rx          :   356.355 MB/s
    Tx          :  1201.798 MB/s
    Connect     :   580.463 ms
    Connect Avg :     0.737 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
    Total       : 226754560 bytes
    Num Conns   :       866
    Rx Total    :   249.504 ms
    Tx Total    :    86.285 ms
    Rx          :   433.360 MB/s
    Tx          :  1253.120 MB/s
    Connect     :   590.655 ms
    Connect Avg :     0.682 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
    Total       : 226754560 bytes
    Num Conns   :       866
    Rx Total    :   274.258 ms
    Tx Total    :    83.674 ms
    Rx          :   394.246 MB/s
    Tx          :  1292.214 MB/s
    Connect     :   585.395 ms
    Connect Avg :     0.676 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   253.840 ms
    Tx Total    :    86.227 ms
    Rx          :   391.979 MB/s
    Tx          :  1153.925 MB/s
    Connect     :   584.268 ms
    Connect Avg :     0.733 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
    Total       : 208666624 bytes
    Num Conns   :       797
    Rx Total    :   279.104 ms
    Tx Total    :    83.607 ms
    Rx          :   356.499 MB/s
    Tx          :  1190.096 MB/s
    Connect     :   580.950 ms
    Connect Avg :     0.729 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
    Total       : 205783040 bytes
    Num Conns   :       786
    Rx Total    :   255.324 ms
    Tx Total    :    85.233 ms
    Rx          :   384.316 MB/s
    Tx          :  1151.260 MB/s
    Connect     :   583.899 ms
    Connect Avg :     0.743 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
    Total       : 205783040 bytes
    Num Conns   :       786
    Rx Total    :   281.997 ms
    Tx Total    :    82.461 ms
    Rx          :   347.964 MB/s
    Tx          :  1189.958 MB/s
    Connect     :   579.312 ms
    Connect Avg :     0.737 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_NTRU_HPS_LEVEL1:
    Total       : 177209344 bytes
    Num Conns   :       677
    Rx Total    :   196.108 ms
    Tx Total    :    66.449 ms
    Rx          :   430.884 MB/s
    Tx          :  1271.653 MB/s
    Connect     :   676.839 ms
    Connect Avg :     1.000 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_NTRU_HPS_LEVEL1:
    Total       : 177209344 bytes
    Num Conns   :       677
    Rx Total    :   214.290 ms
    Tx Total    :    65.610 ms
    Rx          :   394.325 MB/s
    Tx          :  1287.919 MB/s
    Connect     :   573.611 ms
    Connect Avg :     0.847 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HPS_LEVEL3:
    Total       : 123731968 bytes
    Num Conns   :       473
    Rx Total    :   154.804 ms
    Tx Total    :    52.294 ms
    Rx          :   381.126 MB/s
    Tx          :  1128.231 MB/s
    Connect     :   748.152 ms
    Connect Avg :     1.582 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HPS_LEVEL3:
    Total       : 123731968 bytes
    Num Conns   :       473
    Rx Total    :   171.147 ms
    Tx Total    :    49.521 ms
    Rx          :   344.733 MB/s
    Tx          :  1191.409 MB/s
    Connect     :   566.689 ms
    Connect Avg :     1.198 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HRSS_LEVEL3:
    Total       : 129499136 bytes
    Num Conns   :       495
    Rx Total    :   148.598 ms
    Tx Total    :    50.665 ms
    Rx          :   415.550 MB/s
    Tx          :  1218.781 MB/s
    Connect     :   754.638 ms
    Connect Avg :     1.525 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HRSS_LEVEL3:
    Total       : 129499136 bytes
    Num Conns   :       495
    Rx Total    :   163.812 ms
    Tx Total    :    49.151 ms
    Rx          :   376.956 MB/s
    Tx          :  1256.340 MB/s
    Connect     :   582.980 ms
    Connect Avg :     1.178 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_SABER_LEVEL1:
    Total       : 187170816 bytes
    Num Conns   :       715
    Rx Total    :   209.798 ms
    Tx Total    :    72.956 ms
    Rx          :   425.409 MB/s
    Tx          :  1223.339 MB/s
    Connect     :   653.239 ms
    Connect Avg :     0.914 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_SABER_LEVEL1:
    Total       : 187170816 bytes
    Num Conns   :       715
    Rx Total    :   230.841 ms
    Tx Total    :    70.056 ms
    Rx          :   386.629 MB/s
    Tx          :  1273.977 MB/s
    Connect     :   589.748 ms
    Connect Avg :     0.825 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_SABER_LEVEL3:
    Total       : 140509184 bytes
    Num Conns   :       537
    Rx Total    :   136.204 ms
    Tx Total    :    49.031 ms
    Rx          :   491.907 MB/s
    Tx          :  1366.489 MB/s
    Connect     :   768.874 ms
    Connect Avg :     1.432 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_SABER_LEVEL3:
    Total       : 140509184 bytes
    Num Conns   :       537
    Rx Total    :   149.070 ms
    Tx Total    :    48.039 ms
    Rx          :   449.453 MB/s
    Tx          :  1394.687 MB/s
    Connect     :   625.833 ms
    Connect Avg :     1.165 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
    Total       : 182190080 bytes
    Num Conns   :       696
    Rx Total    :   219.789 ms
    Tx Total    :    75.536 ms
    Rx          :   395.266 MB/s
    Tx          :  1150.114 MB/s
    Connect     :   641.859 ms
    Connect Avg :     0.922 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
    Total       : 182190080 bytes
    Num Conns   :       696
    Rx Total    :   241.393 ms
    Tx Total    :    72.367 ms
    Rx          :   359.890 MB/s
    Tx          :  1200.483 MB/s
    Connect     :   581.373 ms
    Connect Avg :     0.835 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
    Total       : 133431296 bytes
    Num Conns   :       510
    Rx Total    :   152.666 ms
    Tx Total    :    53.693 ms
    Rx          :   416.760 MB/s
    Tx          :  1184.982 MB/s
    Connect     :   743.577 ms
    Connect Avg :     1.458 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
    Total       : 133431296 bytes
    Num Conns   :       510
    Rx Total    :   169.131 ms
    Tx Total    :    50.632 ms
    Rx          :   376.188 MB/s
    Tx          :  1256.605 MB/s
    Connect     :   611.105 ms
    Connect Avg :     1.198 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
    Total       : 191102976 bytes
    Num Conns   :       730
    Rx Total    :   211.835 ms
    Tx Total    :    72.819 ms
    Rx          :   430.170 MB/s
    Tx          :  1251.386 MB/s
    Connect     :   651.010 ms
    Connect Avg :     0.892 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
    Total       : 191102976 bytes
    Num Conns   :       730
    Rx Total    :   233.104 ms
    Tx Total    :    70.994 ms
    Rx          :   390.919 MB/s
    Tx          :  1283.561 MB/s
    Connect     :   589.063 ms
    Connect Avg :     0.807 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
    Total       : 136052736 bytes
    Num Conns   :       520
    Rx Total    :   168.780 ms
    Tx Total    :    57.603 ms
    Rx          :   384.376 MB/s
    Tx          :  1126.236 MB/s
    Connect     :   723.880 ms
    Connect Avg :     1.392 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
    Total       : 136052736 bytes
    Num Conns   :       520
    Rx Total    :   189.078 ms
    Tx Total    :    52.841 ms
    Rx          :   343.112 MB/s
    Tx          :  1227.747 MB/s
    Connect     :   594.282 ms
    Connect Avg :     1.143 ms
```

The following benchmarks were obtained with the following configuration flags:

```text
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math-all \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC521"
```

**Note**: Only two cores are used for these benchmarks.

```text
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
    Total       :  22806528 bytes
    Num Conns   :        88
    Rx Total    :    29.526 ms
    Tx Total    :     9.423 ms
    Rx          :   368.325 MB/s
    Tx          :  1154.060 MB/s
    Connect     :   447.201 ms
    Connect Avg :     5.082 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
    Total       :  22806528 bytes
    Num Conns   :        88
    Rx Total    :    32.363 ms
    Tx Total    :     9.206 ms
    Rx          :   336.028 MB/s
    Tx          :  1181.257 MB/s
    Connect     :   442.915 ms
    Connect Avg :     5.033 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_NTRU_HPS_LEVEL5:
    Total       :  13631488 bytes
    Num Conns   :        53
    Rx Total    :    23.578 ms
    Tx Total    :     6.093 ms
    Rx          :   275.676 MB/s
    Tx          :  1066.835 MB/s
    Connect     :   977.259 ms
    Connect Avg :    18.439 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_NTRU_HPS_LEVEL5:
    Total       :  13631488 bytes
    Num Conns   :        53
    Rx Total    :    26.030 ms
    Tx Total    :     5.735 ms
    Rx          :   249.711 MB/s
    Tx          :  1133.407 MB/s
    Connect     :   651.191 ms
    Connect Avg :    12.287 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_SABER_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    17.298 ms
    Tx Total    :     5.341 ms
    Rx          :   361.309 MB/s
    Tx          :  1170.286 MB/s
    Connect     :   977.262 ms
    Connect Avg :    19.162 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_SABER_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    19.302 ms
    Tx Total    :     5.038 ms
    Rx          :   323.794 MB/s
    Tx          :  1240.683 MB/s
    Connect     :   662.081 ms
    Connect Avg :    12.982 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
    Total       :  10747904 bytes
    Num Conns   :        42
    Rx Total    :     8.199 ms
    Tx Total    :    30.942 ms
    Rx          :   625.096 MB/s
    Tx          :   165.633 MB/s
    Connect     :   958.292 ms
    Connect Avg :    22.816 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
    Total       :  10747904 bytes
    Num Conns   :        42
    Rx Total    :     9.919 ms
    Tx Total    :     3.685 ms
    Rx          :   516.689 MB/s
    Tx          :  1390.684 MB/s
    Connect     :   679.437 ms
    Connect Avg :    16.177 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    19.132 ms
    Tx Total    :     6.887 ms
    Rx          :   326.680 MB/s
    Tx          :   907.481 MB/s
    Connect     :   976.107 ms
    Connect Avg :    19.139 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
    Total       :  13107200 bytes
    Num Conns   :        51
    Rx Total    :    23.578 ms
    Tx Total    :     5.039 ms
    Rx          :   265.078 MB/s
    Tx          :  1240.273 MB/s
    Connect     :   673.107 ms
    Connect Avg :    13.198 ms
```

## Documentation

Technical documentation and other resources such as known answer tests can be found at the NIST PQC website:

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.

For more algorithm-specific benchmarking information, the OQS Project has benchmarking information at their website:

<https://openquantumsafe.org/benchmarking/>
