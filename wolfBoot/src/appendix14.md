# wolfBoot Configuration Options

This section shows parameters by running `make config`.

- `ARCH`: Architecture of the target to be used.
    - Default: ARM
    - Possible: x86_64/AARCH64/ARM/RNESAS_RX/RISCV/PPC/ARM_BE

- `HASH`: Selection of hash algorithm to be used.
    - Default: SHA256
    - Possible: SHA3/SHA256/SHA384

- `MCUXSDK`: Enable when using NXP's MCUXpresso SDK.
    - Default: 1

- `MCUXPRESSO`: Setting for MCUXpresso IDE environment.
    - Default: /mnt/c/Users/(User)/(Project)/wolfboot-2.4.0/mcux-sdk

- `MCUXPRESSO_CPU`: CPU-specific settings for MCUXpresso.
    - Default: MK64FN1M0VLL12

- `MCUXPRESSO_DRIVERS`: Enable driver support for MCUXpresso.
    - Default: /mnt/c/Users/(User)/(Project)/wolfboot-2.4.0/mcux-sdk/devices/MK64F12

- `MCUXPRESSO_CMSIS`: Enable CMSIS (Cortex Microcontroller Software Interface Standard) library.
    - Default: /mnt/c/Users/(User)/(Project)/wolfboot-2.4.0/CMSIS_5/CMSIS

- `FREEDOM_E_SDK`: Enable when using SiFive Freedom-E SDK (for RISC-V).
    - Default: /home/(User)/src/freedom-e-sdk

- `STM32CUBE`: Enable STM32Cube HAL (for STM32).
    - Default: /home/(User)/STM32Cube/Repository/STM32Cube_FW_WB_V1.3.0

- `CYPRESS_PDL`: Enable Cypress Peripheral Driver Library (PDL).
    - Default: /home/(User)/src/psoc6pdl

- `CYPRESS_CORE_LIB`: Enable Cypress core library.
    - Default: /home/(User)/src/cypress-core-lib

- `CYPRESS_TARGET_LIB`: Enable Cypress target-specific library.
    - Default: /home/(User)/src/TARGET_CY8CKIT-062S2-43012

- `CORTEX_M7`: Enable when targeting ARM Cortex-M7.
    - Default: 0

- `CORTEX_M33`: Enable when targeting ARM Cortex-M33.
    - Default: 0

- `NO_ASM`: Disable assembly optimizations and implement in C language only.
    - Default: 0

- `NO_XIP`: Disable XIP (Execute in Place) (do not execute code directly from flash memory).
    - Default: 0

- `WOLFBOOT_VERSION`: Option to specify the version of wolfBoot.
    - Default is set in include/wolfboot/version.h

- `V`: Enable Verbose build.
    - Default: 0

- `NO_MPU`: Disable Memory Protection Unit (MPU).
    - Default: 0

- `SPMATH`: Enable SP Math library (single-precision math library).
    - Default: 1

- `SPMATHALL`: Enable all SP Math functions.
    - Default: 0

- `IMAGE_HEADER_SIZE`: Specify the firmware image header size.
    - Default: 256

- `PKA`: Enable public key cryptography processing (Public Key Accelerator).
    - Default: 1

- `TZEN`: Enable TrustZone security features.
    - Default: 0

- `PSOC6_CRYPTO`: Use Cypress PSoC 6 series hardware cryptographic engine.
    - Default: 1

- `WOLFBOOT_TPM_VERIFY`: Enable firmware verification using TPM (Trusted Platform Module).
    - Default: 0

- `WOLFBOOT_TPM_SEAL`: Enable function to seal data using TPM.
    - Default: 0

- `WOLFBOOT_TPM_KEYSTORE`: Enable key storage using TPM.
    - Default: 0

- `WOLFCRYPT_TZ`: Enable the use of wolfCrypt in TrustZone.
    - Default: 0

- `WOLFCRYPT_TZ_PKCS11`: Enable PKCS#11 interface in TrustZone.
    - Default: 0

- `WOLFBOOT_LOAD_ADDRESS`: Specify the load address for wolfBoot.
    - Default: 0x200000

- `WOLFBOOT_LOAD_DTS_ADDRESS`: Specify the load address for Device Tree Storage (DTS).
    - Default: 0x400000

- `WOLFBOOT_DTS_BOOT_ADDRESS`: Specify the device tree address during boot.
    - Default: 0x30000

- `WOLFBOOT_DTS_UPDATE_ADDRESS`: Specify the device tree address for updates.
    - Default: 0x50000

- `DELTA_BLOCK_SIZE`: Specify the block size for delta updates.
    - Default: 256

- `WOLFBOOT_HUGE_STACK`: Option to increase stack size.
    - Default: 0

- `FORCE_32BIT`: Option to force build as a 32-bit system.
    - Default: 0

- `ENCRYPT_WITH_CHACHA`: Enable firmware encryption using the ChaCha algorithm.
    - Default: 0

- `ARMORED`: Enable additional mitigations against fault-injection attacks, e.g. voltage and clock glitches, or EMFI.
    - Default: 0

- `LMS_LEVELS`: Specify the levels for LMS (Leighton-Micali Signature) hash-based signatures.
    - Default: 0

- `LMS_HEIGHT`: Specify the hash tree height for LMS signatures.
    - Default: 0

- `LMS_WINTERNITZ`: Set the Winternitz coefficient (LMS signature parameter).
    - Default: 0

- `WOLFBOOT_UNIVERSAL_KEYSTORE`: Enable storing public keys of different types in the same keystore.
    - Default: 0

- `XMSS_PARAMS`: Specify parameters for XMSS (eXtended Merkle Signature Scheme).
    - Default: XMSS-SHA2_10_256
    - Possible: XMSS-SHA2_10_256

- `ELF`: Enable support for ELF format.
    - Default: 0

- `BIG_ENDIAN`: Support big-endian architecture.
    - Default: 0

- `NXP_CUSTOM_DCD`: Enable custom DCD (Device Configuration Data) settings for NXP platforms.
    - Default: 0

- `NXP_CUSTOM_DCD_OBJS`: Enable custom DCD objects for NXP.

- `FLASH_OTP_KEYSTORE`: Enable flash key storage using OTP (One-Time Programmable) memory.
    - Default: 0

- `KEYVAULT_OBJ_SIZE`: Specify the size of objects stored in KeyVault.

- `KEYVAULT_MAX_ITEMS`: Specify the maximum number of items that can be stored in KeyVault.

- `NO_ARM_ASM`: Disable ARM assembly code and implement in C language only.
    - Default: 0

- `SIGN_SECONDARY`: Enable a second signature for the images. Used to implement hybrid mode (e.g. ECC + ML_DSA). Set to the secondary algorithm selected for hybrid (classic + PQC) authentication.

- `WOLFHSM_CLIENT`: Enable wolfHSM client (HSM).
    - Default: 0

- `WOLFHSM_CLIENT_LOCAL_KEYS`: Option for wolfHSM client to use local keys.
    - Default: 0
