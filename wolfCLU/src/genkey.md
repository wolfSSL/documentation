### GENKEY Command — Cryptographic Key Generation

The `wolfssl genkey` command is used to generate cryptographic key pairs or
individual public/private keys for supported algorithms.

This command provides a unified interface for key generation, similar in
spirit to OpenSSL’s `genpkey` and related commands, but with a simplified
and explicit option set.

The set of supported key types depends on the wolfSSL build configuration.
With the default configuration, the following key types are available:

- `rsa`
- `ecc`
- `ed25519`
- `dilithium`
- `xmssmt`
- `xmss`

---

#### Functional Overview

The `genkey` command supports the following key generation operations:

- Generating a public/private key pair
- Generating only a private key
- Generating only a public key
- Outputting keys in PEM or DER format

When generating a key pair, the command produces separate files for the
public and private keys, using filename suffixes to distinguish them.

---

#### Supported Key Types

| Key Type | Description |
|---------|-------------|
| `rsa` | RSA public/private key pair |
| `ecc` | Elliptic Curve Cryptography (ECC) key |
| `ed25519` | Ed25519 signature key |

> **Note:**  
> Availability of key types depends on how wolfSSL was configured and built.

---

#### Common Options

| Option | Description |
|------|-------------|
| `<keytype>` | Type of key to generate (`rsa`, `ecc`, `ed25519`) |
| `-size <bits>` | Key size in bits (RSA only, optional) |
| `-out <filename>` | Base name of the output file(s) |
| `-outform PEM \| DER` | Output format of the generated key(s) |
| `-output <PUB \| PRIV \| KEYPAIR>` | Specify which key(s) to generate |

---

#### Output Behavior

The output files are determined by the value of the `-output` option:

| `-output` Value | Generated Files |
|----------------|----------------|
| `KEYPAIR` | `<filename>.priv` and `<filename>.pub` |
| `PRIV` | `<filename>.priv` |
| `PUB` | `<filename>.pub` |

File extensions are automatically appended to the base filename specified
by `-out`.

---

#### Notes

- If `-size` is not specified, a default key size is used where applicable.
- The `-size` option applies only to RSA keys.
- For ECC and Ed25519 keys, curve selection is determined by the build
  configuration or internal defaults.
- The generated keys are written directly to files; no interactive prompts
  are used.

---

#### Examples

Generate an RSA key pair in DER format:

```sh
wolfssl genkey rsa -size 2048 -out mykey -outform der -output KEYPAIR
```

Generate only a private RSA key in PEM format:

```sh
wolfssl genkey rsa -size 2048 -out mykey -outform pem -output PRIV
```

Generate an Ed25519 key pair:

```sh
wolfssl genkey ed25519 -out myedkey -outform pem -output KEYPAIR
```

#### Additional Key Generation Options

The following options provide additional control over key generation parameters
for specific key types.

---

#### RSA-Specific Options

| Option | Description |
|------|-------------|
| `-exponent <value>` | RSA public exponent value (e.g. `65537`) |

> **Note:**  
> The `-exponent` option is applicable only to RSA key generation.
> If not specified, a default exponent value is used.

#### Examples

Generate an RSA key with a custom public exponent:

```sh
wolfssl genkey rsa -size 2048 -exponent 65537 -out mykey -outform pem -output KEYPAIR
```


---

#### Post-Quantum and Hash-Based Key Types

Depending on the build configuration, the `genkey` command may support
post-quantum and hash-based signature algorithms.

---

##### Dilithium (Post-Quantum Signature)

| Option | Description |
|------|-------------|
| `dilithium` | Generate a Dilithium post-quantum signature key |
| `-level <2 \| 3 \| 5>` | Security level of the Dilithium key |

Supported security levels:

- Level 2
- Level 3
- Level 5

The selected level determines the security strength and key size.

---

##### XMSSMT (Multi-Tree XMSS)

| Option | Description |
|------|-------------|
| `xmssmt` | Generate an XMSS Multi-Tree (XMSSMT) key |
| `-height <20 \| 40 \| 60>` | Total tree height |
| `-layer <value>` | Number of layers in the multi-tree structure |

Valid `-layer` values depend on the selected height:

- Height 20 or 40: `2`, `4`, `8`
- Height 60: `3`, `6`, `12`

> **Note:**  
> The height must be divisible by the number of layers.

---

##### XMSS (Single-Tree XMSS)

| Option | Description |
|------|-------------|
| `xmss` | Generate a single-tree XMSS key |
| `-height <10 \| 16 \| 20>` | Tree height |

Supported heights:

- 10
- 16
- 20

The tree height determines the maximum number of signatures that can be
generated with a single XMSS key.

---

#### Notes on Post-Quantum Key Generation

- Availability of post-quantum and hash-based algorithms depends on the
  wolfSSL build configuration and enabled features.
- Larger heights and higher security levels result in larger key sizes
  and increased computational cost.
- XMSS and XMSSMT keys have a **limited number of signatures** and must be
  managed carefully to avoid key exhaustion.

---

Generate a Dilithium Level 3 key pair:

```sh
wolfssl genkey dilithium -level 3 -out pqkey -outform pem -output KEYPAIR
```

Generate an XMSSMT key with height 40 and 4 layers:

```sh
wolfssl genkey xmssmt -height 40 -layer 4 -out xmssmtkey -outform pem -output KEYPAIR
```

Generate an XMSS key with height 16:

```sh
wolfssl genkey xmss -height 16 -out xmsskey -outform pem -output KEYPAIR
```