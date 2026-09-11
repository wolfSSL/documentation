# Loading wolfProvider

## Configuring OpenSSL to Enable Provider Usage

For documentation on how applications use and consume OpenSSL providers, refer to the OpenSSL documentation:

[OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man7/provider.html)

If the application is configured to read/use an OpenSSL config file, additional provider setup steps can be done there. For OpenSSL config documentation, reference the OpenSSL documentation:

[OpenSSL 3.0](https://www.openssl.org/docs/man3.0/man5/config.html)

An application can read and consume the default OpenSSL config file (openssl.cnf) or config as set by OPENSSL\_CONF environment variable and default [openssl\_conf] section.

Alternatively to using an OpenSSL config file, applications can explicitly initialize and register wolfProvider using the desired OSSL\_PROVIDER_\* APIs. As one example, initializing wolfProvider and registering for all algorithms could be done using:
```
    OSSL_PROVIDER *prov = NULL;
    const char *build = NULL;
    OSSL_PARAM request[] = {
        { "buildinfo", OSSL_PARAM_UTF8_PTR, &build, 0, 0 },
        { NULL, 0, NULL, 0, 0 }
    };

    prov = OSSL_PROVIDER_load(NULL, "libwolfprov");
    if (prov != NULL) {
        if (OSSL_PROVIDER_get_params(prov, request))
            printf("Provider 'libwolfprov' buildinfo: %s\n", build);
        else
            ERR_print_errors_fp(stderr);
        OSSL_PROVIDER_unload(prov);
    }
    else {
        ERR_print_errors_fp(stderr);
    }
```

Loading a provider makes it available; it does not by itself force every operation to use it. To require wolfProvider for a given operation, fetch algorithms with a property query using wolfProvider's registered property `"provider=wolfprov"` (for a FIPS build, `"provider=wolfprov,fips=yes"`) via the `EVP_*_fetch()` APIs. Note that `libwolfprov` is the module name used to *load* the provider, while `provider=wolfprov` is the property used to *select* its algorithms.

wolfProvider does not currently implement a provider self-test dispatch (`OSSL_FUNC_PROVIDER_SELF_TEST`). `OSSL_PROVIDER_self_test()` on the loaded provider therefore does not run a wolfProvider self-test and should not be relied on as one.

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

When wolfProvider is built as a static library, it is loaded as an OpenSSL built-in provider rather than as a dynamically loaded module. The application links against static wolfProvider (and its wolfSSL and OpenSSL dependencies), registers wolfProvider's entry point with `OSSL_PROVIDER_add_builtin()`, and then loads it by name:
```
#include <openssl/provider.h>
#include <wolfprovider/wp_wolfprov.h>

int load_wolfprovider(void)
{
    OSSL_PROVIDER *prov;

    if (OSSL_PROVIDER_add_builtin(NULL, "libwolfprov",
            wolfssl_provider_init) != 1) {
        return -1;
    }
    prov = OSSL_PROVIDER_load(NULL, "libwolfprov");
    if (prov == NULL) {
        return -1;
    }
    /* use prov, then call OSSL_PROVIDER_unload(prov) when finished */
    return 0;
}
```
The entry point `wolfssl_provider_init()` is declared in `wolfprovider/wp_wolfprov.h`; it is passed to `OSSL_PROVIDER_add_builtin()` and is not called directly by the application.

## Replace-Default Mode

In the standard loading models described above, wolfProvider is loaded *alongside*
OpenSSL's own providers: the application activates `libwolfprov` through a config
file, an `OSSL_PROVIDER_load()`/`OSSL_PROVIDER_add_builtin()` call, or a property
query. OpenSSL's native `default` (and, for a FIPS build, `fips`) provider remains
present, and any operation that wolfProvider does not service can still be answered
by OpenSSL's own crypto.

Replace-default mode changes that relationship. Instead of loading beside OpenSSL's
default provider, wolfProvider *becomes* it. In replace-default mode, an OpenSSL
request for the built-in `default` or `fips` provider resolves to wolfProvider (the
`libwolfprov` module), so an unmodified application uses wolfSSL cryptography with
**no code, no `openssl.cnf`, and no environment configuration** — and with no path
back to OpenSSL's native implementations for the redirected providers.

### How It Works

Replace-default mode works by replacing one OpenSSL source file,
`crypto/provider_predefined.c`, before OpenSSL is built. That file defines
`ossl_predefined_providers[]`, the table OpenSSL consults to map a built-in provider
*name* to the initialization function used when that provider is loaded. In stock
OpenSSL the `default` name maps to `ossl_default_provider_init` (OpenSSL's own
crypto). wolfProvider ships a drop-in replacement,
`patches/provider_predefined.c.replace-default`, that rewrites the table so the
`default` and `fips` names (and `legacy`, in static-legacy builds) instead map to a
small loader function:

```c
const OSSL_PROVIDER_INFO ossl_predefined_providers[] = {
    { "fips",    NULL, load_wolfprov_and_init, NULL, 0 },
    { "default", NULL, load_wolfprov_and_init, NULL, 1 },
# ifdef STATIC_LEGACY
    { "legacy",  NULL, load_wolfprov_and_init, NULL, 0 },
# endif
    { "base",    NULL, ossl_base_provider_init, NULL, 0 },
    { "null",    NULL, ossl_null_provider_init, NULL, 0 },
    { NULL, NULL, NULL, NULL, 0 }
};
```

`load_wolfprov_and_init()` uses OpenSSL's DSO layer to `dlopen` `libwolfprov`, bind
its `wolfssl_provider_init` entry point, and call it as the provider's init
function. From that point on, whenever OpenSSL lazily loads its default provider —
which it does automatically the first time an application performs any crypto
without having explicitly selected a provider — it loads wolfProvider instead.

Two entries are deliberately left untouched. OpenSSL's `base` provider (encoders,
decoders, `PEM`/`DER` serialization, and other non-cryptographic services) and its
`null` provider keep their original OpenSSL initialization functions, because
wolfProvider does not replace those non-crypto services.

