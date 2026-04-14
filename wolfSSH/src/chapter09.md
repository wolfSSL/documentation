# Windows Certificate Store Integration

## Overview

wolfSSH supports using the **Microsoft Windows Certificate Store** as a source of host keys, client authentication keys, and trusted CA certificates. This eliminates the need to manage private keys as files on disk — keys remain in the OS-managed certificate store where they are protected by the Windows security model (ACLs, TPM-backed storage, etc.).

The feature spans four areas:

1. **Server host-key signing** — `wolfsshd` and the echoserver can load their host key from a Windows certificate store instead of a PEM/DER file.
2. **Client authentication** — The SFTP client (and any application using the client common helpers) can authenticate to a server using a certificate and private key held in the Windows certificate store.
3. **Trusted CA loading** — `wolfsshd` can load trusted CA certificates from the Windows system store or a per-user certificate store, in addition to (or instead of) file-based CA certificates.
4. **CI test matrix** — A GitHub Actions workflow exercises all four server/client key-source combinations on Windows.

## Build Requirements

- **wolfSSL** compiled with `--enable-ssh` (and `--enable-keygen` if key generation is needed).
- **wolfSSH** compiled with `WOLFSSH_CERTS` defined (enabled by `--enable-certs` or `--enable-all`).
- **Windows platform** — the feature is gated on `USE_WINDOWS_API` and links against `ncrypt.lib` and `crypt32.lib`.

The Visual Studio project files under `ide/winvs/` have been updated to link `ncrypt.lib` and `crypt32.lib` for all relevant targets (wolfssh library, echoserver, client, sftpclient, unit-test, api-test).

All certificate-store code is conditionally compiled:

```c
#ifdef USE_WINDOWS_API
#ifdef WOLFSSH_CERTS
    /* ... cert store code ... */
#endif /* WOLFSSH_CERTS */
#endif /* USE_WINDOWS_API */
```

On non-Windows platforms, or when `WOLFSSH_CERTS` is not defined, none of this code is compiled and the binary size is unaffected.

The system CA loading path additionally requires `WOLFSSL_SYS_CA_CERTS` to be defined in the wolfSSL build.

## Supported Key Types

| Algorithm | SSH Type Name | Certificate Store Support |
|-----------|--------------|---------------------------|
| RSA | `ssh-rsa`, `rsa-sha2-256`, `rsa-sha2-512`, `x509v3-ssh-rsa` | Yes (via `NCryptSignHash` + `BCRYPT_PAD_PKCS1`) |
| ECDSA P-256 | `ecdsa-sha2-nistp256`, `x509v3-ecdsa-sha2-nistp256` | Yes (via `NCryptSignHash`, no padding) |
| ECDSA P-384 | `ecdsa-sha2-nistp384`, `x509v3-ecdsa-sha2-nistp384` | Yes |
| ECDSA P-521 | `ecdsa-sha2-nistp521`, `x509v3-ecdsa-sha2-nistp521` | Yes |

ECC curve detection is automatic — the certificate's algorithm parameters OID is decoded to determine which NIST curve is in use.

## Architecture

### Private Key Abstraction (`WOLFSSH_PVT_KEY`)

The `WOLFSSH_PVT_KEY` structure in `wolfssh/internal.h` has been extended with fields that allow a key slot to reference the Windows certificate store instead of an in-memory DER blob:

| Field              | Type              | Description |
|--------------------|-------------------|-------------|
| `useCertStore`     | `byte` (bitfield) | `1` if this key lives in the Windows certificate store. |
| `certStoreContext` | `void*`           | Opaque pointer to the `PCCERT_CONTEXT` returned by `CertFindCertificateInStore`. Freed with `CertFreeCertificateContext` in `CtxResourceFree`. |
| `storeName`        | `const wchar_t*`  | Wide-string store name (e.g., `L"My"`, `L"Root"`). Heap-allocated, freed in `CtxResourceFree`. |
| `subjectName`      | `const wchar_t*`  | Wide-string subject/CN used for certificate lookup. Heap-allocated, freed in `CtxResourceFree`. |
| `dwFlags`          | `DWORD`           | Store flags such as `CERT_SYSTEM_STORE_CURRENT_USER` or `CERT_SYSTEM_STORE_LOCAL_MACHINE`. |
| `cert` / `certSz`  | `byte*` / `word32` | Copy of the DER-encoded certificate. Used to extract the public key for key-exchange hashing and for presenting the certificate during authentication. |

