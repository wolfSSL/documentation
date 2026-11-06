# wolfSSL Hardware Optimization Support Reference

## A. Architecture-Level ISA/SIMD Optimizations

None of the assembly optimizations below are enabled by a default `./configure`. `--enable-all-asm` turns on the applicable ones for the build host: `--enable-intelasm` and SP assembly on x86-64, `--enable-armasm` and SP assembly on AArch64, and the PowerPC assembly on PowerPC hosts. It is also on by default with `--enable-all-crypto` (and therefore `--enable-all`) on most hosts.

| Architecture | Algorithms | user_settings.h Macro | configure Option | Notes |
|---|---|---|---|---|
| **Intel x86-64** | AES (all modes) | `WOLFSSL_AESNI` | `--enable-aesni` | AES-NI instructions |
| Intel x86-64 | SHA-256, SHA-512 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | `HAVE_INTEL_AVX1` / `HAVE_INTEL_AVX2` are then defined internally; the AVX1 or AVX2 code is chosen at run time |
| Intel x86-64 | SHA-3 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | sha3_asm.S |
| Intel x86-64 | ChaCha20, Poly1305 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | |
| Intel x86-64 | X25519 (Curve25519), Ed25519 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | fe_x25519_asm.S |
| Intel x86-64 | ML-KEM, ML-DSA, FrodoKEM | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | wc_mlkem_asm.S, wc_mldsa_asm.S, wc_frodokem_asm.S |
| Intel x86-64 | SM3 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` + `--enable-sm3` | sm3_asm.S (SM algorithms need wolfSM, see Appendix K) |
| Intel x86-64 | Falcon | - | `--enable-falcon=asm` + `--enable-experimental` | wc_falcon_fpr_x86_64_asm.S |
| Intel x86-64 | RSA/ECC/DH (SP) | `WOLFSSL_SP_X86_64_ASM` | `--enable-sp --enable-sp-asm` | sp_x86_64_asm.S |
| **Intel x86 (32-bit)** | AES, AES-XTS | `WOLFSSL_AESNI` | `--enable-aesni` | aes_asm.S, aes_xts_x86_asm.S (32-bit AES-GCM uses C GHASH over AES-NI) |
| **ARM AArch64** | AES, SHA-1, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_ARMASM` | `--enable-armasm` | ARMv8 CE (Crypto Extension) |
| ARM AArch64 | X25519 (Curve25519), Ed25519 | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-curve25519.S |
| ARM AArch64 | ML-KEM, ML-DSA, FrodoKEM | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-mlkem-asm.S, armv8-mldsa-asm.S, armv8-frodokem-asm.S |
| ARM AArch64 | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM64_ASM` | `--enable-sp --enable-sp-asm` | sp_arm64.c |
| **ARM 32-bit (ARMv8-32)** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_ARMASM` | `--enable-armasm` | |
| ARM 32-bit | X25519 (Curve25519), Ed25519 | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-32-curve25519.S |
| ARM 32-bit | ML-KEM, ML-DSA, FrodoKEM | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-32-mlkem-asm.S, armv8-32-mldsa-asm.S, armv8-32-frodokem-asm.S |
| ARM 32-bit | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM32_ASM` | `--enable-sp --enable-sp-asm` | sp_arm32.c |
| **ARM Thumb2** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305, X25519 (Curve25519), Ed25519, ML-KEM, FrodoKEM | `WOLFSSL_ARMASM` + `WOLFSSL_ARMASM_THUMB2` | `--enable-armasm` | thumb2-*-asm.S, thumb2-curve25519.S |
| **ARM Thumb** | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM_THUMB_ASM` | `--enable-sp --enable-sp-asm` | sp_armthumb.c |
| **ARM Cortex-M** | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM_CORTEX_M_ASM` | `--enable-sp --enable-sp-asm` | sp_cortexm.c |
| **RISC-V 64-bit** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_RISCV_ASM` | `--enable-riscv-asm` | port/riscv64/riscv-64-*-asm.S |
| RISC-V 64-bit | RSA/ECC/DH (SP) | `WOLFSSL_SP_RISCV64_ASM` | `--enable-sp --enable-sp-asm` | sp_riscv64.c |
| **PowerPC 32-bit** | AES, SHA-256, SHA-512, SHA-3 | `WOLFSSL_PPC32_ASM` | `--enable-ppc32-asm` | port/ppc32/ppc32-*-asm.S |
| **PowerPC 64-bit** | AES, SHA-256, SHA-512, SHA-3 | `WOLFSSL_PPC64_ASM` | `--enable-ppc64-asm` | port/ppc64/ppc64-*-asm.S |
| **Qualcomm Hexagon DSP** | ECC P-256 verify (SP) | `WOLFSSL_DSP` | user_settings.h | sp_dsp32.c, see IDE/HEXAGON |

