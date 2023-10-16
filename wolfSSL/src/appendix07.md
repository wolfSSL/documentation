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

**Note**: SABER KEM and NTRU KEM were deprecated and removed as they did not
          move on to standardization.

**Note**: KYBER KEM 90s variants were deprecated and removed as NIST is not
          considering them for standardization.

**Note**: Dilithium Signature Scheme's AES variants were deprecated and removed
          as NIST is not considering them for standardization.

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

Post-Quantum Hybrid KEM Naming Convention:

wolfSSL Variant Name  |  NIST ECC Curve and PQC Submission Variant Name
--------------------  |  ----------------------------------------------
P256_KYBER_LEVEL1     |  ECDSA P-256 and KYBER512
P384_KYBER_LEVEL3     |  ECDSA P-384 and KYBER768
P521_KYBER_LEVEL5     |  ECDSA P-521 and KYBER1024

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
KYBER_LEVEL1          |  570
KYBER_LEVEL3          |  572
KYBER_LEVEL5          |  573
P256_KYBER_LEVEL1     |  12090
P384_KYBER_LEVEL3     |  12092
P521_KYBER_LEVEL5     |  12093

Post-Quantum OIDs for Certificates:

wolfSSL Variant Name  |  OID
--------------------  |  ---
FALCON_LEVEL1         |  1.3.9999.3.1
FALCON_LEVEL5         |  1.3.9999.3.4
DILITHIUM_LEVEL2      |  1.3.6.1.4.1.2.267.7.4.4
DILITHIUM_LEVEL3      |  1.3.6.1.4.1.2.267.7.6.5
DILITHIUM_LEVEL5      |  1.3.6.1.4.1.2.267.7.8.7
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

**Note**: We are primarily benchmarking the post-quantum algorithms, but leave some conventional algorithms for comparison purposes.

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
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER_LEVEL1     | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER_LEVEL3     | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER_LEVEL5     | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P256_KYBER90S_LEVEL1  | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P384_KYBER90S_LEVEL3  | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | P521_KYBER90S_LEVEL5  | 8467
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | ECC SECP256R1         | 6997
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | ECC SECP256R1         | 11248
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | KYBER_LEVEL1          | 8180
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1        | P256_KYBER_LEVEL1     | 8308
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | KYBER_LEVEL5          | 14007
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5        | P521_KYBER_LEVEL5     | 14257
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL2     | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL3     | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | DILITHIUM_LEVEL5     | ECC SECP256R1         | 13477

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

## Post-Quantum Stateful Hash-Based Signatures

This section covers post-quantum stateful hash-based signature (HBS) schemes such as LMS/HSS, and XMSS/XMSS^MT, for which wolfSSL has recently added support.

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

