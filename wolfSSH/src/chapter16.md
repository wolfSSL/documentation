# wolfSSH Additional API Reference

This chapter documents the remaining public wolfSSH interfaces: ssh-agent
forwarding, key generation, logging, the certificate manager (including the
Windows certificate store helpers), and the platform portability layer.

##  SSH Agent Functions

These functions support ssh-agent forwarding. They require wolfSSH to be built
with agent support (`WOLFSSH_AGENT`, from `./configure --enable-agent`).

### wolfSSH_AGENT_new()

```c
#include <wolfssh/agent.h>

WOLFSSH_AGENT_CTX* wolfSSH_AGENT_new(void* heap);
```

**Description**

Allocates and initializes a new ssh-agent context, including its random number
generator.

**Parameters**

- `heap` - pointer to a heap to use for memory allocations, or `NULL`

**Return Values**

- pointer to the new agent context, or `NULL` if the allocation or the random
  number generator initialization fails

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
Each session copies the setting when it is created.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `isEnabled` - non-zero to enable agent forwarding, 0 to disable

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E` if `ctx` is `NULL`

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
- `WS_SSH_NULL_E` if `ssh` is `NULL`

**See Also**

- `wolfSSH_CTX_AGENT_enable()`

### wolfSSH_AGENT_ChannelOpen()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_ChannelOpen(WOLFSSH* ssh);
```

**Description**

Server side. Opens the "auth-agent@openssh.com" channel to the client after the
client's "auth-agent-req@openssh.com" channel request has asked for agent
forwarding. The server accepts that request only when an agent callback is set
with wolfSSH_CTX_set_agent_cb(). On the default path wolfSSH_accept() opens the
channel itself. An application that drives its own channels (see
wolfSSH_CTX_SetAppChannels()) polls this function instead.

The function opens at most one channel per session; once the channel has been
opened, later calls only flush any output still queued. On success it invokes the
agent callback with `WOLFSSH_AGENT_LOCAL_SETUP`. `WS_SUCCESS` means the open
request was sent, not that the peer accepted it; a refusal is reported to the
channel-open-fail callback. If an error is raised after the open is on the wire
(for example, by a failing high-water callback), the channel stays open and the
next call returns `WS_SUCCESS`.

Only the send path records its result in `ssh->error`. A call made before the
peer has asked for forwarding returns `WS_BAD_ARGUMENT` without recording an
error, so the session can still be passed to wolfSSH_accept().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS` when the channel open has been sent
- `WS_WANT_READ` or `WS_WANT_WRITE` while output is still queued; call again
- `WS_BAD_ARGUMENT` on a client session, or before the peer has asked for agent
  forwarding
- `WS_FATAL_ERROR` once the session has been disconnected (`ssh->error` holds
  `WS_DISCONNECT`)
- `WS_SSH_NULL_E` if `ssh` is `NULL`
- `WS_MEMORY_E` if the agent context or channel cannot be allocated
- another negative error code reported by the send

**See Also**

- `wolfSSH_AGENT_RelayChannel()`
- `wolfSSH_CTX_set_agent_cb()`

### wolfSSH_AGENT_Relay()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_Relay(WOLFSSH* ssh,
        const byte* msg, word32* msgSz, byte* rsp, word32* rspSz);
```

**Description**

Relays one agent protocol message to the local agent and returns the agent's
response. The message in `msg` is written to the agent through the agent I/O
callback exactly as given, so it must be a complete agent message, including its
4-byte length prefix. If nothing could be written, the function calls the agent
callback with `WOLFSSH_AGENT_LOCAL_SETUP` to reconnect and tries once more. The
function then reads one whole agent reply, including its 4-byte length prefix,
and copies it to `rsp`. On input `rspSz` holds the size of the `rsp` buffer; on
output it holds the size of the response written. A reply declaring a length of
0 or more than `WOLFSSH_AGENT_MAX_MSG_SZ` (262144 bytes by default) is rejected.

