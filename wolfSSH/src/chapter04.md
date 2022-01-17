#  Library Design

The wolfSSH library is meant to be included directly into an application. The primary use case in mind during development is replacing serial- or telnet-based menus on embedded devices. The library is agnostic to networking using I/O callbacks, but provides callbacks for *NIX and Windows networking by default as examples. Timing is platform specific and should be provided by the application, functions will be provided to perform actions on timeouts.

##  Directory Layout

The wolfSSH library header files are located in the **wolfssh** directory. The only header required to be included in a source file is **wolfssh/ssh.h**. An example is shown below.
```
#include <wolfssh/ssh.h>
```
The wolfSFTP library header file is also included in the wolfssh directory. To call this header file use:
```
#include <wolfssh/wolfsftp.h>
```
All main source files are located in the **src** directory that resides in the root directory.
