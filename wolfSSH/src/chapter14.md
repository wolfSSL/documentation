#  wolfSSL SFTP API Reference

##  Connection Functions



### wolfSSH_SFTP_accept()



**Synopsis:**

**Description:**

Function to handle an incoming connection request from a client.

**Return Values:**

Returns WS_SFTP_COMPLETE on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_accept(WOLFSSH* ssh );
```
```
WOLFSSH* ssh;
```
```
//create new WOLFSSH structure
...
```
```
if (wolfSSH_SFTP_accept(ssh) != WS_SUCCESS) {
//handle error case
}
```

**See Also:**

wolfSSH_SFTP_free()
wolfSSH_new()
wolfSSH_SFTP_connect()

### wolfSSH_SFTP_connect()



**Synopsis:**

**Description:**

Function for initiating a connection to a SFTP server.

**Return Values:**

**WS_SFTP_COMPLETE:** on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure to be used for connection

**Example:**

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_new()
wolfSSH_free()

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_connect(WOLFSSH* ssh );
```
```
WOLFSSH* ssh;
```
```
//after creating a new WOLFSSH structrue
```
```
wolfSSH_SFTP_connect(ssh);
```

### wolfSSH_SFTP_negotiate()



**Synopsis:**

**Description:**

Function to handle either an incoming connection from client or to send out a
connection request to a server. It is dependent on which side of the connection the
created WOLFSSH structure is set to for which action is performed.

**Return Values:**

Returns WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection

**Example:**

**See Also:**

wolfSSH_SFTP_free()

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_negotiate(WOLFSSH* ssh)
```
```
WOLFSSH* ssh;
```
```
//create new WOLFSSH structure with side of connection
set
....
```
```
if (wolfSSH_SFTP_negotiate(ssh) != WS_SUCCESS) {
//handle error case
}
```

wolfSSH_new()
wolfSSH_SFTP_connect()
wolfSSH_SFTP_accept()


##  Protocol Level Functions



### wolfSSH_SFTP_RealPath()



**Synopsis:**

**Description:**

Function to send REALPATH packet to peer. It gets the name of the file returned from
peer.

**Return Values:**

Returns a pointer to a WS_SFTPNAME structure on success and NULL on error.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - directory / file name to get real path of

**Example:**

```
#include <wolfssh/wolfsftp.h>
WS_SFTPNAME* wolfSSH_SFTP_RealPath(WOLFSSH* ssh , char*
dir );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh ;
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_read( ssh ) != WS_SUCCESS) {
//handle error case
}
```

### wolfSSH_SFTP_Close()



**Synopsis:**

**Description:**

Function to to send a close packet to the peer.

**Return Values:**

**WS_SUCCESS** on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**handle** - handle to try and close
**handleSz** - size of handle buffer

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Close(WOLFSSH* ssh , byte* handle , word32
handleSz );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_Close(ssh, handle, handleSz) !=
WS_SUCCESS) {
//handle error case
}
```

### wolfSSH_SFTP_Open()



**Synopsis:**

**Description:**

Function to to send an open packet to the peer. This sets handleSz with the size of
resulting buffer and gets the resulting handle from the peer and places it in the buffer
handle.

Available reasons for open:
WOLFSSH_FXF_READ
WOLFSSH_FXF_WRITE
WOLFSSH_FXF_APPEND
WOLFSSH_FXF_CREAT
WOLFSSH_FXF_TRUNC
WOLFSSH_FXF_EXCL

**Return Values:**

**WS_SUCCESS** on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - name of file to open
**reason** - reason for opening the file
**atr** - initial attributes for file
**handle** - resulting handle from open
**handleSz** - gets set to the size of resulting handle

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Open(WOLFSSH* ssh , char* dir , word32
reason ,
WS_SFTP_FILEATRB* atr , byte* handle , word32* handleSz ) ;
```

**Example:**

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh ;
char name[NAME_SIZE];
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
WS_SFTP_FILEATRB atr;
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_Open( ssh , name , WOLFSSH_FXF_WRITE |
WOLFSSH_FXF_APPEND | WOLFSSH_FXF_CREAT , & atr , handle ,
& handleSz )
!= WS_SUCCESS) {
//handle error case
}
```

