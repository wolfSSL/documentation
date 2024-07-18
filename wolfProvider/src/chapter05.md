# Provider Control Commands

wolfProvider exposes several provider control commands allowing applications to change the behavior of wolfProvider or adjust internal settings. The following control commands are currently supported:

| Control Command | Description | Value |
| ----------- | --------------- | ----------- |
| enable_debug | Enable wolfProvider debug logging | Numeric: 1 = enable, 0 = disable. See [Chapter 6](chapter06.md) for more details on debug logging. |
| log_level | Set wolfProvider logging level | Numeric: Bitmask of logging levels from wolfProvider_LogType in “include/wolfprovider/we_logging.h”. See [Chapter 6](chapter06.md) for more details on debug logging. |
| log_components | Set components to be logged by wolfProvider. | Numeric: Bitmask of components from wolfProvider_LogComponents in “include/wolfprovider/we_logging.h. See [Chapter 6](chapter06.md) for more details on debug logging. |
| set_logging_cb | Set wolfProvider logging callback | Function pointer to function used to print log messages. Function must match the wolfProvider_Logging_cb prototype from we_logging.h. See [Chapter 6](chapter06.md) for more details on debug logging. |



Provider control commands can be set using `OpenSSL’s PROVIDER_ctrl_cmd()` API. For example, to enable debug logging:

```
int ret = 0;
ret = PROVIDER_ctrl_cmd(e, “enable_debug”, 1, NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to enable debug logging\n”);
}
```

Some control commands can also be set through an OpenSSL config file. More documentation on usage of OpenSSL provider control commands can be found in the OpenSSL man pages:

[https://www.openssl.org/docs/man1.0.2/man3/provider.html](https://www.openssl.org/docs/man1.0.2/man3/provider.html)

[https://www.openssl.org/docs/man1.1.1/man3/PROVIDER_ctrl_cmd.html](https://www.openssl.org/docs/man1.0.2/man3/provider.html)

[https://www.openssl.org/docs/man1.1.1/man3/PROVIDER_ctrl_cmd_string.html](https://www.openssl.org/docs/man1.0.2/man3/provider.html)