When `useCertStore` is set, the in-memory `key`/`keySz` fields are **not populated** — all signing operations go through the Windows CNG/CAPI path.

### Signing Path — `SignWithCertStoreKey()`

The static function `SignWithCertStoreKey()` in `src/internal.c` handles signing operations:

```c
static int SignWithCertStoreKey(WOLFSSH* ssh,
        const WOLFSSH_PVT_KEY* pvtKey,
        const byte* data, word32 dataSz,
        enum wc_HashType hashId,
        byte* sig, word32* sigSz);
```

This function:

1. Calls `CryptAcquireCertificatePrivateKey()` with `CRYPT_ACQUIRE_ONLY_NCRYPT_KEY_FLAG` to obtain an NCrypt key handle.
2. For **RSA** keys — calls `NCryptSignHash()` with `BCRYPT_PAD_PKCS1` and the appropriate hash algorithm identifier (`BCRYPT_SHA256_ALGORITHM`, etc.). The input is a pre-encoded PKCS#1 DigestInfo.
3. For **ECDSA** keys — calls `NCryptSignHash()` with no padding. The output is raw `r || s` (each component is half the total signature length). The caller is responsible for converting to the SSH wire format.
4. Falls back to legacy CAPI (`CryptSignHash`) if the key is not CNG-based, reversing the little-endian output to big-endian.

`SignWithCertStoreKey` is called from three places:

- `SignHRsa()` — server-side KEX signature (RSA)
- `SignHEcdsa()` — server-side KEX signature (ECDSA)
- `SendUserAuthRequestRsaCert()` / `BuildUserAuthRequestEccCert()` — client-side user-auth signature

### Public Key Extraction — `ExtractPubKeyDerFromCert()`

Since the private key never leaves the certificate store, the public key needed for key-exchange hash computation is extracted from the DER certificate using wolfCrypt's `wc_GetPubKeyDerFromCert()`:

```c
static int ExtractPubKeyDerFromCert(const byte* certDer, word32 certDerSz,
        byte** outDer, word32* outDerSz, void* heap);
```

This is used in `SendKexGetSigningKey()` to populate the RSA/ECC key structures with public-key-only data so the existing key-exchange hash logic works unchanged.

## Public API

### `wolfSSH_CTX_UsePrivateKey_fromStore()`

```c
int wolfSSH_CTX_UsePrivateKey_fromStore(WOLFSSH_CTX* ctx,
        const wchar_t* storeName, DWORD dwFlags,
        const wchar_t* subjectName);
```

Loads a host/client private key from the Windows certificate store. Declared in `wolfssh/ssh.h` (under `USE_WINDOWS_API` and `WOLFSSH_CERTS` guards).

**Parameters:**

| Parameter     | Description |
|---------------|-------------|
| `ctx`         | wolfSSH context (server or client). |
| `storeName`   | Certificate store name as a wide string (e.g., `L"My"`, `L"Root"`). |
| `dwFlags`     | Store location flags: `CERT_SYSTEM_STORE_CURRENT_USER` (0x00010000) or `CERT_SYSTEM_STORE_LOCAL_MACHINE` (0x00020000). |
| `subjectName` | Subject CN (or substring) to search for, as a wide string. A `CN=` prefix is automatically stripped if the initial search fails. |

**Behavior:**

1. Opens the specified certificate store with `CertOpenStore(CERT_STORE_PROV_SYSTEM_W, ...)`.
2. Finds the certificate using `CertFindCertificateInStore(... CERT_FIND_SUBJECT_STR_W ...)`.
3. Determines the key type (RSA or ECDSA P-256/P-384/P-521) from the certificate's public key algorithm OID and, for ECC, the curve parameters.
4. Copies the DER certificate into the `WOLFSSH_PVT_KEY` slot and retains the `PCCERT_CONTEXT`.
5. Verifies that the private key is accessible by calling `CryptAcquireCertificatePrivateKey()` — this catches permission errors early (e.g., running as LocalSystem without key access).
6. Calls `RefreshPublicKeyAlgo()` so the new key type is advertised during key exchange.

