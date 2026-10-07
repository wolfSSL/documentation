# Getting Started

After downloading and building wolfSSH, there are some automated test and example programs to show the uses of the library.

## Testing

###  wolfSSH Unit Test

The wolfSSH unit test is used to verify the API. Both positive and negative test cases are performed. This test can be run manually and it additionally runs as part of other automated processes such as the make and make check commands. The command `make check` also runs the API test (`tests/api.test`), the regression test (`tests/regress.test`), the client/server test suite (`tests/testsuite.test`), and the key exchange test (`tests/kex.test`).

All examples and tests must be run from the wolfSSH home directory so the test tools can find their certificates and keys.

To run the unit test manually:
```
$ ./tests/unit.test
```
or
```
$ make check (when using autoconf)
```

### Testing Notes

After cloning the repository, be sure to make the testing private keys read-only for the user, otherwise ssh will tell you to do it.
```
$ chmod 0600 ./keys/gretel-key-rsa.pem ./keys/hansel-key-rsa.pem \
             ./keys/gretel-key-ecc.pem ./keys/hansel-key-ecc.pem
```

Authentication against the example echoserver can be done with a password or public key. To use a password the command line:
```
$ ssh -p 22222 USER@localhost
```

Where the _USER_ and password pairs are:
```
jill:upthehill
jack:fetchapail
```

To use public key authentication use the command line:
```
$ ssh -i ./keys/USER-key-TYPE.pem -p 22222 USER@localhost
```

Where the _USER_ can be gretel or hansel, and TYPE is rsa or ecc. The echoserver accepts the RSA keys by default; give it the option `-e` to accept the ECC keys instead.

Keep in mind, the echoserver has several fake accounts in its wsUserAuth callback function. (jack, jill, hansel, and gretel) When the shell support is enabled, those fake accounts will not work. They don't exist in the system's passwd file. The users will authenticate, but the server will err out because they don't exist in the system. You can add your own username to the password or public key list in the echoserver. That account will be logged into a shell started by the echoserver with the privileges of the user running echoserver.

## Examples

###  wolfSSH Echo Server

The echoserver is the workhorse of wolfSSH. It originally only allowed one to authenticate one of the canned account and would repeat the characters typed into it. When enabling shell support, see the later section, it can spawn a user shell. It will need an actual user name on the machine and an updated user authentication callback function to validate the credentials. The echoserver can also handle SCP and SFTP connections. From the terminal run:
```
    $ ./examples/echoserver/echoserver -f
```

The option `-f` enables echo-only mode. From another terminal run:
```
    $ ssh jill@localhost -p 22222
```

When prompted for a password, enter "upthehill". The server will send a canned
banner to the client:
```
    wolfSSH Example Echo Server
```

Characters typed into the client will be echoed to the screen by the server.
If the characters are echoed twice, the client has local echo enabled. The
echo server isn't being a proper terminal so the CR/LF translation will not
work as expected.

The following control characters will trigger special actions in the
echoserver:

- CTRL-C: Terminate the connection.
- CTRL-E: Print out some session statistics.
- CTRL-F: Trigger a new key exchange.

The echoserver tool accepts the following command line options. Some options
are only available when the matching feature is built in.
```
    -?             display this help and exit
    -1             exit after a single (one) connection
    -e             expect ECC public key from client
    -E             load ECC private key first
    -f             echo input (shell builds only)
    -A             drive channels from the application callbacks
    -p <num>       port to accept on, default 22222
    -N             use non-blocking sockets
    -d <string>    set the home directory for SFTP connections
    -D             confine SFTP connections to the home directory,
                   rather than only starting them there
    -j <file>      load in a SSH public key to accept from peer
                   (user assumed in comment)
    -I <name>:<file>
                   load in a SSH public key to accept from peer
    -s <file>      load in a TPM public key file to replace default
                   hansel key
    -G <file>      load ECC/RSA host key blob from TPM (private key
                   stays in TPM)
    -J <name>:<file>
                   load in an X.509 PEM cert to accept from peer
    -K <name>:<file>
                   load in an X.509 DER cert to accept from peer
    -P <name>:<password>
                   add password to accept from peer
    -i <name>:<password>
                   add password to accept via keyboard-interactive
                   from peer
    -a <file>      load in a root CA certificate file
    -k <list>      set the comma separated list of key algos to use
    -x <list>      set the comma separated list of key exchange algos
                   to use
    -m <list>      set the comma separated list of mac algos to use
    -W <spec>      Windows cert store: "store:subject[:flags]"
    -b <num>       test user auth would block
    -H             set test highwater callback
```

