#  API Reference

This section describes the public application program interfaces for the wolfSSH library.

##  Error Codes



###  WS_ErrorCodes (enum)



The following API response codes are defined in wolfssh/error.h and describe the different types of errors that can occur. `WS_SUCCESS` is 0; all error codes are negative. `WS_FATAL_ERROR` is a deprecated alias for `WS_ERROR`, and `WS_LAST_E` always tracks the last defined error code (`WS_CERT_KEY_USAGE_E` as of v1.6.0). Value -1059 is unassigned.

- WS_SUCCESS (0): Function success
- WS_ERROR (-1001): General function failure
- WS_FATAL_ERROR (-1001): Deprecated alias for WS_ERROR
- WS_BAD_ARGUMENT (-1002): Bad function argument
- WS_MEMORY_E (-1003): Memory allocation failure
- WS_BUFFER_E (-1004): Input/output buffer size error
- WS_PARSE_E (-1005): General parsing error
- WS_NOT_COMPILED (-1006): Feature not compiled in
- WS_OVERFLOW_E (-1007): Would overflow if continued
- WS_BAD_USAGE (-1008): Bad example usage
- WS_SOCKET_ERROR_E (-1009): Socket error
- WS_WANT_READ (-1010): Nonblocking read would block, call again
- WS_WANT_WRITE (-1011): Nonblocking write would block, call again
- WS_RECV_OVERFLOW_E (-1012): Received buffer overflow
- WS_VERSION_E (-1013): Peer using wrong version of SSH
- WS_SEND_OOB_READ_E (-1014): Attempted to read buffer out of bounds
- WS_INPUT_CASE_E (-1015): Bad process input state, programming error
- WS_BAD_FILETYPE_E (-1016): Bad file type
- WS_UNIMPLEMENTED_E (-1017): Feature not implemented
- WS_RSA_E (-1018): RSA buffer error
- WS_BAD_FILE_E (-1019): Bad file
- WS_INVALID_ALGO_ID (-1020): Invalid algorithm ID
- WS_DECRYPT_E (-1021): Decrypt error
- WS_ENCRYPT_E (-1022): Encrypt error
- WS_VERIFY_MAC_E (-1023): Verify MAC error
- WS_CREATE_MAC_E (-1024): Create MAC error
- WS_RESOURCE_E (-1025): Insufficient resources for new channel
- WS_INVALID_CHANTYPE (-1026): Invalid channel type
- WS_INVALID_CHANID (-1027): Peer requested invalid channel ID
- WS_INVALID_USERNAME (-1028): Invalid user name
- WS_CRYPTO_FAILED (-1029): Crypto action failed
- WS_INVALID_STATE_E (-1030): Invalid state
- WS_EOF (-1031): End of file
- WS_INVALID_PRIME_CURVE (-1032): Invalid prime curve in ECC
- WS_ECC_E (-1033): ECDSA buffer error
- WS_CHANOPEN_FAILED (-1034): Peer returned channel open failure
- WS_REKEYING (-1035): Status: rekey in progress
- WS_CHANNEL_CLOSED (-1036): Status: channel closed
- WS_INVALID_PATH_E (-1037): Invalid path
- WS_SCP_CMD_E (-1038): SCP command error
- WS_SCP_BAD_MSG_E (-1039): SCP bad message
- WS_SCP_PATH_LEN_E (-1040): SCP path too long
- WS_SCP_TIMESTAMP_E (-1041): SCP timestamp error
- WS_SCP_DIR_STACK_EMPTY_E (-1042): SCP directory stack empty
- WS_SCP_CONTINUE (-1043): Status: SCP continue
- WS_SCP_ABORT (-1044): Status: SCP abort
- WS_SCP_ENTER_DIR (-1045): Status: SCP enter directory
- WS_SCP_EXIT_DIR (-1046): Status: SCP exit directory
- WS_SCP_EXIT_DIR_FINAL (-1047): Status: SCP exit final directory
- WS_SCP_COMPLETE (-1048): Status: SCP transfer complete
- WS_SCP_INIT (-1049): Status: SCP transfer verified
- WS_MATCH_KEX_ALGO_E (-1050): Cannot match KEX algorithm with peer
- WS_MATCH_KEY_ALGO_E (-1051): Cannot match key algorithm with peer
- WS_MATCH_ENC_ALGO_E (-1052): Cannot match encryption algorithm with peer
- WS_MATCH_MAC_ALGO_E (-1053): Cannot match MAC algorithm with peer
- WS_PERMISSIONS (-1054): Permissions error
- WS_SFTP_COMPLETE (-1055): Status: SFTP connection established
- WS_NEXT_ERROR (-1056): Getting next value/state is error
- WS_CHAN_RXD (-1057): Status: channel data received
- WS_INVALID_EXTDATA (-1058): Invalid channel extended data type
- WS_SFTP_BAD_REQ_ID (-1060): SFTP bad request ID
- WS_SFTP_BAD_REQ_TYPE (-1061): SFTP bad request type
- WS_SFTP_STATUS_NOT_OK (-1062): SFTP status not OK
- WS_SFTP_FILE_DNE (-1063): SFTP file does not exist
- WS_SIZE_ONLY (-1064): Only getting size of buffer needed
- WS_CLOSE_FILE_E (-1065): Unable to close local file
- WS_PUBKEY_REJECTED_E (-1066): Server public key rejected
- WS_EXTDATA (-1067): Extended data available to be read
- WS_USER_AUTH_E (-1068): User authentication error
- WS_SSH_NULL_E (-1069): SSH object was null
- WS_SSH_CTX_NULL_E (-1070): SSH_CTX object was null
- WS_CHANNEL_NOT_CONF (-1071): Channel open not confirmed
- WS_CHANGE_AUTH_E (-1072): Changing auth type attempt
- WS_WINDOW_FULL (-1073): Channel window full
- WS_MISSING_CALLBACK (-1074): Callback is missing
- WS_DH_SIZE_E (-1075): DH prime larger than expected
- WS_PUBKEY_SIG_MIN_E (-1076): Signature too small
- WS_AGENT_NULL_E (-1077): Agent object was null
- WS_AGENT_NO_KEY_E (-1078): Agent does not have requested key
- WS_AGENT_CXN_FAIL (-1079): Could not connect to agent
- WS_SFTP_BAD_HEADER (-1080): SFTP bad header
- WS_CERT_NO_SIGNER_E (-1081): No signer certificate available
- WS_CERT_EXPIRED_E (-1082): Certificate expired
- WS_CERT_REVOKED_E (-1083): User certificate reported revoked
- WS_CERT_SIG_CONFIRM_E (-1084): Root certificate signature verify failure
- WS_CERT_OTHER_E (-1085): Other certificate issue
- WS_CERT_PROFILE_E (-1086): Certificate does not meet profile requirements
- WS_CERT_KEY_SIZE_E (-1087): Key size error
- WS_CTX_KEY_COUNT_E (-1088): Adding too many private keys
- WS_MATCH_UA_KEY_ID_E (-1089): Match user auth key failure
- WS_KEY_AUTH_MAGIC_E (-1090): OpenSSH key auth magic check failure
- WS_KEY_CHECK_VAL_E (-1091): OpenSSH key check value failure
- WS_KEY_FORMAT_E (-1092): OpenSSH key format failure
- WS_SFTP_NOT_FILE_E (-1093): Not a regular file
- WS_MSGID_NOT_ALLOWED_E (-1094): Message ID not allowed at this point in the protocol
- WS_ED25519_E (-1095): Ed25519 failure
- WS_AUTH_PENDING (-1096): User authentication still pending
- WS_KDF_E (-1097): KDF error
- WS_DISCONNECT (-1098): Peer sent disconnect
- WS_MLDSA_E (-1099): ML-DSA failure
- WS_ED448_E (-1100): Ed448 failure
- WS_CERT_KEY_USAGE_E (-1101): Certificate KeyUsage or ExtendedKeyUsage does not permit SSH use

###  WS_IOerrors (enum)



These are the return codes the library expects to receive from a user-provided I/O callback. Otherwise the library expects the number of bytes read or written from the I/O action.

- WS_CBIO_ERR_GENERAL (-1): General unexpected error 
- WS_CBIO_ERR_WANT_READ (-2): Socket read would block, call again 
- WS_CBIO_ERR_WANT_WRITE (-2): Socket write would block, call again 
- WS_CBIO_ERR_CONN_RST (-3): Connection reset
- WS_CBIO_ERR_ISR (-4): Interrupt
- WS_CBIO_ERR_CONN_CLOSE (-5): Connection closed or EPIPE
- WS_CBIO_ERR_TIMEOUT (-6): Socket timeout

##  Initialization / Shutdown



### wolfSSH_Init()

```c
#include <wolfssh/ssh.h>

int wolfSSH_Init(void);
```

**Description**

Initializes the wolfSSH library for use. Must be called once per application before any other call into the library.

**Parameters**

None

**Return Values**

- `WS_SUCCESS`
- `WS_CRYPTO_FAILED`

**See Also**

- `wolfSSH_Cleanup()`

### wolfSSH_Cleanup()

```c
#include <wolfssh/ssh.h>

int wolfSSH_Cleanup(void);
```

**Description**

Cleans up the wolfSSH library when done. Should be called before termination of the application. After calling, do not make any more calls to the library.

**Parameters**

None

**Return Values**

- `WS_SUCCESS`
- `WS_CRYPTO_FAILED`

**See Also**

- `wolfSSH_Init()`

##  Debugging output functions



### wolfSSH_Debugging_ON()

```c
#include <wolfssh/ssh.h>

void wolfSSH_Debugging_ON(void);
```

**Description**

Enables debug logging during runtime. Does nothing when debugging is disabled at build time.

**Parameters**

None

**Return Values**

None

**See Also**

- `wolfSSH_Debugging_OFF()`

### wolfSSH_Debugging_OFF()

```c
#include <wolfssh/ssh.h>

void wolfSSH_Debugging_OFF(void);
```

**Description**

Disables debug logging during runtime. Does nothing when debugging is disabled at build time.

**Parameters**

None

**Return Values**

None

**See Also**

- `wolfSSH_Debugging_ON()`

##  Context Functions



### wolfSSH_CTX_new()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CTX* wolfSSH_CTX_new(byte side, void* heap);
```

**Description**

Creates a wolfSSH context object. This object can be configured and then used as a factory for wolfSSH session objects.

**Parameters**

- `side` - the endpoint role: `WOLFSSH_ENDPOINT_SERVER` or `WOLFSSH_ENDPOINT_CLIENT`
- `heap` - pointer to a heap to use for memory allocations, or `NULL`

**Return Values**

- `WOLFSSH_CTX*` - pointer to the newly allocated context object
- `NULL` - on failure

**See Also**

- `wolfSSH_CTX_free()`

### wolfSSH_CTX_free()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_free(WOLFSSH_CTX* ctx);
```

**Description**

Deallocates a wolfSSH context object.

**Parameters**

- `ctx` - the wolfSSH context to free

**Return Values**

None

**See Also**

- `wolfSSH_CTX_new()`

### wolfSSH_CTX_SetBanner()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetBanner(WOLFSSH_CTX* ctx, const char* newBanner);
```

**Description**

Sets a banner message presented to the peer before authentication.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `newBanner` - the banner message text

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_CTX_UsePrivateKey_buffer()`

### wolfSSH_CTX_UsePrivateKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UsePrivateKey_buffer(WOLFSSH_CTX* ctx,
        const byte* in, word32 inSz, int format);
```

**Description**

Loads a private key from a buffer into the SSH context instead of from a file. The key is provided by the `in` argument of size `inSz`. The `format` argument specifies the buffer encoding: `WOLFSSH_FORMAT_ASN1` or `WOLFSSH_FORMAT_PEM` (PEM is unimplemented at this time).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `in` - buffer containing the private key to be loaded
- `inSz` - size of the input buffer
- `format` - format of the private key in the input buffer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_BAD_FILETYPE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_MEMORY_E`
- `WS_RSA_E`
- `WS_BAD_FILE_E`

**See Also**

- `wolfSSH_CTX_UseCert_buffer()`

### wolfSSH_CTX_UseCert_buffer()

**Availability**

Requires `WOLFSSH_CERTS`.

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UseCert_buffer(WOLFSSH_CTX* ctx,
        const byte* cert, word32 certSz, int format);
```

**Description**

Loads the server's X.509 certificate from a buffer into the context, for certificate-based host authentication. The `format` is `WOLFSSH_FORMAT_ASN1` or `WOLFSSH_FORMAT_PEM`. The buffer should hold the leaf certificate; when a PEM buffer holds several certificates, only the first is read. The "TRUSTED CERTIFICATE" PEM form is meant for root CAs and is declined here.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cert` - buffer containing the certificate
- `certSz` - size of the certificate buffer
- `format` - encoding of the certificate

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**See Also**

- `wolfSSH_CTX_AddRootCert_buffer()`

### wolfSSH_CTX_AddRootCert_buffer()

**Availability**

Requires `WOLFSSH_CERTS`.

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_AddRootCert_buffer(WOLFSSH_CTX* ctx,
        const byte* cert, word32 certSz, int format);
```

**Description**

Adds a trusted root CA certificate to the context, used to verify certificates presented by the peer. The `format` is `WOLFSSH_FORMAT_ASN1` or `WOLFSSH_FORMAT_PEM`. A PEM buffer may be a bundle: every certificate in it is loaded, in either the plain or the "TRUSTED CERTIFICATE" form (the latter with wolfSSL 5.8.0 or later). A block that fails to load is skipped; the call fails only when no CA could be loaded at all.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cert` - buffer containing the root certificate
- `certSz` - size of the certificate buffer
- `format` - encoding of the certificate

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**See Also**

- `wolfSSH_CTX_UseCert_buffer()`
- `wolfSSH_CTX_AddRootCert_file()`

### wolfSSH_CTX_UseCert_file()

**Availability**

Requires `WOLFSSH_CERTS` and filesystem support (not available with `NO_FILESYSTEM` or `WOLFSSH_USER_FILESYSTEM`).

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UseCert_file(WOLFSSH_CTX* ctx, const char* name);
```

**Description**

Loads the server's X.509 certificate from the file `name` into the context, the file counterpart of wolfSSH_CTX_UseCert_buffer(). Whether the file holds PEM or DER is detected from its content. An OpenSSH certificate line is not accepted here.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `name` - path to the certificate file

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` or `name` is NULL
- `WS_BAD_FILE_E` - the file cannot be opened or read, is empty, or is larger than `WOLFSSH_MAX_FILE_SIZE`
- `WS_BAD_FILETYPE_E` - the content is not a PEM or DER X.509 certificate
- `WS_MEMORY_E`
- other errors from decoding the certificate