### wolfSSH_SFTP_SendReadPacket()

**Synopsis:**

**Description:**

Function to to send a read packet to the peer. The buffer handle should contain the
result of a previous call to wolfSSH_SFTP_Open. The resulting bytes from a read are
placed into the “out” buffer.

**Return Values:**

Returns the number of bytes read on success.
A negative value is returned on failure.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**handle** - handle to try and read from
**handleSz** - size of handle buffer
**ofst** - offset to start reading from
**out** - buffer to hold result from read
**outSz** - size of out buffer

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SendReadPacket(WOLFSSH* ssh , byte*
handle , word32
handleSz , word64 ofst , byte* out , word32 outSz );
```

**See Also:**

wolfSSH_SFTP_SendWritePacket()
wolfSSH_SFTP_Open()

```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
byte out[OUT_SIZE];
word32 outSz = OUT_SIZE;
word32 ofst = 0;
int ret;
```
```
//set up ssh and do sftp connections
...
//get handle with wolfSSH_SFTP_Open()
```
```
if ((ret = wolfSSH_SFTP_SendReadPacket(ssh, handle,
handleSz, ofst,
out, outSz)) < 0) {
//handle error case
}
//ret holds the number of bytes placed into out buffer
```

### wolfSSH_SFTP_SendWritePacket()



**Synopsis:**

**Description:**

Function to send a write packet to the peer.
The buffer handle should contain the result of a previous call to
wolfSSH_SFTP_Open().

**Return Values:**

Returns the number of bytes written on success.
A negative value is returned on failure.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**handle** - handle to try and read from
**handleSz** - size of handle buffer
**ofst** - offset to start reading from
**out** - buffer to send to peer for writing
**outSz** - size of out buffer

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SendWritePacket(WOLFSSH* ssh , byte*
handle , word32
handleSz , word64 ofst , byte* out , word32 outSz );
```

**See Also:**

wolfSSH_SFTP_SendReadPacket()
wolfSSH_SFTP_Open()

```
WOLFSSH* ssh;
byte handle[HANDLE_SIZE];
word32 handleSz = HANDLE_SIZE;
byte out[OUT_SIZE];
word32 outSz = OUT_SIZE;
word32 ofst = 0;
int ret;
```
```
//set up ssh and do sftp connections
...
//get handle with wolfSSH_SFTP_Open()
```
```
if ((ret = wolfSSH_SFTP_SendWritePacket(ssh, handle,
handleSz, ofst,
out,outSz)) < 0) {
//handle error case
}
//ret holds the number of bytes written
```

### wolfSSH_SFTP_STAT()



**Synopsis:**

**Description:**

Function to send a STAT packet to the peer. This will get the attributes of file or
directory. If the file or attribute does not exist the peer will return resulting in this function
returning an error value.

**Return Values:**

**WS_SUCCESS** on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - NULL terminated name of file or directory to get attributes of
**atr** - resulting attributes are set into this structure

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_STAT(WOLFSSH* ssh , char* dir ,
WS_SFTP_FILEATRB* atr);
```

**See Also:**

wolfSSH_SFTP_LSTAT()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh;
byte name[NAME_SIZE];
int ret;
WS_SFTP_FILEATRB atr;
```
```
//set up ssh and do sftp connections
...
```
```
if ((ret = wolfSSH_SFTP_STAT(ssh, name, &atr)) < 0) {
//handle error case
}
```

### wolfSSH_SFTP_LSTAT()

**Synopsis:**

**Description:**

Function to send a LSTAT packet to the peer. This will get the attributes of file or
directory. It follows symbolic links where a STAT packet will not follow symbolic links. If
the file or attribute does not exist the peer will return resulting in this function returning
an error value.

**Return Values:**

WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - NULL terminated name of file or directory to get attributes of
**atr** - resulting attributes are set into this structure

