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

### Building for Bare-Metal

wolfTPM can be built for bare-metal embedded environments where no operating system is present. This section covers the steps needed to integrate wolfTPM directly into your project by compiling the source files rather than using autotools or CMake.

This approach is common for microcontrollers such as ARM Cortex-M, RISC-V, UltraScale+/Versal, Microblaze, and others.

#### Prerequisites

- wolfCrypt library source code
- wolfTPM library source code
- A TPM 2.0 module connected via SPI (or I2C)

#### Step 1: Define Preprocessor Macros

Add the following preprocessor macros to your project build settings or compiler command line:

```
WOLFTPM_USER_SETTINGS
WOLFSSL_USER_SETTINGS
```

These macros tell wolfTPM and wolfSSL to look for a `user_settings.h` file instead of using autoconf-generated `options.h` file.

#### Step 2: Create a user_settings.h File

Create a `user_settings.h` file in your project that contains the build configuration options for both wolfSSL and wolfTPM.

A reference configuration file is available in the wolfSSL repository:
[examples/configs/user_settings_wolftpm.h](https://github.com/wolfSSL/wolfssl/blob/master/examples/configs/user_settings_wolftpm.h)

Example `user_settings.h` for wolfTPM:

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

You will need to implement your own RNG seed function if using `CUSTOM_RAND_GENERATE_SEED`:

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

#### Step 3: Configure Include Paths

Add the following directories to your project's include paths:

1. **wolfSSL root directory** - e.g., `/path/to/wolfssl`
2. **wolfTPM root directory** - e.g., `/path/to/wolftpm`
3. **Your user_settings.h location** - must be discoverable by the compiler (in your include path)

Example compiler flags:

```
-I/path/to/wolfssl
-I/path/to/wolftpm
-I/path/to/your/project/include
```

#### Step 4: Add Source Files

Add the required source files from wolfSSL and wolfTPM to your project.

**wolfCrypt source files** (minimum required for wolfTPM):

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

**wolfTPM source files**:

```
wolftpm/src/tpm2.c
wolftpm/src/tpm2_packet.c
wolftpm/src/tpm2_tis.c
wolftpm/src/tpm2_wrap.c
wolftpm/src/tpm2_param_enc.c
```

#### Step 5: Implement the SPI HAL Callback

wolfTPM requires a single SPI transmit/receive callback to communicate with the TPM module. You need to implement this function for your specific hardware platform.

Reference implementations are available in the wolfTPM repository under `hal/`:

- [hal/tpm_io_xilinx.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_xilinx.c) - Xilinx Microblaze
- [hal/tpm_io_stm32.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_stm32.c) - STM32
- [hal/tpm_io_infineon.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_infineon.c) - Infineon Tricore
- [hal/tpm_io_microchip.c](https://github.com/wolfSSL/wolfTPM/blob/master/hal/tpm_io_microchip.c) - Microchip

##### Standard I/O Callback

The standard SPI callback has the following signature:

```c
typedef int (*TPM2HalIoCb)(
    TPM2_CTX* ctx,
    const byte* txBuf, byte* rxBuf,
    word16 xferSz,
    void* userCtx
);
```

Example implementation:

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

##### Advanced I/O Callback

For platforms that need more control, enable `WOLFTPM_ADV_IO` to use the advanced callback:

```c
typedef int (*TPM2HalIoCb)(
    TPM2_CTX* ctx,
    INT32 isRead, UINT32 addr,
    BYTE* xferBuf, UINT16 xferSz,
    void* userCtx
);
```

This provides access to the register address and read/write direction for platforms that require separate read and write operations.

#### Step 6: Initialize and Use wolfTPM

After completing the setup, you can initialize wolfTPM and start communicating with the TPM:

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

#### Optional Build Configurations

##### Reducing Memory Footprint

For constrained environments, consider these options in `user_settings.h`:

```c
/* Reduce stack usage */
#define WOLFTPM_SMALL_STACK

/* Disable wrapper layer if using native API only */
#define WOLFTPM2_NO_WRAPPER

/* Use smaller RSA key sizes only */
#define MAX_RSA_BITS 2048
```

##### Selecting TPM Module Type

If you know your TPM module type at compile time:

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

If not specified, wolfTPM will attempt to auto-detect the module at runtime using `WOLFTPM_AUTODETECT` (default behavior).

##### I2C Support

For TPM modules connected via I2C instead of SPI:

```c
#define WOLFTPM_I2C
#define WOLFTPM_ADV_IO
```

You will need to implement the advanced I/O callback for I2C communication.

#### Cryptographic Key Storage

In bare-metal environments, the TPM provides secure storage for cryptographic keys that is isolated from main processor memory. The key material never leaves the TPM in plaintext form.

- Keys created with `TPM2_CreatePrimary` reside in the TPM and return a handle
- Keys created with `TPM2_Create` return an encrypted blob that can be stored in non-volatile memory and reloaded using `TPM2_Load`
- Use `TPM2_EvictControl` to store keys persistently in the TPM's NVRAM

This separation ensures that cryptographic keys are protected even if the main processor's memory is compromised.

#### Troubleshooting

##### SPI Communication Issues

1. Verify SPI clock polarity and phase (typically CPOL=0, CPHA=0 for TPM)
2. Check SPI clock speed - start with a slower speed (1-10 MHz) and increase
3. Verify chip select is asserted low during entire send/recieve
4. Some TPMs require wait states during SPI operations which requires extra bytes until the MSB is set to signal response readiness (enabled with `WOLFTPM_CHECK_WAIT_STATE`)
5. Enable debug output with `#define DEBUG_WOLFTPM` (general), `WOLFTPM_DEBUG_VERBOSE` (detailed), or `WOLFTPM_DEBUG_IO` (SPI/I2C transactions)

##### Build Errors

1. Ensure `WOLFSSL_USER_SETTINGS` and `WOLFTPM_USER_SETTINGS` are defined
2. Verify include paths are correctly set
3. Check that all required source files are included in the build