###  wolfSSH Client

The client establishes a connection to an SSH server. In its simplest mode,
it sends the string "Hello, wolfSSH!" to the server, prints the response,
and then exits. With the pseudo terminal option, the client will be a real
client.

The client tool accepts the following command line options. Some options
are only available when the matching feature is built in.
```
    -?             display this help and exit
    -h <host>      host to connect to, default 127.0.0.1
    -p <num>       port to connect on, default 22222
    -u <username>  username to authenticate as (REQUIRED)
    -P <password>  password for username, prompted if omitted
    -K <password>  TPM key authentication password
    -e             use sample ecc key for user
    -i <filename>  filename for the user's private key
    -j <filename>  filename for the user's public key
    -x             exit after successful connection without doing
                   read/write
    -N             use non-blocking sockets
    -t             use pseudo terminal
    -c <command>   executes remote command and pipe stdin/stdout
    -R             raw untranslated output (Windows only)
    -a             Attempt to use SSH-AGENT
    -J <filename>  filename for DER certificate to use
    -A <filename>  filename for DER CA certificate to verify host
    -X             Ignore IP checks on peer vs peer certificate
    -E             List all possible algos
    -k <list>      set the list of key algos
    -C <list>      set the list of encrypt algos
    -q             turn off debugging output
```

### wolfSSH portfwd

The portfwd tool establishes a connection to an SSH server and sets up a
listener for local port forwarding, or with the option `-r` asks the server
to listen for remote port forwarding. It runs until the connection ends.

The portfwd tool accepts the following command line options:
```
    -?             display this help and exit
    -h <host>      host to connect to, default 127.0.0.1
    -p <num>       port to connect on, default 22222
    -u <username>  username to authenticate as (REQUIRED)
    -P <password>  password for username, prompted if omitted
    -F <host>      host to forward from, default 0.0.0.0
    -f <num>       host port to forward from (REQUIRED), 0 with -r
                   lets the peer pick the listener port
    -T <host>      host to forward to, default to host
    -t <num>       port to forward to (REQUIRED)
    -r             remote (reverse) forward: ask the SSH server to
                   listen on -F/-f and tunnel connections back to
                   the local -T/-t target
```

### wolfSSH scpclient

The scpclient, wolfscp, establishes a connection to an SSH server and copies
the specified files from or to the local machine. When using the wolfSSH
example, absolute paths must be used, and directories must end with a `/`.

The scpclient tool accepts the following command line options:
```
    -h             display this help and exit
    -H <host>      host to connect to, default 127.0.0.1
    -p <num>       port to connect on, default 22222
    -u <username>  username to authenticate as (REQUIRED)
    -P <password>  password for username, prompted if omitted
    -L <from>:<to> copy from local to server
    -S <from>:<to> copy from server to local
    -i <filename>  filename for the user's private key
    -j <filename>  filename for the user's public key
    -J <filename>  filename for DER certificate to use
    -A <filename>  filename for DER CA certificate to verify host
    -X             Ignore IP checks on peer vs peer certificate
```

### wolfSSH sftpclient

The sftpclient, wolfsftp, establishes a connection to an SSH server and
allows directory navigation, getting and putting files, making and removing
directories, etc.

The sftpclient tool accepts the following command line options. Some options
are only available when the matching feature is built in.
```
    -?             display this help and exit
    -h <host>      host to connect to, default 127.0.0.1
    -p <num>       port to connect on, default 22222
    -u <username>  username to authenticate as (REQUIRED)
    -P <password>  password for username, prompted if omitted
    -d <path>      set the default local path
    -N             use non blocking sockets
    -l <filename>  local filename
    -r <filename>  remote filename
    -g             put local filename as remote filename
    -G             get remote filename as local filename
    -i <filename>  filename for the user's private key
    -j <filename>  filename for the user's public key
    -k <list>      set the comma separated list of server host key
                   algos to accept
    -W <spec>      Windows cert store: "store:subject[:flags]"
    -J <filename>  filename for DER certificate to use
    -A <filename>  filename for DER CA certificate to verify host
    -X             Ignore IP checks on peer vs peer certificate
```

