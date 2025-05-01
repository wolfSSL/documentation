### PKCS8 Command

Processes PKCS#8 private key files. Allows conversion between different formats (PEM/DER) and decryption of private keys. Encrypting PKCS#8 keys is not yet supported.

- [-in] input file containing the private key (required)
- [-out] output file to write the processed key to (default stdout)
- [-inform] input format (PEM or DER, default PEM)
- [-outform] output format (PEM or DER, default PEM)
- [-passin] password source for encrypted input key
- [-traditional] output key in traditional (non-PKCS#8) format
- [-topk8] convert input to PKCS#8 format
- [-nocrypt] don't encrypt the output key (no password)

Example for converting an encrypted PEM key to DER format:

```
wolfssl pkcs8 -in server-keyEnc.pem -passin pass:mypassword -outform DER -out key.der
```

Example for converting a key to traditional format:

```
wolfssl pkcs8 -in server-key.pem -traditional -out traditional-key.pem
```