**See Also**

- `wolfSSH_CTX_UseCert_buffer()`
- `wolfSSH_CTX_AddRootCert_file()`

### wolfSSH_CTX_AddRootCert_file()

**Availability**

Requires `WOLFSSH_CERTS` and filesystem support (not available with `NO_FILESYSTEM` or `WOLFSSH_USER_FILESYSTEM`).

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_AddRootCert_file(WOLFSSH_CTX* ctx, const char* name);
```

**Description**

Adds the trusted root CA certificate(s) in the file `name` to the context, the file counterpart of wolfSSH_CTX_AddRootCert_buffer(). Whether the file holds PEM or DER is detected from its content; a PEM bundle loads every CA it contains.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `name` - path to the CA certificate file

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` or `name` is NULL
- `WS_BAD_FILE_E` - the file cannot be opened or read, is empty, or is larger than `WOLFSSH_MAX_FILE_SIZE`
- `WS_BAD_FILETYPE_E` - the content is not a PEM or DER X.509 certificate
- `WS_MEMORY_E`
- other errors from decoding the certificate

**See Also**

- `wolfSSH_CTX_AddRootCert_buffer()`
- `wolfSSH_CTX_UseCert_file()`

### wolfSSH_CTX_UsePrivateKey_fromStore()

**Availability**

Requires `WOLFSSH_CERTS` and `WOLFSSH_WINDOWS_CERT_STORE` (Windows only).

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UsePrivateKey_fromStore(WOLFSSH_CTX* ctx,
        const wchar_t* storeName, word32 dwFlags,
        const wchar_t* subjectName);
```

**Description**

Uses a certificate and its private key from a Windows system certificate store as the server host key. The certificate is located by its Common Name, `subjectName`, which may carry a "CN=" prefix and must match in full, case insensitively. The store `storeName` (for example, L"My") is opened read-only. `dwFlags` selects the store location and must hold only `CERT_SYSTEM_STORE_*` location bits, such as `CERT_SYSTEM_STORE_CURRENT_USER`; control flags such as `CERT_STORE_DELETE_FLAG` are rejected.

The key is registered under its plain key type (`ssh-rsa` or `ecdsa-sha2-nistp*`) and, where the build supports it, under the matching RFC 6187 `x509v3-*` type, so the store certificate itself can be sent to peers that negotiate certificate algorithms. The private key stays in the store; signing is done through CNG.

Only a time-valid certificate whose private key is accessible and usable for signing is selected. When only expired or not-yet-valid certificates match, the call fails with `WS_CERT_EXPIRED_E`; define `WOLFSSH_CERT_STORE_ALLOW_EXPIRED` to select one of them instead. A store key cannot be mixed with a file- or TPM-based host key or host certificate already loaded for the same algorithm, in either load order; replacing a previously loaded store key is allowed. On any failure the context is left unchanged.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `storeName` - name of the system certificate store
- `dwFlags` - the store location, a `CERT_SYSTEM_STORE_*` value
- `subjectName` - Common Name of the certificate to use

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - a NULL argument, bad `dwFlags`, an unsupported key type, or a mixed key configuration
- `WS_BAD_FILE_E` - the store cannot be opened
- `WS_CRYPTO_FAILED` - certificates match, but none has a private key that is both accessible and enrolled for signing
- `WS_CERT_EXPIRED_E` - only certificates outside their validity period match
- `WS_CTX_KEY_COUNT_E` - two free key slots are not available
- `WS_MEMORY_E`
- `WS_FATAL_ERROR` - no certificate matches

**See Also**

- `wolfSSH_CTX_GetCertStoreCert()`
- `wolfSSH_CTX_UsePrivateKey_buffer()`

### wolfSSH_CTX_GetCertStoreCert()

**Availability**

Requires `WOLFSSH_CERTS` and `WOLFSSH_WINDOWS_CERT_STORE` (Windows only).

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_GetCertStoreCert(WOLFSSH_CTX* ctx,
        const byte** cert, word32* certSz, const char** algoName);
```

**Description**

Reports the certificate that a host key loaded with wolfSSH_CTX_UsePrivateKey_fromStore() is bound to, so an application can offer it for certificate user authentication. `cert` and `certSz` receive the DER certificate, which is owned by the context and remains valid until the context is freed or the key slot is replaced. `algoName` receives the static `x509v3-*` algorithm name. Any of the output pointers may be NULL to skip it. When several store credentials are loaded, the first `x509v3-*` slot in load order is returned.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cert` - output for a pointer to the DER certificate
- `certSz` - output for the certificate size
- `algoName` - output for the SSH algorithm name

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` is NULL
- `WS_FATAL_ERROR` - no certificate-store-backed `x509v3-*` key slot exists

**See Also**

- `wolfSSH_CTX_UsePrivateKey_fromStore()`

##  SSH Session Functions



### wolfSSH_new()

```c
#include <wolfssh/ssh.h>

WOLFSSH* wolfSSH_new(WOLFSSH_CTX* ctx);
```

**Description**

Creates a wolfSSH session object, initialized with the provided wolfSSH context.

**Parameters**

- `ctx` - the wolfSSH context used to initialize the session

**Return Values**

- `WOLFSSH*` - pointer to the newly allocated session object
- `NULL` - on failure

**See Also**

- `wolfSSH_free()`

### wolfSSH_free()

```c
#include <wolfssh/ssh.h>

void wolfSSH_free(WOLFSSH* ssh);
```

**Description**

Deallocates a wolfSSH session object.

**Parameters**

- `ssh` - session to deallocate

**Return Values**

None

**See Also**

- `wolfSSH_new()`

### wolfSSH_worker()

```c
#include <wolfssh/ssh.h>

int wolfSSH_worker(WOLFSSH* ssh, word32* channelId);
```

**Description**

Services the SSH connection: receives any pending inbound data and flushes pending outbound packets. This is the main driver call for a running session. Besides `WS_SUCCESS`, it returns several non-fatal statuses that callers must not treat as errors:

- `WS_CHAN_RXD` - channel data arrived; read it with wolfSSH_stream_read() or wolfSSH_ChannelIdRead()
- `WS_EXTDATA` - extended (stderr) data arrived; drain it with wolfSSH_ChannelIdReadExt() (or wolfSSH_extended_data_read() for the first channel)
- `WS_EOF` - the peer half-closed a channel. It sends no more data, but the channel is still open for sending. This is reported once, on arrival; an application that must not miss it tests wolfSSH_ChannelGetEof() or registers the channel EOF callback. The library does not answer with an EOF of its own; reply, if the protocol wants one, with wolfSSH_ChannelSendEof().
- `WS_CHANNEL_CLOSED` - the peer closed a channel, which has been retired
- `WS_WANT_READ`, `WS_WANT_WRITE`, `WS_REKEYING` - transient; call again

Take the event from the return value, not from wolfSSH_get_error(). The return names what arrived; wolfSSH_get_error() names what the transport did, and on any pass the two are independent: the return can carry an event while wolfSSH_get_error() reports a write that is still owed or that failed. A caller that tolerates only `WS_WANT_READ` drops live sessions, since a queued write reports `WS_WANT_WRITE`. Any other code is an error, either in the return itself or as `WS_FATAL_ERROR` with the cause in wolfSSH_get_error() -- `WS_DISCONNECT` for the peer's disconnect, which is how most sessions end. Once the session has disconnected, every further call returns `WS_FATAL_ERROR` with `WS_DISCONNECT` latched.

To ask whether a write is still owed, call wolfSSH_OutputPending(); to ask whether a key exchange is in flight, call wolfSSH_RekeyPending().

For `WS_CHAN_RXD`, `WS_EXTDATA`, `WS_EOF`, `WS_SUCCESS`, and a `WS_REKEYING` that displaced `WS_SUCCESS` or `WS_CHAN_RXD`, the ID of the channel the event belongs to is written to `channelId` when it is not NULL. It is left alone for every other status, `WS_CHANNEL_CLOSED` included; use wolfSSH_GetLastRxId() there.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - optional output for the ID of the channel the event belongs to; may be NULL

**Return Values**

- `WS_SUCCESS`
- `WS_CHAN_RXD`
- `WS_EXTDATA`
- `WS_EOF`
- `WS_CHANNEL_CLOSED`
- `WS_REKEYING`
- `WS_WANT_READ`
- `WS_WANT_WRITE`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR` - check wolfSSH_get_error() for the cause

**See Also**

- `wolfSSH_GetLastRxId()`
- `wolfSSH_OutputPending()`
- `wolfSSH_RekeyPending()`

### wolfSSH_GetLastRxId()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetLastRxId(WOLFSSH* ssh, word32* channelId);
```

**Description**

Writes the channel ID of the channel that most recently received data into `channelId`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - output for the last received channel ID

**Return Values**

- `WS_SUCCESS`
- `WS_ERROR`

**See Also**

- `wolfSSH_worker()`

### wolfSSH_OutputPending()

```c
#include <wolfssh/ssh.h>

int wolfSSH_OutputPending(const WOLFSSH* ssh);
```

**Description**

Reports whether the session still has queued output that a short (non-blocking) send left unsent. Unlike a status code, it gives a correct answer after any return, including a success. Flush the queued data by calling wolfSSH_worker() (or the call that queued it) again.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- non-zero - a write is still owed
- 0 - nothing is queued, or `ssh` is NULL

**See Also**

- `wolfSSH_worker()`
- `wolfSSH_RekeyPending()`

### wolfSSH_RekeyPending()

```c
#include <wolfssh/ssh.h>

int wolfSSH_RekeyPending(const WOLFSSH* ssh);
```

**Description**

Reports whether a key exchange is in flight, the first one included. Only the exchange of SSH_MSG_NEWKEYS from both sides clears the flag, so it stays set after a failed exchange; end a service loop on the result of wolfSSH_worker(), not on this call.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- non-zero - a key exchange is in progress
- 0 - no key exchange is in progress, or `ssh` is NULL

**See Also**

- `wolfSSH_worker()`
- `wolfSSH_OutputPending()`
- `wolfSSH_TriggerKeyExchange()`

### wolfSSH_set_fd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_set_fd(WOLFSSH* ssh, WS_SOCKET_T fd);
```

**Description**

Assigns the provided file descriptor to the session. The session uses this descriptor for network I/O in the default I/O callbacks.

**Parameters**

- `ssh` - session to set the descriptor on
- `fd` - file descriptor for the socket used by the session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_get_fd()`

### wolfSSH_get_fd()

```c
#include <wolfssh/ssh.h>

WS_SOCKET_T wolfSSH_get_fd(const WOLFSSH* ssh);
```

**Description**

Returns the file descriptor used as the input/output facility for the SSH connection. Typically this is a socket file descriptor.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the session's socket file descriptor on success
- -1 (`INVALID_SOCKET` on Windows) if `ssh` is NULL. This is the same invalid-socket value a new session's descriptor is initialized to.

**See Also**

- `wolfSSH_set_fd()`

### wolfSSH_SetFilesystemHandle()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetFilesystemHandle(WOLFSSH* ssh, void* handle);
```

**Description**

Associates a user-provided filesystem handle with the session. Ports that supply their own filesystem layer use this handle when performing file operations for the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `handle` - opaque filesystem handle to associate with the session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_GetFilesystemHandle()`

### wolfSSH_GetFilesystemHandle()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetFilesystemHandle(WOLFSSH* ssh);
```

**Description**

Returns the filesystem handle previously associated with the session by wolfSSH_SetFilesystemHandle(), or NULL if none was set.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the filesystem handle associated with the session
- `NULL` - if `ssh` is NULL or no handle was set

**See Also**

- `wolfSSH_SetFilesystemHandle()`

##  Data High Water Mark Functions



### wolfSSH_SetHighwater()


```c
#include <wolfssh/ssh.h>

int wolfSSH_SetHighwater(WOLFSSH* ssh, word32 level);
```

**Description**

Sets the data highwater mark, in bytes, for the session. When the amount of data transferred reaches this level, the highwater callback is invoked (typically to trigger a rekey).

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `level` - the highwater mark, in bytes

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_GetHighwater()`

### wolfSSH_GetHighwater()


```c
#include <wolfssh/ssh.h>

word32 wolfSSH_GetHighwater(WOLFSSH* ssh);
```

**Description**

Returns the current data highwater mark, in bytes, for the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the data highwater mark, in bytes

**See Also**

- `wolfSSH_SetHighwater()`

### wolfSSH_SetHighwaterCb()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetHighwaterCb(WOLFSSH_CTX* ctx, word32 level,
        WS_CallbackHighwater cb);
```

**Description**

Sets, at the context level, the default data highwater mark and the callback that is invoked when a session reaches it. Sessions created from this context inherit these defaults.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `level` - the default data highwater mark, in bytes
- `cb` - the highwater callback function

**Return Values**

None

**See Also**

- `wolfSSH_SetHighwaterCtx()`

### wolfSSH_SetHighwaterCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetHighwaterCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer that is passed to the session's highwater callback when it is invoked.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the highwater callback

**Return Values**

None

**See Also**

- `wolfSSH_GetHighwaterCtx()`

### wolfSSH_GetHighwaterCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetHighwaterCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetHighwaterCtx() that is passed to the highwater callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the highwater user context pointer
- `NULL` - if `ssh` is invalid or no context was set

**See Also**

- `wolfSSH_SetHighwaterCtx()`

### wolfSSH_CTX_SetMsgHighwater()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_SetMsgHighwater(WOLFSSH_CTX* ctx, word32 level);
```

**Description**

Sets, at the context level, the default packet-count highwater mark (RFC 4344, Section 3.1). When the number of packets sent or received on a session reaches this level, a rekey is triggered. Sessions created from this context inherit the default.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `level` - the packet-count highwater mark

**Return Values**

None

**See Also**

- `wolfSSH_SetMsgHighwater()`

### wolfSSH_SetMsgHighwater()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetMsgHighwater(WOLFSSH* ssh, word32 level);
```

**Description**

Sets the packet-count highwater mark (RFC 4344, Section 3.1) for a single session.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `level` - the packet-count highwater mark

**Return Values**

None

**See Also**

- `wolfSSH_GetMsgHighwater()`

### wolfSSH_GetMsgHighwater()

```c
#include <wolfssh/ssh.h>

word32 wolfSSH_GetMsgHighwater(WOLFSSH* ssh);
```

**Description**

Returns the current packet-count highwater mark for the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the packet-count highwater mark

**See Also**

- `wolfSSH_SetMsgHighwater()`

##  Error Checking



### wolfSSH_get_error()



```c
#include <wolfssh/ssh.h>

