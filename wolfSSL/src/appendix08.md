# wolfSSL Hardware Optimization Support Reference

## A. Architecture-Level ISA/SIMD Optimizations

| Architecture | Algorithms | user_settings.h Macro | configure Option | Notes |
|---|---|---|---|---|
| **Intel x86-64** | AES (all modes) | `WOLFSSL_AESNI` | `--enable-aesni` | AES-NI instructions |
| Intel x86-64 | SHA-256, SHA-512 | `USE_INTEL_SPEEDUP` + `HAVE_INTEL_AVX1` | Auto-detected | AVX1 assembly |
| Intel x86-64 | SHA-512, SHA-3 | `USE_INTEL_SPEEDUP` + `HAVE_INTEL_AVX2` | Auto-detected | AVX2 assembly |
| Intel x86-64 | ChaCha20, Poly1305 | `USE_INTEL_SPEEDUP` | Auto-detected | |
| Intel x86-64 | X25519 (Curve25519), Ed25519 | `USE_INTEL_SPEEDUP` | Auto-detected | fe_x25519_asm.S |
| Intel x86-64 | RSA/ECC/DH (SP) | `WOLFSSL_SP_X86_64_ASM` | Auto-detected | sp_x86_64_asm.S |
| **ARM AArch64** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_ARMASM` | `--enable-armasm` | ARMv8 CE (Crypto Extension) |
| ARM AArch64 | X25519 (Curve25519), Ed25519 | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-curve25519.S |
| ARM AArch64 | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM64_ASM` | Auto-detected | sp_arm64.c |
| **ARM 32-bit (ARMv8-32)** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_ARMASM` | `--enable-armasm` | |
| ARM 32-bit | X25519 (Curve25519), Ed25519 | `WOLFSSL_ARMASM` | `--enable-armasm` | armv8-32-curve25519.S |
| ARM 32-bit | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM32_ASM` | Auto-detected | sp_arm32.c |
| **ARM Thumb2** | X25519 (Curve25519), Ed25519 | `WOLFSSL_ARMASM` + `WOLFSSL_ARMASM_THUMB2` | `--enable-armasm` | thumb2-curve25519.S |
| **ARM Thumb** | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM_THUMB_ASM` | Auto-detected | sp_armthumb.c |
| **ARM Cortex-M** | RSA/ECC/DH (SP) | `WOLFSSL_SP_ARM_CORTEX_M_ASM` | Auto-detected | sp_cortexm.c |
| **RISC-V 64-bit** | AES, SHA-256/512, SHA-3, ChaCha20, Poly1305 | `WOLFSSL_RISCV_ASM` | `--enable-riscv` | riscv/riscv-64-*.c |
| **PowerPC 32-bit** | SHA-256 | `WOLFSSL_PPC32_ASM` | Auto-detected | ppc32/ppc32-sha256-asm.S |

## B. SP Math Library (Public Key Cryptography)

| Architecture | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| x86-64 assembly | RSA 2048/3072/4096, ECC P-256/P-384/P-521, DH | `WOLFSSL_SP_X86_64_ASM` | Auto-detected |
| ARM AArch64 assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM64_ASM` | Auto-detected |
| ARM 32-bit assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM32_ASM` | Auto-detected |
| ARM Thumb assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM_THUMB_ASM` | Auto-detected |
| Cortex-M assembly | RSA, ECC, DH | `WOLFSSL_SP_ARM_CORTEX_M_ASM` | Auto-detected |
| Generic C (32-bit / 64-bit) | RSA, ECC, DH | `WOLFSSL_SP_MATH` | `--enable-sp` |

### sp_int.c Inline Assembly Speedups

`sp_int.c` contains small inline assembly helpers for multi-precision multiply/add operations used when the dedicated per-algorithm SP files (e.g. `sp_x86_64.c`) are absent or for non-RSA/ECC key sizes. These are controlled by the following macros (auto-detected; can also be set in `user_settings.h`):

