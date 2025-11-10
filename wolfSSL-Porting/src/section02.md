# Porting wolfSSL

## Data Types

Q:  When do I need to read this section?
A:  Setting the correct data type size for your platform is always important.

wolfSSL benefits speed-wise from having a 64-bit type available.  Define SIZEOF_LONG and SIZEOF_LONG_LONG to match the result of sizeof(long) and sizeof(long long) on your platform.  This can be added to a custom define in the settings.h file or to user_settings.h.  For example, in settings.h under a sample define of MY_NEW_PLATFORM:

```
#ifdef MY_NEW_PLATFORM
	#define SIZEOF_LONG 4
	#define SIZEOF_LONG_LONG 8
	...
#endif
```

There are two additional data types used by wolfSSL and wolfCrypt, called “word32” and “word16”.  The default type mappings for these are:

```
#ifndef WOLFSSL_TYPES
#ifndef byte
typedef unsigned char  byte;
#endif
	typedef unsigned short word16;
typedef unsigned int   word32;
typedef byte           word24[3];
#endif
```

“word32” should be mapped to the compiler’s 32-bit type, and “word16” to the compiler’s 16-bit type.  If these default mappings are incorrect for your platform, you should define WOLFSSL_TYPES in settings.h or user_settings.h and assign your own custom typedefs for word32 and word16.

The fastmath library in wolfSSL uses the “fp_digit” and “fp_word” types.  By default these are mapped in <wolfssl/wolfcrypt/tfm.h> depending on build configuration.

“fp_word” should be twice the size of “fp_digit”.  If the default cases do not hold true for your platform, you should define WOLFSSL_BIGINT_TYPES in settings.h or user_settings.h and assign your own custom typedefs for fp_word and fp_digit.

wolfSSL does use a 64-bit type when available for some operations.  The wolfSSL build tries to detect and set up the correct underlying data type for word64 based on what SIZEOF_LONG and SIZEOF_LONG_LONG have been set to.  On some platforms that don’t have a true 64-bit type, where two 32-bit types are used in conjunction, performance can be slow.  To compile out the use of 64-bit types, define NO_64BIT.

## Endianness

Q:  When do I need to read this section?
A:  Your platform is a big endian system.

Is your platform big endian or little endian?  wolfSSL defaults to a little endian system.  If your system is big endian, define BIG_ENDIAN_ORDER when building wolfSSL.  Example of setting this in settings.h:

```
#ifdef MY_NEW_PLATFORM
	...
	#define BIG_ENDIAN_ORDER
	...
#endif
```

## writev

Q:  When do I need to read this section?
A:  <sys/uio.h> is not available.

By default, the wolfSSL API makes available wolfSSL_writev() to applications, which simulates writev() semantics.  On systems that don’t have the <sys/uio.h> header available, define NO_WRITEV to exclude this feature.

## Input/Output

Q:  When do I need to read this section?
A:  A BSD-style socket API is not available, you are using a custom transport layer or TCP/IP stack, or only want to use static buffers.

wolfSSL defaults to using a BSD-style socket interface.  If your transport layer provides a BSD socket interface, wolfSSL should integrate into it as-is, unless custom headers are needed.

wolfSSL provides a custom I/O abstraction layer which allows users to tailor wolfSSL's I/O functionality to their system.  Full details can be found in Section 5.1.2 of the wolfSSL Manual:
https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-5-portability.html

Simply put, you can define WOLFSSL_USER_IO, then write your own I/O callback functions using wolfSSL's default EmbedSend() and EmbedReceive() as templates.  These two functions are located in ./src/wolfio.c.

wolfSSL uses dynamic buffers for input and output, which default to 0 bytes.  If an input record is received that is greater in size than the buffer, then a dynamic buffer is temporarily used to handle the request and then freed.

If you prefer using large, 16kB static buffers which will never need dynamic memory, you can enable this option by defining LARGE_STATIC_BUFFERS.

If dynamic buffers are used and the user requests an wolfSSL_write() that is bigger than the buffer size, then a dynamic block up to MAX_RECORD_SIZE is used to send the data. Users wishing to only send the data in chunks of the current buffer size at maximum, as defined by RECORD_SIZE, can do this by defining STATIC_CHUNKS_ONLY.  When using this define, RECORD_SIZE defaults to 128 bytes.

## Filesystem

Q:  When do I need to read this section?
A:  No file system is available, standard file system functions are not available, or you have a custom file system.

