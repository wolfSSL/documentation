# wolfSSH Additional API Reference

This chapter documents the remaining public wolfSSH interfaces: ssh-agent
forwarding, key generation, logging, the certificate manager, and the
platform portability layer.

##  SSH Agent Functions

These functions support ssh-agent forwarding. They require wolfSSH to be built
with agent support (`WOLFSSH_AGENT`, from `./configure --enable-agent`).

### wolfSSH_AGENT_new()

```c
#include <wolfssh/agent.h>

WOLFSSH_AGENT_CTX* wolfSSH_AGENT_new(void* heap);
```

**Description**

Allocates and initializes a new ssh-agent context.

**Parameters**

- `heap` - pointer to a heap to use for memory allocations, or `NULL`

**Return Values**

- pointer to the new agent context, or `NULL` on failure

**See Also**

- `wolfSSH_AGENT_free()`

### wolfSSH_AGENT_free()

```c
#include <wolfssh/agent.h>

void wolfSSH_AGENT_free(WOLFSSH_AGENT_CTX* agent);
```

**Description**

Frees an ssh-agent context previously allocated with wolfSSH_AGENT_new().

**Parameters**

- `agent` - the agent context to free

**Return Values**

None

**See Also**

- `wolfSSH_AGENT_new()`

### wolfSSH_CTX_set_agent_cb()

```c
#include <wolfssh/agent.h>

int wolfSSH_CTX_set_agent_cb(WOLFSSH_CTX* ctx,
        WS_CallbackAgent agentCb, WS_CallbackAgentIO agentIoCb);
```

**Description**

Registers the agent callback and the agent I/O callback on the context. These
callbacks let the application service agent requests and perform agent I/O.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `agentCb` - the agent callback
- `agentIoCb` - the agent I/O callback

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_set_agent_cb_ctx()`

### wolfSSH_set_agent_cb_ctx()

```c
#include <wolfssh/agent.h>

int wolfSSH_set_agent_cb_ctx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the agent callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the agent callbacks

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_CTX_AGENT_enable()

```c
#include <wolfssh/agent.h>

int wolfSSH_CTX_AGENT_enable(WOLFSSH_CTX* ctx, byte isEnabled);
```

**Description**

Enables or disables ssh-agent forwarding for sessions created from the context.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `isEnabled` - non-zero to enable agent forwarding, 0 to disable

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_AGENT_enable()`

### wolfSSH_AGENT_enable()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_enable(WOLFSSH* ssh, byte isEnabled);
```

**Description**

Enables or disables ssh-agent forwarding for a single session.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `isEnabled` - non-zero to enable agent forwarding, 0 to disable

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_CTX_AGENT_enable()`

### wolfSSH_AGENT_Relay()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_Relay(WOLFSSH* ssh,
        const byte* msg, word32* msgSz, byte* rsp, word32* rspSz);
```

**Description**

Relays an agent protocol message to the agent and returns the agent's response.
On input `rspSz` holds the size of the `rsp` buffer; on output it holds the size
of the response written.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `msg` - the agent message to relay
- `msgSz` - pointer to the size of the message
- `rsp` - buffer that receives the agent's response
- `rspSz` - on input the response buffer size, set on output to the response size

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

### wolfSSH_AGENT_SignRequest()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_SignRequest(WOLFSSH* ssh,
        const byte* digest, word32 digestSz,
        byte* sig, word32* sigSz,
        const byte* keyBlob, word32 keyBlobSz, word32 flags);
```

**Description**

Requests that the agent sign the given `digest` using the key identified by
`keyBlob`. The resulting signature is written to `sig`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `digest` - the digest to sign
- `digestSz` - size of the digest
- `sig` - buffer that receives the signature
- `sigSz` - on input the signature buffer size, set on output to the signature size
- `keyBlob` - the public key blob identifying which key to sign with
- `keyBlobSz` - size of the key blob
- `flags` - signature request flags

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

##  Key Generation Functions

These functions generate SSH key pairs. They require wolfSSH to be built with
key generation support (`WOLFSSH_KEYGEN`, from `./configure --enable-keygen`),
and the corresponding algorithm must be enabled in wolfCrypt.

### wolfSSH_MakeRsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeRsaKey(byte* out, word32 outSz, word32 size, word32 e);
```

**Description**

