# wolfTPMのビルド

 wolfTPM ライブラリをビルドするには、最初に wolfSSL ライブラリをビルドしてインストールする必要があります。この [ダウンロードページ](https://wolfssl.jp/download/), から取得するか"git clone" コマンドを使ってクローンしてください:
```
$ git clone https://github.com/wolfssl/wolfssl
```

wolfSSL ライブラリをダウンロードしたら、configure スクリプトに次のオプションを渡してビルドします：
```
$ cd wolfssl
$ ./configure --enable-wolftpm
```
または同等の、次のオプションを使用します:

```
$ ./configure --enable-certgen --enable-certreq --enable-certext
--enable-pkcs7 --enable-cryptocb --enable-aescfb
```
次に、wolfSSL ライブラリをビルドしてインストールするだけで、ユーザーの好みに応じてインストールできます。

次のステップは、wolfTPM ライブラリをダウンロードしてインストールすることです。 wolfTPM は、同様に次の Web サイトからダウンロードできます [ダウンロードページ](https://wolfssl.jp/download/) あるいはGitHubからクローンします。次のコマンドでwolfTPMをビルドします:
```
$ git clone https://github.com/wolfssl/wolftpm
$ cd wolftpm
$ ./autogen.sh
$ ./configure
$ make
```

### ビルドオプションとマクロ定義

```
--enable-debug          デバッグ出力を有効にする/最適化をオフにする
                        --enable-debug=yes|no|verbose|io が指定可
                        これらは次のマクロ定義と同義： DEBUG_WOLFTPM, WOLFTPM_DEBUG_VERBOSE, WOLFTPM_DEBUG_IO

--enable-examples       サンプルプログラムもビルドする(デフォルトで有効)

--enable-wrapper        ラッパーコードを有効にする(デフォルトで有効)
　　　　　　　　　　　　　無効にする場合には次のマクロを定義: WOLFTPM2_NO_WRAPPER

--enable-wolfcrypt      wolfCryptのRNG,セッション認証、パラメータ暗号化に関するフック関数を有効化する(デフォルトで有効)
                        無効にする場合には次のマクロを定義:WOLFTPM2_NO_WOLFCRYPT

--enable-advio          アドバンストIOを有効にする(デフォルトで無効)
　　　　　　　　　　　　　次のマクロ定義と同義：WOLFTPM_ADV_IO

--enable-i2c            I2C TPM のサポートを有効にする(デフォルトで無効)。加えてadvioを有効化も必要
                        次のマクロ定義と同義：WOLFTPM_I2C

--enable-checkwaitstate TIS / SPI Check Wait Stateを有効化する(デフォルトではチップに依存する)
                        次のマクロ定義と同義：WOLFTPM_CHECK_WAIT_STATE

--enable-smallstack     スタック使用量を削減する

--enable-tislock        Linuxの名前付きセマフォをSPIドライバーのプロセス間排他ロックに使用 
                        次のマクロ定義と同義：WOLFTPM_TIS_LOCK

--enable-autodetect     実行時モジュール検出を有効にする(デフォルトで有効。モジュールが指定されない場合)
                        次のマクロ定義と同義：WOLFTPM_AUTODETECT

--enable-infineon       Infineon SLB9670 TPM のサポートを有効化する(デフォルトで無効)

--enable-st             ST ST33TPM のサポートを有効化する(デフォルトで無効)
                        次のマクロ定義と同義：WOLFTPM_ST33

--enable-microchip      Enable Microchip ATTPM20のサポートを有効化する(デフォルトで無効)
                        次のマクロ定義と同義：WOLFTPM_MCHP

--enable-nuvoton        Nuvoton NPCT65x/NPCT75x のサポートを有効化する(デフォルトで無効)
                        次のマクロ定義と同義： WOLFTPM_NUVOTON

--enable-devtpm         Linux /dev/tpmX用カーネルドライバーのサポートを有効化する(デフォルトで無効)
                        次のマクロ定義と同義：WOLFTPM_LINUX_DEV

--enable-swtpm          SWTPM TCP protocolのサポートを有効化する(デフォルトで無効) 
                        次のマクロ定義と同義： WOLFTPM_SWTPM

--enable-winapi         Windows TBS APIを使用する (デフォルトで無効)
                        次のマクロ定義と同義： WOLFTPM_WINAPI

WOLFTPM_USE_SYMMETRIC   TLSサンプルプログラムで対称　AES/Hashing/HMAC のサポートを有効化する

WOLFTPM2_USE_SW_ECDHE   TLSサンプルプログラムでECCエフェメラル鍵の生成とシェアードシークレットの生成にTPMを使用しない

TLS_BENCH_MODE          TLSベンチマークを有効にする

NO_TPM_BENCH            TPMのベンチマークサンプルプログラムを無効にする
```

### Infineon SLB9670向けビルド

以下のコマンドでwolfTPMをビルド:<br>

```
git clone https://github.com/wolfSSL/wolfTPM.git
cd wolfTPM
./autogen.sh
./configure
make
```

### ST ST33TP* 向けビルド

以下のコマンドでwolfTPMをビルド:

```
./autogen.sh
./configure --enable-st33 [--enable-i2c]
make
```

Raspberry Pi上のI2C向けにビルドする際にはIC2を有効にする必要があります。以下がその手順です：<br>
1. `sudo vim /boot/config.txt`　で編集します。<br>
2. `dtparam=i2c_arm=on`　の行のコメントを外し有効にします。<br>
3. `sudo reboot`　で再起動します。<br>

### Microchip ATTPM20 向けビルド

以下のコマンドでwolfTPMをビルド:

```
./autogen.sh
./configure --enable-microchip
make
```

### Nuvoton向けビルド

以下のコマンドでwolfTPMをビルド:<br>

```
./autogen.sh
./configure --enable-nuvoton
make
```

### "/dev/tpmX"向けビルド

次のビルドオプションはLinux TIS カーネルドライバーでサポートされているいずれのTPMベンダーに対して使用できます。<br>

以下のコマンドでwolfTPMをビルド:<br>

```
./autogen.sh
./configure --enable-devtpm
make
```
注意：Linuxカーネルドライバーを通してTPMデバイスを使用する際にはwolfTPMを使用するアプリケーションに対して必要なパーミッションが付与されていることを確認してください。何故なら通常、"/dev/tpmX"は"tss"ユーザーグループにのみRead/Writeパーミッションが与えられているからです。wolfTPMのサンプルプログラムを"sudo"コマンドと共に実行するかあるいはユーザーを次のようにして"tss"グループに追加する必要があります：<br>


```
sudo adduser yourusername tss
```

#### QEMU と swtpmを使ってのビルド



以下ではQEMU上でwolfTPMを使いlinuxカーネルデバイスの"/dev/tpmX"を使うデモンストレーションを行います。これには[swtpm](https://github.com/stefanberger/swtpm)のインストールかビルドが必要です。以下の手順は短いビルドの手順の一つを示したものです。操作には[libtpms](https://github.com/stefanberger/libtpms/wiki#compile-and-install-on-linux)と[swtpm](https://github.com/stefanberger/swtpm/wiki#compile-and-install-on-linux)を参照する必要があります。<br>


```
PREFIX=$PWD/inst
git clone git@github.com:stefanberger/libtpms.git
cd libtpms/
./autogen.sh --with-openssl --with-tpm2 --prefix=$PREFIX && make install
cd ..
git clone git@github.com:stefanberger/swtpm.git
cd swtpm
PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ ./autogen.sh --with-openssl --with-tpm2 \
    --prefix=$PREFIX && \
  make install
cd ..
```
基本的なLinuxインストールをセットアップします。他のインストールベースをインストールしてもかまいません。このセットアップには時間を要します。


```
# ミニインストールイメージをダウンロード
curl -O http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/mini.iso
# qemuイメージファイルを作成
qemu-img create -f qcow2 lubuntu.qcow2 5G
# tpm用にディレクトリを作成
mkdir $PREFIX/mytpm
# swtpmを実行
$PREFIX/bin/swtpm socket --tpm2 --tpmstate dir=$PREFIX/mytpm \
  --ctrl type=unixio,path=$PREFIX/mytpm/swtpm-sock --log level=20 &
# インストールのためにqemuを起動
qemu-system-x86_64 -m 1024 -boot d -bios bios-256k.bin -boot menu=on \
  -chardev socket,id=chrtpm,path=$PREFIX/mytpm/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 -hda lubuntu.qcow2 -cdrom mini.iso
```
ベースシステムがインストールされたら、qemuを実行する準備が整ったので、qemuインスタンス中からwolfSSLとwolfTPMをビルドします。<br>

```
# swtpm を再スタート
$PREFIX/bin/swtpm socket --tpm2 --tpmstate dir=$PREFIX/mytpm \
  --ctrl type=unixio,path=$PREFIX/mytpm/swtpm-sock --log level=20 &
# wolfTPMをインストールして起動するためにqemu システムをスタート
qemu-system-x86_64 -m 1024 -boot d -bios bios-256k.bin -boot menu=on \
  -chardev socket,id=chrtpm,path=$PREFIX/mytpm/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 -hda lubuntu.qcow2
```


以下のコマンドでQEMUターミナルでwolfTPMをチェックアウトしてビルドします：

```
sudo apt install automake libtool gcc git make

# wolfSSLを取得してビルド
git clone https://github.com/wolfssl/wolfssl.git
pushd wolfssl
./autogen.sh && \
  ./configure --enable-wolftpm --disable-examples --prefix=$PWD/../inst && \
  make install
popd

# wolfTPMを取得してビルド
git clone https://github.com/wolfssl/wolftpm.git
pushd wolftpm
./autogen.sh && \
  ./configure --enable-devtpm --prefix=$PWD/../inst --enable-debug && \
  make install
sudo make check
popd
```
次のコマンドでQEMUでサンプルプログラムを実行できます。`sudo ./examples/wrap/wrap`　`/dev/tpm0`へのアクセスには"sudo"を付加する必要になる場合があります。<br>


### SWTPM向けにビルド

wolfTPMは次の仕様書のD.3章に記載のSW TPMとインターフェイスすることが可能。
[TPM-Rev-2.0-Part-4-Supporting-Routines-01.38-code](https://trustedcomputinggroup.org/wp-content/uploads/TPM-Rev-2.0-Part-4-Supporting-Routines-01.38-code.pdf)

SWTPMに接続するソケットは排他的に使用しなければならず、TISあるいはdevtpmとはコンパチブルではありません。<br>

wolTPMのテストでは機能のサブセットのみがサポートされています。プラットフォームの要求事項はwolfTPMでは使用されません。<br>


テストでは次の二つの実装が使用されます：<br>

* https://sourceforge.net/projects/ibmswtpm2/files/<br>
* https://github.com/stefanberger/swtpm<br>

この機能を有効にするにはwolfTPMを以下のオプションとともにビルド：<br>

```
./configure --enable-swtpm
make
```

#### SWTPM シミュレーターのセットアップ

##### ibmswtpm2

チェックアウトとビルド<br>
```
git clone https://github.com/kgoldman/ibmswtpm2.git
cd ibmswtpm2/src/
make
```

実行<br>

```
./tpm_server --rm
```

"rm"スイッチはオプションで、指定するとキャッシュファイル(NVChip)を削除します。あるいは"`rm NVChip`"を実行しても同様です。<br>


##### swtpm

libtpmsをビルド<br>

```
git clone git@github.com:stefanberger/libtpms.git
(cd libtpms && ./autogen.sh --with-tpm2 --with-openssl --prefix=/usr && make install)
```

swtpmをビルド<br>

```
git clone git@github.com:stefanberger/swtpm.git
(cd swtpm && ./autogen.sh && make install)
```
注意：Mac OS X　では以下を最初に実行すること：

```
brew install openssl socat
pip3 install cryptography

export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# libtpms had to use --prefix=/usr/local
```

swtpmを実行<br>

```
mkdir -p /tmp/myvtpm
swtpm socket --tpmstate dir=/tmp/myvtpm --tpm2 --ctrl type=tcp,port=2322 --server type=tcp,port=2321 --flags not-need-init
```

#### サンプルプログラムを実行

```
./examples/pcr/extend
./examples/wrap/wrap_test
```

### Windows TBS API 向けにビルド

wolfTPMは Windows ネイティブTBS(TPM Base Services)を使用するようにビルドできます。<br>

Windows TBS インターフェイスを使用する際にはNVアクセスは既定でブロックされます。TPM NVストレージ空間は非常に制限されていてデータ書き込みにより鍵ハンドルのロードに失敗するなどの未定義のふるまいを引き起こす可能性があります。このようなNVストレージ空間への書き込みはTBSによっては管理されていません。<br>

TPMは"`TPM2_Create`"を使って鍵を生成した場合には、ディスク上に格納したり必要に応じたロードが安全にできるように暗号化した秘密鍵ブロブを返すように設計されています。秘密鍵ブロブを保護するのに使用されるのは対称暗号化鍵だけです。"`TPM2_Load`"を使って鍵をロードする場合には一時的なハンドルを得て署名や暗号化/復号に使用します。<br>

"`TPM2_CreatePrimary`"を使って生成した鍵はハンドルで返されます。暗号化された鍵データが返されるわけではありません。このハンドルは"`TPM2_FlushContext`"が呼び出されるまでロードされた状態が保たれます。<br>


#### 制限事項

wolfTPM はTPM 2.0デバイスを搭載したWindows 10でテストされています。
WindowsがTPM1.2の機能をサポートしている場合はwolfTPMではサポートされません。TPM 2.0が搭載されていることを確認する場合には、PowerShellを開き"`Get-PnpDevice -Class SecurityDevices`"を実行してください。


```
Status     Class           FriendlyName
------     -----           ------------
OK         SecurityDevices Trusted Platform Module 2.0
Unknown    SecurityDevices Trusted Platform Module 2.0
```

#### MSYS2上でビルド

MSYS2を使ってテスト済み

```
export PREFIX=$PWD/tmp_install

cd wolfssl
./autogen.sh
./configure --prefix="$PREFIX" --enable-wolftpm
make
make install

cd ../wolftpm/
./autogen.sh
./configure --prefix="$PREFIX" --enable-winapi
make
```

#### linux上でのビルド


mingw-w32-bin_x86_64-linux_20131221.tar.bz2　を使ってテスト済み。
[ソースはこちら。](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Automated%20Builds/)

ツールを抽出してPATH変数に追加します。

```
mkdir mingw_tools
cd mingw_tools
tar xjvf ../mingw-w32-bin_x86_64-linux_20131221.tar.bz2
export PATH=$PWD/bin/:$PWD/i686-w64-mingw32/bin:$PATH
cd ..
```

以下でビルドします。

```
export PREFIX=$PWD/tmp_install
export CFLAGS="-DWIN32 -DMINGW -D_WIN32_WINNT=0x0600 -DUSE_WOLF_STRTOK"
export LIBS="-lws2_32"

cd wolfssl
./autogen.sh
./configure --host=i686 CC=i686-w64-mingw32-gcc --prefix="$PREFIX" --enable-wolftpm
make
make install

cd ../wolftpm/
./autogen.sh
./configure --host=i686 CC=i686-w64-mingw32-gcc --prefix="$PREFIX" --enable-winapi
make
cd ..
```

#### Windows上での実行

マシン上でのTPMの存在とその状態を確認する為には"tpm.msc"を実行してください。

### ベアメタル環境向けのビルド

wolfTPMは、OSが存在しないベアメタルの組み込み環境向けにもビルドできます。
このセクションでは、wolfTPMをユーザのプロジェクトへ導入し、autotoolsやCMakeを使用せずにコンパイルする手順を解説します。

このセクションで示す手順は、ARM Cortex-MやRISC-V、UltraScale+/Versal、Microblazeのような一般的なマイコンボードに適用できます。

#### 準備

- wolfCryptのソースコード (wolfSSLリポジトリに含まれます)
- wolfTPMのソースコード
- SPIまたはI2Cで接続されたTPM 2.0チップ

#### ステップ1：プリプロセッサマクロの定義

ユーザのプロジェクトにおけるビルド設定やコンパイルコマンドに、以下のプリプロセッサマクロを追加します。

```
WOLFTPM_USER_SETTINGS
WOLFSSL_USER_SETTINGS
```

これらのマクロを定義することで、wolfTPMとwolfSSLはautoconfが作成した`options.h`ではなく`user_settings.h`を参照するようになります。


#### ステップ2：user_settings.hの作成

ユーザのプロジェクトに、wolfTPMとwolfSSLの構成オプションを記した`user_settings.h`を作成します。

詳細はwolfSSLリポジトリ内で提供しているリファレンスファイル[examples/configs/user_settings_wolftpm.h](https://github.com/wolfSSL/wolfssl/blob/master/examples/configs/user_settings_wolftpm.h)をご覧ください。

wolfTPM向けの`user_settings.h`のサンプルは次のとおりです。


```h
/* System */
#define WOLFSSL_GENERAL_ALIGNMENT 4
#define SINGLE_THREADED
#define WOLFCRYPT_ONLY
#define SIZEOF_LONG_LONG 8

/* Platform - bare metal */
#define NO_FILESYSTEM
#define NO_WRITEV
#define NO_MAIN_DRIVER
#define NO_DEV_RANDOM
#define NO_ERROR_STRINGS
#define NO_SIG_WRAPPER

/* wolfTPM required features */
#define WOLF_CRYPTO_CB
#define WOLFSSL_PUBLIC_MP
#define WOLFSSL_AES_CFB
#define HAVE_AES_DECRYPT

/* ECC options */
#define HAVE_ECC
#define ECC_TIMING_RESISTANT

/* RSA options */
#undef NO_RSA
#define WOLFSSL_KEY_GEN
#define WC_RSA_BLINDING

/* Big math library */
#define WOLFSSL_SP_MATH_ALL /* sp_int.c */
#define WOLFSSL_SP_SMALL
#define SP_INT_BITS 4096
//#define SP_WORD_SIZE 32

/* SHA options */
#define NO_SHA /* on by default */
#define NO_SHA256 /* on by default */
#define WOLFSSL_SHA512
#define WOLFSSL_SHA384

/* Disable unneeded features to reduce footprint */
#define NO_PKCS8
#define NO_PKCS12
#define NO_PWDBASED
#define NO_DSA
#define NO_DES3
#define NO_RC4
#define NO_PSK
#define NO_MD4
#define NO_MD5
#define WOLFSSL_NO_SHAKE128
#define WOLFSSL_NO_SHAKE256
#define NO_DH

/* Other interesting size reduction options */
#if 0
    #define RSA_LOW_MEM
    #define WOLFSSL_AES_SMALL_TABLES
    #define USE_SLOW_SHA
    #define USE_SLOW_SHA256
    #define USE_SLOW_SHA512
    #define NO_AES_192
#endif

/* Custom random seed source - implement your own */
#define HAVE_HASHDRBG
#define CUSTOM_RAND_GENERATE_SEED my_rng_seed
```

`CUSTOM_RAND_GENERATE_SEED`を使用する場合、ユーザは別途独自のRNGシード関数を定義する必要があります。

```c
int my_rng_seed(byte* seed, word32 sz)
{
    int rc;
    (void)os;
    /* enable parameter encryption for the RNG request */
    rc = wolfTPM2_SetAuthSession(&wolftpm_dev, 0, &wolftpm_session,
        (TPMA_SESSION_decrypt | TPMA_SESSION_encrypt |
        TPMA_SESSION_continueSession));
    if (rc == 0) {
        rc = wolfTPM2_GetRandom(&wolftpm_dev, seed, sz);
    }
    wolfTPM2_UnsetAuthSession(&wolftpm_dev, 0, &wolftpm_session);
    return rc;
}
```

#### ステップ3：インクルードパスの設定

ユーザのプロジェクトにて、以下のディレクトリをインクルードパスに追加します。

1. **wolfSSLルートディレクトリ** - 例：`/path/to/wolfssl`
2. **wolfTPMルートディレクトリ** - 例：`/path/to/wolftpm`
3. **ステップ2で作成した user_settings.h** - 必ず、コンパイラが辿れるように構成する必要があります。

コンパイラフラグの例を以下に示します。

```sh
-I/path/to/wolfssl
-I/path/to/wolftpm
-I/path/to/your/project/include
```

#### ステップ4：ソースファイルの追加

必要なソースファイルを、wolfSSL/wolfTPMリポジトリからユーザのプロジェクトに追加します。


**wolfCryptソースファイル** (wolfTPMを使用するための最小構成)：

```
wolfssl/wolfcrypt/src/aes.c
wolfssl/wolfcrypt/src/asn.c
wolfssl/wolfcrypt/src/cryptocb.c
wolfssl/wolfcrypt/src/ecc.c
wolfssl/wolfcrypt/src/hash.c
wolfssl/wolfcrypt/src/hmac.c
wolfssl/wolfcrypt/src/random.c
wolfssl/wolfcrypt/src/rsa.c
wolfssl/wolfcrypt/src/sha.c
wolfssl/wolfcrypt/src/sha256.c
wolfssl/wolfcrypt/src/sha512.c
wolfssl/wolfcrypt/src/sp_int.c
wolfssl/wolfcrypt/src/wc_port.c
wolfssl/wolfcrypt/src/wolfmath.c
```

**wolfTPMソースファイル**：

```
wolftpm/src/tpm2.c
wolftpm/src/tpm2_packet.c
wolftpm/src/tpm2_tis.c
wolftpm/src/tpm2_wrap.c
wolftpm/src/tpm2_param_enc.c
```

#### ステップ5：SPI HALコールバックの実装

wolfTPMはTPMチップと通信するために、単一のSPI送受信コールバックを使用します。
ユーザは使用するハードウェアプラットフォームに対応するコールバック関数を別途実装する必要があります。

なお、wolfTPMリポジトリ内`hal/`ディレクトリにて、このコールバック関数の実装例をいくつか提供しています。
ぜひお使いください。

- [hal/tpm_io_xilinx.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_xilinx.c) - Xilinx Microblaze
- [hal/tpm_io_stm32.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_stm32.c) - STM32
- [hal/tpm_io_infineon.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_infineon.c) - Infineon Tricore
- [hal/tpm_io_microchip.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_microchip.c) - Microchip

##### 標準的な入出力コールバック

SPIコールバックは以下のように定義されます。

```c
typedef int (*TPM2HalIoCb)(
    TPM2_CTX* ctx,
    const byte* txBuf, byte* rxBuf,
    word16 xferSz,
    void* userCtx
);
```

これに基づいて、以下のように実装します。

```c
#include <wolftpm/tpm2.h>
#include <wolftpm/tpm2_tis.h>

int TPM2_IoCb(TPM2_CTX* ctx,
    const byte* txBuf, byte* rxBuf, word16 xferSz,
    void* userCtx)
{
    int ret = TPM_RC_FAILURE;

    /* TODO: Assert SPI chip select */
    spi_cs_assert();

    /* Perform SPI transfer - simultaneously send txBuf and receive to rxBuf */
    if (spi_transfer(txBuf, rxBuf, xferSz) == 0) {
        ret = TPM_RC_SUCCESS;
    }

    /* TODO: De-assert SPI chip select */
    spi_cs_deassert();

    (void)ctx;
    (void)userCtx;

    return ret;
}
```

##### 応用的な入出力コールバック

さらなる制御を必要とするプラットフォームを使用する場合、`WOLFTPM_ADV_IO`を定義することで以下のようなコールバックを利用できます。

```c
typedef int (*TPM2HalIoCb)(
    TPM2_CTX* ctx,
    INT32 isRead, UINT32 addr,
    BYTE* xferBuf, UINT16 xferSz,
    void* userCtx
);
```

これにより、レジスタアドレスへのアクセスや、読み込み・書き込み操作を分ける必要のあるプラットフォーム向けの読み書き方向の提示(`isRead`)ができるようになります。

#### ステップ6：wolfTPMの初期化と使用

ここまでの手順を終えると、以下のようにしてwolfTPMを使用してTPMとの通信を行えます。

```c
#include <wolftpm/tpm2_wrap.h>

int main(void)
{
    int rc;
    WOLFTPM2_DEV dev;

    /* Initialize wolfTPM */
    rc = wolfTPM2_Init(&dev, TPM2_IoCb, NULL);
    if (rc != TPM_RC_SUCCESS) {
        /* Handle error */
        return rc;
    }

    /* Get TPM capabilities */
    WOLFTPM2_CAPS caps;
    rc = wolfTPM2_GetCapabilities(&dev, &caps);
    if (rc == TPM_RC_SUCCESS) {
        /* Use TPM ... */
    }

    /* Cleanup */
    wolfTPM2_Cleanup(&dev);

    return 0;
}
```

#### 任意のビルド構成オプション

##### メモリ使用量の削減

制約の厳しい環境では、`user_settings.h`に以下のオプションを追加することをご検討ください。

```c
/* Reduce stack usage */
#define WOLFTPM_SMALL_STACK

/* Disable wrapper layer if using native API only */
#define WOLFTPM2_NO_WRAPPER

/* Use smaller RSA key sizes only */
#define MAX_RSA_BITS 2048
```

##### TPMチップタイプの選択

コンパイル時にTPMチップのタイプが判明している場合、以下のフラグを使用できます。

```c
/* For Infineon */
#define WOLFTPM_SLB9670
#define WOLFTPM_SLB9672
#define WOLFTPM_SLB9673

/* For ST ST33 */
#define WOLFTPM_ST33

/* For Nuvoton */
#define WOLFTPM_NUVOTON

/* For Microchip ATTPM20 */
#define WOLFTPM_MICROCHIP
```

指定されていない場合、wolfTPMはチップタイプを自動で検出します。
この機能はデフォルトで定義されている`WOLFTPM_AUTODETECT`により実行されます。

##### I2C対応

TPMチップがSPIではなくI2Cで接続されている場合、以下のオプションを追加してください。

```c
#define WOLFTPM_I2C
#define WOLFTPM_ADV_IO
```

I2C通信で使用する応用的な入出力コールバックは別途実装する必要があります。

#### 暗号鍵ストレージ

TPMチップにより、メインメモリから隔離された暗号鍵のための安全な記憶域を使用できます。
保存された鍵情報が平文でTPMから外に出ることはありません。

- `TPM2_CreatePrimary`を使用して鍵を作成すると、TPM内で保管されます。
- `TPM2_Create`を使用して鍵を作成すると、NVRAMに保管できるよう暗号化されたものが返却されます。これは`TPM2_Load`を使用することで再びTPMに読み込むことが可能です。
- `TPM2_EvictControl`を使用することで、鍵を永続的にTPMのNVRAMに格納できます。

この分離により、万一メインプロセッサのメモリが侵害されても暗号鍵は保護されます。

#### トラブルシューティング

##### SPI通信に関する問題

1. SPIのクロック極性と周期を確認します。CPOL=0, CPHA=0 のような値です。
2. SPIのクロック速度を確認します。まずは1〜10MHzのようなゆっくりとした速度でお試しになることをおすすめします。
3. 送受信フローでチップ選択が行われていることを確認します。
4. いくつかのTPMでは、SPI操作の中に待機ステートを含めることが求められます。これはMSBに到達するまでのすべてのデータを読み込むために必要な場合があります。その場合、`WOLFTPM_CHECK_WAIT_STATE`を有効化してください。
5. `#define DEBUG_WOLFTPM`(標準)や、`WOLFTPM_DEBUG_VERBOSE`(詳細)、`WOLFTPM_DEBUG_IO`(SPI/I2C関連)を有効化し、デバッグ出力を確認します。

##### ビルドエラーが発生する場合

1. `WOLFSSL_USER_SETTINGS`および`WOLFTPM_USER_SETTINGS`が有効化されていることを確認します。
2. インクルードパスが正しく設定されていることを確認します。
3. 必要なソースファイルのすべてが用意されていることを確認します。

詳しい手順は本セクション「ベアメタル環境向けのビルド」ステップ1〜6をご参照ください。