wolfSSL uses the filesystem for loading keys and certificates into the SSL session or context.  wolfSSL also allows loading these from memory buffers.  If strictly using memory buffers, a filesystem is not needed.

You can disable wolfSSL's usage of the filesystem by defining NO_FILESYSTEM when building the library.  This means that certificates and keys will need to be loaded from memory buffers instead of files.  An example of setting this in settings.h:

```
#ifdef MY_NEW_PLATFORM
	...
	#define NO_FILESYSTEM
	...
#endif
```

Test key and certificate buffers can be found in the ./wolfssl/certs_test.h header file.  These will match up to corresponding certificates and keys found in the ./certs directory.  

The certs_test.h header file can be updated using the ./gencertbuf.pl script if needed.  Inside gencertbuf.pl, there are two arrays:  fileList_1024 and fileList_2048.  Additional certificates or keys may be added to the respective array, depending on key size, and must be in DER format.  The above mentioned arrays map a certificate/key file location with the desired buffer name.  After modifying gencertbuf.pl, running it from the wolfSSL root directory will update the certificate and key buffers in ./wolfssl/certs_test.h:

./gencertbuf.pl

If you would like to use a filesystem other than the default, the filesystem abstraction layer is located in ./wolfssl/wolfcrypt/wc_port.h.  Here you will see filesystem ports for various platforms including EBSNET, FREESCALE_MQX, and MICRIUM.  You can add a custom define for your platform if needed - allowing you to define file system functions with XFILE, XFOPEN, XFSEEK, etc.  For example, the filesystem layer in wc_port.h for Micrium's µC/OS (MICRIUM) is as follows:

```
#elif defined(MICRIUM)                                                          
#include <fs.h>                                                             
#define XFILE      FS_FILE*                                                 
#define XFOPEN     fs_fopen                                                 
#define XFSEEK     fs_fseek                                                 
#define XFTELL     fs_ftell                                                 
#define XREWIND    fs_rewind                                                
#define XFREAD     fs_fread                                                 
#define XFCLOSE    fs_fclose                                                
#define XSEEK_END  FS_SEEK_END                                              
#define XBADFILE   NULL 
```

## Threading

Q:  When do I need to read this section?
A:  You want to use wolfSSL in a multithreaded environment, or want to just compile it in single threaded mode.

If wolfSSL will only be used in a single threaded environment, the wolfSSL mutex layer can be disabled when compiling wolfSSL by defining SINGLE_THREADED.  This will negate the need to port the wolfSSL mutex layer.  

If wolfSSL needs to be used in a multithreaded environment, the wolfSSL mutex layer will need to be ported to the new environment.  The mutex layer can be found in ./wolfssl/wolfcrypt/wc_port.h and ./wolfcrypt/src/wc_port.c.  wolfSSL_Mutex will need to be defined for the new system in wc_port.h and the mutex functions (wc_InitMutex, wc_FreeMutex, wc_LockMutex and wc_UnLockMutex) in wc_port.c.  You can search in wc_port.h and wc_port.c to see an example for some existing platform port layers (EBSNET, FREESCALE_MQX, etc.).

## Random Seed

Q:  When do I need to read this section?
A:  Either /dev/random or /dev/urandom is not available, you want to integrate into a hardware RNG, or you need to understand wolfSSL's random number generation architecture.

### Overview

wolfSSL uses a FIPS-certified Hash_DRBG (Deterministic Random Bit Generator) based on SHA-256 by default. This DRBG is compliant with NIST SP 800-90A and provides cryptographically secure random number generation for all SSL/TLS operations. The DRBG requires an entropy source (seed) to initialize and periodically reseed itself.

### Default Behavior

By default, wolfSSL's DRBG obtains entropy from the following sources in order of preference:

1. **Hardware entropy sources** (if available and enabled):
   - Intel RDSEED instruction (`HAVE_INTEL_RDSEED`)
   - AMD RDSEED instruction (`HAVE_AMD_RDSEED`)
   - Platform-specific hardware RNG (various embedded platforms)

2. **Operating system entropy sources**:
   - `/dev/urandom` (preferred on Unix-like systems)
   - `/dev/random` (fallback if /dev/urandom is unavailable)
   - `getrandom()` system call on Linux (when `WOLFSSL_GETRANDOM` is defined)