Generates an RSA key pair of `size` bits using public exponent `e`, writing the
encoded key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - RSA key size in bits (for example, 2048)
- `e` - RSA public exponent (for example, 65537)

**Return Values**

- the number of bytes written on success
- a negative error code on failure

**See Also**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeEcdsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEcdsaKey(byte* out, word32 outSz, word32 size);
```

**Description**

Generates an ECDSA key pair for the curve of the given `size` in bits (for
example, 256 for NIST P-256), writing the encoded key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - ECC curve size in bits (for example, 256, 384, or 521)

**Return Values**

- the number of bytes written on success
- a negative error code on failure

**See Also**

- `wolfSSH_MakeRsaKey()`
- `wolfSSH_MakeEd25519Key()`

### wolfSSH_MakeEd25519Key()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEd25519Key(byte* out, word32 outSz, word32 size);
```

**Description**

Generates an Ed25519 key pair, writing the encoded key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - key size in bits (256 for Ed25519)

**Return Values**

- the number of bytes written on success
- a negative error code on failure

**See Also**

- `wolfSSH_MakeEcdsaKey()`

##  Logging Functions

These functions control wolfSSH debug logging. The logging code is compiled in
when wolfSSH is built with `DEBUG_WOLFSSH` (from `./configure --enable-debug`)
or with `WOLFSSH_SSHD`.

### wolfSSH_SetLoggingCb()

```c
#include <wolfssh/log.h>

void wolfSSH_SetLoggingCb(wolfSSH_LoggingCb logF);
```

**Description**

Registers a callback that receives log messages, each with its log level and
message text, instead of the default logging output.

**Parameters**

- `logF` - the logging callback

**Return Values**

None

**See Also**

- `wolfSSH_LogEnabled()`

### wolfSSH_LogEnabled()

```c
#include <wolfssh/log.h>

int wolfSSH_LogEnabled(void);
```

**Description**

Reports whether logging is currently enabled.

**Parameters**

None

**Return Values**

- non-zero if logging is enabled
- 0 if logging is disabled

### wolfSSH_Log()

```c
#include <wolfssh/log.h>

void wolfSSH_Log(enum wolfSSH_LogLevel level, const char* const fmt, ...);
```

**Description**

Writes a printf-style formatted log message at the given level. The log levels,
from lowest to highest, are `WS_LOG_DEBUG`, `WS_LOG_INFO`, `WS_LOG_WARN`,
`WS_LOG_ERROR`, and `WS_LOG_USER`, plus the per-subsystem levels `WS_LOG_SFTP`,
`WS_LOG_SCP`, `WS_LOG_AGENT`, and `WS_LOG_CERTMAN`.

**Parameters**

- `level` - the `wolfSSH_LogLevel` for the message
- `fmt` - printf-style format string
- `...` - arguments for the format string

**Return Values**

None

**See Also**

- `wolfSSH_SetLoggingCb()`

##  Certificate Manager Functions

The certificate manager verifies X.509 certificates for certificate-based
authentication. These functions require wolfSSH to be built with certificate
support (`WOLFSSH_CERTS`, from `./configure --enable-certs`).

### wolfSSH_CERTMAN_new()

```c
#include <wolfssh/certman.h>

WOLFSSH_CERTMAN* wolfSSH_CERTMAN_new(void* heap);
```

**Description**

Allocates and initializes a new certificate manager.

**Parameters**

- `heap` - pointer to a heap to use for memory allocations, or `NULL`

**Return Values**

- pointer to the new certificate manager, or `NULL` on failure

**See Also**

- `wolfSSH_CERTMAN_free()`

### wolfSSH_CERTMAN_free()

```c
#include <wolfssh/certman.h>

void wolfSSH_CERTMAN_free(WOLFSSH_CERTMAN* cm);
```

**Description**

Frees a certificate manager previously allocated with wolfSSH_CERTMAN_new().

**Parameters**

- `cm` - the certificate manager to free

**Return Values**

None

**See Also**

- `wolfSSH_CERTMAN_new()`

### wolfSSH_CERTMAN_LoadRootCA_buffer()

```c
#include <wolfssh/certman.h>

int wolfSSH_CERTMAN_LoadRootCA_buffer(WOLFSSH_CERTMAN* cm,
        const unsigned char* rootCa, word32 rootCaSz);
```

**Description**

Loads a trusted root CA certificate from a buffer into the certificate manager.
Loaded roots are used to verify certificates presented by a peer.

