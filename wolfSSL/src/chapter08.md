# Debugging

## Debugging and Logging

wolfSSL (formerly CyaSSL) has support for debugging through log messages in environments where debugging is limited. To turn logging on use the function [`wolfSSL_Debugging_ON()`](group__Debug.md#function-wolfssl_debugging_on) and to turn it off use [`wolfSSL_Debugging_OFF()`](group__Debug.md#function-wolfssl_debugging_off). In a normal build (release mode) these functions will have no effect. In a debug build, define `DEBUG_WOLFSSL` to ensure these functions are turned on.

As of wolfSSL 2.0, logging callback functions may be registered at runtime to provide more flexibility with how logging is done. The logging callback can be registered with the function [`wolfSSL_SetLoggingCb()`](group__Logging.md#function-wolfssl_setloggingcb):

```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```

The log levels can be found in `wolfssl/wolfcrypt/logging.h`, and the implementation is located in `logging.c`.  By default, wolfSSL logs to `stderr` with `fprintf`.

## Error Codes

wolfSSL tries to provide informative error messages in order to help with debugging.

[//]: # (This is a comment. links to group__IO.md and group__Debug.md are causing lines to be truncated so I have removed references to them.)

Each `wolfSSL_read()` and `wolfSSL_write()` call will return the number of bytes written upon success, 0 upon connection closure, and -1 for an error,  just like `read()` and `write()`.  In the event of an error you can use two calls to get more information about the error.

The function `wolfSSL_get_error()` will return the current error code. It takes the current `WOLFSSL` object, and `wolfSSL_read()` or `wolfSSL_write()` result value as arguments and returns the current error code.

```c
int err = wolfSSL_get_error(ssl, result);
```

To get a more human-readable error code description, the `wolfSSL_ERR_error_string()` function can be used.  It takes the return code from `wolfSSL_get_error` and a storage buffer as arguments, and places the corresponding error description into the storage buffer (`errorString` in the example below).

```c
char errorString[80];
wolfSSL_ERR_error_string(err, errorString);
```

If you are using non blocking sockets, you can test for errno EAGAIN/EWOULDBLOCK or more correctly you can test the specific error code for `SSL_ERROR_WANT_READ` or `SSL_ERROR_WANT_WRITE`.

For a list of wolfSSL and wolfCrypt error codes, please see Appendix C (Error Codes).
