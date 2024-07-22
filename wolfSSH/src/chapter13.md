#  API Reference

This section describes the public application program interfaces for the wolfSSH library.

##  Error Codes



###  WS_ErrorCodes (enum)



The following API response codes are defined in: wolfssh/wolfssh/error.h and describe the different types of errors that can occur.

- WS_SUCCESS (0): Function success
- WS_FATAL_ERROR (-1): General function failure
- WS_BAD_ARGUMENT (-2): Function argument out of bounds
- WS_MEMORY_E (-3): Memory allocation error
- WS_BUFFER_E (-4): Input/output buffer size error
- WS_PARSE_E (-5): General parsing error
- WS_NOT_COMPILED (-6): Feature not compiled in
- WS_OVERFLOW_E (-7): Would overflow if continued
- WS_BAD_USAGE (-8): Bad example usage
- WS_SOCKET_ERROR_E (-9): Socket error
- WS_WANT_READ (-10): IO callback would read block error
- WS_WANT_WRITE (-11): IO callback would write block error
- WS_RECV_OVERFLOW_E (-12): Received buffer overflow
- WS_VERSION_E (-13): Peer using wrong version of SSH
- WS_SEND_OOB_READ_E (-14): Attempted to read buffer out of bounds
- WS_INPUT_CASE_E (-15): Bad process input state, programming error
- WS_BAD_FILETYPE_E (-16): Bad filetype
- WS_UNIMPLEMENTED_E (-17): Feature not implemented
- WS_RSA_E (-18): RSA buffer error
- WS_BAD_FILE_E (-19): Bad file
- WS_INVALID_ALGO_ID (-20): invalid algorithm ID
- WS_DECRYPT_E (-21): Decrypt error
- WS_ENCRYPT_E (-22): Encrypt error
- WS_VERIFY_MAC_E (-23): verify mac error
- WS_CREATE_MAC_E (-24): Create mac error
- WS_RESOURCE_E (-25): Insufficient resources for new channel
- WS_INVALID_CHANTYPE (-26): Invalid channel type
- WS_INVALID_CHANID(-27): Peer requested invalid channel ID
- WS_INVALID_USERNAME(-28): Invalid user name
- WS_CRYPTO_FAILED(-29): Crypto action failed
- WS_INVALID_STATE_E(-30): Invalid State
- WC_EOF(-31): End of File
- WS_INVALID_PRIME_CURVE(-32): Invalid prime curve in ECC
- WS_ECC_E(-33): ECDSA buffer error
- WS_CHANOPEN_FAILED(-34): Peer returned channel open failure
- WS_REKEYING(-35): Rekeying with peer
- WS_CHANNEL_CLOSED(-36): Channel closed

###  WS_IOerrors (enum)



These are the return codes the library expects to receive from a user-provided I/O callback. Otherwise the library expects the number of bytes read or written from the I/O action.

- WS_CBIO_ERR_GENERAL (-1): General unexpected error 
- WS_CBIO_ERR_WANT_READ (-2): Socket read would block, call again 
- WS_CBIO_ERR_WANT_WRITE (-2): Socket write would block, call again 
- WS_CBIO_ERR_CONN_RST (-3): Connection reset
- WS_CBIO_ERR_ISR (-4): Interrupt
- WS_CBIO_ERR_CONN_CLOSE (-5): Connection closed or EPIPE
- WS_CBIO_ERR_TIMEOUT (-6): Socket timeout"

##  Initialization / Shutdown



### wolfSSH_Init()



**Synopsis**

**Description**

Initializes the wolfSSH library for use. Must be called once per application and before any other calls to the library.

**Return Values**

WS_SUCCESS
WS_CRYPTO_FAILED

**Parameters**

None

**See Also**

wolfSSH_Cleanup()

```
#include <wolfssh/ssh.h>
int wolfSSH_Init(void);
```

### wolfSSH_Cleanup()



**Synopsis**

**Description**

Cleans up the wolfSSH library when done. Should be called at before termination of the application. After calling, do not make any more calls to the library.

**Return Values**

**WS_SUCCESS**

**WS_CRYPTO_FAILED**

**Parameters**

None

**See Also**

wolfSSH_Init()

```
#include <wolfssh/ssh.h>
int wolfSSH_Cleanup(void);
```

##  Debugging output functions



### wolfSSH_Debugging_ON()



**Synopsis**

**Description**

Enables debug logging during runtime. Does nothing when debugging is disabled at build time.

**Return Values**

None

**Parameters**

None

**See Also**

wolfSSH_Debugging_OFF()

```
#include <wolfssh/ssh.h>
void wolfSSH_Debugging_ON(void);
```

### wolfSSH_Debugging_OFF()



**Synopsis**

**Description**

Disables debug logging during runtime. Does nothing when debugging is disabled at build time.

**Return Values**

None

**Parameters**

None

**See Also**

wolfSSH_Debugging_ON()

```
#include <wolfssh/ssh.h>
void wolfSSH_Debugging_OFF(void);
```

##  Context Functions



### wolfSSH_CTX_new()



**Synopsis**

**Description**

Creates a wolfSSH context object. This object can be configured and then used as a factory for wolfSSH session objects.

**Return Values**

**WOLFSSH_CTX*** – returns pointer to allocated WOLFSSH_CTX object or NULL

**Parameters**

**side** – indicate client side (unimplemented) or server side
**heap** – pointer to a heap to use for memory allocations

**See Also**

wolfSSH_wolfSSH_CTX_free()

