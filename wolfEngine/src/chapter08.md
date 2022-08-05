# Loading wolfEngine

## Configuring OpenSSL to Enable Engine Usage

For documentation on how applications use and consume OpenSSL engines, refer to the OpenSSL documentation:

[OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/engine.html)
[OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/ENGINE_add.html)

There are several ways an application can choose to consume, register, and configure engine usage. In the simplest usage, to load and register all ENGINE implementations bundled with OpenSSL an application would need to call the following (taken from the above OpenSSL documentation):
```
/* For OpenSSL 1.0.2, need to make the “dynamic” ENGINE available */
ENGINE_load_dynamic();

/* Load all bundled ENGINEs into memory and make them visible */
ENGINE_load_builtin_engines();
/* Register all of them for every algorithm they collectively implement */
ENGINE_register_all_complete();
```
At this point, if the application is configured to read/use an OpenSSL config file, additional engine setup steps can be done there. For OpenSSL config documentation, reference the OpenSSL documentation:

[OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/OPENSSL_config.html)
[OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/OPENSSL_config.html)

For example, an application can read and consume the default OpenSSL config file (openssl.cnf) or config as set by OPENSSL_CONF environment variable, and default [openssl_conf] section by calling:
```
OPENSSL_config(NULL);
```

Alternatively to using an OpenSSL config file, applications can explicitly initialize and register wolfEngine using the desired ENGINE_* APIs. As one example, initializing wolfEngine and registering for all algorithms could be done using:
```
ENGINE* e = NULL;

e = ENGINE_by_id(“wolfengine”);
if (e == NULL) {
printf(“Failed to find wolfEngine\n”);
/* error */
}
ENGINE_set_default(e, ENGINE_METHOD_ALL);

/* normal application execution / behavior */

ENGINE_finish(e);
ENGINE_cleanup();
```

## Loading wolfEngine from an OpenSSL Configuration File

wolfEngine can be loaded from an OpenSSL config file if an application using OpenSSL is set up to process a config file. An example of how the wolfEngine library may be added to a config file is below. The [wolfssl_section] could be modified to set engine control commands (enable_debug) if needed.

```
openssl_conf = openssl_init

[openssl_init]
engines = engine_section

[engine_section]
wolfSSL = wolfssl_section

[wolfssl_section]
# If using OpenSSL <= 1.0.2, change engine_id to wolfengine
(drop the "lib").
engine_id = libwolfengine
# dynamic_path = .libs/libwolfengine.so
init = 1
# Use wolfEngine as the default for all algorithms it provides.
default_algorithms = ALL
# Only enable when debugging application - produces large
amounts of output.
# enable_debug = 1
```

## wolfEngine Static Entrypoint

When wolfEngine is used as a static library, applications can call the following entry point to load wolfEngine:
```
#include <wolfengine/we_wolfengine.h>
ENGINE_load_wolfengine();
```
