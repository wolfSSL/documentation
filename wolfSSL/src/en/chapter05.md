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

See the header `wolfssl/wolfcrypt/memory.h` for the callback prototypes and `memory.c` for the implementation.

#### string.h

wolfSSL uses several functions that behave like `string.h`’s `memcpy()`, `memset()`, and `memcmp()` amongst others. They are abstracted to `XMEMCPY()`, `XMEMSET()`, and `XMEMCMP()` respectively.  And by default, they point to the C standard library versions.  Defining `STRING_USER` allows the user to provide their own hooks in `types.h`. For example, by default `XMEMCPY()` is:

```c
#define XMEMCPY(d,s,l)    memcpy((d),(s),(l))
```

After defining `STRING_USER` you could do:

```c
#define XMEMCPY(d,s,l)    my_memcpy((d),(s),(l))
```

Or if you prefer to avoid macros:

```c
external void* my_memcpy(void* d, const void* s, size_t n);
```

to set wolfSSL’s abstraction layer to point to your version `my_memcpy()`.

#### math.h

wolfSSL uses two functions that behave like `math.h`’s `pow()` `log()`. They are only required by Diffie-Hellman, so if you exclude DH from the build, then you don’t have to provide your own. They are abstracted to `XPOW()` and `XLOG()` and found in `wolfcrypt/src/dh.c`.

#### File System Use

By default, wolfSSL uses the system’s file system for the purpose of loading keys and certificates. This can be turned off by defining `NO_FILESYSTEM`, see item V. If instead, you’d like to use a file system but not the system one, you can use the `XFILE()` layer in `ssl.c` to point the file system calls to the ones you’d like to use.  See the example provided by the MICRIUM define.

### Custom Input/Output Abstraction Layer

wolfSSL provides a custom I/O abstraction layer for those who wish to have higher control over I/O of their SSL connection or run SSL on top of a different transport medium other than TCP/IP.

The user will need to define two functions:

1. The network Send function
2. The network Receive function

These two functions are prototyped by `CallbackIOSend` and `CallbackIORecv` in `ssl.h`:

```c
typedef int (*CallbackIORecv)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
typedef int (*CallbackIOSend)(WOLFSSL *ssl, char *buf, int sz, void *ctx);
```

The user needs to register these functions per `WOLFSSL_CTX` with `wolfSSL_SetIOSend()` and `wolfSSL_SetIORecv()`.  For example, in the default case, `CBIORecv()` and `CBIOSend()` are registered at the bottom of `io.c`:

```c
void wolfSSL_SetIORecv(WOLFSSL_CTX *ctx, CallbackIORecv CBIORecv)
{
     ctx->CBIORecv = CBIORecv;
}

void wolfSSL_SetIOSend(WOLFSSL_CTX *ctx, CallbackIOSend CBIOSend)
{
    ctx->CBIOSend = CBIOSend;
}
```

The user can set a context per WOLFSSL object (session) with `wolfSSL_SetIOWriteCtx()` and `wolfSSL_SetIOReadCtx()`, as demonstrated at the bottom of `io.c`.  For example, if the user is using memory buffers, the context may be a pointer to a structure describing where and how to access the memory buffers.  The default case, with no user overrides, registers the socket as the context.

The `CBIORecv` and `CBIOSend` function pointers can be pointed to your custom I/O functions. The default `Send()` and `Receive()` functions, `EmbedSend()` and `EmbedReceive()`, located in `io.c`, can be used as templates and guides.

`WOLFSSL_USER_IO` can be defined to remove the automatic setting of the default I/O functions `EmbedSend()` and `EmbedReceive()`.

### Operating System Abstraction Layer

The wolfSSL OS abstraction layer helps facilitate easier porting of wolfSSL to a user’s operating system.  The `wolfssl/wolfcrypt/settings.h` file contains settings which end up triggering the OS layer.

OS-specific defines are located in `wolfssl/wolfcrypt/types.h` for wolfCrypt and `wolfssl/internal.h` for wolfSSL.

## Supported Operating Systems

One factor which defines wolfSSL is its ability to be easily ported to new platforms.  As such, wolfSSL has support for a long list of operating systems out-of-the-box.  Currently-supported operating systems include:

* Win32/64
* Linux
* Mac OS X
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
* TRON/ITRON/µITRON
* Micrium's µC/OS-III
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
* µT-Kernel
* RIOT
* CMSIS-RTOS
* FROSTED
* Green Hills INTEGRITY
* Keil RTX
* TOPPERS
* PetaLinux
* Apache Mynewt

## Supported Chipmakers

wolfSSL has support for chipsets including ARM, Intel, Motorola, mbed, Freescale, Microchip (PIC32), STMicro (STM32F2/F4), NXP, Analog Devices, Texas Instruments, AMD and more.

## C# Wrapper

wolfSSL has limited support for use in C#. A Visual Studio project containing the port can be found in the directory `root_wolfSSL/wrapper/CSharp/`. After opening the Visual Studio project set the “Active solution configuration” and “Active solution platform” by clicking on BUILD-\>Configuration Manager… The supported “Active solution configuration”s are DLL Debug and DLL Release. The supported platforms are Win32 and x64.

Once having set the solution and platform the preprocessor flag `HAVE_CSHARP` will need to be added. This turns on the options used by the C# wrapper and used by the examples included.

To then build simply select build solution. This creates the `wolfssl.dll`, `wolfSSL_CSharp.dll` and examples. Examples can be ran by targeting them as an entry point and then running debug in Visual Studio.

Adding the created C# wrapper to C# projects can be done a couple of ways. One way is to install the created `wolfssl.dll` and `wolfSSL_CSharp.dll` into the directory `C:/Windows/System/`. This will allow projects that have:

```cs
using wolfSSL.CSharp

public some_class {

    public static main(){
    wolfssl.Init()
    ...
}
...
```

to make calls to the wolfSSL C# wrapper. Another way is to create a Visual Studio project and have it reference the bundled C# wrapper solution in wolfSSL.
