# Features Beyond Mbed TLS

| Feature | Mbed TLS 3.6 / 4.x | wolfSSL |
| ---------------------------------- | ------------------------------------ | ------------------------------ |
| TLS 1.3 | Yes | Yes |
| DTLS 1.3 (RFC 9147) | No, DTLS 1.2 only | Yes |
| DTLS Connection ID (RFC 9146) | Yes | Yes, DTLS 1.2 and 1.3 |
| ML-KEM hybrid key exchange | No | Yes, on by default |
| ML-DSA, SLH-DSA certificates in TLS 1.3 | No | Yes |
| LMS, XMSS | LMS verify, experimental LMS signing, no XMSS | Sign and verify |
| Ed25519, Ed448 | No | Yes |
| QUIC | No | Yes |
| Encrypted Client Hello | No | Yes |
| OCSP stapling | No | Yes, v1 and v2 |
| TLS 1.3 post-handshake auth | No | Yes |
| Raw public keys (RFC 7250) | No | Yes |
| FIPS 140-3 validated crypto | No | Yes, through a separately validated wolfCrypt module |
| Hardware offload | `_ALT` or PSA drivers | Crypto callbacks plus more than 30 in-tree ports |

## DTLS 1.3

Mbed TLS supports DTLS 1.2 only. wolfSSL adds DTLS 1.3 (RFC 9147), with
Connection ID in both versions, bringing the TLS 1.3 handshake to datagram
transports such as CoAP, LwM2M and cellular IoT. Moving is a method change:
in a build with `--enable-dtls13`, `wolfDTLS_client_method()` negotiates DTLS
1.3 where the server supports it and falls back to DTLS 1.2.

## Post-Quantum Cryptography

The Mbed TLS roadmap lists ML-KEM as future work, and its only ML-DSA code is
an experimental ML-DSA-87 driver on the development branch. wolfCrypt ships
the complete NIST set, with its own implementations and assembly
optimizations for Intel and ARM:

- ML-KEM (FIPS 203), used in TLS 1.3 as pure ML-KEM or as hybrid groups such
  as X25519MLKEM768, SecP256r1MLKEM768 and SecP384r1MLKEM1024.
- ML-DSA (FIPS 204) for certificates, TLS 1.3 authentication, CMS and
  certificate generation, and SLH-DSA (FIPS 205) for certificates and TLS 1.3
  authentication.
- LMS/HSS and XMSS/XMSS^MT stateful hash-based signatures for firmware
  signing.
- Falcon for applications that want compact lattice signatures
  (experimental: `--enable-falcon --enable-experimental`).

ML-KEM and the hybrid groups are on by default; ML-DSA and SLH-DSA need
`--enable-mldsa` and `--enable-slhdsa`. The sample client in
[Porting a TLS Client](chapter03.md), with no PQC-specific code, negotiates
SecP256r1MLKEM768 against a default wolfSSL server. With
`--enable-curve25519` the preferred group becomes X25519MLKEM768, the hybrid
that browsers deploy today.

## FIPS 140-3

wolfCrypt holds FIPS 140-3 validations, and Mbed TLS has none. Contact wolfSSL
to find out which certificate fits your platform.

## Keeping the PSA Crypto API

[wolfPSA](https://github.com/wolfSSL/wolfPSA) implements the PSA Crypto API on
wolfCrypt, so most code already ported to PSA for Mbed TLS 4.x runs on
wolfCrypt without API changes. The PAKE functions, and with them EC J-PAKE, are
not implemented.

## The wolfSSL Product Family

wolfCrypt is also the crypto core for the rest of the wolfSSL products:
[wolfCert](https://github.com/wolfSSL/wolfCert) for EST and SCEP enrollment,
[wolfMQTT](https://github.com/wolfSSL/wolfMQTT),
[wolfSSH](https://github.com/wolfSSL/wolfssh),
[wolfTPM](https://github.com/wolfSSL/wolfTPM),
[wolfBoot](https://github.com/wolfSSL/wolfBoot) for secure boot,
[wolfHSM](https://github.com/wolfSSL/wolfHSM),
[wolfPKCS11](https://github.com/wolfSSL/wolfPKCS11),
[wolfPSA](https://github.com/wolfSSL/wolfPSA),
[wolfProvider](https://github.com/wolfSSL/wolfProvider) for OpenSSL 3,
[wolfIP](https://github.com/wolfSSL/wolfip),
[wolfSentry](https://github.com/wolfSSL/wolfsentry) and
[wolfCOSE](https://github.com/wolfSSL/wolfCOSE). Language bindings exist for
Python, Rust, C#, Java (JSSE and JCE) and Ada, and the
[wolfSSL OSP repository](https://github.com/wolfSSL/osp) carries ports of
projects such as curl, nginx and OpenSSH.
