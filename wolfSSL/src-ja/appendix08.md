# wolfSSL ハードウェア最適化サポート対応表

## A. アーキテクチャ別 ISA/SIMD 最適化

以下のアセンブリ最適化は、デフォルトの `./configure` ではいずれも有効になりません。
`--enable-all-asm` は、ビルドホストに該当する最適化を有効にします（x86-64 では `--enable-intelasm` と SP アセンブリ、AArch64 では `--enable-armasm` と SP アセンブリ、PowerPC ホストでは PowerPC アセンブリ）。
また、ほとんどのホストでは、`--enable-all-crypto`（したがって `--enable-all`）を指定した場合にも `--enable-all-asm` がデフォルトで有効になります。

| アーキテクチャ | アルゴリズム | user_settings.h マクロ | configure オプション | 備考 |
|---|---|---|---|---|
| **Intel x86-64** | AES（全モード） | `WOLFSSL_AESNI` | `--enable-aesni` | AES-NI 命令 |
| Intel x86-64 | SHA-256, SHA-512 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | `HAVE_INTEL_AVX1` / `HAVE_INTEL_AVX2` は内部で定義され、AVX1 と AVX2 のどちらのコードを使用するかは実行時に選択されます |
| Intel x86-64 | SHA-3 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | sha3_asm.S |
| Intel x86-64 | ChaCha20, Poly1305 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | |
| Intel x86-64 | X25519 (Curve25519), Ed25519 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | fe_x25519_asm.S |
| Intel x86-64 | ML-KEM, ML-DSA, FrodoKEM | `USE_INTEL_SPEEDUP` | `--enable-intelasm` | wc_mlkem_asm.S, wc_mldsa_asm.S, wc_frodokem_asm.S |
| Intel x86-64 | SM3 | `USE_INTEL_SPEEDUP` | `--enable-intelasm` + `--enable-sm3` | sm3_asm.S（SM アルゴリズムには wolfSM が必要です。付録K をご参照ください） |
| Intel x86-64 | Falcon | - | `--enable-falcon=asm` + `--enable-experimental` | wc_falcon_fpr_x86_64_asm.S |
| Intel x86-64 | RSA/ECC/DH (SP) | `WOLFSSL_SP_X86_64_ASM` | `--enable-sp --enable-sp-asm` | sp_x86_64_asm.S |
| **Intel x86 (32-bit)** | AES, AES-XTS | `WOLFSSL_AESNI` | `--enable-aesni` | aes_asm.S, aes_xts_x86_asm.S（32-bit の AES-GCM は、AES-NI と C 実装の GHASH を組み合わせて使用します） |
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
| **Qualcomm Hexagon DSP** | ECC P-256 検証 (SP) | `WOLFSSL_DSP` | user_settings.h | sp_dsp32.c、IDE/HEXAGON を参照 |

SP アセンブリマクロ（`WOLFSSL_SP_*_ASM`）を使用するには、SP 実装（`--enable-sp`、デフォルトで無効）と `--enable-sp-asm` の両方が必要です。
その場合、configure がホスト CPU に対応するマクロを選択します。
`--enable-sp-asm` がデフォルトで有効になるのは、x86-64 と AArch64 で制限付きの `--enable-sp-math` を選択した場合のみです。
デフォルトの数学ライブラリは `sp_int.c`（`WOLFSSL_SP_MATH_ALL`）です。

## B. SP Mathライブラリ（公開鍵暗号）

| アーキテクチャ | 対応アルゴリズム | user_settings.h マクロ | configure オプション |
|---|---|---|---|
| x86-64 アセンブリ | RSA 2048/3072/4096, ECC P-256/P-384/P-521, DH | `WOLFSSL_SP_X86_64_ASM` | `--enable-sp --enable-sp-asm` |
| ARM AArch64 アセンブリ | RSA, ECC, DH | `WOLFSSL_SP_ARM64_ASM` | `--enable-sp --enable-sp-asm` |
| ARM 32-bit アセンブリ | RSA, ECC, DH | `WOLFSSL_SP_ARM32_ASM` | `--enable-sp --enable-sp-asm` |
| ARM Thumb アセンブリ | RSA, ECC, DH | `WOLFSSL_SP_ARM_THUMB_ASM` | `--enable-sp --enable-sp-asm` |
| Cortex-M アセンブリ | RSA, ECC, DH | `WOLFSSL_SP_ARM_CORTEX_M_ASM` | `--enable-sp --enable-sp-asm` |
| RISC-V 64-bit アセンブリ | RSA, ECC, DH | `WOLFSSL_SP_RISCV64_ASM` | `--enable-sp --enable-sp-asm` |
| 汎用 C (32-bit / 64-bit) | RSA, ECC, DH | `WOLFSSL_HAVE_SP_RSA`, `WOLFSSL_HAVE_SP_DH`, `WOLFSSL_HAVE_SP_ECC` | `--enable-sp` |