Example:

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_LSTAT(WOLFSSH* ssh , char* dir ,
WS_SFTP_FILEATRB* atr );
```

**See Also:**

wolfSSH_SFTP_STAT()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh;
byte name[NAME_SIZE];
int ret;
WS_SFTP_FILEATRB atr;
```
```
//set up ssh and do sftp connections
...
```
```
if ((ret = wolfSSH_SFTP_LSTAT(ssh, name, &atr)) < 0) {
//handle error case
}
```

### wolfSSH_SFTPNAME_free()

**Synopsis:**

**Description:**

Function to free a single WS_SFTPNAME node. Note that if this node is in the middle of a
list of nodes then the list will be broken.

**Return Values:**

None

**Parameters:**

**name** - structure to be free’d

**Example:**

**See Also:**

```
#include <wolfssh/wolfsftp.h>
```
### void wolfSSH_SFTPNAME_free(WS_SFTPNMAE* name );

```
WOLFSSH* ssh;
WS_SFTPNAME* name;
```
```
//set up ssh and do sftp connections
...
name = wolfSSH_SFTP_RealPath(ssh, path);
if (name != NULL) {
wolfSSH_SFTPNAME_free(name);
}
```

wolfSSH_SFTPNAME_list_free

wolfSSH_SFTPNAME_list_free()



**Synopsis:**

**Description:**

Function to free a all WS_SFTPNAME nodes in a list.

**Return Values:**

None

**Parameters:**

**name** - head of list to be free’d

**Example:**

```
#include <wolfssh/wolfsftp.h>
void wolfSSH_SFTPNAME_list_free(WS_SFTPNMAE* name );
```

**See Also:**

wolfSSH_SFTPNAME_free()

```
WOLFSSH* ssh;
WS_SFTPNAME* name;
```
```
//set up ssh and do sftp connections
...
```
```
name = wolfSSH_SFTP_LS(ssh, path);
if (name != NULL) {
wolfSSH_SFTPNAME_list_free(name);
}
```

##  Reget / Reput Functions

### wolfSSH_SFTP_SaveOfst()



**Synopsis:**

**Description:**

Function to save an offset for an interrupted get or put command. The offset can be
recovered by calling wolfSSH_SFTP_GetOfst

**Return Values:**

Returns WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure for connection
**from** - NULL terminated string of source path
**to** - NULL terminated string with destination path
**ofst** - offset into file to be saved

Example:

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_SaveOfst(WOLFSSH* ssh , char* from , char*
to ,
word64 ofst );
```

**See Also:**

wolfSSH_SFTP_GetOfst()
wolfSSH_SFTP_Interrupt()

```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_SaveOfst(ssh, from, to, ofst) !=
WS_SUCCESS) {
//handle error case
}
```

### wolfSSH_SFTP_GetOfst()



**Synopsis:**

**Description:**

Function to retrieve an offset for an interrupted get or put command.

**Return Values:**

Returns offset value on success. If not stored offset is found then 0 is returned.

**Parameters:**

**ssh** - pointer to WOLFSSH structure for connection
**from** - NULL terminated string of source path
**to** - NULL terminated string with destination path

**Example:**

```
#include <wolfssh/wolfsftp.h>
word64 wolfSSH_SFTP_GetOfst(WOLFSSH* ssh, char* from,
char* to);
```
```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;
```
```
//set up ssh and do sftp connections
...
```
```
ofst = wolfSSH_SFTP_GetOfst(ssh, from, to);
//start reading/writing from ofst
```

**See Also:**

wolfSSH_SFTP_SaveOfst()
wolfSSH_SFTP_Interrup()

### wolfSSH_SFTP_ClearOfst()



**Synopsis:**

**Description:**

Function to clear all stored offset values.

**Return Values:**

**WS_SUCCESS** on success

**Parameters:**

**ssh** - pointer to WOLFSSH structure

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_ClearOfst(WOLFSSH* ssh);
```

**See Also:**

wolfSSH_SFTP_SaveOfst()
wolfSSH_SFTP_GetOfst()

### wolfSSH_SFTP_Interrupt()



