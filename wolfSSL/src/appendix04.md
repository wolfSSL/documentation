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

* FALCON Signature Scheme
* KYBER KEM
* SABER KEM
* NTRU KEM

An explanation of lattice-based cryptography would fall outside the scope of this document but more information about these algorithms can be found in their NIST submissions at <https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>. 

Unfortunately, it might come as a shock, but we do not actually know that these algorithms will resist attacks from quantum computers. In fact, we do not even know that these algorithms are safe against a conventional computer. Its getting less and less likely, but someone could break lattice-based cryptography. However, as security experts will tell you, this is how cryptography has always worked. Algorithms are good when we start using them, but weaknesses and vulnerabilities are discovered and technology gets better. The post-quantum algorithms are somewhat problematic in that they are relatively new and could use a bit more attention from the community.

One solution is to not put our full faith into these new algorithms. For now, we can hedge our bets by hybridizing post-quantum KEMs with the conventional algorithms that we actually trust. ECC with NIST standardized curves seem like good candidates as we have to keep using them since FIPS compliance is a priority. For this reason, we have not only integrated post-quantum KEMs but also hybridized them with ECDSA over NIST approved curves. Please see our list of hybrid groups below. 

## Getting Started with wolfSSL's liboqs Integration

The following instructions will get you started from a clean Linux development environment and lead you step by step to performing a quantum-safe TLS 1.3 connection.

### Building Open Quantum Safe

In order be able to use liboqs, you must have it built and installed on your system. We support the `0.7.0` release of liboqs. You can download it from the following link:

<https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.7.0.tar.gz>

Once unpacked, this would be sufficient:

```sh
$ cd liboqs-0.7.0
$ mkdir build
$ cd build
$ cmake -DOQS_USE_OPENSSL=0 ..
$ make all
$ sudo make install
```

For authentication, you can generate a certificate chain using the Open Quantum Safe project's fork of OpenSSL. We support FALCON certificates and keys generated by the `2021-08 snapshot` of the `OQS-OpenSSL_1_1_1-stable` branch of the fork. You can download it from the following link:

<https://github.com/open-quantum-safe/openssl/archive/refs/tags/OQS-OpenSSL_1_1_1-stable-snapshot-2021-08.tar.gz>

Once unpacked, this would be sufficient for building it:

```sh
$ cd openssl-OQS-OpenSSL_1_1_1-stable-snapshot-2021-08/
$ ./config no-shared
$ make all
```

**Note**: installation is NOT required.

There is a script for generating a FALCON NIST Level 1 and FALCON NIST Level 5 certificate chain which can be found in the `wolfssl-examples` github repo at `pq/generate_falcon_chains.sh.` Please find detailed instructions on how to generate and verify the keys and certificates in `pq/README.md`. As a quick-start, simply copy `generate_falcon_chains.sh` into the `openssl-OQS-OpenSSL_1_1_1-stable-snapshot-2021-08` directory and execute the script.

Once the certificates and keys are generated, copy them from the `openssl-OQS-OpenSSL_1_1_1-stable-snapshot-2021-08` directory to the `certs` directory of wolfssl.

### Building wolfSSL

Follow these steps to build wolfSSL with liboqs integration:

```sh
$ cd wolfssl
$ ./autogen.sh (Not necessary if configure script is already present)
$ ./configure --with-liboqs
$ make all
```

### Making a Quantum Safe TLS Connection

You can run the server and client like this in separate terminals:

```sh
$ examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level5_root_cert.pem \
  -c certs/falcon_level1_entity_cert.pem \
  -k certs/falcon_level1_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

```sh
$ examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
  -A certs/falcon_level1_root_cert.pem \
  -c certs/falcon_level5_entity_cert.pem \
  -k certs/falcon_level5_entity_key.pem \
  --oqs P521_KYBER_LEVEL5
