# Loading wolfProvider

## Configuring OpenSSL to Enable Provider Usage

For documentation on how applications use and consume OpenSSL providers, refer to the OpenSSL documentation:

[OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/provider.html)
[OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/PROVIDER_add.html)

There are several ways an application can choose to consume, register, and configure provider usage. In the simplest usage, to load and register all PROVIDER implementations bundled with OpenSSL an application would need to call the following (taken from the above OpenSSL documentation):
```
/* For OpenSSL 1.0.2, need to make the “dynamic” PROVIDER available */
PROVIDER_load_dynamic();

/* Load all bundled PROVIDERs into memory and make them visible */
PROVIDER_load_builtin_providers();
/* Register all of them for every algorithm they collectively implement */
PROVIDER_register_all_complete();
```
At this point, if the application is configured to read/use an OpenSSL config file, additional provider setup steps can be done there. For OpenSSL config documentation, reference the OpenSSL documentation:

[OpenSSL 1.0.2](https://www.openssl.org/docs/man1.0.2/man3/OPENSSL_config.html)
[OpenSSL 1.1.1](https://www.openssl.org/docs/man1.1.1/man3/OPENSSL_config.html)

For example, an application can read and consume the default OpenSSL config file (openssl.cnf) or config as set by OPENSSL_CONF environment variable, and default [openssl_conf] section by calling:
```
OPENSSL_config(NULL);
```

Alternatively to using an OpenSSL config file, applications can explicitly initialize and register wolfProvider using the desired PROVIDER_* APIs. As one example, initializing wolfProvider and registering for all algorithms could be done using:
```
PROVIDER* e = NULL;

e = PROVIDER_by_id(“wolfprovider”);
if (e == NULL) {
printf(“Failed to find wolfProvider\n”);
/* error */
}
PROVIDER_set_default(e, PROVIDER_METHOD_ALL);

/* normal application execution / behavior */

PROVIDER_finish(e);
PROVIDER_cleanup();
```

## Loading wolfProvider from an OpenSSL Configuration File

wolfProvider can be loaded from an OpenSSL config file if an application using OpenSSL is set up to process a config file. An example of how the wolfProvider library may be added to a config file is below. The [wolfssl_section] could be modified to set provider control commands (enable_debug) if needed.

```
openssl_conf = openssl_init

[openssl_init]
providers = provider_section

[provider_section]
wolfSSL = wolfssl_section

[wolfssl_section]
# If using OpenSSL <= 1.0.2, change provider_id to wolfprovider
(drop the "lib").
provider_id = libwolfprovider
# dynamic_path = .libs/libwolfprovider.so
init = 1
# Use wolfProvider as the default for all algorithms it provides.
default_algorithms = ALL
# Only enable when debugging application - produces large
amounts of output.
# enable_debug = 1
```

## wolfProvider Static Entrypoint

When wolfProvider is used as a static library, applications can call the following entry point to load wolfProvider:
```
#include <wolfprovider/we_wolfprovider.h>
PROVIDER_load_wolfprovider();
```
