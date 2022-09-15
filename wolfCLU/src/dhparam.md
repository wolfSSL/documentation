### DHPARAM Command

Used for creating Diffie Hellman params and keys.

Available arguments are:    

- [-genkey] create new DH key
- [-in] file to read params from to create a key
- [-out] file to output to (default stdout)
- [-check] check if generated parameters are valid
- [-noout] do not print out the params

Example: 

```
wolfssl dhparam -check -out dh.params 1024