```

You have just achieved a fully quantum-safe TLS 1.3 connection using AES-256 for symmetric encryption, the FALCON signature scheme for authentication and ECDHE hybridized with KYBER KEM for key establishment.

## Naming Convention Mappings Between wolfSSL and OQS's fork of OpenSSL

All the teams that made submission to the NIST PQC competition supported multiple levels of security as defined by NIST here: <https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation-criteria/security-(evaluation-criteria)>

As such, they had to come up with ways to identify their variants and each team came up with their own variant naming scheme. As you can see in the following tables, there was no co-ordination between the teams on how to do this. The wolfSSL library uses a NIST-level-based naming convention of the variants. The OQS team chose to follow the naming conventions of each of the submission papers. Please see the following tables mapping our naming conventions with those of the submission papers.
 
Post-Quantum Signature Scheme Naming Convention:

wolfSSL Variant Name  |  PQC Submission Variant Name
--------------------  |  --------------------------- 
FALCON_LEVEL1         |  FALCON512
FALCON_LEVEL5         |  FALCON1024 

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

## Cryptographic Artifact Sizes

All sizes are in bytes.

Post-Quantum Signature Scheme Artifact Sizes:

wolfSSL Variant Name | Public Key Size | Private Key Size | Maximum Signature Size
-------------------- | --------------- | ---------------- | ----------------------
FALCON_LEVEL1        | 897             | 1281             | 690
FALCON_LEVEL5        | 1793            | 2305             | 1330

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

## TLS 1.3 Data Transmission Sizes

The following results were taken by running the example server and client and recording all information being transmitted via wireshark. This includes the TLS 1.3 handshake with mutual authentication, "hello wolfssl!" and "I hear you fa shizzle!" messages. The `tcp.len` of all packets were summed:

Ciphersuite            | Authentication | Key Establishment     | Total Bytes
---------------------- | -------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | ECC SECP256R1         | 5455
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_LEVEL1          | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_LEVEL3          | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_LEVEL5          | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_90S_LEVEL1      | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_90S_LEVEL3      | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | KYBER_90S_LEVEL5      | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | NTRU_HPS_LEVEL1       | 6463
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | NTRU_HPS_LEVEL3       | 6925
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | NTRU_HPS_LEVEL5       | 7525
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | NTRU_HRSS_LEVEL3      | 7341
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | SABER_LEVEL1          | 6473
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | SABER_LEVEL3          | 7145
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | SABER_LEVEL5          | 7849
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P256_KYBER_LEVEL1     | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P384_KYBER_LEVEL3     | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P521_KYBER_LEVEL5     | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P256_KYBER90S_LEVEL1  | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P384_KYBER90S_LEVEL3  | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P521_KYBER90S_LEVEL5  | 8467
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P256_NTRU_HPS_LEVEL1  | 6593
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P384_NTRU_HPS_LEVEL3  | 7119
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P521_NTRU_HPS_LEVEL5  | 7791
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P384_NTRU_HRSS_LEVEL3 | 7535
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P256_SABER_LEVEL1     | 6603
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P384_SABER_LEVEL3     | 7339
TLS_AES_256_GCM_SHA384 | RSA 2048 bit   | P521_SABER_LEVEL5     | 8115
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1  | ECC SECP256R1         | 6997
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5  | ECC SECP256R1         | 11248
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1  | KYBER_LEVEL1          | 8180
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL1  | P256_KYBER_LEVEL1     | 8308
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5  | KYBER_LEVEL5          | 14007
TLS_AES_256_GCM_SHA384 | FALCON_LEVEL5  | P521_KYBER_LEVEL5     | 14257

## Statistics

The following statistics and benchmarks were taken on an 11th GenIntel Core i7-1165G7@3-GHz with 8 cores running Ubuntu 21.10. liboqs was upgraded to `ba5b61a779a0db364f0e691a0a0bc8ac42e73f1b` on their main branch due to compiler incompatibilities with the older code in `0.7.0`. The following configurations were used:

liboqs:
```
CFLAGS="-Os" cmake -DOQS_USE_OPENSSL=0 -DOQS_MINIMAL_BUILD="OQS_ENABLE_KEM_saber_saber;OQS_ENABLE_KEM_saber_lightsaber;OQS_ENABLE_KEM_saber_firesaber;OQS_ENABLE_KEM_kyber_1024;OQS_ENABLE_KEM_kyber_1024_90s;OQS_ENABLE_KEM_kyber_768;OQS_ENABLE_KEM_kyber_768_90s;OQS_ENABLE_KEM_kyber_512;OQS_ENABLE_KEM_kyber_512_90s;OQS_ENABLE_KEM_ntru_hps2048509;OQS_ENABLE_KEM_ntru_hps2048677;OQS_ENABLE_KEM_ntru_hps4096821;OQS_ENABLE_KEM_ntru_hrss701;OQS_ENABLE_SIG_falcon_1024;OQS_ENABLE_SIG_falcon_512" ..
```

wolfSSL:
```
./configure --with-liboqs \
            --disable-psk \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp-math-all \
            --enable-sp-asm \
            CFLAGS="-Os"