**Parameters**

- `cm` - the certificate manager
- `rootCa` - buffer containing the root CA certificate
- `rootCaSz` - size of the root CA buffer

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_CERTMAN_VerifyCerts_buffer()`

### wolfSSH_CERTMAN_VerifyCerts_buffer()

```c
#include <wolfssh/certman.h>

int wolfSSH_CERTMAN_VerifyCerts_buffer(WOLFSSH_CERTMAN* cm,
        const unsigned char* cert, word32 certSz, word32 certCount);
```

**Description**

Verifies a chain of `certCount` certificates contained in the buffer against the
root CAs loaded into the certificate manager.

**Parameters**

- `cm` - the certificate manager
- `cert` - buffer containing the certificate chain
- `certSz` - size of the certificate buffer
- `certCount` - number of certificates in the chain

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_CERTMAN_LoadRootCA_buffer()`

##  Portability Functions

These functions form part of the wolfSSH platform portability layer, which
abstracts filesystem and string operations across supported targets. They are
primarily used internally and when porting wolfSSH to a new platform; the exact
set available depends on the target build configuration.

### wfopen()

```c
#include <wolfssh/port.h>

int wfopen(WFILE** f, const char* filename, const char* mode);
```

**Description**

Portable file-open wrapper. Opens `filename` using the access `mode` and stores
the resulting file handle in `f`.

**Parameters**

- `f` - receives the opened file handle
- `filename` - path of the file to open
- `mode` - access mode string (as for the C library `fopen`)

**Return Values**

- 0 on success
- non-zero on failure

### wstrnstr()

```c
#include <wolfssh/port.h>

char* wstrnstr(const char* s1, const char* s2, unsigned int n);
```

**Description**

Finds the first occurrence of the substring `s2` within the first `n` bytes of
`s1`.

**Parameters**

- `s1` - the string to search
- `s2` - the substring to find
- `n` - maximum number of bytes of `s1` to search

**Return Values**

- pointer to the first occurrence of `s2` in `s1`, or `NULL` if not found

### wstrncat()

```c
#include <wolfssh/port.h>

char* wstrncat(char* s1, const char* s2, size_t n);
```

**Description**

Appends up to `n` bytes of the string `s2` to the end of `s1`.

**Parameters**

- `s1` - destination string, appended to in place
- `s2` - source string to append
- `n` - maximum number of bytes to append

**Return Values**

- pointer to the destination string `s1`

### wstrdup()

```c
#include <wolfssh/port.h>

char* wstrdup(const char* s1, void* heap, int type);
```

**Description**

Duplicates the string `s1`, allocating the copy from the given `heap`.

**Parameters**

- `s1` - the string to duplicate
- `heap` - heap used for the allocation
- `type` - allocation type hint

**Return Values**

- pointer to the duplicated string, or `NULL` on failure

### WS_FindFirstFileA()

**Availability**

Available on Windows builds (`USE_WINDOWS_API`).

```c
#include <wolfssh/port.h>

void* WS_FindFirstFileA(const char* fileName,
        char* realFileName, size_t realFileNameSz, int* isDir, void* heap);
```

**Description**

Begins a directory enumeration for `fileName`, returning a find handle and the
first matching entry. `isDir` is set to indicate whether the entry is a
directory.

**Parameters**

- `fileName` - the directory or search pattern to enumerate
- `realFileName` - buffer that receives the matched file name
- `realFileNameSz` - size of the `realFileName` buffer
- `isDir` - output set non-zero if the entry is a directory
- `heap` - heap used for allocations

**Return Values**

- an opaque find handle on success, or `NULL` on failure

**See Also**

- `WS_FindNextFileA()`

### WS_FindNextFileA()

**Availability**

Available on Windows builds (`USE_WINDOWS_API`).

```c
#include <wolfssh/port.h>

int WS_FindNextFileA(void* findHandle,
        char* realFileName, size_t realFileNameSz);
```

**Description**

Continues a directory enumeration started with WS_FindFirstFileA(), returning the
next matching entry.

**Parameters**

- `findHandle` - the find handle returned by WS_FindFirstFileA()
- `realFileName` - buffer that receives the matched file name
- `realFileNameSz` - size of the `realFileName` buffer

**Return Values**

- non-zero if another entry was returned
- 0 when there are no more entries

**See Also**

- `WS_FindFirstFileA()`
