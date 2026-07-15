# wolfSSH SFTP API Reference

##  Connection Functions



### wolfSSH_SFTP_accept()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_accept(WOLFSSH* ssh);
```

**Description**

Handles an incoming SFTP connection request from a client. Called on the server side after the SSH session is established.

**Parameters**

- `ssh` - pointer to the wolfSSH session used for the connection

**Return Values**

- `WS_SFTP_COMPLETE` on success
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_connect()`
- `wolfSSH_SFTP_negotiate()`

### wolfSSH_SFTP_connect()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_connect(WOLFSSH* ssh);
```

**Description**

Initiates an SFTP connection to a server. Called on the client side after the SSH session is established.

**Parameters**

- `ssh` - pointer to the wolfSSH session used for the connection

**Return Values**

- `WS_SFTP_COMPLETE` on success
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_negotiate()`

### wolfSSH_SFTP_negotiate()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_negotiate(WOLFSSH* ssh);
```

**Description**

Performs SFTP protocol negotiation. Depending on which side the session was created for, this either handles an incoming connection from a client or sends a connection request to a server.

**Parameters**

- `ssh` - pointer to the wolfSSH session used for the connection

**Return Values**

- `WS_SUCCESS` on success
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_connect()`


### wolfSSH_SFTP_SetDefaultPath()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SetDefaultPath(WOLFSSH* ssh, const char* path);
```

**Description**

Sets the default (starting) directory for the SFTP session. On the server side this is the base directory against which relative paths are resolved.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `path` - the default path to set

**Return Values**

- `WS_SUCCESS`
- `WS_BAD_ARGUMENT`

##  Protocol Level Functions



### wolfSSH_SFTP_RealPath()



```c
#include <wolfssh/wolfsftp.h>

WS_SFTPNAME* wolfSSH_SFTP_RealPath(WOLFSSH* ssh, char* dir);
```

**Description**

Sends a REALPATH request to the peer and returns the canonical name of the file or directory. The returned `WS_SFTPNAME` must be freed with wolfSSH_SFTPNAME_free().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - the file or directory name to resolve

**Return Values**

- pointer to a `WS_SFTPNAME` structure on success
- `NULL` on error

**See Also**

- `wolfSSH_SFTPNAME_free()`

### wolfSSH_SFTP_Close()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Close(WOLFSSH* ssh, byte* handle, word32 handleSz);
```

**Description**

Sends a close request to the peer for the given file handle, which was obtained from a previous call to wolfSSH_SFTP_Open().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `handle` - the file handle to close
- `handleSz` - size of the handle buffer

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_Open()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Open(WOLFSSH* ssh, char* dir, word32 reason,
        WS_SFTP_FILEATRB* atr, byte* handle, word32* handleSz);
```

**Description**

Sends an open request to the peer for the file named by `dir`. On success the resulting file handle is placed in `handle` and its size is written to `handleSz`. The `reason` argument is a bitmask of the open flags: `WOLFSSH_FXF_READ`, `WOLFSSH_FXF_WRITE`, `WOLFSSH_FXF_APPEND`, `WOLFSSH_FXF_CREAT`, `WOLFSSH_FXF_TRUNC`, or `WOLFSSH_FXF_EXCL`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - name of the file to open
- `reason` - bitmask of open flags (see above)
- `atr` - initial file attributes
- `handle` - output buffer for the resulting file handle
- `handleSz` - on input the buffer size, set on output to the handle size

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_Close()`
- `wolfSSH_SFTP_SendReadPacket()`
- `wolfSSH_SFTP_SendWritePacket()`

### wolfSSH_SFTP_SendReadPacket()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SendReadPacket(WOLFSSH* ssh, byte* handle,
        word32 handleSz, const word32* ofst, byte* out, word32 outSz);
```

**Description**

Sends a read request to the peer for the file referenced by `handle` (obtained from wolfSSH_SFTP_Open()). The bytes read are placed into the `out` buffer. The `ofst` argument points to the file offset to read from.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `handle` - the file handle to read from
- `handleSz` - size of the handle buffer
- `ofst` - pointer to the file offset to start reading from
- `out` - buffer to hold the data read
- `outSz` - size of the output buffer

**Return Values**

- greater than or equal to 0 - number of bytes read on success
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_SendWritePacket()`
- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_SendWritePacket()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SendWritePacket(WOLFSSH* ssh, byte* handle,
        word32 handleSz, const word32* ofst, byte* out, word32 outSz);
