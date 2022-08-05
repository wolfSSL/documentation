# Portability

wolfEngine has been designed to leverage the portability of the associated wolfCrypt and OpenSSL libraries.

## Threading

wolfEngine is thread safe and uses mutex locking mechanisms from wolfCrypt (`wc_LockMutex()`, `wc_UnLockMutex()`) where necessary. wolfCrypt has mutex operations abstracted for supported platforms.

## Dynamic Memory Usage

wolfEngine uses OpenSSL’s memory allocation functions to remain consistent with OpenSSL behavior. Allocation functions used internally to wolfEngine include `OPENSSL_malloc()`, `OPENSSL_free()`, `OPENSSL_zalloc()`, and `OPENSSL_realloc()`.

## Logging

wolfEngine logs by default to stderr via `fprintf()`. Applications can override this by registering a custom logging function (see [Chapter 6](chapter06.md)).

Additional macros that may be defined when compiling wolfEngine to adjust logging behavior include:

**WOLFENGINE_USER_LOG** - Macro that defines the nameof function for log output. Users can define this to a custom log function to be used in place of fprintf.

**WOLFENGINE_LOG_PRINTF** - Define that toggles the usageof fprintf (to stderr) to use printf (to stdout) instead. Not applicable if using WOLFENGINE_USER_LOG or custom logging callback.
