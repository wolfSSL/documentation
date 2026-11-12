# Library Design

## Library Headers

With the release of wolfSSL 2.0.0 RC3, library header files are now located in the following locations:

* wolfSSL: `wolfssl/`
* wolfCrypt: `wolfssl/wolfcrypt/`
* wolfSSL OpenSSL Compatibility Layer: `wolfssl/openssl/`

When using the OpenSSL Compatibility layer (see [OpenSSL Compatibility](chapter13.md#openssl-compatibility)), the `/wolfssl/openssl/ssl.h` header is required to be included:

```c
#include <wolfssl/openssl/ssl.h>
```

When using only the wolfSSL native API, only the `/wolfssl/ssl.h` header is required to be included:

```c
#include <wolfssl/ssl.h>
```

Applications must include the wolfSSL build configuration before any other wolfSSL header, so that the application and the library agree on the enabled features and structure layouts. For a `./configure` build, include `wolfssl/options.h` first, or define `WOLFSSL_USE_OPTIONS_H` so that `settings.h` includes it automatically:

```c
#include <wolfssl/options.h>
#include <wolfssl/ssl.h>
```

For a build configured with `user_settings.h`, define [`WOLFSSL_USER_SETTINGS`](chapter02.md#wolfssl_user_settings) when compiling the application so that `settings.h` includes `user_settings.h`. If no configuration is detected, `settings.h` emits the warning "No configuration for wolfSSL detected, check header order".

## Startup and Exit

All applications should call [`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init) before using the library and call [`wolfSSL_Cleanup()`](group__TLS.md#function-wolfssl_cleanup) at program termination. `wolfSSL_Init()` is reference counted. The first call initializes wolfCrypt (`wolfCrypt_Init()`), the global RNG and RAND mutexes, the session cache locks and other global state. Call `wolfSSL_Cleanup()` once for each successful `wolfSSL_Init()`. Applications that only use wolfCrypt should call `wolfCrypt_Init()` and `wolfCrypt_Cleanup()` instead.

## Structure Usage

In addition to header file location changes, the release of wolfSSL 2.0.0 RC3 created a more visible distinction between the native wolfSSL API and the wolfSSL OpenSSL Compatibility Layer.  With this distinction, the main SSL/TLS structures used by the native wolfSSL API have changed names.  The new structures are as follows.  The previous names are still used when using the OpenSSL Compatibility Layer (see [OpenSSL Compatibility](chapter13.md#openssl-compatibility)).

* `WOLFSSL`         (previously SSL)
* `WOLFSSL_CTX`     (previously SSL_CTX)
* `WOLFSSL_METHOD`      (previously SSL_METHOD)
* `WOLFSSL_SESSION` (previously SSL_SESSION)
* `WOLFSSL_X509`        (previously X509)
* `WOLFSSL_X509_NAME`   (previously X509_NAME)
* `WOLFSSL_X509_CHAIN`  (previously X509_CHAIN)

## Thread Safety

wolfSSL (formerly CyaSSL) is thread safe by design. Multiple threads can enter the library simultaneously without creating conflicts because wolfSSL avoids global data, static data, and the sharing of objects. The user must still take care to avoid potential problems in some areas.

1. A client may share a WOLFSSL object across multiple threads but access must be synchronized, i.e., trying to read/write at the same time from two different threads with the same SSL pointer is not supported. To read in one thread and write in another, build wolfSSL with `--enable-writedup` and use `wolfSSL_write_dup()` to create a write-only `WOLFSSL` object.

    wolfSSL could take a more aggressive (constrictive) stance and lock out other users when a function is entered that cannot be shared but this level of granularity seems counter-intuitive. All users (even single threaded ones) will pay for the locking and multi-thread ones won't be able to re-enter the library even if they aren't sharing objects across threads. This penalty seems much too high and wolfSSL leaves the responsibility of synchronizing shared objects in the hands of the user.

2. Besides sharing WOLFSSL pointers, users must also take care to completely initialize a `WOLFSSL_CTX` before passing the structure to [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new). The same `WOLFSSL_CTX` can create multiple `WOLFSSL` structs. Many settings are copied into the `WOLFSSL` object by [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new), but the object also keeps a reference to its `WOLFSSL_CTX` and reads some items from it at use time, for example the certificate manager (trusted CAs, CRL and OCSP) and the public key callbacks. Changes to the `WOLFSSL_CTX` after `wolfSSL_new()` (or simultaneous changes) may therefore affect existing objects, so do not modify a `WOLFSSL_CTX` while it is in use by other threads.

    Again, multiple threads should synchronize writing access to a `WOLFSSL_CTX` and it is advised that a single thread initialize the `WOLFSSL_CTX` to avoid the synchronization and update problem described above.

3. Some optimizations allocate memory on a per thread basis. If fixed point ECC cache is enabled (`FP_ECC`), then threads should release the cached buffers using `wc_ecc_fp_free()` before the thread exits.

## Input and Output Buffers

wolfSSL now uses dynamic buffers for input and output. The static input and output buffers default to `RECORD_HEADER_SZ` (5 bytes) and are controlled by the [`STATIC_BUFFER_LEN`](chapter02.md#static_buffer_len) and [`LARGE_STATIC_BUFFERS`](chapter02.md#large_static_buffers) defines in `wolfssl/internal.h`. If an input record is received that is greater in size than the static buffer, then a dynamic buffer is temporarily used to handle the request and then freed. The maximum record size, `MAX_RECORD_SIZE`, is 2^14 or 16,384.

If you prefer the previous way that wolfSSL operated, with 16 KB static buffers that will never need dynamic memory, you can still get that option by defining `LARGE_STATIC_BUFFERS`. Defining `WOLFSSL_CALLBACKS` also turns on `LARGE_STATIC_BUFFERS`.

If dynamic buffers are used and the user requests a [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) that is bigger than the buffer size, then a dynamic block up to `MAX_RECORD_SIZE` is used to send the data. Users wishing to only send the data in chunks of at most `RECORD_SIZE` size can do this by defining `STATIC_CHUNKS_ONLY`.  This will cause wolfSSL to use I/O buffers which grow up to `RECORD_SIZE`, which is 128 bytes by default (`MAX_MTU` when DTLS is enabled, and `MAX_RECORD_SIZE` with `LARGE_STATIC_BUFFERS`). A user-supplied `RECORD_SIZE` must be between 128 and `MAX_RECORD_SIZE`, otherwise the build fails.