The DRBG is enabled by default and can be found in `./wolfcrypt/src/random.c`. The Hash_DRBG implementation uses SHA-256 and maintains internal state that is periodically reseeded to ensure continued entropy.

### Disabling /dev/urandom or /dev/random

If your platform does not have `/dev/urandom` or `/dev/random`, or you want to disable their use, you can define:

- **`NO_DEV_URANDOM`**: Disables use of `/dev/urandom` (will fall back to `/dev/random`)
- **`NO_DEV_RANDOM`**: Disables use of both `/dev/urandom` and `/dev/random`

When `NO_DEV_RANDOM` is defined, you must provide an alternative entropy source using one of the methods described below.

### Disabling the DRBG

The entire Hash_DRBG can be disabled by defining `WC_NO_HASHDRBG`. However, when the DRBG is disabled, you **must** provide a custom random number generator using `CUSTOM_RAND_GENERATE_BLOCK`.

Example in `user_settings.h`:
```c
#define WC_NO_HASHDRBG
#define CUSTOM_RAND_GENERATE_BLOCK myHardwareRNG
```

Where `myHardwareRNG` is a function with the signature:
```c
int myHardwareRNG(unsigned char* output, unsigned int sz);
```

This function should fill the `output` buffer with `sz` bytes of random data from your hardware RNG and return 0 on success.

### Custom Seed Generation Methods

wolfSSL provides several methods to customize how the DRBG obtains its seed:

#### 1. CUSTOM_RAND_GENERATE_SEED

Define a custom function that generates seed data. This is the most direct way to provide entropy.

```c
#define CUSTOM_RAND_GENERATE_SEED myGenerateSeed

int myGenerateSeed(unsigned char* output, unsigned int sz)
{
    // Fill output buffer with sz bytes of entropy from your source
    // Return 0 on success, non-zero on error
}
```

#### 2. CUSTOM_RAND_GENERATE

Define a function that returns random values one at a time. wolfSSL will call this function repeatedly to fill the seed buffer.

```c
#define CUSTOM_RAND_GENERATE myRandFunc
#define CUSTOM_RAND_TYPE unsigned int

unsigned int myRandFunc(void)
{
    // Return a random value from your entropy source
}
```

The `CUSTOM_RAND_TYPE` should match the return type of your function (e.g., `unsigned int`, `unsigned long`, etc.).

Example from `./wolfcrypt/src/random.c` (lines 2707-2736):
```c
int wc_GenerateSeed(OS_Seed* os, byte* output, word32 sz)
{
    word32 i = 0;
    while (i < sz) {
        if ((i + sizeof(CUSTOM_RAND_TYPE)) > sz ||
            ((wc_ptr_t)&output[i] % sizeof(CUSTOM_RAND_TYPE)) != 0) {
            output[i++] = (byte)CUSTOM_RAND_GENERATE();
        }
        else {
            *((CUSTOM_RAND_TYPE*)&output[i]) = CUSTOM_RAND_GENERATE();
            i += sizeof(CUSTOM_RAND_TYPE);
        }
    }
    return 0;
}
```

#### 3. wc_SetSeed_Cb (Runtime Callback)

Set a seed generation callback at runtime using `wc_SetSeed_Cb()`. This requires defining `WC_RNG_SEED_CB` at build time.

Build configuration:
```c
#define WC_RNG_SEED_CB
```

Runtime usage:
```c
#include <wolfssl/wolfcrypt/random.h>

int myCustomSeedFunc(OS_Seed* os, byte* seed, word32 sz)
{
    // Generate sz bytes of entropy into seed buffer
    // Return 0 on success
}

// Set the callback before initializing RNG
wc_SetSeed_Cb(myCustomSeedFunc);

// Now initialize and use RNG as normal
WC_RNG rng;
wc_InitRng(&rng);
```

The callback function is defined in `./wolfcrypt/src/random.c` (lines 319-323).

#### 4. Crypto Callbacks (WC_ALGO_TYPE_SEED)

Use wolfSSL's crypto callback mechanism to provide seed generation through a hardware security module or custom crypto device. This requires `WOLF_CRYPTO_CB` to be defined.

Build configuration:
```c
#define WOLF_CRYPTO_CB
```