Returns `WS_SUCCESS` on success. Possible errors: `WS_BAD_ARGUMENT`, `WS_FATAL_ERROR` (store open/find failed), `WS_MEMORY_E`, `WS_CRYPTO_FAILED` (private key inaccessible).

### `wolfSSH_SetCertManager()`

```c
int wolfSSH_SetCertManager(WOLFSSH_CTX* ctx, WOLFSSL_CERT_MANAGER* cm);
```

Replaces the wolfSSH context's internal certificate manager with an externally-configured one. Declared in `wolfssh/certman.h`. Used by `wolfsshd` to inject a `WOLFSSL_CERT_MANAGER` that has already loaded system and/or user CA certificates via `wolfSSL_CTX_load_system_CA_certs()` or `wolfSSL_CTX_load_windows_user_CA_certs()`.

The function increments the reference count on `cm` via `wolfSSL_CertManager_up_ref()`, so the caller retains ownership and can free the source SSL context independently.

### `wolfSSH_ParseCertStoreSpec()`

```c
int wolfSSH_ParseCertStoreSpec(const char* spec,
        wchar_t** wStoreName, wchar_t** wSubjectName,
        DWORD* dwFlags, void* heap);
```

Parses a colon-delimited spec string `"store:subject:flags"` into wide-string components suitable for `wolfSSH_CTX_UsePrivateKey_fromStore()`. Declared in `wolfssh/certman.h` (under `USE_WINDOWS_API`). Used by the echoserver and SFTP client to accept a `-W` command-line argument.

**Spec format:** `StoreName:SubjectName:Flags`

- `StoreName` — e.g., `My`, `Root`, `Trust`
- `SubjectName` — e.g., `CN=MyServer`, `MyServer`
- `Flags` — `CURRENT_USER`, `LOCAL_MACHINE`, or a numeric DWORD value

**Example specs:**

- `"My:CN=WolfSSHServer:CURRENT_USER"` — personal store, current user, RSA or ECC cert with CN containing "WolfSSHServer"
- `"My:alice:LOCAL_MACHINE"` — machine store, cert with subject containing "alice"
- `"Root:MyCorp CA:CURRENT_USER"` — root store, cert with subject containing "MyCorp CA"

## wolfsshd Configuration

### New `sshd_config` Options

All wolfSSH-specific options use a `wolfSSH_` prefix to avoid conflicts with OpenSSH configuration parsers.

#### Host Key from Certificate Store

| Option                  | Description | Example |
|-------------------------|-------------|---------|
| `HostKeyStore`          | Certificate store name for the host key. | `My` |
| `HostKeyStoreSubject`   | Subject CN to find the host certificate. | `CN=SSHServer` |
| `HostKeyStoreFlags`     | Store location: `CURRENT_USER` or `LOCAL_MACHINE`. | `CURRENT_USER` |

When `HostKeyStore` and `HostKeyStoreSubject` are both set, `wolfsshd` loads the host key from the Windows certificate store instead of from the `HostKey` file path. If they are not set, the traditional `HostKey` file path is used as a fallback.

#### System CA Certificates

| Option                              | Description                                              | Values       |
|-------------------------------------|----------------------------------------------------------|--------------|
| `wolfSSH_TrustedSystemCAKeys`       | Load CA certificates from the operating system's default trust store. | `yes` / `no` |

When set to `yes`, `wolfsshd` calls `wolfSSL_CTX_load_system_CA_certs()` to populate the certificate manager with the OS-trusted root CAs. Requires wolfSSL built with `WOLFSSL_SYS_CA_CERTS`.

#### User CA Store (Windows)

