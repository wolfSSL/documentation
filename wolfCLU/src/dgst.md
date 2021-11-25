### DGST Command
Can verify the signature. The last argument is the data that was signed.

Hash algos supported:     

- [-sha]
- [-sha224]
- [-sha256]
- [-sha384]
- [-sha512]

Parameters:     

- [-signature] file containing the signature
- [-verify] key used to verify the signature

Example:
```
wolfssl dgst -signature test.sig -verify key.pem test
```