int wolfSSH_get_error(const WOLFSSH* ssh);
```

**Description**

Returns the last error set on the wolfSSH session object.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- a `WS_ErrorCodes` value (see Error Codes)

**See Also**

- `wolfSSH_get_error_name()`

### wolfSSH_get_error_name()



```c
#include <wolfssh/ssh.h>

const char* wolfSSH_get_error_name(const WOLFSSH* ssh);
```

**Description**

Returns the name string of the last error set on the wolfSSH session object.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the error name string

**See Also**

- `wolfSSH_get_error()`

### wolfSSH_ErrorToName()


```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ErrorToName(int err);
```

**Description**

Returns the name string for the given wolfSSH error code.

**Parameters**

- `err` - the error code value (a `WS_ErrorCodes` value)

**Return Values**

- pointer to the error name string

**See Also**

- `wolfSSH_get_error_name()`

##  I/O Callbacks



### wolfSSH_SetIORecv()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIORecv(WOLFSSH_CTX* ctx, WS_CallbackIORecv cb);
```

**Description**

Registers a receive callback used by wolfSSH to read input data. The callback signature is shown by the `WS_CallbackIORecv` type.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - function to register as the receive callback for the context

**Return Values**

None

**See Also**

- `wolfSSH_SetIOSend()`

### wolfSSH_SetIOSend()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOSend(WOLFSSH_CTX* ctx, WS_CallbackIOSend cb);
```

**Description**

Registers a send callback used by wolfSSH to write output data. The callback signature is shown by the `WS_CallbackIOSend` type.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - function to register as the send callback for the context

**Return Values**

None

**See Also**

- `wolfSSH_SetIORecv()`

### wolfSSH_SetIOReadCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOReadCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Registers a context passed to the session's receive (I/O read) callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - context to register with the session's receive callback

**Return Values**

None

**See Also**

- `wolfSSH_GetIOReadCtx()`

### wolfSSH_SetIOWriteCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetIOWriteCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Registers a context passed to the session's send (I/O write) callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - context to register with the session's send callback

**Return Values**

None

**See Also**

- `wolfSSH_GetIOWriteCtx()`

### wolfSSH_GetIOReadCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetIOReadCtx(WOLFSSH* ssh);
```

**Description**

Returns the context previously registered for the session's receive (I/O read) callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the registered read context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetIOReadCtx()`

### wolfSSH_GetIOWriteCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetIOWriteCtx(WOLFSSH* ssh);
```

**Description**

Returns the context previously registered for the session's send (I/O write) callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the registered write context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetIOWriteCtx()`

##  User Authentication



### wolfSSH_SetUserAuth()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx, WS_CallbackUserAuth cb);
```

**Description**

Registers the user authentication callback on the wolfSSH context. The callback is invoked on the server during the handshake to decide whether to authenticate the client.

The callback returns `WOLFSSH_USERAUTH_SUCCESS` only on a positive authentication decision. `WOLFSSH_USERAUTH_PARTIAL_SUCCESS` reports that one factor of a multi-method authentication passed, `WOLFSSH_USERAUTH_SUCCESS_ANOTHER` reports that a keyboard-interactive round passed and asks for the next round, `WOLFSSH_USERAUTH_WOULD_BLOCK` asks for the request to be retried, and `WOLFSSH_USERAUTH_REJECTED` is a hard rejection: the server answers with USERAUTH_FAILURE and then ends the session. Any other value is treated as an ordinary failure.

Note: `WOLFSSH_USERAUTH_SUCCESS` has the value 0, the same as `WS_SUCCESS`. A bare `return 0;`, a forwarded `WS_SUCCESS` from a helper, or a fall-through default of 0 silently authenticates the client. Return `WOLFSSH_USERAUTH_FAILURE` for any auth type or code path the callback does not explicitly handle. For `WOLFSSH_USERAUTH_PUBLICKEY`, the callback must check the offered public key against the user's authorized keys: the library verifies the signature, not the key's authorization.

Every request that does not fully authenticate counts against the session's limit on failed attempts (see wolfSSH_CTX_SetMaxAuthAttempts()).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the user authentication callback function

**Return Values**

None

**See Also**

- `wolfSSH_SetUserAuthCtx()`
- `wolfSSH_CTX_SetMaxAuthAttempts()`

### wolfSSH_SetUserAuthCtx()


```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh, void* userAuthCtx);
```

**Description**

Sets the user context pointer passed to the user authentication callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `userAuthCtx` - user context pointer to pass to the authentication callback

**Return Values**

None

**See Also**

- `wolfSSH_GetUserAuthCtx()`

### wolfSSH_GetUserAuthCtx()


```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetUserAuthCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the user authentication context pointer
- `NULL` - if `ssh` is NULL

**See Also**

- `wolfSSH_SetUserAuthCtx()`

### wolfSSH_SetUserAuthTypes()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthTypes(WOLFSSH_CTX* ctx, WS_CallbackUserAuthTypes cb);
```

**Description**

Registers a callback that reports which user authentication types the server offers. The callback returns a bitmask of the `WOLFSSH_USERAUTH_*` values (for example, `WOLFSSH_USERAUTH_PASSWORD` or `WOLFSSH_USERAUTH_PUBLICKEY`).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the user authentication types callback

**Return Values**

None

**See Also**

- `wolfSSH_SetUserAuth()`

### wolfSSH_SetUserAuthResult()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthResult(WOLFSSH_CTX* ctx, WS_CallbackUserAuthResult cb);
```

**Description**

Registers a callback that is invoked with the result of a user authentication attempt.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the user authentication result callback

**Return Values**

None

**See Also**

- `wolfSSH_SetUserAuthResultCtx()`

### wolfSSH_SetUserAuthResultCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetUserAuthResultCtx(WOLFSSH* ssh, void* userAuthResultCtx);
```

**Description**

Sets the user context pointer passed to the user authentication result callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `userAuthResultCtx` - user context pointer to pass to the result callback

**Return Values**

None

**See Also**

- `wolfSSH_GetUserAuthResultCtx()`

### wolfSSH_GetUserAuthResultCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetUserAuthResultCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetUserAuthResultCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the user authentication result context pointer
- `NULL` - if `ssh` is NULL

**See Also**

- `wolfSSH_SetUserAuthResultCtx()`

### wolfSSH_CTX_SetPublicKeyCheck()

```c
#include <wolfssh/ssh.h>

void wolfSSH_CTX_SetPublicKeyCheck(WOLFSSH_CTX* ctx,
        WS_CallbackPublicKeyCheck cb);
```

**Description**

Registers a callback, used on the client side, to check the server's public (host) key before continuing the handshake. This is the client's only defense against a man-in-the-middle. The callback returns 0 to accept the key, or non-zero to reject it and fail the key exchange.

Note: because 0 accepts, a stub that defaults to `return 0;` accepts any server host key and defeats man-in-the-middle protection. The callback must match the key against a trust store, such as a known-hosts list. If no callback is registered, the host key is rejected (`WS_PUBKEY_REJECTED_E`).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the public key check callback

**Return Values**

None

**See Also**

- `wolfSSH_SetPublicKeyCheckCtx()`

### wolfSSH_SetPublicKeyCheckCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetPublicKeyCheckCtx(WOLFSSH* ssh, void* publicKeyCheckCtx);
```

**Description**

Sets the user context pointer passed to the public key check callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `publicKeyCheckCtx` - user context pointer to pass to the callback

**Return Values**

None

**See Also**

- `wolfSSH_GetPublicKeyCheckCtx()`

### wolfSSH_GetPublicKeyCheckCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetPublicKeyCheckCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetPublicKeyCheckCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the public key check context pointer
- `NULL` - if `ssh` is NULL

**See Also**

- `wolfSSH_SetPublicKeyCheckCtx()`

### wolfSSH_CTX_SetMaxAuthAttempts()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetMaxAuthAttempts(WOLFSSH_CTX* ctx, int value);
```

**Description**

Sets the server-side limit on failed user authentication attempts per connection for sessions created from this context. The default is `DEFAULT_MAX_AUTH_ATTEMPTS` (6), the same value as the OpenSSH `MaxAuthTries` default. When the limit is reached the server sends an SSH_MSG_DISCONNECT and drops the connection. A `value` less than or equal to 0 restores the built-in default; there is no "unlimited" setting. Every request that does not fully authenticate is charged, including a partial success; only the opening "none" request that clients use to learn the method list is exempt.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `value` - the maximum number of failed attempts, or 0 or less for the default

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` is NULL

**See Also**

- `wolfSSH_CTX_GetMaxAuthAttempts()`
- `wolfSSH_SetMaxAuthAttempts()`

### wolfSSH_CTX_GetMaxAuthAttempts()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_GetMaxAuthAttempts(WOLFSSH_CTX* ctx);
```

**Description**

Returns the context's limit on failed user authentication attempts.

**Parameters**

- `ctx` - pointer to the wolfSSH context

**Return Values**

- the current limit
- `WS_BAD_ARGUMENT` - `ctx` is NULL

**See Also**

- `wolfSSH_CTX_SetMaxAuthAttempts()`

### wolfSSH_SetMaxAuthAttempts()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetMaxAuthAttempts(WOLFSSH* ssh, int value);
```

**Description**

Overrides, for one session, the limit on failed user authentication attempts that the session inherited from its context. The semantics of `value` are those of wolfSSH_CTX_SetMaxAuthAttempts().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `value` - the maximum number of failed attempts, or 0 or less for the default

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` is NULL

**See Also**

- `wolfSSH_GetMaxAuthAttempts()`
- `wolfSSH_CTX_SetMaxAuthAttempts()`

### wolfSSH_GetMaxAuthAttempts()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetMaxAuthAttempts(WOLFSSH* ssh);
```

**Description**

Returns the session's limit on failed user authentication attempts.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the current limit
- `WS_BAD_ARGUMENT` - `ssh` is NULL

**See Also**

- `wolfSSH_SetMaxAuthAttempts()`

##  Set Username



### wolfSSH_SetUsername()


```c
#include <wolfssh/ssh.h>

int wolfSSH_SetUsername(WOLFSSH* ssh, const char* username);
```

**Description**

Sets the username used for the SSH connection, provided as a null-terminated string.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `username` - the username for the SSH connection

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**See Also**

- `wolfSSH_GetUsername()`

### wolfSSH_SetUsernameRaw()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetUsernameRaw(WOLFSSH* ssh, const byte* username,
        word32 usernameSz);
```

**Description**

Sets the username used for the SSH connection from a buffer and length, rather than a null-terminated string. Useful when the username is not null-terminated or may contain arbitrary bytes.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `username` - buffer containing the username
- `usernameSz` - length of the username buffer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`

**See Also**

- `wolfSSH_SetUsername()`

### wolfSSH_GetUsername()

```c
#include <wolfssh/ssh.h>

char* wolfSSH_GetUsername(WOLFSSH* ssh);
```

**Description**

Returns the username associated with the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the session's username string
- `NULL` - if `ssh` is NULL or no username is set

**See Also**

- `wolfSSH_SetUsername()`

##  Connection Functions

### wolfSSH_accept()



```c
#include <wolfssh/ssh.h>

int wolfSSH_accept(WOLFSSH* ssh);
```

**Description**

Called on the server side; waits for an SSH client to initiate the SSH handshake and completes it.

wolfSSH_accept() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking, wolfSSH_accept() returns when the I/O cannot yet satisfy the handshake; a call to wolfSSH_get_error() then yields either `WS_WANT_READ` or `WS_WANT_WRITE`. The caller repeats the call when data is available and wolfSSH resumes where it left off.

If the underlying I/O is blocking, wolfSSH_accept() returns only once the handshake has finished or an error occurred.

By default wolfSSH_accept() runs through to an established session with the first channel open. When application-driven channels are enabled with wolfSSH_CTX_SetAppChannels() or wolfSSH_SetAppChannels(), it instead returns `WS_SUCCESS` as soon as the user has authenticated, and the application drives the session from there with wolfSSH_worker() and the channel callbacks. In the default mode, a granted SCP command makes wolfSSH_accept() return `WS_SCP_INIT`, and a granted "sftp" subsystem request hands off to wolfSSH_SFTP_accept().

Once the session has disconnected (a disconnect sent or received), this call returns `WS_FATAL_ERROR` and wolfSSH_get_error() reports `WS_DISCONNECT`.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_SCP_INIT` - an SCP transfer was requested (`WOLFSSH_SCP` builds)
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_connect()`
- `wolfSSH_stream_read()`
- `wolfSSH_CTX_SetAppChannels()`

### wolfSSH_connect()


```c
#include <wolfssh/ssh.h>

int wolfSSH_connect(WOLFSSH* ssh);
```

**Description**

Called on the client side; initiates an SSH handshake with a server. The underlying communication channel must already be set up before this call.

wolfSSH_connect() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking, wolfSSH_connect() returns when the I/O cannot yet satisfy the handshake; a call to wolfSSH_get_error() then yields either `WS_WANT_READ` or `WS_WANT_WRITE`. The caller repeats the call when the I/O is ready and wolfSSH resumes where it left off.

If the underlying I/O is blocking, wolfSSH_connect() returns only once the handshake has finished or an error occurred.

Once the session has disconnected (a disconnect sent or received), this call returns `WS_FATAL_ERROR` and wolfSSH_get_error() reports `WS_DISCONNECT`.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_accept()`

### wolfSSH_shutdown()


```c
#include <wolfssh/ssh.h>

int wolfSSH_shutdown(WOLFSSH* ssh);
```

**Description**

Tears down the first channel in the session's channel list, sending SSH_MSG_CHANNEL_EOF, the exit status, and SSH_MSG_CHANNEL_CLOSE, and then reads the peer's close reply. It does not send SSH_MSG_DISCONNECT; use wolfSSH_SendDisconnect() for that.

wolfSSH_shutdown() also flushes anything a short non-blocking send left queued, with or without a channel to tear down, such as a rejected authentication's USERAUTH_FAILURE or a disconnect of this side's own. That flush can be short too, so `WS_WANT_WRITE` may be owed to it rather than to the teardown messages; either way, call wolfSSH_shutdown() again until it reports something else. Once the peer has disconnected, nothing new is sent: only a disconnect of this side's own that is still queued goes out, and wolfSSH_get_error() reports `WS_DISCONNECT`.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_CHANNEL_CLOSED` - the channel list is now empty
- `WS_WANT_WRITE` - output is still queued; call again
- `WS_WANT_READ`
- `WS_BAD_ARGUMENT` - `ssh` is NULL, or there is no channel to tear down
- other negative error codes from the send or receive path

