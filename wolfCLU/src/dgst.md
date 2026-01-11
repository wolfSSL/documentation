### DGST Command — Message Digest and Digital Signature Operations

The `wolfssl dgst` command is used to compute cryptographic message digests
and to **create or verify digital signatures** over input data.

This command provides functionality similar to OpenSSL’s `openssl dgst`
command. The last argument on the command line specifies the input data
to be hashed or signed.

Typical use cases include:

- Computing a message digest (hash) of input data
- Creating a digital signature using a private key
- Verifying a digital signature using a public key or certificate

---

#### Functional Overview

The `dgst` command operates on arbitrary input data and supports
multiple hash algorithms.

Depending on the options used, it supports the following operations:

- **Digest computation**
  - Calculate a hash value for the input data
- **Signature generation**
  - Create a digital signature over the input data using a private key
- **Signature verification**
  - Verify a digital signature using a public key or certificate

The input data is specified as the **last argument** to the command.

---

#### Supported Hash Algorithms

The following message digest algorithms are supported:

- `-md5`
- `-sha`
- `-sha224`
- `-sha256`
- `-sha384`
- `-sha512`

If no digest algorithm is explicitly specified, a default algorithm
may be used depending on the build configuration.

---

#### Common Options

| Option | Description |
|------|-------------|
| `-inform pem \| der` | Input format for keys or signature files |
| `-out <file>` | Output file for the generated signature or digest |

---

#### Signature Generation Options

These options are used when creating a digital signature.

| Option | Description |
|------|-------------|
| `-sign <file>` | Private key used to create the signature |

When `-sign` is specified, the command generates a signature over the
input data and writes it to the file specified by `-out`.

---

#### Signature Verification Options

These options are used when verifying an existing digital signature.

| Option | Description |
|------|-------------|
| `-signature <file>` | File containing the signature to verify |
| `-verify <file>` | Public key or certificate used to verify the signature |

When both `-signature` and `-verify` are specified, the command verifies
the signature against the input data.

---

#### Notes

- The input data to be hashed or signed is specified as the **last argument**
  on the command line.
- The `-sign` and `-verify` options are mutually exclusive.
- When verifying a signature, the verification result is printed to stdout.
- Key and signature file formats must match the specified `-inform` option.

---

#### Examples

Create a digital signature using a private key:

```sh
wolfssl dgst -sha256 -sign keyPrivate.pem -out data.sig data.txt
```

Verify a digital signature:

```sh
wolfssl dgst -sha256 -signature data.sig -verify keyPublic.pem data.txt
```

Compute a message digest:

```sh
wolfssl dgst -sha256 data.txt
```
