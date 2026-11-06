# RFCs, Specifications, and Reference

## Protocols

* SSL v3.0 - [RFC6101](https://datatracker.ietf.org/doc/html/rfc6101) (Historic; deprecated by [RFC7568](https://datatracker.ietf.org/doc/html/rfc7568))
* TLS v1.0 - [RFC2246](https://www.ietf.org/rfc/rfc2246.txt)
* TLS v1.1 - [RFC4346](https://www.ietf.org/rfc/rfc4346.txt)
* Deprecating TLS 1.0 and TLS 1.1 - [RFC8996](https://datatracker.ietf.org/doc/html/rfc8996)
* TLS v1.2 - [RFC5246](https://www.ietf.org/rfc/rfc5246.txt)
* TLS v1.3 - [RFC8446](https://www.ietf.org/rfc/rfc8446.txt), revised in [RFC9846](https://datatracker.ietf.org/doc/html/rfc9846)
* DTLS v1.0 - [RFC4347](https://datatracker.ietf.org/doc/html/rfc4347)
* DTLS v1.2 - [RFC6347](https://datatracker.ietf.org/doc/html/rfc6347)
* DTLS v1.3 - [RFC9147](https://datatracker.ietf.org/doc/html/rfc9147)
* Using TLS to Secure QUIC - [RFC9001](https://datatracker.ietf.org/doc/html/rfc9001)
* Recommendations for Secure Use of TLS and DTLS (BCP 195) - [RFC9325](https://datatracker.ietf.org/doc/html/rfc9325)
* IPv4 - [Wikipedia](https://en.wikipedia.org/wiki/IPv4)
* IPv6 - [Wikipedia](https://en.wikipedia.org/wiki/IPv6)

## TLS Extensions and Cipher Suites

* TLS Extensions (SNI, Maximum Fragment Length, Trusted CA Keys, Truncated HMAC, Certificate Status Request) - [RFC6066](https://datatracker.ietf.org/doc/html/rfc6066)
* Multiple Certificate Status Request (`status_request_v2`) - [RFC6961](https://datatracker.ietf.org/doc/html/rfc6961)
* Application-Layer Protocol Negotiation (ALPN) - [RFC7301](https://datatracker.ietf.org/doc/html/rfc7301)
* Renegotiation Indication - [RFC5746](https://datatracker.ietf.org/doc/html/rfc5746)
* Session Tickets - [RFC5077](https://datatracker.ietf.org/doc/html/rfc5077)
* Encrypt-then-MAC - [RFC7366](https://datatracker.ietf.org/doc/html/rfc7366)
* Extended Master Secret - [RFC7627](https://datatracker.ietf.org/doc/html/rfc7627)
* ECC Cipher Suites for TLS 1.2 and Earlier - [RFC8422](https://datatracker.ietf.org/doc/html/rfc8422) (obsoletes [RFC4492](https://datatracker.ietf.org/doc/html/rfc4492))
* Finite Field Diffie-Hellman Ephemeral (FFDHE) Groups - [RFC7919](https://datatracker.ietf.org/doc/html/rfc7919)
* Brainpool Curves for TLS 1.3 - [RFC8734](https://datatracker.ietf.org/doc/html/rfc8734)
* Raw Public Keys - [RFC7250](https://datatracker.ietf.org/doc/html/rfc7250)
* AES-GCM Cipher Suites - [RFC5288](https://datatracker.ietf.org/doc/html/rfc5288)
* AES-CCM Cipher Suites - [RFC6655](https://datatracker.ietf.org/doc/html/rfc6655)
* ChaCha20-Poly1305 Cipher Suites - [RFC7905](https://datatracker.ietf.org/doc/html/rfc7905)
* ECDHE-PSK AEAD Cipher Suites - [RFC8442](https://datatracker.ietf.org/doc/html/rfc8442)
* Integrity-Only Cipher Suites for TLS 1.3 - [RFC9150](https://datatracker.ietf.org/doc/html/rfc9150)
* ShangMi (SM) Cipher Suites for TLS 1.3 - [RFC8998](https://datatracker.ietf.org/doc/html/rfc8998)
* Deprecating MD5 and SHA-1 Signature Hashes in TLS 1.2 and DTLS 1.2 - [RFC9155](https://datatracker.ietf.org/doc/html/rfc9155)
* DTLS Connection ID - [RFC9146](https://datatracker.ietf.org/doc/html/rfc9146)
* DTLS-SRTP - [RFC5764](https://datatracker.ietf.org/doc/html/rfc5764)
* Encrypted Client Hello (ECH) - [RFC9849](https://datatracker.ietf.org/doc/html/rfc9849)
* Certificate Authentication with External PSK (`cert_with_extern_psk`) - [RFC9973](https://datatracker.ietf.org/doc/html/rfc9973) (obsoletes [RFC8773](https://datatracker.ietf.org/doc/html/rfc8773))
* ML-KEM for TLS 1.3 - [draft-ietf-tls-mlkem](https://datatracker.ietf.org/doc/draft-ietf-tls-mlkem/)
* Hybrid ECDHE-ML-KEM for TLS 1.3 - [draft-ietf-tls-ecdhe-mlkem](https://datatracker.ietf.org/doc/draft-ietf-tls-ecdhe-mlkem/)

## Stream Ciphers

* Stream Cipher Information - [Wikipedia](https://en.wikipedia.org/wiki/Stream_cipher)
* RC4 / ARC4 - [IETF Draft](https://tools.ietf.org/id/draft-kaukonen-cipher-arcfour-03.txt) [Wikipedia](https://en.wikipedia.org/wiki/Rc4)
* ChaCha20 and Poly1305 - [RFC8439](https://datatracker.ietf.org/doc/html/rfc8439)

## Block Ciphers

* Block Cipher Information - [Wikipedia](https://en.wikipedia.org/wiki/Block_cipher)
* AES - [NIST Publication](https://csrc.nist.gov/publications/fips/fips197/fips-197.pdf) [Wikipedia](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
* Block Cipher Modes (ECB, CBC, CFB, OFB, CTR) - [NIST SP 800-38A](https://csrc.nist.gov/pubs/sp/800/38/a/final)
* AES-CMAC - [NIST SP 800-38B](https://csrc.nist.gov/pubs/sp/800/38/b/upd1/final)
* AES-CCM - [NIST SP 800-38C](https://csrc.nist.gov/pubs/sp/800/38/c/upd1/final)
* AES-GCM - [NIST SP 800-38D](https://csrc.nist.gov/pubs/sp/800/38/d/final)
* AES-SIV - [RFC5297](https://datatracker.ietf.org/doc/html/rfc5297)
* AES-GCM-SIV - [RFC8452](https://datatracker.ietf.org/doc/html/rfc8452)
* AES Key Wrap - [RFC3394](https://datatracker.ietf.org/doc/html/rfc3394), with padding - [RFC5649](https://datatracker.ietf.org/doc/html/rfc5649)
* AES-NI - [Intel Software Network](https://software.intel.com/en-us/articles/intel-advanced-encryption-standard-instructions-aes-ni/)
* DES/3DES - [NIST Publication](https://csrc.nist.gov/publications/fips/fips46-3/fips46-3.pdf) [Wikipedia](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

## Hashing Functions

* SHA-1 and SHA-2 - [NIST FIPS 180-4](https://csrc.nist.gov/pubs/fips/180-4/upd1/final) [Wikipedia](https://en.wikipedia.org/wiki/SHA_hash_functions)
* SHA-3 and SHAKE - [NIST FIPS 202](https://csrc.nist.gov/pubs/fips/202/final)
* MD4 - [RFC1320](https://tools.ietf.org/html/rfc1320)
* MD5 - [RFC1321](https://tools.ietf.org/html/rfc1321)
* RIPEMD-160 - [Specification document](https://homes.esat.kuleuven.be/~bosselae/ripemd160.html)
* HKDF - [RFC5869](https://datatracker.ietf.org/doc/html/rfc5869)

## Public Key Cryptography

* Diffie-Hellman - [Wikipedia](https://en.wikipedia.org/wiki/Diffie-Hellman_key_exchange)
* RSA - [MIT Paper](https://people.csail.mit.edu/rivest/Rsapaper.pdf) [Wikipedia](https://en.wikipedia.org/wiki/RSA)
* RSA (PKCS#1 v2.2) - [RFC8017](https://datatracker.ietf.org/doc/html/rfc8017)
* Digital Signature Standard (DSA, ECDSA, EdDSA) - [NIST FIPS 186-5](https://csrc.nist.gov/pubs/fips/186-5/final). FIPS 186-5 supersedes FIPS 186-3 and 186-4 and no longer approves DSA for signature generation.
* ECDSA - [NIST FIPS 186-5](https://csrc.nist.gov/pubs/fips/186-5/final) [SEC 1](https://www.secg.org/sec1-v2.pdf), deterministic ECDSA - [RFC6979](https://datatracker.ietf.org/doc/html/rfc6979)
* EdDSA (Ed25519, Ed448) - [RFC8032](https://datatracker.ietf.org/doc/html/rfc8032)
* X25519 and X448 - [RFC7748](https://datatracker.ietf.org/doc/html/rfc7748)
* X.509 - [RFC5280](https://datatracker.ietf.org/doc/html/rfc5280), algorithm identifiers - [RFC3279](https://www.ietf.org/rfc/rfc3279.txt)
* ASN.1 - [Specification Document](https://luca.ntop.org/Teaching/Appunti/asn1.html) [Wikipedia](https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One)
* PSK - [RFC4279](https://tools.ietf.org/html/rfc4279)
* HPKE - [RFC9180](https://datatracker.ietf.org/doc/html/rfc9180)

## Post-Quantum Cryptography

* ML-KEM - [NIST FIPS 203](https://csrc.nist.gov/pubs/fips/203/final)
* ML-DSA - [NIST FIPS 204](https://csrc.nist.gov/pubs/fips/204/final)
* SLH-DSA - [NIST FIPS 205](https://csrc.nist.gov/pubs/fips/205/final)
* LMS/HSS - [RFC8554](https://datatracker.ietf.org/doc/html/rfc8554)
* XMSS - [RFC8391](https://datatracker.ietf.org/doc/html/rfc8391)
* Stateful Hash-Based Signatures (LMS, XMSS) - [NIST SP 800-208](https://csrc.nist.gov/pubs/sp/800/208/final)

## Other

* PKCS#5, PBKDF1, PBKDF2 - [RFC8018](https://datatracker.ietf.org/doc/html/rfc8018)
* PKCS#7 / CMS - [RFC5652](https://datatracker.ietf.org/doc/html/rfc5652)
* PKCS#8 - [RFC5958](https://datatracker.ietf.org/doc/html/rfc5958)
* PKCS#12 - [RFC7292](https://datatracker.ietf.org/doc/html/rfc7292) [Wikipedia](https://en.wikipedia.org/wiki/PKCS_12)
* OCSP - [RFC6960](https://datatracker.ietf.org/doc/html/rfc6960)
* Time-Stamp Protocol (TSP) - [RFC3161](https://datatracker.ietf.org/doc/html/rfc3161)
* Argon2 - [RFC9106](https://datatracker.ietf.org/doc/html/rfc9106)
* Hash DRBG - [NIST SP 800-90A Rev. 1](https://csrc.nist.gov/pubs/sp/800/90/a/r1/final)