wolfSSL is adding support for the LMS/HSS hash-based signature scheme to our wolfCrypt embedded crypto engine. This will be achieved by experimental integration with the hash-sigs LMS/HSS library (<https://github.com/cisco/hash-sigs>), similar to our previous libOQS integration.

Leighton-Micali Signatures (LMS), and its multi-tree variant, the Hierarchical Signature System (HSS), is a post-quantum, stateful hash-based signature scheme. It is noted for having small public and private keys, and fast signing and verifying. Its signature sizes are larger, but are tunable via its Winternitz parameter. See these two links from RFC8554 for more details:

- LMS: <https://datatracker.ietf.org/doc/html/rfc8554>
- HSS: <https://datatracker.ietf.org/doc/html/rfc8554#section-6>

As previously discussed, the LMS/HSS signature system consists of a finite number of one-time signature (OTS) keys, and thus may only safely generate a finite number of signatures. However the number of signatures, and the signature size, are tunable via a set of defined parameters, which will be discussed next.

#### Supported Parameters

LMS/HSS signatures are defined by 3 parameters:
- levels: number of levels of Merkle trees.
- height: height of an individual Merkle tree.
- Winternitz: number of bits from hash used in a Winternitz chain. Used as a space-time tradeoff for the signature size.

wolfSSL supports all LMS/HSS parameters defined in RFC8554:

- levels = {1..8}
- height = {5, 10, 15, 20, 25}
- Winternitz = {1, 2, 4, 8}

The number of available signatures is:
- N = 2 ** (levels * height)

For convenience some parameter sets have been predefined in the enum `wc_LmsParm`. Its values are shown in the table below:

parameter set |  description
--------------------  |  ---------------------------
WC_LMS_PARM_NONE      | Not set, use default (WC_LMS_PARM_L1_H15_W2)
WC_LMS_PARM_L1_H15_W2 | 1 level Merkle tree of 15 height, Winternitz 2
WC_LMS_PARM_L1_H15_W4 | same as above, Winternitz 4
WC_LMS_PARM_L2_H10_W2 | 2 level Merkle tree of 10 height, Winternitz 4
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
- Larger winternitz values will reduce the signature size, at the expense of longer key generation and sign/verify times.

Key generation time is strongly determined by the height of the first level tree. A 3 level, 5 height tree is much faster than 1 level, 15 height at initial key gen, even if the number of available signatures is the same.

#### LMS/HSS Build Instructions

Please see the wolfSSL repo's INSTALL file (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL). Item 17 (Building with hash-sigs lib for LMS/HSS support [EXPERIMENTAL]) has instructions on how to configure and build wolfSSL and the hash-sigs LMS/HSS library.

#### Benchmark Data

The following benchmark data was taken on an 8-core Intel i7-8700 CPU @ 3.20GHz, on Fedora 38 (`6.2.9-300.fc38.x86_64`). The multi-threaded example used 4 worker threads and 4 cores, while the single-threaded example used only a single core.

As discussed in item 17 of the INSTALL file, the hash-sigs lib offers two static libraries:
- `hss_lib.a`: a single-threaded version.
- `hss_lib_thread.a`: a multi-threaded version.

The multi-threaded version will spawn worker threads to accelerate cpu intensive tasks, such as key generation.  This will mainly speedup key generation and signing for all parameter values, and to a lesser extent will speedup verifying for larger levels values.

For reference, wolfSSL was built with the following to obtain both benchmarks:

```text
  ./configure \
    --enable-static \
    --disable-shared \
    --enable-lms=yes \
    --with-liblms=<path to hash sigs install>
```

**multi-threaded benchmark**

The following is benchmark data obtained when built against the multi-threaded `hss_lib_thread.a`, which used 4 worker threads to parallelize intensive tasks, and used 4 cores.

```text
./wolfcrypt/benchmark/benchmark -lms_hss
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
LMS/HSS L2_H10_W2  9300     sign      1500 ops took 1.075 sec, avg 0.717 ms, 1394.969 ops/sec
LMS/HSS L2_H10_W2  9300   verify      5200 ops took 1.002 sec, avg 0.193 ms, 5189.238 ops/sec
LMS/HSS L2_H10_W4  5076     sign       800 ops took 1.012 sec, avg 1.265 ms, 790.776 ops/sec
LMS/HSS L2_H10_W4  5076   verify      2500 ops took 1.003 sec, avg 0.401 ms, 2493.584 ops/sec
LMS/HSS L3_H5_W4  7160     sign      1500 ops took 1.051 sec, avg 0.701 ms, 1427.485 ops/sec
LMS/HSS L3_H5_W4  7160   verify      2700 ops took 1.024 sec, avg 0.379 ms, 2636.899 ops/sec
LMS/HSS L3_H5_W8  3992     sign       300 ops took 1.363 sec, avg 4.545 ms, 220.030 ops/sec
LMS/HSS L3_H5_W8  3992   verify       400 ops took 1.066 sec, avg 2.664 ms, 375.335 ops/sec
LMS/HSS L3_H10_W4  7640     sign       900 ops took 1.090 sec, avg 1.211 ms, 825.985 ops/sec
LMS/HSS L3_H10_W4  7640   verify      2400 ops took 1.037 sec, avg 0.432 ms, 2314.464 ops/sec
LMS/HSS L4_H5_W8  5340     sign       300 ops took 1.310 sec, avg 4.367 ms, 228.965 ops/sec
LMS/HSS L4_H5_W8  5340   verify       400 ops took 1.221 sec, avg 3.053 ms, 327.599 ops/sec
Benchmark complete
```

**single-threaded benchmark**

The following is benchmark data obtained when built against the single-threaded `hss_lib.a`,
which will use only a single core.

```text
$ ./wolfcrypt/benchmark/benchmark -lms_hss
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
LMS/HSS L2_H10_W2  9300     sign       800 ops took 1.115 sec, avg 1.394 ms, 717.589 ops/sec
LMS/HSS L2_H10_W2  9300   verify      4500 ops took 1.001 sec, avg 0.223 ms, 4493.623 ops/sec
LMS/HSS L2_H10_W4  5076     sign       500 ops took 1.239 sec, avg 2.478 ms, 403.519 ops/sec
LMS/HSS L2_H10_W4  5076   verify      2100 ops took 1.006 sec, avg 0.479 ms, 2087.944 ops/sec
LMS/HSS L3_H5_W4  7160     sign       800 ops took 1.079 sec, avg 1.349 ms, 741.523 ops/sec
LMS/HSS L3_H5_W4  7160   verify      1600 ops took 1.012 sec, avg 0.632 ms, 1581.686 ops/sec
LMS/HSS L3_H5_W8  3992     sign       100 ops took 1.042 sec, avg 10.420 ms, 95.971 ops/sec
LMS/HSS L3_H5_W8  3992   verify       200 ops took 1.220 sec, avg 6.102 ms, 163.894 ops/sec
LMS/HSS L3_H10_W4  7640     sign       400 ops took 1.010 sec, avg 2.526 ms, 395.864 ops/sec
LMS/HSS L3_H10_W4  7640   verify      1500 ops took 1.052 sec, avg 0.701 ms, 1426.284 ops/sec
LMS/HSS L4_H5_W8  5340     sign       100 ops took 1.066 sec, avg 10.665 ms, 93.768 ops/sec
LMS/HSS L4_H5_W8  5340   verify       200 ops took 1.478 sec, avg 7.388 ms, 135.358 ops/sec
Benchmark complete
```

### XMSS/XMSS^MT signatures

wolfSSL is adding support for XMSS/XMSS^MT stateful hash-based signatures. Similar to LMS, this
will be done by experimental integration with the xmss-reference repository
(https://github.com/XMSS/xmss-reference.git), from RFC 8391
(https://www.rfc-editor.org/rfc/rfc8391.html).

The xmss-reference supports `xmss_core_fast`, and `xmss_core` implementations. The `xmss_core_fast`
implementation was designed to prioritize performance with larger private key sizes as a tradeoff.
Our integration uses `xmss_core_fast`, with a patch applied so that the wolfCrypt SHA256 implementation
may be used instead.

The patch may be found here
```pq/stateful_hash_sig/0001-Patch-to-support-wolfSSL-xmss-reference-integration.patch```
in the wolfssl-examples repository: https://github.com/wolfSSL/wolfssl-examples.

Overall, XMSS/XMSS^MT is similar to LMS/HSS. For a more detailed comparison see
"LMS vs XMSS: Comparison of two Hash-Based Signature Standards" (https://eprint.iacr.org/2017/349.pdf).


XMSS^MT is the Multi-Tree generalization of XMSS,
analogous to HSS with LMS, with the distinction that the Winternitz value is fixed to `w=16` in
XMSS/XMSS^MT. The public key is slightly larger in XMSS/XMSS^MT (at 68 bytes in XMSS/XMSS^MT, vs 60 bytes in LMS/HSS), while signatures are slightly smaller.

#### Supported Parameters

wolfSSL supports the SHA256 XMSS/XMSS^MT parameter sets from Tables 10 and 11 from NIST SP 800-208 (https://csrc.nist.gov/pubs/sp/800/208/final).

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
 
#### Benchmark Data

In the following, benchmark data is shown for several XMSS/XMSS^MT parameter sets,
for intel x86_64 and aarch64.  The SHA256 performance on these systems is also listed for reference,
as computing the large number of required hash chains will constitute the bulk of the CPU
work for XMSS/XMSS^MT. Additionally, our patch to xmss-reference substitutes wolfCrypt's SHA256 implementation, and therefore benefits from the same ASM speedups.

As previously mentioned, our xmss integration is using the `xmss_core_fast` implementation from xmss-reference, which has faster performance at the tradeoff of larger private key sizes.

**x86_64**

The following x86_64 benchmark data were taken on an 8-core Intel i7-8700 CPU @ 3.20GHz, on Fedora 38 (`6.2.9-300.fc38.x86_64`). This CPU has `avx avx2` flags, which can accelerate hash operations and be utilized with `--enable-intelasm`.

With `--enable-intelasm`:

```text
$./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    500 MiB took 1.009 seconds,  495.569 MiB/s Cycles per byte =   6.14
XMSS-SHA2_10_256  2500     sign       200 ops took 1.010 sec, avg 5.052 ms, 197.925 ops/sec
XMSS-SHA2_10_256  2500   verify      1600 ops took 1.011 sec, avg 0.632 ms, 1582.844 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       200 ops took 1.286 sec, avg 6.431 ms, 155.504 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       700 ops took 1.009 sec, avg 1.441 ms, 693.905 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       300 ops took 1.223 sec, avg 4.076 ms, 245.335 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       400 ops took 1.027 sec, avg 2.569 ms, 389.329 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       200 ops took 1.466 sec, avg 7.332 ms, 136.394 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       400 ops took 1.024 sec, avg 2.560 ms, 390.627 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       300 ops took 1.202 sec, avg 4.006 ms, 249.637 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       200 ops took 1.089 sec, avg 5.446 ms, 183.635 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       200 ops took 1.724 sec, avg 8.618 ms, 116.033 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       300 ops took 1.136 sec, avg 3.788 ms, 263.995 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       300 ops took 1.210 sec, avg 4.034 ms, 247.889 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       200 ops took 1.575 sec, avg 7.877 ms, 126.946 ops/sec
Benchmark complete
```

Without `--enable-intelasm`:

```text
$./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: 	Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    275 MiB took 1.005 seconds,  273.549 MiB/s Cycles per byte =  11.13
XMSS-SHA2_10_256  2500     sign       200 ops took 1.356 sec, avg 6.781 ms, 147.480 ops/sec
XMSS-SHA2_10_256  2500   verify      1200 ops took 1.025 sec, avg 0.854 ms, 1170.547 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       200 ops took 1.687 sec, avg 8.436 ms, 118.546 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       600 ops took 1.187 sec, avg 1.978 ms, 505.663 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       200 ops took 1.119 sec, avg 5.593 ms, 178.785 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       300 ops took 1.086 sec, avg 3.622 ms, 276.122 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       200 ops took 1.991 sec, avg 9.954 ms, 100.460 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       300 ops took 1.043 sec, avg 3.478 ms, 287.545 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       200 ops took 1.114 sec, avg 5.572 ms, 179.454 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       200 ops took 1.495 sec, avg 7.476 ms, 133.770 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       100 ops took 1.111 sec, avg 11.114 ms, 89.975 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       200 ops took 1.070 sec, avg 5.349 ms, 186.963 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       200 ops took 1.148 sec, avg 5.739 ms, 174.247 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       100 ops took 1.080 sec, avg 10.797 ms, 92.618 ops/sec
Benchmark complete
```

**aarch64**

The following aarch64 data were taken on Ubuntu linux (`5.15.0-71-generic`) running on an Apple M1, with cpu flags `sha1 sha2 sha3 sha512`, which will specifically significantly accelerate SHA hash operations when built with `--enable-armasm`.

With `--enable-armasm`:

```text
$ ./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                   2305 MiB took 1.001 seconds, 2303.346 MiB/s
XMSS-SHA2_10_256  2500     sign       800 ops took 1.079 sec, avg 1.349 ms, 741.447 ops/sec
XMSS-SHA2_10_256  2500   verify      6500 ops took 1.007 sec, avg 0.155 ms, 6455.445 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       700 ops took 1.155 sec, avg 1.650 ms, 606.154 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify      3100 ops took 1.021 sec, avg 0.329 ms, 3037.051 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign      1100 ops took 1.006 sec, avg 0.915 ms, 1093.191 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify      1700 ops took 1.013 sec, avg 0.596 ms, 1677.399 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       600 ops took 1.096 sec, avg 1.827 ms, 547.226 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify      1600 ops took 1.062 sec, avg 0.664 ms, 1506.946 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign      1100 ops took 1.007 sec, avg 0.916 ms, 1092.214 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       900 ops took 1.088 sec, avg 1.209 ms, 827.090 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       600 ops took 1.179 sec, avg 1.966 ms, 508.728 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify      1100 ops took 1.038 sec, avg 0.944 ms, 1059.590 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign      1100 ops took 1.015 sec, avg 0.923 ms, 1083.767 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       600 ops took 1.149 sec, avg 1.914 ms, 522.367 ops/sec
Benchmark complete
```

Without `--enable-armasm`:

```text
$ ./wolfcrypt/benchmark/benchmark -xmss_xmssmt -sha256
------------------------------------------------------------------------------
 wolfSSL version 5.6.3
------------------------------------------------------------------------------
Math: Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
SHA-256                    190 MiB took 1.020 seconds,  186.277 MiB/s
XMSS-SHA2_10_256  2500     sign       200 ops took 1.908 sec, avg 9.538 ms, 104.845 ops/sec
XMSS-SHA2_10_256  2500   verify       800 ops took 1.002 sec, avg 1.253 ms, 798.338 ops/sec
XMSSMT-SHA2_20/2_256  4963     sign       100 ops took 1.084 sec, avg 10.843 ms, 92.222 ops/sec
XMSSMT-SHA2_20/2_256  4963   verify       500 ops took 1.240 sec, avg 2.479 ms, 403.334 ops/sec
XMSSMT-SHA2_20/4_256  9251     sign       200 ops took 1.615 sec, avg 8.074 ms, 123.855 ops/sec
XMSSMT-SHA2_20/4_256  9251   verify       200 ops took 1.071 sec, avg 5.355 ms, 186.726 ops/sec
XMSSMT-SHA2_40/4_256  9893     sign       100 ops took 1.354 sec, avg 13.543 ms, 73.840 ops/sec
XMSSMT-SHA2_40/4_256  9893   verify       300 ops took 1.483 sec, avg 4.945 ms, 202.237 ops/sec
XMSSMT-SHA2_40/8_256 18469     sign       200 ops took 1.588 sec, avg 7.941 ms, 125.922 ops/sec
XMSSMT-SHA2_40/8_256 18469   verify       100 ops took 1.042 sec, avg 10.415 ms, 96.014 ops/sec
XMSSMT-SHA2_60/6_256 14824     sign       100 ops took 1.571 sec, avg 15.710 ms, 63.654 ops/sec
XMSSMT-SHA2_60/6_256 14824   verify       200 ops took 1.526 sec, avg 7.632 ms, 131.033 ops/sec
XMSSMT-SHA2_60/12_256 27688     sign       200 ops took 1.607 sec, avg 8.036 ms, 124.434 ops/sec
XMSSMT-SHA2_60/12_256 27688   verify       100 ops took 1.501 sec, avg 15.011 ms, 66.616 ops/sec
Benchmark complete
```
