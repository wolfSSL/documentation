#  Building and Using wolfSSH SFTP

## Building wolfSSH SFTP

It is assumed that wolfSSL has already been built to be used with wolfSSH. To see building instructions for wolfSSL visit Chapter 2.

To build wolfSSH with support for SFTP use --enable-sftp, in the case of building with autotools, or define the macro WOLFSSH_SFTP if building without autotools. An example of this would be:
```
./configure --enable-sftp && make
```
By default the internal buffer size for handling reads and writes for get and put commands is set to 32768 bytes. This value can be overwritten in the case that the application needs to consume less resources or in the case that a larger buffer is desired. To override the default size define the macro `WOLFSSH_MAX_SFTP_RW` at compile time. An example of setting it would be as follows:

```
./configure --enable-sftp CPPFLAGS="-DWOLFSSH_MAX_SFTP_RW=2048"
```

A server allows each session at most `WOLFSSH_MAX_SFTP_HANDLES` (64) open file and directory handles. File data buffers are zeroed before they are freed; the configure option `--disable-sftp-zeroize` (`WOLFSSH_NO_SFTP_BUFFER_ZERO`) turns that off.

##  Using wolfSSH SFTP Apps

A SFTP server and client application are bundled with wolfSSH. Both applications get built by autotools when building the wolfSSH library with SFTP support. The server application is located in examples/echoserver/ and is called echoserver. The client application is located in examples/sftpclient/ and is called wolfsftp.

An example of starting up a server that would handle incoming SFTP client connections would be as follow:
```
./examples/echoserver/echoserver
```
Where the command is being ran from the root wolfSSH directory. This starts up a server that is able to handle both SSH and SFTP connections.

Starting the client with specific username:
```
$ ./examples/sftpclient/wolfsftp -u <username>
```
The default "username:password" to run the test is either: "jack:fetchapail" or "jill:upthehill". The default port is 22222.

A full list of supported commands can be seen with typing "help" after a connection.
```
wolfSSH sftp> help

Commands :
    cd  <string>                      change directory
    chmod <mode> <path>               change mode
    creat <mode> <path>               create file with given permissions
    get <remote file> <local file>    pulls file(s) from server
    lcd <path>                        change local directory
    lls                               list local directory
    ls                                list current directory
    mkdir <dir name>                  creates new directory on server
    put <local file> <remote file>    push file(s) to server
    pwd                               list current path
    quit                              exit
    rename <old> <new>                renames remote file
    reget <remote file> <local file>  resume pulling file
    reput <remote file> <local file>  resume pushing file
    <crtl + c>                        interrupt get/put cmd
```

An example of connecting to another system would be
```
src/wolfssh$ ./examples/sftpclient/wolfsftp -p 22 -u user -h 192.168.1.111
```

##  SFTP Server Start Directory and Confinement

An SFTP server session has two independent path settings:

- The start path is the directory the session begins in, which relative paths are resolved against. It grants and denies nothing. Set it with `wolfSSH_SFTP_SetDefaultPath()`.
- The confinement root is the directory the session is restricted to. A request for a path that resolves outside it fails with `WS_PERMISSIONS`. With no root, or a root of "/", the session is not confined. Set it with `wolfSSH_SFTP_SetConfinePath()`.

Setting the start path does not confine the session. Keeping the two separate lets a server start a session deep inside the confinement root, confine a session without changing where it starts, or do neither and let the operating system limit access, as wolfSSHd does by running the session as the authenticated user.

Paths are resolved lexically, which cannot prove that a symbolic link stays inside the root, so a confined session rejects every symbolic link below the root, including ones that point back inside it. Serve trees without symbolic links, or build with `WOLFSSH_NO_SYMLINK_CHECK` to drop the check along with the protection it gives. The root itself is not checked, so it should be a directory the server controls with no symbolic links in its path. The check is made before the operation uses the path, so a process running as the same user could still swap a path component for a link in between; for hostile multi-user deployments, also use an operating system jail.

The example echoserver sets the start path with the option `-d`, and with the option `-D` also confines the session to it:
```
./examples/echoserver/echoserver -d /srv/sftp -D
```