```
#include <wolfssh/ssh.h>
WOLFSSH_CTX* wolfSSH_CTX_new(byte side , void* heap );
```

### wolfSSH_CTX_free()



**Synopsis**

**Description**

Deallocates a wolfSSH context object.

**Return Values**

None

**Parameters**

**ctx** – the wolfSSH context used to initialize the wolfSSH session

**See Also**

wolfSSH_wolfSSH_CTX_new()

```
#include <wolfssh/ssh.h>
void wolfSSH_CTX_free(WOLFSSH_CTX* ctx );
```

### wolfSSH_CTX_SetBanner()


**Synopsis**

**Description**

Sets a banner message that a user can see.

**Return Values**

WS_BAD_ARGUMENT
WS_SUCCESS

**Parameters**

**ssh -** Pointer to wolfSSH session
**newBanner** - The banner message text.

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetBanner(WOLFSSH_CTX* ctx , const char*
newBanner );
```

### wolfSSH_CTX_UsePrivateKey_buffer()



**Synopsis**

**Description**

This function loads a private key buffer into the SSH context. It is called with a buffer as input instead of a file. The buffer is provided by the **in** argument of size **inSz**. The argument **format** specifies the type of buffer: **WOLFSSH_FORMAT_ASN1** or **WOLFSSL_FORMAT_PEM** (unimplemented at this time).

**Return Values**

**WS_SUCCESS
WS_BAD_ARGUMENT** – at least one of the parameters is invalid
**WS_BAD_FILETYPE_E** – wrong format
**WS_UNIMPLEMENTED_E** – support for PEM format not implemented
**WS_MEMORY_E** – out of memory condition
**WS_RSA_E** – cannot decode RSA key
**WS_BAD_FILE_E** – cannot parse buffer

**Parameters**

**ctx** – pointer to the wolfSSH context
**in** – buffer containing the private key to be loaded
**inSz** – size of the input buffer
**format** – format of the private key located in the input buffer

**See Also**

wolfSSH_UseCert_buffer()
wolfSSH_UseCaCert_buffer()

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_UsePrivateKey_buffer(WOLFSSH_CTX* ctx ,
const byte* in , word32 inSz , int format );
```

##  SSH Session Functions



### wolfSSH_new()



**Synopsis**

**Description**

Creates a wolfSSH session object. It is initialized with the provided wolfSSH context.

**Return Values**

**WOLFSSH*** – returns pointer to allocated WOLFSSH object or NULL

**Parameters**

**ctx** – the wolfSSH context used to initialize the wolfSSH session

**See Also**

wolfSSH_free()

```
#include <wolfssh/ssh.h>
WOLFSSH* wolfSSH_new(WOLFSSH_CTX* ctx );
```

### wolfSSH_free()



**Synopsis**

**Description**

Deallocates a wolfSSH session object.

**Return Values**

None

**Parameters**

**ssh** – session to deallocate

**See Also**

wolfSSH_new()

```
#include <wolfssh/ssh.h>
void wolfSSH_free(WOLFSSH* ssh );
```

### wolfSSH_set_fd()



**Synopsis**

**Description**

Assigns the provided file descriptor to the ssh object. The ssh session will use the file descriptor for network I/O in the default I/O callbacks.

**Return Values**

#### WS_SUCCESS

WS_BAD_ARGUMENT – one of the parameters is invalid

**Parameters**

**ssh** – session to set the fd
**fd** – file descriptor for the socket used by the session

**See Also**

wolfSSH_get_fd()

```
#include <wolfssh/ssh.h>
int wolfSSH_set_fd(WOLFSSH* ssh , int fd );
```

### wolfSSH_get_fd()



**Synopsis**

**Description**

This function returns the file descriptor ( **fd** ) used as the input/output facility for the SSH connection. Typically this will be a socket file descriptor.

**Return Values**

**int** – file descriptor
**WS_BAD_ARGUEMENT**

**Parameters**

**ssh** – pointer to the SSL session.

**See Also**

wolfSSH_set_fd()

```
#include <wolfssh/ssh.h>
int wolfSSH_get_fd(const WOLFSSH* ssh );
```

##  Data High Water Mark Functions



### wolfSSH_SetHighwater()


**Synopsis**

**Description**

Sets the highwater mark for the ssh session.

**Return Values**

WS_SUCCESS
WS_BAD_ARGUMENT

**Parameters**

**ssh -** Pointer to wolfSSH session
**highwater** - data indicating the highwater security mark

```
#include <wolfssh/ssh.h>
int wolfSSH_SetHighwater(WOLFSSH* ssh , word32 highwater );
```

### wolfSSH_GetHighwater()


**Synopsis**

**Description**

Returns the highwater security mark

**Return Values**

**word32** - The highwater security mark.

**Parameters**

**ssh -** Pointer to wolfSSH session

```
#include <wolfssh/ssh.h>
word32 wolfSSH_GetHighwater(WOLFSSH* ssh );
```

### wolfSSH_SetHighwaterCb()


**Synopsis**

**Description**

The wolfSSH_SetHighwaterCb function sets the highwater security mark for the SSH session as well as the high water call back.

**Return Values**

none

**Parameters**

**ctx** – The wolfSSH context used to initialize the wolfSSH session.
**highwater** - The highwater security mark.
**cb** - The call back highwater function.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetHighwaterCb(WOLFSSH_CTX* ctx , word32 highwater ,
WS_CallbackHighwater cb );
```

### wolfSSH_SetHighwaterCtx()


**Synopsis**

**Description**

The wolfSSH_SetHighwaterCTX function sets the highwater security mark for the given context.

**Return Values**

none

**Parameters**

**ssh -** pointer to wolfSSH session
**ctx** - pointer to highwater security mark in the wolfSSH context.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetHighwaterCtx(WOLFSSH* ssh, void* ctx);
```

