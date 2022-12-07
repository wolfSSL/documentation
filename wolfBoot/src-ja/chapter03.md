

# ターゲット



この章では、サポートされているターゲットの構成について説明します。



## サポートされているターゲット




* [Cortex A53 /Raspberry PI 3](#cortex-a53--raspberry-pi-3-experimental)


* [CypressPSOC-6](#cypress-psoc-6)


* [NXP LPC54XXX](#nxp-lpc54xxx)


* [NXP IMX-RT](#nxp-imx-rt)


* [NXP kinetis](#nxp-kinetis)


* [NXP T2080 PPC](#nxp-t2080-ppc)


* [sifive hifive1 risc-v](#sifive-hifive1-risc-v)


* [STM32F4](#stm32f4)


* [STM32L4](#stm32l4)


* [STM32F7](#stm32f7)


* [STM32G0](#stm32g0)


* [STM32H7](#stm32h7)


* [STM32L5](#stm32l5)


* [STM32L0](#stm32l0)


* [STM32WB55](#stm32wb55)


* [Ti Hercules TMS570LC435](#ti-hercules-tms570lc435)


* [Xilinx Zynq Ultrascale](#xilinx-zynq-ultrascale)


* [QEMU X86_64 UEFI](#qemu-x86_64-uefi)




## STM32F4



STM32-F407での512KBパーティションの例


`test-app`で提供されるファームウェアの例は、アドレス0x20000から始まるプライマリパーティションから起動するように構成されています。フラッシュレイアウトは、`target.h`の次の構成を使用してデフォルトの例で提供されます。



```C
#define WOLFBOOT_SECTOR_SIZE              0x20000
#define WOLFBOOT_PARTITION_SIZE           0x20000
#define WOLFBOOT_PARTITION_BOOT_ADDRESS   0x20000
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS 0x40000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS   0x60000
```



これにより、次のパーティション構成が得られます。

![example partitions](png/example_partitions.png)



この構成は、可能なレイアウトの1つを示しており、フラッシュメモリの物理セクターの先頭にスロットが配置されています。


このターゲットのすべての実行可能なファームウェアイメージのエントリポイントは、最初のフラッシュパーティションの先頭から256バイト先の、`0x20100`,です。これは、パーティションの先頭にあるファームウェアイメージヘッダーの存在によるものです。


この特定のケースでは、フラッシュジオメトリのため、2つのイメージ間の適切なセクタースワッピングを考慮するには、スワップスペースが128kbという大きさでなければなりません。


他のシステムでは、複数の小さなフラッシュブロックが使用される場合、スワップスペースは512バイトで済む場合があります。


フラッシュおよびアプリケーション内プログラミング(IAP)のジオメトリの詳細については、各ターゲットデバイスのメーカーマニュアルに記載されています。



### STM32F4プログラミング




```
st-flash write factory.bin 0x08000000
```




### STM32F4デバッグ




1. GDBサーバーを開始します



OpenOCD：`openocd --file ./config/openocd/openocd_stm32f4.cfg`ORST-LINK：`st-util -p 3333`



2. GDBクライアントを開始します




```sh
arm-none-eabi-gdb
add-symbol-file test-app/image.elf 0x20100
mon reset init
b main
c
```


## STM32L4

STM32L4での例1MBパーティション



-  セクターサイズ：4KB


-  wolfBootパーティションサイズ：40KB


-  アプリケーションパーティションサイズ：488KB




```C
#define WOLFBOOT_SECTOR_SIZE                 0x1000   /* 4 KB */
#define WOLFBOOT_PARTITION_BOOT_ADDRESS      0x0800A000
#define WOLFBOOT_PARTITION_SIZE              0x7A000  /* 488 KB */
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS    0x08084000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS      0x080FE000
```


## STM32L5


### シナリオ1：TrustZoneが有効なケース


#### サンプルプログラムの内容



サンプルプログラムの実装では、セキュアアプリケーションから非セキュアアプリケーションに切り替える方法を示しています。内部フラッシュと内部SRAMメモリにシステムをを分割できるので最初の半分にセキュアアプリケーションを配置し、残り半分に非セキュアアプリケーションを配置しています。



#### ハードウェアおよびソフトウェア環境




-  このサンプルプログラムは、セキュリティを有効にしてSTM32L562QEIXQデバイスで実行されます(TZEN=1)。


-  このサンプルプログラムは、STMicroelectronics STM32L562E-DK(MB1373)でテストされています。


-  ユーザーオプションバイト要件(STM32CubeProgrammer toolを使用 - 手順については以下を参照してください)




```
TZEN=1                              System with TrustZone-M enabled
DBANK=1                             Dual bank mode
SECWM1_PSTRT=0x0  SECWM1_PEND=0x7F  All 128 pages of internal Flash Bank1 set as secure
SECWM2_PSTRT=0x1  SECWM2_PEND=0x0   No page of internal Flash Bank2 set as secure, hence Bank2 non-secure
```




-  注：STM32CubeProgrammer v2.3.0が必要です(v2.4.0にはSTM32L5の既知のバグがあります)




#### 使い方




1. `cp ./config/examples/stm32l5.config .config`


2. `make TZEN=1`


3. 上記で報告されたオプションバイト構成を備えたボードを準備します

```
STM32_Programmer_CLI -c port=swd mode=hotplug -ob TZEN=1 DBANK=1
STM32_Programmer_CLI -c port=swd mode=hotplug -ob SECWM1_PSTRT=0x0 SECWM1_PEND=0x7F SECWM2_PSTRT=0x1 SECWM2_PEND=0x0
```


4. `wolfBoot.bin` をフラッシュの0x0C000000 に配置

```
STM32_Programmer_CLI -c port=swd -d ./wolfboot.bin 0x0C000000
```

5.  `.\test-app\image_v1_signed.bin` をフラッシュ0x08040000 に配置

```
STM32_Programmer_CLI -c port=swd -d ./test-app/image_v1_signed.bin 0x08040000
```

6. 赤色LED LD9が点灯します




7.  注：STM32_Programmer_CLIデフォルトのロケーション


* Windows：`C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe`


* Linux：`/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI`


* Mac OS/X：`/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI`




### シナリオ2：TrustZoneが無効のケース

#### サンプルプログラムの内容



実装では、TrustZoneが無効になっているDual_BankモードでSTM32L5xxを使用する方法を示しています。Dual_Bankオプションは、TrustZoneが無効になっている場合にのみこのターゲットで使用できます(Tzen=0)。


フラッシュメモリは、2つの異なるバンクにセグメント化されています。


 - バンク0：(0x08000000) 
 - バンク1：(0x08040000)


Bank 0にはアドレス0x08000000にブートローダーが含まれ、アドレス0x08040000にアプリケーションが含まれています。有効なイメージがバンク1の同じオフセットで利用可能な場合、2つの有効なイメージ間で起動するために候補として0x08048000が選択されます。


サンプルプログラムのコンフィギュレーションファイルは`/config/examples/stm32l5-nonsecure-dualbank.config`を使います。


イメージ `./test-app/image.bin`をFlash`0x08000000`に配置します。 
    
```
STM32_Programmer_CLI -c port=swd -d ./test-app/image.bin 0x08000000
```


または以下を使用して各パーティションをプログラムします。

1. `wolfboot.bin`をフラッシュ0x08000000に配置します

```
STM32_Programmer_CLI -c port=swd -d ./wolfboot.bin
```

2. イメージ./test-app/image_v1_signed.binをフラッシュ0x08008000に配置

```
STM32_Programmer_CLI -c port=swd -d ./test-app/image_v1_signed.bin 0x08008000
```


Red LD9は、成功したboot()を示すことになります



### デバッグ



`make DEBUG=1`を使用してファームウェアをリロードします。



-  STM32Cube IDEv.1.3.0が必要です


-  以下のコマンドでデバッガーを経由して実行します。



Linux:



```
ST-LINK_gdbserver -d -cp /opt/st/stm32cubeide_1.3.0/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_1.3.0.202002181050/tools/bin -e -r 1 -p 3333`
```



Mac OS/X：



```sh
sudo ln -s /Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.macos64_1.6.0.202101291314/tools/bin/native/mac_x64/libSTLinkUSBDriver.dylib /usr/local/lib/libSTLinkUSBDriver.dylib
/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.macos64_1.6.0.202101291314/tools/bin/ST-LINK_gdbserver -d -cp ./Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_1.6.0.202101291314/tools/bin -e -r 1 -p 3333
```




-  ARM-NONE-EABI-GDBと接続します



wolfBootには、構成する.gdbinitがあります

```
arm-none-eabi-gdb
add-symbol-file test-app/image.elf
mon reset init
```

## STM32U5

### シナリオ1：TrustZoneが有効のケース

#### サンプルプログラムの内容

サンプルプログラムの実装では、セキュアアプリケーションから非セキュアアプリケーションに切り替える方法を示しています。内部フラッシュと内部SRAMメモリにシステムをを分割できるので最初の半分にセキュアアプリケーションを配置し、残り半分に非セキュアアプリケーションを配置しています。

#### ハードウェアとソフトウエア環境

- サンプルプログラムはセキュリティ機能を有効にした（TZEN=1) STM32U585All6Q上で動作します。
- サンプルプログラムはSTMicroelectoromics B-U585I-IOT02A(MB1551)でテスト済みです。

```
TZEN = 1                            System with TrustZone-M enabled
DBANK = 1                           Dual bank mode
SECWM1_PSTRT=0x0  SECWM1_PEND=0x7F  All 128 pages of internal Flash Bank1 set as secure
SECWM2_PSTRT=0x1  SECWM2_PEND=0x0   No page of internal Flash Bank2 set as secure, hence Bank2 non-secure
```

- 注意: STM32CubeProgrammer V2.8.0 以降が必要です

#### 使用方法

1. コンフィギュレーションファイルをコピーします
    ```
    cp ./config/examples/stm32u5.config .config 
    ```
2. makeします
    ```
    make TZEN=1
    ```
3. 上記コンフィギュレーションを適用したボードを用意します
    ```
    STM32_Programmer_CLI -c port=swd mode=hotplug -ob TZEN=1 DBANK=1
    ```
    ```
    STM32_Programmer_CLI -c port=swd mode=hotplug -ob SECWM1_PSTRT=0x0 SECWM1_PEND=0x7F SECWM2_PSTRT=0x1 SECWM2_PEND=0x0
    ```
4. wolfBoot.binを0x0c000000に書き込みます
    ```
    STM32_Programmer_CLI -c port=swd -d ./wolfboot.bin 0x0C000000
    ```

5. イメージを0x08040000に書き込みます
    ```
    STM32_Programmer_CLI -c port=swd -d./test-app/image_v1_signed.bin 0x08100000
    ```

6. 赤色LED9が点灯します

STM32_Programme_CLIの存在位置
- Windows: `C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe`
- Linux: `/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI`
- Mac OS/X: `/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI`

### シナリオ2：TrustZoneが無効のケース

#### サンプルプログラムの内容

実装では、TrustZoneが無効になっているDual_BankモードでSTM32U5xxを使用する方法を示しています。Dual_Bankオプションは、TrustZoneが無効になっている場合にのみこのターゲットで使用できます(Tzen=0)。


フラッシュメモリは、2つの異なるバンクにセグメント化されています。


 - バンク0：(0x08000000) 
 - バンク1：(0x08100000)


Bank 0にはアドレス0x08000000にブートローダーが含まれ、アドレス0x08100000にアプリケーションが含まれています。有効なイメージがバンク1の同じオフセットで利用可能な場合、2つの有効なイメージ間で起動するために候補として0x08108000が選択されます。

サンプルプログラムのコンフィギュレーションファイルは config/examples/stm32u5-nonsecure-dualbank.config を使います。

    
1. イメージ./test-app/image.bin をフラッシュ 0x08000000に配置します
```
STM32_Programmer_CLI -c port=swd -d ./test-app/image.elf 0x08000000
```

あるいは各パーティションを以下のよにプログラムします
- イメージ wolfboot.bin をフラッシュ0x08000000に配置
```
STM32_Programmer_CLI -c port=swd -d ./wolfboot.elf
```
- イメージimage_v1_signed.binをフラッシュ0x08008000に配置
```
STM32_Programmer_CLI -c port=swd -d ./test-app/image_v1_signed.bin 0x08008000
```

2. 赤色LED LD9が点灯してブートの成功を示します。


#### デバッグ

以下のコマンドでファームウェアをリロードします。
```
make DEBUG=1
```

STM32CubeIDE v.1.7.0 が必要です。
デバッガーは各OSで以下のように起動します：

Linux:
```
ST-LINK_gdbserver -d -cp /opt/st/stm32cubeide_1.3.0/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_1.3.0.202002181050/tools/bin -e -r 1 -p 3333
```
Max OS/X:
```
sudo ln -s /Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.macos64_1.6.0.202101291314/tools/bin/native/mac_x64/libSTLinkUSBDriver.dylib /usr/local/lib/libSTLinkUSBDriver.dylib

/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.macos64_1.6.0.202101291314/tools/bin/ST-LINK_gdbserver -d -cp ./Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_1.6.0.202101291314/tools/bin -e -r 1 -p 3333
```
Windows：
```
ST-LINK_gdbserver -d -cp C:\ST\STM32CubeIDE_1.7.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_2.0.0.202105311346\tools\bin -e -r 1 -p 3333
```

arm-none-eabi-gdbに接続します

wolfBootは　.gdbinitファイルに以下の内容を含んでいます

```
arm-none-eabi-gdb
add-symbol-file test-app/image.elf
mon reset init
```


## STM32L0



STM32-L073で192KBパーティションの例


このデバイスは、単一のフラッシュページ(それぞれ256B)を消去できます。


ただし、スワップにロジックセクターサイズ4KBを使用して、スワップパーティションに書き込みの量を制限することを選択します。


この例`target.h`で提案されたジオメトリは、wolfBootに32KBを使用し、それぞれ64KBの2節を使用しているため、最大8KBのSwapに使用する余地があります(ここでは4Kが使用されています)。



```C
#define WOLFBOOT_SECTOR_SIZE                 0x1000   /* 4 KB */
#define WOLFBOOT_PARTITION_BOOT_ADDRESS      0x8000
#define WOLFBOOT_PARTITION_SIZE              0x10000 /* 64 KB */
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS    0x18000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS      0x28000
```


### STM32L0ビルド

```
make TARGET=stm32l0
```
を使用してビルドします。オプション`CORTEX_M0`が、このターゲットに対して自動的に選択されます。





## STM32G0



STM32G0x0x0/STM32G0x1をサポートします。


STM32-G070での例128KBパーティション：



-  セクターサイズ：2KB


-  wolfBootパーティションサイズ：32KB


-  アプリケーションパーティションサイズ：44KB




```C
#define WOLFBOOT_SECTOR_SIZE                 0x800   /* 2 KB */
#define WOLFBOOT_PARTITION_BOOT_ADDRESS      0x08008000
#define WOLFBOOT_PARTITION_SIZE              0xB000  /* 44 KB */
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS    0x08013000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS      0x0801E000
```




### STM32G0のビルド



リファレンスコンフィギュレーションとして`/config/examples/stm32g0.config`を参照してください。このコンフィギュレーションファイルをwolfBoot Rootに
```
cp ./config/examples/stm32g0.config .config
```
でコピーしてください。その後、makeコマンドを使用してビルドします。



これのターゲットは`stm32g0`：`make TARGET=stm32g0`です。オプション`CORTEX_M0`は、このターゲットに対して自動的に選択されます。オプション`NVM_FLASH_WRITEONCE=1`は、このターゲットで必須です。


このターゲットは、`FLASH_CR:SEC_PROT`および`FLASH_SECT:SEC_SIZE`レジスタを使用して、ブートローダー領域の安全なメモリ保護もサポートします。これは、0x8000000ベースアドレスからアクセスをブロックする2KBページの数です。



```
STM32_Programmer_CLI -c port=swd mode=hotplug -ob SEC_SIZE=0x10
```



RAMFUNCTIONのサポート(SEC_PROTに必要)の場合は、`RAM_CODE=1`を指定してください。


コンパイルは以下が必要です：

```
make TARGET=stm32g0 NVM_FLASH_WRITEONCE=1
```



### STM32G0のデバッグ

ビルド生成物はwolfboot.binとtest-app/image_v1_signed.binを併せたfactory.binの一つだけとなります。このイメージはフラッシュの0x08000000に配置する必要があります。
STM32CubeProgrammerを使ったコマンドラインは:

```
STM32_Programmer_CLI -c port=swd -d factory.bin 0x08000000
```

となります。

```
make DEBUG=1
```
を使用してファームウェアを再ビルドします。


GDBをポート3333で起動します:

```
ST-LINK_gdbserver -d -e -r 1 -p 3333
 or
st-util -p 3333
```


wolfBootは、GDB構成のための.gdbinitがあります。


```
arm-none-eabi-gdb
add-symbol-file test-app/image.elf 0x08008100
mon reset init
```



## STM32WB55



Nucleo-68ボードでの分割の例：


-  セクターサイズ：4KB
-  wolfBootパーティションサイズ：32KB
-  アプリケーションパーティションサイズ：128KB



```C
#define WOLFBOOT_SECTOR_SIZE                 0x1000   /* 4 KB */
#define WOLFBOOT_PARTITION_BOOT_ADDRESS      0x8000
#define WOLFBOOT_PARTITION_SIZE              0x20000 /* 128 KB */
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS    0x28000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS      0x48000
```



### STM32WB55ビルド


TARGET=stm32wbを指定してmakeします。


IAPドライバーは、各消去操作の後にMultipleをサポートしていないため、オプション`NVM_FLASH_WRITEONCE=1`はこのターゲットで必須です。


ビルド：

```
make TARGET=stm32wb NVM_FLASH_WRITEONCE=1
```




### STM32WB55 をOpenOCDで使う


```
openocd --file ./config/openocd/openocd_stm32wbx.cfg
```


```
telnet localhost 4444
reset halt
flash write_image unlock erase factory.bin 0x08000000
flash verify_bank 0 factory.bin
reset
```




### STM32WB55をST-Linkdeで使う



```
git clone https://github.com/stlink-org/stlink.git
cd stlink
cmake .
make
sudo make install
```




```
st-flash write factory.bin 0x08000000
# Start GDB server
st-util -p 3333
```




### STM32WB55デバッグ



`make DEBUG=1`を使用してファームウェアをリロードします。


wolfBootは、GDB構成のための.gdbinitがあります。

```
arm-none-eabi-gdb
add-symbol-file test-app/image.elf 0x08008100
mon reset init
```






## SiFive HiFive1 RISC-V




### 機能


* E31 RISC-V 320MHz 32ビットプロセッサ


* オンボード16kbスクラッチパッドRAM


* 外部4MB QSPIフラッシュ




### デフォルトのリンカー設定


* フラッシュ：アドレス0x20000000、サイズ 0x6a120(424KB)
* RAM：アドレス0x80000000、サイズ 0x4000(16KB)




### ストックブートローダー

アドレスの開始：0x20000000は64KBです。「ダブルタップ」リセット機能を提供して、HALTブートを使用し、デバッガーが再プログラミングのために接続できるようにします。リセットボタンを押すと、緑色に点灯します、そこで再びリセットボタンを押すと、ボードは赤い点滅を始めます。



### アプリケーションコード

アドレスの開始：0x20010000



### wolfBoot構成



デフォルトのwolfBoot構成により、セカンドステージブートローダーが追加され、ストックは「ダブルタップ」ブートローダーを回復のためのフォールバックとして残します。制作の実装は、これを`target.h`のパーティションアドレスとパーティションアドレスに置き換える必要があるため、`0x10000`だけ少なくなります。


Freedom SDKの場所を設定するには、`FREEDOM_E_SDK=~/src/freedom-e-sdk`を使用します。


wolfBootをテストするために必要な変更は次のとおりです。



1. MakeFileの引数：

* ARCH=RISCV
* TARGET= hifive1



    ```
    make ARCH=RISCV TARGET=hifive1 RAM_CODE=1 clean
    make ARCH=RISCV TARGET=hifive1 RAM_CODE=1
    ```



riscv64-unknown-elf-`クロスコンパイラを使用する場合は、`make`に`CROSS_COMPILE=riscv64-unknown-elf-`を追加するか、次のように`arch.mk`を変更できます。

```
ifeq ($(ARCH),RISCV)
-  CROSS_COMPILE:=riscv32-unknown-elf-
+  CROSS_COMPILE:=riscv64-unknown-elf-
```


2. `include/target.h`



ブートローダーサイズ：0x10000(64KB)アプリケーションサイズ0x40000(256KB)スワップセクターサイズ：0x1000(4KB)



```c
#define WOLFBOOT_SECTOR_SIZE                 0x1000
#define WOLFBOOT_PARTITION_BOOT_ADDRESS      0x20020000
#define WOLFBOOT_PARTITION_SIZE              0x40000
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS    0x20060000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS      0x200A0000
```


### ビルドオプション




* ED25519の代わりにECCを使用するには、引数`SIGN=ECC256`を作成します


* JLinkを使用するためのヘックスとしてwolfbootを出力するには、引数`wolfboot.hex`を指定します




### ロード



JLinkでロードする：


```
JLinkExe -device FE310 -if JTAG -speed 4000 -jtagconf -1,-1 -autoconnect 1
loadbin factory.bin 0x20010000
rnh
```


### デバッグ



Jlinkでのデバッグ：


1つの端末：

```
JLinkGDBServer -device FE310 -port 3333
```


別の端末で：

```
riscv64-unknown-elf-gdb wolfboot.elf -ex "set remotetimeout 240" -ex "target extended-remote localhost:3333"
add-symbol-file test-app/image.elf 0x20020100
```






## STM32F7



STM32-F76xおよびF77xは、デュアルバンクハードウェアアシストスワッピング機能を提供します。フラッシュジオメトリを事前に定義する必要があり、wolfBootをコンパイルして、HardWareAssisted Bank-Swappingを使用して更新を実行できます。




STM32-F769での2MBパーティションの例：



-  デュアルバンク構成


    - バンクA：0x08000000〜0x080ffffff(1MB)
    - バンクB：0x08100000〜0x081ffffff(1MB)


-  wolfBootは再起動後にバンクAから実行されます(アドレス：0x08000000)


-  ブートパーティション @バンクA + 0x20000=0x08020000


-  Partition@Bank B + 0x20000=0x08120000を更新します


-  アプリケーションエントリポイント：0x08020100




```C
#define WOLFBOOT_SECTOR_SIZE              0x20000
#define WOLFBOOT_PARTITION_SIZE           0x40000
#define WOLFBOOT_PARTITION_BOOT_ADDRESS   0x08020000
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS 0x08120000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS   0x0   /* Unused, swap is hw-assisted */
```




### ビルドオプション



STM32F76x/77xでデュアルバンクハードウェアアシストスワップ機能を有効にするには、The`DUALBANK_SWAP=1`コンパイル時オプションを使用します。一部のコードでは、イメージのスワッピング中にRAMで実行する必要があるため、この場合にはコンパイル時オプション`RAMCODE=1`も必要です。


デュアルバンクSTM32F7ビルドは、以下を使用してビルドできます。



```
make TARGET=stm32f7 DUALBANK_SWAP=1 RAM_CODE=1
```




### ファームウェアのロード



シングルバンク(1x2MB)とデュアルバンク(2 x 1MB)モードマッピングを切り替えるには、この[STM32F7-DUALBANK-TOOL](https://github.com/danielinux/stm32f7-dualbank-tool)を使用することができます。OpenOCDを開始する前に、フラッシュモードをデュアルバンクに切り替えます(例：デュアルバンクツールを使用して`make dualbank`を介して)。


Flashing/DebuggingのOpenOCD構成は、作業ディレクトリの`openocd.cfg`にコピーできます。



```
source [find interface/stlink.cfg]
source [find board/stm32f7discovery.cfg]
$_TARGETNAME configure -event reset-init {
    mmw 0xe0042004 0x7 0x0
}
init
reset
halt
```



OpenOCDは、コマンドラインから順番にターミナルスクリプトを実行するために、バックグラウンドで実行し、端子接続を監視し、端子接続を監視するために実行できます。

OpenOCDが実行されている場合、ローカルTCPポート4444を使用して、インタラクティブ端末プロンプトにアクセスできます。`telnet localhost 4444`

次のOpenOCDコマンドを使用して、wolfBootの初期イメージとBank 0でフラッシュするためにロードされたテストアプリケーションがロードされます。



```
flash write_image unlock erase wolfboot.bin 0x08000000
flash verify_bank 0 wolfboot.bin
flash write_image unlock erase test-app/image_v1_signed.bin 0x08020000
flash verify_bank 0 test-app/image_v1_signed.bin 0x20000
reset
resume 0x0000001
```



新しいバージョン(2)と同じアプリケーションイメージに署名するには、以下のコマンドでPythonスクリプト`sign.py`を使用してください。



```
tools/keytools/sign.py test-app/image.bin ed25519.der 2
```



OpenOCDから、更新されたイメージ(バージョン2)を2番目のバンクにフラッシュ書き込みできます。

```
flash write_image unlock erase test-app/image_v2_signed.bin 0x08120000
flash verify_bank 0 test-app/image_v1_signed.bin 0x20000
```



再起動すると、wolfBootは最高の候補者(この場合はバージョン2)を選択し、イメージを認証します。受け入れられた候補のイメージがBank Bに存在する場合(この場合など)、wolfBootはブート前に1つのバンク交換を実行します。


この場合、バンクのスワップ操作は即時であり、スワップイメージは必要ありません。フォールバックメカニズムは、他のバンクの2番目の選択肢(古いファームウェア)に依存する可能性があります。



### STM32F7デバッグ



OpenOCDでのデバッグ：


前のセクションのOpenOCD構成を使用して、OpenOCDを実行します。


別のコンソールから、GDBを使用して接続します。例えば：



```
arm-none-eabi-gdb
(gdb) target remote:3333
```






## STM32H7



STM32H7フラッシュジオメトリを事前に定義する必要があります。


"make config"を使用して.configファイルを生成するか、テンプレートコンフィギュレーションファイルをコピーします。

```
cp ./config/examples/stm32h7.config .config
```


STM32-H753での例2MBパーティション：



```
WOLFBOOT_SECTOR_SIZE?=0x20000
WOLFBOOT_PARTITION_SIZE?=0xD0000
WOLFBOOT_PARTITION_BOOT_ADDRESS?=0x8020000
WOLFBOOT_PARTITION_UPDATE_ADDRESS?=0x80F0000
WOLFBOOT_PARTITION_SWAP_ADDRESS?=0x81C0000
```




### ビルドオプション



STM32H7ビルドは、以下を使用してビルドできます。



```
make TARGET=stm32h7 SIGN=ECC256
```

### STM32H7のプログラミング

ST-Link Flash Toolを使った書き込み:

```
st-flash write factory.bin 0x08000000
```
あるいは

```
st-flash write wolfboot.bin 0x08000000
st-flash write test-app/image_v1_signed.bin 0x08020000
```

### STM32H7のテスト

新しいバージョン(2)と同じアプリケーションイメージに署名するには、以下のコマンドでPythonスクリプト`sign.py`を使用してください。


Python:
```
tools/keytools/sign.py test-app/image.bin ed25519.der 2
```

C Tool:

```
tools/keytools/sign --ecc256 --sha256 test-app/image.bin wolfboot_signing_private_key.der 2
```

更新イメージバージョン２を書き込みます：

```
st-flash write test-app/image_v2_signed.bin 0x08120000
```

リブート時にはwolfBootが最も適したアプリケーションイメージ（この場合にはバージョン２）を選択して認証します。認証に成功すると、イメージはバンクBに残りwolfBootがブート前にスワップを実行します。




### STM32H7デバッグ


1. GDBサーバーを起動

```
st-util -p 3333
```

2. GDBクライアントをwolfBootのルートフォルダから起動

```
arm-none-eabi-gdb
add-symbol-file test-app/image.elf 0x08020000
mon reset init
b main
c
```



## NXP LPC54xxx




### ビルドオプション



LPC54XXXビルドは、コンパイル時にCPUタイプとMCUXPresso SDKパスを指定して実行します。


次の構成は、LPC54606J512BD208に対してテストされています。



```
make TARGET=lpc SIGN=ECC256 MCUXPRESSO?=/path/to/LPC54606J512/SDK
    MCUXPRESSO_CPU?=LPC54606J512BD208 \
    MCUXPRESSO_DRIVERS?=$(MCUXPRESSO)/devices/LPC54606 \
    MCUXPRESSO_CMSIS?=$(MCUXPRESSO)/CMSIS
```




### ファームウェアのロード



Jlinkのロード(例：LPC54606J512)



```
JLinkExe -device LPC606J512 -if SWD -speed 4000
erase
loadbin factory.bin 0
r
h
```




### Jlinkでデバッグ




```
JLinkGDBServer -device LPC606J512 -if SWD -speed 4000 -port 3333
```



次に、別のコンソールから：



```
arm-none-eabi-gdb wolfboot.elf -ex "target remote localhost:3333"
(gdb) add-symbol-file test-app/image.elf 0x0000a100
```






## Cortex-a53/raspberry pi 3(実験)



Ubuntu20 上で`https://github.com/raspberrypi/linux`を使用してテストしました

前提条件として以下が必要です。

```
sudo apt install gcc-aarch64-linux-gnu qemu-system-aarch64
```

### カーネルをコンパイル




* Raspberry-Pi Linuxカーネルを入手：




```
git clone https://github.com/raspberrypi/linux linux-rpi -b rpi-4.19.y --depth=1
```




* カーネルイメージをビルド：




```
export wolfboot_dir=`pwd`
cd linux-rpi
patch -p1 < $wolfboot_dir/tools/wolfboot-rpi-devicetree.diff
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
```




* イメージと.dtbをwolfbootディレクトリにコピーします




```
cp Image arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb $wolfboot_dir
cd $wolfboot_dir
```




### qmenu-System-aarch64でのテスト




* サンプル構成(RSA4096、SHA3)を使用してwolfBootをビルド




```
cp config/examples/raspi3.config .config
make clean
make wolfboot.bin CROSS_COMPILE=aarch64-linux-gnu-
```




* Linuxカーネルイメージに署名


```
make keytools
./tools/keytools/sign --rsa4096 --sha3 Image wolfboot_signing_private_key.der 1
```




* イメージ作成


```
tools/bin-assemble/bin-assemble wolfboot_linux_raspi.bin 0x0 wolfboot.bin 0xc0000 Image_v1_signed.bin
dd if=bcm2710-rpi-3-b.dtb of=wolfboot_linux_raspi.bin bs=1 seek=128K conv=notrunc
```




* qmenuを使用したテストブート




```
qemu-system-aarch64 -M raspi3 -m 512 -serial stdio -kernel wolfboot_linux_raspi.bin -append "terminal=ttyS0 rootwait" -dtb ./bcm2710-rpi-3-b.dtb -cpu cortex-a53
```



## Xilinx Zynq Ultrascale



Xilinx UltraScale+ ZCU102(Aarch64)


構成オプションをビルドする(`.config`)：



```
TARGET=zynq
ARCH=AARCH64
SIGN=RSA4096
HASH=SHA3
```




### QNX




```sh
cd ~
source qnx700/qnxsdp-env.sh
cd wolfBoot
cp ./config/examples/zynqmp.config .config
make clean
make CROSS_COMPILE=aarch64-unknown-nto-qnx7.0.0-
```




#### デバッグ


```
qemu-system-aarch64 -M raspi3 -kernel /path/to/wolfboot/factory.bin -serial stdio -gdb tcp::3333 -S
```




#### 署名



`tools/keytools/sign.py --rsa4096 --sha3 /srv/linux-rpi4/vmlinux.bin rsa4096.der 1`





## CypressPSOC-6



Cypress PSOC 62S2は、デュアルコアCortex-M4＆Cortex-M0+ MCUです。Secure Bootプロセスは、M0+.wolfBootによって管理され、アプリケーションの確認とファームウェアの更新を管理するために、Second Stage Flash ブートローダとしてコンパイルできます。



### ビルド



次の構成は、PSOC 62S2 Wi-Fi BT Pioneer Kit(CY8CKIT-052S2-43012)を使用してテストされています。



#### ターゲット固有の要件



wolfBootは、次のコンポーネントを使用して、PSoCの周辺機能にアクセスします：


* [Cypress コアライブラリ](https://github.com/cypresssemiconductorco/core-lib) 
* [PSoC 6 周辺ドライバーライブラリ](https://github.com/cypresssemiconductorco/psoc6pdl)
* [CY8CKIT-062S2-43012 BSP](https://github.com/cypresssemiconductorco/TARGET_CY8CKIT-062S2-43012)


Cypressは、フラッシュとデバッグをプログラミングするための[カスタマイズ済みOpenOCD](https://github.com/cypresssemiconductorco/Openocd)を提供します。



### クロック設定



wolfBootは、PLL1を100 MHzで実行するように構成し、その周波数で`CLK_FAST`、`CLK_PERI`、および`CLK_SLOW`を駆動しています。



#### ビルドコンフィグレーション



次のコンフィグレーションは、PSoC CY8CKIT-62S2-43012でテストされています:



```
make TARGET=psoc6 \
    NVM_FLASH_WRITEONCE=1 \
    CYPRESS_PDL=./lib/psoc6pdl \
    CYPRESS_TARGET_LIB=./lib/TARGET_CY8CKIT-062S2-43012 \
    CYPRESS_CORE_LIB=./lib/core-lib \
    WOLFBOOT_SECTOR_SIZE=4096
```



注：コンフィギュレーションファイル`.config`は`/config/examples/cypsoc6.config`にあります。


ハードウェアアクセラレーションは、PSoC6 Crypto HWサポートを使用してデフォルトで有効になります。


ハードウェアアクセラレーションを無効にしてコンパイルするには、wolfBootのコンフィグレーションで次のオプションを使用してください。


`PSOC6_CRYPTO=0`






#### OpenOCDインストール



カスタマイズ済みOpenOCDをコンパイルしてインストールします。


`openocd`を実行しているときに次のコンフィギュレーションファイルを使用して、PSoC6ボードに接続します:



```
### openocd.cfg for PSoC-62S2
source [find interface/kitprog3.cfg]
transport select swd
adapter speed 1000
source [find target/psoc6_2m.cfg]
init
reset init
```




### ファームウェアのロード



`factory.bin`をOpenOCDでデバイスにアップロードするには、デバイスを接続し、OpenOCDを前のセクションから構成とともに実行し、`telnet localhost 4444`を使用してTCPポート4444で実行されているローカルOpenOCDサーバーに接続します。


Telnetコンソールから、次を入力：


```
program factory.bin 0x10000000
```

転送が終了したら、OpenOCDを閉じるか、デバッグセッションを開始できます。



### デバッグ



OpenOCDでのデバッグ：


OpenOCDを実行するには、以前のセクションのOpenOCD構成を使用します。


別のコンソールから、GDBを使用して接続します、例えば：



```
arm-none-eabi-gdb
(gdb) target remote:3333
```



ボードをリセットして、M0+フラッシュブートローダーの位置(wolfBoot reset handler)から開始するには、以下のモニターコマンドシーケンスを使用します。



```
(gdb) mon init
(gdb) mon reset init
(gdb) mon psoc6 reset_halt
```






## NXP IMX-RT



NXP RT1060/1062およびRT1050


NXP IMX-RT1060は、SHA256アクセラレータであるDCPコプロセッサを備えたARM Cortex-M7です。このターゲットのサンプルコンフィグレーションファイルは`/config/examples/imx-rt1060.config`で提供されます。



### wolfBootのビルド



wolfBootがこのプラットフォーム上のデバイスドライバーにアクセスするためにはMCUXPresso SDKが必要です。パッケージは、ターゲットを選択し、コンポーネントのデフォルトの選択を維持することにより、[MCUXpresso SDK Builder](https://mcuxpresso.nxp.com/en/welcome)から取得できます。



* RT1060を使用するには`EVKB-IMXRT1060`を使用します。`config/examples/imx-rt1060.config`のコンフィグレーション例を参照してください。


* RT1050を使用するには`EVKB-IMXRT1050`を使用します。`config/examples/imx-rt1050.config`のコンフィグレーション例を参照してください。



wolfBoot `MCUXPRESSO` コンフィグレーション変数をSDKパッケージが抽出されるパスに設定し、`make`を実行してwolfBootを通常ビルドします。


iMX-RT1060/iMX-RT1050のwolfBootサポートは、MCUXPresso SDKバージョン2.11.1を使用してテストされています。


DCPサポート(SHA256のハードウェアアクセラレーション)は、コンフィグレーションファイルでPKA=1を使用して有効にできます。ファームウェアは、`factory.bin`をデバイスに関連付けられた仮想USBドライブにコピーすることにより、ターゲットに直接アップロードできます。





## NXP Kinetis



暗号ハードウェアアクセラレーションでK64とK82をサポートします。



### ビルドオプション



サンプルプログラムのコンフィギュレーションファイルは、`/config/examples/kinetis-k82f.config`を参照してください。


ターゲットは`kinetis`です。LTC PKAをサポートする場合には`PKA=`　で指定します。


MCUXpresso構成については、`MCUXPRESSO`、`MCUXPRESSO_CPU`、`MCUXPRESSO_DRIVERS`、`MCUXPRESSO_CMSIS`を設定します。



### K82のパーティション分割の例




```
WOLFBOOT_PARTITION_SIZE?=0x7A000
WOLFBOOT_SECTOR_SIZE?=0x1000
WOLFBOOT_PARTITION_BOOT_ADDRESS?=0xA000
WOLFBOOT_PARTITION_UPDATE_ADDRESS?=0x84000
WOLFBOOT_PARTITION_SWAP_ADDRESS?=0xff000
```




## NXP T2080 PPC



T2080はPPC e6500ベースのプロセッサです。


このターゲットのコンフィギュレーションファイルは、`/config/examples/t2080.config`で提供されます。



### wolfBootのビルド



wolfBootは、gcc powerpcツールでビルドできます。たとえば、`aptinstall gcc-powerpc-linux-gnu`。これでmakeが正しいツールを使ってビルドできます。



## TI Hercules TMS570LC435



サンプルプログラムのコンフィギュレーションファイルについては、`/config/examples/ti-tms570lc435.config`を参照してください。





## QEMU X86-64 UEFI



UEFI biosを備えたX86-64ビットマシンは、EFIアプリケーションとしてwolfBootを実行できます。



### 前提要件:



* Qemu-system-x86_64
* [gnu-efi](https://sourceforge.net/projects/gnu-efi/)
* [Open Virtual Machine firmware bios images (OVMF)](https://tianocore.org/)

Debianのようなシステムでは、次のようにパッケージをインストールするだけで十分です。

```
# for wolfBoot and others
apt install git make gcc

# for test scripts
apt install sudo dosfstools curl
apt install qemu qemu-system-x86 ovmf gnu-efi

# for buildroot
apt install file bzip2 g++ wget cpio unzip rsync bc
```



### コンフィグレーション



サンプルプログラムのコンフィギュレーションファイルは`config/examples/x86_64_efi.config`で提供されます



### qemuを使ってのビルドと実行



EFI環境で実行するためのブートローダーと初期化スクリプト`startup.nsh`は、ループバックFATパーティションに保存されます。


スクリプト`tools/efi/prepare_uefi_partition.sh`は、新しい空のFATループバックパーティションを作成し、`startup.nsh`を追加します。


埋め込まれたrootfsパーティションを備えたカーネルを作成して、スクリプト`tools/efi/compile_efi_linux.sh`を介してイメージに追加できます。スクリプトは、実際にターゲットシステムの2つのインスタンスを追加します：`kernel.img`および`update.img`は、両方とも認証に署名し、それぞれバージョン`1`および`2`でタグ付けされています。


`make`でコンパイルすると、`wolfboot.efi`にブートローダーイメージが生成されます。




スクリプト`tools/efi/run_efi.sh`は、`wolfboot.efi`をブートローダーループバックパーティションに追加し、QEMUでシステムを実行します。両方のカーネルイメージが存在していて有効な場合、wolfBootはより高いバージョン番号を使用してイメージを選択します。そのため、`update.img`はバージョン`2`でタグ付けされたときにステージングされます。


シーケンスを以下にまとめます。



```
cp config/examples/x86_64_efi.config .config
tools/efi/prepare_efi_partition.sh
make
tools/efi/compile_efi_linux.sh
tools/efi/run_efi.sh
```

```
EFI v2.70 (EDK II, 0x00010000)
[700/1832]
Mapping table
      FS0: Alias(s):F0a:;BLK0:
          PciRoot(0x0)/Pci(0x1,0x1)/Ata(0x0)
     BLK1: Alias(s):
               PciRoot(0x0)/Pci(0x1,0x1)/Ata(0x0)
Press ESC in 1 seconds to skip startup.nsh or any other key to continue.
Starting wolfBoot EFI...
Image base: 0xE3C6000
Opening file: kernel.img, size: 6658272
Opening file: update.img, size: 6658272
Active Part 1
Firmware Valid
Booting at 0D630000
Staging kernel at address D630100, size: 6658016
```

Ctrol-Cあるいはrootとしてログインし、poweroffでqemuを終了します。

## Nordic nRF52840

ContikiとRIOT-OS向けのNordic nRF5280 サンプルプログラムを[wolfBoot-example repo](https://github.com/wolfSSL/wolfboot-examples)で提供しています。

nRF52用サンプルプログラム:
* RIOT-OS: https://github.com/wolfSSL/wolfBoot-examples/tree/master/riotOS-nrf52840dk-ble
* Contiki-OS: https://github.com/wolfSSL/wolfBoot-examples/tree/master/contiki-nrf52

nRF52向けフラッシュメモリレイアウト例：

* 0x000000 - 0x01efff : Reserved for Nordic SoftDevice binary
* 0x01f000 - 0x02efff : Bootloader partition for wolfBoot
* 0x02f000 - 0x056fff : Active (boot) partition
* 0x057000 - 0x057fff : Unused
* 0x058000 - 0x07ffff : Upgrade partition

```
#define WOLFBOOT_SECTOR_SIZE              4096
#define WOLFBOOT_PARTITION_SIZE           0x28000

#define WOLFBOOT_PARTITION_BOOT_ADDRESS   0x2f000
#define WOLFBOOT_PARTITION_SWAP_ADDRESS   0x57000
#define WOLFBOOT_PARTITION_UPDATE_ADDRESS 0x58000
```

## シミュレートターゲット

内部あるいは外部フラッシュメモリを模したファイルを使うシミュレートターゲットを生成することができます。ビルドするとwolfBoot.elfファイルを生成します。また、別のファームウエアイメージとして実行可能なELFファイルを提供することもできます。サンプルプログラム test-app/app_sim.cはlibwolfboot.cと対話するために引数を使用し、機能テストを自動化します。このサンプルプログラムのコンフィギュレーションファイルはconfig/examples/sim.configを参照してください。

test-app/sim.cを使ったファームウェア更新プログラムは以下をコマンドで生成します：
```
cp ./config/examples/sim.config .config
make

# create the file internal_flash.dd with firmware v1 on the boot partition and
# firmware v2 on the update partition
make test-sim-internal-flash-with-update
# it should print 1
./wolfboot.elf success get_version
# trigger an update
./wolfboot.elf update_trigger
# it should print 2
./wolfboot.elf success get_version
# it should print 2
./wolfboot.elf success get_version
```