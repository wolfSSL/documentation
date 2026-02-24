### ECC Command

Sign and verify data using ECC (Elliptic Curve Cryptography) keys.

Arguments:

- [-sign] Sign operation
- [-verify] Verify operation
- [-inkey] Input key file
- [-in] Input file to sign or verify
- [-out] Output file for signature (sign operation)
- [-sigfile] Signature file (verify operation)
- [-pubin] Input key is a public key (for verify operation)

Usage Examples:

Sign a file with ECC private key:

```
wolfssl ecc -sign -inkey ecc-priv.pem -in file.txt -out file.sig
```

Verify a signature with ECC public key:

```
wolfssl ecc -verify -inkey ecc-pub.pem -sigfile file.sig -in file.txt -pubin
```

Verify a signature with ECC private key:

```
wolfssl ecc -verify -inkey ecc-priv.pem -sigfile file.sig -in file.txt
```
