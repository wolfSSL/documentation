# Debugging

## Debugging and Logging

wolfSSL (formerly CyaSSL) has support for debugging through log messages in environments where debugging is limited. To turn logging on use the function [`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on) and to turn it off use [`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off). In a normal build (release mode) these functions will have no effect. In a debug build, define [`DEBUG_WOLFSSL`](chapter02.md#debug_wolfssl) to ensure these functions are turned on. The [`--enable-debug`](chapter02.md#--enable-debug) configure option defines `DEBUG_WOLFSSL`. Without it, `wolfSSL_Debugging_ON()` and `wolfSSL_SetLoggingCb()` return `NOT_COMPILED_IN`.

As of wolfSSL 2.0, logging callback functions may be registered at runtime to provide more flexibility with how logging is done. The logging callback can be registered with the function [`wolfSSL_SetLoggingCb()`](group__Logging.md#function-wolfssl_setloggingcb):

```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```

The log levels can be found in `wolfssl/wolfcrypt/logging.h`, and the implementation is located in `logging.c`.  By default, wolfSSL logs to `stderr` with `fprintf`.

### Controlling Log Output

When no logging callback is registered, the output can be redirected at compile time:

* `WOLFSSL_DEBUG_PRINTF_FN` replaces `fprintf` with another printf-like function, and `WOLFSSL_DEBUG_PRINTF_FIRST_ARGS` replaces its leading arguments (`stderr,` by default, including the trailing comma; it can be defined to nothing).
* `WOLFSSL_USER_LOG(msg)` can be defined to a function or macro that receives each complete log message.

`wolfSSL_SetLoggingPrefix()` sets a prefix string that is printed, in brackets, before each message written by the default `WOLFSSL_DEBUG_PRINTF_FN` output (it is not passed to a logging callback). The prefix is stored per thread where the compiler supports thread-local storage, which is useful to tell apart, for example, a client and a server running in one process.

Certificate-related debug messages are a subset of the debug output. They are on by default with `DEBUG_WOLFSSL` and can be turned off with `NO_WOLFSSL_DEBUG_CERTS`. Defining [`WOLFSSL_DEBUG_CERTS`](chapter02.md#wolfssl_debug_certs) without `DEBUG_WOLFSSL` compiles in only the certificate messages. They are off at run time until `wolfSSL_CertDebugging_ON()` is called (`wolfSSL_Debugging_ON()` returns `NOT_COMPILED_IN` in such a build), or define `WOLFSSL_CERT_LOG_ENABLED_DEFAULT` to 1 to have them on from the start. `wolfSSL_CertDebugging_OFF()` turns them off again.

Two configure options add more detail to the debug output:

* `--enable-debug-code-points` adds the source file and line number to the debug messages (`WOLFSSL_DEBUG_CODEPOINTS`).
* `--enable-debug-trace-errcodes` prints a trace message where a library error code is raised (`WOLFSSL_DEBUG_TRACE_ERROR_CODES`). `--enable-debug-trace-errcodes=backtrace` also prints a backtrace, using `libbacktrace`.

### Verbose Logging

wolfSSL 5.9.4 moved the highest-volume trace messages into a separate tier: `WOLFSSL_MSG_VERBOSE()` and `WOLFSSL_ENTER_VERBOSE()`. These are the container helpers, name entry handling and similar code that a single API call can hit thousands of times. They are compiled out of a normal `DEBUG_WOLFSSL` build, which cuts the volume of debug output considerably (about 62% for the unit test suite). To see them, define `WOLFSSL_VERBOSE_LOGGING` in addition to `DEBUG_WOLFSSL`:

```sh
./configure --enable-debug CPPFLAGS=-DWOLFSSL_VERBOSE_LOGGING
```

`WOLFSSL_VERBOSE_LOGGING` on its own produces no output; it only admits the verbose traces into a build that is already logging. The older `WOLFSSL_DEBUG_OPENSSL` macro, which did the same job inside the OpenSSL compatibility layer, now works as an alias for it.

## Error Codes

wolfSSL tries to provide informative error messages in order to help with debugging.

[//]: # (This is a comment. links to group__IO.md and group__Debug.md are causing lines to be truncated so I have removed references to them.)

Each `wolfSSL_read()` and `wolfSSL_write()` call will return the number of bytes read or written upon success, 0 upon connection closure, and -1 for an error,  just like `read()` and `write()`.  In the event of an error you can use two calls to get more information about the error.

The function `wolfSSL_get_error()` will return the current error code. It takes the current `WOLFSSL` object, and `wolfSSL_read()` or `wolfSSL_write()` result value as arguments and returns the current error code.

```c
int err = wolfSSL_get_error(ssl, result);
```

To get a more human-readable error code description, the `wolfSSL_ERR_error_string()` function can be used.  It takes the return code from `wolfSSL_get_error` and a storage buffer as arguments, and places the corresponding error description into the storage buffer (`errorString` in the example below).

```c
char errorString[WOLFSSL_MAX_ERROR_SZ];
wolfSSL_ERR_error_string(err, errorString);
```

The buffer must hold at least `WOLFSSL_MAX_ERROR_SZ` bytes (80 by default, 200 in some configurations). Alternatively, `wolfSSL_ERR_error_string_n(err, buf, sizeof(buf))` takes the buffer length. For return codes from wolfCrypt functions, `wc_GetErrorString()` returns a description string.

If you are using non blocking sockets, you can test for errno EAGAIN/EWOULDBLOCK or more correctly you can test the specific error code for `WOLFSSL_ERROR_WANT_READ` or `WOLFSSL_ERROR_WANT_WRITE`.

For a list of wolfSSL and wolfCrypt error codes, please see [Error Codes](appendix06.md).
