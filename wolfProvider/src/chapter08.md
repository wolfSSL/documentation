# wolfProvider Design

wolfProvider is composed of the following source files, all located under the "src" subdirectory of the wolfProvider package.

| Source File | Description |
| --------------- | ---------------- |
| wp_wolfprov.c | Contains library entry points. Calls OpenSSL IMPLEMENT_DYNAMIC_BIND_FN for dynamic loading of the library using the OpenSSL provider framework. Also includes static entry points when compiled and used as a static library. |
| wp_internal.c | Includes wolfprovider_bind() function, which handles registration of provider algorithm callbacks. Also includes other wolfprovider internal functionality. |
| wp_logging.c | wolfProvider logging framework and function implementations. |
| wp_aes_aead.c | wolfProvider AES-AEAD (Authenticated Encryption with Associated Data) implementation. |
| wp_aes_block.c | wolfProvider AES-ECB and AES-CBC implementation. |
| wp_aes_stream.c | wolfProvider AES stream cipher implementation. |
| wp_aes_wrap.c | wolfProvider AES key wrapping implementation. |
| wp_cmac.c | wolfProvider CMAC (Cipher-based Message Authentication Code) implementation. |
| wp_dec_epki2pki.c | wolfProvider encrypted private key to private key conversion implementation. |
| wp_dec_pem2der.c | wolfProvider PEM to DER format conversion implementation. |
| wp_des.c | wolfProvider DES implementation. |
| wp_dh_exch.c | wolfProvider DH key exchange implementation. |
| wp_dh_kmgmt.c | wolfProvider DH key management implementation. |
| wp_digests.c | wolfProvider message digest implementations (SHA-1, SHA-2, SHA-3, ...). |
| wp_drbg.c | wolfProvider DRBG (Deterministic Random Bit Generator) implementation. |
| wp_ecc_kmgmt.c | wolfProvider ECC key management implementation. |
| wp_ecdh_exch.c | wolfProvider ECDH key exchange implementation. |
| wp_ecdsa_sig.c | wolfProvider ECDSA signature implementation. |
| wp_ecx_exch.c | wolfProvider ECX key exchange implementation (X25519, X448, ...). |
| wp_ecx_kmgmt.c | wolfProvider ECX key management implementation. |
| wp_ecx_sig.c | wolfProvider ECX signature implementation (Ed25519, Ed448, ...). |
| wp_file_store.c | wolfProvider file storage implementation. |
| wp_fips.c | wolfProvider FIPS validation implementation. |
| wp_gmac.c | wolfProvider GMAC (Galois/Counter Mode) implementation. |
| wp_hkdf.c | wolfProvider HKDF (HMAC-based Key Derivation Function) implementation. |
| wp_hmac.c | wolfProvider HMAC implementation. |
| wp_kbkdf.c | wolfProvider KBKDF (Key-Based Key Derivation Function) implementation. |
| wp_kdf_exch.c | wolfProvider KDF key exchange implementation. |
| wp_kdf_kmgmt.c | wolfProvider KDF key management implementation. |
| wp_krb5kdf.c | wolfProvider Kerberos 5 KDF implementation. |
| wp_mac_kmgmt.c | wolfProvider MAC key management implementation. |
| wp_mac_sig.c | wolfProvider MAC signature implementation. |
| wp_params.c | wolfProvider parameter handling implementation. |
| wp_pbkdf2.c | wolfProvider PBKDF2 (Password-Based Key Derivation Function 2) implementation. |
| wp_rsa_asym.c | wolfProvider RSA asymmetric encryption implementation. |
| wp_rsa_kem.c | wolfProvider RSA KEM (Key Encapsulation Mechanism) implementation. |
| wp_rsa_kmgmt.c | wolfProvider RSA key management implementation. |
| wp_rsa_sig.c | wolfProvider RSA signature implementation. |
| wp_tls1_prf.c | wolfProvider TLS 1.0 PRF implementation. |
| wp_tls_capa.c | wolfProvider TLS capabilities implementation. |


## wolfProvider Entry Points

The main entry points into the wolfProvider library are **OSSL_provider_init()** and **wolfssl_provider_init()**.

