# Portability

wolfProvider has been designed to leverage the portability of the associated wolfCrypt and OpenSSL libraries.

## Threading

wolfProvider is thread safe and uses mutex locking mechanisms from wolfCrypt (`wc_LockMutex()`, `wc_UnLockMutex()`) where necessary. wolfCrypt has mutex operations abstracted for supported platforms.

## Dynamic Memory Usage

wolfProvider uses OpenSSL’s memory allocation functions to remain consistent with OpenSSL behavior. Allocation functions used internally to wolfProvider include `OPENSSL_malloc()`, `OPENSSL_free()`, `OPENSSL_zalloc()`, and `OPENSSL_realloc()`.

## Logging

wolfProvider logs by default to stderr via `fprintf()`. Applications can override this by registering a custom logging function (see [Chapter 5](chapter05.md)).

Additional macros that may be defined when compiling wolfProvider to adjust logging behavior include:

**WOLFPROV_USER_LOG** - Macro that defines the nameof function for log output. Users can define this to a custom log function to be used in place of fprintf.

**WOLFPROV_LOG_PRINTF** - Define that toggles the usageof fprintf (to stderr) to use printf (to stdout) instead. Not applicable if using WOLFPROV_USER_LOG or custom logging callback.