### wolfssh Client Application

The wolfssh client application, built with `--enable-sshclient`, connects to a
server and opens a terminal, or runs a command given after the destination.
It defaults the user name to the current user and uses the private key
`$HOME/.ssh/id_ecdsa` to authenticate.
```
    wolfssh [-a] [-E logfile] [-G] [-l login_name] [-p port] [-V]
            destination [command]
```

The options are:
```
    -a             attempt to use SSH-AGENT (agent builds only)
    -E logfile     append the log to this file instead of stderr, and
                   turn logging on
    -G             print out the configuration as used
    -l login_name  overrides the login name in the destination
    -p port        overrides the destination port number
    -V             print out the version
```

The destination is either `[user@]hostname` or `ssh://[user@]hostname[:port]`.
The default port is 22. The option `-N` is no longer accepted.

### wolfSSHd

wolfSSHd is an SSH server daemon, built with `--enable-sshd`, that reads an
OpenSSH style `sshd_config` file and logs users in to the local system. It
supports shell and exec sessions, and SCP and SFTP when built with them.

wolfSSHd refuses a host key file that is not owned by the user it runs as (or
root), or that is group or world readable, so give it a copy of the key it can
use. For example:
```
    $ sudo install -m 600 keys/gretel-key-ecc.pem /etc/ssh/wolfsshd_key.pem
    $ sudo ./apps/wolfsshd/wolfsshd -D -h /etc/ssh/wolfsshd_key.pem -p 11111
    $ ssh <user>@localhost -p 11111
```

If wolfSSHd stops on a directive in the system `sshd_config` file it does not
support, copy the file, remove that line, and give the copy with `-f`.

wolfSSHd accepts the following command line options:
```
    -?             display this help and exit
    -f <file name> configuration file to use, default is
                   /etc/ssh/sshd_config
    -p <int>       port number to listen on
    -d             turn on debug mode
    -D             run in foreground (do not detach)
    -h <file name> host private key file to use
    -E <file name> append to log file
    -t             test mode: load the configuration and exit
                   without listening
```

wolfSSHd recognizes the following configuration directives:

| Directive | Notes |
|--------------------------------|-----------------------------------------------|
| `Port` | Port to listen on, default 22. |
| `Protocol` | Only `2` is accepted. |
| `HostKey` | Host private key file. Not allowed inside a `Match` block. |
| `HostCertificate` | Host X.509 certificate file. Not allowed inside a `Match` block. |
| `PasswordAuthentication` | `yes` (default) or `no`. |
| `PubkeyAuthentication` | `yes` (default) or `no`. |
| `PermitEmptyPasswords` | `yes` or `no` (default). |
| `PermitRootLogin` | `no` (default), `yes`, `prohibit-password` (also spelled `without-password`), or `forced-commands-only`. Applies to every account with UID 0. |
| `AuthorizedKeysFile` | Authorized keys file, default `.ssh/authorized_keys` in the user's home directory. A relative path is taken from the home directory. `%u` expands to the user name, `%h` to the home directory, and `%%` to a percent sign; any other `%` token is an error. |
| `StrictModes` | `yes` (default) or `no`. |
| `TrustedUserCAKeys` | CA file for user certificates: X.509 CA certificates, or OpenSSH CA public keys for OpenSSH certificates. |
| `AuthorizedUPNDomains` | Restricts the UPN realm of a user's FPKI certificate. |
| `LoginGraceTime` | Seconds allowed to authenticate, default 120. |
| `UsePrivilegeSeparation` | `yes`, `no`, or `sandbox`. |
| `ChrootDirectory` | Directory to chroot the user's session into. |
| `ForceCommand` | Command run in place of the one the client asks for. |
| `Banner` | File sent to the client before authentication. |
| `PidFile` | File the daemon's process ID is written to. |
| `Include` | Reads another configuration file. |
| `Match` | Starts a block of settings for a `User` or `Group`. |
| `wolfSSH_HostKeyStore`, `wolfSSH_HostKeyStoreSubject`, `wolfSSH_HostKeyStoreFlags` | Windows certificate store builds only. Load the host key and certificate from a certificate store. |
| `wolfSSH_TrustedUserCAStore`, `wolfSSH_WinUserStores`, `wolfSSH_WinUserPvPara`, `wolfSSH_WinUserDwFlags` | Windows certificate store builds only. Load user certificate CAs from a Windows certificate store. |
| `wolfSSH_TrustedSystemCAKeys` | `yes` or `no`. Load the operating system's trust store as the user certificate CAs. |

