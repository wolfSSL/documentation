# wolfSSH Preprocessor Guard Macros

Many wolfSSH features, algorithms, and functions are controlled by build-time
preprocessor macros. This chapter is a reference for the macros that are
intended to be set by applications. They are defined at build time through the
compiler command line (for example `CPPFLAGS`/`CFLAGS`), or by the `./configure`
options described in the "Building wolfSSH" chapter.

##  Algorithm-Disable Macros

Each of the following `WOLFSSH_NO_*` macros disables one algorithm (or a family
of algorithms). In an autotools build these are normally set automatically based
on which algorithms are enabled in wolfCrypt; they may also be defined manually
to remove an algorithm from wolfSSH.

Two algorithm families are "soft-disabled" by default: they are compiled in and
still work, but are not advertised during key exchange unless re-enabled.

| Macro | Effect |
|--------------------------------------|------------------------------------|
| `WOLFSSH_NO_SHA1_SOFT_DISABLE` | SHA-1 algorithms are compiled in but not advertised during KEX by default. Define this to advertise SHA-1 algorithms by default. |
| `WOLFSSH_NO_AES_CBC_SOFT_DISABLE` | AES-CBC algorithms are compiled in but not advertised during KEX by default. Define this to advertise AES-CBC algorithms by default. |
| `WOLFSSH_NO_SHA1` | Disables SHA-1 in HMAC and digital signatures. |
| `WOLFSSH_NO_HMAC_SHA1` | Disables HMAC-SHA1. |
| `WOLFSSH_NO_HMAC_SHA1_96` | Disables HMAC-SHA1-96. |
| `WOLFSSH_NO_HMAC_SHA2_256` | Disables HMAC-SHA2-256. |
| `WOLFSSH_NO_HMAC_SHA2_512` | Disables HMAC-SHA2-512. |
| `WOLFSSH_NO_DH_GROUP1_SHA1` | Disables DH group 1 (Oakley 1) with SHA-1. |
| `WOLFSSH_NO_DH_GROUP14_SHA1` | Disables DH group 14 (Oakley 14) with SHA-1. |
| `WOLFSSH_NO_DH_GROUP14_SHA256` | Disables DH group 14 with SHA-256. |
| `WOLFSSH_NO_DH_GROUP16_SHA512` | Disables DH group 16 with SHA-512. |
| `WOLFSSH_NO_DH_GEX_SHA256` | Disables DH group exchange with SHA-256. |
| `WOLFSSH_NO_DH` | Disables all DH key agreement. |
| `WOLFSSH_NO_ECDH_SHA2_NISTP256` | Disables ECDH key exchange with NIST P-256. |
| `WOLFSSH_NO_ECDH_SHA2_NISTP384` | Disables ECDH key exchange with NIST P-384. |
| `WOLFSSH_NO_ECDH_SHA2_NISTP521` | Disables ECDH key exchange with NIST P-521. |
| `WOLFSSH_NO_ECDH` | Disables all ECDH key agreement. |
| `WOLFSSH_NO_CURVE25519_SHA256` | Disables Curve25519 key exchange. |
| `WOLFSSH_NO_NISTP256_MLKEM768_SHA256` | Disables the NIST P-256 with ML-KEM-768 post-quantum hybrid key exchange. |
| `WOLFSSH_NO_NISTP384_MLKEM1024_SHA384` | Disables the NIST P-384 with ML-KEM-1024 post-quantum hybrid key exchange. |
| `WOLFSSH_NO_CURVE25519_MLKEM768_SHA256` | Disables the Curve25519 with ML-KEM-768 post-quantum hybrid key exchange. |
| `WOLFSSH_NO_RSA` | Disables RSA server and user authentication. |
| `WOLFSSH_NO_SSH_RSA_SHA1` | Disables `ssh-rsa` (RSA with SHA-1), and `x509v3-ssh-rsa`. |
| `WOLFSSH_NO_RSA_SHA2_256` | Disables `rsa-sha2-256`. |
| `WOLFSSH_NO_RSA_SHA2_512` | Disables `rsa-sha2-512`. |
| `WOLFSSH_NO_ECDSA` | Disables ECDSA server and user authentication. |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP256` | Disables ECDSA authentication with NIST P-256. |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP384` | Disables ECDSA authentication with NIST P-384. |
| `WOLFSSH_NO_ECDSA_SHA2_NISTP521` | Disables ECDSA authentication with NIST P-521. |
| `WOLFSSH_NO_ED25519` | Disables Ed25519 server and user authentication, and the ML-DSA composites with Ed25519. Set unless wolfCrypt has Ed25519 with signing, verifying, streaming verify, and key import and export. |
| `WOLFSSH_NO_MLDSA` | Disables all ML-DSA server and user authentication. Set unless wolfCrypt has ML-DSA and is version 5.9.2 or later. |
| `WOLFSSH_NO_MLDSA44` | Disables ML-DSA-44. |
| `WOLFSSH_NO_MLDSA65` | Disables ML-DSA-65. |
| `WOLFSSH_NO_MLDSA87` | Disables ML-DSA-87. |
| `WOLFSSH_NO_MLDSA44_ES256`, `WOLFSSH_NO_MLDSA65_ES256`, `WOLFSSH_NO_MLDSA87_ES384`, `WOLFSSH_NO_MLDSA44_ED25519`, `WOLFSSH_NO_MLDSA65_ED25519`, `WOLFSSH_NO_MLDSA87_ED448` | Each disables one ML-DSA composite. Set when the ML-DSA level or the algorithm it pairs with is disabled. |
| `WOLFSSH_NO_MLDSA_COMPOSITES` | Disables all of the ML-DSA composites. |
| `WOLFSSH_NO_OSSH_CERT_RSA` | Disables RSA OpenSSH certificates. Set when RSA, or both `rsa-sha2-256` and `rsa-sha2-512`, are disabled. |
| `WOLFSSH_NO_AES_CBC` | Disables AES-CBC encryption. |
| `WOLFSSH_NO_AES_CTR` | Disables AES-CTR encryption. |
| `WOLFSSH_NO_AES_GCM` | Disables AES-GCM encryption. |
| `WOLFSSH_NO_AEAD` | Disables all AEAD ciphers. |

