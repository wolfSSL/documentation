### GENKEY Command
Used to generate RSA, ECC, and ED25519 keys. If using "-output KEY" a private key is created having .priv appended to -out argument and a public key is created with .pub appended to the -out argument. If generating ED25519 keys compile wolfSSL with --enable-ed25519.

Available arguments are:    

- [-out] file to write to
- [rsa | ecc | ed25519] key type to generate
- [-inkey] input file for key
- [-size] size of key to generate
- [-outform] output form, either DER or PEM
- [-exponent] RSA exponent size

Example:

```
wolfssl genkey rsa -size 2048 -out mykey -outform pem  -output KEY
```