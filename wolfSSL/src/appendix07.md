# Experimenting with Post-Quantum Cryptography

A while back, the wolfSSL team integrated experimental post-quantum cryptographic algorithms into the wolfSSL library. This was done by integrating with the Open Quantum Safe team's liboqs. Currently, wolfCrypt implements LMS, XMSS, ML-DSA and ML-KEM. So, for the purpose of code size reduction and ease of maintence, the wolfSSL team removed the integration with liboqs.

This appendix is intended for anyone that wants to start learning about post-quantum cryptography in the context of (D)TLS 1.3. It explains why post-quantum algorithms are important, what we have done in response to the quantum threat and how you can start experimenting with these new algorithms.

**Note**: Some of the post-quantum algorithms are not fully standardized yet. Some OIDs and codepoints are temporary and expected to change in the future. You should have no expectation of backwards compatibility until they are fully standardized.

## A Gentle Introduction to Post-Quantum Cryptography

### Why Post-Quantum Cryptography?

For some time now, many resources have been devoted to the development of quantum computers. So much so that commercialization of cloud quantum computing resources has already begun. While the current state of the art is still not in the realm of being cryptographically relevant, some threat models such as "harvest now, decrypt later" mean that preparations need to happen sooner than the appearance of cryptographically relevant quantum computers.

NIST is leading the way for standardization of a new class of algorithms designed to replace the public key cryptography algorithms that will become vulnerable to quantum computers. At the time of the writing of this passage, NIST has already standardized ML-DSA, ML-KEM, and SLH-DSA. Currently, standards organizations have various draft documents describing OIDs and codepoints. NIST is working on bringing these algorithms under the ubmbrella of the CMVP regulatory framework allowing for FIPS-140-3 validations of implementations of these algorithms.

### How do we Protect Ourselves?

From a high level perspective, for every TLS 1.3 connection, authentication, integrity and confidentiality are the main security goals that protect each connection. Authentication is maintained via signature schemes such as ECDSA. Confidentiality and integrity are maintained by key establishment algorithms such as ECDHE and then using the established key with symmetric encryption algorithms such as AES to encrypt a communication stream. We can thus decompose the security of the TLS 1.3 protocol into 3 types of cryptographic algorithms:

* authentication algorithms
* key establishment algorithms
* symmetric cipher algorithms

The threat of quantum computers to conventional cryptography takes two forms. Grover’s algorithm reduces the security of modern symmetric cipher algorithms by approximately half while Shor’s algorithm completely breaks the security of modern authentication and key establishment algorithms. As a result, we can continue to protect our communications using the AES-256 symmetric cipher which is considered sufficiently secure even in the presence of a cryptographically relevant quantum computer. We can then replace our conventional authentication and key establishment algorithms with post-quantum algorithms. Note that during TLS 1.3 handshakes, the ciphersuite specifies the symmetric cipher to be used for the duration of the connection. Both CNSA (Commercial National Security Algorithm Suite) 1.0 and 2.0 prescribe using the AES_256_GCM_SHA384 ciphersuite. For key establishment and authentication, there are post-quantum KEMs (Key Encapsulation Mechanisms) and signature schemes.

These use different kinds of math from the conventional algorithms. They are designed specifically for resistance to quantum-computers. The authentication algorithm and KEM that NIST has standardized for use with network protocols are lattice-based algorithms.

* ML-DSA (Dilithium) Signature Scheme
* ML-KEM (KYBER) KEM

**Note**: SABER KEM and NTRU KEM were deprecated and removed as they did not
          move on to standardization.

**Note**: KYBER KEM 90s variants were deprecated and removed as NIST is not
          considering them for standardization.

**Note**: Dilithium Signature Scheme's AES variants were deprecated and removed
          as NIST is not considering them for standardization.

**Note**: When the liboqs integration was removed, we also removed the FALCON
          and SPHINCS+ signature schemes. We will have our own implmentations
          in the future.

An explanation of lattice-based cryptography would fall outside the scope of this document but more information about these algorithms can be found in their NIST submissions at <https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.

Unfortunately, it might come as a shock, but we do not actually know that these algorithms will resist attacks from quantum computers. In fact, we do not even know that these algorithms are safe against a conventional computer. Its getting less and less likely, but someone could break lattice-based cryptography. However, as security experts will tell you, this is how cryptography has always worked. Algorithms are good when we start using them, but weaknesses and vulnerabilities are discovered and technology gets better. The post-quantum algorithms are somewhat problematic in that they are relatively new and could use a bit more attention from the community.

