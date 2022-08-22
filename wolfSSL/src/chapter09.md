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

## Startup and Exit

All applications should call [`wolfSSL_Init()`](group__TLS.md#function-wolfssl_init) before using the library and call [`wolfSSL_Cleanup()`](group__TLS.md#function-wolfssl_cleanup) at program termination. Currently these functions only initialize and free the shared mutex for the session cache in multi-user mode but in the future they may do more so it's always a good idea to use them.

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

1. A client may share an WOLFSSL object across multiple threads but access must be synchronized, i.e., trying to read/write at the same time from two different threads with the same SSL pointer is not supported.

    wolfSSL could take a more aggressive (constrictive) stance and lock out other users when a function is entered that cannot be shared but this level of granularity seems counter-intuitive. All users (even single threaded ones) will pay for the locking and multi-thread ones won't be able to re-enter the library even if they aren't sharing objects across threads. This penalty seems much too high and wolfSSL leaves the responsibility of synchronizing shared objects in the hands of the user.

2. Besides sharing WOLFSSL pointers, users must also take care to completely initialize an `WOLFSSL_CTX` before passing the structure to [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new). The same `WOLFSSL_CTX` can create multiple `WOLFSSL` structs but the `WOLFSSL_CTX` is only read during [`wolfSSL_new()`](group__Setup.md#function-wolfssl_new) creation and any future (or simultaneous changes) to the `WOLFSSL_CTX` will not be reflected once the `WOLFSSL` object is created.

    Again, multiple threads should synchronize writing access to a `WOLFSSL_CTX` and it is advised that a single thread initialize the `WOLFSSL_CTX` to avoid the synchronization and update problem described above.

3. Some optimizations allocate memory on a per thread basis. If fixed point ECC cache is enabled (`FP_ECC`), then threads should release the cached buffers using `wc_ecc_fp_free()` before the thread exits.

## Input and Output Buffers

wolfSSL now uses dynamic buffers for input and output. They default to 0 bytes and are controlled by the `RECORD_SIZE` define in `wolfssl/internal.h`. If an input record is received that is greater in size than the static buffer, then a dynamic buffer is temporarily used to handle the request and then freed. You can set the static buffer size up to the `MAX_RECORD_SIZE` which is 2^16 or 16,384.

If you prefer the previous way that wolfSSL operated, with 16Kb static buffers that will never need dynamic memory, you can still get that option by defining `LARGE_STATIC_BUFFERS`.

If dynamic buffers are used and the user requests a [`wolfSSL_write()`](group__IO.md#function-wolfssl_write) that is bigger than the buffer size, then a dynamic block up to `MAX_RECORD_SIZE` is used to send the data. Users wishing to only send the data in chunks of at most `RECORD_SIZE` size can do this by defining `STATIC_CHUNKS_ONLY`.  This will cause wolfSSL to use I/O buffers which grow up to `RECORD_SIZE`, which is 128 bytes by default.