The directives `Subsystem`, `ChallengeResponseAuthentication`, `UsePAM`,
`X11Forwarding`, `PrintMotd`, `AcceptEnv` and `UseDNS` are recognized for
compatibility with OpenSSH configuration files, but have no effect; wolfSSHd
logs a warning for each. Any other directive is an error. A directive and its
value must be separated by whitespace; the OpenSSH `Keyword=value` form is
rejected.

A `Match` block may only be keyed on `User` or `Group`; `Match User X Group Y`
requires both to match. The `wolfSSH_` store directives and
`wolfSSH_TrustedSystemCAKeys` are global only and are rejected inside a `Match`
block. `TrustedUserCAKeys` may be set inside one.

With `StrictModes yes`, an authorized keys file must be a regular file, not a
symbolic link, owned by the user or root, with no group or world writable
component in its path. `StrictModes no` relaxes only the check of authorized
keys files. Host key files and CA files are always checked: they must be owned
by the daemon's user or root, and a host private key must not be group or world
readable.

`PermitRootLogin prohibit-password` refuses password and keyboard-interactive
logins for root, allowing public key logins. `forced-commands-only` also
requires a `ForceCommand` for a root public key login; the `command=` option in
authorized keys files is not enforced.

For X.509 user certificates (`--enable-certs`), the CA is set with
`TrustedUserCAKeys`. A certificate is bound to the requested account by its
UPN when wolfSSL has FPKI support, and by a case-insensitive match of its
subject CN otherwise. Without FPKI, on systems other than Windows, the
configuration must also set `AuthorizedKeysFile`, and the certificate is
checked against the user's authorized keys file; a login relying on the CA
alone fails. With FPKI, `AuthorizedUPNDomains` restricts the UPN realm.

For OpenSSH user certificates (`--enable-ossh-certs`), list the signing CA
public keys in `TrustedUserCAKeys`. The certificate's principals must include
the requested user, it must be within its validity period, and its
`source-address` restriction, if any, must match the client. A certificate's
`force-command` overrides the requested command. OpenSSH certificate logins
are not supported on Windows.

wolfSSHd sessions run with a umask of 022 (`WOLFSSHD_DEFAULT_UMASK`).

## SCP

wolfSSH includes server-side support for scp, which includes support for both copying files 'to' the server, and copying files 'from' the server. Both
single file and recursive directory copy are supported with the default
send and receive callbacks.

To compile wolfSSH with scp support, use the `--enable-scp` build option
or define `WOLFSSH_SCP`:
```
    $ ./configure --enable-scp
    $ make
```


The wolfSSH example echoserver accepts scp requests when wolfSSH is built
with SCP support. To start the example server, run:

    $ ./examples/echoserver/echoserver

Standard scp commands can be used on the client side. The following are a
few examples, where `scp` represents the ssh client you are using.

To copy a single file TO the server, using the default example user "jill":

    $ scp -P 22222 <local_file> jill@127.0.0.1:<remote_path>

To copy the same single file TO the server, but with timestamp and in
verbose mode:

    $ scp -v -p -P 22222 <local_file> jill@127.0.0.1:<remote_path>

To recursively copy a directory TO the server:

    $ scp -P 22222 -r <local_dir> jill@127.0.0.1:<remote_dir>

To copy a single file FROM the server to the local client:

    $ scp -P 22222 jill@127.0.0.1:<remote_file> <local_path>

To recursively copy a directory FROM the server to the local client:

    $ scp -P 22222 -r jill@127.0.0.1:<remote_dir> <local_path>

## SFTP