One solution is to not put our full faith into these new algorithms. For now, we can hedge our bets by hybridizing post-quantum algorithms with the conventional algorithms that we actually trust. ECC with NIST standardized curves seem like good candidates as we have to keep using them since FIPS 140-3 compliance is a priority. For this reason, we have not only implemented post-quantum KEMs but also hybridized them with ECDSA over NIST approved curves. Please see our list of hybrid groups below.

## Getting Started with Post-Quantum algorithms in wolfSSL

The following instructions will get you started from a clean Linux development environment and lead you step by step to performing a quantum-safe TLS 1.3 connection.

### Build Instructions

Please see the wolfSSL repo's INSTALL file (https://github.com/wolfSSL/wolfssl/blob/master/INSTALL). Item 15 has instructions on how to configure and build wolfSSL with ML-KEM and ML-DSA enabled.

You will need the patched OQS OpenSSL Provider fork in order to generate X.509 certificates with post-quantum cryptographic keys and signatures. Instructions can be found at https://github.com/wolfSSL/osp/tree/master/oqs/README.md. For your convenience, pre-generated certificates can be found there as well.

### Making a Quantum Safe TLS Connection

You can run the server and client like this in separate terminals:

```sh
examples/server/server -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A ../osp/oqs/mldsa87_root_cert.pem \
      -c ../osp/oqs/mldsa44_entity_cert.pem \
      -k ../osp/oqs/mldsa44_entity_key.pem \
      --pqc SecP521r1MLKEM1024
```

```sh
examples/client/client -v 4 -l TLS_AES_256_GCM_SHA384 \
      -A ../osp/oqs/mldsa44_root_cert.pem \
      -c ../osp/oqs/mldsa87_entity_cert.pem \
      -k ../osp/oqs/mldsa87_entity_key.pem \
      --pqc SecP521r1MLKEM1024
```

You have just achieved a fully quantum-safe TLS 1.3 connection using AES-256 for symmetric encryption, the ML-DSA signature scheme for authentication and ECDHE hybridized with ML-KEM for key establishment.

Further information about other post-quantum examples can be found at https://github.com/wolfSSL/wolfssl-examples/blob/master/pq/README.md.

## Post Quantum Algorithm Variant Names

Post-Quantum algorithm variant names: 

NIST Security Level   |  PQC Variant Name
--------------------  |  ---------------------------
2                     |  `ML_DSA_44`
3                     |  `ML_DSA_65`
5                     |  `ML_DSA_87`
1                     |  `ML_KEM_512`
3                     |  `ML_KEM_768`
5                     |  `ML_KEM_1024`

Post-Quantum hybrid KEM names:

wolfSSL Variant Name  |  NIST ECC Curve and PQC Submission Variant Name
--------------------  |  ----------------------------------------------
`SecP256r1MLKEM512`   |  ECDSA P-256 and KYBER512
`SecP384r1MLKEM768`   |  ECDSA P-384 and KYBER768
`SecP521r1MLKEM1024`  |  ECDSA P-521 and KYBER1024

## Cryptographic Artifact Sizes

All sizes are in bytes.

Post-Quantum Signature Scheme Artifact Sizes:

PQC Variant Name | Public Key Size | Private Key Size | Maximum Signature Size
---------------- | --------------- | ---------------- | ----------------------
ML_DSA_44        | 1312            | 2560             | 2420
ML_DSA_65        | 1952            | 4032             | 3309
ML_DSA_87        | 2592            | 4896             | 4627

Post-Quantum KEM Artifact Sizes:

PQC Variant Name | Public Key Size | Private Key Size | Ciphertext Size | Shared Secret Size
---------------- | --------------- | ---------------- | --------------- | ------------------
ML_KEM_512       | 800             | 1632             | 768             | 32
ML_KEM_768       | 1184            | 2400             | 1088            | 32
ML_KEM_1024      | 1568            | 3168             | 1568            | 32

## Statistics

The following statistics and benchmarks were taken on an 11th GenIntel Core i7-1185G7@3-GHz with 8 cores running Ubuntu 22.04.5 LTS

wolfSSL:

