# Logging

wolfProvider supports output of log messages for informative and debug purposes. To enable debug logging, wolfProvider must first be compiled with debug support enabled. If using Autoconf, this is done using the `--enable-debug` option to `./configure`:
```
./configure --enable-debug
```

If not using Autoconf/configure, define `WOLFPROV_DEBUG` when compiling the wolfProvider library.

## Controlling Logging Levels

wolfProvider supports the following logging levels. These are defined as preprocessor macros in the `include/wolfprovider/wp_logging.h` header file:

| Log Enum | Description | Log Enum Value |
| -------------- |  --------------- |--------------------- |
| WP_LOG_LEVEL_ERROR | Logs errors | 0x0001 |
| WP_LOG_LEVEL_ENTER | Logs when entering functions | 0x0002 |
| WP_LOG_LEVEL_LEAVE | Logs when leaving functions | 0x0004 |
| WP_LOG_LEVEL_INFO | Logs informative messages | 0x0008 |
| WP_LOG_LEVEL_VERBOSE | Verbose logs, including encrypted/decrypted/digested data | 0x0010 |
| WP_LOG_LEVEL_DEBUG | Logs debug-level detail, including wolfSSL return codes | 0x0020 |
| WP_LOG_LEVEL_TRACE | Logs trace-level ultra-detailed information | 0x0040 |
| WP_LOG_LEVEL_DEFAULT | Default log level | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO |
| WP_LOG_LEVEL_ALL | All log levels are enabled | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_ENTER &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO &#124; WP_LOG_LEVEL_VERBOSE &#124; WP_LOG_LEVEL_DEBUG &#124; WP_LOG_LEVEL_TRACE |


The default wolfProvider logging level (`WP_LOG_LEVEL_DEFAULT`) includes `WP_LOG_LEVEL_ERROR`, `WP_LOG_LEVEL_LEAVE`, and `WP_LOG_LEVEL_INFO`.

The levels and components that can be enabled at runtime are bounded by the compile-time filters `WOLFPROV_LOG_LEVEL_FILTER` and `WOLFPROV_LOG_COMPONENTS_FILTER` (defined in `wp_logging.h`, defaulting to `WP_LOG_LEVEL_DEFAULT` and `WP_LOG_COMP_DEFAULT`). A level or component excluded by these filters at build time cannot be turned on at runtime; to enable, for example, `WP_LOG_LEVEL_DEBUG` or `WP_LOG_LEVEL_VERBOSE`, widen `WOLFPROV_LOG_LEVEL_FILTER` at compile time.

Log levels can be controlled using the `wolfProv_SetLogLevel(int mask)`. For example, to turn on only error and informative logs:
```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

int main(void)
{
    int ret = wolfProv_SetLogLevel(WP_LOG_LEVEL_ERROR | WP_LOG_LEVEL_INFO);
    if (ret != 0) {
        printf("Failed to set logging level\n");
    }
    return 0;
}
```

## Controlling Component Logging

wolfProvider allows logging on a per-component basis. Components are defined as preprocessor macros in `include/wolfprovider/wp_logging.h`:

| Log Component Enum | Description | Component Enum Value |
| ------------------------------ | --------------- | -------------------------------- |
| WP_LOG_COMP_RNG | Random number generation | 0x0001 |
| WP_LOG_COMP_DIGEST | Digests (SHA-1/2/3) | 0x0002 |
| WP_LOG_COMP_MAC | MAC functions (HMAC, CMAC) | 0x0004 |
| WP_LOG_COMP_CIPHER | Ciphers (AES, 3DES) | 0x0008 |
| WP_LOG_COMP_PK | Public Key Algorithms (RSA, ECC) | 0x0010 |
| WP_LOG_COMP_KE | Key Agreement Algorithms (DH, ECDH) | 0x0020 |
| WP_LOG_COMP_KDF | Key Derivation Algorithms | 0x0040 |
| WP_LOG_COMP_PROVIDER | All provider specific logs | 0x0080 |
| WP_LOG_COMP_ALL | Log all components | all components below |
| WP_LOG_COMP_DEFAULT | Default components logged (all) | WP_LOG_COMP_ALL |

Finer-grained per-algorithm components are also available for targeted logging, including `WP_LOG_COMP_RSA`, `WP_LOG_COMP_ECC`, `WP_LOG_COMP_DH`, `WP_LOG_COMP_AES`, `WP_LOG_COMP_SHA`, `WP_LOG_COMP_HMAC`, `WP_LOG_COMP_HKDF`, `WP_LOG_COMP_SSHKDF`, `WP_LOG_COMP_PQC`, and others. See `wp_logging.h` for the full list.

The default wolfProvider logging configuration logs all components (`WP_LOG_COMP_DEFAULT`).

Components logged can be controlled using the `wolfProv_SetLogComponents(int mask)`. For example, to turn on logging only for the Digest and Cipher algorithms:
```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

int main(void)
{
    int ret = wolfProv_SetLogComponents(WP_LOG_COMP_DIGEST | WP_LOG_COMP_CIPHER);
    if (ret != 0) {
        printf("Failed to set log components\n");
    }
    return 0;
}
```
## Setting a Custom Logging Callback

By default wolfProvider outputs debug log messages using **fprintf()** to **stderr**.

Applications that want to have more control over how or where log messages are output can write and register a custom logging callback with wolfProvider. The logging callback should match the prototype of wolfProv_Logging_cb in `include/wolfprovider/wp_logging.h`:
```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (* wolfProv_Logging_cb )(const int logLevel,
const int component,
const char *const logMessage);
```
The callback can then be registered with wolfProvider using the `wolfProv_SetLoggingCb(wolfProv_Logging_cb logf)`. For example:
```
#include <stdio.h>
#include <wolfprovider/wp_logging.h>

void customLogCallback(const int logLevel, const int component,
    const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, "wolfProvider log message: %s\n", logMessage);
}

int main(void)
{
    int ret;

    ret = wolfProv_SetLoggingCb(customLogCallback);
    if (ret != 0) {
        /* failed to set logging callback */
    }

    return 0;
}
```
