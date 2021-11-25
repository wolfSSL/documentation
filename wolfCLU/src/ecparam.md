### ECPARAM Command

Used for creating ECC keys.

Available arguments are:    

- [-genkey] create new key
- [-out] output file
- [-name] curve name i.e. secp384r1


Example: 

```
wolfssl ecparam -genkey -out new.key -name secp384r1
```