wolfSSH provides server and client side support for SFTP version 3. This
allows the user to set up an encrypted connection for managing file systems.

To compile wolfSSH with SFTP support, use the `--enable-sftp` build option or
define `WOLFSSH_SFTP`:

```
    $ ./configure --enable-sftp
    $ make
```

The SFTP client created is located in the directory examples/sftpclient/ and the
server is ran using the same echoserver as with wolfSSH.

```
    src/wolfssh$ ./examples/sftpclient/wolfsftp
```

A full list of supported commands can be seen with typing "help" after a
connection.

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

##  Shell Support

wolfSSH's example echoserver can now fork a shell for the user trying to log in. This currently has only been tested on Linux and macOS. The file echoserver.c must be modified to have the user's credentials in the user authentication callback, or the user authentication callback needs to be changed to verify the provided password.

To compile wolfSSH with shell support, use the --enable-shell build option or define WOLFSSH_SHELL:
```
$ ./configure --enable-shell
$ make
```

To try it, start the echoserver with a password for the current user, and connect with the example client using a pseudo terminal, where `<user>` is the name of the user currently logged in:
```
$ ./examples/echoserver/echoserver -P <user>:junk
$ ./examples/client/client -t -u <user> -P junk
```

By default, the echoserver will try to start a shell. To use the echo testing behavior, give the echoserver the command line option -f.
```
$ ./examples/echoserver/echoserver -f
```

## Post-Quantum

wolfSSH supports post-quantum key exchange with ML-KEM (formerly known as
Kyber) and post-quantum signatures with ML-DSA (formerly known as Dilithium).

* **ML-KEM**: the hybrid key exchanges `mlkem768x25519-sha256` (ML-KEM-768
  with Curve25519), `mlkem768nistp256-sha256` (ML-KEM-768 with ECDH over
  P-256), and `mlkem1024nistp384-sha384` (ML-KEM-1024 with ECDH over P-384).
  When available they are offered ahead of the classical key exchanges.
* **ML-DSA**: the ML-DSA-44, ML-DSA-65, and ML-DSA-87 parameter sets
  (`ssh-mldsa-44`, `ssh-mldsa-65`, `ssh-mldsa-87`) for both server host keys
  and client public key authentication, and composites of ML-DSA with ECDSA,
  Ed25519, or Ed448. When built with certificate support, ML-DSA X.509
  certificates (`x509v3-ssh-mldsa-44`, `x509v3-ssh-mldsa-65`, and
  `x509v3-ssh-mldsa-87`) are also supported.

These algorithms are provided by wolfCrypt; liboqs is not used. Build and
install wolfSSL with support for them. ML-DSA needs wolfSSL 5.9.2 or later.
For example:

```
    $ ./configure --enable-wolfssh --enable-mlkem --enable-mldsa
```

After that, configure and build wolfSSH as usual:

```
    $ ./configure
    $ make all
```

The wolfSSH client and server will automatically negotiate an ML-KEM hybrid
key exchange.

```
    $ ./examples/echoserver/echoserver -f

    $ ./examples/client/client -u jill -P upthehill
```

On the client side, you will see the following output:

```
Server said: Hello, wolfSSH!
```

Other SSH clients that support these key exchanges, such as OpenSSH for
`mlkem768x25519-sha256`, can also connect to the echoserver.


## Certificate Support

wolfSSH can accept X.509 certificates in place of just public keys when
authenticating a user.

To compile wolfSSH with X.509 support, use the `--enable-certs` build option
or define `WOLFSSH_CERTS`:

```
    $ ./configure --enable-certs CPPFLAGS=-DWOLFSSH_NO_FPKI
    $ make
```

For this example, FPKI checking is turned off because the included certificate
for "fred" does not have the required FPKI extensions. If `WOLFSSH_NO_FPKI` is
not defined, the certificate is rejected.

With or without FPKI, a peer certificate is held to RFC 6187 section 2.2: a
KeyUsage extension must assert digitalSignature, and an ExtendedKeyUsage
extension must name anyExtendedKeyUsage or a purpose for the role being
verified (id-kp-secureShellClient or clientAuth for a user certificate,
id-kp-secureShellServer or serverAuth for a host certificate). A certificate
without those extensions is accepted. A mismatch fails with
`WS_CERT_KEY_USAGE_E`.