```text
./configure --enable-kyber \
            --enable-dilithium \
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

The `tls_bench` example application binary file is 2498432 bytes after being built then stripped (Approximately 2.4M).  Without `--enable-kyber --enable-dilithium` it is 2290912 bytes after being built then stripped (Approximately 2.2M). This is a difference of 207520 bytes (Approximately 200K).

### TLS 1.3 Data Transmission Sizes

The following results were taken by running the example server and client and recording all information being transmitted via wireshark. This includes the TLS 1.3 handshake with mutual authentication, "hello wolfssl!" and "I hear you fa shizzle!" messages. The `tcp.len` of all packets were summed:

Ciphersuite            | Authentication       | Key Establishment     | Total Bytes
---------------------- | -------------------- | --------------------- | -----------
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ECC SECP256R1         | 5455
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_512            | 6633
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_768            | 7337
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | ML_KEM_1024           | 8201
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP256r1MLKEM512       | 6763
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP384r1MLKEM768       | 7531
TLS_AES_256_GCM_SHA384 | RSA 2048 bit         | SecP521r1MLKEM1024      | 8467
TLS_AES_256_GCM_SHA384 | ML_DSA_44            | ECC SECP256R1         | 7918
TLS_AES_256_GCM_SHA384 | ML_DSA_65            | ECC SECP256R1         | 10233
TLS_AES_256_GCM_SHA384 | ML_DSA_87            | ECC SECP256R1         | 13477

### Heap and Stack Usage

NOTE: This is out of date. These were obtained when wolfSSL was using the liboqs
      implementations of these algorithms. This is left here for historical
      purposes.

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

### Benchmarks

The following benchmarks were obtained with the following configuration flags:

```text
./configure --enable-kyber \
            --enable-dilithium \
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
CPU: Intel x86_64 - avx1 avx2 rdrand rdseed bmi2 aesni adx movbe bmi1 sha
Math: 	Multi-Precision: Disabled
	Single Precision: ecc 256 384 521 rsa/dh 2048 3072 4096 asm sp_x86_64.c

ECC    SECP256R1 key gen 95600 ops took 1.000 sec, avg 0.010 ms, 95587.830 ops/sec
ECDHE  SECP256R1 agree   24800 ops took 1.003 sec, avg 0.040 ms, 24737.512 ops/sec
ECDSA  SECP256R1 sign    61400 ops took 1.001 sec, avg 0.016 ms, 61337.775 ops/sec
ECDSA  SECP256R1 verify  23000 ops took 1.001 sec, avg 0.044 ms, 22976.012 ops/sec
ML-KEM 512       key gen 284600 ops took 1.000 sec, avg 0.004 ms, 284565.467 ops/sec
ML-KEM 512       encap   270800 ops took 1.000 sec, avg 0.004 ms, 270749.585 ops/sec
ML-KEM 512       decap   172900 ops took 1.000 sec, avg 0.006 ms, 172896.249 ops/sec
ML-KEM 768       key gen 159800 ops took 1.000 sec, avg 0.006 ms, 159776.306 ops/sec
ML-KEM 768       encap   152800 ops took 1.000 sec, avg 0.007 ms, 152765.071 ops/sec
ML-KEM 768       decap   100100 ops took 1.000 sec, avg 0.010 ms, 100091.147 ops/sec
ML-KEM 1024      key gen 108300 ops took 1.000 sec, avg 0.009 ms, 108277.024 ops/sec
ML-KEM 1024      encap   104400 ops took 1.000 sec, avg 0.010 ms, 104388.900 ops/sec
ML-KEM 1024      decap   74100 ops took 1.001 sec, avg 0.014 ms, 74057.147 ops/sec
ML-DSA 44        key gen 20700 ops took 1.004 sec, avg 0.049 ms, 20617.041 ops/sec
ML-DSA 44        sign    5100 ops took 1.019 sec, avg 0.200 ms, 5003.233 ops/sec
ML-DSA 44        verify  18500 ops took 1.005 sec, avg 0.054 ms, 18403.134 ops/sec
ML-DSA 65        key gen 10200 ops took 1.007 sec, avg 0.099 ms, 10133.468 ops/sec
ML-DSA 65        sign    2900 ops took 1.004 sec, avg 0.346 ms, 2887.112 ops/sec
ML-DSA 65        verify  11600 ops took 1.005 sec, avg 0.087 ms, 11544.122 ops/sec
ML-DSA 87        key gen 7700 ops took 1.013 sec, avg 0.132 ms, 7598.278 ops/sec
ML-DSA 87        sign    2600 ops took 1.000 sec, avg 0.385 ms, 2599.634 ops/sec
ML-DSA 87        verify  7200 ops took 1.007 sec, avg 0.140 ms, 7152.274 ops/sec
```

#### Benchmarks from wolfSSL

The following benchmarks were obtained with the following configuration flags:


```text
./configure --enable-kyber \
            --enable-dilithium \
            --disable-shared \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp \
            --enable-sp-math \
            --enable-sp-asm \
            CFLAGS="-Os -DECC_USER_CURVES -DHAVE_ECC256"