### wolfSSH_GetHighwaterCtx()


**Synopsis**

**Description**

The wolfSSH_GetHighwaterCtx() returns the highwaterCtx security mark from the SSH session.

**Return Values**

**void*** - the highwater security mark
**NULL** - if there is an error with the WOLFSSH object.

**Parameters**

**ssh -** pointer to WOLFSSH object

```
#include <wolfssh/ssh.h>
void wolfSSH_GetHighwaterCtx(WOLFSSH* ssh );
```

##  Error Checking



### wolfSSH_get_error()



**Synopsis**

**Description**

Returns the error set in the wolfSSH session object.

**Return Values**

WS_ErrorCodes (enum)

**Parameters**

**ssh** – pointer to WOLFSSH object

**See Also**

wolfSSH_get_error_name()

```
#include <wolfssh/ssh.h>
int wolfSSH_get_error(const WOLFSSH* ssh );
```

### wolfSSH_get_error_name()



**Synopsis**

**Description**

Returns the name of the error set in the wolfSSH session object.

**Return Values**

**const char*** – error name string

**Parameters**

**ssh** – pointer to WOLFSSH object

**See Also**

wolfSSH_get_error()

```
#include <wolfssh/ssh.h>
const char* wolfSSH_get_error_name(const WOLFSSH* ssh );
```

### wolfSSH_ErrorToName()


**Synopsis**

**Description**

Returns the name of an error when called with an error number in the parameter.

**Return Values**

**const char*** – name of error string

**Parameters**

**err** - the int value of the error

```
#include <wolfssh/ssh.h>
const char* wolfSSH_ErrorToName(int err );
```

##  I/O Callbacks



### wolfSSH_SetIORecv()


**Synopsis**

**Description**

This function registers a receive callback for wolfSSL to get input data.

**Return Values**

None

**Parameters**

**ctx** – pointer to the SSH context
**cb** – function to be registered as the receive callback for the wolfSSH context, **ctx**. The signature of this function must follow that as shown above in the Synopsis section.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIORecv(WOLFSSH_CTX* ctx , WS_CallbackIORecv cb );
```

### wolfSSH_SetIOSend()


**Synopsis**

**Description**

This function registers a send callback for wolfSSL to write output data.

**Return Values**

None

**Parameters**

**ctx** – pointer to the wolfSSH context
**cb** – function to be registered as the send callback for the wolfSSH context, **ctx**. The signature of this function must follow that as shown above in the Synopsis section.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOSend(WOLFSSH_CTX* ctx , WS_CallbackIOSend cb );
```

### wolfSSH_SetIOReadCtx()


**Synopsis**

**Description**

This function registers a context for the SSH session receive callback function.

**Return Values**

None

**Parameters**

**ssh** – pointer to WOLFSSH object
**ctx** – pointer to the context to be registered with the SSH session ( **ssh** ) receive callback
function.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOReadCtx(WOLFSSH* ssh , void* ctx );
```

### wolfSSH_SetIOWriteCtx()


**Synopsis**

**Description**

This function registers a context for the SSH session’s send callback function.

**Return Values**

None

**Parameters**

**ssh** – pointer to WOLFSSH session.
**ctx** – pointer to be registered with the SSH session’s ( **ssh** ) send callback function.

```
#include <wolfssh/ssh.h>
void wolfSSH_SetIOWriteCtx(WOLFSSH* ssh , void* ctx );
```

### wolfSSH_GetIOReadCtx()


**Synopsis**

**Description**

This function return the ioReadCtx member of the WOLFSSH structure.

**Return Values**

**Void*** - pointer to the ioReadCtx member of the WOLFSSH structure.

**Parameters**

**ssh** – pointer to WOLFSSH object

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetIOReadCtx(WOLFSSH* ssh );
```

### wolfSSH_GetIOWriteCtx()


**Synopsis**

**Description**

This function returns the ioWriteCtx member of the WOLFSSH structure.

**Return Values**

**Void*** – pointer to the ioWriteCtx member of the WOLFSSH structure.

**Parameters**

**ssh** – pointer to WOLFSSH object

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetIOWriteCtx(WOLFSSH* ssh );
```

##  User Authentication



### wolfSSH_SetUserAuth()


**Synopsis**

**Description**

The wolfSSH_SetUserAuth() function is used to set the user authentication for the
current wolfSSH context if the context does not equal NULL.

**Return Values**

None

**Parameters**

**ctx** – pointer to the wolfSSH context
**cb** – call back function for the user authentication

```
#include <wolfssh/ssh.h>
void wolfSSH_SetUserAuth(WOLFSSH_CTX* ctx ,
WS_CallbackUserAuth cb )
```

### wolfSSH_SetUserAuthCtx()


**Synopsis**

**Description**

The wolfSSH_SetUserAuthCtx() function is used to set the value of the user
authentication context in the SSH session.

**Return Values**

None

**Parameters**

**ssh** – pointer to WOLFSSH object
**userAuthCtx** – pointer to the user authentication context

```
#include <wolfssh/ssh.h>
void wolfSSH_SetUserAuthCtx(WOLFSSH* ssh , void*
userAuthCtx )
```

### wolfSSH_GetUserAuthCtx()


**Synopsis**

**Description**

The wolfSSH_GetUserAuthCtx() function is used to return the pointer to the user
authentication context.

**Return Values**

**Void*** – pointer to the user authentication context
**Null** – returns if ssh is equal to NULL

**Parameters**

**ssh** – pointer to WOLFSSH object

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetUserAuthCtx(WOLFSSH* ssh )
```