**See Also**

- `wolfSSH_SendDisconnect()`
- `wolfSSH_ChannelExit()`
- `wolfSSH_OutputPending()`

### wolfSSH_stream_read()



```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_read(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of decrypted data from the first channel in the session's channel list. The bytes read are removed from the internal buffer, and the channel window is credited for them.

wolfSSH_stream_read() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking and cannot satisfy the read, the call returns a negative value and wolfSSH_get_error() yields `WS_WANT_READ` or `WS_WANT_WRITE`; the caller repeats the call when data is available. If the underlying I/O is blocking, the call returns only when data is available or an error occurred. If a rekey is in progress, the call fails and wolfSSH_get_error() yields `WS_REKEYING`; call wolfSSH_worker() to complete it.

A successful read sends the peer a window adjust. On a non-blocking socket that send can be short: the byte count is still returned, but wolfSSH_get_error() is left at `WS_WANT_WRITE` to show the adjust is queued; it goes out on the next send or the next wolfSSH_worker() call.

This call serves only the first channel. Data, normal or extended, arriving for any other channel makes it fail with `WS_ERROR`; read those channels with wolfSSH_ChannelIdRead() and wolfSSH_ChannelIdReadExt(). When extended (stderr) data arrives on the first channel the call returns `WS_EXTDATA`; drain it with wolfSSH_extended_data_read() until that returns 0. An EOF from the peer is reported only once the buffered data has been read. After a disconnect, data that arrived before it can still be read; once the buffer is empty the call fails with `WS_DISCONNECT` in wolfSSH_get_error().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes read on success
- `WS_BAD_ARGUMENT`
- `WS_EXTDATA` - extended data is waiting on the first channel
- `WS_EOF` - the peer sent EOF on the channel
- `WS_ERROR` - data arrived for another channel, or the peer sent EOF (wolfSSH_get_error() reports `WS_EOF`)
- `WS_BUFFER_E`
- `WS_FATAL_ERROR` - check wolfSSH_get_error(), which reports `WS_REKEYING`, `WS_DISCONNECT`, `WS_WANT_READ`, `WS_WANT_WRITE`, or another error

**See Also**

- `wolfSSH_stream_send()`
- `wolfSSH_extended_data_read()`
- `wolfSSH_ChannelIdRead()`
- `wolfSSH_accept()`

### wolfSSH_stream_send()



```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_send(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Writes `bufSz` bytes from `buf` to the SSH stream data buffer.

wolfSSH_stream_send() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking and cannot send all pending data, a call to wolfSSH_get_error() yields `WS_WANT_READ` or `WS_WANT_WRITE`, and the caller repeats the call when the socket is ready to send. If the underlying I/O is blocking, the call returns only once the data has been sent or an error occurred. If the error is not want-read/want-write (for example `WS_REKEYING`), call wolfSSH_worker() until the internal SSH processing completes.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes written on success
- `WS_BAD_ARGUMENT`
- `WS_EOF` - this side already sent EOF on the channel
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - check wolfSSH_get_error(), which reports `WS_REKEYING` during a key exchange or `WS_DISCONNECT` once the session has disconnected

**See Also**

- `wolfSSH_stream_read()`
- `wolfSSH_stream_send_eof()`
- `wolfSSH_accept()`


### wolfSSH_stream_send_eof()

```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_send_eof(WOLFSSH* ssh);
```

**Description**

Half-closes the first channel in the session's channel list by sending SSH_MSG_CHANNEL_EOF, as wolfSSH_ChannelSendEof() does for a named channel. Data sends on the channel then fail with `WS_EOF`; reads keep working until the peer sends its own EOF or closes the channel. A second call puts no second EOF on the wire. Unlike wolfSSH_stream_send(), which returns `WS_FATAL_ERROR` with the cause latched, this call reports `WS_REKEYING` itself during a key exchange.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` is NULL, or there is no channel
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_REKEYING` - a key exchange is in progress; try again after it completes
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- a send-path status such as `WS_WANT_WRITE`

**See Also**

- `wolfSSH_ChannelSendEof()`
- `wolfSSH_stream_send()`
- `wolfSSH_ChannelGetEof()`

### wolfSSH_stream_exit()


```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_exit(WOLFSSH* ssh, int status);
```

**Description**

Exits the SSH stream, sending the given exit status to the peer and closing the channel.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `status` - the exit status to report to the peer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` is NULL, or there is no channel
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_stream_send()`

### wolfSSH_TriggerKeyExchange()


```c
#include <wolfssh/ssh.h>

int wolfSSH_TriggerKeyExchange(WOLFSSH* ssh);
```

**Description**

Triggers the key exchange (rekey) process by preparing and sending an SSH_MSG_KEXINIT. A successful start leaves the session's error state alone; only a failure records its code there for wolfSSH_get_error().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- other negative error codes, including `WS_WANT_WRITE`, from sending the KEXINIT

**See Also**

- `wolfSSH_worker()`
- `wolfSSH_RekeyPending()`

### wolfSSH_stream_peek()

```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_peek(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Copies up to `bufSz` bytes of pending decrypted data from the first channel into `buf` without removing them from the internal buffer. A subsequent wolfSSH_stream_read() will return the same data. If `buf` is NULL, only the count of available bytes (capped at `bufSz`) is returned. An EOF from the peer is reported only once the buffered data has been read. After a disconnect, buffered data can still be peeked; once the buffer is empty the call fails with `WS_DISCONNECT` in wolfSSH_get_error().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer where the peeked data is placed, or NULL
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes copied (or available, if `buf` is NULL)
- `WS_BAD_ARGUMENT` - `ssh` is NULL, or there is no channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_ERROR` - the buffer is empty and the peer sent EOF (wolfSSH_get_error() reports `WS_EOF`)
- `WS_FATAL_ERROR` - the buffer is empty and the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_stream_read()`
- `wolfSSH_ChannelIdPeek()`

### wolfSSH_extended_data_send()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_send(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Sends `bufSz` bytes as extended channel data (the stderr data type) on the first channel in the session's channel list. To send on another channel, use wolfSSH_ChannelIdSendExt().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_EOF` - this side already sent EOF on the channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_extended_data_read()`

### wolfSSH_extended_data_read()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_read(WOLFSSH* ssh, byte* out, word32 outSz);
```

**Description**

Reads up to `outSz` bytes of buffered extended data (stderr) from the first channel in the session's channel list into `out`. This is the stderr counterpart of wolfSSH_stream_read(), and reads the same channel.

Applications must drain stderr: it shares the channel receive window with normal data (RFC 4254 section 5.2), and the window is only replenished as the data is read, so unread stderr eventually stalls the channel. Call this after wolfSSH_stream_read() returns `WS_EXTDATA`, until it returns 0. For other channels, use wolfSSH_ChannelIdReadExt(); wolfSSH_worker() names the channel the extended data arrived on when it returns `WS_EXTDATA`.

Draining sends the peer a window adjust. On a non-blocking socket that send can be short: the byte count is still returned, but wolfSSH_get_error() is left at `WS_WANT_WRITE` to show a flush is owed. An application that only reads must then flush with wolfSSH_worker(), or the peer's window is never replenished. The buffer belongs to the channel, so anything unread when the channel is removed is discarded with it.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `out` - buffer where the data is placed
- `outSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT` - `ssh` or `out` is NULL, `outSz` is 0, or there is no channel
- `WS_INVALID_STATE_E`

**See Also**

- `wolfSSH_extended_data_send()`
- `wolfSSH_ChannelIdReadExt()`
- `wolfSSH_ChannelReadExt()`

### wolfSSH_SendIgnore()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendIgnore(WOLFSSH* ssh, const byte* buf, word32 bufSz);
```

**Description**

Sends an SSH_MSG_IGNORE message to the peer. The peer discards the contents; this can be used as a keepalive or for traffic-analysis resistance. The `buf` and `bufSz` arguments are currently unused: the message always carries 128 zero bytes.

When strict key exchange is offered, an IGNORE sent before the initial key exchange completes would make a strict peer end the connection, so the call is refused with `WS_INVALID_STATE_E` until then.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - payload (currently unused)
- `bufSz` - size of the payload (currently unused)

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_INVALID_STATE_E` - strict KEX is offered and the initial key exchange has not completed
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

### wolfSSH_SendDisconnect()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendDisconnect(WOLFSSH* ssh, word32 reason);
```

**Description**

Sends an SSH_MSG_DISCONNECT message to the peer with the given reason code (see the `WS_DisconnectReasonCodes` values).

A disconnect, sent or received, ends the session (RFC 4253 section 11.1). From then on wolfSSH_shutdown(), the send calls, wolfSSH_accept(), wolfSSH_connect() and wolfSSH_worker() report `WS_DISCONNECT`, inbound messages other than a disconnect are dropped, and the channel callbacks stop firing. Channel data that arrived before the disconnect can still be read.

One disconnect ends the session, so a second call fails with `WS_DISCONNECT`. The exception is a disconnect of this side's own left queued by a short non-blocking send: while it is still queued, calling again retries the flush. wolfSSH_shutdown() retries it too.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `reason` - disconnect reason code

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_WANT_WRITE` - the message is queued; call again to flush it
- `WS_FATAL_ERROR` - the session already disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_shutdown()`

### wolfSSH_global_request()

```c
#include <wolfssh/ssh.h>

int wolfSSH_global_request(WOLFSSH* ssh, const unsigned char* data,
        word32 dataSz, int reply);
```

**Description**

Sends a global request (SSH_MSG_GLOBAL_REQUEST) to the peer, using `data` as the request name. If `reply` is 1, the peer is asked to reply with success or failure. The request-specific data that RFC 4254 section 7.1 places after the want-reply boolean cannot be carried by this call, so requests that need it have their own calls, such as wolfSSH_FwdRemoteSetup(). Replies carry no request ID, so in a `WOLFSSH_FWD` build a request sent with `reply` set takes its place in the same send-order queue that wolfSSH_FwdRemoteSetup() uses.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `data` - request name
- `dataSz` - size of the request name
- `reply` - 1 to request a reply from the peer, 0 otherwise

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` or `data` is NULL, or `reply` is not 0 or 1
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- other negative error codes from the send path

### wolfSSH_ChannelIdRead()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdRead(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of buffered data from the channel identified by `channelId`, with the contract of wolfSSH_ChannelRead(): it drains what is already buffered, returning 0 when the buffer is empty, and never receives from the transport or reports EOF. Unlike wolfSSH_ChannelRead(), it also reads during a key exchange. Call wolfSSH_worker() to receive more data.

The read credits the channel window and sends the peer a window adjust. The byte count is returned even when that adjust cannot go out; check wolfSSH_get_error() after the call, where `WS_WANT_WRITE` means the adjust is queued.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to read from
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT`
- `WS_INVALID_CHANID` - no channel has that ID
- `WS_INVALID_STATE_E`

**See Also**

- `wolfSSH_ChannelIdSend()`
- `wolfSSH_ChannelIdPeek()`
- `wolfSSH_ChannelIdReadExt()`

### wolfSSH_ChannelIdPeek()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdPeek(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Copies up to `bufSz` bytes of buffered data from the channel identified by `channelId` into `buf` without consuming them, with the contract of wolfSSH_stream_peek(), except that it also peeks during a key exchange. If `buf` is NULL, only the count of available bytes (capped at `bufSz`) is returned.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to peek
- `buf` - buffer where the peeked data is placed, or NULL
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes copied (or available, if `buf` is NULL)
- `WS_BAD_ARGUMENT` - `ssh` is NULL
- `WS_INVALID_CHANID` - no channel has that ID
- `WS_ERROR` - the buffer is empty and the peer sent EOF (wolfSSH_get_error() reports `WS_EOF`)
- `WS_FATAL_ERROR` - the buffer is empty and the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelIdRead()`
- `wolfSSH_stream_peek()`

### wolfSSH_ChannelIdSend()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdSend(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Sends `bufSz` bytes on the channel identified by `channelId`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to send on
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_INVALID_CHANID` - no channel has that ID
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_EOF` - this side already sent EOF on the channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelIdRead()`
- `wolfSSH_ChannelIdSendExt()`

### wolfSSH_ChannelIdReadExt()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdReadExt(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of buffered extended data (stderr) from the channel identified by `channelId`. This has the drain contract of wolfSSH_extended_data_read(), but reads the named channel instead of the first one in the channel list. Each channel's stderr must be drained, since it shares the channel receive window with normal data; wolfSSH_worker() names the channel when it returns `WS_EXTDATA`. The byte count is returned even when the window adjust cannot go out; wolfSSH_get_error() then reports the adjust's status, such as `WS_WANT_WRITE`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to read from
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT` - `ssh` or `buf` is NULL, or `bufSz` is 0
- `WS_INVALID_CHANID` - no channel has that ID
- `WS_INVALID_STATE_E`

**See Also**

- `wolfSSH_ChannelIdSendExt()`
- `wolfSSH_extended_data_read()`
- `wolfSSH_ChannelReadExt()`

### wolfSSH_ChannelIdSendExt()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdSendExt(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Sends `bufSz` bytes as extended data (the stderr data type) on the channel identified by `channelId`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to send on
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_INVALID_CHANID` - no channel has that ID
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_EOF` - this side already sent EOF on the channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelIdReadExt()`
- `wolfSSH_extended_data_send()`
- `wolfSSH_ChannelSendExt()`

### wolfSSH_CTX_SetSshProtoIdStr()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetSshProtoIdStr(WOLFSSH_CTX* ctx, const char* protoIdStr);
```

**Description**

Overrides the SSH protocol identification string that is sent to the peer during the version exchange at the start of the connection. The string is validated and rejected with `WS_BAD_ARGUMENT`, leaving the context unchanged, unless it:

- begins with "SSH-2.0-"
- is between 11 and 255 bytes long, counting the "SSH-2.0-" prefix and the trailing CR LF
- ends with CR LF (`"\r\n"`)
- carries only printable US-ASCII (0x20 to 0x7e) in the body, which rules out an embedded CR or LF
- does not begin the body with a space (RFC 4253 section 4.2 reads the body as softwareversion followed by optional comments, so a leading space would make softwareversion empty; a space later in the body starts the comments)

The string is stored by reference, not copied, so it must remain valid and unmodified for the lifetime of the context. It is validated only when set.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `protoIdStr` - the protocol identification string to send, including the trailing CR LF

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_CTX_SetWindowPacketSize()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetWindowPacketSize(WOLFSSH_CTX* ctx,
        word32 windowSz, word32 maxPacketSz);
```

**Description**

Sets the default channel window size and maximum packet size for sessions created from this context. A `windowSz` of 0 selects the default (`DEFAULT_WINDOW_SZ`, 128 KB), and the window may not exceed 256 KB (`WINDOW_SZ_UPPER_BOUND`). A `maxPacketSz` of 0 selects the default (`DEFAULT_MAX_PACKET_SZ`, 32768), and the packet size may not exceed `MAX_PACKET_SZ` less the channel data packet overhead.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `windowSz` - the channel window size, in bytes, or 0 for the default
- `maxPacketSz` - the maximum packet size, in bytes, or 0 for the default

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` is NULL, or a size is over its limit

## Channel Callbacks

Interfaces to the wolfSSH library return single int values. Communicating
status of asynchronous information, like the peer opening a channel, isn't
easy with that interface. wolfSSH uses callback functions to notify the
calling application of changes in state of a channel.

There are callback functions for receipt of the following SSHv2 protocol
messages:

* SSH_MSG_CHANNEL_OPEN
* SSH_MSG_CHANNEL_OPEN_CONFIRMATION
* SSH_MSG_CHANNEL_OPEN_FAILURE
* SSH_MSG_CHANNEL_REQUEST
  - "shell"
  - "subsystem"
  - "exec"
  - any request type, through the request policy callback set with
    wolfSSH_CTX_SetChannelReqAnyCb()
* SSH_MSG_CHANNEL_EOF
* SSH_MSG_CHANNEL_CLOSE

### Callback Function Prototypes

The channel callback functions all take a pointer to a **WOLFSSH_CHANNEL**
object, _channel_, and a pointer to the application defined data structure,
_ctx_. Properties about the channel may be queried using API functions.

```
typedef int (*WS_CallbackChannelOpen)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelReq)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelEof)(WOLFSSH_CHANNEL* channel, void* ctx);
typedef int (*WS_CallbackChannelClose)(WOLFSSH_CHANNEL* channel, void* ctx);
```

The request policy callback has its own prototype, which also receives the
request type and its type-specific data, and returns one of the
`WS_ReqCbResult` values. The global request policy callback (see
wolfSSH_CTX_SetGlobalReqAnyCb()) uses the same result values.

```
typedef enum WS_ReqCbResult {
    WOLFSSH_REQ_UNHANDLED = 0,
    WOLFSSH_REQ_ACCEPT,
    WOLFSSH_REQ_REJECT
} WS_ReqCbResult;

