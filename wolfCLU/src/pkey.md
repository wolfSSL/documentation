### PKEY Command
Used for dealing with generic key operations. Prints the key read in to stdout.

- [-in] file input for key
- [-inform] pem or der input format
- [-pubout] only print out the public key


Example:

```
./wolfssl pkey -in ./certs/server-key.pem -inform pem -pubout
```