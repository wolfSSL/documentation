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

In order be able to use liboqs, you must have it built and installed on your system. We support the 0.7.0 release of liboqs. You can download it from the following link:

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

## Statistics

The following statistics and benchmarks were taken on an 11th GenIntel Core i7-1165G7@3-GHz with 8 cores running Ubuntu 21.10. The following configuration was used:

```
./configure --with-liboqs \
            --enable-all \
            --disable-psk \
            --enable-intelasm \
            --enable-aesni \
            --enable-sp-math-all \
            --enable-sp-asm \
            --disable-shared \
            CFLAGS="-O3"
```

**NOTE**: that we are primarily benchmarking the post-quantum algorithms, but leave some conventonal algorithms for comparisson purposes.

### Runtime Binary Sizes

The `tls_bench` example application binary file is 12533216 bytes after being built then stripped (Approximately 12Mb).  Without the `--with-liboqs` it is 2592504 bytes after being built then stripped (Approximately 2.5Mb). This is a difference of 9940712 bytes (Approximately 10Mb).

### Benchmarks for KEM Groups

**NOTE**: Only two cores are used.

```
Side   Cipher                  Group              Total Bytes  # Cons   Rx ms  Tx ms  Rx MB/s  Tx MB/s Con Total ms Con Avg ms
Server TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL1       94109696     360 116.876 34.657  383.954 1294.841      817.056      2.270
Client TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL1       94109696     360 131.154 35.160  342.155 1276.323      788.418      2.190
Server TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL3       93061120     356 115.693 33.436  383.559 1327.160      821.014      2.306
Client TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL3       93061120     356 128.384 35.466  345.642 1251.191      782.233      2.197
Server TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL5       90439680     346 111.384 33.741  387.174 1278.110      824.229      2.382
Client TLS13-AES256-GCM-SHA384 NTRU_HPS_LEVEL5       90439680     346 125.771 33.862  342.884 1273.565      775.349      2.241
Server TLS13-AES256-GCM-SHA384 NTRU_HRSS_LEVEL3      94371840     361 117.989 34.373  381.391 1309.184      817.547      2.265
Client TLS13-AES256-GCM-SHA384 NTRU_HRSS_LEVEL3      94371840     361 131.532 35.736  342.122 1259.240      786.960      2.180
Server TLS13-AES256-GCM-SHA384 SABER_LEVEL1         102498304     392  59.561 24.098  820.594 2028.163      886.410      2.261
Client TLS13-AES256-GCM-SHA384 SABER_LEVEL1         102498304     392  68.141 25.480  717.260 1918.205      876.183      2.235
Server TLS13-AES256-GCM-SHA384 SABER_LEVEL3          94896128     363 119.808 35.041  377.687 1291.359      812.975      2.240
Client TLS13-AES256-GCM-SHA384 SABER_LEVEL3          94896128     363 133.942 36.115  337.832 1252.953      801.405      2.208
Server TLS13-AES256-GCM-SHA384 SABER_LEVEL5          95420416     365 118.562 35.462  383.767 1283.067      816.716      2.238
Client TLS13-AES256-GCM-SHA384 SABER_LEVEL5          95420416     365 133.489 35.353  340.851 1287.030      802.679      2.199
Server TLS13-AES256-GCM-SHA384 KYBER_LEVEL1          96206848     368 121.553 35.806  377.408 1281.203      811.458      2.205
Client TLS13-AES256-GCM-SHA384 KYBER_LEVEL1          96206848     368 136.426 36.592  336.262 1253.697      803.225      2.183
Server TLS13-AES256-GCM-SHA384 KYBER_LEVEL3          95420416     365 120.274 34.591  378.302 1315.382      814.565      2.232
Client TLS13-AES256-GCM-SHA384 KYBER_LEVEL3          95420416     365 133.376 36.390  341.142 1250.349      805.180      2.206
Server TLS13-AES256-GCM-SHA384 KYBER_LEVEL5         103284736     395  42.482 20.276 1159.324 2429.029      908.970      2.301
Client TLS13-AES256-GCM-SHA384 KYBER_LEVEL5         103284736     395  49.772 21.487  989.521 2292.058      896.947      2.271
Server TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL1      96993280     371 120.944 35.366  382.408 1307.751      812.404      2.190
Client TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL1      96993280     371 136.143 35.860  339.715 1289.753      804.651      2.169
Server TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL3     105381888     403  44.744 21.192 1123.055 2371.223      906.669      2.250
Client TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL3     105381888     403  52.139 22.585  963.778 2224.936      897.175      2.226
Server TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL5      94371840     361 119.703 35.377  375.930 1272.003      814.267      2.256
Client TLS13-AES256-GCM-SHA384 KYBER_90S_LEVEL5      94371840     361 134.287 35.772  335.103 1257.981      805.325      2.231
Server TLS13-AES256-GCM-SHA384 P256_NTRU_HPS_LEVEL1  60817408     233  76.671 22.750  378.238 1274.731      879.020      3.773
Client TLS13-AES256-GCM-SHA384 P256_NTRU_HPS_LEVEL1  60817408     233  86.820 22.524  334.025 1287.495      738.097      3.168
Server TLS13-AES256-GCM-SHA384 P384_NTRU_HPS_LEVEL3  44040192     169  54.520 16.256  385.181 1291.823      916.406      5.423
Client TLS13-AES256-GCM-SHA384 P384_NTRU_HPS_LEVEL3  44040192     169  61.869 16.285  339.425 1289.535      712.385      4.215
Server TLS13-AES256-GCM-SHA384 P521_NTRU_HPS_LEVEL5  19660800      76  29.085  7.474  322.332 1254.278      957.413     12.598
Client TLS13-AES256-GCM-SHA384 P521_NTRU_HPS_LEVEL5  19660800      76  33.677  7.209  278.379 1300.403      691.634      9.100
Server TLS13-AES256-GCM-SHA384 P384_NTRU_HRSS_LEVEL3 44302336     170  57.043 16.498  370.334 1280.433      910.827      5.358
Client TLS13-AES256-GCM-SHA384 P384_NTRU_HRSS_LEVEL3 44302336     170  63.837 16.978  330.922 1244.290      708.998      4.171
Server TLS13-AES256-GCM-SHA384 P256_SABER_LEVEL1     63700992     244  80.349 23.606  378.040 1286.733      874.786      3.585
Client TLS13-AES256-GCM-SHA384 P256_SABER_LEVEL1     63700992     244  90.496 23.652  335.651 1284.268      744.870      3.053
Server TLS13-AES256-GCM-SHA384 P384_SABER_LEVEL3     43778048     168  57.115 16.670  365.490 1252.215      911.031      5.423
Client TLS13-AES256-GCM-SHA384 P384_SABER_LEVEL3     43778048     168  64.237 16.679  324.967 1251.606      715.602      4.260
Server TLS13-AES256-GCM-SHA384 P521_SABER_LEVEL5     19922944      77  28.219  7.415  336.650 1281.136      960.078     12.469
Client TLS13-AES256-GCM-SHA384 P521_SABER_LEVEL5     19922944      77  32.301  7.546  294.109 1258.954      699.756      9.088
Server TLS13-AES256-GCM-SHA384 P256_KYBER_LEVEL1     63963136     245  76.158 22.451  400.484 1358.504      882.070      3.600
Client TLS13-AES256-GCM-SHA384 P256_KYBER_LEVEL1     63963136     245  85.451 23.111  356.928 1319.726      755.673      3.084
Server TLS13-AES256-GCM-SHA384 P384_KYBER_LEVEL3     44826624     172  56.518 16.446  378.198 1299.699      913.542      5.311
Client TLS13-AES256-GCM-SHA384 P384_KYBER_LEVEL3     44826624     172  63.516 16.811  336.531 1271.461      722.291      4.199
Server TLS13-AES256-GCM-SHA384 P521_KYBER_LEVEL5     20185088      78  29.065  7.660  331.153 1256.542      964.071     12.360
Client TLS13-AES256-GCM-SHA384 P521_KYBER_LEVEL5     20185088      78  33.797  7.504  284.790 1282.652      709.853      9.101
Server TLS13-AES256-GCM-SHA384 P256_KYBER_90S_LEVEL1 63700992     244  80.024 23.131  379.576 1313.165      876.429      3.592
Client TLS13-AES256-GCM-SHA384 P256_KYBER_90S_LEVEL1 63700992     244  89.563 23.826  339.146 1274.874      750.150      3.074
Server TLS13-AES256-GCM-SHA384 P384_KYBER_90S_LEVEL3 45088768     173  56.515 16.961  380.427 1267.642      910.839      5.265
Client TLS13-AES256-GCM-SHA384 P384_KYBER_90S_LEVEL3 45088768     173  64.275 16.516  334.500 1301.789      717.551      4.148
Server TLS13-AES256-GCM-SHA384 P521_KYBER_90S_LEVEL5 20185088      78  27.928  7.776  344.641 1237.779      966.315     12.389
Client TLS13-AES256-GCM-SHA384 P521_KYBER_90S_LEVEL5 20185088      78  32.654  7.547  294.757 1275.358      704.159      9.028
Server TLS13-AES256-GCM-SHA384 ECC_SECP256R1         74186752     284  92.216 26.950  383.610 1312.610      718.210      2.529
Client TLS13-AES256-GCM-SHA384 ECC_SECP256R1         74186752     284 103.709 27.326  341.098 1294.538      715.137      2.518
Server TLS13-AES256-GCM-SHA384 ECC_SECP384R1         56360960     216  69.969 20.583  384.099 1305.679      659.206      3.052
Client TLS13-AES256-GCM-SHA384 ECC_SECP384R1         56360960     216  78.755 20.905  341.247 1285.562      657.209      3.043
Server TLS13-AES256-GCM-SHA384 ECC_SECP521R1         30408704     117  37.973 11.407  381.849 1271.107      579.722      4.955
Client TLS13-AES256-GCM-SHA384 ECC_SECP521R1         30408704     117  42.993 11.258  337.264 1287.986      578.255      4.942
Server TLS13-AES256-GCM-SHA384 ECC_X25519            96206848     368 119.481 34.674  383.951 1323.022      804.787      2.187
Client TLS13-AES256-GCM-SHA384 ECC_X25519            96206848     368 132.489 36.774  346.254 1247.495      799.288      2.172
Server TLS13-AES256-GCM-SHA384 ECC_X448              88080384     337 108.965 32.332  385.444 1299.015      775.730      2.302
Client TLS13-AES256-GCM-SHA384 ECC_X448              88080384     337 123.017 32.864  341.417 1278.000      770.812      2.287
Server TLS13-AES256-GCM-SHA384 FFDHE_2048            54263808     208  67.686 19.861  382.282 1302.774      746.248      3.588
Client TLS13-AES256-GCM-SHA384 FFDHE_2048            54263808     208  75.651 20.568  342.033 1258.043      742.362      3.569
Server TLS13-AES256-GCM-SHA384 FFDHE_3072            30146560     116  39.867 10.760  360.577 1335.958      710.457      6.125
Client TLS13-AES256-GCM-SHA384 FFDHE_3072            30146560     116  43.340 11.924  331.678 1205.573      708.111      6.104
```

