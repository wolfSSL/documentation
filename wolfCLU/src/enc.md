### ENC Command

Used for encrypting an input. Setting -d enables decryption.

Available encryption and decryption algorithms (depends on configure settings):

- aes-cbc-128
- aes-cbc-192
- aes-cbc-256
- aes-ctr-128
- aes-ctr-192
- aes-ctr-256
- 3des-cbc-56
- 3des-cbc-112
- 3des-cbc-168
- camellia-cbc-128
- camellia-cbc-192
- camellia-cbc-256

Arguments:

- [-in] input file to read from
- [-out] file to write to (default stdout)
- [-pwd] password input
- [-k] another option for password input
- [-pass] option for password source, e.g., pass:password
- [-key] hex key input
- [-iv] hex iv input
- [-inkey] input file for key
- [-pbkdf2] use kdf version 2
- [-md] specify hash algo to use, e.g., md5, sha256
- [-d] decrypt the input file
- [-p] display debug information (key / iv ...)
- [-base64] handle decoding a base64 input
- [-nosalt] do not use a salt input to kdf

Example:

```
wolfssl enc -aes-128-cbc -k Thi$i$myPa$$w0rd -in somefile.txt

wolfssl enc aes-cbc-256 -pwd Thi$i$myPa$$w0rd -in somefile.txt -out encryptedfile.txt

wolfssl enc aes-cbc-256 -d -pwd Thi$i$myPa$$w0rd -in encryptedfile.txt -out decryptedfile.txt
```