| Architecture | user_settings.h Macro |
|---|---|
| Intel x86-64 | `WOLFSSL_SP_X86_64` |
| Intel x86 (32-bit) | `WOLFSSL_SP_X86` |
| ARM AArch64 | `WOLFSSL_SP_ARM64` |
| ARM 32-bit | `WOLFSSL_SP_ARM32` |
| ARM Thumb | `WOLFSSL_SP_ARM_THUMB` |
| RISC-V 64-bit | `WOLFSSL_SP_RISCV64` |
| RISC-V 32-bit | `WOLFSSL_SP_RISCV32` |
| MIPS 64-bit | `WOLFSSL_SP_MIPS64` |
| MIPS 32-bit | `WOLFSSL_SP_MIPS` |
| s390x | `WOLFSSL_SP_S390X` |

### SP Key Size Configuration

```c
#define WOLFSSL_SP_MATH
#define WOLFSSL_SP_X86_64_ASM        /* x86-64 */
#define WOLFSSL_SP_ARM64_ASM         /* AArch64 */
#define WOLFSSL_SP_ARM_CORTEX_M_ASM  /* Cortex-M */

#define WOLFSSL_SP_2048  /* RSA-2048 */
#define WOLFSSL_SP_3072  /* RSA-3072 */
#define WOLFSSL_SP_4096  /* RSA-4096 */
#define WOLFSSL_SP_256   /* ECC P-256 */
#define WOLFSSL_SP_384   /* ECC P-384 */
#define WOLFSSL_SP_521   /* ECC P-521 */
```

## C. Microcontroller/SoC Chip-Specific Hardware Accelerators

