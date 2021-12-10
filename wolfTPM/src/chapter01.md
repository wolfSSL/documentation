# Intro

wolfTPM is a portable, open-source TPM 2.0 stack with backward API compatibility designed for embedded use. It is highly portable, due to having been written in native C, having a single IO callback for SPI hardware interface, no external dependencies, and its compacted code with low resource usage. wolfTPM offers API wrappers to help with complex TPM operations like attestation and examples to help with complex cryptographic processes like the generation of Certificate Signing Request (CSR) using a TPM.

## Protocol overview

Trusted Platform Module (TPM, also known as ISO/IEC 11889) is an international standard for a secure crypto processor, a dedicated micro controller designed to secure hardware through integrated cryptographic keys. Computer programs can use a TPM to authenticate hardware devices, since each TPM chip has a unique and secret RSA key burned in as it is produced.

According to Wikipedia, a TPM provides the following[\[1\]](#cite-one) :

- A random number generator

- Facilities for the secure generation of cryptographic keys for limited uses.

- Remote attestation: Creates a nearly unforgeable hash key summary of the hardware and software configuration. The software in charge of hashing the configuration data determines the extent of the summary. This allows a third party to verify that the software has not been changed.

- Binding: Encrypts data using the TPM bind key, a unique RSA key descended from a storage key.

- Sealing: Similar to binding, but in addition, specifies the TPM state for the data to be decrypted (unsealed).

In addition, TPM can also be used for various applications such as platform integrity, disk encryption, password protection, and software license protection.

## Hierarchies

Platform: **TPM_RH_PLATFORM**

Owner: **PM_RH_OWNER**

Endorsement: **TPM_RH_ENDORSEMENT**

Each hierarchy has their own manufacture generated seed. The arguments used on TPM2_Create or TPM2_CreatePrimary create a template, which is fed
into a KDF to produce the same key based hierarchy used. The key generated is the same each time; even after reboot. The generation of a new RSA 2048 bit key takes about 15 seconds.

Typically these are created and then stored in NV using TPM2_EvictControl. Each TPM generates their own keys uniquely based on the seed. There is also an Ephemeral hierarchy (TPM_RH_NULL), which can be used to create ephemeral keys.

## Platform Configuration Registers (PCRs)

Platform Configuration Registers (PCRs) are one of the essential features of a TPM. Their prime use case is to provide a method to cryptographically record (measure) software state: both the software running on a platform and configuration data used by that software.[\[2\]](#cite-two)

wolfTPM contains hash digests for SHA-1 and SHA-256 with an index 0-23. These hash digests can be extended to prove the integrity of a boot sequence (secure boot).

## Terminology

This project uses the terms append vs. marshall and parse vs. unmarshall.

## Hardware

Tested with:

* Infineon OPTIGA (TM) Trusted Platform Module 2.0 SLB 9670.
    - LetsTrust: [http://letstrust.de] (<https://buyzero.de/collections/andere-platinen/products/letstrust-hardware-tpm-trusted-platform-module).> Compact Raspberry Pi TPM 2.0 board based on Infineon SLB 9670.

* ST ST33TP* TPM 2.0 module (SPI and I2C)

* Microchip ATTPM20 module

* Nuvoton NPCT65X or NPCT75x TPM2.0 module

### Device Identification

Infineon SLB9670:
TIS: TPM2: Caps 0x30000697, Did 0x001b, Vid 0x15d1, Rid 0x10
Mfg IFX (1), Vendor SLB9670, Fw 7.85 (4555), FIPS 140-2 1, CC-EAL4 1

ST ST33TP SPI
TPM2: Caps 0x1a7e2882, Did 0x0000, Vid 0x104a, Rid 0x4e
Mfg STM  (2), Vendor , Fw 74.8 (1151341959), FIPS 140-2 1, CC-EAL4 0

ST ST33TP I2C
TPM2: Caps 0x1a7e2882, Did 0x0000, Vid 0x104a, Rid 0x4e
Mfg STM  (2), Vendor , Fw 74.9 (1151341959), FIPS 140-2 1, CC-EAL4 0

Microchip ATTPM20
TPM2: Caps 0x30000695, Did 0x3205, Vid 0x1114, Rid 0x 1
Mfg MCHP (3), Vendor , Fw 512.20481 (0), FIPS 140-2 0, CC-EAL4 0

Nations Technologies Inc. TPM 2.0 module
Mfg NTZ (0), Vendor Z32H330, Fw 7.51 (419631892), FIPS 140-2 0, CC-EAL4 0

Nuvoton NPCT650 TPM2.0
Mfg NTC (0), Vendor rlsNPCT , Fw 1.3 (65536), FIPS 140-2 0, CC-EAL4 0

Nuvoton NPCT750 TPM2.0
TPM2: Caps 0x30000697, Did 0x00fc, Vid 0x1050, Rid 0x 1
Mfg NTC (0), Vendor NPCT75x"!!4rls, Fw 7.2 (131072), FIPS 140-2 1, CC-EAL4 0