The session must have an agent context; on the client side, wolfSSH_connect()
creates one when agent forwarding is enabled. For an agent channel whose data arrives in
pieces, use wolfSSH_AGENT_RelayChannel() instead.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `msg` - the agent message to relay
- `msgSz` - pointer to the size of the message
- `rsp` - buffer that receives the agent's response
- `rspSz` - on input the response buffer size, set on output to the response size

**Return Values**

- `WS_SUCCESS`
- `WS_ERROR` on any failure. When `ssh` is not `NULL`, the specific error is
  stored in the session and can be retrieved with wolfSSH_get_error(). Possible
  errors include `WS_AGENT_NULL_E` (no agent context), `WS_BAD_ARGUMENT`,
  `WS_AGENT_CXN_FAIL` (agent I/O failed), and `WS_BUFFER_E` (the reply is out of
  range or does not fit in `rsp`).

**See Also**

- `wolfSSH_AGENT_RelayChannel()`

### wolfSSH_AGENT_RelayChannel()

```c
#include <wolfssh/agent.h>

int wolfSSH_AGENT_RelayChannel(WOLFSSH* ssh, word32 channelId);
```

**Description**

Moves whole agent messages between the forwarded agent channel `channelId` and
the local agent. Each call reads whatever channel data is already buffered,
frames it into complete agent messages, writes each message to the agent through
the agent I/O callback, and sends each reply back on the channel. A partial
request or an unfinished reply is held between calls, so the same `channelId`
must be passed again to finish either. If a different `channelId` is passed,
bytes held for the previous channel are discarded. If the agent context is still
in its initial state, the function first invokes the agent callback with
`WOLFSSH_AGENT_LOCAL_SETUP`.

A typical client calls this function when a read reports `WS_CHAN_RXD` for the
agent channel (the channel ID is available from wolfSSH_GetLastRxId()), and
calls it again whenever a reply is still owed.

While a reply is owed, the return value names what is holding it:
`WS_WANT_WRITE` means the transport, and `WS_WINDOW_FULL` or `WS_REKEYING` means
the peer. Call the function again until it returns `WS_SUCCESS`. Any other
non-success code leaves the channel unusable.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the local ID of the agent channel

**Return Values**

- `WS_SUCCESS` when all buffered requests have been relayed and their replies sent
- `WS_WANT_WRITE`, `WS_WINDOW_FULL`, or `WS_REKEYING` while a reply is still
  owed; call again
- `WS_SSH_NULL_E` if `ssh` is `NULL`
- `WS_AGENT_NULL_E` if the session has no agent context
- `WS_AGENT_CXN_FAIL` if the agent connection or agent I/O fails
- `WS_BUFFER_E` if a message declares a length of 0 or more than
  `WOLFSSH_AGENT_MAX_MSG_SZ`
- `WS_INVALID_CHANID` if no channel has the given ID
- another negative error code on failure

**See Also**

- `wolfSSH_AGENT_Relay()`
- `wolfSSH_AGENT_ChannelOpen()`

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
`keyBlob`. The resulting signature is written to `sig`. The function invokes the
agent callback with `WOLFSSH_AGENT_LOCAL_SETUP` before the request and with
`WOLFSSH_AGENT_LOCAL_CLEANUP` afterward, and uses the agent I/O callback to
exchange the request and the reply. On failure `*sigSz` is set to 0.

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
- `WS_SSH_NULL_E` if `ssh` is `NULL`
- `WS_AGENT_NULL_E` if the session has no agent context
- `WS_BAD_ARGUMENT` if `sigSz` is `NULL`
- `WS_MEMORY_E` if the reply buffer cannot be allocated
- `WS_AGENT_CXN_FAIL` if the request could not be written to the agent
- `WS_AGENT_NO_KEY_E` if the agent returns no reply, a reply that is not a
  signature, or a failure
