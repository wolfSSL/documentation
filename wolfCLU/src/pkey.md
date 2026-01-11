### PKEY Command — Generic Public and Private Key Processing

The `wolfssl pkey` command is a **generic key handling utility** used to
read, inspect, convert, and extract public keys from cryptographic key files.

Unlike the `rsa` command, which is specific to RSA keys, the `pkey` command
is designed to work with **multiple key types** through a unified interface.

This command provides functionality similar to OpenSSL’s `openssl pkey`
command.

Typical use cases include:

- Converting keys between PEM and DER formats
- Extracting public keys from private keys
- Handling different key types using a single command
- Inspecting or re-encoding key material

---

#### Functional Overview

The `pkey` command operates on an existing cryptographic key and supports
the following operations:

- Reading public or private keys
- Converting key encoding formats (PEM ↔ DER)
- Outputting a public key from a private key
- Processing keys without regard to their specific algorithm

The behavior of the command depends on whether the input key is a public key
or a private key, and on the options specified.

---

#### Input and Output

- **Input**
  - Public key or private key (PEM or DER)
- **Output**
  - Public key or private key (PEM or DER)

---

#### Common Options

| Option | Description |
|------|-------------|
| `-in <file>` | Input file containing the key |
| `-out <file>` | Output file (default: stdout) |
| `-inform pem \| der` | Input key format |
| `-outform pem \| der` | Output key format |
| `-pubin` | Expect the input to be a public key |
| `-pubout` | Output the public key instead of the private key |

---

#### Notes

- If `-pubin` is not specified, the command assumes the input is a private key.
- When `-pubout` is specified, the public key is extracted from the private key
  and written to the output.
- The `pkey` command does not generate keys; use the `genkey` command for
  key generation.
- Algorithm-specific inspection (such as RSA modulus output) is not supported;
  use algorithm-specific commands such as `rsa` when needed.

---

#### Examples

Extract a public key from a private key:

```sh
wolfssl pkey -in key.pem -pubout -out pubkey.pem
```

Convert a key from PEM to DER format:

```sh
wolfssl pkey -in key.pem -inform pem -outform der -out key.der
```

Read and output a public key:

```sh
wolfssl pkey -pubin -in pubkey.pem -outform pem
```
