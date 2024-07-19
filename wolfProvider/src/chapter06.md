# Logging

wolfProvider supports output of log messages for informative and debug purposes. To enable debug logging, wolfProvider must first be compiled with debug support enabled. If using Autoconf, this is done using the `--enable-debug` option to `./configure`:
```
./configure --enable-debug
```

If not using Autoconf/configure, define `WOLFPROVIDER_DEBUG` when compiling the wolfProvider library.

## Enable / Disable Debug Logging

Once debug support has been compiled into the library, debugging must be enabled at runtime using the wolfProvider control commands specified in Section 5. To enable debug logging, use the `enable_debug` control command with the value of "1" to enable logging or "0" to disable logging. To enable logging using the `PROVIDER_ctrl_cmd()` API:
```
int ret = 0;
ret = PROVIDER_ctrl_cmd(e, “enable_debug”, 1, NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to enable debug logging\n”);
}
```

If wolfProvider has not been compiled with debug support enabled, an attempt to set `enable_debug` with `PROVIDER_ctrl_cmd()` will return failure (0).

## Controlling Logging Levels

wolfProvider supports the following logging levels. These are defined in the “include/wolfprovider/we_logging.h” header file as part of the wolfProvider_LogType enum:

| Log Enum | Description | Log Enum Value | 
| -------------- |  --------------- |--------------------- |
| WE_LOG_ERROR | Logs errors | 0x0001 |
| WE_LOG_ENTER | Logs when entering functions | 0x0002 |
| WE_LOG_LEAVE | Logs when leaving functions | 0x0004 |
| WE_LOG_INFO | Logs informative messages | 0x0008 |
| WE_LOG_VERBOSE | Verbose logs, including encrypted/decrypted/digested data | 0x0010 |
| WE_LOG_LEVEL_DEFAULT | Default log level, all except verbose level | WE_LOG_ERROR &#124; WE_LOG_ENTER &#124; WE_LOG_LEAVE &#124; WE_LOG_INFO |
WE_LOG_LEVEL_ALL WE_LOG_ERROR | All log levels are enabled | WE_LOG_ENTER &#124; WE_LOG_LEAVE &#124; WE_LOG_INFO &#124; WE_LOG_VERBOSE |


The default wolfProvider logging level includes `WE_LOG_ERROR`, `WE_LOG_ENTER`, `WE_LOG_LEAVE`, and `WE_LOG_INFO`. This includes all log levels except verbose logs (`WE_LOG_VERBOSE`).

Log levels can be controlled using the "**log_level**" provider control command at runtime, either through the `PROVIDER_ctrl_cmd()` API or OpenSSL configuration file settings. For example, to turn on only error and informative logs using the “log_level” control command, an application would call:
```
#include <wolfprovider/we_logging.h>

ret = PROVIDER_ctrl_cmd(e, “log_level”, WP_LOG_ERROR | WP_LOG_INFO,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set logging level\n”);
}
```

## Controlling Component Logging

wolfProvider allows logging on a per-component basis. Components are defined in the wolfProvider_LogComponents enum in `include/wolfprovider/we_logging.h`:

| Log Component Enum | Description | Component Enum Value |
| ------------------------------ | --------------- | -------------------------------- |
| WP_LOG_RNG | Random number generation | 0x0001 |
| WP_LOG_DIGEST | Digests (SHA-1/2/3) | 0x0002 |
| WP_LOG_MAC | MAC functions (HMAC, CMAC) | 0x0004 |
| WP_LOG_CIPHER | Ciphers (AES, 3DES) | 0x0008 |
| WP_LOG_PK | Public Key Algorithms (RSA, ECC) | 0x0010 |
| WP_LOG_KE | Key Agreement Algorithms (DH, ECDH) | 0x0020 |
| WP_LOG_PROVIDER | All provider specific logs | 0x0040 |
| WP_LOG_COMPONENTS_ALL | Log all components | WP_LOG_RNG &#124; WP_LOG_DIGEST &#124; WP_LOG_MAC &#124; WP_LOG_CIPHER &#124; WP_LOG_PK &#124; WP_LOG_KE &#124; WP_LOG_PROVIDER |
| WP_LOG_COMPONENTS_DEFAULT | Default components logged (all). | WP_LOG_COMPONENTS_ALL |


The default wolfProvider logging configuration logs all components (`WP_LOG_COMPONENTS_DEFAULT`).

Components logged can be controlled using the “ **log_components** ” provider control command at runtime, either through the `PROVIDER_ctrl_cmd()` API or OpenSSL configuration file settings. For example, to turn on only logging only for the Digest and Cipher algorithms:
```
#include <wolfprovider/we_logging.h>

ret = PROVIDER_ctrl_cmd(e, “ **log_components** ”, WP_LOG_DIGEST | WP_LOG_CIPHER,
NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to set log components\n”);
}
```
## Setting a Custom Logging Callback

By default wolfProvider outputs debug log messages using **fprintf()** to **stderr**.

Applications that want to have more control over how or where log messages are output can write and register a custom logging callback with wolfProvider. The logging callback should match the prototype of wolfProvider_Logging_cb in `include/wolfprovider/we_logging.h`:
```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (* **wolfProvider_Logging_cb** )(const int logLevel,
const int component,
const char *const logMessage);
```
The callback can then be registered with wolfProvider using the “ **set_logging_cb** ” provider control command. For example, to use the `PROVIDER_ctrl_cmd()` API to set a custom logging callback:
```
void **customLogCallback** (const int logLevel, const int component,
const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, “wolfProvider log message: %d\n”, logMessage);
}

int **main** (void)
{
    int ret;
    PROVIDER* e;
...
    ret = PROVIDER_ctrl_cmd(e, “ **set_logging_cb** ”, 0, NULL,
    (void(*)(void))my_Logging_cb, 0);
    if (ret != 1) {
        /* failed to set logging callback */
    }
...
}
```
