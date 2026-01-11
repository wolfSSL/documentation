### RSA Command — RSA Key Processing and Inspection

The `wolfssl rsa` command is used to **read, inspect, convert, and extract
information from RSA keys**.

This command provides functionality similar to OpenSSL’s `openssl rsa`
command and supports both private and public RSA keys in PEM or DER format.

Typical use cases include:

- Converting RSA keys between PEM and DER formats
- Printing RSA key components
- Extracting the RSA modulus
- Handling encrypted PEM private keys
- Converting between public and private key representations

---

#### Functional Overview

The `rsa` command operates on an existing RSA key and supports the following
operations:

- Reading RSA private or public keys
- Converting key encoding formats (PEM ↔ DER)
- Outputting public keys from private keys
- Printing specific RSA parameters, such as the modulus
- Processing password-protected PEM private keys

The behavior of the command depends on whether the input key is a private
key or a public key, and on the options specified.

---

#### Input and Output

- **Input**
  - RSA private key or public key (PEM or DER)
- **Output**
  - RSA private key or public key (PEM or DER), or selected key information

---

#### Common Options

| Option | Description |
|------|-------------|
| `-in <file>` | Input file containing the RSA key |
| `-inform PEM \| DER` | Input key format |
| `-out <file>` | Output file (default: stdout) |
| `-outform PEM \| DER` | Output key format |
| `-passin <source>` | Password for encrypted PEM private keys |
| `-noout` | Do not output the key material |

---

#### Public and Private Key Handling Options

These options control how public and private keys are interpreted and output.

| Option | Description |
|------|-------------|
| `-RSAPublicKey_in` | Expect an RSA public key in RSAPublicKey format as input |
| `-pubin` | Expect a public key as input |
| `-pubout` | Output a public key instead of a private key |

> **Note:**  
> `-RSAPublicKey_in` and `-pubin` are used to explicitly specify that the input
> key is a public key.

---

#### RSA Parameter Output Options

| Option | Description |
|------|-------------|
| `-modulus` | Print the RSA modulus (`n` value) |

When `-modulus` is specified, the command prints the modulus value in
hexadecimal form.

---

#### Notes

- If neither `-pubin` nor `-RSAPublicKey_in` is specified, the command
  assumes the input is a private RSA key.
- When processing encrypted PEM private keys, `-passin` must be provided.
- The `-noout` option suppresses output of the key itself but allows
  parameter output such as `-modulus`.
- This command does not generate RSA keys; use the `genkey` command for
  key generation.

---

#### Examples

Convert an RSA private key from PEM to DER format:

```sh
wolfssl rsa -in rsa-key.pem -inform PEM -outform DER -out rsa-key.der
```

Print the RSA modulus:

```sh
wolfssl rsa -in rsa-key.pem -modulus -noout
```

Extract a public key from a private key:

```sh
wolfssl rsa -in rsa-key.pem -pubout -out rsa-pub.pem
```

Read and output an RSA public key:

```sh
wolfssl rsa -pubin -in rsa-pub.pem -outform PEM
```