### Benchmarks for Signature Schemes

**NOTE**: Only a single core is used.
```
FALCON                    1 sign   5500 ops took 1.005 sec, avg 0.183 ms, 5471.037 ops/sec
FALCON                    1 verify 29100 ops took 1.002 sec, avg 0.034 ms, 29049.807 ops/sec
FALCON                    5 sign   2800 ops took 1.001 sec, avg 0.358 ms, 2796.496 ops/sec
FALCON                    5 verify 15200 ops took 1.002 sec, avg 0.066 ms, 15168.616 ops/sec
ECDSA BRAINPOOLP256R1   256 sign   14600 ops took 1.004 sec, avg 0.069 ms, 14544.887 ops/sec
ECDSA BRAINPOOLP256R1   256 verify 13300 ops took 1.004 sec, avg 0.075 ms, 13245.692 ops/sec
ECDSA       SECP256R1   256 sign   15700 ops took 1.005 sec, avg 0.064 ms, 15628.247 ops/sec
ECDSA       SECP256R1   256 verify 13500 ops took 1.006 sec, avg 0.075 ms, 13416.990 ops/sec
ED                    25519 sign   91300 ops took 1.000 sec, avg 0.011 ms, 91288.116 ops/sec
ED                    25519 verify 29100 ops took 1.001 sec, avg 0.034 ms, 29065.441 ops/sec
ED                      448 sign   14200 ops took 1.006 sec, avg 0.071 ms, 14108.941 ops/sec
ED                      448 verify 4900 ops took 1.008 sec, avg 0.206 ms, 4862.611 ops/sec
ECCSI                   256 sign   2159 ops took 1.000 sec, avg 0.463 ms, 2158.482 ops/sec
ECCSI                   256 verify 805 ops took 1.000 sec, avg 1.243 ms, 804.603 ops/sec
```