| Option                                  | Description                                     | Values/Default                            |
|-----------------------------------------|-------------------------------------------------|-------------------------------------------|
| `wolfSSH_TrustedUserCaStore`            | Load user CA certificates from a Windows certificate store. | `yes` / `no`                  |
| `wolfSSH_WinUserStores`                 | Certificate store provider type.                | Default: `CERT_STORE_PROV_SYSTEM`         |
| `wolfSSH_WinUserDwFlags`                | Store location flags.                           | Default: `CERT_SYSTEM_STORE_CURRENT_USER` |
| `wolfSSH_WinUserPvPara`                 | Store name parameter (the "pvPara" argument to `CertOpenStore`). | Default: `MY`            |

When `wolfSSH_TrustedUserCaStore` is `yes`, `wolfsshd` calls `wolfSSL_CTX_load_windows_user_CA_certs()` with the configured store parameters. The loaded CAs are then injected into the wolfSSH certificate manager via `wolfSSH_SetCertManager()`.

### Example `sshd_config`

```
# Use certificate store for host key
HostKeyStore My
HostKeyStoreSubject CN=WolfSSHD-Host
HostKeyStoreFlags CURRENT_USER

# Trust system CAs for client certificate verification
wolfSSH_TrustedSystemCAKeys yes

# Also trust certs from a custom user store
wolfSSH_TrustedUserCaStore yes
wolfSSH_WinUserStores CERT_STORE_PROV_SYSTEM
wolfSSH_WinUserDwFlags CERT_SYSTEM_STORE_CURRENT_USER
wolfSSH_WinUserPvPara MY
```

## Example / Tool Usage

### Echoserver (`-W` flag)

The echoserver accepts a `-W` flag (or the `WOLFSSH_CERT_STORE` environment variable) to load the host key from the certificate store:

```
echoserver.exe -W "My:CN=WolfSSHServer:CURRENT_USER"
```

This is equivalent to:

```
set WOLFSSH_CERT_STORE=My:CN=WolfSSHServer:CURRENT_USER
echoserver.exe
```

When `-W` is used, the echoserver skips loading file-based host keys and skips the `ChangeToWolfSshRoot()` directory search.

### SFTP Client (`-W` flag)

The SFTP client accepts a `-W` flag for client certificate authentication:

```
wolfsftp.exe -u testuser -h 127.0.0.1 -p 22222 -W "My:CN=TestUser:CURRENT_USER"
```

This loads the client's private key and certificate from the specified store. The certificate is presented as an `x509v3-ssh-rsa` or `x509v3-ecdsa-sha2-*` public key type during authentication. No `-i` (private key file) or `-J` (certificate file) flags are needed.

### Client Common Helpers

The client common library (`examples/client/common.c`) provides two helper functions for applications:

```c
int ClientSetPrivateKeyFromStore(WOLFSSH_CTX* ctx,
        const wchar_t* storeName, DWORD dwFlags, const wchar_t* subjectName);

int ClientSetupCertStoreAuth(WOLFSSH_CTX* ctx);
```

`ClientSetPrivateKeyFromStore` calls `wolfSSH_CTX_UsePrivateKey_fromStore()`, and `ClientSetupCertStoreAuth` wires up the global auth-callback variables (`userPublicKey`, `userPublicKeyType`, etc.) so that `ClientUserAuth` presents the certificate for public-key authentication.

## Use Case Examples

### Server Loading a Host Key from the Certificate Store

```c
#include <wolfssh/ssh.h>
#include <windows.h>
#include <wincrypt.h>

WOLFSSH_CTX* ctx;
int ret;

wolfSSH_Init();
ctx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_SERVER, NULL);

/* Load the host key from "My" store for the current user.
 * The certificate with subject containing "SSHHostKey" must already
 * be imported into the store with its private key. */
ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx,
        L"My",                             /* store name */
        CERT_SYSTEM_STORE_CURRENT_USER,    /* current user's personal store */
        L"SSHHostKey");                    /* subject CN substring */
if (ret != WS_SUCCESS) {
    printf("Failed to load host key from cert store: %d\n", ret);
}

/* Proceed with normal server setup: set callbacks, accept connections... */
```

### Server Loading a Host Key from the Local Machine Store

```c
/* For a Windows service running as LocalSystem, the host certificate
 * is typically in the Local Machine store. The service account must
 * have permission to access the private key. */
ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx,
        L"My",                              /* store name */
        CERT_SYSTEM_STORE_LOCAL_MACHINE,    /* machine-wide store */
        L"CN=wolfsshd.example.com");        /* CN= prefix is auto-stripped */
```

