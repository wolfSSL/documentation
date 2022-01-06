# Introduction

[wolfBoot](https://www.wolfssl.com/products/wolfboot/) is a portable, OS-agnostic, secure bootloader solution for 32-bit microcontrollers, relying on wolfCrypt for firmware authentication, providing firmware update mechanisms.

Due to the minimalist design of the bootloader and the tiny HAL API, wolfBoot is completely independent from any OS or bare-metal application, and can be easily ported and integrated in existing embedded software projects to provide a secure firmware update mechanism.


**Features**

- Multi-slot partitioning of the flash device
- Integrity verification of the firmware image(s)
- Authenticity verification of the firmware image(s) using wolfCrypt's Digital Signature Algorithms (DSA)
- Minimalist hardware abstraction layer (HAL) interface to facilitate portability across different vendors/MCUs
- Copy/swap images from secondary slots into the primary slots to consent firmware update operations
- In-place chain-loading of the firmware image in the primary slot
- Support of Trusted Platform Module(TPM)
- Measured boot support, storing of the firmware image hash into a TPM Platform Configuration Register(PCR)

**Components**

The [wolfBoot Github repository](https://github.com/wolfSSL/wolfBoot) contains the following components:

- the wolfBoot bootloader
- key generator and image signing tools (requires python 3.x and wolfcrypt-py https://github.com/wolfSSL/wolfcrypt-py)
- Baremetal test applications