The SP assembly macros (`WOLFSSL_SP_*_ASM`) need the SP implementation (`--enable-sp`, disabled by default) together with `--enable-sp-asm`; configure then picks the macro for the host CPU. `--enable-sp-asm` is only on by default on x86-64 and AArch64 when the restricted `--enable-sp-math` is selected. The default math library is `sp_int.c` (`WOLFSSL_SP_MATH_ALL`).

## B. SP Math Library (Public Key Cryptography)

| Architecture | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| x86-64 assembly | RSA 2048/3072/4096, ECC P-256/P-384/P-521, DH | `WOLFSSL_SP_X86_64_ASM` | `--enable-sp --enable-sp-asm` |
| ARM AArch64 assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM64_ASM` | `--enable-sp --enable-sp-asm` |
| ARM 32-bit assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM32_ASM` | `--enable-sp --enable-sp-asm` |
| ARM Thumb assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM_THUMB_ASM` | `--enable-sp --enable-sp-asm` |
| Cortex-M assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM_CORTEX_M_ASM` | `--enable-sp --enable-sp-asm` |
| RISC-V 64-bit assembly | RSA, ECC, DH | `WOLFSSL_SP_RISCV64_ASM` | `--enable-sp --enable-sp-asm` |
| Generic C (32-bit / 64-bit) | RSA, ECC, DH | `WOLFSSL_HAVE_SP_RSA`, `WOLFSSL_HAVE_SP_DH`, `WOLFSSL_HAVE_SP_ECC` | `--enable-sp` |

`--enable-sp` builds the generic C implementation (sp_c32.c / sp_c64.c) and defines `WOLFSSL_HAVE_SP_RSA`, `WOLFSSL_HAVE_SP_DH` and `WOLFSSL_HAVE_SP_ECC`. `WOLFSSL_SP_MATH` (`--enable-sp-math`) is the restricted mode that only supports the key sizes and curves implemented by SP.

### sp_int.c Inline Assembly Speedups

`sp_int.c` contains small inline assembly helpers for multi-precision multiply/add operations used when the dedicated per-algorithm SP files (e.g. `sp_x86_64.c`) are absent or for non-RSA/ECC key sizes. These are controlled by the following macros (auto-detected; can also be set in `user_settings.h`):

| Architecture | user_settings.h Macro |
|---|---|
| Intel x86-64 | `WOLFSSL_SP_X86_64` |
| Intel x86 (32-bit) | `WOLFSSL_SP_X86` |
| ARM AArch64 | `WOLFSSL_SP_ARM64` |
| ARM 32-bit | `WOLFSSL_SP_ARM32` |
| ARM Cortex-M | `WOLFSSL_SP_ARM_CORTEX_M` |
| ARM Thumb | `WOLFSSL_SP_ARM_THUMB` |
| PowerPC 64-bit | `WOLFSSL_SP_PPC64` |
| PowerPC 32-bit | `WOLFSSL_SP_PPC` |
| RISC-V 64-bit | `WOLFSSL_SP_RISCV64` |
| RISC-V 32-bit | `WOLFSSL_SP_RISCV32` |
| MIPS 64-bit | `WOLFSSL_SP_MIPS64` |
| MIPS 32-bit | `WOLFSSL_SP_MIPS` |
| s390x | `WOLFSSL_SP_S390X` |

### SP Key Size Configuration