##  Set Username



### wolfSSH_SetUsername()


**Synopsis**

**Description**

Sets the username required for the SSH connection.

**Return Values**

WS_BAD_ARGUMENT
WS_SUCCESS
WS_MEMORY_E

**Parameters**

**ssh -** Pointer to wolfSSH session
**username** - The input username for the SSH connection.

```
#include <wolfssh/ssh.h>
int wolfSSH_setUsername(WOLFSSH* ssh , const char* username );
```

##  Connection Functions

### wolfSSH_accept()



**Synopsis**

**Description**

wolfSSH_accept is called on the server side and waits for an SSH client to initiate the
SSH handshake.

wolfSSL_accept() works with both blocking and non-blocking I/O. When the underlying
I/O is non-blocking, wolfSSH_accept() will return when the underlying I/O could not
satisfy the needs of wolfSSH_accept to continue the handshake. In this case, a call to
wolfSSH_get_error() will yield either **WS_WANT_READ** or **WS_WANT_WRITE**. The
calling process must then repeat the call to wolfSSH_accept when data is available to
read and wolfSSH will pick up where it left off. When using a non-blocking socket,
nothing needs to be done, but select() can be used to check for the required condition.

If the underlying I/O is blocking, wolfSSH_accept() will only return once the handshake
has been finished or an error occurred.

**Return Values**

**WS_SUCCESS** - The function succeeded.
**WS_BAD_ARGUMENT** - A parameter value was null.
**WS_FATAL_ERROR** – There was an error, call wolfSSH_get_error() for more detail

**Parameters**

**ssh** – pointer to the wolfSSH session

**See Also**

wolfSSH_stream_read()

```
#include <wolfssh/ssh.h>
int wolfSSH_accept(WOLFSSH* ssh);
```

### wolfSSH_connect()


**Synopsis**

**Description**

This function is called on the client side and initiates an SSH handshake with a server.
When this function is called, the underlying communication channel has already been
set up.

wolfSSH_connect() works with both blocking and non-blocking I/O. When the
underlying I/O is non-blocking, wolfSSH_connect() will return when the underlying I/O
could not satisfy the needs of wolfSSH_connect to continue the handshake. In this
case, a call to wolfSSH_get_error() will yield either **WS_WANT_READ** or
**WS_WANT_WRITE**. The calling process must then repeat the call to
wolfSSH_connect() when the underlying I/O is ready and wolfSSH will pick up where it
left off. When using a non-blocking socket, nothing needs to be done, but select() can
be used to check for the required condition.

If the underlying I/O is blocking, wolfSSH_connect() will only return once the handshake
has been finished or an error occurred.

**Return Values**

**WS_BAD_ARGUMENT
WS_FATAL_ERROR
WS_SUCCESS** - This will return if the call is successful.

**Parameters**

**ssh** - Pointer to wolfSSH session

```
#include <wolfssh/ssh.h>
int wolfSSH_connect(WOLFSSH* ssh);
```

### wolfSSH_shutdown()


**Synopsis**

**Description**

Closes and disconnects the SSH channel.

**Return Values**

**WS_BAD_ARGUMENT** - returned if the parameter is NULL
**WS_SUCCES** - returns when everything has been correctly shutdown

**Parameters**

**ssh -** Pointer to wolfSSH session

```
#include <wolfssh/ssh.h>
int wolfSSH_shutdown(WOLFSSH* ssh);
```

### wolfSSH_stream_read()



**Synopsis**

**Description**

wolfSSH_stream_read reads up to **bufSz** bytes from the internal decrypted data stream
buffer. The bytes are removed from the internal buffer.

wolfSSH_stream_read() works with both blocking and non-blocking I/O. When the
underlying I/O is non-blocking, wolfSSH_stream_read() will return when the underlying
I/O could not satisfy the needs of wolfSSH_stream_read to continue the read. In this
case, a call to wolfSSH_get_error() will yield either **WS_WANT_READ** or
**WS_WANT_WRITE**. The calling process must then repeat the call to
wolfSSH_stream_read when data is available to read and wolfSSH will pick up where it
left off. When using a non-blocking socket, nothing needs to be done, but select() can
be used to check for the required condition.

If the underlying I/O is blocking, wolfSSH_stream_read() will only return when data is
available or an error occurred.

**Return Values**

**>0** – number of bytes read upon success
**0** – returned on socket failure caused by either a clean connection shutdown or a
socket.
**WS_BAD_ARGUMENT** – returns if one or more parameters is equal to NULL
**WS_EOF** – returns when end of stream is reached
**WS_FATAL_ERROR** – there was an error, call **wolfSSH_get_error()** for more detail
**WS_REKEYING** if currently a rekey is in process, use wolfSSH_worker() to complete

**Parameters**

**ssh** – pointer to the wolfSSH session

```
#include <wolfssh/ssh.h>
int wolfSSH_stream_read(WOLFSSH* ssh ,
byte* buf , word32 bufSz );
```

**buf** – buffer where wolfSSH_stream_read() will place the data
**bufSz** – size of the buffer

**See Also**

wolfSSH_accept()
wolfSSH_stream_send()


### wolfSSH_stream_send()



**Synopsis**

**Description**