**OSSL_provider_init()** is the standard OpenSSL provider entry point that is called automatically by OpenSSL when the provider is loaded dynamically. This function is defined in `wp_wolfprov.c` and serves as a wrapper that calls `wolfssl_provider_init()`.

**wolfssl_provider_init()** is the core initialization function that:

- Sets up the provider context
- Initializes the dispatch table with provider functions
- Handles FIPS mode configuration
- Sets up debugging if enabled
- Returns the provider's dispatch table containing function pointers for:

  * `wolfprov_teardown` - Provider cleanup
  * `wolfprov_gettable_params` - Parameter table retrieval
  * `wolfprov_get_params` - Parameter retrieval
  * `wolfprov_query` - Operation querying
  * `wolfssl_prov_get_capabilities` - Capability reporting

The provider is loaded by OpenSSL when applications request wolfProvider algorithms, and the dispatch table allows OpenSSL to call the appropriate wolfProvider functions for cryptographic operations.

## wolfProvider Dispatch Table Functions

The wolfProvider dispatch table contains several key functions that handle different aspects of provider operation. Each function serves a specific purpose in the OpenSSL provider framework.

**Note on OSSL Parameters (Referenced Later):** OSSL parameters are a standardized way for OpenSSL to exchange configuration data and capabilities information with providers. Parameters can represent simple values (integers, strings, booleans) or complex structures, and they enable applications to query provider capabilities, configure behavior, and retrieve status information. The parameter system provides a type-safe, extensible mechanism for provider-application communication.

### wolfprov_teardown

The `wolfprov_teardown()` function is responsible for cleaning up wolfProvider when it is unloaded by OpenSSL. It performs the following cleanup tasks:

- Frees allocated provider context and resources
- Cleans up any remaining algorithm implementations
- Removes registered callbacks and handlers
- Ensures proper memory deallocation to prevent memory leaks
- Resets any global state maintained by the provider

This function is called automatically by OpenSSL when the provider is being unloaded, ensuring that all resources are properly released.

### wolfprov_gettable_params

The `wolfprov_gettable_params()` function returns a table of parameter descriptors that define what parameters the provider supports. This function accomplishes the following tasks:

- Defines the structure and types of parameters that can be retrieved
- Provides metadata about parameter names, types, and descriptions
- Enables OpenSSL to understand what parameters are available from the provider
- Supports parameter validation and type checking
- Allows applications to discover available provider parameters

The returned table contains parameter definitions that applications can use to query provider capabilities and configuration options.

### wolfprov_get_params

The `wolfprov_get_params()` function retrieves specific parameter values from the provider. This function:

- Accepts parameter requests from OpenSSL or applications
- Returns the current values of requested parameters
- Handles parameter type conversion and validation
- Provides access to provider configuration and state information
- Supports both simple parameters and complex parameter structures

Common parameters that can be retrieved include provider version, supported algorithms, FIPS mode status, and other configuration details.

### wolfssl_prov_get_capabilities

The `wolfssl_prov_get_capabilities()` function reports the cryptographic capabilities of wolfProvider to OpenSSL. It provides capability information which:

- Returns information about supported algorithms and operations
- Provides details about algorithm parameters and constraints
- Indicates FIPS compliance and validation status
- Reports performance characteristics and limitations
- Enables OpenSSL to make informed decisions about algorithm selection

The capabilities information helps OpenSSL determine when to use wolfProvider algorithms and how to configure them appropriately for different use cases.

### wolfprov_query

The `wolfprov_query()` function is the primary mechanism for algorithm discovery and registration in wolfProvider. It serves as the central routing mechanism that:

- Handles requests from OpenSSL for specific algorithm implementations
- Returns the appropriate algorithm structure when a supported algorithm is requested
- Provides operation-specific dispatch tables for cryptographic operations
- Manages algorithm registration and lookup within the provider
- Supports both symmetric and asymmetric cryptographic operations
- Enables dynamic algorithm discovery based on OpenSSL's requirements

When OpenSSL requests an algorithm (such as AES, RSA, SHA-256, etc.), `wolfprov_query()` determines if wolfProvider supports that algorithm and returns the corresponding implementation structure. This function acts as the central routing mechanism that connects OpenSSL's algorithm requests to the specific wolfProvider implementations found in the various source files (e.g., `wp_aes_block.c`, `wp_rsa_sig.c`, etc.).
