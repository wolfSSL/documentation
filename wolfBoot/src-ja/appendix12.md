# TrustZone-MセキュアドメインにおけるwolfCrypt

ARMv8-Mマイクロコントローラーは、ソフトウェア実行のためのハードウェアによるドメイン分離をサポートしています。
このTEEメカニズムは2つの個別ドメイン（セキュアおよび非セキュア）を提供し、非セキュアドメインからセキュア関数を呼び出すためのインターフェースとして使用できる追加ゾーン（非セキュア呼び出し可能）を提供します。

wolfBootはオプションで、非セキュアドメインにステージングされたあらゆるソフトウェアからアクセス可能な非呼び出し可能APIとして、暗号化機能をエクスポートできます。

## TrustZone-MセキュアドメインでwolfCryptを使用したwolfBootのコンパイル

wolfBootが`TZEN=1`および`WOLFCRYPT_TZ=1`オプションでコンパイルされると、wolfCrypt暗号ライブラリのより完全なコンポーネントセットがブートローダーに組み込まれます。
そうすると、非セキュア呼び出し可能APIを通じて非セキュアドメインで実行されるアプリケーションまたはOSからアクセスできるようになります。

この機能は、コアとなる暗号操作をアプリケーションから分離するために使用されます。

## 非セキュアワールドでのPKCS11 API

`WOLFCRYPT_TZ_PKCS11`オプションは、セキュアモードの専用フラッシュ領域にPKCS11オブジェクトを保存するためのストレージを含む、標準的なPKCS11インターフェースを提供します。

これにより、非セキュアドメインで実行されるアプリケーション、TLSライブラリ、およびオペレーティングシステムは、標準的なPKCS11インターフェースを通じてwolfCryptにアクセスし、非セキュアドメインに公開されることのない事前プロビジョニングされた鍵を使用して暗号ライブラリを使用できます。

## STM32L552を使用した例

 - TrustZone-Mおよび PKCS11インターフェースでwolfCryptをサポートするSTM32-L5の例設定をコピーします。`cp config/examples/stm32l5-wolfcrypt-tz.config .config`

 - `make`を実行します。`wolfboot.elf`とテストアプリケーションは別々のオブジェクトとしてビルドされます。アプリケーションは署名され、`test-app/image_v1_signed.bin`として保存されます。

 - ターゲットデバイスのオプションバイトが以下のように設定されていることを確認します。

```
OPTION BYTES BANK: 0

   Read Out Protection:

     RDP          : 0xAA (Level 0, no protection)

   BOR Level:

     BOR_LEV      : 0x0 (BOR Level 0, reset level threshold is around 1.7 V)

   User Configuration:

     nRST_STOP    : 0x1 (No reset generated when entering Stop mode)
     nRST_STDBY   : 0x1 (No reset generated when entering Standby mode)
     nRST_SHDW    : 0x1 (No reset generated when entering the Shutdown mode)
     IWDG_SW      : 0x1 (Software independant watchdog)
     IWDG_STOP    : 0x1 (IWDG counter active in stop mode)
     IWDG_STDBY   : 0x1 (IWDG counter active in standby mode)
     WWDG_SW      : 0x1 (Software window watchdog)
     SWAP_BANK    : 0x0 (Bank 1 and bank 2 address are not swapped)
     DB256        : 0x1 (256Kb dual-bank Flash with contiguous addresses)
     DBANK        : 0x0 (Single bank mode with 128 bits data read width)
     SRAM2_PE     : 0x1 (SRAM2 parity check disable)
     SRAM2_RST    : 0x1 (SRAM2 is not erased when a system reset occurs)
     nSWBOOT0     : 0x1 (BOOT0 taken from PH3/BOOT0 pin)
     nBOOT0       : 0x1 (nBOOT0 = 1)
     PA15_PUPEN   : 0x1 (USB power delivery dead-battery disabled/ TDI pull-up activated)
     TZEN         : 0x1 (Global TrustZone security enabled)
     HDP1EN       : 0x0 (No HDP area 1)
     HDP1_PEND    : 0x0  (0x8000000)
     HDP2EN       : 0x0 (No HDP area 2)
     HDP2_PEND    : 0x0  (0x8000000)
     NSBOOTADD0   : 0x100000  (0x8000000)
     NSBOOTADD1   : 0x17F200  (0xBF90000)
     SECBOOTADD0  : 0x180000  (0xC000000)
     BOOT_LOCK    : 0x0 (Boot based on the pad/option bit configuration)

   Secure Area 1:

     SECWM1_PSTRT : 0x0  (0x8000000)
     SECWM1_PEND  : 0x39  (0x8039000)

   Write Protection 1:

     WRP1A_PSTRT  : 0x7F  (0x807F000)
     WRP1A_PEND   : 0x0  (0x8000000)
     WRP1B_PSTRT  : 0x7F  (0x807F000)
     WRP1B_PEND   : 0x0  (0x8000000)
OPTION BYTES BANK: 1

   Secure Area 2:

     SECWM2_PSTRT : 0x7F  (0x807F000)
     SECWM2_PEND  : 0x0  (0x8000000)

   Write Protection 2:

     WRP2A_PSTRT  : 0x7F  (0x80BF000)
     WRP2A_PEND   : 0x0  (0x8040000)
     WRP2B_PSTRT  : 0x7F  (0x80BF000)
     WRP2B_PEND   : 0x0  (0x8040000)
```

 - `wolfboot.bin`とテストアプリケーションをフラッシュの2つの異なるドメインにアップロードします。

