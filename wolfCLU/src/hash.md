### HASH Command
Used to create a hash of input data.

Available algorithms (depends on configure settings):

- md5
- sha
- sha256
- sha384
- sha512
- blake2b
- base64enc
- base64dec

Arguments:

- [algorithm] hash algorithm to use
- [-in] file to hash

Example:

```
wolfssl hash sha256 -in somefile.txt

wolfssl hash blake2b -in somefile.txt
```