- `WS_BUFFER_E` if the signature does not fit in `sig`
- another negative error code on failure

##  Key Generation Functions

These functions generate SSH key pairs. They require wolfSSH to be built with
key generation support (`WOLFSSH_KEYGEN`, from `./configure --enable-keygen`),
and wolfSSL must be built with key generation (`WOLFSSL_KEY_GEN`). The
corresponding algorithm must also be enabled; if it is not, the function returns
`WS_NOT_COMPILED`. A failure inside wolfCrypt is reported as `WS_CRYPTO_FAILED`.

The ML-DSA functions require wolfSSL 5.9.2 or later built with ML-DSA support.

### wolfSSH_MakeRsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeRsaKey(byte* out, word32 outSz, word32 size, word32 e);
```

**Description**

Generates an RSA key pair of `size` bits using public exponent `e`, writing the
DER-encoded private key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - RSA key size in bits (for example, 2048)
- `e` - RSA public exponent (for example, 65537)

**Return Values**

- the number of bytes written on success
- `WS_NOT_COMPILED` if RSA is disabled
- `WS_CRYPTO_FAILED` on a key generation or encoding failure

**See Also**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeEcdsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEcdsaKey(byte* out, word32 outSz, word32 size);
```

**Description**

Generates an ECDSA key pair for the curve of the given `size` in bits (for
example, 256 for NIST P-256), writing the DER-encoded private key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - ECC curve size in bits (for example, 256, 384, or 521)

**Return Values**

- the number of bytes written on success
- `WS_NOT_COMPILED` if ECDSA is disabled
- `WS_CRYPTO_FAILED` on a key generation or encoding failure

**See Also**

- `wolfSSH_MakeRsaKey()`
- `wolfSSH_MakeEd25519Key()`

### wolfSSH_MakeEd25519Key()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeEd25519Key(byte* out, word32 outSz, word32 size);
```

**Description**

Generates an Ed25519 key pair, writing the DER-encoded private key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `size` - key size in bits (256 for Ed25519)

**Return Values**

- the number of bytes written on success
- `WS_NOT_COMPILED` if Ed25519 key generation is not available
- `WS_CRYPTO_FAILED` on a key generation or encoding failure

**See Also**

- `wolfSSH_MakeEcdsaKey()`

### wolfSSH_MakeMlDsaKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeMlDsaKey(byte* out, word32 outSz, word32 level);
```

**Description**

Generates an ML-DSA (FIPS 204) key pair at the given security level, writing the
DER-encoded private key to `out`.

**Parameters**

- `out` - buffer that receives the generated key
- `outSz` - size of the output buffer
- `level` - ML-DSA parameter set: `WOLFSSH_MLDSAKEY_44`, `WOLFSSH_MLDSAKEY_65`,
  or `WOLFSSH_MLDSAKEY_87`

**Return Values**

- the number of bytes written on success
- `WS_BAD_ARGUMENT` if `level` is not one of the values above
- `WS_NOT_COMPILED` if ML-DSA is not available
- `WS_MEMORY_E` if a small-stack allocation fails
- `WS_CRYPTO_FAILED` on a key generation or encoding failure

**See Also**

- `wolfSSH_MakeMlDsaCompositeKey()`

### wolfSSH_MakeMlDsaCompositeKey()

```c
#include <wolfssh/keygen.h>

int wolfSSH_MakeMlDsaCompositeKey(byte* out, word32 outSz,
        word32 level, word32 tradType);
```

**Description**

Generates a composite key pair that pairs an ML-DSA key with a traditional
signature key. The result is written to `out` as a NUL-terminated, unencrypted
OpenSSH private key in PEM form ("-----BEGIN OPENSSH PRIVATE KEY-----"), with an
empty comment. The ML-DSA half is stored as its seed.

Only these combinations of `level` and `tradType` are accepted:

- `WOLFSSH_MLDSAKEY_44` with `WOLFSSH_COMPOSITE_TRAD_ED25519` or
  `WOLFSSH_COMPOSITE_TRAD_ECDSA` (NIST P-256)