`--enable-sp` は汎用 C 実装（sp_c32.c / sp_c64.c）をビルドし、`WOLFSSL_HAVE_SP_RSA`、`WOLFSSL_HAVE_SP_DH`、`WOLFSSL_HAVE_SP_ECC` を定義します。
`WOLFSSL_SP_MATH`（`--enable-sp-math`）は、SP が実装している鍵長と曲線のみをサポートする制限付きモードです。

### sp_int.c インラインアセンブリ高速化

`sp_int.c` には、アーキテクチャ専用 SP ファイル（例：`sp_x86_64.c`）が存在しない場合や、RSA/ECC 以外の鍵長に対応するため、多倍長整数の乗算・加算向けの小規模インラインアセンブリが含まれています。
以下のマクロで制御されます（自動検出、または `user_settings.h` で明示設定可）：

| アーキテクチャ | user_settings.h マクロ |
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

### SP 鍵サイズ設定

SP を有効にすると、RSA-2048、RSA-3072、ECC P-256 はデフォルトで含まれます。
RSA-4096、P-384、P-521 は追加する必要があります。
アセンブリマクロは、ターゲットに合ったものを1つだけ選択してください。

```c
/* RSA、DH、ECCでSPを有効化 */
#define WOLFSSL_HAVE_SP_RSA
#define WOLFSSL_HAVE_SP_DH
#define WOLFSSL_HAVE_SP_ECC

/* オプション: 制限付きSP Math（以下で有効にしたサイズと曲線のみ） */
/* #define WOLFSSL_SP_MATH */

/* オプション: アセンブリ（いずれか1つを選択） */
#define WOLFSSL_SP_ASM
#define WOLFSSL_SP_X86_64_ASM          /* x86-64 */
/* #define WOLFSSL_SP_ARM64_ASM */     /* AArch64 */
/* #define WOLFSSL_SP_ARM_CORTEX_M_ASM */ /* Cortex-M */

/* 追加の鍵サイズと曲線 */
#define WOLFSSL_SP_4096  /* RSA-4096 */
#define WOLFSSL_SP_384   /* ECC P-384 */
#define WOLFSSL_SP_521   /* ECC P-521 */

/* 不要なデフォルトサイズを除外 */
/* #define WOLFSSL_SP_NO_2048 */  /* RSA-2048 */
/* #define WOLFSSL_SP_NO_3072 */  /* RSA-3072 */
/* #define WOLFSSL_SP_NO_256 */   /* ECC P-256 */
```

## C. マイコン/SoC チップ別ハードウェアアクセラレータ

これらのポートは、`user_settings.h` での定義によって選択します（例えば `WOLFSSL_STM32F4` を定義すると、`settings.h` が `STM32_CRYPTO` と `STM32_HASH` を定義します）。
自動検出はされません。
configure オプションが存在するものは、そのオプションも記載しています。

