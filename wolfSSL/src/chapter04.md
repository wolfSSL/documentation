# Features

wolfSSL (formerly CyaSSL) supports the C programming language as a primary interface, but also supports several other host languages, including Java, PHP, Perl, and Python (through a [SWIG](https://swig.org/) interface). If you have interest in hosting wolfSSL in another programming language that is not currently supported, please contact us.

This chapter covers some of the features of wolfSSL in more depth, including Stream Ciphers, AES-NI, IPv6 support, SSL Inspection (Sniffer) support, and more.

## Features Overview

For an overview of wolfSSL features, please reference the wolfSSL product webpage: [https://www.wolfssl.com/products/wolfssl](https://www.wolfssl.com/products/wolfssl)

## Protocol Support

wolfSSL supports **SSL 3.0**, **TLS **(**1.0**, **1.1**, **1.2, 1.3**), and **DTLS **(**1.0 **and **1.2**). You can easily select a protocol to use by using one of the following functions (as shown for either the client or server).  wolfSSL does not support SSL 2.0, as it has been insecure for several years.  The client and server functions below change slightly when using the OpenSSL compatibility layer.  For the OpenSSL-compatible functions, please see [OpenSSL Compatibility](chapter13.md#openssl-compatibility).

### Server Functions

* [`wolfDTLSv1_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gaf418d2cdcba0b6389b6ad75eab927347) - DTLS 1.0
* [`wolfDTLSv1_2_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gad509f76e1ac3ef1beddd6f9549740075) - DTLS 1.2
* [`wolfSSLv3_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga29cb8f4188a54ece2c5c91d13ff2fdee) - SSL 3.0
* [`wolfTLSv1_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga7f5c45e48e18fd0638da5522acff40d2) - TLS 1.0
* [`wolfTLSv1_1_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gae69f7ca1c91761c2321f23e590d3ab23) - TLS 1.1
* [`wolfTLSv1_2_server_method()`](https://wolfssl.com/doxygen/group__Setup.html#ga1eb25bb098c005afaf859ade2c8a7a06) - TLS 1.2
* [`wolfTLSv1_3_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gac5981b6217a145f572e070d5fbba7598) - TLS 1.3
* [`wolfSSLv23_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gaec510d9f1206e05e5f2046b367b1f4c0) - Use highest possible version from SSLv3 - TLS 1.2

wolfSSL supports robust server downgrade with the [`wolfSSLv23_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gaec510d9f1206e05e5f2046b367b1f4c0) function. See [Robust Client and Server Downgrade](#robust-client-and-server-downgrade) for a details.

### Client Functions

* [`wolfDTLSv1_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga54ce048303a97222c9e5cc81dcb69f0a) - DTLS 1.0
* [`wolfDTLSv1_2_client_method_ex()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a285af74c1737ba6e87306d3cefd093b8) - DTLS 1.2
* [`wolfSSLv3_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga76150354400b8a9c51d86f98b492e30c) - SSL 3.0
* [`wolfTLSv1_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga766c120c5ebfd425f9bad7e4104c3a03) - TLS 1.0
* [`wolfTLSv1_1_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga17bc479b058fc4b6fb245b7aa0676531) - TLS 1.1
* [`wolfTLSv1_2_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gad509f76e1ac3ef1beddd6f9549740075) - TLS 1.2
* [`wolfTLSv1_3_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga403e9eb25c8d5cde0a5917e5b10b9762) - TLS 1.3
* [`wolfSSLv23_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gae5d3f13c218a012a3c8b1e018388ec49) - Use highest possible version from SSLv3 - TLS 1.2

wolfSSL supports robust client downgrade with the [`wolfSSLv23_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gae5d3f13c218a012a3c8b1e018388ec49) function. See [Robust Client and Server Downgrade](#robust-client-and-server-downgrade) for a details.

For details on how to use these functions, please see the [Getting Started](chapter03.md#getting-started) chapter. For a comparison between SSL 3.0, TLS 1.0, 1.1, 1.2, and DTLS, please see Appendix A.

### Robust Client and Server Downgrade

Both wolfSSL clients and servers have robust version downgrade capability.  If a specific protocol version method is used on either side, then only that version will be negotiated or an error will be returned.  For example, a client that uses TLS 1.0 and tries to connect to an SSL 3.0 only server, the connection will fail, likewise connecting to a TLS 1.1 will fail as well.

To resolve this issue, a client that uses the [`wolfSSLv23_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gae5d3f13c218a012a3c8b1e018388ec49) function will support the highest protocol version supported by the server by downgrading if necessary. In this case, the client will be able to connect to a server running TLS 1.0 - TLS 1.3 (or a subset or superset that includes SSL 3.0 depending on which protocol versions are configured in wolfSSL).  The only versions it can't connect to is SSL 2.0 which has been insecure for years, and SSL 3.0 which has been disabled by default.

Similarly, a server using the [`wolfSSLv23_server_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gaec510d9f1206e05e5f2046b367b1f4c0) function can handle clients supporting protocol versions from TLS 1.0 - TLS 1.2.  A wolfSSL server can't accept a connection from SSLv2 because no security is provided.

### IPv6 Support

If you are an adopter of IPv6 and want to use an embedded SSL implementation then you may have been wondering if wolfSSL supports IPv6.  The answer is yes, we do support wolfSSL running on top of IPv6.

wolfSSL was designed as IP neutral, and will work with both IPv4 and IPv6, but the current test applications default to IPv4 (so as to apply to a broader range of systems).  To change the test applications to IPv6, use the **--enable-ipv6 **option while building wolfSSL.

Further information on IPv6 can be found here:

[https://en.wikipedia.org/wiki/IPv6](https://en.wikipedia.org/wiki/IPv6).

### DTLS

wolfSSL has support for DTLS (“Datagram” TLS) for both client and server.  The current supported version is DTLS 1.0.

The TLS protocol was designed to provide a secure transport channel across a **reliable** medium (such as TCP).  As application layer protocols began to be developed using UDP transport (such as SIP and various electronic gaming protocols), a need arose for a way to provide communications security for applications which are delay sensitive. This need lead to the creation of the DTLS protocol.

Many people believe the difference between TLS and DTLS is the same as TCP vs. UDP. This is incorrect.  UDP has the benefit of having no handshake, no tear-down, and no delay in the middle if something gets lost (compared with TCP).  DTLS on the other hand, has an extended SSL handshake and tear-down and must implement TCP-like behavior for the handshake.  In essence, DTLS reverses the benefits that are offered by UDP in exchange for a secure connection.

DTLS can be enabled when building wolfSSL by using the [`--enable-dtls`](chapter02.md#enable-dtls) build option.

### LwIP (Lightweight Internet Protocol)

wolfSSL supports the lightweight internet protocol implementation out of the box. To use  this protocol all you need to do is define `WOLFSSL_LWIP` or navigate to the `settings.h` file and uncomment the line:

```c
/*#define WOLFSSL_LWIP*/
```

The focus of lwIP is to reduce RAM usage while still providing a full TCP stack. That focus makes lwIP great for use in embedded systems, an area where wolfSSL is an ideal match for SSL/TLS needs.

### TLS Extensions

A list of TLS extensions supported by wolfSSL and note of which RFC can be referenced for the given extension.

| RFC | Extension | wolfSSL Type |
| --- | --------- | ------------ |
| [6066](https://datatracker.ietf.org/doc/html/rfc6066) | Server Name Indication | `TLSX_SERVER_NAME` |
| [6066](https://datatracker.ietf.org/doc/html/rfc6066) | Maximum Fragment Length Negotiation | `TLSX_MAX_FRAGMENT_LENGTH` |
| [6066](https://datatracker.ietf.org/doc/html/rfc6066) | Truncated HMAC | `TLSX_TRUNCATED_HMAC` |
| [6066](https://datatracker.ietf.org/doc/html/rfc6066) | Status Request | `TLSX_STATUS_REQUEST` |
| [7919](https://datatracker.ietf.org/doc/html/rfc7919) | Supported Groups | `TLSX_SUPPORTED_GROUPS` |
| [5246](https://datatracker.ietf.org/doc/html/rfc5246) | Signature Algorithm | `TLSX_SIGNATURE_ALGORITHMS` |
| [7301](https://datatracker.ietf.org/doc/html/rfc7301) | Application Layer Protocol Negotiation | `TLSX_APPLICATION_LAYER_PROTOCOL` |
| [6961](https://datatracker.ietf.org/doc/html/rfc6961) | Multiple Certificate Status Request | `TLSX_STATUS_REQUEST_V2` |
| [Draft](https://tools.ietf.org/html/draft-whyte-qsh-tls12-00) | Quantum-Safe Hybrid Key Exchange | `TLSX_QUANTUM_SAFE_HYBRID` |
| [5077](https://datatracker.ietf.org/doc/html/rfc5077) | Session Ticket | `TLSX_SESSION_TICKET` |
| [5746](https://datatracker.ietf.org/doc/html/rfc5746) | Renegotiation Indication | `TLSX_RENEGOTIATION_INFO` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Key Share | `TLSX_KEY_SHARE` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Pre Shared Key | `TLSX_PRE_SHARED_KEY` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | PSK Key Exchange Modes | `TLSX_PSK_KEY_EXCHANGE_MODES` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Early Data | `TLSX_EARLY_DATA` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Cookie | `TLSX_COOKIE` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Supported Versions | `TLSX_SUPPORTED_VERSIONS` |
| [8446](https://datatracker.ietf.org/doc/html/rfc8446) | Post Handshake Authorization | `TLSX_POST_HANDSHAKE_AUTH` |

## Cipher Support

### Cipher Suite Strength and Choosing Proper Key Sizes

To see what ciphers are currently being used you can call the method: [`wolfSSL_get_ciphers()`](https://www.wolfssl.com/doxygen/group__IO.html#ga8ce5eb8872afd2784b562123e4607404).

This function will return the currently enabled cipher suites.

Cipher suites come in a variety of strengths.  Because they are made up of several different types of algorithms (authentication, encryption, and message authentication code (MAC)), the strength of each varies with the chosen key sizes.

There can be many methods of grading the strength of a cipher suite - the specific method used seems to vary between different projects and companies and can include things such as symmetric and public key algorithm key sizes, type of algorithm, performance, and known weaknesses.

**NIST** (National Institute of Standards and Technology) makes recommendations on choosing an acceptable cipher suite by providing comparable algorithm strengths for varying key sizes of each.  The strength of a cryptographic algorithm depends on the algorithm and the key size used.  The NIST Special Publication, [SP800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final), states that two algorithms are considered to be of comparable strength as follows:

> Two algorithms are considered to be of comparable strength for the given key sizes (X and Y) if the amount of work needed to “break the algorithms” or determine the keys (with the given key sizes) is approximately the same using a given resource. The security strength of an algorithm for a given key size is traditionally described in terms of the amount of work it takes to try all keys for a symmetric algorithm with a key size of “X” that has no shortcut attacks (i.e., the most efficient attack is to try all possible keys).

The following two tables are based off of both Table 2 (pg. 56) and Table 4 (pg. 59) from [NIST SP800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final), and shows comparable security strength between algorithms as well as a strength measurement (based off of NIST’s suggested algorithm security lifetimes using bits of security).

**Note**:  In the following table “L” is the size of the public key for finite field cryptography (FFC), “N” is the size of the private key for FFC, “k” is considered the key size for integer factorization cryptography (IFC), and “f” is considered the key size for elliptic curve cryptography.

| Bits of Security | Symmetric Key Algorithms | **FFC** Key Size (DSA, DH, etc.) | **IFC** Key Size (RSA, etc.) | **ECC** Key Size (ECDSA, etc.) | Description |
| ---------------- | ------------------------ | -------------------------------- | ---------------------------- | ------------------------------ | ----------- |
| 80 | 2TDEA, etc. | L = 1024, N = 160 | k = 1024 | f = 160-223 | Security good through 2010 |
| 128 | AES-128, etc. | L = 3072, N = 256 | k = 3072 | f = 256-383 | Security good through 2030 |
| 192 | AES-192, etc. | L = 7680, N = 384 | k = 7680 | f = 384-511 | Long Term Protection |
| 256 | AES-256, etc. | L = 15360, N = 512 | k = 15360 | f = 512+ | Secure for the foreseeable future |

Using this table as a guide, to begin to classify a cipher suite, we categorize it based on the strength of the symmetric encryption algorithm.  In doing this, a rough grade classification can be devised to classify each cipher suite based on bits of security (only taking into account symmetric key size):

* **LOW** - bits of security smaller than 128 bits
* **MEDIUM** - bits of security equal to 128 bits
* **HIGH** - bits of security larger than 128 bits

Outside of the symmetric encryption algorithm strength, the strength of a cipher suite will depend greatly on the key sizes of the key exchange and authentication algorithm keys.  The strength is only as good as the cipher suite’s weakest link.

Following the above grading methodology (and only basing it on symmetric encryption algorithm strength), wolfSSL 2.0.0 currently supports a total of 0 LOW strength cipher suites, 12 MEDIUM strength cipher suites, and 8 HIGH strength cipher suites – as listed below.  The following strength classification could change depending on the chosen key sizes of the other algorithms involved. For a reference on hash function security strength, see Table 3 (pg. 56) of [NIST SP800-57](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final).

In some cases, you will see ciphers referenced as “**EXPORT**” ciphers.  These ciphers originated from the time period in US history (as late as 1992) when it was illegal to export software with strong encryption from the United States.  Strong encryption was classified as “Munitions” by the US Government (under the same category as Nuclear Weapons, Tanks, and Ballistic Missiles). Because of this restriction, software being exported included “weakened” ciphers (mostly in smaller key sizes).  In the current day, this restriction has been lifted, and as such, EXPORT ciphers are no longer a mandated necessity.

### Supported Cipher Suites

The following cipher suites are supported by wolfSSL. A cipher suite is a combination of authentication, encryption, and message authentication code (MAC) algorithms which are used during the TLS or SSL handshake to negotiate security settings for a connection.

Each cipher suite defines a key exchange algorithm, a bulk encryption algorithm, and a message authentication code algorithm (MAC). The **key exchange algorithm **(RSA, DSS, DH, EDH) determines how the client and server will authenticate during the handshake process. The **bulk encryption algorithm** (DES, 3DES, AES, ARC4, RABBIT, HC-128), including block ciphers and stream ciphers, is used to encrypt the message stream. The **message authentication code (MAC) algorithm** (MD2, MD5, SHA-1, SHA-256, SHA-512, RIPEMD) is a hash function used to create the message digest.

The table below matches up to the cipher suites (and categories) found in `<wolfssl_root>/wolfssl/internal.h` (starting at about line 706).  If you are looking for a cipher suite which is not in the following list, please contact us to discuss getting it added to wolfSSL.

ECC cipher suites:

* `TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_DHE_RSA_WITH_AES_256_CBC_SHA`
* `TLS_DHE_RSA_WITH_AES_128_CBC_SHA`
* `TLS_DH_anon_WITH_AES_128_CBC_SHA`
* `TLS_RSA_WITH_AES_256_CBC_SHA`
* `TLS_RSA_WITH_AES_128_CBC_SHA`
* `TLS_RSA_WITH_NULL_SHA`
* `TLS_PSK_WITH_AES_256_CBC_SHA`
* `TLS_PSK_WITH_AES_128_CBC_SHA256`
* `TLS_PSK_WITH_AES_256_CBC_SHA384`
* `TLS_PSK_WITH_AES_128_CBC_SHA`
* `TLS_PSK_WITH_NULL_SHA256`
* `TLS_PSK_WITH_NULL_SHA384`
* `TLS_PSK_WITH_NULL_SHA`
* `SSL_RSA_WITH_RC4_128_SHA`
* `SSL_RSA_WITH_RC4_128_MD5`
* `SSL_RSA_WITH_3DES_EDE_CBC_SHA`
* `SSL_RSA_WITH_IDEA_CBC_SHA`
* `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA`
* `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`
* `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA`
* `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA`
* `TLS_ECDHE_RSA_WITH_RC4_128_SHA`
* `TLS_ECDHE_ECDSA_WITH_RC4_128_SHA`
* `TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`
* `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256`
* `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384`
* `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384`
* `TLS_ECDHE_PSK_WITH_NULL_SHA256`
* `TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256`
* `TLS_ECDHE_ECDSA_WITH_NULL_SHA`

Static ECC cipher suites:

* `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA`
* `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA`
* `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA`
* `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA`
* `TLS_ECDH_RSA_WITH_RC4_128_SHA`
* `TLS_ECDH_ECDSA_WITH_RC4_128_SHA`
* `TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256`
* `TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256`
* `TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384`
* `TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384`

wolfSSL extension - eSTREAM cipher suites:

* `TLS_RSA_WITH_HC_128_MD5`
* `TLS_RSA_WITH_HC_128_SHA`
* `TLS_RSA_WITH_RABBIT_SHA`

Blake2b cipher suites:

* `TLS_RSA_WITH_AES_128_CBC_B2B256`
* `TLS_RSA_WITH_AES_256_CBC_B2B256`
* `TLS_RSA_WITH_HC_128_B2B256`

wolfSSL extension - Quantum-Safe Handshake:

* `TLS_QSH`

wolfSSL extension - NTRU cipher suites:

* `TLS_NTRU_RSA_WITH_RC4_128_SHA`
* `TLS_NTRU_RSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_NTRU_RSA_WITH_AES_128_CBC_SHA`
* `TLS_NTRU_RSA_WITH_AES_256_CBC_SHA`

SHA-256 cipher suites:

* `TLS_DHE_RSA_WITH_AES_256_CBC_SHA256`
* `TLS_DHE_RSA_WITH_AES_128_CBC_SHA256`
* `TLS_RSA_WITH_AES_256_CBC_SHA256`
* `TLS_RSA_WITH_AES_128_CBC_SHA256`
* `TLS_RSA_WITH_NULL_SHA256`
* `TLS_DHE_PSK_WITH_AES_128_CBC_SHA256`
* `TLS_DHE_PSK_WITH_NULL_SHA256`

SHA-384 cipher suites:

* `TLS_DHE_PSK_WITH_AES_256_CBC_SHA384`
* `TLS_DHE_PSK_WITH_NULL_SHA384`

AES-GCM cipher suites:

* `TLS_RSA_WITH_AES_128_GCM_SHA256`
* `TLS_RSA_WITH_AES_256_GCM_SHA384`
* `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`
* `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`
* `TLS_PSK_WITH_AES_128_GCM_SHA256`
* `TLS_PSK_WITH_AES_256_GCM_SHA384`
* `TLS_DHE_PSK_WITH_AES_128_GCM_SHA256`
* `TLS_DHE_PSK_WITH_AES_256_GCM_SHA384`

ECC AES-GCM cipher suites:

* `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`
* `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`
* `TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256`
* `TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384`
* `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`
* `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`
* `TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256`
* `TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384`

AES-CCM cipher suites:

* `TLS_RSA_WITH_AES_128_CCM_8`
* `TLS_RSA_WITH_AES_256_CCM_8`
* `TLS_ECDHE_ECDSA_WITH_AES_128_CCM`
* `TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8`
* `TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8`
* `TLS_PSK_WITH_AES_128_CCM`
* `TLS_PSK_WITH_AES_256_CCM`
* `TLS_PSK_WITH_AES_128_CCM_8`
* `TLS_PSK_WITH_AES_256_CCM_8`
* `TLS_DHE_PSK_WITH_AES_128_CCM`
* `TLS_DHE_PSK_WITH_AES_256_CCM`

Camellia cipher suites:

* `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA`
* `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA`
* `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256`
* `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256`
* `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA`
* `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA`
* `TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256`
* `TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256`

ChaCha cipher suites:

* `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_PSK_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256`
* `TLS_ECDHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256`
* `TLS_ECDHE_ECDSA_WITH_CHACHA20_OLD_POLY1305_SHA256`
* `TLS_DHE_RSA_WITH_CHACHA20_OLD_POLY1305_SHA256`

Renegotiation Indication Extension Special Suite:

* `TLS_EMPTY_RENEGOTIATION_INFO_SCSV`

### AEAD Suites

wolfSSL supports AEAD suites, including AES-GCM, AES-CCM, and CHACHA-POLY1305. The big difference between these AEAD suites and others is that they authenticate the encrypted data with any additional cleartext data. This helps with mitigating man in the middle attacks that result in having data tampered with. AEAD suites use a combination of a block cipher (or more recently also a stream cipher) algorithm combined with a tag produced by a keyed hash algorithm. Combining these two algorithms is handled by the wolfSSL encrypt and decrypt process which makes it easier for users. All that is needed for using a specific AEAD suite is simply enabling the algorithms that are used in a supported suite.

### Block and Stream Ciphers

wolfSSL supports the **AES**, **DES**, **3DES**, and **Camellia** block ciphers and the **RC4**, **RABBIT**, **HC-128** and **CHACHA20 **stream ciphers. AES, DES, 3DES, RC4 and RABBIT are enabled by default.  Camellia, HC-128, and ChaCha20 can be enabled when building wolfSSL (with the [`--enable-hc128`](chapter02.md#enable-hc128), [`--enable-camellia`](chapter02.md#enable-camellia), and [`--disable-chacha`](chapter02.md#disable-chacha) build options, respectively). The default mode of AES is CBC mode.  To enable GCM or CCM mode with AES, use the [`--enable-aesgcm`](chapter02.md#enable-aesgcm) and [`--enable-aesccm`](chapter02.md#enable-aesccm) build options.  Please see the examples for usage and the [wolfCrypt Usage Reference](chapter10.md#wolfcrypt-usage-reference) for specific usage information.

While SSL uses RC4 as the default stream cipher, it has been obsoleted due to compromise. wolfSSL has added two ciphers from the eStream project into the code base, RABBIT and HC-128. RABBIT is nearly twice as fast as RC4 and HC-128 is about 5 times as fast! So if you've ever decided not to use SSL because of speed concerns, using wolfSSL's stream ciphers should lessen or eliminate that performance doubt. Recently wolfSSL also added ChaCha20. While RC4 is about 11% more performant than ChaCha, RC4 is generally considered less secure than ChaCha. ChaCha can put up very nice times of it’s own with added security as a tradeoff.

To see a comparison of cipher performance, visit the wolfSSL Benchmark web page, located here: <https://www.wolfssl.com/docs/benchmarks>.

#### What’s the Difference?

A block cipher has to be encrypted in chunks that are the block size for the cipher. For example, AES has a block size of 16 bytes. So if you're encrypting a bunch of small, 2 or 3 byte chunks back and forth, over 80% of the data is useless padding, decreasing the speed of the encryption/decryption process and needlessly wasting network bandwidth to boot. Basically block ciphers are designed for large chunks of data, have block sizes requiring padding, and use a fixed, unvarying transformation.

Stream ciphers work well for large or small chunks of data. They are suitable for smaller data sizes because no block size is required. If speed is a concern, stream ciphers are your answer, because they use a simpler transformation that typically involves an xor'd keystream. So if you need to stream media, encrypt various data sizes including small ones, or have a need for a fast cipher then stream ciphers are your best bet.

### Hashing Functions

wolfSSL supports several different hashing functions, including **MD2**, **MD4**, **MD5**, **SHA-1**, **SHA-2** (SHA-224, SHA-256, SHA-384, SHA-512), **SHA-3** (BLAKE2), and **RIPEMD-160**.  Detailed usage of these functions can be found in the wolfCrypt Usage Reference, [Hash Functions](chapter10.md#hash-functions).

### Public Key Options

wolfSSL supports the **RSA**, **ECC**, **DSA/DSS**, **DH**, and **NTRU** public key options, with support for **EDH** (Ephemeral Diffie-Hellman) on the wolfSSL server.  Detailed usage of these functions can be found in the wolfCrypt Usage Reference, [Public Key Cryptography](chapter10.md#public-key-cryptography).

wolfSSL has support for four cipher suites utilizing NTRU public key:

* `TLS_NTRU_RSA_WITH_3DES_EDE_CBC_SHA`
* `TLS_NTRU_RSA_WITH_RC4_128_SHA`
* `TLS_NTRU_RSA_WITH_AES_128_CBC_SHA`
* `TLS_NTRU_RSA_WITH_AES_256_CBC_SHA`

The strongest one, AES-256, is the default. If wolfSSL is enabled with NTRU and the NTRU library is available, these cipher suites are built into the wolfSSL library. A wolfSSL client will have these cipher suites available without any interaction needed by the user. On the other hand, a wolfSSL server application will need to load an NTRU private key and NTRU x509 certificate in order for those cipher suites to be available for use.

The example servers, echoserver and server, both use the define `HAVE_NTRU` (which is turned on by enabling NTRU) to specify whether or not to load NTRU keys and certificates. The wolfSSL package comes with test keys and certificates in the /certs directory. ntru-cert.pem is the certificate and ntru-key.raw is the private key blob.

The wolfSSL NTRU cipher suites are given the highest preference order when the protocol picks a suite. Their exact preference order is the reverse of the above listed suites, i.e., AES-256 will be picked first and 3DES last before moving onto the “standard” cipher suites. Basically, if a user builds NTRU into wolfSSL and both sides of the connection support NTRU then an NTRU cipher suite will be picked unless a user on one side has explicitly excluded them by stating to only use different cipher suites. Using NTRU over RSA can provide a 20 - 200X speed improvement. The improvement increases as the size of keys increases, meaning a much larger speed benefit when using large keys (8192-bit) versus smaller keys (1024-bit).

### ECC Support

wolfSSL has support for Elliptic Curve Cryptography (ECC) including but not limited to: ECDH-ECDSA, ECDHE-ECDSA, ECDH-RSA, ECDHE-PSK and ECDHE-RSA.

wolfSSL’s ECC implementation can be found in the `<wolfssl_root>/wolfssl/wolfcrypt/ecc.h` header file and the `<wolfssl_root>/wolfcrypt/src/ecc.c` source file.

Supported cipher suites are shown in the table above.  ECC is disabled by default on non x86\_64 builds, but can be turned on when building wolfSSL with the `HAVE_ECC` define or by using the autoconf system:

```sh
./configure --enable-ecc
make
make check
```

When `make check` runs, note the numerous cipher suites that wolfSSL checks (if make check doesn’t produce a list of cipher suites run `./testsuite/testsuite.test` on its own).  Any of these cipher suites can be tested individually, e.g., to try ECDH-ECDSA with AES256-SHA, the example wolfSSL server can be started like this:

```sh
./examples/server/server -d -l ECDHE-ECDSA-AES256-SHA -c ./certs/server-ecc.pem -k ./certs/ecc-key.pem
```

(`-d`) disables client cert check while (`-l`) specifies the cipher suite list. (`-c`) is the certificate to use and (`-k`) is the corresponding private key to use.  To have the client connect try:

```sh
./examples/client/client -A ./certs/server-ecc.pem
```

where (`-A`) is the CA certificate to use to verify the server.

### PKCS Support

PKCS (Public Key Cryptography Standards) refers to a group of standards created and published by RSA Security, Inc. wolfSSL has support for **PKCS #1, PKCS #3, PKCS #5, PKCS #7, PKCS #8, PKCS #9, PKCS #10, PKCS #11,** and **PKCS #12.**

Additionally, wolfSSL also provides support for RSA-Probabilistic Signature Scheme (PSS), which is standardized as part of PKCS #1.

#### PKCS #5, PBKDF1, PBKDF2, PKCS #12

PKCS #5 is a password based key derivation method which combines a password, a salt, and an iteration count to generate a password-based key.  wolfSSL supports both PBKDF1 and PBKDF2 key derivation functions. A key derivation function produces a derived key from a base key and other parameters (such as the salt and iteration count as explained above). PBKDF1 applies a hash function (MD5, SHA1, etc) to derive keys, where the derived key length is bounded by the length of the hash function output. With PBKDF2, a pseudorandom function is applied (such as HMAC-SHA-1) to derive the keys. In the case of PBKDF2, the derived key length is unbounded.

wolfSSL also supports the PBKDF function from PKCS #12 in addition to PBKDF1 and PBKDF2. The function prototypes look like this:

```c
int PBKDF2(byte* output, const byte* passwd, int pLen,
           const byte* salt,int sLen, int iterations,
           int kLen, int hashType);

int PKCS12_PBKDF(byte* output, const byte* passwd, int pLen,
                 const byte* salt, int sLen, int iterations,
                 int kLen, int hashType, int purpose);
```

`output` contains the derived key, `passwd` holds the user password of length `pLen`, `salt` holds the salt input of length `sLen`, `iterations` is the number of iterations to perform, `kLen` is the desired derived key length, and `hashType` is the hash to use (which can be MD5, SHA1, or SHA2).

If you are using `./configure` to build wolfssl, the way to enable this functionality is to use the option [`--enable-pwdbased`](chapter02.md#enable-pwdbased)

A full example can be found in `<wolfSSL Root>/wolfcrypt/test.c`. More information can be found on PKCS #5, PBKDF1, and PBKDF2 from the following specifications:

PKCS#5, PBKDF1, PBKDF2: [https://tools.ietf.org/html/rfc2898](https://tools.ietf.org/html/rfc2898)

#### PKCS #8

PKCS #8 is designed as the Private-Key Information Syntax Standard, which is used to store private key information - including a private key for some public-key algorithm and set of attributes.

The PKCS #8 standard has two versions which describe the syntax to store both encrypted private keys and non-encrypted keys. wolfSSL supports both unencrypted and encrypted PKCS #8. Supported formats include PKCS #5 version 1 - version 2, and PKCS#12. Types of encryption available include DES, 3DES, RC4, and AES.

PKCS#8:  [https://tools.ietf.org/html/rfc5208](https://tools.ietf.org/html/rfc5208)

#### PKCS #7

PKCS #7 is designed to transfer bundles of data whether is an enveloped certificate or unencrypted but signed string of data. The functionality is turned on by using the enable option ([`--enable-pkcs7`](chapter02.md#enable-pkcs7)) or by using the macro `HAVE_PKCS7`. Note that degenerate cases are allowed by default as per the RFC having an empty set of signers. To toggle allowing degenerate cases on and off the function `wc_PKCS7_AllowDegenerate()` can be called.

Supported features include:

* Degenerate bundles
* KARI, KEKRI, PWRI, ORI, KTRI bundles
* Detached signatures
* Compressed and Firmware package bundles
* Custom callback support
* Limited streaming capability

##### PKCS #7 Callbacks

Additional callbacks and supporting functions were added to allow for a user to choose their keys after the PKCS7 bundle has been parsed.For unwrapping the CEK the function `wc_PKCS7_SetWrapCEKCb()` can be called. The callback set by this function gets called in the case of KARI and KEKRI bundles. The keyID or SKID gets passed from wolfSSL to the user along with the originator key in the case of KARI. After the user unwraps the CEK with their KEK the decrypted key to be used should then be passed back to wolfSSL. An example of this can be found in the wolfssl-examples repository in the file `signedData-EncryptionFirmwareCB.c`.

An additional callback was added for decryption of PKCS7 bundles. For setting a decryption callback function the API `wc_PKCS7_SetDecodeEncryptedCb()` can be used. To set a user defined context the API `wc_PKCS7_SetDecodeEncryptedCtx()` should be used. This callback will get executed on calls to `wc_PKCS7_DecodeEncryptedData()`.

##### PKCS #7 Streaming

Stream oriented API for PKCS7 decoding gives the option of passing inputs in smaller chunks instead of all at once.By default the streaming functionality with PKCS7 is on. To turn off support for streaming PKCS7 API the macro `NO_PKCS7_STREAM` can be defined. An example of doing this with autotools would be `./configure --enable-pkcs7 CFLAGS=-DNO_PKCS7_STREAM`.

For streaming when decoding/verifying bundles the following functions are supported:

1. `wc_PKCS7_DecodeEncryptedData()`
2. [`wc_PKCS7_VerifySignedData()`](https://www.wolfssl.com/doxygen/group__PKCS7.html#ga77daaf1333bb7aecef288a476cca411d)
3. [`wc_PKCS7_VerifySignedData_ex()`](https://www.wolfssl.com/doxygen/group__PKCS7.html#gac940af4d5e8d11886b821b04674f48d3)
4. [`wc_PKCS7_DecodeEnvelopedData()`](https://www.wolfssl.com/doxygen/group__PKCS7.html#gaf75f2185b48a9458dcfafbe764bafb2d)
5. `wc_PKCS7_DecodeAuthEnvelopedData()`

**Note**: that when calling [`wc_PKCS7_VerifySignedData_ex`](https://www.wolfssl.com/doxygen/group__PKCS7.html#gac940af4d5e8d11886b821b04674f48d3) it is expected that the argument pkiMsgFoot is the full buffer. The internal structure only supports streaming of one buffer which in this case would be `pkiMsgHead`.

### Forcing the Use of a Specific Cipher

By default, wolfSSL will pick the “best” (highest security) cipher suite that both sides of the connection can support.  To force a specific cipher, such as 128 bit AES, add something similar to:

```c
wolfSSL_CTX_set_cipher_list(ctx, "AES128-SHA");
```

after the call to [`wolfSSL_CTX_new()`](https://www.wolfssl.com/doxygen/group__Setup.html#gadfa552e771944a6a1102aa43f45378b5) so that you have:

```c
ctx = wolfSSL_CTX_new(method);
wolfSSL_CTX_set_cipher_list(ctx, "AES128-SHA");
```

### Quantum-Safe Handshake Ciphersuite

wolfSSL has support for the cipher suite utilizing post quantum handshake cipher suite such as with NTRU: `TLS_QSH`

If wolfSSL is enabled with NTRU and the NTRU package is available, the `TLS_QSH` cipher suite is built into the wolfSSL library. A wolfSSL client and server will have this cipher suite available without any interaction needed by the user.

The wolfSSL quantum safe handshake ciphersuite is given the highest preference order when the protocol picks a suite. Basically, if a user builds NTRU into wolfSSL and both sides of the connection support NTRU then an NTRU cipher suite will be picked unless a user on one side has explicitly excluded them by stating to only use different cipher suites.

Users can adjust what crypto algorithms and if the client sends across public keys by using the function examples:

```c
wolfSSL_UseClientQSHKeys(ssl, 1);
wolfSSL_UseSupportedQSH(ssl, WOLFSSL_NTRU_EESS439);
```

To test if a QSH connection was established after a client has connected the following function example can be used:

```c
wolfSSL_isQSH(ssl);
```

## Hardware Accelerated Crypto

wolfSSL is able to take advantage of several hardware accelerated (or “assisted”) crypto functionalities in various processors and chips.  The following sections explain which technologies wolfSSL supports out-of-the-box.

### AES-NI

AES is a key encryption standard used by governments worldwide, which wolfSSL has always supported. Intel has released a new set of instructions that is a faster way to implement AES. wolfSSL is the first SSL library to fully support the new instruction set for production environments.

Essentially, Intel and AMD have added AES instructions at the chip level that perform the computationally-intensive parts of the AES algorithm, boosting performance.  For a list of Intel’s chips that currently have support for AES-NI, you can look here:

[https://ark.intel.com/search/advanced/?s=t&AESTech=true](https://ark.intel.com/search/advanced/?s=t&AESTech=true)

We have added the functionality to wolfSSL to allow it to call  the instructions directly from the chip, instead of running the algorithm in software. This means that when you’re running wolfSSL on a chipset that supports AES-NI, you can run your AES crypto 5-10 times faster!

If you are running on an AES-NI supported chipset, enable AES-NI with the [`--enable-aesni` build option](chapter02.md#enable-aesni).  To build wolfSSL with AES-NI, GCC 4.4.3 or later is required to make use of the assembly code.  wolfSSL supports the ASM instructions on AMD processors using the same build options.

References and further reading on AES-NI, ordered from general to specific, are listed below.  For information about performance gains with AES-NI, please see the third link to the Intel Software Network page.

* [AES (Wikipedia)](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
* [AES-NI (Wikipedia)](https://en.wikipedia.org/wiki/AES_instruction_set)
* [AES-NI (Intel Software Network page)](https://software.intel.com/en-us/articles/intel-advanced-encryption-standard-instructions-aes-ni/)

AES-NI will accelerate the following AES cipher modes: AES-CBC, AES-GCM, AES-CCM-8, AES-CCM, and AES-CTR. AES-GCM is further accelerated with the use of the 128-bit multiply function added to the Intel chips for the GHASH authentication.

### STM32F2

wolfSSL is able to use the STM32F2 hardware-based cryptography and random number generator through the STM32F2 Standard Peripheral Library.

For necessary defines, see the `WOLFSSL_STM32F2` define in `settings.h`. The `WOLFSSL_STM32F2` define enables STM32F2 hardware crypto and RNG support by default.  The defines for enabling these individually are `STM32F2_CRYPTO` (for hardware crypto support) and `STM32F2_RNG` (for hardware RNG support).

Documentation for the STM32F2 Standard Peripheral Library can be found in the following document: <https://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/USER_MANUAL/DM00023896.pdf>

### Cavium NITROX

wolfSSL has support for Cavium NITROX (<https://www.cavium.com/processor_security.html>). To enable Cavium NITROX support when building wolfSSL use the following configure option:

```sh
./configure --with-cavium=/home/user/cavium/software
```

Where the [`--with-cavium=**`](chapter02.md#with-cavium) option is pointing to your licensed cavium/software directory.  Since Cavium doesn't build a library wolfSSL pulls in the `cavium_common.o` file which gives a libtool warning about the portability of this.  Also, if you're using the github source tree you'll need to remove the `-Wredundant-decls` warning from the generated Makefile because the cavium headers don't conform to this warning.

Currently wolfSSL supports Cavium RNG, AES, 3DES, RC4, HMAC, and RSA directly at the crypto layer.  Support at the SSL level is partial and currently just does AES, 3DES, and RC4.  RSA and HMAC are slower until the Cavium calls can be utilized in non-blocking mode.  The example client turns on cavium support as does the crypto test and benchmark.  Please see the `HAVE_CAVIUM` define.

### ESP32-WROOM-32

wolfSSL is able to use the ESP32-WROOM-32 hardware-based cryptography.

For necessary defines, see the `WOLFSSL_ESPWROOM32` define in `settings.h`. The `WOLFSSL_ESPWROOM32` define enables ESP32-WROOM-32 hardware crypto and RNG support by default. Currently wolfSSL supports RNG, AES, SHA and RSA primitive at the crypt layer. The example projects including TLS server/client, wolfCrypt test and benchmark can be found at /examples/protocols directory in ESP-IDF after deploying files.

## SSL Inspection (Sniffer)

Beginning with the wolfSSL 1.5.0 release, wolfSSL has included a build option allowing it to be built with SSL Sniffer (SSL Inspection) functionality. This means that you can collect SSL traffic packets and with the correct key file, are able to decrypt them as well. The ability to “inspect” SSL traffic can be useful for several reasons, some of which include:

* Analyzing Network Problems
* Detecting network misuse by internal and external users
* Monitoring network usage and data in motion
* Debugging client/server communications

To enable sniffer support, build wolfSSL with the [`--enable-sniffer`](chapter02.md#enable-sniffer) option on \*nix or use the **vcproj** files on Windows. You will need to have **pcap** installed on \*nix or **WinPcap** on Windows. The main sniffer functions which can be found in `sniffer.h` are listed below with a short description of each:

* `ssl_SetPrivateKey` - Sets the private key for a specific server and port.
* `ssl_SetNamedPrivateKey` - Sets the private key for a specific server, port and domain name.
* `ssl_DecodePacket` - Passes in a TCP/IP packet for decoding.
* `ssl_Trace` - Enables / Disables debug tracing to the traceFile.
* `ssl_InitSniffer` - Initialize the overall sniffer.
* `ssl_FreeSniffer` - Free the overall sniffer.
* `ssl_EnableRecovery` - Enables option to attempt to pick up decoding of SSL traffic in the case of lost packets.
* `ssl_GetSessionStats` - Obtains memory usage for the sniffer sessions.

To look at wolfSSL's sniffer support and see a complete example, please see the `snifftest` app in the `sslSniffer/sslSnifferTest` folder from the wolfSSL download.

Keep in mind that because the encryption keys are setup in the SSL Handshake, the handshake needs to be decoded by the sniffer in order for future application data to be decoded. For example, if you are using "snifftest" with the wolfSSL example echoserver and echoclient, the snifftest application must be started before the handshake begins between the server and client.

The sniffer can only decode streams encrypted with the following algorithms: AES-CBC, DES3-CBC, ARC4, HC-128, RABBIT, Camellia-CBC, and IDEA. If ECDHE or DHE key agreement is used the stream cannot be sniffed; only RSA or ECDH key-exchange is supported.

Watch callbacks with wolfSSL sniffer can be turned on with `WOLFSSL_SNIFFER_WATCH`. With the sniffer watch feature compiled in, the function `ssl_SetWatchKeyCallback()` can be used to set a custom callback. The callback is then used to inspect the certificate chain, error value, and digest of the certificate sent from the peer. If a non 0 value is returned from the callback then an error state is set when processing the peer’s certificate. Additional supporting functions for the watch callbacks are:

* `ssl_SetWatchKeyCtx`: Sets a custom user context that gets passed to the watch callback.
* `ssl_SetWatchKey_buffer`: Loads a new DER format key into server session.
* `ssl_SetWatchKey_file`: File version of `ssl_SetWatchKey_buffer`.

Statistics collecting with the sniffer can be compiled in with defining the macro `WOLFSSL_SNIFFER_STATS`. The statistics are kept in a SSLStats structure and are copied to an applications SSLStats structure by a call to `ssl_ReadStatistics`. Additional API to use with sniffer statistics is `ssl_ResetStatistics` (resets the collection of statistics) and `ssl_ReadResetStatistics` (reads the current statistic values and then resets the internal state). The following is the current statistics kept when turned on:

* `sslStandardConns`
* `sslClientAuthConns`
* `sslResumedConns`
* `sslEphemeralMisses`
* `sslResumeMisses`
* `sslCiphersUnsupported`
* `sslKeysUnmatched`
* `sslKeyFails`
* `sslDecodeFails`
* `sslAlerts`
* `sslDecryptedBytes`
* `sslEncryptedBytes`
* `sslEncryptedPackets`
* `sslDecryptedPackets`
* `sslKeyMatches`
* `sslEncryptedConns`

## Compression

wolfSSL supports data compression with the **zlib** library. The `./configure` build system detects the presence of this library, but if you're building in some other way define the constant `HAVE_LIBZ` and include the path to zlib.h for your includes.

Compression is off by default for a given cipher. To turn it on, use the function [`wolfSSL_set_compression()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga072ad1832a9f74102e204afde9cd9dd6) before SSL connecting or accepting. Both the client and server must have compression turned on in order for compression to be used.

Keep in mind that while compressing data before sending decreases the actual size of the messages being sent and received, the amount of data saved by compression usually takes longer time to analyze than it does to send it raw on all but the slowest of networks.

## Pre-Shared Keys

wolfSSL has support for these ciphers with static pre-shared keys:

* `TLS_PSK_WITH_AES_256_CBC_SHA`
* `TLS_PSK_WITH_AES_128_CBC_SHA256`
* `TLS_PSK_WITH_AES_256_CBC_SHA384`
* `TLS_PSK_WITH_AES_128_CBC_SHA`
* `TLS_PSK_WITH_NULL_SHA256`
* `TLS_PSK_WITH_NULL_SHA384`
* `TLS_PSK_WITH_NULL_SHA`
* `TLS_PSK_WITH_AES_128_GCM_SHA256`
* `TLS_PSK_WITH_AES_256_GCM_SHA384`
* `TLS_PSK_WITH_AES_128_CCM`
* `TLS_PSK_WITH_AES_256_CCM`
* `TLS_PSK_WITH_AES_128_CCM_8`
* `TLS_PSK_WITH_AES_256_CCM_8`
* `TLS_PSK_WITH_CHACHA20_POLY1305`

These suites are built into wolfSSL with `WOLFSSL_STATIC_PSK` on, all PSK suites can be turned off at build time with the constant `NO_PSK`. To only use these ciphers at runtime use the function [`wolfSSL_CTX_set_cipher_list()`](https://www.wolfssl.com/doxygen/group__Setup.html#gac5835a41f08b90828e72ec20d46d6399) with the desired ciphersuite.

wolfSSL has support for ephemeral key PSK suites:

* `ECDHE-PSK-AES128-CBC-SHA256`
* `ECDHE-PSK-NULL-SHA256`
* `ECDHE-PSK-CHACHA20-POLY1305`
* `DHE-PSK-CHACHA20-POLY1305`
* `DHE-PSK-AES256-GCM-SHA384`
* `DHE-PSK-AES128-GCM-SHA256`
* `DHE-PSK-AES256-CBC-SHA384`
* `DHE-PSK-AES128-CBC-SHA256`
* `DHE-PSK-AES128-CBC-SHA256`

On the client, use the function [`wolfSSL_CTX_set_psk_client_callback()`](https://www.wolfssl.com/doxygen/ssl_8h.html#afbf551ed2cfbc67dae6e3237c526d022) to setup the callback. The client example in `<wolfSSL_Home>/examples/client/client.c` gives example usage for setting up the client identity and key, though the actual callback is implemented in `wolfssl/test.h`.

On the server side two additional calls are required:

* [`wolfSSL_CTX_set_psk_server_callback()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9088d514ee6bf4c62333ab1ec0ebb9bf)
* [`wolfSSL_CTX_use_psk_identity_hint()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#gaa9eba22667861bb69697879e19f7cd5f)

The server stores its identity hint to help the client with the 2nd call, in our server example that's "wolfssl server".  An example server psk callback can also be found in `my_psk_server_cb()` in `wolfssl/test.h`.

wolfSSL supports identities and hints up to 128 octets and pre-shared keys up to 64 octets.

## Client Authentication

Client authentication is a feature which enables the server to authenticate clients by requesting that the clients send a certificate to the server for authentication when they connect. Client authentication requires an X.509 client certificate from a CA (or self-signed if generated by you or someone other than a CA).

By default, wolfSSL validates all certificates that it receives - this includes both client and server. To set up client authentication, the server must load the list of trusted CA certificates to be used to verify the client certificate against:

```c
wolfSSL_CTX_load_verify_locations(ctx, caCert, 0);
```

To turn on client verification and control its behavior, the [`wolfSSL_CTX_set_verify()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga9ea9a0b45f8cb4feb7eff739e83aa7bd) function is used.  In the following example, `SSL_VERIFY_PEER` turns on a certificate request from the server to the client.  `SSL_VERIFY_FAIL_IF_NO_PEER_CERT` instructs the server to fail if the client does not present a certificate to validate on the server side.  Other options to [`wolfSSL_CTX_set_verify()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga9ea9a0b45f8cb4feb7eff739e83aa7bd) include `SSL_VERIFY_NONE` and `SSL_VERIFY_CLIENT_ONCE`.

```c
wolfSSL_CTX_set_verify(ctx,SSL_VERIFY_PEER | ((usePskPlus)?
                       SSL_VERIFY_FAIL_EXCEPT_PSK :
                       SSL_VERIFY_FAIL_IF_NO_PEER_CERT),0);
```

An example of client authentication can be found in the example server (`server.c`) included in the wolfSSL download (`/examples/server/server.c`).

## Server Name Indication

SNI is useful when a server hosts multiple ‘virtual’ servers at a single underlying network address. It may be desirable for clients to provide the name of the server which it is contacting. To enable SNI with wolfSSL you can simply do:

```sh
./configure --enable-sni
```

Using SNI on the client side requires an additional function call, which should be one of the following functions:

* [`wolfSSL_CTX_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9c0f3a9d0e24d6c1573bd5c80468bff5)
* [`wolfSSL_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a1e9a31d166aa1135c8170a769ca420bb)

[`wolfSSL_CTX_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9c0f3a9d0e24d6c1573bd5c80468bff5) is most recommended when the client contacts the same server multiple times. Setting the SNI extension at the context level will enable the SNI usage in all SSL objects created from that same context from the moment of the call forward.

[`wolfSSL_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a1e9a31d166aa1135c8170a769ca420bb) will enable SNI usage for one SSL object only, so it is recommended to use this function when the server name changes between sessions.

On the server side one of the same function calls is required. Since the wolfSSL server doesn't host multiple 'virtual' servers, the SNI usage is useful when the termination of the connection is desired in the case of SNI mismatch. In this scenario, [`wolfSSL_CTX_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9c0f3a9d0e24d6c1573bd5c80468bff5) will be more efficient, as the server will set it only once per context creating all subsequent SSL objects with SNI from that same context.

## Handshake Modifications

### Grouping Handshake Messages

wolfSSL has the ability to group handshake messages if the user desires.  This can be done at the context level with [`wolfSSL_CTX_set_group_messages(ctx);`](https://www.wolfssl.com/doxygen/group__Setup.html#gaaf5a2105cfefaf340ec42046022d55ea) or at the SSL object level with [`wolfSSL_set_group_messages(ssl);`](https://www.wolfssl.com/doxygen/group__Setup.html#ga09578c76efc115ca197d2c92bc3df7b8).

## Truncated HMAC

Currently defined TLS cipher suites use the HMAC to authenticate record-layer communications. In TLS, the entire output of the hash function is used as the MAC tag. However, it may be desirable in constrained environments to save bandwidth by truncating the output of the hash function to 80 bits when forming MAC tags. To enable the usage of Truncated HMAC at wolfSSL you can simply do:

```sh
./configure --enable-truncatedhmac
```

Using Truncated HMAC on the client side requires an additional function call, which should be one of the following functions:

* [`wolfSSL_CTX_UseTruncatedHMAC()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ab7b37dc3206175bb2a28e6b60f0079b6)
* [`wolfSSL_UseTruncatedHMAC()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ae94274ae30a6bb3992d291c6267467d1)

[`wolfSSL_CTX_UseTruncatedHMAC()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ab7b37dc3206175bb2a28e6b60f0079b6) is most recommended when the client would like to enable Truncated HMAC for all sessions. Setting the Truncated HMAC extension at context level will enable it in all SSL objects created from that same context from the moment of the call forward.

[`wolfSSL_UseTruncatedHMAC()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ae94274ae30a6bb3992d291c6267467d1) will enable it for one SSL object only, so it's recommended to use this function when there is no need for Truncated HMAC on all sessions.

On the server side no call is required. The server will automatically attend to the client's request for Truncated HMAC.

All TLS extensions can also be enabled with:

```sh
./configure --enable-tlsx
```

## User Crypto Module

User Crypto Module allows for a user to plug in custom crypto that they want used during supported operations (Currently RSA operations are supported). An example of a module is located in the directory `root_wolfssl/wolfcrypt/user-crypto/` using IPP libraries. Examples of the configure option when building wolfSSL to use a crypto module is as follows:

```sh
./configure --with-user-crypto
```

or

```sh
./configure --with-user-crypto=/dir/to
```

When creating a user crypto module that performs RSA operations, it is mandatory that there is a header file for RSA called `user_rsa.h`. For all user crypto operations it is mandatory that the users library be called `libusercrypto`. These are the names that wolfSSL autoconf tools will be looking for when linking and using a user crypto module. In the example provided with wolfSSL, the header file `user_rsa.h` can be found in the directory `wolfcrypt/user-crypto/include/` and the library once created is located in the directory `wolfcrypt/user-crypto/lib/`. For a list of required API look at the header file provided.

To build the example, after having installed IPP libraries, the following commands from the root wolfSSL directory should be ran.

```sh
cd wolfcrypt/user-crypto/
./autogen.sh
./configure
make
sudo make install
```

The included example in wolfSSL requires the use of IPP, which will need to be installed before the project can be built. Though even if not having IPP libraries to build the example it is intended to provide users with an example of file name choice and API interface. Once having made and installed both the library libusercrypto and header files, making wolfSSL use the crypto module does not require any extra steps. Simply using the configure flag [`--with-user-crypto`](chapter02.md#with-user-crypto) will map all function calls from the typical wolfSSL crypto to the user crypto module.

Memory allocations, if using wolfSSL’s XMALLOC, should be tagged with `DYNAMIC_TYPE_USER_CRYPTO`. Allowing for analyzing memory allocations used by the module.

User crypto modules **cannot** be used in conjunction with the wolfSSL configure options fast-rsa and/or fips. Fips requires that specific, certified code be used and fast-rsa makes use of the example user crypto module to perform RSA operations.

## Timing-Resistance in wolfSSL

wolfSSL provides the function “ConstantCompare” which guarantees constant time when doing comparison operations that could potentially leak timing information. This API is used at both the TLS and crypto level in wolfSSL to deter against timing based, side-channel attacks.

The wolfSSL ECC implementation has the define `ECC_TIMING_RESISTANT` to enable timing-resistance in the ECC algorithm. Similarly the define `TFM_TIMING_RESISTANT` is provided in the fast math libraries for RSA algorithm timing-resistance. The function exptmod uses the timing resistant Montgomery ladder.

See also: [`--disable-harden`](chapter02.md#disable-harden)

Timing resistance and cache resistance defines enabled with `--enable-harden`:

* `WOLFSSL_SP_CACHE_RESISTANT`: Enables logic to mask the address used.
* `WC_RSA_BLINDING`: Enables blinding mode, to prevent timing attacks.
* `ECC_TIMING_RESISTANT`: ECC specific timing resistance.
* `TFM_TIMING_RESISTANT`: Fast math specific timing resistance.

## Fixed ABI

wolfSSL provides a fixed Application Binary Interface (ABI) for a subset of the Application Programming Interface (API). Starting with wolfSSL v4.3.0, the following functions will be compatible across all future releases of wolfSSL:

* [`wolfSSL_Init()`](https://www.wolfssl.com/doxygen/group__TLS.html#gae2a25854de5230820a6edf16281d8fd7)
* [`wolfTLSv1_2_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#gad509f76e1ac3ef1beddd6f9549740075)
* [`wolfTLSv1_3_client_method()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga403e9eb25c8d5cde0a5917e5b10b9762)
* [`wolfSSL_CTX_new()`](https://www.wolfssl.com/doxygen/group__Setup.html#gadfa552e771944a6a1102aa43f45378b5)
* [`wolfSSL_CTX_load_verify_locations()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga8cd186024ebed18b23e155a19510bb8a)
* [`wolfSSL_new()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga3b1873a50ef7fcee4e2cc8968c81b6c9)
* [`wolfSSL_set_fd()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga4f23ec6e60cc92e0e899071653d3188b)
* [`wolfSSL_connect()`](https://www.wolfssl.com/doxygen/group__IO.html#ga5b8f41cca120758d1860c7bc959755dd)
* [`wolfSSL_read()`](https://www.wolfssl.com/doxygen/group__IO.html#ga33732bde756a527d61a32212b4b9a017)
* [`wolfSSL_write()`](https://www.wolfssl.com/doxygen/group__IO.html#ga74b924a81e9efdf66d074690e5f53ef1)
* [`wolfSSL_get_error()`](https://www.wolfssl.com/doxygen/group__Debug.html#gae30b3ae133f07c6b9d2b567367489b02)
* [`wolfSSL_shutdown()`](https://www.wolfssl.com/doxygen/group__TLS.html#ga4d8ddcffbe653b7ec26878e34093c048)
* [`wolfSSL_free()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga7fc776693622e2352a558d512bb9a127)
* [`wolfSSL_CTX_free()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga93af2b070b4397008992b8272b960b55)
* [`wolfSSL_check_domain_name()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga72e50573073c923af27afbdac38ed003)
* [`wolfSSL_UseALPN()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga175c36853fc902b7b3722f6f22a819f4)
* [`wolfSSL_CTX_SetMinVersion()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga5a8633d4f99f9129b66287a4c78cbf12)
* [`wolfSSL_pending()`](https://www.wolfssl.com/doxygen/group__IO.html#gab66706eee747081a26b7cc0fd32b2e2b)
* [`wolfSSL_set_timeout()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga67478ea936f476426fa9da48fbdf6aa2)
* [`wolfSSL_CTX_set_timeout()`](https://www.wolfssl.com/doxygen/group__Setup.html#gaaa43e8ada566eb593d4f97e556a7cd31)
* [`wolfSSL_get_session()`](https://www.wolfssl.com/doxygen/group__IO.html#ga516dc5cbe0553fc01cea02bff4a13361)
* [`wolfSSL_set_session()`](https://www.wolfssl.com/doxygen/group__Setup.html#ga898ec1024c7b5dfb6c6997242f3c85d4)
* [`wolfSSL_flush_sessions()`](https://www.wolfssl.com/doxygen/group__IO.html#gafb9b8ef0c2ba29ff514353366edfd50a)
* [`wolfSSL_CTX_set_session_cache_mode()`](https://www.wolfssl.com/doxygen/group__Setup.html#gacb05e0623f30437047701e4b967b2b69)
* [`wolfSSL_get_sessionID()`](https://www.wolfssl.com/doxygen/group__openSSL.html#gaaebff9ff526a2464b1f67bb770bb1749)
* [`wolfSSL_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a1e9a31d166aa1135c8170a769ca420bb)
* [`wolfSSL_CTX_UseSNI()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9c0f3a9d0e24d6c1573bd5c80468bff5)
* [`wc_ecc_init_ex()`](https://www.wolfssl.com/doxygen/group__ECC.html#gaa67c8901e9f2f244747ac2d8543d27cb)
* [`wc_ecc_make_key_ex()`](https://www.wolfssl.com/doxygen/group__ECC.html#gad510edd30f492a95fe70b3f8588362e8)
* [`wc_ecc_sign_hash()`](https://www.wolfssl.com/doxygen/group__ECC.html#ga0de1f56d50dcd1eb684a0e2a45eebf27)
* [`wc_ecc_free()`](https://www.wolfssl.com/doxygen/group__ECC.html#gacc8ca4ad64faa3a702da1cca449015bc)
* [`wolfSSL_SetDevId()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a0781e7d7f789b6c21c76f39c66f02f22)
* [`wolfSSL_CTX_SetDevId()`](https://www.wolfssl.com/doxygen/ssl_8h.html#ab85c92d48d5f0fee51c94742081bf203)
* [`wolfSSL_CTX_SetEccSignCb()`](https://www.wolfssl.com/doxygen/ssl_8h.html#a9fd0345508d38eec20c19362cd95264c)
* [`wolfSSL_CTX_use_certificate_chain_file()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#gae89581a7f4f389787b260af942bd679a)
* [`wolfSSL_CTX_use_certificate_file()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga5b680f7fbb898ae5321eb751969b5c26)
* [`wolfSSL_use_certificate_chain_file()`](https://www.wolfssl.com/doxygen/group__openSSL.html#ga288b96eafef6b56d6cf1b0e3863cac68)
* [`wolfSSL_use_certificate_file()`](https://www.wolfssl.com/doxygen/group__openSSL.html#ga591d02d2721bc1d2fc2d0113804fb33a)
* [`wolfSSL_CTX_use_PrivateKey_file()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga0b3a1e99413ae72d4324fb912ca20b6c)
* [`wolfSSL_use_PrivateKey_file()`](https://www.wolfssl.com/doxygen/group__openSSL.html#ga6a3c37cdb1d7c357e3fb9d857596357b)
* [`wolfSSL_X509_load_certificate_file()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga5ea2c2225d5733a1112320371b83a60c)
* [`wolfSSL_get_peer_certificate()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#gaba449cd82adf628f6820220e7afacd9d)
* [`wolfSSL_X509_NAME_oneline()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga3c6c437135932840ac1549c031e6c91d)
* [`wolfSSL_X509_get_issuer_name()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga0a9ae5277d16909ce71ee414c4c701e7)
* [`wolfSSL_X509_get_subject_name()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#gaf4ca6eb0f6a9ba1c5bb150b773bbea3b)
* [`wolfSSL_X509_get_next_altname()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga8cbf7b5b55ab5f48f4117310c8f3e875)
* [`wolfSSL_X509_notBefore()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga46b5758cddc77d9cd908254286f06cb2)
* [`wolfSSL_X509_notAfter()`](https://www.wolfssl.com/doxygen/group__CertsKeys.html#ga8307df36fb9968c39564503a57ccbc6a)
* [`wc_ecc_key_new()`](https://www.wolfssl.com/doxygen/group__ECC.html#ga19edca21f45eca90c1e8a12d7c0023f8)
* [`wc_ecc_key_free()`](https://www.wolfssl.com/doxygen/group__ECC.html#ga11c9d85dc7576f54da58eca7fea6468d)
