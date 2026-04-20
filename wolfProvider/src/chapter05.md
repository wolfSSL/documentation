# Logging

wolfProvider supports output of log messages for informative and debug purposes. To enable debug logging, wolfProvider must first be compiled with debug support enabled. If using Autoconf, this is done using the `--enable-debug` option to `./configure`:
```
./configure --enable-debug
```

If not using Autoconf/configure, define `WOLFPROV_DEBUG` when compiling the wolfProvider library.

## Controlling Logging Levels

wolfProvider supports the following logging levels. These are defined in the “include/wolfprovider/wp_logging.h” header file as part of the wolfProvider_LogType enum:

| Log Enum              | Description | Log Enum Value | 
| --------------        | --------------- |--------------------- |
| WP_LOG_LEVEL_ERROR    | Logs errors | 0x0001 |
| WP_LOG_LEVEL_ENTER    | Logs when entering functions | 0x0002 |
| WP_LOG_LEVEL_LEAVE    | Logs when leaving functions | 0x0004 |
| WP_LOG_LEVEL_INFO     | Logs informative messages | 0x0008 |
| WP_LOG_LEVEL_VERBOSE  | Verbose logs, including encrypted/decrypted/digested data | 0x0010 |
| WP_LOG_LEVEL_DEFAULT  | Default log level, all except verbose level | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_ENTER &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO |
WP_LOG_LEVEL_ALL | All log levels are enabled | WP_LOG_LEVEL_ERROR &#124; WP_LOG_LEVEL_ENTER &#124; WP_LOG_LEVEL_LEAVE &#124; WP_LOG_LEVEL_INFO &#124; WP_LOG_LEVEL_VERBOSE |


The default wolfProvider logging level includes `WP_LOG_LEVEL_ERROR`, `WP_LOG_LEVEL_ENTER`, `WP_LOG_LEVEL_LEAVE`, and `WP_LOG_LEVEL_INFO`. This includes all log levels except verbose logs (`WP_LOG_LEVEL_VERBOSE`).

Log levels can be controlled using the `wolfProv_SetLogLevel(int mask)`. For example, to turn on only error and informative logs:
```
#include <wolfprovider/wp_logging.h>

ret = wolfProv_SetLogLevel(WP_LOG_LEVEL_ERROR | WP_LOG_LEVEL_INFO);
if (ret != 0) {
    printf(“Failed to set logging level\n”);
}
```

## Controlling Component Logging at build time

wolfProvider allows logging on a per-component basis. The full list of components is defined in the wolfProvider_LogComponents enum in `include/wolfprovider/wp_logging.h`:

| Log Component Enum | Description | Component Enum Value |
| ------------------------------ | --------------- | -------------------------------- |
| WP_LOG_COMP_RNG | Random number generation | 0x0001 |
| WP_LOG_COMP_DIGEST | Digests (SHA-1/2/3) | 0x0002 |
| WP_LOG_COMP_MAC | MAC functions (HMAC, CMAC) | 0x0004 |
| WP_LOG_COMP_CIPHER | Ciphers (AES, 3DES) | 0x0008 |
| WP_LOG_COMP_PK | Public Key Algorithms (RSA, ECC) | 0x0010 |
| WP_LOG_COMP_KE | Key Agreement Algorithms (DH, ECDH) | 0x0020 |
| WP_LOG_COMP_KDF | Password Based Key Derivation Algorithms | 0x0040 |
| WP_LOG_COMP_PROVIDER | All provider specific logs | 0x0080 |
| WP_LOG_COMP_COMP_ALL | Log all components | WP_LOG_COMP_RNG &#124; WP_LOG_COMP_DIGEST &#124; WP_LOG_COMP_MAC &#124; WP_LOG_COMP_CIPHER &#124; WP_LOG_COMP_PK &#124; WP_LOG_COMP_KE &#124; WP_LOG_COMP_KDF &#124; WP_LOG_COMP_PROVIDER |
| WP_LOG_COMP_DEFAULT | Default components logged (all). | WP_LOG_COMP_ALL |


The default wolfProvider logging configuration logs all components (`WP_LOG_COMP_DEFAULT`).

Components logged can be controlled using the `wolfProv_SetLogComponents(int mask)`. For example, to turn on logging only for the Digest and Cipher algorithms:
```
#include <wolfprovider/wp_logging.h>

ret = wolfProv_SetLogComponents(WP_LOG_COMP_DIGEST | WP_LOG_COMP_CIPHER);
if (ret != 0) {
    printf(“Failed to set log components\n”);
}
```

## Controlling Component Logging at run time
wolfProvider allows runtime adjustments to the log settings through environment variables. `WOLFPROV_LOG_LEVEL` controls the log level, while `WOLFPROV_LOG_COMPONENTS` controls which components are logged. These values are expected to be strings in the format below.

*Note that the environment variables can only control levels and components which have been enabled at build time.* 

```
# Enable info logs only from the ED25519 block.
export WOLFPROV_LOG_LEVEL='WP_LOG_LEVEL_INFO' 
export WOLFPROV_LOG_COMPONENTS='WP_LOG_COMP_ED25519'
```

```
# Enable error and info logs only from the rsa and provider blocks.
export WOLFPROV_LOG_LEVEL='(WP_LOG_LEVEL_ERROR | WP_LOG_LEVEL_INFO)'
export WOLFPROV_LOG_COMPONENTS='(WP_LOG_LEVEL_RSA | WP_LOG_LEVEL_PROVIDER)'
```

```
# Disable all wolfProvider logs
export WOLFPROV_LOG_LEVEL=
export WOLFPROV_LOG_COMPONENTS=
```

*Note that this functionality only applies to logs from wolfProvider, not logs from the wolfSSL library.*

## Setting a Custom Logging Callback

By default wolfProvider outputs debug log messages using **fprintf()** to **stderr**.

Applications that want to have more control over how or where log messages are output can write and register a custom logging callback with wolfProvider. The logging callback should match the prototype of wolfProvider_Logging_cb in `include/wolfprovider/wp_logging.h`:
```
/**
* wolfProvider logging callback.
* logLevel - [IN] - Log level of message
* component - [IN] - Component that log message is coming from
* logMessage - [IN] - Log message
*/
typedef void (* wolfProvider_Logging_cb )(const int logLevel,
const int component,
const char *const logMessage);
```
The callback can then be registered with wolfProvider using the `wolfProv_SetLoggingCb(wolfProv_Logging_cb logf)`. For example:
```
void customLogCallback (const int logLevel, const int component,
const char* const logMessage)
{
    (void)logLevel;
    (void)component;
    fprintf(stderr, “wolfProvider log message: %d\n”, logMessage);
}

int main (void)
{
    int ret;
...
    ret = wolfProv_SetLoggingCb((void(*)(void))my_Logging_cb);
    if (ret != 0) {
        /* failed to set logging callback */
    }
...
}
```
