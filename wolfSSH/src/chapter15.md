# wolfSSH SCP API Reference

This section describes the public application programming interface for SCP
(Secure Copy) file transfer in wolfSSH.

All functions in this chapter require wolfSSH to be built with SCP support
(`WOLFSSH_SCP`, from `./configure --enable-scp`). The client-side transfer
functions wolfSSH_SCP_connect(), wolfSSH_SCP_to(), and wolfSSH_SCP_from() are
not available when the client is compiled out (`NO_WOLFSSH_CLIENT`). SCP is
available in a client-only build.

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

### wolfSSH_SCP_accept()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SCP_accept(WOLFSSH* ssh);
```

**Description**

Server side. Runs an SCP transfer on a session whose channel already carries a
bound "exec scp ..." command. This is the same work wolfSSH_accept() performs
when it returns `WS_SCP_INIT` and is called again. It is exposed so that an
application that binds the `scp` command to a channel itself, such as one using
application-driven channels, can start the transfer. Use either this function or
the wolfSSH_accept() path for a given transfer, not both.

Call it after wolfSSH_accept() has returned and the exec channel-request
callback has reported an SCP command. Do not call it from inside that callback.
Like wolfSSH_SFTP_accept(), it works on the first channel in the session's
channel list. The SCP receive callback must be set; the default callbacks are
installed on a new context unless `WOLFSSH_SCP_USER_CALLBACKS` is defined.

On a non-blocking socket the function returns `WS_WANT_READ` or `WS_WANT_WRITE`
with the transfer partly done. Call it again on the same session until it
returns `WS_SCP_COMPLETE`. A pending `WS_WANT_READ` or `WS_WANT_WRITE` recorded
in the session is cleared at the start of each call.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SCP_COMPLETE` when the transfer is done
- `WS_WANT_READ` or `WS_WANT_WRITE` when the transfer needs to be resumed
- `WS_BAD_ARGUMENT` if `ssh` is `NULL` or no SCP receive callback is set
- a negative error code on failure

**See Also**

- `wolfSSH_ChannelCommandIsScp()`
- `wolfSSH_SetScpRecv()`
- `wolfSSH_SetScpSend()`

### wolfSSH_ChannelCommandIsScp()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_ChannelCommandIsScp(const WOLFSSH_CHANNEL* channel);
```

**Description**

Reports whether the session command recorded on `channel` starts an SCP
transfer. It is intended for use from an exec channel-request callback, and
wolfSSH_accept() uses the same test, so the application and the library cannot
disagree about what starts a transfer.

The command must begin with "scp" as a token of its own: either the whole
command is "scp" or "scp" is followed by a space. A plain prefix match such as
"scpbackup" is not an SCP command. The test covers the recorded command size
rather than the string length, and a command containing a NUL byte anywhere
within that size is not treated as an SCP command, because the parser that
serves the transfer reads a C string and would silently drop the rest.

**Parameters**

- `channel` - the channel whose session command to test

**Return Values**

- 1 if the command starts an SCP transfer
- 0 if it does not, including when the channel has no command
- `WS_BAD_ARGUMENT` if `channel` is `NULL`

**See Also**

- `wolfSSH_SCP_accept()`

### wolfSSH_SetScpErrorMsg()

```c
#include <wolfssh/wolfscp.h>

int wolfSSH_SetScpErrorMsg(WOLFSSH* ssh, const char* message);
```

**Description**

Sets a custom error message string on the session, which is reported to the peer
when an SCP transfer fails. Intended to be called from inside the SCP callbacks.
The message is copied, so the caller keeps ownership of `message`. A later call
replaces the previous message.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `message` - null-terminated error message to report

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT` if `ssh` or `message` is `NULL`
- `WS_MEMORY_E` if the copy cannot be allocated

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

The callback returns the number of bytes it placed in `buf`, one of the `WS_SCP_*`
status codes, or a negative error to abort the transfer. Its `fileNameSz`
argument is the capacity of the `fileName` buffer, not the length of a name
already in it. Returning 0 is valid only on the call that fills in the file
metadata (name, mode, times, and `totalFileSz`) before any data is ready; the
library then sends the file header and calls back with
`WOLFSSH_SCP_CONTINUE_FILE_TRANSFER`. A second 0 in a row while `fileOffset` is
still short of `totalFileSz` is treated as a stalled callback and aborts the
transfer, because the API has no "no data right now" status. A callback that
must wait for data should block rather than return 0.

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
