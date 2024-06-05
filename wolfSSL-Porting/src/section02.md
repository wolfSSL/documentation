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
A:  Either /dev/random or /dev/urandom is not available or you want to integrate into a hardware RNG.

By default, wolfSSL uses /dev/urandom or /dev/random to generate a RNG seed.  The NO_DEV_RANDOM define can be used when building wolfSSL to disable the default GenerateSeed() function.  If this is defined, you need to write a custom GenerateSeed() function in ./wolfcrypt/src/random.c, specific to your target platform.  This allows you to seed wolfSSL’s PRNG with a hardware-based random entropy source if available.

For examples of how GenerateSeed() needs to be written, reference wolfSSL’s existing GenerateSeed() implementations in ./wolfcrypt/src/random.c.

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