**Synopsis:**

**Description:**

Function to set interrupt flag and stop a get/put command.

**Return Values:**

None

**Parameters:**

**ssh** - pointer to WOLFSSH structure

**Example:**

```
WOLFSSH* ssh;
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_ClearOfst(ssh) != WS_SUCCESS) {
//handle error
}
```
```
#include <wolfssh/wolfsftp.h>
void wolfSSH_SFTP_Interrupt(WOLFSSH* ssh);
```

**See Also:**

wolfSSH_SFTP_SaveOfst()
wolfSSH_SFTP_GetOfst()

```
WOLFSSH* ssh;
char from[NAME_SZ];
char to[NAME_SZ];
word64 ofst;
```
```
//set up ssh and do sftp connections
...
```
```
wolfSSH_SFTP_Interrupt(ssh);
wolfSSH_SFTP_SaveOfst(ssh, from, to, ofst);
```

##  Command Functions



### wolfSSH_SFTP_Remove()



**Synopsis:**

**Description:**

Function for sending a “remove” packet across the channel.
The file name passed in as “f” is sent to the peer for removal.

**Return Values:**

**WS_SUCCESS** : returns WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**f** - file name to be removed

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Remove(WOLFSSH* ssh , char* f );
```
```
WOLFSSH* ssh;
int ret;
char* name[NAME_SZ];
```
```
//set up ssh and do sftp connections
...
```
```
ret = wolfSSH_SFTP_Remove(ssh, name);
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

### wolfSSH_SFTP_MKDIR()



**Synopsis:**

**Description:**

Function for sending a “mkdir” packet across the channel. The directory name passed in
as “dir” is sent to the peer for creation. Currently the attributes passed in are not used
and default attributes is set instead.

**Return Values:**

**WS_SUCCESS** : returns WS_SUCCESS on success.

**Parameters:**

ssh - pointer to WOLFSSH structure used for connection
dir - NULL terminated directory to be created
atr - attributes to be used with directory creation

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_MKDIR(WOLFSSH* ssh , char* dir ,
WS_SFTP_FILEATRB*
atr );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

### wolfSSH_SFTP_RMDIR()



**Synopsis:**

**Description:**

Function for sending a “rmdir” packet across the channel. The directory name passed in
as “dir” is sent to the peer for deletion.

**Return Values:**

**WS_SUCCESS** : returns WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - NULL terminated directory to be remove

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];
```
```
//set up ssh and do sftp connections
...
```
```
ret = wolfSSH_SFTP_MKDIR(ssh, dir, DIR_SZ);
```
```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_RMDIR(WOLFSSH* ssh , char* dir );
```

**Example:**

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];
```
```
//set up ssh and do sftp connections
...
```
```
ret = wolfSSH_SFTP_RMDIR(ssh, dir);
```

### wolfSSH_SFTP_Rename()



**Synopsis:**

**Description:**

Function for sending a “rename” packet across the channel. This tries to have a peer file
renamed from “old” to “nw”.

**Return Values:**

**WS_SUCCESS** : returns WS_SUCCESS on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**old** - Old file name
**nw** - New file name

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Rename(WOLFSSH* ssh , const char* old ,
const char*
nw );
```
```
WOLFSSH* ssh;
int ret;
char* old[NAME_SZ];
char* nw[NAME_SZ]; //new file name
```
```
//set up ssh and do sftp connections
...
```
```
ret = wolfSSH_SFTP_Rename(ssh, old, nw);
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

### wolfSSH_SFTP_LS()



**Synopsis:**

**Description:**

Function for performing LS operation which gets a list of all files and directories in the
current working directory. This is a high level function that performs REALPATH,
OPENDIR, READDIR, and CLOSE operations.

**Return Values:**

On Success, returns a pointer to a list of WS_SFTPNAME structures.
NULL on failure.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**dir** - directory to list

**Example:**

