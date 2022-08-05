# Engine Control Commands

wolfEngine exposes several engine control commands allowing applications to change the behavior of wolfEngine or adjust internal settings. The following control commands are currently supported:

| Control Command | Description | Value |
| ----------- | --------------- | ----------- |
| enable_debug | Enable wolfEngine debug logging | Numeric: 1 = enable, 0 = disable. See [Chapter 6](chapter06.md) for more details on debug logging. |
| log_level | Set wolfEngine logging level | Numeric: Bitmask of logging levels from wolfEngine_LogType in “include/wolfengine/we_logging.h”. See [Chapter 6](chapter06.md) for more details on debug logging. |
| log_components | Set components to be logged by wolfEngine. | Numeric: Bitmask of components from wolfEngine_LogComponents in “include/wolfengine/we_logging.h. See [Chapter 6](chapter06.md) for more details on debug logging. |
| set_logging_cb | Set wolfEngine logging callback | Function pointer to function used to print log messages. Function must match the wolfEngine_Logging_cb prototype from we_logging.h. See [Chapter 6](chapter06.md) for more details on debug logging. |



Engine control commands can be set using `OpenSSL’s ENGINE_ctrl_cmd()` API. For example, to enable debug logging:

```
int ret = 0;
ret = ENGINE_ctrl_cmd(e, “enable_debug”, 1, NULL, NULL, 0);
if (ret != 1) {
    printf(“Failed to enable debug logging\n”);
}
```

Some control commands can also be set through an OpenSSL config file. More documentation on usage of OpenSSL engine control commands can be found in the OpenSSL man pages:

[https://www.openssl.org/docs/man1.0.2/man3/engine.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)

[https://www.openssl.org/docs/man1.1.1/man3/ENGINE_ctrl_cmd.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)

[https://www.openssl.org/docs/man1.1.1/man3/ENGINE_ctrl_cmd_string.html](https://www.openssl.org/docs/man1.0.2/man3/engine.html)