Implementation example (from `wolfssl-examples/tls/cryptocb-common.c`):
```c
int myCryptoCb(int devIdArg, wc_CryptoInfo* info, void* ctx)
{
    if (info->algo_type == WC_ALGO_TYPE_SEED) {
        // Generate random seed data
        // info->seed.seed = output buffer
        // info->seed.sz = requested size
        
        // Example: Fill with entropy from hardware
        while (info->seed.sz > 0) {
            word32 len = min(info->seed.sz, BLOCK_SIZE);
            // Get entropy from your hardware
            getHardwareEntropy(info->seed.seed, len);
            info->seed.seed += len;
            info->seed.sz -= len;
        }
        return 0;
    }
    return CRYPTOCB_UNAVAILABLE;
}

// Register the callback
int devId = 1;
wc_CryptoCb_RegisterDevice(devId, myCryptoCb, NULL);

// Use the device ID when initializing RNG
WC_RNG rng;
wc_InitRng_ex(&rng, NULL, devId);
```

This method is particularly useful for integrating with HSMs, TPMs, or other hardware security devices.

### Testing and Development

#### WOLFSSL_GENSEED_FORTEST

For development and testing purposes only, you can define `WOLFSSL_GENSEED_FORTEST` to use a fake, predictable seed. **This should never be used in production** as it provides no security.

```c
#define WOLFSSL_GENSEED_FORTEST
```

This will generate a deterministic seed pattern (0x00, 0x01, 0x02, ...) suitable only for testing and debugging. The implementation is in `./wolfcrypt/src/random.c` (lines 4269-4285).

### Platform-Specific Examples

For examples of platform-specific `wc_GenerateSeed()` implementations, reference the existing implementations in `./wolfcrypt/src/random.c`:

- **Windows**: Uses `CryptGenRandom()` or `BCryptGenRandom()` (lines 2753+)
- **SGX**: Uses `sgx_read_rand()` (lines 2738-2751)
- **Embedded platforms**: Various implementations for FreeRTOS, Zephyr, Micrium, etc.
- **Hardware RNG**: Examples for STM32, NXP, Renesas, Infineon, and other platforms

### Summary of Configuration Options

| Define | Purpose | Requires |
|--------|---------|----------|
| `NO_DEV_URANDOM` | Disable /dev/urandom | Falls back to /dev/random |
| `NO_DEV_RANDOM` | Disable /dev/urandom and /dev/random | Alternative seed source |
| `WC_NO_HASHDRBG` | Disable Hash_DRBG entirely | `CUSTOM_RAND_GENERATE_BLOCK` |
| `CUSTOM_RAND_GENERATE_BLOCK` | Provide complete RNG replacement | Function implementation |
| `CUSTOM_RAND_GENERATE_SEED` | Custom seed generation function | Function implementation |
| `CUSTOM_RAND_GENERATE` | Custom random value function | Function + `CUSTOM_RAND_TYPE` |
| `WC_RNG_SEED_CB` | Enable runtime seed callback | `wc_SetSeed_Cb()` usage |
| `WOLF_CRYPTO_CB` | Enable crypto callbacks | Callback registration |
| `WOLFSSL_GENSEED_FORTEST` | Fake seed for testing | **Testing only!** |

### Recommendations

1. **Use the default DRBG** when possible - it's FIPS-certified and well-tested
2. **For embedded systems without /dev/random**: Use `CUSTOM_RAND_GENERATE_SEED` with your hardware RNG
3. **For HSM/TPM integration**: Use crypto callbacks with `WC_ALGO_TYPE_SEED`
4. **For maximum flexibility**: Use `wc_SetSeed_Cb()` to set callbacks at runtime
5. **Never use** `WOLFSSL_GENSEED_FORTEST` in production

For additional examples and reference implementations, see:
- `./wolfcrypt/src/random.c` - All seed generation implementations
- `wolfssl-examples/tls/cryptocb-common.c` - Crypto callback example with WC_ALGO_TYPE_SEED
- Platform-specific examples in `./wolfcrypt/src/port/` directoriesc.

## Memory

Q:  When do I need to read this section?
A:  When you don’t have standard memory functions available or are interested in memory usage differences between optional math libraries.

wolfSSL proper uses both malloc() and free() by default.  When using the normal big integer math library, wolfCrypt will also use realloc().  

By default wolfSSL/wolfCrypt use the normal big integer math library, which uses quite a bit of dynamic memory.  When building wolfSSL, the fastmath library can be enabled, which is both faster and uses no dynamic memory for crypto operations (all on the stack).  By using fastmath, wolfSSL won't need a realloc() implementation at all.  As the SSL layer of wolfSSL still uses some dynamic memory, malloc() and free() are still required.