```

**Note**: that we are primarily benchmarking the post-quantum algorithms, but leave some conventional algorithms for comparisson purposes.

### Runtime Binary Sizes

The `tls_bench` example application binary file is 2479992 bytes after being built then stripped (Approximately 2.4M).  Without the `--with-liboqs` it is 571832 bytes after being built then stripped (Approximately 559K). This is a difference of 1908160 bytes (Approximately 1.9Mb).

### Benchmarks for KEM Groups

**Note**: Only two cores are used.

```
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL1:
	Total       :  81526784 bytes
	Num Conns   :       312
	Rx Total    :   104.738 ms
	Tx Total    :    33.224 ms
	Rx          :   371.165 MB/s
	Tx          :  1170.076 MB/s
	Connect     :   836.402 ms
	Connect Avg :     2.681 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL1:
	Total       :  81526784 bytes
	Num Conns   :       312
	Rx Total    :   115.019 ms
	Tx Total    :    32.250 ms
	Rx          :   337.988 MB/s
	Tx          :  1205.411 MB/s
	Connect     :   814.897 ms
	Connect Avg :     2.612 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL3:
	Total       :  80478208 bytes
	Num Conns   :       308
	Rx Total    :   102.574 ms
	Tx Total    :    32.463 ms
	Rx          :   374.119 MB/s
	Tx          :  1182.112 MB/s
	Connect     :   837.583 ms
	Connect Avg :     2.719 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL3:
	Total       :  80478208 bytes
	Num Conns   :       308
	Rx Total    :   112.774 ms
	Tx Total    :    31.413 ms
	Rx          :   340.283 MB/s
	Tx          :  1221.643 MB/s
	Connect     :   806.966 ms
	Connect Avg :     2.620 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL5:
	Total       :  79953920 bytes
	Num Conns   :       306
	Rx Total    :   101.202 ms
	Tx Total    :    32.180 ms
	Rx          :   376.724 MB/s
	Tx          :  1184.748 MB/s
	Connect     :   841.708 ms
	Connect Avg :     2.751 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HPS_LEVEL5:
	Total       :  79953920 bytes
	Num Conns   :       306
	Rx Total    :   110.684 ms
	Tx Total    :    31.854 ms
	Rx          :   344.449 MB/s
	Tx          :  1196.870 MB/s
	Connect     :   801.366 ms
	Connect Avg :     2.619 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HRSS_LEVEL3:
	Total       :  82313216 bytes
	Num Conns   :       315
	Rx Total    :   104.672 ms
	Tx Total    :    33.355 ms
	Rx          :   374.982 MB/s
	Tx          :  1176.727 MB/s
	Connect     :   835.610 ms
	Connect Avg :     2.653 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group NTRU_HRSS_LEVEL3:
	Total       :  82313216 bytes
	Num Conns   :       315
	Rx Total    :   115.212 ms
	Tx Total    :    32.244 ms
	Rx          :   340.676 MB/s
	Tx          :  1217.282 MB/s
	Connect     :   811.924 ms
	Connect Avg :     2.578 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL1:
	Total       :  83361792 bytes
	Num Conns   :       319
	Rx Total    :   106.528 ms
	Tx Total    :    34.231 ms
	Rx          :   373.141 MB/s
	Tx          :  1161.230 MB/s
	Connect     :   831.525 ms
	Connect Avg :     2.607 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL1:
	Total       :  83361792 bytes
	Num Conns   :       319
	Rx Total    :   117.493 ms
	Tx Total    :    32.928 ms
	Rx          :   338.317 MB/s
	Tx          :  1207.162 MB/s
	Connect     :   827.114 ms
	Connect Avg :     2.593 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL3:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   103.526 ms
	Tx Total    :    34.228 ms
	Rx          :   382.753 MB/s
	Tx          :  1157.667 MB/s
	Connect     :   835.111 ms
	Connect Avg :     2.626 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL3:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   115.529 ms
	Tx Total    :    31.724 ms
	Rx          :   342.988 MB/s
	Tx          :  1249.046 MB/s
	Connect     :   828.796 ms
	Connect Avg :     2.606 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL5:
	Total       :  83361792 bytes
	Num Conns   :       319
	Rx Total    :   106.236 ms
	Tx Total    :    33.545 ms
	Rx          :   374.166 MB/s
	Tx          :  1184.958 MB/s
	Connect     :   835.147 ms
	Connect Avg :     2.618 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SABER_LEVEL5:
	Total       :  83361792 bytes
	Num Conns   :       319
	Rx Total    :   116.151 ms
	Tx Total    :    33.222 ms
	Rx          :   342.227 MB/s
	Tx          :  1196.489 MB/s
	Connect     :   826.073 ms
	Connect Avg :     2.590 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
	Total       :  83886080 bytes
	Num Conns   :       321
	Rx Total    :   106.112 ms
	Tx Total    :    33.832 ms
	Rx          :   376.961 MB/s
	Tx          :  1182.302 MB/s
	Connect     :   833.762 ms
	Connect Avg :     2.597 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL1:
	Total       :  83886080 bytes
	Num Conns   :       321
	Rx Total    :   115.532 ms
	Tx Total    :    33.819 ms
	Rx          :   346.223 MB/s
	Tx          :  1182.760 MB/s
	Connect     :   830.659 ms
	Connect Avg :     2.588 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
	Total       :  82837504 bytes
	Num Conns   :       317
	Rx Total    :   104.853 ms
	Tx Total    :    33.958 ms
	Rx          :   376.717 MB/s
	Tx          :  1163.195 MB/s
	Connect     :   834.753 ms
	Connect Avg :     2.633 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL3:
	Total       :  82837504 bytes
	Num Conns   :       317
	Rx Total    :   116.104 ms
	Tx Total    :    32.361 ms
	Rx          :   340.213 MB/s
	Tx          :  1220.613 MB/s
	Connect     :   830.492 ms
	Connect Avg :     2.620 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
	Total       :  90963968 bytes
	Num Conns   :       348
	Rx Total    :    52.821 ms
	Tx Total    :    21.809 ms
	Rx          :   821.171 MB/s
	Tx          :  1988.827 MB/s
	Connect     :   900.283 ms
	Connect Avg :     2.587 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_LEVEL5:
	Total       :  90963968 bytes
	Num Conns   :       348
	Rx Total    :    56.213 ms
	Tx Total    :    23.134 ms
	Rx          :   771.623 MB/s
	Tx          :  1874.985 MB/s
	Connect     :   893.851 ms
	Connect Avg :     2.569 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
	Total       :  84148224 bytes
	Num Conns   :       322
	Rx Total    :   106.540 ms
	Tx Total    :    34.535 ms
	Rx          :   376.620 MB/s
	Tx          :  1161.859 MB/s
	Connect     :   832.680 ms
	Connect Avg :     2.586 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL1:
	Total       :  84148224 bytes
	Num Conns   :       322
	Rx Total    :   117.951 ms
	Tx Total    :    32.999 ms
	Rx          :   340.183 MB/s
	Tx          :  1215.936 MB/s
	Connect     :   829.895 ms
	Connect Avg :     2.577 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   104.203 ms
	Tx Total    :    33.231 ms
	Rx          :   380.269 MB/s
	Tx          :  1192.401 MB/s
	Connect     :   837.349 ms
	Connect Avg :     2.633 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL3:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   114.545 ms
	Tx Total    :    32.522 ms
	Rx          :   345.935 MB/s
	Tx          :  1218.407 MB/s
	Connect     :   833.651 ms
	Connect Avg :     2.622 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   106.045 ms
	Tx Total    :    34.000 ms
	Rx          :   373.660 MB/s
	Tx          :  1165.452 MB/s
	Connect     :   833.861 ms
	Connect Avg :     2.622 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group KYBER_90S_LEVEL5:
	Total       :  83099648 bytes
	Num Conns   :       318
	Rx Total    :   117.970 ms
	Tx Total    :    32.122 ms
	Rx          :   335.889 MB/s
	Tx          :  1233.564 MB/s
	Connect     :   829.933 ms
	Connect Avg :     2.610 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_NTRU_HPS_LEVEL1:
	Total       :  45350912 bytes
	Num Conns   :       174
	Rx Total    :    60.496 ms
	Tx Total    :    18.177 ms
	Rx          :   357.464 MB/s
	Tx          :  1189.719 MB/s
	Connect     :   905.095 ms
	Connect Avg :     5.202 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_NTRU_HPS_LEVEL1:
	Total       :  45350912 bytes
	Num Conns   :       174
	Rx Total    :    64.987 ms
	Tx Total    :    18.708 ms
	Rx          :   332.758 MB/s
	Tx          :  1155.953 MB/s
	Connect     :   716.255 ms
	Connect Avg :     4.116 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HPS_LEVEL3:
	Total       :  29097984 bytes
	Num Conns   :       112
	Rx Total    :    21.880 ms
	Tx Total    :     7.735 ms
	Rx          :   634.136 MB/s
	Tx          :  1793.791 MB/s
	Connect     :   967.733 ms
	Connect Avg :     8.640 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HPS_LEVEL3:
	Total       :  29097984 bytes
	Num Conns   :       112
	Rx Total    :    23.002 ms
	Tx Total    :     8.142 ms
	Rx          :   603.198 MB/s
	Tx          :  1704.078 MB/s
	Connect     :   710.929 ms
	Connect Avg :     6.348 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_NTRU_HPS_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    25.211 ms
	Tx Total    :     5.444 ms
	Rx          :   257.821 MB/s
	Tx          :  1194.069 MB/s
	Connect     :   965.004 ms
	Connect Avg :    18.208 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_NTRU_HPS_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    27.384 ms
	Tx Total    :     5.740 ms
	Rx          :   237.365 MB/s
	Tx          :  1132.371 MB/s
	Connect     :   648.859 ms
	Connect Avg :    12.243 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HRSS_LEVEL3:
	Total       :  28835840 bytes
	Num Conns   :       111
	Rx Total    :    30.122 ms
	Tx Total    :     9.003 ms
	Rx          :   456.476 MB/s
	Tx          :  1527.322 MB/s
	Connect     :   952.431 ms
	Connect Avg :     8.580 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_NTRU_HRSS_LEVEL3:
	Total       :  28835840 bytes
	Num Conns   :       111
	Rx Total    :    31.482 ms
	Tx Total    :     9.869 ms
	Rx          :   436.761 MB/s
	Tx          :  1393.204 MB/s
	Connect     :   693.809 ms
	Connect Avg :     6.251 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_SABER_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    28.412 ms
	Tx Total    :    11.682 ms
	Rx          :   787.516 MB/s
	Tx          :  1915.295 MB/s
	Connect     :   948.409 ms
	Connect Avg :     5.269 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_SABER_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    30.442 ms
	Tx Total    :    11.885 ms
	Rx          :   735.010 MB/s
	Tx          :  1882.674 MB/s
	Connect     :   773.063 ms
	Connect Avg :     4.295 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_SABER_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    41.268 ms
	Tx Total    :    10.902 ms
	Rx          :   339.243 MB/s
	Tx          :  1284.148 MB/s
	Connect     :   936.217 ms
	Connect Avg :     8.285 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_SABER_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    43.123 ms
	Tx Total    :    12.233 ms
	Rx          :   324.654 MB/s
	Tx          :  1144.466 MB/s
	Connect     :   673.655 ms
	Connect Avg :     5.962 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_SABER_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    25.002 ms
	Tx Total    :     5.541 ms
	Rx          :   259.974 MB/s
	Tx          :  1173.055 MB/s
	Connect     :   981.157 ms
	Connect Avg :    18.512 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_SABER_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    27.128 ms
	Tx Total    :     5.685 ms
	Rx          :   239.605 MB/s
	Tx          :  1143.293 MB/s
	Connect     :   666.796 ms
	Connect Avg :    12.581 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    61.094 ms
	Tx Total    :    18.091 ms
	Rx          :   366.237 MB/s
	Tx          :  1236.822 MB/s
	Connect     :   904.377 ms
	Connect Avg :     5.024 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    65.539 ms
	Tx Total    :    18.878 ms
	Rx          :   341.400 MB/s
	Tx          :  1185.258 MB/s
	Connect     :   726.876 ms
	Connect Avg :     4.038 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    41.608 ms
	Tx Total    :    11.377 ms
	Rx          :   336.473 MB/s
	Tx          :  1230.568 MB/s
	Connect     :   937.189 ms
	Connect Avg :     8.294 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    43.823 ms
	Tx Total    :    12.194 ms
	Rx          :   319.465 MB/s
	Tx          :  1148.068 MB/s
	Connect     :   679.081 ms
	Connect Avg :     6.010 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    26.556 ms
	Tx Total    :     6.155 ms
	Rx          :   244.763 MB/s
	Tx          :  1055.968 MB/s
	Connect     :   963.644 ms
	Connect Avg :    18.182 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    29.747 ms
	Tx Total    :     5.286 ms
	Rx          :   218.506 MB/s
	Tx          :  1229.724 MB/s
	Connect     :   653.181 ms
	Connect Avg :    12.324 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    61.892 ms
	Tx Total    :    18.407 ms
	Rx          :   361.517 MB/s
	Tx          :  1215.595 MB/s
	Connect     :   907.580 ms
	Connect Avg :     5.042 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P256_KYBER_90S_LEVEL1:
	Total       :  46923776 bytes
	Num Conns   :       180
	Rx Total    :    66.700 ms
	Tx Total    :    18.819 ms
	Rx          :   335.456 MB/s
	Tx          :  1188.967 MB/s
	Connect     :   727.746 ms
	Connect Avg :     4.043 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    41.884 ms
	Tx Total    :    11.245 ms
	Rx          :   334.257 MB/s
	Tx          :  1245.049 MB/s
	Connect     :   938.972 ms
	Connect Avg :     8.309 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P384_KYBER_90S_LEVEL3:
	Total       :  29360128 bytes
	Num Conns   :       113
	Rx Total    :    44.288 ms
	Tx Total    :    12.573 ms
	Rx          :   316.110 MB/s
	Tx          :  1113.476 MB/s
	Connect     :   681.701 ms
	Connect Avg :     6.033 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    27.950 ms
	Tx Total    :     5.953 ms
	Rx          :   232.558 MB/s
	Tx          :  1091.917 MB/s
	Connect     :   961.226 ms
	Connect Avg :    18.136 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group P521_KYBER_90S_LEVEL5:
	Total       :  13631488 bytes
	Num Conns   :        53
	Rx Total    :    30.836 ms
	Tx Total    :     5.800 ms
	Rx          :   210.793 MB/s
	Tx          :  1120.596 MB/s
	Connect     :   649.261 ms
	Connect Avg :    12.250 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
	Total       :  57409536 bytes
	Num Conns   :       220
	Rx Total    :    71.891 ms
	Tx Total    :    23.104 ms
	Rx          :   380.783 MB/s
	Tx          :  1184.838 MB/s
	Connect     :   668.705 ms
	Connect Avg :     3.040 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
	Total       :  57409536 bytes
	Num Conns   :       220
	Rx Total    :    79.276 ms
	Tx Total    :    22.119 ms
	Rx          :   345.314 MB/s
	Tx          :  1237.621 MB/s
	Connect     :   664.370 ms
	Connect Avg :     3.020 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
	Total       :  40108032 bytes
	Num Conns   :       154
	Rx Total    :    49.248 ms
	Tx Total    :    16.372 ms
	Rx          :   388.345 MB/s
	Tx          :  1168.172 MB/s
	Connect     :   576.246 ms
	Connect Avg :     3.742 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
	Total       :  40108032 bytes
	Num Conns   :       154
	Rx Total    :    54.535 ms
	Tx Total    :    15.492 ms
	Rx          :   350.693 MB/s
	Tx          :  1234.511 MB/s
	Connect     :   569.802 ms
	Connect Avg :     3.700 ms
wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
	Total       :  21757952 bytes
	Num Conns   :        84
	Rx Total    :    26.961 ms
	Tx Total    :     8.916 ms
	Rx          :   384.810 MB/s
	Tx          :  1163.589 MB/s
	Connect     :   471.549 ms
	Connect Avg :     5.614 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
	Total       :  21757952 bytes
	Num Conns   :        84
	Rx Total    :    29.946 ms
	Tx Total    :     8.431 ms
	Rx          :   346.456 MB/s
	Tx          :  1230.514 MB/s
	Connect     :   457.454 ms
	Connect Avg :     5.446 ms
```

### Benchmarks for Signature Schemes

**Note**: Only a single core is used.

```
FALCON         1 sign    5600 ops took 1.017 sec, avg 0.182 ms, 5507.545 ops/sec
FALCON         1 verify 28100 ops took 1.001 sec, avg 0.036 ms, 28058.444 ops/sec
FALCON         5 sign    2700 ops took 1.018 sec, avg 0.377 ms, 2652.544 ops/sec
FALCON         5 verify 15000 ops took 1.002 sec, avg 0.067 ms, 14968.912 ops/sec
ECDSA  SECP256R1 sign    2100 ops took 1.044 sec, avg 0.497 ms, 2010.741 ops/sec
ECDSA  SECP256R1 verify  3100 ops took 1.022 sec, avg 0.330 ms, 3034.340 ops/sec
```

### Heap and Stack Usage

These statistics were obtained by adding the following configuration flags: `--enable-trackmemory --enable-stacksize`. 

Memory use for server sign and client verify without server authentication of the client, TLS13-AES256-GCM-SHA384 ciphersuite and ECC SECP256R1 for key exchange.

```
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

```
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

## Documentation

Technical documentation and other resources such as known answer tests can be found at the NIST PQC website: 

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.

For more algorithm-specific benchmarking information, the OQS Project has benchmarking information at their website:

<https://openquantumsafe.org/benchmarking/>

