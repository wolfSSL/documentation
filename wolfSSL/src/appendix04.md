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

## Documentation

Technical documentation and other resources such as known answer tests can be found at the NIST PQC website: 

<https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions>.