### Client Loading a Key for Certificate Authentication

```c
WOLFSSH_CTX* ctx;

ctx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_CLIENT, NULL);

/* Load the client identity from the current user's personal store */
ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx,
        L"My",
        CERT_SYSTEM_STORE_CURRENT_USER,
        L"alice");  /* matches cert with subject containing "alice" */
if (ret != WS_SUCCESS) {
    fprintf(stderr, "Cert store key load failed: %d\n", ret);
    return ret;
}

/* The CTX now holds the certificate DER and a reference to the
 * private key in the Windows cert store. During SSH handshake,
 * signing operations use NCryptSignHash transparently. */
```

### Loading System and User CAs into wolfSSH

```c
#include <wolfssh/ssh.h>
#include <wolfssh/certman.h>
#include <wolfssl/ssl.h>

WOLFSSH_CTX* sshCtx;
WOLFSSL_CTX* sslCtx;
int ret;

sshCtx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_SERVER, NULL);

/* Create a temporary wolfSSL context to load CA certificates */
sslCtx = wolfSSL_CTX_new(wolfSSLv23_server_method());

/* Load the OS-trusted root CAs (requires WOLFSSL_SYS_CA_CERTS) */
if (wolfSSL_CTX_load_system_CA_certs(sslCtx) != WOLFSSL_SUCCESS) {
    fprintf(stderr, "Failed to load system CAs\n");
}

/* On Windows, also load from a user certificate store */
if (wolfSSL_CTX_load_windows_user_CA_certs(sslCtx,
        "CERT_STORE_PROV_SYSTEM",           /* store provider */
        "CERT_SYSTEM_STORE_CURRENT_USER",   /* dwFlags */
        "MY"                                /* pvPara (store name) */
        ) != WOLFSSL_SUCCESS) {
    fprintf(stderr, "Failed to load user CAs\n");
}

/* Transfer the loaded CAs into wolfSSH's certificate manager */
ret = wolfSSH_SetCertManager(sshCtx,
        wolfSSL_CTX_GetCertManager(sslCtx));
if (ret != WS_SUCCESS) {
    fprintf(stderr, "Failed to set cert manager: %d\n", ret);
}

/* The temporary SSL context can be freed; the cert manager
 * is kept alive by the wolfSSH CTX's reference. */
wolfSSL_CTX_free(sslCtx);
```

### Parsing a Spec String and Loading a Key

```c
#include <wolfssh/ssh.h>
#include <wolfssh/certman.h>

const char* spec = "My:CN=MySSHServer:CURRENT_USER";
wchar_t* wStoreName = NULL;
wchar_t* wSubjectName = NULL;
DWORD dwFlags = 0;
int ret;

/* Parse the colon-separated spec into wide-string components */
ret = wolfSSH_ParseCertStoreSpec(spec, &wStoreName, &wSubjectName,
        &dwFlags, NULL);
if (ret != WS_SUCCESS) {
    fprintf(stderr, "Invalid cert store spec\n");
    return ret;
}

/* Use the parsed components to load the key */
ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx, wStoreName, dwFlags,
        wSubjectName);

/* Caller must free the allocated wide strings */
WFREE(wStoreName, NULL, DYNTYPE_TEMP);
WFREE(wSubjectName, NULL, DYNTYPE_TEMP);

if (ret != WS_SUCCESS) {
    fprintf(stderr, "Failed to load key from store: %d\n", ret);
}
```

### End-to-End Server and Client with Certificate Store Keys

**Prerequisites — importing certificates into the Windows store:**

```powershell
# Import a PFX (PKCS#12) containing the server certificate + private key
# into the current user's "My" (Personal) store:
$pfx = Get-PfxData -FilePath .\server-cert.pfx `
    -Password (ConvertTo-SecureString "password" -AsPlainText -Force)
Import-PfxCertificate -FilePath .\server-cert.pfx `
    -CertStoreLocation Cert:\CurrentUser\My `
    -Password (ConvertTo-SecureString "password" -AsPlainText -Force)

