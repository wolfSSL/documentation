### ENC Command

Used for encrypting an input. Setting -d enables decryption.

Available encryption and decryption algorithms are:    

- aes-cbc-128
- aes-cbc-192
- aes-cbc-256
- aes-ctr-128
- aes-ctr-192
- aes-ctr-256
- 3des-cbc-56
- 3des-cbc-112
- 3des-cbc-168

Available arguments are:    

- [-in] input file to read from
- [-out] file to write to (default stdout)
- [-pwd] password input
- [-key] hex key input
- [-iv]  hex iv input
- [-inkey] input file for key
- [-pbkdf2] use kdf version 2
- [-md] specify hash algo to use i.e md5, sha256
- [-d] decrypt the input file
- [-p] display debug information (key / iv ...)
- [-k] another option for password input
- [-base64] handle decoding a base64 input
- [-nosalt] do not use a salt input to kdf


Example: 

```
wolfssl enc -aes-128-cbc -k Thi$i$myPa$$w0rd -in somefile.txt
```
