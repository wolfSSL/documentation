### ECPARAM Command

Used for creating ECC keys.

Arguments:

- [-genkey] create new key
- [-out] output file
- [-name] curve name

Available curve names:

- PRIME239V1
- PRIME239V2
- PRIME239V3
- SECP256R1
- SECP224R1
- SECP384R1
- SECP521R1
- SECP256K1
- BRAINPOOLP224R1
- BRAINPOOLP256R1
- BRAINPOOLP320R1
- BRAINPOOLP384R1
- BRAINPOOLP512R1

Example:

```
wolfssl ecparam -genkey -out new.key -name secp384r1

wolfssl ecparam -genkey -out brainpool.key -name BRAINPOOLP256R1
```