# Import the client certificate + private key:
Import-PfxCertificate -FilePath .\client-cert.pfx `
    -CertStoreLocation Cert:\CurrentUser\My `
    -Password (ConvertTo-SecureString "password" -AsPlainText -Force)

# Import the CA certificate into the trusted root store:
Import-Certificate -FilePath .\ca-cert.der `
    -CertStoreLocation Cert:\CurrentUser\Root

# Verify the imports:
Get-ChildItem Cert:\CurrentUser\My | Where-Object { $_.Subject -match "SSHServer" }
Get-ChildItem Cert:\CurrentUser\My | Where-Object { $_.Subject -match "TestClient" }
```

**Server code:**

```c
#include <wolfssh/ssh.h>

int main(void)
{
    WOLFSSH_CTX* ctx;
    WOLFSSH* ssh;
    int ret;

    wolfSSH_Init();
    ctx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_SERVER, NULL);

    /* Load the host key from the certificate store */
    ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx,
            L"My", CERT_SYSTEM_STORE_CURRENT_USER, L"SSHServer");
    if (ret != WS_SUCCESS) {
        fprintf(stderr, "Host key load failed: %d\n", ret);
        return 1;
    }

    /* Set your user-auth callback, then accept connections as usual */
    wolfSSH_SetUserAuth(ctx, myUserAuthCallback);
    ssh = wolfSSH_new(ctx);

    /* ... bind, listen, accept, wolfSSH_accept(ssh), etc. ... */

    wolfSSH_free(ssh);
    wolfSSH_CTX_free(ctx);
    wolfSSH_Cleanup();
    return 0;
}
```

**Client code:**

```c
#include <wolfssh/ssh.h>
#include <wolfssh/certman.h>

int main(void)
{
    WOLFSSH_CTX* ctx;
    WOLFSSH* ssh;
    int ret;

    wolfSSH_Init();
    ctx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_CLIENT, NULL);

    /* Load client identity from the cert store */
    ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx,
            L"My", CERT_SYSTEM_STORE_CURRENT_USER, L"TestClient");
    if (ret != WS_SUCCESS) {
        fprintf(stderr, "Client key load failed: %d\n", ret);
        return 1;
    }

    wolfSSH_SetUserAuth(ctx, myClientAuthCallback);
    ssh = wolfSSH_new(ctx);
    wolfSSH_SetUserAuthCtx(ssh, myAuthContext);

    /* ... connect, wolfSSH_connect(ssh), etc. ... */

    wolfSSH_free(ssh);
    wolfSSH_CTX_free(ctx);
    wolfSSH_Cleanup();
    return 0;
}
```

### SFTP Session Using Certificate Store (Command Line)

```bat
REM Start the echoserver with a cert-store host key
echoserver.exe -W "My:CN=SSHServer:CURRENT_USER" -p 22222

REM In another terminal, connect with the SFTP client using a cert-store client key
wolfsftp.exe -h 127.0.0.1 -p 22222 -u testuser -W "My:CN=TestClient:CURRENT_USER"
```

Inside the SFTP session:

```
wolfSSH sftp> ls
.
..
Documents
Desktop
wolfSSH sftp> pwd
/home/testuser
wolfSSH sftp> put localfile.txt remotefile.txt
wolfSSH sftp> quit
```

### wolfsshd with Certificate Store Host Key and System CA Trust

This demonstrates the daemon configuration for a production-like deployment where the host key is in the Local Machine store and client certificates are verified against the OS trust store.

**`sshd_config`:**

```
Port 22
ListenAddress 0.0.0.0

# Host key from the Local Machine certificate store
HostKeyStore My
HostKeyStoreSubject CN=sshd.example.com
HostKeyStoreFlags LOCAL_MACHINE

# Accept client X.509 certificates signed by any OS-trusted CA
wolfSSH_TrustedSystemCAKeys yes

# Also accept client certs signed by CAs in the current user's personal store
wolfSSH_TrustedUserCaStore yes
wolfSSH_WinUserStores CERT_STORE_PROV_SYSTEM
wolfSSH_WinUserDwFlags CERT_SYSTEM_STORE_CURRENT_USER
wolfSSH_WinUserPvPara MY

# Standard options
PasswordAuthentication yes
PermitRootLogin no
```

