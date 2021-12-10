# Building wolfTPM

To build the wolfTPM library, it's required to first build and install the wolfSSL library. This can be downloaded from the [downloads page](https://wolfssl.com/download/), or through a "git clone" command, shown below:
```
$ git clone https://github.com/wolfssl/wolfssl
```
Once the wolfSSL library has been downloaded, it needs to be built with the following option being passed to the configure script:
```
$ ./configure --enable-wolftpm
```
Or equivalently, with the following options:

```
$ ./configure --enable-certgen --enable-certreq --enable-certext
--enable-pkcs7 --enable-cryptocb --enable-aescfb
```
Then the wolfSSL library just needs to be built and installed however the user prefers.

The next step is to download and install the wolfTPM library. wolfTPM can similarly be downloaded from the [downloads page](https://wolfssl.com/download/) or be cloned from GitHub. The following commands show how to clone and install wolfTPM:
```
$ git clone https://github.com/wolfssl/wolftpm
$ cd wolftpm
$ ./autogen.sh
$ ./configure
$ make
```

### Build options and defines

```
--enable-debug          Add debug code/turns off optimizations (yes|no|verbose|io) 
                        - DEBUG_WOLFTPM, WOLFTPM_DEBUG_VERBOSE, WOLFTPM_DEBUG_IO
--enable-examples       Enable Examples (default: enabled)
--enable-wrapper        Enable wrapper code (default: enabled) - WOLFTPM2_NO_WRAPPER
--enable-wolfcrypt      Enable wolfCrypt hooks for RNG, Auth Sessions and Parameter encryption 
                        (default: enabled) - WOLFTPM2_NO_WOLFCRYPT
--enable-advio          Enable Advanced IO (default: disabled) - WOLFTPM_ADV_IO
--enable-i2c            Enable I2C TPM Support (default: disabled, requires advio) - WOLFTPM_I2C
--enable-checkwaitstate Enable TIS / SPI Check Wait State support (default: depends on chip) 
                        - WOLFTPM_CHECK_WAIT_STATE
--enable-smallstack     Enable options to reduce stack usage
--enable-tislock        Enable Linux Named Semaphore for locking access to SPI device for 
                        concurrent access between processes - WOLFTPM_TIS_LOCK

--enable-autodetect     Enable Runtime Module Detection (default: enable - when no module 
                        specified) - WOLFTPM_AUTODETECT
--enable-infineon       Enable Infineon SLB9670 TPM Support (default: disabled)
--enable-st             Enable ST ST33TPM Support (default: disabled) - WOLFTPM_ST33
--enable-microchip      Enable Microchip ATTPM20 Support (default: disabled) - WOLFTPM_MCHP
--enable-nuvoton        Enable Nuvoton NPCT65x/NPCT75x Support (default: disabled) 
                        - WOLFTPM_NUVOTON

--enable-devtpm         Enable using Linux kernel driver for /dev/tpmX (default: disabled) 
                        - WOLFTPM_LINUX_DEV
--enable-swtpm          Enable using SWTPM TCP protocol. For use with simulator. 
                        (default: disabled) - WOLFTPM_SWTPM
--enable-winapi         Use Windows TBS API. (default: disabled) - WOLFTPM_WINAPI

WOLFTPM_USE_SYMMETRIC   Enables symmetric AES/Hashing/HMAC support for TLS examples.
WOLFTPM2_USE_SW_ECDHE   Disables use of TPM for ECC ephemeral key generation and shared secret 
                        for TLS examples.
TLS_BENCH_MODE          Enables TLS benchmarking mode.
NO_TPM_BENCH            Disables the TPM benchmarking example.
```

### Building Infineon SLB9670

Build wolfTPM:

```
git clone https://github.com/wolfSSL/wolfTPM.git
cd wolfTPM
./autogen.sh
./configure
make
```

### Building ST ST33TP*

Build wolfTPM:

```
./autogen.sh
./configure --enable-st33 [--enable-i2c]
make
```

For the I2C support on Raspberry Pi you may need to enable I2C. Here are the steps:
1. Edit `sudo vim /boot/config.txt`
2. Uncomment `dtparam=i2c_arm=on`
3. Reboot `sudo reboot`

### Building Microchip ATTPM20

Build wolfTPM:

```
./autogen.sh
./configure --enable-microchip
make
```

### Building Nuvoton

Build wolfTPM:

```
./autogen.sh
./configure --enable-nuvoton
make
```

### Building for "/dev/tpmX"

This build option allows you to talk to any TPM vendor supported by the Linux TIS kernel driver

Build wolfTPM:

```
./autogen.sh
./configure --enable-devtpm
make
```

Note: When using a TPM device through the Linux kernel driver make sure sufficient permissions are given to the application that uses wolfTPM, because the "/dev/tpmX" typically has read-write permissions only for the "tss" user group. Either run wolfTPM examples and your application using sudo or add your user to the "tss" group like this:

```
sudo adduser yourusername tss
```

#### With QEMU and swtpm

This demonstrates using wolfTPM in QEMU to communicate using the linux
kernel device "/dev/tpmX". You will need to install or build
[swtpm](https://github.com/stefanberger/swtpm). Below are a short
method to build. You may need to consult the instructions for
[libtpms](https://github.com/stefanberger/libtpms/wiki#compile-and-install-on-linux)
and
[swtpm](https://github.com/stefanberger/swtpm/wiki#compile-and-install-on-linux)

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

You can setup a basic linux installation. Other installation bases can
be used. This step will take some time to install the base linux
system.

```
# download mini install image
curl -O http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/mini.iso
# create qemu image file
qemu-img create -f qcow2 lubuntu.qcow2 5G
# create directory for tpm state and socket
mkdir $PREFIX/mytpm
# start swtpm
$PREFIX/bin/swtpm socket --tpm2 --tpmstate dir=$PREFIX/mytpm \
  --ctrl type=unixio,path=$PREFIX/mytpm/swtpm-sock --log level=20 &
# start qemu for installation
qemu-system-x86_64 -m 1024 -boot d -bios bios-256k.bin -boot menu=on \
  -chardev socket,id=chrtpm,path=$PREFIX/mytpm/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 -hda lubuntu.qcow2 -cdrom mini.iso
```

Once a base system is installed it's ready to start the qemu and build
wolfSSL and wolfTPM in the qemu instance.

```
# start swtpm again
$PREFIX/bin/swtpm socket --tpm2 --tpmstate dir=$PREFIX/mytpm \
  --ctrl type=unixio,path=$PREFIX/mytpm/swtpm-sock --log level=20 &
# start qemu system to install and run wolfTPM
qemu-system-x86_64 -m 1024 -boot d -bios bios-256k.bin -boot menu=on \
  -chardev socket,id=chrtpm,path=$PREFIX/mytpm/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 -hda lubuntu.qcow2
```

To build checkout and build wolfTPM, in the QEMU terminal

```
sudo apt install automake libtool gcc git make

# get and build wolfSSL
git clone https://github.com/wolfssl/wolfssl.git
pushd wolfssl
./autogen.sh && \
  ./configure --enable-wolftpm --disable-examples --prefix=$PWD/../inst && \
  make install
popd

# get and build wolfTPM
git clone https://github.com/wolfssl/wolftpm.git
pushd wolftpm
./autogen.sh && \
  ./configure --enable-devtpm --prefix=$PWD/../inst --enable-debug && \
  make install
sudo make check
popd
```

You can now run the examples such as `sudo ./examples/wrap/wrap`
within QEMU. Using `sudo` maybe required for access to `/dev/tpm0`.

### Building for SWTPM

wolfTPM is to be able to interface with SW TPM interfaces defined by
section D.3 of
[TPM-Rev-2.0-Part-4-Supporting-Routines-01.38-code](https://trustedcomputinggroup.org/wp-content/uploads/TPM-Rev-2.0-Part-4-Supporting-Routines-01.38-code.pdf)

Using the socket connection for SWTPM is exclusive and not compatible
with TIS or devtpm.

Only a subset of functionality is implemented to support testing of
wolfTPM. The platform requests are not used by wolfTPM.

Two implementations were used in testing:

* https://sourceforge.net/projects/ibmswtpm2/files/
* https://github.com/stefanberger/swtpm

To enable this functionality, build wolfTPM as shown below:
```
./configure --enable-swtpm
make
```

#### SWTPM simulator setup

##### ibmswtpm2

Checkout and Build
```
git clone https://github.com/kgoldman/ibmswtpm2.git
cd ibmswtpm2/src/
make
```

Running:
```
./tpm_server --rm
```

The rm switch is optional and remove the cache file
NVChip. Alternately you can `rm NVChip`

##### swtpm

Build libtpms

```
git clone git@github.com:stefanberger/libtpms.git
(cd libtpms && ./autogen.sh --with-tpm2 --with-openssl --prefix=/usr && make install)
```

Build swtpm

```
git clone git@github.com:stefanberger/swtpm.git
(cd swtpm && ./autogen.sh && make install)
```

Note: On Mac OS X had to do the following first:

```
brew install openssl socat
pip3 install cryptography

export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# libtpms had to use --prefix=/usr/local
```

Running swtpm

```
mkdir -p /tmp/myvtpm
swtpm socket --tpmstate dir=/tmp/myvtpm --tpm2 --ctrl type=tcp,port=2322 --server type=tcp,port=2321 --flags not-need-init
```

#### Running examples

```
./examples/pcr/extend
./examples/wrap/wrap_test
```

### Building for Windows TBS API

wolfTPM can be built to use Windows native TBS (TPM Base Services)

When using the Windows TBS interface the NV access is blocked by default. TPM NV storage space is very limited and when filled can cause undefined behaviors, such as failures loading key handles. These are not managed by TBS.

The TPM is designed to return an encrypted private key blob on key creation using `TPM2_Create`, which you can safely store on the disk and load when needed. The symmetric encryption key used to protect the private key blob is only known by the TPM. When you load a key using `TPM2_Load` you get a transient handle, which can be used for signing and even encryption/decryption.

For primary keys created with `TPM2_CreatePrimary` you get back a handle. There is no encrypted private data returned. That handle will remain loaded until `TPM2_FlushContext` is called.

For normal key creation using `TPM2_Create` you get back a `TPM2B_PRIVATE outPrivate`, which is the encrypted blob that you can store and load anytime using `TPM2_Load`.

#### Limitations

wolfTPM has been tested on Windows 10 with TPM 2.0 devices. While
Windows does support TPM 1.2, functionality is limited and not
supported by wolfTPM.

Presence of TPM 2.0 can be checked by opening PowerShell
and running `Get-PnpDevice -Class SecurityDevices`

```
Status     Class           FriendlyName
------     -----           ------------
OK         SecurityDevices Trusted Platform Module 2.0
Unknown    SecurityDevices Trusted Platform Module 2.0
```

#### Building in MSYS2

Tested using MSYS2

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

#### Building on linux

Tested using mingw-w32-bin_x86_64-linux_20131221.tar.bz2
[source](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Automated%20Builds/)

Extract the tools and add them to the `PATH`
```
mkdir mingw_tools
cd mingw_tools
tar xjvf ../mingw-w32-bin_x86_64-linux_20131221.tar.bz2
export PATH=$PWD/bin/:$PWD/i686-w64-mingw32/bin:$PATH
cd ..
```

Build
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

#### Running on Windows

To confirm presence and status of TPM on the machine run `tpm.msc`
