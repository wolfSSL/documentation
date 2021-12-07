# Intro

wolfTPM is a portable TPM 2.0 project, designed for embedded use. It is highly portable, due to
having been written in native C, having a single IO callback for SPI hardware interface, no
external dependencies, and its compacted code with low resource usage.

## Protocol overview

Trusted Platform Module (TPM, also known as ISO/IEC 11889) is an international standard for a secure cryptoprocessor, a dedicated microcontroller designed to secure hardware through integrated cryptographic keys. Computer programs can use a TPM to authenticate hardware devices, since each TPM chip has a unique and secret RSA key burned in as it is produced.

According to Wikipedia, a TPM provides the following<sup>1</sup> :
* A random number generator
* Facilities for the secure generation of cryptographic keys for limited uses.
* Remote attestation: Creates a nearly unforgeable hash key summary of the hardware and software configuration. The software in charge of hashing the configuration data determines the extent of the summary. This allows a third party to verify that the software has not been
changed.
* Binding: Encrypts data using the TPM bind key, a unique RSA key descended from a storage key.
* Sealing: Similar to binding, but in addition, specifies the TPM state for the data to be decrypted (unsealed).

In addition, TPM can also be used for various applications such as platform integrity, disk encryption, password protection, and software license protection.

## Hierarchies

Platform: **TPM_RH_PLATFORM**
Owner: **PM_RH_OWNER**
Endorsement: **TPM_RH_ENDORSEMENT**

Each hierarchy has their own manufacture generated seed. The arguments used on TPM2_Create or TPM2_CreatePrimary create a template, which is fed
into a KDF to produce the same key based hierarchy used. The key generated is the same each time; even after reboot. The generation of a new RSA 2048 bit key takes about 15 seconds.

Typically these are created and then stored in NV using TPM2_EvictControl. Each TPM generates their own keys uniquely based on the seed. There is also an Ephemeral hierarchy (TPM_RH_NULL), which can be used to create ephemeral keys.

## Platform Configuration Registers (PCRs)

Platform Configuration Registers (PCRs) are one of the essential features of a TPM. Their prime use case is to provide a method to cryptographically record (measure) software state: both the software running on a platform and configuration data used by that software.<sup>2</sup>

wolfTPM contains hash digests for SHA-1 and SHA-256 with an index 0-23. These hash digests can be extended to prove the integrity of a boot sequence (secure boot).
