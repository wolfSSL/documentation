### PKEY Command
Used for dealing with generic key operations. Prints the key read in to stdout.

Arguments:

- [-in] file input for key to read
- [-out] file to output to (default stdout)
- [-inform] pem or der input format (defaults to pem)
- [-outform] pem or der output format
- [-pubout] output the public key
- [-pubin] expect to read public key in

Example:

```
wolfssl pkey -in ./certs/server-key.pem -inform pem -pubout

wolfssl pkey -in ./certs/server-key.pem -out pubkey.pem -pubout
```