- `WOLFSSH_MLDSAKEY_65` with `WOLFSSH_COMPOSITE_TRAD_ED25519` or
  `WOLFSSH_COMPOSITE_TRAD_ECDSA` (NIST P-256)
- `WOLFSSH_MLDSAKEY_87` with `WOLFSSH_COMPOSITE_TRAD_ED448` or
  `WOLFSSH_COMPOSITE_TRAD_ECDSA` (NIST P-384)

Pass `NULL` for `out` to query the required buffer size.

**Parameters**

- `out` - buffer that receives the PEM-encoded key, or `NULL` to query the size
- `outSz` - size of the output buffer
- `level` - ML-DSA parameter set: `WOLFSSH_MLDSAKEY_44`, `WOLFSSH_MLDSAKEY_65`,
  or `WOLFSSH_MLDSAKEY_87`
- `tradType` - traditional algorithm: `WOLFSSH_COMPOSITE_TRAD_ECDSA`,
  `WOLFSSH_COMPOSITE_TRAD_ED25519`, or `WOLFSSH_COMPOSITE_TRAD_ED448`

**Return Values**

- on success, the number of bytes written, including the terminating NUL
- when `out` is `NULL`, the required buffer size, including the terminating NUL
- `WS_BAD_ARGUMENT` if the `level` and `tradType` combination is not supported
- `WS_NOT_COMPILED` if ML-DSA or the requested composite algorithm is not
  compiled in
- `WS_BUFFER_E` if `outSz` is too small
- `WS_MEMORY_E` if an allocation fails
- `WS_CRYPTO_FAILED` on a key generation or encoding failure

**See Also**

- `wolfSSH_MakeMlDsaKey()`

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
message text, instead of the default logging output. Passing `NULL` leaves the
current callback in place. Builds with `WOLFSSH_NO_DEFAULT_LOGGING_CB` have no
default callback, so nothing is output until one is registered.

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

Reports whether logging is currently enabled. Logging is off by default and is
turned on with wolfSSH_Debugging_ON(). Builds without logging support always
return 0.

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

The formatted message is truncated to `WOLFSSH_DEFAULT_LOG_WIDTH` bytes (120 by
default, including the terminating NUL). Before the message is passed to the
logging callback, control characters other than tab, and DEL, are replaced with
`?`, so untrusted strings logged with `%s` cannot inject newlines or terminal
escape sequences into the log.

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

### wolfSSH_SetCertManager()

```c
#include <wolfssh/certman.h>

int wolfSSH_SetCertManager(WOLFSSH_CTX* ctx, struct WOLFSSL_CERT_MANAGER* cm);
```

**Description**

Replaces the wolfSSL certificate manager used by the context with `cm`. The
function takes a reference on `cm` and frees its reference to the previous
manager. The caller keeps its own reference and remains responsible for freeing
it.

wolfSSH modifies the shared manager. In builds with OCSP support (`HAVE_OCSP`)
it enables `WOLFSSL_OCSP_CHECKALL` on `cm`, so a caller that also uses the
manager for TLS finds that every chain requires an OCSP response. During
certificate authentication, wolfSSH permanently adds verified peer intermediate
CAs to the manager as trusted roots. Use a manager dedicated to wolfSSH rather
than one shared with a live TLS stack.

Passing the manager that is already in use applies the OCSP policy again and
changes nothing else. On `WS_FATAL_ERROR` nothing has changed: the context keeps
its previous manager and no policy has been applied to `cm`.

**Availability**

