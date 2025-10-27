# wolfProvider Open Source Project Integration Guide

## Notes on Open Source Integration

wolfProvider conforms to the general OpenSSL provider framework and architecture. As such, it can be leveraged from any OpenSSL-consuming application that correctly loads and initializes providers and wolfProvider through an OpenSSL configuration file or programmatically via API calls.

wolfSSL has tested wolfProvider with numerous open source projects through automated CI/CD workflows. This chapter contains notes and tips on wolfProvider integration with the tested projects.

### Tested Open Source Projects

The following Open Source Projects (OSPs) have been tested and verified to work with wolfProvider:

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

## Testing and Validation
All of the above referenced open source project's are continuously tested in the wolfProvider CI/CD pipeline with:

* OpenSSL version `openssl-3.5.2`
* wolfSSL version `v5.8.2-stable`
* Force failure testing to ensure proper error handling
* debian bookworm packaging testing
* FIPS testing is also done through a Jenkins pipeline

This comprehensive testing ensures that wolfProvider consistently maintains compatibility with a wide range of open source projects and their various use cases.


## Integrating an Open Source Project with wolfProvider

This guide is designed to assist in integrating an Open Source Project (OSP) with wolfProvider.

### Building wolfProvider from Source

Build wolfProvider using the provided script:

```bash
./scripts/build-wolfprovider.sh
```

This script clones and builds a local installation of OpenSSL (into `openssl-source` and `openssl-install`), wolfSSL (into `wolfssl-source` and `wolfssl-install`), and also builds wolfProvider itself.

### Getting an OSP to use wolfProvider

#### Establish a Baseline

First, establish a baseline for test results. For this example, we will use cURL. Clone and build cURL with default options, then run `make test-ci` to ensure it works properly without wolfProvider:

```bash
git clone https://github.com/curl/curl.git
cd curl
autoreconf -ivf
./configure --with-openssl
make
make test-ci
```

#### Check for Hard-Loaded Default Provider

Search the OSP source code for `provider_load`:

```bash
grep -r "provider_load" .
```

If the code hard-loads the default provider, it will need to be patched to use libwolfprov instead.

If the OSP code does not hard-load the default provider, then the provider is likely picked up from the OpenSSL configuration file being used. To override this behavior, use an OpenSSL configuration file that specifies wolfProvider. A sample configuration is provided at `wolfProvider/provider.conf`.

You will also need the appropriate `LD_LIBRARY_PATH` and `OPENSSL_MODULES` environment variables. The `OPENSSL_MODULES` variable is used as the path where provider libraries are searched.

To get a complete set of environment variables needed for testing you can run the following script:

```bash
./scripts/test-sanity.sh
```

This script dumps all environment variables used for testing. Copy the values for `LD_LIBRARY_PATH`, `OPENSSL_CONF`, and `OPENSSL_MODULES` from the output.

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

Even if the previous tests for the OSP run successfully, there is no guarantee that wolfProvider itself actually ran. If the default provider was being used instead, it would also pass with the same result. So we need to verify that wolfProvider is actually being used.

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

There are a number of potential problems to be aware of when integrating an OSP with wolfProvider.

#### False Positives with WOLFPROV_FORCE_FAIL

A successful `WOLFPROV_FORCE_FAIL=1` test does not fully guarantee that the OSP under test is using wolfProvider. When you export environment variables, everything in the system uses those conditions.

For example, imagine a test framework where the OSP binary performs some work and outputs a PEM file. In a test script, you now call `openssl` to verify the contents of the PEM file, which fails because `openssl` now uses the always-failing provider when attempting the operation. In this case, the underlying OSP did not use wolfProvider, yet setting `WOLFPROV_FORCE_FAIL=1` gave the behavior you expected.

Always double-check that the underlying OSP is operating as you expect it to.

#### Inline Crypto and Algorithms Not Using OpenSSL

Some Open Source Projects implement cryptographic algorithms directly in their code rather than delegating to OpenSSL. These inline crypto implementations bypass OpenSSL entirely, which means they won't use wolfProvider even when it's properly configured.

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
* OSP binaries that run under systemd with custom environment handling
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

#### Building your OSP with Replace Default

Here's a complete example demonstrating how to build and test your OSP using wolfProvider with the replace default approach for this example we used cURL again.

**Step 1: Build wolfProvider with Replace Default**

```bash
cd wolfProvider
./scripts/build-wolfprovider.sh --distclean --replace-default
```

This creates a patched OpenSSL in `openssl-install/` that has wolfProvider as its default provider.

**Step 2: Build the OSP**

The next step would be to build the OSP. In the case of cURL, we can build it by running roughly the following commands:

```bash
git clone https://github.com/curl/curl.git
cd curl
autoreconf -ivf
./configure --with-openssl
make
make test-ci
```

**Step 4: Verify wolfProvider is being used**

Since OpenSSL was patched to use wolfProvider as default, the built OSP will automatically use wolfProvider we can verify that replace default is in effect and correctly working by running the following command:

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

If the OSP you are integrating is included in the list of tested open source projects, we have already implented and tested your project!You can check out exactly how we did it by looking at the GitHub Actions workflows in the [wolfSSL/wolfProvider](https://github.com/wolfSSL/wolfProvider) repository on GitHub under `.github/workflows/`. For example, the cURL integration workflow is available at [here](https://github.com/wolfSSL/wolfProvider/blob/master/.github/workflows/curl.yml)