typedef int (*WS_CallbackChannelReqAny)(WOLFSSH_CHANNEL* channel,
        const byte* type, word32 typeSz, const byte* data, word32 dataSz,
        int wantReply, void* ctx);
```

Note that 0 is `WOLFSSH_REQ_UNHANDLED` here, where the shell, subsystem and
exec request callbacks read a 0 return as acceptance. A callback of this
family returns one of the three `WS_ReqCbResult` values, not `WS_SUCCESS`.

### wolfSSH_CTX_SetChannelOpenCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelOpenCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen cb);
```

**Description**

Sets the callback invoked when a Channel Open (SSH_MSG_CHANNEL_OPEN) message is received from the peer. This is the policy callback for peer channel opens: when no callback is registered, every channel open from the peer is accepted by default, except the forwarding channel types, which are refused without a forwarding callback (see wolfSSH_CTX_SetFwdCb()). A client refuses a "session" channel open from a server outright, ahead of this callback. Register a callback to enforce a channel policy.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel open callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_SetChannelOpenCtx()`


### wolfSSH_CTX_SetChannelOpenRespCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelOpenRespCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen confCb, WS_CallbackChannelOpen failCb);
```

**Description**

Sets the callbacks invoked when a Channel Open Confirmation (SSH_MSG_CHANNEL_OPEN_CONFIRMATION) or a Channel Open Failure (SSH_MSG_CHANNEL_OPEN_FAILURE) message is received from the peer.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `confCb` - callback for a channel open confirmation
- `failCb` - callback for a channel open failure

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelOpenCb()`


### wolfSSH_CTX_SetChannelReqShellCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqShellCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback invoked when a Channel Request (SSH_MSG_CHANNEL_REQUEST) message is received from the peer for a _shell_.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel request callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelReqExecCb()`


### wolfSSH_CTX_SetChannelReqSubsysCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqSubsysCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback invoked when a Channel Request (SSH_MSG_CHANNEL_REQUEST) message is received from the peer for a _subsystem_. A common example of a subsystem is SFTP.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel request callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelReqShellCb()`


### wolfSSH_CTX_SetChannelReqExecCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqExecCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback invoked when a Channel Request (SSH_MSG_CHANNEL_REQUEST) message is received from the peer for a command to _exec_.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel request callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelReqShellCb()`


### wolfSSH_CTX_SetChannelReqAnyCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelReqAnyCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReqAny cb);
```

**Description**

Sets a policy callback consulted first for every Channel Request (SSH_MSG_CHANNEL_REQUEST) from the peer, ahead of the shell, exec and subsystem callbacks and of the built-in handling. A request with no callback of its own -- env, pty-req, window-change, exit-status, auth-agent-req, or a type the library does not know -- can then be granted or refused by policy.

`type` is the request name as it arrived, `typeSz` bytes, and `data` is the request's type-specific part, `dataSz` bytes, for the callback to parse. Neither is NUL terminated, and a name may hold any byte, so match on `typeSz` bytes rather than with the string functions. `wantReply` is what the peer asked for. The callback shares the channel request context set with wolfSSH_SetChannelReqCtx().

The callback returns a `WS_ReqCbResult`. `WOLFSSH_REQ_UNHANDLED` (0, and what a missing callback answers) leaves the request to the other callbacks and the built-in handling. `WOLFSSH_REQ_ACCEPT` and `WOLFSSH_REQ_REJECT` settle the request, and the shell, exec and subsystem callbacks are not consulted. The library still parses and records what it needs from a request it knows, so an accepted session request sets the channel's session type and the modes of an accepted pty-req are kept; a request that does not fit its type is refused whatever the callback says. A type the library does not know is answered with CHANNEL_SUCCESS on `WOLFSSH_REQ_ACCEPT`, where it is otherwise refused.

The callback may free the channel it was handed with wolfSSH_ChannelFree(); the request ends there, and one wanting a reply fails with `WS_INVALID_CHANID`. `type` and `data` point into the session's input buffer and are valid only for the length of the call, so a callback keeping either must copy it. The callback must not re-enter the receive side of the library on this session (wolfSSH_worker(), wolfSSH_stream_read(), wolfSSH_accept(), or the SFTP calls).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel request policy callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_SetChannelReqCtx()`
- `wolfSSH_CTX_SetChannelReqShellCb()`
- `wolfSSH_CTX_SetGlobalReqAnyCb()`


### wolfSSH_CTX_SetAppChannels()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetAppChannels(WOLFSSH_CTX* ctx, byte enable);
```

**Description**

Enables or disables application-driven channel handling on the server side for sessions created from this context. It is off by default.

When off, wolfSSH_accept() runs the session state machine through to an established session with the first channel open, and a shell, exec, or subsystem request with no callback registered for it is accepted.

When on, wolfSSH_accept() returns `WS_SUCCESS` as soon as the user has authenticated, and the application owns every channel from there, driving the session with wolfSSH_worker() and the channel callbacks. A shell, exec, or subsystem request with no callback registered is then rejected. wolfSSH_accept() never reaches the built-in SCP entry point in this mode, so it does not return `WS_SCP_INIT`. wolfSSH_SFTP_accept() still serves, but only on a session channel whose "sftp" subsystem request the subsystem callback granted; called ahead of that, it returns `WS_INVALID_STATE_E`.

Set this on the context before wolfSSH_new(), or on a session with wolfSSH_SetAppChannels() before the first wolfSSH_accept() call.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `enable` - non-zero to enable application-driven channels, 0 to disable

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_SetAppChannels()`
- `wolfSSH_accept()`
- `wolfSSH_ChannelGetSessionGranted()`


### wolfSSH_SetAppChannels()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetAppChannels(WOLFSSH* ssh, byte enable);
```

**Description**

Enables or disables application-driven channel handling for one session, overriding the setting inherited from its context. See wolfSSH_CTX_SetAppChannels(). Set it before the first wolfSSH_accept() call. Turning it on later still applies to the channel requests that follow, but cannot move where wolfSSH_accept() returns on a session that has already gone past user authentication.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `enable` - non-zero to enable application-driven channels, 0 to disable

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**See Also**

- `wolfSSH_CTX_SetAppChannels()`

### wolfSSH_CTX_SetChannelEofCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelEofCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelEof cb);
```

**Description**

Sets the callback invoked when a Channel EOF (SSH_MSG_CHANNEL_EOF) message is received from the peer, indicating the peer will not transmit any more data on this channel. The channel stays open for sending. The library never answers a received EOF with one of its own; the application decides whether to reply, with wolfSSH_ChannelSendEof() or wolfSSH_stream_send_eof().

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel EOF callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelCloseCb()`


### wolfSSH_CTX_SetChannelCloseCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelCloseCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelClose cb);
```

**Description**

Sets the callback invoked when a Channel Close (SSH_MSG_CHANNEL_CLOSE) message is received from the peer, indicating the peer wants to terminate this channel.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the channel close callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_CTX_SetChannelEofCb()`


### wolfSSH_SetChannelOpenCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelOpenCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context passed to the channel open, channel open confirmation, and channel open failure callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context to pass to the channel open callbacks

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**See Also**

- `wolfSSH_GetChannelOpenCtx()`


### wolfSSH_SetChannelReqCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelReqCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context passed to the channel request (shell/exec/subsystem) callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context to pass to the channel request callbacks

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**See Also**

- `wolfSSH_GetChannelReqCtx()`


### wolfSSH_SetChannelEofCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelEofCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context passed to the channel EOF callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context to pass to the channel EOF callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**See Also**

- `wolfSSH_GetChannelEofCtx()`


### wolfSSH_SetChannelCloseCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelCloseCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context passed to the channel close callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context to pass to the channel close callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_NULL_E`

**See Also**

- `wolfSSH_GetChannelCloseCtx()`


### wolfSSH_GetChannelOpenCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelOpenCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context previously set with wolfSSH_SetChannelOpenCtx() for the channel open callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the channel open context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetChannelOpenCtx()`


### wolfSSH_GetChannelReqCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelReqCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context previously set with wolfSSH_SetChannelReqCtx() for the channel request callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the channel request context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetChannelReqCtx()`


### wolfSSH_GetChannelEofCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelEofCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context previously set with wolfSSH_SetChannelEofCtx() for the channel EOF callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the channel EOF context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetChannelEofCtx()`


### wolfSSH_GetChannelCloseCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetChannelCloseCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context previously set with wolfSSH_SetChannelCloseCtx() for the channel close callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the channel close context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetChannelCloseCtx()`


## Channel Functions

These functions operate directly on `WOLFSSH_CHANNEL` objects, which represent the individual channels multiplexed over an SSH session.

### wolfSSH_ChannelGetSessionType()

```c
#include <wolfssh/ssh.h>

WS_SessionType wolfSSH_ChannelGetSessionType(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns the `WS_SessionType` (shell, exec, subsystem, terminal, or unknown) for the specified channel.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- the channel's `WS_SessionType`

**See Also**

- `wolfSSH_ChannelGetSessionCommand()`


### wolfSSH_ChannelGetSessionCommand()

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ChannelGetSessionCommand(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns the command the peer requested to execute over the specified channel (for an "exec" request), or the subsystem name (for a "subsystem" request). Use wolfSSH_ChannelGetSessionCommandSz() for its recorded length.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- pointer to the command string, or `NULL` if none

**See Also**

- `wolfSSH_ChannelGetSessionType()`
- `wolfSSH_ChannelGetSessionCommandSz()`

### wolfSSH_ChannelGetSessionCommandSz()

```c
#include <wolfssh/ssh.h>

word32 wolfSSH_ChannelGetSessionCommandSz(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns the recorded length, in bytes, of the command or subsystem name returned by wolfSSH_ChannelGetSessionCommand(). A peer-supplied command may contain a NUL byte, so compare this length against the string length when the distinction matters.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- the length of the session command, or 0 if there is none or `channel` is NULL

**See Also**

- `wolfSSH_ChannelGetSessionCommand()`

### wolfSSH_ChannelGetSessionGranted()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetSessionGranted(const WOLFSSH_CHANNEL* channel);
```

**Description**

Reports whether a shell, exec, or subsystem request on the channel has been answered with CHANNEL_SUCCESS. A session request callback sees this still clear for the request it is answering, so a set flag there means an earlier request was granted.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- 1 - a session request on the channel has been granted
- 0 - none has been granted
- `WS_BAD_ARGUMENT` - `channel` is NULL

**See Also**

- `wolfSSH_ChannelGetSessionType()`
- `wolfSSH_CTX_SetAppChannels()`
- `wolfSSH_ChannelCommandIsScp()`

### wolfSSH_ChannelFree()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelFree(WOLFSSH_CHANNEL* channel);
```

**Description**

Frees a channel object and removes it from its session.

**Parameters**

- `channel` - pointer to the channel to free

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetId()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetId(WOLFSSH_CHANNEL* channel, word32* id, byte peer);
```

**Description**

Retrieves the numeric channel ID for the given channel. Set `peer` to `WS_CHANNEL_ID_SELF` for this side's ID or `WS_CHANNEL_ID_PEER` for the peer's ID.

**Parameters**

- `channel` - pointer to the channel
- `id` - output for the channel ID
- `peer` - `WS_CHANNEL_ID_SELF` or `WS_CHANNEL_ID_PEER`

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_ChannelFind()`

### wolfSSH_ChannelFind()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFind(WOLFSSH* ssh, word32 id, byte peer);
```

**Description**

Finds the channel on the session matching the given ID. Set `peer` to `WS_CHANNEL_ID_SELF` to match this side's ID or `WS_CHANNEL_ID_PEER` to match the peer's ID.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `id` - the channel ID to find
- `peer` - `WS_CHANNEL_ID_SELF` or `WS_CHANNEL_ID_PEER`

**Return Values**

- pointer to the matching channel, or `NULL` if not found

**See Also**

- `wolfSSH_ChannelNext()`

### wolfSSH_ChannelNext()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelNext(WOLFSSH* ssh, WOLFSSH_CHANNEL* channel);
```

**Description**

Iterates the channels on a session. Pass `NULL` for `channel` to get the first channel; pass a channel to get the one after it.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channel` - the current channel, or `NULL` to start iteration

**Return Values**

- pointer to the next channel, or `NULL` at the end of the list

**See Also**

- `wolfSSH_ChannelFind()`

### wolfSSH_ChannelRead()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelRead(WOLFSSH_CHANNEL* channel, byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of buffered data from the given channel. It drains only what is already buffered, returning 0 when the buffer is empty; it never receives from the transport and never reports EOF. Call wolfSSH_worker() to receive more data.

The read credits the channel window and sends the peer a window adjust, as wolfSSH_stream_read() does. It does not clear the session's error state on entry, so check wolfSSH_get_error() after the call: `WS_WANT_WRITE` there means the adjust is queued, while the byte count is still returned.

**Parameters**

- `channel` - pointer to the channel
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT`
- `WS_REKEYING` - a key exchange is in progress (wolfSSH_ChannelIdRead() reads during one)
- `WS_INVALID_STATE_E`

**See Also**

- `wolfSSH_ChannelSend()`
- `wolfSSH_ChannelReadExt()`
- `wolfSSH_ChannelIdRead()`

### wolfSSH_ChannelReadExt()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelReadExt(WOLFSSH_CHANNEL* channel, byte* buf,
        word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of buffered extended data (stderr) from the given channel. This has the drain contract of wolfSSH_extended_data_read(), but reads the named channel. Unlike wolfSSH_ChannelRead(), it does not fail with `WS_REKEYING` during a key exchange: the data is already buffered, and the window credit the read owes is held until the key exchange completes.

**Parameters**

- `channel` - pointer to the channel
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT` - `channel` or `buf` is NULL, or `bufSz` is 0
- `WS_INVALID_STATE_E`

**See Also**

- `wolfSSH_ChannelSendExt()`
- `wolfSSH_ChannelIdReadExt()`
- `wolfSSH_extended_data_read()`

### wolfSSH_ChannelSend()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSend(WOLFSSH_CHANNEL* channel, const byte* buf,
        word32 bufSz);
```

**Description**

Sends `bufSz` bytes on the given channel.

**Parameters**

- `channel` - pointer to the channel
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_EOF` - this side already sent EOF on the channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelRead()`
- `wolfSSH_ChannelSendExt()`

### wolfSSH_ChannelSendExt()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSendExt(WOLFSSH_CHANNEL* channel,
        const byte* buf, word32 bufSz);