wolfSSH_stream_send writes **bufSz** bytes from buf to the SSH stream data buffer.
wolfSSH_stream_send() works with both blocking and non-blocking I/O. When the
underlying I/O is non-blocking, wolfSSH_stream_send() will return a want write
error when the underlying I/O could not satisfy the needs of wolfSSH_stream_send
and there is still pending data in the SSH stream data buffer to be sent. In this
case, a call to wolfSSH_get_error() will yield either **WS_WANT_READ** or
**WS_WANT_WRITE**. The calling process must then repeat the call to
wolfSSH_stream_send when the socket is ready to send and wolfSSH will send out
any pending data left in the SSH stream data buffer then pull data from the input 
**buf**. When using a non-blocking socket, nothing needs to be done, but select()
can be used to check for the required condition.    
    
If the underlying I/O is blocking, wolfSSH_stream_send() will only return when the data
has been sent or an error occurred.    
    
In cases where I/O want write/read is not the error encountered (i.e. WS_REKEYING)
then wolfSSH_worker() should be called until the internal SSH processes are completed.

**Return Values**

**>0** – number of bytes written to SSH stream data buffer upon success
**0** – returned on socket failure caused by either a clean connection shutdown or a socket
error, call **wolfSSH_get_error()** for more detail
**WS_FATAL_ERROR** – there was an error, call wolfSSH_get_error() for more detail
**WS_BAD_ARGUMENT** if any of the parameters is null
**WS_REKEYING** if currently a rekey is in process, use wolfSSH_worker() to complete

**Parameters**

**ssh** – pointer to the wolfSSH session
**buf** – buffer wolfSSH_stream_send() will send

```
#include <wolfssh/ssh.h>
int wolfSSH_stream_send(WOLFSSH* ssh , byte* buf , word32
bufSz );
```

**bufSz** – size of the buffer

**See Also**

wolfSSH_accept()
wolfSSH_stream_read()


### wolfSSH_stream_exit()


**Synopsis**

**Description**

This function is used to exit the SSH stream.

**Return Values**

**WS_BAD_ARGUMENT** - returned if a parameter value is NULL
**WS_SUCCESS** - returns if function was a success

**Parameters**

**ssh** – Pointer to wolfSSH session
**status** – the status of the SSH connection

```
#include <wolfssh/ssh.h>
int wolfSSH_stream_exit(WOLFSSH* ssh, int status);
```

### wolfSSH_TriggerKeyExchange()


**Synopsis**

**Description**

Triggers key exchange process. Prepares and sends packet of allocated handshake
info.

**Return Values**

**WS_BAD_ARGUEMENT** – if **ssh** is NULL
**WS_SUCCESS**

**Parameters**

**ssh** – pointer to the wolfSSH session

```
#include <wolfssh/ssh.h>
int wolfSSH_TriggerKeyExchange(WOLFSSH* ssh );
```

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

### wolfSSH_CTX_SetChannelOpenCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelOpenCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
Open (**SSH_MSG_CHANNEL_OPEN**) message is received from the peer.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelOpenRespCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelOpenRespCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelOpen confCb,
        WS_CallbackChannelOpen failCb);
```

**Description**

Sets the callback functions, _confCb_ and _failCb_, into the wolfSSH _ctx_
used when a Channel Open Confirmation (**SSH_MSG_CHANNEL_OPEN_CONFIRMATION**)
or a Channel Open Failure (**SSH_MSG_CHANNEL_OPEN_FAILURE**) message is
received from the peer.

**Return Values**

* **WS_SUCCESS** - Setting callbacks in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelReqShellCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelReqShellCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
Request (**SSH_MSG_CHANNEL_REQUEST**) message is received from the peer for
a _shell_.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelReqSubsysCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelReqSubsysCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
Request (**SSH_MSG_CHANNEL_REQUEST**) message is received from the peer for
a _subsystem_. A common example of a subsystem is SFTP.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelReqExecCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelReqExecCb(WOLFSSH_CTX* ctx,
        WS_CallbackChannelReq cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
Request (**SSH_MSG_CHANNEL_REQUEST**) message is received from the peer for
a command to _exec_.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelEofCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelEof(WOLFSSH_CTX* ctx,
        WS_CallbackChannelEof cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
EOF (**SSH_MSG_CHANNEL_EOF**) message is received from the peer. This
message indicates that the peer isn't going to transmit any more data on this
channel.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_CTX_SetChannelCloseCb

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_CTX_SetChannelClose(WOLFSSH_CTX* ctx,
        WS_CallbackChannelClose cb);
```

**Description**

Sets the callback function, _cb_, into the wolfSSH _ctx_ used when a Channel
Close (**SSH_MSG_CHANNEL_CLOSE**) message is received from the peer. This
message indicates that the peer is interested in terminating this channel.

**Return Values**

* **WS_SUCCESS** - Setting callback in _ctx_ was successful
* **WS_SSH_CTX_NULL_E** - _ctx_ is **NULL**


### wolfSSH_SetChannelOpenCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_SetChannelOpenCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the context, _ctx_, into the wolfSSH _ssh_ object used when the callback
for the Channel Open (**SSH_MSG_CHANNEL_OPEN**) message, Channel Open
Confirmation (**SSH_MSG_CHANNEL_CONFIRMATION**) message, or Channel Open
Failure (**SSH_MSG_CHANNEL_FAILURE**) is received from the peer.

**Return Values**

* **WS_SUCCESS** - Setting context in _ssh_ was successful
* **WS_SSH_NULL_E** - _ssh_ is **NULL**


