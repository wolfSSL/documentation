# Portability

## Abstraction Layers

### C Standard Library Abstraction Layer

wolfSSL (formerly CyaSSL) can be built without the C standard library to provide a higher level of portability and flexibility to developers. The user will have to map the functions they wish to use instead of the C standard ones.

#### Memory Use

Most C programs use `malloc()` and `free()` for dynamic memory allocation. wolfSSL uses `XMALLOC()` and `XFREE()` instead. By default, these point to the C runtime versions. By defining `XMALLOC_USER`, the user can provide their own hooks. Each memory function takes two additional arguments over the standard ones, a heap hint, and an allocation type. The user is free to ignore these or use them in any way they like.  You can find the wolfSSL memory functions in `wolfssl/wolfcrypt/types.h`.

wolfSSL also provides the ability to register memory override functions at runtime instead of compile time. `wolfssl/wolfcrypt/memory.h` is the header for this functionality and the user can call the following function to set up the memory functions:

```c
int wolfSSL_SetAllocators(wolfSSL_Malloc_cb  malloc_function,
                         wolfSSL_Free_cb    free_function,
                         wolfSSL_Realloc_cb realloc_function);
```

See the header `wolfssl/wolfcrypt/memory.h` for the callback prototypes and `memory.c` for the implementation. The prototypes depend on the build. By default they match `malloc()`, `free()` and `realloc()`. With `WOLFSSL_STATIC_MEMORY` defined, each callback also takes the heap hint and allocation type (`void* heap, int type`), and with `WOLFSSL_DEBUG_MEMORY` defined, each callback also takes the calling function name and line number (`const char* func, unsigned int line`). The functions currently registered can be read back with `wolfSSL_GetAllocators()`.

