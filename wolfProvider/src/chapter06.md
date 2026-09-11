# Portability

wolfProvider has been designed to leverage the portability of the associated wolfCrypt and OpenSSL libraries.

## Supported Platforms

wolfProvider is cross-platform and builds on the major platforms supported by wolfSSL and OpenSSL, including:

* Linux and other *nix-like systems, built with the autoconf system (see [Building wolfProvider](chapter03.md))
* macOS
* Windows, using the Visual Studio 2022 solution that builds `libwolfprov.dll` (see [Building wolfProvider](chapter03.md))
* Android, using the build scripts under `IDE/Android`
* Apple platforms, using the framework build scripts under `IDE/XCODE`

Both FIPS and non-FIPS builds are supported on Linux, macOS, Windows, and Android (the Android build supports FIPS Ready via its `USE_FIPS` option).

## Threading

wolfProvider's cryptographic operations are thread safe and use mutex locking mechanisms from wolfCrypt (`wc_LockMutex()`, `wc_UnLockMutex()`) where necessary. wolfCrypt has mutex operations abstracted for supported platforms.

The global configuration setters are an exception: the logging setters (`wolfProv_SetLogLevel()`, `wolfProv_SetLogComponents()`, `wolfProv_SetLoggingCb()`) and the FIPS-check state update process-global state without internal synchronization. Configure these once during initialization, before other threads use the provider.

## Dynamic Memory Usage

wolfProvider uses OpenSSL’s memory allocation functions to remain consistent with OpenSSL behavior. Allocation functions used internally to wolfProvider include `OPENSSL_malloc()`, `OPENSSL_free()`, `OPENSSL_zalloc()`, and `OPENSSL_realloc()`.

## Logging

wolfProvider logs by default to stderr via `fprintf()`. Applications can override this by registering a custom logging function (see [Chapter 5](chapter05.md)).

Additional macros that may be defined when compiling wolfProvider to adjust logging behavior include:

**WOLFPROV_USER_LOG** - Macro that defines the nameof function for log output. Users can define this to a custom log function to be used in place of fprintf.

**WOLFPROV_LOG_PRINTF** - Define that toggles the usageof fprintf (to stderr) to use printf (to stdout) instead. Not applicable if using WOLFPROV_USER_LOG or custom logging callback.
