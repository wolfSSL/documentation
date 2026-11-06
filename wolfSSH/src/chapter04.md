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

Other headers in the **wolfssh** directory declare the optional features: **wolfssh/wolfscp.h** for SCP, **wolfssh/agent.h** for ssh-agent support, **wolfssh/certman.h** for X.509 certificates, and **wolfssh/keygen.h** for key generation.

##  Algorithm Negotiation

During key exchange the client and server each offer lists of algorithms, and the first algorithm in the client's list that the server also supports is used. The lists can be changed with the `wolfSSH_CTX_SetAlgoList*()` and `wolfSSH_SetAlgoList*()` functions. Those functions validate their input, and return `WS_INVALID_ALGO_ID` for a list naming an unknown algorithm. The cipher and the MAC are negotiated separately for each direction of the connection, so the two directions may use different ones.

Algorithms using SHA-1, and the AES-CBC ciphers, are compiled in but not offered by default. They can be added back to an algorithm list, or offered by default by building with `WOLFSSH_NO_SHA1_SOFT_DISABLE` or `WOLFSSH_NO_AES_CBC_SOFT_DISABLE`. The "none" cipher and MAC can only be negotiated in a build with `--enable-none-cipher`.

wolfSSH implements strict key exchange (the Terrapin mitigation), which is used when both peers offer it. It is on by default and can be turned off with `wolfSSH_CTX_SetStrictKex()`.

##  Rekeying

When the number of bytes sent or received under the current keys reaches the highwater mark (`wolfSSH_SetHighwater()`, default `DEFAULT_HIGHWATER_MARK`), or the number of packets sent or received reaches the packet-count highwater mark (`wolfSSH_SetMsgHighwater()`, default `WOLFSSH_DEFAULT_MSG_HIGHWATER_MARK`), wolfSSH calls the highwater callback. The default callback starts a new key exchange; another may be set with `wolfSSH_SetHighwaterCb()`. The application can also start one with `wolfSSH_TriggerKeyExchange()`. `wolfSSH_RekeyPending()` reports whether a key exchange is in progress.
