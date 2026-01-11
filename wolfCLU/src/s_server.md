### S_SERVER Command — TLS Server Startup and Operation Testing

The `wolfssl s_server` command is a diagnostic utility used to start a
**simple TLS/SSL server** using a specified certificate and private key.

This command serves a role similar to OpenSSL’s `openssl s_server` command
and is primarily used for the following purposes:

- Testing TLS server-side behavior
- Verifying the correctness of certificates and private keys
- Testing client certificate verification
- Confirming TLS version negotiation
- Performing interoperability tests using tools such as `s_client`

---

#### Functional Overview

The `s_server` command listens on a specified port, accepts incoming
client connections, and performs the TLS handshake.

Depending on the options specified, it supports the following behaviors:

- Starting a TLS server using a specified certificate and private key
- Enabling or disabling client certificate verification
- Restricting the TLS protocol versions that may be used
- Accepting multiple client connections
- Sending a simple HTTP (HTML) response

This command is intended for **testing and verification purposes** and is
not designed for use as a high-performance or production-grade server.

---

#### Input and Output

- **Input**
  - Server certificate (PEM format)
  - Server private key (PEM format)
  - (Optional) CA certificate for client certificate verification
- **Output**
  - Connection status and TLS handshake information (standard output)

---

#### Common Options

| Option | Description |
|------|-------------|
| `-port <int>` | TCP port number to listen on |
| `-key <file>` | Server private key file (PEM format only) |
| `-cert <file>` | Server certificate file (PEM format only) |
| `-CAfile <file>` | CA certificate used to verify client certificates (PEM format only) |
| `-noVerify` | Disable client certificate verification |
| `-version <int>` | Specify the SSL/TLS protocol version to use |
| `-naccept <int>` | Number of connections to accept (default: 1) |
| `-www` | Send responses in HTTP (HTML) format |
| `-readyFile <file>` | Create a file to indicate that the server is ready |

---

#### TLS Version Selection (`-version`)

The `-version` option restricts the SSL/TLS protocol versions that the
server will accept.

| Value | Protocol |
|------|----------|
| `0` | SSLv3 |
| `1` | TLS 1.0 |
| `2` | TLS 1.1 |
| `3` | TLS 1.2 |
| `4` | TLS 1.3 |

> **Note:**  
> The actual set of available protocol versions depends on how wolfSSL
> was configured and built.

---

#### Client Certificate Verification

- Client certificate verification is enabled by default.
- When `-noVerify` is specified, client certificates are neither requested
  nor verified.
- To enable client certificate verification, a trusted CA certificate must
  be specified using the `-CAfile` option.

---

#### Notes

- The files specified with the `-key` and `-cert` options must be in
  **PEM format**.
- This command implements a simple TLS server and is not suitable for
  high-load or production server use.
- The `-www` option is a convenience feature for easily testing TLS
  connectivity.
- The `-readyFile` option can be used by external monitoring tools to
  detect when the server has finished starting up.

---

#### Examples

Start a TLS server listening on port 4433:

```sh
wolfssl s_server \
  -port 4433 \
  -cert server-cert.pem \
  -key server-key.pem
```

Start a server that only allows TLS 1.2:

```sh
wolfssl s_server \
  -port 4433 \
  -cert server-cert.pem \
  -key server-key.pem \
  -version 3
```

Disable client certificate verification:

```sh
wolfssl s_server \
  -port 4433 \
  -cert server-cert.pem \
  -key server-key.pem \
  -noVerify
Accept multiple client connections:
```

```sh
wolfssl s_server \
  -port 4433 \
  -cert server-cert.pem \
  -key server-key.pem \
  -naccept 10
```