### Heap and Stack Usage

Memory use for server sign and client verify. TLS13-AES256-GCM-SHA384 ciphersuite and ECC SECP256R1 for key exchange.

```
falcon 1    server   heap total: 2920414  heap peak: 2579713  stack: 111584
falcon 1    client   heap total: 2720797  heap peak: 2556718  stack: 100872
falcon 5    server   heap total: 2947287  heap peak: 2586482  stack: 137952
falcon 5    client   heap total: 2737315  heap peak: 2563937  stack: 100872
RSA    2048 server   heap total: 2899406  heap peak: 2549897  stack: 108424
RSA    2048 client   heap total: 2768827  heap peak: 2540497  stack: 107592

```

Memory use for KEM groups. TLS13-AES256-GCM-SHA384 ciphersuite and RSA-2048 for authentication. 

```
KYBER_LEVEL1
server     heap total: 443171  heap peak: 137518
client     heap total: 298130  heap peak: 128955

KYBER_LEVEL3
server     heap total: 450915  heap peak: 138542
client     heap total: 300306  heap peak: 130427

KYBER_LEVEL5
server     heap total: 460419  heap peak: 139886
client     heap total: 302802  heap peak: 132059

KYBER_90S_LEVEL1
server     heap total: 443171  heap peak: 137518
client     heap total: 298130  heap peak: 128955

KYBER_90S_LEVEL3
server     heap total: 450915  heap peak: 138542
client     heap total: 300306  heap peak: 130427

KYBER_90S_LEVEL5
server     heap total: 460419  heap peak: 139886
client     heap total: 302802  heap peak: 132059

NTRU_HPS_LEVEL1
server     heap total: 441301  heap peak: 137279
client     heap total: 297093  heap peak: 128088

NTRU_HPS_LEVEL3
server     heap total: 446383  heap peak: 137972
client     heap total: 298316  heap peak: 128849

NTRU_HPS_LEVEL5
server     heap total: 452983  heap peak: 138872
client     heap total: 299872  heap peak: 299872

NTRU_HRSS_LEVEL3
server     heap total: 450959  heap peak: 138596
client     heap total: 299364  heap peak: 129481

SABER_LEVEL1
server     heap total: 441411  heap peak: 137326
client     heap total: 297746  heap peak: 128731

SABER_LEVEL3
server     heap total: 448803  heap peak: 138350
client     heap total: 299826  heap peak: 130139

SABER_LEVEL5
server     heap total: 456547  heap peak: 139438
client     heap total: 301970  heap peak: 131579

P256_NTRU_HPS_LEVEL1
server     heap total: 2937228  heap peak: 2580002
client     heap total: 2791850  heap peak: 2791850

P384_NTRU_HPS_LEVEL3
server     heap total: 2943062  heap peak: 2580791
client     heap total: 2793249  heap peak: 2575923

P521_NTRU_HPS_LEVEL5
server     heap total: 2950508  heap peak: 2581799
client     heap total: 2795003  heap peak: 2576951

P384_NTRU_HRSS_LEVEL3
server     heap total: 2947638  heap peak: 2581415
client     heap total: 2794297  heap peak: 2576555

P256_SABER_LEVEL1
server     heap total: 2937338  heap peak: 2580049
client     heap total: 2792503  heap peak: 2575741

P384_SABER_LEVEL3
server     heap total: 2945482  heap peak: 2581169
client     heap total: 2794759  heap peak: 2577213

P521_SABER_LEVEL5
server     heap total: 2954072  heap peak: 2582365
client     heap total: 2797101  heap peak: 2578725

P256_KYBER_LEVEL1
server     heap total: 2939098  heap peak: 2580241
client     heap total: 2792887  heap peak: 2575965

P384_KYBER_LEVEL3
server     heap total: 2947594  heap peak: 2581361
client     heap total: 2795239  heap peak: 2577501

P521_KYBER_LEVEL5
server     heap total: 2957944  heap peak: 2582813
client     heap total: 2797933  heap peak: 2579205

P256_KYBER_90S_LEVEL1
server     heap total: 2939098  heap peak: 2580241
client     heap total: 2792887  heap peak: 2575965

P384_KYBER_90S_LEVEL3
server     heap total: 2947594  heap peak: 2581361
client     heap total: 2795239  heap peak: 2577501

P521_KYBER_90S_LEVEL5
server     heap total: 2957944  heap peak: 2582813
client     heap total: 2797933  heap peak: 2579205

ECDSA SECP256R1
server     heap total: 2899406  heap peak: 2549897
client     heap total: 2768827  heap peak: 2540497
```

**Note**: no variance in stack usage.

## Documentation

Technical documentation and other resources such as known answer tests can be found at the NIST PQC website: 

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.
