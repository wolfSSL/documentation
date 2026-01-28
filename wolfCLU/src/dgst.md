### DGST Command
Used for creating and verifying digital signatures. The last argument is the data that was signed.

Hash algorithms supported:

- [-md5]
- [-sha]
- [-sha224]
- [-sha256]
- [-sha384]
- [-sha512]

Arguments:

- [-signature] file containing the signature
- [-inform] pem or der in format
- [-verify] key used to verify the signature
- [-sign] private key used to create the signature
- [-out] output file for signature

**Sign**

Example:
```
wolfssl dgst -sha256 -sign keyPrivate.pem -out test.sig testfile
```

**Verify**

Example:
```
wolfssl dgst -sha256 -signature test.sig -verify keyPublic.pem testfile
```
