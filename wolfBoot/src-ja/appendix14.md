# コンフィギュレーションオプション

この章では、`make config`時に設定可能なコンフィギュレーションオプションについて解説します。

- `ARCH`: 使用するターゲットのアーキテクチャ
    - デフォルト：ARM
    - 設定可能値：x86_64/AARCH64/ARM/RNESAS_RX/RISCV/PPC/ARM_BE

- `HASH`: 使用するハッシュアルゴリズムを選択
    - デフォルト：SHA256
    - 設定可能値：SHA3/SHA256/SHA384

- `MCUXSDK`: NXPのMCU Xpresso SDKを使用する場合に有効化
    - デフォルト：1

- `MCUXPRESSO`: MCU Xpresso IDE環境向けの設定
    - デフォルト：/home/(User)/(Project)/wolfboot-2.4.0/mcux-sdk

- `MCUXPRESSO_CPU`: MCU Xpresso用のCPU固有の設定
    - デフォルト：MK64FN1M0VLL12

- `MCUXPRESSO_DRIVERS`: MCU Xpressoのドライバサポートを有効化
    - デフォルト：/home/(User)/(Project)/wolfboot-2.4.0/mcux-sdk/devices/MK64F12

- `MCUXPRESSO_CMSIS`: CMSIS（Cortex Microcontroller Software Interface Standard）ライブラリを有効化
    - デフォルト：/home/(User)/(Project)/wolfboot-2.4.0/CMSIS_5/CMSIS

- `FREEDOM_E_SDK`: SiFive Freedom-E SDKを使用する場合に有効化（RISC-V 向け）
    - デフォルト：/home/(User)/src/freedom-e-sdk

- `STM32CUBE`: STM32Cube HAL（STM32 向け）を有効化
    - デフォルト：/home/(User)/STM32Cube/Repository/STM32Cube_FW_WB_V1.3.0

- `CYPRESS_PDL`: Cypress Peripheral Driver Library（PDL）を有効化
    - デフォルト：/home/(User)/src/psoc6pdl

- `CYPRESS_CORE_LIB`: Cypressのコアライブラリを有効化
    - デフォルト：/home/(User)/src/cypress-core-lib

- `CYPRESS_TARGET_LIB`: Cypressのターゲット固有ライブラリを有効化
    - デフォルト：/home/(User)/src/TARGET_CY8CKIT-062S2-43012

- `CORTEX_M7`: ARM Cortex-M7をターゲットとする場合に有効化
    - デフォルト：0

- `CORTEX_M33`: ARM Cortex-M33をターゲットとする場合に有効化
    - デフォルト：0

- `NO_ASM`: アセンブリ最適化を無効化し、C言語のみで実装
    - デフォルト：0

- `NO_XIP`: XIP（Execute in Place）を無効化（フラッシュメモリから直接コードを実行しない）
    - デフォルト：0

- `WOLFBOOT_VERSION`: wolfBootのバージョンを指定するためのオプション
    - デフォルト値は include/wolfboot/version.h で定義されます

- `V`: ビルド時に詳細出力を有効化
    - デフォルト：0

- `NO_MPU`: メモリ保護ユニット（MPU）を無効化
    - デフォルト：0

- `SPMATH`: SP Mathライブラリ（ソフトウェア数学演算）を有効化
    - デフォルト：1

- `SPMATHALL`: すべてのSPMath関数を有効化
    - デフォルト：0

- `IMAGE_HEADER_SIZE`: ファームウェアのイメージヘッダーサイズを指定
    - デフォルト：256

- `PKA`: 公開鍵暗号処理を有効化（Public Key Accelerator）
    - デフォルト：1

- `TZEN`: TrustZoneセキュリティ機能を有効化
    - デフォルト：0

- `PSOC6_CRYPTO`: Cypress PSoC 6シリーズのハードウェア暗号エンジンを使用
    - デフォルト：1

- `WOLFBOOT_TPM_VERIFY`: TPM（Trusted Platform Module）を使用したファームウェア検証を有効化
    - デフォルト：0