Requires wolfSSH built with certificate support (`WOLFSSH_CERTS`). Requires
wolfSSL 4.6.0 or later; with older versions the function returns
`WS_NOT_COMPILED` for any arguments.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cm` - the wolfSSL certificate manager to use

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if `ctx` or `cm` is `NULL`, or the context has no
  certificate manager
- `WS_FATAL_ERROR` if the reference cannot be taken or OCSP cannot be enabled
  on `cm`
- `WS_NOT_COMPILED` with wolfSSL older than 4.6.0

**See Also**

- `wolfSSH_CERTMAN_VerifyCerts_buffer()`

### wolfSSH_CERTMAN_new()

```c
#include <wolfssh/certman.h>

WOLFSSH_CERTMAN* wolfSSH_CERTMAN_new(void* heap);
```

**Description**

Allocates and initializes a new certificate manager, backed by a new wolfSSL
certificate manager. In builds with OCSP support (`HAVE_OCSP`), OCSP checking of
every certificate in a chain (`WOLFSSL_OCSP_CHECKALL`) is enabled on it.

**Parameters**

- `heap` - pointer to a heap to use for memory allocations, or `NULL`

**Return Values**

- pointer to the new certificate manager, or `NULL` on failure, including when
  OCSP cannot be enabled

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
Loaded roots are used to verify certificates presented by a peer. The
certificate must be DER-encoded.

**Parameters**

- `cm` - the certificate manager
- `rootCa` - buffer containing the DER-encoded root CA certificate
- `rootCaSz` - size of the root CA buffer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if `cm` or `rootCa` is `NULL`, or `rootCaSz` is 0
- a wolfSSL error code if the certificate cannot be loaded

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
root CAs loaded into the certificate manager. The buffer holds each DER-encoded
certificate preceded by its 4-byte big-endian length, leaf first, followed by
the intermediates; the root CA may be omitted. The chain may hold at most
`MAX_CHAIN_DEPTH` certificates (9 unless wolfSSL defines it).

The certificates are verified from the end of the chain toward the leaf. In
builds with OCSP support, each certificate is also checked with OCSP; a
certificate with no OCSP responder URL, when no default responder is
configured, is treated as not revoked. Each verified intermediate that is a CA
is added to the certificate manager as a trusted root so the next certificate
has a signer. The addition is permanent. An intermediate that is not a CA fails
the chain.

The leaf must be an end-entity certificate, not a CA. The function then applies
the RFC 6187 section 2.2 leaf checks in every build: a KeyUsage extension, if
present, must assert digitalSignature; an ExtendedKeyUsage extension, if
present, must name anyExtendedKeyUsage or a purpose usable for the SSH role
being verified. For a user certificate (verified by a server) that purpose is
id-kp-secureShellClient or TLS clientAuth; for a host certificate (verified by a
client) it is id-kp-secureShellServer or TLS serverAuth. The role comes from the
context that owns the certificate manager; a standalone manager created with
wolfSSH_CERTMAN_new() accepts either. Builds with FPKI profile matching (that
is, without `WOLFSSH_NO_FPKI`) also require the leaf to match one of the
supported FPKI profiles.

**Parameters**

- `cm` - the certificate manager
- `cert` - buffer containing the length-prefixed certificate chain
- `certSz` - size of the certificate buffer
- `certCount` - number of certificates in the chain

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if `cm` or `cert` is `NULL`, `certCount` is 0, or
  `certCount` exceeds `MAX_CHAIN_DEPTH`
- `WS_MEMORY_E` if an allocation fails
- `ASN_PARSE_E` if a certificate length runs past the end of the buffer
- `WS_CERT_NO_SIGNER_E` if a certificate has no trusted signer, or an
  intermediate is not a CA
- `WS_CERT_EXPIRED_E` if a certificate has expired
- `WS_CERT_SIG_CONFIRM_E` if a certificate signature does not verify
- `WS_CERT_REVOKED_E` if OCSP reports a certificate as revoked
- `WS_CERT_KEY_USAGE_E` if the leaf KeyUsage or ExtendedKeyUsage does not
  permit SSH use for the role
- `WS_CERT_PROFILE_E` if the leaf is a CA, or does not match an FPKI profile
- `WS_CERT_OTHER_E` for any other verification or OCSP failure

**See Also**

- `wolfSSH_CERTMAN_LoadRootCA_buffer()`

### wolfSSH_CertStoreLocationFromName()

**Availability**

Available when wolfSSH is built with certificate support and Windows
certificate store support (`WOLFSSH_CERTS` and `WOLFSSH_WINDOWS_CERT_STORE`,
from `./configure --enable-certs --enable-windows-cert-store`).

```c
#include <wolfssh/certman.h>

