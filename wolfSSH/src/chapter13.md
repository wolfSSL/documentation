#  API Reference

This section describes the public application program interfaces for the wolfSSH library.

##  Error Codes



###  WS_ErrorCodes (enum)



The following API response codes are defined in wolfssh/error.h and describe the different types of errors that can occur. `WS_SUCCESS` is 0; all error codes are negative. `WS_FATAL_ERROR` is a deprecated alias for `WS_ERROR`, and `WS_LAST_E` always tracks the last defined error code.

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
- WS_MSGID_NOT_ALLOWED_E (-1094): Message not allowed before user authentication
- WS_ED25519_E (-1095): Ed25519 failure
- WS_AUTH_PENDING (-1096): User authentication still pending
- WS_KDF_E (-1097): KDF error
- WS_DISCONNECT (-1098): Peer sent disconnect

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

Loads the server's X.509 certificate from a buffer into the context, for certificate-based host authentication. The `format` is `WOLFSSH_FORMAT_ASN1` or `WOLFSSH_FORMAT_PEM`.

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

Adds a trusted root CA certificate to the context, used to verify certificates presented by the peer. The `format` is `WOLFSSH_FORMAT_ASN1` or `WOLFSSH_FORMAT_PEM`.

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

Services the SSH connection: receives any pending inbound data and flushes pending outbound packets. This is the main driver call for a running session. On success, if `channelId` is not NULL, the ID of the channel that most recently received data is written to it.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - optional output for the last channel ID that received data; may be NULL

**Return Values**

- `WS_SUCCESS`
- `WS_CHAN_RXD`
- `WS_REKEYING`
- `WS_WANT_READ`
- `WS_WANT_WRITE`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_GetLastRxId()`

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
- `WS_BAD_ARGUMENT` (or `INVALID_SOCKET` on Windows) if `ssh` is NULL

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

Registers the user authentication callback on the wolfSSH context. The callback is invoked during the handshake to authenticate the peer.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the user authentication callback function

**Return Values**

None

**See Also**

- `wolfSSH_SetUserAuthCtx()`

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

Registers a callback, used on the client side, to check the server's public (host) key before continuing the handshake. The application can accept or reject the key from this callback.

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

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_connect()`
- `wolfSSH_stream_read()`

### wolfSSH_connect()


```c
#include <wolfssh/ssh.h>

int wolfSSH_connect(WOLFSSH* ssh);
```

**Description**

Called on the client side; initiates an SSH handshake with a server. The underlying communication channel must already be set up before this call.

wolfSSH_connect() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking, wolfSSH_connect() returns when the I/O cannot yet satisfy the handshake; a call to wolfSSH_get_error() then yields either `WS_WANT_READ` or `WS_WANT_WRITE`. The caller repeats the call when the I/O is ready and wolfSSH resumes where it left off.

If the underlying I/O is blocking, wolfSSH_connect() returns only once the handshake has finished or an error occurred.

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