For systems without a heap, see the static memory feature (`WOLFSSL_STATIC_MEMORY`) described in [Static Buffer Allocation Option](chapter04.md#static-buffer-allocation-option).

#### string.h

wolfSSL uses several functions that behave like `string.h`'s `memcpy()`, `memset()`, and `memcmp()` amongst others. They are abstracted to `XMEMCPY()`, `XMEMSET()`, and `XMEMCMP()` respectively.  And by default, they point to the C standard library versions.  Defining [`STRING_USER`](chapter02.md#string_user) allows the user to provide their own hooks in `types.h`. With `STRING_USER` defined, `types.h` defines none of the string macros, so the user must provide all of them: `XMEMCPY`, `XMEMSET`, `XMEMCMP`, `XMEMMOVE`, `XSTRLEN`, `XSTRNCPY`, `XSTRSTR`, `XSTRNSTR`, `XSTRCMP`, `XSTRNCMP`, `XSTRNCAT`, `XSTRCASECMP`, `XSTRNCASECMP`, `XSTRTOK`, `XSTRSEP`, `XSNPRINTF` and `XSPRINTF`. If `XATOI` is not defined, it falls back to `atoi()` from `<stdlib.h>`, but only for the features that need it. For example, by default `XMEMCPY()` is:

```c
#define XMEMCPY(d,s,l)    memcpy((d),(s),(l))
```

After defining `STRING_USER` you could do:

```c
#define XMEMCPY(d,s,l)    my_memcpy((d),(s),(l))
```

Or, instead of a macro, implement a function named `XMEMCPY` and declare it where wolfSSL can see it (e.g. in `user_settings.h`):

```c
extern void* XMEMCPY(void* d, const void* s, size_t n);
```

wolfSSL always calls `XMEMCPY()`, so a function with another name, such as `my_memcpy()`, is only used if a macro maps `XMEMCPY()` to it as shown above.

#### math.h

wolfSSL uses two functions that behave like `math.h`'s `pow()` `log()`. They are only required by Diffie-Hellman, so if you exclude DH from the build, then you don't have to provide your own. They are abstracted to `XPOW()` and `XLOG()` and found in `wolfcrypt/src/dh.c`. Define `USER_MATH_LIB` to supply your own `XPOW()` and `XLOG()`, or define [`WOLFSSL_DH_CONST`](chapter02.md#wolfssl_dh_const) to avoid needing them at all.

#### File System Use

By default, wolfSSL uses the system's file system for the purpose of loading keys and certificates. This can be turned off by defining [`NO_FILESYSTEM`](chapter02.md#no_filesystem). If instead, you'd like to use a file system but not the system one, you can use the `XFILE`/`XFOPEN`/`XFREAD`/... abstraction layer in the FILESYSTEM SECTION of `wolfssl/wolfcrypt/wc_port.h` to point the file system calls to the ones you'd like to use.  See the example provided by the `MICRIUM` define in that file. Define `WOLFSSL_USER_FILESYSTEM` to supply all of these definitions yourself (for example in `user_settings.h`).

### Custom Input/Output Abstraction Layer

wolfSSL provides a custom I/O abstraction layer for those who wish to have higher control over I/O of their SSL connection or run SSL on top of a different transport medium other than TCP/IP.

The user will need to define two functions:

1. The network Send function
2. The network Receive function

These two functions are prototyped by `CallbackIOSend` and `CallbackIORecv` in `wolfssl/wolfio.h`:

```c
typedef int (*CallbackIORecv)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
typedef int (*CallbackIOSend)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
```

The user needs to register these functions per `WOLFSSL_CTX` with `wolfSSL_CTX_SetIOSend()` and `wolfSSL_CTX_SetIORecv()`, or per `WOLFSSL` object with `wolfSSL_SSLSetIOSend()` and `wolfSSL_SSLSetIORecv()`. The older names `wolfSSL_SetIOSend()` and `wolfSSL_SetIORecv()` are deprecated aliases of the `WOLFSSL_CTX` functions. In the default case, `EmbedReceive()` and `EmbedSend()` are registered when the `WOLFSSL_CTX` is created (`InitSSL_Ctx()` in `src/internal.c`). For example, to register your own functions:

```c
int myRecv(WOLFSSL* ssl, char* buf, int sz, void* ctx);
int mySend(WOLFSSL* ssl, char* buf, int sz, void* ctx);

wolfSSL_CTX_SetIORecv(ctx, myRecv);
wolfSSL_CTX_SetIOSend(ctx, mySend);
```

The user can set a context per WOLFSSL object (session) with `wolfSSL_SetIOWriteCtx()` and `wolfSSL_SetIOReadCtx()`, which are implemented in `src/wolfio.c`.  For example, if the user is using memory buffers, the context may be a pointer to a structure describing where and how to access the memory buffers.  The default case, with no user overrides, registers the socket as the context.

The receive callback returns the number of bytes it placed in `buf`, and the send callback returns the number of bytes it sent from `buf`. On failure, or when no data can be transferred yet, a callback returns one of the following values from `enum IOerrors` in `wolfssl/error-ssl.h`:

| Return value | Meaning |
| --- | --- |
| `WOLFSSL_CBIO_ERR_GENERAL` (-1) | General, unexpected error |
| `WOLFSSL_CBIO_ERR_WANT_READ` (-2) | Non-blocking: no data available yet, read must be called again |
| `WOLFSSL_CBIO_ERR_WANT_WRITE` (-2) | Non-blocking: data cannot be sent yet, write must be called again |
| `WOLFSSL_CBIO_ERR_CONN_RST` (-3) | Connection reset |
| `WOLFSSL_CBIO_ERR_ISR` (-4) | Interrupt |
| `WOLFSSL_CBIO_ERR_CONN_CLOSE` (-5) | Connection closed or EPIPE |
| `WOLFSSL_CBIO_ERR_TIMEOUT` (-6) | Socket timeout |

The default `Send()` and `Receive()` functions, `EmbedSend()` and `EmbedReceive()`, located in `src/wolfio.c` (prototypes in `wolfssl/wolfio.h`), can be used as templates and guides. For a simple memory-based example, see `mem_send()` and `mem_recv()` in `examples/tls13/tls13_memio.c`.

`WOLFSSL_USER_IO` can be defined to remove the automatic setting of the default I/O functions `EmbedSend()` and `EmbedReceive()`.

### Operating System Abstraction Layer

The wolfSSL OS abstraction layer helps facilitate easier porting of wolfSSL to a user's operating system.  The `wolfssl/wolfcrypt/settings.h` file contains settings which end up triggering the OS layer.

OS-specific threading, mutex, filesystem and time abstractions are located in `wolfssl/wolfcrypt/wc_port.h` and `wolfcrypt/src/wc_port.c`. Memory and string macros are located in `wolfssl/wolfcrypt/types.h`. For a step-by-step guide to porting wolfSSL to a new platform, see [wolfSSL Porting Guide](appendix10.md).

## Supported Operating Systems

One factor which defines wolfSSL is its ability to be easily ported to new platforms.  As such, wolfSSL has support for a long list of operating systems out-of-the-box.  Currently-supported operating systems include:

* Win32/64
* Linux
* macOS
* Solaris
* ThreadX
* VxWorks
* FreeBSD
* NetBSD
* OpenBSD
* embedded Linux
* Yocto Linux
* OpenEmbedded
* WinCE
* Haiku
* OpenWRT
* iPhone (iOS)
* Android
* Nintendo Wii and Gamecube through DevKitPro
* QNX
* MontaVista
* NonStop
* TRON/ITRON/uITRON
* Micrium's uC/OS-III
* FreeRTOS
* SafeRTOS
* NXP/Freescale MQX
* Nucleus
* TinyOS
* HP/UX
* AIX
* ARC MQX
* TI-RTOS
* uTasker
* embOS
* INtime
* Mbed
* uT-Kernel
* RIOT
* CMSIS-RTOS
* FROSTED
* Green Hills INTEGRITY
* Keil RTX
* TOPPERS
* PetaLinux
* Apache Mynewt
* Zephyr
* Espressif ESP-IDF
* Linux kernel module (`linuxkm/`)
* FreeBSD kernel module (`bsdkm/`)
* Azure Sphere
* Deos
* Telit M2MB
* ChibiOS
* NET+OS
* Intel SGX
* Arduino
* Raspberry Pi Pico

## Supported Chipmakers

wolfSSL has support for chipsets including ARM, Intel, Motorola, mbed, Freescale, Microchip (PIC32, ATECC), STMicro (STM32), NXP, Analog Devices (Maxim), Texas Instruments, AMD (Xilinx), Espressif, Renesas, Infineon (Cypress), Silicon Labs, Nordic, Nuvoton, Realtek, Altera, Raspberry Pi and more. Hardware-specific ports are found in `wolfcrypt/src/port/`.

## C# Wrapper

wolfSSL has limited support for use in C#. A Visual Studio project containing the port can be found in the directory `root_wolfSSL/wrapper/CSharp/`. After opening the Visual Studio project set the "Active solution configuration" and "Active solution platform" by clicking on BUILD-\>Configuration Manager... The supported "Active solution configuration"s are DLL Debug and DLL Release. The supported platforms are Win32 and x64.

The solution `wrapper/CSharp/wolfSSL_CSharp.sln` builds wolfSSL using `wrapper/CSharp/user_settings.h` (the project defines `WOLFSSL_USER_SETTINGS`), so no additional preprocessor flags need to be added.

To then build simply select build solution. This creates the `wolfssl.dll`, `wolfSSL_CSharp.dll` and examples. Examples can be run by setting them as the startup project and then running debug in Visual Studio.

On Linux the wrapper can be used with Mono: copy `wrapper/CSharp/user_settings.h` to the wolfSSL root directory, build and install wolfSSL with `./configure --enable-usersettings`, then compile the wrapper and examples with `mcs`. See `wrapper/CSharp/README.md` for the full steps.

Adding the created C# wrapper to C# projects can be done a couple of ways. One way is to install the created `wolfssl.dll` and `wolfSSL_CSharp.dll` into the directory `C:/Windows/System/`. This will allow projects that have:

```cs
using wolfSSL.CSharp;

public class SomeClass {

    public static void Main() {
        wolfssl.Init();
        ...
    }
    ...
}
```

to make calls to the wolfSSL C# wrapper. Another way is to create a Visual Studio project and have it reference the bundled C# wrapper solution in wolfSSL.
