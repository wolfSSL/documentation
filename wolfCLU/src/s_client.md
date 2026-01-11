## S_CLIENT Command — TLS Client Connection and Diagnostics

The `wolfssl s_client` command is a diagnostic utility used to establish
a **TLS/SSL client connection** to a remote server and inspect the
handshake and certificate verification behavior.

This command provides functionality similar to OpenSSL’s
`openssl s_client` command and is commonly used for:

- Testing TLS connectivity to a server
- Inspecting server certificates and certificate chains
- Verifying server certificates against a trusted CA
- Debugging TLS handshake and STARTTLS behavior

---

### Functional Overview

The `s_client` command initiates a TLS connection to a specified server
and performs the TLS handshake.

Depending on the options used, it supports the following behaviors:

- Direct TLS connections to a TCP endpoint
- STARTTLS negotiation for application protocols such as SMTP
- Server certificate verification using a CA file
- Immediate termination on verification failure

The command is intended for **interactive testing and diagnostics**, not
for automated production use.

---

### Connection Target

The remote endpoint is specified using the `-connect` option.
Both IPv4 and IPv6 addresses are supported.

IPv6 addresses must be enclosed in square brackets (`[]`).

Examples:

```sh
-connect 127.0.0.1:443
-connect '[::1]:11111'
-connect '[fe80::63:57c0:9b88:77ca%en0]:11111'
-connect '[2001:4860:4860::8888]:443'
```

### Common Options

| Option | Description |
|------|-------------|
| `-connect <host:port>` | Remote server address and port to connect to |
| `-starttls <proto>` | Enable STARTTLS for the specified protocol (e.g. `smtp`) |
| `-CAfile <file>` | Trusted CA certificate file used for server certificate verification |
| `-verify_return_error` | Close the connection immediately if certificate verification fails |
| `-disable_stdin_check` | Disable standard input readiness checks during the session |

---

### Notes

- The `-connect` option supports both IPv4 and IPv6 addresses.  
  IPv6 addresses must be enclosed in square brackets (`[]`).
- The `-starttls` option is used for protocols that begin in plaintext and
  then upgrade to TLS, such as SMTP.
- If `-verify_return_error` is not specified, the connection may continue
  even if certificate verification fails, depending on configuration.
- The `-disable_stdin_check` option is primarily intended for non-interactive
  or scripted use cases.

---

### Examples

Connect to a TLS server:

```sh
wolfssl s_client -connect example.com:443
```

Use STARTTLS with SMTP:

```sh
wolfssl s_client -connect mail.example.com:25 -starttls smtp
```

Verify the server certificate and abort on error:

```sh
wolfssl s_client -connect example.com:443 \
  -CAfile ca-cert.pem \
  -verify_return_error
```


