#  Introduction

This manual is written as a technical guide to the wolfSSH embedded library. It will explain how to build and get started with wolfSSH, provide an overview of build options, features, support, and much more.

wolfSSH is an implementation of the SSH (Secure Shell) server written in C and uses the wolfCrypt library which is also available from wolfSSL. Furthermore, wolfSSH has been built from the ground up in order for it to have multi-platform use. This implementation is based off of the SSH v2 specification.

##  Protocol Overview

SSH is a layered set of protocols that provide multiplexed streams of data between two peers. Typically, it is used for securing a connection to a shell on the server. However, it is also commonly used to securely copy files between two machines or tunnel the X display protocol.

##  Why Choose wolfSSH?

The wolfSSH library is a lightweight SSHv2 server library written in ANSI C and targeted for embedded, RTOS, and resource-constrained environments - primarily because of its small size, speed, and feature set. It is commonly used in standard operating environments as well because of its royalty-free pricing and excellent cross platform support. wolfSSH supports the industry standard SSH v2. wolfSSH is powered by the wolfCrypt library. A version of the wolfCrypt cryptography library has been FIPS 140-3 validated (Certificate #4718) and FIPS 140-2 validated (Certificate #3389). For additional information, visit the wolfCrypt FIPS FAQ or contact fips@wolfssl.com.

### Features


- SSH v2.0 (server and client)

- Minimum footprint size of 33kB

- Runtime memory usage between 1.4 and 2kB, not including a configurable receive buffer

- Multiple hashing functions: SHA-1, SHA-2 (SHA-256, SHA-384, SHA-512)

- Block and authenticated ciphers: AES-CBC, AES-CTR, AES-GCM

- Key exchange options: DHE and ECDHE (with curves NISTP256, NISTP384, NISTP521)

- Public key authentication options: RSA and ECDSA (with curves NISTP256, NISTP384, NISTP521)

- User authentication support (password and public key authentication)

- Simple API

- PEM and DER X.509 certificate support

- Hardware Cryptography Support: Intel AES-NI support, Intel AVX1/2, RDRAND, RDSEED, Cavium NITROX support, STM32F2/F4 hardware crypto support, Freescale CAU / mmCAU / SEC, Microchip PIC32MZ

- Post quantum hybrid key exchange with Hybrid ECDH-P256 Kyber-Level1

- Support for SFTP, SCP, SSH-AGENT, local and remote port forwarding
