#  Notes and Limitations

- SFTP is implemented at protocol version 3. Extended file attributes are not handled: they are neither sent nor applied. An SFTP `SETSTAT` or `FSETSTAT` request applies the attributes it carries or is answered with `SSH_FX_OP_UNSUPPORTED`.
- Password change requests are not supported and are refused.
- Compression is not supported; only "none" is offered.
- wolfSSH offers neither the `chacha20-poly1305@openssh.com` cipher nor the `*-etm@openssh.com` MACs.
- Algorithms using SHA-1, and AES-CBC, are compiled in but not offered by default.
- The "none" cipher and MAC can only be negotiated in a build with `--enable-none-cipher` (`WOLFSSH_ALLOW_NONE_CIPHER`).
- RSA user authentication keys must be at least 2048 bits (`WOLFSSH_RSA_MIN_KEY_BITS`).
- DH group exchange uses groups of at least 2048 bits (`WOLFSSH_DEFAULT_GEXDH_MIN`), so it fails with a server that only offers 1024-bit groups.
- Applications must read the stderr (extended) data a peer sends. Data left unread fills the channel window and stalls the channel.
- wolfSSHd recognizes, but does not implement, the directives `Subsystem`, `ChallengeResponseAuthentication`, `UsePAM`, `X11Forwarding`, `PrintMotd`, `AcceptEnv` and `UseDNS`. It does not enforce the `command=` option in authorized keys files, and does not support OpenSSH certificate logins on Windows.
