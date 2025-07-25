# Notes on Open Source Integration

wolfProvider conforms to the general OpenSSL provider framework and architecture. As such, it can be leveraged from any OpenSSL-consuming application that correctly loads and initializes providers and wolfProvider through an OpenSSL configuration file or programmatically via API calls.

wolfSSL has tested wolfProvider with numerous open source projects through automated CI/CD workflows. This chapter contains notes and tips on wolfProvider integration with the tested projects.

## Tested Open Source Projects

The following Open Source Projects (OSPs) have been tested and verified to work with wolfProvider:

### Network and Web Technologies
* cURL - Command line tool for transferring data with URLs
* gRPC - High-performance RPC framework
* libwebsockets - Lightweight C library for websockets
* Nginx - High-performance HTTP server and reverse proxy
* Qt5 Network - Qt networking module

### Security and Authentication
* OpenSSH - Secure shell implementation
* libssh2 - SSH2 library
* libfido2 - FIDO2 library for WebAuthn
* OpenSC - Smart card tools and middleware
* pam-pkcs11 - PAM module for PKCS#11
* OpenVPN - VPN solution
* Stunnel - SSL wrapper for network services

### System and Network Tools
* systemd - System and service manager
* tcpdump - Network packet analyzer
* rsync - File synchronization utility
* tnftp - Enhanced FTP client
* iperf - Network performance measurement tool
* IPMItool - IPMI management tool
* PPP - Point-to-Point Protocol implementation

### Directory and Identity Services
* OpenLDAP - Lightweight Directory Access Protocol
* SSSD - System Security Services Daemon
* Net-SNMP - Network management protocol implementation

### Cryptography and PKI
* cjose - C library for JWT
* libeac3 - Electronic Authentication Components
* libhashkit2 - Consistent hashing library
* liboauth2 - OAuth2 library
* libtss2 - TPM2 Software Stack
* tpm2-tools - TPM2 tools
* xmlsec - XML Security library
* sscep - SCEP client implementation

### Development and Testing
* Asan - Address Sanitizer testing
* Codespell - Spell checker for source code
* Multi-Compiler - Multi-compiler testing

### Remote Access and Display
* x11vnc - VNC server for X11
* python3-ntp - Python NTP library

### Other Utilities
* Socat - Multipurpose relay for bidirectional data transfer
* Simple - Simple test applications

## General Setup
Most of these projects require similar setup steps:

1. Clone from Github
2. Build with Autotools
3. Configure with OpenSSL
4. Make and Install
5. Use wolfProvider:
   ```
   export OPENSSL_CONF=/path/to/provider.conf
   export OPENSSL_MODULES=/path/to/wolfprov-install/lib
   ```

After running make (or the equivalent build script) the configured version of OpenSSL can be checked by running `ldd /path/to/compiled/binary`. This will provide a list of which libraries are linked against. If the incorrect version is present then setting some combination of these four environment variables before rebuilding may help:
```
export LD_LIBRARY_PATH="/path/to/wolfssl/install/lib:/path/to/openssl/install/lib64"
export PKG_CONFIG_PATH="/path/to/openssl/install/lib64/pkgconfig"
export LDFLAGS="-L/path/to/openssl/install/lib64"
export CPPFLAGS="-I/path/to/openssl/install/include"
```

Further, wolfProvider gives some ability to determine if the library is actually using wolfProvider. Just do `export WOLFPROV_FORCE_FAIL=1` or `WOLFPROV_FORCE_FAIL=1 /command/to/run` and if the command ends up using wolfProvider crypto it will fail.

If the project being used is included in the list of tested open source project's then the testing scripts can be referenced. These can be found in the [wolfssl/wolfProvider](https://github.com/wolfSSL/wolfProvider) repository on GitHub under .github/workflows/.

## Testing and Validation
All of the above referenced open source project's are continuously tested in the wolfProvider CI/CD pipeline with:

* OpenSSL version 3.5.0
* wolfSSL with both master and stable releases
* Force failure testing to ensure proper error handling
* FIPS testing is also done through a Jenkins pipeline

This comprehensive testing ensures that wolfProvider maintains compatibility with a wide range of open source projects and their various use cases.