Closes and disconnects the SSH session, sending a disconnect message to the peer.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_connect()`
- `wolfSSH_accept()`

### wolfSSH_stream_read()



```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_read(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes from the internal decrypted data stream buffer. The bytes read are removed from the internal buffer.

wolfSSH_stream_read() works with both blocking and non-blocking I/O. When the underlying I/O is non-blocking and cannot satisfy the read, a call to wolfSSH_get_error() yields `WS_WANT_READ` or `WS_WANT_WRITE`, and the caller repeats the call when data is available. If the underlying I/O is blocking, the call returns only when data is available or an error occurred. If a rekey is in progress (`WS_REKEYING`), call wolfSSH_worker() to complete it.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes read on success
- 0 - the connection was shut down
- `WS_BAD_ARGUMENT`
- `WS_EOF`
- `WS_FATAL_ERROR`
- `WS_REKEYING`

**See Also**

- `wolfSSH_stream_send()`
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
- 0 - the connection was shut down
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`
- `WS_REKEYING`

**See Also**

- `wolfSSH_stream_read()`
- `wolfSSH_accept()`


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
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_stream_send()`

### wolfSSH_TriggerKeyExchange()


```c
#include <wolfssh/ssh.h>

int wolfSSH_TriggerKeyExchange(WOLFSSH* ssh);
```

**Description**

Triggers the key exchange (rekey) process by preparing and sending the initial handshake packet.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_worker()`

### wolfSSH_stream_peek()

```c
#include <wolfssh/ssh.h>

int wolfSSH_stream_peek(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Copies up to `bufSz` bytes of pending decrypted stream data into `buf` without removing them from the internal buffer. A subsequent wolfSSH_stream_read() will return the same data.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer where the peeked data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes copied
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_stream_read()`

### wolfSSH_extended_data_send()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_send(WOLFSSH* ssh, byte* buf, word32 bufSz);
```

**Description**

Sends `bufSz` bytes as extended channel data (typically the stderr data type).

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - buffer to send
- `bufSz` - size of the buffer

**Return Values**

- greater than 0 - number of bytes sent on success
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_extended_data_read()`

### wolfSSH_extended_data_read()

```c
#include <wolfssh/ssh.h>

int wolfSSH_extended_data_read(WOLFSSH* ssh, byte* out, word32 outSz);
```

**Description**

Reads up to `outSz` bytes of received extended channel data (typically stderr) into `out`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `out` - buffer where the data is placed
- `outSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_extended_data_send()`

### wolfSSH_SendIgnore()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendIgnore(WOLFSSH* ssh, const byte* buf, word32 bufSz);
```

**Description**

Sends an SSH_MSG_IGNORE message carrying the given payload. The peer discards the contents; this can be used as a keepalive or for traffic-analysis resistance.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `buf` - payload to include in the message
- `bufSz` - size of the payload

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_SendDisconnect()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SendDisconnect(WOLFSSH* ssh, word32 reason);
```

**Description**

Sends an SSH_MSG_DISCONNECT message to the peer with the given reason code (see the `WS_DisconnectReasonCodes` values).

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `reason` - disconnect reason code

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

**See Also**

- `wolfSSH_shutdown()`

### wolfSSH_global_request()

```c
#include <wolfssh/ssh.h>

int wolfSSH_global_request(WOLFSSH* ssh, const unsigned char* data,
        word32 dataSz, int reply);
```

**Description**

Sends a global request to the peer carrying the given data. If `reply` is non-zero, the peer is asked to reply with success or failure.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `data` - request payload
- `dataSz` - size of the payload
- `reply` - non-zero to request a reply from the peer

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

### wolfSSH_ChannelIdRead()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelIdRead(WOLFSSH* ssh, word32 channelId,
        byte* buf, word32 bufSz);
```

**Description**

Reads up to `bufSz` bytes of received data from the channel identified by `channelId`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `channelId` - the channel to read from
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_ChannelIdSend()`

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
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_ChannelIdRead()`

### wolfSSH_CTX_SetSshProtoIdStr()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetSshProtoIdStr(WOLFSSH_CTX* ctx, const char* protoIdStr);
```

**Description**

Overrides the SSH protocol identification string that is sent to the peer during the version exchange at the start of the connection.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `protoIdStr` - the protocol identification string to send

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

Sets the default channel window size and maximum packet size for sessions created from this context.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `windowSz` - the channel window size, in bytes
- `maxPacketSz` - the maximum packet size, in bytes

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

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

### wolfSSH_CTX_SetChannelOpenCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelOpenCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen cb);
```

**Description**

Sets the callback invoked when a Channel Open (SSH_MSG_CHANNEL_OPEN) message is received from the peer.

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


### wolfSSH_CTX_SetChannelEofCb()

```c
#include <wolfssh/ssh.h>

int wolfSSH_CTX_SetChannelEofCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelEof cb);
```

**Description**

Sets the callback invoked when a Channel EOF (SSH_MSG_CHANNEL_EOF) message is received from the peer, indicating the peer will not transmit any more data on this channel.

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

Returns the command the peer requested to execute over the specified channel (for an "exec" request).

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- pointer to the command string, or `NULL` if none

**See Also**

- `wolfSSH_ChannelGetSessionType()`

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

Reads up to `bufSz` bytes of received data from the given channel.

**Parameters**

- `channel` - pointer to the channel
- `buf` - buffer where the data is placed
- `bufSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes read
- `WS_BAD_ARGUMENT`
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_ChannelSend()`

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
- `WS_FATAL_ERROR`

**See Also**

- `wolfSSH_ChannelRead()`

### wolfSSH_ChannelExit()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelExit(WOLFSSH_CHANNEL* channel);
```

**Description**

Closes the given channel, sending EOF and close messages to the peer.

**Parameters**

- `channel` - pointer to the channel

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

### wolfSSH_ChannelGetEof()

```c
#include <wolfssh/ssh.h>

int wolfSSH_ChannelGetEof(WOLFSSH_CHANNEL* channel);
```

**Description**

Reports whether the peer has sent EOF on the given channel.

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

Returns the command the peer requested to run for this session (for an "exec" request).

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- pointer to the command string, or `NULL` if none

**See Also**

- `wolfSSH_GetSessionType()`

### wolfSSH_SetChannelType()

```c
#include <wolfssh/ssh.h>

int wolfSSH_SetChannelType(WOLFSSH* ssh, byte type, byte* name,
        word32 nameSz);
```

**Description**

Sets the channel request type (for example, shell, exec, or subsystem) and optional name for the session's channel.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `type` - the channel request type
- `name` - optional name associated with the type (for example, the subsystem name)
- `nameSz` - length of `name`

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

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

Registers the port forwarding setup/cleanup callback (`fwdCb`) and the forwarding I/O callback (`fwdIoCb`) on the context.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `fwdCb` - forwarding setup/cleanup callback
- `fwdIoCb` - forwarding I/O callback

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

**Return Values**

- `WS_SUCCESS`
- `WS_SSH_CTX_NULL_E`
- `WS_SSH_NULL_E`


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
