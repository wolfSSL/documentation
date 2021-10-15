# Debugging

## Debugging and Logging

wolfSSL (formerly CyaSSL) has support for debugging through log messages in environments where debugging is limited. To turn logging on use the function [`wolfSSL_Debugging_ON()`](https://www.wolfssl.com/doxygen/group__Debug.html#ga9a46a862ed6a487c5a838b1ae9f73809) and to turn it off use [`wolfSSL_Debugging_OFF()`](https://www.wolfssl.com/doxygen/group__Debug.html#ga25f58f99133b5e7961bfc0d6de089036). In a normal build (release mode) these functions will have no effect. In a debug build, define `DEBUG_WOLFSSL` to ensure these functions are turned on.

As of wolfSSL 2.0, logging callback functions may be registered at runtime to provide more flexibility with how logging is done. The logging callback can be registered with the function [`wolfSSL_SetLoggingCb()`](https://www.wolfssl.com/doxygen/group__Logging.html#gac898aab95627a55ec315536c57f75c29):

```c
int wolfSSL_SetLoggingCb(wolfSSL_Logging_cb log_function);

typedef void (*wolfSSL_Logging_cb)(const int logLevel,
                  const char *const logMessage);
```

The log levels can be found in `wolfssl/wolfcrypt/logging.h`, and the implementation is located in `logging.c`.  By default, wolfSSL logs to `stderr` with `fprintf`.

## Error Codes

wolfSSL tries to provide informative error messages in order to help with debugging.

Each [`wolfSSL_read()`](https://www.wolfssl.com/doxygen/group__IO.html#ga33732bde756a527d61a32212b4b9a017) and [`wolfSSL_write()`](https://www.wolfssl.com/doxygen/group__IO.html#ga74b924a81e9efdf66d074690e5f53ef1) call will return the number of bytes written upon success, 0 upon connection closure, and -1 for an error,  just like `read()` and `write()`.  In the event of an error you can use two calls to get more information about the error.

The function [`wolfSSL_get_error()`](https://www.wolfssl.com/doxygen/group__Debug.html#gae30b3ae133f07c6b9d2b567367489b02) will return the current error code. It takes the current `WOLFSSL` object, and [`wolfSSL_read()`](https://www.wolfssl.com/doxygen/group__IO.html#ga33732bde756a527d61a32212b4b9a017) or [`wolfSSL_write()`](https://www.wolfssl.com/doxygen/group__IO.html#ga74b924a81e9efdf66d074690e5f53ef1) result value as an arguments and returns the corresponding error code.

```c
int err = wolfSSL_get_error(ssl, result);
```

To get a more human-readable error code description, the [`wolfSSL_ERR_error_string()`](https://www.wolfssl.com/doxygen/group__Debug.html#ga3855cc561a97e6f1b7b6c92171d8078a) function can be used.  It takes the return code from [`wolfSSL_get_error`](https://www.wolfssl.com/doxygen/group__Debug.html#gae30b3ae133f07c6b9d2b567367489b02) and a storage buffer as arguments, and places the corresponding error description into the storage buffer (`errorString` in the example below).

```c
char errorString[80];
wolfSSL_ERR_error_string(err, errorString);
```

If you are using non blocking sockets, you can test for errno EAGAIN/EWOULDBLOCK or more correctly you can test the specific error code for `SSL_ERROR_WANT_READ` or `SSL_ERROR_WANT_WRITE`.

For a list of wolfSSL and wolfCrypt error codes, please see Appendix C (Error Codes).