The library also sets `WOLFSSH_NO_PUBKEY_AUTH` when RSA, ECDSA, Ed25519, and
ML-DSA are all disabled, which leaves out public key user authentication.

##  Feature-Enable Macros

These macros turn whole subsystems on. In an autotools build each is defined by
the corresponding `./configure` option shown below. The relevant API for most of
these features is documented in the API reference chapters.

| Macro | Enables | Configure option |
|--------------------------------|---------------------|------------------------------|
| `WOLFSSH_SFTP` | SFTP support | `--enable-sftp` |
| `WOLFSSH_SCP` | SCP support | `--enable-scp` |
| `WOLFSSH_FWD` | TCP/IP port forwarding | `--enable-fwd` |
| `WOLFSSH_AGENT` | ssh-agent forwarding | `--enable-agent` |
| `WOLFSSH_CERTS` | X.509 certificate support | `--enable-certs` |
| `WOLFSSH_OSSH_CERTS` | OpenSSH certificate user authentication | `--enable-ossh-certs` |
| `WOLFSSH_WINDOWS_CERT_STORE` | keys and certificates from the Windows certificate store; requires `WOLFSSH_CERTS` and a Windows target | `--enable-windows-cert-store` |
| `WOLFSSH_TPM` | TPM 2.0 support for host keys and user keys | `--enable-tpm` |
| `WOLFSSH_SSHD` | wolfsshd daemon | `--enable-sshd` |
| `WOLFSSH_USE_PAM` | PAM for wolfsshd | `--with-pam` |
| `WOLFSSH_SHELL` | echoserver shell support | `--enable-shell` |
| `WOLFSSH_KEYGEN` | key generation API | `--enable-keygen` |
| `WOLFSSH_KEYBOARD_INTERACTIVE` | keyboard-interactive authentication | `--enable-keyboard-interactive` |
| `WOLFSSH_SSHCLIENT` | wolfSSH client application | `--enable-sshclient` |
| `WOLFSSH_TERM` | PTY / terminal handling | on by default (`--disable-term` to remove) |
| `WOLFSSH_SMALL_STACK` | reduced stack usage for constrained targets | `--enable-smallstack` |
| `WOLFSSH_ALLOW_NONE_CIPHER` | negotiating the insecure "none" cipher and MAC | `--enable-none-cipher` |
| `NO_WOLFSSH_SERVER` | leaves out the server code | `--disable-server` |
| `NO_WOLFSSH_CLIENT` | leaves out the client code | `--disable-client` |

The following macros adjust behavior rather than enabling a subsystem:

| Macro | Effect |
|--------------------------------------|--------------------------------------------------|
| `WOLFSSH_NO_DEFAULT_LOGGING_CB` | Omits the built-in default logging callback. |
| `WOLFSSH_NO_TIMESTAMP` | Omits timestamps from log output. |
| `WOLFSSH_NO_SYMLINK_CHECK` | Disables the check that rejects symbolic links below an SFTP confinement root, and the escape protection it gives. |
| `WOLFSSH_NO_SFTP_BUFFER_ZERO` | Skips zeroing SFTP file data buffers before they are freed. Set by `--disable-sftp-zeroize`. |
| `WOLFSSH_NO_FPKI` | Skips the Federal PKI (FPKI) profile checks on X.509 certificates. |
| `WOLFSSH_ALLOW_USERAUTH_NONE` | Lets the server accept the "none" user authentication method, passing it to the user authentication callback as `WOLFSSH_USERAUTH_NONE`. |
| `WOLFSSH_SCP_USER_CALLBACKS` | Omits the default SCP send and receive callbacks; the application must set its own. |
| `WOLFSSH_USER_IO` | Omits the default socket I/O callbacks; the application must set its own. |
| `WOLFSSH_CERT_STORE_ALLOW_EXPIRED` | Lets a Windows certificate store lookup use an expired or not yet valid certificate when no time-valid one matches. |
| `WOLFSSH_IGNORE_UNKNOWN_CONFIG` | wolfSSHd logs a warning and ignores an unknown or unsupported configuration line, instead of failing to start. |
| `WOLFSSH_NO_HOSTKEY_PERMS` | On QNX, wolfSSHd skips the owner and mode checks of its host key file. |

##  Tuning and Value Macros

These macros take a numeric value rather than acting as an on/off switch. Define
them at build time to override the default.

| Macro | Meaning | Default |
|-------------------------------------|-----------------------------------|--------------|
| `DEFAULT_WINDOW_SZ` | Initial channel window size, in bytes. | 131072 (128 KB) |
| `DEFAULT_MAX_PACKET_SZ` | Maximum channel packet size, in bytes. | 32768 |
| `MAX_PACKET_SZ` | Largest SSH packet sent or accepted, in bytes. | 35000 |
| `DEFAULT_MAX_AUTH_ATTEMPTS` | Failed user authentication attempts the server allows before it disconnects. | 6 |
| `WOLFSSH_RSA_MIN_KEY_BITS` | Minimum RSA user authentication key size, in bits. | 2048 |
| `WOLFSSH_DEFAULT_GEXDH_MIN` | Minimum DH group exchange group size a client requests, in bits. | 2048 |
| `WOLFSSH_DEFAULT_GEXDH_PREFERRED` | Preferred DH group exchange group size a client requests, in bits. | 3072 |
| `WOLFSSH_DEFAULT_GEXDH_MAX` | Maximum DH group exchange group size a client requests, in bits. | 8192 |
| `WOLFSSH_DH_GEX_MIN_BITS` | Smallest DH group exchange group either side accepts, in bits. | 2048 |
| `WOLFSSH_MAX_NAMELIST_SZ` | Largest name-list accepted from the peer, in bytes. | 4096 |
| `WOLFSSH_MAX_NAMELIST_CNT` | Most names accepted in a name-list from the peer. | 64 |
| `WOLFSSH_MAX_PVT_KEYS` | Most private keys a context can hold. | 16 |
| `WOLFSSH_MAX_PROMPTS` | Most keyboard-interactive prompts. | 64 |
| `WOLFSSH_MAX_PROMPT_SZ` | Largest keyboard-interactive prompt, in bytes. | 1024 |
| `DEFAULT_HIGHWATER_MARK` | Default data highwater mark, in bytes, before a rekey is triggered. | about 1 GB |
| `WOLFSSH_DEFAULT_MSG_HIGHWATER_MARK` | Default packet-count highwater mark before a rekey is triggered. | 0x80000000 |
| `WOLFSSH_MR_ROUNDS` | Miller-Rabin rounds used when the client checks the server's DH group-exchange prime. | 8 |
| `WOLFSSH_KEY_QUANTITY_REQ` | Number of keys required in an OpenSSH-style key wrapper. | 1 |
| `WOLFSSH_MAX_FILENAME` | Maximum filename length, in bytes. | 256 |
| `WOLFSSH_MAX_SFTP_RW` | Maximum SFTP read/write chunk size, in bytes. | 32768 |
| `WOLFSSH_MAX_SFTP_RECV` | Maximum SFTP receive size, in bytes. | 32768 |
| `WOLFSSH_MAX_SFTP_NAME` | Maximum size of an SFTP name list, in bytes. | 1048576 (1 MB) |
| `WOLFSSH_MAX_SFTP_PACKET` | Largest SFTP request a server accepts, in bytes. | `WOLFSSH_MAX_SFTP_RW` + `WOLFSSH_MAX_SFTP_RECV` |
| `WOLFSSH_MAX_SFTP_HANDLES` | Most open SFTP handles per server session. | 64 |
| `WOLFSSHD_DEFAULT_UMASK` | umask wolfSSHd sessions run with. | 022 |