To provide a CA root certificate to validate a user's certificate, give the
echoserver the command line option `-a`.

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem
```

The echoserver and client have a fake user named "fred" whose certificate
will be used for authentication.

An example echoserver/client connection using the example certificate
fred-cert.der would be:

```
    $ ./examples/echoserver/echoserver -a ./keys/ca-cert-ecc.pem -K fred:./keys/fred-cert.der

    $ ./examples/client/client -u fred -J ./keys/fred-cert.der -i ./keys/fred-key.der
```

## OpenSSH Certificate Support

wolfSSH can accept OpenSSH user certificates (`*-cert-v01@openssh.com`) for
public key user authentication. To compile wolfSSH with OpenSSH certificate
support, use the `--enable-ossh-certs` build option or define
`WOLFSSH_OSSH_CERTS`. The certificate's CA key, principals, validity period,
and its force-command and source-address options are passed to the user
authentication callback, which must check that the CA is trusted. wolfSSHd
uses the CA keys listed in `TrustedUserCAKeys`.

## Windows Certificate Store

On Windows, host and user keys can come from the Windows certificate store
instead of files. This requires certificate support; enable it with the
`--enable-windows-cert-store` build option (mingw hosts only) or by defining
`WOLFSSH_WINDOWS_CERT_STORE`. An RSA store certificate is offered as
`x509v3-ssh-rsa`, which RFC 6187 signs with SHA-1, so it also needs
`WOLFSSH_NO_SHA1_SOFT_DISABLE`, and wolfSSL built with
`WC_SIG_MIN_HASH_TYPE=WC_HASH_TYPE_SHA`. ECDSA store keys need neither.

The echoserver and the SFTP client take a `-W store:subject[:flags]` option
naming the store, the certificate's subject CN, and optionally the store
location: CURRENT_USER (the default), LOCAL_MACHINE, USERS, CURRENT_SERVICE,
SERVICES, CURRENT_USER_GROUP_POLICY, LOCAL_MACHINE_GROUP_POLICY, or
LOCAL_MACHINE_ENTERPRISE, each also accepted with a `CERT_SYSTEM_STORE_`
prefix or as a number. `-W` supplies both the certificate and its private key;
in the SFTP client it cannot be combined with `-i`, `-j`, or `-J`.

```
    $ ./examples/echoserver/echoserver -W "My:wolfSSH-Server:LOCAL_MACHINE" -a ./keys/ca-cert-ecc.pem

    $ ./examples/sftpclient/wolfsftp -u testuser -W "My:testuser:CURRENT_USER" -A ./keys/ca-cert-ecc.der -X
```

## TPM Host Keys

With `--enable-tpm`, the server can keep its ECDSA or RSA host key inside a
TPM 2.0 so the host private key is never in memory. The key is registered with
`wolfSSH_CTX_UseTpmHostKey()`, and the exchange hash is signed by the TPM. An
X.509 host certificate can be paired with the TPM key by calling
`wolfSSH_CTX_UseCert_buffer()` after `wolfSSH_CTX_UseTpmHostKey()`. The
echoserver loads a TPM host key blob with the option `-G`:

```
    $ ./examples/echoserver/echoserver -G ../wolfTPM/hostkey.bin
```

The examples `examples/tpmcertserver/tpmcertserver` and `tpmcertclient` show a
TPM host key with a self-signed X.509 host certificate.

## Strict Key Exchange

wolfSSH implements strict key exchange, the mitigation for the Terrapin attack
(CVE-2023-48795). It is offered in the initial KEXINIT and used whenever the
peer offers it too, so no configuration is needed for the usual case. With
strict KEX in force, wolfSSH accepts nothing but the key exchange messages and
SSH_MSG_DISCONNECT until the peer's SSH_MSG_NEWKEYS arrives, and it resets the
packet sequence numbers at every SSH_MSG_NEWKEYS. A message that arrives out of
turn ends the connection.

An application that has to interoperate with a peer that mishandles strict KEX
can turn it off for later sessions with `wolfSSH_CTX_SetStrictKex(ctx, 0)`.
`wolfSSH_GetStrictKexNegotiated()` reports whether a session is using it.