```

**Description**

Sends `bufSz` bytes as extended data (the stderr data type) on the given channel.

**Parameters**

- `channel` - pointer to the channel
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_EOF` - this side already sent EOF on the channel
- `WS_REKEYING` - a key exchange is in progress
- `WS_WINDOW_FULL` - the peer's channel window is full
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelReadExt()`
- `wolfSSH_ChannelIdSendExt()`

### wolfSSH_ChannelExit()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelExit(WOLFSSH_CHANNEL* channel);
```

**Description**

Closes the given channel, sending SSH_MSG_CHANNEL_EOF and then SSH_MSG_CHANNEL_CLOSE to the peer. The channel stays on the session's channel list, and the channel pointer stays valid, until the peer's close arrives and wolfSSH_worker() reports `WS_CHANNEL_CLOSED`. A walk with wolfSSH_ChannelNext() has to step past a channel it has exited rather than re-read the head of the list.

`WS_WANT_WRITE` means the teardown is incomplete: the close is built only once the EOF is sent, so call again until the result is something else. Retrying does not send a second EOF. `WS_SUCCESS` means both messages are queued, not that they reached the peer. A peer that never answers leaves the channel on the list for the life of the session.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open, so there is no peer channel ID to address
- `WS_WANT_WRITE` - call again to complete the teardown
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_ChannelSendEof()`
- `wolfSSH_worker()`

### wolfSSH_ChannelSendEof()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSendEof(WOLFSSH_CHANNEL* channel);
```

**Description**

Sends SSH_MSG_CHANNEL_EOF on the given channel, closing the sending direction and leaving the receiving direction open (the half-close of RFC 4254 section 5.3). Data sends on the channel then fail with `WS_EOF` -- wolfSSH_ChannelSend(), wolfSSH_stream_send() and the extended data variants -- while requests, the exit status and the teardown messages still go out. Reads work until the peer sends its own EOF or closes the channel. The call is idempotent: a second call puts no second EOF on the wire.

The library never answers a received EOF with one of its own. It reports it as `WS_EOF` and through the channel EOF callback, and the application decides whether to reply with this call or wolfSSH_stream_send_eof(). wolfSSH_ChannelExit() and wolfSSH_shutdown() send an EOF themselves while tearing the channel down.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `channel` is NULL
- `WS_CHANNEL_NOT_CONF` - the peer has not confirmed the channel open yet
- `WS_REKEYING` - a key exchange is in progress
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- a send-path status such as `WS_WANT_WRITE`

**See Also**

- `wolfSSH_stream_send_eof()`
- `wolfSSH_ChannelGetEof()`
- `wolfSSH_ChannelExit()`

### wolfSSH_ChannelGetEof()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetEof(WOLFSSH_CHANNEL* channel);
```

**Description**

Reports whether the peer has sent EOF on the given channel. wolfSSH_worker() reports a received EOF as `WS_EOF` only once, on arrival; this call is the durable check.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- 1 - the channel has received EOF
- 0 - the channel has not received EOF

### wolfSSH_ChannelGetType()

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_ChannelGetType(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns the channel type string (for example, "session") for the given channel.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- pointer to the channel type string, or `NULL` if none

### wolfSSH_ChannelIsPty()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIsPty(const WOLFSSH_CHANNEL* channel);
```

**Description**

Reports whether the given channel has an associated pseudo-terminal (PTY).

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- 1 - the channel has a PTY
- 0 - the channel does not have a PTY


##  Testing Functions


### wolfSSH_GetStats()


```c
#include <wolfssh/ssh.h>

void wolfSSH_GetStats(WOLFSSH* ssh, word32* txCount, word32* rxCount,
        word32* seq, word32* peerSeq);
```

**Description**

Writes the session's transfer statistics into the provided output pointers.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `txCount` - output for the total bytes transmitted on the session
- `rxCount` - output for the total bytes received on the session
- `seq` - output for the outgoing packet sequence number
- `peerSeq` - output for the peer's packet sequence number

**Return Values**

None

### wolfSSH_KDF()


```c
#include <wolfssh/ssh.h>

int wolfSSH_KDF(byte hashId, byte keyId, byte* key, word32 keySz,
        const byte* k, word32 kSz, const byte* h, word32 hSz,
        const byte* sessionId, word32 sessionIdSz);
```

**Description**

Runs the SSH key derivation function. It derives a symmetric key from the source keying material `k` (the Diffie-Hellman shared secret) and `h` (the exchange hash produced during key exchange). The particular key produced is selected by `keyId`. This function is primarily exposed so the test suite can run known-answer tests against the key derivation.

The `keyId` values are:

```
A - initial IV, client to server
B - initial IV, server to client
C - encryption key, client to server
D - encryption key, server to client
E - integrity key, client to server
F - integrity key, server to client
```

**Parameters**

- `hashId` - the hash type used to derive keying material (for example, `WC_HASH_TYPE_SHA` or `WC_HASH_TYPE_SHA256`)
- `keyId` - which key to derive (A through F, as above)
- `key` - output buffer for the derived key
- `keySz` - size of the output key buffer
- `k` - the Diffie-Hellman shared secret
- `kSz` - size of `k`
- `h` - the exchange hash
- `hSz` - size of `h`
- `sessionId` - the session identifier
- `sessionIdSz` - size of the session identifier

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_CRYPTO_FAILED`

### wolfSSH_ShowSizes()

```c
#include <wolfssh/ssh.h>

void wolfSSH_ShowSizes(void);
```

**Description**

Prints the sizes of wolfSSH's internal data structures. This is a diagnostic aid, useful for tuning memory use on constrained targets.

**Parameters**

None

**Return Values**

None


##  Session Functions



### wolfSSH_GetSessionType()


```c
#include <wolfssh/ssh.h>

WS_SessionType wolfSSH_GetSessionType(const WOLFSSH* ssh);
```

**Description**

Returns the session type for the session's channel: one of `WOLFSSH_SESSION_UNKNOWN`, `WOLFSSH_SESSION_SHELL`, `WOLFSSH_SESSION_EXEC`, `WOLFSSH_SESSION_SUBSYSTEM`, or `WOLFSSH_SESSION_TERMINAL`.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the session's `WS_SessionType`

**See Also**

- `wolfSSH_GetSessionCommand()`

### wolfSSH_GetSessionCommand()


```c
#include <wolfssh/ssh.h>

const char* wolfSSH_GetSessionCommand(const WOLFSSH* ssh);
```

**Description**

Returns the command the peer requested to run for this session (for an "exec" request), or the subsystem name, taken from the first channel in the session's channel list. Use wolfSSH_GetSessionCommandSz() for its recorded length.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the command string, or `NULL` if none

**See Also**

- `wolfSSH_GetSessionType()`
- `wolfSSH_GetSessionCommandSz()`

### wolfSSH_GetSessionCommandSz()

```c
#include <wolfssh/ssh.h>

word32 wolfSSH_GetSessionCommandSz(const WOLFSSH* ssh);
```

**Description**

Returns the recorded length, in bytes, of the command returned by wolfSSH_GetSessionCommand(), taken from the first channel in the session's channel list.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the length of the session command, or 0 if there is none or `ssh` is NULL

**See Also**

- `wolfSSH_GetSessionCommand()`
- `wolfSSH_ChannelGetSessionCommandSz()`

### wolfSSH_SetChannelType()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelType(WOLFSSH* ssh, byte type, byte* name,
        word32 nameSz);
```

**Description**

Sets the channel request type (for example, shell, exec, or subsystem) and optional name for the session's channel. Exec and subsystem carry a name string the peer requires, so one must be available: passing no name keeps the name an earlier call stored, and with nothing stored the call is refused. Shell and terminal take no name and drop any stored one. A refused call changes nothing, the selected type included.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `type` - the channel request type
- `name` - the command or subsystem name for exec or subsystem, or NULL to keep a stored one
- `nameSz` - length of `name`

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` is NULL, `type` is unknown, exec is requested on the server side, `name` is `WOLFSSH_MAX_CHN_NAMESZ` bytes or longer, `nameSz` is given with no `name`, or exec or subsystem has no name given and none stored
- `WS_MEMORY_E` - the name cannot be allocated

### wolfSSH_ChangeTerminalSize()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChangeTerminalSize(WOLFSSH* ssh, word32 columns,
        word32 rows, word32 widthPixels, word32 heightPixels);
```

**Description**

Notifies the peer that the terminal (window) size has changed, sending the new dimensions.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `columns` - the new width in character columns
- `rows` - the new height in character rows
- `widthPixels` - the new width in pixels
- `heightPixels` - the new height in pixels

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)

**See Also**

- `wolfSSH_SetTerminalResizeCb()`

### wolfSSH_SetTerminalResizeCb()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTerminalResizeCb(WOLFSSH* ssh, WS_CallbackTerminalSize cb);
```

**Description**

Registers a callback that is invoked when the peer reports a terminal size change.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `cb` - the terminal resize callback

**Return Values**

None

**See Also**

- `wolfSSH_SetTerminalResizeCtx()`

### wolfSSH_SetTerminalResizeCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTerminalResizeCtx(WOLFSSH* ssh, void* usrCtx);
```

**Description**

Sets the user context pointer passed to the terminal resize callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `usrCtx` - user context pointer to pass to the callback

**Return Values**

None

### wolfSSH_GetExitStatus()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetExitStatus(WOLFSSH* ssh);
```

**Description**

Returns the exit status the peer reported for the session's command.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the exit status reported by the peer

**See Also**

- `wolfSSH_SetExitStatus()`

### wolfSSH_SetExitStatus()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetExitStatus(WOLFSSH* ssh, word32 exitStatus);
```

**Description**

Sets the exit status to report to the peer for the session's command.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `exitStatus` - the exit status to report

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_GetExitStatus()`

### wolfSSH_DoModes()

```c
#include <wolfssh/ssh.h>

int wolfSSH_DoModes(const byte* modes, word32 modesSz, int fd);
```

**Description**

Applies the SSH-encoded terminal modes in `modes` to the terminal referenced by the file descriptor `fd`.

**Parameters**

- `modes` - buffer of SSH-encoded terminal modes
- `modesSz` - length of the modes buffer
- `fd` - file descriptor of the terminal to configure

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ConvertConsole()

**Availability**

Available only on Windows builds (`USE_WINDOWS_API`).

```c
#include <wolfssh/ssh.h>

int wolfSSH_ConvertConsole(WOLFSSH* ssh, WOLFSSH_HANDLE handle,
        byte* buf, word32 bufSz);
```

**Description**

Processes console data read from the Windows console handle, translating it for the SSH stream.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `handle` - the Windows console handle
- `buf` - buffer of console data to convert
- `bufSz` - length of the buffer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_SetKeyingCompletionCb()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetKeyingCompletionCb(WOLFSSH_CTX* ctx,
        WS_CallbackKeyingCompletion cb);
```

**Description**

Registers a callback that is invoked when a key exchange (initial or rekey) completes.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the keying completion callback

**Return Values**

None

**See Also**

- `wolfSSH_SetKeyingCompletionCbCtx()`

### wolfSSH_SetKeyingCompletionCbCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetKeyingCompletionCbCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the keying completion callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the callback

**Return Values**

None

### wolfSSH_RealPath()

```c
#include <wolfssh/ssh.h>

int wolfSSH_RealPath(const char* defaultPath, char* in,
        char* out, word32 outSz);
```

**Description**

Resolves the path `in`, relative to `defaultPath`, into a canonical absolute path written to `out`.

**Parameters**

- `defaultPath` - the base path used to resolve a relative `in`
- `in` - the path to resolve
- `out` - buffer where the resolved path is written
- `outSz` - size of the output buffer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  Port Forwarding Functions



All functions in this section require wolfSSH to be built with port forwarding support (`WOLFSSH_FWD`, from `./configure --enable-fwd`).

### wolfSSH_ChannelFwdNewLocal()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNewLocal(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**Description**

Sets up a local TCP/IP forwarding channel on the session. Once the session is connected and authenticated, connections are forwarded to `host` on port `hostPort`, tagged with the originating address `origin` and port `originPort`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `host` - destination host address
- `hostPort` - destination port
- `origin` - originating connection address
- `originPort` - originating connection port

**Return Values**

- pointer to the new channel, or `NULL` on error

**See Also**