```

**Description**

Sends a write request to the peer for the file referenced by `handle` (obtained from wolfSSH_SFTP_Open()), writing the contents of the `out` buffer. The `ofst` argument points to the file offset to write at.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `handle` - the file handle to write to
- `handleSz` - size of the handle buffer
- `ofst` - pointer to the file offset to start writing at
- `out` - buffer of data to send to the peer
- `outSz` - size of the buffer

**Return Values**

- greater than or equal to 0 - number of bytes written on success
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_SendReadPacket()`
- `wolfSSH_SFTP_Open()`

### wolfSSH_SFTP_STAT()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_STAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**Description**

Sends a STAT request to the peer to retrieve the attributes of a file or directory, following symbolic links. If the target does not exist, the peer returns an error and this function returns an error value.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - null-terminated name of the file or directory
- `atr` - structure that receives the resulting attributes

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_LSTAT()`
- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_LSTAT()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_LSTAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**Description**

Sends an LSTAT request to the peer to retrieve the attributes of a file or directory. Unlike wolfSSH_SFTP_STAT(), LSTAT does not follow symbolic links: it returns the attributes of the link itself. If the target does not exist, the peer returns an error and this function returns an error value.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - null-terminated name of the file or directory
- `atr` - structure that receives the resulting attributes

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_STAT()`
- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_SetSTAT()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SetSTAT(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**Description**

Sends a SETSTAT request to the peer to apply the attributes in `atr` (for example permissions, size, or timestamps) to the named file or directory.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - null-terminated name of the file or directory
- `atr` - the attributes to apply

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_STAT()`

### wolfSSH_SFTPNAME_free()

```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTPNAME_free(WS_SFTPNAME* n);
```

**Description**

Frees a single `WS_SFTPNAME` node. If the node is in the middle of a list, freeing it breaks the list; use wolfSSH_SFTPNAME_list_free() to free an entire list.

**Parameters**

- `n` - the `WS_SFTPNAME` node to free

**Return Values**

None

**See Also**

- `wolfSSH_SFTPNAME_list_free()`

### wolfSSH_SFTPNAME_list_free()

```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTPNAME_list_free(WS_SFTPNAME* n);
```

**Description**

Frees an entire list of `WS_SFTPNAME` nodes, such as the list returned by wolfSSH_SFTP_LS().

**Parameters**

- `n` - head of the `WS_SFTPNAME` list to free

**Return Values**

None

**See Also**

- `wolfSSH_SFTPNAME_free()`

##  Reget / Reput Functions

### wolfSSH_SFTP_SaveOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_SaveOfst(WOLFSSH* ssh, char* frm, char* to,
        const word32* ofst);
```

**Description**

Saves the transfer offset for an interrupted get or put, keyed by the source (`frm`) and destination (`to`) paths. The saved offset can later be recovered with wolfSSH_SFTP_GetOfst().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `frm` - null-terminated source path
- `to` - null-terminated destination path
- `ofst` - pointer to the offset to save

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_GetOfst()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_GetOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_GetOfst(WOLFSSH* ssh, char* frm, char* to,
        word32* ofst);
```

**Description**

Retrieves the saved transfer offset for an interrupted get or put, keyed by the source (`frm`) and destination (`to`) paths, writing it to `ofst`. If no saved offset is found, `ofst` is set to 0.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `frm` - null-terminated source path
- `to` - null-terminated destination path
- `ofst` - output for the saved offset

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_ClearOfst()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_ClearOfst(WOLFSSH* ssh);
```

**Description**

Clears all stored transfer offsets for the session.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_GetOfst()`

### wolfSSH_SFTP_Interrupt()



```c
#include <wolfssh/wolfsftp.h>

void wolfSSH_SFTP_Interrupt(WOLFSSH* ssh);
```

**Description**

Sets the interrupt flag on the session to stop an in-progress get or put transfer. The current offset can be saved with wolfSSH_SFTP_SaveOfst() so the transfer can be resumed later.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

None

**See Also**

- `wolfSSH_SFTP_SaveOfst()`
- `wolfSSH_SFTP_GetOfst()`

##  Command Functions



### wolfSSH_SFTP_Remove()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Remove(WOLFSSH* ssh, char* f);
```

**Description**

Sends a remove request to the peer to delete the file named by `f`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `f` - null-terminated name of the file to remove

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_RMDIR()`

### wolfSSH_SFTP_MKDIR()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_MKDIR(WOLFSSH* ssh, char* dir, WS_SFTP_FILEATRB* atr);
```

**Description**

Sends a mkdir request to the peer to create the directory named by `dir`. The `atr` attributes are currently not used; default attributes are applied instead.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - null-terminated name of the directory to create
- `atr` - attributes for the new directory (currently unused)

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_RMDIR()`

### wolfSSH_SFTP_RMDIR()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_RMDIR(WOLFSSH* ssh, char* dir);
```

**Description**

Sends an rmdir request to the peer to delete the directory named by `dir`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - null-terminated name of the directory to remove

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_MKDIR()`

### wolfSSH_SFTP_Rename()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Rename(WOLFSSH* ssh, const char* old, const char* nw);
```

**Description**

Sends a rename request to the peer, renaming the file `old` to `nw`.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `old` - the current file name
- `nw` - the new file name

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_Remove()`

### wolfSSH_SFTP_LS()



```c
#include <wolfssh/wolfsftp.h>

WS_SFTPNAME* wolfSSH_SFTP_LS(WOLFSSH* ssh, char* dir);
```

**Description**

Lists the files and directories in `dir`. This is a high-level helper that performs the REALPATH, OPENDIR, READDIR, and CLOSE operations. The returned list must be freed with wolfSSH_SFTPNAME_list_free().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `dir` - the directory to list

**Return Values**

- pointer to a list of `WS_SFTPNAME` structures on success
- `NULL` on failure

**See Also**

- `wolfSSH_SFTPNAME_list_free()`
- `wolfSSH_SFTP_RealPath()`

### wolfSSH_SFTP_CHMOD()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_CHMOD(WOLFSSH* ssh, char* n, char* oct);
```

**Description**

Changes the permission bits of the file or directory `n` to the mode given by the octal string `oct` (for example, "644"). Implemented by sending a SETSTAT request with the new permissions.

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `n` - null-terminated name of the file or directory
- `oct` - octal permission string (for example, "755")

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_SetSTAT()`

### wolfSSH_SFTP_Get()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Get(WOLFSSH* ssh, char* from, char* to,
        byte resume, WS_STATUS_CB* statusCb);
```

**Description**

Downloads a file from the peer to a local path. This is a high-level helper that performs the LSTAT, OPEN, READ, and CLOSE operations. A transfer in progress can be interrupted with wolfSSH_SFTP_Interrupt().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `from` - the remote file name to get
- `to` - the local path to write the file to
- `resume` - non-zero to resume a previously interrupted transfer, 0 otherwise
- `statusCb` - callback invoked with transfer progress, or `NULL`

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_Put()`
- `wolfSSH_SFTP_Interrupt()`

### wolfSSH_SFTP_Put()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_Put(WOLFSSH* ssh, char* from, char* to,
        byte resume, WS_STATUS_CB* statusCb);
```

**Description**

Uploads a local file to the peer. This is a high-level helper that performs the OPEN, WRITE, and CLOSE operations. A transfer in progress can be interrupted with wolfSSH_SFTP_Interrupt().

**Parameters**

- `ssh` - pointer to the wolfSSH session
- `from` - the local file name to push
- `to` - the remote path to write the file to
- `resume` - non-zero to resume a previously interrupted transfer, 0 otherwise
- `statusCb` - callback invoked with transfer progress, or `NULL`

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_Get()`
- `wolfSSH_SFTP_Interrupt()`

##  SFTP Server Functions



### wolfSSH_SFTP_read()



```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_read(WOLFSSH* ssh);
```

**Description**

The main server-side SFTP entry point. Reads from the I/O buffer and dispatches to the appropriate internal handler based on the SFTP packet type received. Call this from the server loop to service SFTP requests.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- `WS_SUCCESS`
- a negative error code on failure

**See Also**

- `wolfSSH_SFTP_accept()`
- `wolfSSH_SFTP_PendingSend()`

### wolfSSH_SFTP_PendingSend()

```c
#include <wolfssh/wolfsftp.h>

int wolfSSH_SFTP_PendingSend(WOLFSSH* ssh);
```

**Description**

Reports whether the SFTP layer has buffered outbound data still waiting to be sent. This is useful when driving non-blocking I/O to know that another send attempt is needed.

**Parameters**

- `ssh` - pointer to the wolfSSH session

**Return Values**

- non-zero if there is pending data to send
- 0 if there is no pending data

**See Also**

- `wolfSSH_SFTP_read()`