For a comparison of resource usage (stack/heap) between the big integer math library and fastmath library, ask us to see our Resource Use document.

To enable fastmath, define USE_FAST_MATH and build in ./wolfcrypt/src/tfm.c instead of ./wolfcrypt/src/integer.c.  Since the stack memory can be large when using fastmath, we recommend defining TFM_TIMING_RESISTANT as well.

If the normal malloc(), free(), and possibly realloc() functions are not available, define XMALLOC_USER, then provide custom memory function hooks in ./wolfssl/wolfcrypt/types.h specific to the target environment.  

Please read section 5.1.1.1 of the wolfSSL Manual for details about using XMALLOC_USER:
[Section 5.1.1.1](https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-5-portability.html)

## Time

Q:  When do I need to read this section?
A:  When standard time functions (time(), gmtime()) are not available, or you need to specify a custom clock tick function.

By default, wolfSSL uses time(), gmtime(), and ValidateDate(), as specified in ./wolfcrypt/src/asn.c.  These are abstracted to XTIME, XGMTIME, and XVALIDATE_DATE.  If the standard time functions, and time.h, are not available, the user can define USER_TIME.  After defining USER_TIME, the user can define their own XTIME, XGMTIME, and XVALIDATE_DATE functions.

wolfSSL uses time(0) by default for the clock tick function.  This is located in ./src/internal.c inside of the LowResTimer() function.

Defining USER_TICKS allows the user to define their own clock tick function if time(0) is not wanted. The custom function needs second accuracy, but doesn’t have to be correlated to EPOCH.  See LowResTimer() function in ./src/internal.c for reference.

## C Standard Library

Q:  When do I need to read this section?
A:  When you don’t have a C standard library available, or have a custom one.

wolfSSL can be built without the C standard library to provide a higher level of portability and flexibility to developers.  When doing so, the user needs to map functions they wish to use instead of the C standard ones.

Section 2.8, above, covered memory functions.  In addition to memory function abstraction, wolfSSL also abstracts string function and math functions, where the specific functions are typically abstracted to a define in the form of X<FUNC>, where <FUNC> is the name of the function being abstracted.

Please read Section 5.1 of the wolfSSL Manual for details:
[Section 5.1](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-5-portability.html)

## Logging

Q:  When do I need to read this section?
A:  You want to enable debug messages but don’t have stderr available.

By default, wolfSSL provides debug output through stderr.  In order for debug messages to be enabled, wolfSSL must be compiled with DEBUG_WOLFSSL defined, and wolfSSL_Debugging_ON() must be called from the application code.  wolfSSL_Debugging_OFF() may be used by the application layer to turn off wolfSSL debug messages.

For environments which do not have stderr available, or wish to output debug messages over a different output stream or in a different format, wolfSSL allows applications to register a logging callback.

Please read Section 8.1 of the wolfSSL Manual for details:
[Section 8.1](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-8-debugging.html)

## Public Key Operations

Q:  When do I need to read this section?
A:  You want to use your own public key implementation with wolfSSL.

wolfSSL allows users to write their own public key callbacks which will be called when the SSL/TLS layer needs to do public key operations.  The user can optionally define 6 functions:

ECC sign callback
ECC verify callback
RSA sign callback
RSA verify callback
RSA encrypt callback
RSA decrypt callback

For full details, please read Section 6.4 of the wolfSSL Manual:
[Section 6.4](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-6-callbacks.html)

## Atomic Record Layer Processing

Q:  When do I need to read this section?
A:  You want to do your own processing of record layers, specifically MAC/encrypt and decrypt/verify operations.

By default, wolfSSL handles record layer processing for the user using its cryptography library, wolfCrypt.  wolfSSL provides Atomic Record Processing callbacks for users who wish to have more control over MAC/encrypt and decrypt/verify functionality during the SSL/TLS connection.

The user will need to define 2 functions:
MAC/encrypt callback function
Decrypt/verify callback function

For full details, please read Section 6.3 of the wolfSSL Manual:
[Section 6.3](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-6-callbacks.html)

## Features

Q:  When do I need to read this section?
A:  When you want to disable features.

Features can be disabled when building wolfSSL by using the appropriate defines.  For a list of defines available, please refer to Chapter 2 of the wolfSSL Manual:
[Chapter 2](https://www.wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html)