- `wolfSSH_ChannelFwdNewRemote()`

### wolfSSH_ChannelFwdNewRemote()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNewRemote(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**Description**

Sets up a remote TCP/IP forwarding channel on the session, requesting that the peer forward connections back to `host` on port `hostPort`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `host` - destination host address
- `hostPort` - destination port
- `origin` - originating connection address
- `originPort` - originating connection port

**Return Values**

- pointer to the new channel, or `NULL` on error

**See Also**

- `wolfSSH_ChannelFwdNewLocal()`

### wolfSSH_CTX_SetFwdCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetFwdCb(WOLFSSH_CTX* ctx,
        WS_CallbackFwd fwdCb, WS_CallbackFwdIO fwdIoCb);
```

**Description**

Registers the port forwarding setup/cleanup callback (`fwdCb`) on the context. Forwarding channel opens from the peer ("direct-tcpip" and "forwarded-tcpip") are refused when no `fwdCb` is registered. Each `WOLFSSH_FWD_LOCAL_SETUP` the callback receives is later matched by a `WOLFSSH_FWD_LOCAL_CLEANUP`.

```c
typedef int (*WS_CallbackFwd)(WS_FwdCbAction action, void* fwdCbCtx,
        const char* address, word32 port);
```

The callback's return value below `WS_FWD_PORT_CHECK` (1024) is a `WS_FwdCbError` status, with `WS_FWD_SUCCESS` meaning success. For a `WOLFSSH_FWD_REMOTE_SETUP` request with port 0, the callback instead returns the unprivileged port (at or above `WS_FWD_PORT_CHECK`) it allocated, which the server reports to the peer. A rejected port-0 setup gets a `WOLFSSH_FWD_REMOTE_CLEANUP` even though the setup returned success. A client answers "tcpip-forward" and "cancel-tcpip-forward" requests with a failure, whatever the callback would do.

The forwarding I/O callback, `fwdIoCb`, is reserved: it is stored, but nothing in the library calls it, since forwarded data moves through the channel API. The parameter is kept so existing code still compiles; pass NULL.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `fwdCb` - forwarding setup/cleanup callback
- `fwdIoCb` - reserved forwarding I/O callback; unused

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_SetFwdCbCtx()`

### wolfSSH_SetFwdCbCtx()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetFwdCbCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the port forwarding callbacks.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the forwarding callbacks

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelFwdNew()

```c
#include <wolfssh/ssh.h>

WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh,
        const char* host, word32 hostPort,
        const char* origin, word32 originPort);
```

**Description**

Deprecated. Use wolfSSH_ChannelFwdNewLocal(); this function is retained for backward compatibility and forwards to it.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `host` - destination host address
- `hostPort` - destination port
- `origin` - originating connection address
- `originPort` - originating connection port

**Return Values**

- pointer to the new channel, or `NULL` on error

**See Also**

- `wolfSSH_ChannelFwdNewLocal()`

### wolfSSH_ChannelSetFwdFd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelSetFwdFd(WOLFSSH_CHANNEL* channel, int fwdFd);
```

**Description**

Deprecated. Associates a forwarding file descriptor with a forwarding channel.

**Parameters**

- `channel` - pointer to the forwarding channel
- `fwdFd` - the forwarding file descriptor

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetFwdFd()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetFwdFd(const WOLFSSH_CHANNEL* channel);
```

**Description**

Deprecated. Returns the forwarding file descriptor associated with a forwarding channel.

**Parameters**

- `channel` - pointer to the forwarding channel

**Return Values**

- the forwarding file descriptor, or a negative error code

### wolfSSH_FwdRemoteSetup()

```c
#include <wolfssh/ssh.h>

int wolfSSH_FwdRemoteSetup(WOLFSSH* ssh, const char* bindAddr,
        word32 bindPort, int wantReply);
```

**Description**

Client only. Sends a "tcpip-forward" global request (RFC 4254 section 7.1) asking the server to listen on `bindAddr`:`bindPort` and tunnel the connections it accepts back as "forwarded-tcpip" channels, and registers the forward on the session. A `bindPort` of 0 asks the server to choose the port, and requires `wantReply`, since the reply is the only place the bound port is named.

A client refuses any "forwarded-tcpip" channel open naming a bind it has not registered (RFC 4254 section 7.2), from the start of the session; a session that registers nothing refuses them all. A `bindAddr` of "", "*", "0.0.0.0", or an IPv6 any-address matches on port alone; any other address must equal the one the server reports in the open. Register the spelling the server will echo back, or a wildcard, or relax the match with wolfSSH_SetFwdRemoteMatch().

One `bindAddr`:`bindPort` is one registration however often it is requested, so one cancel undoes it. When several requests name one bind, the last one sent governs.

`WS_WANT_WRITE` means the request is queued and goes out on the next flush, with the forward registered. So does an error reported after the request reached the peer; retrying then is a harmless repeat. Only an error that kept the request off the wire leaves nothing registered.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `bindAddr` - the address for the server to listen on
- `bindPort` - the port for the server to listen on, or 0 for the server to choose
- `wantReply` - 1 to ask the server for a reply, 0 otherwise

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` or `bindAddr` is NULL, `bindPort` is over 65535, `wantReply` is not 0 or 1, `bindPort` is 0 without `wantReply`, or the session is not a client
- `WS_REKEYING` - a key exchange is in progress
- `WS_RESOURCE_E` - too many requests are awaiting a reply
- `WS_MEMORY_E`
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- a send-path status such as `WS_WANT_WRITE`

**See Also**

- `wolfSSH_FwdRemoteCancel()`
- `wolfSSH_SetFwdRemoteMatch()`
- `wolfSSH_CTX_SetFwdCb()`

### wolfSSH_FwdRemoteCancel()

```c
#include <wolfssh/ssh.h>

int wolfSSH_FwdRemoteCancel(WOLFSSH* ssh, const char* bindAddr,
        word32 bindPort, int wantReply);
```

**Description**

Client only. Sends a "cancel-tcpip-forward" global request, tearing down a forward set up with wolfSSH_FwdRemoteSetup(). `bindPort` is the port the server bound, which after a port-0 request is the one it reported, not 0; such a forward cannot be cancelled before that reply arrives.

The forward stops matching inbound "forwarded-tcpip" opens as soon as the cancel goes out, so an open racing it is refused. Without `wantReply`, that is the end of it. With `wantReply`, the registration is held until the server answers: a refusal leaves the listener up and puts the forward back, and a confirmation drops it. With several cancels outstanding, all of them have to be refused for the forward to come back. Registering again while a cancel is outstanding brings the forward back as the new request goes out.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `bindAddr` - the address the forward was registered with
- `bindPort` - the port the server bound
- `wantReply` - 1 to ask the server for a reply, 0 otherwise

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` or `bindAddr` is NULL, `bindPort` is 0 or over 65535, `wantReply` is not 0 or 1, or the session is not a client
- `WS_REKEYING` - a key exchange is in progress
- `WS_RESOURCE_E` - too many requests are awaiting a reply
- `WS_MEMORY_E`
- `WS_FATAL_ERROR` - the session has disconnected (wolfSSH_get_error() reports `WS_DISCONNECT`)
- a send-path status such as `WS_WANT_WRITE`

**See Also**

- `wolfSSH_FwdRemoteSetup()`

### wolfSSH_SetFwdRemoteMatch()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetFwdRemoteMatch(WOLFSSH* ssh, byte match);
```

**Description**

Sets how strictly an inbound "forwarded-tcpip" channel open must match a forward registered with wolfSSH_FwdRemoteSetup(). A client checks these opens from the start of the session, so set this before the peer can send one.

```c
enum WS_FwdRemoteMatch {
    WOLFSSH_FWD_MATCH_STRICT = 0, /* bind and port, the default */
    WOLFSSH_FWD_MATCH_PORT   = 1, /* port alone, the bind is not compared */
    WOLFSSH_FWD_MATCH_OFF    = 2  /* accept any open, matching nothing */
};
```

`WOLFSSH_FWD_MATCH_STRICT` is the default and is what RFC 4254 section 7.2 asks for. `WOLFSSH_FWD_MATCH_PORT` is for a peer that rewrites the bind address it echoes back but keeps the port. `WOLFSSH_FWD_MATCH_OFF` accepts any "forwarded-tcpip" open, as wolfSSH did before this check existed, leaving the channel open callback as the only policy check.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `match` - a `WS_FwdRemoteMatch` value

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ssh` is NULL or `match` is not a known setting

**See Also**

- `wolfSSH_FwdRemoteSetup()`
- `wolfSSH_CTX_SetChannelOpenCb()`


##  Key Load Functions


### wolfSSH_ReadKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_buffer(const byte* in, word32 inSz,
        int format, byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        void* heap);
```

**Description**

Reads a key from the buffer `in` of size `inSz` and decodes it as a `format` type key. The `format` can be `WOLFSSH_FORMAT_ASN1`, `WOLFSSH_FORMAT_PEM`, `WOLFSSH_FORMAT_SSH`, or `WOLFSSH_FORMAT_OPENSSH`. The decoded key, ready for use by `wolfSSH_CTX_UsePrivateKey_buffer()`, is stored in the buffer pointed to by `out` of size `outSz`. If `out` is NULL, `heap` is used to allocate a buffer for the key. The key type string is stored in `outType`, with its length in `outTypeSz`.

**Parameters**

- `in` - buffer containing the encoded key
- `inSz` - size of the input buffer
- `format` - the encoding of the input key
- `out` - output buffer for the decoded key (allocated from `heap` if NULL)
- `outSz` - output for the decoded key size
- `outType` - output for the key type string
- `outTypeSz` - output for the key type string length
- `heap` - heap used for allocation when `out` is NULL

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_RSA_E`
- `WS_ECC_E`
- `WS_KEY_AUTH_MAGIC_E`
- `WS_KEY_FORMAT_E`
- `WS_KEY_CHECK_VAL_E`

**See Also**

- `wolfSSH_ReadKey_file()`

### wolfSSH_ReadKey_buffer_ex()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_buffer_ex(const byte* in, word32 inSz, int format,
        byte** out, word32* outSz, const byte** outType, word32* outTypeSz,
        int isPrivate, void* heap);
```

**Description**

Like wolfSSH_ReadKey_buffer(), but takes an explicit `isPrivate` flag indicating whether the buffer holds a private or public key rather than inferring it.

**Parameters**

- `in` - buffer containing the encoded key
- `inSz` - size of the input buffer
- `format` - the encoding of the input key
- `out` - output buffer for the decoded key (allocated from `heap` if NULL)
- `outSz` - output for the decoded key size
- `outType` - output for the key type string
- `outTypeSz` - output for the key type string length
- `isPrivate` - non-zero if the key is a private key, 0 if public
- `heap` - heap used for allocation when `out` is NULL

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`

**See Also**

- `wolfSSH_ReadKey_buffer()`

### wolfSSH_ReadPublicKey_buffer()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadPublicKey_buffer(const byte* in, word32 inSz, int format,
        byte** out, word32* outSz, const byte** outType, word32* outTypeSz,
        void* heap);
```

**Description**

Reads and decodes a public key from the buffer `in`. Behaves like wolfSSH_ReadKey_buffer() but is specialized for public keys.

**Parameters**

- `in` - buffer containing the encoded public key
- `inSz` - size of the input buffer
- `format` - the encoding of the input key
- `out` - output buffer for the decoded key (allocated from `heap` if NULL)
- `outSz` - output for the decoded key size
- `outType` - output for the key type string
- `outTypeSz` - output for the key type string length
- `heap` - heap used for allocation when `out` is NULL

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`

**See Also**

- `wolfSSH_ReadKey_buffer()`


### wolfSSH_ReadKey_file()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_file(const char* name,
        byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        byte* isPrivate, void* heap);
```

**Description**

Reads the key from the file `name`. The format is guessed from the file contents. The key buffer `out`, the key type `outType`, and their sizes are produced as by wolfSSH_ReadKey_buffer(). The `isPrivate` flag is set to indicate whether the key is private. Any allocations use the specified `heap`.

**Parameters**

- `name` - path to the key file
- `out` - output buffer for the decoded key (allocated from `heap` if NULL)
- `outSz` - output for the decoded key size
- `outType` - output for the key type string
- `outTypeSz` - output for the key type string length
- `isPrivate` - output set non-zero if the key is private
- `heap` - heap used for allocation when `out` is NULL

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_BAD_FILE_E`
- `WS_MEMORY_E`
- `WS_BUFFER_E`
- `WS_PARSE_E`
- `WS_UNIMPLEMENTED_E`
- `WS_RSA_E`
- `WS_ECC_E`
- `WS_KEY_AUTH_MAGIC_E`
- `WS_KEY_FORMAT_E`
- `WS_KEY_CHECK_VAL_E`

**See Also**

- `wolfSSH_ReadKey_buffer()`


### wolfSSH_ReadCert_buffer()

**Availability**

Requires `WOLFSSH_CERTS` (X.509 certificates) or `WOLFSSH_OSSH_CERTS` (OpenSSH certificates).

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadCert_buffer(const byte* in, word32 inSz,
        byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        byte* flavor, void* heap);
```

**Description**

Decodes a certificate from the buffer `in`, detecting its form from the content: a DER or PEM X.509 certificate (`WOLFSSH_CERTS` builds), or an OpenSSH certificate line (`WOLFSSH_OSSH_CERTS` builds). Of several PEM certificates, only the first is read. On success, `out` receives a newly allocated buffer, from `heap`, holding the DER certificate or the OpenSSH certificate blob, which the caller frees; `outType` receives the SSH algorithm name for the certificate, and `flavor` receives the kind of certificate found:

```c
enum WS_CertFlavors {
    WOLFSSH_CERT_FLAVOR_UNKNOWN,
    WOLFSSH_CERT_FLAVOR_X509,
    WOLFSSH_CERT_FLAVOR_OSSH
};
```

X.509 certificates are what wolfSSH_CTX_UseCert_buffer() and wolfSSH_CTX_AddRootCert_buffer() consume. On failure, all output parameters are cleared.

**Parameters**

- `in` - buffer containing the certificate
- `inSz` - size of the input buffer
- `out` - output for the newly allocated decoded certificate
- `outSz` - output for the decoded certificate size
- `outType` - output for the algorithm name string
- `outTypeSz` - output for the algorithm name string length
- `flavor` - output for the `WS_CertFlavors` value
- `heap` - heap used for the allocation

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `in` or an output pointer is NULL, or `inSz` is 0
- `WS_BAD_FILETYPE_E` - the content is not a recognized certificate form
- `WS_PARSE_E` - the certificate body does not decode
- `WS_MEMORY_E`
- other errors from identifying the certificate

**See Also**

- `wolfSSH_ReadCert_file()`
- `wolfSSH_ReadKey_buffer()`

### wolfSSH_ReadCert_file()

**Availability**

Requires `WOLFSSH_CERTS` or `WOLFSSH_OSSH_CERTS`, and filesystem support (not available with `NO_FILESYSTEM` or `WOLFSSH_USER_FILESYSTEM`).

```c
#include <wolfssh/ssh.h>