RSA-2048, RSA-3072 and ECC P-256 are included by default when SP is enabled; RSA-4096, P-384 and P-521 have to be added. Pick the one assembly macro that matches the target:

```c
/* Enable SP for RSA, DH and ECC */
#define WOLFSSL_HAVE_SP_RSA
#define WOLFSSL_HAVE_SP_DH
#define WOLFSSL_HAVE_SP_ECC

/* Optional: restricted SP math (only the sizes and curves enabled below) */
/* #define WOLFSSL_SP_MATH */

/* Optional: assembly, choose one */
#define WOLFSSL_SP_ASM
#define WOLFSSL_SP_X86_64_ASM          /* x86-64 */
/* #define WOLFSSL_SP_ARM64_ASM */     /* AArch64 */
/* #define WOLFSSL_SP_ARM_CORTEX_M_ASM */ /* Cortex-M */

/* Additional key sizes and curves */
#define WOLFSSL_SP_4096  /* RSA-4096 */
#define WOLFSSL_SP_384   /* ECC P-384 */
#define WOLFSSL_SP_521   /* ECC P-521 */

/* Remove default sizes that are not needed */
/* #define WOLFSSL_SP_NO_2048 */  /* RSA-2048 */
/* #define WOLFSSL_SP_NO_3072 */  /* RSA-3072 */
/* #define WOLFSSL_SP_NO_256 */   /* ECC P-256 */
```

## C. Microcontroller/SoC Chip-Specific Hardware Accelerators

These ports are selected with defines in `user_settings.h` (for example `WOLFSSL_STM32F4`, which makes `settings.h` define `STM32_CRYPTO` and `STM32_HASH`); they are not detected automatically. Where a configure option exists, it is listed.