int wolfSSH_CertStoreLocationFromName(const char* in, word32* out);
```

**Description**

Parses the name of a Windows system certificate store location into its
`CERT_SYSTEM_STORE_*` value. Accepted names are `CURRENT_USER`,
`LOCAL_MACHINE`, `USERS`, `CURRENT_SERVICE`, `SERVICES`,
`CURRENT_USER_GROUP_POLICY`, `LOCAL_MACHINE_GROUP_POLICY`, and
`LOCAL_MACHINE_ENTERPRISE`, and the same names with a `CERT_SYSTEM_STORE_`
prefix. The location may also be given as a decimal number or a 0x-prefixed
hexadecimal number. The number must start with a digit and be consumed whole; a
leading sign or whitespace is rejected, and a leading 0 is read as decimal, not
octal. Only assigned store locations are accepted, never control flags.

**Parameters**

- `in` - NUL-terminated location name or number
- `out` - receives the `CERT_SYSTEM_STORE_*` value

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if `in` or `out` is `NULL`, `in` is empty, or `in` is not
  a valid location

**See Also**

- `wolfSSH_ParseCertStoreSpec()`

### wolfSSH_ParseCertStoreSpec()

**Availability**

Available when wolfSSH is built with certificate support and Windows
certificate store support (`WOLFSSH_CERTS` and `WOLFSSH_WINDOWS_CERT_STORE`).

```c
#include <wolfssh/certman.h>

int wolfSSH_ParseCertStoreSpec(const char* spec,
        wchar_t** wStoreName, wchar_t** wSubjectName,
        word32* dwFlags, void* heap);
```

**Description**

Splits a certificate store specification of the form `store:subject[:flags]`
into a store name, a subject name, and a store location. The specification is
split at the first two colons, so neither the store name nor the subject may
contain a colon, and a third colon is rejected. For example, "My:CN=host:65536"
is store "My", subject "CN=host", and flags 65536. The optional `flags` field
takes any spelling that wolfSSH_CertStoreLocationFromName() accepts and defaults
to `CURRENT_USER`. The store name and subject are converted from UTF-8 to
newly allocated wide strings; invalid UTF-8 is rejected.

On success the caller owns the two wide strings and must release them with
wolfSSH_FreeCertStoreSpec() using the same `heap`. On failure any non-NULL
`wStoreName` and `wSubjectName` out-pointer is set to `NULL`, and `dwFlags` is
left unchanged.

**Parameters**

- `spec` - NUL-terminated specification string
- `wStoreName` - receives the allocated store name
- `wSubjectName` - receives the allocated subject name
- `dwFlags` - receives the store location value
- `heap` - heap used for the allocations

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if an argument is `NULL` or the specification is malformed
- `WS_MEMORY_E` if an allocation fails
- `WS_FATAL_ERROR` if the UTF-8 to wide string conversion fails

**See Also**

- `wolfSSH_FreeCertStoreSpec()`
- `wolfSSH_CertStoreLocationFromName()`

### wolfSSH_FreeCertStoreSpec()

**Availability**

Available when wolfSSH is built with certificate support and Windows
certificate store support (`WOLFSSH_CERTS` and `WOLFSSH_WINDOWS_CERT_STORE`).

```c
#include <wolfssh/certman.h>

void wolfSSH_FreeCertStoreSpec(wchar_t* wStoreName, wchar_t* wSubjectName,
        void* heap);