int wolfSSH_ReadCert_file(const char* name,
        byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        byte* flavor, void* heap);
```

**Description**

Reads the file `name` and decodes the certificate in it as wolfSSH_ReadCert_buffer() does. On failure, all output parameters are cleared.

**Parameters**

- `name` - path to the certificate file
- `out` - output for the newly allocated decoded certificate
- `outSz` - output for the decoded certificate size
- `outType` - output for the algorithm name string
- `outTypeSz` - output for the algorithm name string length
- `flavor` - output for the `WS_CertFlavors` value
- `heap` - heap used for allocations

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - an output pointer is NULL
- `WS_BAD_FILE_E` - `name` is NULL, or the file cannot be opened or read, is empty, or is larger than `WOLFSSH_MAX_FILE_SIZE`
- `WS_BAD_FILETYPE_E`
- `WS_PARSE_E`
- `WS_MEMORY_E`

**See Also**

- `wolfSSH_ReadCert_buffer()`
- `wolfSSH_ReadKey_file()`

## Key Exchange Algorithm Configuration

wolfSSH sets up a set of algorithm lists used during the Key Exchange (KEX)
based on the availability of algorithms in the wolfCrypt library used.

Provided are some accessor functions to see which algorithms are available
to use and to see the algorithm lists used in the KEX. The accessor functions
come in sets of four: set or get from CTX object, and set or get from SSH
object. All SSH objects made with a CTX inherit the CTX's algorithm lists,
and they may be provided their own.

By default, any algorithms using SHA-1 are disabled but may be re-enabled
using one of the following functions. If SHA-1 is disabled in wolfCrypt, then
SHA-1 cannot be used.


### wolfSSH Set Algo Lists

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetAlgoListKex(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListKey(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListCipher(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListMac(WOLFSSH_CTX* ctx, const char* list);
int wolfSSH_CTX_SetAlgoListKeyAccepted(WOLFSSH_CTX* ctx, const char* list);

int wolfSSH_SetAlgoListKex(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListKey(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListCipher(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListMac(WOLFSSH* ssh, const char* list);
int wolfSSH_SetAlgoListKeyAccepted(WOLFSSH* ssh, const char* list);
```

**Description**

These functions act as setters for the various algorithm lists set in the
wolfSSH _ctx_ or _ssh_ objects. The strings are sent to the peer during the
KEX Initialization and are used to compare against when the peer sends its
KEX Initialization message. The KeyAccepted list is used for user
authentication.

The CTX versions of the functions set the algorithm list for the specified
WOLFSSH_CTX object, _ctx_. They have default values set at compile time. The
specified value is used instead. Note, the library does not copy this string,
it is owned by the application and it is up to the application to free it
when the CTX is deallocated by the application. When creating an SSH object
using a CTX, the SSH object inherits the CTX's strings. The SSH object
algorithm lists may be overridden.

`Kex` specifies the key exchange algorithm list. `Key` specifies the server
public key algorithm list. `Cipher` specifies the bulk encryption algorithm
list. `Mac` specifies the message authentication code algorithm list.
`KeyAccepted` specifies the public key algorithms allowed for user
authentication.

The setters validate the list and leave the current list in place when it
is rejected. The `Kex`, `Cipher`, and `Mac` setters reject NULL. The `Key`
setters accept NULL only on a server, where it restores the default of
deriving the host key list from the loaded private keys; a client has no
such fallback. The `KeyAccepted` setters accept NULL on either side, but
that empties the list rather than restoring a default: the server then
advertises an empty RFC 8308 "server-sig-algs", telling clients it accepts
no signature algorithms.

**Return Values**

- `WS_SUCCESS`
- `WS_INVALID_ALGO_ID` - the list is not valid
- `WS_SSH_CTX_NULL_E` - `ctx` is NULL
- `WS_SSH_NULL_E` - `ssh` is NULL


### wolfSSH Get Algo List

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_CTX_GetAlgoListKex(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListKey(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListCipher(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListMac(WOLFSSH_CTX* ctx);
const char* wolfSSH_CTX_GetAlgoListKeyAccepted(WOLFSSH_CTX* ctx);

const char* wolfSSH_GetAlgoListKex(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListKey(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListCipher(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListMac(WOLFSSH* ssh);
const char* wolfSSH_GetAlgoListKeyAccepted(WOLFSSH* ssh);
```

**Description**

These functions act as getters for the various algorithm lists set in the
wolfSSH _ctx_ or _ssh_ objects.

`Kex` specifies the key exchange algorithm list. `Key` specifies the server
public key algorithm list. `Cipher` specifies the bulk encryption algorithm
list. `Mac` specifies the message authentication code algorithm list.
`KeyAccepted` specifies the public key algorithms allowed for user
authentication.

**Return Values**

These functions return a pointer to either the default value set at compile
time or the value set at run time with the setter functions. If the _ctx_
or `ssh` parameters are NULL the functions return NULL.


### wolfSSH_CheckAlgoName()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CheckAlgoName(const char* name);
```

**Description**

Checks whether the given single algorithm `name` is valid and supported.

**Parameters**

- `name` - the algorithm name to check

**Return Values**

- `WS_SUCCESS`
- `WS_INVALID_ALGO_ID`


### wolfSSH_CTX_SetStrictKex()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetStrictKex(WOLFSSH_CTX* ctx, byte enable);
```

**Description**

Enables or disables offering strict key exchange, the Terrapin (CVE-2023-48795) mitigation, for sessions created from this context. Strict KEX is enabled by default. When both sides offer it, a non-KEX message during the initial key exchange ends the connection, and sequence numbers are reset at each key exchange. wolfSSH_new() copies the context's setting, so a change affects only sessions created afterward.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `enable` - non-zero to offer strict KEX, 0 to opt out

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` - `ctx` is NULL

**See Also**

- `wolfSSH_CTX_GetStrictKex()`
- `wolfSSH_GetStrictKexNegotiated()`

### wolfSSH_CTX_GetStrictKex()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_GetStrictKex(WOLFSSH_CTX* ctx);
```

**Description**

Reports whether the context offers strict key exchange.

**Parameters**

- `ctx` - pointer to the wolfSSH context

**Return Values**

- 1 - strict KEX is offered
- 0 - strict KEX is not offered
- `WS_BAD_ARGUMENT` - `ctx` is NULL

**See Also**

- `wolfSSH_CTX_SetStrictKex()`

### wolfSSH_GetStrictKexNegotiated()

```c
#include <wolfssh/ssh.h>

int wolfSSH_GetStrictKexNegotiated(WOLFSSH* ssh);
```

**Description**

Reports whether the session negotiated strict key exchange, that is, whether both sides offered it.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- 1 - strict KEX was negotiated
- 0 - strict KEX was not negotiated
- `WS_SSH_NULL_E` - `ssh` is NULL

**See Also**

- `wolfSSH_CTX_SetStrictKex()`

### wolfSSH Query Algorithms

```c
#include <wolfssh/ssh.h>

const char* wolfSSH_QueryKex(word32* index);
const char* wolfSSH_QueryKey(word32* index);
const char* wolfSSH_QueryCipher(word32* index);
const char* wolfSSH_QueryMac(word32* index);
```

**Description**

Returns the name string for a valid algorithm of the given type (Kex, Key, Cipher, or Mac). Key types are also used for the user-authentication accepted key types. Initialize `index` to 0 and pass the same pointer on each call to iterate; the functions advance it. When the returned value is NULL, the end of the list has been reached.

**Parameters**

- `index` - iterator, initialized to 0 and passed on each call

**Return Values**

- pointer to an algorithm name string, or `NULL` at the end of the list

### wolfSSH_GetText()

```c
#include <wolfssh/ssh.h>

size_t wolfSSH_GetText(WOLFSSH* ssh, WS_Text id, char* str, size_t strSz);
```

**Description**

Writes the text representation of the negotiated item identified by `id` (a `WS_Text` value such as the KEX algorithm, KEX curve, KEX hash, input/output cipher, or input/output MAC) into `str`, writing no more than `strSz` bytes including the terminating null.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `id` - the `WS_Text` item to retrieve
- `str` - output buffer for the text
- `strSz` - size of the output buffer

**Return Values**

- the number of characters written (excluding the null terminator); a value of `strSz` or more means the output was truncated

## Global Request Callbacks

These callbacks handle SSH global request messages and their success/failure replies.

### wolfSSH_SetGlobalReq()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetGlobalReq(WOLFSSH_CTX* ctx, WS_CallbackGlobalReq cb);
```

**Description**

Registers the callback invoked when a global request message is received from the peer.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the global request callback

**Return Values**

None

**See Also**

- `wolfSSH_SetGlobalReqCtx()`

### wolfSSH_SetGlobalReqCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetGlobalReqCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the global request callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the callback

**Return Values**

None

### wolfSSH_GetGlobalReqCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetGlobalReqCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetGlobalReqCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the global request context pointer, or `NULL` if none

### wolfSSH_CTX_SetGlobalReqAnyCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetGlobalReqAnyCb(WOLFSSH_CTX* ctx,
        WS_CallbackGlobalReqAny cb);
```

**Description**

Sets a policy callback consulted first for a global request from the peer, ahead of the forwarding callback that answers "tcpip-forward" and "cancel-tcpip-forward" and of the global request callback set with wolfSSH_SetGlobalReq() that answers the rest.

```c
typedef int (*WS_CallbackGlobalReqAny)(WOLFSSH* ssh, const byte* name,
        word32 nameSz, const byte* data, word32 dataSz, int wantReply,
        void* ctx);
```

`name` is the request name as it arrived, `nameSz` bytes, and `data` is the request's type-specific part, `dataSz` bytes, for the callback to parse; a "tcpip-forward" naming a port can thus be set up from here without a forwarding callback. Neither is NUL terminated, and a name may hold any byte, so match on `nameSz` bytes rather than with the string functions. The callback shares the global request context set with wolfSSH_SetGlobalReqCtx().

The callback returns a `WS_ReqCbResult` (see the Channel Callbacks section). `WOLFSSH_REQ_UNHANDLED` (0) leaves the request to the other callbacks. `WOLFSSH_REQ_ACCEPT` and `WOLFSSH_REQ_REJECT` settle it, and no other callback is consulted; the reply, when one is wanted, is SSH_MSG_REQUEST_SUCCESS or SSH_MSG_REQUEST_FAILURE.

Two kinds of request never reach this callback. A "tcpip-forward" asking for port 0, or one whose body does not parse, is left to the forwarding callback, which can bind and report the port. And a client answers "tcpip-forward" and "cancel-tcpip-forward" with a failure whatever a policy would say.

`name` and `data` point into the session's input buffer and are valid only for the length of the call, so a callback keeping either must copy it. The callback must not re-enter the receive side of the library on this session (wolfSSH_worker(), wolfSSH_stream_read(), wolfSSH_accept(), or the SFTP calls).

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the global request policy callback

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`

**See Also**

- `wolfSSH_SetGlobalReq()`
- `wolfSSH_SetGlobalReqCtx()`
- `wolfSSH_CTX_SetChannelReqAnyCb()`

### wolfSSH_SetReqSuccess()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqSuccess(WOLFSSH_CTX* ctx, WS_CallbackReqSuccess cb);
```

**Description**

Registers the callback invoked when a request-success reply is received from the peer.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the request-success callback

**Return Values**

None

**See Also**

- `wolfSSH_SetReqSuccessCtx()`

### wolfSSH_SetReqSuccessCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqSuccessCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the request-success callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the callback

**Return Values**

None

### wolfSSH_GetReqSuccessCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetReqSuccessCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetReqSuccessCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the request-success context pointer, or `NULL` if none

### wolfSSH_SetReqFailure()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqFailure(WOLFSSH_CTX* ctx, WS_CallbackReqSuccess cb);
```

**Description**

Registers the callback invoked when a request-failure reply is received from the peer.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the request-failure callback

**Return Values**

None

**See Also**

- `wolfSSH_SetReqFailureCtx()`

### wolfSSH_SetReqFailureCtx()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetReqFailureCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the request-failure callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the callback

**Return Values**

None

### wolfSSH_GetReqFailureCtx()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetReqFailureCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetReqFailureCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the request-failure context pointer, or `NULL` if none

## TPM 2.0 Integration

These functions integrate a wolfTPM 2.0 device and key for host-key operations. They require wolfSSH to be built with `WOLFSSH_TPM` and a wolfTPM installation.

### wolfSSH_SetTpmDev()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTpmDev(WOLFSSH* ssh, WOLFTPM2_DEV* dev);
```

**Description**

Associates a wolfTPM 2.0 device with the session for TPM-backed host-key operations.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dev` - pointer to the wolfTPM 2.0 device

**Return Values**

None

**See Also**

- `wolfSSH_SetTpmKey()`

### wolfSSH_SetTpmKey()

```c
#include <wolfssh/ssh.h>

void wolfSSH_SetTpmKey(WOLFSSH* ssh, WOLFTPM2_KEY* key);
```

**Description**

Associates a wolfTPM 2.0 key with the session for TPM-backed host-key operations.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `key` - pointer to the wolfTPM 2.0 key

**Return Values**

None

### wolfSSH_GetTpmDev()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetTpmDev(WOLFSSH* ssh);
```

**Description**

Returns the wolfTPM 2.0 device previously associated with the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the wolfTPM 2.0 device, or `NULL` if none

### wolfSSH_GetTpmKey()

```c
#include <wolfssh/ssh.h>

void* wolfSSH_GetTpmKey(WOLFSSH* ssh);
```

**Description**

Returns the wolfTPM 2.0 key previously associated with the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the wolfTPM 2.0 key, or `NULL` if none

### wolfSSH_CTX_UseTpmHostKey()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_UseTpmHostKey(WOLFSSH_CTX* ctx,
        WOLFTPM2_DEV* dev, WOLFTPM2_KEY* key);
```

**Description**

Configures the context to use the given wolfTPM 2.0 device and key as the server host key.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `dev` - pointer to the wolfTPM 2.0 device
- `key` - pointer to the wolfTPM 2.0 key

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