```
STM32_Programmer_CLI -c port=swd -d wolfboot.bin 0x0C000000
STM32_Programmer_CLI -c port=swd -d test-app/image_v1_signed.bin 0x08040000
```

 - 再起動後、ボード上のLEDが順番に点灯するはずです。
   - 赤色LED：セキュアブートが成功しました。アプリケーションが開始しました。
   - 青色LED：PKCS11トークンが初期化され、保存しました
   - 緑色LED：ECDSA署名/検証テストが成功しました


## STM32H563を使用した例

 - TrustZoneとPKCS11をサポートするSTM32H5の例設定のいずれかを`.config`にコピーします。
     `cp config/examples/stm32h5-tz.config .config`
     `cp config/examples/stm32h5-tz-dualbank-otp.config .config` (デュアルバンク付き)
     `cp config/examples/stm32h5-tz-dualbank-otp-lms.config .config` (デュアルバンクおよびPQ LMS付き)

 - `make`を実行します。`wolfboot.elf`とテストアプリケーションは別々のオブジェクトとしてビルドされます。アプリケーションは署名され、`test-app/image_v1_signed.bin`として保存されます。

 - ターゲットデバイスのオプションバイトが以下のように設定されていることを確認します。

```
OPTION BYTES BANK: 0

   Product state:

     PRODUCT_STATE: 0xED (Open)

   BOR Level:

     BOR_LEV      : 0x0 (BOR Level 1, the threshold level is low (around 2.1 V))
     BORH_EN      : 0x0  (0x0)

   User Configuration:

     IO_VDD_HSLV  : 0x0  (0x0)
     IO_VDDIO2_HSLV: 0x0  (0x0)
     IWDG_STOP    : 0x1  (0x1)
     IWDG_STDBY   : 0x1  (0x1)
     BOOT_UBE     : 0xB4 (OEM-iRoT (user flash) selected)
     SWAP_BANK    : 0x0  (0x0)
     IWDG_SW      : 0x1  (0x1)
     NRST_STOP    : 0x1  (0x1)
     NRST_STDBY   : 0x1  (0x1)
OPTION BYTES BANK: 1

   User Configuration 2:

     TZEN         : 0xB4 (Trust zone enabled)
     SRAM2_ECC    : 0x1 (SRAM2 ECC check disabled)
     SRAM3_ECC    : 0x1 (SRAM3 ECC check disabled)
     BKPRAM_ECC   : 0x1 (BKPRAM ECC check disabled)
     SRAM2_RST    : 0x1 (SRAM2 not erased when a system reset occurs)
     SRAM1_3_RST  : 0x1 (SRAM1 and SRAM3 not erased when a system reset occurs)
OPTION BYTES BANK: 2

   Boot Configuration:

     NSBOOTADD    : 0x80400  (0x8040000)
     NSBOOT_LOCK  : 0xC3 (The SWAP_BANK and NSBOOTADD can still be modified following their individual rules.)
     SECBOOT_LOCK : 0xC3 (The BOOT_UBE, SWAP_BANK and SECBOOTADD can still be modified following their individual rules.)
     SECBOOTADD   : 0xC0000  (0xC000000)
OPTION BYTES BANK: 3

   Bank1 - Flash watermark area definition:

     SECWM1_STRT  : 0x0  (0x8000000)
     SECWM1_END   : 0x1F  (0x803E000)

   Write sector group protection 1:

     WRPSGn1      : 0xFFFFFFFF  (0x0)
OPTION BYTES BANK: 4

   Bank2 - Flash watermark area definition:

     SECWM2_STRT  : 0x7F  (0x81FE000)
     SECWM2_END   : 0x0  (0x8100000)

   Write sector group protection 2:

     WRPSGn2      : 0xFFFFFFFF  (0x8000000)
OPTION BYTES BANK: 5

   OTP write protection:

     LOCKBL       : 0x0  (0x0)
OPTION BYTES BANK: 6

   Flash data bank 1 sectors:

     EDATA1_EN    : 0x0 (No Flash high-cycle data area)
     EDATA1_STRT  : 0x0  (0x0)
OPTION BYTES BANK: 7

   Flash data bank 2 sectors :

     EDATA2_EN    : 0x0 (No Flash high-cycle data area)
     EDATA2_STRT  : 0x0  (0x0)
OPTION BYTES BANK: 8

   Flash HDP bank 1:

     HDP1_STRT    : 0x1  (0x2000)
     HDP1_END     : 0x0  (0x0)
OPTION BYTES BANK: 9

   Flash HDP bank 2:

     HDP2_STRT    : 0x1  (0x2000)
     HDP2_END     : 0x0  (0x0)
```

 - `wolfboot.bin`とテストアプリケーションをフラッシュの2つの異なるドメインにアップロードします。

```
STM32_Programmer_CLI -c port=swd -d wolfboot.bin 0x0C000000
STM32_Programmer_CLI -c port=swd -d test-app/image_v1_signed.bin 0x08040000
```

 - 再起動後、ボード上のLEDが順番に点灯するはずです。
   - 赤色LED：セキュアブートが成功しました。アプリケーションが開始しました。
   - 青色LED：PKCS11トークンが初期化され、保存しました
   - 緑色LED：ECDSA署名/検証テストが成功しました