```

**Description**

Frees the strings returned by wolfSSH_ParseCertStoreSpec(). Either pointer may
be `NULL`. The `heap` must be the one passed to wolfSSH_ParseCertStoreSpec().

**Parameters**

- `wStoreName` - the store name to free, or `NULL`
- `wSubjectName` - the subject name to free, or `NULL`
- `heap` - heap used for the allocations

**Return Values**

None

**See Also**

- `wolfSSH_ParseCertStoreSpec()`

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

Appends the string `s2` to the end of the string in `s1`, where `n` is the
total size of the buffer holding `s1`. The append is all or nothing: if `s2`
does not fit in the space left, including the terminating NUL, nothing is
appended. If no NUL terminator is found within the first `n` bytes of `s1`, the
function fails without writing.

**Parameters**

- `s1` - destination string, appended to in place
- `s2` - source string to append
- `n` - total size of the `s1` buffer in bytes

**Return Values**

- pointer to the destination string `s1` on success
- `NULL` if `s2` does not fit, or `s1` is not terminated within `n` bytes

### wstrdup()

```c
#include <wolfssh/port.h>

char* wstrdup(const char* s1, void* heap, int type);
```

**Description**

Duplicates the string `s1`, allocating the copy from the given `heap`. A `NULL`
`s1` returns `NULL`.

**Parameters**

- `s1` - the string to duplicate
- `heap` - heap used for the allocation
- `type` - allocation type hint

**Return Values**

- pointer to the duplicated string, or `NULL` on failure

### WS_FindFirstFileA()

**Availability**

Available on Windows builds (`USE_WINDOWS_API`) with SCP or SFTP support,
unless `WOLFSSH_SCP_USER_CALLBACKS` is defined.

```c
#include <wolfssh/port.h>

void* WS_FindFirstFileA(const char* fileName,
        char* realFileName, size_t realFileNameSz, int* isDir, void* heap);
```

**Description**

Begins a directory enumeration for `fileName`, returning a find handle and the
first matching entry. `isDir` is set to indicate whether the entry is a
directory. A leading path separator before a drive letter (as in SFTP paths
such as "/C:/dir") is trimmed before the search. The handle is a Windows find
handle.

**Parameters**

- `fileName` - the directory or search pattern to enumerate
- `realFileName` - buffer that receives the matched file name
- `realFileNameSz` - size of the `realFileName` buffer
- `isDir` - output set non-zero if the entry is a directory, or `NULL`
- `heap` - heap used for allocations

**Return Values**

- an opaque find handle on success
- `INVALID_HANDLE_VALUE` on failure

**See Also**

- `WS_FindNextFileA()`

### WS_FindNextFileA()

**Availability**

Available on Windows builds (`USE_WINDOWS_API`) with SCP or SFTP support,
unless `WOLFSSH_SCP_USER_CALLBACKS` is defined.

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
- 0 when there are no more entries, or the entry name could not be converted
  to a multibyte string that fits in `realFileName`

**See Also**

- `WS_FindFirstFileA()`

### wstrsep()

**Availability**

Available on Windows builds (`USE_WINDOWS_API`). Other platforms use the C
library `strsep()` through the `WSTRSEP()` macro.

```c
#include <wolfssh/port.h>

char* wstrsep(char** s1, const char* delim);
```

**Description**

A replacement for the BSD `strsep()` function, which the Microsoft C runtime
and MinGW do not provide. Finds the first character in `*s1` that appears in
`delim`, replaces it with a NUL to terminate the token in place, and advances
`*s1` past it. If no delimiter remains, `*s1` is set to `NULL`. Portable code
should call the `WSTRSEP()` macro, which maps to `strsep()` or to this
function as appropriate.

**Parameters**

- `s1` - pointer to the string pointer to split; updated to point past the token
- `delim` - NUL-terminated set of delimiter characters

**Return Values**

- pointer to the start of the token
- `NULL` if `*s1` was already `NULL`
