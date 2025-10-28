# wolfProvider Application Integration Guide
---

## Introduction to OpenSSL Providers

This guide provides comprehensive instructions for integrating applications with wolfProvider, an OpenSSL provider that replaces OpenSSL's default cryptographic implementations with wolfSSL's certified algorithms. Whether you're new to OpenSSL providers or need to integrate an existing application, this guide will take you from zero knowledge to successful integration.

### What is an OpenSSL Provider?

OpenSSL 3.0+ introduced a modular architecture where cryptographic algorithms are implemented in separate modules called "providers." Instead of having all cryptographic functions built into the main OpenSSL library, providers contain specific algorithm implementations that can be loaded dynamically. In the case of wolfProvider, we can leverage our provider to utilize all of the [wolfcrypt](https://github.com/wolfSSL/wolfssl) functions, algorithms, validations, and features. 

**Key Concepts:**
- **Provider**: A module containing cryptographic algorithm implementations
- **Default Provider**: OpenSSL's built-in provider with standard algorithms
- **Legacy Provider**: Contains older algorithms that may be deprecated
- **FIPS Provider**: Contains FIPS-validated algorithms
- **Third-party Providers**: Like wolfProvider, which replace OpenSSL's algorithms with alternative implementations

### Why Use wolfProvider?

wolfProvider offers several advantages over OpenSSL's default provider:

1. **FIPS 140-3 Certification**: wolfSSL's algorithms are FIPS 140-3 validated
2. **Performance**: Optimized implementations often outperform OpenSSL
3. **Security**: wolfSSL focuses on security-first design principles
4. **Compliance**: Meets various regulatory requirements
5. **Consistency**: Same cryptographic library across different platforms

### OpenSSL Provider Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Application                      │
├─────────────────────────────────────────────────────┤
│                 OpenSSL Library                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │   Provider  │  │   Provider  │  │   Provider  │  │
│  │   Manager   │  │   Manager   │  │   Manager   │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
├─────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │   Default   │  │ wolfProvider│  │   Legacy    │  │
│  │  Provider   │  │             │  │  Provider   │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────┘
```

The Provider Manager handles loading and routing cryptographic operations to the appropriate provider based on:
- Configuration files
- Environment variables
- Programmatic API calls
- Default fallback behavior

### How Providers Are Loaded

OpenSSL can load providers through several mechanisms:

#### 1. Configuration File Loading

OpenSSL reads configuration from:
- System-wide: `/etc/ssl/openssl.cnf` (Linux), `/usr/local/ssl/openssl.cnf` (macOS), or `C:\Program Files\Common Files\SSL\openssl.cnf` (Windows)
- User-specific: `~/.openssl/openssl.cnf` (Unix-like systems) or `%USERPROFILE%\.openssl\openssl.cnf` (Windows)
- Environment-specified: Path in `OPENSSL_CONF` environment variable (overrides all defaults)
- Built-in default: OpenSSL has a minimal built-in configuration if no file is found

**Example Configuration:**
```ini
openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
wolfProvider = wolfProvider_sect

[default_sect]
activate = 1

[wolfProvider_sect]
module = /path/to/libwolfprov.so
activate = 1
```

#### 2. Environment Variable Loading

Enviroment vairables can be used to set the configuration file and the directory containing the provider modules. Usually, these variables are set in the application's build system or deployment environment. When integrating applications with wolfProvider, these environment variables must be set to ensure that wolfProvider is used. 

Key environment variables:
- `OPENSSL_CONF`: Path to configuration file
- `OPENSSL_MODULES`: Directory containing provider modules
- `LD_LIBRARY_PATH`: Library search path (Linux/Unix)


These enviroment vairaibles allow openssl to correctly find the provider modules and configuration file. We will go into further detail regarding how to set these and deploy the correct env vararibles in order to use wolfProvider.

#### 3. Programmatic Loading

Applications can load providers directly using OpenSSL APIs. Many applications will use the OpenSSL configuration file to load providers. However, some applications will load providers programmatically using the OpenSSL APIs. This is a more flexible approach and allows for more control over the provider loading process. Usually if an applications loads OpenSSL like this it will look like this: 

```c
/* Example of default provider loading */
OSSL_PROVIDER *default_provider = OSSL_PROVIDER_load(NULL, "default");
if (default_provider == NULL) {
    /* Handle error */
}
```

As you can see the default provider is loaded and we will most likely need to patch this in order to load the correct provider. In our case we want to load `libwolfprov` instead of the default provider. an example is provided below:

```c
/* Example of wolfProvider loading */
OSSL_PROVIDER *wolfProvider = OSSL_PROVIDER_load(NULL, "libwolfprov");
if (wolfProvider == NULL) {
    /* Handle error */
}
```

### Provider Selection and Fallback

When an application requests a cryptographic operation, OpenSSL will first:

1. **Checks loaded providers** in order of preference
2. **Searches for the algorithm** in each provider
3. **Uses the first match** found
4. **Falls back to default** if no provider implements the algorithm

The order of provider loading matters. If multiple providers implement the same algorithm, the first one loaded typically wins.



## Notes on Application Integration
---

wolfProvider conforms to the general OpenSSL provider framework and architecture. As such, it can be leveraged from any OpenSSL-consuming application that correctly loads and initializes providers and wolfProvider through an OpenSSL configuration file or programmatically via API calls.

wolfSSL has tested wolfProvider with numerous Applications through automated CI/CD workflows. This chapter contains notes and tips on wolfProvider integration with the tested projects.

### Tested Open Source Applications

The following applications have been tested and verified to work with wolfProvider:

#### Network and Web Technologies
* cURL - Command line tool for transferring data with URLs
* gRPC - High-performance RPC framework
* libwebsockets - Lightweight C library for websockets
* Nginx - High-performance HTTP server and reverse proxy
* Qt5 Network - Qt networking module

#### Security and Authentication
* OpenSSH - Secure shell implementation
* libssh2 - SSH2 library
* libfido2 - FIDO2 library for WebAuthn
* OpenSC - Smart card tools and middleware
* pam-pkcs11 - PAM module for PKCS#11
* OpenVPN - VPN solution
* Stunnel - SSL wrapper for network services

#### System and Network Tools
* systemd - System and service manager
* tcpdump - Network packet analyzer
* rsync - File synchronization utility
* tnftp - Enhanced FTP client
* iperf - Network performance measurement tool
* IPMItool - IPMI management tool
* PPP - Point-to-Point Protocol implementation

#### Directory and Identity Services
* OpenLDAP - Lightweight Directory Access Protocol
* SSSD - System Security Services Daemon
* Net-SNMP - Network management protocol implementation

#### Cryptography and PKI
* cjose - C library for JWT
* libeac3 - Electronic Authentication Components
* libhashkit2 - Consistent hashing library
* liboauth2 - OAuth2 library
* libtss2 - TPM2 Software Stack
* tpm2-tools - TPM2 tools
* xmlsec - XML Security library
* sscep - SCEP client implementation

#### Development and Testing
* Asan - Address Sanitizer testing
* Codespell - Spell checker for source code
* Multi-Compiler - Multi-compiler testing

#### Remote Access and Display
* x11vnc - VNC server for X11
* python3-ntp - Python NTP library

#### Other Utilities
* Socat - Multipurpose relay for bidirectional data transfer
* Simple - Simple test applications



## Integration Methodology
---

Before diving into specific integration steps, it's important to understand the overall methodology and what we are trying to achive with this integration. This integration is designed to replace the default provider with wolfProvider. We can utilize enviroment variables and OpenSSL configuration file to load wolfProvider. We can also patch the application to load wolfProvider instead of the default provider.

### Integration Goals

The primary goal is to ensure that your application uses wolfProvider for cryptographic operations instead of OpenSSL's default provider. This involves:

1. **Building wolfProvider**: Creating the provider library
2. **Configuring the environment**: Setting up OpenSSL to load wolfProvider
3. **Building your application**: Ensuring it links against the correct OpenSSL
4. **Verifying integration**: Confirming wolfProvider is actually being used
5. **Testing thoroughly**: Ensuring functionality works as expected

### Integration Process Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Build         │    │   Configure     │    │   Build         │
│   wolfProvider  │───▶│   Environment   │───▶│   Application   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Provider      │    │   OpenSSL       │    │   Application   │
│   Library       │    │   Configuration │    │   Binary        │
│   (libwolfprov) │    │   & Environment │    │   (with crypto) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌─────────────────────────┐
                    │   Verification &        │
                    │   Testing               │
                    └─────────────────────────┘
```

### Pre-Integration Analysis

Before starting integration, analyze your application:

1. **Does it use OpenSSL?** Check if the application actually uses OpenSSL for crypto
2. **How does it load providers?** Look for hard-coded provider loading
3. **What algorithms does it use?** Some may be implemented inline
4. **What's the build system?** Understand how to modify the build process
5. **Are there existing tests?** You'll need a baseline to compare against

### Success Criteria

Your integration is successful when:

1. **Application builds** without errors against wolfProvider-enabled OpenSSL
2. **Tests pass** with wolfProvider loaded
3. **Tests fail** when `WOLFPROV_FORCE_FAIL=1` is set
4. **Performance** meets or exceeds baseline
5. **All cryptographic operations** use wolfProvider (verified)

## Integrating an Application with wolfProvider
---

This guide is designed to assist in integrating an Application with wolfProvider.

### Building wolfProvider from Source

Build wolfProvider using the provided script. This script will clone and build a local installation of OpenSSL (into `openssl-source` and `openssl-install`), wolfSSL (into `wolfssl-source` and `wolfssl-install`), and also builds wolfProvider itself. This script will consolodate all of your building needs for wolfProvider. You can use the `--help` flag to see all of the available options and arguments. For now we will start with a basline build like so:

```bash
./scripts/build-wolfprovider.sh
```

### Getting an Application to use wolfProvider

#### Establish a Baseline

**Why establish a baseline?** Before integrating wolfProvider, you need to verify that your application works correctly with standard OpenSSL. This baseline serves multiple purposes:

1. **Proves the application works**: Ensures there are no existing issues
2. **Provides comparison data**: Performance and functionality benchmarks
3. **Identifies test failures**: Distinguishes wolfProvider issues from pre-existing problems
4. **Documents expected behavior**: Creates a reference for verification

**Baseline Process**: For this example, we will use cURL. Clone and build cURL with default options, then run `make test-ci` to ensure it works properly without wolfProvider:

```bash
git clone https://github.com/curl/curl.git
cd curl
autoreconf -ivf
./configure --with-openssl
make
make test-ci
```

#### Check for Hard-Loaded Default Provider

**What is hard-loading?** Some applications explicitly load specific providers using OpenSSL APIs, bypassing configuration files and environment variables. This can prevent wolfProvider from being used.

**Detection Methods**: There are a few ways to check if the application is hard-loading the default provider. We can search for provider loading calls, provider-specific code, and explicit provider names.

1. **Search for provider loading calls:**
```bash
grep -r "provider_load" .
grep -r "OSSL_PROVIDER_load" .
grep -r "EVP_default_properties_enable_fips" .
```

2. **Look for provider-specific code:**
```bash
grep -r "default" . | grep -i provider
grep -r "fips" . | grep -i provider
```

3. **Check for explicit provider names:**
```bash
grep -r "default" . | grep -i openssl
```

**If hard-loading is found:**
- The application will need to be patched to load wolfProvider instead
- This requires source code modifications
- Consider the Replace Default approach as an alternative

**If no hard-loading is found:**
- The provider is likely loaded from OpenSSL configuration files
- Use wolfProvider's configuration file: `wolfProvider/provider.conf`
- We can set appropriate environment variables to load wolfProvider in this case.

#### Environment Variable Setup

If the Application code does not hard-load the default provider, then the provider is likely picked up from the OpenSSL configuration file being used. To override this behavior, use an OpenSSL configuration file that specifies wolfProvider. A sample configuration 
is provided at `wolfProvider/provider.conf`.

**Critical Environment Variables:**

1. **`OPENSSL_CONF`**: Path to the OpenSSL configuration file that loads wolfProvider
2. **`OPENSSL_MODULES`**: Directory containing provider modules (where libwolfprov.so is located)
3. **`LD_LIBRARY_PATH`**: Library search path for OpenSSL and wolfProvider libraries

**Getting the correct values:**

To get a complete set of environment variables needed for testing you can run the following script:

```bash
./scripts/test-sanity.sh
```

This script outputs all environment variables used for testing. Copy the values for:
- `LD_LIBRARY_PATH`
- `OPENSSL_CONF` 
- `OPENSSL_MODULES`

**Example output**: The output will look something like the following:
```bash
LD_LIBRARY_PATH=/path/to/wolfssl/install/lib:/path/to/openssl/install/lib64
OPENSSL_CONF=/path/to/wolfProvider/provider.conf
OPENSSL_MODULES=/path/to/wolfProvider
```

**Why these variables matter**: These variables are critical for ensuring that wolfProvider is used. `OPENSSL_CONF` tells OpenSSL which configuration file to use. `OPENSSL_MODULES` tells OpenSSL where to find provider libraries. `LD_LIBRARY_PATH` ensures the correct OpenSSL and wolfSSL libraries are loaded.
- `OPENSSL_CONF` tells OpenSSL which configuration file to use
- `OPENSSL_MODULES` tells OpenSSL where to find provider libraries
- `LD_LIBRARY_PATH` ensures the correct OpenSSL and wolfSSL libraries are loaded

#### Run Tests with wolfProvider

Using the values copied from the `test-sanity.sh` output, export the environment variables and run the tests:

```bash
export LD_LIBRARY_PATH=...
export OPENSSL_CONF=...
export OPENSSL_MODULES=...
make test-ci
```

### Verifying wolfProvider is Being Used

#### Using `WOLFPROV_FORCE_FAIL`

Even if the previous tests for the Application run successfully, there is no guarantee that wolfProvider itself actually ran. If the default provider was being used instead, it would also pass with the same result. So we need to verify that wolfProvider is actually being used.

To ensure wolfProvider is actually running for the test, use the environment variable `WOLFPROV_FORCE_FAIL`. When set to `1`, all crypto calls to wolfProvider will fail. This allows us to verify exactly what is being used and if it is using wolfProvider. You can verify the behavior by running the following command:

```bash
export WOLFPROV_FORCE_FAIL=1
make test-ci
```

If wolfProvider is being used, the tests should now fail. If they pass, then wolfProvider is not being used.

#### Using the `verify-install.sh` script

Another good test to run is the `scripts/verify-install.sh` script. This script will verify that the OpenSSL and wolfProvider libraries are installed correctly and that wolfProvider is being used. depending on the options you pass to the script, it will verify that the OpenSSL and wolfProvider libraries are installed correctly and that wolfProvider is being used.

```bash
./scripts/verify-install.sh
```

### Debugging wolfProvider

To debug wolfProvider, it must be rebuilt with debug options. This enables debug logging to stderr by default. Build with debug using the following commands:

```bash
cd wolfProvider
./scripts/build-wolfprovider.sh --distclean --debug
```

wolfProvider is now built with debug symbols (as are local installs of OpenSSL and wolfSSL), and logs to stderr by default.

### wolfProvider "Gotchas"

There are a number of potential problems to be aware of when integrating an Application with wolfProvider.

#### False Positives with WOLFPROV_FORCE_FAIL

A successful `WOLFPROV_FORCE_FAIL=1` test does not fully guarantee that the Application under test is using wolfProvider. When you export environment variables, everything in the system uses those conditions.

For example, imagine a test framework where the Application binary performs some work and outputs a PEM file. In a test script, you now call `openssl` to verify the contents of the PEM file, which fails because `openssl` now uses the always-failing provider when attempting the operation. In this case, the underlying Application did not use wolfProvider, yet setting `WOLFPROV_FORCE_FAIL=1` gave the behavior you expected.

Always double-check that the underlying Application is operating as you expect it to.

#### Inline Crypto and Algorithms Not Using OpenSSL

Some Applications implement cryptographic algorithms directly in their code rather than delegating to OpenSSL. These inline crypto implementations bypass OpenSSL entirely, which means they won't use wolfProvider even when it's properly configured.

OpenSSH is a prominent example of this behavior. By default, OpenSSH uses certain algorithms that are implemented directly in OpenSSH's code:

- `ed25519` - uses OpenSSH's inline crypto, not OpenSSL
- `chacha20-poly1305` - also implemented in OpenSSH's own code  
- Many other OpenSSH-specific algorithms

When testing OpenSSH with `WOLFPROV_FORCE_FAIL=1`:

```bash
export WOLFPROV_FORCE_FAIL=1
ssh-keygen -t ed25519
```

This test will likely succeed because the `ed25519` algorithm bypasses OpenSSL entirely and uses OpenSSH's inline implementation. Only operations that explicitly call OpenSSL's crypto APIs will fail with `WOLFPROV_FORCE_FAIL=1`.

Yet the command above could fail still in some cases. If Openssl is used in the background to parse the OpenSSL configuration file and other OpenSSL related operations. This could create a rare situation where `WOLFPROV_FORCE_FAIL=1` may cause OpenSSH tests to fail even though the primary cryptographic operations (like generating an ed25519 key or the chacha20-poly1305 cipher) are not using OpenSSL at all yet they still fail with WOLFPROV_FORCE_FAIL=1.

#### Complex Test Environments

Be on the lookout for complex test environments that override or explicitly set environment variables. Common issues include:

* Explicitly set `OPENSSL_CONF` variables
* Application binaries that run under systemd with custom environment handling
* Test frameworks using VMs that need to be modified to inject new environment variables into them
* Debug logs being swallowed by the test framework or sent directly to `/dev/null`

As a workaround for lost debug logs, consider modifying the logging to go directly to a local file.

#### Verifying Library Dependencies

After running make (or the equivalent build script), you can check which OpenSSL version is linked by running:

```bash
ldd /path/to/compiled/binary
```

This provides a list of which libraries are linked. If the incorrect version is present, set these environment variables before rebuilding:

```bash
export LD_LIBRARY_PATH="/path/to/wolfssl/install/lib:/path/to/openssl/install/lib64"
export PKG_CONFIG_PATH="/path/to/openssl/install/lib64/pkgconfig"
export LDFLAGS="-L/path/to/openssl/install/lib64"
export CPPFLAGS="-I/path/to/openssl/install/include"
```

### Alternative Approach: Replace Default

The traditional approach of configuring wolfProvider through environment variables or OpenSSL configuration files can be complex and error-prone, especially in production environments. The `--replace-default` option provides a robust alternative by modifying the OpenSSL source code itself to make wolfProvider the default cryptographic provider.

#### How Replace Default Works

When using `--replace-default`, the wolfProvider build script modifies OpenSSL's provider initialization code at compile-time. Instead of loading the standard OpenSSL default provider, the patched OpenSSL hard-loads wolfProvider as the default provider. This means:

* **No configuration files needed**: OpenSSL is compiled with wolfProvider as its built-in default
* **No environment variables required**: `OPENSSL_CONF` and `OPENSSL_MODULES` are not needed
* **Guaranteed provider usage**: Applications cannot accidentally use standard OpenSSL crypto since wolfProvider is the only provider
* **Compile-time integration**: wolfProvider becomes part of OpenSSL rather than being loaded dynamically

The patch modifies OpenSSL's provider loading mechanism to statically link wolfProvider as the default provider during initialization, ensuring it's always used.

#### Building with Replace Default

To build wolfProvider with replace default enabled, use the build script:

```bash
./scripts/build-wolfprovider.sh --replace-default
```

This performs the following steps:
1. **Downloads and patches OpenSSL**: Opens the OpenSSL source and applies a patch that hard-loads wolfProvider as the default provider
2. **Builds patched OpenSSL**: Compiles OpenSSL with wolfProvider integrated
3. **Builds wolfProvider**: Compiles the wolfProvider library against the patched OpenSSL
4. **Installs components**: Installs both the patched OpenSSL and wolfProvider

For a complete rebuild from scratch:

```bash
./scripts/build-wolfprovider.sh --distclean --replace-default
```

#### Building your Application with Replace Default

Here's a complete example demonstrating how to build and test your Application using wolfProvider with the replace default approach for this example we used cURL again.

**Step 1: Build wolfProvider with Replace Default**

```bash
cd wolfProvider
./scripts/build-wolfprovider.sh --distclean --replace-default
```

This creates a patched OpenSSL in `openssl-install/` that has wolfProvider as its default provider.

**Step 2: Build the Application**

The next step would be to build the Application. In the case of cURL, we can build it by running roughly the following commands:

```bash
git clone https://github.com/curl/curl.git
cd curl
autoreconf -ivf
./configure --with-openssl
make
make test-ci
```

**Step 4: Verify wolfProvider is being used**

Since OpenSSL was patched to use wolfProvider as default, the built Application will automatically use wolfProvider we can verify that replace default is in effect and correctly working by running the following command:

```bash
./scripts/verify-install.sh --replace-default
```

This should show that OpenSSL and wolfProvider are installed correctly with replace default in effect and it will look something like the following:

```bash
Run $GITHUB_WORKSPACE/scripts/verify-install.sh --replace-default 
SUCCESS: openssl and wolfProvider installed correctly
```

**Step 5: Force failure verification**

With replace default, you can still use `WOLFPROV_FORCE_FAIL` to verify wolfProvider is active:

```bash
export WOLFPROV_FORCE_FAIL=1
make test-ci
```

#### When to Use Replace Default

This approach is recommended when:

* You have control over the OpenSSL installation and can rebuild OpenSSL
* You need absolute certainty that wolfProvider is being used
* You want to avoid environment variable and loading complexities
* You're deploying to production environments where misconfiguration risk must be eliminated
* You want system-wide consistency across all applications
* You're building custom distributions or containers where you control the base OpenSSL

The replace default approach is used in wolfProvider's Debian packaging and CI/CD workflows currently. For working examples of this approach, see the GitHub Actions workflows in the [wolfProvider repository](https://github.com/wolfSSL/wolfProvider/tree/master/.github/workflows).

### Reference Implementation

If the Application you are integrating is included in the list of tested Open Source Projects, we have already implented and tested your project! You can check out exactly how we did it by looking at the GitHub Actions workflows in the [wolfSSL/wolfProvider](https://github.com/wolfSSL/wolfProvider) repository on GitHub under `.github/workflows/`. For example, the cURL integration workflow is available at [here](https://github.com/wolfSSL/wolfProvider/blob/master/.github/workflows/curl.yml)



## Testing and Validation
---

### Comprehensive Testing Strategy

wolfProvider employs a multi-layered testing approach to ensure reliability, compatibility, and security across diverse environments and applications. This section details the testing methodologies, tools, and processes used to validate wolfProvider integrations.

### CI/CD Pipeline Testing

All referenced open source applications are continuously tested in the wolfProvider CI/CD pipeline with:

**Core Components:**
* OpenSSL version `openssl-3.5.2`
* wolfSSL version `v5.8.2-stable`
* Force failure testing to ensure proper error handling
* Debian bookworm packaging testing
* FIPS testing through Jenkins pipeline

### GitHub Workflows Reference

The wolfProvider project maintains comprehensive GitHub Actions workflows that serve as both testing infrastructure and integration examples. These workflows demonstrate best practices for:

**Key Workflow Categories:**

1. **Application-Specific Workflows**: Individual workflows for each tested application (cURL, OpenSSH, Nginx, etc.)
2. **Build and Test Workflows**: Automated building and testing across multiple environments
3. **Packaging Workflows**: Debian package creation and validation
4. **FIPS Testing Workflows**: Specialized testing for FIPS compliance

**Accessing Workflow Examples:**

All workflow files are available in the [wolfProvider GitHub repository](https://github.com/wolfSSL/wolfProvider/tree/master/.github/workflows/).

This comprehensive testing framework ensures that wolfProvider consistently maintains compatibility with a wide range of Applications and their various use cases, providing confidence for production deployments.
