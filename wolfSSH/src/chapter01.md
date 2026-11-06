#  Introduction

This manual is written as a technical guide to the wolfSSH embedded library. It will explain how to build and get started with wolfSSH, provide an overview of build options, features, support, and much more.

wolfSSH is an implementation of the SSH (Secure Shell) server and client written in C and uses the wolfCrypt library which is also available from wolfSSL. Furthermore, wolfSSH has been built from the ground up in order for it to have multi-platform use. This implementation is based off of the SSH v2 specification.

##  Protocol Overview

SSH is a layered set of protocols that provide multiplexed streams of data between two peers. Typically, it is used for securing a connection to a shell on the server. However, it is also commonly used to securely copy files between two machines or tunnel the X display protocol.

##  Why Choose wolfSSH?

The wolfSSH library is a lightweight SSHv2 server and client library written in ANSI C and targeted for embedded, RTOS, and resource-constrained environments - primarily because of its small size, speed, and feature set. It is commonly used in standard operating environments as well because of its royalty-free pricing and excellent cross platform support. wolfSSH supports the industry standard SSH v2. wolfSSH is powered by the wolfCrypt library. A version of the wolfCrypt cryptography library has been FIPS 140-3 validated (Certificate #4718) and FIPS 140-2 validated (Certificate #3389). For additional information, visit the wolfCrypt FIPS FAQ or contact fips@wolfssl.com.

### Features


- SSH v2.0 (server and client)

- Minimum footprint size of 33kB

- Runtime memory usage between 1.4 and 2kB, not including a configurable receive buffer

- Multiple hashing functions: SHA-1, SHA-2 (SHA-256, SHA-384, SHA-512)

- Block and authenticated ciphers: AES-CBC, AES-CTR, AES-GCM (128-, 192- and 256-bit keys)

- Message authentication: HMAC-SHA1, HMAC-SHA1-96, HMAC-SHA2-256, HMAC-SHA2-512

- Cipher and MAC negotiated independently for each direction of the connection

- Key exchange options: DH (groups 1, 14 and 16, and group exchange), ECDH (with curves NISTP256, NISTP384, NISTP521), and Curve25519

- Post-quantum hybrid key exchange: ML-KEM-768 with Curve25519 or NIST P-256, and ML-KEM-1024 with NIST P-384

- Public key authentication options: RSA (ssh-rsa, rsa-sha2-256, rsa-sha2-512), ECDSA (with curves NISTP256, NISTP384, NISTP521), Ed25519, and the post-quantum ML-DSA-44, ML-DSA-65 and ML-DSA-87, alone or as composites with ECDSA, Ed25519 or Ed448, for both host keys and user authentication

- Builds with neither RSA nor ECDSA, such as an Ed25519-only build

- SHA-1 and AES-CBC algorithms compiled in but not offered by default

- Strict key exchange, the mitigation for the Terrapin attack (CVE-2023-48795), on by default

- Rekeying triggered by the amount of data or by the number of packets sent

- User authentication support (password, keyboard-interactive and public key authentication)

- Simple API

- PEM and DER X.509 certificate support for host keys and user authentication (RFC 6187), including ML-DSA certificates

- OpenSSH certificate user authentication in wolfSSHd

- TPM 2.0 resident host keys and user keys, and host keys from the Windows certificate store

- Hardware Cryptography Support: Intel AES-NI support, Intel AVX1/2, RDRAND, RDSEED, Cavium NITROX support, STM32F2/F4 hardware crypto support, Freescale CAU / mmCAU / SEC, Microchip PIC32MZ

- Support for SFTP, SCP, SSH-AGENT, local and remote port forwarding (client and server)

- wolfSSHd, an SSH server daemon, and wolfssh, an SSH client application
