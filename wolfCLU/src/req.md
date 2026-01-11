### REQ Command — Certificate Request and Self-Signed Certificate Generation

The `wolfssl req` command is used to create and process
**Certificate Signing Requests (CSRs)** and, optionally,
to generate **self-signed X.509 certificates**.

This command provides functionality similar to OpenSSL’s
`openssl req` command and is primarily intended for:

- Generating a new Certificate Signing Request (CSR)
- Creating a new private key for use with a CSR
- Generating a self-signed X.509 certificate
- Verifying and inspecting an existing CSR

The behavior of the command depends on the combination of options
used, particularly `-newkey`, `-inkey`, and `-x509`.

---

#### Functional Overview

The `req` command supports the following primary use cases:

- **CSR generation**
  - Using an existing private key
  - Generating a new private key as part of the request
- **Self-signed certificate generation**
  - Creating an X.509 certificate directly from a CSR request
- **CSR inspection and verification**
  - Printing the contents of a CSR
  - Verifying the signature on a CSR

Certificate subject information and extensions can be provided
either interactively or via a configuration file.

---

### #Common Options

| Option | Description |
|------|-------------|
| `-in <file>` | Input file to read from |
| `-out <file>` | Output file to write to (default: stdout) |
| `-inform der \| pem` | Input format for `-in` |
| `-outform der \| pem` | Output format for `-out` |
| `-config <file>` | Configuration file for certificate request parameters |
| `-subj <subject>` | Specify the subject name on the command line |
| `-text` | Output the request in human-readable form |
| `-noout` | Do not output the encoded request or certificate |

---

#### Key and CSR Generation Options

These options control how the private key and CSR are generated.

| Option | Description |
|------|-------------|
| `-newkey <type>` | Generate a new private key for the request |
| `-keyout <file>` | File to write the newly generated private key to |
| `-nodes` | Do not encrypt the output private key |
| `-inkey <file>` | Use an existing private key for the request |
| `-key <file>` | Public key to include in the certificate request |

---

#### Self-Signed Certificate Options

| Option | Description |
|------|-------------|
| `-x509` | Generate a self-signed X.509 certificate instead of a CSR |
| `-days <n>` | Number of days the certificate should be valid |
| `-extensions <section>` | Section name in the configuration file for extensions |

---

#### Verification Options

| Option | Description |
|------|-------------|
| `-verify` | Verify the signature on the CSR |

---

#### Notes

- When `-x509` is specified, the output is an X.509 certificate rather than a CSR.
- The `-newkey` option generates a new private key and associates it with the request.
- If neither `-newkey` nor `-inkey` is specified, the command expects a key to be
  provided through other means.
- To sign a CSR with a CA key, use the `x509 -req` command.

---

#### Examples

Generate a new CSR and private key:

```sh
wolfssl req -newkey rsa:2048 -keyout server.key -out server.csr
```

Generate a self-signed certificate:

```sh
wolfssl req -x509 -newkey rsa:2048 -days 365 \
  -keyout server.key -out server.crt
```

Display the contents of an existing CSR:

```
wolfssl req -in server.csr -text
```

Verify a CSR signature:

```
wolfssl req -in server.csr -verify
```