The replacement also refuses to compile if OpenSSL itself is being built as a FIPS
module:

```c
#ifdef FIPS_MODULE
#error "For wolfProvider replace default mode, do not build OpenSSL with FIPS"
#endif
```

This is intentional: in replace-default mode, FIPS behavior is expected to come from
wolfCrypt underneath wolfProvider, not from OpenSSL's separate FIPS module. For this
reason `--replace-default` is mutually exclusive with the OpenSSL-side
`--enable-fips-baseline` patch, and `scripts/build-wolfprovider.sh` rejects the
combination.

Because the redirect lives entirely in the OpenSSL build, wolfProvider still needs
to be present at runtime: `load_wolfprov_and_init()` loads `libwolfprov` by name, so
the wolfProvider shared library must be installed where the dynamic loader can find
it. If it is missing, the patched OpenSSL reports
`Could not load libwolfprov.so. Is the libwolfprov package installed?` and provider
initialization fails. "No configuration" does not mean "no dependency."

### Enabling Replace-Default Mode

Enabling replace-default has two parts, and both must be present:

1. **Build wolfProvider for replace-default.** Pass `--enable-replace-default` to
   `./configure`, or define `-DWOLFPROV_REPLACE_DEFAULT` in `CFLAGS` (convenient for
   Yocto-style/system-package builds that drive the build through flags).
2. **Build OpenSSL with the `provider_predefined.c` replacement**, so that OpenSSL's
   built-in `default`/`fips` names load wolfProvider.

The build script does both in one step:

```sh
./scripts/build-wolfprovider.sh --replace-default
```

