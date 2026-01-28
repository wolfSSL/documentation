### GENKEY Command
Used to generate RSA, ECC and ED25519 keys. If using "-output KEYPAIR" a private key is created having .priv appended to -out argument and a public key is created with .pub appended to the -out argument. If generating ED25519 keys compile wolfSSL with --enable-ed25519.

Available key types (depends on configure settings):

- rsa
- ecc
- ed25519

Arguments:

- [rsa | ecc | ed25519] key type to generate
- [-size] size of key to generate (bits)
- [-out] file to write to
- [-outform] output form, either DER or PEM (defaults to DER)
- [-output] key to generate, either PUB, PRIV or KEYPAIR (defaults to KEYPAIR)

Example:

```
wolfssl genkey rsa -size 2048 -out mykey -outform pem -output KEYPAIR

wolfssl genkey ecc -out ecckey -outform pem -output KEYPAIR

wolfssl genkey ed25519 -out ed25519key -outform pem -output KEYPAIR
```

The above command would output the files: mykey.priv and mykey.pub.
Changing the -output option to just PRIV would output only the private key.

### Typical Workflow: RSA Key to Certificate

**Step 1: Generate RSA key pair for server**

```
wolfssl genkey rsa -size 2048 -out server -outform pem -output KEYPAIR
```

This creates `server.priv` (private key) and `server.pub` (public key).

**Step 2: Generate RSA key pair for CA**

```
wolfssl genkey rsa -size 2048 -out ca -outform pem -output KEYPAIR
```

See the [REQ Command](req.md) for creating CSR and certificates, and the [CA Command](ca.md) for signing certificates.
