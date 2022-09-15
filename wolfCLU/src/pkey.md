### PKEY Command
Used for dealing with generic key operations. Prints the key read in to stdout.

- [-in] file input for key
- [-inform] pem or der input format (defaults to pem)
- [-pubout] only print out the public key
- [-pubin] expect to public key as input

Example:

```
./wolfssl pkey -in ./certs/server-key.pem -inform pem -pubout
```