```

**Note**: Only two cores are used for these benchmarks.

```text
wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   965.511 ms
        Tx Total    :     7.469 ms
        Rx          :     2.978 MB/s
        Tx          :   384.903 MB/s
        Connect     :    48.343 ms
        Connect Avg :     2.014 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   967.748 ms
        Tx Total    :     6.789 ms
        Rx          :     2.971 MB/s
        Tx          :   423.496 MB/s
        Connect     :    48.574 ms
        Connect Avg :     2.024 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   960.296 ms
        Tx Total    :     7.494 ms
        Rx          :     2.994 MB/s
        Tx          :   383.617 MB/s
        Connect     :    56.255 ms
        Connect Avg :     2.344 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   962.002 ms
        Tx Total    :     7.367 ms
        Rx          :     2.989 MB/s
        Tx          :   390.259 MB/s
        Connect     :    56.220 ms
        Connect Avg :     2.343 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   938.745 ms
        Tx Total    :     7.889 ms
        Rx          :     2.929 MB/s
        Tx          :   348.596 MB/s
        Connect     :    61.261 ms
        Connect Avg :     2.664 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   940.382 ms
        Tx Total    :     7.540 ms
        Rx          :     2.924 MB/s
        Tx          :   364.711 MB/s
        Connect     :    61.433 ms
        Connect Avg :     2.671 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   952.389 ms
        Tx Total    :     5.561 ms
        Rx          :     3.019 MB/s
        Tx          :   517.005 MB/s
        Connect     :    50.177 ms
        Connect Avg :     2.091 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   954.202 ms
        Tx Total    :     4.751 ms
        Rx          :     3.013 MB/s
        Tx          :   605.110 MB/s
        Connect     :    48.602 ms
        Connect Avg :     2.025 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   955.030 ms
        Tx Total    :     5.882 ms
        Rx          :     3.010 MB/s
        Tx          :   488.757 MB/s
        Connect     :    51.283 ms
        Connect Avg :     2.137 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   955.658 ms
        Tx Total    :     6.200 ms
        Rx          :     3.008 MB/s
        Tx          :   463.686 MB/s
        Connect     :    49.717 ms
        Connect Avg :     2.072 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.042 ms
        Tx Total    :     7.294 ms
        Rx          :     2.955 MB/s
        Tx          :   394.150 MB/s
        Connect     :    51.750 ms
        Connect Avg :     2.156 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.655 ms
        Tx Total    :     7.996 ms
        Rx          :     2.953 MB/s
        Tx          :   359.573 MB/s
        Connect     :    50.328 ms
        Connect Avg :     2.097 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group SecP256r1MLKEM512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   961.483 ms
        Tx Total    :     7.430 ms
        Rx          :     2.990 MB/s
        Tx          :   386.966 MB/s
        Connect     :    55.885 ms
        Connect Avg :     2.329 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group SecP256r1MLKEM512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   963.042 ms
        Tx Total    :     7.088 ms
        Rx          :     2.985 MB/s
        Tx          :   405.605 MB/s
        Connect     :    53.236 ms
        Connect Avg :     2.218 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group SecP384r1MLKEM768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   927.519 ms
        Tx Total    :     7.338 ms
        Rx          :     2.965 MB/s
        Tx          :   374.747 MB/s
        Connect     :    64.464 ms
        Connect Avg :     2.803 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group SecP384r1MLKEM768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   929.281 ms
        Tx Total    :     6.923 ms
        Rx          :     2.959 MB/s
        Tx          :   397.229 MB/s
        Connect     :    60.200 ms
        Connect Avg :     2.617 ms

wolfSSL Server Benchmark on TLS13-AES128-GCM-SHA256 with group SecP521r1MLKEM1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   918.122 ms
        Tx Total    :     7.598 ms
        Rx          :     2.995 MB/s
        Tx          :   361.941 MB/s
        Connect     :    79.426 ms
        Connect Avg :     3.453 ms
wolfSSL Client Benchmark on TLS13-AES128-GCM-SHA256 with group SecP521r1MLKEM1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   919.900 ms
        Tx Total    :     7.563 ms
        Rx          :     2.989 MB/s
        Tx          :   363.618 MB/s
        Connect     :    71.686 ms
        Connect Avg :     3.117 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   962.723 ms
        Tx Total    :     6.394 ms
        Rx          :     2.986 MB/s
        Tx          :   449.663 MB/s
        Connect     :    52.042 ms
        Connect Avg :     2.168 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP256R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   963.166 ms
        Tx Total    :     7.537 ms
        Rx          :     2.985 MB/s
        Tx          :   381.433 MB/s
        Connect     :    52.348 ms
        Connect Avg :     2.181 ms



wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   966.071 ms
        Tx Total    :     8.458 ms
        Rx          :     2.976 MB/s
        Tx          :   339.929 MB/s
        Connect     :    56.135 ms
        Connect Avg :     2.339 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP384R1:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   968.053 ms
        Tx Total    :     7.895 ms
        Rx          :     2.970 MB/s
        Tx          :   364.155 MB/s
        Connect     :    56.188 ms
        Connect Avg :     2.341 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   930.195 ms
        Tx Total    :     7.849 ms
        Rx          :     2.956 MB/s
        Tx          :   350.364 MB/s
        Connect     :    62.644 ms
        Connect Avg :     2.724 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ECC_SECP521R1:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   932.128 ms
        Tx Total    :     7.440 ms
        Rx          :     2.950 MB/s
        Tx          :   369.619 MB/s
        Connect     :    62.538 ms
        Connect Avg :     2.719 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   973.208 ms
        Tx Total    :     8.190 ms
        Rx          :     2.954 MB/s
        Tx          :   351.021 MB/s
        Connect     :    49.608 ms
        Connect Avg :     2.067 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   975.874 ms
        Tx Total    :     7.051 ms
        Rx          :     2.946 MB/s
        Tx          :   407.772 MB/s
        Connect     :    48.708 ms
        Connect Avg :     2.030 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   965.259 ms
        Tx Total    :     8.098 ms
        Rx          :     2.978 MB/s
        Tx          :   355.041 MB/s
        Connect     :    51.284 ms
        Connect Avg :     2.137 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_768:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   967.507 ms
        Tx Total    :     7.774 ms
        Rx          :     2.972 MB/s
        Tx          :   369.828 MB/s
        Connect     :    49.899 ms
        Connect Avg :     2.079 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   972.588 ms
        Tx Total    :     7.835 ms
        Rx          :     2.956 MB/s
        Tx          :   366.959 MB/s
        Connect     :    52.259 ms
        Connect Avg :     2.177 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group ML_KEM_1024:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   974.238 ms
        Tx Total    :     7.838 ms
        Rx          :     2.951 MB/s
        Tx          :   366.813 MB/s
        Connect     :    50.758 ms
        Connect Avg :     2.115 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SecP256r1MLKEM512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   971.832 ms
        Tx Total    :     7.544 ms
        Rx          :     2.958 MB/s
        Tx          :   381.096 MB/s
        Connect     :    54.727 ms
        Connect Avg :     2.280 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SecP256r1MLKEM512:
        Total       :   6029312 bytes
        Num Conns   :        24
        Rx Total    :   972.623 ms
        Tx Total    :     8.807 ms
        Rx          :     2.956 MB/s
        Tx          :   326.456 MB/s
        Connect     :    52.613 ms
        Connect Avg :     2.192 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SecP384r1MLKEM768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   921.217 ms
        Tx Total    :     7.740 ms
        Rx          :     2.985 MB/s
        Tx          :   355.285 MB/s
        Connect     :    69.367 ms
        Connect Avg :     3.016 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SecP384r1MLKEM768:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   923.622 ms
        Tx Total    :     6.928 ms
        Rx          :     2.977 MB/s
        Tx          :   396.956 MB/s
        Connect     :    63.739 ms
        Connect Avg :     2.771 ms

wolfSSL Server Benchmark on TLS13-AES256-GCM-SHA384 with group SecP521r1MLKEM1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   920.447 ms
        Tx Total    :     7.735 ms
        Rx          :     2.988 MB/s
        Tx          :   355.548 MB/s
        Connect     :    78.446 ms
        Connect Avg :     3.411 ms
wolfSSL Client Benchmark on TLS13-AES256-GCM-SHA384 with group SecP521r1MLKEM1024:
        Total       :   5767168 bytes
        Num Conns   :        23
        Rx Total    :   921.889 ms
        Tx Total    :     7.585 ms
        Rx          :     2.983 MB/s
        Tx          :   362.578 MB/s
        Connect     :    71.310 ms
        Connect Avg :     3.100 ms
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

### Developer Notes

* If you are trying to thwart the “harvest now, decrypt later” threat model and you are willing to sacrifice some interoperability, then you do not want to advertise support for conventional algorithms in the Supported Groups extension.  Be sure to call `wolfSSL_UseKeyShare()` and `wolfSSL_set_groups()` with your chosen algorithms.  Only calling `wolfSSL_UseKeyShare()` is insufficient as that will advertise your support for quantum-vulnerable algorithms. If your peer does not support post-quantum algorithms, they will then send a HelloRetryRequest which will then result in a connection with a conventional algorithm.