- `WOLFBOOT_TPM_SEAL`: TPMを使用してデータを封印（シール）する機能を有効化
    - デフォルト：0

- `WOLFBOOT_TPM_KEYSTORE`: TPMを使用して鍵ストレージを有効化
    - デフォルト：0

- `WOLFCRYPT_TZ`: TrustZoneでwolfCryptを使用する機能を有効化
    - デフォルト：0

- `WOLFCRYPT_TZ_PKCS11`: TrustZoneでPKCS#11インターフェースを有効化
    - デフォルト：0

- `WOLFBOOT_LOAD_ADDRESS`: wolfBootのロードアドレスを指定
    - デフォルト：0x200000

- `WOLFBOOT_LOAD_DTS_ADDRESS`: デバイスツリーストレージ（DTS）のロードアドレスを指定
    - デフォルト：0x400000

- `WOLFBOOT_DTS_BOOT_ADDRESS`: ブート時のデバイスツリーアドレスを指定
    - デフォルト：0x30000

- `WOLFBOOT_DTS_UPDATE_ADDRESS`: アップデート用のデバイスツリーアドレスを指定
    - デフォルト：0x50000

- `DELTA_BLOCK_SIZE`: 差分更新のブロックサイズを指定
    - デフォルト：256

- `WOLFBOOT_HUGE_STACK`: スタックサイズを拡大するオプション
    - デフォルト：0

- `FORCE_32BIT`: 32ビットシステムとして強制的にビルドするオプション
    - デフォルト：0

- `ENCRYPT_WITH_CHACHA`: ChaCha暗号アルゴリズムを使用したファームウェア暗号化を有効化
    - デフォルト：0

- `ARMORED`: フォールトインジェクション攻撃（電圧およびクロックグリッチ、EMFIなど）に対する緩和策を有効化
    - デフォルト：0

- `LMS_LEVELS`: LMS（Leighton-Micali Signature）ハッシュベース署名のレベルを指定
    - デフォルト：0

- `LMS_HEIGHT`: LMS署名のハッシュツリーの高さを指定
    - デフォルト：0

- `LMS_WINTERNITZ`: Winternitz係数を設定（LMS署名のパラメータ）
    - デフォルト：0

- `WOLFBOOT_UNIVERSAL_KEYSTORE`: 同じキーストア内に異なるタイプの公開鍵を格納できるように設定
    - デフォルト：0

- `XMSS_PARAMS`: XMSS（eXtended Merkle Signature Scheme）のパラメータを指定
    - デフォルト：XMSS-SHA2_10_256
    - 設定可能値：XMSS-SHA2_10_256

- `ELF`: ELFフォーマットのサポートを有効化
    - デフォルト：0

- `BIG_ENDIAN`: ビッグエンディアンアーキテクチャをサポート
    - デフォルト：0

- `NXP_CUSTOM_DCD`: NXPプラットフォーム向けにDCD（Device Configuration Data）カスタム設定を有効化
    - デフォルト：0

- `NXP_CUSTOM_DCD_OBJS`: NXPのカスタムDCDオブジェクトを有効化

- `FLASH_OTP_KEYSTORE`: OTP（One-Time Programmable）メモリを使用したフラッシュ鍵ストレージを有効化
    - デフォルト：0

- `KEYVAULT_OBJ_SIZE`: KeyVaultに格納するオブジェクトのサイズを指定

- `KEYVAULT_MAX_ITEMS`: KeyVaultに保存できる最大アイテム数を指定

- `NO_ARM_ASM`: ARM アセンブリコードを無効化し、C言語のみで実装
    - デフォルト：0

- `SIGN_SECONDARY`: ハイブリッド（従来型暗号 + PQC）認証用に選択されたセカンダリアルゴリズムに設定し、イメージ用の第二の署名を有効化

- `WOLFHSM_CLIENT`: wolfHSMクライアントを有効化
    - デフォルト：0

- `WOLFHSM_CLIENT_LOCAL_KEYS`: wolfHSMクライアントがローカルキーを使用するオプション
    - デフォルト：0