Doing only step 1 builds a replace-default-capable wolfProvider but leaves a stock
OpenSSL that still uses its own default provider; doing only step 2 patches an
OpenSSL that has no wolfProvider to load. Use the build script (or follow the
Integration Guide) so the two stay in sync. See the wolfProvider Integration Guide
(`docs/INTEGRATION_GUIDE.md`) for the authoritative, step-by-step procedure,
including packaging and whole-system deployment.

In replace-default mode, no `OPENSSL_CONF` or `OPENSSL_MODULES` configuration is
required, because wolfProvider is already the default provider. The
`scripts/env-setup` helper detects this mode and skips setting those variables (in
standard mode it points `OPENSSL_CONF` at `provider.conf` to activate `libwolfprov`).

### Why Use Replace-Default Mode

There are two primary reasons to build in replace-default mode.

**1. To prove that wolfProvider is actually the one doing the crypto.** In the
standard loading model, OpenSSL can still satisfy a request from its own default
provider in several situations — an application (or a dependency) that explicitly
asks for the `default` provider, an algorithm wolfProvider does not implement, or a
configuration file that is simply not picked up. In those cases OpenSSL silently
falls back to its native implementation, and nothing in the application's behavior
makes that visible. Replace-default mode removes the fallback path entirely: since
the `default`/`fips` names *are* wolfProvider, there is no OpenSSL-native provider
left to fall back to. This makes it the definitive way to verify that an
application, a library, or a whole system genuinely routes its cryptography through
wolfCrypt rather than only appearing to. wolfProvider's CI uses it together with
force-failure testing (`WOLFPROV_FORCE_FAIL=1`) for exactly this purpose.

**2. Whole-system replacement.** Replace-default mode makes wolfCrypt the crypto
backend for *every* OpenSSL consumer linked against the patched libcrypto, with no
per-application configuration and no source changes to any of them. This is the
model used when the goal is to substitute wolfCrypt underneath an entire
distribution or image — for example a Yocto image, or a Debian package build where
`scripts/build-wolfprovider.sh --replace-default` forwards the replacement into the
system OpenSSL package. Every application on the resulting system uses wolfSSL
cryptography without being individually rebuilt or reconfigured.

Replace-default mode is also the recommended model for FIPS deployments, for the
same reason as (1): removing the OpenSSL default-provider fallback path reduces the
risk that an application inadvertently uses a non-FIPS algorithm from OpenSSL's own
provider. It does not by itself guarantee system-wide FIPS compliance — explicitly
loaded third-party providers and direct low-level calls remain outside its control —
but it closes the most common accidental-fallback path. See the FIPS 140-3 Support
chapter and the wolfProvider FIPS Integration Guide for details.

### Confirming Replace-Default Mode Is Active

The most reliable check is the OpenSSL provider list. In replace-default mode the
built-in `default` provider reports **wolfSSL Provider** as its name, and there is no
separate `libwolfprov` entry:

```sh
$ openssl list -providers
Providers:
  default
    name: wolfSSL Provider
    version: ...
    status: active
```

In the standard model the same command instead shows wolfProvider as a distinct
`libwolfprov` provider alongside OpenSSL's `default`. An OpenSSL built by the
wolfProvider scripts also carries a build-metadata suffix in its version string
(`openssl version` shows, for example, `OpenSSL 3.x.y+wolfProvider-nonfips`), though
that suffix alone marks a wolfProvider-produced OpenSSL, not specifically
replace-default mode.

### Replace-Default Testing Builds

A separate `--enable-replace-default-testing` option (which requires
`--replace-default`) exists **for wolfProvider's own unit tests only, and must not
be used in production**. Because a replace-default OpenSSL no longer exposes a
genuine OpenSSL default provider to compare against, this option exports a handful of
otherwise-internal OpenSSL symbols so the unit tests can load the real OpenSSL
provider under a separate name and check wolfProvider's output against it. It is a
test-harness aid, not a deployment mode; the build scripts print prominent
"testing only" warnings when it is enabled.