### wolfSSH_SetChannelReqCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_SetChannelReqCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the context, _ctx_, into the wolfSSH _ssh_ object used when the callback
for the Channel Request (**SSH_MSG_CHANNEL_REQUEST**) message is received from
the peer.

**Return Values**

* **WS_SUCCESS** - Setting context in _ssh_ was successful
* **WS_SSH_NULL_E** - _ssh_ is **NULL**


### wolfSSH_SetChannelEofCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_SetChannelEofCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the context, _ctx_, into the wolfSSH _ssh_ object used when the callback
for the Channel EOF (**SSH_MSG_CHANNEL_EOF**) message is received from
the peer.

**Return Values**

* **WS_SUCCESS** - Setting context in _ssh_ was successful
* **WS_SSH_NULL_E** - _ssh_ is **NULL**


### wolfSSH_SetChannelCloseCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
int wolfSSH_SetChannelCloseCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the context, _ctx_, into the wolfSSH _ssh_ object used when the callback
for the Channel Close (**SSH_MSG_CHANNEL_CLOSE**) message is received from
the peer.

**Return Values**

* **WS_SUCCESS** - Setting context in _ssh_ was successful
* **WS_SSH_NULL_E** - _ssh_ is **NULL**


### wolfSSH_GetChannelOpenCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetChannelOpenCtx(WOLFSSH* ssh);
```

**Description**

Gets the context from the wolfSSH _ssh_ object used when the callback for the
Channel Open (**SSH_MSG_CHANNEL_OPEN**) message.

**Return Values**

* pointer to the context data


### wolfSSH_GetChannelReqCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetChannelReqCtx(WOLFSSH* ssh);
```

**Description**

Gets the context from the wolfSSH _ssh_ object used when the callback for the
Channel Request (**SSH_MSG_CHANNEL_REQUEST**) message.

**Return Values**

* pointer to the context data


