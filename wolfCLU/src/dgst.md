### DGST Command
Can verify the signature. The last argument is the data that was signed.

Hash algos supported:     

- [-sha]
- [-sha224]
- [-sha256]
- [-sha384]
- [-sha512]

**Sign**

Parameters:     

- [-sign] key used to create signature
- [-out] file to write signature to

Example:
```
wolfssl dgst -sign keyPrivate.pem -out test.sig testfile
```

**Verify**

Parameters:     

- [-verify] key used to verify the signature
- [-signature] file containing the signature

Example:
```
wolfssl dgst -verify keyPublic.pem -signature test.sig testfile
```