| Vendor / Chip | Algorithms | user_settings.h Macro | configure Option | Source |
|---|---|---|---|---|
| **STMicroelectronics** | | | | |
| STM32F2/F4/F7/H7 (CRYP) | AES-ECB/CBC/CTR/GCM | `STM32_CRYPTO` (set by the family define, e.g. `WOLFSSL_STM32F4`) | user_settings.h | port/st/stm32.c |
| STM32L4/L5/WB55 | AES, SHA (partial) | `STM32_CRYPTO` (set by the family define) | user_settings.h | port/st/stm32.c |
| STM32U5 (DHUK) | AES with key wrapping | `WOLFSSL_STM32U5_DHUK` | user_settings.h | port/st/stm32.c |
| STM32MP13 (bare metal) | AES, SHA, RNG, ECC (PKA) | `WOLFSSL_STM32MP13` (sets `STM32_CRYPTO`) | user_settings.h | port/st/stm32.c, see port/st/STM32MP13.md |
| STM32V8 (Cortex-M85) | AES, SHA, PKA, RNG | `WOLFSSL_STM32V8` | user_settings.h | port/st/stm32.c |
| STM32 bare-metal (direct register access, no HAL, ~27 families) | HASH, AES, PKA, RNG, DHUK wrapped keys, CCB protected ECDSA | `WOLFSSL_STM32_BARE` | user_settings.h | port/st/stm32.c |
| STM32 CubeMX / CubeMX2 crypto callback device | AES (plaintext key), AES-GCM, ECDSA | `WOLFSSL_STM32_CUBEMX` / `WOLFSSL_MX2_CONF_INCLUDE` | user_settings.h | port/st/ |
| STSAFE-A100/A120 | ECDSA, ECDH | `WOLFSSL_STSAFEA100` / `WOLFSSL_STSAFEA120` | `--enable-stsafe=a100` / `--enable-stsafe=a120` | port/st/stsafe.c |
| **NXP** | | | | |
| i.MX RT (DCP) | AES-ECB/CBC (128-bit), SHA-1, SHA-256 | `WOLFSSL_IMXRT_DCP` | user_settings.h | port/nxp/dcp_port.c |
| i.MX 6/8 (CAAM) | AES, SHA, RSA, ECC, DH, HMAC | `WOLFSSL_IMX6_CAAM` / `WOLFSSL_SECO_CAAM` | `--enable-caam` | port/caam/* |
| SE050 Secure Element | AES, SHA, RSA, ECC, X25519, ECDH | `WOLFSSL_SE050` + `WOLFSSL_SE050_CRYPT` | `--with-se050=PATH` | port/nxp/se050_port.c |
| EdgeLock Secure Enclave (ELE) | RNG (seed) | `WOLFSSL_NXP_ELE` | `--enable-ele` | port/nxp/ele_cryptocb.c, ele_rng.c |
| EdgeLock ELS/PKC (e.g. RW61x) | AES-ECB/CBC/CTR/GCM, CMAC, SHA-256/384/512, RNG | `WOLFSSL_ELS_PKC` | `--with-els-pkc=PATH` | port/nxp/els_pkc_port.c |
| LPC55S69 HashCrypt | AES-ECB/CBC/CTR/OFB/CFB, SHA-1, SHA-256 | `WOLFSSL_NXP_HASHCRYPT` (set by `WOLFSSL_NXP_LPC55S6X`) | user_settings.h | port/nxp/hashcrypt_port.c |
| LPC55S69 CASPER | RSA public key operations, ECC point multiply | `WOLFSSL_NXP_CASPER` (set by `WOLFSSL_NXP_LPC55S6X`) | user_settings.h | port/nxp/casper_port.c |
| LPC55S69 hardware PUF | PUF key generation and storage | `WOLFSSL_NXP_HWPUF` | user_settings.h | port/nxp/hwpuf_port.c |
| Kinetis mmCAU / LTC | AES, DES, MD5, SHA-1, SHA-256 (mmCAU); AES-GCM, RSA/ECC math (LTC) | `FREESCALE_USE_MMCAU` / `FREESCALE_USE_LTC` | user_settings.h | aes.c, des3.c, port/nxp/ksdk_port.c |
| QorIQ SEC (T1040, T2080) | AES-CBC/CTR/ECB/GCM, ECDSA, ECDH, RSA, FFDHE, RNG | `WOLFSSL_SEC_QORIQ` | `--enable-sec-qoriq` | port/nxp/sec_qoriq*.c |
| **Espressif** | | | | |
| ESP32 / ESP32-S2 / ESP32-S3 | AES, SHA-1/256/384/512, RSA, ECC | `WOLFSSL_ESPIDF` + `WOLFSSL_ESP32` (settings.h then defines `WOLFSSL_ESP32_CRYPT`) | ESP-IDF component | port/Espressif/esp32_*.c |
| ESP32-C3 / C6 / H2 | AES, SHA-256/384/512 (partial) | `WOLFSSL_ESPIDF` + `WOLFSSL_ESP32` (settings.h then defines `WOLFSSL_ESP32_CRYPT`) | ESP-IDF component | port/Espressif/esp32_*.c |
| **Renesas** | | | | |
| RX64M/RX71M/RX72M | SHA-1, SHA-256 | `WOLFSSL_RENESAS_RX64_HASH` | user_settings.h | port/Renesas/renesas_rx64_*.c |
| RX65N / RX72N (TSIP) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_TSIP` | user_settings.h | port/Renesas/renesas_tsip_*.c |
| RA6M3 / RA6M4 (SCE Protected Mode) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_SCEPROTECT` | user_settings.h | port/Renesas/renesas_fspsm_*.c |
| RZ/N2L (RSIP) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_RSIP` | user_settings.h | port/Renesas/renesas_fspsm_*.c |
| RA FSP Secure Manager | AES, SHA, RSA, ECC, HMAC | `WOLFSSL_RENESAS_FSPSM` | user_settings.h | port/Renesas/renesas_fspsm_*.c |
| **Cypress** | | | | |
| PSoC 6 | AES, SHA, ECC, RNG | `WOLFSSL_PSOC6_CRYPTO` | user_settings.h | port/cypress/psoc6_crypto.c |
| **Silicon Labs** | | | | |
| EFR32 / EFM32 (SE) | AES, SHA, ECC, RNG | `WOLFSSL_SILABS_SE_ACCEL` | user_settings.h | port/silabs/silabs_*.c |
| EFR32 Secure Element crypto callback device | AES-ECB/CBC/CTR/GCM/CCM, ChaCha20, CMAC, SHA-1/224/256/384/512, HKDF, PBKDF2, ECDSA, ECDH, RNG | `WOLFSSL_SILABS_CRYPTOCB` | `--enable-silabs-cryptocb` | port/silabs/silabs_cb_*.c |
| **Maxim** | | | | |
| MAX3266X | AES-ECB/CBC, SHA-1/224/256/384/512, TRNG, MAA (RSA/ECC math) | `WOLFSSL_MAX3266X` | user_settings.h | port/maxim/max3266x.c |
| MAXQ10XX | AES, SHA, RSA, ECC, RNG | `WOLFSSL_MAXQ10XX_CRYPTO` | `--with-maxq10xx=PART` | port/maxim/maxq10xx.c |
| **Microchip** | | | | |
| PIC32MZ | AES, SHA, RNG | `WOLFSSL_PIC32MZ_CRYPT` | user_settings.h | port/pic32/ |
| ATECC508A / 608A | AES, SHA, ECC (ECDH/ECDSA) | `WOLFSSL_ATECC508A` / `WOLFSSL_ATECC608A` | `--enable-microchip=508` / `--enable-microchip=608` | port/atmel/atmel.c |
| TA100 | RSA, ECC, AES-GCM | `WOLFSSL_MICROCHIP_TA100` | `--enable-microchip=100` | port/atmel/atmel.c |
| PolarFire SoC Athena F5200 (TeraFire) | AES-256-CTR, SHA-384 | `WOLFSSL_MPFS_ATHENA` | `--with-mpfs-athena=PATH` | port/microchip/mpfs_athena.c |
| **Xilinx / AMD** | | | | |
| Zynq UltraScale+ MPSoC | AES-GCM, SHA3-384, RSA | `WOLFSSL_XILINX_CRYPT` | `--enable-xilinx` | port/xilinx/xil-*.c |
| Versal | AES-GCM, SHA-3, RSA, ECDSA, RNG | `WOLFSSL_XILINX_CRYPT_VERSAL` | user_settings.h (`--enable-xilinx` only defines `WOLFSSL_XILINX_CRYPT`) | port/xilinx/xil-versal-*.c |
| Versal Gen2 (ASU) | TRNG, hashes, HMAC, AES ciphers, CMAC, GMAC, RSA (raw, PSS, OAEP), ECC, ECDH, ECIES, EdDSA, X25519/X448 (X25519/X448 need Vitis 2026.1 or later) | `WOLFSSL_VERSAL_GEN2_ASU` | user_settings.h | port/xilinx/versal_gen2_asu/ |
| **Altera** | | | | |
| Agilex 5 SDM (FPGA Crypto Services) | AES, SHA-256/384/512, HMAC, ECDSA sign, ECDH, RNG | `WOLFSSL_ALTERA_FCS` | `--enable-alterafcs` | port/altera/ |
| **Nuvoton** | | | | |
| M2354 | AES-ECB/CBC/CTR/GCM, SHA-1/224/256/384/512, RSA, ECDSA, ECDH, RNG | `WOLFSSL_NUVOTON_M2354` | user_settings.h | port/nuvoton/ |
| **Texas Instruments** | | | | |
| TM4C (Tiva) | AES (CBC/CTR/GCM/CCM), 3DES, MD5, SHA-1, SHA-224, SHA-256 | `WOLFSSL_TI_CRYPT` / `WOLFSSL_TI_HASH` | user_settings.h | port/ti/ti-aes.c, ti-des3.c, ti-hash.c, ti-ccm.c |
| AM64x (SA2UL, Cortex-R5F) | TRNG, AES-ECB/CBC/GCM, SHA-256/512, HMAC, CMAC | `WOLFSSL_TI_AM64X_R5` | user_settings.h | port/ti/ti-sa2ul_r5_port.c |
| C2000 C28x (AESA crypto callback device) | AES-ECB/CBC/CTR, oscillator jitter entropy | `WOLFSSL_C2000_AES` / `WOLFSSL_C2000_ENTROPY` (with `WOLFSSL_WIDE_BYTE`) | user_settings.h | port/ti/ti-c2000-*.c |
| **RealTek** | | | | |
| AmebaPro2 (RTL8735B HUK crypto callback device) | AES, HMAC-SHA256, ECDSA, TRNG | `WOLFSSL_RTL8735B_HUK` / `WOLFSSL_RTL8735B_AES` | user_settings.h (`--enable-rtl8735b` builds the host compile test) | port/realtek/rtl8735b.c |
| **WISeKey / SealSQ** | | | | |
| VaultIC secure element | P-256 sign, verify, keygen, ECDH | `WOLFSSL_VAULTIC` | `--enable-vaultic` | port/sealsq/vaultic.c |
| **Tropic Square** | | | | |
| TROPIC01 secure element | AES-CBC, AES-GCM, ECDSA, RNG | `WOLFSSL_TROPIC01` | `--with-tropic01=PATH` | port/tropicsquare/tropic01.c |
| **Vorago** | | | | |
| VA416x0 | TRNG (seeds the Hash-DRBG) | `WOLFSSL_VA416X0_TRNG` | user_settings.h | wolfcrypt/src/random.c |
| **Raspberry Pi** | | | | |
| RP2040 / RP2350 (Pico) | RNG | `WOLFSSL_RPIPICO` | user_settings.h | port/rpi_pico/pico.c |
| **Nordic** | | | | |
| nRF51 | RNG | `WOLFSSL_NRF51` | user_settings.h | port/nrf51.c |
| **IoT-Safe (SIM)** | ECC, SHA, RNG | `WOLFSSL_IOTSAFE` | `--enable-iotsafe` | port/iotsafe/ |

## D. External Accelerators and Coprocessors

| Product | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| Intel QuickAssist (QAT) | AES, RSA, DH, ECC, SHA | `HAVE_INTEL_QA` | `--with-intelqa=PATH` |
| Intel QAT (synchronous) | Same as above | `HAVE_INTEL_QA_SYNC` | `--with-intelqa-sync=PATH` |
| Cavium NITROX | AES, RSA, DH, ECC, SHA | `HAVE_CAVIUM` | `--with-cavium=PATH` |
| Cavium NITROX V | Same as above | `HAVE_CAVIUM_V` | `--with-cavium-v=PATH` |
| Cavium Octeon (MIPS) | AES, RSA, ECC, SHA | `HAVE_CAVIUM_OCTEON_SYNC` | `--with-octeon-sync=PATH` |
| NXP CAAM | AES, SHA, RSA, ECC, HMAC, DH | `WOLFSSL_CAAM` | `--enable-caam` |
| NVIDIA CUDA GPU | AES | `HAVE_CUDA` | `--enable-cuda` |
| MagicCrypto library | ARIA cipher; ECDSA, ECDH and SHA-256/384 through a crypto callback | `HAVE_ARIA` | `--enable-aria` |
| PKCS#11 token or HSM | Depends on the token | `HAVE_PKCS11` | `--enable-pkcs11` |

## E. OS Kernel Hardware Offload Interfaces

| Interface | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| Linux `/dev/crypto` | AES, SHA, HMAC, RSA, ECDSA, X25519 | `WOLFSSL_DEVCRYPTO` | `--enable-devcrypto` |
| Linux Kernel Crypto API | AES, SHA, HMAC, RSA, ECC, DH | `WOLFSSL_KCAPI` | `--enable-kcapi` |
| Linux AF_ALG | AES, SHA (kernel backend dependent) | `WOLFSSL_AFALG` | `--enable-afalg` |
| PSA (Platform Security Architecture) | Vendor implementation dependent | `WOLFSSL_HAVE_PSA` | `--enable-psa` |
| AUTOSAR Csm / CryIf | AES-CBC, RNG, AES-CMAC | `WOLFSSL_AUTOSAR` | `--enable-autosar` |

## F. Physically Unclonable Functions

| Type | Function | user_settings.h Macro | configure Option |
|---|---|---|---|
| SRAM PUF | Device key derivation and identity from SRAM start-up values | `WOLFSSL_PUF` + `WOLFSSL_PUF_SRAM` | `--enable-puf` |
