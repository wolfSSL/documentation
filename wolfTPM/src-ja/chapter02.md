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