| ベンダー / チップ | 対応アルゴリズム | user_settings.h マクロ | configure オプション | ソース |
|---|---|---|---|---|
| **STMicroelectronics** | | | | |
| STM32F2/F4/F7/H7 (CRYP) | AES-ECB/CBC/CTR/GCM | `STM32_CRYPTO`（ファミリーの定義により設定。例：`WOLFSSL_STM32F4`） | user_settings.h | port/st/stm32.c |
| STM32L4/L5/WB55 | AES, SHA（部分） | `STM32_CRYPTO`（ファミリーの定義により設定） | user_settings.h | port/st/stm32.c |
| STM32U5 (DHUK) | 鍵ラップ付き AES | `WOLFSSL_STM32U5_DHUK` | user_settings.h | port/st/stm32.c |
| STM32MP13 (ベアメタル) | AES, SHA, RNG, ECC (PKA) | `WOLFSSL_STM32MP13` (`STM32_CRYPTO`を設定) | user_settings.h | port/st/stm32.c、port/st/STM32MP13.md を参照 |
| STM32V8 (Cortex-M85) | AES, SHA, PKA, RNG | `WOLFSSL_STM32V8` | user_settings.h | port/st/stm32.c |
| STM32 ベアメタル（レジスタ直接アクセス、HAL 不使用、約27ファミリー） | HASH, AES, PKA, RNG, DHUK ラップ鍵, CCB 保護 ECDSA | `WOLFSSL_STM32_BARE` | user_settings.h | port/st/stm32.c |
| STM32 CubeMX / CubeMX2 暗号コールバックデバイス | AES（平文鍵）, AES-GCM, ECDSA | `WOLFSSL_STM32_CUBEMX` / `WOLFSSL_MX2_CONF_INCLUDE` | user_settings.h | port/st/ |
| STSAFE-A100/A120 | ECDSA, ECDH | `WOLFSSL_STSAFEA100` / `WOLFSSL_STSAFEA120` | `--enable-stsafe=a100` / `--enable-stsafe=a120` | port/st/stsafe.c |
| **NXP** | | | | |
| i.MX RT (DCP) | AES-ECB/CBC (128-bit), SHA-1, SHA-256 | `WOLFSSL_IMXRT_DCP` | user_settings.h | port/nxp/dcp_port.c |
| i.MX 6/8 (CAAM) | AES, SHA, RSA, ECC, DH, HMAC | `WOLFSSL_IMX6_CAAM` / `WOLFSSL_SECO_CAAM` | `--enable-caam` | port/caam/* |
| SE050 セキュアエレメント | AES, SHA, RSA, ECC, X25519, ECDH | `WOLFSSL_SE050` + `WOLFSSL_SE050_CRYPT` | `--with-se050=PATH` | port/nxp/se050_port.c |
| EdgeLock Secure Enclave (ELE) | RNG（シード） | `WOLFSSL_NXP_ELE` | `--enable-ele` | port/nxp/ele_cryptocb.c, ele_rng.c |
| EdgeLock ELS/PKC（例：RW61x） | AES-ECB/CBC/CTR/GCM, CMAC, SHA-256/384/512, RNG | `WOLFSSL_ELS_PKC` | `--with-els-pkc=PATH` | port/nxp/els_pkc_port.c |
| LPC55S69 HashCrypt | AES-ECB/CBC/CTR/OFB/CFB, SHA-1, SHA-256 | `WOLFSSL_NXP_HASHCRYPT`（`WOLFSSL_NXP_LPC55S6X` により設定） | user_settings.h | port/nxp/hashcrypt_port.c |
| LPC55S69 CASPER | RSA 公開鍵演算, ECC 点乗算 | `WOLFSSL_NXP_CASPER`（`WOLFSSL_NXP_LPC55S6X` により設定） | user_settings.h | port/nxp/casper_port.c |
| LPC55S69 ハードウェア PUF | PUF による鍵の生成と保管 | `WOLFSSL_NXP_HWPUF` | user_settings.h | port/nxp/hwpuf_port.c |
| Kinetis mmCAU / LTC | AES, DES, MD5, SHA-1, SHA-256 (mmCAU); AES-GCM, RSA/ECC 演算 (LTC) | `FREESCALE_USE_MMCAU` / `FREESCALE_USE_LTC` | user_settings.h | aes.c, des3.c, port/nxp/ksdk_port.c |
| QorIQ SEC (T1040, T2080) | AES-CBC/CTR/ECB/GCM, ECDSA, ECDH, RSA, FFDHE, RNG | `WOLFSSL_SEC_QORIQ` | `--enable-sec-qoriq` | port/nxp/sec_qoriq*.c |
| **Espressif** | | | | |
| ESP32 / ESP32-S2 / ESP32-S3 | AES, SHA-1/256/384/512, RSA, ECC | `WOLFSSL_ESPIDF` + `WOLFSSL_ESP32`（これにより settings.h が `WOLFSSL_ESP32_CRYPT` を定義） | ESP-IDF コンポーネント | port/Espressif/esp32_*.c |
| ESP32-C3 / C6 / H2 | AES, SHA-256/384/512（部分） | `WOLFSSL_ESPIDF` + `WOLFSSL_ESP32`（これにより settings.h が `WOLFSSL_ESP32_CRYPT` を定義） | ESP-IDF コンポーネント | port/Espressif/esp32_*.c |
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
| EFR32 Secure Element 暗号コールバックデバイス | AES-ECB/CBC/CTR/GCM/CCM, ChaCha20, CMAC, SHA-1/224/256/384/512, HKDF, PBKDF2, ECDSA, ECDH, RNG | `WOLFSSL_SILABS_CRYPTOCB` | `--enable-silabs-cryptocb` | port/silabs/silabs_cb_*.c |
| **Maxim** | | | | |
| MAX3266X | AES-ECB/CBC, SHA-1/224/256/384/512, TRNG, MAA (RSA/ECC 演算) | `WOLFSSL_MAX3266X` | user_settings.h | port/maxim/max3266x.c |
| MAXQ10XX | AES, SHA, RSA, ECC, RNG | `WOLFSSL_MAXQ10XX_CRYPTO` | `--with-maxq10xx=PART` | port/maxim/maxq10xx.c |
| **Microchip** | | | | |
| PIC32MZ | AES, SHA, RNG | `WOLFSSL_PIC32MZ_CRYPT` | user_settings.h | port/pic32/ |
| ATECC508A / 608A | AES, SHA, ECC (ECDH/ECDSA) | `WOLFSSL_ATECC508A` / `WOLFSSL_ATECC608A` | `--enable-microchip=508` / `--enable-microchip=608` | port/atmel/atmel.c |
| TA100 | RSA, ECC, AES-GCM | `WOLFSSL_MICROCHIP_TA100` | `--enable-microchip=100` | port/atmel/atmel.c |
| PolarFire SoC Athena F5200 (TeraFire) | AES-256-CTR, SHA-384 | `WOLFSSL_MPFS_ATHENA` | `--with-mpfs-athena=PATH` | port/microchip/mpfs_athena.c |
| **Xilinx / AMD** | | | | |
| Zynq UltraScale+ MPSoC | AES-GCM, SHA3-384, RSA | `WOLFSSL_XILINX_CRYPT` | `--enable-xilinx` | port/xilinx/xil-*.c |
| Versal | AES-GCM, SHA-3, RSA, ECDSA, RNG | `WOLFSSL_XILINX_CRYPT_VERSAL` | user_settings.h（`--enable-xilinx` は `WOLFSSL_XILINX_CRYPT` のみを定義） | port/xilinx/xil-versal-*.c |
| Versal Gen2 (ASU) | TRNG, ハッシュ, HMAC, AES 暗号, CMAC, GMAC, RSA (raw, PSS, OAEP), ECC, ECDH, ECIES, EdDSA, X25519/X448（X25519/X448 には Vitis 2026.1 以降が必要） | `WOLFSSL_VERSAL_GEN2_ASU` | user_settings.h | port/xilinx/versal_gen2_asu/ |
| **Altera** | | | | |
| Agilex 5 SDM (FPGA Crypto Services) | AES, SHA-256/384/512, HMAC, ECDSA 署名, ECDH, RNG | `WOLFSSL_ALTERA_FCS` | `--enable-alterafcs` | port/altera/ |
| **Nuvoton** | | | | |
| M2354 | AES-ECB/CBC/CTR/GCM, SHA-1/224/256/384/512, RSA, ECDSA, ECDH, RNG | `WOLFSSL_NUVOTON_M2354` | user_settings.h | port/nuvoton/ |
| **Texas Instruments** | | | | |
| TM4C (Tiva) | AES (CBC/CTR/GCM/CCM), 3DES, MD5, SHA-1, SHA-224, SHA-256 | `WOLFSSL_TI_CRYPT` / `WOLFSSL_TI_HASH` | user_settings.h | port/ti/ti-aes.c, ti-des3.c, ti-hash.c, ti-ccm.c |
| AM64x (SA2UL, Cortex-R5F) | TRNG, AES-ECB/CBC/GCM, SHA-256/512, HMAC, CMAC | `WOLFSSL_TI_AM64X_R5` | user_settings.h | port/ti/ti-sa2ul_r5_port.c |
| C2000 C28x（AESA 暗号コールバックデバイス） | AES-ECB/CBC/CTR, オシレータのジッタによるエントロピー | `WOLFSSL_C2000_AES` / `WOLFSSL_C2000_ENTROPY`（`WOLFSSL_WIDE_BYTE` と併用） | user_settings.h | port/ti/ti-c2000-*.c |
| **RealTek** | | | | |
| AmebaPro2（RTL8735B HUK 暗号コールバックデバイス） | AES, HMAC-SHA256, ECDSA, TRNG | `WOLFSSL_RTL8735B_HUK` / `WOLFSSL_RTL8735B_AES` | user_settings.h（`--enable-rtl8735b` はホスト上でのコンパイルテストをビルドします） | port/realtek/rtl8735b.c |
| **WISeKey / SealSQ** | | | | |
| VaultIC セキュアエレメント | P-256 署名, 検証, 鍵生成, ECDH | `WOLFSSL_VAULTIC` | `--enable-vaultic` | port/sealsq/vaultic.c |
| **Tropic Square** | | | | |
| TROPIC01 セキュアエレメント | AES-CBC, AES-GCM, ECDSA, RNG | `WOLFSSL_TROPIC01` | `--with-tropic01=PATH` | port/tropicsquare/tropic01.c |
| **Vorago** | | | | |
| VA416x0 | TRNG（Hash-DRBG のシードとして使用） | `WOLFSSL_VA416X0_TRNG` | user_settings.h | wolfcrypt/src/random.c |
| **Raspberry Pi** | | | | |
| RP2040 / RP2350 (Pico) | RNG | `WOLFSSL_RPIPICO` | user_settings.h | port/rpi_pico/pico.c |
| **Nordic** | | | | |
| nRF51 | RNG | `WOLFSSL_NRF51` | user_settings.h | port/nrf51.c |
| **IoT-Safe (SIM)** | ECC, SHA, RNG | `WOLFSSL_IOTSAFE` | `--enable-iotsafe` | port/iotsafe/ |

## D. 外部アクセラレータ・コプロセッサ

| 製品 | 対応アルゴリズム | user_settings.h マクロ | configure オプション |
|---|---|---|---|
| Intel QuickAssist (QAT) | AES, RSA, DH, ECC, SHA | `HAVE_INTEL_QA` | `--with-intelqa=PATH` |
| Intel QAT（同期） | 同上 | `HAVE_INTEL_QA_SYNC` | `--with-intelqa-sync=PATH` |
| Cavium NITROX | AES, RSA, DH, ECC, SHA | `HAVE_CAVIUM` | `--with-cavium=PATH` |
| Cavium NITROX V | 同上 | `HAVE_CAVIUM_V` | `--with-cavium-v=PATH` |
| Cavium Octeon (MIPS) | AES, RSA, ECC, SHA | `HAVE_CAVIUM_OCTEON_SYNC` | `--with-octeon-sync=PATH` |
| NXP CAAM | AES, SHA, RSA, ECC, HMAC, DH | `WOLFSSL_CAAM` | `--enable-caam` |
| NVIDIA CUDA GPU | AES | `HAVE_CUDA` | `--enable-cuda` |
| MagicCrypto ライブラリ | ARIA 暗号、および暗号コールバック経由の ECDSA、ECDH、SHA-256/384 | `HAVE_ARIA` | `--enable-aria` |
| PKCS#11 トークンまたは HSM | トークンに依存 | `HAVE_PKCS11` | `--enable-pkcs11` |

## E. OS カーネル経由ハードウェアオフロード

| インターフェース | 対応アルゴリズム | user_settings.h マクロ | configure オプション |
|---|---|---|---|
| Linux `/dev/crypto` | AES, SHA, HMAC, RSA, ECDSA, X25519 | `WOLFSSL_DEVCRYPTO` | `--enable-devcrypto` |
| Linux Kernel Crypto API | AES, SHA, HMAC, RSA, ECC, DH | `WOLFSSL_KCAPI` | `--enable-kcapi` |
| Linux AF_ALG | AES, SHA（カーネルバックエンド依存） | `WOLFSSL_AFALG` | `--enable-afalg` |
| PSA (Platform Security Architecture) | ベンダー実装依存 | `WOLFSSL_HAVE_PSA` | `--enable-psa` |
| AUTOSAR Csm / CryIf | AES-CBC, RNG, AES-CMAC | `WOLFSSL_AUTOSAR` | `--enable-autosar` |

## F. 物理複製困難関数 (PUF)

| 種類 | 機能 | user_settings.h マクロ | configure オプション |
|---|---|---|---|
| SRAM PUF | SRAM の起動時の値を用いたデバイス鍵の導出とデバイス識別 | `WOLFSSL_PUF` + `WOLFSSL_PUF_SRAM` | `--enable-puf` |
