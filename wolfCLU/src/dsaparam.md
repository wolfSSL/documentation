### DSAPARAM Command

Used for creating DSA params and keys. Make sure wolfSSL is compiled with `--enable-dsa`.

Available arguments are:    

- [-genkey] create new DSA key
- [-in] file to read params from to create a key
- [-out] file to output to (default stdout)
- [-noout] do not print out the params

Example: 

```
wolfssl dsaparam -out dsa.params 1024
wolfssl dsaparam -in dsa.params -genkey
```
