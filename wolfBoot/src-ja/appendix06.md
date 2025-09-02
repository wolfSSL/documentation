# wolfBootローダー/アップデーター

## loader.c

wolfBootセーフブートプロセスを開始し、`*_updater.c`実装のいずれかを活用する、デフォルトのwolfBootローダーエントリーポイントです。

## loader_stage1.c

wolfBootをフラッシュからRAMにロードして実行するための第一段階ローダーです。
これは、フラッシュがメモリマップされていない（XIP）プラットフォームで必要です。
例えば、外部NANDフラッシュが使用されるPowerPC e500v2では、ブート用に小さな4KBの領域しか利用できないため、wolfBootはRAMにロードした後に実行される必要があります。

例: `make WOLFBOOT_STAGE1_LOAD_ADDR=0x1000 stage1`

* `WOLFBOOT_STAGE1_SIZE`: wolfBoot第一段階ローダーの最大サイズ
* `WOLFBOOT_STAGE1_FLASH_ADDR`: 第一段階ローダーのフラッシュ内の場所（ブートROMからXIP）
* `WOLFBOOT_STAGE1_BASE_ADDR`: 第一段階ローダーをロードするRAM内のアドレス
* `WOLFBOOT_STAGE1_LOAD_ADDR`: wolfBootをロードするRAM内のアドレス
* `WOLFBOOT_LOAD_ADDRESS`: アプリケーションパーティションをロードするRAM内のアドレス

## update_ram.c

RAMベースのアップデーターの実装です。

## update_flash.c

フラッシュベースのアップデーターの実装です。

## update_flash_hwswap.c

ハードウェア支援アップデーターの実装です。