```
#include <wolfssh/wolfsftp.h>
WS_SFTPNAME* wolfSSH_SFTP_LS(WOLFSSH* ssh , char* dir );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()
wolfSSH_SFTPNAME_list_free()

```
WOLFSSH* ssh;
int ret;
char* dir[DIR_SZ];
WS_SFTPNAME* name;
WS_SFTPNAME* tmp;
```
```
//set up ssh and do sftp connections
...
```
```
name = wolfSSH_SFTP_LS(ssh, dir);
tmp = name;
while (tmp != NULL) {
printf("%s\n", tmp->fName);
tmp = tmp->next;
}
wolfSSH_SFTPNAME_list_free(name);
```

### wolfSSH_SFTP_Get()



**Synopsis:**

**Description:**

Function for performing get operation which gets a file from the peer and places it in a
local directory. This is a high level function that performs LSTAT, OPEN, READ, and
CLOSE operations. To interrupt the operation call the function
wolfSSH_SFTP_Interrupt. (See the API documentation of this function for more
information on what it does)

**Return Values:**

**WS_SUCCESS** : on success.
All other return values should be considered error cases.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**from** - file name to get
**to** - file name to place result at
**resume** - flag to try resume of operation. 1 for yes 0 for no
**statusCb** - callback function to get status

**Example:**

```
#include <wolfssh/wolfsftp.h>
```
```
int wolfSSH_SFTP_Get(WOLFSSH* ssh , char* from , char* to ,
byte resume ,
WS_STATUS_CB* statusCb );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
static void myStatusCb(WOLFSSH* sshIn, long bytes, char*
name)
{
char buf[80];
WSNPRINTF(buf, sizeof(buf), "Processed %8ld\t bytes
\r", bytes);
WFPUTS(buf, fout);
(void)name;
(void)sshIn;
}
...
WOLFSSH* ssh;
char* from[NAME_SZ];
char* to[NAME_SZ];
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_Get( ssh , from , to , 0 , & myStatusCb ) !=
WS_SUCCESS) {
//handle error case
}
```

### wolfSSH_SFTP_Put()



**Synopsis:**

**Description:**

Function for performing put operation which pushes a file local file to a peers directory.
This is a high level function that performs OPEN, WRITE, and CLOSE operations.
To interrupt the operation call the function wolfSSH_SFTP_Interrupt.
(See the API documentation of this function for more information on what it does)

**Return Values:**

**WS_SUCCESS** on success.
All other return values should be considered error cases.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection
**from** - file name to push
**to** - file name to place result at
**resume** - flag to try resume of operation. 1 for yes 0 for no
**statusCb** - callback function to get status

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_Put(WOLFSSH* ssh , char* from , char* to ,
byte resume , WS_STATUS_CB* statusCb );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
static void myStatusCb(WOLFSSH* sshIn, long bytes, char*
name)
{
char buf[80];
WSNPRINTF(buf, sizeof(buf), "Processed %8ld\t bytes
\r", bytes);
WFPUTS(buf, fout);
(void)name;
(void)sshIn;
}
...
```
```
WOLFSSH* ssh;
char* from[NAME_SZ];
char* to[NAME_SZ];
```
```
//set up ssh and do sftp connections
...
```
```
if (wolfSSH_SFTP_Put(ssh, from, to, 0, &myStatusCb) !=
WS_SUCCESS) {
//handle error case
}
```

##  SFTP Server Functions



### wolfSSH_SFTP_read()



**Synopsis:**

**Description:**

Main SFTP server function that handles incoming packets. This function tries to read
from the I/O buffer and calls internal functions to depending on the SFTP packet type
received.

**Return Values:**

**WS_SUCCESS:** on success.

**Parameters:**

**ssh** - pointer to WOLFSSH structure used for connection

**Example:**

```
#include <wolfssh/wolfsftp.h>
int wolfSSH_SFTP_read(WOLFSSH* ssh );
```

**See Also:**

wolfSSH_SFTP_accept()
wolfSSH_SFTP_connect()

```
WOLFSSH* ssh;
```
```
//set up ssh and do sftp connections
...
if (wolfSSH_SFTP_read(ssh) != WS_SUCCESS) {
//handle error case
}
```