**Starting the daemon:**

```bat
wolfsshd.exe -f sshd_config -D
```

The `-D` flag runs in foreground (debug) mode with logs to stderr. In production, omit `-D` to run as a Windows service.

### Mixed Mode — File Keys for Server, Certificate Store for Client

The server uses traditional file-based host keys while clients authenticate with certificates from the Windows store. This is useful when migrating to certificate-based auth incrementally.

**Server `sshd_config`:**

```
Port 22222
HostKey /etc/wolfssh/server-key-rsa.pem

# Trust the enterprise CA from the system store for client cert verification
wolfSSH_TrustedSystemCAKeys yes

# Also trust certs from a dedicated CA store
TrustedUserCAKeys /etc/wolfssh/ca-cert.pem
```

**Client connecting with cert store key:**

```bat
wolfsftp.exe -h server.example.com -p 22222 -u alice -W "My:alice:CURRENT_USER"
```

### Custom Application Using the Parse and Load Pattern

For applications that accept a cert store specifier as a single string (e.g., from a config file or environment variable), the parse-then-load pattern avoids manual wide-string construction:

```c
#include <wolfssh/ssh.h>
#include <wolfssh/certman.h>

int loadKeyFromSpec(WOLFSSH_CTX* ctx, const char* spec)
{
    wchar_t* wStoreName = NULL;
    wchar_t* wSubjectName = NULL;
    DWORD dwFlags = 0;
    int ret;

    ret = wolfSSH_ParseCertStoreSpec(spec, &wStoreName, &wSubjectName,
            &dwFlags, NULL);
    if (ret != WS_SUCCESS) {
        fprintf(stderr, "Bad spec string: '%s'\n", spec);
        return ret;
    }

    ret = wolfSSH_CTX_UsePrivateKey_fromStore(ctx, wStoreName, dwFlags,
            wSubjectName);

    WFREE(wStoreName, NULL, DYNTYPE_TEMP);
    WFREE(wSubjectName, NULL, DYNTYPE_TEMP);

    return ret;
}

int main(void)
{
    WOLFSSH_CTX* ctx;
    const char* envSpec;

    wolfSSH_Init();
    ctx = wolfSSH_CTX_new(WOLFSSH_ENDPOINT_SERVER, NULL);

    envSpec = getenv("WOLFSSH_CERT_STORE");
    if (envSpec != NULL) {
        if (loadKeyFromSpec(ctx, envSpec) != WS_SUCCESS) {
            fprintf(stderr, "Failed to load key from cert store\n");
            return 1;
        }
    } else {
        /* Fall back to file-based key loading */
        /* wolfSSH_CTX_UsePrivateKey_buffer(ctx, ...); */
    }

    /* ... rest of server setup ... */

    wolfSSH_CTX_free(ctx);
    wolfSSH_Cleanup();
    return 0;
}
```

### Loading System CAs Programmatically (Without sshd_config)

For applications that are not using `wolfsshd` but still want to verify client certificates against the Windows system trust store:

```c
#include <wolfssh/ssh.h>
#include <wolfssh/certman.h>
#include <wolfssl/ssl.h>

int setupSystemCAVerification(WOLFSSH_CTX* sshCtx)
{
    WOLFSSL_CTX* sslCtx;
    int ret = WS_SUCCESS;

    sslCtx = wolfSSL_CTX_new(wolfSSLv23_server_method());
    if (sslCtx == NULL)
        return WS_FATAL_ERROR;

    /* Load all CAs from the OS trust store (Windows, macOS, or Linux) */
    if (wolfSSL_CTX_load_system_CA_certs(sslCtx) != WOLFSSL_SUCCESS) {
        wolfSSL_CTX_free(sslCtx);
        return WS_FATAL_ERROR;
    }

    /* Transfer the cert manager (with its loaded CAs) into wolfSSH */
    ret = wolfSSH_SetCertManager(sshCtx,
            wolfSSL_CTX_GetCertManager(sslCtx));

    wolfSSL_CTX_free(sslCtx);
    return ret;
}
```
