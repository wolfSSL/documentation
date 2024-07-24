# Loading wolfProvider

## Configuring OpenSSL to Enable Provider Usage

For documentation on how applications use and consume OpenSSL providers, refer to the OpenSSL documentation:

[OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man7/provider.html)

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

[OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man5/config.html)

An application can read and consume the default OpenSSL config file (openssl.cnf) or config as set by OPENSSL_CONF environment variable, and default [openssl_conf] section.

Alternatively to using an OpenSSL config file, applications can explicitly initialize and register wolfProvider using the desired PROVIDER_\* APIs. As one example, initializing wolfProvider and registering for all algorithms could be done using:
```
    OSSL_PROVIDER *prov = NULL;
    const char *build = NULL;
    OSSL_PARAM request[] = {
        { "buildinfo", OSSL_PARAM_UTF8_PTR, &build, 0, 0 },
        { NULL, 0, NULL, 0, 0 }
    };

    if ((prov = OSSL_PROVIDER_load(NULL, "libwolfprov")) != NULL
        && OSSL_PROVIDER_get_params(prov, request))
        printf("Provider 'libwolfprov' buildinfo: %s\n", build);
    else
        ERR_print_errors_fp(stderr);

    if (OSSL_PROVIDER_self_test(prov) == 0)
        printf("Provider selftest failed\n");
    else
        printf("Provider selftest passed\n");

    OSSL_PROVIDER_unload(prov);
```

## Loading wolfProvider from an OpenSSL Configuration File

wolfProvider can be loaded from an OpenSSL config file if an application using OpenSSL is set up to process a config file. An example of how the wolfProvider library may be added to a config file is below.

```
openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
libwolfprov = libwolfprov_sect

[libwolfprov_sect]
activate = 1
```

## wolfProvider Static Entrypoint

When wolfProvider is used as a static library, applications can call the following entry point to load wolfProvider:
```
#include <wolfprovider/we_wolfprovider.h>
wolfssl_provider_init(const OSSL_CORE_HANDLE* handle, const OSSL_DISPATCH* in, const OSSL_DISPATCH** out, void** provCtx);
```
