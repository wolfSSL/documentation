### HASH Command — Hash Calculation and Encoding Operations

The `wolfssl hash` command is a simple utility used to perform
**cryptographic hash calculations** and **encoding/decoding operations**
on files.

This command processes an input file using the specified algorithm and
prints the result to standard output.
It provides a lightweight and easy-to-use interface corresponding to a
subset of OpenSSL’s `openssl dgst` and `openssl enc` functionality.

---

#### Functional Overview

The `hash` command supports the following operations:

- Cryptographic hash calculation
- Base64 encoding
- Base64 decoding

The file to be processed is specified using the `-in` option.

---

#### Supported Algorithms

The following algorithms are available with the current build configuration:

- `md5`
- `sha`
- `sha256`
- `sha384`
- `sha512`
- `blake2b`
- `base64enc`
- `base64dec`

> **Note:**  
> The set of available algorithms depends on how wolfSSL was configured
> and built.

---

#### Command Syntax

```sh
wolfssl hash <-algorithm> -in <file to process>
```

#### Common Options

| Option | Description |
|------|-------------|
| `-in <file>` | Input file to be processed |
| `<algorithm>` | Hash or encode/decode algorithm to use |

---

#### Notes

- The hash result or encoded/decoded output is written to standard output.
- This command does not perform signing or verification.  
  Use the `dgst` command for digital signature creation or verification.
- The `base64enc` and `base64dec` options perform data encoding and decoding,
  not cryptographic operations.

---

#### Examples

Compute a SHA-1 hash:

```sh
wolfssl hash sha -in data.txt
```

Compute a SHA-256 hash:

```
wolfssl hash sha256 -in data.txt
```

Compute a BLAKE2b hash:

```sh
wolfssl hash blake2b -in data.txt
```

Perform Base64 encoding:

```sh
wolfssl hash base64enc -in data.bin
```

Perform Base64 decoding:

```sh
wolfssl hash base64dec -in data.b64
```