### wolfSSH_GetChannelEofCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetChannelEofCtx(WOLFSSH* ssh);
```

**Description**

Gets the context from the wolfSSH _ssh_ object used when the callback for the
Channel EOF (**SSH_MSG_CHANNEL_EOF**) message.

**Return Values**

* pointer to the context data


### wolfSSH_GetChannelCloseCtx

**Synopsis**

```
#include <wolfssh/ssh.h>
void* wolfSSH_GetChannelCloseCtx(WOLFSSH* ssh);
```

**Description**

Gets the context from the wolfSSH _ssh_ object used when the callback for the
Channel Close (**SSH_MSG_CHANNEL_CLOSE**) message.

**Return Values**

* pointer to the context data


### wolfSSH_ChannelGetSessionType

**Synopsis**

```
#include <wolfssh/ssh.h>
WS_SessionType wolfSSH_ChannelGetSessionType(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns the **WS_SessionType** for the specified _channel_.

**Return Values**

* **WS_SessionType** - type for the session


### wolfSSH_ChannelGetSessionCommand

**Synopsis**

```
#include <wolfssh/ssh.h>
const char* wolfSSH_ChannelGetSessionCommand(const WOLFSSH_CHANNEL* channel);
```

**Description**

Returns a pointer to the command the user wishes to execute over the specified
_channel_.

**Return Values**

* **const char*** - pointer to the string holding the command sent by the user


##  Testing Functions


### wolfSSH_GetStats()


**Synopsis**

**Description**

Updates **txCount** , **rxCount** , **seq** , and **peerSeq** with their respective **ssh** session
statistics.

**Return Values**

none

**Parameters**

**ssh** – pointer to the wolfSSH session
**txCount** – address where total transferred bytes in **ssh** session are stored.
**rxCount** – address where total received bytes in **ssh** session are stored.
**seq** – packet sequence number is initially 0 and is incremented after every packet
**peerSeq** – peer packet sequence number is initially 0 and is incremented after every
packet

```
#include <wolfssh/ssh.h>
void wolfSSH_GetStats(WOLFSSH* ssh , word32* txCount , word32*
rxCount ,
word32* seq , word32* peerSeq )
```

### wolfSSH_KDF()


**Synopsis**

**Description**

This is used so that the API test can do known answer tests for the key derivation.

The Key Derivation Function derives a symmetric **key** based on source keying material,
**k** and **h**. Where **k** is the Diffie-Hellman shared secret and **h** is the hash of the
handshake that was produced during initial key exchange. Multiple types of keys could
be derived which are specified by the **keyId** and **hashId**.

```
Initial IV client to server: keyId = A
Initial IV server to client: keyId = B
Encryption key client to server: keyId = C
Encryption key server to client: keyId = D
Integrity key client to server: keyId = E
Integrity key server to client : keyId = F
```
**Return Values**

WS_SUCCESS
WS_CRYPTO_FAILED

**Parameters**

**hashId** – type of hash to generate keying material.
e.g. ( WC_HASH_TYPE_SHA and WC_HASH_TYPE_SHA256 )
**keyId** – letter A - F to indicate which key to make
**key** – generated key used for comparisons to expected key

```
#include <wolfssh/ssh.h>
int wolfSSH_KDF(byte hashId , byte keyId , byte* key , word32
keySz ,
const byte* k , word32 kSz , const byte* h , word32
hSz ,
const byte* sessionId , word32 sessionIdSz );
```

**keySz** – needed size of **key
k** – shared secret from the Diffie-Hellman key exchange
**kSz** – size of the shared secret ( **k** )
**h** – hash of the handshake that was produced during key exchange
**hSz** – size of the hash ( **h** )
**sessionId** – unique identifier from first **h** calculated.
**sessionIdSz** – size of the **sessionId**


##  Session Functions



### wolfSSH_GetSessionType()


**Synopsis**

**Description**

The wolfSSH_GetSessionType() is used to return the type of session

**Return Values**

WOLFSSH_SESSION_UNKNOWN
WOLFSSH_SESSION_SHELL
WOLFSSH_SESSION_EXEC
WOLFSSH_SESSION_SUBSYSTEM

**Parameters**

**ssh -** pointer to wolfSSH session

```
#include <wolfssh/ssh.h>
WS_SessionType wolfSSH_GetSessionType(const WOLFSSH* ssh );
```

### wolfSSH_GetSessionCommand()


**Synopsis**

**Description**

This function is used to return the current command in the session.

**Return Values**

**const char*** - Pointer to command

**Parameters**

**ssh -** pointer to wolfSSH session

```
#include <wolfssh/ssh.h>
const char* wolfSSH_GetSessionCommand(const WOLFSSH* ssh );
```

##  Port Forwarding Functions



### wolfSSH_ChannelFwdNew()


**Synopsis**

**Description**

Sets up a TCP/IP forwarding channel on a WOLFSSH session. When the SSH session
is connected and authenticated, a local listener is created on the interface for address
_host_ on port _hostPort_. Any new connections on that listener will trigger a new channel
request to the SSH server to establish a connection to _host_ on port _hostPort_.

**Return Values**

**WOLFSSH_CHAN*** – NULL on error or new channel record

**Parameters**

**ssh** – wolfSSH session
**host** – host address to bind listener
**hostPort** – host port to bind listener
**origin** – IP address of the originating connection
**originPort** – port number of the originating connection

```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh ,
const char* host , word32 hostPort ,
const char* origin , word32 originPort );
```

### wolfSSH_ChannelFree()


**Synopsis**

**Description**

Releases the memory allocated for the channel _channel_. The channel is removed from
its session’s channel list.

**Return Values**

**int** – error code

**Parameters**

**channel** – wolfSSH channel to free

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelFree(WOLFSSH_CHANNEL* channel );
```

### wolfSSH_worker()


**Synopsis**

**Description**

The wolfSSH worker function babysits the connection and as data is received
processes it. SSH sessions have many bookkeeping messages for the session and this
takes care of them automatically. When data for a particular channel is received, the
worker places the data into the channel. (The function wolfSSH_stream_read() does
much the same but also returns the receive data for a single channel.)
wolfSSH_worker() will perform the following actions:

1. Attempt to send any pending data in the _outputBuffer_.
2. Call _DoReceive()_ on the session’s socket.
3. If data is received for a particular channel, return data received notice and set the
    channel ID.

**Return Values**

**int** – error or status
**WS_CHANNEL_RXD** – data has been received on a channel and the ID is set

**Parameters**

**ssh** – pointer to the wolfSSH session
**id** – pointer to the location to save the ID value

```
#include <wolfssh/ssh.h>
int wolfSSH_worker(WOLFSSH* ssh , word32* channelId );
```

### wolfSSH_ChannelGetId()


**Synopsis**

**Description**

Given a channel, returns the ID or peer’s ID for the channel.

**Return Values**

**int** – error code

**Parameters**

**channel** – pointer to channel
**id** – pointer to location to save the ID value
**peer** – either self (my channel ID) or peer (my peer’s channel ID)

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelGetId(WOLFSSH_CHANNEL* channel ,
word32* id , byte peer );
```

### wolfSSH_ChannelFind()


**Synopsis**

**Description**

Given a session _ssh_ , find the channel associated with _id_.

**Return Values**

**WOLFSSH_CHANNEL*** – pointer to the channel, NULL if the ID isn’t in the list

**Parameters**

**ssh** – wolfSSH session
**id** – channel ID to find
**peer** – either self (my channel ID) or peer (my peer’s channel ID)

```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFind(WOLFSSH* ssh ,
word32 id , byte peer );
```

### wolfSSH_ChannelRead()


**Synopsis**

**Description**

Copies data out of a channel object.

**Return Values**

**int** – bytes read
**>0** – number of bytes read upon success
**0** – returns on socket failure cause by either a clean connection shutdown or a
socket error, call wolfSSH_get_error() for more detail
**WS_FATAL_ERROR** – there was some other error, call wolfSSH_get_error() for
more detail

**Parameters**

**channel** – pointer to the wolfSSH channel
**buf** – buffer where wolfSSH_ChannelRead will place the data
**bufSz** – size of the buffer

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelRead(WOLFSSH_CHANNEL* channel ,
byte* buf , word32 bufSz );
```

### wolfSSH_ChannelSend()


**Synopsis**

**Description**

Sends data to the peer via the specified channel. Data is packaged into a channel data
message. This will send as much data as possible via the peer socket. If there is more
to be sent, calls to _wolfSSH_worker()_ will continue sending more data for the channel to
the peer.

**Return Values**

**int** – bytes sent
**>0** – number of bytes sent upon success
**0** – returns on socket failure cause by either a clean connection shutdown or a
socket error, call wolfSSH_get_error() for more detail
**WS_FATAL_ERROR** – there was some other error, call wolfSSH_get_error() for
more detail

**Parameters**

**channel** – pointer to the wolfSSH channel
**buf** – buffer wolfSSH_ChannelSend() will send
**bufSz** – size of the buffer

```
#include <wolfssh/ssh.h>
int* wolfSSH_ChannelSend(WOLFSSH_CHANNEL* channel ,
const byte* buf , word32 bufSz );
```

### wolfSSH_ChannelExit()


**Synopsis**

**Description**

Terminates a channel, sending the close message to the peer, marks the channel as
closed. This does not free the channel and it remains on the channel list. After closure,
data can not be sent on the channel, but data may still be available to be received. (At
the moment, it sends EOF, close, and deletes the channel.)

**Return Values**

**int** – error code

**Parameters**

**channel** – wolfSSH session channel

```
#include <wolfssh/ssh.h>
int wolfSSH_ChannelExit(WOLFSSH_CHANNEL* channel );
```

### wolfSSH_ChannelNext()


**Synopsis**

**Description**

Returns the next channel after _channel_ in _ssh_ ’s channel list. If _channel_ is NULL, the first
channel from the channel list for _ssh_ is returned.

**Return Values**

**WOLFSSH_CHANNEL*** – pointer to either the first channel, next channel, or NULL

**Parameters**

**ssh** – wolfSSH session
**channel** – wolfSSH session channel

```
#include <wolfssh/ssh.h>
WOLFSSH_CHANNEL* wolfSSH_ChannelFwdNew(WOLFSSH* ssh ,
WOLFSSH_CHANNEL* channel );
```


##  Key Load Functions


### wolfSSH_ReadKey_buffer()

**Synopsis**

```
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_buffer(const byte* in, word32 inSz,
        int format, byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        void* heap);
```

**Description**

Reads a key file from the buffer _in_ of size _inSz_ and tries to decode it
as a _format_ type key. The _format_ can be **WOLFSSH_FORMAT_ASN1**,
**WOLFSSH_FORMAT_PEM**, **WOLFSSH_FORMAT_SSH**, or **WOLFSSH_FORMAT_OPENSSH**.
The key ready for use by `wolfSSH_UsePrivateKey_buffer()` is stored in the
buffer pointed to by _out_, of size _outSz_. If _out_ is NULL, _heap_ is used
to allocate a buffer for the key. The type string of the key is stored in
_outType_, with its string length in _outTypeSz_.

**Return Values**

* **WS_SUCCESS** - read key is successful
* **WS_BAD_ARGUMENT** - parameter has a bad value
* **WS_MEMORY_E** - failure allocating memory
* **WS_BUFFER_E** - buffer not large enough for indicated size
* **WS_PARSE_E** - problem parsing the key file
* **WS_UNIMPLEMENTED_E** - key type not supported
* **WS_RSA_E** - something wrong with RSA (PKCS1) key
* **WS_ECC_E** - something wrong with ECC (X9.63) key
* **WS_KEY_AUTH_MAGIC_E** - OpenSSH key auth magic value bad
* **WS_KEY_FORMAT_E** - OpenSSH key format incorrect
* **WS_KEY_CHECK_VAL_E** - OpenSSH key check value corrupt


### wolfSSH_ReadKey_file()

**Synopsis**

```
#include <wolfssh/ssh.h>

int wolfSSH_ReadKey_file(const char* name,
        byte** out, word32* outSz,
        const byte** outType, word32* outTypeSz,
        byte* isPrivate, void* heap);
```

**Description**

Reads the key from the file _name_. The format is guessed based on data in
the file. The key buffer _out_, the key type _outType_, and their sizes
are passed to `wolfSSH_ReadKey_buffer()`. The flag _isPrivate_ is set
as appropriate. Any memory allocations use the specified _heap_.

**Return Values**

* **WS_SUCCESS** - read key is successful
* **WS_BAD_ARGUMENT** - parameter has a bad value
* **WS_BAD_FILE_E** - problem reading the file
* **WS_MEMORY_E** - failure allocating memory
* **WS_BUFFER_E** - buffer not large enough for indicated size
* **WS_PARSE_E** - problem parsing the key file
* **WS_UNIMPLEMENTED_E** - key type not supported
* **WS_RSA_E** - something wrong with RSA (PKCS1) key
* **WS_ECC_E** - something wrong with ECC (X9.63) key
* **WS_KEY_AUTH_MAGIC_E** - OpenSSH key auth magic value bad
* **WS_KEY_FORMAT_E** - OpenSSH key format incorrect
* **WS_KEY_CHECK_VAL_E** - OpenSSH key check value corrupt


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

**Synopsis**

```
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

* **WS_SUCCESS** - successful
* **WS_SSH_CTX_NULL_E** - provided CTX was null
* **WS_SSH_NULL_E** - provide SSH was null


### wolfSSH Get Algo List

**Synopsis**

```
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


### wolfSSH_CheckAlgoName

**Synopsis**

```
#include <wolfssh/ssh.h>

int wolfSSH_CheckAlgoName(const char* name);
```

**Description**

Given a single algorithm _name_ checks to see if it is valid.

**Return Values**

* **WS_SUCCESS** - _name_ is a valid algorithm name
* **WS_INVALID_ALGO_ID** - _name_ is an invalid algorithm name


### wolfSSH Query Algorithms

**Synopsis**

```
#include <wolfssh/ssh.h>

const char* wolfSSH_QueryKex(word32* index);
const char* wolfSSH_QueryKey(word32* index);
const char* wolfSSH_QueryCipher(word32* index);
const char* wolfSSH_QueryMac(word32* index);
```

**Description**

Returns the name string for a valid algorithm of the particular type: Kex,
Key, Cipher, or Mac. Note, Key types are also used for the user authentication
accepted key types. The value passed as _index_ must be initialized to 0,
the passed in on each call to the function. At the end of the list, the
_index_ is invalid.

**Return Values**

Returns a constant string with the name of an algorithm. Null indicates the
end of the list.
