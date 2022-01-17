#  Building and Using wolfSSH SFTP

## Building wolfSSH SFTP

It is assumed that wolfSSL has already been built to be used with wolfSSH. To see building instructions for wolfSSL visit Chapter 2.

To build wolfSSH with support for SFTP use --enable-sftp, in the case of building with autotools, or define the macro WOLFSSH_SFTP if building without autotools. An example of this would be:
```
./configure --enable-sftp && make
```
By default the internal buffer size for handling reads and writes for get and put commands is set to 1024 bytes. This value can be overwritten in the case that the application needs to consume less resources or in the case that a larger buffer is desired. To override the default size define the macro `WOLFSSH_MAX_SFTP_RW` at compile time. An example of setting it would be as follows:

```
./configure --enable-sftp
C_EXTRA_FLAGS=’WOLFSSH_MAX_SFTP_RW=2048
```

##  Using wolfSSH SFTP Apps

A SFTP server and client application are bundled with wolfSSH. Both applications get built by autotools when building the wolfSSH library with SFTP support. The server application is located in examples/echoserver/ and is called echoserver. The client application is located in wolfsftp/client/ and is called wolfsftp.

An example of starting up a server that would handle incoming SFTP client connections would be as follow:
```
./examples/echoserver/echoserver
```
Where the command is being ran from the root wolfSSH directory. This starts up a server that is able to handle both SSH and SFTP connections.

Starting the client with specific username:
```
$ ./wolfsftp/client/wolfsftp -u <username>
```
The default “username:password” to run the test is either: “jack:fetchapail” or “jill:upthehill”. The default port is 22222.

A full list of supported commands can be seen with typeing "help" after a connection.
```
wolfSSH sftp> help

Commands :
    cd  <string>                      change directory
    chmod <mode> <path>               change mode
    get <remote file> <local file>    pulls file(s) from server
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