| Vendor / Chip | Algorithms | user_settings.h Macro | configure Option | Source |
|---|---|---|---|---|
| **STMicroelectronics** | | | | |
| STM32F2/F4/F7/H7 (CRYP) | AES-ECB/CBC/CTR/GCM | `STM32_CRYPTO` | HAL auto-detected | port/st/stm32.c |
| STM32L4/L5/WB55 | AES, SHA (partial) | `STM32_CRYPTO` | HAL auto-detected | port/st/stm32.c |
| STM32U5 (DHUK) | AES with key wrapping | `WOLFSSL_STM32U5_DHUK` | Auto-detected | port/st/stm32.c |
| STM32MP1/MP13/MP25 | AES, SHA, RSA, ECC | `WOLFSSL_STM32_CRYPT` | Auto-detected | port/st/stm32.c |
| **NXP** | | | | |
| i.MX RT (DCP) | AES-ECB/CBC/CTR/GCM, SHA | `WOLFSSL_IMXRT_DCP` | Auto-detected | port/nxp/dcp_port.c |
| i.MX 6/8 (CAAM) | AES, SHA, RSA, ECC, DH, HMAC | `WOLFSSL_IMX6_CAAM` / `WOLFSSL_SECO_CAAM` | `--enable-caam` | port/caam/* |
| SE050 Secure Element | AES, SHA, RSA, ECC, X25519, ECDH | `WOLFSSL_SE050` + `WOLFSSL_SE050_CRYPT` | Auto-detected | port/nxp/se050_port.c |
| **Espressif** | | | | |
| ESP32 / ESP32-S2 / ESP32-S3 | AES, SHA-1/256/384/512, RSA, ECC | `WOLFSSL_ESP32_CRYPT` | `--enable-esp32` | port/Espressif/esp32_*.c |
| ESP32-C3 / C6 / H2 | AES, SHA-256/384/512 (partial) | `WOLFSSL_ESP32_CRYPT` | `--enable-esp32` | port/Espressif/esp32_*.c |
| **Renesas** | | | | |
| RX64M/RX71M/RX72M | SHA-1, SHA-256 | `WOLFSSL_RENESAS_RX64_HASH` | Auto-detected | port/Renesas/renesas_rx64_*.c |
| RX65N (SCE) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_SCEPROTECT` | Auto-detected | port/Renesas/renesas_*.c |
| RZ/A1/A2 (TSIP) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_TSIP` | Auto-detected | port/Renesas/renesas_tsip_*.c |
| RA4M4/RA6M4 (RSIP) | AES, SHA, RSA, ECC, RNG | `WOLFSSL_RENESAS_RSIP` | Auto-detected | port/Renesas/renesas_rsip*.c |
| RA FSP Secure Manager | AES, SHA, RSA, ECC, HMAC | `WOLFSSL_RENESAS_FSPSM` | Auto-detected | port/Renesas/renesas_fspsm_*.c |
| **Cypress** | | | | |
| PSoC 6 | AES, SHA, ECC, RNG | `WOLFSSL_PSOC6_CRYPTO` | Auto-detected | port/cypress/psoc6_crypto.c |
| **Silicon Labs** | | | | |
| EFR32 / EFM32 (SE) | AES, SHA, ECC, RNG | `WOLFSSL_SILABS_SE_ACCEL` | Auto-detected | port/silabs/silabs_*.c |
| **Maxim** | | | | |
| MAX3266X | AES-ECB/CBC, RSA | `WOLFSSL_MAX3266X` | Auto-detected | port/maxim/max3266x.c |
| MAXQ10XX | AES, SHA, RSA, ECC, RNG | `WOLFSSL_MAXQ10XX_CRYPTO` | `--with-maxq10xx=PART` | port/maxim/maxq10xx.c |
| **Microchip** | | | | |
| PIC32MZ | AES, SHA, RNG | `WOLFSSL_PIC32MZ_CRYPT` | Auto-detected | port/pic32/ |
| ATECC508A / 608A | AES, SHA, ECC (ECDH/ECDSA) | `WOLFSSL_ATECC` | Auto-detected | port/atmel/atmel.c |
| **Xilinx** | | | | |
| Zynq / Zynq-7000 | AES, SHA, RSA, ECC | `WOLFSSL_XILINX_CRYPT` | `--enable-xilinx` | port/xilinx/xil-*.c |
| Versal | AES-GCM, SHA-3, RNG | `WOLFSSL_XILINX_CRYPT_VERSAL` | `--enable-xilinx` | port/xilinx/xil-versal-*.c |
| **ARM CryptoCell** | | | | |
| CC-300/312/700/712/714 | AES, SHA, RSA, ECC, ChaCha, Poly1305 | `WOLFSSL_CRYPTOCELL` | `--enable-cryptocell` | port/arm/cryptocell*.c |
| **IoT-Safe (SIM)** | ECC, SHA, RNG | `WOLFSSL_IOTSAFE` | `--enable-iotsafe` | port/iotsafe/ |

## D. External Accelerators and Coprocessors

| Product | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| Intel QuickAssist (QAT) | AES, RSA, DH, ECC, SHA | `HAVE_INTEL_QA` | `--with-intelqa=PATH` |
| Intel QAT (synchronous) | Same as above | `ENABLED_INTEL_QA_SYNC` | `--with-intelqa-sync=PATH` |
| Cavium NITROX | AES, RSA, DH, ECC, SHA | `HAVE_CAVIUM` | `--with-cavium=PATH` |
| Cavium NITROX V | Same as above | `HAVE_CAVIUM_V` | `--with-cavium=PATH` |
| Cavium Octeon (MIPS) | AES, RSA, ECC, SHA | `HAVE_CAVIUM_OCTEON` | `--with-octeon-sync=PATH` |
| NXP CAAM | AES, SHA, RSA, ECC, HMAC, DH | `WOLFSSL_CAAM` | `--enable-caam` |

## E. OS Kernel Hardware Offload Interfaces

| Interface | Algorithms | user_settings.h Macro | configure Option |
|---|---|---|---|
| Linux `/dev/crypto` | AES, SHA-1/256/512, RSA, ECC, DH, HMAC | `WOLFSSL_DEVCRYPTO` | `--enable-devcrypto` |
| Linux Kernel Crypto API | AES, SHA, RSA, ECC, X25519, HMAC | `WOLFSSL_KCAPI` | `--enable-kcapi` |
| Linux AF_ALG | AES, SHA (kernel backend dependent) | `WOLFSSL_AFALG` | `--enable-afalg` |
| PSA (Platform Security Architecture) | Vendor implementation dependent | `WOLFSSL_HAVE_PSA` | `--enable-psa` |
