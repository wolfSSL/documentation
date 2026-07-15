# wolfSSH SCP API Reference

This section describes the public application programming interface for SCP
(Secure Copy) file transfer in wolfSSH.

All functions in this chapter require wolfSSH to be built with SCP support
(`WOLFSSH_SCP`, from `./configure --enable-scp`).

##  SCP Transfer Functions

### wolfSSH_SCP_connect()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_connect(WOLFSSH* ssh, byte* cmd);
```

**Description**

Initiates an SCP session over an established SSH connection by sending the SCP
command `cmd` to the server. Called on the client side before transferring
files.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `cmd` - the SCP command to send to the server

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SCP_to()`
- `wolfSSH_SCP_from()`

### wolfSSH_SCP_to()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_to(WOLFSSH* ssh, const char* src, const char* dst);
```

**Description**

Sends (uploads) the local file or directory `src` to the remote destination
`dst` over the SSH connection. Called on the client side.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `src` - path to the local source file or directory
- `dst` - destination path on the remote peer

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SCP_from()`
- `wolfSSH_SCP_connect()`

### wolfSSH_SCP_from()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_from(WOLFSSH* ssh, const char* src, const char* dst);
```

**Description**

Retrieves (downloads) the remote file or directory `src` from the peer and
writes it to the local destination `dst` over the SSH connection. Called on the
client side.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `src` - path to the source file or directory on the remote peer
- `dst` - destination path on the local system

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SCP_to()`
- `wolfSSH_SCP_connect()`

### wolfSSH_SetScpErrorMsg()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SetScpErrorMsg(WOLFSSH* ssh, const char* message);
```

**Description**

Sets a custom error message string on the session, which is reported to the peer
when an SCP transfer fails.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `message` - null-terminated error message to report

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  SCP Callbacks

When using SCP with application-managed storage (for example, on systems without
a filesystem, or to filter transfers), the application registers send and receive
callbacks. Each callback may be given a user context pointer.

### wolfSSH_SetScpRecv()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpRecv(WOLFSSH_CTX* ctx, WS_CallbackScpRecv cb);
```

**Description**

Registers the SCP receive callback on the context. The callback is invoked as
incoming files are received, allowing the application to store the data itself.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the SCP receive callback

**Return Values**

None

**See Also**

- `wolfSSH_SetScpRecvCtx()`
- `wolfSSH_SetScpSend()`

### wolfSSH_SetScpSend()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpSend(WOLFSSH_CTX* ctx, WS_CallbackScpSend cb);
```

**Description**

Registers the SCP send callback on the context. The callback is invoked when the
peer requests files, allowing the application to supply the data itself.

**Parameters**

- `ctx` - pointer to the wolfSSH context
- `cb` - the SCP send callback

**Return Values**

None

**See Also**

- `wolfSSH_SetScpSendCtx()`
- `wolfSSH_SetScpRecv()`

### wolfSSH_SetScpRecvCtx()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpRecvCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the SCP receive callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the receive callback

**Return Values**

None

**See Also**

- `wolfSSH_GetScpRecvCtx()`

### wolfSSH_SetScpSendCtx()

```c
#include <wolfssh/wolfscp.h>

void wolfSSH_SetScpSendCtx(WOLFSSH* ssh, void* ctx);
```

**Description**

Sets the user context pointer passed to the SCP send callback.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `ctx` - user context pointer to pass to the send callback

**Return Values**

None

**See Also**

- `wolfSSH_GetScpSendCtx()`

### wolfSSH_GetScpRecvCtx()

```c
#include <wolfssh/wolfscp.h>

void* wolfSSH_GetScpRecvCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetScpRecvCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the SCP receive context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetScpRecvCtx()`

### wolfSSH_GetScpSendCtx()

```c
#include <wolfssh/wolfscp.h>

void* wolfSSH_GetScpSendCtx(WOLFSSH* ssh);
```

**Description**

Returns the user context pointer previously set with wolfSSH_SetScpSendCtx().

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- the SCP send context pointer, or `NULL` if none

**See Also**

- `wolfSSH_SetScpSendCtx()`
