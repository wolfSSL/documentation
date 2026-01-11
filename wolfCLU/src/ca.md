### CA Command — Certificate Authority Signing and Certificate Issuance

The `wolfssl ca` command is used to **sign Certificate Signing Requests (CSRs)**
and issue X.509 certificates, acting as a basic **Certificate Authority (CA)**
utility.

This command provides functionality similar to OpenSSL’s `openssl ca` command,
with a simplified feature set focused on common certificate signing operations.
It supports signing CSRs using a CA certificate and private key, as well as
generating self-signed certificates.

Typical use cases include:

- Signing a CSR with a CA private key to issue an X.509 certificate
- Applying certificate extensions from a configuration file
- Controlling certificate validity period and signature algorithm
- Generating self-signed certificates for testing or internal use

---

#### Functional Overview

The `ca` command operates on a CSR input and produces a signed X.509 certificate.

Depending on the options used, it supports the following modes of operation:

- **CA-signed certificate generation**
  - A CSR is signed using a CA certificate and its associated private key
- **Self-signed certificate generation**
  - The certificate is signed using the private key associated with the input
    certificate (`-selfsign`)

The command relies on a configuration file for parsing certificate extensions
and other certificate-related parameters.

---

#### Input and Output

- **Input**
  - Certificate Signing Request (CSR)
- **Output**
  - X.509 certificate (PEM or DER)

---

#### Common Options

| Option | Description |
|------|-------------|
| `-in <file>` | Input CSR file |
| `-out <file>` | Output file for the generated certificate |
| `-inform PEM \| DER` | Input format of the CSR |
| `-outform PEM \| DER` | Output format of the certificate |
| `-config <file>` | Configuration file for certificate parameters |
| `-days <n>` | Number of days the certificate should be valid |
| `-md <hash>` | Message digest algorithm used for signing (e.g. `sha256`) |

---

#### CA Key and Certificate Options

These options specify the CA credentials used for signing.

| Option | Description |
|------|-------------|
| `-keyfile <file>` | Private key used to sign the certificate |
| `-cert <file>` | CA certificate corresponding to the signing key |

---

#### Extension Handling Options

| Option | Description |
|------|-------------|
| `-extensions <section>` | Section name in the configuration file from which to parse certificate extensions |

---

#### Self-Signed Certificate Option

| Option | Description |
|------|-------------|
| `-selfsign` | Sign the certificate using the private key associated with the input certificate |

> **Note:**  
> When `-selfsign` is specified, the certificate is signed using its own key,
> rather than a separate CA key.

---

#### Notes

- The input file specified by `-in` must be a valid CSR.
- When generating a CA-signed certificate, both `-keyfile` and `-cert`
  must be specified.
- Extension parsing is limited to basic configuration file support.
- This command does not manage certificate databases or serial number files,
  unlike OpenSSL’s full `ca` command.

---

#### Examples

Sign a CSR using a CA certificate and private key:

```sh
wolfssl ca \
  -config ca.conf \
  -in server.csr \
  -out server-cert.pem \
  -cert ca-cert.pem \
  -keyfile ca-key.pem \
  -md sha256 \
  -days 365
```

Generate a self-signed certificate:

```sh
wolfssl ca \
  -config selfsign.conf \
  -in server.csr \
  -out server-cert.pem \
  -selfsign \
  -md sha256 \
  -days 365
```
