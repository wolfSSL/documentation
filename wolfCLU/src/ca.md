### CA Command
Used for signing Certificates. Can handle some basic config file parsing.

Available arguments are:    

- [-in] input CSR file
- [-out] file to write to
- [-keyfile] file to read private key from
- [-cert] file to read CA from
- [-extensions] section in config file to parse extensions from
- [-md] type of hash to use i.e sha, sha256, ...
- [-inform] PEM/DER type of CSR input
- [-config] file to parse for configuration
- [-days] number of days should be valid for
- [-selfsign] sign with key associated with input cert

Example:

```
wolfssl ca -config ca.conf -in test.csr -out test.pem -md sha256 -selfsign -keyfile ./key
```
